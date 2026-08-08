import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, BookOpenText } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { getSchoolBook, getSchoolTopic } from "@/lib/supabase/queries-school";
import BookReader from "@/components/school/BookReader";
import UpgradeGate from "@/components/school/UpgradeGate";
import { schoolAccessFor, canOpenTopic } from "@/lib/school/access";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const result = await getSchoolBook(id);
  return {
    title: result?.book.title
      ? `${result.book.title} — หนังสือฉบับเต็ม`
      : "หนังสือฉบับเต็ม — School",
    description: result?.book.description ?? "อ่านเนื้อหาฉบับเต็มแบบต่อเนื่อง",
  };
}

export default async function BookPage({ params }: PageProps) {
  const { id } = await params;
  const result = await getSchoolBook(id);
  if (!result) notFound();
  const { book, chapters } = result;

  const topic = await getSchoolTopic(book.topic_id);

  // Which chapters has this user already read?
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  // หนังสือฉบับเต็มคือเนื้อหาที่ลึกที่สุดของวิชา — ล็อกพร้อมกับวิชาต้นทาง
  let access = schoolAccessFor(null);
  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .maybeSingle();
    access = schoolAccessFor(profile);
  }
  const unlocked = canOpenTopic(access, topic);

  let readChapterIds: string[] = [];
  if (user && unlocked && chapters.length > 0) {
    const { data: progress } = await supabase
      .from("school_progress")
      .select("unit_id")
      .eq("user_id", user.id)
      .eq("unit_type", "book_chapter")
      .in(
        "unit_id",
        chapters.map((c) => c.id)
      );
    readChapterIds = (progress ?? []).map(
      (r: { unit_id: string }) => r.unit_id
    );
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href={topic ? `/school/topic/${topic.id}` : "/school"}>
        <Button variant="ghost" size="sm" className="-ml-2 mb-4 gap-2">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>

      <div className="mb-4 flex flex-wrap items-center gap-2">
        <Badge className="bg-amber-100 text-amber-700">หนังสือฉบับเต็ม</Badge>
        <Badge variant="outline">{chapters.length} บท</Badge>
        <Badge variant="outline">Reference</Badge>
      </div>
      <h1 className="mb-3 flex items-center gap-2 text-3xl font-bold">
        <BookOpenText className="h-7 w-7 text-amber-600" /> {book.title}
      </h1>
      {book.description && (
        <p className="mb-6 text-sm text-muted-foreground">{book.description}</p>
      )}

      {!unlocked ? (
        <UpgradeGate
          title={`หนังสือของวิชา “${topic?.name_th ?? ""}” อยู่ในแพ็ก School`}
          description={`เนื้อหาฉบับเต็ม ${chapters.length} บท — สมัครแพ็ก School เพื่ออ่านได้ทุกเล่มของทุกวิชาในชั้นปี`}
          fallbackHref={topic ? `/school/topic/${topic.id}` : "/school"}
          fallbackLabel="กลับหน้าวิชา"
        />
      ) : chapters.length === 0 ? (
        <p className="text-sm text-muted-foreground">
          ยังไม่มีเนื้อหาในหนังสือเล่มนี้
        </p>
      ) : (
        <BookReader
          topicId={book.topic_id}
          chapters={chapters}
          readChapterIds={readChapterIds}
        />
      )}

      {book.source && (
        <p className="mt-6 text-xs italic text-muted-foreground">
          ที่มา: {book.source}
        </p>
      )}
    </div>
  );
}
