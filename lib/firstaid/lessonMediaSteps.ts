// สื่อเสริมที่แอดมินผูกกับเนื้อหา (ตาราง lesson_media เดิม)
//
// Phase 1 ตัดระบบ admin media override ออก — ฟังก์ชันทั้งหมดคง signature เดิมไว้
// เพื่อให้ LessonReader/ScenarioRunner/AlgorithmFlowchart ไม่ต้องแก้ แต่ทำงานเป็น
// passthrough: fetch คืน [] เสมอ และ merge คืน step คงที่ตามเดิม
// ระบบ override จาก Supabase จะกลับมาใน Phase 2/3 พร้อมหน้า admin

export type MediaRowData = {
  id: string | number;
  kind: "image" | "video";
  url?: string;
  youtube?: string;
  alt?: string;
  caption?: string;
  after_step?: number | null;
  step_id?: string | null;
  created_at?: string;
};

export type MediaStep = {
  type: "image" | "video";
  src?: string;
  youtube?: string;
  alt?: string;
  caption?: string;
};

// แปลงแถวจากตาราง lesson_media เป็น step ที่ LessonStep เรนเดอร์ได้
export function mediaRowToStep(row: MediaRowData): MediaStep {
  if (row.kind === "image") {
    return { type: "image", src: row.url, alt: row.alt || "", caption: row.caption || "" };
  }
  // video
  if (row.youtube) return { type: "video", youtube: row.youtube, caption: row.caption || "" };
  return { type: "video", src: row.url, caption: row.caption || "" };
}

// รวม step คงที่ (จาก lessons.js) กับสื่อที่ผูกไว้ใน DB
// Phase 1: rows ว่างเสมอ → คืน staticSteps เดิมไม่เปลี่ยน
export function mergeSteps<T>(staticSteps: T[], rows?: MediaRowData[] | null): T[] {
  if (!rows?.length) return staticSteps;
  // (โค้ด merge เดิมคงไว้เผื่อ Phase 2/3 เปิดระบบ override กลับมา)
  const byAfter = new Map<number, T[]>();
  const atEnd: T[] = [];
  for (const row of rows) {
    const step = mediaRowToStep(row) as unknown as T;
    const after = row.after_step;
    if (after == null || after >= staticSteps.length) {
      atEnd.push(step);
    } else {
      const k = Math.max(0, after);
      if (!byAfter.has(k)) byAfter.set(k, []);
      byAfter.get(k)!.push(step);
    }
  }
  const out: T[] = [];
  if (byAfter.has(0)) out.push(...byAfter.get(0)!);
  staticSteps.forEach((s, i) => {
    out.push(s);
    const stepNum = i + 1;
    if (byAfter.has(stepNum)) out.push(...byAfter.get(stepNum)!);
  });
  out.push(...atEnd);
  return out;
}

// ดึงสื่อที่ผูกกับเนื้อหาหนึ่ง (บทเรียน/สถานการณ์/ผัง)
// Phase 1: ไม่มีตาราง lesson_media ใน Supabase ใหม่ → คืน [] เสมอ
export async function fetchContentMedia(
  _contentType: "lesson" | "scenario" | "algorithm",
  _contentId: string | undefined | null,
): Promise<MediaRowData[]> {
  return [];
}

// ดึงสื่อของบทเรียน (คงพฤติกรรมเดิม — ใช้ใน LessonReader)
export function fetchLessonMedia(lessonId: string | undefined | null) {
  return fetchContentMedia("lesson", lessonId);
}

// จัดกลุ่มสื่อตาม step_id สำหรับเนื้อหาแบบ branching (สถานการณ์/ผัง)
// คืน Map<stepId, row[]> โดยคงลำดับ created_at เดิม
export function groupMediaByStep(rows?: MediaRowData[] | null) {
  const map = new Map<string, MediaRowData[]>();
  for (const row of rows || []) {
    if (!row.step_id) continue;
    if (!map.has(row.step_id)) map.set(row.step_id, []);
    map.get(row.step_id)!.push(row);
  }
  return map;
}
