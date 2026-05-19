import type { Metadata } from "next";
import Script from "next/script";
import { Sarabun } from "next/font/google";
import { Geist_Mono } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import { BetaProvider } from "@/components/beta/BetaProvider";
import BetaWelcomeModal from "@/components/beta/BetaWelcomeModal";
import BetaPromoBanner from "@/components/beta/BetaPromoBanner";
import ChatWidget from "@/components/ChatWidget";
import "./globals.css";

const GA_ID = process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID;
const TIKTOK_PIXEL_ID = "D80UTR3C77UEO91IVCV0";
const FB_PIXEL_ID = "966371002896288";
const GTM_ID = "GTM-5VGNTDV3";

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
  // FB requires fb:app_id meta on all pages that should be shareable via
  // Graph API `link` param — without it FB rejects with "url is invalid".
  other: {
    "fb:app_id": "1524889459310260",
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
          dangerouslySetInnerHTML={{
            __html: `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${GTM_ID}');`,
          }}
        />
        <script
          dangerouslySetInnerHTML={{
            __html: `!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');fbq('init','${FB_PIXEL_ID}');fbq('track','PageView');`,
          }}
        />
        <script
          dangerouslySetInnerHTML={{
            __html: `(function(){var p=new URLSearchParams(location.search),c=p.get('ttclid');if(c){var e=new Date();e.setDate(e.getDate()+30);document.cookie='ttclid='+c+';expires='+e.toUTCString()+';path=/;SameSite=Lax';}})();`,
          }}
        />
        <script
          dangerouslySetInnerHTML={{
            __html: `!function(w,d,t){w.TiktokAnalyticsObject=t;var ttq=w[t]=w[t]||[];ttq.methods=["page","track","identify","instances","debug","on","off","once","ready","alias","group","enableCookie","disableCookie","holdConsent","revokeConsent","grantConsent"],ttq.setAndDefer=function(t,e){t[e]=function(){t.push([e].concat(Array.prototype.slice.call(arguments,0)))}};for(var i=0;i<ttq.methods.length;i++)ttq.setAndDefer(ttq,ttq.methods[i]);ttq.instance=function(t){for(var e=ttq._i[t]||[],n=0;n<ttq.methods.length;n++)ttq.setAndDefer(e,ttq.methods[n]);return e},ttq.load=function(e,n){var r="https://analytics.tiktok.com/i18n/pixel/events.js",o=n&&n.partner;ttq._i=ttq._i||{},ttq._i[e]=[],ttq._i[e]._u=r,ttq._t=ttq._t||{},ttq._t[e]=+new Date,ttq._o=ttq._o||{},ttq._o[e]=n||{},n=document.createElement("script");n.type="text/javascript",n.async=!0,n.src=r+"?sdkid="+e+"&lib="+t;e=document.getElementsByTagName("script")[0];e.parentNode.insertBefore(n,e)};ttq.load('${TIKTOK_PIXEL_ID}');ttq.page();}(window,document,'ttq');`,
          }}
        />
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
        <noscript>
          <iframe
            src={`https://www.googletagmanager.com/ns.html?id=${GTM_ID}`}
            height="0"
            width="0"
            style={{ display: "none", visibility: "hidden" }}
          />
        </noscript>
        <noscript>
          <img
            height="1"
            width="1"
            style={{ display: "none" }}
            src={`https://www.facebook.com/tr?id=${FB_PIXEL_ID}&ev=PageView&noscript=1`}
            alt=""
          />
        </noscript>
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
          <ChatWidget />
        </BetaProvider>
        <Analytics />
      </body>
    </html>
  );
}
