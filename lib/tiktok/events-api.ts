import { createHash, randomUUID } from "node:crypto";

const PIXEL_ID = process.env.TIKTOK_PIXEL_ID ?? "D80UTR3C77UEO91IVCV0";
const ENDPOINT = "https://business-api.tiktok.com/open_api/v1.3/event/track/";

type TikTokEventName =
  | "ViewContent"
  | "ClickButton"
  | "Lead"
  | "CompleteRegistration"
  | "Subscribe"
  | "Purchase"
  | "InitiateCheckout";

export interface TikTokEventInput {
  event: TikTokEventName;
  eventId?: string;
  email?: string | null;
  phone?: string | null;
  externalId?: string | null;
  ip?: string | null;
  userAgent?: string | null;
  ttclid?: string | null;
  ttp?: string | null;
  url?: string | null;
  value?: number;
  currency?: string;
  contentId?: string;
  contentName?: string;
  contentType?: string;
}

function sha256Lower(value: string): string {
  return createHash("sha256").update(value.trim().toLowerCase()).digest("hex");
}

function sha256(value: string): string {
  return createHash("sha256").update(value.trim()).digest("hex");
}

export async function sendTikTokEvent(input: TikTokEventInput): Promise<void> {
  const token = process.env.TIKTOK_EVENTS_API_TOKEN ?? process.env.TIKTOK_ACCESS_TOKEN;
  if (!token) return;

  const user: Record<string, string> = {};
  if (input.email) user.email = sha256Lower(input.email);
  if (input.phone) user.phone = sha256(input.phone);
  if (input.externalId) user.external_id = sha256(input.externalId);
  if (input.ip) user.ip = input.ip;
  if (input.userAgent) user.user_agent = input.userAgent;
  if (input.ttclid) user.ttclid = input.ttclid;
  if (input.ttp) user.ttp = input.ttp;

  const properties: Record<string, unknown> = {};
  if (input.value !== undefined) properties.value = input.value;
  if (input.currency) properties.currency = input.currency;
  if (input.contentId) properties.content_id = input.contentId;
  if (input.contentName) properties.content_name = input.contentName;
  if (input.contentType) properties.content_type = input.contentType;

  const body = {
    event_source: "web",
    event_source_id: PIXEL_ID,
    data: [
      {
        event: input.event,
        event_time: Math.floor(Date.now() / 1000),
        event_id: input.eventId ?? randomUUID(),
        user,
        properties,
        ...(input.url ? { page: { url: input.url } } : {}),
      },
    ],
  };

  try {
    const res = await fetch(ENDPOINT, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Access-Token": token,
      },
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      console.error(
        `[tiktok-events] ${input.event} failed: ${res.status} ${text.slice(0, 200)}`
      );
    }
  } catch (err) {
    console.error(`[tiktok-events] ${input.event} fetch error:`, err);
  }
}
