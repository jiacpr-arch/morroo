import type { Metadata, Viewport } from "next";
import { Noto_Sans_Thai } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "../globals.css";

// Second root layout (route group) for the acls.morroo.com section — same
// pattern as app/(firstaid)/layout.tsx. Unlike firstaid, this imports
// morroo's own globals.css (shadcn/ui + design tokens) rather than an
// independent stylesheet: the consolidation plan calls for ACLS/BLS to share
// morroo's component system, with only the accent color scoped per course
// via AccentThemeProvider (see components/resus/AccentThemeProvider.tsx).
const notoSansThai = Noto_Sans_Thai({
  variable: "--font-noto-thai",
  subsets: ["thai", "latin"],
  weight: ["400", "500", "600", "700", "800"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://acls.morroo.com"),
  title: "หลักสูตร ACLS Provider | เรียนออนไลน์ + Code Blue Sim — Jia Training Center",
  description:
    "หลักสูตร Advanced Cardiovascular Life Support (ACLS) มาตรฐาน ILCOR 2025 สำหรับแพทย์และพยาบาล: บทเรียนออนไลน์, Code Blue Sim, คลังความรู้และยา ACLS, สอบและรับใบเซอร์อายุ 2 ปี",
  alternates: { canonical: "https://acls.morroo.com/" },
  openGraph: {
    type: "website",
    siteName: "ACLS by Jia Training Center",
    title: "หลักสูตร ACLS Provider — เรียนออนไลน์ + Code Blue Sim",
    description:
      "Advanced Cardiovascular Life Support มาตรฐาน ILCOR 2025 สำหรับบุคลากรทางการแพทย์",
    url: "https://acls.morroo.com/",
    locale: "th_TH",
  },
  twitter: {
    card: "summary_large_image",
    title: "หลักสูตร ACLS Provider — เรียนออนไลน์ + Code Blue Sim",
    description: "Advanced Cardiovascular Life Support มาตรฐาน ILCOR 2025",
  },
};

export const viewport: Viewport = {
  themeColor: "#1D4ED8",
};

export default function AclsRootLayout({
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
