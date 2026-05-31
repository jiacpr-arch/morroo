import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, GitCompare } from "lucide-react";
import CompareTool from "@/components/school/CompareTool";

export const metadata = {
  title: "Compare & Contrast — School",
  description: "เปรียบเทียบ 2-4 disease / concept / drug แบบ side-by-side ด้วย AI",
};

export default function ComparePage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-pink-100 text-pink-700">Compare & Contrast</Badge>
        <Badge variant="outline">AI generated</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <GitCompare className="h-6 w-6 text-pink-600" /> เปรียบเทียบ
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ฝึก discrimination — เลือก 2-4 อย่างที่สับสน (เช่น MI vs PE vs aortic dissection)
        — AI สร้างตาราง side-by-side
      </p>

      <CompareTool />
    </div>
  );
}
