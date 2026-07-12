import Link from "next/link";
import { getAssessmentSets, getExamQuestions } from "@/lib/acls-reader/assessment";
import { preCourseLessons } from "@/lib/acls-reader/precourse";
import { PrereqGuard } from "@/components/acls-reader/PostTestLock";
import TrackedExam from "@/components/acls-reader/TrackedExam";
import { POST_TEST_LESSON_ID, POST_TEST_PASS_PERCENT } from "@/lib/courses/assessment-ids";

// force-dynamic: draws a random set (A/B/C) fresh every attempt, same as
// acls-emr's PostTestExam.jsx.
export const dynamic = "force-dynamic";

export const metadata = { title: "Post-test" };

export default async function PostTestPage() {
  const sets = await getAssessmentSets();
  const pretestIds = sets.filter((s) => s.id.startsWith("pretest")).map((s) => s.id);
  const posttestSets = sets.filter((s) => s.id.startsWith("posttest"));
  const chosen = posttestSets[Math.floor(Math.random() * posttestSets.length)];
  const lessons = preCourseLessons.map((l: { id: string; passingScore: number }) => ({
    id: l.id,
    passingScore: l.passingScore,
  }));

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">Post-test</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">Post-test ACLS</h1>
        <p className="mt-2 text-muted-foreground">
          สุ่มข้อสอบ 1 ใน {posttestSets.length || 3} ชุด — เกณฑ์ผ่าน {POST_TEST_PASS_PERCENT}%
        </p>
      </header>

      {!chosen ? (
        <p className="rounded-lg border border-border bg-muted/40 p-4 text-center text-muted-foreground">
          ยังไม่มีแบบทดสอบ Post-test
        </p>
      ) : (
        <PrereqGuard pretestIds={pretestIds} lessons={lessons}>
          <PostTestBody setId={chosen.id} />
        </PrereqGuard>
      )}
    </div>
  );
}

async function PostTestBody({ setId }: { setId: string }) {
  const { questions } = await getExamQuestions(setId);
  return (
    <TrackedExam
      questions={questions}
      setId={setId}
      passPct={POST_TEST_PASS_PERCENT}
      lessonId={POST_TEST_LESSON_ID}
    />
  );
}
