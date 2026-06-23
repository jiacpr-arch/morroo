"use client";

import { X } from "lucide-react";
import { useAiHealth } from "./AiHealthProvider";

/**
 * Site-wide banner shown when the AI features are failing repeatedly. Driven by
 * AiHealthProvider; renders nothing in the healthy/dismissed state.
 */
export default function AiStatusBanner() {
  const { degraded, dismiss } = useAiHealth();
  if (!degraded) return null;
  return (
    <div className="sticky top-0 z-[60] flex items-center justify-center gap-2 bg-amber-500 px-4 py-2 text-center text-sm text-white">
      <span>
        ⚠️ ระบบ AI กำลังหนาแน่นชั่วคราว บางคำตอบอาจช้าหรือใช้ไม่ได้ — กำลังกู้คืน
        ลองใหม่อีกครั้งในสักครู่นะคะ
      </span>
      <button
        onClick={dismiss}
        aria-label="ปิดแจ้งเตือน"
        className="ml-2 shrink-0 rounded p-0.5 hover:bg-white/20"
      >
        <X className="h-4 w-4" />
      </button>
    </div>
  );
}
