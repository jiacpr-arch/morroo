"use client";

// CTA ท้ายเกม — จังหวะที่ผู้เล่นตั้งใจสูงสุดของทั้ง funnel
//
// เดิมตรงนี้เป็นฟอร์มขออีเมลแลกข้อสอบฟรี 10 ข้อ ถอดออกแล้วตามที่เจ้าของตัดสินใจ
// (2026-07-25): "ต้องการแค่ให้ลูกค้าเข้าในเว็บแล้วตัดสินใจดีกว่า การเก็บหลีด
// ไม่ค่อยได้ผลแล้วไม่มีพนักงานดูแลต่อ" — lead ที่เก็บมาค้างที่ stage `new` 40 ราย
// โดยไม่มีใครตามต่อ การขออีเมลจึงเป็นแค่ friction ที่ไม่ได้แปลงเป็นอะไร
//
// แทนที่ด้วยทางออกไปดูเนื้อหาจริงในเว็บ ซึ่งเป็นสิ่งที่คนเพิ่งเล่นจบอยากได้ต่อ
// จริง ๆ และไม่ต้องมีคนคอยดูแลหลังบ้าน `casegame_cta_click` กลายเป็นตัววัด
// ปลายทางแทน `casegame_lead`

import { useEffect, useRef } from "react";
import Link from "next/link";
import { track } from "@/lib/analytics";
import {
  buildCtaClickProps,
  buildCtaViewProps,
  CASEGAME_EVENTS,
  caseGameCategory,
} from "@/lib/sim/track";

interface Props {
  slug: string;
  category?: string;
  grade: string | null;
  /** id ของรอบเล่นที่เพิ่งจบ — ผูก view/click เข้ากับ start ตัวเดียวกัน */
  runId: string;
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

export default function DebriefBrowseCta({ slug, category, grade, runId }: Props) {
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
        {isLongcase ? "เคสนี้มาจาก Long Case ของจริง" : "เคสนี้อิงแนวทาง ACLS ของจริง"}
      </p>
      <p className="cbs-browse-sub">
        ของจริงในเว็บมีให้ฝึกอีกเพียบ — <b>เข้าไปดูได้เลย ไม่ต้องกรอกอะไร</b>
      </p>

      {links.map((link) => (
        <Link
          key={link.target}
          href={link.href}
          className="cbs-btn-main cbs-browse-btn"
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
