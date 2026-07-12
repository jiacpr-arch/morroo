"use client";
// ไอคอน SVG + โลโก้ JIA TRAINER CENTER — ย้ายมาจาก jia-online App.jsx ตรงๆ
import { useState, type ReactNode } from "react";
import { B, LOGO_SRC } from "@/lib/cpr/config";

export const icons: Record<string, (s: number, c: string) => ReactNode> = {
  play: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M8 5v14l11-7z"/></svg>,
  check: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="3"><polyline points="20 6 9 17 4 12"/></svg>,
  lock: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4" fill="none" stroke={c} strokeWidth="2"/></svg>,
  star: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>,
  cert: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><circle cx="12" cy="8" r="6"/><path d="M8.21 13.89L7 23l5-3 5 3-1.21-9.12"/></svg>,
  arrow: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>,
  back: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>,
  heart: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>,
  book: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg>,
  qr: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><rect x="2" y="2" width="8" height="8" rx="1"/><rect x="14" y="2" width="8" height="8" rx="1"/><rect x="2" y="14" width="8" height="8" rx="1"/><rect x="14" y="14" width="4" height="4" rx=".5"/></svg>,
  line: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 2C6.48 2 2 5.82 2 10.5c0 2.93 1.95 5.5 4.86 7.15-.19.67-.68 2.42-.78 2.79-.12.46.17.45.36.33.15-.1 2.38-1.62 3.35-2.28.7.1 1.43.16 2.21.16 5.52 0 10-3.82 10-8.5S17.52 2 12 2z"/></svg>,
  save: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>,
  replay: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg>,
  warn: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill={c}><path d="M12 2L1 21h22L12 2zm0 15a1.5 1.5 0 110 3 1.5 1.5 0 010-3zm-1-2h2V10h-2v5z"/></svg>,
  clock: (s, c) => <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>,
};

export const I = ({ name, size = 20, color = B.black }: { name: string; size?: number; color?: string }) =>
  icons[name]?.(size, color) || null;

// โลโก้ JIA TRAINER CENTER — แสดงรูปจาก public/cpr/logo.png ถ้าโหลดไม่ได้ fallback เป็นไอคอน cert เดิม
export const Logo = ({ size = 120 }: { size?: number }) => {
  const [err, setErr] = useState(false);
  if (err)
    return (
      <div style={{ margin: "0 auto", width: size * 0.5, height: size * 0.5, borderRadius: "50%", background: `${B.gold}15`, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <I name="cert" size={size * 0.3} color={B.gold} />
      </div>
    );
  // eslint-disable-next-line @next/next/no-img-element
  return <img src={LOGO_SRC} alt="JIA TRAINER CENTER" onError={() => setErr(true)} style={{ width: size, height: "auto", maxWidth: "100%", display: "block", margin: "0 auto" }} />;
};
