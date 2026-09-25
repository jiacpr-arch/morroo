"use client";

/**
 * Lapse survey + win-back offers (cancellation_feedback) and trial → paid
 * conversion. Data: GET /api/admin/winback?days=… — see lib/winback.ts.
 */

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, Loader2, Shield, UserMinus } from "lucide-react";
import {
  LAPSE_REASON_LABELS,
  isLapseReason,
  type FeedbackSummary,
  type TrialConversion,
} from "@/lib/winback";

interface RecentAnswer {
  created_at: string;
  reason: string;
  reason_detail: string;
  was_trial: boolean;
  last_plan: string | null;
  offer_response: string | null;
}

interface Payload {
  days: number;
  summary: FeedbackSummary;
  recent: RecentAnswer[];
  conversion: TrialConversion;
}

const PRESETS = [7, 30, 90, 365] as const;

const SOURCE_LABELS: Record<string, string> = {
  profile: "หน้าโปรไฟล์",
  expiry_line: "LINE D+1",
  expiry_email: "อีเมล D+1",
  direct: "เข้าตรง",
};

function Stat({ label, value, sub }: { label: string; value: string; sub?: string }) {
  return (
    <Card>
      <CardHeader className="pb-1">
        <CardTitle className="text-xs text-muted-foreground font-normal">{label}</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-2xl font-bold">{value}</p>
        {sub && <p className="text-xs text-muted-foreground mt-1">{sub}</p>}
      </CardContent>
    </Card>
  );
}

export default function AdminWinbackPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [days, setDays] = useState<(typeof PRESETS)[number]>(30);
  const [data, setData] = useState<Payload | null>(null);
  const [fetching, setFetching] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login?next=/admin/winback");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      setIsAdmin((profile as { role?: string } | null)?.role === "admin");
      setLoading(false);
    }
    init();
  }, [router]);

  useEffect(() => {
    if (!isAdmin) return;
    let cancelled = false;
    async function load() {
      setFetching(true);
      setError("");
      const res = await fetch(`/api/admin/winback?days=${days}`);
      const json = await res.json().catch(() => ({}));
      if (cancelled) return;
      if (!res.ok) setError(json.error ?? "โหลดข้อมูลไม่สำเร็จ");
      else setData(json as Payload);
      setFetching(false);
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [isAdmin, days]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  const s = data?.summary;
  const c = data?.conversion;
  const maxReason = Math.max(1, ...(s?.reasons.map((r) => r.count) ?? [1]));

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/admin"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า Admin
        </Link>
        <h1 className="text-2xl font-bold flex items-center gap-2">
          <UserMinus className="h-6 w-6 text-brand" />
          ไม่ต่ออายุ / Win-back
        </h1>
        <p className="text-muted-foreground text-sm mt-1">
          เหตุผลที่สมาชิกไม่ต่ออายุ (แพ็กจ่ายครั้งเดียว ไม่ auto-renew) · อัตรารับข้อเสนอ · trial → จ่ายเงิน
        </p>
      </div>

      <div className="mb-6 flex flex-wrap items-center gap-2">
        <span className="text-sm text-muted-foreground">ช่วงเวลา:</span>
        {PRESETS.map((d) => (
          <button
            key={d}
            onClick={() => setDays(d)}
            className={`text-sm px-3 py-1.5 rounded-lg ${
              days === d ? "bg-brand text-white" : "bg-muted text-muted-foreground hover:bg-muted/80"
            }`}
          >
            {d} วัน
          </button>
        ))}
        {fetching && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground ml-2" />}
      </div>

      {error && <p className="mb-4 text-sm text-red-600">{error}</p>}

      {c && (
        <>
          <h2 className="font-semibold mb-2">Trial → จ่ายเงิน</h2>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-8">
            <Stat label="เริ่ม trial" value={c.started.toLocaleString()} sub={`กำลังทดลอง ${c.running}`} />
            <Stat label="trial จบแล้ว" value={c.ended.toLocaleString()} />
            <Stat
              label="จ่ายเงินแล้ว"
              value={`${c.converted.toLocaleString()} (${c.rate}%)`}
              sub={`ภายใน trial + 7 วัน: ${c.convertedEarly}`}
            />
            <Stat
              label="มัธยฐานวันถึงจ่าย"
              value={c.medianDaysToPay == null ? "—" : `${c.medianDaysToPay} วัน`}
            />
          </div>
        </>
      )}

      {s && (
        <>
          <h2 className="font-semibold mb-2">ข้อเสนอ win-back</h2>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-8">
            <Stat label="ตอบแบบสอบถาม" value={s.total.toLocaleString()} sub={`เป็น trial ${s.trialShare}%`} />
            <Stat label="เสนอส่วนลด" value={s.offersShown.toLocaleString()} />
            <Stat
              label="กดรับข้อเสนอ"
              value={`${s.offersAccepted.toLocaleString()} (${s.acceptanceRate}%)`}
            />
            <Stat
              label="ใช้โค้ดจ่ายจริง"
              value={`${s.offersRedeemed.toLocaleString()} (${s.redemptionRate}%)`}
            />
          </div>

          <Card className="mb-6">
            <CardHeader>
              <CardTitle className="text-base">เหตุผลที่ไม่ต่ออายุ</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {s.total === 0 && <p className="text-sm text-muted-foreground">ยังไม่มีข้อมูลในช่วงนี้</p>}
              {s.total > 0 &&
                s.reasons.map((r) => (
                  <div key={r.reason} className="text-sm">
                    <div className="flex justify-between mb-0.5">
                      <span>{r.label}</span>
                      <span className="text-muted-foreground">
                        {r.count} ({r.pct}%)
                      </span>
                    </div>
                    <div className="h-2 rounded bg-muted">
                      <div
                        className="h-2 rounded bg-brand"
                        style={{ width: `${(r.count / maxReason) * 100}%` }}
                      />
                    </div>
                  </div>
                ))}
              {s.total > 0 && (
                <div className="flex flex-wrap gap-2 pt-3">
                  {Object.entries(s.bySource).map(([src, n]) => (
                    <Badge key={src} variant="secondary" className="text-xs">
                      {SOURCE_LABELS[src] ?? src}: {n}
                    </Badge>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </>
      )}

      {data && data.recent.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">ความเห็นล่าสุด</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-3">
              {data.recent.map((r, i) => (
                <li key={i} className="text-sm border-b pb-2 last:border-0">
                  <div className="flex flex-wrap items-center gap-2 text-xs text-muted-foreground mb-1">
                    <Badge variant="secondary" className="text-[10px]">
                      {isLapseReason(r.reason) ? LAPSE_REASON_LABELS[r.reason] : r.reason}
                    </Badge>
                    {r.was_trial && <Badge className="text-[10px] bg-amber-100 text-amber-700">trial</Badge>}
                    {r.last_plan && <span>{r.last_plan}</span>}
                    {r.offer_response && <span>· {r.offer_response === "accepted" ? "รับข้อเสนอ" : "ปฏิเสธ"}</span>}
                    <span>· {new Date(r.created_at).toLocaleDateString("th-TH")}</span>
                  </div>
                  <p className="whitespace-pre-wrap">{r.reason_detail}</p>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
