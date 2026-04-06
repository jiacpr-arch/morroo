import { notFound } from "next/navigation";
import Link from "next/link";
import { getBlogPost, getBlogPosts, getAllSlugs } from "@/lib/blog";
import type { Metadata } from "next";

export async function generateStaticParams() {
  const slugs = await getAllSlugs();
  return slugs.map((slug) => ({ slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const post = await getBlogPost(slug);
  if (!post) return { title: "ไม่พบบทความ" };
  return {
    title: post.title,
    description: post.description,
    alternates: { canonical: `https://www.morroo.com/blog/${slug}` },
    openGraph: {
      title: post.title,
      description: post.description,
      url: `https://www.morroo.com/blog/${slug}`,
      type: "article",
      publishedTime: post.publishedAt,
    },
  };
}

export default async function BlogPostPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const [post, allPosts] = await Promise.all([getBlogPost(slug), getBlogPosts()]);
  if (!post) notFound();

  const articleSchema = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: post.title,
    description: post.description,
    datePublished: post.publishedAt,
    author: {
      "@type": "Organization",
      name: "หมอรู้ (MorRoo)",
      url: "https://www.morroo.com",
    },
    publisher: {
      "@type": "EducationalOrganization",
      name: "หมอรู้ (MorRoo)",
      url: "https://www.morroo.com",
    },
    inLanguage: "th",
  };

  const related = allPosts.filter((p) => p.slug !== slug).slice(0, 2);

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(articleSchema) }}
      />
      <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
        {/* Breadcrumb */}
        <nav className="mb-6 text-sm text-muted-foreground">
          <Link href="/" className="hover:text-foreground">
            หน้าแรก
          </Link>
          {" / "}
          <Link href="/blog" className="hover:text-foreground">
            บทความ
          </Link>
          {" / "}
          <span className="text-foreground">{post.category}</span>
        </nav>

        {/* Header */}
        <header className="mb-8">
          <div className="mb-3 flex items-center gap-3 text-sm text-muted-foreground">
            <span>{post.category}</span>
            <span>·</span>
            <span>
              {new Date(post.publishedAt).toLocaleDateString("th-TH", {
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </span>
            <span>·</span>
            <span>อ่าน {post.readingTime} นาที</span>
          </div>
          <h1 className="text-3xl font-bold leading-snug text-foreground">
            {post.title}
          </h1>
          <p className="mt-3 text-lg text-muted-foreground">
            {post.description}
          </p>
        </header>

        {/* Content */}
        <article
          className="prose prose-lg max-w-none
            prose-headings:font-bold prose-headings:text-foreground
            prose-p:text-foreground/80 prose-p:leading-relaxed
            prose-a:text-brand prose-a:no-underline hover:prose-a:underline
            prose-li:text-foreground/80
            prose-strong:text-foreground
            prose-table:text-sm
            prose-th:bg-muted prose-th:p-2
            prose-td:p-2 prose-td:border"
          dangerouslySetInnerHTML={{ __html: post.content }}
        />

        {/* CTA */}
        <div className="mt-12 rounded-xl bg-brand/10 border border-brand/20 p-6">
          <h2 className="text-lg font-semibold">เริ่มฝึกสอบกับหมอรู้ได้เลย</h2>
          <p className="mt-1 text-sm text-muted-foreground">
            ข้อสอบ MEQ + MCQ 1,300+ ข้อ + Long Case กับ AI — เริ่มต้นฟรี
          </p>
          <div className="mt-4 flex flex-wrap gap-3">
            <Link
              href="/exams"
              className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90 transition-colors"
            >
              ทำข้อสอบ MEQ ฟรี
            </Link>
            <Link
              href="/nl"
              className="rounded-lg border border-brand px-5 py-2 text-sm font-medium text-brand hover:bg-brand/10 transition-colors"
            >
              ทำข้อสอบ MCQ ฟรี
            </Link>
          </div>
        </div>

        {/* Related */}
        {related.length > 0 && (
          <div className="mt-12">
            <h2 className="mb-4 text-xl font-semibold">บทความที่เกี่ยวข้อง</h2>
            <div className="space-y-4">
              {related.map((r) => (
                <Link key={r.slug} href={`/blog/${r.slug}`}>
                  <div className="rounded-lg border border-border p-4 hover:shadow-sm transition-shadow">
                    <p className="text-xs text-muted-foreground mb-1">
                      {r.category} · อ่าน {r.readingTime} นาที
                    </p>
                    <p className="font-medium text-foreground hover:text-brand transition-colors">
                      {r.title}
                    </p>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </>
  );
}
