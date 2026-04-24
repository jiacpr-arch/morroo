import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

// GET /api/leaderboard?period=weekly|alltime&limit=10
// Returns { board: [...], me: { rank, ... } | null }
export async function GET(request: NextRequest) {
  const url = new URL(request.url);
  const period = url.searchParams.get("period") === "alltime" ? "alltime" : "weekly";
  const limitParam = Number(url.searchParams.get("limit") ?? "10");
  const limit = Number.isFinite(limitParam) ? Math.min(Math.max(limitParam, 1), 50) : 10;

  const supabase = await createClient();

  const [{ data: boardData }, { data: { user } }] = await Promise.all([
    supabase.rpc("get_leaderboard", { p_period: period, p_limit: limit }),
    supabase.auth.getUser(),
  ]);

  let me = null;
  if (user) {
    const { data: rankData } = await supabase.rpc("get_user_leaderboard_rank", {
      p_user_id: user.id,
      p_period: period,
    });
    me = Array.isArray(rankData) && rankData.length > 0 ? rankData[0] : null;
  }

  return NextResponse.json({ board: boardData ?? [], me, period });
}
