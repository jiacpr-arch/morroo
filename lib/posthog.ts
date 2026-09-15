"use client";

/**
 * PostHog สำหรับเว็บหมอรู้หลัก (แยกจาก lib/firstaid/posthog.ts ที่ใช้ key ของ
 * ส่วน firstaid) — โหลดแบบ lazy (dynamic import) เพื่อไม่เพิ่มน้ำหนัก bundle แรก
 * และเงียบสนิทเมื่อไม่ตั้ง NEXT_PUBLIC_POSTHOG_KEY (preview/fork ไม่มี key
 * จะไม่โหลดสคริปต์เลย) — แพทเทิร์นเดียวกับ Clarity ใน layout
 *
 * ตั้งค่าเน้นความเป็นส่วนตัว + ประหยัดโควตา:
 * - person_profiles: "identified_only" — ผู้เยี่ยมชมที่ไม่ล็อกอินไม่ถูกสร้างโปรไฟล์
 * - autocapture ปิด — เก็บเฉพาะ event ที่เราตั้งใจยิงผ่าน lib/analytics
 * - $pageview จับเองผ่าน history_change (SPA navigation ของ App Router)
 */

import type { PostHog } from "posthog-js";
import { attributionEventProps, getBrowserStores } from "@/lib/attribution";

const KEY = process.env.NEXT_PUBLIC_POSTHOG_KEY;
const HOST = process.env.NEXT_PUBLIC_POSTHOG_HOST || "https://us.i.posthog.com";

let client: PostHog | null = null;
let loading: Promise<void> | null = null;

/** เริ่มโหลด PostHog (ครั้งเดียว) — คืน promise ที่ resolve เมื่อพร้อมใช้ */
export function initPostHog(): Promise<void> {
  if (!KEY || typeof window === "undefined") return Promise.resolve();
  if (!loading) {
    loading = import("posthog-js")
      .then(({ default: posthog }) => {
        posthog.init(KEY, {
          api_host: HOST,
          person_profiles: "identified_only",
          capture_pageview: "history_change",
          capture_pageleave: false,
          autocapture: false,
        });
        client = posthog;
        // ลงทะเบียน utm ที่เราเก็บเอง (lib/attribution.ts) เป็น super property
        // ทันทีหลัง init — ทับค่าที่ PostHog auto-register จาก URL ปัจจุบันเอง
        // (ซึ่งเป็นแค่ last-URL ไม่ใช่ first/last-touch ของจริงที่เราคำนวณ) ทำให้
        // $pageview อัตโนมัติหลังจากนี้ก็ยังพก utm ไปด้วย
        const attrProps = attributionEventProps(getBrowserStores());
        if (attrProps) posthog.register(attrProps);
      })
      .catch(() => {
        // โหลดไม่ได้ (adblock/เน็ตล่ม) — เว็บทำงานต่อตามปกติ
      });
  }
  return loading;
}

/** ยิง event — ถ้ายังโหลดไม่เสร็จจะรอให้พร้อมก่อนแล้วค่อยยิง (ไม่ทิ้ง event) */
export function phCapture(event: string, props?: Record<string, unknown>): void {
  if (!KEY || typeof window === "undefined") return;
  if (client) {
    client.capture(event, props);
    return;
  }
  initPostHog().then(() => client?.capture(event, props));
}

/** ลงทะเบียน super property ใหม่ (เช่น utm ที่เพิ่งอัปเดตตอน navigate ในเว็บ) */
export function phRegister(props: Record<string, unknown>): void {
  if (!KEY || typeof window === "undefined") return;
  if (client) {
    client.register(props);
    return;
  }
  initPostHog().then(() => client?.register(props));
}

/** ผูก event เข้ากับผู้ใช้ที่ล็อกอิน (ใช้ Supabase user id — ไม่ส่งอีเมล/PII) */
export function phIdentify(distinctId: string): void {
  if (!KEY || typeof window === "undefined") return;
  if (client) {
    client.identify(distinctId);
    return;
  }
  initPostHog().then(() => client?.identify(distinctId));
}

/** ล้าง identity ตอน logout เพื่อไม่ให้ event ของคนถัดไปในเครื่องเดียวกันปนกัน */
export function phReset(): void {
  client?.reset();
}
