import Link from "next/link";
import type { Metadata } from "next";
import GoodyEmbed from "@/components/GoodyEmbed";
import NewsCard from "@/components/NewsCard";
import { getNewsItems, type NewsSection, type NewsSourceType } from "@/lib/news";
import { getJiaAedNewsItems } from "@/lib/jiaaed-news";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "ข่าวและอัปเดต — หมอรู้",
  description:
    "รวมข่าวสาร อัปเดตฟีเจอร์ บทความเตรียมสอบ ข่าวสอบใบประกอบวิชาชีพเวชกรรม และข่าวสุขภาพล่าสุดจากหมอรู้",
  alternates: { canonical: "https://www.morroo.com/news" },
  openGraph: {
    title: "ข่าวและอัปเดต — หมอรู้",
    description:
      "รวมข่าวสาร อัปเดตฟีเจอร์ บทความ และข่าวสอบล่าสุดจากหมอรู้",
    url: "https://www.morroo.com/news",
  },
};

const FILTERS: { key: string; label: string; sourceType?: NewsSourceType }[] = [
  { key: "all", label: "ทั้งหมด" },
  { key: "product_update", label: "🚀 อัปเดตระบบ", sourceType: "product_update" },
  { key: "blog", label: "📝 บทความ", sourceType: "blog" },
  { key: "exam", label: "📅 ข่าวสอบ", sourceType: "exam" },
  { key: "health", label: "🏥 ข่าวสุขภาพ" },
  { key: "aed", label: "⚡ ข่าวกู้ชีพ/AED" },
];

const SECTIONS: { key: NewsSection; label: string }[] = [
  { key: "exams", label: "MEQ" },
  { key: "nl", label: "MCQ / NL" },
  { key: "longcase", label: "Long Case" },
  { key: "school", label: "School" },
  { key: "acls", label: "ACLS" },
];

function buildHref(
  filter: string,
  section: string | null
): string {
  const params = new URLSearchParams();
  if (filter !== "all") params.set("filter", filter);
  if (section) params.set("section", section);
  const q = params.toString();
  return q ? `/news?${q}` : "/news";
}

export default async function NewsPage({
  searchParams,
}: {
  searchParams: Promise<{ filter?: string; section?: string }>;
}) {
  const { filter = "all", section } = await searchParams;
  const activeFilter = FILTERS.find((f) => f.key === filter) ?? FILTERS[0];
  const activeSection = SECTIONS.find((s) => s.key === section)?.key;
  const isHealthTab = activeFilter.key === "health";
  const isAedTab = activeFilter.key === "aed";

  const items = isHealthTab
    ? []
    : isAedTab
      ? await getJiaAedNewsItems(30)
      : await getNewsItems({
          sourceType: activeFilter.sourceType,
          section: activeSection,
          limit: 50,
        });

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-foreground">ข่าวและอัปเดต</h1>
        <p className="mt-2 text-muted-foreground">
          อัปเดตฟีเจอร์ใหม่ บทความ ข่าวสอบ และข่าวสุขภาพล่าสุด
        </p>
      </div>

      {/* Source filter */}
      <div className="mb-4 flex flex-wrap gap-2">
        {FILTERS.map((f) => {
          const active = f.key === activeFilter.key;
          return (
            <Link
              key={f.key}
              href={buildHref(f.key, activeSection ?? null)}
              className={`rounded-full px-4 py-1.5 text-sm font-medium transition-colors ${
                active
                  ? "bg-brand text-white"
                  : "bg-muted text-muted-foreground hover:bg-brand/10 hover:text-brand"
              }`}
            >
              {f.label}
            </Link>
          );
        })}
      </div>

      {/* Section filter (only for tabs backed by news_items) */}
      {!isHealthTab && !isAedTab && (
        <div className="mb-8 flex flex-wrap items-center gap-2 text-sm">
          <span className="text-muted-foreground">Section:</span>
          <Link
            href={buildHref(activeFilter.key, null)}
            className={`rounded-full px-3 py-1 transition-colors ${
              !activeSection
                ? "bg-foreground text-background"
                : "bg-muted text-muted-foreground hover:bg-muted-foreground/10"
            }`}
          >
            ทั้งหมด
          </Link>
          {SECTIONS.map((s) => {
            const active = activeSection === s.key;
            return (
              <Link
                key={s.key}
                href={buildHref(activeFilter.key, s.key)}
                className={`rounded-full px-3 py-1 transition-colors ${
                  active
                    ? "bg-foreground text-background"
                    : "bg-muted text-muted-foreground hover:bg-muted-foreground/10"
                }`}
              >
                {s.label}
              </Link>
            );
          })}
        </div>
      )}

      {isHealthTab ? (
        <div className="overflow-hidden rounded-xl border bg-card">
          <GoodyEmbed site="health" type="news" title="ข่าวสุขภาพ" />
        </div>
      ) : items.length === 0 ? (
        <p className="py-12 text-center text-muted-foreground">
          {isAedTab ? (
            <>
              โหลดข่าวไม่สำเร็จ — ดูข่าวทั้งหมดได้ที่{" "}
              <a
                href="https://jiaaed.com/news"
                target="_blank"
                rel="noopener noreferrer"
                className="font-medium text-brand hover:underline"
              >
                jiaaed.com/news
              </a>
            </>
          ) : (
            "ยังไม่มีข่าวในหมวดนี้"
          )}
        </p>
      ) : (
        <>
          <div className="space-y-4">
            {items.map((item) => (
              <NewsCard key={item.id} item={item} />
            ))}
          </div>
          {isAedTab && (
            <p className="mt-6 text-center text-sm text-muted-foreground">
              ข่าวคัดสรรโดย{" "}
              <a
                href="https://jiaaed.com/news"
                target="_blank"
                rel="noopener noreferrer"
                className="font-medium text-brand hover:underline"
              >
                JiaAED
              </a>{" "}
              — ลิขสิทธิ์ข่าวต้นฉบับเป็นของสำนักข่าวที่อ้างอิง
            </p>
          )}
        </>
      )}

      <div className="mt-12 rounded-xl border border-brand/20 bg-brand/10 p-6 text-center">
        <h2 className="text-lg font-semibold">อยากรู้ทุกอัปเดตเร็วที่สุด?</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          แอด LINE หมอรู้เพื่อรับข้อสอบฟรีทุกเช้า + ข่าวสารใหม่ทันที
        </p>
        <div className="mt-4 flex flex-wrap justify-center gap-3">
          <Link
            href="/exams"
            className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white transition-colors hover:bg-brand/90"
          >
            ทำข้อสอบ MEQ
          </Link>
          <Link
            href="/blog"
            className="rounded-lg border border-brand px-5 py-2 text-sm font-medium text-brand transition-colors hover:bg-brand/10"
          >
            อ่านบทความทั้งหมด
          </Link>
        </div>
      </div>
    </div>
  );
}
