import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import ExamClient from "../_shared/ExamClient";

export const metadata: Metadata = {
  title: "แบบทดสอบหลังเรียน (Post-test) | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/post-test") },
};

export default function Page() {
  return <ExamClient kind="post" />;
}
