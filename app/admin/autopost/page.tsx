"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  BarChart3,
  CalendarClock,
  CheckCircle2,
  Clock,
  Camera,
  Film,
  Layers,
  Loader2,
  RefreshCw,
  Shield,
  Trash2,
  XCircle,
} from "lucide-react";

interface BlogPostRow {
  slug: string;
  title: string;
  published_at: string | null;
  cover_image: string | null;
  ig_post_id: string | null;
  ig_posted_at: string | null;
  ig_last_error: string | null;
  ig_story_id: string | null;
  ig_story_posted_at: string | null;
  ig_story_last_error: string | null;
  ig_carousel_id: string | null;
  ig_carousel_posted_at: string | null;
  ig_carousel_last_error: string | null;
  ig_reel_id: string | null;
  ig_reel_posted_at: string | null;
  ig_reel_last_error: string | null;
  ig_reel_video_url: string | null;
}

interface ScheduledRow {
  id: string;
  slug: string;
  platform: string;
  scheduled_for: string;
  status: string;
  result_id: string | null;
  error: string | null;
  created_at: string;
  posted_at: string | null;
}

interface InsightsRow {
  slug: string;
  media_id: string;
  media_type: string;
  reach: number | null;
  likes: number | null;
  saves: number | null;
  comments: number | null;
  shares: number | null;
  profile_visits: number | null;
  video_views: number | null;
  captured_at: string;
  title: string;
  cover_image: string | null;
}

type IgStatus = "posted" | "failed" | "pending";

function igStatus(row: BlogPostRow): IgStatus {
  if (row.ig_post_id) return "posted";
  if (row.ig_last_error) return "failed";
  return "pending";
}

function igStoryStatus(row: BlogPostRow): IgStatus {
  if (row.ig_story_id) return "posted";
  if (row.ig_story_last_error) return "failed";
  return "pending";
}

function igCarouselStatus(row: BlogPostRow): IgStatus {
  if (row.ig_carousel_id) return "posted";
  if (row.ig_carousel_last_error) return "failed";
  return "pending";
}

function igReelStatus(row: BlogPostRow): IgStatus {
  if (row.ig_reel_id) return "posted";
  if (row.ig_reel_last_error) return "failed";
  return "pending";
}

function StatusBadge({ status }: { status: IgStatus }) {
  if (status === "posted") {
    return (
      <Badge className="bg-green-100 text-green-700 hover:bg-green-100">
        <CheckCircle2 className="h-3 w-3 mr-1" />
        posted
      </Badge>
    );
  }
  if (status === "failed") {
    return (
      <Badge className="bg-red-100 text-red-700 hover:bg-red-100">
        <XCircle className="h-3 w-3 mr-1" />
        failed
      </Badge>
    );
  }
  return (
    <Badge className="bg-gray-100 text-gray-700 hover:bg-gray-100">
      <Clock className="h-3 w-3 mr-1" />
      pending
    </Badge>
  );
}

function ScheduleStatusBadge({ status }: { status: string }) {
  const variant: Record<string, string> = {
    pending: "bg-blue-100 text-blue-700",
    posted: "bg-green-100 text-green-700",
    failed: "bg-red-100 text-red-700",
    cancelled: "bg-gray-100 text-gray-700",
  };
  return (
    <Badge className={`${variant[status] ?? variant.pending} hover:${variant[status] ?? ""}`}>
      {status}
    </Badge>
  );
}

function formatDate(iso: string | null): string {
  if (!iso) return "—";
  const d = new Date(iso);
  return d.toLocaleString("th-TH", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

type Tab = "posts" | "carousel" | "reels" | "scheduled" | "insights";

const TABS: { id: Tab; label: string; icon: React.ComponentType<{ className?: string }> }[] = [
  { id: "posts", label: "Feed & Story", icon: Camera },
  { id: "carousel", label: "Carousel", icon: Layers },
  { id: "reels", label: "Reels", icon: Film },
  { id: "scheduled", label: "Scheduled", icon: CalendarClock },
  { id: "insights", label: "Insights", icon: BarChart3 },
];

export default function AdminAutopostPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [rows, setRows] = useState<BlogPostRow[]>([]);
  const [tab, setTab] = useState<Tab>("posts");
  const [retrying, setRetrying] = useState<string | null>(null);
  const [scheduled, setScheduled] = useState<ScheduledRow[]>([]);
  const [insights, setInsights] = useState<InsightsRow[]>([]);
  const [refreshingInsights, setRefreshingInsights] = useState(false);

  const loadRows = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("blog_posts")
      .select(
        "slug, title, published_at, cover_image, ig_post_id, ig_posted_at, ig_last_error, ig_story_id, ig_story_posted_at, ig_story_last_error, ig_carousel_id, ig_carousel_posted_at, ig_carousel_last_error, ig_reel_id, ig_reel_posted_at, ig_reel_last_error, ig_reel_video_url",
      )
      .order("published_at", { ascending: false })
      .limit(50);
    setRows((data as BlogPostRow[] | null) ?? []);
  }, []);

  const loadScheduled = useCallback(async () => {
    const res = await fetch("/api/admin/autopost/schedule");
    if (res.ok) {
      const data = await res.json();
      setScheduled(data.items ?? []);
    }
  }, []);

  const loadInsights = useCallback(async (refresh = false) => {
    const res = await fetch(`/api/admin/autopost/insights${refresh ? "?refresh=1" : ""}`);
    if (res.ok) {
      const data = await res.json();
      setInsights(data.items ?? []);
    }
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      if ((profile as { role?: string } | null)?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      await Promise.all([loadRows(), loadScheduled(), loadInsights(false)]);
      setLoading(false);
    }
    init();
  }, [router, loadRows, loadScheduled, loadInsights]);

  const stats = useMemo(() => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayMs = today.getTime();
    const weekAgoMs = todayMs - 7 * 86400 * 1000;

    let igToday = 0;
    let igPending = 0;
    let igFailedWeek = 0;
    let storyToday = 0;
    let carouselToday = 0;
    let reelToday = 0;

    for (const r of rows) {
      const postedMs = r.ig_posted_at ? new Date(r.ig_posted_at).getTime() : 0;
      const storyPostedMs = r.ig_story_posted_at ? new Date(r.ig_story_posted_at).getTime() : 0;
      const carouselPostedMs = r.ig_carousel_posted_at
        ? new Date(r.ig_carousel_posted_at).getTime()
        : 0;
      const reelPostedMs = r.ig_reel_posted_at ? new Date(r.ig_reel_posted_at).getTime() : 0;
      if (r.ig_post_id && postedMs >= todayMs) igToday += 1;
      if (!r.ig_post_id && !r.ig_last_error) igPending += 1;
      if (!r.ig_post_id && r.ig_last_error && postedMs >= weekAgoMs) igFailedWeek += 1;
      if (r.ig_story_id && storyPostedMs >= todayMs) storyToday += 1;
      if (r.ig_carousel_id && carouselPostedMs >= todayMs) carouselToday += 1;
      if (r.ig_reel_id && reelPostedMs >= todayMs) reelToday += 1;
    }

    return { igToday, igPending, igFailedWeek, storyToday, carouselToday, reelToday };
  }, [rows]);

  const retry = useCallback(
    async (slug: string, platform: "ig" | "ig_story" | "ig_carousel" | "ig_reel") => {
      setRetrying(`${slug}:${platform}`);
      try {
        const res = await fetch("/api/admin/autopost/retry", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ slug, platform }),
        });
        if (!res.ok) {
          const data = await res.json().catch(() => ({}));
          alert(`Retry failed: ${data.error ?? res.statusText}`);
        }
        await loadRows();
      } catch (err) {
        alert(`Retry error: ${String(err)}`);
      } finally {
        setRetrying(null);
      }
    },
    [loadRows],
  );

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="text-muted-foreground mt-2">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/admin"
          className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 mr-1" />
          กลับ Admin Dashboard
        </Link>
      </div>

      <div className="mb-8 flex items-center gap-3">
        <Camera className="h-7 w-7 text-pink-600" />
        <div>
          <h1 className="text-2xl font-bold">IG Autopost</h1>
          <p className="text-muted-foreground mt-1 text-sm">
            จัดการ feed / story / carousel / reels และตารางเวลา
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 mb-6">
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">Feed วันนี้</p>
            <p className="text-2xl font-bold">{stats.igToday}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">Story วันนี้</p>
            <p className="text-2xl font-bold">{stats.storyToday}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">Carousel วันนี้</p>
            <p className="text-2xl font-bold">{stats.carouselToday}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">Reel วันนี้</p>
            <p className="text-2xl font-bold">{stats.reelToday}</p>
          </CardContent>
        </Card>
        <Card className={stats.igPending > 0 ? "border-yellow-300" : ""}>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">รอโพสต์</p>
            <p className="text-2xl font-bold">{stats.igPending}</p>
          </CardContent>
        </Card>
        <Card className={stats.igFailedWeek > 0 ? "border-red-300" : ""}>
          <CardContent className="pt-5 pb-4">
            <p className="text-xs text-muted-foreground">Failed (7d)</p>
            <p className="text-2xl font-bold">{stats.igFailedWeek}</p>
          </CardContent>
        </Card>
      </div>

      {/* Tab bar */}
      <div className="flex gap-1 mb-4 border-b overflow-x-auto">
        {TABS.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => setTab(id)}
            className={`flex items-center gap-2 px-4 py-2 text-sm font-medium whitespace-nowrap border-b-2 transition-colors ${
              tab === id
                ? "border-pink-600 text-pink-600"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
          >
            <Icon className="h-4 w-4" />
            {label}
          </button>
        ))}
      </div>

      {tab === "posts" && <PostsTable rows={rows} retry={retry} retrying={retrying} />}
      {tab === "carousel" && (
        <CarouselTable rows={rows} retry={retry} retrying={retrying} />
      )}
      {tab === "reels" && (
        <ReelsTab rows={rows} reload={loadRows} retry={retry} retrying={retrying} />
      )}
      {tab === "scheduled" && (
        <ScheduledTab
          items={scheduled}
          rows={rows}
          reload={loadScheduled}
        />
      )}
      {tab === "insights" && (
        <InsightsTab
          items={insights}
          refreshing={refreshingInsights}
          onRefresh={async () => {
            setRefreshingInsights(true);
            try {
              await loadInsights(true);
            } finally {
              setRefreshingInsights(false);
            }
          }}
        />
      )}
    </div>
  );
}

function CoverThumb({ src }: { src: string | null }) {
  if (!src) return <div className="w-12 h-12 rounded bg-muted shrink-0" />;
  // eslint-disable-next-line @next/next/no-img-element
  return <img src={src} alt="" className="w-12 h-12 rounded object-cover bg-muted shrink-0" />;
}

function ArticleCell({ row }: { row: BlogPostRow }) {
  return (
    <div className="flex items-center gap-3">
      <CoverThumb src={row.cover_image} />
      <div className="min-w-0">
        <Link
          href={`/blog/${row.slug}`}
          className="font-medium hover:underline line-clamp-1"
        >
          {row.title}
        </Link>
        <p className="text-xs text-muted-foreground line-clamp-1">{row.slug}</p>
      </div>
    </div>
  );
}

function PostsTable({
  rows,
  retry,
  retrying,
}: {
  rows: BlogPostRow[];
  retry: (slug: string, platform: "ig" | "ig_story") => void;
  retrying: string | null;
}) {
  return (
    <Card>
      <CardContent className="p-0 overflow-x-auto">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left">
            <tr>
              <th className="px-4 py-3 font-medium">บทความ</th>
              <th className="px-4 py-3 font-medium">IG Feed</th>
              <th className="px-4 py-3 font-medium">IG Story</th>
              <th className="px-4 py-3 font-medium">โพสต์เมื่อ</th>
              <th className="px-4 py-3 font-medium text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 && (
              <tr>
                <td colSpan={5} className="px-4 py-8 text-center text-muted-foreground">
                  ยังไม่มีบทความ
                </td>
              </tr>
            )}
            {rows.map((r) => {
              const feedStatus = igStatus(r);
              const storyStat = igStoryStatus(r);
              return (
                <tr key={r.slug} className="border-t">
                  <td className="px-4 py-3"><ArticleCell row={r} /></td>
                  <td className="px-4 py-3 align-top">
                    <StatusBadge status={feedStatus} />
                    {r.ig_last_error && !r.ig_post_id && (
                      <p
                        className="text-xs text-red-600 mt-1 max-w-xs truncate"
                        title={r.ig_last_error}
                      >
                        {r.ig_last_error}
                      </p>
                    )}
                  </td>
                  <td className="px-4 py-3 align-top">
                    <StatusBadge status={storyStat} />
                    {r.ig_story_last_error && !r.ig_story_id && (
                      <p
                        className="text-xs text-red-600 mt-1 max-w-xs truncate"
                        title={r.ig_story_last_error}
                      >
                        {r.ig_story_last_error}
                      </p>
                    )}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground align-top">
                    <div>{formatDate(r.ig_posted_at)}</div>
                    {r.ig_story_posted_at && (
                      <div className="text-xs">story: {formatDate(r.ig_story_posted_at)}</div>
                    )}
                  </td>
                  <td className="px-4 py-3 align-top text-right">
                    <div className="flex flex-col gap-1 items-end">
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={retrying === `${r.slug}:ig` || feedStatus === "posted"}
                        onClick={() => retry(r.slug, "ig")}
                      >
                        {retrying === `${r.slug}:ig` ? (
                          <Loader2 className="h-3 w-3 animate-spin" />
                        ) : (
                          <RefreshCw className="h-3 w-3" />
                        )}
                        <span className="ml-1">Retry Feed</span>
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={retrying === `${r.slug}:ig_story` || storyStat === "posted"}
                        onClick={() => retry(r.slug, "ig_story")}
                      >
                        {retrying === `${r.slug}:ig_story` ? (
                          <Loader2 className="h-3 w-3 animate-spin" />
                        ) : (
                          <RefreshCw className="h-3 w-3" />
                        )}
                        <span className="ml-1">Retry Story</span>
                      </Button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </CardContent>
    </Card>
  );
}

function CarouselTable({
  rows,
  retry,
  retrying,
}: {
  rows: BlogPostRow[];
  retry: (slug: string, platform: "ig_carousel") => void;
  retrying: string | null;
}) {
  return (
    <>
      <p className="text-sm text-muted-foreground mb-4">
        Carousel 5 สไลด์ (cover + 3 bullets + CTA card link) — สร้างจาก hook ของบทความ
        อัตโนมัติ สไลด์สุดท้ายเป็น link card visual + URL บทความ + แนะนำ link in bio
      </p>
      <Card>
        <CardContent className="p-0 overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-left">
              <tr>
                <th className="px-4 py-3 font-medium">บทความ</th>
                <th className="px-4 py-3 font-medium">Carousel</th>
                <th className="px-4 py-3 font-medium">โพสต์เมื่อ</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const carouselStat = igCarouselStatus(r);
                return (
                  <tr key={r.slug} className="border-t">
                    <td className="px-4 py-3"><ArticleCell row={r} /></td>
                    <td className="px-4 py-3 align-top">
                      <StatusBadge status={carouselStat} />
                      {r.ig_carousel_last_error && !r.ig_carousel_id && (
                        <p
                          className="text-xs text-red-600 mt-1 max-w-xs truncate"
                          title={r.ig_carousel_last_error}
                        >
                          {r.ig_carousel_last_error}
                        </p>
                      )}
                    </td>
                    <td className="px-4 py-3 text-muted-foreground align-top">
                      {formatDate(r.ig_carousel_posted_at)}
                    </td>
                    <td className="px-4 py-3 align-top text-right">
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={
                          retrying === `${r.slug}:ig_carousel` ||
                          carouselStat === "posted"
                        }
                        onClick={() => retry(r.slug, "ig_carousel")}
                      >
                        {retrying === `${r.slug}:ig_carousel` ? (
                          <Loader2 className="h-3 w-3 animate-spin" />
                        ) : (
                          <Layers className="h-3 w-3" />
                        )}
                        <span className="ml-1">Post Carousel</span>
                      </Button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </>
  );
}

function ReelsTab({
  rows,
  reload,
  retry,
  retrying,
}: {
  rows: BlogPostRow[];
  reload: () => Promise<void>;
  retry: (slug: string, platform: "ig_reel") => void;
  retrying: string | null;
}) {
  const [slug, setSlug] = useState("");
  const [videoUrl, setVideoUrl] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const submit = useCallback(async () => {
    if (!slug.trim() || !videoUrl.trim()) {
      alert("กรอก slug และ videoUrl");
      return;
    }
    setSubmitting(true);
    try {
      const res = await fetch("/api/admin/autopost/reel", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ slug: slug.trim(), videoUrl: videoUrl.trim(), postNow: true }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        alert(`Failed: ${data.error ?? res.statusText}`);
      } else {
        setSlug("");
        setVideoUrl("");
        await reload();
      }
    } finally {
      setSubmitting(false);
    }
  }, [slug, videoUrl, reload]);

  return (
    <>
      <p className="text-sm text-muted-foreground mb-4">
        IG Reel ต้องเตรียม MP4 (9:16, ≤90s) ไว้บน HTTPS URL ใส่ slug บทความ + URL วิดีโอ
        ระบบจะใส่ caption จาก hook ของบทความและโพสต์ให้
      </p>

      <Card className="mb-6">
        <CardContent className="pt-6 space-y-4">
          <div>
            <Label htmlFor="reel-slug">Slug บทความ</Label>
            <Input
              id="reel-slug"
              placeholder="example-blog-slug"
              value={slug}
              onChange={(e) => setSlug(e.target.value)}
            />
          </div>
          <div>
            <Label htmlFor="reel-video">Video URL (https, MP4)</Label>
            <Input
              id="reel-video"
              placeholder="https://cdn.example.com/reel.mp4"
              value={videoUrl}
              onChange={(e) => setVideoUrl(e.target.value)}
            />
          </div>
          <Button onClick={submit} disabled={submitting}>
            {submitting ? <Loader2 className="h-4 w-4 animate-spin" /> : <Film className="h-4 w-4" />}
            <span className="ml-2">Queue + Post Now</span>
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="p-0 overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-left">
              <tr>
                <th className="px-4 py-3 font-medium">บทความ</th>
                <th className="px-4 py-3 font-medium">Reel</th>
                <th className="px-4 py-3 font-medium">Video URL</th>
                <th className="px-4 py-3 font-medium">โพสต์เมื่อ</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.filter((r) => r.ig_reel_video_url || r.ig_reel_id).map((r) => {
                const reelStat = igReelStatus(r);
                return (
                  <tr key={r.slug} className="border-t">
                    <td className="px-4 py-3"><ArticleCell row={r} /></td>
                    <td className="px-4 py-3 align-top">
                      <StatusBadge status={reelStat} />
                      {r.ig_reel_last_error && !r.ig_reel_id && (
                        <p
                          className="text-xs text-red-600 mt-1 max-w-xs truncate"
                          title={r.ig_reel_last_error}
                        >
                          {r.ig_reel_last_error}
                        </p>
                      )}
                    </td>
                    <td className="px-4 py-3 text-xs text-muted-foreground align-top max-w-xs truncate">
                      {r.ig_reel_video_url ? (
                        <a
                          href={r.ig_reel_video_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="hover:underline"
                        >
                          {r.ig_reel_video_url}
                        </a>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td className="px-4 py-3 text-muted-foreground align-top">
                      {formatDate(r.ig_reel_posted_at)}
                    </td>
                    <td className="px-4 py-3 align-top text-right">
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={
                          retrying === `${r.slug}:ig_reel` ||
                          reelStat === "posted" ||
                          !r.ig_reel_video_url
                        }
                        onClick={() => retry(r.slug, "ig_reel")}
                      >
                        {retrying === `${r.slug}:ig_reel` ? (
                          <Loader2 className="h-3 w-3 animate-spin" />
                        ) : (
                          <RefreshCw className="h-3 w-3" />
                        )}
                        <span className="ml-1">Retry Reel</span>
                      </Button>
                    </td>
                  </tr>
                );
              })}
              {!rows.some((r) => r.ig_reel_video_url || r.ig_reel_id) && (
                <tr>
                  <td colSpan={5} className="px-4 py-8 text-center text-muted-foreground">
                    ยังไม่มี Reel ในคิว
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </>
  );
}

function ScheduledTab({
  items,
  rows,
  reload,
}: {
  items: ScheduledRow[];
  rows: BlogPostRow[];
  reload: () => Promise<void>;
}) {
  const [slug, setSlug] = useState("");
  const [platform, setPlatform] = useState<string>("ig");
  const [when, setWhen] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const submit = useCallback(async () => {
    if (!slug.trim() || !when) {
      alert("กรอก slug และเวลา");
      return;
    }
    setSubmitting(true);
    try {
      const res = await fetch("/api/admin/autopost/schedule", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          slug: slug.trim(),
          platform,
          scheduledFor: new Date(when).toISOString(),
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        alert(`Failed: ${data.error ?? res.statusText}`);
      } else {
        setSlug("");
        setWhen("");
        await reload();
      }
    } finally {
      setSubmitting(false);
    }
  }, [slug, platform, when, reload]);

  const cancel = useCallback(
    async (id: string) => {
      if (!confirm("ยกเลิกตารางนี้?")) return;
      const res = await fetch(`/api/admin/autopost/schedule?id=${id}`, {
        method: "DELETE",
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        alert(`Cancel failed: ${data.error ?? res.statusText}`);
      }
      await reload();
    },
    [reload],
  );

  return (
    <>
      <p className="text-sm text-muted-foreground mb-4">
        ตั้งเวลาโพสต์ล่วงหน้า — cron รัน /api/cron/autopost-scheduled ทุก 15 นาที
        และจะโพสต์รายการที่ถึงเวลาแล้ว
      </p>

      <Card className="mb-6">
        <CardContent className="pt-6 grid gap-4 md:grid-cols-4">
          <div className="md:col-span-2">
            <Label htmlFor="sch-slug">Slug</Label>
            <Input
              id="sch-slug"
              list="slug-suggest"
              placeholder="example-blog-slug"
              value={slug}
              onChange={(e) => setSlug(e.target.value)}
            />
            <datalist id="slug-suggest">
              {rows.map((r) => (
                <option key={r.slug} value={r.slug}>
                  {r.title}
                </option>
              ))}
            </datalist>
          </div>
          <div>
            <Label htmlFor="sch-platform">Platform</Label>
            <select
              id="sch-platform"
              value={platform}
              onChange={(e) => setPlatform(e.target.value)}
              className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
            >
              <option value="ig">IG Feed</option>
              <option value="ig_story">IG Story</option>
              <option value="ig_carousel">IG Carousel</option>
              <option value="fb">FB</option>
              <option value="fb_story">FB Story</option>
            </select>
          </div>
          <div>
            <Label htmlFor="sch-when">เวลา (local)</Label>
            <Input
              id="sch-when"
              type="datetime-local"
              value={when}
              onChange={(e) => setWhen(e.target.value)}
            />
          </div>
          <div className="md:col-span-4">
            <Button onClick={submit} disabled={submitting}>
              {submitting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <CalendarClock className="h-4 w-4" />
              )}
              <span className="ml-2">Schedule</span>
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="p-0 overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-left">
              <tr>
                <th className="px-4 py-3 font-medium">Slug</th>
                <th className="px-4 py-3 font-medium">Platform</th>
                <th className="px-4 py-3 font-medium">เมื่อ</th>
                <th className="px-4 py-3 font-medium">สถานะ</th>
                <th className="px-4 py-3 font-medium">ผลลัพธ์</th>
                <th className="px-4 py-3 font-medium text-right">Action</th>
              </tr>
            </thead>
            <tbody>
              {items.length === 0 && (
                <tr>
                  <td colSpan={6} className="px-4 py-8 text-center text-muted-foreground">
                    ยังไม่มีตารางที่กำหนดไว้
                  </td>
                </tr>
              )}
              {items.map((s) => (
                <tr key={s.id} className="border-t">
                  <td className="px-4 py-3 font-mono text-xs">{s.slug}</td>
                  <td className="px-4 py-3 text-xs">{s.platform}</td>
                  <td className="px-4 py-3 text-muted-foreground">
                    {formatDate(s.scheduled_for)}
                  </td>
                  <td className="px-4 py-3"><ScheduleStatusBadge status={s.status} /></td>
                  <td className="px-4 py-3 text-xs text-muted-foreground max-w-xs truncate">
                    {s.result_id ? `id:${s.result_id}` : s.error ?? "—"}
                  </td>
                  <td className="px-4 py-3 text-right">
                    {s.status === "pending" && (
                      <Button size="sm" variant="outline" onClick={() => cancel(s.id)}>
                        <Trash2 className="h-3 w-3" />
                        <span className="ml-1">Cancel</span>
                      </Button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </>
  );
}

function InsightsTab({
  items,
  refreshing,
  onRefresh,
}: {
  items: InsightsRow[];
  refreshing: boolean;
  onRefresh: () => Promise<void>;
}) {
  return (
    <>
      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-muted-foreground">
          Insights ล่าสุดต่อ media (snapshot รายวันจาก cron) — กด Refresh เพื่อยิง Graph API ตอนนี้
        </p>
        <Button size="sm" variant="outline" onClick={onRefresh} disabled={refreshing}>
          {refreshing ? <Loader2 className="h-4 w-4 animate-spin" /> : <RefreshCw className="h-4 w-4" />}
          <span className="ml-1">Refresh</span>
        </Button>
      </div>
      <Card>
        <CardContent className="p-0 overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 text-left">
              <tr>
                <th className="px-4 py-3 font-medium">บทความ</th>
                <th className="px-4 py-3 font-medium">Type</th>
                <th className="px-4 py-3 font-medium text-right">Reach</th>
                <th className="px-4 py-3 font-medium text-right">Likes</th>
                <th className="px-4 py-3 font-medium text-right">Saves</th>
                <th className="px-4 py-3 font-medium text-right">Comments</th>
                <th className="px-4 py-3 font-medium text-right">Shares</th>
                <th className="px-4 py-3 font-medium text-right">Visits</th>
                <th className="px-4 py-3 font-medium">Captured</th>
              </tr>
            </thead>
            <tbody>
              {items.length === 0 && (
                <tr>
                  <td colSpan={9} className="px-4 py-8 text-center text-muted-foreground">
                    ยังไม่มี snapshot — กด Refresh เพื่อดึงครั้งแรก
                  </td>
                </tr>
              )}
              {items.map((s) => (
                <tr key={`${s.slug}::${s.media_type}::${s.captured_at}`} className="border-t">
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-3">
                      <CoverThumb src={s.cover_image} />
                      <div className="min-w-0">
                        <p className="font-medium line-clamp-1">{s.title}</p>
                        <p className="text-xs text-muted-foreground line-clamp-1">{s.slug}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-4 py-3 text-xs">{s.media_type}</td>
                  <td className="px-4 py-3 text-right">{s.reach ?? "—"}</td>
                  <td className="px-4 py-3 text-right">{s.likes ?? "—"}</td>
                  <td className="px-4 py-3 text-right">{s.saves ?? "—"}</td>
                  <td className="px-4 py-3 text-right">{s.comments ?? "—"}</td>
                  <td className="px-4 py-3 text-right">{s.shares ?? "—"}</td>
                  <td className="px-4 py-3 text-right">{s.profile_visits ?? "—"}</td>
                  <td className="px-4 py-3 text-xs text-muted-foreground">
                    {formatDate(s.captured_at)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </>
  );
}
