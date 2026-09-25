"use client";

import { useEffect, useState } from "react";
import { Bell, BellOff, Loader2, Share, SquarePlus, ExternalLink } from "lucide-react";
import { track } from "@/lib/analytics";
import {
  SW_URL,
  getPushSupport,
  readPushEnv,
  urlBase64ToUint8Array,
  type PushSupport,
} from "@/lib/push-client";

const VAPID_PUBLIC_KEY = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;

const IN_APP_NAME: Record<"facebook" | "instagram" | "line", string> = {
  facebook: "Facebook",
  instagram: "Instagram",
  line: "LINE",
};

type Status = "checking" | "off" | "on" | "denied" | "busy";

async function getRegistration(): Promise<ServiceWorkerRegistration> {
  const existing = await navigator.serviceWorker.getRegistration("/");
  if (existing) return existing;
  await navigator.serviceWorker.register(SW_URL, { scope: "/", updateViaCache: "none" });
  return navigator.serviceWorker.ready;
}

/**
 * Profile-page toggle: "แจ้งเตือนบนเครื่องนี้" — subscribes THIS browser/device
 * to Web Push. Per-device on purpose: each phone/computer opts in separately.
 */
export default function PushToggle() {
  const [support, setSupport] = useState<PushSupport | null>(null);
  const [status, setStatus] = useState<Status>("checking");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    async function init() {
      const env = readPushEnv();
      if (!env) return;
      const s = getPushSupport(env);
      if (cancelled) return;
      setSupport(s);
      if (s.kind !== "supported") return;
      if (Notification.permission === "denied") {
        setStatus("denied");
        return;
      }
      try {
        const reg = await navigator.serviceWorker.getRegistration("/");
        const sub = reg ? await reg.pushManager.getSubscription() : null;
        if (!cancelled) setStatus(sub ? "on" : "off");
      } catch {
        if (!cancelled) setStatus("off");
      }
    }
    init();
    return () => {
      cancelled = true;
    };
  }, []);

  const enable = async () => {
    if (!VAPID_PUBLIC_KEY) {
      setError("ระบบแจ้งเตือนยังไม่เปิดใช้งาน");
      return;
    }
    setError(null);
    setStatus("busy");
    try {
      const permission = await Notification.requestPermission();
      if (permission !== "granted") {
        setStatus(permission === "denied" ? "denied" : "off");
        return;
      }
      const reg = await getRegistration();
      const sub =
        (await reg.pushManager.getSubscription()) ??
        (await reg.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
        }));
      const res = await fetch("/api/push/subscribe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ subscription: sub.toJSON() }),
      });
      if (!res.ok) throw new Error(`subscribe ${res.status}`);
      setStatus("on");
      track("push_optin", { result: "on" });
    } catch (err) {
      console.error("[push] enable failed:", err);
      setError("เปิดการแจ้งเตือนไม่สำเร็จ ลองใหม่อีกครั้ง");
      setStatus("off");
    }
  };

  const disable = async () => {
    setError(null);
    setStatus("busy");
    try {
      const reg = await navigator.serviceWorker.getRegistration("/");
      const sub = reg ? await reg.pushManager.getSubscription() : null;
      if (sub) {
        await fetch("/api/push/subscribe", {
          method: "DELETE",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ endpoint: sub.endpoint }),
        });
        await sub.unsubscribe();
      }
      setStatus("off");
      track("push_optin", { result: "off" });
    } catch (err) {
      console.error("[push] disable failed:", err);
      setError("ปิดการแจ้งเตือนไม่สำเร็จ ลองใหม่อีกครั้ง");
      setStatus("on");
    }
  };

  if (!support) return null;

  if (support.kind === "in_app") {
    return (
      <p className="flex items-start gap-2 rounded-lg bg-amber-50 border border-amber-200 px-3 py-2 text-sm text-amber-800">
        <ExternalLink className="h-4 w-4 mt-0.5 shrink-0" />
        <span>
          เบราว์เซอร์ในแอป {IN_APP_NAME[support.app]} รับการแจ้งเตือนไม่ได้ — กดเมนู
          &ldquo;เปิดในเบราว์เซอร์&rdquo; (Chrome/Safari) แล้วกลับมาเปิดที่หน้านี้อีกครั้ง
        </span>
      </p>
    );
  }

  if (support.kind === "ios_needs_install") {
    return (
      <div className="rounded-lg bg-muted/50 border px-3 py-2 text-sm space-y-1">
        <p className="font-medium">iPhone/iPad: ติดตั้งหมอรู้ลงหน้าจอหลักก่อน</p>
        <p className="text-muted-foreground">
          ใน Safari กด <Share className="inline h-4 w-4 -mt-0.5" /> แชร์ → เลือก{" "}
          <SquarePlus className="inline h-4 w-4 -mt-0.5" /> &ldquo;เพิ่มไปยังหน้าจอโฮม&rdquo;
          แล้วเปิดหมอรู้จากไอคอนบนหน้าจอ จากนั้นกลับมาเปิดการแจ้งเตือนที่หน้านี้ (iOS 16.4 ขึ้นไป)
        </p>
      </div>
    );
  }

  if (support.kind === "unsupported") {
    return (
      <p className="text-sm text-muted-foreground">
        เบราว์เซอร์นี้ยังไม่รองรับการแจ้งเตือน ลองใช้ Chrome, Edge, Firefox หรือ Safari เวอร์ชันล่าสุด
      </p>
    );
  }

  const on = status === "on";
  const busy = status === "busy" || status === "checking";

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between gap-3">
        <div className="min-w-0">
          <p className="text-sm font-medium flex items-center gap-1.5">
            {on ? <Bell className="h-4 w-4 text-brand" /> : <BellOff className="h-4 w-4 text-muted-foreground" />}
            แจ้งเตือนบนเครื่องนี้
          </p>
          <p className="text-xs text-muted-foreground mt-0.5">
            เตือนเมื่อยังไม่ได้ทำข้อสอบประจำวัน กันสตรีคขาด
          </p>
        </div>
        <button
          type="button"
          role="switch"
          aria-checked={on}
          aria-label="แจ้งเตือนบนเครื่องนี้"
          disabled={busy || status === "denied"}
          onClick={on ? disable : enable}
          className={`relative inline-flex h-6 w-11 shrink-0 items-center rounded-full transition-colors disabled:opacity-50 ${
            on ? "bg-brand" : "bg-gray-300"
          }`}
        >
          {busy ? (
            <Loader2 className="absolute left-1/2 -translate-x-1/2 h-4 w-4 animate-spin text-white" />
          ) : (
            <span
              className={`inline-block h-5 w-5 rounded-full bg-white shadow transition-transform ${
                on ? "translate-x-5" : "translate-x-0.5"
              }`}
            />
          )}
        </button>
      </div>
      {status === "denied" && (
        <p className="text-xs rounded px-2 py-1.5 bg-amber-50 text-amber-800 border border-amber-200">
          คุณบล็อกการแจ้งเตือนของเว็บนี้ไว้ — เปิดสิทธิ์ &ldquo;การแจ้งเตือน&rdquo; ในการตั้งค่าเว็บไซต์ของเบราว์เซอร์ แล้วรีเฟรชหน้านี้
        </p>
      )}
      {error && (
        <p className="text-xs rounded px-2 py-1.5 bg-red-50 text-red-600 border border-red-200">{error}</p>
      )}
    </div>
  );
}
