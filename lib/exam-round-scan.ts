/**
 * สแกนประกาศ ศรว. แล้วอัปเดตปฏิทินสอบ (exam_rounds) อัตโนมัติ — ไม่มีขั้นยืนยันโดยคน
 *
 *   หน้าข่าว cmathai.org/news → ลิงก์ประกาศ (ใหม่สุดก่อน, เฉพาะที่ยังไม่เคยอ่าน)
 *   → หน้ารายละเอียด (+ PDF แนบ ≤ 2 ไฟล์ ≤ 5 MB) → Claude สกัดรอบสอบ
 *   → validateExtractedRound (ตัวกันพลาดที่ไม่พึ่ง AI) → planRoundChanges → applyChangePlan
 *   → LINE แจ้งแอดมิน
 *
 * ใช้โดย cron exam-watch (วันละครั้ง) และปุ่ม "สแกนประกาศ ศรว. ตอนนี้" ใน /admin/exam-dates
 * (ปุ่มส่ง force = อ่านซ้ำแม้เคยอ่านแล้ว; ผลลัพธ์ idempotent จึงรันซ้ำได้ปลอดภัย)
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { sendLineMessage } from "@/lib/line";
import { bangkokDateString } from "@/lib/exam-reminders";
import {
  CMA_NEWS_URL,
  classifyCmaUrl,
  extractAnnouncementLinks,
  extractPdfLinks,
  htmlToText,
  isCmaHost,
} from "@/lib/exam-watch";
import { extractRoundsFromSource, type RoundSource } from "@/lib/exam-round-ai";
import {
  applyChangePlan,
  buildRoundAlertText,
  planHasChanges,
  planRoundChanges,
  validateExtractedRound,
  type ApplyResult,
  type ChangePlan,
  type ExistingRound,
  type RejectedRound,
  type ValidRound,
} from "@/lib/exam-round-extract";

export const SCANNED_URLS_SETTINGS_KEY = "exam_rounds_scanned_urls";
const MAX_SCANNED_URLS = 200;
const MAX_PDF_BYTES = 5 * 1024 * 1024;
const FETCH_TIMEOUT_MS = 15_000;
const UA =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0 Safari/537.36";

export interface ScanOptions {
  /** จำนวนหน้าประกาศสูงสุดที่อ่านในรอบนี้ (cron = 3, ปุ่มแอดมิน = 5) */
  maxPages?: number;
  /** อ่านซ้ำแม้เคยอ่านแล้ว */
  force?: boolean;
  /** ส่ง LINE แจ้งแอดมินเมื่อมีการเปลี่ยน/ข้ามรอบ (ปุ่มแอดมินปิดไว้ เพราะเห็นรายงานบนหน้าจออยู่แล้ว) */
  alert?: boolean;
  now?: Date;
}

export interface PdfReport {
  url: string;
  ok: boolean;
  bytes?: number;
  error?: string;
}

export interface PageReport {
  url: string;
  linkText: string;
  fetched: boolean;
  error?: string;
  textChars: number;
  pdfs: PdfReport[];
  aiErrors: string[];
  accepted: string[];
  rejected: RejectedRound[];
}

export interface ScanReport {
  listFetched: boolean;
  listError?: string;
  linksFound: number;
  alreadyScanned: number;
  pages: PageReport[];
  applied: ApplyResult;
  changes: { inserted: number; dateChanges: number; confirms: number };
  lockedConflicts: number;
  suspicious: boolean;
  alertSent: boolean;
}

type FetchResult<T> = { ok: true; value: T } | { ok: false; error: string };

async function fetchCma(url: string, kind: "text" | "binary"): Promise<FetchResult<string | ArrayBuffer>> {
  if (!classifyCmaUrl(url) && url !== CMA_NEWS_URL) return { ok: false, error: "URL ไม่อยู่ในรายการที่อนุญาต" };
  try {
    const res = await fetch(url, {
      headers: { "User-Agent": UA, Accept: kind === "text" ? "text/html" : "application/pdf" },
      signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
      cache: "no-store",
    });
    // redirect ต้องไม่พาออกนอก host ของ ศรว.
    if (res.url && !isCmaHost(res.url)) return { ok: false, error: "redirect ออกนอก host ที่อนุญาต" };
    if (!res.ok) return { ok: false, error: `HTTP ${res.status}` };
    if (kind === "text") return { ok: true, value: await res.text() };
    const buf = await res.arrayBuffer();
    if (buf.byteLength > MAX_PDF_BYTES) return { ok: false, error: `ไฟล์ใหญ่เกิน ${MAX_PDF_BYTES / 1024 / 1024} MB` };
    return { ok: true, value: buf };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : String(err) };
  }
}

async function loadScanned(db: SupabaseClient): Promise<Set<string>> {
  const { data } = await db.from("app_settings").select("value").eq("key", SCANNED_URLS_SETTINGS_KEY).maybeSingle();
  try {
    const arr = JSON.parse((data as { value?: string } | null)?.value ?? "[]");
    return new Set(Array.isArray(arr) ? arr.filter((x): x is string => typeof x === "string") : []);
  } catch {
    return new Set();
  }
}

async function saveScanned(db: SupabaseClient, set: Set<string>): Promise<void> {
  const value = JSON.stringify([...set].slice(-MAX_SCANNED_URLS));
  const { error } = await db
    .from("app_settings")
    .upsert({ key: SCANNED_URLS_SETTINGS_KEY, value, updated_at: new Date().toISOString() });
  if (error) console.error("[exam-round-scan] save scanned urls failed:", error.message);
}

async function loadExisting(db: SupabaseClient): Promise<ExistingRound[]> {
  const { data, error } = await db.from("exam_rounds").select("id, kind, label, exam_date, confirmed, locked");
  if (error) throw new Error(`อ่าน exam_rounds ไม่ได้: ${error.message}`);
  return (data as ExistingRound[] | null) ?? [];
}

const emptyApplied = (): ApplyResult => ({ inserted: 0, changed: 0, confirmed: 0, errors: [] });

export async function scanExamAnnouncements(db: SupabaseClient, opts: ScanOptions = {}): Promise<ScanReport> {
  const { maxPages = 3, force = false, alert = true, now = new Date() } = opts;
  const today = bangkokDateString(now);

  const report: ScanReport = {
    listFetched: false,
    linksFound: 0,
    alreadyScanned: 0,
    pages: [],
    applied: emptyApplied(),
    changes: { inserted: 0, dateChanges: 0, confirms: 0 },
    lockedConflicts: 0,
    suspicious: false,
    alertSent: false,
  };

  const list = await fetchCma(CMA_NEWS_URL, "text");
  if (!list.ok) {
    report.listError = list.error;
    return report;
  }
  report.listFetched = true;

  const links = extractAnnouncementLinks(list.value as string);
  report.linksFound = links.length;

  const scanned = await loadScanned(db);
  const todo = (force ? links : links.filter((l) => !scanned.has(l.url))).slice(0, maxPages);
  report.alreadyScanned = links.length - (force ? links.length : links.filter((l) => !scanned.has(l.url)).length);

  const aggregate: ChangePlan = { inserts: [], dateChanges: [], confirms: [], lockedConflicts: [], noops: 0, suspicious: false };
  const allRejected: RejectedRound[] = [];
  const sourceUrls: string[] = [];

  for (const link of todo) {
    const page: PageReport = {
      url: link.url,
      linkText: link.text,
      fetched: false,
      textChars: 0,
      pdfs: [],
      aiErrors: [],
      accepted: [],
      rejected: [],
    };
    report.pages.push(page);

    const detail = await fetchCma(link.url, "text");
    if (!detail.ok) {
      page.error = detail.error; // ไม่ mark ว่าอ่านแล้ว — รอบหน้าลองใหม่
      continue;
    }
    page.fetched = true;
    const html = detail.value as string;
    const text = htmlToText(html);
    page.textChars = text.length;

    const sources: RoundSource[] = [];
    if (text.length >= 200) sources.push({ url: link.url, text, pdfBase64: null });
    for (const pdfUrl of extractPdfLinks(html, link.url)) {
      const pdf = await fetchCma(pdfUrl, "binary");
      if (!pdf.ok) {
        page.pdfs.push({ url: pdfUrl, ok: false, error: pdf.error });
        continue;
      }
      const buf = pdf.value as ArrayBuffer;
      page.pdfs.push({ url: pdfUrl, ok: true, bytes: buf.byteLength });
      sources.push({ url: pdfUrl, text: null, pdfBase64: Buffer.from(buf).toString("base64") });
    }

    let existing: ExistingRound[];
    try {
      existing = await loadExisting(db);
    } catch (err) {
      page.error = err instanceof Error ? err.message : String(err);
      return report; // ตารางยังไม่พร้อม — หยุดทั้งรอบ ไม่ mark อะไร
    }
    const labels = existing.map((e) => e.label);

    const valid: ValidRound[] = [];
    for (const src of sources) {
      const extraction = await extractRoundsFromSource(src, labels, today);
      if (extraction.error) page.aiErrors.push(extraction.error);
      for (const raw of extraction.rounds) {
        const check = validateExtractedRound(raw, { now, sourceText: src.text });
        if (check.ok) {
          valid.push(check.round);
          page.accepted.push(check.round.label);
        } else {
          page.rejected.push({ label: check.label, reason: check.reason });
        }
      }
    }
    allRejected.push(...page.rejected);

    const plan = planRoundChanges(existing, valid);
    if (plan.suspicious) report.suspicious = true;
    if (planHasChanges(plan)) {
      const applied = await applyChangePlan(db, plan, link.url);
      report.applied.inserted += applied.inserted;
      report.applied.changed += applied.changed;
      report.applied.confirmed += applied.confirmed;
      report.applied.errors.push(...applied.errors);
      sourceUrls.push(link.url);
    }
    aggregate.inserts.push(...plan.inserts);
    aggregate.dateChanges.push(...plan.dateChanges);
    aggregate.confirms.push(...plan.confirms);
    aggregate.lockedConflicts.push(...plan.lockedConflicts);

    // อ่านครบทุกแหล่งโดย AI ไม่ error = ถือว่าอ่านแล้ว (ไม่เสียค่า AI ซ้ำทุกวัน)
    if (page.aiErrors.length === 0) scanned.add(link.url);
  }

  report.changes = {
    inserted: aggregate.inserts.length,
    dateChanges: aggregate.dateChanges.length,
    confirms: aggregate.confirms.length,
  };
  report.lockedConflicts = aggregate.lockedConflicts.length;
  aggregate.suspicious = report.suspicious;

  if (todo.length > 0) await saveScanned(db, scanned);

  const worthAlerting =
    planHasChanges(aggregate) || aggregate.lockedConflicts.length > 0 || allRejected.length > 0 || report.suspicious;
  if (alert && worthAlerting) {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (adminLineId) {
      report.alertSent = await sendLineMessage(adminLineId, [
        { type: "text", text: buildRoundAlertText(aggregate, allRejected, sourceUrls) },
      ]).catch(() => false);
    } else {
      console.error("[exam-round-scan] ADMIN_LINE_USER_ID not set — cannot notify");
    }
  }
  return report;
}
