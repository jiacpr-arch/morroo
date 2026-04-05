/** @type {import('next-sitemap').IConfig} */
const { getAllSlugs } = require("./lib/blog");

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
    const blogSlugs = getAllSlugs();
    return blogSlugs.map((slug) => ({
      loc: `/blog/${slug}`,
      changefreq: "weekly",
      priority: 0.8,
    }));
  },
};
