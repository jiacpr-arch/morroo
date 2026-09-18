import type { Metadata } from "next";
import { Sarabun } from "next/font/google";
import Link from "next/link";
import { Analytics } from "@vercel/analytics/next";
import { Activity, ArrowUpRight, Gamepad2 } from "lucide-react";
import { Suspense } from "react";
import AnalyticsPageviewTracker from "@/components/AnalyticsPageviewTracker";
import PostHogInit from "@/components/PostHogInit";
import "../globals.css";

// Root layout ที่สองสำหรับ game.morroo.com — เสิร์ฟผ่าน host-rewrite ใน
// middleware.ts และตัด Navbar/Footer ฝั่งเว็บหลักออก เพื่อให้เป็น hub อิสระ

// pixel ตัวเดียวกับเว็บหลัก (app/(morroo)/layout.tsx) — hub เป็นปลายทางของ
// โฆษณาแต่ก่อนหน้านี้ไม่มี pixel เลย ทำให้คนที่จ่ายเงินพาเข้ามามองไม่เห็นใน
// Meta ทั้งหมด: ไม่เข้า Custom Audience (retarget ไม่ได้) และไม่ได้ cookie
// _fbp ซึ่ง fbq ตั้งบนโดเมนแม่ morroo.com — พอผู้เล่นกดต่อไปเกมบน
// www.morroo.com ฝั่ง CAPI (app/api/track/casegame) จึงไม่มี _fbp ให้แนบ
// แล้ว Meta attribute conversion กลับไปหาโฆษณาไม่ได้
const FB_PIXEL_ID = "966371002896288";

const sarabun = Sarabun({
  variable: "--font-sarabun",
  subsets: ["thai", "latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://game.morroo.com"),
  title: "Morroo Games — รวมเกมฝึกช่วยชีวิตและเกมเคสการแพทย์",
  description:
    "เกมฝึกช่วยชีวิตครบทุกระดับ: ปฐมพยาบาล CPR สำหรับประชาชน, BLS/ACLS สำหรับบุคลากร, เกมเคสจากข้อสอบจริงสำหรับแพทย์ — เล่นฟรีเกือบทุกเกม",
  alternates: { canonical: "https://game.morroo.com/" },
  openGraph: {
    type: "website",
    siteName: "Morroo Games",
    title: "Morroo Games — รวมเกมฝึกช่วยชีวิต",
    description:
      "เลือกเกมที่ตรงกับระดับของคุณ: ประชาชนทั่วไป · บุคลากรทางการแพทย์ · แพทย์",
    url: "https://game.morroo.com/",
    locale: "th_TH",
  },
};

export default function GamesRootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="th" className={`${sarabun.variable} scroll-smooth`}>
      <head>
        {/* inline แบบเดียวกับ (morroo) layout — ไม่ใช้ next/script เพื่อให้ fbq
            พร้อมก่อน hydration และโผล่ใน SSR HTML */}
        <script
          dangerouslySetInnerHTML={{
            __html: `!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');fbq('init','${FB_PIXEL_ID}');fbq('track','PageView');`,
          }}
        />
      </head>
      <body className="flex min-h-full flex-col bg-[#fbfdfc] font-sans text-slate-900 antialiased">
        <noscript>
          <img
            height="1"
            width="1"
            style={{ display: "none" }}
            src={`https://www.facebook.com/tr?id=${FB_PIXEL_ID}&ev=PageView&noscript=1`}
            alt=""
          />
        </noscript>
        <header className="sticky top-0 z-50 border-b border-slate-200/75 bg-white/88 backdrop-blur-xl">
          <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6 lg:px-8">
            <Link
              href="/"
              className="group flex items-center gap-2.5 rounded-lg focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-teal-600"
              aria-label="Morroo Games — หน้าหลัก"
            >
              <span className="relative flex h-9 w-9 items-center justify-center rounded-xl bg-[#0a2032] text-white shadow-sm">
                <Gamepad2 className="h-5 w-5" aria-hidden />
                <span className="absolute -right-0.5 -top-0.5 h-2.5 w-2.5 rounded-full border-2 border-white bg-[#ef5b5b]" />
              </span>
              <span className="text-lg font-black tracking-tight text-slate-900">
                Morroo <span className="text-teal-600">Games</span>
              </span>
            </Link>
            <a
              href="https://www.morroo.com?utm_source=morroo&utm_medium=games_hub&utm_content=header_home"
              className="group inline-flex items-center gap-1.5 rounded-full border border-slate-200 bg-white px-3.5 py-2 text-xs font-bold text-slate-600 shadow-sm transition hover:border-teal-200 hover:text-teal-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-teal-600 sm:text-sm"
            >
              <span className="hidden sm:inline">ไปที่</span> morroo.com
              <ArrowUpRight className="h-3.5 w-3.5 transition group-hover:-translate-y-0.5 group-hover:translate-x-0.5" aria-hidden />
            </a>
          </div>
        </header>

        <main className="flex-1">{children}</main>

        <footer className="border-t border-slate-200 bg-white">
          <div className="mx-auto flex max-w-6xl flex-col gap-5 px-4 py-8 text-sm text-slate-500 sm:flex-row sm:items-center sm:justify-between sm:px-6 lg:px-8">
            <div className="flex items-center gap-3">
              <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-teal-50 text-teal-700">
                <Activity className="h-5 w-5" aria-hidden />
              </span>
              <p>
                พัฒนาโดยทีมเดียวกับ{" "}
                <a href="https://www.morroo.com" className="font-bold text-slate-700 underline decoration-teal-300 underline-offset-4 hover:text-teal-700">
                  หมอรู้ (morroo.com)
                </a>
                {" "}และ Jia Training Center
              </p>
            </div>
            <p className="max-w-md text-xs leading-5 sm:text-right">
              เกมเพื่อการเรียนรู้ ไม่ใช้แทนการอบรมหรือคำแนะนำทางการแพทย์
            </p>
          </div>
        </footer>

        <Analytics />
        <PostHogInit />
        <Suspense fallback={null}>
          <AnalyticsPageviewTracker />
        </Suspense>
      </body>
    </html>
  );
}
