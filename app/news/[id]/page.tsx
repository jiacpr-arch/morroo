import { notFound, redirect } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import type { Metadata } from "next";
import { Rocket, Calendar, FileText, HeartPulse } from "lucide-react";
import { getNewsItem, type NewsSourceType } from "@/lib/news";

export const revalidate = 60;
export const dynamicParams = true;

const SOURCE_LABEL: Record<NewsSourceType, string> = {
  product_update: "อัปเดตระบบ",
  blog: "บทความ",
  exam: "ข่าวสอบ",
  external_health: "ข่าวสุขภาพ",
};

const SOURCE_ICON: Record<NewsSourceType, typeof Rocket> = {
  product_update: Rocket,
  blog: FileText,
  exam: Calendar,
  external_health: HeartPulse,
};

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const item = await getNewsItem(id);
  if (!item) return { title: "ไม่พบข่าว" };
  return {
    title: `${item.title} — ข่าวหมอรู้`,
    description: item.summary,
    alternates: { canonical: `https://www.morroo.com/news/${id}` },
    openGraph: {
      title: item.title,
      description: item.summary,
      url: `https://www.morroo.com/news/${id}`,
      type: "article",
      publishedTime: item.publishedAt,
      ...(item.coverImage
        ? { images: [{ url: item.coverImage, width: 1200, height: 630 }] }
        : {}),
    },
  };
}

export default async function NewsItemPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const item = await getNewsItem(id);
  if (!item) notFound();

  // Blog / external items live at their source — redirect there to avoid
  // duplicating content and to send users to the canonical URL.
  if (item.sourceType === "blog" && item.link) redirect(item.link);
  if (item.sourceType === "external_health" && item.link) redirect(item.link);

  const Icon = SOURCE_ICON[item.sourceType];
  const dateStr = new Date(item.publishedAt).toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <Link href="/news" className="hover:text-foreground">
          ข่าว
        </Link>
        {" / "}
        <span className="text-foreground">{SOURCE_LABEL[item.sourceType]}</span>
      </nav>

      <header className="mb-8">
        <div className="mb-3 flex items-center gap-2 text-sm text-muted-foreground">
          <Icon className="h-4 w-4" />
          <span>{SOURCE_LABEL[item.sourceType]}</span>
          <span>·</span>
          <span>{dateStr}</span>
        </div>
        <h1 className="text-3xl font-bold leading-snug text-foreground sm:text-4xl">
          {item.title}
        </h1>
        <p className="mt-3 text-lg text-muted-foreground">{item.summary}</p>
      </header>

      {item.coverImage && (
        <div className="mb-10 overflow-hidden rounded-xl border border-border">
          <Image
            src={item.coverImage}
            alt={item.title}
            width={1200}
            height={630}
            priority
            className="h-auto w-full"
          />
        </div>
      )}

      {item.body && (
        <article
          className="prose prose-lg max-w-none
            prose-headings:font-semibold prose-headings:text-foreground
            prose-p:leading-8 prose-p:text-foreground/85
            prose-a:text-brand prose-a:font-medium prose-a:no-underline hover:prose-a:underline
            prose-li:text-foreground/85
            prose-strong:text-foreground"
          dangerouslySetInnerHTML={{ __html: item.body }}
        />
      )}

      {item.link && (
        <div className="mt-8">
          <Link
            href={item.link}
            className="inline-flex items-center gap-2 rounded-lg bg-brand px-5 py-2.5 text-sm font-medium text-white transition-colors hover:bg-brand/90"
          >
            ไปยังหน้าที่เกี่ยวข้อง →
          </Link>
        </div>
      )}

      <div className="mt-12 border-t border-border pt-6">
        <Link
          href="/news"
          className="text-sm font-medium text-brand hover:underline"
        >
          ← กลับไปยังหน้าข่าวทั้งหมด
        </Link>
      </div>
    </div>
  );
}
