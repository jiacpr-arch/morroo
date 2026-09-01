import { createHmac } from "node:crypto";

export function makeUnsubscribeToken(userId: string): string {
  const secret = process.env.BLOG_GENERATE_SECRET ?? "fallback-secret";
  return createHmac("sha256", secret).update(userId).digest("hex").slice(0, 32);
}

export function generateUnsubscribeUrl(userId: string, baseUrl = "https://www.morroo.com"): string {
  return `${baseUrl}/api/newsletter/unsubscribe?uid=${userId}&token=${makeUnsubscribeToken(userId)}`;
}
