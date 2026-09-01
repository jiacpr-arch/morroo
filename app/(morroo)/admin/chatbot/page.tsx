import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { MessageCircle, Users, ArrowLeft, Globe, Smartphone } from "lucide-react";

function FacebookIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z" />
    </svg>
  );
}
import type { Metadata } from "next";

export const metadata: Metadata = { title: "Chatbot Analytics | Admin" };
export const revalidate = 0; // always fresh

type Channel = "web" | "line" | "facebook";

const CHANNEL_META: Record<Channel, { label: string; color: string; bg: string; icon: React.ReactNode }> = {
  web:      { label: "Web",      color: "text-teal-700",  bg: "bg-teal-50",   icon: <Globe className="h-5 w-5 text-teal-600" /> },
  line:     { label: "LINE",     color: "text-green-700", bg: "bg-green-50",  icon: <Smartphone className="h-5 w-5 text-green-600" /> },
  facebook: { label: "Facebook", color: "text-blue-700",  bg: "bg-blue-50",   icon: <FacebookIcon className="h-5 w-5 text-blue-600" /> },
};

function fmt(n: number) {
  return n.toLocaleString("th-TH");
}

function dayKey(iso: string) {
  return iso.slice(0, 10); // "YYYY-MM-DD"
}

function last7Keys(): string[] {
  return Array.from({ length: 7 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (6 - i));
    return d.toISOString().slice(0, 10);
  });
}

export default async function ChatbotAnalyticsPage() {
  // Auth check
  const ssrClient = await createClient();
  const { data: { user } } = await ssrClient.auth.getUser();
  if (!user) redirect("/login");

  const admin = createAdminClient();

  const { data: profile } = await admin
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if (profile?.role !== "admin") redirect("/admin");

  // ── Fetch stats in parallel ─────────────────────────────────────────────────
  const since7d = new Date(Date.now() - 7 * 86_400_000).toISOString();

  const [
    webMsgRes, lineMsgRes, fbMsgRes,
    webUserRes, lineUserRes, fbUserRes,
    recentRes, trendRes,
    webTodayRes, lineTodayRes, fbTodayRes,
  ] = await Promise.all([
    // Total user messages per channel (all time)
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "web").eq("role", "user"),
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "line").eq("role", "user"),
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "facebook").eq("role", "user"),
    // Unique users per channel
    admin.from("chat_messages").select("channel_user_id").eq("channel", "web").eq("role", "user"),
    admin.from("chat_messages").select("channel_user_id").eq("channel", "line").eq("role", "user"),
    admin.from("chat_messages").select("channel_user_id").eq("channel", "facebook").eq("role", "user"),
    // Recent messages (all channels)
    admin.from("chat_messages")
      .select("channel, role, content, created_at, channel_user_id")
      .order("created_at", { ascending: false })
      .limit(20),
    // Last 7 days messages for chart
    admin.from("chat_messages")
      .select("channel, created_at")
      .eq("role", "user")
      .gte("created_at", since7d),
    // Today's messages
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "web").eq("role", "user").gte("created_at", new Date().toISOString().slice(0, 10)),
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "line").eq("role", "user").gte("created_at", new Date().toISOString().slice(0, 10)),
    admin.from("chat_messages").select("id", { count: "exact", head: true }).eq("channel", "facebook").eq("role", "user").gte("created_at", new Date().toISOString().slice(0, 10)),
  ]);

  const totalByChannel: Record<Channel, number> = {
    web:      webMsgRes.count ?? 0,
    line:     lineMsgRes.count ?? 0,
    facebook: fbMsgRes.count ?? 0,
  };

  const uniqueUsers: Record<Channel, number> = {
    web:      new Set((webUserRes.data ?? []).map((r) => r.channel_user_id)).size,
    line:     new Set((lineUserRes.data ?? []).map((r) => r.channel_user_id)).size,
    facebook: new Set((fbUserRes.data ?? []).map((r) => r.channel_user_id)).size,
  };

  const todayByChannel: Record<Channel, number> = {
    web:      webTodayRes.count ?? 0,
    line:     lineTodayRes.count ?? 0,
    facebook: fbTodayRes.count ?? 0,
  };

  // Build 7-day trend table
  const days = last7Keys();
  type DayRow = Record<Channel, number> & { date: string };
  const trendMap: Record<string, DayRow> = Object.fromEntries(
    days.map((d) => [d, { date: d, web: 0, line: 0, facebook: 0 }])
  );
  for (const row of trendRes.data ?? []) {
    const d = dayKey(row.created_at as string);
    if (trendMap[d]) {
      trendMap[d][row.channel as Channel]++;
    }
  }
  const trendRows = days.map((d) => trendMap[d]);
  const maxDay = Math.max(1, ...trendRows.map((r) => r.web + r.line + r.facebook));

  const totalAll = totalByChannel.web + totalByChannel.line + totalByChannel.facebook;
  const recent = recentRes.data ?? [];

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-8 flex items-center gap-4">
        <Link href="/admin" className="text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-5 w-5" />
        </Link>
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <MessageCircle className="h-6 w-6 text-teal-600" /> Chatbot Analytics
          </h1>
          <p className="text-sm text-muted-foreground mt-0.5">สถิติพี่หมอรู้ทุก channel</p>
        </div>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <p className="text-3xl font-bold">{fmt(totalAll)}</p>
            <p className="text-sm text-muted-foreground">ข้อความทั้งหมด</p>
          </CardContent>
        </Card>
        {(["web", "line", "facebook"] as Channel[]).map((ch) => {
          const meta = CHANNEL_META[ch];
          return (
            <Card key={ch}>
              <CardContent className="pt-6">
                <div className="flex items-center gap-2 mb-1">{meta.icon}<span className="text-xs font-medium text-muted-foreground">{meta.label}</span></div>
                <p className="text-2xl font-bold">{fmt(totalByChannel[ch])}</p>
                <p className="text-xs text-muted-foreground">{fmt(uniqueUsers[ch])} users · วันนี้ {todayByChannel[ch]}</p>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* 7-day trend */}
      <Card className="mb-8">
        <CardHeader>
          <CardTitle className="text-base">ข้อความ 7 วันล่าสุด</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-2">
            {trendRows.map((row) => {
              const total = row.web + row.line + row.facebook;
              const pct = Math.round((total / maxDay) * 100);
              const d = new Date(row.date + "T00:00:00");
              const label = d.toLocaleDateString("th-TH", { weekday: "short", day: "numeric", month: "short" });
              return (
                <div key={row.date} className="flex items-center gap-3 text-sm">
                  <span className="w-28 shrink-0 text-muted-foreground text-xs">{label}</span>
                  <div className="flex-1 flex rounded-full overflow-hidden h-5 bg-muted/40">
                    {row.web > 0 && (
                      <div
                        className="bg-teal-500 flex items-center justify-center text-[10px] text-white font-medium"
                        style={{ width: `${Math.round((row.web / maxDay) * 100)}%` }}
                      >{row.web > 2 ? row.web : ""}</div>
                    )}
                    {row.line > 0 && (
                      <div
                        className="bg-green-500 flex items-center justify-center text-[10px] text-white font-medium"
                        style={{ width: `${Math.round((row.line / maxDay) * 100)}%` }}
                      >{row.line > 2 ? row.line : ""}</div>
                    )}
                    {row.facebook > 0 && (
                      <div
                        className="bg-blue-500 flex items-center justify-center text-[10px] text-white font-medium"
                        style={{ width: `${Math.round((row.facebook / maxDay) * 100)}%` }}
                      >{row.facebook > 2 ? row.facebook : ""}</div>
                    )}
                    {total === 0 && <div className="w-full" />}
                  </div>
                  <span className="w-8 text-right text-xs font-medium">{total || "–"}</span>
                </div>
              );
            })}
          </div>
          {/* Legend */}
          <div className="flex gap-4 mt-4 text-xs text-muted-foreground">
            <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-sm bg-teal-500" />Web</span>
            <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-sm bg-green-500" />LINE</span>
            <span className="flex items-center gap-1"><span className="h-2.5 w-2.5 rounded-sm bg-blue-500" />Facebook</span>
          </div>
        </CardContent>
      </Card>

      {/* Channel breakdown */}
      <Card className="mb-8">
        <CardHeader>
          <CardTitle className="text-base">สัดส่วน channel</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {(["web", "line", "facebook"] as Channel[]).map((ch) => {
              const pct = totalAll > 0 ? Math.round((totalByChannel[ch] / totalAll) * 100) : 0;
              const meta = CHANNEL_META[ch];
              return (
                <div key={ch} className="space-y-1">
                  <div className="flex justify-between text-sm">
                    <span className="flex items-center gap-2">{meta.icon}<span className={`font-medium ${meta.color}`}>{meta.label}</span></span>
                    <span className="text-muted-foreground">{fmt(totalByChannel[ch])} ข้อความ · {fmt(uniqueUsers[ch])} users ({pct}%)</span>
                  </div>
                  <div className="h-2 rounded-full bg-muted/40 overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all ${ch === "web" ? "bg-teal-500" : ch === "line" ? "bg-green-500" : "bg-blue-500"}`}
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* Recent messages */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">ข้อความล่าสุด</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <div className="divide-y divide-border">
            {recent.map((msg, i) => {
              const ch = msg.channel as Channel;
              const meta = CHANNEL_META[ch];
              const isUser = msg.role === "user";
              const ts = new Date(msg.created_at as string).toLocaleString("th-TH", {
                day: "numeric", month: "short", hour: "2-digit", minute: "2-digit",
              });
              return (
                <div key={i} className="flex gap-3 px-4 py-3 hover:bg-muted/30">
                  <div className={`mt-0.5 shrink-0 h-7 w-7 rounded-full flex items-center justify-center ${meta.bg}`}>
                    {meta.icon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-0.5">
                      <Badge variant="outline" className={`text-[10px] py-0 ${meta.color}`}>{meta.label}</Badge>
                      <Badge variant={isUser ? "default" : "secondary"} className="text-[10px] py-0">
                        {isUser ? "user" : "bot"}
                      </Badge>
                      <span className="text-[10px] text-muted-foreground ml-auto">{ts}</span>
                    </div>
                    <p className="text-sm text-foreground line-clamp-2 leading-snug">
                      {(msg.content as string) || "–"}
                    </p>
                  </div>
                </div>
              );
            })}
            {recent.length === 0 && (
              <p className="px-4 py-8 text-center text-sm text-muted-foreground">ยังไม่มีข้อความ</p>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
