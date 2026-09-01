import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Stethoscope } from "lucide-react";
import { getSchoolCases } from "@/lib/supabase/queries-school";

export const revalidate = 60;

export const metadata = {
  title: "Integrated Cases — Vertical Y1→Y6",
  description: "case ที่เดินผ่าน basic science → clinical — เห็นว่า Y1 ที่เรียนนำไปใช้ตอนไหน",
};

export default async function CasesIndexPage() {
  const cases = await getSchoolCases();

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-orange-100 text-orange-700">Integrated Cases</Badge>
        <Badge variant="outline">{cases.length} case</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Stethoscope className="h-6 w-6 text-orange-600" /> Vertical Integration (Y1 → Y6)
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        1 case = walk-through ผ่าน <strong>basic science → physio → path → pharm → clinical</strong> — เห็นว่าเรื่องที่เรียนตอนนี้ไปเชื่อมตอนไหน
      </p>

      <p className="text-xs text-muted-foreground italic mb-4">
        💡 หา exam practice หรือ?  ลอง{" "}
        <Link href="/longcase" className="underline">Long Case</Link> (จับเวลาจริง),{" "}
        <Link href="/exams" className="underline">MEQ Progressive Case</Link> หรือ{" "}
        <Link href="/nl/practice" className="underline">MCQ Practice</Link>
      </p>

      {cases.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี case (admin ลง content ผ่าน Path A)
        </div>
      ) : (
        <div className="space-y-3">
          {cases.map((c) => (
            <Link key={c.id} href={`/school/case/${c.id}`}>
              <Card className="hover:shadow-md hover:border-orange-300 transition-all cursor-pointer">
                <CardContent className="p-4 space-y-2">
                  <div className="flex items-center gap-2 flex-wrap">
                    <Badge variant="outline" className="text-xs">
                      {c.difficulty}
                    </Badge>
                    {c.school_systems && (
                      <Badge variant="outline" className="text-xs">
                        <span className="mr-1">{c.school_systems.icon}</span>
                        {c.school_systems.name_th}
                      </Badge>
                    )}
                    <Badge variant="outline" className="text-xs">
                      Y{c.audience_years.join(", Y")}
                    </Badge>
                  </div>
                  <p className="font-bold">{c.title}</p>
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {c.presentation}
                  </p>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
