import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import EmergencyCallClient from "./EmergencyCallClient";

export const metadata: Metadata = {
  title: "เหตุฉุกเฉิน — โทร 1669 | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/call") },
};

export default function Page() {
  return <EmergencyCallClient />;
}
