import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import CheckinStub from "../../_shared/CheckinStub";

export const metadata: Metadata = {
  title: "สแกน QR เช็คชื่อ | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/checkin/scan") },
};

export default function Page() {
  return <CheckinStub />;
}
