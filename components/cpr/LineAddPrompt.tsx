"use client";
import { useEffect } from "react";
import { B, LINE_QR_URL } from "@/lib/cpr/config";
import { isSignedUp, load, save, type CprUser } from "@/lib/cpr/storage";
import { genCoupon, getLinkCode, lineLinkDeepLink, markLineAdded, supaRest } from "@/lib/cpr/api";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

export default function LineAddPrompt({ go, user, variant = "post-register" }: { go: Go; user: CprUser | null; variant?: "post-register" | "pre-course" }) {
  const linkCode = getLinkCode();
  const deepLink = lineLinkDeepLink(linkCode);
  const preCourse = variant === "pre-course";
  // หลังสมัครเสร็จ: โชว์คูปอง ฿100 บนจอ (ออก/บันทึกถ้ายังไม่มี — ครอบคลุมทั้ง LINE/Google/Email)
  const coupon = (!preCourse && isSignedUp())
    ? (load<string | null>("coupon", null) || (() => { const c = genCoupon(); save("coupon", c); try { supaRest("promo_codes", "POST", { code: c, type: "online", discount: 100, staff_name: "system" }); } catch (_e) {} return c; })())
    : null;
  // gate ก่อนเรียน = ข้ามได้ (strong-soft) แต่จด line_skipped_at ไว้เพื่อไม่เด้งซ้ำ + ให้แบนเนอร์ในคอร์สตามต่อ
  useEffect(() => {
    safeTrack("line_gate_view", { variant });
    phCapture("line_gate_view", { variant });
  }, [variant]);
  const onAdded = () => { markLineAdded(user); safeTrack("line_oa_confirm_added", { variant }); phCapture("line_oa_confirm_added", { variant }); go("course"); };
  const onSkip = () => { safeTrack("line_oa_skipped", { variant }); phCapture("line_oa_skipped", { variant }); save("line_skipped_at", new Date().toISOString()); go("course"); };
  const onClickLink = () => { safeTrack("line_oa_clicked", { variant, has_link_code: true }); phCapture("line_oa_clicked", { variant, has_link_code: true }); };
  // เข้าเรียนเลย (post-register) — ไม่ขวางก่อนได้คุณค่า; จด line_skipped_at กันเด้งซ้ำ ปล่อยให้แบนเนอร์ในคอร์ส + หน้าใบประกาศตามต่อ
  const onEnterCourse = () => { safeTrack("post_register_enter_course", { variant }); phCapture("post_register_enter_course", { variant }); save("line_skipped_at", new Date().toISOString()); go("course"); };

  // ── post-register: หลังสมัครเสร็จ ดัน "เริ่มเรียนเลย" เป็นปุ่มหลัก, LINE เป็นตัวเลือกเบา ๆ ──
  if (variant === "post-register") {
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <div style={{ fontSize: 16, fontWeight: 700 }}>สมัครสำเร็จ 🎉</div>
        </div>
        <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
          {coupon && (
            <div style={{ ...css.card, textAlign: "center", marginBottom: 14, border: `2px solid ${B.gold}`, background: `${B.gold}10` }}>
              <div style={{ fontSize: 15, fontWeight: 800, color: B.black }}>🎉 สมัครสำเร็จ! รับคูปองส่วนลด ฿100</div>
              <div style={{ fontSize: 26, fontWeight: 800, color: B.red, letterSpacing: 3, fontFamily: "monospace", margin: "10px 0" }}>{coupon}</div>
              <div style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.6 }}>เก็บรหัสนี้ไว้ใช้เป็นส่วนลดคอร์สภาคปฏิบัติ (on-site) — แจ้งตอนจอง หรือกรอกตอนชำระเงิน</div>
            </div>
          )}
          <div style={{ ...css.card, textAlign: "center" }}>
            <div style={{ width: 64, height: 64, borderRadius: "50%", background: `${B.green}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 14px" }}>
              <I name="check" size={34} color={B.green} />
            </div>
            <h2 style={{ fontSize: 19, fontWeight: 800, margin: "0 0 8px" }}>พร้อมเริ่มเรียนแล้ว!</h2>
            <p style={{ fontSize: 13, color: B.dkGray, lineHeight: 1.7, margin: "0 0 18px" }}>เริ่มบทเรียนได้เลย — เรียนจบรับใบประกาศ + คูปองส่วนลดภาคปฏิบัติ</p>
            <button onClick={onEnterCourse} style={{ ...css.btn(B.red, B.white, true), marginBottom: 14 }}>
              เริ่มเรียนเลย →
            </button>
            {/* LINE แบบเบา: ตัวเลือกเสริม ไม่บังคับ — กดได้ถ้าสนใจ ไม่กดก็ไปต่อได้ */}
            <a href={deepLink} onClick={() => { onClickLink(); markLineAdded(user); }} target="_blank" rel="noopener noreferrer"
              style={{ display: "flex", alignItems: "center", gap: 12, background: "#06C75510", border: "1px solid #06C75540", borderRadius: 12, padding: "12px 14px", textDecoration: "none", color: B.black, textAlign: "left" }}>
              <div style={{ minWidth: 38, height: 38, borderRadius: 10, background: "#06C755", display: "flex", alignItems: "center", justifyContent: "center" }}><I name="line" size={22} color={B.white} /></div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13, fontWeight: 700 }}>เพิ่ม LINE @jiacpr <span style={{ color: B.dkGray, fontWeight: 400 }}>(ไม่บังคับ)</span></div>
                <div style={{ fontSize: 11, color: B.dkGray, marginTop: 2 }}>รับใบเซอร์ PDF + เตือนทบทวน + โปรพิเศษ — เพิ่มภายหลังจากในคอร์สก็ได้</div>
              </div>
              <span style={{ fontSize: 12, fontWeight: 700, color: "#06994A" }}>เพิ่ม →</span>
            </a>
          </div>
        </div>
      </div>
    );
  }

  const title = preCourse ? "เพิ่ม LINE ก่อนเริ่มเรียน 🎓" : "อย่าลืมเพิ่ม LINE!";
  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        {preCourse && <button onClick={() => go("landing")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>}
        <div style={{ fontSize: 16, fontWeight: 700 }}>เพิ่ม LINE @jiacpr</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
        {coupon && (
          <div style={{ ...css.card, textAlign: "center", marginBottom: 14, border: `2px solid ${B.gold}`, background: `${B.gold}10` }}>
            <div style={{ fontSize: 15, fontWeight: 800, color: B.black }}>🎉 สมัครสำเร็จ! รับคูปองส่วนลด ฿100</div>
            <div style={{ fontSize: 26, fontWeight: 800, color: B.red, letterSpacing: 3, fontFamily: "monospace", margin: "10px 0" }}>{coupon}</div>
            <div style={{ fontSize: 12, color: B.dkGray, lineHeight: 1.6 }}>เก็บรหัสนี้ไว้ใช้เป็นส่วนลดคอร์สภาคปฏิบัติ (on-site) — แจ้งตอนจอง หรือกรอกตอนชำระเงิน</div>
          </div>
        )}
        <div style={{ ...css.card, textAlign: "center" }}>
          <div style={{ width: 64, height: 64, borderRadius: "50%", background: "#06C75518", display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 14px" }}>
            <I name="line" size={36} color="#06C755" />
          </div>
          <h2 style={{ fontSize: 18, fontWeight: 800, margin: "0 0 8px" }}>{title}</h2>
          {preCourse && <p style={{ fontSize: 13, color: "#06994A", fontWeight: 600, lineHeight: 1.6, margin: "0 0 12px" }}>แอด LINE @jiacpr เพื่อปลดล็อกคอร์สเรียนฟรี + เก็บสิทธิ์ไว้เรียนต่อได้ทุกอุปกรณ์ — ใช้เวลาไม่ถึง 10 วินาที</p>}
          <p style={{ fontSize: 13, color: B.dkGray, lineHeight: 1.7, margin: "0 0 16px" }}>
            แอด LINE @jiacpr เพื่อ:<br />
            <strong style={{ color: B.black }}>✓</strong> รับใบ Certificate แบบ PDF<br />
            <strong style={{ color: B.black }}>✓</strong> แจ้งเตือนทบทวน CPR ทุก 3 เดือน<br />
            <strong style={{ color: B.black }}>✓</strong> รับโปรต่ออายุ + คูปองพิเศษ<br />
            <strong style={{ color: B.black }}>✓</strong> สอบถามได้ตลอด
          </p>
          <div style={{ background: B.white, border: `2px solid ${B.ltGray}`, borderRadius: 14, padding: 12, display: "inline-block", marginBottom: 14 }}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={LINE_QR_URL} alt="LINE QR @jiacpr" width="180" height="180" style={{ display: "block" }} onError={(e) => { (e.target as HTMLImageElement).style.display = "none"; }} />
            <div style={{ fontSize: 13, fontWeight: 700, marginTop: 6, color: "#06C755" }}>@jiacpr</div>
          </div>
          <a href={deepLink} onClick={onClickLink} target="_blank" rel="noopener noreferrer"
            style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15, marginBottom: 8 }}>
            <I name="line" size={22} color={B.white} /> เพิ่มเพื่อน + ผูกบัญชีอัตโนมัติ
          </a>
          <div style={{ fontSize: 11, color: B.dkGray, marginBottom: 12, lineHeight: 1.5 }}>
            (กดปุ่ม → LINE จะเด้งข้อความพร้อมโค้ด <strong style={{ fontFamily: "monospace", color: B.red }}>JIA-LINK-{linkCode}</strong> + ข้อความนัดเรียนภาคปฏิบัติ → กดส่ง = admin รับเรื่อง + ผูกบัญชีให้อัตโนมัติ)
          </div>
          <button onClick={onAdded} style={{ ...css.btn(B.red, B.white, true), marginBottom: 8 }}>
            <I name="check" size={16} color={B.white} /> เพิ่มเพื่อนแล้ว → เข้าเรียนเลย
          </button>
          <button onClick={onSkip} style={{ background: "none", border: "none", color: B.dkGray, fontSize: 12, padding: "8px 12px", cursor: "pointer", textDecoration: "underline" }}>
            ข้ามไปก่อน (เพิ่มได้ทีหลัง)
          </button>
        </div>
      </div>
    </div>
  );
}
