import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import LineCallbackClient from "./LineCallbackClient";

export const metadata: Metadata = {
  title: "กำลังเข้าสู่ระบบ… | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/auth/line/callback") },
  robots: { index: false },
};

export default function Page() {
  return <LineCallbackClient />;
}
