"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";
import { Gamepad2, Loader2, Lock, PlayCircle } from "lucide-react";

/**
 * สิทธิ์เข้าเล่นของผู้ใช้คนนี้ — ต้องสะท้อนกติกาจริงใน `app/api/longcase/start`
 * ซึ่งให้ผู้ใช้ที่ล็อกอินแล้วแต่ไม่มีแพ็กเกจ **เล่นฟรีได้ 1 เคส/เดือน**
 *
 * เดิมปุ่มนี้รับแค่ `hasAccess` (= มีแพ็กเกจที่ยังไม่หมดอายุ) แล้วโชว์กุญแจกับ
 * ทุกคนที่เหลือ — คนที่ล็อกอินแล้วและยังไม่ได้ใช้เคสฟรีของเดือนนั้นจึงโดนกันไว้
 * ทั้งที่ API ยอมให้เล่น และแบนเนอร์บนหน้าเดียวกันก็โฆษณาว่า "ฟรี 1 เคส/เดือน"
 */
export type LongCaseEntitlement =
  /** มีแพ็กเกจ เล่นได้ไม่จำกัด */
  | "subscriber"
  /** ล็อกอินแล้ว ยังไม่ได้ใช้เคสฟรีของเดือนนี้ */
  | "free_case_available"
  /** ล็อกอินแล้ว ใช้เคสฟรีของเดือนนี้ไปแล้ว */
  | "free_case_used"
  /** ยังไม่ได้ล็อกอิน */
  | "guest"
  /** ไม่มีทางลองฟรีในหมวดนี้เลย ต้องมีแพ็กเกจเท่านั้น (เช่น Board Oral) */
  | "locked";

export default function LongCaseStartButton({
  caseId,
  entitlement,
  gameSlug,
}: {
  caseId: string;
  entitlement: LongCaseEntitlement;
  /** เวอร์ชันเกมของเคสนี้ ถ้ามี — ทางลองฟรีที่ไม่ต้องล็อกอินเลย */
  gameSlug?: string;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // คนที่ยังไม่ล็อกอิน: ยื่นของที่เล่นได้ทันทีให้ก่อน อย่าเพิ่งไล่ไปสมัคร
  // เวอร์ชันเกมคือเคสเดียวกันเล่าด้วยกลไกเกม เล่นจบได้ใน ~5 นาที ไม่ต้องมีบัญชี
  if (entitlement === "guest") {
    if (gameSlug) {
      return (
        <Link
          href={`/sim/${gameSlug}`}
          onClick={() => track("longcase_guest_try_game", { caseId })}
          className="flex w-full items-center justify-center rounded-md bg-teal-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-teal-700"
        >
          <Gamepad2 className="mr-2 h-4 w-4" />
          ลองเคสนี้ฟรี — เวอร์ชันเกม
        </Link>
      );
    }
    return (
      <Link
        href="/login"
        onClick={() => track("longcase_guest_login_prompt", { caseId })}
        className="flex w-full items-center justify-center rounded-md border border-amber-300 bg-white px-4 py-2 text-sm font-medium text-amber-600 transition-colors hover:bg-amber-50"
      >
        เข้าสู่ระบบเพื่อเล่นฟรี 1 เคส
      </Link>
    );
  }

  if (entitlement === "locked") {
    return (
      <a
        href="/pricing"
        className="flex w-full items-center justify-center rounded-md border border-amber-300 bg-white px-4 py-2 text-sm font-medium text-amber-600 transition-colors hover:bg-amber-50"
      >
        <Lock className="mr-2 h-4 w-4" />
        อัปเกรดเพื่อเข้าสอบ
      </a>
    );
  }

  if (entitlement === "free_case_used") {
    return (
      <a
        href="/pricing"
        className="flex w-full items-center justify-center rounded-md border border-amber-300 bg-white px-4 py-2 text-sm font-medium text-amber-600 transition-colors hover:bg-amber-50"
      >
        <Lock className="mr-2 h-4 w-4" />
        ใช้เคสฟรีของเดือนนี้แล้ว — อัปเกรด
      </a>
    );
  }

  async function handleStart() {
    setLoading(true);
    setError("");
    track("longcase_start", { caseId });
    try {
      const res = await fetch("/api/longcase/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ caseId }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data.error || "ไม่สามารถเริ่มได้");
        return;
      }
      router.push(`/longcase/session?id=${data.sessionId}`);
    } catch {
      setError("เกิดข้อผิดพลาด กรุณาลองใหม่");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      <Button
        onClick={handleStart}
        disabled={loading}
        className="w-full bg-amber-500 hover:bg-amber-600 text-white"
      >
        {loading ? (
          <><Loader2 className="h-4 w-4 mr-2 animate-spin" /> กำลังเตรียมเคส...</>
        ) : (
          <>
            <PlayCircle className="h-4 w-4 mr-2" />
            {entitlement === "free_case_available" ? "เริ่มเคสฟรีของเดือนนี้" : "เริ่มสอบ Long Case"}
          </>
        )}
      </Button>
      {error && <p className="text-xs text-red-500 mt-1.5">{error}</p>}
    </div>
  );
}
