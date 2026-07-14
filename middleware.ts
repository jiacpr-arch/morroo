import { NextResponse, type NextRequest, after } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";
import { sendMetaEvent } from "@/lib/meta/events-api";

// Bots that should not generate CAPI PageView events
const BOT_UA_RE =
  /bot|crawl|spider|slurp|bytespider|facebookexternalhit|twitterbot|linkedinbot|whatsapp|applebot|yandex/i;

// Each consolidated app is served by this same Next.js app on its own
// subdomain (plus a "-beta." variant for pre-cutover QA): requests on that
// host are rewritten into the section's internal route tree, which lives in
// its own root layout with its own Meta pixel (see app/(firstaid),
// app/(acls), app/(bls)).
//
// `prefix` is deliberately NOT a bare "/acls" or "/bls": app/(morroo)/ already
// has unrelated routes named acls-emr and acls-reader, so a naive
// `pathname.startsWith("/acls")` would wrongly capture "/acls-emr" too. The
// segment-boundary-safe check in inSection() below is the real fix (an exact
// prefix match or prefix + "/"), but the distinct "-course" suffix is kept as
// a second, independent safety margin against future collisions.
type Section = {
  hostRe: RegExp;
  prefix: string;
  canonicalHost: string;
  /** true if this section fires its own Meta pixel (skip morroo's CAPI here) */
  skipMorrooCapi: boolean;
};

const SECTIONS: Section[] = [
  {
    hostRe: /^firstaid(-beta)?\./i,
    prefix: "/firstaid",
    canonicalHost: "firstaid.morroo.com",
    skipMorrooCapi: true,
  },
  {
    hostRe: /^acls(-beta)?\./i,
    prefix: "/acls-course",
    canonicalHost: "acls.morroo.com",
    skipMorrooCapi: true,
  },
  {
    hostRe: /^bls(-beta)?\./i,
    prefix: "/bls-course",
    canonicalHost: "bls.morroo.com",
    skipMorrooCapi: true,
  },
];

function matchSection(request: NextRequest): Section | undefined {
  const host = request.headers.get("host") ?? "";
  return SECTIONS.find((s) => s.hostRe.test(host));
}

// Segment-boundary-safe: "/acls-course" must match "/acls-course" and
// "/acls-course/x", but never "/acls-emr" or "/acls-reader".
function inSection(pathname: string, prefix: string): boolean {
  return pathname === prefix || pathname.startsWith(`${prefix}/`);
}

function shouldSendCapiPageView(request: NextRequest): boolean {
  const ua = request.headers.get("user-agent") ?? "";
  if (BOT_UA_RE.test(ua)) return false;
  // Only fire for browser HTML navigations, not fetch/XHR/prefetch
  const accept = request.headers.get("accept") ?? "";
  if (!accept.includes("text/html")) return false;
  const { pathname } = request.nextUrl;
  if (pathname.startsWith("/api/")) return false;
  return true;
}

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const section = matchSection(request);

  let rewriteUrl: URL | undefined;
  if (section) {
    if (inSection(pathname, section.prefix)) {
      // Canonicalise: the internal prefix must not be a second public URL on
      // the subdomain — strip it so each page has exactly one address.
      const url = request.nextUrl.clone();
      url.pathname = pathname.slice(section.prefix.length) || "/";
      return NextResponse.redirect(url, 301);
    }
    if (!pathname.startsWith("/api") && !pathname.startsWith("/_next")) {
      rewriteUrl = request.nextUrl.clone();
      rewriteUrl.pathname = `${section.prefix}${pathname === "/" ? "" : pathname}`;
    }
  } else {
    // Reverse direction: on the production www host a section's internal
    // path tree is not a public URL — 301 to that section's subdomain so
    // ads/SEO see one canonical home. Previews and localhost keep the
    // internal prefix reachable directly for QA.
    const host = request.headers.get("host") ?? "";
    if (/(^|\.)morroo\.com$/i.test(host.split(":")[0])) {
      const hitSection = SECTIONS.find((s) => inSection(pathname, s.prefix));
      if (hitSection) {
        const target = new URL(request.url);
        target.host = hitSection.canonicalHost;
        target.port = "";
        target.pathname = pathname.slice(hitSection.prefix.length) || "/";
        return NextResponse.redirect(target, 301);
      }
    }
  }

  // Skip Supabase session refresh if not configured
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    process.env.NEXT_PUBLIC_SUPABASE_URL === "your-supabase-url"
  ) {
    return rewriteUrl ? NextResponse.rewrite(rewriteUrl) : NextResponse.next();
  }

  // Timeout guard — don't let Supabase hang the entire request. The fallback
  // must preserve the section host-rewrite or an auth hiccup would render
  // morroo's tree on the subdomain.
  let response: NextResponse = rewriteUrl
    ? NextResponse.rewrite(rewriteUrl)
    : NextResponse.next();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);
  try {
    response = await updateSession(request, rewriteUrl);
  } catch {
    // response stays as the pre-built rewrite/next fallback
  } finally {
    clearTimeout(timeout);
  }

  // Persist _fbc from the fbclid URL param server-side so attribution works
  // even when the browser pixel is blocked by an ad blocker.
  const fbclid = request.nextUrl.searchParams.get("fbclid");
  if (fbclid && !request.cookies.get("_fbc")) {
    response.cookies.set("_fbc", `fb.1.${Date.now()}.${fbclid}`, {
      path: "/",
      maxAge: 90 * 24 * 60 * 60, // 90 days, matches FB pixel default
      sameSite: "lax",
      httpOnly: false, // browser pixel must also read this cookie
    });
  }

  // Send server-side CAPI PageView so Meta sees traffic even when the browser
  // pixel is blocked by ad blockers (~97% of ad clicks were invisible).
  // Skipped on sections with their own pixel (browser-side only for now) —
  // firing morroo's pixel there would misattribute the traffic.
  if (!section?.skipMorrooCapi && shouldSendCapiPageView(request)) {
    const fbc =
      request.cookies.get("_fbc")?.value ??
      (fbclid ? `fb.1.${Date.now()}.${fbclid}` : null);
    const fbp = request.cookies.get("_fbp")?.value ?? null;
    const ip =
      (request.headers.get("x-forwarded-for") ?? "").split(",")[0].trim() ||
      null;
    const userAgent = request.headers.get("user-agent") ?? null;
    after(() =>
      sendMetaEvent({
        event: "PageView",
        fbc,
        fbp,
        ip,
        userAgent,
        url: request.url,
      })
    );
  }

  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|api/billing/webhook|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
