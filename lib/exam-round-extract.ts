/**
 * ตัวกรอง + กติกาลงปฏิทิน เมื่อ AI อ่านวันสอบจากประกาศ ศรว. — ลงปฏิทินอัตโนมัติโดยไม่มีคนยืนยัน
 * จึงต้องมีตัวกันพลาดที่ไม่พึ่ง AI (validateExtractedRound) และกติกาที่ไม่ทับงานของแอดมิน (planRoundChanges)
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { bangkokDateString } from "@/lib/exam-reminders";
import { formatThaiExamDate } from "@/lib/exam-dates";
import type { ExamKind } from "@/lib/exam-level";
import { isRealIsoDate, normalizeThaiText, parseThaiDate, weekdayOfIso } from "@/lib/thai-date";

export const ROUND_KINDS: readonly ExamKind[] = ["nl1", "nl2", "part1", "osce", "meq"];
/** AI ตอบเปลี่ยนเกินนี้ในครั้งเดียว = น่าสงสัย → ไม่ลงอะไรเลย แจ้งแอดมินแทน */
export const MAX_ROUNDS_PER_SCAN = 6;
const WINDOW_PAST_DAYS = 30;
const WINDOW_FUTURE_DAYS = 730;

export interface ValidRound {
  kind: ExamKind;
  label: string;
  /** YYYY-MM-DD (ค.ศ.) */
  date: string;
  evidence: string;
}

export type RoundCheck =
  | { ok: true; round: ValidRound }
  | { ok: false; reason: string; label: string };

function addDays(iso: string, days: number): string {
  const d = new Date(`${iso}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

/**
 * ตรวจรอบสอบที่ AI สกัดมา (untrusted). ผ่านต้องครบทุกข้อ:
 *  - kind อยู่ใน enum, label ไม่ว่าง, date เป็นวันที่จริงในช่วง [วันนี้-30 วัน, วันนี้+24 เดือน]
 *  - thai_date_text ที่ AI อ้างว่าเขียนในประกาศ แปลงด้วยโค้ดแล้ว "เท่ากับ" date (จับปี พ.ศ./ค.ศ. คลาดเคลื่อน)
 *  - ถ้า thai_date_text มีชื่อวัน ต้องตรงกับวันในสัปดาห์จริง
 *  - ถ้ามีเนื้อข้อความของแหล่งที่มา (sourceText) ต้องพบ thai_date_text อยู่ในนั้นจริง
 */
export function validateExtractedRound(
  raw: unknown,
  ctx: { now?: Date; sourceText?: string | null } = {}
): RoundCheck {
  const o = (raw && typeof raw === "object" ? raw : {}) as Record<string, unknown>;
  const label = typeof o.label === "string" ? o.label.replace(/\s+/g, " ").trim().slice(0, 120) : "";
  const fail = (reason: string): RoundCheck => ({ ok: false, reason, label: label || "(ไม่มีชื่อรอบ)" });

  if (typeof o.kind !== "string" || !ROUND_KINDS.includes(o.kind as ExamKind)) {
    return fail("ชนิดรอบสอบไม่รู้จัก");
  }
  if (label.length < 3) return fail("ไม่มีชื่อรอบ");

  const date = typeof o.date === "string" ? o.date : "";
  if (!isRealIsoDate(date)) return fail("วันที่ไม่ถูกต้อง");

  const today = bangkokDateString(ctx.now ?? new Date());
  if (date < addDays(today, -WINDOW_PAST_DAYS) || date > addDays(today, WINDOW_FUTURE_DAYS)) {
    return fail("วันที่อยู่นอกช่วงที่เป็นไปได้");
  }

  const thaiText = typeof o.thai_date_text === "string" ? o.thai_date_text : "";
  const parsed = parseThaiDate(thaiText);
  if (!parsed) return fail("อ่านข้อความวันที่ตามประกาศไม่ได้");
  if (parsed.iso !== date) return fail(`วันที่ไม่ตรงกับข้อความในประกาศ (${parsed.iso} ≠ ${date})`);
  if (parsed.weekday !== null && parsed.weekday !== weekdayOfIso(date)) {
    return fail("ชื่อวันในประกาศไม่ตรงกับวันที่");
  }

  if (typeof ctx.sourceText === "string") {
    if (!normalizeThaiText(ctx.sourceText).includes(normalizeThaiText(thaiText))) {
      return fail("ไม่พบข้อความวันที่นี้ในประกาศ");
    }
  }

  const evidence = typeof o.evidence === "string" ? o.evidence.replace(/\s+/g, " ").trim().slice(0, 500) : "";
  return { ok: true, round: { kind: o.kind as ExamKind, label, date, evidence } };
}

export interface ExistingRound {
  id: string;
  kind: string;
  label: string;
  exam_date: string;
  confirmed: boolean;
  locked: boolean;
}

export interface ChangePlan {
  inserts: ValidRound[];
  dateChanges: { id: string; round: ValidRound; previous: string }[];
  confirms: { id: string; round: ValidRound }[];
  /** รอบที่แอดมินล็อกไว้แต่ประกาศบอกวันอื่น — ไม่แตะ แจ้งแอดมินให้ตัดสินเอง */
  lockedConflicts: { existing: ExistingRound; round: ValidRound }[];
  noops: number;
  suspicious: boolean;
}

const emptyPlan = (): ChangePlan => ({
  inserts: [],
  dateChanges: [],
  confirms: [],
  lockedConflicts: [],
  noops: 0,
  suspicious: false,
});

/** กติกาลงปฏิทิน (pure) — ดูรายละเอียดใน applyChangePlan */
export function planRoundChanges(existing: readonly ExistingRound[], valid: readonly ValidRound[]): ChangePlan {
  const plan = emptyPlan();
  if (valid.length > MAX_ROUNDS_PER_SCAN) {
    plan.suspicious = true;
    return plan;
  }

  const byLabel = new Map(existing.map((e) => [`${e.kind}|${e.label}`, e]));
  const byDate = new Map(existing.map((e) => [`${e.kind}|${e.exam_date}`, e]));
  const seen = new Set<string>();

  for (const round of valid) {
    const labelKey = `${round.kind}|${round.label}`;
    const dateKey = `${round.kind}|${round.date}`;
    if (seen.has(labelKey) || seen.has(dateKey)) {
      plan.noops++;
      continue;
    }
    seen.add(labelKey);
    seen.add(dateKey);

    const sameLabel = byLabel.get(labelKey);
    if (sameLabel) {
      if (sameLabel.locked) {
        if (sameLabel.exam_date !== round.date) plan.lockedConflicts.push({ existing: sameLabel, round });
        else plan.noops++;
      } else if (sameLabel.exam_date !== round.date) {
        plan.dateChanges.push({ id: sameLabel.id, round, previous: sameLabel.exam_date });
      } else if (!sameLabel.confirmed) {
        plan.confirms.push({ id: sameLabel.id, round });
      } else {
        plan.noops++;
      }
      continue;
    }

    // ชื่อรอบต่างกันแต่เป็นวันเดียวกับรอบที่มีอยู่ → ถือว่ารอบเดียวกัน (กันซ้ำ)
    const sameDate = byDate.get(dateKey);
    if (sameDate) {
      if (!sameDate.locked && !sameDate.confirmed) plan.confirms.push({ id: sameDate.id, round });
      else plan.noops++;
      continue;
    }

    plan.inserts.push(round);
  }
  return plan;
}

export function planHasChanges(plan: ChangePlan): boolean {
  return plan.inserts.length + plan.dateChanges.length + plan.confirms.length > 0;
}

export interface ApplyResult {
  inserted: number;
  changed: number;
  confirmed: number;
  errors: string[];
}

/**
 * เขียนแผนลง exam_rounds. รอบใหม่ = confirmed (ประกาศจากแหล่งทางการที่ผ่านตัวกรองแล้ว).
 * update มีเงื่อนไข locked = false ในคำสั่งเอง — ถ้าแอดมินล็อกระหว่างทาง ก็ไม่ถูกทับ
 */
export async function applyChangePlan(
  db: SupabaseClient,
  plan: ChangePlan,
  sourceUrl: string
): Promise<ApplyResult> {
  const result: ApplyResult = { inserted: 0, changed: 0, confirmed: 0, errors: [] };
  const now = new Date().toISOString();

  for (const r of plan.inserts) {
    const { error } = await db.from("exam_rounds").insert({
      kind: r.kind,
      label: r.label,
      exam_date: r.date,
      confirmed: true,
      is_active: true,
      source: "auto",
      source_url: sourceUrl,
      evidence: r.evidence,
      locked: false,
    });
    if (!error) result.inserted++;
    else if (error.code !== "23505") result.errors.push(`${r.label}: ${error.message}`);
  }

  for (const c of plan.dateChanges) {
    const { error } = await db
      .from("exam_rounds")
      .update({
        exam_date: c.round.date,
        previous_date: c.previous,
        confirmed: true,
        source: "auto",
        source_url: sourceUrl,
        evidence: c.round.evidence,
        updated_at: now,
      })
      .eq("id", c.id)
      .eq("locked", false);
    if (!error) result.changed++;
    else result.errors.push(`${c.round.label}: ${error.message}`);
  }

  for (const c of plan.confirms) {
    const { error } = await db
      .from("exam_rounds")
      .update({ confirmed: true, source: "auto", source_url: sourceUrl, evidence: c.round.evidence, updated_at: now })
      .eq("id", c.id)
      .eq("locked", false);
    if (!error) result.confirmed++;
    else result.errors.push(`${c.round.label}: ${error.message}`);
  }
  return result;
}

export interface RejectedRound {
  label: string;
  reason: string;
}

const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

/** ข้อความ LINE แจ้งแอดมินเมื่อปฏิทินสอบเปลี่ยนเอง (หรือมีรอบที่ถูกข้าม) */
export function buildRoundAlertText(plan: ChangePlan, rejected: readonly RejectedRound[], sourceUrls: readonly string[]): string {
  const lines: string[] = ["📅 ปฏิทินสอบ ศรว. อัปเดตอัตโนมัติ"];
  for (const r of plan.inserts) lines.push(`• เพิ่ม: ${r.label} — ${formatThaiExamDate(r.date)}`);
  for (const c of plan.dateChanges) {
    lines.push(
      `• เปลี่ยนวัน: ${c.round.label} — จาก ${formatThaiExamDate(c.previous)} เป็น ${formatThaiExamDate(c.round.date)}`
    );
  }
  for (const c of plan.confirms) lines.push(`• ยืนยันแล้ว: ${c.round.label} — ${formatThaiExamDate(c.round.date)}`);
  for (const c of plan.lockedConflicts) {
    lines.push(
      `⚠ ${c.round.label}: ประกาศบอก ${formatThaiExamDate(c.round.date)} แต่ที่คุณล็อกไว้คือ ${formatThaiExamDate(c.existing.exam_date)} (ไม่ได้แก้ให้)`
    );
  }
  if (plan.suspicious) lines.push("⚠ AI ส่งรอบมามากผิดปกติ จึงไม่ลงปฏิทินอะไรเลย — โปรดตรวจประกาศเอง");
  for (const r of rejected.slice(0, 5)) lines.push(`⚠ ข้ามรอบ "${r.label}": ${r.reason}`);
  if (rejected.length > 5) lines.push(`…และอีก ${rejected.length - 5} รอบที่ถูกข้าม`);
  if (sourceUrls.length > 0) lines.push("", `ที่มา: ${sourceUrls[0]}`);
  lines.push(`ตรวจ/แก้ไขได้ที่ ${SITE_URL}/admin/exam-dates`);
  return lines.join("\n");
}
