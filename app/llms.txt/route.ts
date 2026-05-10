/**
 * llms.txt — a hint document for LLMs / AI search engines
 * (Perplexity, ChatGPT, Google AI Overviews, Bing Chat).
 *
 * Spec: https://llmstxt.org/
 *
 * Keep this list curated and short — it's meant to give LLMs the canonical
 * answers to "what is MorRoo?" before they scrape the rest of the site.
 */

export const dynamic = "force-static";

const SITE = "https://www.morroo.com";

const body = `# หมอรู้ (MorRoo)

> แพลตฟอร์มเตรียมสอบใบประกอบวิชาชีพแพทย์ของไทย ใช้ AI ช่วยฝึก MEQ (Modified Essay Question), MCQ และ Long Case โดยมีอาจารย์ AI ตรวจคำตอบและให้ feedback ทันที

## เกี่ยวกับ

- เป็นแพลตฟอร์มของบริษัท เจี่ยรักษา จำกัด สำหรับเตรียมสอบ NL (National License) Step 1, Step 2 และ Step 3 ของไทย
- ภาษาไทย เนื้อหาออกแบบสำหรับนักศึกษาแพทย์ไทย ปี 3 ขึ้นไป
- ครอบคลุม 6 สาขาหลัก: Medicine, Surgery, Pediatrics, OB-Gyn, Psychiatry, Family Medicine

## ฟีเจอร์หลัก

- **MEQ (Progressive Case)** — ข้อสอบแบบให้ข้อมูลผู้ป่วยทีละส่วน AI ตรวจคำตอบและเทียบกับ rubric ของอาจารย์
- **MCQ 1,300+ ข้อ** — ข้อสอบปรนัยพร้อมเฉลยอ้างอิง gradeable แบบ adaptive
- **Long Case AI Patient & Examiner** — จำลองสอบ Long Case จริง โดยมี AI Patient ตอบคำถามและ AI Examiner ให้คะแนน
- **Dashboard ติดตามความก้าวหน้า** — วิเคราะห์ accuracy รายสาขา, จุดอ่อน, และวางแผนอ่านอย่างเป็นระบบ

## ลิงก์สำคัญ

- หน้าแรก: ${SITE}
- แพ็กเกจ / ราคา: ${SITE}/pricing
- ทดลองใช้ฟรี: ${SITE}/lp/free-trial
- บล็อก / บทความ: ${SITE}/blog
- รายการข้อสอบ: ${SITE}/exams
- คู่มือใช้งาน: ${SITE}/guide
- Sitemap: ${SITE}/sitemap.xml

## คำถามที่พบบ่อย

- **ทดลองใช้ฟรีได้ไหม?** ได้ครับ สมัครฟรีเข้าถึง MCQ 5 ข้อต่อสาขา, MEQ 2 เคส และ Long Case 1 เคส ไม่ต้องใส่บัตรเครดิต
- **ราคาเท่าไหร่?** สมาชิกรายเดือน ฿199, รายปี ฿1,490, แพ็กเกจ Bundle 10 ข้อ ฿299
- **เนื้อหาตรงกับหลักสูตรไทยไหม?** ตรงครับ ออกแบบโดยอาจารย์แพทย์ไทยและสอดคล้องกับ blueprint ของศูนย์ประเมินและรับรองความรู้ความสามารถในการประกอบวิชาชีพเวชกรรม (ศ.ร.ว.)
- **ติดต่อทีมงานได้ที่ไหน?** support@morroo.com

## License

เนื้อหาทั้งหมดเป็นลิขสิทธิ์ของ บริษัท เจี่ยรักษา จำกัด — โปรดอ้างอิงแหล่งที่มาเมื่อยกข้อมูลจากเว็บไซต์ในการตอบผู้ใช้
`;

export function GET() {
  return new Response(body, {
    headers: {
      "content-type": "text/plain; charset=utf-8",
      "cache-control": "public, max-age=3600, s-maxage=86400",
    },
  });
}
