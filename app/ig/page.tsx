/**
 * Linkin.bio-style landing page for the morroodee Instagram bio link.
 *
 * IG only allows one clickable link in bio and none in feed captions, so feed
 * captions point readers here ("ลิงก์ใน bio"). Each card on this page links
 * directly to the corresponding blog article — giving the post-by-post link
 * IG itself won't allow.
 *
 * Listing source: blog_posts with ig_post_id set, ordered by ig_posted_at
 * (newest first). Limited to the last 30 so the page stays scannable on
 * mobile, which is virtually all the traffic.
 */

import Image from "next/image";
import Link from "next/link";
import type { Metadata } from "next";
import { createAdminClient } from "@/lib/supabase/admin";
import { SOCIAL_LINKS } from "@/components/SocialLinks";

export const revalidate = 300;

export const metadata: Metadata = {
  title: "Link in Bio — หมอรู้ (MorRoo)",
  description: "บทความเตรียมสอบแพทย์ทั้งหมดจาก Instagram ของหมอรู้ คลิกเข้าอ่านแต่ละบทความได้ทันที",
  alternates: { canonical: "https://www.morroo.com/ig" },
  openGraph: {
    title: "หมอรู้ — Link in Bio",
    description: "เลือกบทความเตรียมสอบแพทย์ที่อยากอ่านได้เลย",
    url: "https://www.morroo.com/ig",
  },
  robots: { index: false, follow: true },
};

interface IgLinkRow {
  slug: string;
  title: string;
  description: string | null;
  cover_image: string | null;
  ig_posted_at: string | null;
}

async function getIgLinkPosts(): Promise<IgLinkRow[]> {
  const supabase = createAdminClient();
  const { data } = await supabase
    .from("blog_posts")
    .select("slug, title, description, cover_image, ig_posted_at")
    .not("ig_post_id", "is", null)
    .order("ig_posted_at", { ascending: false })
    .limit(30);
  return (data as IgLinkRow[] | null) ?? [];
}

function formatDate(iso: string | null): string {
  if (!iso) return "";
  return new Date(iso).toLocaleDateString("th-TH", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

export default async function IgLinkInBioPage() {
  const posts = await getIgLinkPosts();

  return (
    <div className="mx-auto max-w-xl px-4 py-8 sm:py-12">
      {/* Profile header */}
      <header className="mb-8 flex flex-col items-center text-center">
        <div className="mb-4 flex h-20 w-20 items-center justify-center rounded-full bg-gradient-to-br from-brand to-brand-light text-2xl font-bold text-white ring-2 ring-brand/30">
          ม
        </div>
        <h1 className="text-xl font-bold">@morroodee</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          เตรียมสอบแพทย์ด้วย AI — MEQ, MCQ, Long Case
        </p>

        {/* Primary CTAs */}
        <div className="mt-5 flex w-full flex-col gap-2">
          <Link
            href="/"
            className="rounded-full bg-brand py-3 text-center text-sm font-semibold text-white shadow-sm transition-opacity hover:opacity-90"
          >
            🌐 เข้าเว็บหมอรู้ morroo.com
          </Link>
          <a
            href={SOCIAL_LINKS.line}
            target="_blank"
            rel="noopener noreferrer"
            className="rounded-full bg-[#06C755] py-3 text-center text-sm font-semibold text-white shadow-sm transition-opacity hover:opacity-90"
          >
            💬 ทักหาเราใน LINE
          </a>
          <Link
            href="/pricing"
            className="rounded-full border border-border bg-card py-3 text-center text-sm font-semibold text-foreground transition-colors hover:bg-muted"
          >
            💎 ดูแพ็กเกจ + ทดลองฟรี
          </Link>
        </div>
      </header>

      {/* Recent posts */}
      {posts.length > 0 && (
        <section>
          <h2 className="mb-3 text-xs font-medium uppercase tracking-wider text-muted-foreground">
            บทความล่าสุดจาก IG
          </h2>
          <ul className="space-y-3">
            {posts.map((post) => (
              <li key={post.slug}>
                <Link
                  href={`/blog/${post.slug}`}
                  className="flex gap-3 rounded-xl border border-border bg-card p-3 transition-all hover:border-brand/40 hover:shadow-sm"
                >
                  {post.cover_image && (
                    <div className="relative h-20 w-20 flex-shrink-0 overflow-hidden rounded-lg bg-muted">
                      <Image
                        src={post.cover_image}
                        alt=""
                        fill
                        sizes="80px"
                        className="object-cover"
                      />
                    </div>
                  )}
                  <div className="min-w-0 flex-1">
                    <p className="line-clamp-2 text-sm font-semibold leading-snug">
                      {post.title}
                    </p>
                    {post.description && (
                      <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">
                        {post.description}
                      </p>
                    )}
                    <p className="mt-1.5 text-[10px] text-muted-foreground">
                      {formatDate(post.ig_posted_at)}
                    </p>
                  </div>
                </Link>
              </li>
            ))}
          </ul>
          <div className="mt-5 text-center">
            <Link
              href="/blog"
              className="text-sm font-medium text-brand hover:underline"
            >
              ดูบทความทั้งหมด →
            </Link>
          </div>
        </section>
      )}
    </div>
  );
}
