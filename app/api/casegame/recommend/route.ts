import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  getLongcaseGameCards,
  getMeqGameCards,
  getPolishedLongcaseCards,
} from "@/lib/supabase/queries-sim";
import {
  normalizeDifficulty,
  normalizeSpecialty,
  OTHER_SPECIALTY,
} from "@/lib/casegame/normalize";
import {
  recommendNextCases,
  type CaseCandidate,
  type PlayedCase,
} from "@/lib/casegame/recommend";

export const dynamic = "force-dynamic";

/** เพดานประวัติที่รับจาก client — พอสำหรับคนเล่นหนัก และกัน payload บวม */
const MAX_HISTORY = 200;
/** เพดานจำนวนเคสที่คืน — debrief แสดงไหวราว 3 ใบบนมือถือ */
const MAX_LIMIT = 5;

interface Body {
  excludeSlug?: string;
  lastWon?: boolean;
  lastGrade?: string | null;
  limit?: number;
  /**
   * ประวัติจากเครื่องผู้เล่นที่ยังไม่ล็อกอิน (localStorage) — คนล็อกอินไม่ต้องส่ง
   * มา เพราะอ่านจาก sim_runs ที่เชื่อถือได้กว่า
   *
   * ไม่ต้อง validate เชิงความปลอดภัย: ประวัตินี้มีผลแค่กับคำแนะนำที่ผู้ส่งเอง
   * จะได้รับกลับไป ไม่ได้เขียนอะไรลง DB และไม่ได้ให้สิทธิ์อะไรเพิ่ม
   */
  history?: PlayedCase[];
}

function sanitizeHistory(raw: unknown): PlayedCase[] {
  if (!Array.isArray(raw)) return [];
  const out: PlayedCase[] = [];
  for (const item of raw.slice(-MAX_HISTORY)) {
    if (!item || typeof item !== "object") continue;
    const r = item as Record<string, unknown>;
    if (typeof r.slug !== "string" || !r.slug) continue;
    if (typeof r.won !== "boolean") continue;
    const specialty = typeof r.specialty === "string" ? normalizeSpecialty(r.specialty) : null;
    out.push({
      slug: r.slug,
      specialty: specialty && specialty !== OTHER_SPECIALTY ? specialty : null,
      won: r.won,
    });
  }
  return out;
}

/** ประวัติของผู้ใช้ที่ล็อกอิน — คืน null เมื่อไม่ได้ล็อกอิน (ให้ fallback ไป client history) */
async function historyFromAccount(): Promise<PlayedCase[] | null> {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return null;
    const { data } = await supabase
      .from("sim_runs")
      .select("scenario_slug, specialty, won")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(MAX_HISTORY);
    type Row = { scenario_slug: string; specialty: string | null; won: boolean };
    return ((data as Row[] | null) ?? []).map((r) => {
      // แถวที่ backfill มาเก็บสาขาดิบไว้ (ไทย/อังกฤษปนกัน) ต้อง normalize ตอนอ่าน
      const canonical = r.specialty ? normalizeSpecialty(r.specialty) : null;
      return {
        slug: r.scenario_slug,
        specialty: canonical && canonical !== OTHER_SPECIALTY ? canonical : null,
        won: r.won,
      };
    });
  } catch {
    return null;
  }
}

/** เคสทั้งหมดที่เล่นได้ พร้อมสาขา/ความยากที่ normalize แล้ว */
async function loadCatalog(): Promise<CaseCandidate[]> {
  const [polished, longcase, meq] = await Promise.all([
    getPolishedLongcaseCards(),
    getLongcaseGameCards(),
    getMeqGameCards(),
  ]);

  const seen = new Set<string>();
  const out: CaseCandidate[] = [];
  const add = (slug: string, title: string, specialty: string, difficulty: string) => {
    if (seen.has(slug)) return;
    seen.add(slug);
    const canonical = normalizeSpecialty(specialty);
    out.push({
      slug,
      title,
      specialty: canonical === OTHER_SPECIALTY ? "" : canonical,
      difficulty: normalizeDifficulty(difficulty),
    });
  };

  for (const p of polished) add(p.slug, p.title, p.specialty, p.difficulty);
  for (const l of longcase) add(l.slug, l.title, l.specialty, l.difficulty);
  for (const m of meq) add(m.slug, m.title, m.specialty, m.difficulty);
  return out;
}

/**
 * POST /api/casegame/recommend
 *
 * แนะนำเคสถัดไปแทนการสุ่มมั่ว — ใช้ประวัติจากบัญชีถ้าล็อกอิน ไม่งั้นใช้ประวัติ
 * ที่ client ส่งมาจาก localStorage (ผู้เล่น ~92% ไม่ได้ล็อกอิน จึงต้องรองรับ)
 */
export async function POST(request: Request) {
  let body: Body = {};
  try {
    body = (await request.json()) as Body;
  } catch {
    // ไม่มี body ก็แนะนำแบบไม่มีประวัติได้
  }

  const [catalog, accountHistory] = await Promise.all([
    loadCatalog(),
    historyFromAccount(),
  ]);
  const history = accountHistory ?? sanitizeHistory(body.history);

  const picks = recommendNextCases(catalog, history, {
    excludeSlug: typeof body.excludeSlug === "string" ? body.excludeSlug : undefined,
    lastWon: typeof body.lastWon === "boolean" ? body.lastWon : undefined,
    lastGrade: typeof body.lastGrade === "string" ? body.lastGrade : null,
    limit: Math.min(MAX_LIMIT, Math.max(1, Number(body.limit) || 3)),
  });

  return NextResponse.json({ picks });
}
