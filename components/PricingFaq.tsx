"use client";

import { track } from "@/lib/analytics";

type Props = {
  surface: string;
};

const FAQS: { q: string; a: string }[] = [
  {
    q: "ทดลองฟรีได้ไหม ต้องใส่บัตรเครดิตหรือเปล่า?",
    a: "ทดลองฟรีได้ทันที — MCQ 5 ข้อต่อสาขา · MEQ 2 เคส · Long Case 1 เคส ไม่ต้องใส่บัตรเครดิต ใช้เวลาสมัครแค่ 30 วินาที",
  },
  {
    q: "สมัครแล้วยกเลิกได้ไหม?",
    a: "ได้เลย ไม่ผูกมัด ยกเลิกผ่านหน้า Profile ได้ทุกเมื่อ สมาชิกจะยังคงใช้งานได้จนกว่าจะหมดรอบบิลที่จ่ายไว้",
  },
  {
    q: "ชำระเงินทางไหนได้บ้าง?",
    a: "บัตรเครดิต/เดบิตทุกประเภทผ่าน Stripe (เปิดใช้งานทันที) หรือโอนเงินผ่านธนาคาร (ตรวจสอบและเปิดสิทธิ์ภายใน 1-2 ชั่วโมง) ปลอดภัยระดับสากล",
  },
  {
    q: "ใช้งานบนมือถือได้ไหม?",
    a: "ใช้ได้เต็มรูปแบบทุกฟีเจอร์ — MCQ, MEQ, Long Case ทำงานได้ดีทั้งบน iOS และ Android ไม่ต้องโหลดแอป เปิดผ่านเบราว์เซอร์ได้เลย",
  },
  {
    q: "แพ็ก นศพ. และ Board ต่างกันยังไง?",
    a: "แพ็ก นศพ. เหมาะกับ extern/intern ที่เตรียมสอบ NL Step 2 — มี MCQ NL + MEQ + Long Case แพ็ก Board เหมาะกับแพทย์ที่สอบวุฒิบัตรเฉพาะทาง — มี MCQ ตาม Blueprint ของราชวิทยาลัยฯ + Oral Exam จำลอง",
  },
  {
    q: "ข้อสอบที่นี่มาจากไหน อ้างอิงตำราอะไร?",
    a: "ข้อสอบสร้างด้วย AI (Claude) ที่อ้างอิงตำราหลักของแต่ละสาขา (Harrison/Tintinalli/Nelson/Williams ฯลฯ) และแนวข้อสอบ NL ย้อนหลัง เพิ่มข้อสอบใหม่ทุกวัน",
  },
  {
    q: "มี AI ช่วยตรวจคำตอบจริงไหม?",
    a: "ใช่ AI ตรวจคำตอบ MEQ + Long Case ให้คะแนนพร้อม feedback ทันที — ระบบเทียบกับ approach มาตรฐานที่กรรมการสอบจริงใช้ ให้คะแนนแยกด้าน (history, dx, mx ฯลฯ) พร้อมจุดที่ควรปรับ",
  },
  {
    q: "ชวนเพื่อนได้ส่วนลดไหม?",
    a: "ทุกครั้งที่เพื่อนสมัครและซื้อแพ็กเกจผ่านลิงก์ของคุณ — เราจะต่ออายุสมาชิกของคุณ +30 วันฟรี ไม่จำกัดจำนวนเพื่อน รหัสแชร์อยู่ในหน้า Profile",
  },
];

export const PRICING_FAQ_ITEMS = FAQS;

export default function PricingFaq({ surface }: Props) {
  return (
    <div className="mx-auto max-w-3xl">
      <h2 className="text-2xl sm:text-3xl font-bold text-center mb-2">
        คำถามที่พบบ่อย
      </h2>
      <p className="text-center text-muted-foreground mb-8">
        คำตอบสั้นๆ สำหรับเรื่องที่คนสงสัยก่อนตัดสินใจ
      </p>
      <div className="space-y-3">
        {FAQS.map((f, i) => (
          <details
            key={f.q}
            className="group rounded-xl border bg-card p-4 sm:p-5"
            onToggle={(e) => {
              if ((e.currentTarget as HTMLDetailsElement).open) {
                track("pricing_faq_expand", { surface, index: i });
              }
            }}
          >
            <summary className="cursor-pointer list-none flex items-start justify-between gap-3 font-semibold text-foreground">
              <span className="flex-1">{f.q}</span>
              <span className="shrink-0 mt-0.5 text-muted-foreground text-sm group-open:rotate-180 transition-transform">
                ▾
              </span>
            </summary>
            <p className="mt-3 text-sm text-muted-foreground leading-relaxed">
              {f.a}
            </p>
          </details>
        ))}
      </div>
    </div>
  );
}
