import type { MetadataRoute } from "next";

// Web app manifest for www.morroo.com, served at /manifest.webmanifest and
// linked from app/(morroo)/layout.tsx (metadata.manifest).
//
// A route handler inside the (morroo) group rather than the app/manifest.ts
// file convention on purpose: the file convention auto-injects
// <link rel="manifest"> into EVERY root layout, including (firstaid) and
// (games). firstaid.morroo.com serves its own manifest at the same public
// path (the middleware host-rewrite maps it to /firstaid/manifest.webmanifest)
// and game.morroo.com has none — so morroo's manifest stays scoped to morroo.
//
// Installability matters for Web Push on iOS: Safari only exposes PushManager
// to a site that was added to the home screen (iOS 16.4+).

const manifest: MetadataRoute.Manifest = {
  id: "/",
  name: "หมอรู้ (MorRoo) — เตรียมสอบแพทย์ด้วย AI",
  short_name: "หมอรู้",
  description: "ข้อสอบ MEQ + MCQ + Long Case พร้อมเฉลยละเอียด เตรียมสอบแพทย์ด้วย AI",
  lang: "th",
  // Logged-out users get bounced to /login by the dashboard itself.
  start_url: "/dashboard?utm_source=pwa&utm_medium=homescreen",
  scope: "/",
  display: "standalone",
  theme_color: "#16A085",
  background_color: "#ffffff",
  icons: [
    { src: "/icons/morroo-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
    { src: "/icons/morroo-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
    { src: "/icons/morroo-maskable-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
  ],
};

export function GET() {
  return new Response(JSON.stringify(manifest), {
    headers: {
      "Content-Type": "application/manifest+json",
      "Cache-Control": "public, max-age=3600",
    },
  });
}
