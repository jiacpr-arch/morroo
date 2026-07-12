"use client";
// แจ้งเตือนเมื่อเปิดใน in-app browser (Facebook/Instagram) — LINE deep link ทำงานไม่ดีในนั้น
import { useEffect, useState } from "react";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";

function detectInApp(): string | null {
  if (typeof navigator === "undefined") return null;
  const ua = navigator.userAgent || "";
  if (/FBAN|FBAV|FB_IAB/.test(ua)) return "Facebook";
  if (/Instagram/.test(ua)) return "Instagram";
  return null;
}

export default function InAppNotice() {
  // เริ่มเป็น null เสมอ (ตรงกับ SSR) แล้วค่อย detect ใน effect — กัน hydration mismatch
  const [src, setSrc] = useState<string | null>(null);
  const [hide, setHide] = useState(false);
  const [copied, setCopied] = useState(false);
  useEffect(() => {
    const s = detectInApp();
    setSrc(s);
    if (s) {
      safeTrack("inapp_browser_detected", { source: s });
      phCapture("inapp_browser_detected", { source: s });
    }
  }, []);
  if (!src || hide) return null;
  const copy = async () => {
    try {
      await navigator.clipboard.writeText(window.location.href);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (_e) {}
  };
  return (
    <div style={{ background: "#FEF3C7", borderBottom: "1px solid #FDE68A", color: "#92400E", padding: "10px 14px", display: "flex", gap: 10, alignItems: "flex-start", fontSize: 13, lineHeight: 1.4 }}>
      <div style={{ flex: 1, minWidth: 0 }}>
        <b>เปิดในเบราว์เซอร์จริงเพื่อแอด LINE ได้ลื่นกว่า</b>
        <div style={{ marginTop: 2 }}>คุณกำลังเปิดผ่านแอป {src} — กดเมนู ⋯ มุมขวาบนแล้วเลือก “เปิดในเบราว์เซอร์” (Chrome/Safari)</div>
        <button onClick={copy} style={{ marginTop: 8, padding: "6px 10px", borderRadius: 8, border: "1px solid #D97706", background: "#fff", color: "#92400E", fontWeight: 700, fontSize: 12, cursor: "pointer" }}>{copied ? "คัดลอกลิงก์แล้ว" : "คัดลอกลิงก์"}</button>
      </div>
      <button onClick={() => setHide(true)} aria-label="ปิด" style={{ background: "none", border: "none", color: "#92400E", cursor: "pointer", fontSize: 18, lineHeight: 1, flexShrink: 0 }}>×</button>
    </div>
  );
}
