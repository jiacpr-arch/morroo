// Set the signed-in user's exam level (profiles.target_exam) and/or study year
// (profiles.current_year). The user id comes from the session, never the body.
//
// POST { target_exam?: "part1"|"part2"|"NL2"|"meq"|"board" (lib/exam-level),
//        board_specialty?: <board_specialties.slug> | null, current_year?: 1-6 | null }
//   → { ok: true, data: { target_exam, board_specialty, current_year } }

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { isBoardSpecialtySlug, isCurrentYear, isExamTarget } from "@/lib/exam-level";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = (await request.json().catch(() => null)) as {
    target_exam?: unknown;
    board_specialty?: unknown;
    current_year?: unknown;
  } | null;
  if (!body) {
    return NextResponse.json({ error: "Invalid body" }, { status: 400 });
  }

  const update: {
    target_exam?: string;
    board_specialty?: string | null;
    current_year?: number | null;
  } = {};
  if (body.target_exam !== undefined) {
    if (!isExamTarget(body.target_exam)) {
      return NextResponse.json({ error: "Invalid target_exam" }, { status: 400 });
    }
    update.target_exam = body.target_exam;
  }
  if (body.board_specialty !== undefined) {
    if (body.board_specialty === null) {
      update.board_specialty = null;
    } else {
      // must be a real, active specialty (the column is a FK, but answer 400 not 500)
      const slug = body.board_specialty;
      const { data: spec } = isBoardSpecialtySlug(slug)
        ? await supabase
            .from("board_specialties")
            .select("slug")
            .eq("slug", slug)
            .eq("is_active", true)
            .maybeSingle()
        : { data: null };
      if (!isBoardSpecialtySlug(slug) || !spec) {
        return NextResponse.json({ error: "Invalid board_specialty" }, { status: 400 });
      }
      update.board_specialty = slug;
    }
  }
  if (body.current_year !== undefined) {
    if (body.current_year !== null && !isCurrentYear(body.current_year)) {
      return NextResponse.json({ error: "Invalid current_year" }, { status: 400 });
    }
    update.current_year = body.current_year as number | null;
  }
  if (Object.keys(update).length === 0) {
    return NextResponse.json({ error: "Nothing to update" }, { status: 400 });
  }

  const { data, error } = await supabase
    .from("profiles")
    .update(update)
    .eq("id", user.id)
    .select("target_exam, board_specialty, current_year")
    .single();
  if (error) {
    console.error("[profile/exam-level] update failed:", error.message);
    return NextResponse.json({ error: "Update failed" }, { status: 500 });
  }

  return NextResponse.json({ ok: true, data });
}
