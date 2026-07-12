import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import SettingsClient from "./SettingsClient";

export const metadata: Metadata = {
  title: "ตั้งค่าการแสดงผลและบัญชี | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/settings") },
};

export default function Page() {
  return <SettingsClient />;
}
