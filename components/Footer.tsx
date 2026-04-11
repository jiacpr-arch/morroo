"use client";

import Link from "next/link";
import { useTranslation } from "@/lib/i18n/context";

export default function Footer() {
  const { t } = useTranslation();
  return (
    <footer className="border-t bg-brand-dark text-white">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-8 md:grid-cols-4">
          {/* Brand */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-lg font-bold">
              <span className="text-2xl">🩺</span>
              <span>{t.nav.brand}</span>
            </div>
            <p className="text-sm text-white/70 whitespace-pre-line">
              {t.footer.description}
            </p>
          </div>

          {/* Links */}
          <div>
            <h3 className="font-semibold mb-3">{t.footer.exams}</h3>
            <ul className="space-y-2 text-sm text-white/70">
              <li><Link href="/exams" className="hover:text-white transition-colors">{t.footer.allExams}</Link></li>
              <li><Link href="/exams?category=อายุรศาสตร์" className="hover:text-white transition-colors">{t.categories["internal-medicine"]}</Link></li>
              <li><Link href="/exams?category=ศัลยศาสตร์" className="hover:text-white transition-colors">{t.categories.surgery}</Link></li>
              <li><Link href="/exams?category=กุมารเวชศาสตร์" className="hover:text-white transition-colors">{t.categories.pediatrics}</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">{t.footer.about}</h3>
            <ul className="space-y-2 text-sm text-white/70">
              <li><Link href="/blog" className="hover:text-white transition-colors">{t.footer.articles}</Link></li>
              <li><Link href="/pricing" className="hover:text-white transition-colors">{t.footer.pricingPlan}</Link></li>
              <li><Link href="/login" className="hover:text-white transition-colors">{t.nav.login}</Link></li>
              <li><Link href="/register" className="hover:text-white transition-colors">{t.nav.register}</Link></li>
              <li><Link href="/privacy" className="hover:text-white transition-colors">{t.footer.privacyPolicy}</Link></li>
              <li><Link href="/terms" className="hover:text-white transition-colors">{t.footer.purchasePolicy}</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">{t.footer.contactUs}</h3>
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
              <li>🕐 {t.footer.workHours}</li>
            </ul>
            <a
              href="https://www.jiacpr.com"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block rounded-lg bg-white/10 hover:bg-white/20 border border-white/20 px-4 py-2 text-sm font-medium text-white transition-colors"
            >
              {t.footer.contactUs} →
            </a>
          </div>
        </div>

        <div className="mt-10 border-t border-white/10 pt-6 text-center text-sm text-white/50">
          {t.footer.copyright.replace("{year}", String(new Date().getFullYear()))}
        </div>
      </div>
    </footer>
  );
}
