import Link from "next/link";
import { getAssessmentSets, getExamQuestions } from "@/lib/acls-reader/assessment";
import TrackedExam from "@/components/acls-reader/TrackedExam";
import { PRE_TEST_LESSON_ID, PRE_TEST_PASS_PERCENT } from "@/lib/courses/assessment-ids";

export const dynamic = "force-dynamic";

export const metadata = { title: "Pre-test" };

export default async function PreTestPage() {
  const sets = await getAssessmentSets();
  const pretestSet = sets.find((s) => s.id.startsWith("pretest"));

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">Pre-test</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">Pre-test ACLS</h1>
        <p className="mt-2 text-muted-foreground">
          ทำก่อนเริ่มเรียน เพื่อวัดพื้นฐานความรู้ — เกณฑ์ผ่าน {PRE_TEST_PASS_PERCENT}%
        </p>
      </header>

      {!pretestSet ? (
        <p className="rounded-lg border border-border bg-muted/40 p-4 text-center text-muted-foreground">
          ยังไม่มีแบบทดสอบ Pre-test
        </p>
      ) : (
        <PreTestBody setId={pretestSet.id} />
      )}
    </div>
  );
}

async function PreTestBody({ setId }: { setId: string }) {
  const { questions } = await getExamQuestions(setId);
  return (
    <TrackedExam
      questions={questions}
      setId={setId}
      passPct={PRE_TEST_PASS_PERCENT}
      lessonId={PRE_TEST_LESSON_ID}
    />
  );
}
