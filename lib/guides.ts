/**
 * SEO landing pages for high-intent keyword traffic.
 *
 * Each guide is a long-form, single-page article tuned for one search
 * intent. They sit under /learn/[slug] (see app/learn/[slug]/page.tsx)
 * — /guide is already taken by the user manual / FAQ. Exists mainly to
 * (a) rank organically for the keyword, (b) catch paid-search traffic
 * that doesn't convert on /nl/practice, and (c) funnel readers into the
 * free trial through `FreeTrialBanner`.
 *
 * Content is hard-coded TS rather than DB-driven so it ships, indexes,
 * and stays under version control — adding a guide is a one-PR change.
 */

export type GuideSection = {
  heading: string;
  body: string[];
  bullets?: string[];
};

export type Guide = {
  slug: string;
  title: string;
  metaTitle: string;
  metaDescription: string;
  intro: string;
  keywords: string[];
  publishedAt: string;
  readingMinutes: number;
  sections: GuideSection[];
  // Internal links shown at the bottom and inline; keeps the page from
  // dead-ending and feeds engagement signals back to Google.
  relatedLinks: { href: string; label: string }[];
};

export const GUIDES: Guide[] = [
  {
    slug: "sob-nl-step-3",
    title: "วิธีเตรียมสอบ NL Step 3 ฉบับใช้งานจริง",
    metaTitle:
      "วิธีเตรียมสอบ NL Step 3 — แนวข้อสอบ MEQ Progressive Case + ติว AI",
    metaDescription:
      "คู่มือเตรียมสอบใบประกอบวิชาชีพแพทย์ขั้นที่ 3 (NL Step 3) ครอบคลุมแนวข้อสอบ MEQ Progressive Case วิธีอ่าน เทคนิคทำเวลา และตัวอย่างเคสจริง พร้อมฝึกฟรีกับ AI",
    intro:
      "สอบ NL Step 3 เป็นด่านสุดท้ายของใบประกอบวิชาชีพแพทย์ แต่ผู้เข้าสอบจำนวนมากเตรียมตัวไม่ตรงจุดเพราะรูปแบบข้อสอบต่างจาก Step 1/2 อย่างชัดเจน คู่มือนี้สรุปวิธีอ่าน ตารางอ่าน เทคนิคทำข้อสอบ MEQ Progressive Case และคลังแหล่งฝึกที่ใช้ได้ฟรี",
    keywords: [
      "สอบ NL",
      "NL Step 3",
      "เตรียมสอบแพทย์",
      "MEQ Progressive Case",
      "ติว NL",
    ],
    publishedAt: "2026-05-28",
    readingMinutes: 8,
    sections: [
      {
        heading: "NL Step 3 ต่างจาก Step 1/2 ตรงไหน",
        body: [
          "Step 1/2 ใช้ MCQ ล้วน เน้นทฤษฎีและการวินิจฉัย ส่วน NL Step 3 ใช้ข้อสอบแบบ MEQ Progressive Case ที่เปิดข้อมูลผู้ป่วยทีละตอน (6 ตอน) เพื่อทดสอบกระบวนการคิดทางคลินิก ไม่ใช่แค่ความรู้",
          "ความท้าทายคือต้องวิเคราะห์ข้อมูลใหม่ทุกตอน ห้ามย้อนกลับไปแก้คำตอบเดิม และต้องบริหารเวลาให้พอกับ 6 ตอนต่อเคส",
        ],
      },
      {
        heading: "ตารางอ่าน 8 สัปดาห์ก่อนสอบ",
        body: [
          "ตารางนี้ออกแบบให้ใช้ได้แม้ทำ intern ควบคู่กัน เน้นการฝึกข้อสอบจริงแทนการอ่าน textbook อย่างเดียว",
        ],
        bullets: [
          "สัปดาห์ 1-2: ทบทวน Internal Medicine + Surgery — ฝึก MEQ 3 เคส/สัปดาห์",
          "สัปดาห์ 3-4: Pediatrics + OB-Gyn — ฝึก MEQ 3 เคส/สัปดาห์ + MCQ สาขาละ 50 ข้อ",
          "สัปดาห์ 5-6: Psychiatry, Orthopedics, จิตเวช, ฉุกเฉิน — เคสละ 1 รอบ",
          "สัปดาห์ 7: เน้น Long Case ฝึกซักประวัติ + presentation",
          "สัปดาห์ 8: Mock สอบเต็มรูปแบบ จับเวลา + รีวิวจุดอ่อน",
        ],
      },
      {
        heading: "เทคนิคทำ MEQ Progressive Case ให้ทันเวลา",
        body: [
          "MEQ แต่ละเคสมีเวลาจำกัด เคล็ดลับคือต้อง 'อ่านก่อนคิด คิดก่อนเขียน' และไม่ตื่นเต้นเวลาเจอข้อมูลใหม่",
        ],
        bullets: [
          "อ่านโจทย์ทั้งตอนก่อนตอบ — ห้ามตอบทีละบรรทัด",
          "เขียน differential 3-5 ข้อก่อนเลือก plan",
          "ตอบ rationale สั้นๆ ไม่ลอกตำรา — กรรมการให้คะแนนตามตรรกะ ไม่ใช่ความยาว",
          "ถ้าตันให้ข้ามไปข้ออื่นก่อน อย่าจมเวลากับข้อเดียว",
        ],
      },
      {
        heading: "แหล่งฝึกที่ใช้ได้จริง",
        body: [
          "หมอรู้ (MorRoo) มีข้อสอบ MEQ Progressive Case มากกว่า 200 เคสครอบคลุม 6 สาขาหลัก พร้อม AI Examiner ที่ให้คะแนน + feedback แบบสอบจริงทันที — ฟรี 2 เคสแรกไม่ต้องใช้บัตรเครดิต",
          "ใช้คู่กับ Long Case Simulator ที่ AI รับบทผู้ป่วยให้ซักประวัติ + นำเสนอ Examiner เหมือนสอบจริง — มี 1 เคสฟรีต่อบัญชี",
        ],
      },
    ],
    relatedLinks: [
      { href: "/exams", label: "เริ่มทำ MEQ Progressive Case ฟรี" },
      { href: "/longcase", label: "ฝึก Long Case กับ AI Patient" },
      { href: "/nl/practice", label: "ฝึก MCQ NL Step 3 ตามสาขา" },
    ],
  },
  {
    slug: "meq-progressive-case",
    title: "MEQ Progressive Case คืออะไร อ่านวิธีตอบให้ได้คะแนน",
    metaTitle:
      "MEQ Progressive Case คืออะไร — ตัวอย่าง + เทคนิคทำให้ได้คะแนนเต็ม",
    metaDescription:
      "อธิบายรูปแบบข้อสอบ MEQ Progressive Case ที่ใช้ในการสอบใบประกอบวิชาชีพแพทย์ พร้อมตัวอย่างคำถาม วิธีตอบให้ได้คะแนน และข้อสอบฟรีให้ลองทำ",
    intro:
      "MEQ (Modified Essay Question) แบบ Progressive Case คือข้อสอบอัตนัยประยุกต์ที่ใช้ในการสอบ NL Step 3 — ผู้สอบจะได้ข้อมูลผู้ป่วยทีละส่วน ทำให้ต้องตัดสินใจทางคลินิกตามข้อมูลที่มีอยู่ ณ จุดนั้นเหมือนเจอผู้ป่วยจริง",
    keywords: [
      "MEQ คืออะไร",
      "MEQ Progressive Case",
      "ข้อสอบ MEQ",
      "เฉลย MEQ",
    ],
    publishedAt: "2026-05-28",
    readingMinutes: 6,
    sections: [
      {
        heading: "MEQ Progressive Case โครงสร้าง 6 ตอน",
        body: [
          "เคส MEQ มาตรฐานในการสอบ NL Step 3 ประกอบด้วย 6 ตอน เปิดข้อมูลตามลำดับเวลาจริงของผู้ป่วย",
        ],
        bullets: [
          "ตอน 1: ประวัติ + อาการสำคัญ → ถาม differential diagnosis",
          "ตอน 2: ผลตรวจร่างกาย → ถาม investigation ที่จะส่ง",
          "ตอน 3: ผลแล็บเบื้องต้น → ถาม working diagnosis + management",
          "ตอน 4: ผลการรักษา/ภาวะแทรกซ้อน → ถามขั้นต่อไป",
          "ตอน 5: ติดตามผล → ถาม long-term plan",
          "ตอน 6: ประเด็นจริยธรรม/การให้คำปรึกษา",
        ],
      },
      {
        heading: "วิธีตอบที่กรรมการให้คะแนน",
        body: [
          "ปัจจัยที่ทำให้คะแนนต่างกันมากที่สุดคือ 'rationale' — ผู้สอบที่อธิบายเหตุผลทางคลินิกได้ดีจะได้คะแนนเต็มแม้คำตอบหลักไม่ตรงเป๊ะ",
        ],
        bullets: [
          "เขียน differential 3-5 ข้อพร้อมเหตุผลสั้นๆ ทำไมคิดถึงข้อนี้",
          "ระบุ investigation ที่ specific + อธิบายว่าตามหาอะไร",
          "Plan management ต้องระบุยา/dose/วิธีให้ — ไม่ใช่แค่ 'admit + supportive'",
          "ตอนตอบจริยธรรม ให้พูดถึงผู้ป่วย-ครอบครัว-ทีมรักษา ครบทั้ง 3 มุม",
        ],
      },
      {
        heading: "ตัวอย่างเคสที่ออกบ่อย",
        body: [
          "เคสที่เจอบ่อยในข้อสอบ NL Step 3 ในช่วง 3 ปีหลังคือกลุ่มที่ต้องใช้กระบวนการคิดเชิงระบบ",
        ],
        bullets: [
          "Chest pain ในผู้สูงอายุ — ต้องวินิจฉัยแยก ACS / aortic dissection / PE",
          "Acute abdomen ในหญิงตั้งครรภ์ — ectopic pregnancy / appendicitis",
          "DKA/HHS — เน้น management ตามขั้นและการแก้ electrolyte",
          "Status epilepticus — first-line / second-line drugs และ refractory",
        ],
      },
      {
        heading: "ลองทำ MEQ ฟรี — มี AI ตรวจให้",
        body: [
          "หมอรู้มี MEQ Progressive Case 200+ เคสครอบคลุมทุกสาขา ลองฟรี 2 เคสไม่ต้องใส่บัตรเครดิต AI จะตรวจคำตอบทันทีและให้ feedback แบบเดียวกับกรรมการสอบจริง",
        ],
      },
    ],
    relatedLinks: [
      { href: "/exams", label: "เริ่มทำ MEQ ฟรี 2 เคส" },
      { href: "/learn/sob-nl-step-3", label: "ตารางอ่านเตรียมสอบ NL Step 3" },
      { href: "/longcase", label: "ฝึก Long Case กับ AI Patient" },
    ],
  },
  {
    slug: "long-case-ai-practice",
    title: "ฝึกสอบ Long Case ด้วย AI Patient — ทำได้ทุกที่ทุกเวลา",
    metaTitle:
      "ฝึก Long Case กับ AI Patient + Examiner — ซักประวัติ-PE-Lab-นำเสนอ",
    metaDescription:
      "ฝึก Long Case Exam เหมือนสอบจริง AI Patient ตอบโต้แบบคนไข้ AI Examiner ให้คะแนนและ feedback ทันที ลองฟรี 1 เคสไม่ต้องใส่บัตรเครดิต",
    intro:
      "Long Case คือข้อสอบที่ทำให้คนตกที่สุดในการสอบใบประกอบวิชาชีพแพทย์ เพราะต้องซักประวัติ ตรวจร่างกาย สั่ง investigation แล้วนำเสนอ + ตอบคำถามกรรมการแบบสด การฝึกแบบเดี่ยวๆ ที่บ้านทำไม่ได้ — แต่ AI Patient + Examiner ของหมอรู้แก้ปัญหานี้ได้",
    keywords: [
      "Long Case แพทย์",
      "ฝึกสอบ Long Case",
      "AI Patient",
      "Long Case AI",
    ],
    publishedAt: "2026-05-28",
    readingMinutes: 5,
    sections: [
      {
        heading: "Long Case ยากตรงไหน",
        body: [
          "Long Case ทดสอบทักษะ end-to-end ของการรักษาผู้ป่วย 1 ราย ใช้เวลา 30-60 นาที ตั้งแต่เจอครั้งแรกถึงนำเสนอ",
          "ไม่มีคำตอบสำเร็จรูป กรรมการให้คะแนนตามวิธีคิด ความสมเหตุสมผลของ plan และความเป็นมืออาชีพ",
        ],
      },
      {
        heading: "วิธีฝึกที่ใช้ได้ผล",
        body: [
          "ทักษะ Long Case ฝึกได้ด้วยการทำซ้ำเท่านั้น ยิ่งฝึกหลากหลายเคส ยิ่งคล่อง การฝึกแบบเดี่ยวข้อจำกัดคือไม่มีคนรับบทผู้ป่วยให้",
        ],
        bullets: [
          "ฝึกซักประวัติแบบโครงสร้าง — chief complaint, HPI, PMH, FH, SH",
          "ฝึกตรวจร่างกายให้เป็น routine — ไม่ใช่จำว่าเคสนี้ต้องตรวจอะไร",
          "ฝึกนำเสนอกระชับ 2-3 นาที — มี framework SOAP/หลักอื่น",
          "ฝึกตอบคำถาม follow-up ไม่ตื่นเต้นกรรมการ",
        ],
      },
      {
        heading: "AI Patient + Examiner ของหมอรู้ทำอะไร",
        body: [
          "เคสจริงไม่จำเป็นต้องหาคน standardized patient มาช่วยฝึก AI ทำได้ดีพอ ให้ feedback ได้แม่นยำกว่ามนุษย์ในบางมิติ",
        ],
        bullets: [
          "AI Patient ตอบโต้แบบผู้ป่วยจริง รวมถึงพูดอ้อมหรือไม่รู้ศัพท์การแพทย์",
          "เลือก PE ที่จะตรวจได้ ระบบให้ผลตรวจตามที่เลือก",
          "สั่ง Lab/Imaging ได้ ระบบให้ผลพร้อมค่า normal range",
          "AI Examiner ตั้งคำถาม clinical reasoning ระดับสอบจริง",
          "ได้คะแนนแยกด้าน (history, PE, dx, mx, professionalism) + feedback ละเอียดทุกข้อ",
        ],
      },
      {
        heading: "เริ่มฟรี 1 เคส ไม่ต้องใช้บัตรเครดิต",
        body: [
          "ลองเคส Long Case 1 เคสฟรีก่อนตัดสินใจ — สมัครฟรี ใช้เวลา 30 วินาที เคสครอบคลุม Surgery, Cardiology, Obstetrics, Internal Medicine และอีก 10+ สาขา",
        ],
      },
    ],
    relatedLinks: [
      { href: "/longcase", label: "เริ่ม Long Case ฟรี 1 เคส" },
      { href: "/learn/sob-nl-step-3", label: "ตารางอ่านเตรียมสอบ NL Step 3" },
      { href: "/exams", label: "ข้อสอบ MEQ Progressive Case" },
    ],
  },
];

export function getGuide(slug: string): Guide | null {
  return GUIDES.find((g) => g.slug === slug) ?? null;
}

export function getAllGuideSlugs(): string[] {
  return GUIDES.map((g) => g.slug);
}
