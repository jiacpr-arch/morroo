/**
 * เรียงวิชาตามรหัสวิชาจากน้อยไปมาก (client-safe)
 *
 * รหัสวิชาคือสิ่งที่นักเรียนใช้เรียกวิชาจริง ๆ (FMMD 1101, พศพบ 1101) ลิสต์วิชา
 * ทุกที่จึงเรียงตามรหัส ไม่ใช่ลำดับในเล่มหลักสูตร (sort_order)
 *
 * - เทียบแบบ numeric เพื่อให้ "FMMD 99" มาก่อน "FMMD 100" (string sort ล้วนจะสลับกัน)
 * - วิชาที่ยังไม่ผูกรหัส (code = null) ไปต่อท้าย และคงลำดับเดิมไว้ (sort เสถียร)
 */

export interface TopicCodeOrdered {
  code?: string | null;
}

const collator = new Intl.Collator("en", { numeric: true, sensitivity: "base" });

export function compareTopicByCode(
  a: TopicCodeOrdered,
  b: TopicCodeOrdered,
): number {
  const ac = a.code?.trim() ?? "";
  const bc = b.code?.trim() ?? "";
  if (!ac && !bc) return 0;
  if (!ac) return 1;
  if (!bc) return -1;
  return collator.compare(ac, bc);
}

/** คืน array ใหม่ที่เรียงตามรหัสวิชา — ไม่แก้ array เดิม */
export function sortTopicsByCode<T extends TopicCodeOrdered>(topics: T[]): T[] {
  return [...topics].sort(compareTopicByCode);
}
