import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import CheckinStub from "../_shared/CheckinStub";

export const metadata: Metadata = {
  title: "เช็คชื่อภาคปฏิบัติ | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/checkin") },
};

export default function Page() {
  return <CheckinStub />;
}
