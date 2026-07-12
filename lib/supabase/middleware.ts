import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

const ONBOARDING_SKIP_PATHS = [
  "/login",
  "/register",
  "/onboarding",
  "/auth",
  "/api",
  "/privacy",
  "/purchase-policy",
];

// When rewriteUrl is provided (firstaid.morroo.com host-rewrite), every
// response — including the ones re-created inside setAll() — must be a
// rewrite, otherwise refreshed auth cookies would ride on a response that
// renders the wrong route.
export async function updateSession(request: NextRequest, rewriteUrl?: URL) {
  const makeResponse = () =>
    rewriteUrl
      ? NextResponse.rewrite(rewriteUrl, { request })
      : NextResponse.next({ request });

  let supabaseResponse = makeResponse();

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = makeResponse();
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { pathname } = request.nextUrl;

  // The firstaid section has its own funnel: anonymous learners are
  // first-class and LINE signups are created with onboarding_done = true, so
  // morroo's login-bounce and onboarding redirects must never fire there.
  if (rewriteUrl || pathname.startsWith("/firstaid")) {
    return supabaseResponse;
  }

  // Already-authenticated users have no business on the auth pages — bounce
  // them to their profile instead of showing the login/register forms again.
  if (user && (pathname === "/login" || pathname === "/register")) {
    const url = request.nextUrl.clone();
    url.pathname = "/profile";
    url.search = "";
    return NextResponse.redirect(url);
  }

  // Onboarding redirect: logged-in users with onboarding_done = false
  const skipOnboarding = ONBOARDING_SKIP_PATHS.some((p) =>
    pathname.startsWith(p)
  );

  if (user && !skipOnboarding) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("onboarding_done")
      .eq("id", user.id)
      .single();

    if (profile && profile.onboarding_done === false) {
      const url = request.nextUrl.clone();
      url.pathname = "/onboarding";
      return NextResponse.redirect(url);
    }
  }

  return supabaseResponse;
}
