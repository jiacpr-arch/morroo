"use client";

// CTA ท้ายเกม — จังหวะที่ผู้เล่นตั้งใจสูงสุดของทั้ง funnel
//
// ประวัติการตัดสินใจของหน้านี้:
//  1. เดิมเป็นฟอร์มขออีเมลแลกข้อสอบฟรี 10 ข้อ
//  2. ถอดออก (2026-07-25) ตามที่เจ้าของตัดสินใจ: "ต้องการแค่ให้ลูกค้าเข้าในเว็บ
//     แล้วตัดสินใจดีกว่า การเก็บหลีดไม่ค่อยได้ผลแล้วไม่มีพนักงานดูแลต่อ"
//     — lead ค้างที่ stage `new` 40 ราย โดยไม่มีใครตามต่อ
//  3. ตอนนี้ (2026-07-26): "อยากให้เล่นเกมจนจบแล้วจึงแอด LINE หรือล็อกอิน LINE"
//
// LINE จึงเป็นตัวเลือกหลัก — และไม่ขัดกับข้อ 2 เพราะไม่ใช่การเก็บ lead ที่ต้อง
// มีคนตามต่อ:
//   ล็อกอินด้วย LINE → ได้บัญชีจริง ยกยศ/เคสที่เล่นไว้เข้าบัญชีอัตโนมัติ
//   แอด LINE OA     → บอทออกโค้ดทดลองให้เองแล้ว (detectTrialIntent, PR #367)
// ทั้งสองทางไม่ต้องพิมพ์อะไรบนมือถือเลย ต่างจากการกรอกอีเมล
//
// 2026-07-28: ปุ่มแอด OA เปลี่ยนจาก plain add-friend link เป็น LINE "oaMessage"
// prefilled-link (ยิ่งกว่าแตะเดียว — แตะแล้วกดส่งอีกทีในแชท LINE ก็ได้โค้ดเลย
// ไม่ต้องพิมพ์เอง) ข้อความที่พรีฟิลไว้ต้องตรงกับ TRIAL_INTENT_PATTERNS ใน
// lib/bot-intent.ts ไม่งั้นบอทจะไม่ยิงโค้ดให้ทั้งที่ผู้ใช้กดส่งแล้ว
//
// ลิงก์ดูเนื้อหาอื่นยังอยู่ แต่ลงมาเป็นทางเลือกรองสำหรับคนที่ยังไม่อยากผูก LINE
// `casegame_cta_click` เป็นตัววัดปลายทาง แยกด้วย prop `target`

import { useEffect, useRef } from "react";
import Link from "next/link";
import { track } from "@/lib/analytics";
import {
  buildCtaClickProps,
  buildCtaViewProps,
  CASEGAME_EVENTS,
  caseGameCategory,
} from "@/lib/sim/track";

/** LINE Login ยังอยู่หลัง flag เดียวกับหน้า /login — ปิดอยู่ก็ยังเหลือทางแอด OA */
const LINE_LOGIN_ENABLED = process.env.NEXT_PUBLIC_LINE_LOGIN_ENABLED === "true";

/**
 * ข้อความพรีฟิลต้องแมตช์ TRIAL_INTENT_PATTERNS ใน lib/bot-intent.ts (มีคำว่า
 * "ทดลอง" และ "โค้ด" ตรงๆ) ผู้ใช้แค่กดส่งในแชท LINE ก็ถึง handleBotIntent
 * ที่ออกโค้ด monthly_1m ให้อัตโนมัติ — ไม่มีคนตอบ ไม่มีคิวรอ
 */
const LINE_TRIAL_MESSAGE = "ขอโค้ดทดลอง Premium ฟรี";
const LINE_OA_TRIAL_URL = `https://line.me/R/oaMessage/@901nmwcd/?${encodeURIComponent(LINE_TRIAL_MESSAGE)}`;

interface Props {
  slug: string;
  category?: string;
  grade: string | null;
  /** id ของรอบเล่นที่เพิ่งจบ — ผูก view/click เข้ากับ start ตัวเดียวกัน */
  runId: string;
  /** จำนวนเคสที่เก็บไว้ในเครื่อง — ทำให้ข้อเสนอเป็นรูปธรรม ไม่ใช่คำเชิญลอยๆ */
  localRuns?: number;
}

interface BrowseLink {
  href: string;
  label: string;
  /** ค่าที่ส่งเข้า prop `target` ของ casegame_cta_click */
  target: string;
}

/**
 * ปลายทางต่อจากเกม เลือกตามหมวดของเคสที่เพิ่งเล่น — คนที่เพิ่งเล่นเคส Long Case
 * สนใจ Long Case ตัวเต็มมากกว่าคนที่เพิ่งเล่น ACLS ซึ่งใกล้กับข้อสอบ MEQ มากกว่า
 */
function browseLinks(category?: string): BrowseLink[] {
  const nl: BrowseLink = {
    href: "/nl/practice",
    label: "ลองทำข้อสอบจริง ฟรี ไม่ต้องสมัคร",
    target: "browse_nl",
  };

  if (caseGameCategory(category) === "longcase") {
    return [
      { href: "/longcase", label: "ซ้อม Long Case ตัวเต็มกับ AI Examiner", target: "browse_longcase" },
      nl,
    ];
  }

  return [
    nl,
    { href: "/exams", label: "ดูข้อสอบ MEQ แบบ Progressive Case", target: "browse_exams" },
  ];
}

function LineGlyph() {
  return (
    <svg className="cbs-line-glyph" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M12 2C6.48 2 2 6.02 2 11c0 3.39 1.9 6.35 4.75 8.07L6 22l3.29-1.72C10.15 20.73 11.06 21 12 21c5.52 0 10-4.02 10-9S17.52 2 12 2z" />
    </svg>
  );
}

export default function DebriefBrowseCta({
  slug, category, grade, runId, localRuns = 0,
}: Props) {
  const isLongcase = caseGameCategory(category) === "longcase";
  const links = browseLinks(category);

  // ตัวหารของ CTA — คอมโพเนนต์นี้ถูก render เฉพาะตอนจบเกมจริง (ไม่ล็อกอิน,
  // ไม่ใช่โหมดซ้อม) การ mount จึงเท่ากับ "เห็น CTA" กันซ้ำด้วย runId เผื่อ
  // effect ถูกเรียกสองรอบ (StrictMode) หรือ re-render
  const viewedRunRef = useRef("");
  useEffect(() => {
    if (viewedRunRef.current === runId) return;
    viewedRunRef.current = runId;
    track(CASEGAME_EVENTS.ctaView, buildCtaViewProps({ slug, category, grade, runId }));
  }, [runId, slug, category, grade]);

  function handleClick(target: string) {
    track(
      CASEGAME_EVENTS.ctaClick,
      buildCtaClickProps({ slug, category, grade, runId, target })
    );
  }

  return (
    <div className="cbs-browse-cta">
      <p className="cbs-browse-title">
        {localRuns > 0
          ? `คุณเล่นไปแล้ว ${localRuns} เคส`
          : isLongcase
            ? "เคสนี้มาจาก Long Case ของจริง"
            : "เคสนี้อิงแนวทาง ACLS ของจริง"}
      </p>
      <p className="cbs-browse-sub">
        ความคืบหน้าเก็บอยู่ในเครื่องนี้เท่านั้น — ผูกกับ LINE แล้ว
        <b> ยศและเคสที่เล่นไว้จะอยู่กับคุณถาวร</b>
      </p>

      {LINE_LOGIN_ENABLED && (
        <a
          className="cbs-line-btn"
          // next= พากลับเข้าเคสเดิม เพื่อให้ claimPendingLocalRuns ยกประวัติเข้า
          // บัญชีทันทีที่กลับมา ไม่ต้องรอเล่นจบอีกรอบ
          href={`/api/auth/line?mode=register&next=${encodeURIComponent(`/sim/${slug}`)}`}
          onClick={() => handleClick("line_login")}
        >
          <LineGlyph /> เข้าสู่ระบบด้วย LINE
        </a>
      )}

      <a
        className={`cbs-line-btn ${LINE_LOGIN_ENABLED ? "cbs-line-btn-alt" : ""}`}
        href={LINE_OA_TRIAL_URL}
        target="_blank"
        rel="noopener noreferrer"
        onClick={() => handleClick("line_trial")}
      >
        <LineGlyph /> แอด LINE ขอโค้ดทดลอง Premium ฟรี
      </a>
      <p className="cbs-line-note">แตะเดียว กดส่งในแชท — บอทส่งโค้ดให้ทันที</p>

      <div className="cbs-browse-or"><span>หรือดูเนื้อหาอื่นก่อน</span></div>

      {links.map((link) => (
        <Link
          key={link.target}
          href={link.href}
          className="cbs-browse-link"
          onClick={() => handleClick(link.target)}
        >
          {link.label} →
        </Link>
      ))}

      <p className="cbs-login-hint">
        มีบัญชีอยู่แล้ว?{" "}
        <Link href="/login" onClick={() => handleClick("login")}>
          เข้าสู่ระบบ
        </Link>{" "}
        ระบบจะยกเคสที่คุณเล่นไว้ในเครื่องนี้เข้าบัญชีให้ พร้อม XP และยศ
      </p>
    </div>
  );
}
