"use client";

/**
 * "ไม่ต่ออายุ" — lapse survey + win-back offer.
 *
 * Plans are one-time purchases (no auto-renew), so this isn't a cancel
 * button: it's where a member whose plan / trial is ending tells us why
 * they're not buying again, and gets an offer tailored to that reason
 * (lib/winback.ts). Linked from the profile page and the D+1 expiry
 * LINE / email (?source=…).
 *
 *   step 1  reason + free text
 *   step 2  offer (discount code → /payment/<plan>?coupon=…, or none)
 *   step 3  done (took the offer, or confirmed not renewing)
 */

import { use, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Textarea } from "@/components/ui/textarea";
import { track } from "@/lib/analytics";
import {
  LAPSE_REASONS,
  LAPSE_REASON_LABELS,
  type LapseReason,
  type WinbackOfferView,
} from "@/lib/winback";
import { ArrowLeft, Check, Copy, Gift, Heart, Loader2 } from "lucide-react";

type Step = "reason" | "offer" | "done";

interface State {
  eligible: boolean;
  wasTrial: boolean;
  lastPlanLabel: string | null;
  expiresAt: string | null;
  existing: { id: string; response: string | null; offer: WinbackOfferView } | null;
}

const fmtDate = (iso: string) =>
  new Date(iso).toLocaleDateString("th-TH", { year: "numeric", month: "long", day: "numeric" });

export default function RenewalFeedbackPage({
  searchParams,
}: {
  searchParams: Promise<{ source?: string }>;
}) {
  const { source } = use(searchParams);
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [state, setState] = useState<State | null>(null);
  const [step, setStep] = useState<Step>("reason");
  const [reason, setReason] = useState<LapseReason | null>(null);
  const [detail, setDetail] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [feedbackId, setFeedbackId] = useState<string | null>(null);
  const [offer, setOffer] = useState<WinbackOfferView | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    let cancelled = false;
    fetch("/api/winback")
      .then(async (res) => {
        if (res.status === 401) {
          router.push(`/login?redirect=${encodeURIComponent("/renewal")}`);
          return;
        }
        const json = (await res.json()) as State;
        if (cancelled) return;
        setState(json);
        if (json.existing) {
          setFeedbackId(json.existing.id);
          setOffer(json.existing.offer);
          setStep(json.existing.response ? "done" : "offer");
          setAccepted(json.existing.response === "accepted");
        }
        setLoading(false);
      })
      .catch(() => {
        if (!cancelled) {
          setError("โหลดข้อมูลไม่สำเร็จ");
          setLoading(false);
        }
      });
    return () => {
      cancelled = true;
    };
  }, [router]);

  async function submitReason() {
    if (!reason) return;
    setSubmitting(true);
    setError("");
    try {
      const res = await fetch("/api/winback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reason, detail, source }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(json.error ?? "บันทึกไม่สำเร็จ");
      } else {
        setFeedbackId(json.id);
        setOffer(json.offer);
        setStep("offer");
        track("winback_reason", { reason, offer: json.offer?.kind, percent: json.offer?.percent });
      }
    } catch {
      setError("บันทึกไม่สำเร็จ กรุณาลองใหม่");
    }
    setSubmitting(false);
  }

  async function respond(response: "accepted" | "declined") {
    if (feedbackId) {
      await fetch("/api/winback", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ id: feedbackId, response }),
      }).catch(() => {});
    }
    track("winback_response", { response, offer: offer?.kind ?? null });
    if (response === "accepted" && offer) {
      router.push(offer.ctaHref);
      return;
    }
    setAccepted(false);
    setStep("done");
  }

  async function copyCode() {
    if (!offer?.code) return;
    await navigator.clipboard.writeText(offer.code).catch(() => {});
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-lg px-4 py-8">
      <Link
        href="/profile"
        className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
      >
        <ArrowLeft className="h-4 w-4" /> กลับหน้าโปรไฟล์
      </Link>

      {state && !state.eligible && !state.existing ? (
        <Card>
          <CardContent className="py-8 text-center space-y-3">
            <p className="font-semibold">ตอนนี้ยังไม่มีแพ็กที่ใกล้หมดอายุ</p>
            <p className="text-sm text-muted-foreground">
              แพ็กเกจของหมอรู้เป็นแบบจ่ายครั้งเดียว ไม่มีการตัดเงินอัตโนมัติ — หมดอายุแล้วจะกลับเป็นสมาชิกฟรีเอง
            </p>
            <Link href="/profile">
              <Button variant="outline" className="mt-2">กลับหน้าโปรไฟล์</Button>
            </Link>
          </CardContent>
        </Card>
      ) : (
        <>
          <div className="mb-4 flex items-center gap-2 text-xs text-muted-foreground">
            {(["reason", "offer", "done"] as Step[]).map((s, i) => (
              <span
                key={s}
                className={`rounded-full px-2 py-0.5 ${step === s ? "bg-brand text-white" : "bg-muted"}`}
              >
                {i + 1}. {s === "reason" ? "เหตุผล" : s === "offer" ? "ข้อเสนอ" : "เสร็จสิ้น"}
              </span>
            ))}
          </div>

          {step === "reason" && (
            <Card>
              <CardHeader>
                <h1 className="text-xl font-bold">ทำไมถึงไม่ต่ออายุ?</h1>
                <p className="text-sm text-muted-foreground">
                  {state?.wasTrial ? "ทดลองใช้ฟรี" : `แพ็ก ${state?.lastPlanLabel ?? ""}`}
                  {state?.expiresAt &&
                    (new Date(state.expiresAt) > new Date()
                      ? ` จะหมดอายุ ${fmtDate(state.expiresAt)}`
                      : ` หมดอายุเมื่อ ${fmtDate(state.expiresAt)}`)}
                  {" "}— บอกเราหน่อย ใช้เวลาไม่ถึงนาที
                </p>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="grid gap-2">
                  {LAPSE_REASONS.map((r) => (
                    <button
                      key={r}
                      type="button"
                      onClick={() => setReason(r)}
                      className={`rounded-lg border px-4 py-3 text-left text-sm transition-colors ${
                        reason === r ? "border-brand bg-brand/5 font-medium" : "hover:bg-muted"
                      }`}
                    >
                      {LAPSE_REASON_LABELS[r]}
                    </button>
                  ))}
                </div>
                <Textarea
                  value={detail}
                  onChange={(e) => setDetail(e.target.value)}
                  maxLength={1000}
                  rows={3}
                  placeholder={
                    reason === "content_mismatch"
                      ? "อยากได้เนื้อหาหรือวิชาไหนเพิ่ม?"
                      : "เล่าเพิ่มเติม (ไม่บังคับ)"
                  }
                />
                {error && <p className="text-sm text-red-600">{error}</p>}
                <Button
                  className="w-full bg-brand hover:bg-brand-light text-white"
                  disabled={!reason || submitting}
                  onClick={submitReason}
                >
                  {submitting ? <Loader2 className="h-4 w-4 animate-spin" /> : "ถัดไป"}
                </Button>
              </CardContent>
            </Card>
          )}

          {step === "offer" && offer && (
            <Card className={offer.kind === "discount" ? "border-brand/40" : undefined}>
              <CardHeader>
                <h2 className="text-xl font-bold flex items-center gap-2">
                  {offer.kind === "discount" ? (
                    <Gift className="h-5 w-5 text-brand" />
                  ) : (
                    <Heart className="h-5 w-5 text-rose-500" />
                  )}
                  {offer.headline}
                </h2>
                <p className="text-sm text-muted-foreground">{offer.body}</p>
              </CardHeader>
              <CardContent className="space-y-3">
                {offer.kind === "discount" && offer.code && (
                  <div className="rounded-lg border border-dashed border-brand/50 bg-brand/5 p-4 text-center">
                    <p className="text-xs text-muted-foreground">
                      โค้ดส่วนลด {offer.percent}% {offer.planLabel ? `· แพ็ก ${offer.planLabel}` : ""}
                    </p>
                    <button
                      type="button"
                      onClick={copyCode}
                      className="mt-1 inline-flex items-center gap-2 font-mono text-2xl font-bold tracking-wider"
                    >
                      {offer.code}
                      {copied ? <Check className="h-4 w-4 text-green-600" /> : <Copy className="h-4 w-4 text-muted-foreground" />}
                    </button>
                    {offer.expiresAt && (
                      <p className="text-xs text-muted-foreground mt-1">ใช้ได้ถึง {fmtDate(offer.expiresAt)} · ใช้ได้ 1 ครั้ง</p>
                    )}
                  </div>
                )}
                <Button
                  className="w-full bg-brand hover:bg-brand-light text-white"
                  onClick={() => respond("accepted")}
                >
                  {offer.ctaLabel}
                </Button>
                <Button variant="outline" className="w-full" onClick={() => respond("declined")}>
                  ไม่ต่ออายุตอนนี้
                </Button>
                <p className="text-xs text-center text-muted-foreground">
                  แพ็กเกจเป็นแบบจ่ายครั้งเดียว ไม่มีการตัดเงินอัตโนมัติ
                </p>
              </CardContent>
            </Card>
          )}

          {step === "done" && (
            <Card>
              <CardContent className="py-8 text-center space-y-3">
                <Heart className="h-10 w-10 text-rose-500 mx-auto" />
                <p className="font-semibold">ขอบคุณสำหรับความเห็น</p>
                <p className="text-sm text-muted-foreground">
                  {accepted
                    ? "ใช้โค้ดที่หน้าชำระเงินได้เลย"
                    : "เมื่อหมดอายุ บัญชีจะกลับเป็นสมาชิกฟรี ประวัติการทำข้อสอบยังอยู่ครบ กลับมาต่ออายุได้ทุกเมื่อ"}
                </p>
                {offer?.kind === "discount" && offer.code && (
                  <p className="text-sm">
                    โค้ด <span className="font-mono font-bold">{offer.code}</span>
                    {offer.expiresAt ? ` ใช้ได้ถึง ${fmtDate(offer.expiresAt)}` : ""}
                  </p>
                )}
                <div className="flex justify-center gap-2 pt-2">
                  {offer && (
                    <Link href={offer.ctaHref}>
                      <Button className="bg-brand hover:bg-brand-light text-white">{offer.ctaLabel}</Button>
                    </Link>
                  )}
                  <Link href="/profile">
                    <Button variant="outline">กลับหน้าโปรไฟล์</Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          )}
        </>
      )}
    </div>
  );
}
