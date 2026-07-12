import type { Metadata } from "next";
import BlsHubClient from "./BlsHubClient";

export const metadata: Metadata = {
  title: "เกมฝึก BLS 8 ด่าน — ปฐมพยาบาล",
  description:
    "เกมฝึกตัดสินใจช่วยชีวิต 8 ด่าน เคสต่อเนื่องจับเวลา ผ่านครบปลดข้อสอบรวม",
};

export default function BlsHubPage() {
  return <BlsHubClient />;
}
