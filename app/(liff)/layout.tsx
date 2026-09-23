import type { Metadata } from "next";
import { Sarabun } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import { Suspense } from "react";
import AnalyticsPageviewTracker from "@/components/AnalyticsPageviewTracker";
import PostHogInit from "@/components/PostHogInit";
import "../globals.css";

// Second root layout (route group) for the /line/liff bridge — Phase 2 of
// docs/spec-line-liff.md. This page is a technical hand-off (LINE →
// Supabase session), never a marketing destination, so it deliberately
// skips everything app/(morroo)/layout.tsx carries: Navbar, Footer,
// ChatWidget, ExitIntentPopup, FirstVisitNudge, BetaPromoBanner,
// AiHealthProvider/AiStatusBanner, SignupConversion, and every ad pixel
// (GTM/FB/TikTok/Clarity) — none of that is relevant to a visitor who's
// mid-redirect inside the LINE in-app browser, and the popups in particular
// would visually stack on top of the LIFF card.
//
// Kept: Sarabun (the page renders Thai copy), Vercel Analytics + PostHog +
// pageview tracking (still useful to see how the bridge itself performs —
// success/error rates, drop-off), same as the (games) root layout.
const sarabun = Sarabun({
  variable: "--font-sarabun",
  subsets: ["thai", "latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://www.morroo.com"),
  title: "เชื่อมบัญชี LINE | หมอรู้ MorRoo",
  description: "กำลังเชื่อมบัญชี LINE กับหมอรู้ (MorRoo)",
  // Purely a technical hand-off page — never meant to show up in search.
  robots: { index: false, follow: false },
};

export default function LiffRootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="th" className={`${sarabun.variable} antialiased`}>
      <body className="min-h-full">
        {children}
        <Analytics />
        <PostHogInit />
        <Suspense fallback={null}>
          <AnalyticsPageviewTracker />
        </Suspense>
      </body>
    </html>
  );
}
