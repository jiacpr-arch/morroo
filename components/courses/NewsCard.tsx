"use client";

import { useEffect, useState } from "react";
import { Bell, ChevronRight } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import { getNews, type NewsItem } from "@/lib/courses/news";
import { dashCard } from "./course-ui";
import { cn } from "@/lib/utils";

// Ported from acls-emr's src/components/NewsCard.jsx — a compact "latest
// news" teaser (single item) meant for a homepage/dashboard slot, distinct
// from the full list rendered by components/courses/NewsList.tsx. Fetches
// client-side (against the anon-key browser client, same as any RSC caller
// of lib/courses/news.ts) and silently refetches when the tab regains focus,
// same as the source.

const COURSE_LABEL: Record<string, string> = { acls: "ACLS", bls: "BLS", both: "ทั่วไป" };

// Only surface news from the last 30 days — older items stay on the /news
// page but never show up as "ข่าวล่าสุด" on the home/dashboard cards.
const MAX_AGE_DAYS = 30;

export default function NewsCard({ course }: { course: CourseMode }) {
  const [item, setItem] = useState<NewsItem | null | undefined>(undefined);

  useEffect(() => {
    let cancelled = false;
    const load = () => {
      getNews(course, { limit: 1, maxAgeDays: MAX_AGE_DAYS, freshOnly: true }).then((rows) => {
        if (!cancelled) setItem(rows[0] || null);
      });
    };
    load();
    // Refetch when the user comes back to the tab/app so a long-lived session
    // doesn't keep showing a snapshot from when it was first opened.
    const onVisible = () => {
      if (document.visibilityState === "visible") load();
    };
    document.addEventListener("visibilitychange", onVisible);
    window.addEventListener("focus", load);
    return () => {
      cancelled = true;
      document.removeEventListener("visibilitychange", onVisible);
      window.removeEventListener("focus", load);
    };
  }, [course]);

  if (!item) return null;

  const date = formatDate(item.published_at);
  const courseLabel = COURSE_LABEL[item.course] || "";
  const courseBadgeCls =
    item.course === "bls"
      ? "bg-sky-500/15 text-sky-600 dark:text-sky-400"
      : item.course === "acls"
        ? "bg-red-500/15 text-red-600 dark:text-red-400"
        : "bg-muted text-muted-foreground";

  const Wrapper = item.source_url ? "a" : "div";
  const linkProps = item.source_url
    ? { href: item.source_url, target: "_blank", rel: "noopener noreferrer" }
    : {};

  return (
    <Wrapper
      {...linkProps}
      className={cn(dashCard, "group flex gap-3 no-underline transition-shadow hover:shadow-md")}
      style={{ borderLeft: "4px solid #DC2626" }}
    >
      <div
        className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg"
        style={{ background: "rgba(220, 38, 38, 0.12)", color: "#DC2626" }}
      >
        <Bell size={18} strokeWidth={2.2} />
      </div>
      <div className="min-w-0 flex-1">
        <div className="flex flex-wrap items-center gap-1.5">
          <span className="text-[11px] font-semibold uppercase tracking-wider" style={{ color: "#DC2626" }}>
            ข่าวล่าสุด
          </span>
          <span className="text-[11px] text-muted-foreground opacity-50">·</span>
          {courseLabel && (
            <span className={cn("rounded px-1.5 py-0.5 text-[11px] font-semibold", courseBadgeCls)}>
              {courseLabel}
            </span>
          )}
          {item.source_name && (
            <span className="text-[11px] text-muted-foreground">{item.source_name}</span>
          )}
          <span className="text-[11px] text-muted-foreground opacity-50">·</span>
          <span className="text-[11px] text-muted-foreground">{date}</span>
        </div>
        <div className="mt-0.5 text-sm font-semibold text-foreground">{item.title}</div>
        <div className="mt-1 line-clamp-2 text-xs leading-relaxed text-muted-foreground">
          {item.summary}
        </div>
      </div>
      {item.source_url && (
        <ChevronRight
          size={18}
          strokeWidth={2.2}
          className="shrink-0 self-center text-muted-foreground transition-colors group-hover:text-red-600"
        />
      )}
    </Wrapper>
  );
}

function formatDate(iso: string): string {
  if (!iso) return "";
  try {
    const d = new Date(iso);
    const now = new Date();
    const diffMs = now.getTime() - d.getTime();
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    if (diffDays < 1) {
      const hrs = Math.floor(diffMs / (1000 * 60 * 60));
      if (hrs < 1) return "เพิ่งเข้ามา";
      return `${hrs} ชม.ที่แล้ว`;
    }
    if (diffDays < 7) return `${diffDays} วันที่แล้ว`;
    return d.toLocaleDateString("th-TH", { day: "numeric", month: "short" });
  } catch {
    return "";
  }
}
