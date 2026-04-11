"use client";

import PricingCard from "@/components/PricingCard";
import { PRICING_PLANS } from "@/lib/types";
import { useTranslation } from "@/lib/i18n/context";

export default function PricingContent() {
  const { t } = useTranslation();

  const plans = [
    { ...PRICING_PLANS[0], name: t.pricing.planFree, description: t.pricing.planFreeDesc, features: [t.pricing.free5, t.pricing.shortAnswer, t.pricing.noDetail], cta: t.pricing.ctaFree, period: "" },
    { ...PRICING_PLANS[1], name: t.pricing.planBundle, description: t.pricing.planBundleDesc, features: [t.pricing.pick10, t.pricing.detailAnswer, t.pricing.keyPoints, t.pricing.aiGrade, t.pricing.noExpiry], cta: t.pricing.ctaBundle, period: t.pricing.perQuestions },
    { ...PRICING_PLANS[2], name: t.pricing.planMonthly, description: t.pricing.planMonthlyDesc, features: [t.pricing.unlimited, t.pricing.detailAll, t.pricing.keyPoints, t.pricing.aiUnlimited, t.pricing.longCaseUnlimited, t.pricing.newWeekly], cta: t.pricing.ctaMonthly, period: t.pricing.perMonth },
    { ...PRICING_PLANS[3], name: t.pricing.planYearly, description: t.pricing.planYearlyDesc, features: [t.pricing.everythingMonthly, t.pricing.aiUnlimited, t.pricing.longCaseUnlimited, t.pricing.save898, t.pricing.earlyAccess], cta: t.pricing.ctaYearly, period: t.pricing.perYear },
  ];

  const faqs = [
    { q: t.pricing.faq1q, a: t.pricing.faq1a },
    { q: t.pricing.faq2q, a: t.pricing.faq2a },
    { q: t.pricing.faq3q, a: t.pricing.faq3a },
    { q: t.pricing.faq4q, a: t.pricing.faq4a },
  ];

  return (
    <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <div className="text-center mb-12">
        <h1 className="text-3xl sm:text-4xl font-bold">{t.pricing.title}</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-xl mx-auto">
          {t.pricing.desc}
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
        {plans.map((plan) => (
          <PricingCard key={plan.type} {...plan} />
        ))}
      </div>

      {/* FAQ */}
      <div className="mt-20 max-w-3xl mx-auto">
        <h2 className="text-2xl font-bold text-center mb-8">{t.pricing.faqTitle}</h2>
        <div className="space-y-6">
          {faqs.map((faq) => (
            <div key={faq.q} className="border rounded-lg p-5">
              <h3 className="font-semibold">{faq.q}</h3>
              <p className="mt-2 text-sm text-muted-foreground">{faq.a}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
