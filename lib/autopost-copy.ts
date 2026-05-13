/**
 * Generate a structured FB/IG caption "core" using Claude Haiku.
 *
 * Returns the parts that only the model can write (hook line, 1-2 sentence
 * subline, 3 key takeaways). Callers assemble the final caption with platform-
 * specific CTA / contact / hashtags via `buildFbCaption` / `buildIgCaption`.
 *
 * Falls back to title + description split into a synthetic structure if the
 * AI call fails, so the autopost pipeline never blocks on a Claude outage.
 */

export type HookParts = {
  hook: string;       // 1 line, max 1 emoji — the scroll-stopper
  subline: string;    // 1-2 sentences setting up why the article matters
  bullets: string[];  // 3 ✅ key takeaways (each ≤ 80 chars)
};

const MORROO_LINE_HANDLE = "@508srmcr";

function fallbackParts(title: string, description: string): HookParts {
  return {
    hook: title,
    subline: description,
    bullets: [
      "เข้าใจคอนเซ็ปต์ที่ออกสอบบ่อยแบบกระชับ",
      "ตัวอย่างเคสจริง + เทคนิคจำที่ใช้ได้ทันที",
      "ฝึกข้อสอบ MEQ + MCQ ฟรีต่อเนื่องในเว็บ",
    ],
  };
}

export async function generateHook(args: {
  title: string;
  description: string;
  apiKey: string | undefined;
}): Promise<HookParts> {
  if (!args.apiKey) return fallbackParts(args.title, args.description);

  try {
    const res = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": args.apiKey,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5",
        max_tokens: 600,
        tool_choice: { type: "tool", name: "compose_caption" },
        tools: [
          {
            name: "compose_caption",
            description:
              "Compose the structured core of a Facebook/Instagram caption " +
              "for a Thai medical-exam-prep blog article on morroo.com.",
            input_schema: {
              type: "object",
              properties: {
                hook: {
                  type: "string",
                  description:
                    "บรรทัดเดียว ภาษาไทย 60-110 ตัวอักษร — ต้อง hook ให้คนหยุดเลื่อน " +
                    "ใส่ emoji ได้ไม่เกิน 1 ตัว ห้าม hashtag ห้าม URL",
                },
                subline: {
                  type: "string",
                  description:
                    "1-2 ประโยค ภาษาไทย 80-180 ตัวอักษร — ขยายความว่าทำไมต้องอ่าน " +
                    "ห้าม emoji ห้าม hashtag ห้าม URL",
                },
                bullets: {
                  type: "array",
                  minItems: 3,
                  maxItems: 3,
                  items: {
                    type: "string",
                    description:
                      "key takeaway สั้น ๆ 30-80 ตัวอักษร ภาษาไทย — สิ่งที่ผู้อ่านจะได้ " +
                      "ห้าม emoji (จะถูกเติม ✅ หน้าให้) ห้าม hashtag ห้าม URL",
                  },
                  description: "3 key takeaways เรียงตามความสำคัญ",
                },
              },
              required: ["hook", "subline", "bullets"],
            },
          },
        ],
        messages: [
          {
            role: "user",
            content:
              `เขียน caption core สำหรับโพสต์เฟซบุ๊กของเว็บไซต์เตรียมสอบแพทย์ "หมอรู้" (morroo.com) ` +
              `กลุ่มเป้าหมาย: นิสิตนักศึกษาแพทย์ที่กำลังเตรียมสอบ MEQ/MCQ/Long Case ` +
              `ต้องชวนให้คลิกอ่านบทความ + รู้สึกว่าได้ความรู้ใช้สอบจริง ` +
              `น้ำเสียงกึ่งทางการ เป็นมิตร ตรงประเด็น\n\n` +
              `หัวข้อบทความ: ${args.title}\n` +
              `สรุปบทความ: ${args.description}\n\n` +
              `เรียก tool compose_caption พร้อม hook, subline, bullets ครบ`,
          },
        ],
      }),
    });

    if (!res.ok) return fallbackParts(args.title, args.description);

    const data = await res.json();
    const toolUse = data.content?.find((c: { type: string }) => c.type === "tool_use");
    const input = toolUse?.input as Partial<HookParts> | undefined;

    if (!input?.hook || !input?.subline || !Array.isArray(input.bullets) || input.bullets.length < 3) {
      return fallbackParts(args.title, args.description);
    }

    return {
      hook: input.hook.trim(),
      subline: input.subline.trim(),
      bullets: input.bullets.slice(0, 3).map((b) => b.trim()),
    };
  } catch {
    return fallbackParts(args.title, args.description);
  }
}

function stripScheme(url: string): string {
  return url.replace(/^https?:\/\//, "");
}

/**
 * Assemble the Facebook caption body. `postToFacebook` appends the trailing
 * "🔗 <canonical URL>" so the og: card always points at the right URL.
 *
 * Structure (mirrors what engages well on similar Thai health pages):
 *   hook → subline → 3 ✅ bullets → CTA + inline URL → LINE → hashtags
 */
export function buildFbCaption(parts: {
  hook: string;
  subline: string;
  bullets: string[];
  articleUrl: string;
  hashtags: string;
  lineHandle?: string;
}): string {
  const lineHandle = parts.lineHandle ?? MORROO_LINE_HANDLE;
  return [
    parts.hook,
    "",
    parts.subline,
    "",
    ...parts.bullets.map((b) => `✅ ${b}`),
    "",
    `อ่านบทความเต็ม + ฝึกข้อสอบฟรี 👉 ${stripScheme(parts.articleUrl)}`,
    "",
    `มีข้อสงสัย ติดต่อเราที่ LINE ${lineHandle}`,
    "",
    parts.hashtags,
  ].join("\n");
}

/**
 * Assemble the Instagram caption body. IG strips URL clickability in captions,
 * so the inline URL is replaced with a "link in bio" hint.
 */
export function buildIgCaption(parts: {
  hook: string;
  subline: string;
  bullets: string[];
  siteHost: string;        // e.g. "www.morroo.com"
  hashtags: string;
  lineHandle?: string;
}): string {
  const lineHandle = parts.lineHandle ?? MORROO_LINE_HANDLE;
  return [
    parts.hook,
    "",
    parts.subline,
    "",
    ...parts.bullets.map((b) => `✅ ${b}`),
    "",
    `📖 อ่านบทความเต็มที่ลิงก์ใน bio (${parts.siteHost})`,
    "",
    `มีข้อสงสัย ติดต่อเราที่ LINE ${lineHandle}`,
    "",
    parts.hashtags,
  ].join("\n");
}
