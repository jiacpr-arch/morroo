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
              <li><Link href="/pricing" className="hover:text-white transition-colors">แพ็กเกจราคา</Link></li>
              <li><Link href="/login" className="hover:text-white transition-colors">เข้าสู่ระบบ</Link></li>
              <li><Link href="/register" className="hover:text-white transition-colors">สมัครสมาชิก</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">ติดต่อเรา</h3>
            <ul className="space-y-2 text-sm text-white/70">
              <li>📧 jiacpr@gmail.com</li>
              <li>📱 Line: @jiacpr</li>
            </ul>
          </div>
        </div>

        <div className="mt-10 border-t border-white/10 pt-6 text-center text-sm text-white/50">
          © {new Date().getFullYear()} หมอรู้ (MorRoo) — สงวนลิขสิทธิ์
        </div>
      </div>
    </footer>
  );
}
