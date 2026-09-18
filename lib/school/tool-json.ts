/**
 * Salvaging a `tool_use` response that ran out of `max_tokens`.
 *
 * When generation is cut off mid-JSON the SDK still hands back a `tool_use`
 * block, but its `input` has been through a partial-JSON parser that DROPS any
 * value it only saw half of. A lesson cut off while the model was still writing
 * `body_md` therefore arrives as `{ title, layer, estimated_min }` with the body
 * silently gone — indistinguishable downstream from "the model never wrote a
 * body", which is how a truncated lesson used to surface three steps later as
 * "ต้องมี lesson ก่อนสร้าง flashcards".
 *
 * The raw `input_json_delta` buffer still holds those half-written characters,
 * so these helpers read the value straight out of it instead.
 */

export const TRUNCATION_NOTE =
  "> ⚠️ AI เขียนได้ไม่จบ (เนื้อหายาวเกินโควตาต่อครั้ง) — ส่วนท้ายขาดหายไป ตรวจและเติมให้ครบก่อนบันทึก";

/**
 * Read a string field out of raw tool JSON, including one whose closing quote
 * never arrived. Returns null if the field isn't in the buffer at all.
 */
export function recoverStringField(raw: string, key: string): string | null {
  const opener = new RegExp(`"${key}"\\s*:\\s*"`).exec(raw);
  if (!opener) return null;
  const start = opener.index + opener[0].length;

  let end = start;
  let escaped = false;
  let closed = false;
  for (; end < raw.length; end++) {
    const c = raw[end];
    if (escaped) {
      escaped = false;
      continue;
    }
    if (c === "\\") {
      escaped = true;
      continue;
    }
    if (c === '"') {
      closed = true;
      break;
    }
  }

  let body = raw.slice(start, end);
  if (!closed) {
    // The cut can land inside an escape sequence (`\` or `\u12`), which would
    // make the re-parse below throw. Drop the incomplete tail first.
    body = body.replace(/\\u[0-9a-fA-F]{0,3}$/, "");
    const trailingSlashes = /\\*$/.exec(body)?.[0].length ?? 0;
    if (trailingSlashes % 2 === 1) body = body.slice(0, -1);
  }

  // Re-parsing as a JSON string is what turns \n, \uXXXX etc. back into text.
  try {
    return JSON.parse(`"${body}"`) as string;
  } catch {
    return null;
  }
}

/**
 * Make a body that stops mid-thought safe to show and to save: close off any
 * half-written fenced block, drop the dangling last paragraph, and say plainly
 * that the tail is missing so the reviewer fixes it rather than shipping it.
 */
export function tidyTruncatedBody(md: string): string {
  let kept = md;
  // An unclosed ``` fence would swallow everything after it when rendered, and
  // the inline-quiz parser would choke on the half-written JSON inside it.
  const fences = kept.match(/```/g)?.length ?? 0;
  if (fences % 2 === 1) kept = kept.slice(0, kept.lastIndexOf("```"));
  // Cut back to the last paragraph break so the prose doesn't stop mid-word.
  // Only when that keeps most of the text — on a very early cut there is no
  // good boundary and keeping what we have beats throwing it away.
  const para = kept.lastIndexOf("\n\n");
  if (para > kept.length * 0.5) kept = kept.slice(0, para);
  return `${kept.trimEnd()}\n\n${TRUNCATION_NOTE}`;
}

/**
 * Reading-time estimate, used when the cut landed before the model wrote
 * `estimated_min`. Thai prose has no word spacing, so count characters:
 * ~500 chars/min is a comfortable pace for study material.
 */
export function estimateMinutes(body: string): number {
  return Math.min(120, Math.max(5, Math.round(body.length / 500)));
}

/**
 * Drop entries the partial-JSON parser only half-built. A batch cut off mid
 * object yields things like `{ front: "…" }` with no `back` — inserting those
 * fails the NOT NULL columns and takes the whole batch down with them.
 */
export function keepComplete<T extends object>(
  items: unknown,
  required: readonly (keyof T & string)[],
): T[] {
  if (!Array.isArray(items)) return [];
  return items.filter((item): item is T => {
    if (!item || typeof item !== "object") return false;
    const row = item as Record<string, unknown>;
    return required.every((k) => {
      const v = row[k];
      if (typeof v === "string") return v.trim().length > 0;
      if (Array.isArray(v)) return v.length > 0;
      return v !== undefined && v !== null;
    });
  });
}
