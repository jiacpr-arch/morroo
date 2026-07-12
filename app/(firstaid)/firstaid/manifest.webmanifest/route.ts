// Web app manifest for firstaid.morroo.com, served at /manifest.webmanifest
// (same URL the old PWA used, referenced from app/(firstaid)/layout.tsx).
// The app is no longer offline-first, but installed home-screen icons and
// "add to home screen" keep working.

const manifest = {
  name: "ปฐมพยาบาลเบื้องต้น — Jia Training Center",
  short_name: "ปฐมพยาบาล",
  start_url: "/",
  display: "standalone",
  theme_color: "#16A34A",
  background_color: "#F4F6FA",
  icons: [
    {
      src: "/firstaid-icon.svg",
      sizes: "any",
      type: "image/svg+xml",
      purpose: "maskable any",
    },
  ],
};

export function GET() {
  return new Response(JSON.stringify(manifest), {
    headers: {
      "Content-Type": "application/manifest+json",
    },
  });
}
