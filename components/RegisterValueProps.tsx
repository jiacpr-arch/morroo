import { BookOpen, Sparkles, ShieldCheck, Clock } from "lucide-react";

const PROPS = [
  {
    icon: BookOpen,
    title: "ทดลองฟรี ครบทุกฟีเจอร์",
    desc: "MCQ 5 ข้อ/สาขา · MEQ 2 เคส · Long Case 1 เคส",
  },
  {
    icon: Sparkles,
    title: "AI ตรวจคำตอบทันที",
    desc: "feedback ละเอียดจาก AI Examiner ภายในไม่กี่วินาที",
  },
  {
    icon: ShieldCheck,
    title: "ไม่ต้องใส่บัตรเครดิต",
    desc: "สมัครฟรีลองได้ทันที ใช้เวลา 30 วินาที",
  },
  {
    icon: Clock,
    title: "ยกเลิกได้ทุกเมื่อ",
    desc: "ไม่ผูกมัด รายเดือนแค่ ฿199 / รายปี ฿1,490",
  },
];

// Compact list of free-trial benefits rendered alongside the signup form. Pure
// presentational so it stays a server component and doesn't pull tracking;
// the form itself already fires signup_submit.
export default function RegisterValueProps() {
  return (
    <div className="rounded-2xl border bg-card p-5 sm:p-6 space-y-4">
      <div>
        <h2 className="text-lg font-bold">เริ่มฟรี ไม่ต้องใช้บัตรเครดิต</h2>
        <p className="text-sm text-muted-foreground mt-1">
          สมัคร 30 วินาที เข้าถึงคอนเทนต์เตรียมสอบครบครัน
        </p>
      </div>
      <ul className="space-y-3">
        {PROPS.map((p) => (
          <li key={p.title} className="flex items-start gap-3">
            <div className="shrink-0 mt-0.5 h-9 w-9 rounded-full bg-brand/10 flex items-center justify-center">
              <p.icon className="h-4 w-4 text-brand" />
            </div>
            <div className="flex-1">
              <div className="text-sm font-semibold text-foreground">{p.title}</div>
              <div className="text-xs text-muted-foreground mt-0.5">{p.desc}</div>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}
