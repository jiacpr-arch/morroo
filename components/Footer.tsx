import Link from "next/link";

export default function Footer() {
  return (
    <footer className="border-t bg-brand-dark text-white">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-8 md:grid-cols-4">
          {/* Brand */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-lg font-bold">
              <span className="text-2xl">🩺</span>
              <span>หมอรู้</span>
            </div>
            <p className="text-sm text-white/70">
              แพลตฟอร์มข้อสอบ MEQ ออนไลน์
              <br />
              เตรียมสอบแพทย์ด้วย AI ที่เข้าใจคุณ
            </p>
          </div>

          {/* Links */}
          <div>
            <h3 className="font-semibold mb-3">ข้อสอบ</h3>
            <ul className="space-y-2 text-sm text-white/70">
              <li><Link href="/exams" className="hover:text-white transition-colors">ข้อสอบทั้งหมด</Link></li>
              <li><Link href="/exams?category=อายุรศาสตร์" className="hover:text-white transition-colors">อายุรศาสตร์</Link></li>
              <li><Link href="/exams?category=ศัลยศาสตร์" className="hover:text-white transition-colors">ศัลยศาสตร์</Link></li>
              <li><Link href="/exams?category=กุมารเวชศาสตร์" className="hover:text-white transition-colors">กุมารเวชศาสตร์</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">เกี่ยวกับ</h3>
            <ul className="space-y-2 text-sm text-white/70">
              <li><Link href="/blog" className="hover:text-white transition-colors">บทความ</Link></li>
              <li><Link href="/pricing" className="hover:text-white transition-colors">แพ็กเกจราคา</Link></li>
              <li><Link href="/login" className="hover:text-white transition-colors">เข้าสู่ระบบ</Link></li>
              <li><Link href="/register" className="hover:text-white transition-colors">สมัครสมาชิก</Link></li>
              <li><Link href="/guide" className="hover:text-white transition-colors">คู่มือการใช้งาน</Link></li>
              <li><Link href="/feedback" className="hover:text-white transition-colors">ส่ง Feedback</Link></li>
              <li><Link href="/privacy" className="hover:text-white transition-colors">นโยบายความเป็นส่วนตัว</Link></li>
              <li><Link href="/terms" className="hover:text-white transition-colors">นโยบายการซื้อสินค้า</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">ติดต่อเรา</h3>
            <ul className="space-y-2 text-sm text-white/70 mb-4">
              <li>
                <a href="https://www.jiacpr.com" target="_blank" rel="noopener noreferrer" className="hover:text-white transition-colors">
                  🌐 www.jiacpr.com
                </a>
              </li>
              <li>
                <a href="mailto:Jiacpr@gmail.com" className="hover:text-white transition-colors">
                  📧 Jiacpr@gmail.com
                </a>
              </li>
              <li>📱 Line: @jiacpr</li>
              <li>
                <a href="tel:0885588078" className="hover:text-white transition-colors">
                  📞 088-558-8078
                </a>
                {" / "}
                <a href="tel:021211669" className="hover:text-white transition-colors">
                  02-121-1669
                </a>
              </li>
              <li>📍 JIA TRAINER CENTER, The Street Ratchada ชั้น 3</li>
              <li>🕐 เวลาทำการ 11.00 น. - 20.00 น.</li>
            </ul>
            <a
              href="https://www.jiacpr.com"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block rounded-lg bg-white/10 hover:bg-white/20 border border-white/20 px-4 py-2 text-sm font-medium text-white transition-colors"
            >
              ติดต่อเรา →
            </a>
          </div>
        </div>

        <div className="mt-10 border-t border-white/10 pt-6 text-center text-sm text-white/50">
          © {new Date().getFullYear()} หมอรู้ (MorRoo) — สงวนลิขสิทธิ์
        </div>
      </div>
    </footer>
  );
}
