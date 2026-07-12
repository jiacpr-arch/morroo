import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import HomeClient from "./HomeClient";

export const metadata: Metadata = {
  title:
    "ปฐมพยาบาลเบื้องต้น | เรียนฟรี 1 ชม. รับใบประกาศ — Jia Training Center",
  alternates: { canonical: faUrl("/") },
};

export default function Page() {
  return <HomeClient />;
}
