import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { buildWeeklySummaryFlex } from "@/lib/line-flex-templates";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  // Get paid members with LINE linked and active membership
  const { data: users, error } = await supabase
    .from("profiles")
    .select("id, name, line_user_id")
    .not("line_user_id", "is", null)
    .neq("membership_type", "free")
    .gt("membership_expires_at", new Date().toISOString());

  if (error) {
    console.error("[weekly-summary] query error:", error);
    return NextResponse.json({ error: "DB query failed" }, { status: 500 });
  }

  let sent = 0;
  let skipped = 0;

  for (const user of users ?? []) {
    // Get weekly summary via RPC
    const { data: summary } = await supabase.rpc("get_user_weekly_summary", {
      p_user_id: user.id,
    });

    const row = Array.isArray(summary) ? summary[0] : summary;
    if (!row || row.total_questions === 0) {
      skipped++;
      continue;
    }

    // Get weak topics
    const { data: weakTopics } = await supabase.rpc("get_user_weak_topics", {
      p_user_id: user.id,
      p_threshold: 60,
    });

    const weakNames = (weakTopics ?? [])
      .slice(0, 2)
      .map((t: { subject_name_th?: string }) => t.subject_name_th)
      .filter(Boolean) as string[];

    const msg = buildWeeklySummaryFlex({
      totalQuestions: row.total_questions,
      correctCount: row.correct_count,
      accuracy: Number(row.accuracy),
      bestSubject: row.best_subject ?? "",
      bestSubjectIcon: row.best_subject_icon ?? "",
      streak: row.streak ?? 0,
      weakTopics: weakNames,
    });

    const ok = await sendLineMessage(user.line_user_id, [msg]);
    if (ok) sent++;

    // Rate limit: 100ms delay between sends
    await new Promise((r) => setTimeout(r, 100));
  }

  console.log(`[weekly-summary] sent=${sent} skipped=${skipped} total=${(users ?? []).length}`);
  return NextResponse.json({ ok: true, sent, skipped, total: (users ?? []).length });
}
