import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getRecommendedQuestions } from "@/lib/mcq-recommendation";

export const runtime = "nodejs";

// GET /api/mcq/recommended?examType=NL2&limit=20&preview=1
// Returns a personalised question list + breakdown. With preview=1, only the
// breakdown is returned (used by the dashboard widget).
export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const url = new URL(request.url);
  const examTypeParam = url.searchParams.get("examType");
  const examType = examTypeParam === "NL1" ? "NL1" : "NL2";
  const limitParam = Number(url.searchParams.get("limit") ?? "20");
  const limit = Number.isFinite(limitParam) ? Math.min(Math.max(limitParam, 1), 50) : 20;
  const preview = url.searchParams.get("preview") === "1";

  const result = await getRecommendedQuestions(supabase, user.id, { examType, limit });

  if (preview) {
    return NextResponse.json({ breakdown: result.breakdown, total: result.questions.length });
  }

  return NextResponse.json(result);
}
