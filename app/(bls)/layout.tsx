import type { Metadata, Viewport } from "next";
import { Noto_Sans_Thai } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "../globals.css";

// Second root layout (route group) for the bls.morroo.com section — same
// pattern as app/(acls)/layout.tsx: shares morroo's globals.css + shadcn/ui
// component system, accent color scoped per course via AccentThemeProvider.
const notoSansThai = Noto_Sans_Thai({
  variable: "--font-noto-thai",
  subsets: ["thai", "latin"],
  weight: ["400", "500", "600", "700", "800"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://bls.morroo.com"),
  title: "หลักสูตร BLS Provider | เรียนออนไลน์ + ฝึกสถานการณ์จำลอง — Jia Training Center",
  description:
    "หลักสูตร Basic Life Support (BLS) for Healthcare Providers มาตรฐาน ILCOR 2025 สำหรับบุคลากรทางการแพทย์: บทเรียนออนไลน์, ฝึกสถานการณ์จำลอง, แนวทาง AED, สอบและรับใบเซอร์อายุ 2 ปี",
  alternates: { canonical: "https://bls.morroo.com/" },
  openGraph: {
    type: "website",
    siteName: "BLS by Jia Training Center",
    title: "หลักสูตร BLS Provider — เรียนออนไลน์ + ฝึกสถานการณ์จำลอง",
    description:
      "Basic Life Support for Healthcare Providers มาตรฐาน ILCOR 2025 สำหรับบุคลากรทางการแพทย์",
    url: "https://bls.morroo.com/",
    locale: "th_TH",
  },
  twitter: {
    card: "summary_large_image",
    title: "หลักสูตร BLS Provider — เรียนออนไลน์ + ฝึกสถานการณ์จำลอง",
    description: "Basic Life Support for Healthcare Providers มาตรฐาน ILCOR 2025",
  },
};

export const viewport: Viewport = {
  themeColor: "#0284C7",
};

export default function BlsRootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="th" className={notoSansThai.variable}>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
