"use client";

import { useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog,
  DialogBody,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { formatThaiDate } from "@/lib/beta";

type Kind = "checkpoint_10" | "checkpoint_25";

interface Props {
  kind: Kind;
  open: boolean;
  onDismiss: () => void;
  onSubmitted: () => void;
}

interface CouponResult {
  code: string;
  discount_percent: number;
  expires_at: string;
}

export default function BetaCheckpointSurvey({
  kind,
  open,
  onDismiss,
  onSubmitted,
}: Props) {
  const [submitting, setSubmitting] = useState(false);
  const [coupon, setCoupon] = useState<CouponResult | null>(null);
  const [copied, setCopied] = useState(false);

  // --- checkpoint_10 state ---
  const [difficulty, setDifficulty] = useState<"easy" | "ok" | "hard" | "">("");
  const [problems10, setProblems10] = useState("");
  const [wishedFeature, setWishedFeature] = useState("");

  // --- checkpoint_25 state ---
  const [nps, setNps] = useState<number>(7);
  const [love, setLove] = useState("");
  const [improve, setImprove] = useState("");
  const [pay, setPay] = useState<"yes" | "maybe" | "no" | "">("");
  const [payWhy, setPayWhy] = useState("");
  const [yearLevel, setYearLevel] = useState<
    "p1_3" | "p4" | "p5" | "p6" | "extern" | "grad" | ""
  >("");

  async function handleSubmit() {
    setSubmitting(true);
    const responses =
      kind === "checkpoint_10"
        ? { difficulty, problems: problems10, wished_feature: wishedFeature }
        : {
            nps,
            love,
            improve,
            pay,
            pay_why: payWhy,
            year_level: yearLevel,
          };

    try {
      const res = await fetch("/api/beta/survey", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ type: kind, responses }),
      });
      const data = (await res.json()) as {
        ok?: boolean;
        coupon?: CouponResult | null;
      };
      if (kind === "checkpoint_25" && data.coupon) {
        setCoupon(data.coupon);
      } else {
        onSubmitted();
      }
    } finally {
      setSubmitting(false);
    }
  }

  // Success state — only for checkpoint_25 once coupon is issued
  if (coupon) {
    const expires = formatThaiDate(new Date(coupon.expires_at));
    return (
      <Dialog open={open} dismissible={false}>
        <DialogHeader>
          <DialogTitle>🎉 ขอบคุณสำหรับ feedback!</DialogTitle>
        </DialogHeader>
        <DialogBody>
          <p className="text-sm text-muted-foreground">คูปองส่วนลดของคุณ</p>
          <div className="flex items-center gap-2">
            <code className="flex-1 rounded-lg border border-dashed border-brand/40 bg-brand/5 px-4 py-3 font-mono text-lg font-bold tracking-widest text-brand">
              {coupon.code}
            </code>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => {
                navigator.clipboard.writeText(coupon.code);
                setCopied(true);
                setTimeout(() => setCopied(false), 1500);
              }}
            >
              {copied ? "คัดลอกแล้ว" : "คัดลอก"}
            </Button>
          </div>
          <p className="text-sm">
            ลด <strong>{coupon.discount_percent}%</strong> สำหรับเดือนแรก
          </p>
          <p className="text-xs text-muted-foreground">หมดอายุ: {expires}</p>
        </DialogBody>
        <DialogFooter>
          <button
            type="button"
            onClick={() => {
              onSubmitted();
            }}
            className="text-sm text-muted-foreground hover:underline"
          >
            เก็บไว้ก่อน ค่อยใช้
          </button>
          <Link
            href={`/pricing?coupon=${encodeURIComponent(coupon.code)}`}
            onClick={() => onSubmitted()}
          >
            <Button className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white">
              ดูแพ็กเกจ Paid
            </Button>
          </Link>
        </DialogFooter>
      </Dialog>
    );
  }

  if (kind === "checkpoint_10") {
    const canSubmit = difficulty !== "";
    return (
      <Dialog open={open} onClose={onDismiss} dismissible>
        <DialogHeader>
          <DialogTitle>ขอรบกวน 30 วินาที 🙏</DialogTitle>
          <p className="text-sm text-muted-foreground mt-1">
            feedback ของคุณช่วยให้ MorRoo ดีขึ้น
          </p>
        </DialogHeader>
        <DialogBody>
          <div>
            <p className="text-sm font-medium mb-2">
              คำถามที่ 1: ความยากของข้อสอบที่ผ่านมาเป็นอย่างไร?
            </p>
            <RadioGroup
              name="difficulty"
              value={difficulty}
              onChange={(v) => setDifficulty(v as "easy" | "ok" | "hard")}
              options={[
                { value: "easy", label: "ง่ายเกินไป" },
                { value: "ok", label: "พอดี" },
                { value: "hard", label: "ยากเกินไป" },
              ]}
            />
          </div>
          <div>
            <p className="text-sm font-medium mb-1">
              คำถามที่ 2: มีข้อไหนที่คุณคิดว่ามีปัญหา?
            </p>
            <p className="text-xs text-muted-foreground mb-2">
              (เฉลยไม่ถูก/คำถามกำกวม/ข้อสอบไม่ชัด)
            </p>
            <Textarea
              rows={2}
              placeholder="optional"
              value={problems10}
              onChange={(e) => setProblems10(e.target.value)}
            />
          </div>
          <div>
            <p className="text-sm font-medium mb-2">
              คำถามที่ 3: อยากให้ MorRoo เพิ่ม feature อะไร?
            </p>
            <Textarea
              rows={2}
              placeholder="optional"
              value={wishedFeature}
              onChange={(e) => setWishedFeature(e.target.value)}
            />
          </div>
        </DialogBody>
        <DialogFooter>
          <Button type="button" variant="ghost" onClick={onDismiss}>
            ข้ามไว้ก่อน
          </Button>
          <Button
            type="button"
            onClick={handleSubmit}
            disabled={!canSubmit || submitting}
            className="bg-brand hover:bg-brand-light text-white"
          >
            {submitting ? "กำลังส่ง..." : "ส่ง feedback"}
          </Button>
        </DialogFooter>
      </Dialog>
    );
  }

  // checkpoint_25 — blocking
  const canSubmit25 = pay !== "" && yearLevel !== "";
  return (
    <Dialog open={open} dismissible={false}>
      <DialogHeader>
        <DialogTitle>🎉 ทำครบ 25 ข้อแล้ว! ขอ feedback สุดท้าย</DialogTitle>
        <p className="text-sm text-muted-foreground mt-1">
          ใช้เวลา ~2 นาที · จะได้รับคูปองส่วนลด 50%
        </p>
      </DialogHeader>
      <DialogBody>
        <div>
          <p className="text-sm font-medium mb-2">
            คำถามที่ 1: จะแนะนำให้เพื่อนใช้ MorRoo ไหม?
          </p>
          <input
            type="range"
            min={0}
            max={10}
            step={1}
            value={nps}
            onChange={(e) => setNps(Number(e.target.value))}
            className="w-full accent-brand"
          />
          <div className="flex justify-between text-xs text-muted-foreground mt-1">
            <span>0 = ไม่มีทาง</span>
            <span className="font-semibold text-foreground">{nps}</span>
            <span>10 = แน่นอน</span>
          </div>
        </div>
        <div>
          <p className="text-sm font-medium mb-2">
            คำถามที่ 2: อะไรคือสิ่งที่คุณชอบที่สุดของ MorRoo?
          </p>
          <Textarea
            rows={2}
            placeholder="optional"
            value={love}
            onChange={(e) => setLove(e.target.value)}
          />
        </div>
        <div>
          <p className="text-sm font-medium mb-2">
            คำถามที่ 3: อะไรที่ต้องปรับปรุงมากที่สุด?
          </p>
          <Textarea
            rows={2}
            placeholder="optional"
            value={improve}
            onChange={(e) => setImprove(e.target.value)}
          />
        </div>
        <div>
          <p className="text-sm font-medium mb-2">
            คำถามที่ 4: ถ้าจ่าย 199 บาท/เดือน คุณจะจ่ายไหม?
          </p>
          <RadioGroup
            name="pay"
            value={pay}
            onChange={(v) => setPay(v as "yes" | "maybe" | "no")}
            options={[
              { value: "yes", label: "จ่าย" },
              { value: "maybe", label: "อาจจะจ่าย" },
              { value: "no", label: "ไม่จ่าย" },
            ]}
          />
          <Textarea
            className="mt-2"
            rows={2}
            placeholder="เพราะ (optional)"
            value={payWhy}
            onChange={(e) => setPayWhy(e.target.value)}
          />
        </div>
        <div>
          <p className="text-sm font-medium mb-2">
            คำถามที่ 5: คุณเรียนชั้นปีอะไร?
          </p>
          <RadioGroup
            name="year_level"
            value={yearLevel}
            onChange={(v) =>
              setYearLevel(v as "p1_3" | "p4" | "p5" | "p6" | "extern" | "grad")
            }
            options={[
              { value: "p1_3", label: "ปี 1-3" },
              { value: "p4", label: "ปี 4" },
              { value: "p5", label: "ปี 5" },
              { value: "p6", label: "ปี 6" },
              { value: "extern", label: "Extern/Intern" },
              { value: "grad", label: "จบแล้ว" },
            ]}
          />
        </div>
      </DialogBody>
      <DialogFooter>
        <Button
          type="button"
          onClick={handleSubmit}
          disabled={!canSubmit25 || submitting}
          className="bg-brand hover:bg-brand-light text-white"
        >
          {submitting ? "กำลังส่ง..." : "ส่งและรับคูปอง"}
        </Button>
      </DialogFooter>
    </Dialog>
  );
}

interface RadioOpt {
  value: string;
  label: string;
}

function RadioGroup({
  name,
  value,
  onChange,
  options,
}: {
  name: string;
  value: string;
  onChange: (v: string) => void;
  options: RadioOpt[];
}) {
  return (
    <div className="space-y-2">
      {options.map((opt) => (
        <label
          key={opt.value}
          className="flex items-center gap-2 text-sm cursor-pointer"
        >
          <input
            type="radio"
            name={name}
            value={opt.value}
            checked={value === opt.value}
            onChange={() => onChange(opt.value)}
            className="accent-brand"
          />
          <span>{opt.label}</span>
        </label>
      ))}
    </div>
  );
}
