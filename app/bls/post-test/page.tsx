import Link from "next/link";
import BlsPostTestGate from "@/components/courses/bls/BlsPostTestGate";
import BlsPostTestExam from "@/components/courses/bls/BlsPostTestExam";
import {
  pickRandomPostTestSet,
  POST_TEST_PASS_PERCENT,
  postTestSets,
} from "@/lib/courses/bls/post-test";

// force-dynamic: draws a random set (A/B) fresh every attempt, same as
// acls-emr's BLS post-test picker (pickRandomPostTestSet).
export const dynamic = "force-dynamic";

export const metadata = { title: "Post-test" };

export default function BlsPostTestPage() {
  const chosen = pickRandomPostTestSet();

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">Post-test</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">Post-test BLS</h1>
        <p className="mt-2 text-muted-foreground">
          สุ่มข้อสอบ 1 ใน {postTestSets.length} ชุด — เกณฑ์ผ่าน {POST_TEST_PASS_PERCENT}%
        </p>
      </header>

      <BlsPostTestGate>
        <BlsPostTestExam questions={chosen.questions} setId={chosen.title} />
      </BlsPostTestGate>
    </div>
  );
}
