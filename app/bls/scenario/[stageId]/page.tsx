import { notFound } from "next/navigation";
import Link from "next/link";
import { blsScenarios, FINAL_EXAM_ID } from "@/lib/courses/bls/scenarios";
import BlsScenarioPlayer from "@/components/courses/bls/BlsScenarioPlayer";

export function generateStaticParams() {
  return [...blsScenarios.map((s) => ({ stageId: s.id })), { stageId: FINAL_EXAM_ID }];
}

function findStageMeta(stageId: string) {
  if (stageId === FINAL_EXAM_ID) {
    return { title: "ข้อสอบรวม — ทบทวนทุกเคส" };
  }
  return blsScenarios.find((s) => s.id === stageId);
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ stageId: string }>;
}) {
  const { stageId } = await params;
  const stage = findStageMeta(stageId);
  return { title: stage?.title ?? "ไม่พบด่านนี้" };
}

export default async function BlsScenarioStagePage({
  params,
}: {
  params: Promise<{ stageId: string }>;
}) {
  const { stageId } = await params;
  const isKnown = stageId === FINAL_EXAM_ID || blsScenarios.some((s) => s.id === stageId);
  if (!isKnown) notFound();

  const stage = findStageMeta(stageId);

  return (
    <div className="mx-auto max-w-2xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <Link href="/bls/scenario" className="hover:text-foreground">
          เกมลำดับขั้น BLS
        </Link>
        {" / "}
        <span className="text-foreground">{stage?.title ?? stageId}</span>
      </nav>

      <BlsScenarioPlayer stageId={stageId} />
    </div>
  );
}
