// Analytics ของระบบ CPR — ใช้ Meta Pixel ตัวเดียวกับ morroo (init ที่ root layout แล้ว
// ห้าม init ซ้ำที่นี่) + PostHog โปรเจกต์ของ JIA (คง A/B flag `gate_placement`)
import { track } from "@vercel/analytics";
import { POSTHOG_HOST, POSTHOG_KEY } from "./config";

// แมป event ภายใน → Meta standard event เพื่อใช้เป็นเป้า optimize โฆษณาได้ตรงๆ
export const FB_EVENT_MAP: Record<string, string> = {
  signup_complete: "CompleteRegistration", // สมัครสำเร็จ = คอนเวอร์ชันหลัก
  register_complete: "CompleteRegistration", // ลงทะเบียนรับใบประกาศฯ
  line_oa_added: "Lead", // แอด LINE OA แล้ว
  line_oa_confirm_added: "Lead", // กดยืนยัน "เพิ่มเพื่อนแล้ว"
  teaser_quiz_complete: "ViewContent", // ทำควิซเกริ่นนำจบ (สนใจจริง)
};

type Props = Record<string, unknown> | undefined;

declare global {
  interface Window {
    fbq?: (...args: unknown[]) => void;
  }
}

export const fbTrack = (name: string, props?: Props) => {
  try {
    if (typeof window === "undefined" || !window.fbq) return;
    const std = FB_EVENT_MAP[name];
    if (std) window.fbq("track", std, props || {});
    else window.fbq("trackCustom", name, props || {}); // เก็บ event ที่เหลือไว้ทำ Custom Audience
  } catch (_e) {}
};

export const safeTrack = (name: string, props?: Props) => {
  try {
    track(name, props as Parameters<typeof track>[1]);
  } catch (_e) {}
  try {
    fbTrack(name, props);
  } catch (_e) {}
};

// PostHog (โหลด on-demand) — โปรเจกต์ของ JIA แยกจาก PostHog ตัวอื่นของ morroo
type PostHogLike = {
  init: (key: string, opts: Record<string, unknown>) => void;
  capture: (name: string, props?: Props) => void;
  onFeatureFlags: (cb: () => void) => void;
  getFeatureFlag: (flag: string) => unknown;
};
let _ph: PostHogLike | null = null;
let _phTried = false;
export const getPosthog = async (): Promise<PostHogLike | null> => {
  if (_phTried) return _ph;
  _phTried = true;
  if (!POSTHOG_KEY) return null;
  try {
    const mod = await import("posthog-js");
    const posthog = (mod.default || mod) as unknown as PostHogLike;
    posthog.init(POSTHOG_KEY, { api_host: POSTHOG_HOST, capture_pageview: false });
    _ph = posthog;
    return posthog;
  } catch (_e) {
    return null;
  }
};
export const phCapture = (name: string, props?: Props) => {
  getPosthog().then((ph) => {
    try {
      if (ph) ph.capture(name, props);
    } catch (_e) {}
  });
};
