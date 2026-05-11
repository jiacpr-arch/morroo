/**
 * Helpers for building schema.org JSON-LD blocks.
 *
 * Use with the `<JsonLd>` component, or by emitting <script type="application/ld+json">
 * directly in a server component.
 */

export const SITE_URL = "https://www.morroo.com";

export function breadcrumbList(
  items: { name: string; path: string }[]
) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: items.map((item, idx) => ({
      "@type": "ListItem",
      position: idx + 1,
      name: item.name,
      item: item.path.startsWith("http") ? item.path : `${SITE_URL}${item.path}`,
    })),
  };
}

export function faqPage(items: { q: string; a: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: items.map((it) => ({
      "@type": "Question",
      name: it.q,
      acceptedAnswer: { "@type": "Answer", text: it.a },
    })),
  };
}

export function course(args: {
  name: string;
  description: string;
  url: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Course",
    name: args.name,
    description: args.description,
    provider: {
      "@type": "EducationalOrganization",
      name: "หมอรู้ (MorRoo)",
      sameAs: SITE_URL,
    },
    inLanguage: "th-TH",
    url: args.url.startsWith("http") ? args.url : `${SITE_URL}${args.url}`,
  };
}

export function product(args: {
  name: string;
  description: string;
  url: string;
  priceTHB: number;
  priceValidUntil?: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Product",
    name: args.name,
    description: args.description,
    brand: { "@type": "Brand", name: "หมอรู้ (MorRoo)" },
    url: args.url.startsWith("http") ? args.url : `${SITE_URL}${args.url}`,
    offers: {
      "@type": "Offer",
      priceCurrency: "THB",
      price: args.priceTHB,
      availability: "https://schema.org/InStock",
      url: args.url.startsWith("http") ? args.url : `${SITE_URL}${args.url}`,
      ...(args.priceValidUntil && { priceValidUntil: args.priceValidUntil }),
    },
  };
}

export function article(args: {
  headline: string;
  description: string;
  url: string;
  image?: string;
  datePublished: string;
  dateModified?: string;
  authorName?: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: args.headline,
    description: args.description,
    image: args.image ? [args.image] : undefined,
    datePublished: args.datePublished,
    dateModified: args.dateModified ?? args.datePublished,
    author: {
      "@type": "Organization",
      name: args.authorName ?? "ทีมงานหมอรู้",
    },
    publisher: {
      "@type": "Organization",
      name: "หมอรู้ (MorRoo)",
      logo: {
        "@type": "ImageObject",
        url: `${SITE_URL}/logo.png`,
      },
    },
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": args.url.startsWith("http") ? args.url : `${SITE_URL}${args.url}`,
    },
    inLanguage: "th-TH",
  };
}
