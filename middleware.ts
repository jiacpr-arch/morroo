import { NextResponse, type NextRequest, after } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";
import { sendMetaEvent } from "@/lib/meta/events-api";

// Bots that should not generate CAPI PageView events
const BOT_UA_RE =
  /bot|crawl|spider|slurp|bytespider|facebookexternalhit|twitterbot|linkedinbot|whatsapp|applebot|yandex/i;

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
  // Skip Supabase session refresh if not configured
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    process.env.NEXT_PUBLIC_SUPABASE_URL === "your-supabase-url"
  ) {
    return NextResponse.next();
  }

  // Timeout guard — don't let Supabase hang the entire request
  let response: NextResponse = NextResponse.next();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);
  try {
    response = await updateSession(request);
  } catch {
    // response stays as NextResponse.next()
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
  if (shouldSendCapiPageView(request)) {
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
