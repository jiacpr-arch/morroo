"use client";

import { useState } from "react";
import { Loader2, MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

/** ปุ่ม "ติดตั้ง rich menu" — POST /api/admin/line/rich-menu (ดู lib/line-menu.ts) */
export default function RichMenuInstallButton() {
  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);

  async function install() {
    if (!confirm("ติดตั้ง rich menu ใหม่ให้ผู้ใช้ LINE ทุกคน? (ต้องปิด rich menu ใน LINE OA Manager ก่อน)")) return;
    setBusy(true);
    setMsg(null);
    try {
      const res = await fetch("/api/admin/line/rich-menu", { method: "POST" });
      const body = (await res.json().catch(() => ({}))) as {
        error?: string;
        data?: { richMenuId: string; deleted: number };
      };
      setMsg(
        res.ok && body.data
          ? { ok: true, text: `ติดตั้งแล้ว (${body.data.richMenuId}) · ลบเมนูเก่า ${body.data.deleted} อัน` }
          : { ok: false, text: body.error ?? `ไม่สำเร็จ (${res.status})` }
      );
    } catch {
      setMsg({ ok: false, text: "เชื่อมต่อไม่ได้ ลองใหม่อีกครั้ง" });
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="flex flex-wrap items-center gap-3">
      <Button variant="outline" onClick={install} disabled={busy} className="gap-2">
        {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <MessageCircle className="h-4 w-4" />}
        ติดตั้ง LINE rich menu
      </Button>
      {msg && (
        <span className={`text-sm ${msg.ok ? "text-green-700" : "text-red-600"}`} aria-live="polite">
          {msg.text}
        </span>
      )}
    </div>
  );
}
