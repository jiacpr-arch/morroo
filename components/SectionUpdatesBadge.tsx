import Link from "next/link";
import { Sparkles } from "lucide-react";
import { countRecentUpdatesBySection, type NewsSection } from "@/lib/news";

interface Props {
  section: NewsSection;
  sinceDays?: number;
  className?: string;
}

export default async function SectionUpdatesBadge({
  section,
  sinceDays = 14,
  className,
}: Props) {
  const count = await countRecentUpdatesBySection(section, sinceDays);
  if (count === 0) return null;

  return (
    <Link
      href={`/news?section=${section}`}
      className={`inline-flex items-center gap-2 rounded-full border border-brand/30 bg-brand/5 px-3 py-1.5 text-sm font-medium text-brand transition-colors hover:bg-brand/10 ${className ?? ""}`}
    >
      <Sparkles className="h-4 w-4" />
      มี {count} อัปเดตใหม่ใน section นี้
    </Link>
  );
}
