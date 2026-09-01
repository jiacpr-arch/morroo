"use client";

import { useState } from "react";
import { useSettingsStore } from "@/lib/firstaid/stores/settingsStore";
import { useAuthStore } from "@/lib/firstaid/stores/authStore";
import { HouseAdList } from "@/components/firstaid/HouseAdBanner";
import LineLoginGate from "@/components/firstaid/LineLoginGate";
import { createClient } from "@/lib/supabase/client";
import { useMounted } from "../_shared/useMounted";

const THEMES = ["light", "dark", "system"] as const;

export default function SettingsClient() {
  const mounted = useMounted();
  const theme = useSettingsStore((s) => s.theme);
  const setTheme = useSettingsStore((s) => s.setTheme);

  const session = useAuthStore((s) => s.session);
  const authLoading = useAuthStore((s) => s.loading);
  const [showLogin, setShowLogin] = useState(false);
  const [signingOut, setSigningOut] = useState(false);

  // theme is persisted in localStorage — don't highlight a button until after
  // hydration or SSR markup and the first client render disagree.
  const activeTheme = mounted ? theme : "system";

  const signOut = async () => {
    if (signingOut) return;
    setSigningOut(true);
    try {
      await createClient().auth.signOut();
      // authStore's onAuthStateChange listener clears the session state.
    } finally {
      setSigningOut(false);
    }
  };

  return (
    <div className="page-container">
      <div style={{ marginTop: 8 }}>
        <div className="text-caption">ตั้งค่า</div>
        <div className="text-title">การแสดงผล</div>
      </div>
      <div className="card" style={{ marginTop: 12 }}>
        <label className="label">ธีม</label>
        <div style={{ display: "flex", gap: 8 }}>
          {THEMES.map((t) => (
            <button
              key={t}
              type="button"
              className={`btn ${activeTheme === t ? "btn-primary" : "btn-secondary"}`}
              style={{ flex: 1 }}
              onClick={() => setTheme(t)}
            >
              {t === "light" ? "สว่าง" : t === "dark" ? "มืด" : "ตามระบบ"}
            </button>
          ))}
        </div>
      </div>

      {/* บัญชี — LINE login (จำเป็นสำหรับปลดล็อกบทเรียนแบบเสียเงิน/redeem โค้ด)
          หน้า /settings เป็นจุด landing หลัง OAuth callback ด้วย */}
      <div className="card" style={{ marginTop: 12 }}>
        <label className="label">บัญชี</label>
        {authLoading ? (
          <div className="text-caption">กำลังตรวจสอบสถานะ…</div>
        ) : session ? (
          <>
            <div className="text-body" style={{ marginBottom: 10 }}>
              เข้าสู่ระบบด้วย LINE แล้ว — ความก้าวหน้าและสิทธิ์ปลดล็อกบทเรียนผูกกับบัญชีนี้
            </div>
            <button
              type="button"
              className="btn btn-secondary btn-block"
              disabled={signingOut}
              onClick={signOut}
            >
              {signingOut ? "กำลังออกจากระบบ…" : "ออกจากระบบ"}
            </button>
          </>
        ) : (
          <>
            <div className="text-body" style={{ marginBottom: 10 }}>
              เข้าสู่ระบบด้วย LINE เพื่อบันทึกความก้าวหน้าข้ามอุปกรณ์ และใช้สิทธิ์ปลดล็อกบทเรียน
            </div>
            <button
              type="button"
              className="btn btn-primary btn-block"
              onClick={() => setShowLogin(true)}
            >
              เข้าสู่ระบบด้วย LINE
            </button>
          </>
        )}
      </div>
      {showLogin && !session && <LineLoginGate />}

      <HouseAdList />
    </div>
  );
}
