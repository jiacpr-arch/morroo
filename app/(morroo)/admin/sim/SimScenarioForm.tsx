"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Loader2, Play, WandSparkles, X } from "lucide-react";
import SimRunner from "@/components/sim/SimRunner";
import { createClient } from "@/lib/supabase/client";
import { describeScenarioError } from "@/lib/sim/validate";
import type { SimDbCharacter } from "@/lib/sim/characters";
import type { SimScenario } from "@/lib/sim/types";

interface CharacterRow {
  slug: string;
  name: string;
  role: string | null;
  plate_top: string;
  plate_bottom: string;
  images: Record<string, string> | null;
  motion: string | null;
  status: string;
}

export interface SimFormValues {
  slug: string;
  title: string;
  subtitle: string;
  difficultyTag: string;
  category: string;
  sourceCaseId?: string;
  status: string;
  storyJson: string; // เก็บเป็น string เสมอ — ห้ามทับข้อความผู้ใช้ตอน parse ไม่ผ่าน
}

interface LongCaseOption {
  id: string;
  title: string;
  specialty: string;
}

interface Props {
  initial?: SimFormValues;
  submitLabel: string;
  /** parent จัดการ POST/PATCH เอง — โยน Error พร้อมข้อความไทยเมื่อไม่สำเร็จ */
  onSubmit: (values: SimFormValues, story: unknown) => Promise<void>;
  /** โชว์แผง AI generate (ใช้เฉพาะหน้า new) */
  showAiPanel?: boolean;
}

const EMPTY: SimFormValues = {
  slug: "",
  title: "",
  subtitle: "",
  difficultyTag: "basic",
  category: "acls",
  sourceCaseId: undefined,
  status: "draft",
  storyJson: "",
};

/** parse + validate — คืน { story } หรือ { error } ข้อความไทย */
function parseStory(
  values: SimFormValues,
  extraCharIds: string[],
): { story?: unknown; error?: string } {
  let story: unknown;
  try {
    story = JSON.parse(values.storyJson);
  } catch (e) {
    return { error: `story ไม่ใช่ JSON ที่ถูกต้อง: ${e instanceof Error ? e.message : ""}` };
  }
  const invalid = describeScenarioError(
    {
      slug: values.slug.trim(),
      title: values.title.trim(),
      subtitle: values.subtitle.trim(),
      difficultyTag: values.difficultyTag,
      story,
    },
    extraCharIds,
  );
  if (invalid) return { error: invalid };
  return { story };
}

export default function SimScenarioForm({ initial, submitLabel, onSubmit, showAiPanel }: Props) {
  const [values, setValues] = useState<SimFormValues>(initial ?? EMPTY);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [preview, setPreview] = useState<SimScenario | null>(null);

  // ตัวละครจาก DB — ใช้ validate ฝั่ง client + render ตอนทดลองเล่น
  const [dbCharacters, setDbCharacters] = useState<SimDbCharacter[]>([]);
  useEffect(() => {
    fetch("/api/admin/sim/characters")
      .then((res) => (res.ok ? res.json() : { characters: [] }))
      .then((json) =>
        setDbCharacters(
          ((json.characters ?? []) as CharacterRow[])
            .filter((c) => c.status === "active")
            .map((c) => ({
              slug: c.slug,
              name: c.name,
              role: c.role,
              plate: [c.plate_top, c.plate_bottom] as [string, string],
              images: c.images ?? {},
              motion: (c.motion ?? "none") as SimDbCharacter["motion"],
            })),
        ),
      )
      .catch(() => {});
  }, []);
  const extraCharIds = dbCharacters.map((c) => c.slug);

  // AI panel state
  const [aiTopic, setAiTopic] = useState("");
  const [aiDifficulty, setAiDifficulty] = useState("medium");
  const [aiExtra, setAiExtra] = useState("");
  const [aiBusy, setAiBusy] = useState(false);
  const [aiError, setAiError] = useState<string | null>(null);
  const [aiLongCaseId, setAiLongCaseId] = useState("");

  // รายการ Long Case ที่ published — ใช้ทำ dropdown "แปลงจาก Long Case"
  // (RLS: Published cases are viewable by all — ดึงผ่าน browser client ได้)
  const [longCases, setLongCases] = useState<LongCaseOption[]>([]);
  useEffect(() => {
    if (!showAiPanel) return;
    createClient()
      .from("long_cases")
      .select("id, title, specialty")
      .eq("is_published", true)
      .order("created_at", { ascending: false })
      .then(({ data }: { data: LongCaseOption[] | null }) => setLongCases(data ?? []));
  }, [showAiPanel]);

  function set<K extends keyof SimFormValues>(key: K, value: SimFormValues[K]) {
    setValues((v) => ({ ...v, [key]: value }));
  }

  function formatJson() {
    try {
      set("storyJson", JSON.stringify(JSON.parse(values.storyJson), null, 2));
      setError(null);
    } catch (e) {
      setError(`จัดรูปแบบไม่ได้ — JSON ผิด: ${e instanceof Error ? e.message : ""}`);
    }
  }

  function playtest() {
    const { story, error: parseError } = parseStory(values, extraCharIds);
    if (parseError) {
      setError(parseError);
      return;
    }
    setError(null);
    setPreview({
      slug: values.slug.trim() || "playtest",
      title: values.title.trim() || "ทดลองเล่น",
      subtitle: values.subtitle.trim(),
      difficultyTag: values.difficultyTag,
      category: values.category,
      story: story as SimScenario["story"],
    });
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    const { story, error: parseError } = parseStory(values, extraCharIds);
    if (parseError) {
      setError(parseError);
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      await onSubmit(values, story);
    } catch (err) {
      setError(err instanceof Error ? err.message : "บันทึกไม่สำเร็จ");
    } finally {
      setSubmitting(false);
    }
  }

  async function generateWithAi() {
    if (!aiLongCaseId && !aiTopic.trim()) {
      setAiError("เลือก Long Case ที่จะแปลง หรือใส่หัวข้อ/ภาวะของเคสก่อน");
      return;
    }
    setAiError(null);
    setAiBusy(true);
    try {
      const res = await fetch("/api/admin/sim/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(
          aiLongCaseId
            ? {
                longCaseId: aiLongCaseId,
                extraInstructions: aiExtra.trim() || undefined,
              }
            : {
                topic: aiTopic.trim(),
                difficulty: aiDifficulty,
                extraInstructions: aiExtra.trim() || undefined,
              },
        ),
      });
      const json = await res.json();
      if (!res.ok) throw new Error(json.error ?? "สร้างไม่สำเร็จ");
      const s = json.scenario;
      setValues({
        slug: s.slug ?? "",
        title: s.title ?? "",
        subtitle: s.subtitle ?? "",
        difficultyTag: s.difficultyTag ?? "basic",
        category: s.category ?? "acls",
        sourceCaseId: s.sourceCaseId ?? undefined,
        status: "draft",
        storyJson: JSON.stringify(s.story, null, 2),
      });
      setError(null);
    } catch (err) {
      setAiError(err instanceof Error ? err.message : "สร้างไม่สำเร็จ");
    } finally {
      setAiBusy(false);
    }
  }

  return (
    <div className="space-y-6">
      {showAiPanel && (
        <Card className="border-brand/30 bg-brand/5">
          <CardContent className="space-y-3 p-5">
            <div className="flex items-center gap-2 font-bold">
              <WandSparkles className="h-4 w-4 text-brand" /> สร้างเคสด้วย AI
            </div>
            <div>
              <Label htmlFor="ai-longcase">แปลงจาก Long Case (เกมเคส)</Label>
              <select
                id="ai-longcase"
                className="h-9 w-full rounded-md border bg-transparent px-3 text-sm"
                value={aiLongCaseId}
                onChange={(e) => setAiLongCaseId(e.target.value)}
              >
                <option value="">— ไม่แปลง (แต่งเคส ACLS ใหม่จากหัวข้อด้านล่าง) —</option>
                {longCases.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.title} · {c.specialty}
                  </option>
                ))}
              </select>
              {aiLongCaseId && (
                <p className="mt-1 text-xs text-muted-foreground">
                  จะแปลงเคสนี้เป็นเกมเคส (category: longcase) — ไม่ต้องกรอกหัวข้อด้านล่าง
                </p>
              )}
            </div>
            <div className="grid gap-3 sm:grid-cols-[1fr_150px]">
              <div>
                <Label htmlFor="ai-topic">หัวข้อ / ภาวะ</Label>
                <Input
                  id="ai-topic"
                  placeholder="เช่น PEA arrest จาก hyperkalemia, unstable bradycardia"
                  value={aiTopic}
                  onChange={(e) => setAiTopic(e.target.value)}
                  disabled={!!aiLongCaseId}
                />
              </div>
              <div>
                <Label htmlFor="ai-diff">ระดับ</Label>
                <select
                  id="ai-diff"
                  className="h-9 w-full rounded-md border bg-transparent px-3 text-sm"
                  value={aiDifficulty}
                  onChange={(e) => setAiDifficulty(e.target.value)}
                  disabled={!!aiLongCaseId}
                >
                  <option value="easy">ง่าย</option>
                  <option value="medium">กลาง</option>
                  <option value="hard">ยาก</option>
                </select>
              </div>
            </div>
            <div>
              <Label htmlFor="ai-extra">คำสั่งเพิ่มเติม (ไม่บังคับ)</Label>
              <Input
                id="ai-extra"
                placeholder="เช่น เน้นการสอนเรื่อง H's & T's"
                value={aiExtra}
                onChange={(e) => setAiExtra(e.target.value)}
              />
            </div>
            {aiError && (
              <div className="rounded-md bg-red-50 p-3 text-sm text-red-700">{aiError}</div>
            )}
            <div className="flex items-center gap-3">
              <Button type="button" onClick={generateWithAi} disabled={aiBusy} className="gap-2">
                {aiBusy ? <Loader2 className="h-4 w-4 animate-spin" /> : <WandSparkles className="h-4 w-4" />}
                สร้างด้วย AI
              </Button>
              {aiBusy && (
                <span className="text-sm text-muted-foreground">
                  กำลังแต่งเคส… ใช้เวลาราว 30–60 วินาที
                </span>
              )}
            </div>
          </CardContent>
        </Card>
      )}

      <form onSubmit={submit} className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <Label htmlFor="slug">Slug (kebab-case)</Label>
            <Input
              id="slug"
              placeholder="pea-arrest-01"
              value={values.slug}
              onChange={(e) => set("slug", e.target.value)}
              required
            />
          </div>
          <div>
            <Label htmlFor="difficultyTag">ป้ายระดับเนื้อหา</Label>
            <select
              id="difficultyTag"
              className="h-9 w-full rounded-md border bg-transparent px-3 text-sm"
              value={values.difficultyTag}
              onChange={(e) => set("difficultyTag", e.target.value)}
            >
              <option value="basic">basic — เคสพื้นฐาน</option>
              <option value="megacode">megacode</option>
            </select>
          </div>
        </div>
        <div>
          <Label htmlFor="category">หมวดเคส</Label>
          <select
            id="category"
            className="h-9 w-full rounded-md border bg-transparent px-3 text-sm sm:w-64"
            value={values.category}
            onChange={(e) => set("category", e.target.value)}
          >
            <option value="acls">acls — Code Blue (หน้า /sim)</option>
            <option value="longcase">longcase — เกมเคส (หน้า /casegame)</option>
          </select>
        </div>
        <div>
          <Label htmlFor="title">ชื่อเคส</Label>
          <Input
            id="title"
            placeholder="CODE BLUE: …"
            value={values.title}
            onChange={(e) => set("title", e.target.value)}
            required
          />
        </div>
        <div>
          <Label htmlFor="subtitle">โจทย์ผู้ป่วย (subtitle)</Label>
          <Input
            id="subtitle"
            placeholder="ชายอายุ 58 ปี เจ็บหน้าอก… ล้มลงหมดสติ"
            value={values.subtitle}
            onChange={(e) => set("subtitle", e.target.value)}
          />
        </div>
        <div>
          <Label htmlFor="status">สถานะ</Label>
          <select
            id="status"
            className="h-9 w-full rounded-md border bg-transparent px-3 text-sm sm:w-64"
            value={values.status}
            onChange={(e) => set("status", e.target.value)}
          >
            <option value="draft">draft — ยังไม่แสดงบนเว็บ</option>
            <option value="published">published — แสดงบนหน้า /sim</option>
            <option value="archived">archived — ซ่อน</option>
          </select>
        </div>
        <div>
          <div className="mb-1 flex items-center justify-between">
            <Label htmlFor="story">Story (JSON)</Label>
            <div className="flex gap-2">
              <Button type="button" size="sm" variant="outline" onClick={formatJson}>
                จัดรูปแบบ JSON
              </Button>
              <Button type="button" size="sm" variant="outline" className="gap-1" onClick={playtest}>
                <Play className="h-3.5 w-3.5" /> ทดลองเล่น
              </Button>
            </div>
          </div>
          <Textarea
            id="story"
            rows={24}
            className="font-mono text-xs"
            placeholder='[ { "say": { "who": "nurse_mint", "pose": "panic", "text": "..." } }, …, { "end": true } ]'
            value={values.storyJson}
            onChange={(e) => set("storyJson", e.target.value)}
            required
          />
        </div>

        {error && <div className="rounded-md bg-red-50 p-3 text-sm text-red-700">{error}</div>}

        <Button type="submit" disabled={submitting} className="gap-2">
          {submitting && <Loader2 className="h-4 w-4 animate-spin" />}
          {submitLabel}
        </Button>
      </form>

      {preview && (
        <>
          {/* SimRunner เป็น fixed overlay เต็มจออยู่แล้ว — ใส่ปุ่มปิดลอยทับ */}
          <SimRunner scenario={preview} practice characters={dbCharacters} />
          <button
            type="button"
            onClick={() => setPreview(null)}
            className="fixed right-4 top-4 z-[70] flex h-10 w-10 items-center justify-center rounded-full border-2 border-white bg-black/60 text-white"
            aria-label="ปิดทดลองเล่น"
          >
            <X className="h-5 w-5" />
          </button>
        </>
      )}
    </div>
  );
}
