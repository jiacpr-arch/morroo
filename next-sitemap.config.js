/** @type {import('next-sitemap').IConfig} */
module.exports = {
  siteUrl: "https://www.morroo.com",
  generateRobotsTxt: true,
  changefreq: "daily",
  priority: 0.7,
  sitemapSize: 5000,
  exclude: ["/admin/*", "/api/*", "/payment/*", "/auth/*", "/invoice/*"],
  robotsTxtOptions: {
    policies: [
      { userAgent: "*", allow: "/" },
      { userAgent: "*", disallow: ["/admin", "/api", "/payment", "/auth", "/invoice"] },
    ],
  },
  additionalPaths: async (config) => {
    try {
      // Fetch blog slugs directly from Supabase REST API (no Next.js context needed)
      const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
      const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
      if (!supabaseUrl || !supabaseKey) return [];

      const res = await fetch(
        `${supabaseUrl}/rest/v1/blog_posts?select=slug`,
        { headers: { apikey: supabaseKey, Authorization: `Bearer ${supabaseKey}` } }
      );
      if (!res.ok) return [];
      const rows = await res.json();
      return rows.map((r) => ({
        loc: `/blog/${r.slug}`,
        changefreq: "weekly",
        priority: 0.8,
      }));
    } catch {
      return [];
    }
  },
};
