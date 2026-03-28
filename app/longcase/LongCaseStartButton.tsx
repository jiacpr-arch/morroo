"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Lock, Loader2, PlayCircle } from "lucide-react";

export default function LongCaseStartButton({ caseId, hasAccess }: {
  caseId: string;
  hasAccess: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  if (!hasAccess) {
    return (
      <a href="/pricing" className="flex w-full items-center justify-center rounded-md border border-amber-300 bg-white px-4 py-2 text-sm font-medium text-amber-600 hover:bg-amber-50 transition-colors">
        <Lock className="h-4 w-4 mr-2" />
        อัปเกรดเพื่อเข้าสอบ
      </a>
    );
  }

  async function handleStart() {
    setLoading(true);
    setError("");
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
          <><PlayCircle className="h-4 w-4 mr-2" /> เริ่มสอบ Long Case</>
        )}
      </Button>
      {error && <p className="text-xs text-red-500 mt-1.5">{error}</p>}
    </div>
  );
}
