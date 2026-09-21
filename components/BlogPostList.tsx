"use client";

import Image from "next/image";
import Link from "next/link";
import { useSearchParams } from "next/navigation";

/**
 * รายการบทความ + ตัวกรองหมวด ทำงานฝั่ง client เพื่อให้หน้า /blog เป็น ISR ได้:
 * ถ้าอ่าน searchParams ใน server component Next จะบังคับเรนเดอร์แบบ dynamic
 * ทุก request และ `revalidate` จะไม่มีผล (ดู docs: layouts-and-pages#searchparams)
 * หน้า server ส่งเฉพาะ metadata ของโพสต์มา (ไม่รวม content) เพื่อไม่ให้
 * RSC payload บวม
 */
export type BlogPostSummary = {
  slug: string;
  title: string;
  description: string;
  publishedAt: string;
  category: string;
  readingTime: number;
  coverImage: string | null;
};

const CATEGORIES = ["ทั้งหมด", "ความรู้ทั่วไป", "เตรียมสอบ", "เทคนิคสอบ"];

const categoryColors: Record<string, string> = {
  "ความรู้ทั่วไป": "bg-blue-100 text-blue-700",
  "เตรียมสอบ": "bg-green-100 text-green-700",
  "เทคนิคสอบ": "bg-orange-100 text-orange-700",
};

export default function BlogPostList({ posts: allPosts }: { posts: BlogPostSummary[] }) {
  const cat = useSearchParams().get("cat");
  const posts = cat && cat !== "ทั้งหมด" ? allPosts.filter((p) => p.category === cat) : allPosts;

  return (
    <>
      {/* Category filter */}
      <div className="mb-8 flex flex-wrap gap-2">
        {CATEGORIES.map((c) => {
          const active = (c === "ทั้งหมด" && !cat) || cat === c;
          return (
            <Link
              key={c}
              href={c === "ทั้งหมด" ? "/blog" : `/blog?cat=${encodeURIComponent(c)}`}
              className={`rounded-full px-4 py-1.5 text-sm font-medium transition-colors ${
                active
                  ? "bg-brand text-white"
                  : "bg-muted text-muted-foreground hover:bg-brand/10 hover:text-brand"
              }`}
            >
              {c}
            </Link>
          );
        })}
      </div>

      {posts.length === 0 ? (
        <p className="text-muted-foreground py-12 text-center">ยังไม่มีบทความในหมวดนี้</p>
      ) : (
        <div className="space-y-6">
          {posts.map((post) => (
            <Link key={post.slug} href={`/blog/${post.slug}`}>
              <article className="group overflow-hidden rounded-xl border border-border bg-card transition-shadow hover:shadow-md sm:flex">
                {post.coverImage && (
                  <div className="relative aspect-[16/9] overflow-hidden bg-muted sm:aspect-auto sm:w-56 sm:flex-shrink-0">
                    <Image
                      src={post.coverImage}
                      alt={post.title}
                      fill
                      sizes="(max-width: 640px) 100vw, 224px"
                      className="object-cover transition-transform group-hover:scale-105"
                    />
                  </div>
                )}
                <div className="flex-1 p-6">
                  <div className="mb-3 flex flex-wrap items-center gap-3">
                    <span
                      className={`rounded-full px-3 py-0.5 text-xs font-medium ${
                        categoryColors[post.category] ?? "bg-gray-100 text-gray-600"
                      }`}
                    >
                      {post.category}
                    </span>
                    <span className="text-xs text-muted-foreground">
                      {new Date(post.publishedAt).toLocaleDateString("th-TH", {
                        year: "numeric",
                        month: "long",
                        day: "numeric",
                      })}
                    </span>
                    <span className="text-xs text-muted-foreground">อ่าน {post.readingTime} นาที</span>
                  </div>
                  <h2 className="text-xl font-semibold text-foreground group-hover:text-brand transition-colors">
                    {post.title}
                  </h2>
                  <p className="mt-2 text-muted-foreground line-clamp-2">{post.description}</p>
                  <div className="mt-4 text-sm font-medium text-brand">อ่านต่อ →</div>
                </div>
              </article>
            </Link>
          ))}
        </div>
      )}
    </>
  );
}
