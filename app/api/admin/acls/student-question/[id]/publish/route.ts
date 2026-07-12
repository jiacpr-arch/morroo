import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Publishes a draft student question into the live Q&A:
//   1. Insert a row in acls_qa_deep_items (next sort_order)
//   2. Insert a cover image row in acls_qa_deep_images if we have an image
//   3. Update the student-question row → status='published', link to item id
//
// Body: { question?, answer?, chapterId? } — lets the admin override the
// AI-generated fields right before publishing.
// Ported from acls-emr's api/student-question/publish.js.

export const runtime = "nodejs";

interface PublishBody {
  question?: string;
  answer?: string;
  chapterId?: string | null;
}

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;
  if (!id) return NextResponse.json({ error: "id required" }, { status: 400 });

  let body: PublishBody;
  try {
    body = await request.json();
  } catch {
    body = {};
  }

  const supabase = createAdminClient();

  const { data: row, error: loadErr } = await supabase
    .from("acls_student_questions")
    .select("id, question, deepseek_answer, suggested_chapter_id, generated_image_url, status, published_item_id")
    .eq("id", id)
    .maybeSingle();
  if (loadErr) {
    console.error("load student question failed:", loadErr.message);
    return NextResponse.json({ error: "Failed to load question" }, { status: 500 });
  }
  if (!row) return NextResponse.json({ error: "not found" }, { status: 404 });

  const typedRow = row as {
    id: string;
    question: string;
    deepseek_answer: string | null;
    suggested_chapter_id: string | null;
    generated_image_url: string | null;
    status: string;
    published_item_id: string | null;
  };

  if (typedRow.status === "published" && typedRow.published_item_id) {
    return NextResponse.json(
      { error: "already published", publishedItemId: typedRow.published_item_id },
      { status: 409 },
    );
  }
  if (!typedRow.deepseek_answer) {
    return NextResponse.json({ error: "no answer to publish — run reprocess first" }, { status: 400 });
  }

  const question = String(body.question ?? typedRow.question).trim();
  const answer = String(body.answer ?? typedRow.deepseek_answer).trim();
  const chapterId = body.chapterId === undefined ? typedRow.suggested_chapter_id : body.chapterId || null;

  // Compute next sort_order
  const { data: tail, error: tailErr } = await supabase
    .from("acls_qa_deep_items")
    .select("sort_order")
    .order("sort_order", { ascending: false })
    .limit(1);
  if (tailErr) {
    console.error("read qa_deep sort_order failed:", tailErr.message);
    return NextResponse.json({ error: "Failed to compute sort order" }, { status: 500 });
  }
  const nextOrder = ((tail?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data: created, error: insErr } = await supabase
    .from("acls_qa_deep_items")
    .insert({
      question,
      answer,
      chapter_id: chapterId || null,
      sort_order: nextOrder,
    })
    .select("id")
    .single();
  if (insErr || !created) {
    console.error("create qa_deep item failed:", insErr?.message);
    return NextResponse.json({ error: "create item failed" }, { status: 500 });
  }
  const createdId = (created as { id: string }).id;

  if (typedRow.generated_image_url) {
    const { error: imgErr } = await supabase.from("acls_qa_deep_images").insert({
      item_id: createdId,
      image_type: "cover",
      src: typedRow.generated_image_url,
      alt: question.slice(0, 200),
      caption: "",
      sort_order: 1,
    });
    if (imgErr) {
      // Don't roll back the item — admin can re-upload manually.
      console.warn("attach image failed:", imgErr.message);
    }
  }

  const { error: updErr } = await supabase
    .from("acls_student_questions")
    .update({
      status: "published",
      published_item_id: createdId,
      published_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    })
    .eq("id", id);
  if (updErr) {
    console.error("mark published failed:", updErr.message);
    return NextResponse.json({ error: "mark published failed" }, { status: 500 });
  }

  return NextResponse.json({ ok: true, itemId: createdId });
}
