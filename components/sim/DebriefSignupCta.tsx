"use client";

// CTA ท้ายเกม — จังหวะที่ผู้เล่นตั้งใจสูงสุดของทั้ง funnel
//
// ประวัติการตัดสินใจของหน้านี้ (เดิมชื่อ DebriefBrowseCta.tsx):
//  1. เดิมเป็นฟอร์มขออีเมลแลกข้อสอบฟรี 10 ข้อ
//  2. ถอดออก (2026-07-25) ตามที่เจ้าของตัดสินใจ: "ต้องการแค่ให้ลูกค้าเข้าในเว็บ
//     แล้วตัดสินใจดีกว่า การเก็บหลีดไม่ค่อยได้ผลแล้วไม่มีพนักงานดูแลต่อ"
//     — lead ค้างที่ stage `new` 40 ราย โดยไม่มีใครตามต่อ
//  3. (2026-07-26): "อยากให้เล่นเกมจนจบแล้วจึงแอด LINE หรือล็อกอิน LINE"
//  4. (2026-09-15): CTA เดิมมี 6-7 ลิงก์แข่งกัน (LINE login, LINE OA, 2 ลิงก์
//     ดูเนื้อหา, login, pricing) ลดเหลือ CTA หลักเดียวต่อการตัดสินใจ — โชว์
//     "ผลของคุณ" ก่อน (DebriefResultCard) แล้วค่อยถึง CTA นี้ ปุ่มหลักเลือก
//     อัตโนมัติจาก flag + in-app browser ที่ตรวจได้ (FB/IG/LINE in-app browser
//     ทำให้ LINE Login หลุด state cookie บ่อย — ดู lib/in-app-browser.ts) และ
//     copy เปลี่ยนเป็นประโยชน์จริงที่มีอยู่แล้ว ("ปลดล็อกเคสเพิ่ม" จะเป็นคำโกหก
//     เพราะทุกเคสเล่นฟรีหมด ไม่มีอะไรถูกล็อกไว้)
//
// LINE จึงยังเป็นตัวเลือกหลัก — ไม่ขัดกับข้อ 2 เพราะไม่ใช่การเก็บ lead ที่ต้อง
// มีคนตามต่อ: ล็อกอินด้วย LINE → ได้บัญชีจริง ยกยศ/เคสที่เล่นไว้เข้าบัญชี
// อัตโนมัติ · แอด LINE OA → บอทออกโค้ดทดลองให้เอง (detectTrialIntent, PR #367)
//
// ข้อความพรีฟิลของปุ่มแอด OA อยู่ใน lib/sim/line-links.ts ต้องตรงกับ
// TRIAL_INTENT_PATTERNS ใน lib/bot-intent.ts ไม่งั้นบอทจะไม่ยิงโค้ดให้
//
// `casegame_cta_click` เป็นตัววัดปลายทาง แยกด้วย prop `target`; `cta_variant`
// (ใหม่) บอกว่าโชว์ปุ่มแบบไหนให้ดู — ใช้เทียบอัตราสำเร็จของแต่ละทาง

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { track } from "@/lib/analytics";
import { trackLineLead } from "@/lib/analytics/conversions";
import {
  buildCtaClickProps,
  buildCtaViewProps,
  CASEGAME_EVENTS,
  caseGameCategory,
} from "@/lib/sim/track";
import { lineOaTrialUrl } from "@/lib/sim/line-links";
import { ctaTitle } from "@/lib/sim/debrief-summary";
import { detectInAppBrowser } from "@/lib/in-app-browser";

/** LINE Login ยังอยู่หลัง flag เดียวกับหน้า /login — ปิดอยู่ก็ยังเหลือทางแอด OA */
const LINE_LOGIN_ENABLED = process.env.NEXT_PUBLIC_LINE_LOGIN_ENABLED === "true";

type CtaVariant = "line_login" | "line_oa_inapp" | "line_oa_noflag";

interface Props {
  slug: string;
  category?: string;
  grade: string | null;
  /** id ของรอบเล่นที่เพิ่งจบ — ผูก view/click เข้ากับ start ตัวเดียวกัน */
  runId: string;
  /** จำนวนเคสที่เก็บไว้ในเครื่อง — ทำให้ข้อเสนอเป็นรูปธรรม ไม่ใช่คำเชิญลอยๆ */
  localRuns?: number;
  /** ยศปัจจุบัน (คิดจาก XP ในเครื่อง) — null เมื่ออ่านไม่ได้ */
  rankTitle?: string | null;
  /** percentile จาก DebriefResultCard — อาจยังเป็น null ตอนกด (โหลดไม่ทัน) */
  percentile: number | null;
}

interface BrowseLink {
  href: string;
  label: string;
  target: string;
}

/**
 * ลิงก์ดูเนื้อหารองเดียว — เลือกตามหมวดของเคสที่เพิ่งเล่น คนที่เพิ่งเล่นเคส
 * Long Case สนใจ Long Case ตัวเต็มมากกว่าคนที่เพิ่งเล่น ACLS
 */
function browseLink(category?: string): BrowseLink {
  if (caseGameCategory(category) === "longcase") {
    return { href: "/longcase", label: "ซ้อม Long Case ตัวเต็มกับ AI Examiner", target: "browse_longcase" };
  }
  return { href: "/nl/practice", label: "ลองทำข้อสอบจริง ฟรี ไม่ต้องสมัคร", target: "browse_nl" };
}

function LineGlyph() {
  return (
    <svg className="cbs-line-glyph" viewBox="0 0 24 24" fill="currentColor" aria-hidden>
      <path d="M12 2C6.48 2 2 6.02 2 11c0 3.39 1.9 6.35 4.75 8.07L6 22l3.29-1.72C10.15 20.73 11.06 21 12 21c5.52 0 10-4.02 10-9S17.52 2 12 2z" />
    </svg>
  );
}

export default function DebriefSignupCta({
  slug, category, grade, runId, localRuns = 0, rankTitle = null, percentile,
}: Props) {
  const link = browseLink(category);
  const [variant, setVariant] = useState<CtaVariant | null>(null);
  const [inApp, setInApp] = useState<"facebook" | "instagram" | "line" | null>(null);
  const [copied, setCopied] = useState(false);
  // ปุ่มจริงอยู่ใต้การ์ดผลลัพธ์ (grade/metrics/rank ด้านบน) — บนมือถือมักหลุดจอ
  // แรก ผู้เล่นเลื่อนไม่ถึง (2026-09-17: casegame_cta_view ~ เท่าจำนวนคนเล่นจบ
  // แต่ casegame_cta_click แค่ ~4%) บาร์ลอยนี้ทำหน้าที่เดียวกัน โผล่จนกว่าจะ
  // เลื่อนมาเห็นปุ่มจริง แล้วซ่อนไปเพื่อไม่ให้มีปุ่ม LINE สองอันซ้อนกันบนจอ
  const panelRef = useRef<HTMLDivElement | null>(null);
  const [stickyVisible, setStickyVisible] = useState(true);

  // ตรวจ in-app browser + resolve variant ใน effect เท่านั้น (server ไม่มี
  // userAgent ให้ตรวจ) — ไม่ render CTA จนกว่าจะ resolve เพื่อกันจอกระพริบ
  useEffect(() => {
    const detected = detectInAppBrowser();
    setInApp(detected);
    if (!LINE_LOGIN_ENABLED) {
      setVariant("line_oa_noflag");
    } else if (detected) {
      setVariant("line_oa_inapp");
    } else {
      setVariant("line_login");
    }
  }, []);

  useEffect(() => {
    if (!variant) return;
    const el = panelRef.current;
    if (!el || typeof IntersectionObserver === "undefined") return;
    const observer = new IntersectionObserver(
      ([entry]) => setStickyVisible(!entry.isIntersecting),
      { threshold: 0.3 },
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, [variant]);

  const viewedRunRef = useRef("");
  useEffect(() => {
    if (!variant) return;
    if (viewedRunRef.current === runId) return;
    viewedRunRef.current = runId;
    track(
      CASEGAME_EVENTS.ctaView,
      buildCtaViewProps({ slug, category, grade, runId, ctaVariant: variant, inAppBrowser: inApp, localRuns }),
    );
  }, [variant, runId, slug, category, grade, inApp, localRuns]);

  function handleClick(target: string, isPrimary = false) {
    track(
      CASEGAME_EVENTS.ctaClick,
      buildCtaClickProps({
        slug, category, grade, runId,
        ctaVariant: variant ?? "line_oa_noflag",
        inAppBrowser: inApp,
        localRuns,
        target,
        percentile,
      }),
    );
    if (isPrimary) trackLineLead("casegame_debrief");
  }

  async function copyLink() {
    try {
      await navigator.clipboard.writeText(window.location.href);
      setCopied(true);
      handleClick("open_external");
      setTimeout(() => setCopied(false), 2000);
    } catch {
      // คลิปบอร์ดไม่รองรับ — ผู้ใช้กดเมนู ⋯ เปิดในเบราว์เซอร์เองได้
    }
  }

  // ยังไม่ resolve variant (frame แรกก่อน effect รัน) — ไม่ render อะไรเลย
  // ดีกว่า render ผิด variant แล้วสลับให้เห็น
  if (!variant) return null;

  const title = ctaTitle({ localRuns, rankTitle });
  const reason =
    variant === "line_login"
      ? "แตะเดียว ไม่ต้องพิมพ์ · ได้ XP/ยศ/เหรียญ ขึ้น Leaderboard + ทำข้อสอบจริงฟรี 5 ข้อ/สาขา"
      : "แอดแล้วกดส่งข้อความที่พิมพ์ไว้ให้ — บอทส่งโค้ด Premium ฟรี 1 เดือนทันที";
  const oaUrl = lineOaTrialUrl({ slug, grade });
  const registerHref = `/register?next=${encodeURIComponent(`/sim/${slug}`)}`;
  const primaryHref =
    variant === "line_login"
      ? `/api/auth/line?mode=register&next=${encodeURIComponent(`/sim/${slug}`)}`
      : oaUrl;
  const primaryLabel =
    variant === "line_login" ? "เข้าสู่ระบบด้วย LINE — เก็บผลนี้ไว้" : "แอด LINE รับโค้ด Premium ฟรี 1 เดือน";

  return (
    <>
      {stickyVisible && (
        <div className="cbs-sticky-cta">
          <a
            className="cbs-line-btn cbs-sticky-cta-btn"
            href={primaryHref}
            {...(variant !== "line_login" ? { target: "_blank", rel: "noopener noreferrer" } : {})}
            onClick={() => handleClick(variant === "line_login" ? "line_login_sticky" : "line_trial_sticky", true)}
          >
            <LineGlyph /> {primaryLabel}
          </a>
        </div>
      )}
      <div className="cbs-browse-cta" ref={panelRef}>
        <p className="cbs-browse-title">{title}</p>
        <p className="cbs-cta-reason">{reason}</p>

        {variant === "line_login" && (
          <a
            className="cbs-line-btn cbs-cta-primary"
            // next= พากลับเข้าเคสเดิม เพื่อให้ claimPendingLocalRuns ยกประวัติเข้า
            // บัญชีทันทีที่กลับมา ไม่ต้องรอเล่นจบอีกรอบ
            href={`/api/auth/line?mode=register&next=${encodeURIComponent(`/sim/${slug}`)}`}
            onClick={() => handleClick("line_login", true)}
          >
            <LineGlyph /> เข้าสู่ระบบด้วย LINE — เก็บผลนี้ไว้
          </a>
        )}

        {variant !== "line_login" && (
          <a
            className="cbs-line-btn cbs-cta-primary"
            href={oaUrl}
            target="_blank"
            rel="noopener noreferrer"
            onClick={() => handleClick("line_trial", true)}
          >
            <LineGlyph /> แอด LINE รับโค้ด Premium ฟรี 1 เดือน
          </a>
        )}

        {variant === "line_oa_inapp" && (
          <p className="cbs-iab-hint">
            อยากล็อกอินด้วย LINE? เปิดหน้านี้ใน Safari/Chrome (กดเมนู ⋯){" "}
            <button type="button" className="cbs-iab-copy" onClick={copyLink}>
              {copied ? "คัดลอกลิงก์แล้ว" : "คัดลอกลิงก์"}
            </button>
          </p>
        )}

        <p className="cbs-cta-secondary">
          มีบัญชีแล้ว?{" "}
          <Link href="/login" onClick={() => handleClick("login")}>เข้าสู่ระบบ</Link>
          {" · "}
          <Link href={registerHref} onClick={() => handleClick("register")}>สมัครด้วย Google/อีเมล</Link>
          {" · "}
          {variant === "line_login" && (
            <>
              <a href={oaUrl} target="_blank" rel="noopener noreferrer" onClick={() => handleClick("line_trial")}>
                แอด LINE รับโค้ดทดลอง
              </a>
              {" · "}
            </>
          )}
          <Link href={link.href} className="cbs-browse-link" onClick={() => handleClick(link.target)}>
            {link.label}
          </Link>
        </p>

        <p className="cbs-login-hint">
          ระบบจะยกเคสที่คุณเล่นไว้ในเครื่องนี้เข้าบัญชีให้ พร้อม XP และยศ
        </p>
      </div>
    </>
  );
}
