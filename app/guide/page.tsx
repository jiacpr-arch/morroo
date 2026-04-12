import Link from "next/link";
import type { Metadata } from "next";
import { BookOpen, GraduationCap, Brain, Stethoscope, CreditCard, MessageCircle, Users, FileText, HelpCircle } from "lucide-react";

export const metadata: Metadata = {
  title: "คู่มือการใช้งาน — หมอรู้",
  description: "คู่มือการใช้งานเว็บไซต์หมอรู้ เตรียมสอบแพทย์ NL Step 3 ข้อสอบ MEQ MCQ Long Case",
};

const sections = [
  {
    id: "start",
    icon: BookOpen,
    title: "เริ่มต้นใช้งาน",
    content: [
      {
        subtitle: "สมัครสมาชิก",
        text: "เข้าเว็บ morroo.com แล้วกด \"สมัครสมาชิก\" เลือกได้ 3 วิธี: LINE, Google หรือ Email ถ้ามีรหัสชวนเพื่อน ให้กรอกตอนสมัคร",
      },
      {
        subtitle: "ตั้งค่าเริ่มต้น",
        text: "หลังสมัคร ระบบจะพาตั้งค่า 3 ขั้นตอน: (1) เลือกการสอบ NL1/NL2/ทั้งคู่ (2) ตั้งเป้าหมายรายวัน 10/20/30 ข้อ (3) เลือกวิชาที่อ่อน — สามารถข้ามได้",
      },
    ],
  },
  {
    id: "mcq",
    icon: GraduationCap,
    title: "ทำข้อสอบ MCQ / NL",
    content: [
      {
        subtitle: "โหมดฝึกซ้อม (Practice)",
        text: "เลือกวิชาหรือสุ่มทุกวิชา ไม่จับเวลา เฉลยพร้อมคำอธิบายทันทีหลังตอบ สมาชิกฟรี: 5 ข้อ/เดือน/วิชา | Premium: ไม่จำกัด",
      },
      {
        subtitle: "โหมดจำลองสอบ (Mock Exam)",
        text: "เลือก 20/50/100 ข้อ จับเวลา 1 นาที/ข้อ สุ่มจากทุกวิชา เฉลยแสดงหลังทำเสร็จทั้งชุด แสดงคะแนนรวม + แยกรายวิชา",
      },
    ],
  },
  {
    id: "meq",
    icon: FileText,
    title: "ทำข้อสอบ MEQ",
    content: [
      {
        subtitle: "เลือกข้อสอบ",
        text: "กรองตามหมวดหมู่ (อายุรศาสตร์, ศัลยศาสตร์, กุมาร, สูติ, ออร์โธ, จิตเวช) ความยาก (ง่าย/กลาง/ยาก) และฟรี/Premium",
      },
      {
        subtitle: "รูปแบบข้อสอบ",
        text: "แต่ละข้อสอบมี 6 ตอน: Initial Assessment → Lab Interpretation → Differential Diagnosis → Definitive Diagnosis → Management → Complications พิมพ์คำตอบแล้วส่งทีละตอน",
      },
      {
        subtitle: "ตรวจคำตอบ",
        text: "ดูเฉลย + Key Points ให้คะแนนตัวเอง (0-10) หรือกด \"AI ตรวจให้\" เพื่อให้ AI ให้คะแนนอัตโนมัติ",
      },
    ],
  },
  {
    id: "longcase",
    icon: Stethoscope,
    title: "Long Case กับ AI",
    content: [
      {
        subtitle: "จำลองการสอบ OSCE",
        text: "ใช้เวลาประมาณ 30 นาที/เคส ซักประวัติ AI คนไข้ → ตรวจร่างกาย → สั่ง Lab → วินิจฉัย + รักษา → สัมภาษณ์กับ AI กรรมการ",
      },
      {
        subtitle: "การให้คะแนน",
        text: "AI ให้คะแนน 5 หมวด: History / PE / Lab / DDx / Management พร้อม Teaching Points และ Feedback สมาชิกฟรี: 1 เคส/เดือน | Premium: ไม่จำกัด",
      },
    ],
  },
  {
    id: "payment",
    icon: CreditCard,
    title: "สมัครสมาชิก & ชำระเงิน",
    content: [
      {
        subtitle: "แพ็กเกจ",
        text: "ฟรี (จำกัดจำนวน) | รายเดือน ฿199 | รายปี ฿1,490 (ประหยัด 38%) | ชุดข้อสอบ ฿299 — ทุกแพ็กเกจจ่ายครั้งเดียว ไม่ต่ออัตโนมัติ",
      },
      {
        subtitle: "วิธีชำระเงิน",
        text: "บัตรเครดิต/เดบิต (เปิดใช้ทันที) หรือโอนเงินผ่านธนาคาร (รอตรวจสอบ 1-2 ชั่วโมง) ระบบจะเปิดสิทธิ์อัตโนมัติ + แจ้งเตือนทาง LINE และ Email",
      },
    ],
  },
  {
    id: "line",
    icon: MessageCircle,
    title: "เชื่อมต่อ LINE",
    content: [
      {
        subtitle: "สิทธิพิเศษ",
        text: "เชื่อมต่อ LINE เพื่อรับ: ข้อสอบรายวันทุกเช้า 7:00 น. + สรุปผลรายสัปดาห์ + เตือนก่อนสมาชิกหมดอายุ",
      },
      {
        subtitle: "วิธีเชื่อมต่อ",
        text: "(1) เพิ่มเพื่อน LINE OA @508srmcr (2) ไปหน้า Profile กดสร้างรหัสเชื่อมต่อ (3) ส่งรหัสในแชท LINE OA (4) ระบบจะแจ้ง \"เชื่อมต่อสำเร็จ\"",
      },
    ],
  },
  {
    id: "referral",
    icon: Users,
    title: "ชวนเพื่อน รับ 30 วันฟรี",
    content: [
      {
        subtitle: "วิธีใช้",
        text: "(1) ไปหน้า Profile กดสร้างรหัสชวนเพื่อน (2) คัดลอกลิงก์ส่งให้เพื่อน (3) เมื่อเพื่อนสมัคร + ซื้อแพ็กเกจ คุณได้ +30 วันทันที ไม่จำกัดจำนวนเพื่อน!",
      },
    ],
  },
  {
    id: "dashboard",
    icon: Brain,
    title: "Dashboard & สถิติ",
    content: [
      {
        subtitle: "สรุปผลการเรียน",
        text: "จำนวนข้อที่ทำ ความแม่นยำรวม Streak (วันติดต่อกัน) เวลาเฉลี่ย/ข้อ แถบเป้าหมายรายวัน",
      },
      {
        subtitle: "วิเคราะห์จุดอ่อน",
        text: "วิชาที่ได้ต่ำกว่า 60% จะแสดงเป็น \"ต้องทบทวน\" พร้อมปุ่มฝึกเพิ่ม + เปรียบเทียบคะแนนกับค่าเฉลี่ยของผู้ใช้ทั้งหมด",
      },
    ],
  },
];

const faqs = [
  { q: "สมาชิกฟรีทำอะไรได้บ้าง?", a: "MCQ 5 ข้อ/เดือน/วิชา, MEQ 2 ข้อ/เดือน, Long Case 1 ครั้ง/เดือน ทดลองใช้งานได้ทุกฟีเจอร์" },
  { q: "ซื้อแล้วยกเลิกได้ไหม?", a: "แพ็กเกจเป็นแบบจ่ายครั้งเดียว ไม่ต่ออัตโนมัติ ไม่มี recurring charge ใช้ได้ตามจำนวนวันที่ซื้อ" },
  { q: "หมดอายุแล้วข้อมูลหายไหม?", a: "ไม่หาย ประวัติการทำข้อสอบ คะแนน สถิติ ยังอยู่ครบ แค่จำกัดจำนวนข้อที่ทำได้ต่อเดือน" },
  { q: "ชำระเงินแล้วยังไม่ได้ Premium?", a: "ระบบเปิดอัตโนมัติ ถ้ายังไม่ได้: รีเฟรชหน้าเว็บ → รอ 5 นาที → ติดต่อ LINE OA @508srmcr" },
  { q: "ข้อสอบมาจากไหน?", a: "ข้อสอบสร้างโดย AI (Claude) ที่มี medical knowledge ระดับ evidence-based เพิ่มข้อสอบใหม่ทุกวัน" },
  { q: "Long Case ต่างจาก MEQ ยังไง?", a: "MEQ เป็นข้อเขียน 6 ตอน ส่วน Long Case จำลอง OSCE จริง — ซักประวัติ AI คนไข้ ตรวจร่างกาย สั่ง Lab แล้วนำเสนอเคสกับ AI กรรมการ" },
];

export default function GuidePage() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-3xl font-bold mb-3">คู่มือการใช้งาน</h1>
        <p className="text-muted-foreground text-lg">
          เรียนรู้วิธีใช้หมอรู้เพื่อเตรียมสอบแพทย์อย่างมีประสิทธิภาพ
        </p>
      </div>

      {/* Quick Nav */}
      <nav className="mb-12 rounded-xl border bg-muted/30 p-4">
        <p className="text-sm font-medium mb-3">สารบัญ</p>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
          {sections.map((s) => (
            <a
              key={s.id}
              href={`#${s.id}`}
              className="flex items-center gap-2 rounded-lg px-3 py-2 text-sm hover:bg-brand/10 hover:text-brand transition-colors"
            >
              <s.icon className="h-4 w-4 shrink-0" />
              <span>{s.title}</span>
            </a>
          ))}
        </div>
      </nav>

      {/* Sections */}
      <div className="space-y-12">
        {sections.map((s) => (
          <section key={s.id} id={s.id} className="scroll-mt-24">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-lg bg-brand/10 flex items-center justify-center">
                <s.icon className="h-5 w-5 text-brand" />
              </div>
              <h2 className="text-xl font-bold">{s.title}</h2>
            </div>
            <div className="space-y-4 pl-13">
              {s.content.map((c, i) => (
                <div key={i} className="rounded-lg border p-4">
                  <h3 className="font-semibold mb-1">{c.subtitle}</h3>
                  <p className="text-muted-foreground text-sm leading-relaxed">{c.text}</p>
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>

      {/* FAQ */}
      <section id="faq" className="mt-16 scroll-mt-24">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-lg bg-brand/10 flex items-center justify-center">
            <HelpCircle className="h-5 w-5 text-brand" />
          </div>
          <h2 className="text-xl font-bold">คำถามที่พบบ่อย</h2>
        </div>
        <div className="space-y-3">
          {faqs.map((f, i) => (
            <details key={i} className="group rounded-lg border p-4">
              <summary className="font-medium cursor-pointer list-none flex items-center justify-between">
                {f.q}
                <span className="text-muted-foreground group-open:rotate-180 transition-transform">▼</span>
              </summary>
              <p className="mt-2 text-sm text-muted-foreground">{f.a}</p>
            </details>
          ))}
        </div>
      </section>

      {/* CTA */}
      <div className="mt-12 rounded-xl bg-brand/10 border border-brand/20 p-6 text-center">
        <h2 className="text-lg font-semibold mb-2">มีคำถามเพิ่มเติม?</h2>
        <p className="text-sm text-muted-foreground mb-4">
          ติดต่อเราทาง LINE OA หรือส่ง feedback ได้เลย
        </p>
        <div className="flex justify-center gap-3 flex-wrap">
          <a
            href="https://line.me/R/ti/p/@508srmcr"
            target="_blank"
            rel="noopener noreferrer"
            className="rounded-lg bg-[#06C755] px-5 py-2 text-sm font-medium text-white hover:opacity-90 transition-opacity"
          >
            LINE OA @508srmcr
          </a>
          <Link
            href="/feedback"
            className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90 transition-colors"
          >
            ส่ง Feedback
          </Link>
        </div>
      </div>
    </div>
  );
}
