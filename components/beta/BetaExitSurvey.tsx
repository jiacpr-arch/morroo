"use client";

import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Dialog,
  DialogBody,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

type Reason = "too_hard" | "too_easy" | "boring" | "ux" | "busy" | "other";

const OPTIONS: { value: Reason; label: string }[] = [
  { value: "too_hard", label: "ข้อสอบยากเกินไป" },
  { value: "too_easy", label: "ข้อสอบง่ายเกินไป" },
  { value: "boring", label: "เบื่อ / ไม่น่าสนใจ" },
  { value: "ux", label: "UX ใช้งานยาก" },
  { value: "busy", label: "ติดธุระ เดี๋ยวกลับมา" },
  { value: "other", label: "อื่นๆ" },
];

interface Props {
  /** Attempts completed in this session. Survey only fires after 3+. */
  attemptsInSession: number;
  /** Skip the survey (e.g. user is in paid tier, or already submitted). */
  disabled?: boolean;
}

/**
 * Prompts the user on first internal-navigation / tab-hide after 3+ attempts.
 * Truly blocking beforeunload prompts aren't possible in modern browsers, but
 * we show the modal on visibility changes so the user sees it either way.
 */
export default function BetaExitSurvey({ attemptsInSession, disabled }: Props) {
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState<Reason | "">("");
  const [otherText, setOtherText] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const shownRef = useRef(false);

  useEffect(() => {
    if (disabled) return;
    if (attemptsInSession < 3) return;

    const onHide = () => {
      if (document.visibilityState === "hidden" && !shownRef.current) {
        shownRef.current = true;
        setOpen(true);
      }
    };
    document.addEventListener("visibilitychange", onHide);
    return () => document.removeEventListener("visibilitychange", onHide);
  }, [attemptsInSession, disabled]);

  async function handleSubmit() {
    if (!reason) return;
    setSubmitting(true);
    try {
      await fetch("/api/beta/survey", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          type: "exit",
          responses: {
            reason,
            other_text: reason === "other" ? otherText : null,
          },
        }),
      });
    } finally {
      setSubmitting(false);
      setOpen(false);
    }
  }

  if (!open) return null;

  return (
    <Dialog open onClose={() => setOpen(false)} dismissible>
      <DialogHeader>
        <DialogTitle>ก่อนไป — อะไรทำให้คุณหยุด?</DialogTitle>
        <p className="text-sm text-muted-foreground mt-1">(เลือกได้ 1 ข้อ)</p>
      </DialogHeader>
      <DialogBody>
        {OPTIONS.map((opt) => (
          <label
            key={opt.value}
            className="flex items-center gap-2 text-sm cursor-pointer"
          >
            <input
              type="radio"
              name="exit_reason"
              value={opt.value}
              checked={reason === opt.value}
              onChange={() => setReason(opt.value)}
              className="accent-brand"
            />
            <span>{opt.label}</span>
          </label>
        ))}
        {reason === "other" && (
          <Input
            value={otherText}
            onChange={(e) => setOtherText(e.target.value)}
            placeholder="บอกเราหน่อย…"
            className="mt-2"
          />
        )}
      </DialogBody>
      <DialogFooter>
        <Button
          type="button"
          variant="ghost"
          onClick={() => setOpen(false)}
        >
          กลับไปทำต่อ
        </Button>
        <Button
          type="button"
          onClick={handleSubmit}
          disabled={!reason || submitting}
          className="bg-brand hover:bg-brand-light text-white"
        >
          {submitting ? "กำลังส่ง..." : "ส่งและออก"}
        </Button>
      </DialogFooter>
    </Dialog>
  );
}
