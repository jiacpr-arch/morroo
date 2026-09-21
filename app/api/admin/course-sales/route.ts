/**
 * Hand-entered course sales (CPR / First Aid / ALS) + their Purchase CAPI event.
 *
 * These courses close over chat with a direct transfer, so nothing in the
 * Stripe pipeline ever sees them. Sales records the sale here and Meta learns
 * who actually paid — see docs/spec-capi-conversion-tracking.md, Part A.
 *
 * GET  /api/admin/course-sales?limit=50 → { items, totals }
 * POST /api/admin/course-sales          → { item }
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { sendMetaEvent, sourceUrl } from "@/lib/meta/events-api";
import { courseSaleEventId, validateCourseSale } from "@/lib/course-sales";

export const runtime = "nodejs";

const DEFAULT_LIMIT = 50;
const MAX_LIMIT = 200;

export async function GET(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const limitParam = Number(new URL(request.url).searchParams.get("limit"));
  const limit = Number.isFinite(limitParam)
    ? Math.min(Math.max(Math.trunc(limitParam), 1), MAX_LIMIT)
    : DEFAULT_LIMIT;

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("course_sales")
    .select(
      "id, customer_name, phone, course_id, course_name, price_thb, source_channel, sold_on, capi_sent_at, capi_error, created_at"
    )
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const items = data ?? [];
  return NextResponse.json({
    items,
    totals: {
      count: items.length,
      revenueThb: items.reduce((sum, r) => sum + Number(r.price_thb ?? 0), 0),
      // Surfaced in the UI so a silent Meta outage is visible to whoever is
      // entering sales, not buried in server logs nobody opens.
      capiPending: items.filter((r) => !r.capi_sent_at).length,
    },
  });
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const result = validateCourseSale((body ?? {}) as Record<string, unknown>);
  if (!result.ok) {
    return NextResponse.json({ error: result.errors.join(" · ") }, { status: 400 });
  }
  const { sale } = result;

  const admin = createAdminClient();
  const { data: row, error } = await admin
    .from("course_sales")
    .insert({
      customer_name: sale.customerName,
      phone: sale.phone,
      course_id: sale.course.id,
      course_name: sale.course.name,
      price_thb: sale.priceThb,
      source_channel: sale.sourceChannel,
      sold_on: sale.soldOn,
      recorded_by: guard.userId,
    })
    .select("id, customer_name, course_name, price_thb, sold_on, created_at")
    .single();

  if (error || !row) {
    return NextResponse.json(
      { error: error?.message ?? "บันทึกไม่สำเร็จ" },
      { status: 500 }
    );
  }

  // The sale is already saved. From here nothing may throw the record away:
  // a Meta outage costs one conversion, losing the row costs the receipt.
  let capiSent = false;
  let capiError: string | null = null;
  try {
    capiSent = await sendMetaEvent({
      event: "Purchase",
      eventId: courseSaleEventId(row.id),
      // Closed in chat and typed in afterwards — claiming "website" here
      // would describe a visit that never happened and skew match quality.
      actionSource: "system_generated",
      // Meta only requires event_source_url for website events, so this is
      // not load-bearing. It points at the screen the sale was entered on,
      // which is the only page involved, and gives the event a stable origin
      // in Events Manager instead of a blank column.
      url: sourceUrl("/admin/course-sales"),
      phone: sale.phone,
      value: sale.priceThb,
      currency: "THB",
      contentIds: [sale.course.id],
      contentName: sale.course.name,
      contentType: "product",
    });
    if (!capiSent) capiError = "Meta ไม่รับ event — ดูรายละเอียดใน log";
  } catch (e) {
    // sendMetaEvent swallows its own errors, so this only catches something
    // unexpected upstream (a bad argument, say). Belt and braces.
    capiError = e instanceof Error ? e.message : String(e);
    console.error("[course-sales] CAPI failed:", capiError);
  }

  // Record the outcome so the partial index in the migration can find rows
  // that still owe Meta an event.
  const { error: markErr } = await admin
    .from("course_sales")
    .update({
      capi_sent_at: capiSent ? new Date().toISOString() : null,
      capi_error: capiError,
    })
    .eq("id", row.id);
  if (markErr) console.error("[course-sales] capi status update failed:", markErr.message);

  return NextResponse.json({ item: { ...row, capi_sent: capiSent } }, { status: 201 });
}
