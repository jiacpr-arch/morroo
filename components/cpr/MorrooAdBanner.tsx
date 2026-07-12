"use client";
import { useState } from "react";
import { B, MORROO_ADS } from "@/lib/cpr/config";

export default function MorrooAdBanner() {
  const [ad] = useState(() => MORROO_ADS[Math.floor(Math.random() * MORROO_ADS.length)]);
  const trackedUrl = `${ad.url}${ad.url.includes("?") ? "&" : "?"}utm_source=cpr.morroo.com&utm_medium=banner&utm_campaign=morroo_network&utm_content=${ad.id}`;
  return (
    <a href={trackedUrl} target="_blank" rel="noopener noreferrer" style={{ display: "block", textDecoration: "none", color: "inherit", marginBottom: 16 }}>
      <div style={{ background: B.white, borderRadius: 16, padding: 18, border: `1px solid ${ad.bg}30`, position: "relative", overflow: "hidden", boxShadow: "0 2px 8px rgba(0,0,0,.04)" }}>
        <div style={{ position: "absolute", top: 10, right: 12, fontSize: 9, color: B.dkGray, letterSpacing: 1, textTransform: "uppercase", opacity: 0.55 }}>โฆษณา</div>
        <div style={{ display: "flex", gap: 14, alignItems: "flex-start" }}>
          <div style={{ minWidth: 52, height: 52, borderRadius: 14, background: ad.bgLight, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 28 }}>{ad.emoji}</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 10, fontWeight: 700, color: ad.bg, letterSpacing: 0.5, textTransform: "uppercase", marginBottom: 2 }}>{ad.tag}</div>
            <div style={{ fontSize: 15, fontWeight: 700, color: B.black, marginBottom: 4, lineHeight: 1.3 }}>{ad.headline}</div>
            <div style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.5, marginBottom: 10 }}>{ad.desc}</div>
            <div style={{ display: "inline-flex", alignItems: "center", gap: 6, background: ad.bg, color: B.white, fontSize: 12, fontWeight: 700, padding: "7px 14px", borderRadius: 8 }}>{ad.cta} →</div>
          </div>
        </div>
        <div style={{ marginTop: 12, paddingTop: 8, borderTop: `1px solid ${B.gray}`, fontSize: 10, color: B.dkGray, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span>by <strong style={{ color: ad.bg }}>{ad.brand}</strong></span>
          <span style={{ opacity: 0.6 }}>morroo network</span>
        </div>
      </div>
    </a>
  );
}
