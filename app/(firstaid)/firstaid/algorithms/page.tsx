import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import AlgorithmIndexClient from "./AlgorithmIndexClient";

export const metadata: Metadata = {
  title: "ผังช่วยชีวิตฉุกเฉิน (Algorithm ปฐมพยาบาล) | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  alternates: { canonical: faUrl("/algorithms") },
};

export default function Page() {
  return <AlgorithmIndexClient />;
}
