"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  Loader2,
  Eye,
  UserPlus,
  ShoppingCart,
  PlayCircle,
  TrendingUp,
  ExternalLink,
} from "lucide-react";

type EventRow = {
  event_name: string;
  session_id: string | null;
  path: string | null;
  referrer: string | null;
  created_at: string;
};

type Summary = {
  pageViews: number;
  uniqueVisitors: number;
  signups: number;
  examStarts: number;
  checkoutClicks: number;
  socialLineClicks: number;
  freeTrialCtaClicks: number;
  exitIntentShows: number;
  exitIntentCtaClicks: number;
  landingViews: { surface: string; count: number }[];
  topPaths: { path: string; count: number }[];
  topReferrers: { ref: string; count: number }[];
  signupConv: number | null;
  checkoutConv: number | null;
  ctaToSignupConv: number | null;
};

const RANGES = [
  { label: "24 ชม.", days: 1 },
  { label: "7 วัน", days: 7 },
  { label: "30 วัน", days: 30 },
] as const;

export default function AdminAnalyticsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [days, setDays] = useState<number>(7);
  const [summary, setSummary] = useState<Summary | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);

      const start = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();
      const { data } = await supabase
        .from("analytics_events")
        .select("event_name,session_id,path,referrer,created_at")
        .gte("created_at", start)
        .order("created_at", { ascending: false })
        .limit(50000);

      setSummary(aggregate((data as EventRow[] | null) ?? []));
      setLoading(false);
    }
    load();
  }, [router, days]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-12 text-center">
        <p className="text-muted-foreground">ไม่มีสิทธิ์เข้าถึงหน้านี้</p>
      </div>
    );
  }

  if (!summary) return null;

  return (
    <div className="max-w-6xl mx-auto px-4 py-8 space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <Link
            href="/admin"
            className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground mb-2"
          >
            <ArrowLeft className="h-4 w-4 mr-1" /> กลับ Admin
          </Link>
          <h1 className="text-2xl font-bold">Analytics</h1>
          <p className="text-sm text-muted-foreground">
            mirror จาก Vercel Web Analytics — funnel & conversion
          </p>
        </div>
        <div className="flex gap-2">
          {RANGES.map((r) => (
            <button
              key={r.days}
              onClick={() => setDays(r.days)}
              className={`px-3 py-1.5 rounded-md text-sm border transition-colors ${
                days === r.days
                  ? "bg-brand text-white border-brand"
                  : "bg-background hover:bg-muted"
              }`}
            >
              {r.label}
            </button>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Stat icon={<Eye />} label="Page views" value={summary.pageViews} />
        <Stat
          icon={<TrendingUp />}
          label="Unique visitors"
          value={summary.uniqueVisitors}
        />
        <Stat icon={<UserPlus />} label="Signups" value={summary.signups} />
        <Stat
          icon={<ShoppingCart />}
          label="Checkout clicks"
          value={summary.checkoutClicks}
        />
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Funnel conversion</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <FunnelRow
            from="Visitors"
            to="Signups"
            fromValue={summary.uniqueVisitors}
            toValue={summary.signups}
            conv={summary.signupConv}
          />
          <FunnelRow
            from="Signups"
            to="Checkout clicks"
            fromValue={summary.signups}
            toValue={summary.checkoutClicks}
            conv={summary.checkoutConv}
          />
          <FunnelRow
            from="Visitors"
            to="Exam starts"
            fromValue={summary.uniqueVisitors}
            toValue={summary.examStarts}
            conv={
              summary.uniqueVisitors > 0
                ? (summary.examStarts / summary.uniqueVisitors) * 100
                : null
            }
          />
          <FunnelRow
            from="Free-trial CTA clicks"
            to="Signups"
            fromValue={summary.freeTrialCtaClicks}
            toValue={summary.signups}
            conv={summary.ctaToSignupConv}
          />
          <FunnelRow
            from="Exit-intent popup shows"
            to="Exit-intent CTA clicks"
            fromValue={summary.exitIntentShows}
            toValue={summary.exitIntentCtaClicks}
            conv={
              summary.exitIntentShows > 0
                ? (summary.exitIntentCtaClicks / summary.exitIntentShows) * 100
                : null
            }
          />
        </CardContent>
      </Card>

      {summary.landingViews.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Landing page entries</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2">
              {summary.landingViews.map((l) => (
                <li
                  key={l.surface}
                  className="flex justify-between items-center text-sm border-b pb-1"
                >
                  <span className="font-mono text-xs">{l.surface}</span>
                  <Badge variant="secondary">{l.count.toLocaleString()}</Badge>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      )}

      <div className="grid md:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle className="text-base flex items-center gap-2">
              <PlayCircle className="h-4 w-4" /> Top pages
            </CardTitle>
          </CardHeader>
          <CardContent>
            {summary.topPaths.length === 0 ? (
              <p className="text-sm text-muted-foreground">ยังไม่มีข้อมูล</p>
            ) : (
              <ul className="space-y-2">
                {summary.topPaths.map((p) => (
                  <li
                    key={p.path}
                    className="flex justify-between items-center text-sm border-b pb-1"
                  >
                    <span className="truncate mr-2 font-mono text-xs">{p.path}</span>
                    <Badge variant="secondary">{p.count.toLocaleString()}</Badge>
                  </li>
                ))}
              </ul>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base flex items-center gap-2">
              <ExternalLink className="h-4 w-4" /> Top referrers
            </CardTitle>
          </CardHeader>
          <CardContent>
            {summary.topReferrers.length === 0 ? (
              <p className="text-sm text-muted-foreground">ยังไม่มีข้อมูล</p>
            ) : (
              <ul className="space-y-2">
                {summary.topReferrers.map((r) => (
                  <li
                    key={r.ref}
                    className="flex justify-between items-center text-sm border-b pb-1"
                  >
                    <span className="truncate mr-2">{r.ref}</span>
                    <Badge variant="secondary">{r.count.toLocaleString()}</Badge>
                  </li>
                ))}
              </ul>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function Stat({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: number;
}) {
  return (
    <Card>
      <CardContent className="pt-6">
        <div className="flex items-center gap-2 text-muted-foreground text-xs mb-1">
          <span className="h-4 w-4">{icon}</span>
          {label}
        </div>
        <div className="text-2xl font-bold">{value.toLocaleString()}</div>
      </CardContent>
    </Card>
  );
}

function FunnelRow({
  from,
  to,
  fromValue,
  toValue,
  conv,
}: {
  from: string;
  to: string;
  fromValue: number;
  toValue: number;
  conv: number | null;
}) {
  const pct = conv ?? 0;
  return (
    <div>
      <div className="flex justify-between text-sm mb-1">
        <span>
          {from} → {to}
        </span>
        <span className="font-mono">
          {toValue.toLocaleString()} / {fromValue.toLocaleString()}{" "}
          <span className="text-brand font-bold">
            {conv != null ? `${pct.toFixed(1)}%` : "—"}
          </span>
        </span>
      </div>
      <div className="h-2 bg-muted rounded-full overflow-hidden">
        <div
          className="h-full bg-brand transition-all"
          style={{ width: `${Math.min(pct, 100)}%` }}
        />
      </div>
    </div>
  );
}

// Landing-page entry events fired by components/LandingPageTracker. Mapping
// gives the dashboard a friendly surface label without hard-coding it in two
// places.
const LANDING_VIEW_EVENTS: Record<string, string> = {
  nl_practice_view: "nl_practice",
  longcase_view: "longcase",
  acls_reader_view: "acls_reader",
  exams_list_view: "exams",
  register_view: "register",
  payment_view: "payment",
  guide_view: "learn_guide",
};

function aggregate(rows: EventRow[]): Summary {
  let pageViews = 0;
  let signups = 0;
  let examStarts = 0;
  let checkoutClicks = 0;
  let socialLineClicks = 0;
  let freeTrialCtaClicks = 0;
  let exitIntentShows = 0;
  let exitIntentCtaClicks = 0;
  const sessions = new Set<string>();
  const pathCounts = new Map<string, number>();
  const refCounts = new Map<string, number>();
  const landingCounts = new Map<string, number>();

  for (const r of rows) {
    if (r.session_id) sessions.add(r.session_id);

    const landingSurface = LANDING_VIEW_EVENTS[r.event_name];
    if (landingSurface) {
      landingCounts.set(
        landingSurface,
        (landingCounts.get(landingSurface) ?? 0) + 1
      );
      continue;
    }

    switch (r.event_name) {
      case "pageview":
        pageViews++;
        if (r.path) pathCounts.set(r.path, (pathCounts.get(r.path) ?? 0) + 1);
        if (r.referrer) {
          const host = hostnameOf(r.referrer);
          if (host) refCounts.set(host, (refCounts.get(host) ?? 0) + 1);
        }
        break;
      case "signup_submit":
        signups++;
        break;
      case "exam_start_click":
        examStarts++;
        break;
      case "stripe_checkout_click":
        checkoutClicks++;
        break;
      case "social_click":
        socialLineClicks++;
        break;
      case "free_trial_cta_click":
        freeTrialCtaClicks++;
        break;
      case "exit_intent_show":
        exitIntentShows++;
        break;
      case "exit_intent_cta_click":
        exitIntentCtaClicks++;
        break;
    }
  }

  const toSorted = (m: Map<string, number>) =>
    Array.from(m.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10);

  return {
    pageViews,
    uniqueVisitors: sessions.size,
    signups,
    examStarts,
    checkoutClicks,
    socialLineClicks,
    freeTrialCtaClicks,
    exitIntentShows,
    exitIntentCtaClicks,
    landingViews: toSorted(landingCounts).map(([surface, count]) => ({
      surface,
      count,
    })),
    topPaths: toSorted(pathCounts).map(([path, count]) => ({ path, count })),
    topReferrers: toSorted(refCounts).map(([ref, count]) => ({ ref, count })),
    signupConv: sessions.size > 0 ? (signups / sessions.size) * 100 : null,
    checkoutConv: signups > 0 ? (checkoutClicks / signups) * 100 : null,
    ctaToSignupConv:
      freeTrialCtaClicks > 0 ? (signups / freeTrialCtaClicks) * 100 : null,
  };
}

function hostnameOf(url: string): string | null {
  try {
    return new URL(url).hostname.replace(/^www\./, "");
  } catch {
    return null;
  }
}
