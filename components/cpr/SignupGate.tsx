"use client";
// จอเดียว: กรอกชื่อ+เบอร์ + ยินยอม PDPA → ปลดเนื้อหา (flow line_oa_only ตามเวอร์ชันปัจจุบันของ jia-online)
import { useEffect, useState } from "react";
import { B } from "@/lib/cpr/config";
import { getGateVariant, getUTM, load, save, type CprUser } from "@/lib/cpr/storage";
import { getLinkCode, supaRest } from "@/lib/cpr/api";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

export default function SignupGate({ go, setUser }: { go: Go; setUser: (u: CprUser) => void }) {
  const [name, setName] = useState(() => load<CprUser | null>("user", null)?.name || "");
  const [phone, setPhone] = useState(() => load<CprUser | null>("user", null)?.phone || "");
  const [pdpa, setPdpa] = useState(false);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  useEffect(() => {
    safeTrack("signup_gate_view", { variant: getGateVariant() });
    phCapture("gate_shown", { variant: getGateVariant() });
  }, []);

  const submit = () => {
    if (!name.trim()) { setErr("กรุณากรอกชื่อ-นามสกุล"); return; }
    if (phone.replace(/\D/g, "").length < 9) { setErr("กรุณากรอกเบอร์โทรที่ถูกต้อง"); return; }
    if (!pdpa) { setErr("กรุณายินยอม PDPA ก่อนสมัคร"); return; }
    setErr("");
    setBusy(true);
    const cleanPhone = phone.replace(/\D/g, "");
    const userData: CprUser = { name: name.trim(), phone: cleanPhone };
    setUser(userData);
    save("signed_up", true);
    save("enrolled", true);
    const custId = "cust_" + Date.now() + "_" + Math.random().toString(36).slice(2, 6);
    const linkCode = getLinkCode();
    supaRest("customers", "POST", { id: custId, name: userData.name, tel: cleanPhone, source: "online-course", line_link_code: linkCode, pdpa_consent_at: new Date().toISOString(), signup_at: new Date().toISOString(), gate_variant: getGateVariant(), landing_url: load("landing_url", null), ...getUTM() });
    supaRest("online_students", "POST", { customer_id: custId, name: userData.name, phone: cleanPhone, status: "กำลังเรียน" });
    safeTrack("signup_complete", { provider: "line_oa_only" });
    phCapture("signup_complete", { provider: "line_oa_only", variant: getGateVariant() });
    go("lineprompt");
  };

  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={() => go("course")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 16, fontWeight: 700 }}>สมัครฟรี</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
        <div style={{ ...css.card, textAlign: "center" }}>
          <div style={{ width: 72, height: 72, borderRadius: "50%", background: "#06C75518", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 14px" }}><I name="line" size={36} color="#06C755" /></div>
          <h2 style={{ fontSize: 20, fontWeight: 800, margin: "0 0 6px" }}>อีกขั้นเดียว! 🎉</h2>
          <p style={{ fontSize: 13, color: B.dkGray, lineHeight: 1.7, margin: "0 0 18px" }}>กรอกข้อมูลเพื่อ <strong style={{ color: B.black }}>ปลดคอร์สเต็ม + รับคูปองส่วนลด ฿100</strong></p>
          <div style={{ marginBottom: 12, textAlign: "left" }}>
            <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>ชื่อ-นามสกุล *</label>
            <input type="text" placeholder="เช่น สมชาย ใจดี" value={name} onChange={(e) => { setName(e.target.value); setErr(""); }} style={{ width: "100%", padding: "12px 16px", border: `2px solid ${B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
          </div>
          <div style={{ marginBottom: 12, textAlign: "left" }}>
            <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>เบอร์โทรศัพท์ *</label>
            <input type="tel" placeholder="เช่น 081-234-5678" value={phone} onChange={(e) => { setPhone(e.target.value); setErr(""); }} style={{ width: "100%", padding: "12px 16px", border: `2px solid ${B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
          </div>
          <label style={{ display: "flex", gap: 10, alignItems: "flex-start", cursor: "pointer", marginBottom: 16, textAlign: "left" }}>
            <input type="checkbox" checked={pdpa} onChange={(e) => { setPdpa(e.target.checked); setErr(""); }} style={{ marginTop: 3, width: 18, height: 18 }} />
            <span style={{ fontSize: 11, color: B.dkGray, lineHeight: 1.5 }}>ข้าพเจ้ายินยอมให้ JIA TRAINER CENTER เก็บและใช้ข้อมูลส่วนบุคคล (ชื่อ, เบอร์โทร) เพื่อจัดการหลักสูตร ออกใบประกาศนียบัตร และแจ้งข้อมูลหลักสูตร</span>
          </label>
          {err && <div style={{ color: B.red, fontSize: 12, marginBottom: 12 }}>{err}</div>}
          <button onClick={submit} disabled={busy} style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, width: "100%", background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, border: "none", fontWeight: 700, fontSize: 15, cursor: "pointer", opacity: busy ? 0.6 : 1 }}>
            <I name="line" size={22} color={B.white} /> {busy ? "กำลังสมัคร..." : "สมัคร & เพิ่ม LINE @jiacpr →"}
          </button>
          <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ width: "100%", marginTop: 10, background: "none", border: `1px solid ${B.red}`, borderRadius: 12, color: B.red, fontWeight: 700, fontSize: 14, padding: "11px 16px", cursor: "pointer" }}>🎟️ มีโค้ดแล้ว? ใส่โค้ดเข้าเรียนเลย →</button>
        </div>
      </div>
    </div>
  );
}
