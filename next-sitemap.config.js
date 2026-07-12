/** @type {import('next-sitemap').IConfig} */
module.exports = {
  siteUrl: "https://www.morroo.com",
  generateRobotsTxt: true,
  changefreq: "daily",
  priority: 0.7,
  sitemapSize: 5000,
  exclude: [
    "/admin/*",
    "/api/*",
    "/payment/*",
    "/auth/*",
    "/invoice/*",
    // โซนคอร์ส CPR: หน้าใน flow เรียน/สมัคร/ชำระเงิน ไม่ให้ index (หน้า /cpr, /cpr/store,
    // /cpr/booking, /cpr/blog เพิ่มผ่าน additionalPaths ด้านล่างแทน เพราะ catch-all
    // ไม่ถูก generate เป็น path คงที่)
    "/cpr/*",
  ],
  robotsTxtOptions: {
    policies: [
      { userAgent: "*", allow: "/" },
      {
        userAgent: "*",
        disallow: [
          "/admin",
          "/api",
          "/payment",
          "/auth",
          "/invoice",
          "/cpr/quiz",
          "/cpr/signup",
          "/cpr/register",
          "/cpr/line-add",
          "/cpr/claim",
          "/cpr/payment",
          "/cpr/course",
          "/cpr/certificate",
          "/cpr/minicert",
        ],
      },
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
      // โซนคอร์ส CPR (JIA) — เฉพาะหน้า public ที่ให้ index
      { loc: "/cpr", changefreq: "weekly", priority: 0.8 },
      { loc: "/cpr/store", changefreq: "weekly", priority: 0.6 },
      { loc: "/cpr/booking", changefreq: "weekly", priority: 0.6 },
      { loc: "/cpr/blog", changefreq: "daily", priority: 0.6 },
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
