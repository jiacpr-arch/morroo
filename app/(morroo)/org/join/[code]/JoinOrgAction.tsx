"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";

export default function JoinOrgAction({ code }: { code: string }) {
  const router = useRouter();
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<{ ok: boolean; text: string } | null>(null);

  async function handleJoin() {
    setSubmitting(true);
    setMessage(null);
    try {
      const res = await fetch("/api/org/join", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      });
      const json = (await res.json()) as { result?: string; message?: string; error?: string };
      if (json.result === "joined" || json.result === "already_member") {
        setMessage({ ok: true, text: json.message ?? "เข้าร่วมกลุ่มเรียบร้อย" });
        router.push("/dashboard?welcome=org");
        return;
      }
      setMessage({ ok: false, text: json.message ?? json.error ?? "เข้าร่วมกลุ่มไม่สำเร็จ" });
    } catch {
      setMessage({ ok: false, text: "เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่" });
    }
    setSubmitting(false);
  }

  return (
    <>
      <Button onClick={handleJoin} disabled={submitting} className="w-full">
        {submitting ? "กำลังเข้าร่วม..." : "เข้าร่วมกลุ่ม"}
      </Button>
      {message && (
        <p className={`text-sm ${message.ok ? "text-brand" : "text-red-600"}`}>{message.text}</p>
      )}
    </>
  );
}
