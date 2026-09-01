"use client";

import { useEffect, useState } from "react";

// ข่าวกู้ชีพ/AED จาก JiaAED public API (cache ฝั่ง server 5 นาที)
// เก็บผลล่าสุดลง localStorage เพื่อให้ยังแสดงได้เมื่อโหลดใหม่ไม่สำเร็จ — โหลดไม่ได้และไม่มี cache = ได้ []
const NEWS_API = "https://jiaaed.com/api/news/public";
const CACHE_PREFIX = "jiaaed-news-cache-v1";

export type JiaAedNewsItem = {
  id: string | number;
  topic?: string;
  source_title?: string;
  source_name?: string;
  source_url?: string;
  our_blurb?: string;
  published_at?: string;
};

function readCache(cacheKey: string): JiaAedNewsItem[] {
  // SSR-safe: client components still render on the server in Next.js.
  if (typeof localStorage === "undefined") return [];
  try {
    const items = JSON.parse(localStorage.getItem(cacheKey) || "null");
    return Array.isArray(items) ? items : [];
  } catch {
    return [];
  }
}

export function useJiaAedNews(limit: number) {
  const cacheKey = `${CACHE_PREFIX}-${limit}`;
  // เริ่มจาก [] เสมอ (ให้ server/client render ตรงกัน) แล้วค่อยอ่าน cache ใน effect
  const [items, setItems] = useState<JiaAedNewsItem[]>([]);

  useEffect(() => {
    const cached = readCache(cacheKey);
    if (cached.length > 0) setItems(cached);

    const controller = new AbortController();
    fetch(`${NEWS_API}?limit=${limit}`, { signal: controller.signal })
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (!data?.ok || !Array.isArray(data.items)) return;
        setItems(data.items);
        try {
          localStorage.setItem(cacheKey, JSON.stringify(data.items));
        } catch {
          // storage เต็ม/ปิดใช้งาน — ข้ามได้ แค่เสีย cache
        }
      })
      .catch(() => {});
    return () => controller.abort();
  }, [limit, cacheKey]);

  return items;
}
