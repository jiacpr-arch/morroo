"use client";

import { useEffect, useState } from "react";
import { Bell, Check, X } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import {
  isPushSupported,
  getPermissionState,
  subscribePush,
  unsubscribePush,
  getCurrentSubscription,
  registerServiceWorker,
  type PushPermissionState,
} from "@/lib/courses/push-client";
import { dashCard, btnGhost, btnSm, textCaption } from "./course-ui";
import { cn } from "@/lib/utils";

// Ported from acls-emr's src/components/PushToggle.jsx. Registers the
// push-only service worker (public/course-sw.js) on mount, before checking
// permission/subscription state — push is opt-in, so this is the only place
// on morroo that ever registers a service worker.
export default function PushToggle({ course }: { course: CourseMode }) {
  const [supported, setSupported] = useState(false);
  const [permission, setPermission] = useState<PushPermissionState>("default");
  const [subscribed, setSubscribed] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const sup = isPushSupported();
    setSupported(sup);
    if (!sup) return;
    registerServiceWorker().then(() => {
      setPermission(getPermissionState());
      getCurrentSubscription().then((sub) => setSubscribed(!!sub));
    });
  }, []);

  if (!supported) return null;

  const handleEnable = async () => {
    setLoading(true);
    setError(null);
    try {
      await subscribePush(course);
      setSubscribed(true);
      setPermission("granted");
    } catch (e) {
      setError(String((e as Error)?.message || e));
      setPermission(getPermissionState());
    } finally {
      setLoading(false);
    }
  };

  const handleDisable = async () => {
    setLoading(true);
    setError(null);
    try {
      await unsubscribePush();
      setSubscribed(false);
    } catch (e) {
      setError(String((e as Error)?.message || e));
    } finally {
      setLoading(false);
    }
  };

  const blocked = permission === "denied";

  return (
    <div className={cn(dashCard, "flex items-center gap-3")}>
      <div
        className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg"
        style={{
          background: subscribed ? "rgba(5, 150, 105, 0.12)" : "rgba(37, 99, 235, 0.12)",
          color: subscribed ? "#059669" : "#2563EB",
        }}
      >
        <Bell size={18} strokeWidth={2.2} />
      </div>
      <div className="min-w-0 flex-1">
        <div className="text-sm font-semibold text-foreground">
          {subscribed ? "เปิดแจ้งเตือนข่าวแล้ว" : "รับแจ้งเตือนเมื่อมีข่าวใหม่"}
        </div>
        <div className={cn(textCaption, "mt-0.5 text-muted-foreground")}>
          {blocked
            ? "เบราว์เซอร์บล็อกการแจ้งเตือนไว้ — เปิดที่ Site settings ของเบราว์เซอร์"
            : subscribed
              ? "จะได้แจ้งเตือนทุกครั้งที่มีข่าวใหม่เกี่ยวกับ ACLS/BLS/CPR"
              : "แตะปุ่มแล้วอนุญาต notification เพื่อรับข่าวสำคัญ"}
        </div>
        {error && <div className={cn(textCaption, "mt-1 text-red-600 dark:text-red-400")}>{error}</div>}
      </div>
      {!blocked &&
        (subscribed ? (
          <button onClick={handleDisable} disabled={loading} className={cn(btnGhost, btnSm)}>
            <X size={14} strokeWidth={2.2} /> ปิด
          </button>
        ) : (
          <button
            onClick={handleEnable}
            disabled={loading}
            className={cn(btnGhost, btnSm, "bg-blue-600 text-white hover:bg-blue-700 hover:text-white")}
          >
            <Check size={14} strokeWidth={2.2} /> {loading ? "…" : "เปิด"}
          </button>
        ))}
    </div>
  );
}
