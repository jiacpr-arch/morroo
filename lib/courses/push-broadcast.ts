import webpush from "web-push";
import { createAdminClient } from "@/lib/supabase/admin";
import type { NewsCourse } from "@/lib/courses/news";

// Ported from acls-emr's api/_lib/pushBroadcast.js. Sends a web-push
// notification for a freshly-inserted acls_news item to every active
// subscription (acls_push_subscriptions, renamed from push_subscriptions)
// matching the item's course.

// Same public key as lib/courses/push-client.ts's fallback — duplicated here
// (rather than imported) because that file is client-only and this one is
// server-only, mirroring how the source app duplicated DEFAULT_PUBLIC_KEY
// between src/config/push.js and api/_lib/pushBroadcast.js.
const DEFAULT_PUBLIC_KEY =
  "BH5zjcz8nBNK5ZdfLw4m3-0wTsRLS4I2tjTz-X1waylgkqW5h1iMpkd5wZbaoF6hdR0CWF2WLniS7zwFQA5lWVU";

let configured = false;
function configure(): boolean {
  if (configured) return true;
  const publicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY || DEFAULT_PUBLIC_KEY;
  const privateKey = process.env.VAPID_PRIVATE_KEY;
  const subject = process.env.VAPID_SUBJECT || "mailto:jiacpr@gmail.com";
  if (!privateKey) return false;
  webpush.setVapidDetails(subject, publicKey, privateKey);
  configured = true;
  return true;
}

export interface BroadcastNewsItemInput {
  id?: string;
  title: string;
  summary: string;
  source_url?: string | null;
  course: NewsCourse;
}

export interface BroadcastResult {
  sent: number;
  failed: number;
  disabled: number;
  skipped?: string;
}

interface SubscriptionRow {
  id: string;
  endpoint: string;
  p256dh: string;
  auth: string;
  failure_count: number | null;
}

// Sends to all active (disabled_at is null) subscriptions matching the
// item's course (course='both' -> all; course='acls'|'bls' -> that course
// plus 'both'). Returns { sent, failed, disabled }.
export async function broadcastNewsItem(
  item: BroadcastNewsItemInput,
): Promise<BroadcastResult> {
  if (!configure()) {
    return { sent: 0, failed: 0, disabled: 0, skipped: "VAPID_PRIVATE_KEY missing" };
  }

  const supabase = createAdminClient();
  const itemCourse: NewsCourse = item.course || "both";
  const courseFilter =
    itemCourse === "both" ? ["acls", "bls", "both"] : [itemCourse, "both"];

  const { data: subs, error } = await supabase
    .from("acls_push_subscriptions")
    .select("id, endpoint, p256dh, auth, failure_count")
    .is("disabled_at", null)
    .in("course", courseFilter);

  if (error || !subs?.length) {
    return { sent: 0, failed: 0, disabled: 0 };
  }

  const rows = subs as SubscriptionRow[];

  // Fallback url when the item has no source_url: morroo's own /news route is
  // an unrelated main-blog feature, so route into the course-specific news
  // page instead of the source's plain '/news'. 'both' items default to the
  // ACLS page (acls is the primary course).
  const fallbackUrl = itemCourse === "bls" ? "/bls/news" : "/acls/news";

  const payload = JSON.stringify({
    title: item.title.slice(0, 100),
    body: item.summary.slice(0, 240),
    url: item.source_url || fallbackUrl,
    tag: "news-" + (item.id || Date.now()),
  });

  const results = await Promise.allSettled(
    rows.map((s) =>
      webpush.sendNotification(
        { endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } },
        payload,
      ),
    ),
  );

  let sent = 0;
  let failed = 0;
  let disabled = 0;
  const toDisable: string[] = [];
  // Tracked to mirror the source, which collects failures that aren't a
  // 404/410 but never actually writes an incremented failure_count anywhere.
  const toIncrement: SubscriptionRow[] = [];

  for (let i = 0; i < results.length; i++) {
    const r = results[i];
    if (r.status === "fulfilled") {
      sent++;
      continue;
    }
    failed++;
    const status = (r.reason as { statusCode?: number } | undefined)?.statusCode;
    if (status === 404 || status === 410) {
      toDisable.push(rows[i].id);
      disabled++;
    } else {
      toIncrement.push(rows[i]);
    }
  }
  void toIncrement;

  if (toDisable.length) {
    await supabase
      .from("acls_push_subscriptions")
      .update({ disabled_at: new Date().toISOString() })
      .in("id", toDisable);
  }

  // Touch last_sent_at on successful ones (best-effort, batch).
  if (sent > 0) {
    const successIds = results
      .map((r, i) => (r.status === "fulfilled" ? rows[i].id : null))
      .filter((id): id is string => Boolean(id));
    await supabase
      .from("acls_push_subscriptions")
      .update({ last_sent_at: new Date().toISOString(), failure_count: 0 })
      .in("id", successIds);
  }

  return { sent, failed, disabled };
}
