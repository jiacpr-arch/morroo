import type { Metadata } from "next";
import { Sarabun } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import { Suspense } from "react";
import AnalyticsPageviewTracker from "@/components/AnalyticsPageviewTracker";
import PostHogInit from "@/components/PostHogInit";
import "../globals.css";

// Root layout ที่สอง (route group) สำหรับ game.morroo.com — แพทเทิร์นเดียวกับ
// app/(firstaid)/layout.tsx: เสิร์ฟจากแอป morroo เดียวกันผ่าน host-rewrite ใน
// middleware.ts แต่ตัด Navbar/Footer/pixel ฝั่ง browser ของ morroo ออก ให้เป็น
// landing โล่งๆ สำหรับผู้ชมปนกันหลายระดับ (ประชาชนไม่ต้องเจอเมนูสายแพทย์)
// ยังคง Vercel Analytics + PostHog + pageview mirror ไว้ เพราะ funnel ของ hub
// (view → games_hub_click) วัดผ่าน lib/analytics ชุดเดียวกับ morroo
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
    <html lang="th" className={sarabun.variable}>
      <body className="flex min-h-full flex-col font-sans">
        <header className="border-b bg-background/80 backdrop-blur">
          <div className="mx-auto flex max-w-3xl items-center justify-between px-4 py-3 sm:px-6">
            <span className="text-lg font-black tracking-tight">
              Morroo <span className="text-brand">Games</span>
            </span>
            <a
              href="https://www.morroo.com?utm_source=morroo&utm_medium=games_hub&utm_content=header_home"
              className="text-sm font-semibold text-muted-foreground hover:text-brand"
            >
              morroo.com →
            </a>
          </div>
        </header>
        <main className="flex-1">{children}</main>
        <footer className="border-t py-6 text-center text-xs text-muted-foreground">
          ส่วนหนึ่งของ{" "}
          <a href="https://www.morroo.com" className="font-semibold underline">
            หมอรู้ (morroo.com)
          </a>{" "}
          · เกมเพื่อการเรียนรู้ ไม่ใช้แทนการอบรมหรือคำแนะนำทางการแพทย์
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
