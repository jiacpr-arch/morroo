import type { Metadata, Viewport } from "next";
import { Noto_Sans_Thai, Trirong } from "next/font/google";
import "./cpr.css";

// ฟอนต์ของแบรนด์ JIA (คนละชุดกับ Sarabun ของ morroo) — Trirong ใช้ในใบประกาศนียบัตร
const notoSansThai = Noto_Sans_Thai({
  variable: "--font-cpr-sans",
  subsets: ["thai", "latin"],
  weight: ["300", "400", "500", "600", "700", "800"],
  display: "swap",
});
const trirong = Trirong({
  variable: "--font-cpr-serif",
  subsets: ["thai", "latin"],
  weight: ["400", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "คอร์ส CPR & AED ออนไลน์ | JIA TRAINER CENTER",
    template: "%s | JIA TRAINER CENTER",
  },
  description:
    "เรียน CPR & AED ออนไลน์ มาตรฐาน 2025 — 6 บทเรียนวิดีโอ + แบบทดสอบ + ใบประกาศนียบัตร บทที่ 1 เรียนฟรี พร้อมคูปองส่วนลดคอร์สภาคปฏิบัติ ฿100",
  openGraph: {
    type: "website",
    locale: "th_TH",
    url: "https://www.morroo.com/cpr",
    siteName: "JIA TRAINER CENTER",
    title: "คอร์ส CPR & AED ออนไลน์ | JIA TRAINER CENTER",
    description: "เรียน CPR & AED ออนไลน์ มาตรฐาน 2025 — จบแล้วรับใบประกาศนียบัตร + คูปองส่วนลดคอร์ส On-site",
  },
  alternates: {
    canonical: "https://www.morroo.com/cpr",
  },
};

export const viewport: Viewport = {
  themeColor: "#C8102E",
};

export default function CprLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className={`cpr ${notoSansThai.variable} ${trirong.variable}`}>
      {children}
    </div>
  );
}
