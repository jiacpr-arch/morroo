"use client";
import { useState } from "react";
import { B, COURSE } from "@/lib/cpr/config";
import { load, save, type CprProgress, type CprUser } from "@/lib/cpr/storage";
import { genCoupon, genLinkCode, supaRest } from "@/lib/cpr/api";
import { safeTrack } from "@/lib/cpr/analytics";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

export default function Register({ go, setUser }: { go: Go; setUser: (u: CprUser) => void }) {
  const [f, setF] = useState({ name: "", phone: "", email: "" });
  const [err, setErr] = useState<Record<string, string | undefined>>({});
  const [pdpa, setPdpa] = useState(false);
  const submit = () => {
    const e: Record<string, string> = {};
    if (!f.name.trim()) e.name = "กรุณากรอกชื่อ-นามสกุล";
    if (!f.phone.trim() || f.phone.replace(/\D/g, "").length < 9) e.phone = "กรุณากรอกเบอร์โทรที่ถูกต้อง";
    if (!pdpa) e.pdpa = "กรุณายินยอม PDPA ก่อนลงทะเบียน";
    if (Object.keys(e).length) return setErr(e);
    const cleanPhone = f.phone.replace(/\D/g, "");
    const userData: CprUser = { name: f.name.trim(), phone: cleanPhone, email: f.email };
    setUser(userData);
    save("user", userData);
    const custId = "cust_" + Date.now() + "_" + Math.random().toString(36).slice(2, 6);
    const linkCode = genLinkCode();
    save("line_link_code", linkCode);
    const finalProgress = load<CprProgress>("progress", { done: [], scores: {} });
    const finalModId = COURSE.modules[COURSE.modules.length - 1].id;
    const completed = finalProgress.done.includes(finalModId);
    const coupon = load<string | null>("coupon", null) || (completed ? (() => { const c = genCoupon(); save("coupon", c); return c; })() : null);
    const finalScore = finalProgress.scores[finalModId] || null;
    supaRest("customers", "POST", { id: custId, name: userData.name, tel: cleanPhone, email: f.email || "", source: "online-course", line_link_code: linkCode });
    if (completed) {
      const renew = new Date();
      renew.setMonth(renew.getMonth() + 6);
      supaRest("online_students", "POST", { customer_id: custId, name: userData.name, phone: cleanPhone, email: f.email || "", status: "จบคอร์ส ✅", completed_at: new Date().toISOString(), final_score: finalScore, coupon_code: coupon, renew_date: renew.toISOString().split("T")[0] });
      supaRest("sales_tracking", "POST", { name: userData.name, phone: cleanPhone, completed_date: new Date().toISOString(), score: finalScore, coupon_code: coupon, follow_status: "ยังไม่ติดต่อ" });
      if (coupon) supaRest("promo_codes", "POST", { code: coupon, type: "online", discount: 100, staff_name: "system" });
    } else {
      supaRest("online_students", "POST", { customer_id: custId, name: userData.name, phone: cleanPhone, email: f.email || "", status: "กำลังเรียน" });
    }
    save("enrolled", true);
    safeTrack("register_complete", { has_email: !!f.email, completed });
    go("certificate");
  };
  const field = (key: "name" | "phone" | "email", label: string, ph: string, type = "text") => (
    <div style={{ marginBottom: 16 }}>
      <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>{label}</label>
      <input type={type} placeholder={ph} value={f[key]} onChange={(e) => { setF({ ...f, [key]: e.target.value }); setErr({ ...err, [key]: undefined }); }} style={{ width: "100%", padding: "12px 16px", border: `2px solid ${err[key] ? B.red : B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
      {err[key] && <div style={{ color: B.red, fontSize: 12, marginTop: 4 }}>{err[key]}</div>}
    </div>
  );
  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={() => go("course")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 16, fontWeight: 700 }}>ลงทะเบียนรับใบเกียรติบัตร</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
        <div style={css.card}>
          <h3 style={{ fontSize: 17, fontWeight: 700, marginTop: 0, marginBottom: 6 }}>ยินดีด้วย! คุณผ่านข้อสอบแล้ว</h3>
          <p style={{ fontSize: 13, color: B.dkGray, margin: "0 0 18px", lineHeight: 1.6 }}>กรอกข้อมูลด้านล่างเพื่อออกใบประกาศนียบัตรในชื่อของคุณ</p>
          {field("name", "ชื่อ-นามสกุล *", "เช่น สมชาย ใจดี")}
          {field("phone", "เบอร์โทรศัพท์ *", "เช่น 081-234-5678", "tel")}
          {field("email", "อีเมล (ไม่บังคับ)", "เช่น name@email.com", "email")}
          <div style={{ marginTop: 8 }}>
            <label style={{ display: "flex", gap: 10, alignItems: "flex-start", cursor: "pointer" }}>
              <input type="checkbox" checked={pdpa} onChange={(e) => { setPdpa(e.target.checked); setErr({ ...err, pdpa: undefined }); }} style={{ marginTop: 3, width: 18, height: 18 }} />
              <span style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.5 }}>ข้าพเจ้ายินยอมให้ JIA TRAINER CENTER เก็บรวบรวมและใช้ข้อมูลส่วนบุคคล (ชื่อ, เบอร์โทร, อีเมล) เพื่อจัดการหลักสูตรออนไลน์ การออกใบประกาศนียบัตร และการแจ้งข้อมูลหลักสูตร ข้อมูลจะไม่ถูกเปิดเผยต่อบุคคลภายนอก</span>
            </label>
            {err.pdpa && <div style={{ color: B.red, fontSize: 12, marginTop: 4 }}>{err.pdpa}</div>}
          </div>
        </div>
        <button onClick={submit} style={{ ...css.btn(B.red, B.white, true), marginTop: 20 }}>ลงทะเบียนรับใบประกาศนียบัตร →</button>
      </div>
    </div>
  );
}
