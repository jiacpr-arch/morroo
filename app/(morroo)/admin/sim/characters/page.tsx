"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { CHARACTER_MOTIONS, SIM_CHARACTERS } from "@/lib/sim/characters";
import type { Pose } from "@/lib/sim/types";
import { ChevronLeft, Loader2, Plus, Shield, Trash2, Upload, X } from "lucide-react";

interface CharacterRow {
  id: string;
  slug: string;
  name: string;
  role: string | null;
  plate_top: string;
  plate_bottom: string;
  images: Record<string, string> | null;
  personality: string | null;
  motion: string;
  status: "active" | "archived";
}

const POSES: { pose: Pose; label: string }[] = [
  { pose: "idle", label: "ปกติ" },
  { pose: "talk", label: "พูด" },
  { pose: "panic", label: "ตกใจ" },
  { pose: "stern", label: "เข้ม" },
  { pose: "happy", label: "ยิ้ม" },
];

export default function AdminSimCharactersPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [rows, setRows] = useState<CharacterRow[]>([]);
  const [error, setError] = useState<string | null>(null);

  // ฟอร์มสร้างตัวละครใหม่
  const [showCreate, setShowCreate] = useState(false);
  const [cSlug, setCSlug] = useState("");
  const [cName, setCName] = useState("");
  const [cRole, setCRole] = useState("");
  const [cTop, setCTop] = useState("#2FA8A0");
  const [cBottom, setCBottom] = useState("#17706B");
  const [cPersonality, setCPersonality] = useState("");
  const [cMotion, setCMotion] = useState("none");
  const [creating, setCreating] = useState(false);

  async function load() {
    const res = await fetch("/api/admin/sim/characters");
    if (!res.ok) return;
    const json = await res.json();
    setRows(json.characters ?? []);
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
      await load();
      setLoading(false);
    }
    init();
  }, [router]);

  async function create(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setCreating(true);
    try {
      const res = await fetch("/api/admin/sim/characters", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          slug: cSlug, name: cName, role: cRole, plateTop: cTop, plateBottom: cBottom,
          personality: cPersonality, motion: cMotion,
        }),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error ?? "สร้างไม่สำเร็จ");
      setCSlug(""); setCName(""); setCRole(""); setCPersonality(""); setCMotion("none");
      setShowCreate(false);
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "สร้างไม่สำเร็จ");
    } finally {
      setCreating(false);
    }
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
        href="/admin/sim"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับจัดการเคส
      </Link>

      <div className="mb-2 flex items-center justify-between">
        <h1 className="text-2xl font-bold">ตัวละครในเกม</h1>
        <Button className="gap-2" onClick={() => setShowCreate((v) => !v)}>
          {showCreate ? <X className="h-4 w-4" /> : <Plus className="h-4 w-4" />}
          {showCreate ? "ปิดฟอร์ม" : "เพิ่มตัวละคร"}
        </Button>
      </div>
      <p className="mb-6 text-sm text-muted-foreground">
        อัปโหลดรูป 5 อารมณ์ต่อตัว (+ เฟรมอ้าปากถ้าอยากให้ปากขยับตอนพูด) — ท่าที่ไม่มีรูปเกมจะใช้ภาพวาดสำรองอัตโนมัติ
        · แนะนำ .webp พื้นหลังโปร่งใส สัดส่วนแนวตั้ง ~4:5
      </p>

      {error && <div className="mb-4 rounded-md bg-red-50 p-3 text-sm text-red-700">{error}</div>}

      {showCreate && (
        <Card className="mb-6 border-brand/30">
          <CardContent className="p-5">
            <form onSubmit={create} className="grid gap-3 sm:grid-cols-2">
              <div>
                <Label htmlFor="c-slug">Slug (snake_case — ใช้อ้างในเคส แก้ทีหลังไม่ได้)</Label>
                <Input id="c-slug" placeholder="pharmacist_pim" value={cSlug} onChange={(e) => setCSlug(e.target.value)} required />
              </div>
              <div>
                <Label htmlFor="c-name">ชื่อที่แสดง</Label>
                <Input id="c-name" placeholder="เภสัชพิม" value={cName} onChange={(e) => setCName(e.target.value)} required />
              </div>
              <div>
                <Label htmlFor="c-role">บทบาท</Label>
                <Input id="c-role" placeholder="Pharmacist" value={cRole} onChange={(e) => setCRole(e.target.value)} />
              </div>
              <div>
                <Label htmlFor="c-motion">ท่าเคลื่อนไหว</Label>
                <select
                  id="c-motion"
                  className="h-9 w-full rounded-md border bg-transparent px-3 text-sm"
                  value={cMotion}
                  onChange={(e) => setCMotion(e.target.value)}
                >
                  {CHARACTER_MOTIONS.map((m) => (
                    <option key={m.id} value={m.id}>{m.label}</option>
                  ))}
                </select>
              </div>
              <div className="sm:col-span-2">
                <Label htmlFor="c-personality">บุคลิก/วิธีพูด (AI ใช้เขียนบทให้ตรงคาแรกเตอร์)</Label>
                <Input
                  id="c-personality"
                  placeholder="เช่น ใจเย็น พูดสั้นกระชับ ชอบทวนขนาดยาเสมอ"
                  value={cPersonality}
                  onChange={(e) => setCPersonality(e.target.value)}
                />
              </div>
              <div className="flex items-end gap-3">
                <div>
                  <Label htmlFor="c-top">สีป้ายชื่อ (บน)</Label>
                  <input id="c-top" type="color" className="h-9 w-16 cursor-pointer rounded border" value={cTop} onChange={(e) => setCTop(e.target.value)} />
                </div>
                <div>
                  <Label htmlFor="c-bottom">สีป้ายชื่อ (ล่าง)</Label>
                  <input id="c-bottom" type="color" className="h-9 w-16 cursor-pointer rounded border" value={cBottom} onChange={(e) => setCBottom(e.target.value)} />
                </div>
                <Button type="submit" disabled={creating} className="ml-auto gap-2">
                  {creating && <Loader2 className="h-4 w-4 animate-spin" />} สร้าง
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>
      )}

      {/* ตัวละคร built-in (แก้ในโค้ด) */}
      <h2 className="mb-2 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        ตัวละครหลัก (built-in — วางรูปใน repo ที่ public/images/sim/characters/)
      </h2>
      <div className="mb-6 flex flex-wrap gap-2">
        {Object.entries(SIM_CHARACTERS).map(([slug, c]) => (
          <Badge key={slug} variant="outline" className="gap-1 py-1">
            <span
              className="inline-block h-3 w-3 rounded-full"
              style={{ background: `linear-gradient(180deg, ${c.plate[0]}, ${c.plate[1]})` }}
            />
            {c.name} <span className="font-mono text-[10px] text-muted-foreground">{slug}</span>
          </Badge>
        ))}
      </div>

      {/* ตัวละครจาก DB */}
      <h2 className="mb-2 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        ตัวละครที่เพิ่มเอง
      </h2>
      {rows.length === 0 ? (
        <Card>
          <CardContent className="p-8 text-center text-muted-foreground">
            ยังไม่มี — กด &quot;เพิ่มตัวละคร&quot; เพื่อสร้างตัวแรก
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {rows.map((row) => (
            <CharacterCard key={row.id} row={row} onChanged={load} onError={setError} />
          ))}
        </div>
      )}
    </div>
  );
}

function CharacterCard({
  row,
  onChanged,
  onError,
}: {
  row: CharacterRow;
  onChanged: () => Promise<void>;
  onError: (message: string | null) => void;
}) {
  const [name, setName] = useState(row.name);
  const [role, setRole] = useState(row.role ?? "");
  const [top, setTop] = useState(row.plate_top);
  const [bottom, setBottom] = useState(row.plate_bottom);
  const [personality, setPersonality] = useState(row.personality ?? "");
  const [motion, setMotion] = useState(row.motion ?? "none");
  const [saving, setSaving] = useState(false);
  const [busyKey, setBusyKey] = useState<string | null>(null);
  const fileRef = useRef<HTMLInputElement>(null);
  const pendingRef = useRef<{ pose: Pose; talk: boolean } | null>(null);

  const images = row.images ?? {};
  const dirty =
    name !== row.name || role !== (row.role ?? "") || top !== row.plate_top ||
    bottom !== row.plate_bottom || personality !== (row.personality ?? "") ||
    motion !== (row.motion ?? "none");

  async function save() {
    setSaving(true);
    await fetch(`/api/admin/sim/characters/${row.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, role, plateTop: top, plateBottom: bottom, personality, motion }),
    });
    await onChanged();
    setSaving(false);
  }

  function pickFile(pose: Pose, talk: boolean) {
    pendingRef.current = { pose, talk };
    fileRef.current?.click();
  }

  async function upload(file: File) {
    const target = pendingRef.current;
    if (!target) return;
    const key = `${target.pose}${target.talk ? "_talk" : ""}`;
    setBusyKey(key);
    onError(null);
    const form = new FormData();
    form.set("file", file);
    form.set("pose", target.pose);
    if (target.talk) form.set("talk", "1");
    const res = await fetch(`/api/admin/sim/characters/${row.id}/image`, {
      method: "POST",
      body: form,
    });
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      onError(json.error ?? "อัปโหลดไม่สำเร็จ");
    }
    await onChanged();
    setBusyKey(null);
  }

  async function removeImage(pose: Pose, talk: boolean) {
    const key = `${pose}${talk ? "_talk" : ""}`;
    if (!confirm(`ลบรูปท่า ${key}?`)) return;
    setBusyKey(key);
    await fetch(`/api/admin/sim/characters/${row.id}/image?pose=${pose}${talk ? "&talk=1" : ""}`, {
      method: "DELETE",
    });
    await onChanged();
    setBusyKey(null);
  }

  async function removeCharacter() {
    if (!confirm(`ลบตัวละคร "${row.name}" และรูปทั้งหมด? เคสที่อ้างถึงตัวนี้จะแสดงไม่ได้`)) return;
    await fetch(`/api/admin/sim/characters/${row.id}`, { method: "DELETE" });
    await onChanged();
  }

  return (
    <Card>
      <CardContent className="space-y-4 p-5">
        <div className="flex flex-wrap items-center gap-3">
          <span
            className="inline-block h-8 w-8 rounded-full border-2 border-white shadow"
            style={{ background: `linear-gradient(180deg, ${top}, ${bottom})` }}
          />
          <div className="min-w-0 flex-1">
            <p className="font-bold">{row.name}</p>
            <p className="font-mono text-xs text-muted-foreground">{row.slug}</p>
          </div>
          {row.status === "archived" && <Badge className="bg-muted text-muted-foreground">archived</Badge>}
          <Button size="sm" variant="outline" className="gap-1 text-red-600" onClick={removeCharacter}>
            <Trash2 className="h-3.5 w-3.5" /> ลบ
          </Button>
        </div>

        <div className="grid gap-3 sm:grid-cols-[1fr_1fr_auto_auto_auto]">
          <div>
            <Label>ชื่อ</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div>
            <Label>บทบาท</Label>
            <Input value={role} onChange={(e) => setRole(e.target.value)} />
          </div>
          <div>
            <Label>ป้ายบน</Label>
            <input type="color" className="h-9 w-14 cursor-pointer rounded border" value={top} onChange={(e) => setTop(e.target.value)} />
          </div>
          <div>
            <Label>ป้ายล่าง</Label>
            <input type="color" className="h-9 w-14 cursor-pointer rounded border" value={bottom} onChange={(e) => setBottom(e.target.value)} />
          </div>
          <div className="flex items-end">
            <Button size="sm" onClick={save} disabled={!dirty || saving} className="gap-1">
              {saving && <Loader2 className="h-3.5 w-3.5 animate-spin" />} บันทึก
            </Button>
          </div>
        </div>

        <div className="grid gap-3 sm:grid-cols-[1fr_200px]">
          <div>
            <Label>บุคลิก/วิธีพูด (AI ใช้เขียนบท)</Label>
            <Input
              placeholder="เช่น ขี้ตกใจ พูดเร็ว ชอบรายงานตัวเลข"
              value={personality}
              onChange={(e) => setPersonality(e.target.value)}
            />
          </div>
          <div>
            <Label>ท่าเคลื่อนไหว</Label>
            <select
              className="h-9 w-full rounded-md border bg-transparent px-3 text-sm"
              value={motion}
              onChange={(e) => setMotion(e.target.value)}
            >
              {CHARACTER_MOTIONS.map((m) => (
                <option key={m.id} value={m.id}>{m.label}</option>
              ))}
            </select>
          </div>
        </div>

        {/* ช่องรูปต่อท่า: แถวบนปากปิด แถวล่างเฟรมอ้าปาก */}
        <div className="overflow-x-auto">
          <div className="grid min-w-[560px] grid-cols-5 gap-2">
            {POSES.map(({ pose, label }) => (
              <ImageSlot
                key={pose}
                label={label}
                imageUrl={images[pose]}
                busy={busyKey === pose}
                onUpload={() => pickFile(pose, false)}
                onRemove={() => removeImage(pose, false)}
              />
            ))}
            {POSES.map(({ pose, label }) => (
              <ImageSlot
                key={`${pose}_talk`}
                label={`${label} · อ้าปาก`}
                imageUrl={images[`${pose}_talk`]}
                busy={busyKey === `${pose}_talk`}
                onUpload={() => pickFile(pose, true)}
                onRemove={() => removeImage(pose, true)}
              />
            ))}
          </div>
        </div>

        <input
          ref={fileRef}
          type="file"
          accept="image/webp,image/png,image/jpeg"
          className="hidden"
          onChange={(e) => {
            const file = e.target.files?.[0];
            e.target.value = "";
            if (file) void upload(file);
          }}
        />
      </CardContent>
    </Card>
  );
}

function ImageSlot({
  label,
  imageUrl,
  busy,
  onUpload,
  onRemove,
}: {
  label: string;
  imageUrl?: string;
  busy: boolean;
  onUpload: () => void;
  onRemove: () => void;
}) {
  return (
    <div className="rounded-lg border p-2 text-center">
      <p className="mb-1 truncate text-[11px] font-medium text-muted-foreground">{label}</p>
      <button
        type="button"
        onClick={onUpload}
        className="relative mx-auto flex h-24 w-full items-center justify-center overflow-hidden rounded bg-muted/40 hover:bg-muted"
        aria-label={`อัปโหลดรูป ${label}`}
      >
        {busy ? (
          <Loader2 className="h-5 w-5 animate-spin text-brand" />
        ) : imageUrl ? (
          // eslint-disable-next-line @next/next/no-img-element -- preview รูปจาก Storage (URL dynamic)
          <img src={imageUrl} alt={label} className="h-full w-full object-contain" />
        ) : (
          <Upload className="h-5 w-5 text-muted-foreground" />
        )}
      </button>
      {imageUrl && !busy && (
        <button type="button" onClick={onRemove} className="mt-1 text-[11px] text-red-600 underline">
          ลบรูป
        </button>
      )}
    </div>
  );
}
