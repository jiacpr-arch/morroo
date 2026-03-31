"use client";

import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { Clock, ArrowRight, Hourglass } from "lucide-react";
import type { Exam } from "@/lib/types";
import ComingSoonCountdown from "@/components/ComingSoonCountdown";

const difficultyColors = {
  easy: "bg-green-100 text-green-700",
  medium: "bg-yellow-100 text-yellow-700",
  hard: "bg-red-100 text-red-700",
};

const difficultyLabels = {
  easy: "ง่าย",
  medium: "ปานกลาง",
  hard: "ยาก",
};

export default function ExamCard({ exam, partCount = 0 }: { exam: Exam; partCount?: number }) {
  // Coming soon if publish_date is in the future OR no parts yet
  const publishDate = exam.publish_date ? new Date(exam.publish_date + "T00:00:00") : null;
  const now = new Date();
  const isComingSoon = (publishDate && publishDate > now) || partCount === 0;
  const isNew = exam.created_at && (Date.now() - new Date(exam.created_at).getTime()) < 3 * 24 * 60 * 60 * 1000;

  if (isComingSoon) {
    return (
      <Card className="h-full opacity-75 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-transparent to-muted/50 pointer-events-none z-10" />
        <CardHeader className="pb-3">
          <div className="flex items-center gap-2 flex-wrap">
            <Badge variant="secondary" className="text-xs">
              {exam.category}
            </Badge>
            <Badge className={`text-xs ${difficultyColors[exam.difficulty]}`}>
              {difficultyLabels[exam.difficulty]}
            </Badge>
            <Badge className="bg-purple-100 text-purple-700 text-xs gap-1">
              <Hourglass className="h-3 w-3" /> เร็วๆ นี้
            </Badge>
          </div>
        </CardHeader>
        <CardContent className="pb-3">
          <h3 className="font-semibold text-base leading-snug line-clamp-2">
            {exam.title}
          </h3>
        </CardContent>
        <CardFooter className="pt-0">
          <ComingSoonCountdown publishDate={exam.publish_date} examId={exam.id} />
        </CardFooter>
      </Card>
    );
  }

  return (
    <Link href={`/exams/${exam.id}`}>
      <Card className="group h-full transition-all hover:shadow-lg hover:border-brand/30">
        <CardHeader className="pb-3">
          <div className="flex items-center gap-2 flex-wrap">
            <Badge variant="secondary" className="text-xs">
              {exam.category}
            </Badge>
            <Badge className={`text-xs ${difficultyColors[exam.difficulty]}`}>
              {difficultyLabels[exam.difficulty]}
            </Badge>
            {exam.is_free && (
              <Badge className="bg-brand/10 text-brand text-xs">ฟรี</Badge>
            )}
            {isNew && (
              <Badge className="bg-red-500 text-white text-xs animate-pulse">ใหม่</Badge>
            )}
          </div>
        </CardHeader>
        <CardContent className="pb-3">
          <h3 className="font-semibold text-base leading-snug group-hover:text-brand transition-colors line-clamp-2">
            {exam.title}
          </h3>
        </CardContent>
        <CardFooter className="pt-0 text-sm text-muted-foreground flex items-center justify-between">
          <span className="flex items-center gap-1">
            <Clock className="h-3.5 w-3.5" />{partCount} ตอน
          </span>
          <span className="flex items-center gap-1 text-brand opacity-0 group-hover:opacity-100 transition-opacity">
            เริ่มทำข้อสอบ <ArrowRight className="h-3.5 w-3.5" />
          </span>
        </CardFooter>
      </Card>
    </Link>
  );
}
