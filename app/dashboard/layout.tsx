import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dashboard",
  description:
    "ดูสถิติการเรียน คะแนนรายสาขา แผนติว AI และ Badge ของคุณ — หมอรู้ MorRoo",
};

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return children;
}
