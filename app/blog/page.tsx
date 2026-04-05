import Link from "next/link";
import { blogPosts } from "@/lib/blog";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "บทความเตรียมสอบแพทย์ — MEQ, MCQ, NL Step 3",
  description:
    "บทความและคู่มือเตรียมสอบแพทย์ ครอบคลุม MEQ, MCQ, NL Step 3 เทคนิคการสอบ และความรู้ทางการแพทย์จากผู้เชี่ยวชาญ",
  alternates: { canonical: "https://www.morroo.com/blog" },
  openGraph: {
    title: "บทความเตรียมสอบแพทย์ — หมอรู้",
    description:
      "บทความ MEQ, MCQ, NL Step 3 และเทคนิคการสอบจากผู้เชี่ยวชาญ",
    url: "https://www.morroo.com/blog",
  },
};

const categoryColors: Record<string, string> = {
  "ความรู้ทั่วไป": "bg-blue-100 text-blue-700",
  "เตรียมสอบ": "bg-green-100 text-green-700",
  "เทคนิคสอบ": "bg-orange-100 text-orange-700",
};

export default function BlogPage() {
  const sorted = [...blogPosts].sort(
    (a, b) =>
      new Date(b.publishedAt).getTime() - new Date(a.publishedAt).getTime()
  );

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      <div className="mb-10">
        <h1 className="text-3xl font-bold text-foreground">
          บทความเตรียมสอบแพทย์
        </h1>
        <p className="mt-2 text-muted-foreground">
          ความรู้ เทคนิค และแนวทางสำหรับสอบ NL Step 3
        </p>
      </div>

      <div className="space-y-6">
        {sorted.map((post) => (
          <Link key={post.slug} href={`/blog/${post.slug}`}>
            <article className="group rounded-xl border border-border bg-card p-6 transition-shadow hover:shadow-md">
              <div className="mb-3 flex items-center gap-3">
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
                <span className="text-xs text-muted-foreground">
                  อ่าน {post.readingTime} นาที
                </span>
              </div>
              <h2 className="text-xl font-semibold text-foreground group-hover:text-brand transition-colors">
                {post.title}
              </h2>
              <p className="mt-2 text-muted-foreground line-clamp-2">
                {post.description}
              </p>
              <div className="mt-4 text-sm font-medium text-brand">
                อ่านต่อ →
              </div>
            </article>
          </Link>
        ))}
      </div>

      <div className="mt-12 rounded-xl bg-brand/10 border border-brand/20 p-6 text-center">
        <h2 className="text-lg font-semibold">พร้อมฝึกสอบแล้วใช่ไหม?</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          ลองทำข้อสอบ MEQ + MCQ ฟรีได้เลย ไม่ต้องใส่บัตรเครดิต
        </p>
        <div className="mt-4 flex justify-center gap-3">
          <Link
            href="/exams"
            className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90 transition-colors"
          >
            ทำข้อสอบ MEQ
          </Link>
          <Link
            href="/nl"
            className="rounded-lg border border-brand px-5 py-2 text-sm font-medium text-brand hover:bg-brand/10 transition-colors"
          >
            ทำข้อสอบ MCQ
          </Link>
        </div>
      </div>
    </div>
  );
}
