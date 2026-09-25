import LearningPageHero from "@/components/LearningPageHero";
import Link from "next/link";
import { Suspense } from "react";
import { getBlogPosts } from "@/lib/blog";
import BlogPostList, { type BlogPostSummary } from "@/components/BlogPostList";
import type { Metadata } from "next";

// ISR: หน้านี้ห้ามอ่าน searchParams/cookies ใน server component ไม่งั้นจะกลาย
// เป็น dynamic และ revalidate ไม่มีผล — ตัวกรองหมวดอยู่ใน BlogPostList (client)
export const revalidate = 60;

export const metadata: Metadata = {
  title: "บทความเตรียมสอบแพทย์ — MEQ, MCQ, NL Step 3",
  description:
    "บทความและคู่มือเตรียมสอบแพทย์ ครอบคลุม MEQ, MCQ, NL Step 3 เทคนิคการสอบ และความรู้ทางการแพทย์จากผู้เชี่ยวชาญ",
  alternates: { canonical: "https://www.morroo.com/blog" },
  openGraph: {
    title: "บทความเตรียมสอบแพทย์ — หมอรู้",
    description: "บทความ MEQ, MCQ, NL Step 3 และเทคนิคการสอบจากผู้เชี่ยวชาญ",
    url: "https://www.morroo.com/blog",
  },
};

export default async function BlogPage() {
  const allPosts = await getBlogPosts();
  // ส่งเฉพาะ summary — `content` ของทุกโพสต์รวมกันเกือบ 1MB ไม่ควรไปอยู่ใน RSC payload ของหน้า list
  const posts: BlogPostSummary[] = allPosts.map(
    ({ slug, title, description, publishedAt, category, readingTime, coverImage }) => ({
      slug, title, description, publishedAt, category, readingTime, coverImage,
    })
  );

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      <LearningPageHero
        eyebrow="แวะอ่าน เติมความรู้และแรงบันดาลใจ"
        title="บทความเตรียมสอบแพทย์"
        description="ความรู้ เทคนิค และแนวทางสำหรับสอบ NL Step 3 — เลือกอ่านเรื่องที่สนใจ แล้วเก็บไอเดียดี ๆ ไปใช้กับการเตรียมสอบของคุณ"
        scene="desk"
      />

      <Suspense fallback={null}>
        <BlogPostList posts={posts} />
      </Suspense>

      <div className="mt-12 rounded-xl bg-brand/10 border border-brand/20 p-6 text-center">
        <h2 className="text-lg font-semibold">พร้อมฝึกสอบแล้วใช่ไหม?</h2>
        <p className="mt-1 text-sm text-muted-foreground">
          ลองทำข้อสอบ MEQ + MCQ ฟรีได้เลย ไม่ต้องใส่บัตรเครดิต
        </p>
        <div className="mt-4 flex flex-wrap justify-center gap-3">
          <Link href="/exams" className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90 transition-colors">
            ทำข้อสอบ MEQ
          </Link>
          <Link href="/nl" className="rounded-lg border border-brand px-5 py-2 text-sm font-medium text-brand hover:bg-brand/10 transition-colors">
            ทำข้อสอบ MCQ
          </Link>
        </div>
      </div>
    </div>
  );
}
