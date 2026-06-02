import Link from "next/link";
import { BookMarked, Shuffle } from "lucide-react";
import type { SchoolTopic } from "@/lib/types-school";

interface SubjectFilterProps {
  /** Base path of the mode, e.g. "/school/daily". */
  basePath: string;
  /** Topics (subjects) of the student's current year. */
  topics: SchoolTopic[];
  /** Currently selected subject id, or undefined when "all subjects". */
  activeTopicId?: string;
}

/**
 * Optional subject (รายวิชา) picker for year-based content modes.
 * No selection = random mix across the whole year (default).
 * Selecting one = content from that subject only.
 */
export default function SubjectFilter({
  basePath,
  topics,
  activeTopicId,
}: SubjectFilterProps) {
  if (topics.length === 0) return null;

  const chipBase =
    "inline-flex items-center gap-1 rounded-full border px-3 py-1.5 text-sm transition-colors";
  const active = "bg-brand text-white border-brand";
  const idle = "bg-background hover:bg-muted text-foreground border-border";

  return (
    <div className="mb-6">
      <p className="text-sm font-medium mb-2 flex items-center gap-1.5">
        <BookMarked className="h-4 w-4 text-brand" />
        เลือกรายวิชา
        <span className="font-normal text-muted-foreground">
          (ไม่เลือก = สุ่มทั้งชั้นปี)
        </span>
      </p>
      <div className="flex flex-wrap gap-2">
        <Link
          href={basePath}
          className={`${chipBase} ${!activeTopicId ? active : idle}`}
        >
          <Shuffle className="h-3.5 w-3.5" /> ทุกวิชา (สุ่ม)
        </Link>
        {topics.map((t) => {
          const isActive = t.id === activeTopicId;
          return (
            <Link
              key={t.id}
              href={`${basePath}?subject=${t.id}`}
              className={`${chipBase} ${isActive ? active : idle}`}
            >
              {t.school_systems?.icon && (
                <span aria-hidden>{t.school_systems.icon}</span>
              )}
              {t.name_th}
            </Link>
          );
        })}
      </div>
    </div>
  );
}
