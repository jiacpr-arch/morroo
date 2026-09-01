import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import ExamClient from "../_shared/ExamClient";

export const metadata: Metadata = {
  title: "แบบทดสอบก่อนเรียน (Pre-test) | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/pre-test") },
};

export default function Page() {
  return <ExamClient kind="pre" />;
}
