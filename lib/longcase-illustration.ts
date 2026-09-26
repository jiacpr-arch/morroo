import sharp from "sharp";

/**
 * AI illustrations for Long Case physical-exam signs (rash, pitting edema,
 * scleral icterus…). Shared by the admin route and the batch script.
 *
 * Deliberately NOT for ECG / CXR / CT / ultrasound: generated "results" look
 * plausible but get the physiology wrong, so those must be real studies.
 */

export const PE_ILLUSTRATION_CREDIT = "ภาพประกอบสร้างด้วย AI (ไม่ใช่ภาพผู้ป่วยจริง)";

const MODEL = "gpt-image-2.5-flare";
const MODEL_FALLBACK = "gpt-image-1";

const INVESTIGATION_RE =
  /\b(ecg|ekg|electrocardiogra\w*|cxr|x-?ray|radiograph\w*|ct|mri|ultrasound|sonogra\w*|echocardiogra\w*|film)\b/i;

/** Reject scenes that ask for an investigation image instead of a PE sign. */
export function illustrationSceneError(scene: string): string | null {
  const s = scene.trim();
  if (s.length < 15) return "บรรยายภาพให้ละเอียดขึ้น (อย่างน้อย 15 ตัวอักษร)";
  if (s.length > 800) return "คำบรรยายยาวเกิน 800 ตัวอักษร";
  if (INVESTIGATION_RE.test(s)) return "ใช้กับรูปตรวจร่างกายเท่านั้น — ECG / CXR / CT / US ต้องใช้ผลจริง ห้ามสร้างด้วย AI";
  return null;
}

export function illustrationPrompt(scene: string): string {
  return `Medical textbook illustration for teaching physical examination to medical students — clean digital painting, realistic proportions and anatomy, soft even clinical lighting, plain light neutral background, close-up framed on the body region. Clearly an illustration, NOT a photograph of a real patient.
SIGN TO SHOW: ${scene.trim()}
RULES: show only the described sign accurately; no blood or gore; no text, letters, numbers, arrows, labels, watermarks or captions; no identifiable real person.`;
}

async function callImageApi(apiKey: string, model: string, prompt: string): Promise<Response> {
  return fetch("https://api.openai.com/v1/images/generations", {
    method: "POST",
    headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
    // same size/quality shape as generate-lesson-figures (verified against the live API)
    body: JSON.stringify({ model, prompt, size: "1536x1024", quality: "high" }),
  });
}

/** Generate one illustration and return it as a 1200px-wide WebP. */
export async function generateIllustration(scene: string, apiKey: string): Promise<Buffer> {
  const prompt = illustrationPrompt(scene);
  let res = await callImageApi(apiKey, MODEL, prompt);
  if (!res.ok && res.status >= 400 && res.status < 500) {
    console.warn(`[longcase-illustration] ${MODEL} rejected (${res.status}) — falling back to ${MODEL_FALLBACK}`);
    res = await callImageApi(apiKey, MODEL_FALLBACK, prompt);
  }
  if (!res.ok) throw new Error(`OpenAI image error ${res.status}: ${(await res.text()).slice(0, 300)}`);
  const json = (await res.json()) as { data?: { b64_json?: string }[] };
  const b64 = json.data?.[0]?.b64_json;
  if (!b64) throw new Error("OpenAI image: empty response");
  return sharp(Buffer.from(b64, "base64")).resize({ width: 1200 }).webp({ quality: 82 }).toBuffer();
}
