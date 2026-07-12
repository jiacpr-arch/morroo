import type { Metadata } from "next";
import Link from "next/link";
import EkgQuiz from "@/components/acls-reader/EkgQuiz";

export const metadata: Metadata = {
  title: "ฝึกอ่าน EKG",
  description: "แบบฝึกอ่านจังหวะคลื่นไฟฟ้าหัวใจ ACLS พร้อมเฉลยและคำใบ้",
};

export default function EkgPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls-reader" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">ฝึกอ่าน EKG</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">ฝึกอ่าน EKG</h1>
        <p className="mt-2 text-muted-foreground">
          ดูคลื่นแล้วเลือกจังหวะที่ถูกต้อง — มีเฉลยและคำใบ้ทุกข้อ
        </p>
      </header>

      <EkgQuiz />
    </div>
  );
}
