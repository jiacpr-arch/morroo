"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";
import ExamCard from "@/components/ExamCard";
import { Badge } from "@/components/ui/badge";
import { CATEGORIES } from "@/lib/types";
import type { Exam } from "@/lib/types";

/**
 * ตัวกรอง + รายการข้อสอบของหน้า /exams ทำงานฝั่ง client เพื่อให้หน้าเป็น ISR ได้:
 * การ await searchParams ใน server component บังคับให้ Next เรนเดอร์แบบ dynamic
 * ทุก request และ `revalidate` ไม่มีผล (แนวเดียวกับ BlogPostList)
 * รายการทั้งหมดถูกส่งมาจาก server เรียงลำดับแล้ว ที่นี่แค่กรองตาม query string
 */

const DIFFICULTIES = [
  { value: "easy", label: "ง่าย" },
  { value: "medium", label: "ปานกลาง" },
  { value: "hard", label: "ยาก" },
];

type Filters = { category?: string; difficulty?: string; free?: string };

function buildHref(f: Filters): string {
  const qs = new URLSearchParams();
  if (f.category) qs.set("category", f.category);
  if (f.difficulty) qs.set("difficulty", f.difficulty);
  if (f.free) qs.set("free", f.free);
  const s = qs.toString();
  return s ? `/exams?${s}` : "/exams";
}

function FilterBadge({ href, active, children }: { href: string; active: boolean; children: React.ReactNode }) {
  return (
    <Link href={href}>
      <Badge
        variant={active ? "default" : "secondary"}
        className={`cursor-pointer ${active ? "bg-brand text-white" : "hover:bg-brand/10"}`}
      >
        {children}
      </Badge>
    </Link>
  );
}

export default function ExamsFilterList({
  exams: allExams,
  partCounts,
}: {
  exams: Exam[];
  partCounts: Record<string, number>;
}) {
  const sp = useSearchParams();
  const category = sp.get("category") ?? undefined;
  const difficulty = sp.get("difficulty") ?? undefined;
  const free = sp.get("free") ?? undefined;

  let exams = allExams;
  if (category) exams = exams.filter((e) => e.category === category);
  if (difficulty) exams = exams.filter((e) => e.difficulty === difficulty);
  if (free === "true") exams = exams.filter((e) => e.is_free);
  else if (free === "false") exams = exams.filter((e) => !e.is_free);

  return (
    <>
      {/* Filters */}
      <div className="mb-8 space-y-4">
        {/* Category filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">สาขาวิชา</h3>
          <div className="flex flex-wrap gap-2">
            <FilterBadge href={buildHref({ difficulty, free })} active={!category}>
              ทั้งหมด
            </FilterBadge>
            {CATEGORIES.map((cat) => (
              <FilterBadge
                key={cat.slug}
                href={buildHref({ category: cat.name, difficulty, free })}
                active={category === cat.name}
              >
                {cat.icon} {cat.name}
              </FilterBadge>
            ))}
          </div>
        </div>

        {/* Difficulty filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">ระดับความยาก</h3>
          <div className="flex flex-wrap gap-2">
            <FilterBadge href={buildHref({ category, free })} active={!difficulty}>
              ทั้งหมด
            </FilterBadge>
            {DIFFICULTIES.map((d) => (
              <FilterBadge
                key={d.value}
                href={buildHref({ category, difficulty: d.value, free })}
                active={difficulty === d.value}
              >
                {d.label}
              </FilterBadge>
            ))}
          </div>
        </div>

        {/* Free/Premium filter */}
        <div>
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">ประเภท</h3>
          <div className="flex flex-wrap gap-2">
            <FilterBadge href={buildHref({ category, difficulty })} active={!free}>
              ทั้งหมด
            </FilterBadge>
            <FilterBadge href={buildHref({ category, difficulty, free: "true" })} active={free === "true"}>
              ฟรี
            </FilterBadge>
            <FilterBadge href={buildHref({ category, difficulty, free: "false" })} active={free === "false"}>
              Premium
            </FilterBadge>
          </div>
        </div>
      </div>

      {exams.length === 0 ? (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">ไม่พบข้อสอบที่ตรงกับเงื่อนไข</p>
          <Link href="/exams" className="text-brand hover:underline mt-2 inline-block">
            ดูข้อสอบทั้งหมด
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {exams.map((exam) => (
            <ExamCard key={exam.id} exam={exam} partCount={partCounts[exam.id] || 0} />
          ))}
        </div>
      )}
    </>
  );
}
