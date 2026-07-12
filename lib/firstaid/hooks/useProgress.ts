"use client";

import { useEffect } from "react";
import { useProgressStore } from "@/lib/firstaid/stores/progressStore";

// Loads lesson + exam progress for the learner into the shared progress store.
// Safe to call from any gated page — it re-reads the server so deep-links
// (เปิด URL ตรง ๆ) ก็ได้สถานะล่าสุดก่อนตัดสินใจปลดล็อก/ล็อก
export function useEnsureProgress(learnerId: string | null | undefined) {
  const refresh = useProgressStore((s) => s.refresh);
  useEffect(() => {
    if (learnerId) refresh(learnerId);
  }, [learnerId, refresh]);
}
