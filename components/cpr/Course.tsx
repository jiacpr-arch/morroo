"use client";
import { useEffect, useRef, useState } from "react";
import { AUTH_GATE_ENABLED, B, COURSE, ENCOURAGE, FREE_LAUNCH, PRICING, PROMO_ENABLED, PROMO_FREE_MODULES } from "@/lib/cpr/config";
import { getGateVariant, getPurchased, isModuleAccessible, isSignedUp, load, save, type CprProgress, type CprUser } from "@/lib/cpr/storage";
import { genCoupon, getLinkCode, lineLinkDeepLink, markLineAdded, supaRest, syncProgressRemote } from "@/lib/cpr/api";
import { phCapture, safeTrack } from "@/lib/cpr/analytics";
import { css } from "./styles";
import { I } from "./icons";
import MorrooAdBanner from "./MorrooAdBanner";
import { NewsSection } from "./News";
import type { Go, OpenBlog } from "./types";

export default function Course({ go, progress, setProgress, user, openBlog }: { go: Go; progress: CprProgress; setProgress: (p: CprProgress) => void; user: CprUser | null; openBlog: OpenBlog }) {
  const [active, setActive] = useState<number | null>(null);
  const [quiz, setQuiz] = useState(false);
  const [ans, setAns] = useState<Record<number, number>>({});
  const [result, setResult] = useState<{ score: number; correct: number; total: number; passed: boolean } | null>(null);
  const [watched, setWatched] = useState(false);
  const [reviewMode, setReviewMode] = useState(false);
  const [timer, setTimer] = useState(0);
  const [canWatch, setCanWatch] = useState(false);
  const [mustRewatch, setMustRewatch] = useState(false);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const purchased = getPurchased();
  const hasMod = (id: number) => isModuleAccessible(id, purchased);
  const signedUp = isSignedUp();
  const gateOn = AUTH_GATE_ENABLED && getGateVariant() !== "soft"; // ด่านบังคับสมัครหลังจบบท 1
  const unlocked = (id: number) => {
    if (!hasMod(id)) return false;
    if (id === 1) return true; // บทที่ 1 เรียนฟรีเสมอ
    const m = COURSE.modules.find((x) => x.id === id);
    if (m && !m.vid && progress.done.filter((x) => x <= 6).length < 6) return false; // แบบทดสอบสุดท้าย: ต้องเรียน+ผ่านครบ 6 บทก่อน (บังคับแม้ช่วง FREE_LAUNCH)
    if (!(progress.done.includes(id - 1) || FREE_LAUNCH)) return false;
    if (gateOn && !signedUp) return false; // บท 2+ ต้องสมัครก่อน
    return true;
  };
  const done = (id: number) => progress.done.includes(id);

  // Progress (ใช้ร่วมกันทั้งหน้าบทเรียนและหน้ารายการ)
  const total = COURSE.modules.length;
  const doneCount = progress.done.length;
  const pct = Math.round((doneCount / total) * 100);
  const remaining = total - doneCount; // เหลืออีกกี่บทจะจบ + ได้ใบประกาศ
  const cheer =
    remaining === 0
      ? "เรียนครบทุกบทแล้ว! ไปรับใบประกาศได้เลย 🎉"
      : remaining === 1
        ? "เหลืออีกบทเดียวเท่านั้น สู้ๆ ใกล้ได้ใบประกาศแล้ว!"
        : doneCount === 0
          ? "เริ่มบทแรกกันเลย ค่อยๆ เรียนไปทีละบท เป็นกำลังใจให้นะ 💪"
          : remaining <= 3
            ? "เลยครึ่งทางแล้ว อีกนิดเดียวจะจบและได้ใบประกาศ!"
            : "เรียนมาได้ดีมาก ไปต่อได้เลย เป็นกำลังใจให้!";

  // Timer for video watching (90% of duration)
  useEffect(() => {
    if (active && !reviewMode && !progress.done.includes(active)) {
      const mod = COURSE.modules.find((m) => m.id === active);
      if (mod && mod.dur) {
        const target = Math.floor(mod.dur * 0.9);
        setTimer(target);
        setCanWatch(false);
        timerRef.current = setInterval(() => {
          setTimer((prev) => {
            if (prev <= 1) {
              if (timerRef.current) clearInterval(timerRef.current);
              setCanWatch(true);
              return 0;
            }
            return prev - 1;
          });
        }, 1000);
      }
    }
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [active, reviewMode, mustRewatch]);

  const submitQuiz = () => {
    const mod = COURSE.modules.find((m) => m.id === active)!;
    let correct = 0;
    mod.quiz.forEach((q, i) => {
      if (ans[i] === q.a) correct++;
    });
    const score = Math.round((correct / mod.quiz.length) * 100);
    const passed = score >= 80;
    setResult({ score, correct, total: mod.quiz.length, passed });
    if (passed && active && !progress.done.includes(active)) {
      const np: CprProgress = { ...progress, done: [...progress.done, active], scores: { ...progress.scores, [active]: score } };
      setProgress(np);
      save("progress", np);
      syncProgressRemote(np);
      // เก็บคะแนนรายบทลง online_students ตรงๆ (ไม่ผ่าน course_progress) เพื่อให้พนักงานดูคะแนนย่อยได้
      // แม้ผู้เรียนจะลงทะเบียนแบบชื่อ+เบอร์โทรอย่างเดียว ไม่ได้ล็อกอินผ่าน LINE/Google/Email OTP จริง
      const su = user || load<CprUser | null>("user", null);
      if (su?.phone && su?.name) supaRest("online_students", "PATCH", { chapter_scores: np.scores }, `?phone=ilike.*${su.phone.replace(/\D/g, "").slice(-9)}&name=eq.${encodeURIComponent(su.name)}`);
      if (!mod.vid && mod.id === COURSE.modules[COURSE.modules.length - 1].id) {
        const u = user || load<CprUser | null>("user", null);
        const coupon = (() => { const c = load<string | null>("coupon", null); if (c) return c; const nc = genCoupon(); save("coupon", nc); return nc; })();
        if (u) {
          const renew = new Date();
          renew.setMonth(renew.getMonth() + 6);
          supaRest("online_students", "PATCH", { status: "จบคอร์ส ✅", completed_at: new Date().toISOString(), final_score: score, coupon_code: coupon, renew_date: renew.toISOString().split("T")[0] }, `?phone=ilike.*${u.phone.replace(/\D/g, "").slice(-9)}&name=eq.${encodeURIComponent(u.name)}`);
          supaRest("sales_tracking", "POST", { name: u.name, phone: u.phone.replace(/\D/g, ""), completed_date: new Date().toISOString(), score, coupon_code: coupon, follow_status: "ยังไม่ติดต่อ" });
          if (coupon) supaRest("promo_codes", "POST", { code: coupon, type: "online", discount: 100, staff_name: "system" });
        }
      }
    }
  };
  const resetLesson = () => {
    setActive(null);
    setQuiz(false);
    setAns({});
    setResult(null);
    setWatched(false);
    setReviewMode(false);
    setMustRewatch(false);
    setCanWatch(false);
    setTimer(0);
    if (timerRef.current) clearInterval(timerRef.current);
  };
  const formatTime = (s: number) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;

  if (active) {
    const mod = COURSE.modules.find((m) => m.id === active)!;
    const isFinal = !mod.vid;
    const alreadyDone = done(mod.id);
    return (
      <div style={css.page}>
        <div style={css.header(B.black)}>
          <button onClick={resetLesson} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ flex: 1, fontSize: 14, fontWeight: 700, color: B.white }}>{mod.title}</div>
        </div>
        {/* Progress strip — เห็นความคืบหน้าระหว่างเรียน + ให้กำลังใจ */}
        <div style={{ background: B.black, padding: "0 24px 14px" }}>
          <div style={{ maxWidth: 480, margin: "0 auto" }}>
            <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
              <div style={{ flex: 1, height: 6, borderRadius: 3, background: "rgba(255,255,255,.12)" }}><div style={{ height: "100%", borderRadius: 3, background: B.green, width: `${pct}%`, transition: "width .5s" }} /></div>
              <span style={{ fontSize: 12, fontWeight: 600, color: B.white }}>{pct}%</span>
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11, color: "rgba(255,255,255,.6)", marginTop: 5 }}>
              <span>{doneCount}/{total} บทเรียน</span>
              {remaining > 0 && <><span style={{ opacity: 0.5 }}>·</span><I name="cert" size={13} color={B.gold} /><span>อีก {remaining} บท จะจบและรับใบประกาศ</span></>}
            </div>
          </div>
        </div>
        <div style={{ background: `${B.gold}10`, borderBottom: `1px solid ${B.gold}20`, padding: "10px 24px" }}><div style={{ maxWidth: 480, margin: "0 auto", fontSize: 13, fontWeight: 600, color: "#B45309", textAlign: "center" }}>{cheer}</div></div>
        <div style={{ ...css.wrap, paddingTop: 24, paddingBottom: 40 }}>
          {(!quiz && !isFinal) || reviewMode || mustRewatch ? (
            <>
              <div style={{ borderRadius: 16, overflow: "hidden", marginBottom: 16 }}><iframe width="100%" style={{ aspectRatio: "16/9", border: "none", display: "block" }} src={"https://www.youtube.com/embed/" + mod.vid + "?rel=0"} title={mod.title} allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowFullScreen /></div>
              <p style={{ fontSize: 14, color: B.dkGray, lineHeight: 1.6, marginBottom: 16 }}>{mod.desc}</p>

              {mustRewatch ? (
                <>
                  <div style={{ background: `${B.red}08`, borderRadius: 12, padding: 16, marginBottom: 12, textAlign: "center", border: `1px solid ${B.red}20` }}>
                    <I name="warn" size={24} color={B.red} /><div style={{ color: B.red, fontSize: 14, fontWeight: 600, marginTop: 8 }}>สอบไม่ผ่าน — กรุณาดูวิดีโอใหม่ก่อนสอบอีกครั้ง</div>
                  </div>
                  {!canWatch ? (<div style={{ textAlign: "center", color: B.dkGray, fontSize: 13 }}>รอดูวิดีโอ... เหลือ {formatTime(timer)}</div>) : (<button onClick={() => { setMustRewatch(false); setWatched(true); setQuiz(true); setAns({}); setResult(null); }} style={css.btn(B.red, B.white, true)}>ดูจบแล้ว → ทำแบบทดสอบอีกครั้ง</button>)}
                </>
              ) : reviewMode ? (
                <button onClick={resetLesson} style={css.btn(B.black, B.white, true)}>← กลับหน้าบทเรียน</button>
              ) : alreadyDone ? (
                <><div style={{ background: `${B.green}15`, borderRadius: 12, padding: 16, marginBottom: 12, textAlign: "center" }}><div style={{ color: B.green, fontSize: 14, fontWeight: 600 }}>✓ ผ่านบทนี้แล้ว ({progress.scores[mod.id]}%)</div></div><button onClick={resetLesson} style={css.btn(B.black, B.white, true)}>← กลับ</button></>
              ) : !canWatch ? (
                <div style={{ background: `${B.gold}12`, borderRadius: 12, padding: 16, textAlign: "center" }}><div style={{ fontSize: 13, color: B.dkGray }}>กรุณาดูวิดีโอก่อน</div><div style={{ fontSize: 20, fontWeight: 700, color: B.gold, marginTop: 4 }}>{formatTime(timer)}</div></div>
              ) : !watched ? (
                <button onClick={() => setWatched(true)} style={css.btn(B.green, B.white, true)}>ดูวิดีโอจบแล้ว ✓</button>
              ) : (
                <button onClick={() => setQuiz(true)} style={css.btn(B.red, B.white, true)}>ทำแบบทดสอบ →</button>
              )}
            </>
          ) : (
            <div style={css.card}>
              <h3 style={{ fontSize: 16, fontWeight: 700, marginTop: 0, marginBottom: 4 }}>{isFinal ? "แบบทดสอบสุดท้าย" : "แบบทดสอบท้ายบท"}</h3>
              <p style={{ fontSize: 12, color: B.dkGray, margin: "0 0 20px" }}>ต้องได้ 80% ขึ้นไป ({Math.ceil(mod.quiz.length * 0.8)}/{mod.quiz.length} ข้อ)</p>
              {mod.quiz.map((q, qi) => (
                <div key={qi} style={{ marginBottom: 22 }}>
                  <div style={{ fontSize: 14, fontWeight: 600, marginBottom: 8 }}>{qi + 1}. {q.q}</div>
                  {q.c.map((c, ci) => {
                    let bg = B.gray, border = "transparent";
                    if (result) {
                      if (ci === q.a) { bg = `${B.green}18`; border = B.green; }
                      else if (ans[qi] === ci) { bg = `${B.red}12`; border = B.red; }
                    } else if (ans[qi] === ci) { bg = `${B.red}10`; border = B.red; }
                    return <button key={ci} onClick={() => !result && setAns({ ...ans, [qi]: ci })} style={{ display: "block", width: "100%", textAlign: "left", padding: "10px 14px", marginBottom: 5, background: bg, border: `2px solid ${border}`, borderRadius: 8, fontSize: 13, cursor: result ? "default" : "pointer" }}>{c}</button>;
                  })}
                </div>
              ))}
              {!result ? (
                <button onClick={submitQuiz} disabled={Object.keys(ans).length < mod.quiz.length} style={css.btn(Object.keys(ans).length >= mod.quiz.length ? B.red : B.ltGray, Object.keys(ans).length >= mod.quiz.length ? B.white : B.dkGray, true)}>ส่งคำตอบ</button>
              ) : (
                <div style={{ textAlign: "center" }}>
                  <div style={{ background: result.passed ? `${B.green}12` : `${B.red}08`, borderRadius: 12, padding: 20, marginBottom: 16 }}>
                    <div style={{ fontSize: 40, fontWeight: 800, color: result.passed ? B.green : B.red }}>{result.score}%</div>
                    <div style={{ fontSize: 14, fontWeight: 600, color: result.passed ? B.green : B.red }}>{result.passed ? "ผ่าน!" : "ไม่ผ่าน"}</div>
                    <div style={{ fontSize: 12, color: B.dkGray, marginTop: 4 }}>ตอบถูก {result.correct}/{result.total} ข้อ</div>
                  </div>
                  {result.passed && !isFinal && <div style={{ background: `${B.green}08`, borderRadius: 12, padding: "12px 16px", marginBottom: 12, border: `1px solid ${B.green}20` }}><div style={{ fontSize: 14, fontWeight: 600, color: B.green, textAlign: "center" }}>{ENCOURAGE[mod.id] || "เยี่ยมมาก! ไปต่อได้เลย"}</div></div>}
                  {!result.passed && <div style={{ fontSize: 13, color: B.dkGray, marginBottom: 12, textAlign: "center" }}>ไม่เป็นไร ทบทวนวิดีโออีกครั้ง แล้วสอบใหม่ได้เลย</div>}
                  {result.passed ? (
                    <button onClick={() => { const gate = gateOn && mod.id === 1 && !isFinal && !signedUp; resetLesson(); if (isFinal) go("register"); else if (gate) go("signupgate"); }} style={css.btn(B.green, B.white)}>{isFinal ? "ลงทะเบียนรับใบประกาศนียบัตร →" : gateOn && mod.id === 1 && !signedUp ? "สมัครเพื่อรับใบผ่าน + เรียนต่อ →" : "กลับหน้าบทเรียน →"}</button>
                  ) : mod.vid ? (
                    <button onClick={() => { setQuiz(false); setResult(null); setAns({}); setWatched(false); setMustRewatch(true); setCanWatch(false); setTimer(Math.floor((mod.dur || 0) * 0.9)); }} style={css.btn(B.red, B.white)}>← กลับดูวิดีโอใหม่แล้วสอบอีกครั้ง</button>
                  ) : (
                    <button onClick={() => { setAns({}); setResult(null); }} style={css.btn(B.red, B.white)}>ทำใหม่</button>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    );
  }

  return (
    <div style={css.page}>
      <div style={{ background: `linear-gradient(135deg, ${B.black} 0%, #2a2a2a 100%)`, color: B.white, padding: "24px 24px 30px" }}>
        <div style={{ maxWidth: 480, margin: "0 auto" }}>
          <div style={{ fontSize: 11, letterSpacing: 2, opacity: 0.5, textTransform: "uppercase" }}>JIA TRAINER CENTER</div>
          <h2 style={{ fontSize: 20, fontWeight: 700, margin: "4px 0 14px" }}>CPR & AED ออนไลน์</h2>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <div style={{ flex: 1, height: 6, borderRadius: 3, background: "rgba(255,255,255,.12)" }}><div style={{ height: "100%", borderRadius: 3, background: B.green, width: `${pct}%`, transition: "width .5s" }} /></div>
            <span style={{ fontSize: 12, fontWeight: 600 }}>{pct}%</span>
          </div>
          <div style={{ fontSize: 11, opacity: 0.5, marginTop: 4 }}>{progress.done.length}/{COURSE.modules.length} บทเรียน</div>
        </div>
      </div>
      {!load("line_added", false) && (() => {
        const lc = getLinkCode();
        const dl = lineLinkDeepLink(lc);
        return (
          <div style={{ ...css.wrap, paddingTop: 16 }}>
            <a href={dl} target="_blank" rel="noopener noreferrer"
              onClick={() => { safeTrack("line_oa_clicked", { variant: "course-banner", has_link_code: true }); phCapture("line_oa_clicked", { variant: "course-banner", has_link_code: true }); markLineAdded(user); }}
              style={{ display: "flex", alignItems: "center", gap: 12, background: "#06C75512", border: "1px solid #06C75540", borderRadius: 12, padding: "12px 14px", textDecoration: "none", color: B.black }}>
              <div style={{ minWidth: 38, height: 38, borderRadius: 10, background: "#06C755", display: "flex", alignItems: "center", justifyContent: "center" }}><I name="line" size={22} color={B.white} /></div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13, fontWeight: 700 }}>เพิ่ม LINE @jiacpr + ผูกบัญชี</div>
                <div style={{ fontSize: 11, color: B.dkGray, marginTop: 2 }}>รับเตือนทบทวน + โปรต่ออายุ + คูปองพิเศษ อัตโนมัติ</div>
              </div>
              <button onClick={(e) => { e.preventDefault(); markLineAdded(user); window.open(dl, "_blank"); }} style={{ background: "#06C755", color: B.white, border: "none", borderRadius: 8, padding: "8px 12px", fontSize: 12, fontWeight: 700, cursor: "pointer" }}>เพิ่ม →</button>
            </a>
          </div>
        );
      })()}
      <div style={{ ...css.wrap, paddingTop: 20, paddingBottom: 40 }}>
        {doneCount > 0 && remaining > 0 && <div style={{ background: `${B.gold}10`, borderRadius: 12, padding: "12px 16px", marginBottom: 12, border: `1px solid ${B.gold}30`, textAlign: "center" }}><div style={{ fontSize: 13, fontWeight: 600, color: "#B45309" }}>{cheer}</div><div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 5, fontSize: 11, color: "#B45309", opacity: 0.8, marginTop: 4 }}><I name="cert" size={12} color={B.gold} /><span>อีก {remaining} บท จะจบและรับใบประกาศ</span></div></div>}
        {COURSE.modules.map((m) => {
          const owns = hasMod(m.id);
          const ok = unlocked(m.id);
          const dn = done(m.id);
          const fin = !m.vid;
          const needBuy = !owns && !FREE_LAUNCH && m.id <= 6;
          const gateLock = gateOn && !signedUp && m.id >= 2 && (progress.done.includes(m.id - 1) || FREE_LAUNCH);
          return (
            <button key={m.id} onClick={() => { if (needBuy) { go("store"); return; } if (!ok) { if (gateLock) go("signupgate"); else if (fin) alert("กรุณาเรียนและผ่านแบบทดสอบให้ครบทั้ง 6 บทก่อน จึงจะทำแบบทดสอบสุดท้ายได้"); return; } setActive(m.id); if (fin) setQuiz(true); else if (dn) setReviewMode(true); }} style={{ display: "flex", width: "100%", gap: 12, alignItems: "center", padding: 14, marginBottom: 8, background: needBuy ? `${B.gold}06` : B.white, border: dn ? `2px solid ${B.green}` : needBuy ? `1px dashed ${B.gold}` : "2px solid transparent", borderRadius: 14, cursor: ok || needBuy || gateLock ? "pointer" : "not-allowed", opacity: ok || needBuy || gateLock ? 1 : 0.5, textAlign: "left" }}>
              <div style={{ minWidth: 42, height: 42, borderRadius: 11, background: dn ? B.green : needBuy ? `${B.gold}18` : fin ? `${B.gold}18` : `${B.red}10`, display: "flex", alignItems: "center", justifyContent: "center" }}>{dn ? <I name="check" size={18} color={B.white} /> : needBuy ? <I name="lock" size={16} color={B.gold} /> : !ok ? <I name="lock" size={16} color={gateLock ? "#06C755" : B.dkGray} /> : fin ? <I name="cert" size={18} color={B.gold} /> : <I name="play" size={16} color={B.red} />}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13, fontWeight: 600 }}>{m.title}</div>
                <div style={{ fontSize: 12, color: needBuy ? B.gold : gateLock ? "#06994A" : B.dkGray, marginTop: 2 }}>{dn ? (fin ? `✓ ผ่านแล้ว (${progress.scores[m.id]}%)` : `✓ ผ่านแล้ว • กดเพื่อดูวิดีโอซ้ำ`) : needBuy ? `฿${PRICING.single} — กดเพื่อซื้อ` : gateLock ? "🔓 สมัครฟรีเพื่อปลดล็อก" : fin && !ok ? "🔒 เรียนให้ครบทุกบทก่อน จึงทำแบบทดสอบได้" : m.vid ? `วิดีโอ + ${m.quiz.length} คำถาม` : `${m.quiz.length} คำถาม • ต้องได้ 80%`}</div>
              </div>
              {needBuy ? <span style={{ fontSize: 14, fontWeight: 700, color: B.gold }}>฿{PRICING.single}</span> : ok && !dn ? <I name="arrow" size={14} color={B.dkGray} /> : ok && dn && m.vid ? <I name="replay" size={14} color={B.green} /> : null}
            </button>
          );
        })}
        {PROMO_ENABLED && !FREE_LAUNCH && !load("promo_redeemed", false) && purchased.filter((x) => x <= 6).length < 3 && (
          <button onClick={() => { save("claim_start_redeem", true); go("claim"); }} style={{ width: "100%", marginTop: 8, padding: "14px 16px", background: `${B.gold}12`, border: `1px dashed ${B.gold}`, borderRadius: 12, cursor: "pointer", display: "flex", alignItems: "center", gap: 10, textAlign: "left" }}>
            <I name="star" size={20} color={B.gold} />
            <div style={{ flex: 1, fontSize: 13, fontWeight: 600, color: B.black }}>ปลดล็อก {PROMO_FREE_MODULES.length} บทฟรีด้วยโค้ดส่วนลด <span style={{ fontWeight: 400, color: B.dkGray }}>— ใช้เวลา 30 วิ</span></div>
            <I name="arrow" size={14} color={B.gold} />
          </button>
        )}
        {!FREE_LAUNCH && purchased.filter((x) => x <= 6).length < 6 && <button onClick={() => go("store")} style={{ ...css.btn(B.gold, B.black, true), marginTop: 8, fontSize: 14 }}>ซื้อเพิ่ม / Full Course ฿{PRICING.full} →</button>}
        {pct === 100 && <button onClick={() => go(load("enrolled", false) ? "certificate" : "register")} style={{ ...css.btn(B.gold, B.black, true), marginTop: 16 }}>{load("enrolled", false) ? "ดูใบประกาศนียบัตร & คูปอง →" : "ลงทะเบียนรับใบประกาศนียบัตร →"}</button>}
        {/* Mini cert per module */}
        {progress.done.filter((id) => id <= 6).length > 0 && progress.done.filter((id) => id <= 6).length < 7 && <button onClick={() => go("minicert")} style={{ ...css.btn(B.white, B.dkGray, true), marginTop: 8, border: `1px solid ${B.ltGray}`, fontSize: 13 }}>ดูใบ Mini Certificate →</button>}
        <div style={{ marginTop: 20 }}><MorrooAdBanner /></div>
        <button onClick={() => { if (confirm("ต้องการเริ่มใหม่ / เปลี่ยนคนเรียน?\n\nข้อมูลการเรียนจะถูกล้าง")) { ["jia_user", "jia_enrolled", "jia_progress", "jia_coupon", "jia_last_page"].forEach((k) => localStorage.removeItem(k)); window.location.reload(); } }} style={{ ...css.btn(B.gray, B.dkGray, true), marginTop: 12, fontSize: 13 }}>เริ่มใหม่ / เปลี่ยนคนเรียน</button>
      </div>
      {progress.done.length >= 4 && <NewsSection openBlog={openBlog} goAll={() => go("blog")} title="บทความ CPR เพิ่มเติม" subtitle={pct === 100 ? "ทักษะ CPR เสื่อมใน 3-6 เดือน — แวะอ่านทบทวนได้ตลอด" : "เก่งมาก! ใกล้จบแล้ว — มีบทความทบทวนให้อ่านเพิ่ม"} cprOnly={true} max={5} />}
    </div>
  );
}
