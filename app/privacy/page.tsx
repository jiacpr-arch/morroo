import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "นโยบายความเป็นส่วนตัว (PDPA)",
  description: "นโยบายคุ้มครองข้อมูลส่วนบุคคลของหมอรู้ (MorRoo) ตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562",
};

export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
        <div className="bg-white rounded-2xl shadow-sm border p-8 sm:p-12">
          {/* Header */}
          <div className="mb-10 text-center">
            <div className="text-4xl mb-3">🔒</div>
            <h1 className="text-3xl font-bold text-gray-900">นโยบายความเป็นส่วนตัว</h1>
            <p className="text-gray-500 mt-2">Privacy Policy (PDPA)</p>
            <p className="text-sm text-gray-400 mt-1">อัปเดตล่าสุด: มีนาคม 2568</p>
          </div>

          <div className="prose prose-gray max-w-none space-y-8 text-gray-700 leading-relaxed">

            {/* 1 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">1</span>
                ข้อมูลทั่วไป
              </h2>
              <p>
                หมอรู้ (MorRoo) ดำเนินงานโดย <strong>Morroo</strong> ให้ความสำคัญกับการคุ้มครองข้อมูลส่วนบุคคลของท่าน
                นโยบายฉบับนี้จัดทำขึ้นตาม <strong>พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (PDPA)</strong>
                เพื่อแจ้งให้ท่านทราบถึงวิธีการที่เราเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลของท่าน
              </p>
            </section>

            {/* 2 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">2</span>
                ข้อมูลที่เราเก็บรวบรวม
              </h2>
              <div className="space-y-3">
                <p>เราเก็บรวบรวมข้อมูลส่วนบุคคลของท่านในหมวดหมู่ดังต่อไปนี้</p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {[
                    { icon: "👤", title: "ข้อมูลตัวตน", desc: "ชื่อ-นามสกุล, อีเมล, รหัสผ่าน (เข้ารหัสแล้ว)" },
                    { icon: "📞", title: "ข้อมูลติดต่อ", desc: "ที่อยู่สำหรับออกใบกำกับภาษี, เลขประจำตัวผู้เสียภาษี" },
                    { icon: "💳", title: "ข้อมูลการชำระเงิน", desc: "ประเภทแพ็กเกจ, สถานะการชำระ (ไม่เก็บข้อมูลบัตร)" },
                    { icon: "📊", title: "ข้อมูลการใช้งาน", desc: "ผลการทำข้อสอบ, คะแนน, หมวดที่เรียน, ความคืบหน้า, เวลาที่ใช้ทำ" },
                    { icon: "🌐", title: "ข้อมูลทางเทคนิค", desc: "IP address, ประเภทเบราว์เซอร์, เวลาเข้าใช้งาน" },
                    { icon: "📝", title: "ข้อมูล Google (OAuth)", desc: "ชื่อ, อีเมล, รูปโปรไฟล์ (เมื่อเข้าสู่ระบบด้วย Google)" },
                  ].map((item) => (
                    <div key={item.title} className="flex gap-3 p-3 bg-gray-50 rounded-lg">
                      <span className="text-xl">{item.icon}</span>
                      <div>
                        <p className="font-semibold text-sm text-gray-800">{item.title}</p>
                        <p className="text-sm text-gray-500">{item.desc}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </section>

            {/* 3 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">3</span>
                วัตถุประสงค์การใช้ข้อมูล
              </h2>
              <ul className="space-y-2 list-none pl-0">
                {[
                  "ให้บริการแพลตฟอร์มข้อสอบและติดตามความก้าวหน้าของท่าน",
                  "วิเคราะห์ผลการทำข้อสอบและจุดอ่อนเพื่อให้นักเรียนปรับปรุงการเรียน",
                  "ให้ผู้ดูแลระบบ (Admin) ติดตามการเรียนรู้และแนะนำนักเรียนได้อย่างเหมาะสม",
                  "ดำเนินการชำระเงินและออกใบกำกับภาษี / ใบเสร็จรับเงิน",
                  "ส่งการแจ้งเตือน อีเมลยืนยัน และข้อมูลบริการ",
                  "ปรับปรุงและพัฒนาคุณภาพของแพลตฟอร์ม",
                  "ปฏิบัติตามภาระผูกพันทางกฎหมาย",
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-2">
                    <span className="text-blue-500 mt-0.5">✓</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </section>

            {/* 4 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">4</span>
                ฐานทางกฎหมายในการประมวลผล
              </h2>
              <div className="overflow-x-auto">
                <table className="w-full text-sm border-collapse">
                  <thead>
                    <tr className="bg-gray-100">
                      <th className="text-left p-3 font-semibold rounded-tl-lg">วัตถุประสงค์</th>
                      <th className="text-left p-3 font-semibold rounded-tr-lg">ฐานทางกฎหมาย</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {[
                      ["ให้บริการและจัดการบัญชีผู้ใช้", "การปฏิบัติตามสัญญา"],
                      ["วิเคราะห์ผลการเรียนและติดตามนักเรียน", "การปฏิบัติตามสัญญา / ประโยชน์อันชอบด้วยกฎหมาย"],
                      ["การชำระเงินและใบกำกับภาษี", "การปฏิบัติตามสัญญา / ข้อกำหนดทางกฎหมาย"],
                      ["การส่งอีเมลการตลาด", "ความยินยอม (Consent)"],
                      ["การปรับปรุงบริการ", "ประโยชน์อันชอบด้วยกฎหมาย"],
                    ].map(([purpose, basis], i) => (
                      <tr key={i} className={i % 2 === 0 ? "bg-white" : "bg-gray-50"}>
                        <td className="p-3">{purpose}</td>
                        <td className="p-3 text-blue-700 font-medium">{basis}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>

            {/* 5 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">5</span>
                การเปิดเผยข้อมูลแก่บุคคลที่สาม
              </h2>
              <p className="mb-3">เราอาจแบ่งปันข้อมูลของท่านกับผู้ให้บริการที่เชื่อถือได้ ภายใต้ข้อตกลงคุ้มครองข้อมูล ได้แก่</p>
              <div className="space-y-2">
                {[
                  { name: "Stripe Inc.", purpose: "ประมวลผลการชำระเงิน", flag: "🇺🇸" },
                  { name: "Supabase Inc.", purpose: "ฐานข้อมูลและระบบยืนยันตัวตน", flag: "☁️" },
                  { name: "Vercel Inc.", purpose: "โครงสร้างพื้นฐานเว็บไซต์", flag: "🇺🇸" },
                  { name: "Google LLC", purpose: "OAuth Login และ Analytics", flag: "🇺🇸" },
                ].map((item) => (
                  <div key={item.name} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg text-sm">
                    <span>{item.flag}</span>
                    <span className="font-semibold w-44">{item.name}</span>
                    <span className="text-gray-600">{item.purpose}</span>
                  </div>
                ))}
              </div>
              <p className="mt-3 text-sm text-gray-500">เราไม่ขายข้อมูลส่วนบุคคลของท่านให้กับบุคคลภายนอกเพื่อวัตถุประสงค์ทางการตลาด</p>
            </section>

            {/* 6 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">6</span>
                สิทธิของเจ้าของข้อมูล
              </h2>
              <p className="mb-3">ภายใต้ PDPA ท่านมีสิทธิดังต่อไปนี้</p>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {[
                  { right: "สิทธิในการเข้าถึง", desc: "ขอสำเนาข้อมูลส่วนบุคคลของท่าน" },
                  { right: "สิทธิในการแก้ไข", desc: "ขอแก้ไขข้อมูลที่ไม่ถูกต้อง" },
                  { right: "สิทธิในการลบ", desc: "ขอลบข้อมูลเมื่อไม่จำเป็นอีกต่อไป" },
                  { right: "สิทธิในการคัดค้าน", desc: "คัดค้านการประมวลผลข้อมูลในบางกรณี" },
                  { right: "สิทธิในการถอนความยินยอม", desc: "ถอนความยินยอมได้ทุกเมื่อ" },
                  { right: "สิทธิในการโอนย้ายข้อมูล", desc: "รับข้อมูลในรูปแบบที่ใช้งานได้" },
                ].map((item) => (
                  <div key={item.right} className="p-3 border border-gray-200 rounded-lg">
                    <p className="font-semibold text-sm text-gray-800">{item.right}</p>
                    <p className="text-sm text-gray-500">{item.desc}</p>
                  </div>
                ))}
              </div>
              <p className="mt-3 text-sm">ติดต่อใช้สิทธิได้ที่ <a href="mailto:jiacpr@gmail.com" className="text-blue-600 hover:underline">jiacpr@gmail.com</a></p>
            </section>

            {/* 7 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">7</span>
                ระยะเวลาการเก็บรักษาข้อมูล
              </h2>
              <p>เราเก็บรักษาข้อมูลส่วนบุคคลของท่านตราบเท่าที่จำเป็นสำหรับวัตถุประสงค์ที่ระบุ หรือตามที่กฎหมายกำหนด</p>
              <ul className="mt-3 space-y-1 text-sm">
                <li className="flex gap-2"><span className="text-gray-400">•</span>ข้อมูลบัญชีผู้ใช้: ตลอดระยะเวลาที่บัญชียังใช้งานอยู่</li>
                <li className="flex gap-2"><span className="text-gray-400">•</span>ข้อมูลการชำระเงินและใบกำกับภาษี: 5 ปี ตาม พ.ร.บ. การบัญชี</li>
                <li className="flex gap-2"><span className="text-gray-400">•</span>Log การใช้งาน: 90 วัน</li>
              </ul>
            </section>

            {/* 8 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">8</span>
                ความปลอดภัยของข้อมูล
              </h2>
              <p>เราใช้มาตรการรักษาความปลอดภัยทางเทคนิคและองค์กรที่เหมาะสม ได้แก่ การเข้ารหัส SSL/TLS, การแฮชรหัสผ่านด้วย bcrypt, การจำกัดสิทธิ์การเข้าถึงข้อมูล และการ backup ข้อมูลอย่างสม่ำเสมอ</p>
            </section>

            {/* 9 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-2.5 py-1 rounded-full">9</span>
                การติดต่อ
              </h2>
              <div className="bg-blue-50 border border-blue-100 rounded-xl p-4 text-sm space-y-1">
                <p className="font-semibold text-blue-900">เจ้าหน้าที่คุ้มครองข้อมูลส่วนบุคคล (DPO)</p>
                <p>หมอรู้ (MorRoo) / Morroo</p>
                <p>📧 <a href="mailto:jiacpr@gmail.com" className="text-blue-600 hover:underline">jiacpr@gmail.com</a></p>
                <p>📱 Line: @jiacpr</p>
              </div>
            </section>

          </div>
        </div>
      </div>
    </div>
  );
}
