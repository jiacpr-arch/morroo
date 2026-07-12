"use client";
// ซ่อน chrome ของ morroo (Navbar/Footer/ป๊อปอัพ ฯลฯ) บนโซน /cpr ซึ่งเป็นแบรนด์ JIA แยกต่างหาก
// pattern เดียวกับ FloatingLineButton ที่เช็ค pathname อยู่แล้ว
import { usePathname } from "next/navigation";

export default function HideOnCprChrome({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  if (pathname === "/cpr" || pathname?.startsWith("/cpr/")) return null;
  return <>{children}</>;
}
