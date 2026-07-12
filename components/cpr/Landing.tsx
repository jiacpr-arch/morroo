"use client";
import { useEffect, useState } from "react";
import { B, COURSE, FREE_LAUNCH, PRICING, PROMO_ENABLED, SITE_URL } from "@/lib/cpr/config";
import { load, save } from "@/lib/cpr/storage";
import { css } from "./styles";
import { I } from "./icons";
import MorrooAdBanner from "./MorrooAdBanner";
import { JiaAedNewsSection, NewsSection } from "./News";
import type { Go, OpenBlog } from "./types";

export default function Landing({ go, enterCourse, openBlog }: { go: Go; enterCourse: () => void; openBlog: OpenBlog }) {
  const [a, setA] = useState(false);
  useEffect(() => {
    setTimeout(() => setA(true), 100);
  }, []);
  return (
    <div style={css.page}>
      <div style={{ background: `linear-gradient(135deg, ${B.red} 0%, ${B.dkRed} 100%)`, color: B.white, padding: "52px 24px 56px", textAlign: "center", position: "relative", overflow: "hidden" }}>
        <div style={{ position: "absolute", top: -60, right: -60, width: 240, height: 240, borderRadius: "50%", background: "rgba(255,255,255,.06)" }} />
        <div style={{ position: "relative", zIndex: 1, maxWidth: 480, margin: "0 auto", opacity: a ? 1 : 0, transform: a ? "translateY(0)" : "translateY(20px)", transition: "all .6s ease" }}>
          <div style={{ fontSize: 11, letterSpacing: 3, textTransform: "uppercase", opacity: 0.85, marginBottom: 8, fontWeight: 600 }}>JIA TRAINER CENTER</div>
          <h1 style={{ fontSize: 34, fontWeight: 800, margin: "0 0 4px", lineHeight: 1.2 }}>คอร์ส CPR & AED</h1>
          <h2 style={{ fontSize: 24, fontWeight: 300, margin: "0 0 16px", opacity: 0.95 }}>ออนไลน์</h2>
          {FREE_LAUNCH && <div style={{ display: "inline-block", background: B.gold, color: B.black, borderRadius: 8, padding: "6px 16px", fontSize: 13, fontWeight: 800, marginBottom: 12 }}>เรียนฟรี! เดือนแรกเท่านั้น</div>}
          {!FREE_LAUNCH && <div style={{ display: "inline-block", background: B.gold, color: B.black, borderRadius: 8, padding: "6px 16px", fontSize: 13, fontWeight: 800, marginBottom: 12 }}>บทที่ 1 เรียนฟรี!</div>}
          <p style={{ fontSize: 14, opacity: 0.9, lineHeight: 1.7, marginBottom: 28 }}>เรียนรู้การช่วยชีวิตขั้นพื้นฐาน มาตรฐาน 2025<br />ดูวิดีโอ • ทำแบบทดสอบ • รับใบประกาศนียบัตร</p>
          <div style={{ display: "inline-flex", alignItems: "center", gap: 14, background: "rgba(255,255,255,.15)", borderRadius: 16, padding: "14px 28px", marginBottom: 28 }}>
            {FREE_LAUNCH ? (<><span style={{ fontSize: 44, fontWeight: 800 }}>ฟรี!</span><div style={{ textAlign: "left", fontSize: 12 }}><div style={{ textDecoration: "line-through", opacity: 0.7 }}>ปกติ ฿100</div><div style={{ opacity: 0.85 }}>+ คูปองส่วนลด ฿100</div></div></>) : (<><span style={{ fontSize: 44, fontWeight: 800 }}>฿35</span><div style={{ textAlign: "left", fontSize: 12 }}><div style={{ opacity: 0.85 }}>ต่อหัวข้อ</div><div style={{ opacity: 0.7 }}>Full Course ฿149</div></div></>)}
          </div>
          <div><button onClick={enterCourse} style={{ ...css.btn(B.white, B.red), padding: "16px 52px", fontSize: 16 }}>{FREE_LAUNCH ? "เรียนฟรีเลย →" : "เรียนเลย →"}</button></div>
          {PROMO_ENABLED && !FREE_LAUNCH && !load("promo_redeemed", false) && (
            <div style={{ marginTop: 14 }}>
              <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ width: "100%", maxWidth: 360, background: B.gold, border: "none", borderRadius: 14, color: B.black, fontSize: 16, fontWeight: 800, padding: "15px 24px", cursor: "pointer", boxShadow: "0 6px 20px rgba(0,0,0,.28)", display: "inline-flex", alignItems: "center", justifyContent: "center", gap: 8 }}>🎟️ มีโค้ดแล้ว? กดใส่โค้ดเลย →</button>
              <div style={{ fontSize: 12, opacity: 0.9, marginTop: 8, fontWeight: 600 }}>ได้รับโค้ดจากเจ้าหน้าที่? ใส่ที่นี่เพื่อเรียนฟรี</div>
            </div>
          )}
        </div>
      </div>

      {/* Lead Capture CTA — แสดงเมื่อ promo เปิด หลังจบ free launch และยังไม่เคย claim โค้ด */}
      {PROMO_ENABLED && !FREE_LAUNCH && !load("promo_code", null) && (
        <div style={{ ...css.wrap, paddingTop: 24 }}>
          <button onClick={() => { save("claim_start_redeem", false); go("claim"); }} style={{ width: "100%", background: `linear-gradient(135deg, ${B.gold} 0%, #E08800 100%)`, color: B.white, border: "none", borderRadius: 16, padding: 18, cursor: "pointer", textAlign: "left", display: "flex", alignItems: "center", gap: 14, boxShadow: "0 4px 16px rgba(245,158,11,.25)" }}>
            <div style={{ width: 48, height: 48, borderRadius: 12, background: "rgba(255,255,255,.2)", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}><I name="star" size={26} color={B.white} /></div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 12, fontWeight: 700, opacity: 0.9, textTransform: "uppercase", letterSpacing: 1 }}>โปรพิเศษ</div>
              <div style={{ fontSize: 16, fontWeight: 800, marginTop: 2 }}>รับโค้ดเรียนฟรี 3 บทหลัก</div>
              <div style={{ fontSize: 12, opacity: 0.95, marginTop: 2 }}>แค่กรอกข้อมูล • มูลค่า ฿{PRICING.bundle3}</div>
            </div>
            <I name="arrow" size={18} color={B.white} />
          </button>
        </div>
      )}

      {/* Pricing Section */}
      {!FREE_LAUNCH && (
        <div style={{ ...css.wrap, paddingTop: 36, paddingBottom: 24 }}>
          <h3 style={{ fontSize: 20, fontWeight: 700, marginBottom: 20, textAlign: "center" }}>เลือกแพ็กเกจ</h3>
          {[
            { label: "1 หัวข้อ", price: "฿35", desc: "เลือกหัวข้อที่สนใจ", bg: B.white, border: B.ltGray, badge: null as string | null },
            { label: "3 หัวข้อ", price: "฿100", desc: "เฉลี่ย ฿33/หัวข้อ", bg: B.white, border: B.ltGray, badge: "ประหยัด 5%" },
            { label: "Full Course", price: "฿149", desc: "6 หัวข้อ + Final Exam + Certificate + คูปอง On-site ฿100", bg: `${B.red}06`, border: B.red, badge: "แนะนำ" },
          ].map((p, i) => (
            <div key={i} style={{ background: p.bg, borderRadius: 14, padding: 16, marginBottom: 12, border: `2px solid ${p.border}`, position: "relative" }}>
              {p.badge && <div style={{ position: "absolute", top: -10, right: 12, background: p.badge === "แนะนำ" ? B.red : B.gold, color: B.white, fontSize: 11, fontWeight: 700, padding: "3px 10px", borderRadius: 8 }}>{p.badge}</div>}
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <div><div style={{ fontWeight: 700, fontSize: 15 }}>{p.label}</div><div style={{ fontSize: 12, color: B.dkGray, marginTop: 2 }}>{p.desc}</div></div>
                <div style={{ fontSize: 22, fontWeight: 800, color: B.red }}>{p.price}</div>
              </div>
            </div>
          ))}
          <button onClick={() => go("store")} style={{ ...css.btn(B.red, B.white, true), marginTop: 4 }}>เลือกซื้อหัวข้อ →</button>
        </div>
      )}

      <div style={{ ...css.wrap, paddingTop: FREE_LAUNCH ? 36 : 0, paddingBottom: 24 }}>
        <h3 style={{ fontSize: 20, fontWeight: 700, marginBottom: 20, textAlign: "center" }}>เรียนอะไรบ้าง?</h3>
        {COURSE.modules.slice(0, 6).map((m, i) => (
          <div key={i} style={{ display: "flex", gap: 14, alignItems: "flex-start", marginBottom: 12, background: B.white, borderRadius: 14, padding: "14px 16px" }}>
            <div style={{ minWidth: 38, height: 38, borderRadius: 10, background: `${B.red}12`, display: "flex", alignItems: "center", justifyContent: "center", color: B.red, fontWeight: 800, fontSize: 15 }}>{String(i + 1).padStart(2, "0")}</div>
            <div>
              <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 3 }}>{m.short} {i === 0 && !FREE_LAUNCH ? <span style={{ background: B.green, color: B.white, fontSize: 10, padding: "2px 6px", borderRadius: 4, marginLeft: 6 }}>ฟรี</span> : null}</div>
              <div style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.5 }}>{m.desc}</div>
            </div>
          </div>
        ))}
        <div style={{ background: `${B.gold}18`, borderRadius: 14, padding: 16, textAlign: "center", marginTop: 4 }}><I name="cert" size={26} color={B.gold} /><div style={{ fontWeight: 600, fontSize: 14, marginTop: 6 }}>+ แบบทดสอบสุดท้าย & ใบประกาศนียบัตร</div></div>
      </div>
      <NewsSection openBlog={openBlog} goAll={() => go("blog")} title="ข่าวสาร & บทความ" subtitle="อัปเดตใหม่ทุกวัน — เคสจริง บทความ และทิปส์ช่วยชีวิต" />
      <JiaAedNewsSection />
      <div style={{ ...css.wrap, paddingBottom: 24 }}>
        <div style={{ background: B.white, borderRadius: 16, padding: 24, border: `1px solid ${B.red}12` }}>
          <div style={{ textAlign: "center", marginBottom: 16 }}><h3 style={{ fontSize: 17, fontWeight: 700, margin: 0 }}>ทำไมต้องเรียน CPR?</h3><p style={{ fontSize: 12, color: B.dkGray, marginTop: 4 }}>ข้อมูลจากงานวิจัย</p></div>
          {[
            { n: "10%", c: B.red, t: "ทุก 1 นาทีที่ไม่ได้ทำ CPR\nโอกาสรอดชีวิตลดลง 10%" },
            { n: "3-6 เดือน", c: B.gold, t: "ทักษะ CPR เสื่อมลง\nภายใน 3-6 เดือนหลังอบรม" },
            { n: "58%", c: B.green, t: "ผู้ทบทวนทุกเดือนทำได้ \"ดีเยี่ยม\"\nเทียบกับ 15% ที่ทบทวนปีละครั้ง" },
          ].map((r, i) => (
            <div key={i} style={{ background: `${r.c}08`, borderRadius: 12, padding: 14, marginBottom: 14, borderLeft: `4px solid ${r.c}` }}>
              <div style={{ fontSize: 28, fontWeight: 800, color: r.c }}>{r.n}</div>
              <div style={{ fontSize: 13, marginTop: 4, lineHeight: 1.5, whiteSpace: "pre-line" }}>{r.t}</div>
            </div>
          ))}
        </div>
      </div>
      <div style={{ ...css.wrap, paddingBottom: 16 }}><MorrooAdBanner /></div>
      <div style={{ ...css.wrap, paddingBottom: 100 }}>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
          {[
            { icon: "play", l: "6 วิดีโอ", s: "เรียนได้ทุกที่" },
            { icon: "book", l: "Quiz ทุกบท", s: "ทดสอบความเข้าใจ" },
            { icon: "cert", l: "ใบประกาศฯ", s: "มาตรฐาน 2025" },
            { icon: "heart", l: "คูปอง ฿100", s: "ใช้ตอนเรียน on-site" },
          ].map((f, i) => (
            <div key={i} style={{ background: B.white, borderRadius: 14, padding: 16, textAlign: "center" }}>
              <I name={f.icon} size={22} color={B.red} />
              <div style={{ fontWeight: 600, fontSize: 13, marginTop: 6 }}>{f.l}</div>
              <div style={{ fontSize: 11, color: B.dkGray, marginTop: 2 }}>{f.s}</div>
            </div>
          ))}
        </div>
      </div>
      <div style={{ position: "fixed", bottom: 0, left: 0, right: 0, background: B.white, padding: "14px 20px", boxShadow: "0 -4px 24px rgba(0,0,0,.08)", zIndex: 100 }}>
        <div style={{ maxWidth: 480, margin: "0 auto", display: "flex", alignItems: "center", justifyContent: "space-between", gap: 10 }}>
          <div><div style={{ fontSize: 11, color: B.dkGray }}>{FREE_LAUNCH ? "ช่วง Launch พิเศษ" : "เริ่มต้น"}</div><div style={{ fontSize: 22, fontWeight: 800, color: B.red }}>{FREE_LAUNCH ? "ฟรี!" : "฿35/หัวข้อ"}</div></div>
          <div style={{ display: "flex", gap: 8 }}>
            <button onClick={() => { const txt = "เรียน CPR & AED ออนไลน์! ได้ใบ Certificate + คูปองส่วนลด"; if (navigator.share) navigator.share({ title: "JIA CPR Online", text: txt, url: SITE_URL }); else window.open("https://social-plugins.line.me/lineit/share?url=" + encodeURIComponent(SITE_URL) + "&text=" + encodeURIComponent(txt), "_blank"); }} style={{ ...css.btn(B.white, B.red), padding: "10px 14px", border: `1px solid ${B.red}30`, fontSize: 13 }}>แชร์</button>
            <button onClick={enterCourse} style={css.btn(B.red, B.white)}>{FREE_LAUNCH ? "เรียนฟรี" : "เรียนเลย"}</button>
          </div>
        </div>
      </div>
    </div>
  );
}
