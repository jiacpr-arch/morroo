import Image from "next/image";
import Link from "next/link";
import { Rocket, FileText, Calendar, HeartPulse, Pin, Zap } from "lucide-react";
import type { NewsItem, NewsSourceType } from "@/lib/news";

const SOURCE_META: Record<
  NewsSourceType,
  { label: string; icon: typeof Rocket; tone: string }
> = {
  product_update: {
    label: "อัปเดตระบบ",
    icon: Rocket,
    tone: "bg-violet-100 text-violet-700",
  },
  blog: {
    label: "บทความ",
    icon: FileText,
    tone: "bg-blue-100 text-blue-700",
  },
  exam: {
    label: "ข่าวสอบ",
    icon: Calendar,
    tone: "bg-amber-100 text-amber-700",
  },
  external_health: {
    label: "ข่าวสุขภาพ",
    icon: HeartPulse,
    tone: "bg-rose-100 text-rose-700",
  },
  external_aed: {
    label: "ข่าวกู้ชีพ/AED",
    icon: Zap,
    tone: "bg-orange-100 text-orange-700",
  },
};

function resolveHref(item: NewsItem): string {
  if (item.sourceType === "product_update") return `/news/${item.id}`;
  return item.link ?? `/news/${item.id}`;
}

function isExternal(href: string): boolean {
  return href.startsWith("http://") || href.startsWith("https://");
}

export default function NewsCard({ item }: { item: NewsItem }) {
  const meta = SOURCE_META[item.sourceType];
  const Icon = meta.icon;
  const href = resolveHref(item);
  const external = isExternal(href);
  const dateStr = new Date(item.publishedAt).toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const inner = (
    <article className="group flex h-full flex-col overflow-hidden rounded-xl border border-border bg-card transition-shadow hover:shadow-md sm:flex-row">
      {item.coverImage && (
        <div className="relative aspect-[16/9] w-full overflow-hidden bg-muted sm:aspect-auto sm:w-56 sm:flex-shrink-0">
          <Image
            src={item.coverImage}
            alt={item.title}
            fill
            sizes="(max-width: 640px) 100vw, 224px"
            className="object-cover transition-transform group-hover:scale-105"
          />
        </div>
      )}
      <div className="flex-1 p-5">
        <div className="mb-2 flex flex-wrap items-center gap-2">
          <span
            className={`inline-flex items-center gap-1 rounded-full px-2.5 py-0.5 text-xs font-medium ${meta.tone}`}
          >
            <Icon className="h-3 w-3" />
            {meta.label}
          </span>
          {item.pinned && (
            <span className="inline-flex items-center gap-1 rounded-full bg-yellow-100 px-2.5 py-0.5 text-xs font-medium text-yellow-800">
              <Pin className="h-3 w-3" /> ปักหมุด
            </span>
          )}
          <span className="text-xs text-muted-foreground">{dateStr}</span>
        </div>
        <h3 className="font-semibold text-foreground transition-colors group-hover:text-brand">
          {item.title}
        </h3>
        <p className="mt-1.5 line-clamp-2 text-sm text-muted-foreground">
          {item.summary}
        </p>
        <div className="mt-3 text-sm font-medium text-brand">
          {external ? "อ่านที่ต้นทาง →" : "อ่านต่อ →"}
        </div>
      </div>
    </article>
  );

  if (external) {
    return (
      <a href={href} target="_blank" rel="noopener noreferrer">
        {inner}
      </a>
    );
  }
  return <Link href={href}>{inner}</Link>;
}
