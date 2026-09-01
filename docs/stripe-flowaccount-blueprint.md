# Stripe + FlowAccount Self-Healing Checkout Blueprint

## Overview

ระบบชำระเงินผ่าน Stripe พร้อม 3 เส้นทาง defense-in-depth เพื่อ guarantee ว่าลูกค้าจะได้รับสิทธิ์ + ออกบิล + แจ้งเตือนเสมอ ไม่ว่า webhook จะล้มหรือลูกค้าปิดเบราว์เซอร์

## Architecture

```
                    Stripe ตัดเงิน
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
    1. Webhook      2. Success Page   3. Daily Cron
    (primary)       (fallback)        (safety net)
         │               │               │
         └───────┬───────┘               │
                 ▼                       ▼
         fulfillCheckoutSession()  ←── same idempotent helper
         (keyed on stripe_session_id)
                 │
    ┌────────────┼────────────┬──────────────┐
    ▼            ▼            ▼              ▼
 DB writes    LINE/Email   FlowAccount    Admin Email
 (inline)     (after())    (after())      (after())
```

## 3 Fulfillment Paths

| # | Path | Trigger | Covers |
|---|---|---|---|
| 1 | **Webhook** | Stripe sends `checkout.session.completed` | Normal case, works even if user closes browser |
| 2 | **Success page verify** | User lands on `/payment/success?session_id=...` | Webhook failed but user returned to success page |
| 3 | **Reconcile cron** | Daily at 03:00 UTC | User closed browser AND webhook failed |

All 3 paths call the same `fulfillCheckoutSession()` helper — **idempotent** keyed on `payment_orders.stripe_session_id`. No duplicate invoices/notifications possible.

## Files to Create

### 1. `lib/billing/fulfill-checkout.ts` — Idempotent Fulfillment Helper

```typescript
import type Stripe from "stripe";
import { createAdminClient } from "@/lib/supabase/admin";

export interface FulfillmentResult {
  alreadyProcessed: boolean;
  notify?: {
    sessionId: string;
    userId: string;
    planType: string;
    planLabel: string;
    totalAmount: number;
    amountBeforeVat: number;
    vatAmount: number;
    invoiceNumber: string;
    orderId: string | null;
    publishedOn: string;
    expiresAt: Date;
    invoiceName: string;
    invoiceTaxId: string;
    invoiceAddress: string;
    invoiceEmail: string;
    buyerLineUserId: string | null;
    referrerLineUserId: string | null;
    referrerRewardDays: number;
  };
}

export async function fulfillCheckoutSession(
  session: Stripe.Checkout.Session
): Promise<FulfillmentResult> {
  const metadata = session.metadata ?? {};
  const userId = metadata.userId;
  const planType = metadata.planType;
  // ... extract other metadata fields

  if (!userId || !planType) {
    console.error("[fulfill] missing metadata on session:", session.id);
    return { alreadyProcessed: false };
  }

  const supabase = createAdminClient();

  // ★ IDEMPOTENCY GUARD — key design principle
  const { data: existingOrder } = await supabase
    .from("payment_orders")
    .select("id")
    .eq("stripe_session_id", session.id)
    .maybeSingle();

  if (existingOrder) {
    return { alreadyProcessed: true };
  }

  // ... update profile membership (inline, must complete)
  // ... create payment_order (inline)
  // ... create invoice record (inline)
  // ... handle referral reward (inline)
  // ... fetch LINE user IDs for notifications

  return {
    alreadyProcessed: false,
    notify: { /* all data needed for post-response notifications */ },
  };
}
```

### 2. `lib/billing/send-fulfillment-notifications.ts` — Post-Response Side Effects

```typescript
import { sendLineMessage } from "@/lib/line";
import { createCashInvoice } from "@/lib/flowaccount";
import { lineNotifyNewOrder, emailReceipt, emailNotifyAdmin } from "@/lib/notifications";

export async function sendFulfillmentNotifications(data: NotifyPayload): Promise<void> {
  // Each integration in its own try/catch — one failing won't break others

  // 1. LINE notify referrer (if applicable)
  // 2. LINE notify buyer
  // 3. LINE admin group + email admin + email receipt to buyer (parallel)
  // 4. FlowAccount invoice
}
```

### 3. `app/api/billing/webhook/route.ts` — Stripe Webhook

```typescript
import { NextRequest, NextResponse, after } from "next/server";
import Stripe from "stripe";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";

// ★ LAZY INIT — never instantiate Stripe at module load
// Stripe v21 throws if API key is missing at construction.
// Next.js imports every route module at build time.
// If build env doesn't have STRIPE_SECRET_KEY, eager init crashes the entire deploy.
let _stripe: Stripe | null = null;
function getStripe(): Stripe {
  if (!_stripe) _stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
  return _stripe;
}

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  let event: Stripe.Event;
  try {
    event = getStripe().webhooks.constructEvent(
      body, signature, (process.env.STRIPE_WEBHOOK_SECRET ?? "").trim()
    );
  } catch (err) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 400 });
  }

  // ★ GUARANTEE 200 — always ack after valid signature
  // Processing failures are logged, not propagated to Stripe
  try {
    if (event.type === "checkout.session.completed") {
      const result = await fulfillCheckoutSession(event.data.object as Stripe.Checkout.Session);
      if (result.notify) {
        // ★ after() — runs AFTER response is sent to Stripe
        const notify = result.notify;
        after(() => sendFulfillmentNotifications(notify));
      }
    }
  } catch (err) {
    console.error("[webhook] handler error:", err);
  }

  return NextResponse.json({ received: true }, { status: 200 });
}
```

### 4. `app/api/billing/verify/route.ts` — Success Page Fallback

```typescript
import { NextRequest, NextResponse, after } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { stripe } from "@/lib/stripe";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  // 1. Auth check — must be logged in
  // 2. Extract sessionId from body
  // 3. Fetch session from Stripe (source of truth)
  // 4. Verify session.metadata.userId === logged-in user (prevent abuse)
  // 5. Only fulfill if payment_status === "paid"
  // 6. Call fulfillCheckoutSession() (idempotent — no-op if webhook already ran)
  // 7. Schedule notifications via after() if newly fulfilled
  // 8. Return { status: "ok", alreadyProcessed: true/false }
}
```

### 5. `app/api/billing/reconcile/route.ts` — Daily Cron Safety Net

```typescript
import { NextResponse } from "next/server";
import { stripe } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";
export const maxDuration = 60; // Vercel Hobby max

const LOOKBACK_SECONDS = 2 * 24 * 60 * 60; // 2 days
const MAX_SESSIONS_PER_RUN = 100;

// Auth: query string ?secret=$BLOG_GENERATE_SECRET
//    OR: Authorization: Bearer $CRON_SECRET (Vercel Cron auto-injects)

// Logic:
// 1. List Stripe checkout sessions from last 2 days
// 2. For each paid session, check if payment_orders row exists
// 3. If missing → call fulfillCheckoutSession() + sendFulfillmentNotifications()
// 4. Return summary JSON { scanned, paid, alreadyProcessed, recovered, errors }

// Supports both GET (Vercel Cron) and POST (external cron)
export async function GET(request: Request) { return runReconciliation(request); }
export async function POST(request: Request) { return runReconciliation(request); }
```

### 6. `app/payment/success/SuccessContent.tsx` — Auto-Verify on Mount

```tsx
"use client";
import { useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";

type VerifyStatus = "verifying" | "ok" | "pending" | "error";

export default function SuccessContent() {
  const sessionId = useSearchParams().get("session_id");
  const [status, setStatus] = useState<VerifyStatus>(() =>
    sessionId ? "verifying" : "ok"
  );

  useEffect(() => {
    if (!sessionId) return;
    // POST /api/billing/verify with { sessionId }
    // On success → setStatus("ok")
    // On pending → setStatus("pending") + show refresh button
    // On error → setStatus("error") + show retry + support contact
  }, [sessionId]);

  // Render 4 states: verifying / ok / pending / error
}
```

### 7. `vercel.json` — Cron Schedule

```json
{
  "crons": [
    {
      "path": "/api/billing/reconcile",
      "schedule": "0 3 * * *"
    }
  ]
}
```

## Key Design Principles

### 1. Idempotent Fulfillment
- Key on `payment_orders.stripe_session_id`
- SELECT before INSERT — if exists, return `{ alreadyProcessed: true }`
- All 3 paths can fire for the same session without duplicate side effects

### 2. Webhook Always Returns 200
- Signature invalid → 400 (only case for non-200)
- Processing error → log + return 200 (prevents Stripe infinite retry)
- Slow third-party API → doesn't affect response (runs in `after()`)

### 3. `after()` for Side Effects (Next.js 15.1+)
- LINE, email, FlowAccount run AFTER response is sent
- Each wrapped in its own try/catch
- One failing doesn't affect others

### 4. Lazy Stripe Initialization
- NEVER `const stripe = new Stripe(key)` at module top-level
- Use lazy getter function or Proxy pattern
- Stripe v21 throws at construction if key is missing
- Next.js imports all route modules at build time → missing env = build crash

### 5. Separate DB Writes from Notifications
- Critical: profile update, payment_order, invoice → inline, must complete
- Non-critical: LINE, email, FlowAccount → `after()`, can fail independently

## Notification Channels

| Who | Channel | Content |
|---|---|---|
| **Admin** | LINE group | 🛒 ออเดอร์ใหม่ — plan, amount, email, invoice# |
| **Admin** | Email (`ADMIN_EMAIL`) | Same info + links to Stripe Dashboard & Admin |
| **Buyer** | LINE (personal) | ✅ ชำระเงินสำเร็จ + expiry date + invoice request link |
| **Buyer** | Email | ใบเสร็จรับเงิน HTML |
| **Referrer** | LINE (personal) | 🎉 เพื่อนสมัครแล้ว + reward days |

## Environment Variables Required

```bash
# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# LINE Messaging API
LINE_CHANNEL_ACCESS_TOKEN=...
LINE_CHANNEL_TOKEN=...      # for admin group push
LINE_TARGET_ID=...           # admin group ID
LINE_CHANNEL_SECRET=...

# Email (Resend)
RESEND_API_KEY=re_...
MAIL_FROM=noreply@yourdomain.com
ADMIN_EMAIL=admin@yourdomain.com  # comma-separated for multiple

# FlowAccount
FLOWACCOUNT_TOKEN_URL=...
FLOWACCOUNT_BASE_URL=...
FLOWACCOUNT_CLIENT_ID=...
FLOWACCOUNT_CLIENT_SECRET=...

# Cron
BLOG_GENERATE_SECRET=...    # shared secret for cron endpoints
CRON_SECRET=...              # Vercel Cron auto-injects Bearer header
```

## Database Schema (Supabase)

```sql
-- payment_orders — one row per successful checkout
CREATE TABLE payment_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  plan_type text NOT NULL,
  amount numeric NOT NULL,
  status text DEFAULT 'pending',
  payment_method text DEFAULT 'stripe',
  stripe_session_id text,        -- ★ idempotency key
  created_at timestamptz DEFAULT now()
);

-- invoices — tax invoice records
CREATE TABLE invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number text NOT NULL UNIQUE,  -- INV-YYYY-NNNN
  user_id uuid REFERENCES auth.users NOT NULL,
  order_id uuid REFERENCES payment_orders,
  stripe_session_id text,
  plan_type text NOT NULL,
  amount numeric NOT NULL,        -- before VAT
  vat_amount numeric DEFAULT 0,
  total_amount numeric NOT NULL,
  buyer_name text,
  buyer_tax_id text,
  buyer_email text,
  status text DEFAULT 'paid',
  created_at timestamptz DEFAULT now()
);

-- profiles — add membership columns
ALTER TABLE profiles ADD COLUMN membership_type text DEFAULT 'free';
ALTER TABLE profiles ADD COLUMN membership_expires_at timestamptz;
```

## Middleware/Proxy Config

Exclude webhook from auth middleware (Next.js 16 uses `proxy.ts`):

```typescript
export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|api/billing/webhook|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
```

## Checkout Flow (API)

```typescript
// POST /api/billing/checkout
const session = await stripe.checkout.sessions.create({
  mode: "payment",
  customer_email: user.email,
  line_items: [{ price_data: { currency: "thb", unit_amount: plan.amount * 100, product_data: { name: plan.name } }, quantity: 1 }],
  success_url: `${siteUrl}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${siteUrl}/payment/${planType}`,
  metadata: {
    userId: user.id,
    planType,
    invoiceName: invoiceData?.name ?? "",
    invoiceTaxId: invoiceData?.taxId ?? "",
    invoiceAddress: invoiceData?.address ?? "",
    invoiceEmail: user.email ?? "",
  },
});
```

## Smoke Test Commands

```bash
# 1. Webhook — missing signature
curl -X POST https://yourdomain.com/api/billing/webhook
# Expected: 400 {"error":"Missing stripe-signature"}

# 2. Verify — unauthenticated
curl -X POST https://yourdomain.com/api/billing/verify -H "Content-Type: application/json" -d '{}'
# Expected: 401 {"error":"unauthenticated"}

# 3. Reconcile — unauthorized
curl https://yourdomain.com/api/billing/reconcile
# Expected: 401 {"error":"Unauthorized"}

# 4. Reconcile — authorized
curl "https://yourdomain.com/api/billing/reconcile?secret=$BLOG_GENERATE_SECRET"
# Expected: 200 {"ok":true,"summary":{...}}
```

## Adapting for Other Projects

1. Replace `profiles` table with your user/membership table
2. Replace FlowAccount with your invoicing system (or remove)
3. Replace LINE with Slack/Discord/Telegram (or remove)
4. Adjust plan types and pricing in `STRIPE_PLANS`
5. Adjust VAT calculation (7% for Thailand)
6. Keep the 3-path architecture and idempotency pattern — these are universal
