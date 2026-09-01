import { faUrl } from "@/lib/firstaid/urls";

// robots.txt for the firstaid host. On firstaid.morroo.com the middleware
// rewrites /robots.txt into this handler, so the subdomain gets its own
// robots + sitemap instead of morroo's app/robots.ts.
export function GET() {
  const body = `User-agent: *
Allow: /

Sitemap: ${faUrl("/sitemap.xml")}
`;
  return new Response(body, {
    headers: { "Content-Type": "text/plain; charset=utf-8" },
  });
}
