/**
 * Weekly digest cron — sends a personalised 7-day summary to every
 * opted-in user with an email address and >=1 attempt in the window.
 *
 * Scheduled via vercel.json (Monday 01:00 ICT = Sunday 18:00 UTC).
 * Manual trigger:
 *   GET /api/email/weekly-digest?secret=$DIGEST_SECRET
 */
import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendWeeklyDigest } from "@/lib/email/send";
import { generateUnsubscribeUrl } from "@/lib/newsletter-unsubscribe";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: Request): boolean {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  const expected = process.env.DIGEST_SECRET ?? process.env.BLOG_GENERATE_SECRET;
  if (expected && secret === expected) return true;
  // Vercel cron supplies Authorization: Bearer $CRON_SECRET
  const auth = request.headers.get("authorization") ?? "";
  const cronSecret = process.env.CRON_SECRET;
  return !!cronSecret && auth === `Bearer ${cronSecret}`;
}

export async function GET(request: Request) {
  return handle(request);
}

export async function POST(request: Request) {
  return handle(request);
}

async function handle(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  // Fetch opt-in users with an email.
  const { data: profiles, error: profilesError } = await supabase
    .from("profiles")
    .select("id, name, email")
    .eq("weekly_digest_opt_in", true)
    .neq("email", "");

  if (profilesError) {
    return NextResponse.json({ error: profilesError.message }, { status: 500 });
  }

  const candidates = (profiles as Array<{ id: string; name: string | null; email: string | null }> | null) ?? [];
  let sent = 0;
  let skipped = 0;
  let failed = 0;

  for (const p of candidates) {
    if (!p.email) {
      skipped++;
      continue;
    }

    const { data: digestRows, error: digestError } = await supabase.rpc("get_user_weekly_digest", {
      p_user_id: p.id,
    });

    if (digestError) {
      failed++;
      continue;
    }

    const row = Array.isArray(digestRows) && digestRows.length > 0 ? (digestRows[0] as {
      total_attempts: number | null;
      correct_count: number | null;
      accuracy: number | null;
      streak: number | null;
      best_subject_name: string | null;
      best_subject_icon: string | null;
      best_subject_accuracy: number | null;
      weak_subject_name: string | null;
      weak_subject_icon: string | null;
      weak_subject_accuracy: number | null;
    }) : null;

    // Skip users with zero attempts this week AND zero streak — they're
    // dormant and spamming them weekly hurts retention more than it helps.
    if (!row || ((row.total_attempts ?? 0) === 0 && (row.streak ?? 0) === 0)) {
      skipped++;
      continue;
    }

    try {
      await sendWeeklyDigest({
        email: p.email,
        name: p.name || p.email.split("@")[0],
        totalAttempts: row.total_attempts ?? 0,
        correctCount: row.correct_count ?? 0,
        accuracy: row.accuracy ?? 0,
        streak: row.streak ?? 0,
        bestSubject:
          row.best_subject_name && row.best_subject_icon != null
            ? {
                name: row.best_subject_name,
                icon: row.best_subject_icon,
                accuracy: row.best_subject_accuracy ?? 0,
              }
            : null,
        weakSubject:
          row.weak_subject_name && row.weak_subject_icon != null
            ? {
                name: row.weak_subject_name,
                icon: row.weak_subject_icon,
                accuracy: row.weak_subject_accuracy ?? 0,
              }
            : null,
        unsubscribeUrl: generateUnsubscribeUrl(p.id),
      });
      sent++;
    } catch (err) {
      console.error(`[weekly-digest] failed for ${p.id}:`, err);
      failed++;
    }
  }

  return NextResponse.json({
    candidates: candidates.length,
    sent,
    skipped,
    failed,
  });
}
