import type { MetadataRoute } from "next";

// No manifest.ts existed before this phase (checked with `ls app/manifest.ts`).
// This is a single, site-wide route (there can only be one per app), so it
// covers morroo.com as a whole, not just /acls or /bls — start_url is
// therefore "/" (the main site root) rather than scoped into one course, so
// installing/opting into push from either course doesn't silently redirect
// an install shortcut away from the main site. Icons: morroo only ships
// public/app/favicon.ico today (no dedicated 192/512 PNG icons), so that's
// what's referenced here; a follow-up can add proper sized icons later.
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "หมอรู้ (MorRoo)",
    short_name: "MorRoo",
    description: "เตรียมสอบแพทย์ด้วย AI พร้อมคอร์ส ACLS/BLS และข่าวสารการช่วยชีวิต",
    start_url: "/",
    display: "standalone",
    background_color: "#ffffff",
    theme_color: "#16A085",
    icons: [
      {
        src: "/favicon.ico",
        sizes: "any",
        type: "image/x-icon",
      },
    ],
  };
}
