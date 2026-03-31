"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { Swords, Plus, Loader2, Shield, ToggleLeft, ToggleRight } from "lucide-react";
import type { Challenge } from "@/lib/types-standard";

export default function AdminChallengesPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    title: "",
    description: "",
    challenge_type: "weekly" as "weekly" | "monthly",
    start_date: "",
    end_date: "",
  });

  const supabase = createClient();

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("users").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      const { data } = await supabase
        .from("challenges").select("*").order("start_date", { ascending: false });
      setChallenges((data as Challenge[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  const handleCreate = async () => {
    if (!form.title || !form.start_date || !form.end_date) return;
    setSaving(true);

    const { data, error } = await supabase
      .from("challenges")
      .insert({
        title: form.title,
        description: form.description || null,
        challenge_type: form.challenge_type,
        start_date: new Date(form.start_date).toISOString(),
        end_date: new Date(form.end_date).toISOString(),
        question_ids: [],
        is_active: true,
      })
      .select()
      .single();

    if (!error && data) {
      setChallenges([data as Challenge, ...challenges]);
      setShowForm(false);
      setForm({ title: "", description: "", challenge_type: "weekly", start_date: "", end_date: "" });
    }
    setSaving(false);
  };

  const toggleChallenge = async (challenge: Challenge) => {
    const { error } = await supabase
      .from("challenges")
      .update({ is_active: !challenge.is_active })
      .eq("id", challenge.id);

    if (!error) {
      setChallenges(challenges.map((c) =>
        c.id === challenge.id ? { ...c, is_active: !c.is_active } : c
      ));
    }
  };

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

  const now = new Date();

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold">จัดการ Challenge</h1>
          <p className="text-muted-foreground mt-1">สร้างและจัดการรอบแข่งขัน</p>
        </div>
        <Button
          onClick={() => setShowForm(!showForm)}
          className="bg-brand hover:bg-brand-light text-white gap-2"
        >
          <Plus className="h-4 w-4" /> สร้าง Challenge
        </Button>
      </div>

      {showForm && (
        <Card className="mb-8">
          <CardHeader>
            <h3 className="font-bold">สร้าง Challenge ใหม่</h3>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium">ชื่อ Challenge</label>
                <Input
                  placeholder="Weekly Challenge #1"
                  value={form.title}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">ประเภท</label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.challenge_type}
                  onChange={(e) =>
                    setForm({ ...form, challenge_type: e.target.value as "weekly" | "monthly" })
                  }
                >
                  <option value="weekly">Weekly (รายสัปดาห์)</option>
                  <option value="monthly">Monthly (รายเดือน)</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">เริ่ม</label>
                <Input
                  type="datetime-local"
                  value={form.start_date}
                  onChange={(e) => setForm({ ...form, start_date: e.target.value })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">สิ้นสุด</label>
                <Input
                  type="datetime-local"
                  value={form.end_date}
                  onChange={(e) => setForm({ ...form, end_date: e.target.value })}
                />
              </div>
              <div className="sm:col-span-2">
                <label className="text-sm font-medium">คำอธิบาย</label>
                <Input
                  placeholder="อธิบาย Challenge"
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                />
              </div>
            </div>
            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setShowForm(false)}>ยกเลิก</Button>
              <Button
                onClick={handleCreate}
                disabled={saving || !form.title}
                className="bg-brand hover:bg-brand-light text-white"
              >
                {saving ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                สร้าง Challenge
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      <div className="space-y-3">
        {challenges.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <Swords className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <p className="text-muted-foreground">ยังไม่มี Challenge</p>
            </CardContent>
          </Card>
        ) : (
          challenges.map((c) => {
            const isLive = new Date(c.start_date) <= now && new Date(c.end_date) >= now;
            const isPast = new Date(c.end_date) < now;

            return (
              <Card key={c.id} className={!c.is_active ? "opacity-50" : ""}>
                <CardContent className="py-4">
                  <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <h3 className="font-bold">{c.title}</h3>
                        <Badge variant="secondary">
                          {c.challenge_type === "weekly" ? "Weekly" : "Monthly"}
                        </Badge>
                        {isLive && <Badge className="bg-green-100 text-green-700">LIVE</Badge>}
                        {isPast && <Badge variant="secondary">จบแล้ว</Badge>}
                      </div>
                      <p className="text-sm text-muted-foreground">
                        {new Date(c.start_date).toLocaleDateString("th-TH")} -{" "}
                        {new Date(c.end_date).toLocaleDateString("th-TH")} | {c.question_ids.length} ข้อ
                      </p>
                    </div>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => toggleChallenge(c)}
                    >
                      {c.is_active ? (
                        <ToggleRight className="h-5 w-5 text-green-600" />
                      ) : (
                        <ToggleLeft className="h-5 w-5 text-gray-400" />
                      )}
                    </Button>
                  </div>
                </CardContent>
              </Card>
            );
          })
        )}
      </div>
    </div>
  );
}
