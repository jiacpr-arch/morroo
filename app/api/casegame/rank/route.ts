/**
 * GET /api/casegame/rank — "เทียบกับผู้เล่นอื่น" ท้ายเกมเคส
 *
 * อ่านจาก analytics_events.casegame_complete (ทุกคนรวม guest) ผ่าน RPC
 * get_casegame_percentile (supabase/migrations/20260915_casegame_percentile.sql)
 * ไม่ใช่ sim_runs เพราะ sim_runs มีแค่คนล็อกอิน (~8%) ตัวอย่างต่อ slug บางไป
 *
 * Public GET — ไม่ต้องล็อกอิน เหมือน app/api/track/casegame/route.ts และ
 * app/api/casegame/recommend/route.ts กันสแปมด้วย rate limit + validate slug
 *
 * ไม่มีวันคืน 500 ให้จอ debrief พัง — RPC พลาด/ไม่มีข้อมูลพอ = คืน scope:null
 * แคช CDN 10 นาที เพราะคะแนนเป็นค่าไม่ต่อเนื่อง (0/10/25/40/55/70/85/100) x
 * ~157 เคส x 3 หมวด คีย์รวมน้อย แคชได้คุ้มมาก ไม่ต้องยิง DB ทุกครั้งที่มีคนเล่นจบ
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { caseGameCategory } from "@/lib/sim/track";
import { pickRankScope, type PercentileRow } from "@/lib/casegame/percentile";
import { rateLimited } from "@/lib/firstaid/server/rateLimit";

export const runtime = "nodejs";

const RATE_LIMIT = { key: "casegame-rank", limit: 60, windowMs: 60_000 };
const SLUG_RE = /^[a-z0-9][a-z0-9-]{0,63}$/i;

function noRank() {
  return NextResponse.json(
    { scope: null, sample: 0, below: 0, tie: 0, percentile: null },
    { headers: { "Cache-Control": "public, s-maxage=600, stale-while-revalidate=3600" } },
  );
}

export async function GET(request: Request) {
  const limitedResponse = rateLimited(request, RATE_LIMIT);
  if (limitedResponse) return limitedResponse;

  const { searchParams } = new URL(request.url);
  const slug = searchParams.get("slug") ?? "";
  const scoreRaw = searchParams.get("score") ?? "";
  const category = caseGameCategory(searchParams.get("category") ?? undefined);

  if (!SLUG_RE.test(slug)) {
    return NextResponse.json({ ok: false }, { status: 400 });
  }
  const score = Number(scoreRaw);
  if (!Number.isFinite(score) || score < 0 || score > 100) {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  try {
    const supabase = createAdminClient();
    const { data, error } = await supabase.rpc("get_casegame_percentile", {
      p_slug: slug,
      p_score: Math.round(score),
      p_category: category,
    });
    if (error || !data) return noRank();

    const rows = data as PercentileRow[];
    const picked = pickRankScope(rows, { minSample: 30 });
    const percentile =
      picked.scope && picked.sample > 0 ? Math.round((picked.below / picked.sample) * 100) : null;

    return NextResponse.json(
      { ...picked, percentile },
      { headers: { "Cache-Control": "public, s-maxage=600, stale-while-revalidate=3600" } },
    );
  } catch {
    return noRank();
  }
}
