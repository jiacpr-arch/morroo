import { redirect } from "next/navigation";
import { scenarios } from "@/lib/firstaid/content/scenarios";

export const dynamic = "force-dynamic";

/**
 * พาเข้าฉากจำลองแบบสุ่มทันที — ใช้จาก Games Hub (game.morroo.com) ให้คนกดการ์ด
 * แล้วเข้าเล่นเลย ไม่ต้องมาไล่เลือกที่หน้า /simulation ก่อน (ลอกแพทเทิร์นเดียวกับ
 * app/(morroo)/casegame/random/route.ts)
 *
 * คงพารามิเตอร์แคมเปญไว้เผื่อ attribution จากโฆษณา
 */
export async function GET(request: Request) {
  const sp = new URL(request.url).searchParams;
  const carry = new URLSearchParams();
  for (const key of ["utm_source", "utm_medium", "utm_campaign", "utm_content"]) {
    const value = sp.get(key);
    if (value) carry.set(key, value);
  }
  const qs = carry.toString();

  const list = scenarios as Array<{ id: string }>;
  const pick = list[Math.floor(Math.random() * list.length)];
  redirect(qs ? `/simulation/${pick.id}?${qs}` : `/simulation/${pick.id}`);
}
