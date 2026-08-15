/**
 * กติกาการอัปโหลดไฟล์ต้นฉบับสำหรับ "นำเข้าเนื้อหาด้วย AI" (client-safe)
 *
 * อัปได้หลายไฟล์ต่อครั้ง และทุกไฟล์จะถูกรวมเป็นบทเรียนเดียว — ข้อจำกัดของ
 * Anthropic เป็นแบบ "ต่อ request" ไม่ใช่ต่อไฟล์ ขนาดรวมจึงเป็นตัวตัดสิน
 *
 * เส้นทางอัปโหลดมีสองแบบ และเลือกจากขนาดรวมเสมอ เพื่อไม่ให้ปนกัน:
 *   - รวมไม่เกิน 4 MB  → ส่งไฟล์ไปกับ request ตรง ๆ (multipart)
 *   - เกินกว่านั้น      → อัปทุกไฟล์ขึ้น Supabase Storage แล้วส่งแต่ path
 */

/** ขนาดรวมสูงสุดที่ยัดใส่ body ของ request ได้ */
export const DIRECT_UPLOAD_MAX = 4 * 1024 * 1024;

/** Anthropic รับ payload ต่อ request ไม่เกิน 32 MB (นับรวมทุกไฟล์) */
export const TOTAL_MAX = 32 * 1024 * 1024;

/** รูปภาพต่อไฟล์ต้องไม่เกินเท่านี้ ถึงจะยังพอส่งได้ */
export const IMAGE_MAX = 4 * 1024 * 1024;

export const ALLOWED_TYPES = [
  "application/pdf",
  "image/png",
  "image/jpeg",
  "image/webp",
] as const;

export type AllowedType = (typeof ALLOWED_TYPES)[number];

export interface UploadCandidate {
  name: string;
  size: number;
  type: string;
}

export type UploadPlan =
  | { ok: false; error: string }
  | { ok: true; mode: "inline" | "storage"; totalBytes: number };

function mb(bytes: number): string {
  return (bytes / 1024 / 1024).toFixed(1);
}

export function isAllowedType(type: string): type is AllowedType {
  return (ALLOWED_TYPES as readonly string[]).includes(type);
}

/**
 * ตรวจไฟล์ทั้งชุดแล้วบอกว่าจะส่งทางไหน — รวบ error ทุกไฟล์ในข้อความเดียว
 * ไม่งั้นผู้ใช้ต้องแก้ทีละไฟล์แล้วกดใหม่ซ้ำ ๆ
 */
export function planUpload(files: UploadCandidate[]): UploadPlan {
  if (files.length === 0) return { ok: false, error: "เลือกไฟล์ก่อน" };

  const badType = files.filter((f) => !isAllowedType(f.type));
  if (badType.length) {
    return {
      ok: false,
      error: `รับเฉพาะ PDF หรือรูปภาพ — ${badType.map((f) => f.name).join(", ")}`,
    };
  }

  const empty = files.filter((f) => f.size === 0);
  if (empty.length) {
    return { ok: false, error: `ไฟล์ว่าง: ${empty.map((f) => f.name).join(", ")}` };
  }

  const bigImages = files.filter((f) => f.type !== "application/pdf" && f.size > IMAGE_MAX);
  if (bigImages.length) {
    return {
      ok: false,
      error: `รูปภาพใหญ่เกินไป (สูงสุด 4 MB ต่อรูป): ${bigImages
        .map((f) => `${f.name} (${mb(f.size)} MB)`)
        .join(", ")}`,
    };
  }

  const totalBytes = files.reduce((sum, f) => sum + f.size, 0);
  if (totalBytes > TOTAL_MAX) {
    return {
      ok: false,
      error: `ไฟล์รวมกันใหญ่เกินไป (${mb(totalBytes)} MB) — สูงสุด 32 MB ต่อครั้ง บีบอัดหรือแบ่งอัปหลายรอบ`,
    };
  }

  return { ok: true, mode: totalBytes > DIRECT_UPLOAD_MAX ? "storage" : "inline", totalBytes };
}

const EXTENSION_BY_TYPE: Record<AllowedType, string> = {
  "application/pdf": "pdf",
  "image/png": "png",
  "image/jpeg": "jpg",
  "image/webp": "webp",
};

/** นามสกุลที่ใช้ตั้งชื่อ object ใน storage — ฝั่ง server อ่านชนิดไฟล์กลับจากตรงนี้ */
export function extensionForType(type: string): string | null {
  return isAllowedType(type) ? EXTENSION_BY_TYPE[type] : null;
}

const TYPE_BY_EXTENSION: Record<string, AllowedType> = {
  pdf: "application/pdf",
  png: "image/png",
  jpg: "image/jpeg",
  jpeg: "image/jpeg",
  webp: "image/webp",
};

/** อ่านชนิดไฟล์กลับจาก path ใน storage (คู่กับ extensionForType) */
export function mediaTypeForPath(path: string): AllowedType | null {
  const ext = path.split(".").pop()?.toLowerCase() ?? "";
  return TYPE_BY_EXTENSION[ext] ?? null;
}
