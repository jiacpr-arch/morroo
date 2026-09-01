import { type ReactNode } from "react";
import { headers, cookies } from "next/headers";
import { after } from "next/server";
import { sendMetaEvent } from "@/lib/meta/events-api";

export default async function RegisterLayout({
  children,
}: {
  children: ReactNode;
}) {
  const headersList = await headers();
  const cookieStore = await cookies();

  const fbc = cookieStore.get("_fbc")?.value ?? null;
  const fbp = cookieStore.get("_fbp")?.value ?? null;
  const ip =
    (headersList.get("x-forwarded-for") ?? "").split(",")[0].trim() || null;
  const userAgent = headersList.get("user-agent") ?? null;
  const host = headersList.get("host") ?? "morroo.com";
  const proto = host.startsWith("localhost") ? "http" : "https";

  // Signal to Meta that someone reached the signup page — a strong mid-funnel
  // intent marker. This fires server-side to bypass ad blockers.
  after(() =>
    sendMetaEvent({
      event: "ViewContent",
      fbc,
      fbp,
      ip,
      userAgent,
      url: `${proto}://${host}/register`,
      contentName: "register",
    })
  );

  return <>{children}</>;
}
