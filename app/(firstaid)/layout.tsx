import type { Metadata, Viewport } from "next";
import { Noto_Sans_Thai } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import MetaPixel from "@/components/firstaid/MetaPixel";
import "./firstaid.css";

// Second root layout (route group) for the firstaid.morroo.com section.
// Deliberately does NOT include morroo's Navbar/Footer/GA4/GTM/TikTok or its
// Meta pixel — firstaid runs its own pixel (MetaPixel) and PostHog (inside
// FirstAidShell), keeping ad attribution per-host with no double-fire.
//
// Noto Sans Thai is self-hosted at build time by next/font (same-origin font
// files), which certificate PNG capture via html-to-image depends on.
const notoSansThai = Noto_Sans_Thai({
  variable: "--font-noto-thai",
  subsets: ["thai", "latin"],
  weight: ["400", "500", "600", "700", "800"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://firstaid.morroo.com"),
  title: "ปฐมพยาบาลเบื้องต้น | เรียนฟรี 1 ชม. รับใบประกาศ — Jia Training Center",
  description:
    "คอร์สปฐมพยาบาลออนไลน์ฟรีสำหรับบุคคลทั่วไป: บทเรียน (~1 ชม.), ผังช่วยชีวิตฉุกเฉิน, สถานการณ์จำลอง, สอบรับใบประกาศ โดย Jia Training Center",
  alternates: { canonical: "https://firstaid.morroo.com/" },
  icons: {
    icon: "/firstaid-favicon.svg",
    apple: "/cert-logo.png",
  },
  openGraph: {
    type: "website",
    siteName: "FirstAid by Jia Training Center",
    title: "เรียนปฐมพยาบาลฟรี 1 ชม. รับใบประกาศ",
    description:
      "4 นาที คือเส้นแบ่งชีวิต — เรียนปฐมพยาบาลเบื้องต้นออนไลน์ฟรี ทำ CPR/AED เป็น พร้อมใบประกาศ",
    url: "https://firstaid.morroo.com/",
    images: ["https://firstaid.morroo.com/cert-logo.png"],
    locale: "th_TH",
  },
  twitter: {
    card: "summary_large_image",
    title: "เรียนปฐมพยาบาลฟรี 1 ชม. รับใบประกาศ",
    description:
      "เรียนปฐมพยาบาลเบื้องต้นออนไลน์ฟรี ทำ CPR/AED เป็น พร้อมใบประกาศ โดย Jia Training Center",
  },
  manifest: "/manifest.webmanifest",
};

export const viewport: Viewport = {
  themeColor: "#16A34A",
};

export default function FirstAidRootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="th" className={notoSansThai.variable}>
      <body>
        {children}
        <Analytics />
        <MetaPixel />
      </body>
    </html>
  );
}
