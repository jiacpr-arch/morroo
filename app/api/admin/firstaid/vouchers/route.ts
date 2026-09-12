import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { generateVoucherCode } from "@/lib/firstaid/server/voucherCode";

export const runtime = "nodejs";

/**
 * Admin voucher management for the firstaid course paywall (fa_vouchers).
 * Replaces the voucher page of the old jiacpr-arch/firstaid admin.
 *
 * GET  /api/admin/firstaid/vouchers?status=active|redeemed|void&limit=N
 *   → { items, counts: { active, redeemed, void } }
 *   Redeemed rows are enriched with the learner's LINE display name / email.
 *
 * POST /api/admin/firstaid/vouchers
 *   Body: { chapter: 0-4, count: 1-100, price_thb?: number|null, note?: string }
 *   chapter 0 = whole-course bundle.
 *   → { items: [{ code, chapter, price_thb, status, created_at }] }
 */

const STATUSES = ["active", "redeemed", "void"] as const;
type Status = (typeof STATUSES)[number];

export async function GET(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const url = new URL(request.url);
  const status = url.searchParams.get("status");
  const limit = Math.min(
    1000,
    Math.max(1, Number(url.searchParams.get("limit") ?? 500) || 500),
  );

  const admin = createAdminClient();

  let query = admin
    .from("fa_vouchers")
    .select(
      "code, chapter, status, price_thb, redeemed_by, redeemed_at, created_by, created_at",
    )
    .order("created_at", { ascending: false })
    .limit(limit);
  if (status && (STATUSES as readonly string[]).includes(status)) {
    query = query.eq("status", status);
  }

  const [{ data: rows, error }, ...countRes] = await Promise.all([
    query,
    ...STATUSES.map((s) =>
      admin
        .from("fa_vouchers")
        .select("code", { count: "exact", head: true })
        .eq("status", s),
    ),
  ]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const counts = Object.fromEntries(
    STATUSES.map((s, i) => [s, countRes[i]?.count ?? 0]),
  ) as Record<Status, number>;

  // Resolve redeemed_by (learner_id) → LINE profile so admin can see who used a code.
  const learnerIds = Array.from(
    new Set((rows ?? []).map((r) => r.redeemed_by).filter(Boolean)),
  ) as string[];
  const learnerMap = new Map<
    string,
    { display_name: string | null; email: string | null }
  >();
  if (learnerIds.length > 0) {
    const { data: links } = await admin
      .from("fa_learner_links")
      .select("learner_id, display_name, email")
      .in("learner_id", learnerIds);
    for (const l of links ?? []) {
      learnerMap.set(l.learner_id, {
        display_name: l.display_name,
        email: l.email,
      });
    }
  }

  const items = (rows ?? []).map((r) => ({
    ...r,
    redeemer: r.redeemed_by ? (learnerMap.get(r.redeemed_by) ?? null) : null,
  }));

  return NextResponse.json({ items, counts });
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { chapter?: unknown; count?: unknown; price_thb?: unknown };
  try {
    body = (await request.json()) as typeof body;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const chapter = Number(body.chapter ?? 0);
  if (!Number.isInteger(chapter) || chapter < 0 || chapter > 4) {
    return NextResponse.json(
      { error: "chapter must be 0 (bundle) or 1-4" },
      { status: 400 },
    );
  }
  const count = Number(body.count ?? 1);
  if (!Number.isInteger(count) || count < 1 || count > 100) {
    return NextResponse.json(
      { error: "count must be 1-100" },
      { status: 400 },
    );
  }
  let priceThb: number | null = null;
  if (body.price_thb !== undefined && body.price_thb !== null && body.price_thb !== "") {
    priceThb = Number(body.price_thb);
    if (!Number.isInteger(priceThb) || priceThb < 0) {
      return NextResponse.json(
        { error: "price_thb must be a non-negative integer" },
        { status: 400 },
      );
    }
  }

  const admin = createAdminClient();
  const rows = Array.from({ length: count }, () => ({
    code: generateVoucherCode(),
    chapter,
    price_thb: priceThb,
    created_by: guard.userId,
  }));

  const { data, error } = await admin
    .from("fa_vouchers")
    .insert(rows)
    .select("code, chapter, price_thb, status, created_at");
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ items: data ?? [] });
}
