import { faUrl } from "@/lib/firstaid/urls";
import { lessons } from "@/lib/firstaid/content/lessons";
import { algorithms } from "@/lib/firstaid/content/algorithms";
import { scenarios } from "@/lib/firstaid/content/scenarios";

// Sitemap for the firstaid host (rewritten from /sitemap.xml by middleware).
// Lists every public content URL on the subdomain; gated/utility pages
// (pre/post-test, settings, checkin, auth) are deliberately excluded.
export function GET() {
  const paths = [
    "/",
    "/learn",
    ...(lessons as Array<{ id: string }>).map((l) => `/learn/${l.id}`),
    "/algorithms",
    ...(algorithms as Array<{ id: string }>).map((a) => `/algorithms/${a.id}`),
    "/simulation",
    ...(scenarios as Array<{ id: string }>).map((s) => `/simulation/${s.id}`),
    "/certificate",
    "/call",
  ];

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${paths.map((p) => `  <url><loc>${faUrl(p)}</loc></url>`).join("\n")}
</urlset>
`;

  return new Response(xml, {
    headers: { "Content-Type": "application/xml; charset=utf-8" },
  });
}
