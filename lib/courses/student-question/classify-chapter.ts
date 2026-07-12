// Classifies a student Q&A pair into one of the existing acls_chapters ids
// via a DeepSeek call. Pure w.r.t. its inputs (question/answer/chapters) —
// no Supabase access here, only the network call. Ported from acls-emr's
// api/_lib/classifyChapter.js.

const DEEPSEEK_URL = "https://api.deepseek.com/chat/completions";

export interface ClassifyChapterInput {
  question: string;
  answer: string;
  chapters: { id: string; title: string }[];
}

export interface ClassifyChapterResult {
  chapterId: string | null;
  reason: string;
  suggestedNewChapter: string;
}

/**
 * Classify a Q&A pair into one of the existing chapter ids.
 * Returns { chapterId, reason, suggestedNewChapter } where chapterId is null
 * if no existing chapter fits.
 */
export async function classifyChapter({
  question,
  answer,
  chapters,
}: ClassifyChapterInput): Promise<ClassifyChapterResult> {
  const key = process.env.DEEPSEEK_API_KEY;
  if (!key) throw new Error("DEEPSEEK_API_KEY not configured");
  if (!chapters?.length) {
    return { chapterId: null, reason: "no chapters configured", suggestedNewChapter: "" };
  }

  const catalog = chapters.map((c) => `- id="${c.id}" :: ${c.title}`).join("\n");

  const systemPrompt = [
    "You classify ACLS Q&A items into one of the existing chapter ids.",
    "Pick the SINGLE best matching chapter id from the list below.",
    'If absolutely no existing chapter fits, return chapterId="" AND set',
    "suggestedNewChapter to a short Thai title (max 40 chars) for a new chapter",
    "that would fit. Otherwise leave suggestedNewChapter empty.",
    "Reply with strict JSON only:",
    '{"chapterId": "ch1", "reason": "สั้นๆ", "suggestedNewChapter": ""}',
    "",
    "Chapter catalog:",
    catalog,
  ].join("\n");

  const userPrompt = [
    `Question:\n${question}`,
    "",
    `Answer (first 1500 chars):\n${String(answer || "").slice(0, 1500)}`,
  ].join("\n");

  const resp = await fetch(DEEPSEEK_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "deepseek-chat",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: userPrompt },
      ],
      temperature: 0,
      max_tokens: 200,
      response_format: { type: "json_object" },
    }),
  });
  if (!resp.ok) {
    return { chapterId: null, reason: `classify failed: ${resp.status}`, suggestedNewChapter: "" };
  }
  const data = await resp.json();
  const raw: string = data?.choices?.[0]?.message?.content?.trim() || "{}";
  let parsed: { chapterId?: string; reason?: string; suggestedNewChapter?: string };
  try {
    parsed = JSON.parse(raw);
  } catch {
    return { chapterId: null, reason: `parse failed: ${raw.slice(0, 200)}`, suggestedNewChapter: "" };
  }
  const valid = new Set(chapters.map((c) => c.id));
  const chapterId = parsed.chapterId && valid.has(parsed.chapterId) ? parsed.chapterId : null;
  const suggestedNewChapter = chapterId
    ? ""
    : String(parsed.suggestedNewChapter || "").trim().slice(0, 40);
  return {
    chapterId,
    reason: String(parsed.reason || "").slice(0, 500),
    suggestedNewChapter,
  };
}
