"use client";

// CTA ท้ายเกม — จังหวะที่ผู้เล่นตั้งใจสูงสุดของทั้ง funnel
//
// เดิมหน้า debrief มีแค่ลิงก์ "เข้าสู่ระบบ เพื่อเก็บ XP" ตัวเล็กๆ ซึ่งขอให้คน
// แปลกหน้าสมัครสมาชิกเพื่อแลก XP — ไม่คุ้มในสายตาเขา ตัวนี้เปลี่ยนเป็นการเก็บ
// อีเมลแลกของที่ผูกกับสิ่งที่เพิ่งเล่นจบ แล้วส่งต่อเข้าเส้นทาง lead → redeem
// code → drip ที่มีอยู่แล้ว (lib/leads.ts) โดยไม่ต้องสร้างระบบใหม่

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { track } from "@/lib/analytics";
import { trackLead } from "@/lib/analytics/conversions";
import {
  buildCtaClickProps,
  buildCtaViewProps,
  CASEGAME_EVENTS,
  caseGameCategory,
} from "@/lib/sim/track";

const SURFACE = "casegame_debrief";

interface Props {
  slug: string;
  category?: string;
  grade: string | null;
  /** id ของรอบเล่นที่เพิ่งจบ — ผูก view/click/lead เข้ากับ start ตัวเดียวกัน */
  runId: string;
  campaign?: string | null;
  adSet?: string | null;
}

export default function DebriefLeadCta({
  slug,
  category,
  grade,
  runId,
  campaign,
  adSet,
}: Props) {
  const [email, setEmail] = useState("");
  const [consent, setConsent] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  const isLongcase = caseGameCategory(category) === "longcase";

  // ตัวหารของ funnel ขั้นสุดท้าย — คอมโพเนนต์นี้ถูก render เฉพาะตอนฟอร์มโผล่จริง
  // (จบเกม + ยังไม่ล็อกอิน + ไม่ใช่โหมดซ้อม) การ mount จึงเท่ากับ "เห็นฟอร์ม"
  // กันซ้ำด้วย runId เผื่อ effect ถูกเรียกสองรอบ (StrictMode) หรือ re-render
  const viewedRunRef = useRef("");
  useEffect(() => {
    if (viewedRunRef.current === runId) return;
    viewedRunRef.current = runId;
    track(CASEGAME_EVENTS.ctaView, buildCtaViewProps({ slug, category, grade, runId }));
  }, [runId, slug, category, grade]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!consent || submitting) return;
    setSubmitting(true);
    setErrorMsg("");
    track(
      CASEGAME_EVENTS.ctaClick,
      buildCtaClickProps({ slug, category, grade, runId, target: "lead_form" })
    );

    try {
      const res = await fetch("/api/leads/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email,
          reward_choice: "bundle_10q",
          consent_pdpa: true,
          campaign: campaign ?? SURFACE,
          ad_set: adSet ?? null,
        }),
      });
      const json = (await res.json()) as { error?: string; code?: string };
      if (!res.ok || !json.code) {
        track("lp_lead_form_error", { error: json.error ?? "unknown", surface: SURFACE });
        setErrorMsg(translateError(json.error));
        setSubmitting(false);
        return;
      }
      // ยิงสองชื่อโดยตั้งใจ: lp_lead_form_submit ให้ยอด lead รวมของทั้งระบบยัง
      // ครบ, casegame_lead ให้หน้าแอดมินนับ lead ที่มาจากเกมได้โดยไม่ต้องดึง
      // คอลัมน์ properties มาทั้งก้อน
      track("lp_lead_form_submit", {
        reward_choice: "bundle_10q",
        surface: SURFACE,
        slug,
        campaign: campaign ?? SURFACE,
        ad_set: adSet ?? null,
      });
      track(CASEGAME_EVENTS.lead, {
        slug,
        campaign: campaign ?? SURFACE,
        ad_set: adSet ?? null,
        run_id: runId,
      });
      trackLead(json.code);
      window.location.href = `/redeem/${json.code}`;
    } catch (err) {
      setErrorMsg(err instanceof Error ? err.message : "ลองใหม่อีกครั้ง");
      setSubmitting(false);
    }
  }

  return (
    <form className="cbs-lead-cta" onSubmit={handleSubmit}>
      <p className="cbs-lead-title">
        {isLongcase ? "เคสนี้มาจาก Long Case ของจริง" : "เคสนี้อิงแนวทาง ACLS ของจริง"}
      </p>
      <p className="cbs-lead-sub">
        รับ<b> ข้อสอบจริงฟรี 10 ข้อ </b>ไปฝึกต่อ — ส่งโค้ดเข้าอีเมล ไม่ต้องผูกบัตร
      </p>

      <input
        className="cbs-lead-input"
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        placeholder="อีเมลของคุณ"
        autoComplete="email"
        aria-label="อีเมล"
      />

      <label className="cbs-lead-consent">
        <input
          type="checkbox"
          checked={consent}
          onChange={(e) => setConsent(e.target.checked)}
        />
        <span>
          ยินยอมให้หมอรู้เก็บและใช้ข้อมูลเพื่อส่งสิทธิ์และข่าวสาร ตาม
          <Link href="/privacy" target="_blank"> นโยบายความเป็นส่วนตัว</Link>
        </span>
      </label>

      <button type="submit" className="cbs-btn-main" disabled={submitting || !consent}>
        {submitting ? "กำลังส่งโค้ด…" : "รับข้อสอบฟรี 10 ข้อ →"}
      </button>

      {errorMsg && <p className="cbs-lead-error">{errorMsg}</p>}

      <p className="cbs-login-hint">
        มีบัญชีอยู่แล้ว?{" "}
        <Link
          href="/login"
          onClick={() =>
            track(
              CASEGAME_EVENTS.ctaClick,
              buildCtaClickProps({ slug, category, grade, runId, target: "login" })
            )
          }
        >
          เข้าสู่ระบบ
        </Link>{" "}
        เพื่อเก็บ XP, Badge และขึ้น Leaderboard
      </p>
    </form>
  );
}

function translateError(code?: string): string {
  switch (code) {
    case "missing_email":
    case "invalid_email":
      return "กรุณากรอกอีเมลที่ถูกต้อง";
    case "missing_consent":
      return "กรุณายอมรับเงื่อนไข PDPA";
    default:
      return "เกิดข้อผิดพลาด ลองใหม่อีกครั้ง";
  }
}
