"use client";

import { use } from "react";
import Link from "next/link";
import { ChevronLeft } from "lucide-react";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { ChapterEditor } from "@/components/admin/acls/ChapterEditor";

// Chapter detail/editor page — sections, each with nested Q&A + images.
// Ported from acls-emr's src/pages/AdminChapters.jsx accordion body
// (components/admin/ChapterEditor.jsx), split into its own route here.
export default function ChapterDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const status = useAdminGate();
  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      <Link href="/admin/acls/chapters" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4">
        <ChevronLeft className="h-4 w-4" /> กลับไปคลังความรู้ ALS
      </Link>

      <ChapterEditor chapterId={id} />
    </div>
  );
}
