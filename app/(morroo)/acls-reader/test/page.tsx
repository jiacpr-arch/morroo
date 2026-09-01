import Link from "next/link";
import { getAssessmentSets } from "@/lib/acls-reader/assessment";
import { preCourseLessons } from "@/lib/acls-reader/precourse";
import { PostTestGate } from "@/components/acls-reader/PostTestLock";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

export const revalidate = 600;

function describe(set: { id: string; selectionMode: string; selectionConfig: Record<string, number> | null }) {
  if (set.selectionMode === "pool" && set.selectionConfig) {
    const n = Object.values(set.selectionConfig).reduce((a, b) => a + b, 0);
    return `สุ่ม ${n} ข้อตามระดับความยาก`;
  }
  return "แบบทดสอบทั้งชุด";
}

export default async function TestIndex() {
  const sets = await getAssessmentSets();
  const pretests = sets.filter((s) => s.id.startsWith("pretest"));
  const posttests = sets.filter((s) => s.id.startsWith("posttest"));
  const others = sets.filter((s) => !s.id.startsWith("pretest") && !s.id.startsWith("posttest"));

  const Section = ({ title, items }: { title: string; items: typeof sets }) =>
    items.length === 0 ? null : (
      <div className="mb-8">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          {title}
        </h2>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          {items.map((s) => (
            <Link key={s.id} href={`/acls-reader/test/${s.id}`} className="block">
              <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
                <CardHeader>
                  <CardTitle className="text-base">{s.title}</CardTitle>
                  <CardDescription>{describe(s)}</CardDescription>
                </CardHeader>
              </Card>
            </Link>
          ))}
        </div>
      </div>
    );

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      <header className="mb-10 text-center">
        <h1 className="text-3xl font-bold sm:text-4xl">แบบทดสอบ ACLS</h1>
        <p className="mt-3 text-lg text-muted-foreground">
          ทดสอบความรู้ก่อน/หลังเรียน — มีเฉลยและคำอธิบายทุกข้อ
        </p>
      </header>

      {sets.length === 0 ? (
        <p className="rounded-lg border border-border bg-muted/40 p-4 text-center text-muted-foreground">
          ยังไม่มีแบบทดสอบ
        </p>
      ) : (
        <>
          <Section title="ก่อนเรียน (Pre-test)" items={pretests} />
          <PostTestGate
            items={posttests}
            pretestIds={pretests.map((p) => p.id)}
            lessons={preCourseLessons.map((l) => ({
              id: l.id,
              passingScore: l.passingScore,
            }))}
          />
          <Section title="อื่นๆ" items={others} />
        </>
      )}
    </div>
  );
}
