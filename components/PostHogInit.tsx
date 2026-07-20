"use client";

import { useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { initPostHog, phIdentify, phReset } from "@/lib/posthog";

/**
 * โหลด PostHog หลังหน้า render เสร็จ (ตอนเบราว์เซอร์ว่าง) เพื่อไม่กระทบ
 * ความเร็วโหลดแรก และผูก event เข้ากับ Supabase user id เมื่อล็อกอิน —
 * ไม่ตั้ง NEXT_PUBLIC_POSTHOG_KEY = คอมโพเนนต์นี้ไม่ทำอะไรเลย
 */
export default function PostHogInit() {
  useEffect(() => {
    if (!process.env.NEXT_PUBLIC_POSTHOG_KEY) return;

    const supabase = createClient();

    const start = () => {
      initPostHog().then(() => {
        supabase.auth
          .getUser()
          .then(({ data }: { data: { user: { id: string } | null } }) => {
            if (data.user) phIdentify(data.user.id);
          });
      });
    };

    // รอให้เบราว์เซอร์ว่างก่อนค่อยโหลด (fallback เป็น timer สั้นๆ ใน Safari)
    let idleId: number | undefined;
    let timerId: ReturnType<typeof setTimeout> | undefined;
    if ("requestIdleCallback" in window) {
      idleId = window.requestIdleCallback(start, { timeout: 3000 });
    } else {
      timerId = setTimeout(start, 1500);
    }

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(
      (event: string, session: { user: { id: string } } | null) => {
        if (session?.user) phIdentify(session.user.id);
        if (event === "SIGNED_OUT") phReset();
      }
    ) as { data: { subscription: { unsubscribe: () => void } } };

    return () => {
      if (idleId !== undefined) window.cancelIdleCallback?.(idleId);
      if (timerId !== undefined) clearTimeout(timerId);
      subscription.unsubscribe();
    };
  }, []);

  return null;
}
