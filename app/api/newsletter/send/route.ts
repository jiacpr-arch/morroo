import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

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

async function sendLinebroadcast(message: string): Promise<{ success: boolean; error?: string }> {
  const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
  if (!token) return { success: false, error: "LINE_CHANNEL_ACCESS_TOKEN not set" };

  const res = await fetch("https://api.line.me/v2/bot/message/broadcast", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({
      messages: [
        {
          type: "text",
          text: message,
        },
      ],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    return { success: false, error: err };
  }
  return { success: true };
}

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
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

  // Build LINE message
  let message = "📚 หมอรู้ Weekly — เตรียมสอบประจำสัปดาห์\n\n";

  message += `💡 เทคนิคประจำสัปดาห์\n${tip}\n\n`;

  if (posts && posts.length > 0) {
    message += "📖 บทความใหม่\n";
    for (const post of posts) {
      message += `• ${post.title}\n  ${siteUrl}/blog/${post.slug}\n`;
    }
    message += "\n";
  }

  message += `🎯 ฝึกสอบ MEQ + MCQ ได้เลย\n${siteUrl}/exams\n\n`;
  message += "─────────────────\nหมอรู้ — เตรียมสอบแพทย์ด้วย AI";

  const result = await sendLinebroadcast(message);

  return NextResponse.json({
    success: result.success,
    error: result.error,
    tip: tip.slice(0, 50),
    posts: posts?.length ?? 0,
  });
}
