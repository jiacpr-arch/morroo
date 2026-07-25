"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { xpToRank } from "@/lib/school/rank";

/** cache ต่อแท็บ — กันยิง query ซ้ำทุกครั้งที่ Navbar remount */
const CACHE_KEY = "morroo_rank_xp";

/**
 * ป้ายยศบนแถบเมนู — จุดเดียวที่ผู้เรียนเห็นได้ทุกหน้า
 *
 * Navbar เป็น client component ที่รู้จักแค่ auth user (ไม่เคยแตะตาราง profiles)
 * ตัวนี้จึงยิง query เอง 1 ครั้งต่อการโหลดหน้าเต็ม แล้ว cache ไว้ใน
 * sessionStorage เพื่อไม่ให้การเดินเมนูไปมากลายเป็นภาระ DB — ค่าอาจช้ากว่าจริง
 * ไปหนึ่งจังหวะ ซึ่งรับได้เพราะจอจบเกมรายงานยศสด ๆ อยู่แล้ว
 *
 * ซ่อนตัวเองเมื่อยังไม่ล็อกอินหรืออ่านไม่ได้ (แพทเทิร์นเดียวกับ BetaHeaderCounter)
 */
export default function NavbarRankChip() {
  const [xp, setXp] = useState<number | null>(null);

  useEffect(() => {
    let cancelled = false;
    const supabase = createClient();

    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        sessionStorage.removeItem(CACHE_KEY);
        if (!cancelled) setXp(null);
        return;
      }

      const cached = sessionStorage.getItem(CACHE_KEY);
      if (cached !== null && !cancelled) setXp(Number(cached));

      const { data } = await supabase
        .from("profiles")
        .select("school_xp")
        .eq("id", user.id)
        .maybeSingle();
      if (cancelled || !data) return;
      const value = data.school_xp ?? 0;
      sessionStorage.setItem(CACHE_KEY, String(value));
      setXp(value);
    }

    void load();
    // ล็อกอิน/ออกจากระบบระหว่างอยู่หน้าเดิม — ป้ายต้องตามให้ทัน
    const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
      sessionStorage.removeItem(CACHE_KEY);
      void load();
    });
    return () => {
      cancelled = true;
      subscription.unsubscribe();
    };
  }, []);

  if (xp === null) return null;

  const { rank, next, xpForNext, xpIntoRank } = xpToRank(xp);
  const title = next
    ? `${rank.trait} · อีก ${(xpForNext - xpIntoRank).toLocaleString("th-TH")} XP ถึง${next.title}`
    : rank.trait;

  return (
    <Link
      href="/profile"
      title={title}
      className="inline-flex items-center gap-1 rounded-full bg-amber-50 px-3 py-1 text-xs font-medium text-amber-800 ring-1 ring-amber-200 transition hover:bg-amber-100"
    >
      <span aria-hidden>{rank.icon}</span>
      <span>{rank.short}</span>
    </Link>
  );
}
