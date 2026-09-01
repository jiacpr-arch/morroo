"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { claimPendingLocalRuns } from "@/lib/sim/record";

/**
 * ยกเคสที่เล่นไว้ตอนยังไม่ล็อกอินเข้าบัญชี ทันทีที่ผู้ใช้ที่ล็อกอินแล้วเปิดหน้ารวมเกม
 *
 * ทำไมต้องมีนอกเหนือจากตอนบันทึกผล: คนที่เล่นทิ้งไว้แล้วปิดเบราว์เซอร์ กลับมา
 * ล็อกอินด้วย LINE จากหน้าไหนก็ได้ อาจไม่ได้เปิดหน้าเล่นเกมทันที ถ้ารอให้เล่นจบ
 * อีกรอบถึงจะยก ประวัติจะค้างอยู่ในเครื่องโดยที่เขาไม่รู้ว่ามันยังไม่เข้าบัญชี
 *
 * ไม่เรนเดอร์อะไร — refresh หน้าเมื่อยกสำเร็จ เพื่อให้การ์ดตัวละครที่ server
 * เรนเดอร์ไว้อัปเดตตามทันที
 */
export default function ClaimLocalRuns() {
  const router = useRouter();

  useEffect(() => {
    let cancelled = false;
    void claimPendingLocalRuns().then((claimed) => {
      if (claimed > 0 && !cancelled) router.refresh();
    });
    return () => { cancelled = true; };
  }, [router]);

  return null;
}
