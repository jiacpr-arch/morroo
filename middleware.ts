import { NextResponse, type NextRequest, after } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";
import { sendMetaEvent } from "@/lib/meta/events-api";

// Bots that should not generate CAPI PageView events
const BOT_UA_RE =
  /bot|crawl|spider|slurp|bytespider|facebookexternalhit|twitterbot|linkedinbot|whatsapp|applebot|yandex/i;

// firstaid.morroo.com (plus firstaid-beta.* for pre-cutover QA and
// firstaid.localhost for local dev) is served by this same app: requests on
// that host are rewritten into the /firstaid route tree, which lives in its
// own root layout (app/(firstaid)) with its own Meta pixel.
const FIRSTAID_HOST_RE = /^firstaid(-beta)?\./i;

// Public URL space that belongs to the firstaid app on its subdomain. Only
// these get the host-rewrite; anything else on the subdomain (unknown paths)
// still rewrites and 404s inside the firstaid layout, which is what we want.
function isFirstAidHost(request: NextRequest): boolean {
  const host = request.headers.get("host") ?? "";
  return FIRSTAID_HOST_RE.test(host);
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
  const firstaidHost = isFirstAidHost(request);

  let rewriteUrl: URL | undefined;
  if (firstaidHost) {
    if (pathname.startsWith("/firstaid")) {
      // Canonicalise: the internal prefix must not be a second public URL on
      // the subdomain — strip it so each page has exactly one address.
      const url = request.nextUrl.clone();
      url.pathname = pathname.replace(/^\/firstaid/, "") || "/";
      return NextResponse.redirect(url, 301);
    }
    if (!pathname.startsWith("/api") && !pathname.startsWith("/_next")) {
      rewriteUrl = request.nextUrl.clone();
      rewriteUrl.pathname = `/firstaid${pathname === "/" ? "" : pathname}`;
    }
  } else {
    // Reverse direction: on the production www host the /firstaid tree is not
    // a public URL — 301 to the subdomain so ads/SEO see one canonical home.
    // Previews and localhost keep /firstaid/* reachable directly for QA.
    const host = request.headers.get("host") ?? "";
    if (
      pathname.startsWith("/firstaid") &&
      /(^|\.)morroo\.com$/i.test(host.split(":")[0])
    ) {
      const target = new URL(request.url);
      target.host = "firstaid.morroo.com";
      target.port = "";
      target.pathname = pathname.replace(/^\/firstaid/, "") || "/";
      return NextResponse.redirect(target, 301);
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
  // must preserve the firstaid host-rewrite or an auth hiccup would render
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
  // Skipped on the firstaid host: that section tracks with its own pixel
  // (browser-side only for now), and firing morroo's pixel there would
  // misattribute the traffic.
  if (!firstaidHost && shouldSendCapiPageView(request)) {
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
