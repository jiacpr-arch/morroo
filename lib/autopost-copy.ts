/**
 * Generate a short FB hook using Claude Haiku.
 * Falls back to "${title}\n\n${description}" if AI call fails.
 */
export async function generateHook(args: {
  title: string;
  description: string;
  apiKey: string | undefined;
}): Promise<string> {
  const fallback = `${args.title}\n\n${args.description}`;
  if (!args.apiKey) return fallback;

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
        max_tokens: 200,
        messages: [
          {
            role: "user",
            content:
              `เขียน hook ภาษาไทย 1-2 บรรทัด (ไม่เกิน 180 ตัวอักษร) ` +
              `สำหรับโพสต์เฟซบุ๊กชวนอ่านบทความเตรียมสอบแพทย์ ` +
              `ห้ามมี hashtag ห้ามมี emoji เกิน 1 ตัว ตอบเฉพาะข้อความ hook\n\n` +
              `หัวข้อ: ${args.title}\nสรุป: ${args.description}`,
          },
        ],
      }),
    });

    if (!res.ok) return fallback;

    const data = await res.json();
    const hook: string = data.content?.[0]?.text?.trim() ?? "";
    return hook.length > 10 ? hook : fallback;
  } catch {
    return fallback;
  }
}
