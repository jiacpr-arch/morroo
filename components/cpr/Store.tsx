"use client";
import { useState } from "react";
import { B, COURSE, FN_HEADERS, FN_URL, FREE_LAUNCH, LINE_URL, PRICING, PROMO_ENABLED, PROMO_FREE_MODULES } from "@/lib/cpr/config";
import { calcPrice, getPurchased, load, save, savePurchased, type CprUser } from "@/lib/cpr/storage";
import { supaRest, uploadSlip } from "@/lib/cpr/api";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

export default function Store({ go }: { go: Go }) {
  const [selected, setSelected] = useState<number[]>([]);
  const [step, setStep] = useState<"select" | "payment">("select");
  const [uploading, setUploading] = useState(false);
  const [slipDone, setSlipDone] = useState(false);
  const purchased = getPurchased();
  const user = load<CprUser | null>("user", null);
  const buyable = COURSE.modules.filter((m) => m.id <= 6 && !purchased.includes(m.id));

  const toggle = (id: number) => setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  const selectAll = () => setSelected(buyable.map((m) => m.id));
  const total = calcPrice(selected.length);
  const isFull = selected.length + purchased.filter((x) => x <= 6).length >= 6;

  const [stripePaying, setStripePaying] = useState(false);
  const payWithStripe = async () => {
    setStripePaying(true);
    try {
      const moduleNames = selected.map((id) => COURSE.modules.find((x) => x.id === id)?.short).filter(Boolean);
      const res = await fetch(FN_URL("stripe-checkout"), {
        method: "POST",
        headers: FN_HEADERS,
        body: JSON.stringify({
          type: "online_purchase",
          items: [{ name: `JIA Online: ${moduleNames.join(", ")}`, amount: total }],
          metadata: { phone: user?.phone || "", modules: selected.join(","), name: user?.name || "" },
          // กลับมาที่หน้า /cpr/course บน origin ปัจจุบัน (www.morroo.com)
          successUrl: window.location.origin + "/cpr/course?stripe=success&modules=" + selected.join(","),
          cancelUrl: window.location.origin + "/cpr/course?stripe=cancel",
        }),
      });
      const data = await res.json();
      if (data.url) {
        supaRest("online_purchases", "POST", { phone: user?.phone || "", modules: selected.join(","), amount: total, payment_status: "รอชำระ" });
        window.location.assign(data.url);
      } else {
        alert("เกิดข้อผิดพลาด: " + (data.error || "ไม่สามารถสร้างลิงก์ชำระเงินได้"));
      }
    } catch (err) {
      alert("เกิดข้อผิดพลาด กรุณาลองใหม่");
      console.error(err);
    }
    setStripePaying(false);
  };

  const handleSlip = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    const reader = new FileReader();
    reader.onload = async () => {
      try {
        const fileName = (user?.name || "student") + "_course_" + Date.now() + ".jpg";
        const byteChars = atob(String(reader.result).split(",").pop() || "");
        const byteArr = new Uint8Array(byteChars.length);
        for (let i = 0; i < byteChars.length; i++) byteArr[i] = byteChars.charCodeAt(i);
        const blob = new Blob([byteArr], { type: "image/jpeg" });
        const url = await uploadSlip(fileName, blob);
        if (url) {
          // ต้องบันทึกรายการแจ้งชำระให้สำเร็จก่อน จึงปลดล็อก — กันเคสจ่ายแล้วแต่ไม่มี record ให้แอดมินตรวจ
          const rec = await supaRest("online_purchases", "POST", { phone: user?.phone || "", modules: selected.join(","), amount: total, slip_url: url, payment_status: "แจ้งชำระแล้ว" });
          if (Array.isArray(rec) && rec.length) {
            const newPurchased = [...new Set([...purchased, ...selected])];
            savePurchased(newPurchased);
            setSlipDone(true);
          } else {
            alert("บันทึกการแจ้งชำระไม่สำเร็จ กรุณาส่งสลิปทาง LINE แทน");
          }
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
          <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 8px" }}>ซื้อสำเร็จ!</h2>
          <p style={{ fontSize: 14, color: B.dkGray }}>ปลดล็อก {selected.length} หัวข้อแล้ว เข้าเรียนได้เลย</p>
          <button onClick={() => go("course")} style={{ ...css.btn(B.red, B.white), marginTop: 20, padding: "14px 40px", fontSize: 16 }}>เข้าเรียนเลย →</button>
        </div>
      </div>
    );

  if (step === "payment")
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <button onClick={() => setStep("select")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ fontSize: 16, fontWeight: 700 }}>ชำระเงิน ฿{total}</div>
        </div>
        <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
          <div style={{ ...css.card, marginBottom: 14 }}>
            <div style={{ fontSize: 14, fontWeight: 700, marginBottom: 8 }}>สรุปรายการ</div>
            {selected.map((id) => { const m = COURSE.modules.find((x) => x.id === id)!; return <div key={id} style={{ fontSize: 13, padding: "4px 0", borderBottom: `1px solid ${B.gray}` }}>{m.short}</div>; })}
            <div style={{ display: "flex", justifyContent: "space-between", marginTop: 10, paddingTop: 8, borderTop: `1px solid ${B.ltGray}` }}>
              <span style={{ fontWeight: 600 }}>รวม {selected.length} หัวข้อ</span>
              <span style={{ fontSize: 22, fontWeight: 800, color: B.red }}>฿{total}</span>
            </div>
            {isFull && <div style={{ fontSize: 12, color: B.green, marginTop: 6 }}>ครบ 6 หัวข้อ! ได้ Final Exam + Full Certificate + คูปอง ฿100 ฟรี</div>}
          </div>
          <div style={{ ...css.card, textAlign: "center", marginBottom: 14 }}>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 12 }}>ชำระออนไลน์ (บัตรเครดิต / PromptPay)</div>
            <button onClick={payWithStripe} disabled={stripePaying} style={{ ...css.btn("#635BFF", B.white), padding: "14px 32px", fontSize: 15, width: "100%", opacity: stripePaying ? 0.6 : 1, display: "flex", alignItems: "center", justifyContent: "center", gap: 10 }}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="white"><path d="M13.976 9.15c-2.172-.806-3.356-1.426-3.356-2.409 0-.831.683-1.305 1.901-1.305 2.227 0 4.515.858 6.09 1.631l.89-5.494C18.252.975 15.697 0 12.165 0 9.667 0 7.589.654 6.104 1.872 4.56 3.147 3.757 4.992 3.757 7.218c0 4.039 2.467 5.76 6.476 7.219 2.585.92 3.445 1.574 3.445 2.583 0 .98-.84 1.545-2.354 1.545-1.875 0-4.965-.921-6.99-2.109l-.9 5.555C5.175 22.99 8.385 24 11.714 24c2.641 0 4.843-.624 6.328-1.813 1.664-1.305 2.525-3.236 2.525-5.732 0-4.128-2.524-5.851-6.591-7.305z"/></svg>
              {stripePaying ? "กำลังเปิดหน้าชำระเงิน..." : "ชำระผ่าน Stripe"}
            </button>
            <div style={{ fontSize: 11, color: B.dkGray, marginTop: 8 }}>รองรับ Visa / Mastercard / PromptPay — ปลดล็อคทันที</div>
          </div>
          <div style={{ ...css.card, textAlign: "center", marginBottom: 14, position: "relative" }}>
            <div style={{ position: "absolute", top: -10, left: "50%", transform: "translateX(-50%)", background: B.white, padding: "0 12px", fontSize: 12, color: B.dkGray }}>หรือ</div>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 12 }}>โอนเงินเข้าบัญชี</div>
            <div style={{ background: `${B.gold}12`, borderRadius: 12, padding: 16, marginBottom: 12 }}>
              <div style={{ fontSize: 13, color: B.dkGray }}>ธนาคารกสิกรไทย</div>
              <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: 2, margin: "6px 0" }}>134-3-11564-0</div>
              <div style={{ fontSize: 13, color: B.dkGray }}>บริษัท โรจน์รุ่งธุรกิจ จำกัด</div>
            </div>
            <button onClick={() => { navigator.clipboard?.writeText("1343115640"); alert("คัดลอกเลขบัญชีแล้ว!"); }} style={{ ...css.btn(B.white, B.black, true), border: `1px solid ${B.ltGray}`, fontSize: 13, padding: "8px 20px" }}>คัดลอกเลขบัญชี</button>
          </div>
          <div style={{ ...css.card, textAlign: "center" }}>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 8 }}>อัพโหลดสลิป</div>
            <label style={{ ...css.btn(B.red, B.white), display: "inline-flex", alignItems: "center", gap: 8, cursor: "pointer", opacity: uploading ? 0.6 : 1 }}>
              <I name="save" size={18} color={B.white} /> {uploading ? "กำลังอัพโหลด..." : "เลือกรูปสลิป"}
              <input type="file" accept="image/*" capture="environment" onChange={handleSlip} disabled={uploading} style={{ display: "none" }} />
            </label>
          </div>
          <a href={LINE_URL} target="_blank" rel="noopener noreferrer" style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 14, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}><I name="line" size={22} color={B.white} /> หรือส่งสลิปทาง LINE @jiacpr</a>
        </div>
      </div>
    );

  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={() => go("course")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 16, fontWeight: 700 }}>เลือกซื้อหัวข้อ</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 20, paddingBottom: 120 }}>
        {/* Already purchased */}
        {purchased.filter((x) => x <= 6).length > 0 && (
          <div style={{ marginBottom: 16 }}>
            <div style={{ fontSize: 13, color: B.dkGray, marginBottom: 8 }}>หัวข้อที่ซื้อแล้ว ({purchased.filter((x) => x <= 6).length})</div>
            {purchased.filter((x) => x <= 6).map((id) => { const m = COURSE.modules.find((x) => x.id === id)!; return (
              <div key={id} style={{ display: "flex", alignItems: "center", gap: 10, padding: "10px 14px", marginBottom: 6, background: `${B.green}08`, borderRadius: 10, border: `1px solid ${B.green}30` }}>
                <I name="check" size={16} color={B.green} /><span style={{ fontSize: 13, fontWeight: 600 }}>{m.short}</span>
                {id === PRICING.freeModule && <span style={{ fontSize: 10, background: B.green, color: B.white, padding: "2px 6px", borderRadius: 4, marginLeft: "auto" }}>ฟรี</span>}
              </div>
            ); })}
          </div>
        )}

        {/* Buyable modules */}
        {buyable.length > 0 ? (
          <>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 12 }}>
              <div style={{ fontSize: 14, fontWeight: 700 }}>เลือกหัวข้อที่ต้องการ</div>
              <button onClick={selectAll} style={{ fontSize: 12, color: B.red, background: "none", border: "none", cursor: "pointer", fontWeight: 600 }}>เลือกทั้งหมด</button>
            </div>
            {buyable.map((m) => { const sel = selected.includes(m.id); return (
              <button key={m.id} onClick={() => toggle(m.id)} style={{ display: "flex", width: "100%", alignItems: "center", gap: 12, padding: "12px 14px", marginBottom: 8, background: sel ? `${B.red}06` : B.white, border: sel ? `2px solid ${B.red}` : `1px solid ${B.ltGray}`, borderRadius: 12, cursor: "pointer", textAlign: "left" }}>
                <div style={{ width: 24, height: 24, borderRadius: 6, border: sel ? `2px solid ${B.red}` : `2px solid ${B.ltGray}`, background: sel ? B.red : B.white, display: "flex", alignItems: "center", justifyContent: "center" }}>{sel && <I name="check" size={14} color={B.white} />}</div>
                <div style={{ flex: 1 }}><div style={{ fontSize: 14, fontWeight: 600 }}>{m.short}</div><div style={{ fontSize: 12, color: B.dkGray }}>{m.desc}</div></div>
                <div style={{ fontSize: 15, fontWeight: 700, color: B.red }}>฿{PRICING.single}</div>
              </button>
            ); })}

            {/* Promo code redeem — gateway to Claim component (ซ่อนระหว่าง FREE_LAUNCH เพราะทุกบทฟรีอยู่แล้ว) */}
            {PROMO_ENABLED && !FREE_LAUNCH && !load("promo_redeemed", false) && (
              <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ width: "100%", marginTop: 12, padding: "12px 14px", background: B.white, border: `2px dashed ${B.gold}`, borderRadius: 12, cursor: "pointer", display: "flex", alignItems: "center", gap: 12, textAlign: "left" }}>
                <div style={{ width: 36, height: 36, borderRadius: 9, background: `${B.gold}18`, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}><I name="star" size={18} color={B.gold} /></div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: B.black }}>มีโค้ดส่วนลด 100%?</div>
                  <div style={{ fontSize: 11, color: B.dkGray, marginTop: 2 }}>ปลดล็อก {PROMO_FREE_MODULES.length} บทฟรี — ใช้โค้ดที่นี่</div>
                </div>
                <I name="arrow" size={14} color={B.gold} />
              </button>
            )}

            {/* Price tiers */}
            <div style={{ background: `${B.gold}10`, borderRadius: 12, padding: 14, marginTop: 12 }}>
              <div style={{ fontSize: 13, fontWeight: 700, marginBottom: 6 }}>ยิ่งซื้อเยอะยิ่งถูก!</div>
              <div style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.8 }}>
                1 หัวข้อ = ฿{PRICING.single}<br />
                3 หัวข้อ = ฿{PRICING.bundle3} <span style={{ color: B.green }}>(ประหยัด ฿{PRICING.single * 3 - PRICING.bundle3})</span><br />
                Full 6 หัวข้อ + Final = ฿{PRICING.full} <span style={{ color: B.green }}>(ประหยัด ฿{PRICING.single * 6 - PRICING.full})</span>
              </div>
            </div>
          </>
        ) : (
          <div style={{ textAlign: "center", padding: 20 }}>
            <I name="check" size={40} color={B.green} />
            <div style={{ fontSize: 16, fontWeight: 700, marginTop: 10 }}>ซื้อครบทุกหัวข้อแล้ว!</div>
            <button onClick={() => go("course")} style={{ ...css.btn(B.red, B.white), marginTop: 16 }}>เข้าเรียนเลย →</button>
          </div>
        )}
      </div>

      {/* Bottom bar */}
      {selected.length > 0 && (
        <div style={{ position: "fixed", bottom: 0, left: 0, right: 0, background: B.white, padding: "14px 20px", boxShadow: "0 -4px 24px rgba(0,0,0,.1)", zIndex: 100 }}>
          <div style={{ maxWidth: 480, margin: "0 auto", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <div><div style={{ fontSize: 12, color: B.dkGray }}>{selected.length} หัวข้อ</div><div style={{ fontSize: 22, fontWeight: 800, color: B.red }}>฿{total}</div></div>
            <button onClick={() => setStep("payment")} style={css.btn(B.red, B.white)}>ชำระเงิน →</button>
          </div>
        </div>
      )}
    </div>
  );
}
