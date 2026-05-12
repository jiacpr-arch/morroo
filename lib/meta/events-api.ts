import { createHash, randomUUID } from "node:crypto";

const PIXEL_ID = "966371002896288";
const API_VERSION = "v18.0";

type MetaEventName =
  | "PageView"
  | "ViewContent"
  | "Lead"
  | "CompleteRegistration"
  | "Subscribe"
  | "Purchase"
  | "InitiateCheckout"
  | "AddToCart";

export interface MetaEventInput {
  event: MetaEventName;
  eventId?: string;
  email?: string | null;
  phone?: string | null;
  externalId?: string | null;
  firstName?: string | null;
  lastName?: string | null;
  ip?: string | null;
  userAgent?: string | null;
  fbc?: string | null;
  fbp?: string | null;
  url?: string | null;
  value?: number;
  currency?: string;
  contentIds?: string[];
  contentName?: string;
  contentType?: string;
}

function sha256Lower(value: string): string {
  return createHash("sha256").update(value.trim().toLowerCase()).digest("hex");
}

export async function sendMetaEvent(input: MetaEventInput): Promise<void> {
  const token = process.env.META_CAPI_ACCESS_TOKEN;
  if (!token) return;

  const userData: Record<string, unknown> = {};
  if (input.email) userData.em = [sha256Lower(input.email)];
  if (input.phone) {
    const digits = input.phone.replace(/\D/g, "");
    if (digits) userData.ph = [sha256Lower(digits)];
  }
  if (input.firstName) userData.fn = [sha256Lower(input.firstName)];
  if (input.lastName) userData.ln = [sha256Lower(input.lastName)];
  if (input.externalId) userData.external_id = [sha256Lower(input.externalId)];
  if (input.ip) userData.client_ip_address = input.ip;
  if (input.userAgent) userData.client_user_agent = input.userAgent;
  if (input.fbc) userData.fbc = input.fbc;
  if (input.fbp) userData.fbp = input.fbp;

  const customData: Record<string, unknown> = {};
  if (input.value !== undefined) customData.value = input.value;
  if (input.currency) customData.currency = input.currency;
  if (input.contentIds?.length) customData.content_ids = input.contentIds;
  if (input.contentName) customData.content_name = input.contentName;
  if (input.contentType) customData.content_type = input.contentType;

  const eventData: Record<string, unknown> = {
    event_name: input.event,
    event_time: Math.floor(Date.now() / 1000),
    event_id: input.eventId ?? randomUUID(),
    action_source: "website",
    user_data: userData,
  };
  if (input.url) eventData.event_source_url = input.url;
  if (Object.keys(customData).length) eventData.custom_data = customData;

  const payload: Record<string, unknown> = { data: [eventData] };
  const testCode = process.env.META_CAPI_TEST_EVENT_CODE?.trim();
  if (testCode) payload.test_event_code = testCode;

  const endpoint = `https://graph.facebook.com/${API_VERSION}/${PIXEL_ID}/events?access_token=${encodeURIComponent(token)}`;

  try {
    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      console.error(
        `[meta-capi] ${input.event} failed: ${res.status} ${text.slice(0, 200)}`
      );
    }
  } catch (err) {
    console.error(`[meta-capi] ${input.event} fetch error:`, err);
  }
}
