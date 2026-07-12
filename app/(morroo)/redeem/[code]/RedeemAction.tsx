"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";

type Props = {
  code: string;
  rewardType: string;
};

const REWARD_LABEL: Record<string, string> = {
  monthly_1m: "สมาชิกรายเดือน 1 เดือน (มูลค่า ฿199)",
  bundle_10q: "Bundle 10 ข้อ (มูลค่า ฿299)",
};

export default function RedeemAction({ code, rewardType }: Props) {
  const router = useRouter();
  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string>("");

  async function handleRedeem() {
    setSubmitting(true);
    setErrorMsg("");
    try {
      const res = await fetch("/api/redeem", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        setErrorMsg(translateError(json.error));
        setSubmitting(false);
        return;
      }
      router.push("/dashboard?welcome=redeem");
    } catch (e) {
      setErrorMsg(e instanceof Error ? e.message : "ลองใหม่อีกครั้ง");
      setSubmitting(false);
    }
  }

  return (
    <>
      <p className="text-sm text-muted-foreground">รางวัลที่จะได้รับ</p>
      <p className="text-base font-medium text-teal-700">
        {REWARD_LABEL[rewardType] ?? rewardType}
      </p>
      <Button
        onClick={handleRedeem}
        disabled={submitting}
        className="w-full bg-teal-600 hover:bg-teal-700"
      >
        {submitting ? "กำลังดำเนินการ..." : "รับสิทธิ์ทันที"}
      </Button>
      {errorMsg && (
        <p className="text-xs text-red-600">{errorMsg}</p>
      )}
      <p className="text-xs text-muted-foreground">
        <Link href="/terms" className="underline">
          เงื่อนไขการใช้งาน
        </Link>
      </p>
    </>
  );
}

function translateError(code?: string): string {
  switch (code) {
    case "not_found":
      return "ไม่พบโค้ดนี้";
    case "expired":
      return "โค้ดหมดอายุแล้ว";
    case "already_redeemed":
      return "โค้ดนี้ถูกใช้ไปแล้ว";
    case "unauthorized":
      return "กรุณาเข้าสู่ระบบใหม่";
    default:
      return "เกิดข้อผิดพลาด ลองใหม่อีกครั้ง";
  }
}
