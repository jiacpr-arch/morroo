import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Bot } from "lucide-react";
import TutorChat from "@/components/school/TutorChat";

export const metadata = {
  title: "AI Tutor — School",
  description: "ถามคำถามแพทย์ตอนไหนก็ได้ — AI พร้อม link ไป content ที่เกี่ยวข้อง",
};

export default function TutorPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-indigo-100 text-indigo-700">AI Tutor</Badge>
        <Badge variant="outline">Claude Sonnet 4.6</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Bot className="h-6 w-6 text-indigo-600" /> AI Medical Tutor
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ถามคำถามแพทย์ตอนไหนก็ได้ — AI จะอธิบาย + link ไป lessons/concepts ในระบบให้
      </p>

      <TutorChat />
    </div>
  );
}
