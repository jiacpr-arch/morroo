// Operation MorRoo — data access (server components)
//
// ด่านมี 2 แหล่ง: built-in ในโค้ด (lib/resus/cases.ts) + ตาราง
// resus_cases (แอดมิน/AI สร้าง, เฉพาะ status='published') —
// รวมกันโดย built-in ชนะเมื่อ slug ซ้ำ (โครงเดียวกับ queries-sim.ts)

import { createClient } from "@/lib/supabase/server";
import { CASES, getBuiltinCase } from "@/lib/resus/cases";
import { isValidOperation, type Operation } from "@/lib/resus/types";

interface OperationRow {
  slug: string;
  definition: unknown;
}

function rowToOperation(row: OperationRow): Operation | null {
  const def = row.definition;
  if (!def || typeof def !== "object") return null;
  const op = { ...(def as Record<string, unknown>), slug: row.slug };
  return isValidOperation(op) ? op : null;
}

export async function getResusCases(): Promise<Operation[]> {
  const out = [...CASES];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("resus_cases")
      .select("slug, definition")
      .eq("status", "published")
      .order("created_at", { ascending: true });
    for (const row of (data as OperationRow[] | null) ?? []) {
      if (out.some((o) => o.slug === row.slug)) continue;
      const op = rowToOperation(row);
      if (op) out.push(op);
    }
  } catch {
    // DB ล่ม/ยังไม่ migrate → เล่น built-in ได้เสมอ
  }
  return out;
}

export async function getResusCase(slug: string): Promise<Operation | null> {
  const builtin = getBuiltinCase(slug);
  if (builtin) return builtin;
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("resus_cases")
      .select("slug, definition")
      .eq("slug", slug)
      .eq("status", "published")
      .maybeSingle();
    return data ? rowToOperation(data as OperationRow) : null;
  } catch {
    return null;
  }
}

export interface ResusBest {
  grade: string;
  score: number;
  stars: number;
  won: boolean;
  runs: number;
}

/** ผลดีที่สุดของผู้ใช้ต่อด่าน (สำหรับหน้ารวมด่าน) — key = case_slug */
export async function getMyResusBests(): Promise<Record<string, ResusBest>> {
  const bests: Record<string, ResusBest> = {};
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return bests;
    const { data } = await supabase
      .from("resus_runs")
      .select("case_slug, grade, score, stars, won")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(500);
    type Run = { case_slug: string; grade: string; score: number; stars: number; won: boolean };
    for (const run of (data as Run[] | null) ?? []) {
      const cur = bests[run.case_slug];
      if (!cur) {
        bests[run.case_slug] = {
          grade: run.grade, score: run.score, stars: run.stars ?? 0, won: run.won, runs: 1,
        };
        continue;
      }
      cur.runs += 1;
      if (run.score > cur.score || (run.won && !cur.won)) {
        cur.grade = run.grade;
        cur.score = run.score;
        cur.stars = Math.max(cur.stars, run.stars ?? 0);
        cur.won = cur.won || run.won;
      }
    }
  } catch {
    // Non-blocking
  }
  return bests;
}
