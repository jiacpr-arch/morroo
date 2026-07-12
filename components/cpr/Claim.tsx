"use client";
// Lead Capture + ใช้โค้ดโปรโม (LEAD-/VCH-/โค้ดกลาง multi_use เช่น JIA-STUDENT)
import { useState } from "react";
import { B, COURSE, LEAD_SOURCES, LINE_QR_URL, LINE_URL, PRICING, PROMO_EXPIRY_DAYS, PROMO_FREE_MODULES } from "@/lib/cpr/config";
import { getGateVariant, getUTM, load, save, type CprUser } from "@/lib/cpr/storage";
import { daysUntil, genIdempotencyKey, genLeadCode, getLinkCode, normalizeEmail, normalizePhone, supaRest } from "@/lib/cpr/api";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

 

type Claimed = { code: string; expires_at: string; modules: number[]; name: string };

export default function Claim({ go, setUser, initialStep = "form", initialCode = "" }: { go: Go; setUser: (u: CprUser) => void; initialStep?: string; initialCode?: string }) {
  const [step, setStep] = useState(initialStep);
  const u0 = load<CprUser | null>("user", null);
  const [form, setForm] = useState({
    name: u0?.name || "",
    phone: u0?.phone || "",
    email: u0?.email || "",
    source: "",
    sourceOther: "",
    lineId: "",
  });
  const [err, setErr] = useState<Record<string, string | undefined>>({});
  const [pdpa, setPdpa] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [validating, setValidating] = useState(false);
  const [claimed, setClaimed] = useState<Claimed | null>(() => {
    const code = load<string | null>("promo_code", null);
    const exp = load<string | null>("promo_expires", null);
    return code && exp
      ? { code, expires_at: exp, modules: load<number[]>("promo_unlocked", []).length ? load<number[]>("promo_unlocked", []) : PROMO_FREE_MODULES, name: u0?.name || "" }
      : null;
  });
  const [redeemCode, setRedeemCode] = useState(initialCode || "");
  const [redeemErr, setRedeemErr] = useState("");
  const [copied, setCopied] = useState(false);
  // ต้องรู้ว่าใครใช้โค้ด (ชื่อ+เบอร์) ก่อน redeem เสมอ — ผูก online_students ให้ค้นหา/ดูคะแนนย้อนหลังได้
  const [redeemName, setRedeemName] = useState(u0?.name || "");
  const [redeemPhone, setRedeemPhone] = useState(u0?.phone || "");

  const F = (k: string, v: string) => {
    setForm((p) => ({ ...p, [k]: v }));
    setErr((e) => ({ ...e, [k]: undefined }));
  };

  const checkDuplicate = async () => {
    const email = normalizeEmail(form.email);
    const phone = normalizePhone(form.phone);
    if (!email && !phone) return null;
    const filters: string[] = [];
    if (email) filters.push(`email.eq.${encodeURIComponent(email)}`);
    if (phone) filters.push(`phone.eq.${encodeURIComponent(phone)}`);
    const q = filters.length === 1 ? `?${filters[0]}` : `?or=(${filters.join(",")})`;
    const res = await supaRest("lead_promo_codes", "GET", null, `${q}&select=code,expires_at,redeemed_at,name,unlock_modules&order=created_at.desc&limit=1`);
    if (!Array.isArray(res) || !res.length) return null;
    const r = res[0];
    return { ...r, expired: new Date(r.expires_at) < new Date() };
  };

  const submitForm = async () => {
    const e: Record<string, string> = {};
    if (!form.name.trim()) e.name = "กรุณากรอกชื่อ-นามสกุล";
    const phone = normalizePhone(form.phone);
    if (phone.length < 9) e.phone = "กรุณากรอกเบอร์โทรที่ถูกต้อง";
    const email = normalizeEmail(form.email);
    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) e.email = "กรุณากรอกอีเมลที่ถูกต้อง (สำหรับส่งโค้ดสำรอง)";
    if (!form.source) e.source = "กรุณาเลือกช่องทางที่รู้จัก JIA";
    if (form.source === "other" && !form.sourceOther.trim()) e.sourceOther = "กรุณาระบุช่องทาง";
    if (!pdpa) e.pdpa = "กรุณายินยอม PDPA ก่อนรับโค้ด";
    if (Object.keys(e).length) {
      setErr(e);
      return;
    }

    setSubmitting(true);
    setStep("checking");
    try {
      const dup = await checkDuplicate();
      if (dup && !dup.expired && !dup.redeemed_at) {
        const data = { code: dup.code, expires_at: dup.expires_at, name: form.name.trim(), modules: dup.unlock_modules || PROMO_FREE_MODULES };
        setClaimed(data);
        save("promo_code", dup.code);
        save("promo_expires", dup.expires_at);
        save("promo_email", email);
        supaRest("lead_capture_events", "POST", { code: dup.code, event_type: "duplicate_attempt", metadata: { source: form.source } });
        setStep("already");
        setSubmitting(false);
        return;
      }

      const code = genLeadCode();
      const now = new Date();
      const expires = new Date(now.getTime() + PROMO_EXPIRY_DAYS * 86400000);
      const custId = "cust_lead_" + Date.now() + "_" + Math.random().toString(36).slice(2, 6);

      supaRest("customers", "POST", {
        id: custId, name: form.name.trim(), tel: phone, email, source: "lead-promo-" + form.source,
      });

      const payload = {
        code, email, phone, name: form.name.trim(),
        line_id: form.lineId.trim() || null,
        source: form.source,
        source_other: form.source === "other" ? form.sourceOther.trim() : null,
        unlock_modules: PROMO_FREE_MODULES,
        created_at: now.toISOString(),
        expires_at: expires.toISOString(),
        idempotency_key: genIdempotencyKey(email, phone),
        customer_id: custId,
        email_sent_status: "pending",
      };
      const created = await supaRest("lead_promo_codes", "POST", payload);

      if (!Array.isArray(created) || !created.length) {
        // race condition — re-fetch
        const dup2 = await checkDuplicate();
        if (dup2 && !dup2.expired && !dup2.redeemed_at) {
          setClaimed({ code: dup2.code, expires_at: dup2.expires_at, name: form.name.trim(), modules: dup2.unlock_modules || PROMO_FREE_MODULES });
          save("promo_code", dup2.code);
          save("promo_expires", dup2.expires_at);
          save("promo_email", email);
          setStep("already");
          setSubmitting(false);
          return;
        }
        throw new Error("สร้างโค้ดไม่สำเร็จ");
      }

      const row = created[0];
      const data = { code: row.code, expires_at: row.expires_at, name: form.name.trim(), modules: row.unlock_modules || PROMO_FREE_MODULES };
      setClaimed(data);
      save("promo_code", row.code);
      save("promo_expires", row.expires_at);
      save("promo_email", email);

      supaRest("lead_capture_events", "POST", {
        code: row.code, event_type: "claimed",
        metadata: { source: form.source, source_other: form.source === "other" ? form.sourceOther.trim() : null, has_line_id: !!form.lineId.trim(), ua: (navigator.userAgent || "").slice(0, 200) },
      });

      const userData: CprUser = { name: form.name.trim(), phone, email };
      setUser(userData);
      save("user", userData);

      setStep("reveal");
    } catch (ex) {
      console.error(ex);
      alert("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง");
      setStep("form");
    }
    setSubmitting(false);
  };

  const redeem = async () => {
    setRedeemErr("");
    const code = (redeemCode || "").trim().toUpperCase();
    // นอกจาก LEAD-/VCH- รายคนแล้ว ยังมีโค้ดกลาง (multi_use) ที่แอดมินตั้งชื่อเองได้ เช่น JIA-STUDENT
    if (!/^[A-Z0-9][A-Z0-9-]{3,19}$/.test(code)) {
      setRedeemErr("รหัสไม่ถูกต้อง (เช่น LEAD-XXXXXX, VCH-XXXXXX หรือโค้ดจากเจ้าหน้าที่)");
      return;
    }
    const name = redeemName.trim();
    const phone = normalizePhone(redeemPhone);
    if (!name) { setRedeemErr("กรุณากรอกชื่อ-นามสกุลก่อนใช้โค้ด"); return; }
    if (phone.length < 9) { setRedeemErr("กรุณากรอกเบอร์โทรที่ถูกต้องก่อนใช้โค้ด"); return; }
    setValidating(true);
    try {
      const res = await supaRest("lead_promo_codes", "GET", null, `?code=eq.${encodeURIComponent(code)}&select=code,expires_at,redeemed_at,name,unlock_modules,company,multi_use&limit=1`);
      if (!Array.isArray(res) || !res.length) { setRedeemErr("ไม่พบรหัสนี้ในระบบ"); setValidating(false); return; }
      const row = res[0];
      if (new Date(row.expires_at) < new Date()) {
        setRedeemErr(`รหัสนี้หมดอายุแล้ว (หมดอายุ ${new Date(row.expires_at).toLocaleDateString("th-TH")})`);
        supaRest("lead_capture_events", "POST", { code, event_type: "expired_attempt" });
        setValidating(false);
        return;
      }
      // โค้ดกลาง (multi_use) ใช้ซ้ำได้ไม่จำกัดคน — ห้าม mark redeemed_at (จะไปปิดโค้ดของทุกคน)
      // ติดตามว่าใครใช้บ้างผ่าน lead_capture_events + online_students แทน
      if (!row.multi_use) {
        if (row.redeemed_at) {
          setRedeemErr(`รหัสนี้ถูกใช้ไปแล้วเมื่อ ${new Date(row.redeemed_at).toLocaleDateString("th-TH")}`);
          setValidating(false);
          return;
        }

        const patchRes = await supaRest("lead_promo_codes", "PATCH",
          { redeemed_at: new Date().toISOString(), redeemed_phone: phone, name },
          `?code=eq.${encodeURIComponent(code)}&redeemed_at=is.null`
        );
        if (!Array.isArray(patchRes) || !patchRes.length) {
          setRedeemErr("รหัสถูกใช้พร้อมกันจากเครื่องอื่น กรุณาขอรหัสใหม่");
          setValidating(false);
          return;
        }
      }

      const unlock: number[] = row.unlock_modules && row.unlock_modules.length ? row.unlock_modules : PROMO_FREE_MODULES;
      // "เต็มคอร์ส" จริง (voucher) เท่านั้นถึง grandfather ให้ enrolled=true — โค้ด lead-capture 3 บทฟรี
      // ต้องยังถูกจำกัดแค่ unlock_modules ของมันเอง ไม่ใช่ได้ทุกบทไปฟรีๆ
      const isFullUnlock = [2, 3, 4, 5, 6].every((id) => unlock.includes(id));
      save("promo_unlocked", unlock);
      save("promo_code", code);
      save("promo_redeemed", true);
      if (isFullUnlock) save("enrolled", true);

      // ผูกกับ online_students เสมอ (ไม่ว่าจะเคยสมัครมาก่อนหรือไม่) เพื่อให้พนักงานค้นหาคะแนนย้อนหลังได้
      const u = load<CprUser | null>("user", null);
      if (!u) {
        setUser({ name, phone });
        save("signed_up", true);
        const custId = "cust_" + Date.now() + "_" + Math.random().toString(36).slice(2, 6);
        supaRest("customers", "POST", { id: custId, name, tel: phone, source: "online-course", line_link_code: getLinkCode(), pdpa_consent_at: new Date().toISOString(), signup_at: new Date().toISOString(), gate_variant: getGateVariant(), landing_url: load("landing_url", null), ...getUTM() });
        supaRest("online_students", "POST", { customer_id: custId, name, phone, status: "กำลังเรียน", company: row.company || null });
      } else if (row.company) {
        supaRest("online_students", "PATCH", { company: row.company }, `?phone=ilike.*${phone.slice(-9)}&name=eq.${encodeURIComponent(name)}`);
      }

      // โค้ดกลางไม่ mark redeemed_at บนแถวโค้ด — เก็บชื่อ+เบอร์ของผู้ใช้แต่ละคนไว้ใน event แทน
      supaRest("lead_capture_events", "POST", { code, event_type: "redeemed", metadata: { modules: unlock, company: row.company || null, ...(row.multi_use ? { multi_use: true, name, phone } : {}) } });

      setClaimed({ code, modules: unlock, expires_at: row.expires_at, name });
      setStep("redeemed");
    } catch (ex) {
      console.error(ex);
      setRedeemErr("เกิดข้อผิดพลาด: กรุณาลองใหม่");
    }
    setValidating(false);
  };

  const copyCode = (code: string) => {
    navigator.clipboard?.writeText(code).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  const modulesText = (ids: number[]) => ids.map((id) => COURSE.modules.find((m) => m.id === id)?.short).filter(Boolean).join(" • ");

  const inp = (key: "name" | "phone" | "email" | "sourceOther" | "lineId", label: string, ph: string, type = "text", required = true) => (
    <div style={{ marginBottom: 14 }}>
      <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>{label}{required ? " *" : ""}</label>
      <input type={type} placeholder={ph} value={form[key]} onChange={(e) => F(key, e.target.value)}
        style={{ width: "100%", padding: "12px 14px", border: `2px solid ${err[key] ? B.red : B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
      {err[key] && <div style={{ color: B.red, fontSize: 12, marginTop: 4 }}>{err[key]}</div>}
    </div>
  );

  // ===== Step: form =====
  if (step === "form")
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <button onClick={() => go("landing")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ fontSize: 16, fontWeight: 700 }}>รับโค้ดเรียนฟรี</div>
        </div>
        <div style={{ ...css.wrap, paddingTop: 20, paddingBottom: 40 }}>
          <div style={{ background: `linear-gradient(135deg, ${B.gold} 0%, #E08800 100%)`, color: B.white, borderRadius: 16, padding: 18, marginBottom: 16, textAlign: "center" }}>
            <div style={{ fontSize: 12, fontWeight: 700, opacity: 0.9, letterSpacing: 1, textTransform: "uppercase" }}>ส่วนลด 100%</div>
            <div style={{ fontSize: 22, fontWeight: 800, marginTop: 4 }}>เรียนฟรี 3 บทหลัก</div>
            <div style={{ fontSize: 13, marginTop: 6, opacity: 0.95 }}>{modulesText(PROMO_FREE_MODULES)}</div>
            <div style={{ fontSize: 11, marginTop: 8, opacity: 0.85 }}>มูลค่า ฿{PRICING.bundle3} — รับฟรีเมื่อกรอกข้อมูล</div>
          </div>

          <div style={css.card}>
            <h3 style={{ fontSize: 16, fontWeight: 700, marginTop: 0, marginBottom: 4 }}>กรอกข้อมูลเพื่อรับโค้ด</h3>
            <p style={{ fontSize: 12, color: B.dkGray, marginTop: 0, marginBottom: 18 }}>โค้ดจะแสดงทันที + ส่งสำเนาทางอีเมล</p>

            {inp("name", "ชื่อ-นามสกุล", "เช่น สมชาย ใจดี")}
            {inp("phone", "เบอร์โทรศัพท์", "เช่น 081-234-5678", "tel")}
            {inp("email", "อีเมล", "เช่น name@email.com", "email")}

            <div style={{ marginBottom: 14 }}>
              <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>รู้จัก JIA จากช่องทางไหน? *</label>
              <select value={form.source} onChange={(e) => F("source", e.target.value)}
                style={{ width: "100%", padding: "12px 14px", border: `2px solid ${err.source ? B.red : B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box", background: B.white }}>
                <option value="">— เลือก —</option>
                {LEAD_SOURCES.map((s) => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
              {err.source && <div style={{ color: B.red, fontSize: 12, marginTop: 4 }}>{err.source}</div>}
            </div>

            {form.source === "other" && inp("sourceOther", "โปรดระบุช่องทาง", "เช่น Twitter, Pantip")}

            {inp("lineId", "LINE ID (ไม่บังคับ)", "เช่น jiacpr", "text", false)}

            <div style={{ marginTop: 12 }}>
              <label style={{ display: "flex", gap: 10, alignItems: "flex-start", cursor: "pointer" }}>
                <input type="checkbox" checked={pdpa} onChange={(e) => { setPdpa(e.target.checked); setErr({ ...err, pdpa: undefined }); }} style={{ marginTop: 3, width: 18, height: 18 }} />
                <span style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.5 }}>ข้าพเจ้ายินยอมให้ JIA TRAINER CENTER เก็บข้อมูล (ชื่อ, เบอร์, อีเมล, LINE ID) เพื่อจัดการหลักสูตรออนไลน์, ออกใบประกาศนียบัตร และแจ้งข้อมูลหลักสูตร/โปรโมชั่นในอนาคต ข้อมูลจะไม่เปิดเผยต่อบุคคลภายนอก</span>
              </label>
              {err.pdpa && <div style={{ color: B.red, fontSize: 12, marginTop: 4 }}>{err.pdpa}</div>}
            </div>
          </div>

          <button onClick={submitForm} disabled={submitting} style={{ ...css.btn(B.red, B.white, true), marginTop: 18, opacity: submitting ? 0.6 : 1 }}>รับโค้ดเลย →</button>

          <button onClick={() => setStep("redeem")} style={{ ...css.btn(B.white, B.dkGray, true), marginTop: 10, border: `1px solid ${B.ltGray}`, fontSize: 13 }}>มีโค้ดอยู่แล้ว? กดใช้รหัส →</button>
        </div>
      </div>
    );

  // ===== Step: checking =====
  if (step === "checking")
    return (
      <div style={css.page}>
        <div style={{ ...css.wrap, paddingTop: 80, textAlign: "center" }}>
          <div style={{ width: 60, height: 60, border: `4px solid ${B.ltGray}`, borderTopColor: B.red, borderRadius: "50%", margin: "0 auto 20px", animation: "spin 1s linear infinite" }} />
          <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
          <div style={{ fontSize: 16, fontWeight: 600 }}>กำลังสร้างโค้ดของคุณ...</div>
          <div style={{ fontSize: 13, color: B.dkGray, marginTop: 6 }}>กรุณารอสักครู่</div>
        </div>
      </div>
    );

  // ===== Step: reveal / already =====
  if ((step === "reveal" || step === "already") && claimed) {
    const days = daysUntil(claimed.expires_at);
    const isAlready = step === "already";
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}><div style={{ fontSize: 16, fontWeight: 700, flex: 1, textAlign: "center" }}>{isAlready ? "พบโค้ดในระบบแล้ว" : "ได้รับโค้ดสำเร็จ!"}</div></div>
        <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
          {!isAlready && (
            <div style={{ textAlign: "center", marginBottom: 18 }}>
              <div style={{ width: 64, height: 64, borderRadius: "50%", background: `${B.green}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 10px" }}><I name="check" size={32} color={B.green} /></div>
              <h2 style={{ fontSize: 20, fontWeight: 800, margin: "0 0 4px" }}>ยินดีด้วย {claimed.name}!</h2>
              <p style={{ fontSize: 13, color: B.dkGray, margin: 0 }}>โค้ดของคุณพร้อมใช้แล้ว</p>
            </div>
          )}
          {isAlready && (
            <div style={{ background: `${B.gold}12`, borderRadius: 12, padding: 14, marginBottom: 16, fontSize: 13, color: B.dkGray, textAlign: "center" }}>
              คุณเคยรับโค้ดด้วยอีเมล/เบอร์นี้แล้ว นี่คือโค้ดเดิมของคุณ
            </div>
          )}

          <div style={{ background: B.white, borderRadius: 16, padding: 20, boxShadow: "0 4px 16px rgba(0,0,0,.08)", border: `2px dashed ${B.red}40`, textAlign: "center", marginBottom: 16 }}>
            <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 6 }}>รหัสส่วนลด 100%</div>
            <div style={{ fontSize: 30, fontWeight: 800, color: B.red, letterSpacing: 3, fontFamily: "monospace", marginBottom: 12 }}>{claimed.code}</div>
            <button onClick={() => copyCode(claimed.code)} style={{ ...css.btn(copied ? B.green : B.black, B.white), padding: "10px 24px", fontSize: 13 }}>{copied ? "✓ คัดลอกแล้ว" : "คัดลอกโค้ด"}</button>
            <div style={{ marginTop: 14, padding: "10px 14px", background: `${B.gold}12`, borderRadius: 10, fontSize: 12, color: B.dkGray }}>
              ⏳ หมดอายุใน <strong style={{ color: B.gold }}>{days} วัน</strong> ({new Date(claimed.expires_at).toLocaleDateString("th-TH", { day: "numeric", month: "short", year: "numeric" })})
            </div>
          </div>

          <div style={{ ...css.card, marginBottom: 14 }}>
            <div style={{ fontSize: 13, fontWeight: 700, marginBottom: 8 }}>ปลดล็อกเมื่อใช้โค้ด:</div>
            {(claimed.modules || PROMO_FREE_MODULES).map((id) => {
              const m = COURSE.modules.find((x) => x.id === id);
              if (!m) return null;
              return (
                <div key={id} style={{ display: "flex", alignItems: "center", gap: 10, padding: "8px 0", borderBottom: `1px solid ${B.gray}` }}>
                  <I name="check" size={16} color={B.green} />
                  <div style={{ fontSize: 13 }}><strong>{m.short}</strong><div style={{ fontSize: 11, color: B.dkGray, marginTop: 2 }}>{m.desc}</div></div>
                </div>
              );
            })}
          </div>

          <button onClick={() => { setRedeemCode(claimed.code); setStep("redeem"); }} style={{ ...css.btn(B.red, B.white, true), marginBottom: 12, fontSize: 15 }}>ใช้โค้ดและเข้าเรียนเลย →</button>

          <div style={{ ...css.card, textAlign: "center", marginBottom: 12 }}>
            <div style={{ fontSize: 14, fontWeight: 700, marginBottom: 4 }}>เพิ่ม LINE @jiacpr</div>
            <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 12 }}>รับสิทธิพิเศษและสอบถามได้ทันที</div>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={LINE_QR_URL} alt="LINE QR @jiacpr" style={{ width: 180, height: 180, borderRadius: 12, border: `1px solid ${B.ltGray}` }} />
            <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 12, background: "#06C755", borderRadius: 12, padding: "12px 20px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 14 }}><I name="line" size={20} color={B.white} /> เปิด LINE เพิ่มเพื่อน</a>
          </div>

          <div style={{ background: `${B.gold}10`, borderRadius: 12, padding: 12, fontSize: 12, color: B.dkGray, textAlign: "center", marginBottom: 12 }}>
            📧 เราจะส่งสำเนาโค้ดให้ทาง <strong>{load("promo_email", "อีเมล")}</strong><br />หากไม่ได้รับ ตรวจในกล่อง Spam หรือใช้โค้ดด้านบนได้เลย
          </div>

          <button onClick={() => go("landing")} style={{ ...css.btn(B.white, B.dkGray, true), border: `1px solid ${B.ltGray}`, fontSize: 13 }}>← กลับหน้าแรก</button>
        </div>
      </div>
    );
  }

  // ===== Step: redeem =====
  if (step === "redeem")
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <button onClick={() => setStep(claimed ? "reveal" : "form")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ fontSize: 16, fontWeight: 700 }}>ใช้รหัสส่วนลด</div>
        </div>
        <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
          <div style={css.card}>
            <h3 style={{ fontSize: 16, fontWeight: 700, marginTop: 0, marginBottom: 4 }}>กรอกรหัสส่วนลด</h3>
            <p style={{ fontSize: 12, color: B.dkGray, marginTop: 0, marginBottom: 16 }}>รหัสรูปแบบ LEAD-XXXXXX, VCH-XXXXXX หรือโค้ดที่ได้รับจากเจ้าหน้าที่ (เช่น JIA-STUDENT)</p>
            <input type="text" value={redeemCode} onChange={(e) => { setRedeemCode(e.target.value.toUpperCase()); setRedeemErr(""); }} placeholder="LEAD-XXXXXX" autoCapitalize="characters"
              style={{ width: "100%", padding: "14px 16px", border: `2px solid ${redeemErr ? B.red : B.ltGray}`, borderRadius: 10, fontSize: 18, outline: "none", boxSizing: "border-box", fontFamily: "monospace", letterSpacing: 2, textAlign: "center", textTransform: "uppercase" }} />
            {redeemErr && <div style={{ color: B.red, fontSize: 13, marginTop: 8 }}>{redeemErr}</div>}
          </div>
          <div style={{ ...css.card, marginTop: 12 }}>
            <h3 style={{ fontSize: 14, fontWeight: 700, marginTop: 0, marginBottom: 10 }}>ข้อมูลผู้เรียน (สำหรับตรวจสอบคะแนนภายหลัง)</h3>
            <div style={{ marginBottom: 10 }}>
              <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>ชื่อ-นามสกุล *</label>
              <input type="text" value={redeemName} onChange={(e) => { setRedeemName(e.target.value); setRedeemErr(""); }} placeholder="เช่น สมชาย ใจดี"
                style={{ width: "100%", padding: "12px 14px", border: `2px solid ${B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
            </div>
            <div>
              <label style={{ fontSize: 13, fontWeight: 600, display: "block", marginBottom: 6 }}>เบอร์โทรศัพท์ *</label>
              <input type="tel" value={redeemPhone} onChange={(e) => { setRedeemPhone(e.target.value); setRedeemErr(""); }} placeholder="เช่น 081-234-5678"
                style={{ width: "100%", padding: "12px 14px", border: `2px solid ${B.ltGray}`, borderRadius: 10, fontSize: 14, outline: "none", boxSizing: "border-box" }} />
            </div>
          </div>
          <button onClick={redeem} disabled={validating || !redeemCode} style={{ ...css.btn(B.red, B.white, true), marginTop: 16, opacity: validating || !redeemCode ? 0.5 : 1 }}>{validating ? "กำลังตรวจสอบ..." : "ปลดล็อกบทเรียน →"}</button>
          {!claimed && <button onClick={() => setStep("form")} style={{ ...css.btn(B.white, B.dkGray, true), border: `1px solid ${B.ltGray}`, marginTop: 10, fontSize: 13 }}>ยังไม่มีโค้ด? รับฟรีที่นี่ →</button>}
        </div>
      </div>
    );

  // ===== Step: redeemed =====
  if (step === "redeemed" && claimed)
    return (
      <div style={css.page}>
        <div style={{ ...css.wrap, paddingTop: 60, textAlign: "center", paddingBottom: 40 }}>
          <div style={{ width: 80, height: 80, borderRadius: "50%", background: `${B.green}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 18px" }}><I name="check" size={40} color={B.green} /></div>
          <h2 style={{ fontSize: 24, fontWeight: 800, margin: "0 0 8px" }}>ปลดล็อกสำเร็จ!</h2>
          <p style={{ fontSize: 14, color: B.dkGray, marginBottom: 24 }}>โค้ด {claimed.code} ใช้แล้ว</p>

          <div style={{ ...css.card, textAlign: "left", marginBottom: 20 }}>
            <div style={{ fontSize: 13, fontWeight: 700, marginBottom: 10 }}>บทเรียนที่ปลดล็อก ({(claimed.modules || PROMO_FREE_MODULES).length} บท):</div>
            {(claimed.modules || PROMO_FREE_MODULES).map((id) => {
              const m = COURSE.modules.find((x) => x.id === id);
              return m ? (
                <div key={id} style={{ display: "flex", alignItems: "center", gap: 10, padding: "8px 0", borderBottom: `1px solid ${B.gray}` }}>
                  <I name="check" size={16} color={B.green} />
                  <div style={{ fontSize: 13, fontWeight: 600 }}>{m.short}</div>
                </div>
              ) : null;
            })}
          </div>

          <button onClick={() => go("course")} style={{ ...css.btn(B.red, B.white, true), fontSize: 16, padding: "16px 32px" }}>เข้าเรียนเลย →</button>
        </div>
      </div>
    );

  // fallback
  return (
    <div style={css.page}>
      <div style={{ ...css.wrap, paddingTop: 60, textAlign: "center" }}>
        <p style={{ color: B.dkGray }}>เกิดข้อผิดพลาด</p>
        <button onClick={() => { setStep("form"); setClaimed(null); }} style={{ ...css.btn(B.red, B.white), marginTop: 16 }}>เริ่มใหม่</button>
      </div>
    </div>
  );
}
