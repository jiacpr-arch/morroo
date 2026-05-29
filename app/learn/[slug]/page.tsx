import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { ArrowRight, BookOpen, Clock } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import FreeTrialBanner from "@/components/FreeTrialBanner";
import LandingPageTracker from "@/components/LandingPageTracker";
import { getGuide, getAllGuideSlugs, GUIDES } from "@/lib/guides";

export const revalidate = 3600; // 1 hour — content rarely changes

export async function generateStaticParams() {
  return getAllGuideSlugs().map((slug) => ({ slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const guide = getGuide(slug);
  if (!guide) return {};

  const url = `https://www.morroo.com/learn/${guide.slug}`;
  return {
    title: guide.metaTitle,
    description: guide.metaDescription,
    keywords: guide.keywords,
    alternates: { canonical: url },
    openGraph: {
      type: "article",
      url,
      title: guide.metaTitle,
      description: guide.metaDescription,
      publishedTime: guide.publishedAt,
    },
    twitter: {
      card: "summary_large_image",
      title: guide.metaTitle,
      description: guide.metaDescription,
    },
  };
}

export default async function GuidePage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const guide = getGuide(slug);
  if (!guide) notFound();

  const articleSchema = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: guide.metaTitle,
    description: guide.metaDescription,
    datePublished: guide.publishedAt,
    author: {
      "@type": "Organization",
      name: "หมอรู้ (MorRoo)",
      url: "https://www.morroo.com",
    },
    publisher: {
      "@type": "Organization",
      name: "หมอรู้ (MorRoo)",
      url: "https://www.morroo.com",
      logo: {
        "@type": "ImageObject",
        url: "https://www.morroo.com/logo.png",
      },
    },
    mainEntityOfPage: `https://www.morroo.com/learn/${guide.slug}`,
  };

  const otherGuides = GUIDES.filter((g) => g.slug !== guide.slug);

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(articleSchema) }}
      />
      <article className="mx-auto max-w-3xl px-4 py-10 sm:px-6 sm:py-12">
        <LandingPageTracker
          event="guide_view"
          properties={{ slug: guide.slug }}
        />

        <nav className="mb-6 text-sm text-muted-foreground">
          <Link href="/" className="hover:text-foreground">
            หน้าแรก
          </Link>{" "}
          /{" "}
          <Link href="/learn" className="hover:text-foreground">
            บทเรียน
          </Link>{" "}
          / <span className="text-foreground">{guide.title}</span>
        </nav>

        <header className="mb-8">
          <div className="flex flex-wrap items-center gap-2 mb-3">
            <Badge variant="secondary">คู่มือเตรียมสอบ</Badge>
            <span className="inline-flex items-center gap-1 text-xs text-muted-foreground">
              <Clock className="h-3 w-3" /> อ่าน {guide.readingMinutes} นาที
            </span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-bold leading-tight">
            {guide.title}
          </h1>
          <p className="mt-4 text-lg text-muted-foreground">{guide.intro}</p>
        </header>

        <FreeTrialBanner surface={`guide_${guide.slug}_top`} />

        <div className="prose prose-base sm:prose-lg max-w-none">
          {guide.sections.map((section) => (
            <section key={section.heading} className="mt-8">
              <h2 className="text-2xl font-bold text-foreground">
                {section.heading}
              </h2>
              {section.body.map((p, i) => (
                <p key={i} className="mt-3 text-foreground/90 leading-relaxed">
                  {p}
                </p>
              ))}
              {section.bullets && (
                <ul className="mt-4 space-y-2">
                  {section.bullets.map((b) => (
                    <li
                      key={b}
                      className="flex items-start gap-2 text-foreground/90"
                    >
                      <span className="mt-2 h-1.5 w-1.5 rounded-full bg-brand shrink-0" />
                      <span>{b}</span>
                    </li>
                  ))}
                </ul>
              )}
            </section>
          ))}
        </div>

        <div className="mt-12">
          <FreeTrialBanner surface={`guide_${guide.slug}_bottom`} />
        </div>

        {/* Closing CTA */}
        <section className="mt-12 rounded-2xl bg-brand-dark text-white p-8 text-center">
          <h2 className="text-2xl font-bold">พร้อมเริ่มฝึกแล้วใช่ไหม?</h2>
          <p className="mt-2 text-white/70">
            สมัครฟรีเข้าถึงข้อสอบ MEQ + MCQ + Long Case ทดลองได้ทันที
          </p>
          <div className="mt-6 flex flex-col sm:flex-row items-center justify-center gap-3">
            <Link href="/register">
              <Button
                size="lg"
                className="bg-brand hover:bg-brand-light text-white"
              >
                สมัครฟรี <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
            <Link href="/exams">
              <Button
                size="lg"
                variant="outline"
                className="border-white/30 bg-transparent text-white hover:bg-white/10"
              >
                ดูข้อสอบตัวอย่าง
              </Button>
            </Link>
          </div>
        </section>

        {/* Related */}
        {(guide.relatedLinks.length > 0 || otherGuides.length > 0) && (
          <section className="mt-12 border-t pt-8">
            <h2 className="text-lg font-bold mb-4 flex items-center gap-2">
              <BookOpen className="h-5 w-5" /> อ่านต่อ
            </h2>
            <ul className="grid gap-2 sm:grid-cols-2">
              {guide.relatedLinks.map((l) => (
                <li key={l.href}>
                  <Link
                    href={l.href}
                    className="block rounded-lg border p-3 text-sm hover:border-brand/30 hover:bg-brand/5 transition-colors"
                  >
                    {l.label} →
                  </Link>
                </li>
              ))}
              {otherGuides.map((g) => (
                <li key={g.slug}>
                  <Link
                    href={`/learn/${g.slug}`}
                    className="block rounded-lg border p-3 text-sm hover:border-brand/30 hover:bg-brand/5 transition-colors"
                  >
                    {g.title} →
                  </Link>
                </li>
              ))}
            </ul>
          </section>
        )}
      </article>
    </>
  );
}
