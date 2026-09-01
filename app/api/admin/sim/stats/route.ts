import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { SIM_SCENARIOS } from "@/lib/sim/scenarios";

export const runtime = "nodejs";

interface RunRow {
  user_id: string;
  scenario_slug: string;
  won: boolean;
  grade: string;
  time_to_cpr_sec: number | null;
  time_to_shock_sec: number | null;
}

// aggregate ใน JS จากแถวล่าสุด ≤5000 — volume ช่วงแรกยังเล็ก
// ถ้าข้อมูลโตค่อยย้ายไป Postgres RPC (แบบ get_admin_overall_stats)
export async function GET() {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  const admin = createAdminClient();
  const [{ data: runs, error }, { data: dbScenarios }] = await Promise.all([
    admin
      .from("sim_runs")
      .select("user_id, scenario_slug, won, grade, time_to_cpr_sec, time_to_shock_sec")
      .order("created_at", { ascending: false })
      .limit(5000),
    admin.from("sim_scenarios").select("slug, title"),
  ]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const titles = new Map<string, string>();
  for (const s of SIM_SCENARIOS) titles.set(s.slug, s.title);
  for (const s of dbScenarios ?? []) titles.set(s.slug, s.title);

  const rows = (runs ?? []) as RunRow[];
  const players = new Set(rows.map((r) => r.user_id));
  const gradeDist: Record<string, number> = { S: 0, A: 0, B: 0, C: 0 };
  const perScenario = new Map<
    string,
    { runs: number; wins: number; cprSum: number; cprN: number; shockSum: number; shockN: number }
  >();

  for (const r of rows) {
    if (r.won && gradeDist[r.grade] !== undefined) gradeDist[r.grade] += 1;
    const s = perScenario.get(r.scenario_slug) ?? {
      runs: 0, wins: 0, cprSum: 0, cprN: 0, shockSum: 0, shockN: 0,
    };
    s.runs += 1;
    if (r.won) s.wins += 1;
    if (r.time_to_cpr_sec != null) { s.cprSum += r.time_to_cpr_sec; s.cprN += 1; }
    if (r.time_to_shock_sec != null) { s.shockSum += r.time_to_shock_sec; s.shockN += 1; }
    perScenario.set(r.scenario_slug, s);
  }

  return NextResponse.json({
    totalRuns: rows.length,
    uniquePlayers: players.size,
    winRate: rows.length ? Math.round((rows.filter((r) => r.won).length / rows.length) * 100) : 0,
    gradeDist,
    perScenario: [...perScenario.entries()]
      .map(([slug, s]) => ({
        slug,
        title: titles.get(slug) ?? slug,
        runs: s.runs,
        winRate: Math.round((s.wins / s.runs) * 100),
        avgTimeToCprSec: s.cprN ? Math.round(s.cprSum / s.cprN) : null,
        avgTimeToShockSec: s.shockN ? Math.round(s.shockSum / s.shockN) : null,
      }))
      .sort((a, b) => b.runs - a.runs),
  });
}
