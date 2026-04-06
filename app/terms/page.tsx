import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "นโยบายการซื้อสินค้าและบริการ",
  description: "ข้อกำหนดและเงื่อนไขการซื้อแพ็กเกจ การคืนเงิน และการใช้บริการ หมอรู้ (MorRoo)",
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
        <div className="bg-white rounded-2xl shadow-sm border p-8 sm:p-12">
          {/* Header */}
          <div className="mb-10 text-center">
            <div className="text-4xl mb-3">📋</div>
            <h1 className="text-3xl font-bold text-gray-900">นโยบายการซื้อสินค้าและบริการ</h1>
            <p className="text-gray-500 mt-2">Terms of Purchase & Service Policy</p>
            <p className="text-sm text-gray-400 mt-1">อัปเดตล่าสุด: มีนาคม 2568</p>
          </div>

          <div className="prose prose-gray max-w-none space-y-8 text-gray-700 leading-relaxed">

            {/* 1 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">1</span>
                ข้อมูลผู้ให้บริการ
              </h2>
              <div className="bg-gray-50 rounded-xl p-4 text-sm space-y-1">
                <p><span className="font-semibold">ชื่อบริการ:</span> หมอรู้ (MorRoo)</p>
                <p><span className="font-semibold">ดำเนินงานโดย:</span> Morroo</p>
                <p><span className="font-semibold">เว็บไซต์:</span> morroo.com</p>
                <p><span className="font-semibold">อีเมล:</span> jiacpr@gmail.com</p>
                <p><span className="font-semibold">Line:</span> @jiacpr</p>
              </div>
            </section>

            {/* 2 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">2</span>
                รายละเอียดสินค้าและบริการ
              </h2>
              <p className="mb-3">หมอรู้ ให้บริการ <strong>แพลตฟอร์มข้อสอบ MEQ ออนไลน์</strong> สำหรับเตรียมสอบใบประกอบวิชาชีพเวชกรรม โดยมีแพ็กเกจดังนี้</p>
              <div className="space-y-3">
                {[
                  {
                    name: "แพ็กเกจรายเดือน",
                    price: "฿199 / เดือน",
                    features: ["ข้อสอบ MEQ ครบทุกหมวด", "พร้อมเฉลยและคำอธิบายทุกข้อ", "ติดตามความก้าวหน้า"],
                  },
                  {
                    name: "แพ็กเกจรายปี",
                    price: "฿1,490 / ปี",
                    features: ["ทุกอย่างในแพ็กเกจรายเดือน", "ประหยัดกว่า 38%", "ชุดข้อสอบพิเศษเพิ่มเติม"],
                  },
                  {
                    name: "แพ็กเกจ Bundle",
                    price: "฿299 / เดือน",
                    features: ["ข้อสอบ MEQ + MCQ", "Long Case ฝึกซ้อม", "เข้าถึงทุกเนื้อหา"],
                  },
                ].map((pkg) => (
                  <div key={pkg.name} className="border border-gray-200 rounded-xl p-4">
                    <div className="flex justify-between items-start mb-2">
                      <p className="font-semibold text-gray-900">{pkg.name}</p>
                      <p className="text-emerald-700 font-bold">{pkg.price}</p>
                    </div>
                    <ul className="space-y-1 text-sm text-gray-600">
                      {pkg.features.map((f) => (
                        <li key={f} className="flex gap-2">
                          <span className="text-emerald-500">✓</span>
                          <span>{f}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                ))}
              </div>
              <p className="mt-3 text-sm text-gray-500">ราคาทั้งหมดเป็นสกุลเงินบาท (THB) รวมภาษีมูลค่าเพิ่ม (VAT) แล้ว</p>
            </section>

            {/* 3 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">3</span>
                ช่องทางการชำระเงิน
              </h2>
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                {[
                  { icon: "💳", method: "บัตรเครดิต / เดบิต", detail: "Visa, Mastercard, JCB ผ่าน Stripe" },
                  { icon: "📱", method: "PromptPay QR Code", detail: "สแกนจ่ายผ่าน Banking App" },
                  { icon: "🏦", method: "โอนเงินผ่านธนาคาร", detail: "แนบสลิปยืนยันการโอน" },
                ].map((item) => (
                  <div key={item.method} className="p-4 bg-gray-50 rounded-xl text-center">
                    <div className="text-2xl mb-2">{item.icon}</div>
                    <p className="font-semibold text-sm text-gray-800">{item.method}</p>
                    <p className="text-xs text-gray-500 mt-1">{item.detail}</p>
                  </div>
                ))}
              </div>
            </section>

            {/* 4 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">4</span>
                การเปิดใช้งานและส่งมอบบริการ
              </h2>
              <ul className="space-y-2">
                {[
                  "บัตรเครดิต / PromptPay: บัญชีเปิดใช้งานทันทีหลังการชำระเงินสำเร็จ",
                  "โอนเงินผ่านธนาคาร: เปิดใช้งานภายใน 1-2 ชั่วโมงในวันทำการ หลังตรวจสอบสลิป",
                  "อีเมลยืนยันจะถูกส่งไปยังที่อยู่อีเมลที่ลงทะเบียนไว้",
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-2 text-sm">
                    <span className="text-emerald-500 mt-0.5 shrink-0">✓</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </section>

            {/* 5 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">5</span>
                นโยบายการคืนเงิน
              </h2>
              <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-4">
                <p className="font-semibold text-amber-800 mb-1">⚠️ เนื่องจากเป็นบริการดิจิทัลที่ส่งมอบทันที</p>
                <p className="text-amber-700 text-sm">โดยทั่วไปเราไม่รับคืนเงินหลังจากที่ได้รับสิทธิ์การเข้าถึงบริการแล้ว</p>
              </div>
              <p className="mb-3 font-semibold text-gray-800">ข้อยกเว้นที่เราพิจารณาคืนเงินเต็มจำนวน</p>
              <ul className="space-y-2 text-sm">
                {[
                  "ระบบมีปัญหาทางเทคนิคร้ายแรงที่ทำให้ไม่สามารถใช้บริการได้ และเราไม่สามารถแก้ไขได้ภายใน 7 วัน",
                  "มีการชำระเงินซ้ำซ้อน (Duplicate payment) โดยไม่ตั้งใจ",
                  "ยื่นคำขอคืนเงินภายใน 24 ชั่วโมงหลังชำระเงิน และยังไม่ได้เข้าใช้บริการ",
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-2">
                    <span className="text-emerald-500 mt-0.5 shrink-0">✓</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
              <p className="mt-3 text-sm text-gray-500">ส่งคำขอคืนเงินได้ที่ <a href="mailto:jiacpr@gmail.com" className="text-blue-600 hover:underline">jiacpr@gmail.com</a> พร้อมแนบหลักฐานการชำระเงิน</p>
            </section>

            {/* 6 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">6</span>
                ใบกำกับภาษี / ใบเสร็จรับเงิน
              </h2>
              <ul className="space-y-2 text-sm">
                {[
                  "ท่านสามารถขอรับใบกำกับภาษีได้โดยกรอกข้อมูลในหน้าชำระเงิน ก่อนดำเนินการชำระเงิน",
                  "ระบุประเภท: บุคคลธรรมดา (ชื่อ + เลขบัตรประชาชน) หรือ นิติบุคคล (ชื่อบริษัท + เลขประจำตัวผู้เสียภาษี + ที่อยู่)",
                  "ใบกำกับภาษีจะถูกส่งไปยังอีเมลที่ลงทะเบียนภายใน 7 วันทำการ",
                  "หากต้องการแก้ไขข้อมูลใบกำกับภาษี โปรดติดต่อเราภายใน 30 วันหลังชำระเงิน",
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-2">
                    <span className="text-emerald-500 mt-0.5 shrink-0">✓</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </section>

            {/* 7 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">7</span>
                การต่ออายุและยกเลิกบริการ
              </h2>
              <ul className="space-y-2 text-sm">
                {[
                  "แพ็กเกจรายเดือนและ Bundle จะต่ออายุอัตโนมัติ (Auto-renewal) ท่านสามารถยกเลิกได้ทุกเมื่อ",
                  "หลังยกเลิก สมาชิกจะยังคงใช้งานได้จนกว่าจะหมดรอบบิล",
                  "แพ็กเกจรายปีจะไม่ต่ออายุอัตโนมัติ ท่านต้องชำระเงินใหม่เมื่อหมดอายุ",
                ].map((item, i) => (
                  <li key={i} className="flex items-start gap-2">
                    <span className="text-emerald-500 mt-0.5 shrink-0">✓</span>
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </section>

            {/* 8 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">8</span>
                ข้อห้ามการใช้งาน
              </h2>
              <div className="bg-red-50 border border-red-100 rounded-xl p-4">
                <ul className="space-y-2 text-sm text-red-800">
                  {[
                    "ห้ามแชร์บัญชีผู้ใช้กับบุคคลอื่น (1 บัญชี / 1 ผู้ใช้)",
                    "ห้ามทำซ้ำ คัดลอก หรือเผยแพร่ข้อสอบและเนื้อหาโดยไม่ได้รับอนุญาต",
                    "ห้ามใช้ bot หรือ automated tools ในการทำข้อสอบ",
                    "ห้ามดำเนินการใดๆ ที่กระทบต่อระบบหรือผู้ใช้งานอื่น",
                  ].map((item, i) => (
                    <li key={i} className="flex items-start gap-2">
                      <span className="shrink-0">✕</span>
                      <span>{item}</span>
                    </li>
                  ))}
                </ul>
              </div>
              <p className="mt-3 text-sm text-gray-500">การละเมิดข้อห้ามข้างต้นอาจส่งผลให้ระงับหรือยกเลิกบัญชีโดยไม่คืนเงิน</p>
            </section>

            {/* 9 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">9</span>
                กฎหมายที่ใช้บังคับ
              </h2>
              <p className="text-sm">ข้อกำหนดนี้อยู่ภายใต้กฎหมายไทย ข้อพิพาทใดๆ ให้อยู่ในเขตอำนาจของศาลไทยที่มีเขตอำนาจ</p>
            </section>

            {/* 10 */}
            <section>
              <h2 className="text-xl font-bold text-gray-900 mb-3 flex items-center gap-2">
                <span className="bg-emerald-100 text-emerald-700 text-sm font-semibold px-2.5 py-1 rounded-full">10</span>
                ติดต่อเรา
              </h2>
              <div className="bg-emerald-50 border border-emerald-100 rounded-xl p-4 text-sm space-y-1">
                <p className="font-semibold text-emerald-900">หมอรู้ (MorRoo) Customer Support</p>
                <p>📧 <a href="mailto:jiacpr@gmail.com" className="text-blue-600 hover:underline">jiacpr@gmail.com</a></p>
                <p>📱 Line: @jiacpr</p>
                <p className="text-gray-500 text-xs mt-2">เวลาทำการ: วันจันทร์–ศุกร์ 09:00–18:00 น.</p>
              </div>
            </section>

          </div>
        </div>
      </div>
    </div>
  );
}
