/** @type {import('next-sitemap').IConfig} */
module.exports = {
  siteUrl: "https://www.morroo.com",
  generateRobotsTxt: true,
  changefreq: "daily",
  priority: 0.7,
  sitemapSize: 5000,
  // /firstaid/* is the internal route tree for firstaid.morroo.com (host
  // rewrite) — its public URLs live on the subdomain's own sitemap, not here.
  exclude: ["/admin/*", "/api/*", "/payment/*", "/auth/*", "/invoice/*", "/firstaid", "/firstaid/*"],
  robotsTxtOptions: {
    policies: [
      { userAgent: "*", allow: "/" },
      { userAgent: "*", disallow: ["/admin", "/api", "/payment", "/auth", "/invoice"] },
    ],
  },
  additionalPaths: async (_config) => {
    // SEO landing guides under /learn — slugs come from lib/guides.ts. Mirror
    // them here because next-sitemap runs in a CJS context that can't import
    // the TS data file.
    const guideSlugs = [
      "sob-nl-step-3",
      "meq-progressive-case",
      "long-case-ai-practice",
      "mcq-nl-strategy",
      "clinical-reasoning",
    ];
    const paths = [
      { loc: "/learn", changefreq: "weekly", priority: 0.7 },
      ...guideSlugs.map((slug) => ({
        loc: `/learn/${slug}`,
        changefreq: "monthly",
        priority: 0.8,
      })),
    ];

    try {
      const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
      const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
      if (!supabaseUrl || !supabaseKey) return paths;

      const res = await fetch(
        `${supabaseUrl}/rest/v1/blog_posts?select=slug`,
        { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } }
      );
      if (!res.ok) return paths;
      const rows = await res.json();
      return paths.concat(
        rows.map((r) => ({
          loc: `/blog/${r.slug}`,
          changefreq: "weekly",
          priority: 0.8,
        }))
      );
    } catch {
      return paths;
    }
  },
};
