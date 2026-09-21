import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { broadcastLineMessages, checkLineQuota } from "@/lib/line";
import { buildWeeklyNewsletterFlex } from "@/lib/line-flex-templates";

// Weekly tips pool — rotates by week number
const TIPS = [
  "💊 เขียนยาให้ครบ 4 องค์ประกอบ: ชื่อยา + ขนาด + ช่องทาง + ความถี่ เช่น Ceftriaxone 1g IV OD — ขาดอะไรก็เสียคะแนน",
  "🧠 ฝึกคิด DD จากอาการก่อนอ่านคำถาม เหมือนเจอผู้ป่วยจริง — ช่วยให้คิดเป็นระบบและไม่พลาด Dangerous Diagnosis",
  "🚨 เจอผู้ป่วยวิกฤตใน MEQ เรียง ABCDE เสมอ: Airway → Breathing → Circulation → Disability → Exposure",
  "✅ อย่าลืม Safety nets ท้ายคำตอบ เช่น 'นัด follow-up 1 สัปดาห์' หรือ 'กลับมาถ้าอาการแย่ลง' — ผู้ตรวจให้คะแนนส่วนนี้",
  "⏱️ บริหารเวลา MEQ: 2 นาทีอ่านโจทย์, 15 นาทีตอบ, 3 นาทีตรวจทาน — ถ้าติดตอนไหนข้ามก่อนเสมอ",
  "📝 คำตอบ MEQ ที่ดีต้องเขียนเป็น bullet points ชัดเจน ไม่ใช่ essay ยาว — ผู้ตรวจต้องเห็น Key Point ทันที",
  "🎯 MCQ: ตัดตัวเลือกที่ผิดชัดออก 2-3 ข้อก่อน แล้วเลือกจากที่เหลือ — ช่วยเมื่อไม่มั่นใจ 100%",
  "🏥 Long Case: ฝึก present ให้จบใน 3 นาที: CC+HPI (1 นาที) → PE+Lab (1 นาที) → Diagnosis+Plan (1 นาที)",
];

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (process.env.LINE_AUTOPOST_ENABLED !== "true") {
    return NextResponse.json({ success: false, message: "skipped:LINE_AUTOPOST_ENABLED!=true" });
  }

  const quota = await checkLineQuota();
  if (quota.throttled) {
    return NextResponse.json({ success: false, skipped: true, reason: "line_quota_low", remaining: quota.remaining });
  }

  const supabase = await createClient();

  // Get 3 latest blog posts
  const { data: posts } = await supabase
    .from("blog_posts")
    .select("title, slug, description")
    .order("published_at", { ascending: false })
    .limit(3);

  // Pick tip by week number
  const weekNum = Math.floor(Date.now() / (7 * 24 * 60 * 60 * 1000));
  const tip = TIPS[weekNum % TIPS.length];

  const siteUrl = "https://www.morroo.com";

  const flex = buildWeeklyNewsletterFlex({
    tip,
    articles: (posts ?? []).map((post: { title: string; slug: string }) => ({
      title: post.title,
      url: `${siteUrl}/blog/${post.slug}`,
    })),
    examsUrl: `${siteUrl}/exams`,
  });

  const result = await broadcastLineMessages([flex]);

  return NextResponse.json({
    success: result.ok,
    error: result.error,
    tip: tip.slice(0, 50),
    posts: posts?.length ?? 0,
  });
}
