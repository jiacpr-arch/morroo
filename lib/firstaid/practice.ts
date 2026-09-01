import { scenarios } from "@/lib/firstaid/content/scenarios";
import { chapters } from "@/lib/firstaid/content/lessons";

type Scenario = { id: string; chapter: number };
type Chapter = { id: number; title: string; color?: string };

// เกณฑ์ปลดล็อก Post-test ภาคปฏิบัติ: ต้อง "ผ่าน" ฉากฝึกอย่างน้อย 1 ฉากในทุกบทที่มีฉากฝึก
// (ไม่ต้องผ่านครบทั้ง 40 ฉาก — แค่พิสูจน์ว่าได้ฝึกครอบคลุมทุกบท)
export const chapterIdsWithScenarios: number[] = (chapters as Chapter[])
  .map((c) => c.id)
  .filter((id) => (scenarios as Scenario[]).some((s) => s.chapter === id));

// สถานะฝึกรายบท: [{ chapter, title, color, done }]
export function practiceChapterStatus(passedScenarioIds: Set<string>) {
  return (chapters as Chapter[])
    .filter((c) => chapterIdsWithScenarios.includes(c.id))
    .map((c) => ({
      chapter: c.id,
      title: c.title,
      color: c.color,
      done: (scenarios as Scenario[]).some(
        (s) => s.chapter === c.id && passedScenarioIds.has(s.id),
      ),
    }));
}

// ผ่านเกณฑ์ฝึกครบทุกบทหรือยัง
export function isPracticeDone(passedScenarioIds: Set<string>) {
  return chapterIdsWithScenarios.every((id) =>
    (scenarios as Scenario[]).some((s) => s.chapter === id && passedScenarioIds.has(s.id)),
  );
}

// จำนวนบทที่ยังฝึกไม่ผ่าน — ใช้โชว์ข้อความ "เหลืออีก N บท"
export function practiceChaptersRemaining(passedScenarioIds: Set<string>) {
  return practiceChapterStatus(passedScenarioIds).filter((c) => !c.done).length;
}
