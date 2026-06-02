"use client";

import { FormEvent, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { createClient } from "@/lib/supabase/client";
import { ChevronLeft, Loader2, Shield } from "lucide-react";

export default function NewNewsItemPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [sourceType, setSourceType] = useState<"product_update" | "exam">(
    "product_update",
  );
  const [sourceSection, setSourceSection] = useState("");
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [body, setBody] = useState("");
  const [link, setLink] = useState("");
  const [coverImage, setCoverImage] = useState("");
  const [pinned, setPinned] = useState(false);

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
      setLoading(false);
    }
    init();
  }, [router]);

  async function submit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    const res = await fetch("/api/admin/news", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        source_type: sourceType,
        source_section: sourceSection || null,
        title,
        summary,
        body: body || null,
        link: link || null,
        cover_image: coverImage || null,
        pinned,
      }),
    });
    setSubmitting(false);
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      setError(json.error ?? "เกิดข้อผิดพลาด");
      return;
    }
    router.push("/admin/news");
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
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link
        href="/admin/news"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับ
      </Link>
      <h1 className="mb-6 text-2xl font-bold">เพิ่มข่าวใหม่</h1>

      <Card>
        <CardContent className="py-6">
          <form onSubmit={submit} className="space-y-4">
            <div>
              <Label>ประเภท</Label>
              <div className="mt-1 flex gap-2">
                {(
                  [
                    { v: "product_update", label: "🚀 อัปเดตระบบ" },
                    { v: "exam", label: "📅 ข่าวสอบ" },
                  ] as const
                ).map((t) => (
                  <button
                    type="button"
                    key={t.v}
                    onClick={() => setSourceType(t.v)}
                    className={`rounded-full px-3 py-1.5 text-sm transition-colors ${
                      sourceType === t.v
                        ? "bg-brand text-white"
                        : "bg-muted text-muted-foreground hover:bg-brand/10"
                    }`}
                  >
                    {t.label}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <Label htmlFor="section">Section (ไม่ระบุก็ได้)</Label>
              <select
                id="section"
                value={sourceSection}
                onChange={(e) => setSourceSection(e.target.value)}
                className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="">— ไม่ระบุ —</option>
                <option value="exams">MEQ (exams)</option>
                <option value="nl">MCQ / NL</option>
                <option value="longcase">Long Case</option>
                <option value="school">School</option>
                <option value="acls">ACLS</option>
              </select>
            </div>

            <div>
              <Label htmlFor="title">หัวข้อ *</Label>
              <Input
                id="title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
                placeholder="เช่น เพิ่มฟีเจอร์ AI Examiner ใน Long Case"
              />
            </div>

            <div>
              <Label htmlFor="summary">สรุปสั้น (1-2 บรรทัด) *</Label>
              <Textarea
                id="summary"
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                required
                rows={2}
                placeholder="ย่อสำหรับการ์ดในหน้า /news"
              />
            </div>

            <div>
              <Label htmlFor="body">เนื้อหาเต็ม (HTML, ใส่หรือไม่ก็ได้)</Label>
              <Textarea
                id="body"
                value={body}
                onChange={(e) => setBody(e.target.value)}
                rows={6}
                placeholder="<p>รายละเอียดเพิ่มเติม...</p>"
              />
            </div>

            <div>
              <Label htmlFor="link">ลิงก์ปลายทาง (ใส่หรือไม่ก็ได้)</Label>
              <Input
                id="link"
                value={link}
                onChange={(e) => setLink(e.target.value)}
                placeholder="/longcase หรือ https://..."
              />
            </div>

            <div>
              <Label htmlFor="cover">URL รูปปก (ไม่ระบุก็ได้)</Label>
              <Input
                id="cover"
                value={coverImage}
                onChange={(e) => setCoverImage(e.target.value)}
                placeholder="https://..."
              />
            </div>

            <label className="flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={pinned}
                onChange={(e) => setPinned(e.target.checked)}
              />
              ปักหมุดบนสุดของ /news
            </label>

            {error && (
              <p className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
                {error}
              </p>
            )}

            <div className="flex justify-end gap-2">
              <Link href="/admin/news">
                <Button type="button" variant="outline">
                  ยกเลิก
                </Button>
              </Link>
              <Button type="submit" disabled={submitting}>
                {submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                บันทึก
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
