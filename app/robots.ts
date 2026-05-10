import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      // Social scrapers — explicit Allow so Vercel's edge bot detection
      // doesn't misclassify them, and the FB Sharing Debugger stops
      // emitting "could be due to a robots.txt block" hints.
      { userAgent: "facebookexternalhit", allow: "/" },
      { userAgent: "facebookcatalog", allow: "/" },
      { userAgent: "meta-externalagent", allow: "/" },
      { userAgent: "Twitterbot", allow: "/" },
      { userAgent: "LinkedInBot", allow: "/" },
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/api/", "/admin/", "/onboarding"],
      },
    ],
    sitemap: "https://www.morroo.com/sitemap.xml",
    host: "https://www.morroo.com",
  };
}
