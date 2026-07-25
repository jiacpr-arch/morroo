import { redirect } from "next/navigation";
import {
  getLongcaseGameCards,
  getMeqGameCards,
  getSimScenariosByCategory,
} from "@/lib/supabase/queries-sim";

export const dynamic = "force-dynamic";

/**
 * สุ่มเกมเคส 1 เคสแล้วพาไปเล่นทันที — ใช้จากปุ่ม "สุ่มเคส" ท้ายเกม/หน้าเริ่มเกม
 * เพื่อไม่ต้องกลับไปไล่หาเองในหน้ารวม
 *
 * ?exclude=<slug> กันสุ่มได้เคสเดิมซ้ำตอนกดจากในเกม
 */
export async function GET(request: Request) {
  const sp = new URL(request.url).searchParams;
  const exclude = sp.get("exclude");

  // คงพารามิเตอร์แคมเปญ + `start` ไว้ ไม่งั้นคนที่มาจากโฆษณาแล้วกดสุ่มเคสถัดไป
  // จะหลุด attribution และไม่ได้เข้าเกมทันทีเหมือนตอนแรก
  const carry = new URLSearchParams();
  for (const key of ["utm_source", "utm_medium", "utm_campaign", "utm_content", "start"]) {
    const value = sp.get(key);
    if (value) carry.set(key, value);
  }
  const qs = carry.toString();

  const [polished, longcase, meq] = await Promise.all([
    getSimScenariosByCategory("longcase"),
    getLongcaseGameCards(),
    getMeqGameCards(),
  ]);

  const slugs = [
    ...polished.map((s) => s.slug),
    ...longcase.map((c) => c.slug),
    ...meq.map((c) => c.slug),
  ].filter((s) => s !== exclude);

  // ไม่มีเคสอื่นให้สุ่ม → กลับหน้ารวมให้ผู้ใช้เลือกเอง
  if (slugs.length === 0) redirect(qs ? `/casegame?${qs}` : "/casegame");

  const slug = slugs[Math.floor(Math.random() * slugs.length)];
  redirect(qs ? `/sim/${slug}?${qs}` : `/sim/${slug}`);
}
