import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import CertificateClient from "./CertificateClient";

export const metadata: Metadata = {
  title: "ใบประกาศของฉัน — ภาคทฤษฎีและปฏิบัติ | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/certificate") },
};

export default function Page() {
  return <CertificateClient />;
}
