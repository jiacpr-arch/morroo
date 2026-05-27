import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, BookOpenCheck, Stethoscope, MessageSquare } from "lucide-react";
import type { BoardSpecialty } from "@/lib/types-board";

export default function BoardSpecialtyCard({
  specialty,
}: {
  specialty: BoardSpecialty;
}) {
  const isPublished = specialty.is_published;
  const card = (
    <Card
      className={`group h-full transition-all ${
        isPublished
          ? "hover:shadow-lg hover:border-brand/30 cursor-pointer"
          : "opacity-70"
      }`}
    >
      <CardContent className="pt-6">
        <div className="flex items-start justify-between gap-3 mb-3">
          <div className="flex items-center gap-2">
            <span className="text-3xl leading-none">{specialty.icon}</span>
            <div>
              <h3 className="font-bold text-lg leading-tight">
                {specialty.name_th}
              </h3>
              <p className="text-xs text-muted-foreground mt-0.5">
                {specialty.name_en}
              </p>
            </div>
          </div>
          {isPublished ? (
            <Badge className="bg-emerald-100 text-emerald-700 shrink-0">
              เปิดแล้ว
            </Badge>
          ) : (
            <Badge variant="secondary" className="shrink-0">
              เร็วๆนี้
            </Badge>
          )}
        </div>

        {specialty.royal_college && (
          <p className="text-xs text-muted-foreground mb-3 line-clamp-2">
            {specialty.royal_college}
          </p>
        )}

        <div className="flex flex-wrap gap-1.5 mb-4">
          <Badge variant="outline" className="gap-1 text-xs">
            <BookOpenCheck className="h-3 w-3" />
            MCQ {specialty.total_mcq_count ?? "?"} ข้อ
          </Badge>
          {specialty.has_long_case && (
            <Badge variant="outline" className="gap-1 text-xs">
              <Stethoscope className="h-3 w-3" />
              Long Case
            </Badge>
          )}
          {specialty.has_osce && (
            <Badge variant="outline" className="text-xs">OSCE</Badge>
          )}
          {specialty.has_oral && (
            <Badge variant="outline" className="gap-1 text-xs">
              <MessageSquare className="h-3 w-3" />
              Oral
            </Badge>
          )}
        </div>

        {isPublished && (
          <div className="text-sm text-brand inline-flex items-center gap-1 group-hover:gap-2 transition-all">
            เริ่มฝึก <ArrowRight className="h-4 w-4" />
          </div>
        )}
      </CardContent>
    </Card>
  );

  if (!isPublished) return card;
  return <Link href={`/board/${specialty.slug}`}>{card}</Link>;
}
