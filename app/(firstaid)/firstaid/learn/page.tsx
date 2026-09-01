import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import LearnClient from "./LearnClient";

export const metadata: Metadata = {
  title: "บทเรียนปฐมพยาบาลเบื้องต้น — เรียนออนไลน์ฟรี | Jia Training Center",
  alternates: { canonical: faUrl("/learn") },
};

export default function Page() {
  return <LearnClient />;
}
