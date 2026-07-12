"use client";
// ควิซเกริ่นนำหน้าแรก — 5 ข้อ ทีละข้อ + รูป + feedback ทันที (ตอบผิดไปต่อได้) → จอสรุป → ปุ่มสมัคร
import { useEffect, useState } from "react";
import { B, TEASER_QUIZ, type TeaserItem } from "@/lib/cpr/config";
import { save } from "@/lib/cpr/storage";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";
import { css } from "./styles";
import { I } from "./icons";
import type { Go } from "./types";

function TeaserQuizImg({ item }: { item: TeaserItem }) {
  const [broken, setBroken] = useState(false);
  if (broken || !item.img)
    return (
      <div style={{ width: "100%", aspectRatio: "16/10", borderRadius: 14, background: `linear-gradient(135deg, ${B.red}10, ${B.gold}12)`, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 6, marginBottom: 16, border: `1px solid ${B.ltGray}` }}>
        <div style={{ fontSize: 56, lineHeight: 1 }}>{item.emoji || "❤️"}</div>
      </div>
    );
  // eslint-disable-next-line @next/next/no-img-element
  return <img src={item.img} alt="" onError={() => setBroken(true)} style={{ width: "100%", aspectRatio: "16/10", objectFit: "cover", borderRadius: 14, marginBottom: 16, display: "block", background: B.gray }} />;
}

export default function TeaserQuiz({ go }: { go: Go }) {
  const [idx, setIdx] = useState(0);
  const [picked, setPicked] = useState<number | null>(null); // index ที่เลือกในข้อปัจจุบัน (null = ยังไม่เลือก)
  const [correct, setCorrect] = useState(0);
  const [finished, setFinished] = useState(false);
  useEffect(() => {
    safeTrack("teaser_quiz_view", {});
    phCapture("teaser_quiz_view", {});
  }, []);
  const total = TEASER_QUIZ.length;
  const item = TEASER_QUIZ[idx];

  const choose = (ci: number) => {
    if (picked !== null) return;
    setPicked(ci);
    if (ci === item.a) setCorrect((c) => c + 1);
  };
  const next = () => {
    if (idx + 1 < total) {
      setIdx(idx + 1);
      setPicked(null);
    } else {
      const score = correct;
      setFinished(true);
      safeTrack("teaser_quiz_complete", { score, total });
      phCapture("teaser_quiz_complete", { score, total });
    }
  };
  const startSignup = () => {
    save("teaser_done", true);
    go("signupgate");
  };

  if (finished) {
    return (
      <div style={css.page}>
        <div style={{ ...css.wrap, paddingTop: 40, paddingBottom: 40 }}>
          <div style={{ ...css.card, textAlign: "center" }}>
            <div style={{ fontSize: 56, marginBottom: 8 }}>🎉</div>
            <h2 style={{ fontSize: 22, fontWeight: 800, margin: "0 0 6px" }}>เก่งมาก! ทำได้ {correct}/{total} ข้อ</h2>
            <p style={{ fontSize: 14, color: B.dkGray, lineHeight: 1.7, margin: "0 0 20px" }}>นี่เป็นแค่น้ำจิ้ม 😉 คอร์สเต็มมีวิดีโอสอนละเอียด + ฝึกจริง + ใบประกาศนียบัตร<br /><strong style={{ color: B.black }}>สมัครฟรีเพื่อปลดคอร์สทั้งหมด + รับคูปองส่วนลด ฿100</strong></p>
            <button onClick={startSignup} style={{ ...css.btn(B.red, B.white, true), marginBottom: 10 }}>สมัครฟรี & เริ่มเรียน →</button>
            <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ ...css.btn(B.white, B.red, true), border: `1px solid ${B.red}`, marginBottom: 10 }}>🎟️ มีโค้ดแล้ว? ใส่โค้ดเลย →</button>
            <button onClick={() => { save("teaser_done", true); go("landing"); }} style={{ background: "none", border: "none", color: B.dkGray, fontSize: 13, padding: "6px 12px", cursor: "pointer", textDecoration: "underline" }}>ดูรายละเอียดคอร์สก่อน</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <div style={{ fontSize: 16, fontWeight: 800 }}>JIA TRAINER CENTER</div>
        <div style={{ flex: 1 }} />
        <div style={{ fontSize: 12, fontWeight: 700, opacity: 0.9 }}>ทดสอบความรู้ CPR</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 20, paddingBottom: 40 }}>
        {/* progress dots */}
        <div style={{ display: "flex", gap: 6, justifyContent: "center", marginBottom: 16 }}>
          {TEASER_QUIZ.map((_, i) => <div key={i} style={{ width: i === idx ? 22 : 8, height: 8, borderRadius: 4, background: i < idx ? B.green : i === idx ? B.red : B.ltGray, transition: "all .3s" }} />)}
        </div>
        <div style={css.card}>
          <TeaserQuizImg item={item} />
          <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 4 }}>ข้อ {idx + 1} จาก {total}</div>
          <h3 style={{ fontSize: 17, fontWeight: 700, margin: "0 0 16px", lineHeight: 1.5 }}>{item.q}</h3>
          {item.c.map((c, ci) => {
            let bg = B.gray, border = "transparent";
            const color = B.black;
            if (picked !== null) {
              if (ci === item.a) { bg = `${B.green}18`; border = B.green; }
              else if (ci === picked) { bg = `${B.red}12`; border = B.red; }
            }
            return (
              <button key={ci} onClick={() => choose(ci)} disabled={picked !== null} style={{ display: "flex", alignItems: "center", gap: 10, width: "100%", textAlign: "left", padding: "13px 16px", marginBottom: 8, background: bg, border: `2px solid ${border}`, borderRadius: 10, fontSize: 14, color, cursor: picked === null ? "pointer" : "default" }}>
                <span style={{ flex: 1 }}>{c}</span>
                {picked !== null && ci === item.a && <I name="check" size={18} color={B.green} />}
              </button>
            );
          })}
          {picked !== null && (
            <div style={{ background: `${B.gold}10`, borderRadius: 10, padding: "10px 14px", margin: "6px 0 12px", fontSize: 13, color: "#92600A", textAlign: "center" }}>
              {picked === item.a ? "✅ ถูกต้อง! " : "💡 "}{item.hint}
            </div>
          )}
          {picked !== null && <button onClick={next} style={css.btn(B.red, B.white, true)}>{idx + 1 < total ? "ข้อต่อไป →" : "ดูผลลัพธ์ →"}</button>}
        </div>
        <div style={{ textAlign: "center", marginTop: 14, display: "flex", flexDirection: "column", gap: 6 }}>
          <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ background: "none", border: `1px solid ${B.red}`, borderRadius: 10, color: B.red, fontSize: 13, fontWeight: 700, padding: "9px 12px", cursor: "pointer" }}>🎟️ มีโค้ดแล้ว? ใส่โค้ดเข้าเรียนเลย →</button>
          <button onClick={() => { save("teaser_done", true); go("signupgate"); }} style={{ background: "none", border: "none", color: B.dkGray, fontSize: 12, padding: 6, cursor: "pointer", textDecoration: "underline" }}>ข้ามไปสมัครเลย</button>
        </div>
      </div>
    </div>
  );
}
