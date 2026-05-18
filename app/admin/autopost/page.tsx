"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  CheckCircle2,
  Clock,
  Camera,
  Loader2,
  RefreshCw,
  Shield,
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

type Filter = "all" | "posted" | "failed" | "pending";

export default function AdminAutopostPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [rows, setRows] = useState<BlogPostRow[]>([]);
  const [filter, setFilter] = useState<Filter>("all");
  const [retrying, setRetrying] = useState<string | null>(null);

  const loadRows = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("blog_posts")
      .select(
        "slug, title, published_at, cover_image, ig_post_id, ig_posted_at, ig_last_error, ig_story_id, ig_story_posted_at, ig_story_last_error",
      )
      .order("published_at", { ascending: false })
      .limit(50);
    setRows((data as BlogPostRow[] | null) ?? []);
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
      await loadRows();
      setLoading(false);
    }
    init();
  }, [router, loadRows]);

  const stats = useMemo(() => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayMs = today.getTime();
    const weekAgoMs = todayMs - 7 * 86400 * 1000;

    let igToday = 0;
    let igPending = 0;
    let igFailedWeek = 0;
    let storyToday = 0;

    for (const r of rows) {
      const postedMs = r.ig_posted_at ? new Date(r.ig_posted_at).getTime() : 0;
      const storyPostedMs = r.ig_story_posted_at ? new Date(r.ig_story_posted_at).getTime() : 0;
      if (r.ig_post_id && postedMs >= todayMs) igToday += 1;
      if (!r.ig_post_id && !r.ig_last_error) igPending += 1;
      if (!r.ig_post_id && r.ig_last_error && postedMs >= weekAgoMs) igFailedWeek += 1;
      if (r.ig_story_id && storyPostedMs >= todayMs) storyToday += 1;
    }

    return { igToday, igPending, igFailedWeek, storyToday };
  }, [rows]);

  const filtered = useMemo(() => {
    if (filter === "all") return rows;
    return rows.filter((r) => igStatus(r) === filter);
  }, [rows, filter]);

  const retry = useCallback(
    async (slug: string, platform: "ig" | "ig_story") => {
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
            สถานะการโพสต์ Instagram และกด retry บทความที่ failed
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">โพสต์วันนี้</p>
            <p className="text-2xl font-bold">{stats.igToday}</p>
            <p className="text-xs text-muted-foreground mt-1">soft limit 1/วัน</p>
          </CardContent>
        </Card>
        <Card className={stats.igPending > 0 ? "border-yellow-300" : ""}>
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">รอโพสต์</p>
            <p className="text-2xl font-bold">{stats.igPending}</p>
          </CardContent>
        </Card>
        <Card className={stats.igFailedWeek > 0 ? "border-red-300" : ""}>
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">Failed (7 วัน)</p>
            <p className="text-2xl font-bold">{stats.igFailedWeek}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <p className="text-sm text-muted-foreground">Story วันนี้</p>
            <p className="text-2xl font-bold">{stats.storyToday}</p>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-2 mb-4">
        {(["all", "posted", "failed", "pending"] as Filter[]).map((f) => (
          <Button
            key={f}
            variant={filter === f ? "default" : "outline"}
            size="sm"
            onClick={() => setFilter(f)}
          >
            {f}
          </Button>
        ))}
      </div>

      {/* Table */}
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
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={5} className="px-4 py-8 text-center text-muted-foreground">
                    ไม่มีบทความตรงเงื่อนไข
                  </td>
                </tr>
              )}
              {filtered.map((r) => {
                const feedStatus = igStatus(r);
                const storyStat = igStoryStatus(r);
                const retryFeedKey = `${r.slug}:ig`;
                const retryStoryKey = `${r.slug}:ig_story`;
                return (
                  <tr key={r.slug} className="border-t">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        {r.cover_image && (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img
                            src={r.cover_image}
                            alt=""
                            className="w-12 h-12 rounded object-cover bg-muted shrink-0"
                          />
                        )}
                        <div className="min-w-0">
                          <Link
                            href={`/blog/${r.slug}`}
                            className="font-medium hover:underline line-clamp-1"
                          >
                            {r.title}
                          </Link>
                          <p className="text-xs text-muted-foreground line-clamp-1">{r.slug}</p>
                        </div>
                      </div>
                    </td>
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
                          disabled={retrying === retryFeedKey || feedStatus === "posted"}
                          onClick={() => retry(r.slug, "ig")}
                        >
                          {retrying === retryFeedKey ? (
                            <Loader2 className="h-3 w-3 animate-spin" />
                          ) : (
                            <RefreshCw className="h-3 w-3" />
                          )}
                          <span className="ml-1">Retry Feed</span>
                        </Button>
                        <Button
                          size="sm"
                          variant="outline"
                          disabled={retrying === retryStoryKey || storyStat === "posted"}
                          onClick={() => retry(r.slug, "ig_story")}
                        >
                          {retrying === retryStoryKey ? (
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
    </div>
  );
}
