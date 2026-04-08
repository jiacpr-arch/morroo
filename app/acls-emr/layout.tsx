import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "ACLS EMR — บันทึกการกู้ชีพ",
  description: "บันทึกและจัดการข้อมูลการกู้ชีพ ACLS พร้อมออก PDF Report",
};

export default function AclsEmrLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {children}
    </div>
  );
}
