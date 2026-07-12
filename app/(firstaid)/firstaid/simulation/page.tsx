import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import SimulationSelectClient from "./SimulationSelectClient";

export const metadata: Metadata = {
  title: "ฝึกสถานการณ์จำลองปฐมพยาบาล | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/simulation") },
};

export default function Page() {
  return <SimulationSelectClient />;
}
