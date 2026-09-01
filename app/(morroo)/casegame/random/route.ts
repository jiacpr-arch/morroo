import { redirect } from "next/navigation";
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

/**
 * พาไปเล่นเคสถัดไป — ใช้จากปุ่มท้ายเกม/หน้าเริ่มเกม เพื่อไม่ต้องกลับไปไล่หาเอง
 * ในหน้ารวม
 *
 * เดิมสุ่มแบบ uniform จากทุกเคส (Math.random) ตอนนี้เลือกตามประวัติของผู้เล่น
 * ที่ล็อกอิน — สาขาที่เพิ่งพลาดมาก่อน เคสที่ชนะแล้วไปท้ายสุด
 *
 * ผู้เล่นที่ไม่ได้ล็อกอินยังได้แบบสุ่ม เพราะ route นี้อ่าน localStorage ไม่ได้
 * (คนกลุ่มนั้นเห็นรายการ "เคสถัดไปที่ควรเล่น" ที่จอ debrief แทน ซึ่งเรียก
 * /api/casegame/recommend จากฝั่ง client พร้อมประวัติในเครื่อง)
 *
 * ?exclude=<slug> กันได้เคสเดิมซ้ำตอนกดจากในเกม
 */
export async function GET(request: Request) {
  const sp = new URL(request.url).searchParams;
  const exclude = sp.get("exclude");

  // คงพารามิเตอร์แคมเปญ + `start` ไว้ ไม่งั้นคนที่มาจากโฆษณาแล้วกดเคสถัดไป
  // จะหลุด attribution และไม่ได้เข้าเกมทันทีเหมือนตอนแรก
  const carry = new URLSearchParams();
  for (const key of ["utm_source", "utm_medium", "utm_campaign", "utm_content", "start"]) {
    const value = sp.get(key);
    if (value) carry.set(key, value);
  }
  const qs = carry.toString();

  const [polished, longcase, meq, history] = await Promise.all([
    getPolishedLongcaseCards(),
    getLongcaseGameCards(),
    getMeqGameCards(),
    historyForCurrentUser(),
  ]);

  const seen = new Set<string>();
  const catalog: CaseCandidate[] = [];
  const add = (slug: string, title: string, specialty: string, difficulty: string) => {
    if (seen.has(slug)) return;
    seen.add(slug);
    const canonical = normalizeSpecialty(specialty);
    catalog.push({
      slug,
      title,
      specialty: canonical === OTHER_SPECIALTY ? "" : canonical,
      difficulty: normalizeDifficulty(difficulty),
    });
  };
  for (const p of polished) add(p.slug, p.title, p.specialty, p.difficulty);
  for (const l of longcase) add(l.slug, l.title, l.specialty, l.difficulty);
  for (const m of meq) add(m.slug, m.title, m.specialty, m.difficulty);

  const pool = catalog.filter((c) => c.slug !== exclude);
  // ไม่มีเคสอื่นให้ไปต่อ → กลับหน้ารวมให้ผู้ใช้เลือกเอง
  if (pool.length === 0) redirect(qs ? `/casegame?${qs}` : "/casegame");

  let slug: string;
  if (history === null) {
    // ไม่ล็อกอิน = ไม่มีประวัติฝั่ง server → สุ่มเหมือนเดิม
    slug = pool[Math.floor(Math.random() * pool.length)].slug;
  } else {
    const [top] = recommendNextCases(pool, history, { excludeSlug: exclude ?? undefined, limit: 1 });
    slug = top?.slug ?? pool[0].slug;
  }

  redirect(qs ? `/sim/${slug}?${qs}` : `/sim/${slug}`);
}

/** ประวัติของผู้ใช้ที่ล็อกอิน — null เมื่อไม่ได้ล็อกอิน (ตัวเรียกจะ fallback ไปสุ่ม) */
async function historyForCurrentUser(): Promise<PlayedCase[] | null> {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return null;
    const { data } = await supabase
      .from("sim_runs")
      .select("scenario_slug, specialty, won")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(200);
    type Row = { scenario_slug: string; specialty: string | null; won: boolean };
    return ((data as Row[] | null) ?? []).map((r) => {
      // แถวที่ backfill มาเก็บสาขาดิบไว้ (ไทย/อังกฤษปนกัน) จึงต้อง normalize ตอนอ่าน
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
