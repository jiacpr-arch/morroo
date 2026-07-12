"use client";
import { useState } from "react";
import { B, LINE_URL } from "@/lib/cpr/config";
import { load, save, type CprUser } from "@/lib/cpr/storage";
import { supaRest, uploadSlip } from "@/lib/cpr/api";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

export default function Payment({ go, user }: { go: Go; user: CprUser | null }) {
  const [uploading, setUploading] = useState(false);
  const [slipDone, setSlipDone] = useState(false);

  const handleSlip = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    const reader = new FileReader();
    reader.onload = async () => {
      try {
        const u = user || load<CprUser | null>("user", null);
        const fileName = (u?.name || "student") + "_online_" + Date.now() + ".jpg";
        const byteChars = atob(String(reader.result).split(",").pop() || "");
        const byteArr = new Uint8Array(byteChars.length);
        for (let i = 0; i < byteChars.length; i++) byteArr[i] = byteChars.charCodeAt(i);
        const blob = new Blob([byteArr], { type: "image/jpeg" });
        const url = await uploadSlip(fileName, blob);
        if (url) {
          supaRest("online_purchases", "POST", { phone: u?.phone || "", modules: "online_fee", amount: 100, slip_url: url, payment_status: "แจ้งชำระแล้ว" });
          setSlipDone(true);
          save("enrolled", true);
        } else {
          alert("อัพโหลดไม่สำเร็จ กรุณาส่งสลิปทาง LINE แทน");
        }
      } catch (_err) {
        alert("เกิดข้อผิดพลาด กรุณาส่งสลิปทาง LINE");
      }
      setUploading(false);
    };
    reader.readAsDataURL(file);
  };

  if (slipDone)
    return (
      <div style={css.page}>
        <div style={{ ...css.wrap, paddingTop: 60, textAlign: "center" }}>
          <div style={{ width: 76, height: 76, borderRadius: "50%", background: `${B.green}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 20px" }}><I name="check" size={38} color={B.green} /></div>
          <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 8px" }}>ชำระเงินสำเร็จ!</h2>
          <p style={{ fontSize: 14, color: B.dkGray }}>ได้รับสลิปแล้ว เข้าเรียนได้เลย</p>
          <button onClick={() => go("course")} style={{ ...css.btn(B.red, B.white), marginTop: 20, padding: "14px 40px", fontSize: 16 }}>เข้าเรียนเลย →</button>
        </div>
      </div>
    );

  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={() => go("register")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 16, fontWeight: 700 }}>ชำระเงิน ฿100</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
        <div style={{ ...css.card, textAlign: "center" }}>
          <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 4 }}>คอร์ส CPR & AED ออนไลน์</div>
          <div style={{ fontSize: 36, fontWeight: 800, color: B.red, margin: "8px 0" }}>฿100</div>
          <div style={{ fontSize: 13, color: B.dkGray }}>เอา ฿100 เป็นส่วนลดตอนมาเรียน On-site</div>
        </div>

        <div style={{ ...css.card, marginTop: 14, textAlign: "center" }}>
          <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 12 }}>โอนเงินเข้าบัญชี</div>
          <div style={{ background: `${B.gold}12`, borderRadius: 12, padding: 16, marginBottom: 12 }}>
            <div style={{ fontSize: 13, color: B.dkGray }}>ธนาคารกสิกรไทย</div>
            <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: 2, margin: "6px 0" }}>134-3-11564-0</div>
            <div style={{ fontSize: 13, color: B.dkGray }}>บริษัท โรจน์รุ่งธุรกิจ จำกัด</div>
          </div>
          <button onClick={() => { navigator.clipboard?.writeText("1343115640"); alert("คัดลอกเลขบัญชีแล้ว!"); }} style={{ ...css.btn(B.white, B.black, true), border: `1px solid ${B.ltGray}`, fontSize: 13, padding: "8px 20px" }}>คัดลอกเลขบัญชี</button>
        </div>

        <div style={{ ...css.card, marginTop: 14, textAlign: "center" }}>
          <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 8 }}>อัพโหลดสลิป</div>
          <div style={{ fontSize: 13, color: B.dkGray, marginBottom: 14 }}>โอนแล้วอัพโหลดสลิปที่นี่เลย</div>
          <label style={{ ...css.btn(B.red, B.white), display: "inline-flex", alignItems: "center", gap: 8, cursor: "pointer", opacity: uploading ? 0.6 : 1 }}>
            <I name="save" size={18} color={B.white} /> {uploading ? "กำลังอัพโหลด..." : "เลือกรูปสลิป"}
            <input type="file" accept="image/*" capture="environment" onChange={handleSlip} disabled={uploading} style={{ display: "none" }} />
          </label>
        </div>

        <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 14, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}><I name="line" size={22} color={B.white} /> หรือส่งสลิปทาง LINE @jiacpr</a>
      </div>
    </div>
  );
}
