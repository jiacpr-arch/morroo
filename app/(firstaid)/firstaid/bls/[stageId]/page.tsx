import type { Metadata } from "next";
import BlsStageRunner from "@/components/firstaid/BlsStageRunner";
import { BLS_FINAL_ID, BLS_STAGES } from "@/lib/firstaid/content/blsGame";

interface PageProps {
  params: Promise<{ stageId: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { stageId } = await params;
  const stage = BLS_STAGES.find((s) => s.id === stageId);
  const title =
    stageId === BLS_FINAL_ID ? "ข้อสอบรวม BLS" : stage ? `ด่าน ${stage.stageNumber}: ${stage.title}` : "เกมฝึก BLS";
  return { title: `${title} — ปฐมพยาบาล` };
}

export default async function BlsStagePage({ params }: PageProps) {
  const { stageId } = await params;
  return <BlsStageRunner stageId={stageId} />;
}
