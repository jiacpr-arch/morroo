import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Topic pool — Claude picks one that hasn't been written yet
const TOPIC_POOL = [
  { title: "Long Case Exam คืออะไร และวิธีเตรียมตัวให้พร้อม", category: "ความรู้ทั่วไป", keywords: "Long Case, OSCE, AI Patient, NL Step 3" },
  { title: "10 โรค Must-Know สำหรับสอบ NL Step 3 ที่ออกสอบทุกปี", category: "เตรียมสอบ", keywords: "NL Step 3, โรคที่ออกสอบ, MEQ, MCQ" },
  { title: "Differential Diagnosis คืออะไร และวิธีคิด DD ให้เป็นระบบ", category: "ความรู้ทั่วไป", keywords: "Differential Diagnosis, DD, clinical reasoning, MEQ" },
  { title: "เทคนิค Time Management ในห้องสอบแพทย์ — ไม่ตกเวลา ทุกข้อ", category: "เทคนิคสอบ", keywords: "time management, สอบแพทย์, MEQ, MCQ, NL" },
  { title: "MCQ NL แตกต่างจาก MEQ อย่างไร เลือกเตรียมแบบไหนดี?", category: "ความรู้ทั่วไป", keywords: "MCQ, MEQ, NL Step 3, ความแตกต่าง" },
  { title: "สาขาไหนออกสอบเยอะที่สุดใน NL Step 3 — วิเคราะห์จากข้อสอบจริง", category: "เตรียมสอบ", keywords: "อายุรศาสตร์, ศัลยศาสตร์, กุมาร, สูติ, NL Step 3" },
  { title: "วิธีอ่านผล ECG เบื้องต้นสำหรับสอบแพทย์ — Step-by-Step", category: "ความรู้ทั่วไป", keywords: "ECG, EKG, อ่านผล, สอบแพทย์, Cardiology" },
  { title: "Acute Abdomen — การวินิจฉัยแยกโรคที่ต้องรู้ก่อนสอบ", category: "ความรู้ทั่วไป", keywords: "Acute abdomen, DD, ศัลยศาสตร์, สอบแพทย์" },
  { title: "เทคนิคซักประวัติแบบ OLDCART สำหรับ Long Case และ MEQ", category: "เทคนิคสอบ", keywords: "OLDCART, ซักประวัติ, Long Case, MEQ, clinical" },
  { title: "Fluid Management พื้นฐาน — สิ่งที่ต้องตอบได้ในสอบ NL", category: "ความรู้ทั่วไป", keywords: "Fluid, IV fluid, hydration, NL Step 3, MEQ" },
];

function slugify(title: string): string {
  // Convert Thai title to ASCII slug using index-based approach
  const idx = TOPIC_POOL.findIndex((t) => t.title === title);
  const slugs = [
    "what-is-long-case-exam",
    "10-must-know-diseases-nl-step3",
    "differential-diagnosis-guide",
    "time-management-medical-exam",
    "mcq-vs-meq-nl-step3",
    "which-subjects-appear-most-nl",
    "ecg-reading-basics-for-doctors",
    "acute-abdomen-differential-diagnosis",
    "oldcart-history-taking-technique",
    "fluid-management-basics-nl",
  ];
  return slugs[idx] ?? `article-${Date.now()}`;
}

export async function POST(request: Request) {
  // Verify secret to prevent unauthorized calls
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = await createClient();

  // Find a topic that hasn't been published yet
  const { data: existingSlugs } = await supabase
    .from("blog_posts")
    .select("slug");

  const usedSlugs = new Set((existingSlugs ?? []).map((r: { slug: string }) => r.slug));
  const available = TOPIC_POOL.filter((t) => {
    const slug = slugify(t.title);
    return !usedSlugs.has(slug);
  });

  if (available.length === 0) {
    return NextResponse.json({ message: "All topics already published" });
  }

  // Pick first available topic
  const topic = available[0];
  const slug = slugify(topic.title);

  // Call Claude API to generate article
  const anthropicApiKey = process.env.ANTHROPIC_API_KEY;
  if (!anthropicApiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  const prompt = `คุณเป็นแพทย์ผู้เชี่ยวชาญและนักเขียนบทความการแพทย์สำหรับเว็บไซต์เตรียมสอบแพทย์ "หมอรู้" (morroo.com)

เขียนบทความ SEO ภาษาไทยในหัวข้อ: "${topic.title}"
Keywords สำคัญ: ${topic.keywords}

กฎ:
- เขียน HTML เท่านั้น (ไม่ต้องมี <html>, <head>, <body>)
- ใช้ <h2>, <h3>, <p>, <ul>, <ol>, <li>, <strong>, <em>, <table>, <thead>, <tbody>, <tr>, <th>, <td>
- ความยาว 600-900 คำ (ภาษาไทย)
- ใส่ internal link ไปที่ /exams หรือ /nl หรือ /longcase หรือ /pricing อย่างน้อย 1 จุด
- เนื้อหาต้องถูกต้องทางการแพทย์ เขียนแบบ evidence-based
- ใช้ภาษากึ่งทางการ เข้าใจง่าย เหมาะกับนักศึกษาแพทย์และแพทย์ทั่วไป
- ห้ามมี markdown (เครื่องหมาย ** หรือ ## หรือ \`)

ส่งกลับเฉพาะ HTML content เท่านั้น ไม่ต้องมี comment หรือ explanation`;

  const claudeRes = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": anthropicApiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 2048,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!claudeRes.ok) {
    const err = await claudeRes.text();
    return NextResponse.json({ error: "Claude API error", details: err }, { status: 500 });
  }

  const claudeData = await claudeRes.json();
  const content: string = claudeData.content?.[0]?.text ?? "";

  if (!content) {
    return NextResponse.json({ error: "Empty content from Claude" }, { status: 500 });
  }

  // Estimate reading time (Thai: ~200 words/min, strip HTML tags for word count)
  const textOnly = content.replace(/<[^>]+>/g, " ");
  const wordCount = textOnly.split(/\s+/).filter(Boolean).length;
  const readingTime = Math.max(3, Math.round(wordCount / 200));

  // Derive description from first <p> tag
  const firstPMatch = content.match(/<p[^>]*>([\s\S]*?)<\/p>/);
  const description = firstPMatch
    ? firstPMatch[1].replace(/<[^>]+>/g, "").slice(0, 160)
    : topic.title;

  // Save to Supabase
  const { data, error } = await supabase
    .from("blog_posts")
    .insert({
      slug,
      title: topic.title,
      description,
      category: topic.category,
      reading_time: readingTime,
      content,
      published_at: new Date().toISOString(),
    })
    .select("slug, title")
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ success: true, post: data });
}
