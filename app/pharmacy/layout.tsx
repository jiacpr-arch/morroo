'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const navItems = [
  { href: '/pharmacy', label: '📊 แดชบอร์ด', exact: true },
  { href: '/pharmacy/receive', label: '📥 รับยาเข้า' },
  { href: '/pharmacy/dispense', label: '📤 จ่ายยาออก' },
  { href: '/pharmacy/inventory', label: '📦 คลังยา' },
  { href: '/pharmacy/drugs', label: '💊 จัดการรายการยา' },
]

export default function PharmacyLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Pharmacy Header */}
      <div className="bg-gradient-to-r from-blue-700 to-blue-600 text-white px-6 py-4 shadow-lg">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="text-3xl">🏥</span>
            <div>
              <h1 className="text-xl font-bold tracking-tight">ระบบจัดการคลังยา</h1>
              <p className="text-blue-200 text-xs">Pharmacy Management System · Real-time Stock</p>
            </div>
          </div>
          <div className="text-right text-sm text-blue-200">
            <div id="pharmacy-clock" className="font-mono text-lg text-white" />
            <div className="text-xs">เวลาปัจจุบัน</div>
          </div>
        </div>
      </div>

      {/* Navigation Tabs */}
      <div className="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-10">
        <div className="max-w-7xl mx-auto">
          <nav className="flex overflow-x-auto scrollbar-hide" aria-label="pharmacy navigation">
            {navItems.map(item => {
              const isActive = item.exact
                ? pathname === item.href
                : pathname.startsWith(item.href)
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={[
                    'flex-shrink-0 px-5 py-4 text-sm font-medium border-b-2 transition-all whitespace-nowrap',
                    isActive
                      ? 'border-blue-600 text-blue-700 bg-blue-50 font-semibold'
                      : 'border-transparent text-gray-600 hover:text-gray-900 hover:bg-gray-50 hover:border-gray-300',
                  ].join(' ')}
                >
                  {item.label}
                </Link>
              )
            })}
          </nav>
        </div>
      </div>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto p-4 md:p-6">
        {children}
      </main>

      {/* Clock script */}
      <script dangerouslySetInnerHTML={{
        __html: `
          function updateClock() {
            const el = document.getElementById('pharmacy-clock');
            if (el) {
              const now = new Date();
              el.textContent = now.toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
            }
          }
          updateClock();
          setInterval(updateClock, 1000);
        `
      }} />
    </div>
  )
}
