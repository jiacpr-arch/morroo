"use client";
import { useEffect, useState } from "react";
import { B, LINE_URL } from "@/lib/cpr/config";
import { load, type CprUser } from "@/lib/cpr/storage";
import { supaRest, uploadSlip } from "@/lib/cpr/api";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

/* eslint-disable @typescript-eslint/no-explicit-any */

export default function Booking({ go }: { go: Go }) {
  const coupon = load<string | null>("coupon", null);
  const user = load<CprUser | null>("user", null);
  const [classes, setClasses] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedClass, setSelectedClass] = useState("");
  const [form, setForm] = useState({ name: user?.name || "", phone: user?.phone || "", people: "1", note: coupon ? `คูปองออนไลน์ ${coupon}` : "" });
  const [step, setStep] = useState<"form" | "payment" | "done">("form");
  const [submitting, setSubmitting] = useState(false);
  const [bookingRef, setBookingRef] = useState<string | null>(null); // เก็บ booking id สำหรับ upload slip
  const [uploading, setUploading] = useState(false);
  const [slipSent, setSlipSent] = useState(false);
  const F = (k: string, v: string) => setForm((p) => ({ ...p, [k]: v }));
  const inp: React.CSSProperties = { width: "100%", padding: "12px 14px", borderRadius: 10, border: `1px solid ${B.ltGray}`, fontSize: 15, boxSizing: "border-box", outline: "none" };
  const lbl: React.CSSProperties = { fontSize: 13, fontWeight: 600, color: B.black, marginBottom: 6, display: "block" };
  const price = coupon ? 400 : 500;

  useEffect(() => {
    supaRest("classes", "GET", null, "?status=in.(ready,waiting_instructor)&order=date.asc")
      .then((data) => {
        const now = new Date().toISOString().slice(0, 10);
        const open = (data || []).filter((c: any) => c.date >= now);
        setClasses(open);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  const fmtDate = (d: string) => {
    const dt = new Date(d + "T00:00:00");
    const days = ["อา.", "จ.", "อ.", "พ.", "พฤ.", "ศ.", "ส."];
    const months = ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."];
    return `${days[dt.getDay()]} ${dt.getDate()} ${months[dt.getMonth()]}`;
  };
  const uid = () => Math.random().toString(36).slice(2) + Date.now().toString(36);
  const today = () => new Date().toISOString().slice(0, 10);

  // Step 1: จอง → สร้าง booking (paymentStatus: รอชำระ)
  const submit = async () => {
    if (!form.name || !form.phone || !selectedClass) {
      alert("กรุณากรอกข้อมูลและเลือกคลาสให้ครบ");
      return;
    }
    setSubmitting(true);
    const cls = classes.find((c) => c.id === selectedClass);
    try {
      const custId = uid();
      const phone = form.phone.replace(/\D/g, "");
      await supaRest("customers", "POST", { id: custId, name: form.name, tel: phone, email: "", created_at: today(), source: "online-course" });

      const bkId = uid();
      await supaRest("bookings", "POST", { id: bkId, customer_id: custId, name: form.name, tel: phone, course_type: cls.courseKey || cls.course_key || "", course_name: cls.courseName || cls.course_name || "", class_id: cls.id, channel: "online-course", total_people: parseInt(form.people) || 1, final_price: price, discount_code: coupon || "", discount_amount: coupon ? 100 : 0, payment_mode: "โอน", payment_status: "รอชำระ", start_date: cls.date, time_slot: cls.timeSlot || cls.time_slot || "", total_days: 1, note: form.note || "", pdpa_consent: true, pdpa_consent_date: today(), created_at: new Date().toISOString() });

      setBookingRef(bkId);
      setStep("payment");
    } catch (e) {
      console.log("Booking error:", e);
      alert("เกิดข้อผิดพลาด กรุณาลองใหม่หรือจองผ่าน LINE");
    }
    setSubmitting(false);
  };

  // Step 2: อัพโหลดสลิป
  const handleSlip = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    try {
      const reader = new FileReader();
      reader.onload = async () => {
        const fileName = (form.name || "student") + "_slip_" + Date.now() + ".jpg";
        const byteChars = atob(String(reader.result).split(",").pop() || "");
        const byteArr = new Uint8Array(byteChars.length);
        for (let i = 0; i < byteChars.length; i++) byteArr[i] = byteChars.charCodeAt(i);
        const blob = new Blob([byteArr], { type: "image/jpeg" });
        const url = await uploadSlip(fileName, blob);
        if (url) {
          await supaRest("bookings", "PATCH", { payment_slip: url, payment_status: "แจ้งชำระแล้ว" }, `?id=eq.${encodeURIComponent(bookingRef || "")}`);
          setSlipSent(true);
        } else {
          alert("อัพโหลดไม่สำเร็จ กรุณาลองใหม่หรือส่งสลิปทาง LINE");
        }
        setUploading(false);
      };
      reader.readAsDataURL(file);
    } catch (err) {
      console.log("Slip upload error:", err);
      alert("เกิดข้อผิดพลาด กรุณาส่งสลิปทาง LINE แทน");
      setUploading(false);
    }
  };

  const cls = classes.find((c) => c.id === selectedClass);

  // ===== Step 3: Done =====
  if (step === "done" || (step === "payment" && slipSent))
    return (
      <div style={{ ...css.page, padding: 20 }}>
        <div style={{ maxWidth: 480, margin: "0 auto", textAlign: "center", paddingTop: 60 }}>
          <div style={{ width: 76, height: 76, borderRadius: "50%", background: `${B.green}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 20px" }}><I name="check" size={38} color={B.green} /></div>
          <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 8px" }}>จองสำเร็จ!</h2>
          <p style={{ fontSize: 14, color: B.dkGray, lineHeight: 1.6 }}>ได้รับข้อมูลจองและหลักฐานการโอนแล้ว<br />ทีมงาน JIA จะยืนยันภายใน 24 ชม.</p>
          {cls && <div style={{ background: B.gray, borderRadius: 12, padding: 14, marginTop: 16, fontSize: 14 }}><strong>{fmtDate(cls.date)}</strong> • {cls.timeSlot || cls.time_slot}<br /><span style={{ color: B.dkGray, fontSize: 13 }}>{cls.courseName || cls.course_name}</span></div>}
          <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "inline-flex", alignItems: "center", gap: 10, marginTop: 16, background: "#06C755", borderRadius: 12, padding: "14px 28px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}><I name="line" size={22} color={B.white} /> LINE @jiacpr</a>
          <div><button onClick={() => go("course")} style={{ ...css.btn(B.white, B.black, true), marginTop: 14, border: `1px solid ${B.ltGray}` }}>← กลับหน้าบทเรียน</button></div>
        </div>
      </div>
    );

  // ===== Step 2: Payment =====
  if (step === "payment")
    return (
      <div style={{ ...css.page, padding: 20 }}>
        <div style={{ maxWidth: 480, margin: "0 auto" }}>
          <div style={{ textAlign: "center", marginBottom: 20 }}>
            <div style={{ width: 64, height: 64, borderRadius: "50%", background: `${B.gold}15`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 12px" }}><I name="star" size={32} color={B.gold} /></div>
            <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 6px" }}>ชำระเงิน</h2>
            <p style={{ fontSize: 14, color: B.dkGray }}>โอนเงินแล้วอัพโหลดสลิปด้านล่าง</p>
          </div>

          {/* สรุปการจอง */}
          {cls && (
            <div style={{ background: B.white, borderRadius: 14, padding: 16, marginBottom: 16, boxShadow: "0 1px 6px rgba(0,0,0,.05)" }}>
              <div style={{ fontSize: 13, color: B.dkGray, marginBottom: 6 }}>สรุปการจอง</div>
              <div style={{ fontWeight: 700, fontSize: 15 }}>{fmtDate(cls.date)} • {cls.timeSlot || cls.time_slot}</div>
              <div style={{ fontSize: 13, color: B.dkGray }}>{cls.courseName || cls.course_name} • {form.people} คน</div>
              <div style={{ marginTop: 8, paddingTop: 8, borderTop: `1px solid ${B.ltGray}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <span style={{ fontSize: 13, color: B.dkGray }}>ยอดชำระ</span>
                <span style={{ fontSize: 22, fontWeight: 800, color: B.red }}>฿{price}</span>
              </div>
              {coupon && <div style={{ fontSize: 12, color: B.green, marginTop: 4 }}>ใช้คูปอง {coupon} ลด ฿100 แล้ว</div>}
            </div>
          )}

          {/* ข้อมูลบัญชี */}
          <div style={{ background: B.white, borderRadius: 14, padding: 20, marginBottom: 16, boxShadow: "0 1px 6px rgba(0,0,0,.05)", textAlign: "center" }}>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 12, color: B.black }}>โอนเงินเข้าบัญชี</div>
            <div style={{ background: `${B.gold}12`, borderRadius: 12, padding: 16, marginBottom: 12 }}>
              <div style={{ fontSize: 13, color: B.dkGray }}>ธนาคารกสิกรไทย</div>
              <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: 2, margin: "6px 0", color: B.black }}>134-3-11564-0</div>
              <div style={{ fontSize: 13, color: B.dkGray }}>บริษัท โรจน์รุ่งธุรกิจ จำกัด</div>
            </div>
            <button onClick={() => { navigator.clipboard?.writeText("1343115640"); alert("คัดลอกเลขบัญชีแล้ว!"); }} style={{ ...css.btn(B.white, B.black, true), border: `1px solid ${B.ltGray}`, fontSize: 13, padding: "8px 20px" }}>คัดลอกเลขบัญชี</button>
          </div>

          {/* อัพโหลดสลิป */}
          <div style={{ background: B.white, borderRadius: 14, padding: 20, boxShadow: "0 1px 6px rgba(0,0,0,.05)", textAlign: "center" }}>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 8, color: B.black }}>อัพโหลดสลิปโอนเงิน</div>
            <div style={{ fontSize: 13, color: B.dkGray, marginBottom: 14 }}>ถ่ายรูปสลิปหรือ screenshot แล้วอัพโหลด</div>
            <label style={{ ...css.btn(B.red, B.white), display: "inline-flex", alignItems: "center", gap: 8, cursor: "pointer", opacity: uploading ? 0.6 : 1 }}>
              <I name="save" size={18} color={B.white} /> {uploading ? "กำลังอัพโหลด..." : "เลือกรูปสลิป"}
              <input type="file" accept="image/*" capture="environment" onChange={handleSlip} disabled={uploading} style={{ display: "none" }} />
            </label>
          </div>

          {/* ส่งสลิปทาง LINE แทน */}
          <div style={{ textAlign: "center", marginTop: 16, fontSize: 13, color: B.dkGray }}>หรือส่งสลิปทาง LINE แทน</div>
          <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 8, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}><I name="line" size={22} color={B.white} /> ส่งสลิปทาง LINE @jiacpr</a>
          <button onClick={() => setStep("done")} style={{ ...css.btn(B.white, B.dkGray, true), marginTop: 10, border: `1px solid ${B.ltGray}`, width: "100%", fontSize: 13 }}>ข้ามขั้นตอนนี้ (ส่งสลิปทีหลัง)</button>
        </div>
      </div>
    );

  return (
    <div style={{ ...css.page, padding: 20 }}>
      <div style={{ maxWidth: 480, margin: "0 auto" }}>
        <button onClick={() => go(load("enrolled", false) ? "certificate" : "landing")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer", display: "flex", alignItems: "center", gap: 6, color: B.dkGray, fontSize: 14, marginBottom: 16 }}><I name="back" size={18} color={B.dkGray} /> กลับ</button>

        <div style={{ textAlign: "center", marginBottom: 24 }}>
          <div style={{ width: 64, height: 64, borderRadius: "50%", background: `${B.red}12`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 12px" }}><I name="cert" size={32} color={B.red} /></div>
          <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 6px" }}>จองคอร์ส On-site</h2>
          <p style={{ fontSize: 14, color: B.dkGray }}>CPR & AED มาตรฐาน 2025 | ฝึกปฏิบัติจริง</p>
        </div>

        {/* Info cards */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10, marginBottom: 20 }}>
          {[
            { icon: "clock", t: "2 ชั่วโมง", s: "ต่อรอบ" },
            { icon: "star", t: coupon ? "฿400" : "฿500", s: coupon ? "ลดแล้ว ฿100" : "ต่อท่าน" },
            { icon: "book", t: "ใบรับรอง", s: "มาตรฐาน 2025" },
            { icon: "heart", t: "ฝึกจริง", s: "หุ่น CPR + AED" },
          ].map((c, i) => (
            <div key={i} style={{ background: B.white, borderRadius: 12, padding: 14, textAlign: "center", boxShadow: "0 1px 4px rgba(0,0,0,.05)" }}>
              <I name={c.icon} size={20} color={B.red} /><div style={{ fontWeight: 700, fontSize: 14, marginTop: 4 }}>{c.t}</div><div style={{ fontSize: 11, color: B.dkGray }}>{c.s}</div>
            </div>
          ))}
        </div>

        {coupon && (
          <div style={{ background: `${B.green}10`, borderRadius: 12, padding: "12px 16px", marginBottom: 20, display: "flex", alignItems: "center", gap: 10, border: `1px solid ${B.green}30` }}>
            <I name="check" size={20} color={B.green} /><div><div style={{ fontSize: 13, fontWeight: 700, color: B.green }}>คูปองส่วนลด ฿100 ถูกใช้แล้ว!</div><div style={{ fontSize: 12, color: B.dkGray }}>รหัส: {coupon} • ราคาจาก ฿500 เหลือ ฿400</div></div>
          </div>
        )}

        {/* Form */}
        <div style={{ background: B.white, borderRadius: 16, padding: 20, boxShadow: "0 2px 12px rgba(0,0,0,.06)" }}>
          <div style={{ marginBottom: 14 }}><label style={lbl}>ชื่อ-นามสกุล *</label><input value={form.name} onChange={(e) => F("name", e.target.value)} placeholder="ชื่อจริง นามสกุล" style={inp} /></div>
          <div style={{ marginBottom: 14 }}><label style={lbl}>เบอร์โทร *</label><input value={form.phone} onChange={(e) => F("phone", e.target.value)} placeholder="08X-XXX-XXXX" type="tel" style={inp} /></div>

          <div style={{ marginBottom: 14 }}>
            <label style={lbl}>เลือกวัน-เวลาเรียน *</label>
            {loading ? <div style={{ padding: 14, textAlign: "center", color: B.dkGray, fontSize: 13 }}>กำลังโหลดตารางคลาส...</div> :
              classes.length === 0 ? <div style={{ padding: 14, textAlign: "center", color: B.dkGray, fontSize: 13, background: B.gray, borderRadius: 10 }}>ยังไม่มีคลาสเปิดในขณะนี้ — ติดต่อ LINE เพื่อนัดวัน</div> : (
                <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                  {classes.map((c) => (
                    <button key={c.id} onClick={() => setSelectedClass(c.id)} style={{
                      padding: "12px 14px", borderRadius: 10, textAlign: "left", cursor: "pointer",
                      border: selectedClass === c.id ? `2px solid ${B.red}` : `1px solid ${B.ltGray}`,
                      background: selectedClass === c.id ? `${B.red}08` : B.white,
                    }}>
                      <div style={{ fontWeight: 600, fontSize: 14, color: selectedClass === c.id ? B.red : B.black }}>{fmtDate(c.date)} • {c.timeSlot || c.time_slot}</div>
                      <div style={{ fontSize: 12, color: B.dkGray, marginTop: 2 }}>{c.courseName || c.course_name}{c.place ? ` • ${c.place}` : ""}</div>
                    </button>
                  ))}
                </div>
              )}
          </div>

          <div style={{ marginBottom: 14 }}><label style={lbl}>จำนวนคน</label><select value={form.people} onChange={(e) => F("people", e.target.value)} style={inp}><option>1</option><option>2</option><option>3</option><option>4</option><option>5+</option></select></div>
          <div style={{ marginBottom: 18 }}><label style={lbl}>หมายเหตุ</label><textarea value={form.note} onChange={(e) => F("note", e.target.value)} placeholder="ข้อมูลเพิ่มเติม" rows={2} style={{ ...inp, resize: "vertical" }} /></div>
          <button onClick={submit} disabled={submitting} style={{ ...css.btn(B.red, B.white), width: "100%", padding: "14px", fontSize: 16, opacity: submitting ? 0.6 : 1 }}>{submitting ? "กำลังจอง..." : "จองคอร์ส →"}</button>
        </div>

        <div style={{ textAlign: "center", marginTop: 16, fontSize: 13, color: B.dkGray }}>หรือจองผ่าน LINE ได้เลย</div>
        <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 8, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}><I name="line" size={22} color={B.white} /> จองผ่าน LINE @jiacpr</a>
      </div>
    </div>
  );
}
