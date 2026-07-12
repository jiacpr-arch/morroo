import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import NewsClient from "./NewsClient";

export const metadata: Metadata = {
  title: "ข่าวกู้ชีพ/AED จาก JiaAED | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/news") },
};

export default function Page() {
  return <NewsClient />;
}
