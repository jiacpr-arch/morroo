/**
 * Stripe Customer Portal — ให้ลูกค้าดูประวัติการจ่ายเงิน
 * และจัดการ payment method ได้เอง
 *
 * POST /api/billing/portal
 * Returns: { url: string } — redirect URL to Stripe Customer Portal
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { stripe } from "@/lib/stripe";

export const runtime = "nodejs";

export async function POST() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
    }

    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

    // Find or create Stripe customer by email
    const customers = await stripe.customers.list({
      email: user.email,
      limit: 1,
    });

    let customerId: string;
    if (customers.data.length > 0) {
      customerId = customers.data[0].id;
    } else {
      const customer = await stripe.customers.create({
        email: user.email ?? undefined,
        metadata: { supabase_user_id: user.id },
      });
      customerId = customer.id;
    }

    const portalSession = await stripe.billingPortal.sessions.create({
      customer: customerId,
      return_url: `${siteUrl}/profile`,
    });

    return NextResponse.json({ url: portalSession.url });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[billing/portal] error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
