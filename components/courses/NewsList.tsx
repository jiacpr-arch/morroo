"use client";

import { useMemo, useState } from "react";
import { Bell, Search, ChevronRight } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import type { NewsCourse, NewsItem } from "@/lib/courses/news";
import PushToggle from "./PushToggle";
import { dashCard } from "./course-ui";
import { cn } from "@/lib/utils";

// Ported from acls-emr's src/pages/NewsPage.jsx. Server-fetched items are
// handed down as props (RSC-first convention — items come from
// lib/courses/news.ts's getNews() with `export const revalidate` doing the
// caching); filter tabs + search are applied client-side in-memory rather
// than round-tripping to Supabase per keystroke/tab, since the full course
// news volume is small.
//
// Deliberate simplification vs. the source: dropped the visibilitychange/
// focus live-refetch (the source re-queried Supabase directly from the
// client on every tab focus) and the jiaaed.com external feed section —
// neither is part of this phase's scope, and the RSC + revalidate pattern
// already used across app/acls/** intentionally replaces client-side
// freshness polling.

const COURSE_LABEL: Record<string, string> = { acls: "ACLS", bls: "BLS", both: "ทั่วไป" };

interface Filter {
  id: NewsCourse | null;
  label: string;
}

export default function NewsList({ course, items }: { course: CourseMode; items: NewsItem[] }) {
  const [filter, setFilter] = useState<NewsCourse | null>(null);
  const [search, setSearch] = useState("");

  const filters: Filter[] = useMemo(
    () => [
      { id: null, label: "ทั้งหมด" },
      { id: course, label: course === "bls" ? "BLS" : "ACLS" },
      { id: "both", label: "ทั่วไป" },
    ],
    [course],
  );

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return items.filter((item) => {
      if (filter && item.course !== filter) return false;
      if (q && !item.title.toLowerCase().includes(q) && !item.summary.toLowerCase().includes(q)) {
        return false;
      }
      return true;
    });
  }, [items, filter, search]);

  const grouped = useMemo(() => groupByDate(filtered), [filtered]);

  return (
    <div className="mx-auto max-w-2xl space-y-4 px-4 py-10 pb-24 sm:px-6 lg:px-8">
      <div className="flex items-center gap-3">
        <div
          className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg"
          style={{ background: "rgba(220, 38, 38, 0.12)", color: "#DC2626" }}
        >
          <Bell size={20} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-xl font-bold text-foreground">ข่าวสาร</h1>
          <p className="mt-0.5 text-xs text-muted-foreground">
            ข่าว CPR / ACLS / BLS / AED อัปเดตอัตโนมัติทุกวัน
          </p>
        </div>
      </div>

      <PushToggle course={course} />

      <div className={cn(dashCard, "flex items-center gap-2 !p-3")}>
        <Search size={16} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
        <input
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="ค้นหาข่าว…"
          className="flex-1 border-0 bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
        />
      </div>

      <div className="flex gap-1 rounded-lg bg-muted p-1">
        {filters.map((f) => (
          <button
            key={f.label}
            onClick={() => setFilter(f.id)}
            className={cn(
              "flex-1 rounded-md px-3 py-1.5 text-xs font-semibold transition-colors",
              filter === f.id
                ? "bg-background text-foreground shadow-sm"
                : "text-muted-foreground hover:text-foreground",
            )}
          >
            {f.label}
          </button>
        ))}
      </div>

      {filtered.length === 0 ? (
        <div className="py-12 text-center">
          <div className="mx-auto mb-3 inline-flex h-14 w-14 items-center justify-center rounded-full bg-muted text-muted-foreground">
            <Bell size={26} strokeWidth={1.6} />
          </div>
          <div className="text-sm text-muted-foreground">
            {search.trim() ? "ไม่พบข่าวตามคำค้น" : "ยังไม่มีข่าว"}
          </div>
        </div>
      ) : (
        grouped.map((group) => (
          <div key={group.key} className="space-y-2">
            <div className="px-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
              {group.label}
            </div>
            {group.items.map((item) => (
              <NewsListItem key={item.id} item={item} />
            ))}
          </div>
        ))
      )}
    </div>
  );
}

function NewsListItem({ item }: { item: NewsItem }) {
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
    >
      <div className="min-w-0 flex-1">
        <div className="flex flex-wrap items-center gap-1.5">
          {courseLabel && (
            <span className={cn("rounded px-1.5 py-0.5 text-[11px] font-semibold", courseBadgeCls)}>
              {courseLabel}
            </span>
          )}
          {item.source_name && (
            <span className="text-[11px] text-muted-foreground">{item.source_name}</span>
          )}
          {item.language === "en" && (
            <span className="text-[11px] text-muted-foreground opacity-60">· EN</span>
          )}
          {item.is_evergreen && (
            <span className="rounded bg-amber-500/15 px-1.5 py-0.5 text-[11px] font-semibold text-amber-600 dark:text-amber-400">
              ไกด์ไลน์
            </span>
          )}
        </div>
        <div className="mt-1 text-sm font-semibold text-foreground">{item.title}</div>
        <div className="mt-1 text-xs leading-relaxed text-muted-foreground">{item.summary}</div>
        {item.topics.length > 0 && (
          <div className="mt-2 flex flex-wrap gap-1">
            {item.topics.map((t) => (
              <span key={t} className="rounded bg-muted px-1.5 py-0.5 text-[11px] text-muted-foreground">
                #{t}
              </span>
            ))}
          </div>
        )}
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

// Fixed display order: fresh news bucketed by date first, then evergreen
// reference material (guidelines / landmark research) always last so it never
// buries genuinely fresh news.
const GROUP_ORDER = ["today", "yesterday", "week", "month", "older", "reference"] as const;
type GroupKey = (typeof GROUP_ORDER)[number];
const GROUP_LABEL: Record<GroupKey, string> = {
  today: "วันนี้",
  yesterday: "เมื่อวาน",
  week: "สัปดาห์นี้",
  month: "เดือนนี้",
  older: "ก่อนหน้านี้",
  reference: "อ้างอิง / ไกด์ไลน์สำคัญ",
};

function groupByDate(items: NewsItem[]): { key: GroupKey; label: string; items: NewsItem[] }[] {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const groups = new Map<GroupKey, { key: GroupKey; label: string; items: NewsItem[] }>();
  for (const item of items) {
    let key: GroupKey;
    if (item.is_evergreen) {
      key = "reference";
    } else {
      const d = new Date(item.published_at);
      d.setHours(0, 0, 0, 0);
      const diffDays = Math.floor((today.getTime() - d.getTime()) / (1000 * 60 * 60 * 24));
      if (diffDays <= 0) key = "today";
      else if (diffDays === 1) key = "yesterday";
      else if (diffDays < 7) key = "week";
      else if (diffDays < 30) key = "month";
      else key = "older";
    }

    if (!groups.has(key)) groups.set(key, { key, label: GROUP_LABEL[key], items: [] });
    groups.get(key)!.items.push(item);
  }
  return GROUP_ORDER.filter((k) => groups.has(k)).map((k) => groups.get(k)!);
}
