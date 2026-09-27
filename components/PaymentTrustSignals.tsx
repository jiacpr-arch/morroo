import { ShieldCheck, RotateCcw, Users, Lock } from "lucide-react";

const SIGNALS = [
  {
    icon: Lock,
    title: "ชำระเงินปลอดภัย",
    desc: "เข้ารหัส SSL · ดูแลโดย Stripe",
  },
  {
    icon: RotateCcw,
    title: "ยกเลิกได้ทุกเมื่อ",
    desc: "ไม่ผูกมัด · ใช้ต่อหรือหยุดเมื่อไรก็ได้",
  },
  {
    icon: Users,
    title: "1,000+ แพทย์ใช้งาน",
    desc: "ใช้เตรียมสอบ NL · MEQ · Long Case",
  },
  {
    icon: ShieldCheck,
    title: "เปิดใช้งานทันที",
    desc: "เริ่มทำข้อสอบทุกฟีเจอร์ภายในไม่กี่วินาที",
  },
];

// Reassures the visitor at the payment step. Rendered between the order
// summary and the payment-method selector — the moment of greatest doubt.
export default function PaymentTrustSignals() {
  return (
    <div className="rounded-2xl border border-surface-border bg-surface-warm p-4 sm:p-5">
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {SIGNALS.map((s) => (
          <div key={s.title} className="flex items-start gap-3">
            <div className="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-surface-border bg-white">
              <s.icon className="h-4 w-4 text-brand" />
            </div>
            <div>
              <div className="text-sm font-semibold text-brand-dark">
                {s.title}
              </div>
              <div className="mt-0.5 text-xs leading-5 text-ink-soft">
                {s.desc}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
