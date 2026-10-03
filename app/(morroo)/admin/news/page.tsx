"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  ChevronLeft,
  Loader2,
  Plus,
  Shield,
  Trash2,
  Pin,
  PinOff,
  Send,
  RefreshCw,
  Eye,
  EyeOff,
} from "lucide-react";

interface NewsRow {
  id: string;
  source_type: "product_update" | "blog" | "exam" | "external_health";
  source_section: string | null;
  title: string;
  summary: string;
  link: string | null;
  published_at: string;
  pinned: boolean;
  fb_post_id: string | null;
  fb_last_error: string | null;
  line_broadcast_at: string | null;
  line_last_error: string | null;
  /** manual = แอดมินเขียน, auto = ดึงจาก RSS (cron exam-news-fetch) */
  origin: "manual" | "auto";
  is_active: boolean;
  exam_schedule: boolean;
  source_name: string | null;
}

function statusBadge(sent: boolean, error: string | null): { label: string; className: string } {
  if (sent) return { label: "ส่งแล้ว", className: "bg-green-100 text-green-700" };
  if (error) return { label: "ผิดพลาด", className: "bg-red-100 text-red-700" };
  return { label: "ยังไม่ส่ง", className: "bg-muted text-muted-foreground" };
}

const TYPE_LABEL: Record<NewsRow["source_type"], string> = {
  product_update: "อัปเดตระบบ",
  blog: "บทความ",
  exam: "ข่าวสอบ",
  external_health: "ข่าวสุขภาพ",
};

const TYPE_COLOR: Record<NewsRow["source_type"], string> = {
  product_update: "bg-violet-100 text-violet-700",
  blog: "bg-blue-100 text-blue-700",
  exam: "bg-amber-100 text-amber-700",
  external_health: "bg-rose-100 text-rose-700",
};

export default function AdminNewsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [items, setItems] = useState<NewsRow[]>([]);
  const [busy, setBusy] = useState<string | null>(null);
  const [fetching, setFetching] = useState(false);
  const [fetchMsg, setFetchMsg] = useState<{ ok: boolean; text: string } | null>(null);

  async function load() {
    const res = await fetch("/api/admin/news");
    if (!res.ok) return;
    const json = await res.json();
    setItems(json.items ?? []);
  }

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      await load();
      setLoading(false);
    }
    init();
  }, [router]);

  async function togglePin(item: NewsRow) {
    setBusy(item.id);
    await fetch(`/api/admin/news/${item.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ pinned: !item.pinned }),
    });
    await load();
    setBusy(null);
  }

  async function toggleActive(item: NewsRow) {
    setBusy(item.id);
    await fetch(`/api/admin/news/${item.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ is_active: !item.is_active }),
    });
    await load();
    setBusy(null);
  }

  async function fetchNow() {
    setFetching(true);
    setFetchMsg(null);
    try {
      const res = await fetch("/api/admin/news/fetch", { method: "POST" });
      const json = (await res.json().catch(() => ({}))) as {
        error?: string;
        data?: { added: number; skipped: number; fresh: number; feedErrors: string[] };
      };
      if (res.ok && json.data) {
        const d = json.data;
        setFetchMsg({
          ok: true,
          text: `เพิ่ม ${d.added} ข่าว · ข้าม/ซ่อน ${d.skipped} · ใหม่ที่ตรวจ ${d.fresh}${
            d.feedErrors.length ? ` · ฟีดผิดพลาด ${d.feedErrors.length}` : ""
          }`,
        });
        await load();
      } else {
        setFetchMsg({ ok: false, text: json.error ?? `ไม่สำเร็จ (${res.status})` });
      }
    } catch {
      setFetchMsg({ ok: false, text: "เชื่อมต่อไม่ได้ ลองใหม่อีกครั้ง" });
    } finally {
      setFetching(false);
    }
  }

  async function resend(item: NewsRow) {
    setBusy(item.id);
    await fetch(`/api/admin/news/${item.id}`, { method: "POST" });
    await load();
    setBusy(null);
  }

  async function remove(item: NewsRow) {
    if (!confirm(`ลบข่าว "${item.title}"?`)) return;
    setBusy(item.id);
    await fetch(`/api/admin/news/${item.id}`, { method: "DELETE" });
    await load();
    setBusy(null);
  }

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="mx-auto mb-4 h-12 w-12 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <Link
        href="/admin"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับ Dashboard
      </Link>

      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">จัดการข่าวและอัปเดต</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            โพสต์ product update และข่าวสอบ — บทความ blog จะ sync เข้ามาอัตโนมัติ
          </p>
        </div>
        <div className="flex flex-wrap items-center justify-end gap-2">
          <Button variant="outline" className="gap-2" disabled={fetching} onClick={fetchNow}>
            {fetching ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <RefreshCw className="h-4 w-4" />
            )}
            ดึงข่าวตอนนี้
          </Button>
          <Link href="/admin/news/new">
            <Button className="gap-2">
              <Plus className="h-4 w-4" /> เพิ่มข่าวใหม่
            </Button>
          </Link>
        </div>
      </div>
      <p className="mb-4 text-xs text-muted-foreground">
        ข่าวสอบแพทย์ดึงอัตโนมัติทุกเช้า (06:15) — ที่ AI ว่าเกี่ยวข้องขึ้นหน้า /news ทันที ที่ไม่เกี่ยวถูกซ่อนไว้
        ซ่อน/แสดงได้ที่ปุ่มด้านขวา ข่าวอัตโนมัติจะไม่ถูกโพสต์ Facebook/LINE เอง
      </p>
      {fetchMsg && (
        <p
          className={`mb-4 text-sm ${fetchMsg.ok ? "text-green-700" : "text-red-600"}`}
          aria-live="polite"
        >
          {fetchMsg.text}
        </p>
      )}

      {items.length === 0 ? (
        <Card>
          <CardContent className="py-12 text-center text-muted-foreground">
            ยังไม่มีข่าว
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {items.map((item) => (
            <Card key={item.id} className={item.is_active ? undefined : "opacity-60"}>
              <CardContent className="flex flex-col gap-3 py-4 sm:flex-row sm:items-start sm:justify-between">
                <div className="flex-1">
                  <div className="mb-1.5 flex flex-wrap items-center gap-2">
                    <Badge className={TYPE_COLOR[item.source_type]}>
                      {TYPE_LABEL[item.source_type]}
                    </Badge>
                    {item.source_section && (
                      <Badge variant="outline">{item.source_section}</Badge>
                    )}
                    {item.origin === "auto" && (
                      <Badge className="bg-sky-100 text-sky-700">อัตโนมัติ</Badge>
                    )}
                    {!item.is_active && (
                      <Badge className="bg-gray-200 text-gray-700">ซ่อนอยู่</Badge>
                    )}
                    {item.exam_schedule && (
                      <Badge className="bg-orange-100 text-orange-700">
                        กำหนดการสอบ — ตรวจปฏิทินสอบ
                      </Badge>
                    )}
                    {item.pinned && (
                      <Badge className="bg-yellow-100 text-yellow-800">
                        <Pin className="mr-1 h-3 w-3" /> ปักหมุด
                      </Badge>
                    )}
                    <span className="text-xs text-muted-foreground">
                      {new Date(item.published_at).toLocaleDateString("th-TH")}
                    </span>
                    {item.origin === "auto" && item.source_name && (
                      <span className="text-xs text-muted-foreground">{item.source_name}</span>
                    )}
                    {item.origin === "manual" &&
                      item.source_type !== "blog" &&
                      item.source_type !== "external_health" && (
                      <>
                        {(() => {
                          const fb = statusBadge(!!item.fb_post_id, item.fb_last_error);
                          const line = statusBadge(!!item.line_broadcast_at, item.line_last_error);
                          return (
                            <>
                              <Badge className={fb.className} title={item.fb_last_error ?? undefined}>
                                FB: {fb.label}
                              </Badge>
                              <Badge className={line.className} title={item.line_last_error ?? undefined}>
                                LINE: {line.label}
                              </Badge>
                            </>
                          );
                        })()}
                      </>
                    )}
                  </div>
                  <p className="font-semibold">{item.title}</p>
                  <p className="mt-1 line-clamp-2 text-sm text-muted-foreground">
                    {item.summary}
                  </p>
                </div>
                <div className="flex gap-2 sm:flex-col sm:items-end">
                  {item.origin === "auto" && (
                    <Button
                      size="sm"
                      variant="outline"
                      disabled={busy === item.id}
                      onClick={() => toggleActive(item)}
                    >
                      {item.is_active ? (
                        <>
                          <EyeOff className="mr-1 h-4 w-4" /> ซ่อน
                        </>
                      ) : (
                        <>
                          <Eye className="mr-1 h-4 w-4" /> แสดง
                        </>
                      )}
                    </Button>
                  )}
                  {item.origin === "manual" &&
                    item.source_type !== "blog" &&
                    item.source_type !== "external_health" && (
                    <Button
                      size="sm"
                      variant="outline"
                      disabled={busy === item.id}
                      onClick={() => resend(item)}
                    >
                      <Send className="mr-1 h-4 w-4" /> ส่งอีกครั้ง
                    </Button>
                  )}
                  <Button
                    size="sm"
                    variant="outline"
                    disabled={busy === item.id || item.source_type === "blog"}
                    onClick={() => togglePin(item)}
                  >
                    {item.pinned ? (
                      <>
                        <PinOff className="mr-1 h-4 w-4" /> เลิกปัก
                      </>
                    ) : (
                      <>
                        <Pin className="mr-1 h-4 w-4" /> ปักหมุด
                      </>
                    )}
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    className="text-red-600"
                    disabled={busy === item.id || item.source_type === "blog"}
                    onClick={() => remove(item)}
                  >
                    <Trash2 className="mr-1 h-4 w-4" /> ลบ
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
