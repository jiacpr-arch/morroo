"use client";
import { useEffect, useRef, useState } from "react";
import { B, CERT_DECO, LINE_URL, SERIF, SITE_URL } from "@/lib/cpr/config";
import { load, save, type CprUser } from "@/lib/cpr/storage";
import { genCoupon, getLinkCode, lineLinkDeepLink, supaRest } from "@/lib/cpr/api";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";
import { captureNodeToPng, dataUrlToBlob, deliverBlob, sanitizeFileName } from "@/lib/cpr/cert";
import { css } from "./styles";
import { I, Logo } from "./icons";
import MorrooAdBanner from "./MorrooAdBanner";
import type { Go } from "./types";

export default function Certificate({ user, go }: { user: CprUser | null; go: Go }) {
  const d = new Date();
  const ds = `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear() + 543}`;
  const coupon = load<string | null>("coupon", null) || (() => { const c = genCoupon(); save("coupon", c); return c; })();
  const certRef = useRef<HTMLDivElement>(null);
  const [gen, setGen] = useState<null | "img" | "pdf">(null);
  const fileBase = `JIA_Certificate_${sanitizeFileName(user?.name)}`;
  // ===== Strong-soft LINE gate =====
  const lc = getLinkCode();
  const [lineLinked, setLineLinked] = useState(() => load("line_linked", false));
  const [linkWaiting, setLinkWaiting] = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);
  // fallback สุดท้าย ถ้าสร้างไฟล์ไม่สำเร็จ — บอกผู้ใช้ screenshot เอง
  const saveCertFallback = () => {
    alert("บันทึกอัตโนมัติไม่สำเร็จ กรุณา screenshot หน้าจอเพื่อบันทึกใบประกาศนียบัตร\n\niPhone: กดปุ่ม Power + Volume Up\nAndroid: กดปุ่ม Power + Volume Down\n\nรหัสคูปอง: " + coupon);
  };
  const downloadImage = async () => {
    if (gen || !certRef.current) return;
    setGen("img");
    try {
      const dataUrl = await captureNodeToPng(certRef.current);
      await deliverBlob(await dataUrlToBlob(dataUrl), `${fileBase}.png`, "image/png");
      safeTrack("cert_download", { format: "png" });
    } catch (_e) {
      safeTrack("cert_download_error", { format: "png" });
      saveCertFallback();
    } finally {
      setGen(null);
    }
  };
  const downloadPDF = async () => {
    if (gen || !certRef.current) return;
    setGen("pdf");
    try {
      const dataUrl = await captureNodeToPng(certRef.current);
      const { jsPDF } = await import("jspdf");
      const img = new Image();
      await new Promise((res, rej) => { img.onload = res; img.onerror = rej; setTimeout(() => rej(new Error("img timeout")), 8000); img.src = dataUrl; });
      const pr = Math.max(2, window.devicePixelRatio || 1);
      const wMm = ((img.width / pr) * 25.4) / 96, hMm = ((img.height / pr) * 25.4) / 96;
      const pdf = new jsPDF({ orientation: wMm >= hMm ? "landscape" : "portrait", unit: "mm", format: [wMm, hMm] });
      pdf.addImage(dataUrl, "PNG", 0, 0, wMm, hMm, undefined, "FAST");
      await deliverBlob(pdf.output("blob"), `${fileBase}.pdf`, "application/pdf");
      safeTrack("cert_download", { format: "pdf" });
    } catch (_e) {
      safeTrack("cert_download_error", { format: "pdf" });
      saveCertFallback();
    } finally {
      setGen(null);
    }
  };
  const CERT_W = 900, CERT_H = 636;
  const wrapRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(0.5);
  useEffect(() => {
    const el = wrapRef.current;
    if (!el) return;
    const update = () => setScale(Math.min(1, el.clientWidth / CERT_W));
    update();
    const ro = new ResizeObserver(update);
    ro.observe(el);
    return () => ro.disconnect();
  }, []);
  useEffect(() => () => { if (pollRef.current) clearInterval(pollRef.current); }, []);
  // เปิด LINE พร้อมโค้ด แล้ว poll หา line_user_id ที่ webhook เขียนกลับมา = ยืนยันการผูกจริง
  const startLineLink = () => {
    safeTrack("line_oa_clicked", { variant: "certificate", has_link_code: true });
    phCapture("line_oa_clicked", { variant: "certificate", has_link_code: true });
    const u = user || load<CprUser | null>("user", null);
    const tail = u?.phone ? u.phone.replace(/\D/g, "").slice(-9) : null;
    // ผูกโค้ดนี้กับเรคคอร์ดลูกค้า เพื่อให้ webhook จับคู่ได้แน่นอน
    if (tail) supaRest("customers", "PATCH", { line_link_code: lc }, `?tel=ilike.*${tail}`);
    setLinkWaiting(true);
    if (pollRef.current) clearInterval(pollRef.current);
    let tries = 0;
    pollRef.current = setInterval(async () => {
      tries++;
      if (tail) {
        const rows = await supaRest("customers", "GET", null, `?tel=ilike.*${tail}&select=line_user_id&limit=1`);
        if (Array.isArray(rows) && rows[0]?.line_user_id) {
          if (pollRef.current) clearInterval(pollRef.current);
          pollRef.current = null;
          save("line_linked", true);
          save("line_added", true);
          setLineLinked(true);
          setLinkWaiting(false);
          safeTrack("line_oa_linked", { variant: "certificate" });
          phCapture("line_oa_linked", { variant: "certificate" });
          return;
        }
      }
      if (tries >= 40) {
        if (pollRef.current) clearInterval(pollRef.current);
        pollRef.current = null;
        setLinkWaiting(false);
      }
    }, 3000);
  };
  return (
    <div style={{ ...css.page, padding: 20 }}>
      <div style={{ maxWidth: 480, margin: "0 auto" }}>
        <div style={{ textAlign: "center", marginBottom: 24 }}>
          <div style={{ width: 76, height: 76, borderRadius: "50%", background: `${B.gold}18`, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 auto 16px" }}><I name="star" size={38} color={B.gold} /></div>
          <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 6px" }}>ยินดีด้วย!</h2>
          <p style={{ fontSize: 14, color: B.dkGray }}>คุณผ่านคอร์ส CPR & AED ออนไลน์แล้ว</p>
        </div>
        <div ref={wrapRef} style={{ width: "100%", height: CERT_H * scale, overflow: "hidden", borderRadius: 12, boxShadow: "0 8px 32px rgba(0,0,0,.12)" }}>
          <div style={{ width: CERT_W, height: CERT_H, transform: `scale(${scale})`, transformOrigin: "top left" }}>
            <div ref={certRef} style={{ position: "relative", width: CERT_W, height: CERT_H, boxSizing: "border-box", background: "#FFFDF7", overflow: "hidden" }}>
              <div style={{ position: "absolute", inset: 0 }} dangerouslySetInnerHTML={{ __html: CERT_DECO }} />
              <div style={{ position: "absolute", top: 22, left: 0, right: 0, display: "flex", justifyContent: "center" }}><Logo size={240} /></div>
              <div style={{ position: "absolute", top: 210, left: 0, right: 0, textAlign: "center", fontFamily: SERIF, fontSize: 40, fontWeight: 600, lineHeight: 1, color: "#0E1E3C" }}>ใบประกาศนียบัตร</div>
              <div style={{ position: "absolute", top: 260, left: 0, right: 0, textAlign: "center", fontFamily: SERIF, fontSize: 13, fontWeight: 700, letterSpacing: 4, color: "#B8862F" }}>CERTIFICATE OF COMPLETION</div>
              <div style={{ position: "absolute", top: 292, left: 0, right: 0, textAlign: "center", fontSize: 15, lineHeight: 1, color: B.dkGray }}>ขอมอบใบประกาศนียบัตรฉบับนี้เพื่อแสดงว่า</div>
              <div style={{ position: "absolute", top: 322, left: 0, right: 0, textAlign: "center", fontFamily: SERIF, fontSize: 42, fontWeight: 600, lineHeight: 1, color: "#0E1E3C" }}>{user?.name || "ชื่อผู้เรียน"}</div>
              <div style={{ position: "absolute", top: 392, left: 70, right: 70, textAlign: "center", fontSize: 14, color: B.dkGray }}>ได้ผ่านการอบรม <strong style={{ color: "#0E1E3C" }}>ภาคทฤษฎี (ออนไลน์)</strong></div>
              <div style={{ position: "absolute", top: 412, left: 70, right: 70, textAlign: "center", fontSize: 14, fontWeight: 700, color: B.black }}>หลักสูตรการช่วยชีวิตขั้นพื้นฐาน CPR &amp; AED · มาตรฐาน 2025</div>
              <div style={{ position: "absolute", top: 436, left: 0, right: 0, textAlign: "center", fontSize: 12.5, fontWeight: 600, color: B.red }}>ขอเชิญฝึกภาคปฏิบัติกับผู้สอนตัวจริง เพื่อช่วยชีวิตได้อย่างมั่นใจ</div>
              <div style={{ position: "absolute", top: 484, left: 0, right: 0, textAlign: "center", fontSize: 12.5, fontWeight: 600, color: "#FFF9E8" }}>ส่วนลด ฿100 คอร์ส On-site</div>
              <div style={{ position: "absolute", top: 506, left: 0, right: 0, textAlign: "center", fontSize: 15, fontWeight: 800, letterSpacing: 1, color: "#F3DB8E", fontFamily: "monospace" }}>• {coupon} •</div>
              <div style={{ position: "absolute", top: 548, left: 50, width: 220, textAlign: "center" }}>
                <div style={{ fontSize: 16, fontWeight: 600, color: B.black }}>{ds}</div>
                <div style={{ borderTop: `1.5px solid ${B.gold}`, marginTop: 6, paddingTop: 6, fontSize: 12, color: B.dkGray }}>วันที่ออกใบประกาศ</div>
              </div>
              <div style={{ position: "absolute", top: 548, right: 50, width: 220, textAlign: "center" }}>
                <div style={{ fontFamily: SERIF, fontSize: 15, fontWeight: 600, color: "#0E1E3C" }}>JIA TRAINER CENTER</div>
                <div style={{ borderTop: `1.5px solid ${B.gold}`, marginTop: 6, paddingTop: 6, fontSize: 12, color: B.dkGray }}>ศูนย์ฝึกอบรม CPR &amp; AED</div>
              </div>
              <div style={{ position: "absolute", bottom: 14, left: 0, right: 0, textAlign: "center", fontSize: 11, color: B.dkGray }}>088-558-8078 | cpr.morroo.com | LINE: @jiacpr</div>
            </div>
          </div>
        </div>
        {/* ===== LINE invite (โปรโมชัน ไม่บล็อกการดาวน์โหลด) ===== */}
        {lineLinked ? (
          <div style={{ background: `${B.green}14`, border: `1px solid ${B.green}66`, borderRadius: 12, padding: "12px 14px", marginTop: 16, textAlign: "center", fontSize: 14, fontWeight: 700, color: B.black }}>
            ✓ ผูก LINE @jiacpr เรียบร้อย — จะได้รับใบเซอร์ เตือนทบทวน และโปรทาง LINE
          </div>
        ) : (
          <div style={{ background: "#06C75510", border: "2px solid #06C75540", borderRadius: 16, padding: 18, marginTop: 16, textAlign: "center" }}>
            <I name="line" size={32} color="#06C755" />
            <div style={{ fontSize: 16, fontWeight: 800, color: B.black, margin: "8px 0 4px" }}>ผูก LINE @jiacpr รับคูปอง + เตือนทบทวน</div>
            <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 12, lineHeight: 1.6 }}>แอดแล้วผูกบัญชี รับเพิ่ม: คูปองส่วนลด on-site ฿100 · ใบประกาศทาง LINE · เตือนทบทวน CPR ทุก 3 เดือน</div>
            <a href={lineLinkDeepLink(lc)} onClick={startLineLink} target="_blank" rel="noopener noreferrer"
              style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, background: "#06C755", borderRadius: 12, padding: "14px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 15 }}>
              <I name="line" size={22} color={B.white} /> ผูก LINE รับคูปอง + ใบเซอร์
            </a>
            <div style={{ fontSize: 11, color: B.dkGray, marginTop: 8, lineHeight: 1.5 }}>
              (LINE จะเด้งข้อความพร้อมโค้ด <strong style={{ fontFamily: "monospace", color: B.red }}>JIA-LINK-{lc}</strong> + ข้อความนัดเรียนภาคปฏิบัติ → <strong>กดส่ง</strong> ในแชต @jiacpr = ผูกบัญชีอัตโนมัติ)
            </div>
            {linkWaiting && (
              <div style={{ marginTop: 12, fontSize: 13, fontWeight: 700, color: "#06A047" }}>⏳ กำลังรอการยืนยัน... กดส่งข้อความในแอป LINE แล้วรอสักครู่</div>
            )}
          </div>
        )}

        {/* ดาวน์โหลด + คูปอง: แสดงเสมอ ไม่ต้องผูก/ข้าม LINE ก่อน */}
        <button onClick={downloadImage} disabled={!!gen} style={{ ...css.btn(B.black, B.white, true), marginTop: 16, display: "flex", alignItems: "center", justifyContent: "center", gap: 8, opacity: gen ? 0.6 : 1, cursor: gen ? "default" : "pointer" }}><I name="save" size={18} color={B.white} /> {gen === "img" ? "กำลังสร้างรูป..." : "บันทึกเป็นรูปภาพ"}</button>
        <button onClick={downloadPDF} disabled={!!gen} style={{ ...css.btn(B.white, B.black, true), marginTop: 10, border: `1px solid ${B.ltGray}`, display: "flex", alignItems: "center", justifyContent: "center", gap: 8, opacity: gen ? 0.6 : 1, cursor: gen ? "default" : "pointer" }}><I name="cert" size={18} color={B.black} /> {gen === "pdf" ? "กำลังสร้าง PDF..." : "ดาวน์โหลด PDF"}</button>
        <div style={{ background: `${B.red}08`, borderRadius: 16, padding: 20, marginTop: 16, textAlign: "center" }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: B.red, marginBottom: 4 }}>คูปองส่วนลด ฿100 สำหรับคอร์ส On-site!</div>
          <div style={{ fontSize: 22, fontWeight: 800, color: B.red, letterSpacing: 3, fontFamily: "monospace", marginBottom: 12 }}>{coupon}</div>
          <button onClick={() => go("booking")} style={{ ...css.btn(B.red, B.white, true), display: "block", width: "100%", textAlign: "center", cursor: "pointer" }}>จองคอร์ส On-site ใช้คูปองส่วนลด →</button>
          <a href={LINE_URL} target="_blank" rel="noopener noreferrer" onClick={() => { safeTrack("line_oa_clicked", { variant: "certificate-inquire" }); phCapture("line_oa_clicked", { variant: "certificate-inquire" }); }} style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 10, marginTop: 10, background: "#06C755", borderRadius: 12, padding: "12px 24px", color: B.white, textDecoration: "none", fontWeight: 700, fontSize: 14 }}><I name="line" size={22} color={B.white} /> สอบถามทาง LINE @jiacpr</a>
        </div>
        <button onClick={() => { const txt = "ฉันผ่านคอร์ส CPR & AED ออนไลน์แล้ว! เรียนฟรีที่ " + SITE_URL; if (navigator.share) navigator.share({ title: "JIA CPR Online", text: txt, url: SITE_URL }); else window.open("https://social-plugins.line.me/lineit/share?url=" + encodeURIComponent(SITE_URL) + "&text=" + encodeURIComponent(txt), "_blank"); }} style={{ ...css.btn("#06C755", B.white, true), marginTop: 14, display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>แชร์ให้เพื่อนเรียนด้วย</button>
        <div style={{ marginTop: 20 }}><MorrooAdBanner /></div>
        <button onClick={() => go("course")} style={{ ...css.btn(B.white, B.black, true), marginTop: 10, border: `1px solid ${B.ltGray}` }}>← กลับหน้าบทเรียน</button>
        <button onClick={() => { if (confirm("ต้องการเริ่มใหม่ / เปลี่ยนคนเรียน?")) { ["jia_user", "jia_enrolled", "jia_progress", "jia_coupon", "jia_last_page"].forEach((k) => localStorage.removeItem(k)); window.location.reload(); } }} style={{ ...css.btn(B.gray, B.dkGray, true), marginTop: 8, fontSize: 13 }}>เริ่มใหม่ / เปลี่ยนคนเรียน</button>
      </div>
    </div>
  );
}
