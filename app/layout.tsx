import type { Metadata } from "next";
import { Sarabun } from "next/font/google";
import { Geist_Mono } from "next/font/google";
import Script from "next/script";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import { BetaProvider } from "@/components/beta/BetaProvider";
import BetaWelcomeModal from "@/components/beta/BetaWelcomeModal";
import BetaPromoBanner from "@/components/beta/BetaPromoBanner";
import "./globals.css";

const GA_ID = process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID;

const sarabun = Sarabun({
  variable: "--font-sarabun",
  subsets: ["thai", "latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL("https://www.morroo.com"),
  title: {
    default: "หมอรู้ (MorRoo) — เตรียมสอบแพทย์ ด้วย AI ที่เข้าใจคุณ",
    template: "%s | หมอรู้ MorRoo",
  },
  description:
    "เตรียมสอบแพทย์ด้วย AI ข้อสอบ MEQ Progressive Case, MCQ 1,300+ ข้อ, Long Case กับ AI Patient & Examiner พร้อมเฉลยละเอียดจากผู้เชี่ยวชาญ",
  keywords: [
    "ข้อสอบ MEQ",
    "MCQ แพทย์",
    "สอบ NL",
    "สอบใบประกอบวิชาชีพแพทย์",
    "ติวสอบแพทย์",
    "Long Case",
    "หมอรู้",
    "MorRoo",
    "ข้อสอบแพทย์ออนไลน์",
    "เตรียมสอบ NL Step 3",
  ],
  openGraph: {
    type: "website",
    locale: "th_TH",
    url: "https://www.morroo.com",
    siteName: "หมอรู้ (MorRoo)",
    title: "หมอรู้ — เตรียมสอบแพทย์ ด้วย AI ที่เข้าใจคุณ",
    description:
      "ข้อสอบ MEQ + MCQ 1,300+ ข้อ + Long Case กับ AI พร้อมเฉลยละเอียด",
    images: [
      {
        url: "/opengraph-image",
        width: 1200,
        height: 630,
        alt: "หมอรู้ MorRoo — เตรียมสอบแพทย์ด้วย AI",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "หมอรู้ — เตรียมสอบแพทย์ ด้วย AI ที่เข้าใจคุณ",
    description: "ข้อสอบ MEQ + MCQ + Long Case พร้อมเฉลยละเอียด",
    images: ["/opengraph-image"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: { index: true, follow: true },
  },
  alternates: {
    canonical: "https://www.morroo.com",
  },
};

const organizationSchema = {
  "@context": "https://schema.org",
  "@type": "EducationalOrganization",
  name: "หมอรู้ (MorRoo)",
  url: "https://www.morroo.com",
  logo: "https://www.morroo.com/logo.png",
  description:
    "แพลตฟอร์มข้อสอบ MEQ + MCQ + Long Case สำหรับเตรียมสอบแพทย์",
  sameAs: ["https://www.facebook.com/morroo"],
};

const faqSchema = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: [
    {
      "@type": "Question",
      name: "ข้อสอบ MEQ คืออะไร?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "MEQ (Modified Essay Question) คือข้อสอบอัตนัยประยุกต์ที่ใช้ในการสอบใบประกอบวิชาชีพแพทย์ขั้นตอนที่ 3 เป็นข้อสอบแบบ Progressive Case ที่ให้ข้อมูลผู้ป่วยทีละส่วน",
      },
    },
    {
      "@type": "Question",
      name: "หมอรู้ต่างจากที่อื่นอย่างไร?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "หมอรู้ใช้ AI ตรวจคำตอบและให้ feedback ทันที มีทั้ง MEQ, MCQ 1,300+ ข้อ และ Long Case กับ AI Patient ที่จำลองสอบจริง",
      },
    },
    {
      "@type": "Question",
      name: "ทดลองใช้ฟรีได้ไหม?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "ได้ครับ สมัครฟรีเข้าถึง MCQ 5 ข้อต่อสาขา, MEQ 2 เคส และ Long Case 1 เคส โดยไม่ต้องใส่บัตรเครดิต",
      },
    },
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="th"
      className={`${sarabun.variable} ${geistMono.variable} h-full antialiased`}
    >
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationSchema) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }}
        />
      </head>
      <body className="min-h-full flex flex-col">
        {GA_ID && (
          <>
            <Script
              src={`https://www.googletagmanager.com/gtag/js?id=${GA_ID}`}
              strategy="afterInteractive"
            />
            <Script id="ga4-init" strategy="afterInteractive">
              {`window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}gtag('js',new Date());gtag('config','${GA_ID}');`}
            </Script>
          </>
        )}
        <BetaProvider>
          <BetaPromoBanner variant="sticky-top" />
          <Navbar />
          <main className="flex-1">{children}</main>
          <Footer />
          <BetaWelcomeModal />
        </BetaProvider>
      </body>
    </html>
  );
}
