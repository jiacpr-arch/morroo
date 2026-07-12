"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import {
  Activity, ChevronLeft, Loader2, Pencil, Plus, Shield, Trophy, Users,
} from "lucide-react";

interface ScenarioRow {
  id: string;
  slug: string;
  title: string;
  subtitle: string | null;
  difficulty_tag: string | null;
  status: "draft" | "published" | "archived";
  source: "manual" | "ai";
  updated_at: string;
}

interface Stats {
  totalRuns: number;
  uniquePlayers: number;
  winRate: number;
  gradeDist: Record<string, number>;
  perScenario: {
    slug: string;
    title: string;
    runs: number;
    winRate: number;
    avgTimeToCprSec: number | null;
    avgTimeToShockSec: number | null;
  }[];
}

const STATUS_LABEL: Record<ScenarioRow["status"], string> = {
  draft: "draft",
  published: "published",
  archived: "archived",
};
const STATUS_COLOR: Record<ScenarioRow["status"], string> = {
  draft: "bg-amber-100 text-amber-700",
  published: "bg-emerald-100 text-emerald-700",
  archived: "bg-muted text-muted-foreground",
};

const FILTERS = ["all", "draft", "published", "archived"] as const;

export default function AdminSimPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [rows, setRows] = useState<ScenarioRow[]>([]);
  const [stats, setStats] = useState<Stats | null>(null);
  const [filter, setFilter] = useState<(typeof FILTERS)[number]>("all");
  const [busy, setBusy] = useState<string | null>(null);

  async function load(f: (typeof FILTERS)[number]) {
    const qs = f === "all" ? "" : `?status=${f}`;
    const res = await fetch(`/api/admin/sim${qs}`);
    if (!res.ok) return;
    const json = await res.json();
    setRows(json.scenarios ?? []);
  }

  async function loadStats() {
    const res = await fetch("/api/admin/sim/stats");
    if (!res.ok) return;
    setStats(await res.json());
  }

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
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
      await Promise.all([load("all"), loadStats()]);
      setLoading(false);
    }
    init();
  }, [router]);

  async function changeFilter(f: (typeof FILTERS)[number]) {
    setFilter(f);
    await load(f);
  }

  async function toggleStatus(row: ScenarioRow) {
    const next = row.status === "published" ? "draft" : "published";
    setBusy(row.id);
    await fetch(`/api/admin/sim/${row.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: next }),
    });
    await load(filter);
    setBusy(null);
  }

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="mx-auto mb-4 h-12 w-12 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <Link
        href="/admin"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับ Dashboard
      </Link>

      <div className="mb-6 flex flex-wrap items-center justify-between gap-2">
        <h1 className="text-2xl font-bold">Code Blue Sim — จัดการเคส</h1>
        <div className="flex gap-2">
          <Link href="/admin/sim/characters">
            <Button variant="outline" className="gap-2"><Users className="h-4 w-4" /> ตัวละคร</Button>
          </Link>
          <Link href="/admin/sim/new">
            <Button className="gap-2"><Plus className="h-4 w-4" /> สร้างเคสใหม่</Button>
          </Link>
        </div>
      </div>

      {/* สถิติรวม */}
      {stats && (
        <>
          <div className="mb-4 grid grid-cols-2 gap-3 sm:grid-cols-4">
            <StatCard icon={<Activity className="h-4 w-4 text-brand" />} label="จำนวนรอบเล่น" value={String(stats.totalRuns)} />
            <StatCard icon={<Users className="h-4 w-4 text-brand" />} label="ผู้เล่น" value={String(stats.uniquePlayers)} />
            <StatCard icon={<Trophy className="h-4 w-4 text-amber-600" />} label="อัตรารอด (ROSC)" value={`${stats.winRate}%`} />
            <StatCard
              icon={<Trophy className="h-4 w-4 text-brand" />}
              label="เกรด S/A/B/C"
              value={`${stats.gradeDist.S}/${stats.gradeDist.A}/${stats.gradeDist.B}/${stats.gradeDist.C}`}
            />
          </div>
          {stats.perScenario.length > 0 && (
            <Card className="mb-8">
              <CardContent className="overflow-x-auto p-4">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b text-left text-muted-foreground">
                      <th className="py-2 pr-3 font-medium">เคส</th>
                      <th className="py-2 pr-3 font-medium">รอบ</th>
                      <th className="py-2 pr-3 font-medium">รอด</th>
                      <th className="py-2 pr-3 font-medium">เฉลี่ยถึง CPR</th>
                      <th className="py-2 font-medium">เฉลี่ยถึง Shock</th>
                    </tr>
                  </thead>
                  <tbody>
                    {stats.perScenario.map((s) => (
                      <tr key={s.slug} className="border-b last:border-0">
                        <td className="py-2 pr-3">{s.title}</td>
                        <td className="py-2 pr-3">{s.runs}</td>
                        <td className="py-2 pr-3">{s.winRate}%</td>
                        <td className="py-2 pr-3">{s.avgTimeToCprSec != null ? `${s.avgTimeToCprSec}s` : "—"}</td>
                        <td className="py-2">{s.avgTimeToShockSec != null ? `${s.avgTimeToShockSec}s` : "—"}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </CardContent>
            </Card>
          )}
        </>
      )}

      {/* ฟิลเตอร์สถานะ */}
      <div className="mb-4 flex gap-2">
        {FILTERS.map((f) => (
          <Button
            key={f}
            size="sm"
            variant={filter === f ? "default" : "outline"}
            onClick={() => changeFilter(f)}
          >
            {f === "all" ? "ทั้งหมด" : f}
          </Button>
        ))}
      </div>

      {/* ลิสต์เคส (เฉพาะเคสใน DB — เคส built-in แก้ในโค้ด) */}
      {rows.length === 0 ? (
        <Card>
          <CardContent className="p-8 text-center text-muted-foreground">
            ยังไม่มีเคสใน DB — เคส built-in (vf-arrest-01) อยู่ในโค้ด · กด &quot;สร้างเคสใหม่&quot; เพื่อเริ่ม
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {rows.map((row) => (
            <Card key={row.id}>
              <CardContent className="flex flex-col gap-3 p-4 sm:flex-row sm:items-center">
                <div className="flex-1">
                  <div className="mb-1 flex flex-wrap items-center gap-2">
                    <Badge className={STATUS_COLOR[row.status]}>{STATUS_LABEL[row.status]}</Badge>
                    <Badge variant="outline">{row.source === "ai" ? "🤖 AI" : "✍️ manual"}</Badge>
                    <Badge variant="outline">{row.difficulty_tag}</Badge>
                    <span className="font-mono text-xs text-muted-foreground">{row.slug}</span>
                  </div>
                  <p className="font-bold">{row.title}</p>
                  {row.subtitle && <p className="text-sm text-muted-foreground">{row.subtitle}</p>}
                </div>
                <div className="flex shrink-0 gap-2">
                  <Button
                    size="sm"
                    variant="outline"
                    disabled={busy === row.id}
                    onClick={() => toggleStatus(row)}
                  >
                    {busy === row.id ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : row.status === "published" ? "ซ่อน" : "เผยแพร่"}
                  </Button>
                  <Link href={`/admin/sim/${row.id}`}>
                    <Button size="sm" variant="outline" className="gap-1">
                      <Pencil className="h-3.5 w-3.5" /> แก้ไข
                    </Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}

function StatCard({ icon, label, value }: { icon: React.ReactNode; label: string; value: string }) {
  return (
    <Card>
      <CardContent className="p-4">
        <div className="mb-1 flex items-center gap-2 text-sm text-muted-foreground">
          {icon} {label}
        </div>
        <p className="text-xl font-bold">{value}</p>
      </CardContent>
    </Card>
  );
}
