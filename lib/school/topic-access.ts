/**
 * สิทธิ์อ่านเนื้อหาของวิชาในโหมด School — ตรรกะล้วน ไม่แตะ DB (ทดสอบได้)
 *
 * วิชาหนึ่งเปิดได้ถ้ามีสิทธิ์ School ทั้งระบบ, ซื้อวิชานั้น (`topic:<id>`)
 * หรือซื้อทั้งชั้นปี (`year:<n>`) — ชุด scope เดียวกับที่หน้า guided ใช้
 *
 * ผู้ที่ยังไม่มีสิทธิ์ได้อ่าน "บทแรก" ของทุกวิชาเป็นตัวอย่าง ให้ตรงกับหน้า
 * flashcards / quiz ที่ให้ลองฟรีบางส่วนก่อนเจอ ItemUpsell
 */

/** จำนวนบทแรกของแต่ละวิชาที่เปิดให้อ่านฟรี */
export const FREE_SAMPLE_LESSONS = 1;

/** scope ที่ปลดล็อกวิชานี้ (ดู lib/items.ts: school_topic / school_year) */
export function schoolTopicScopes(topic: { id: string; year: number }): string[] {
  return [`topic:${topic.id}`, `year:${topic.year}`];
}

/**
 * บทนี้เป็นบทตัวอย่างฟรีไหม — ดูจากลำดับจริงของบทในวิชา (sort_order)
 * ไม่ใช่ค่า sort_order เอง ซึ่งอาจเว้นช่องหรือไม่เริ่มที่ 0
 */
export function isFreeSampleLesson(
  lessonId: string,
  orderedLessonIds: readonly string[]
): boolean {
  const idx = orderedLessonIds.indexOf(lessonId);
  return idx >= 0 && idx < FREE_SAMPLE_LESSONS;
}
