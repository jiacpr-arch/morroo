// Code Blue Sim — data access (server components)
//
// เคสมี 2 แหล่ง: built-in ในโค้ด (lib/sim/scenarios.ts) + ตาราง sim_scenarios
// (แอดมิน/AI สร้าง, เฉพาะ status='published') — รวมกันโดย built-in ชนะเมื่อ slug ซ้ำ

import { createClient } from "@/lib/supabase/server";
import { SIM_SCENARIOS, getBuiltinScenario } from "@/lib/sim/scenarios";
import type { SimDbCharacter } from "@/lib/sim/characters";
import { isValidScenario, type SimScenario } from "@/lib/sim/types";

interface SimScenarioRow {
  slug: string;
  title: string;
  subtitle: string | null;
  difficulty_tag: string | null;
  story: unknown;
}

function rowToScenario(row: SimScenarioRow): SimScenario | null {
  const scenario = {
    slug: row.slug,
    title: row.title,
    subtitle: row.subtitle ?? "",
    difficultyTag: row.difficulty_tag ?? undefined,
    story: row.story,
  };
  return isValidScenario(scenario) ? scenario : null;
}

export async function getSimScenarios(): Promise<SimScenario[]> {
  const out = [...SIM_SCENARIOS];
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("sim_scenarios")
      .select("slug, title, subtitle, difficulty_tag, story")
      .eq("status", "published")
      .order("created_at", { ascending: true });
    for (const row of (data as SimScenarioRow[] | null) ?? []) {
      if (out.some((s) => s.slug === row.slug)) continue;
      const scenario = rowToScenario(row);
      if (scenario) out.push(scenario);
    }
  } catch {
    // DB ล่ม/ยังไม่ migrate → เล่น built-in ได้เสมอ
  }
  return out;
}

export async function getSimScenario(slug: string): Promise<SimScenario | null> {
  const builtin = getBuiltinScenario(slug);
  if (builtin) return builtin;
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("sim_scenarios")
      .select("slug, title, subtitle, difficulty_tag, story")
      .eq("slug", slug)
      .eq("status", "published")
      .maybeSingle();
    return data ? rowToScenario(data as SimScenarioRow) : null;
  } catch {
    return null;
  }
}

interface SimCharacterRow {
  slug: string;
  name: string;
  role: string | null;
  plate_top: string;
  plate_bottom: string;
  images: Record<string, string> | null;
  motion: string | null;
}

/** ตัวละคร active จากตาราง sim_characters (ตัวที่แอดมินเพิ่ม) */
export async function getSimCharacters(): Promise<SimDbCharacter[]> {
  try {
    const supabase = await createClient();
    const { data } = await supabase
      .from("sim_characters")
      .select("slug, name, role, plate_top, plate_bottom, images, motion")
      .eq("status", "active")
      .order("created_at", { ascending: true });
    return ((data as SimCharacterRow[] | null) ?? []).map((row) => ({
      slug: row.slug,
      name: row.name,
      role: row.role,
      plate: [row.plate_top, row.plate_bottom] as [string, string],
      images: row.images ?? {},
      motion: (row.motion ?? "none") as SimDbCharacter["motion"],
    }));
  } catch {
    return [];
  }
}

export interface SimBest {
  grade: string;
  score: number;
  won: boolean;
  runs: number;
}

/** ผลดีที่สุดของผู้ใช้ต่อเคส (สำหรับหน้ารวมเคส) — key = scenario_slug */
export async function getMySimBests(): Promise<Record<string, SimBest>> {
  const bests: Record<string, SimBest> = {};
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return bests;
    const { data } = await supabase
      .from("sim_runs")
      .select("scenario_slug, grade, score, won")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(500);
    type Run = { scenario_slug: string; grade: string; score: number; won: boolean };
    for (const run of (data as Run[] | null) ?? []) {
      const cur = bests[run.scenario_slug];
      if (!cur) {
        bests[run.scenario_slug] = { grade: run.grade, score: run.score, won: run.won, runs: 1 };
        continue;
      }
      cur.runs += 1;
      if (run.score > cur.score || (run.won && !cur.won)) {
        cur.grade = run.grade;
        cur.score = run.score;
        cur.won = cur.won || run.won;
      }
    }
  } catch {
    // Non-blocking
  }
  return bests;
}
