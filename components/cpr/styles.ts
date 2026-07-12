// inline style objects เดิมจาก jia-online — คงไว้ก่อนใน Phase 1 (แปลงเป็น Tailwind ใน Phase 2)
import type { CSSProperties } from "react";
import { B } from "@/lib/cpr/config";

export const css = {
  btn: (bg: string, color: string, full?: boolean): CSSProperties => ({
    background: bg,
    color,
    border: "none",
    borderRadius: 12,
    padding: "14px 32px",
    fontSize: 15,
    fontWeight: 700,
    cursor: "pointer",
    transition: "all .2s",
    ...(full ? { width: "100%", display: "block" } : {}),
  }),
  card: { background: B.white, borderRadius: 16, padding: 24, boxShadow: "0 2px 12px rgba(0,0,0,.06)" } as CSSProperties,
  header: (bg: string): CSSProperties => ({ background: bg, color: B.white, padding: "20px 24px", display: "flex", alignItems: "center", gap: 12 }),
  page: { minHeight: "100vh", background: B.cream } as CSSProperties,
  wrap: { maxWidth: 480, margin: "0 auto", padding: "0 20px" } as CSSProperties,
};
