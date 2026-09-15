// ย้าย logic ไปที่ lib/in-app-browser.ts (2026-09-15) เพื่อให้เกมเคสใช้ร่วมได้
// โดยไม่ต้อง import เข้า lib/firstaid/* — ไฟล์นี้เหลือไว้เป็น re-export เพื่อไม่
// กระทบ components/firstaid/InAppBrowserNotice.tsx ที่ import จากที่นี่อยู่เดิม
export {
  detectInAppBrowser,
  detectInAppBrowserFromUA,
  shouldWarnInAppBrowser,
} from "@/lib/in-app-browser";
