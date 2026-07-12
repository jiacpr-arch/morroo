import { notFound } from "next/navigation";
import Link from "next/link";
import { getExamQuestions, getAssessmentSets } from "@/lib/acls-reader/assessment";
import { preCourseLessons } from "@/lib/acls-reader/precourse";
import { isPostTestSet } from "@/lib/acls-reader/prereqs";
import { PrereqGuard } from "@/components/acls-reader/PostTestLock";
import Exam from "@/components/acls-reader/Exam";

// Per-request so pool-based tests draw a fresh set each attempt.
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ setId: string }>;
}) {
  const { setId } = await params;
  const { set } = await getExamQuestions(setId);
  return { title: set?.title ?? "แบบทดสอบ" };
}

export default async function ExamPage({
  params,
}: {
  params: Promise<{ setId: string }>;
}) {
  const { setId } = await params;
  const { set, questions } = await getExamQuestions(setId);
  if (!set) notFound();

  const gated = isPostTestSet(set.id);
  const pretestIds = gated
    ? (await getAssessmentSets())
        .filter((s) => s.id.startsWith("pretest"))
        .map((s) => s.id)
    : [];
  const lessons = preCourseLessons.map((l) => ({
    id: l.id,
    passingScore: l.passingScore,
  }));

  const exam = <Exam questions={questions} setId={set.id} />;

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls-reader" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <Link href="/acls-reader/test" className="hover:text-foreground">
          แบบทดสอบ
        </Link>
        {" / "}
        <span className="text-foreground">{set.title}</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">{set.title}</h1>
        <p className="mt-2 text-muted-foreground">
          {questions.length} ข้อ · เลือกคำตอบแล้วกด “ส่งคำตอบ” เพื่อดูเฉลย
        </p>
      </header>

      {gated ? (
        <PrereqGuard pretestIds={pretestIds} lessons={lessons}>
          {exam}
        </PrereqGuard>
      ) : (
        exam
      )}
    </div>
  );
}
