"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { Loader2, BookOpen, ChevronRight, ChevronLeft } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";

interface ChapterListRow {
  id: string;
  title: string;
  icon: string | null;
  sort_order: number;
  updated_at: string;
  sectionCount: number;
}

// List of ACLS chapters → link to each chapter's detail/editor page.
// Ported from acls-emr's src/pages/AdminChapters.jsx (its accordion is split
// into list + [id] detail pages here, per morroo's routing convention).
export default function AdminChaptersPage() {
  const status = useAdminGate();
  const [chapters, setChapters] = useState<ChapterListRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const { chapters } = await apiGet<{ chapters: ChapterListRow[] }>("/api/admin/acls/chapters");
      setChapters(chapters);
    } catch (err) {
      alert("โหลดไม่สำเร็จ: " + errMsg(err));
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    if (status === "ok") load();
  }, [status, load]);

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="mb-6">
        <h1 className="text-2xl font-bold">คลังความรู้ ALS</h1>
        <p className="text-muted-foreground mt-1">แก้ไขเนื้อหา บันทึกอัตโนมัติเข้า Supabase</p>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
        </div>
      ) : (
        <div className="space-y-2">
          {chapters.map((ch) => (
            <Link key={ch.id} href={`/admin/acls/chapters/${ch.id}`}>
              <Card className="hover:shadow-md transition-shadow cursor-pointer">
                <CardContent className="flex items-center gap-3 py-3">
                  <div className="w-9 h-9 rounded-md bg-red-100 text-red-600 flex items-center justify-center shrink-0 text-base">
                    {ch.icon || <BookOpen className="h-4 w-4" />}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-bold truncate">{ch.title}</div>
                    <div className="text-xs text-muted-foreground">
                      {ch.sectionCount} หัวข้อ · อัปเดตล่าสุด {new Date(ch.updated_at).toLocaleDateString("th-TH")}
                    </div>
                  </div>
                  <ChevronRight className="h-4 w-4 text-muted-foreground shrink-0" />
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}

      <p className="text-xs text-muted-foreground text-center pt-4">
        เนื้อหาจะ refresh ในแอป end-user ภายใน 10 นาที (revalidate) — กด refresh เพื่อดูทันที
      </p>
    </div>
  );
}
