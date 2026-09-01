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
    <div className="rounded-xl border bg-muted/30 p-4 sm:p-5">
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {SIGNALS.map((s) => (
          <div key={s.title} className="flex items-start gap-3">
            <div className="shrink-0 mt-0.5 h-8 w-8 rounded-full bg-white border flex items-center justify-center">
              <s.icon className="h-4 w-4 text-brand" />
            </div>
            <div>
              <div className="text-sm font-semibold text-foreground">
                {s.title}
              </div>
              <div className="text-xs text-muted-foreground mt-0.5">
                {s.desc}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
