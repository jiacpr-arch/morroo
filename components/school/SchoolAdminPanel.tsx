"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Loader2, Check, AlertCircle } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import ImportPanel from "./ImportPanel";

type Tab =
  | "import"
  | "topic"
  | "lesson"
  | "flashcard"
  | "quiz"
  | "case"
  | "concept_link"
  | "bulk";

interface Props {
  systems: { id: string; slug: string; name_th: string; icon: string }[];
  concepts: { id: string; slug: string; name_th: string; icon: string }[];
  topics: {
    id: string;
    year: number;
    slug: string;
    name_th: string;
    school_systems?: { slug: string; name_th: string; icon?: string } | null;
  }[];
}

const LAYERS = ["foundation", "anatomy", "physio", "biochem", "path", "pharm", "clinical"];

export default function SchoolAdminPanel({ systems, concepts, topics }: Props) {
  const [tab, setTab] = useState<Tab>("import");
  const [status, setStatus] = useState<{ kind: "ok" | "err"; msg: string } | null>(null);
  const [busy, setBusy] = useState(false);

  function notify(kind: "ok" | "err", msg: string) {
    setStatus({ kind, msg });
    setTimeout(() => setStatus(null), 3000);
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap gap-1 border-b">
        {(
          [
            ["import", "✨ Import (AI)"],
            ["topic", "Topic"],
            ["lesson", "Lesson"],
            ["flashcard", "Flashcard"],
            ["quiz", "Quiz"],
            ["case", "Case"],
            ["concept_link", "Tag concept"],
            ["bulk", "Bulk JSON"],
          ] as const
        ).map(([k, label]) => (
          <button
            key={k}
            onClick={() => setTab(k)}
            className={`px-3 py-2 text-sm font-medium border-b-2 transition-colors ${
              tab === k
                ? "border-brand text-brand"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {status && (
        <div
          className={`rounded-lg border p-3 text-sm flex items-center gap-2 ${
            status.kind === "ok"
              ? "border-emerald-300 bg-emerald-50 text-emerald-800"
              : "border-rose-300 bg-rose-50 text-rose-800"
          }`}
        >
          {status.kind === "ok" ? <Check className="h-4 w-4" /> : <AlertCircle className="h-4 w-4" />}
          {status.msg}
        </div>
      )}

      {tab === "import" && <ImportPanel topics={topics} />}
      {tab === "topic" && (
        <TopicForm systems={systems} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "lesson" && (
        <LessonForm topics={topics} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "flashcard" && (
        <FlashcardForm topics={topics} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "quiz" && (
        <QuizForm topics={topics} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "case" && (
        <CaseForm systems={systems} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "concept_link" && (
        <ConceptLinkForm concepts={concepts} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "bulk" && <BulkImport busy={busy} setBusy={setBusy} notify={notify} />}
    </div>
  );
}

interface CommonProps {
  busy: boolean;
  setBusy: (b: boolean) => void;
  notify: (kind: "ok" | "err", msg: string) => void;
}

function TopicForm({ systems, busy, setBusy, notify }: { systems: Props["systems"] } & CommonProps) {
  const [systemId, setSystemId] = useState(systems[0]?.id ?? "");
  const [year, setYear] = useState(1);
  const [slug, setSlug] = useState("");
  const [nameTh, setNameTh] = useState("");
  const [nameEn, setNameEn] = useState("");
  const [summary, setSummary] = useState("");

  async function save() {
    if (!systemId || !slug || !nameTh || !nameEn) {
      notify("err", "กรุณากรอกข้อมูลที่ขาด");
      return;
    }
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_topics").insert({
        system_id: systemId,
        year,
        slug,
        name_th: nameTh,
        name_en: nameEn,
        summary: summary || null,
      });
      if (error) throw error;
      notify("ok", `เพิ่ม topic "${nameTh}" สำเร็จ`);
      setSlug("");
      setNameTh("");
      setNameEn("");
      setSummary("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Topic</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <Field label="System">
            <select
              value={systemId}
              onChange={(e) => setSystemId(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {systems.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.icon} {s.name_th}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Year">
            <input
              type="number"
              min={1}
              max={6}
              value={year}
              onChange={(e) => setYear(Number(e.target.value))}
              className="w-full border rounded p-2 text-sm"
            />
          </Field>
        </div>
        <Field label="Slug (English, dash)">
          <input
            value={slug}
            onChange={(e) => setSlug(e.target.value)}
            placeholder="cardiac-cycle"
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <Field label="ชื่อไทย">
            <input
              value={nameTh}
              onChange={(e) => setNameTh(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            />
          </Field>
          <Field label="Name (English)">
            <input
              value={nameEn}
              onChange={(e) => setNameEn(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            />
          </Field>
        </div>
        <Field label="Summary (optional)">
          <textarea
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[60px]"
          />
        </Field>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          บันทึก
        </Button>
      </CardContent>
    </Card>
  );
}

function LessonForm({ topics, busy, setBusy, notify }: { topics: Props["topics"] } & CommonProps) {
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [layer, setLayer] = useState("foundation");
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [estMin, setEstMin] = useState(5);
  const [source, setSource] = useState("");

  async function save() {
    if (!topicId || !title || !body) return notify("err", "ขาด topic / title / body");
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_lessons").insert({
        topic_id: topicId,
        layer,
        title,
        body_md: body,
        estimated_min: estMin,
        source: source || null,
      });
      if (error) throw error;
      notify("ok", `เพิ่ม lesson "${title}" สำเร็จ`);
      setTitle("");
      setBody("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Lesson</h3>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <Field label="Topic">
            <TopicPicker topics={topics} value={topicId} onChange={setTopicId} />
          </Field>
          <Field label="Layer">
            <select
              value={layer}
              onChange={(e) => setLayer(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {LAYERS.map((l) => (
                <option key={l} value={l}>
                  {l}
                </option>
              ))}
            </select>
          </Field>
          <Field label="นาที">
            <input
              type="number"
              value={estMin}
              onChange={(e) => setEstMin(Number(e.target.value))}
              className="w-full border rounded p-2 text-sm"
            />
          </Field>
        </div>
        <Field label="Title">
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Field label="Body (Markdown — split mini quiz by `## ⏸ Mini Quiz`)">
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[200px] font-mono"
            placeholder={"# Part 1\n...\n\n## ⏸ Mini Quiz\n\n# Part 2\n..."}
          />
        </Field>
        <Field label="Source (optional)">
          <input
            value={source}
            onChange={(e) => setSource(e.target.value)}
            placeholder="Guyton chapter 9"
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          บันทึก
        </Button>
      </CardContent>
    </Card>
  );
}

function FlashcardForm({ topics, busy, setBusy, notify }: { topics: Props["topics"] } & CommonProps) {
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [layer, setLayer] = useState("foundation");
  const [front, setFront] = useState("");
  const [back, setBack] = useState("");
  const [difficulty, setDifficulty] = useState("medium");
  const [source, setSource] = useState("");
  const [imageUrl, setImageUrl] = useState("");

  async function save() {
    if (!topicId || !front || !back) return notify("err", "ขาดข้อมูล");
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_flashcards").insert({
        topic_id: topicId,
        layer,
        front,
        back,
        difficulty,
        source: source || null,
        image_url: imageUrl || null,
      });
      if (error) throw error;
      notify("ok", "เพิ่ม flashcard สำเร็จ");
      setFront("");
      setBack("");
      setImageUrl("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Flashcard</h3>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <Field label="Topic">
            <TopicPicker topics={topics} value={topicId} onChange={setTopicId} />
          </Field>
          <Field label="Layer">
            <select
              value={layer}
              onChange={(e) => setLayer(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {LAYERS.map((l) => (
                <option key={l} value={l}>
                  {l}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Difficulty">
            <select
              value={difficulty}
              onChange={(e) => setDifficulty(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              <option value="easy">easy</option>
              <option value="medium">medium</option>
              <option value="hard">hard</option>
            </select>
          </Field>
        </div>
        <Field label="Front">
          <textarea
            value={front}
            onChange={(e) => setFront(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[60px]"
          />
        </Field>
        <Field label="Back">
          <textarea
            value={back}
            onChange={(e) => setBack(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[80px]"
          />
        </Field>
        <Field label="Image URL (dual coding)">
          <input
            value={imageUrl}
            onChange={(e) => setImageUrl(e.target.value)}
            placeholder="https://..."
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Field label="Source">
          <input
            value={source}
            onChange={(e) => setSource(e.target.value)}
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          บันทึก
        </Button>
      </CardContent>
    </Card>
  );
}

function QuizForm({ topics, busy, setBusy, notify }: { topics: Props["topics"] } & CommonProps) {
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [layer, setLayer] = useState("foundation");
  const [difficulty, setDifficulty] = useState("medium");
  const [stem, setStem] = useState("");
  const [choices, setChoices] = useState([
    { label: "A", text: "" },
    { label: "B", text: "" },
    { label: "C", text: "" },
    { label: "D", text: "" },
  ]);
  const [correctAnswer, setCorrectAnswer] = useState("A");
  const [explanation, setExplanation] = useState("");
  const [source, setSource] = useState("");

  function setChoice(i: number, text: string) {
    const c = [...choices];
    c[i] = { ...c[i], text };
    setChoices(c);
  }

  async function save() {
    if (!topicId || !stem || choices.some((c) => !c.text))
      return notify("err", "ขาด topic / stem / choices");
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_quizzes").insert({
        topic_id: topicId,
        layer,
        stem,
        choices,
        correct_answer: correctAnswer,
        explanation: explanation || null,
        difficulty,
        source: source || null,
      });
      if (error) throw error;
      notify("ok", "เพิ่ม quiz สำเร็จ");
      setStem("");
      setExplanation("");
      setChoices([
        { label: "A", text: "" },
        { label: "B", text: "" },
        { label: "C", text: "" },
        { label: "D", text: "" },
      ]);
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Quiz</h3>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <Field label="Topic">
            <TopicPicker topics={topics} value={topicId} onChange={setTopicId} />
          </Field>
          <Field label="Layer">
            <select
              value={layer}
              onChange={(e) => setLayer(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {LAYERS.map((l) => (
                <option key={l} value={l}>
                  {l}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Difficulty">
            <select
              value={difficulty}
              onChange={(e) => setDifficulty(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              <option value="easy">easy</option>
              <option value="medium">medium</option>
              <option value="hard">hard</option>
            </select>
          </Field>
        </div>
        <Field label="Stem">
          <textarea
            value={stem}
            onChange={(e) => setStem(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[80px]"
          />
        </Field>
        <div className="space-y-2">
          {choices.map((c, i) => (
            <div key={c.label} className="flex items-center gap-2">
              <input
                type="radio"
                name="correct"
                checked={correctAnswer === c.label}
                onChange={() => setCorrectAnswer(c.label)}
              />
              <span className="font-bold w-6">{c.label}.</span>
              <input
                value={c.text}
                onChange={(e) => setChoice(i, e.target.value)}
                className="flex-1 border rounded p-2 text-sm"
                placeholder={`ตัวเลือก ${c.label}`}
              />
            </div>
          ))}
        </div>
        <Field label="Explanation">
          <textarea
            value={explanation}
            onChange={(e) => setExplanation(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[80px]"
          />
        </Field>
        <Field label="Source">
          <input
            value={source}
            onChange={(e) => setSource(e.target.value)}
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          บันทึก
        </Button>
      </CardContent>
    </Card>
  );
}

function CaseForm({ systems, busy, setBusy, notify }: { systems: Props["systems"] } & CommonProps) {
  const [slug, setSlug] = useState("");
  const [title, setTitle] = useState("");
  const [presentation, setPresentation] = useState("");
  const [systemId, setSystemId] = useState(systems[0]?.id ?? "");
  const [difficulty, setDifficulty] = useState("medium");

  async function save() {
    if (!slug || !title || !presentation) return notify("err", "ขาดข้อมูล");
    setBusy(true);
    try {
      const supabase = createClient();
      const { error, data } = await supabase
        .from("school_cases")
        .insert({
          slug,
          title,
          presentation,
          primary_system_id: systemId,
          difficulty,
        })
        .select("id")
        .single();
      if (error) throw error;
      notify("ok", `สร้าง case แล้ว (id ${data.id}) — เพิ่ม stage ผ่าน Bulk JSON`);
      setSlug("");
      setTitle("");
      setPresentation("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Case</h3>
        <Field label="Slug">
          <input
            value={slug}
            onChange={(e) => setSlug(e.target.value)}
            className="w-full border rounded p-2 text-sm"
            placeholder="elderly-chest-pain"
          />
        </Field>
        <Field label="Title">
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full border rounded p-2 text-sm"
          />
        </Field>
        <Field label="Presentation">
          <textarea
            value={presentation}
            onChange={(e) => setPresentation(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[100px]"
          />
        </Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Primary system">
            <select
              value={systemId}
              onChange={(e) => setSystemId(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {systems.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.icon} {s.name_th}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Difficulty">
            <select
              value={difficulty}
              onChange={(e) => setDifficulty(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              <option value="easy">easy</option>
              <option value="medium">medium</option>
              <option value="hard">hard</option>
            </select>
          </Field>
        </div>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          บันทึก
        </Button>
        <p className="text-xs text-muted-foreground italic">
          🚧 case_stages เพิ่มผ่าน Bulk JSON ก่อน — ฟอร์มหลายขั้นจะมาทีหลัง
        </p>
      </CardContent>
    </Card>
  );
}

function ConceptLinkForm({ concepts, busy, setBusy, notify }: { concepts: Props["concepts"] } & CommonProps) {
  const [conceptId, setConceptId] = useState(concepts[0]?.id ?? "");
  const [unitType, setUnitType] = useState<"flashcard" | "quiz" | "lesson">("flashcard");
  const [unitId, setUnitId] = useState("");

  async function save() {
    if (!conceptId || !unitId) return notify("err", "ขาด concept หรือ unit_id");
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_concept_links").insert({
        concept_id: conceptId,
        unit_type: unitType,
        unit_id: unitId,
      });
      if (error) throw error;
      notify("ok", "Tag concept สำเร็จ");
      setUnitId("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">Tag concept ให้ unit</h3>
        <p className="text-xs text-muted-foreground">
          ใช้ tag ทำ cross-subject — copy unit_id (uuid) จาก Supabase หรือจาก URL
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <Field label="Concept">
            <select
              value={conceptId}
              onChange={(e) => setConceptId(e.target.value)}
              className="w-full border rounded p-2 text-sm"
            >
              {concepts.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.icon} {c.name_th}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Unit type">
            <select
              value={unitType}
              onChange={(e) => setUnitType(e.target.value as "flashcard" | "quiz" | "lesson")}
              className="w-full border rounded p-2 text-sm"
            >
              <option value="flashcard">flashcard</option>
              <option value="quiz">quiz</option>
              <option value="lesson">lesson</option>
            </select>
          </Field>
          <Field label="Unit ID">
            <input
              value={unitId}
              onChange={(e) => setUnitId(e.target.value)}
              className="w-full border rounded p-2 text-sm font-mono"
              placeholder="uuid"
            />
          </Field>
        </div>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          Tag
        </Button>
      </CardContent>
    </Card>
  );
}

function BulkImport({ busy, setBusy, notify }: CommonProps) {
  const [json, setJson] = useState("");
  const [unitType, setUnitType] = useState<"flashcards" | "quizzes" | "lessons">(
    "flashcards"
  );

  async function save() {
    let arr: unknown[];
    try {
      arr = JSON.parse(json);
    } catch {
      return notify("err", "JSON parse error");
    }
    if (!Array.isArray(arr)) return notify("err", "JSON ต้องเป็น array");
    setBusy(true);
    try {
      const supabase = createClient();
      const table =
        unitType === "flashcards"
          ? "school_flashcards"
          : unitType === "quizzes"
            ? "school_quizzes"
            : "school_lessons";
      const { error } = await supabase.from(table).insert(arr as object[]);
      if (error) throw error;
      notify("ok", `เพิ่ม ${arr.length} ${unitType} สำเร็จ`);
      setJson("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">Bulk JSON import</h3>
        <p className="text-xs text-muted-foreground">
          วาง JSON array ของ objects ตรงกับ schema (`topic_id`, `layer`, `front`, etc.)
        </p>
        <Field label="Unit type">
          <select
            value={unitType}
            onChange={(e) => setUnitType(e.target.value as "flashcards" | "quizzes" | "lessons")}
            className="w-full border rounded p-2 text-sm"
          >
            <option value="flashcards">flashcards</option>
            <option value="quizzes">quizzes</option>
            <option value="lessons">lessons</option>
          </select>
        </Field>
        <Field label="JSON">
          <textarea
            value={json}
            onChange={(e) => setJson(e.target.value)}
            className="w-full border rounded p-2 text-xs min-h-[300px] font-mono"
            placeholder='[\n  {"topic_id":"...", "layer":"physio", "front":"...", "back":"...", "difficulty":"medium"}\n]'
          />
        </Field>
        <Button onClick={save} disabled={busy}>
          {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
          Import
        </Button>
      </CardContent>
    </Card>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="text-xs font-semibold text-muted-foreground block mb-1">
        {label}
      </span>
      {children}
    </label>
  );
}

function TopicPicker({
  topics,
  value,
  onChange,
}: {
  topics: Props["topics"];
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <select
      value={value}
      onChange={(e) => onChange(e.target.value)}
      className="w-full border rounded p-2 text-sm"
    >
      {topics.map((t) => (
        <option key={t.id} value={t.id}>
          Y{t.year} · {t.school_systems?.icon} {t.name_th}
        </option>
      ))}
    </select>
  );
}
