import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sendWeeklyNewsletter } from "@/lib/email/send";

// Weekly tips pool — rotates by week number
const TIPS = [
  {
    title: "เขียนยาให้ครบ 4 องค์ประกอบ",
    content: "ทุกครั้งที่ตอบเรื่องยาใน MEQ ต้องมีครบ: ชื่อยา (generic name) + ขนาด (mg/kg) + ช่องทาง (PO/IV/IM) + ความถี่ (OD/BD/TDS) เช่น Ceftriaxone 1g IV OD — ขาดอะไรก็เสียคะแนน",
  },
  {
    title: "อ่าน Stem แล้วคิด DD ก่อนอ่านคำถาม",
    content: "ฝึกคิด Differential Diagnosis จากอาการก่อนที่จะดูคำถาม เหมือนกับที่คุณจะเจอผู้ป่วยจริง วิธีนี้ช่วยให้คิดเป็นระบบและไม่พลาด DD สำคัญ",
  },
  {
    title: "ใช้ ABCDE ในผู้ป่วยวิกฤต",
    content: "เมื่อเจอ MEQ ผู้ป่วยวิกฤต เรียง Airway → Breathing → Circulation → Disability → Exposure เสมอ ผู้ตรวจจะให้คะแนนตามลำดับนี้",
  },
  {
    title: "บอก Safety nets ท้ายคำตอบ",
    content: "อย่าลืมเพิ่ม safety nets เสมอ เช่น 'นัด follow-up 1 สัปดาห์' หรือ 'กลับมาถ้ามีไข้ขึ้น/อาการแย่ลง' — ผู้ตรวจชอบเห็นว่าคุณนึกถึงความปลอดภัยผู้ป่วย",
  },
  {
    title: "Time management: 20 นาที/เคส MEQ",
    content: "แบ่งเวลา: 2 นาทีอ่านโจทย์ทั้งเคส, 15 นาทีตอบทุกตอน, 3 นาทีตรวจทาน ถ้าติดตอนไหนข้ามก่อน — อย่าเสียเวลากับสิ่งที่ไม่รู้",
  },
  {
    title: "MCQ: ตัดตัวเลือกก่อนเลือก",
    content: "ก่อนเลือกคำตอบ MCQ ให้ตัดตัวเลือกที่ผิดชัดออกก่อน 2-3 ข้อ แล้วเลือกจากที่เหลือ วิธีนี้ช่วยเมื่อไม่มั่นใจ 100% และลดโอกาสเลือกผิดจาก distractor",
  },
  {
    title: "เขียนเป็นข้อ ไม่เขียนเป็นย่อหน้า",
    content: "คำตอบ MEQ ที่ดีต้องเขียนเป็น bullet points ชัดเจน ไม่ใช่ essay ยาว ผู้ตรวจใช้เวลาน้อยมากต่อกระดาษ — ถ้าเห็น Key Point ทันทีจะได้คะแนนเต็ม",
  },
  {
    title: "Long Case: เตรียม Presentation 3 นาที",
    content: "ฝึก present เคส Long Case ให้จบใน 3 นาที: CC + HPI (1 นาที) → PE หลัก + Lab key findings (1 นาที) → Diagnosis + Plan (1 นาที) — กระชับ ชัดเจน ครบถ้วน",
  },
];

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = await createClient();

  // Get all subscribed users (membership_type != free OR created recently)
  const { data: users } = await supabase
    .from("profiles")
    .select("name, email")
    .neq("email", null);

  if (!users || users.length === 0) {
    return NextResponse.json({ message: "No subscribers found" });
  }

  // Count new exams from last 7 days
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
  const { count: newExamCount } = await supabase
    .from("exams")
    .select("id", { count: "exact", head: true })
    .eq("status", "published")
    .gte("created_at", weekAgo);

  // Get 3 latest blog posts
  const { data: posts } = await supabase
    .from("blog_posts")
    .select("title, slug, category, reading_time, description")
    .order("published_at", { ascending: false })
    .limit(3);

  // Pick tip by week number
  const weekNum = Math.floor(Date.now() / (7 * 24 * 60 * 60 * 1000));
  const tip = TIPS[weekNum % TIPS.length];

  const latestPosts = (posts ?? []).map((p: {
    title: string;
    slug: string;
    category: string;
    reading_time: number;
    description: string;
  }) => ({
    title: p.title,
    slug: p.slug,
    category: p.category,
    readingTime: p.reading_time,
    description: p.description,
  }));

  const subscribers = users
    .filter((u: { name: string | null; email: string | null }) => u.email)
    .map((u: { name: string | null; email: string }) => ({
      name: u.name ?? "คุณ",
      email: u.email,
    }));

  const result = await sendWeeklyNewsletter({
    subscribers,
    newExamCount: newExamCount ?? 0,
    tipTitle: tip.title,
    tipContent: tip.content,
    latestPosts,
  });

  return NextResponse.json({ success: true, ...result, subscribers: subscribers.length });
}
