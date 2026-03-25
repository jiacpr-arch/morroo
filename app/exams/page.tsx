import { Suspense } from "react";
import ExamCard from "@/components/ExamCard";
import { Badge } from "@/components/ui/badge";
import { getExams, getExamPartCounts } from "@/lib/supabase/queries";
import { CATEGORIES } from "@/lib/types";
import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "ข้อสอบทั้งหมด",
  description: "รวมข้อสอบ MEQ ทุกสาขาวิชา อายุรศาสตร์ ศัลยศาสตร์ กุมารฯ สูติฯ ออร์โธฯ จิตเวช",
};

async function ExamsList({
  category,
  difficulty,
  isFree,
}: {
  category?: string;
  difficulty?: string;
  isFree?: string;
}) {
  const [allExams, partCounts] = await Promise.all([getExams(), getExamPartCounts()]);
  let exams = allExams;

  if (category) {
    exams = exams.filter((e) => e.category === category);
  }
  if (difficulty) {
    exams = exams.filter((e) => e.difficulty === difficulty);
  }
  if (isFree === "true") {
    exams = exams.filter((e) => e.is_free);
  } else if (isFree === "false") {
    exams = exams.filter((e) => !e.is_free);
  }

  if (exams.length === 0) {
    return (
      <div className="text-center py-16 text-muted-foreground">
        <p className="text-lg">ไม่พบข้อสอบที่ตรงกับเงื่อนไข</p>
        <Link href="/exams" className="text-brand hover:underline mt-2 inline-block">
          ดูข้อสอบทั้งหมด
        </Link>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      {exams.map((exam) => (
        <ExamCard key={exam.id} exam={exam} partCount={partCounts[exam.id] || 0} />
      ))}
    </div>
  );
}

export default async function ExamsPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string; difficulty?: string; free?: string }>;
}) {
  const params = await searchParams;
  const { category, difficulty, free } = params;

  const difficulties = [
    { value: "easy", label: "ง่าย" },
    { value: "medium", label: "ปานกลาง" },
    { value: "hard", label: "ยาก" },
  ];

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">ข้อสอบทั้งหมด</h1>
        <p className="mt-2 text-muted-foreground">
          เลือกข้อสอบที่ต้องการฝึก
        </p>
      </div>

      {/* Filters */}
      <div className="mb-8 space-y-4">
        {/* Category filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">
            สาขาวิชา
          </h3>
          <div className="flex flex-wrap gap-2">
            <Link href="/exams">
              <Badge
                variant={!category ? "default" : "secondary"}
                className={`cursor-pointer ${
                  !category ? "bg-brand text-white" : "hover:bg-brand/10"
                }`}
              >
                ทั้งหมด
              </Badge>
            </Link>
            {CATEGORIES.map((cat) => (
              <Link
                key={cat.slug}
                href={`/exams?category=${encodeURIComponent(cat.name)}${
                  difficulty ? `&difficulty=${difficulty}` : ""
                }${free ? `&free=${free}` : ""}`}
              >
                <Badge
                  variant={category === cat.name ? "default" : "secondary"}
                  className={`cursor-pointer ${
                    category === cat.name
                      ? "bg-brand text-white"
                      : "hover:bg-brand/10"
                  }`}
                >
                  {cat.icon} {cat.name}
                </Badge>
              </Link>
            ))}
          </div>
        </div>

        {/* Difficulty filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">
            ระดับความยาก
          </h3>
          <div className="flex flex-wrap gap-2">
            <Link
              href={`/exams${category ? `?category=${encodeURIComponent(category)}` : ""}${
                free
                  ? `${category ? "&" : "?"}free=${free}`
                  : ""
              }`}
            >
              <Badge
                variant={!difficulty ? "default" : "secondary"}
                className={`cursor-pointer ${
                  !difficulty ? "bg-brand text-white" : "hover:bg-brand/10"
                }`}
              >
                ทั้งหมด
              </Badge>
            </Link>
            {difficulties.map((d) => (
              <Link
                key={d.value}
                href={`/exams?${
                  category ? `category=${encodeURIComponent(category)}&` : ""
                }difficulty=${d.value}${free ? `&free=${free}` : ""}`}
              >
                <Badge
                  variant={difficulty === d.value ? "default" : "secondary"}
                  className={`cursor-pointer ${
                    difficulty === d.value
                      ? "bg-brand text-white"
                      : "hover:bg-brand/10"
                  }`}
                >
                  {d.label}
                </Badge>
              </Link>
            ))}
          </div>
        </div>

        {/* Free/Premium filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">
            ประเภท
          </h3>
          <div className="flex flex-wrap gap-2">
            <Link
              href={`/exams${
                category ? `?category=${encodeURIComponent(category)}` : ""
              }${
                difficulty
                  ? `${category ? "&" : "?"}difficulty=${difficulty}`
                  : ""
              }`}
            >
              <Badge
                variant={!free ? "default" : "secondary"}
                className={`cursor-pointer ${
                  !free ? "bg-brand text-white" : "hover:bg-brand/10"
                }`}
              >
                ทั้งหมด
              </Badge>
            </Link>
            <Link
              href={`/exams?${
                category ? `category=${encodeURIComponent(category)}&` : ""
              }${difficulty ? `difficulty=${difficulty}&` : ""}free=true`}
            >
              <Badge
                variant={free === "true" ? "default" : "secondary"}
                className={`cursor-pointer ${
                  free === "true"
                    ? "bg-brand text-white"
                    : "hover:bg-brand/10"
                }`}
              >
                ฟรี
              </Badge>
            </Link>
            <Link
              href={`/exams?${
                category ? `category=${encodeURIComponent(category)}&` : ""
              }${difficulty ? `difficulty=${difficulty}&` : ""}free=false`}
            >
              <Badge
                variant={free === "false" ? "default" : "secondary"}
                className={`cursor-pointer ${
                  free === "false"
                    ? "bg-brand text-white"
                    : "hover:bg-brand/10"
                }`}
              >
                Premium
              </Badge>
            </Link>
          </div>
        </div>
      </div>

      <Suspense fallback={<div className="text-center py-8">กำลังโหลด...</div>}>
        <ExamsList category={category} difficulty={difficulty} isFree={free} />
      </Suspense>
    </div>
  );
}
