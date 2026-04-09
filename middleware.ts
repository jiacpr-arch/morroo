import { NextResponse, type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/middleware";

export async function middleware(request: NextRequest) {
  // Skip Supabase session refresh if not configured
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    process.env.NEXT_PUBLIC_SUPABASE_URL === "your-supabase-url"
  ) {
    return NextResponse.next();
  }

  // Race against a 5s timeout so slow Supabase never blocks page loads
  const timeout = new Promise<NextResponse>((resolve) =>
    setTimeout(() => resolve(NextResponse.next()), 5000)
  );

  try {
    return await Promise.race([updateSession(request), timeout]);
  } catch {
    return NextResponse.next();
  }
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|api/billing/webhook|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
