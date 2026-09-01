import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import CheckinStub from "../../_shared/CheckinStub";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ sessionCode: string }>;
}): Promise<Metadata> {
  const { sessionCode } = await params;
  return {
    title: "เช็คชื่อภาคปฏิบัติ | ปฐมพยาบาลเบื้องต้น — Jia Training Center",
    alternates: { canonical: faUrl(`/checkin/${sessionCode}`) },
  };
}

export default function Page() {
  return <CheckinStub />;
}
