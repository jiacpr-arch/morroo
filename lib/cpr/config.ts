// ค่าคงที่ของระบบคอร์ส CPR & AED (JIA TRAINER CENTER) — ย้ายมาจาก jia-online App.jsx
// คีย์/URL ทั้งหมดอ่านจาก env (เดิม hardcode ในบันเดิล)

// ==================== BRAND ====================
export const B = {
  red: "#C8102E",
  dkRed: "#9B0020",
  black: "#1A1A1A",
  white: "#FFFFFF",
  cream: "#FFF8F0",
  gray: "#F5F5F5",
  ltGray: "#E8E8E8",
  dkGray: "#666",
  green: "#22C55E",
  gold: "#F59E0B",
};
// ฟอนต์เซริฟไทยสำหรับใบประกาศ (หัวข้อ + ชื่อผู้เรียน) — โหลดผ่าน next/font ใน app/cpr/layout.tsx
export const SERIF = "var(--font-cpr-serif), 'Noto Sans Thai', Georgia, serif";

// ========== CONFIG ==========
export const FREE_LAUNCH = false; // cutover แล้ว (ก.ค. 2569) — บทที่ 1 ฟรี บทที่เหลือเก็บเงินตาม PRICING, Claim CTA เปิดใช้งาน
export const LAUNCH_END = "31 กรกฎาคม 2569";
export const LINE_URL = "https://line.me/R/ti/p/@jiacpr";
export const LINE_QR_URL = "https://qr-official.line.me/sid/L/jiacpr.png";
export const SITE_URL = "https://www.morroo.com/cpr";

export const SUPABASE_URL =
  process.env.NEXT_PUBLIC_CPR_SUPABASE_URL || "https://tpoiyykbgsgnrdwzgzvn.supabase.co";
export const SUPABASE_KEY = process.env.NEXT_PUBLIC_CPR_SUPABASE_ANON_KEY || "";

// ========== AUTH GATE (บังคับสมัครหลังจบบท 1) ==========
export const AUTH_GATE_ENABLED = true; // เปิดด่านบังคับสมัคร (false = กลับไป flow เดิม)
export const LIFF_ID = process.env.NEXT_PUBLIC_CPR_LIFF_ID || "2010458255-JAxIKawy";
export const GOOGLE_LOGIN_ENABLED = true;
export const EMAIL_OTP_ENABLED = true;
export const POSTHOG_KEY = process.env.NEXT_PUBLIC_CPR_POSTHOG_KEY || "";
export const POSTHOG_HOST =
  process.env.NEXT_PUBLIC_CPR_POSTHOG_HOST || "https://us.i.posthog.com";
export const GATE_VARIANT_DEFAULT = "soft"; // soft | before-course | after-lesson-1
export const FN_URL = (n: string) => `${SUPABASE_URL}/functions/v1/${n}`;
export const FN_HEADERS = {
  "Content-Type": "application/json",
  apikey: SUPABASE_KEY,
  Authorization: `Bearer ${SUPABASE_KEY}`,
};

// ========== PRICING ==========
export const PRICING = {
  single: 35, // ฿35 ต่อหัวข้อ
  bundle3: 100, // ฿100 ต่อ 3 หัวข้อ
  full: 149, // ฿149 Full Course + Final Exam
  freeModule: 1, // บทที่ 1 ฟรี (CPR ผู้ใหญ่)
};

// ========== PROMO CODE (Lead Capture) ==========
export const PROMO_ENABLED = true;
export const PROMO_FREE_MODULES = [1, 2, 3];
export const PROMO_EXPIRY_DAYS = 7;
export const PROMO_CODE_PREFIX = "LEAD-";
export const VOUCHER_CODE_PREFIX = "VCH-";
export const VOUCHER_ALL_MODULES = [1, 2, 3, 4, 5, 6, 7];
export const STANDING_NEVER_EXPIRES = "2099-12-31T23:59:59Z";
export const VOUCHER_SOURCES = [
  { value: "voucher_sale", label: "ขาย Voucher" },
  { value: "pre_course", label: "Pre-course (ก่อนเข้าคลาสจริง)" },
];
export const LEAD_SOURCES = [
  { value: "facebook", label: "Facebook (เพจ JIA หรือกลุ่ม)" },
  { value: "tiktok", label: "TikTok" },
  { value: "instagram", label: "Instagram" },
  { value: "line_oa", label: "LINE Official @jiacpr" },
  { value: "google", label: "Google ค้นหา" },
  { value: "friend", label: "เพื่อน/คนรู้จักแนะนำ" },
  { value: "workplace", label: "ที่ทำงาน/โรงเรียน" },
  { value: "youtube", label: "YouTube" },
  { value: "event", label: "งาน/อีเวนต์ออฟไลน์" },
  { value: "other", label: "อื่นๆ (โปรดระบุ)" },
];

export const LOGO_SRC = "/cpr/logo.png";

// ========== COURSE DATA ==========
export type QuizItem = { q: string; c: string[]; a: number };
export type TeaserItem = QuizItem & { img: string; emoji: string; hint: string };
export type CourseModule = {
  id: number;
  title: string;
  short: string;
  desc: string;
  vid: string | null;
  dur: number | null;
  quiz: QuizItem[];
};

// ควิซเกริ่นนำหน้าแรก (CPR ผู้ใหญ่ ง่ายๆ เน้นกำลังใจ ไม่มีเกณฑ์ผ่าน) — ตัวล่อก่อนเก็บ LINE
export const TEASER_QUIZ: TeaserItem[] = [
  { q: "เจอคนหมดสติล้มอยู่ สิ่งแรกที่ควรทำคืออะไร?", c: ["รีบวิ่งเข้าไปทันที", "ดูความปลอดภัยรอบตัวก่อนเข้าไป", "ถ่ายคลิปไว้ก่อน", "เดินเลี่ยงไป"], a: 1, img: "/cpr/teaser/q1.webp", emoji: "⚠️", hint: "ความปลอดภัยของผู้ช่วยมาก่อนเสมอ" },
  { q: "เบอร์โทรขอรถพยาบาล/แพทย์ฉุกเฉินในไทยคือเบอร์อะไร?", c: ["191", "1669", "1112", "1133"], a: 1, img: "/cpr/teaser/q2.webp", emoji: "📞", hint: "จำง่ายๆ 1669 — สายด่วนการแพทย์ฉุกเฉิน" },
  { q: "การกดหน้าอก CPR ควรกดตรงไหน?", c: ["กลางหน้าอก", "ที่ท้อง", "ที่คอ", "ที่ไหล่"], a: 0, img: "/cpr/teaser/q3.webp", emoji: "🫶", hint: "วางส้นมือกลางหน้าอก" },
  { q: "ควรกดหน้าอกเร็วประมาณเท่าไร?", c: ["ช้าๆ สบายๆ", "100–120 ครั้งต่อนาที", "เร็วที่สุดเท่าที่ทำได้", "ไม่สำคัญ"], a: 1, img: "/cpr/teaser/q4.webp", emoji: "🥁", hint: "จังหวะพอๆ กับเพลงเร็ว ~100–120/นาที" },
  { q: "เครื่อง AED (เครื่องกระตุกหัวใจ) คนทั่วไปใช้ได้ไหม?", c: ["ใช้ได้ เครื่องมีเสียงบอกทุกขั้นตอน", "ใช้ได้เฉพาะหมอ", "อันตราย ห้ามแตะ", "ต้องเรียน 1 ปีก่อน"], a: 0, img: "/cpr/teaser/q5.webp", emoji: "❤️‍🩹", hint: "AED ออกแบบให้คนทั่วไปใช้ได้ มีเสียงนำทุกขั้นตอน" },
];

export const COURSE: { title: string; price: number; modules: CourseModule[] } = {
  title: "CPR & AED ออนไลน์",
  price: FREE_LAUNCH ? 0 : PRICING.full,
  modules: [
    { id: 1, title: "บทที่ 1: CPR ผู้ใหญ่", short: "CPR ผู้ใหญ่", desc: "เทคนิคการช่วยชีวิตผู้ใหญ่ขั้นพื้นฐาน ตามมาตรฐาน 2025", vid: "IbvE4PnW_80", dur: 54, quiz: [
      { q: "ขั้นตอนแรกก่อนเข้าช่วยเหลือผู้หมดสติคืออะไร?", c: ["ทำ CPR ทันที", "โทร 1669", "ประเมินความปลอดภัยของที่เกิดเหตุ (Scene Safety)", "ใช้ AED"], a: 2 },
      { q: "การประเมินการตอบสนอง ทำอย่างไร?", c: ["เขย่าตัวแรงๆ", "ตบบ่าพร้อมตะโกน \"คุณ...คุณ...เป็นยังไงบ้าง\"", "ตรวจชีพจร", "ตบหน้า"], a: 1 },
      { q: "ความลึกในการกดหน้าอกผู้ใหญ่คือเท่าไร?", c: ["อย่างน้อย 3 ซม.", "อย่างน้อย 5 ซม. ถึง 6 ซม.", "อย่างน้อย 7 ซม.", "อย่างน้อย 10 ซม."], a: 1 },
      { q: "อัตราความเร็วในการกดหน้าอกที่ถูกต้องคือเท่าไร?", c: ["80-100 ครั้ง/นาที", "100-120 ครั้ง/นาที", "120-140 ครั้ง/นาที", "60-80 ครั้ง/นาที"], a: 1 },
      { q: "อัตราส่วนกดหน้าอก:ช่วยหายใจ ในผู้ใหญ่?", c: ["15:2", "30:2", "15:1", "30:1"], a: 1 },
    ]},
    { id: 2, title: "บทที่ 2: CPR ทารก", short: "CPR ทารก", desc: "เทคนิค CPR สำหรับทารก ความแตกต่างจากผู้ใหญ่", vid: "fu65-_ENCLo", dur: 50, quiz: [
      { q: "การกดหน้าอกทารก ใช้อะไรกด?", c: ["ฝ่ามือ 2 ข้าง", "สันมือ หรือ 2 นิ้วโป้ง", "กำปั้น", "ฝ่ามือ 1 ข้าง"], a: 1 },
      { q: "ความลึกในการกดหน้าอกทารกคือเท่าไร?", c: ["2 ซม.", "ประมาณ 4 ซม. หรือ 1.5 นิ้ว (1/3 ของความหนาหน้าอก)", "5 ซม.", "1 ซม."], a: 1 },
      { q: "อัตราส่วนกดหน้าอก:เป่าปาก สำหรับทารก (ผู้ช่วย 1 คน)?", c: ["15:2", "30:2", "30:1", "10:2"], a: 1 },
      { q: "ถ้ามีผู้ช่วยเหลือ 2 คน อัตราส่วนกด:เป่า เปลี่ยนเป็นเท่าไร?", c: ["30:2", "15:2", "30:1", "10:2"], a: 1 },
      { q: "ตำแหน่งกดหน้าอกทารกอยู่ที่ไหน?", c: ["กึ่งกลางหน้าอก ใต้แนวราวนม", "ด้านซ้ายหน้าอก", "บนท้อง", "ที่คอ"], a: 0 },
    ]},
    { id: 3, title: "บทที่ 3: สิ่งอุดกั้นทางเดินหายใจ ผู้ใหญ่", short: "Choking ผู้ใหญ่", desc: "วิธีช่วยเหลือผู้ใหญ่สำลัก แยกแยะอุดกั้นบางส่วนและสมบูรณ์", vid: "_nT-BcNoUzE", dur: 51, quiz: [
      { q: "การอุดกั้นบางส่วน สังเกตอย่างไร?", c: ["พูดไม่ออก หน้าเขียว", "ผู้ป่วยยังพูดได้ ไอเสียงดัง", "ใช้มือจับคอ", "หมดสติ"], a: 1 },
      { q: "การอุดกั้นสมบูรณ์ (อันตรายถึงชีวิต) สังเกตอย่างไร?", c: ["ไอเสียงดัง ยังพูดได้", "พูดไม่ออก ใช้มือจับคอ หน้าเขียว ไอไม่มีเสียง", "หน้าแดง แต่ยังพูดได้", "เจ็บคอเล็กน้อย"], a: 1 },
      { q: "ถ้าผู้ป่วยยังไอได้เสียงดัง ควรทำอย่างไร?", c: ["ตบหลังทันที", "กดท้อง Heimlich", "ให้ผู้ป่วยไอต่อไป ห้ามตบหลัง", "โทร 1669"], a: 2 },
      { q: "วิธี Heimlich Maneuver ตำแหน่งกดท้องอยู่ที่ไหน?", c: ["เหนือสะดือ ต่ำกว่ากระดูกหน้าอก", "กลางหน้าอก", "ที่สะดือพอดี", "ใต้สะดือ"], a: 0 },
      { q: "ถ้าผู้ป่วยสำลักจนหมดสติ ต้องทำอย่างไร?", c: ["ทำ Heimlich ต่อ", "วางลงบนพื้น เริ่มทำ CPR ทันที", "ให้ดื่มน้ำ", "นั่งรอรถพยาบาล"], a: 1 },
    ]},
    { id: 4, title: "บทที่ 4: สิ่งอุดกั้นทางเดินหายใจ ทารก", short: "Choking ทารก", desc: "วิธีช่วยเหลือทารกสำลัก ตบหลังสลับกดหน้าอก", vid: "pCgxwQUzph0", dur: 32, quiz: [
      { q: "ถ้าทารกยังร้องได้ ไอเสียงดัง ควรทำอย่างไร?", c: ["ตบหลังทันที", "ปล่อยให้ไอเอาสิ่งอุดกั้นออกเอง ห้ามตบหลัง", "กดท้อง", "จับขาสะบัด"], a: 1 },
      { q: "ท่าตบหลังทารก จับทารกอย่างไร?", c: ["อุ้มตั้งขึ้น", "คว่ำหน้าบนแขน ศีรษะต่ำกว่าลำตัว", "วางนอนหงายบนพื้น", "จับตั้งศีรษะขึ้น"], a: 1 },
      { q: "ตบหลังทารก ตบตรงไหน กี่ครั้ง?", c: ["กึ่งกลางกระดูกสะบักทั้ง 2 ข้าง จำนวน 5 ครั้ง", "ตบที่ศีรษะ 3 ครั้ง", "ตบที่ก้น 5 ครั้ง", "ตบที่ท้อง 5 ครั้ง"], a: 0 },
      { q: "หลังตบหลัง 5 ครั้ง ยังไม่ออก ทำอะไรต่อ?", c: ["ตบหลังต่อ", "พลิกหงาย กดหน้าอก 5 ครั้ง ใต้แนวราวนม", "ใช้นิ้วล้วงคอ", "เป่าปาก"], a: 1 },
      { q: "ข้อห้ามในการช่วยทารกสำลัก?", c: ["ห้ามตบหลัง", "ห้ามกดหน้าอก", "ห้ามจับขาสะบัด ห้ามกดท้องแบบผู้ใหญ่ ห้ามล้วงนิ้วเข้าปาก", "ห้ามเป่าปาก"], a: 2 },
    ]},
    { id: 5, title: "บทที่ 5: Megacode — CPR & AED ผู้ใหญ่", short: "CPR & AED ผู้ใหญ่", desc: "การใช้เครื่อง AED ร่วมกับ CPR และการช่วยจนรอด", vid: "dQ9TcHdhIr0", dur: 217, quiz: [
      { q: "ตำแหน่งแปะแผ่น AED ที่แนะนำคือ?", c: ["ทั้ง 2 แผ่นบนหน้าอก", "แผ่นแรกใต้ไหปลาร้าขวา แผ่นสองใต้ราวนมซ้ายแนวรักแร้", "แผ่นบนท้อง 2 แผ่น", "แผ่นบนหลัง 2 แผ่น"], a: 1 },
      { q: "ก่อนกดปุ่ม Shock ต้องดูอะไร?", c: ["ดูว่าเครื่องเปิดอยู่", "ดูว่าไม่มีใครสัมผัสตัวผู้ป่วย", "ดูว่าแผ่นติดแน่น", "ดูว่าผู้ป่วยหายใจ"], a: 1 },
      { q: "ก่อนกดปุ่ม Shock ต้องตะโกนว่าอะไร?", c: ["\"ถอยเลย!\"", "\"หลบออก!\"", "\"ฉันถอย คุณถอย ทุกคนถอย!\"", "\"ห้ามแตะ!\""], a: 2 },
      { q: "จะหยุดปั๊มหัวใจได้เมื่อไหร่?", c: ["เมื่อเหนื่อย", "ทีมฉุกเฉินมาถึง / ผู้ป่วยหายใจเอง / ผู้ป่วยรู้สึกตัว", "เมื่อครบ 5 นาที", "เมื่อ AED ช็อกแล้ว"], a: 1 },
      { q: "ถ้าผู้ป่วยหายใจเองแล้วแต่ยังไม่รู้สึกตัว ต้องทำอย่างไร?", c: ["ปิดเครื่อง AED แล้วรอ", "กด CPR ต่อ", "จัดท่านอนตะแคงกึ่งคว่ำ (Recovery Position) ดูการหายใจทุก 2 นาที", "ให้ดื่มน้ำ"], a: 2 },
    ]},
    { id: 6, title: "บทที่ 6: Megacode — CPR & AED ทารก/เด็ก", short: "CPR & AED ทารก/เด็ก", desc: "ขั้นตอนการช่วยเหลือและการใช้ AED สำหรับเด็กทารก", vid: "lCbImOmcrNA", dur: 119, quiz: [
      { q: "เวลากดหน้าอกทารก ควรกดลึกประมาณเท่าไหร่?", c: ["1 เซนติเมตร", "4 เซนติเมตร", "6 เซนติเมตร", "8 เซนติเมตร"], a: 1 },
      { q: "ถ้ามีผู้ช่วยเหลือ 2 คน ควรกดหน้าอกกี่ครั้ง แล้วเป่าปากกี่ครั้ง?", c: ["กด 30 ครั้ง เป่า 2 ครั้ง", "กด 15 ครั้ง เป่า 2 ครั้ง", "กด 5 ครั้ง เป่า 1 ครั้ง", "กด 10 ครั้ง เป่า 2 ครั้ง"], a: 1 },
      { q: "ตำแหน่งในการติดแผ่น AED สำหรับทารก ที่ดีที่สุดคือข้อใด?", c: ["ติดที่หน้าอกด้านซ้ายและขวา", "ติดที่หน้าอกด้านหน้าและแผ่นหลัง", "ติดที่หน้าผากและท้อง", "ติดที่ท้องและหลัง"], a: 1 },
      { q: "ก่อนกดปุ่มช็อก (Shock) ด้วยเครื่อง AED ต้องทำอะไรก่อน?", c: ["ตรวจดูชีพจร", "เป่าลมเพิ่ม 1 ครั้ง", "บอกให้ทุกคนถอยห่างจากตัวเด็ก", "ถอดแผ่น AED ออกก่อน"], a: 2 },
      { q: "ถ้าไม่มีแผ่น AED สำหรับเด็ก ควรทำอย่างไร?", c: ["ไม่ต้องช็อก", "ใช้แผ่นผู้ใหญ่ แต่ต้องแน่ใจว่าแผ่นไม่แตะกัน", "รอให้มีคนเอาอุปกรณ์สำหรับเด็กมา", "กด CPR อย่างเดียว ไม่ต้องใช้ AED"], a: 1 },
    ]},
    { id: 7, title: "แบบทดสอบสุดท้าย", short: "Final Exam", desc: "ทดสอบความรู้ทั้งหมด 6 บท ต้องได้ 80% ขึ้นไปจึงผ่าน", vid: null, dur: null, quiz: [
      { q: "ขั้นตอนแรกเมื่อพบผู้หมดสติคืออะไร?", c: ["ทำ CPR ทันที", "โทร 1669", "ประเมินความปลอดภัยที่เกิดเหตุ (Scene Safety)", "ใช้ AED"], a: 2 },
      { q: "ประเมินการหายใจใช้เวลาเท่าไร?", c: ["5 วินาที", "ไม่เกิน 10 วินาที", "30 วินาที", "1 นาที"], a: 1 },
      { q: "อัตราส่วนกด:เป่า ผู้ใหญ่?", c: ["15:2", "30:2", "15:1", "5:1"], a: 1 },
      { q: "ความลึกกดหน้าอกผู้ใหญ่?", c: ["3 ซม.", "อย่างน้อย 5 ซม. ถึง 6 ซม.", "7 ซม.", "10 ซม."], a: 1 },
      { q: "ความเร็วกดหน้าอก?", c: ["60-80 ครั้ง/นาที", "80-100 ครั้ง/นาที", "100-120 ครั้ง/นาที", "120-150 ครั้ง/นาที"], a: 2 },
      { q: "กดหน้าอกทารก ใช้อะไร?", c: ["ฝ่ามือ 2 ข้าง", "สันมือ หรือ 2 นิ้วโป้ง", "กำปั้น", "ฝ่ามือ 1 ข้าง"], a: 1 },
      { q: "ผู้ใหญ่สำลักขั้นรุนแรง ทำอย่างไร?", c: ["ให้ดื่มน้ำ", "ตบหลัง 5 ครั้ง สลับกดท้อง 5 ครั้ง", "กดท้อง Heimlich ทันที", "เป่าปาก"], a: 1 },
      { q: "ห้ามทำอะไรกับทารกที่สำลัก?", c: ["ห้ามตบหลัง", "ห้ามกดท้อง ห้ามจับขาสะบัด", "ห้ามกดหน้าอก", "ห้ามเป่าปาก"], a: 1 },
      { q: "ก่อนกด Shock ต้องตะโกนว่าอะไร?", c: ["\"ถอยเลย!\"", "\"ฉันถอย คุณถอย ทุกคนถอย!\"", "\"หลบออก!\"", "\"ห้ามแตะ!\""], a: 1 },
      { q: "จะหยุดปั๊มหัวใจเมื่อไหร่?", c: ["เมื่อเหนื่อย", "เมื่อครบ 5 นาที", "ทีมฉุกเฉินมาถึง / ผู้ป่วยหายใจเอง / ผู้ป่วยรู้สึกตัว", "เมื่อ AED ช็อกแล้ว"], a: 2 },
    ]},
  ],
};

export const ENCOURAGE = ["", "เยี่ยมมาก! รู้เรื่อง CPR ผู้ใหญ่แล้ว ไปบทต่อไปเลย", "ดีมาก! รู้ทั้ง CPR และ AED แล้ว", "เก่งมาก! CPR เด็กก็ไม่ยากเลย", "สุดยอด! เรียนมาครึ่งทางแล้ว", "ใกล้จบแล้ว! อีกบทเดียว", "ผ่านครบทุกบทแล้ว! พร้อมสอบข้อสอบสุดท้ายได้เลย"];

// ==================== MORROO NETWORK ADS ====================
export const MORROO_ADS = [
  { id: "advice", brand: "Morroo Advice", emoji: "🩺", tag: "AI ปรึกษาสุขภาพ", headline: "ไม่สบายใจ? ถาม AI หมอก่อน", desc: "ปรึกษาอาการกับ AI ภาษาไทย ตอบใน 5 วินาที — ฟรี 3 ครั้ง/วัน", cta: "เริ่มปรึกษาฟรี", url: "https://advice.morroo.com", bg: "#3B82F6", bgLight: "#3B82F612" },
  { id: "lab", brand: "Lab.morroo", emoji: "🔬", tag: "AI อ่านผล Lab", headline: "อ่านผล Lab ไม่เข้าใจ?", desc: "ถ่ายรูปใบผลตรวจ → AI อ่านให้ใน 30 วิ พร้อม flag ค่าผิดปกติเป็นภาษาไทย", cta: "ลองอ่านผลฟรี", url: "https://lab.morroo.com", bg: "#0EA5E9", bgLight: "#0EA5E912" },
  { id: "roodee", brand: "RooDee (รู้ดี)", emoji: "📚", tag: "ติวสอบด้วย AI", headline: "เตรียมลูกสอบ ป.1 / TCAS?", desc: "ข้อสอบ 5,000+ ข้อ · AI วิเคราะห์จุดอ่อน · Mock Exam จำลองสนามจริง", cta: "เริ่มเรียนฟรี", url: "https://pocket.morroo.com", bg: "#8B5CF6", bgLight: "#8B5CF612" },
  { id: "roodeeme", brand: "คู่มือข้างตัว", emoji: "⚕️", tag: "AI ผู้ช่วยแพทย์", headline: "หมอ/นศพ. พกคู่มือไว้ในมือถือ", desc: "ICD-10 ไทย · ตรวจยาตีกัน · คำนวณ Drug Dose · ฝึก Long Case กับ AI-คนไข้", cta: "ใช้ฟรี 20 ครั้ง/เดือน", url: "https://roodee.me", bg: "#DC2626", bgLight: "#DC262612" },
];

// กราฟิกตกแต่งใบประกาศ (กรอบทอง + คลื่นน้ำเงิน + ซีล + ริบบิ้น) — ไม่มีข้อความ วางเป็นเลเยอร์พื้นหลัง
export const CERT_DECO = `<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 900 636" preserveAspectRatio="none">
<defs>
<linearGradient id="cg" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#F1D481"/><stop offset="0.5" stop-color="#C49A48"/><stop offset="1" stop-color="#8C6B22"/></linearGradient>
<linearGradient id="ch" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#B8862F"/><stop offset="0.5" stop-color="#F3DB8E"/><stop offset="1" stop-color="#B8862F"/></linearGradient>
<radialGradient id="cs" cx="0.35" cy="0.3" r="0.85"><stop offset="0" stop-color="#F6E3A0"/><stop offset="0.55" stop-color="#C9A24B"/><stop offset="1" stop-color="#8C6B22"/></radialGradient>
</defs>
<rect width="900" height="636" fill="#FFFDF7"/>
<g transform="scale(0.85)">
<path d="M0,0 L232,0 C168,44 92,40 76,112 C60,176 40,170 0,212 Z" fill="#1B315A"/>
<path d="M0,0 L198,0 C146,36 88,33 74,108 C58,172 36,156 0,186 Z" fill="#0E1E3C"/>
<path d="M198,0 C146,36 88,33 74,108 C58,172 36,156 0,186" fill="none" stroke="url(#ch)" stroke-width="5.5"/>
<path d="M232,0 C168,44 92,40 76,112 C60,176 40,170 0,212" fill="none" stroke="url(#ch)" stroke-width="2.2" opacity="0.8"/>
</g>
<g transform="translate(900,636) rotate(180) scale(0.85)">
<path d="M0,0 L232,0 C168,44 92,40 76,112 C60,176 40,170 0,212 Z" fill="#1B315A"/>
<path d="M0,0 L198,0 C146,36 88,33 74,108 C58,172 36,156 0,186 Z" fill="#0E1E3C"/>
<path d="M198,0 C146,36 88,33 74,108 C58,172 36,156 0,186" fill="none" stroke="url(#ch)" stroke-width="5.5"/>
<path d="M232,0 C168,44 92,40 76,112 C60,176 40,170 0,212" fill="none" stroke="url(#ch)" stroke-width="2.2" opacity="0.8"/>
</g>
<rect x="22" y="22" width="856" height="592" fill="none" stroke="url(#cg)" stroke-width="2.5"/>
<rect x="30" y="30" width="840" height="576" fill="none" stroke="url(#cg)" stroke-width="1" opacity="0.6"/>
<g stroke="url(#cg)" stroke-width="2" fill="none">
<path d="M838,30 h34 v34"/><path d="M845,38 h22 v22" stroke-width="1"/>
<path d="M62,606 h-34 v-34"/><path d="M55,598 h-22 v-22" stroke-width="1"/>
</g>
<g fill="url(#cg)" stroke="url(#cg)">
<line x1="305" y1="376" x2="438" y2="376" stroke-width="1.4"/><line x1="462" y1="376" x2="595" y2="376" stroke-width="1.4"/>
<rect x="445" y="371" width="10" height="10" transform="rotate(45 450 376)"/>
<circle cx="305" cy="376" r="2.2" stroke="none"/><circle cx="595" cy="376" r="2.2" stroke="none"/>
</g>
<g transform="translate(160,500)">
<circle r="34" fill="url(#cs)" stroke="#8C6B22" stroke-width="1.5"/><circle r="26.5" fill="none" stroke="#FFF4D6" stroke-width="1.1" opacity="0.7"/>
<rect x="-13" y="-11" width="26" height="22" rx="3" fill="#0E1E3C"/><rect x="-13" y="-11" width="26" height="7" rx="3" fill="#1B315A"/>
<line x1="-7" y1="-15" x2="-7" y2="-8" stroke="#FFF4D6" stroke-width="2.4" stroke-linecap="round"/><line x1="7" y1="-15" x2="7" y2="-8" stroke="#FFF4D6" stroke-width="2.4" stroke-linecap="round"/>
<g fill="#FFF4D6"><circle cx="-6" cy="0" r="1.5"/><circle cx="0" cy="0" r="1.5"/><circle cx="6" cy="0" r="1.5"/><circle cx="-6" cy="6" r="1.5"/><circle cx="0" cy="6" r="1.5"/></g>
</g>
<g transform="translate(740,500)">
<circle r="34" fill="url(#cs)" stroke="#8C6B22" stroke-width="1.5"/><circle r="26.5" fill="none" stroke="#FFF4D6" stroke-width="1.1" opacity="0.7"/>
<path transform="translate(-12,-11)" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" fill="#C8102E"/>
<polyline points="-10,0 -4,0 -1,-5 2,4 5,-1 8,0 11,0" fill="none" stroke="#FFF" stroke-width="1.6" stroke-linejoin="round" stroke-linecap="round"/>
</g>
<g transform="translate(450,500)">
<path d="M-150,-4 l-26,0 l8,15 l-8,15 l26,0 Z" fill="#8C6B22"/><path d="M150,-4 l26,0 l-8,15 l8,15 l-26,0 Z" fill="#8C6B22"/>
<rect x="-150" y="-29" width="300" height="58" rx="6" fill="#0E1E3C" stroke="url(#ch)" stroke-width="2.5"/>
<rect x="-144" y="-23" width="288" height="46" rx="4" fill="none" stroke="url(#ch)" stroke-width="0.8" opacity="0.55"/>
</g>
</svg>`;
