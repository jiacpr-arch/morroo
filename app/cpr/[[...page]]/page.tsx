import type { Metadata } from "next";
import CprApp from "@/components/cpr/CprApp";

// หน้าใน flow เรียน/ชำระเงิน — ไม่ให้ index (landing/store/booking/blog index ได้ตามปกติ)
const NOINDEX_SLUGS = new Set([
  "quiz",
  "signup",
  "register",
  "line-add",
  "claim",
  "payment",
  "course",
  "certificate",
  "minicert",
]);

type Params = Promise<{ page?: string[] }>;
type SearchParams = Promise<Record<string, string | string[] | undefined>>;

export async function generateMetadata({ params }: { params: Params }): Promise<Metadata> {
  const { page } = await params;
  const slug = page?.[0] || "";
  if (NOINDEX_SLUGS.has(slug)) {
    return { robots: { index: false, follow: false } };
  }
  return {};
}

export default async function CprPage({ params, searchParams }: { params: Params; searchParams: SearchParams }) {
  const { page } = await params;
  const sp = await searchParams;
  const first = (v: string | string[] | undefined) => (Array.isArray(v) ? v[0] : v);
  const search = {
    promo: first(sp.promo),
    code: first(sp.code),
    stripe: first(sp.stripe),
    modules: first(sp.modules),
    admin: first(sp.admin),
  };
  return <CprApp segments={page ?? []} search={search} />;
}
