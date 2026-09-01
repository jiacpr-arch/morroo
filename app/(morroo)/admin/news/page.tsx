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
        <Link href="/admin/news/new">
          <Button className="gap-2">
            <Plus className="h-4 w-4" /> เพิ่มข่าวใหม่
          </Button>
        </Link>
      </div>

      {items.length === 0 ? (
        <Card>
          <CardContent className="py-12 text-center text-muted-foreground">
            ยังไม่มีข่าว
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {items.map((item) => (
            <Card key={item.id}>
              <CardContent className="flex flex-col gap-3 py-4 sm:flex-row sm:items-start sm:justify-between">
                <div className="flex-1">
                  <div className="mb-1.5 flex flex-wrap items-center gap-2">
                    <Badge className={TYPE_COLOR[item.source_type]}>
                      {TYPE_LABEL[item.source_type]}
                    </Badge>
                    {item.source_section && (
                      <Badge variant="outline">{item.source_section}</Badge>
                    )}
                    {item.pinned && (
                      <Badge className="bg-yellow-100 text-yellow-800">
                        <Pin className="mr-1 h-3 w-3" /> ปักหมุด
                      </Badge>
                    )}
                    <span className="text-xs text-muted-foreground">
                      {new Date(item.published_at).toLocaleDateString("th-TH")}
                    </span>
                  </div>
                  <p className="font-semibold">{item.title}</p>
                  <p className="mt-1 line-clamp-2 text-sm text-muted-foreground">
                    {item.summary}
                  </p>
                </div>
                <div className="flex gap-2 sm:flex-col sm:items-end">
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
