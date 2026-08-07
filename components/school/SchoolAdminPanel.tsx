"use client";

import { useEffect, useRef, useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Loader2, Check, AlertCircle, ImagePlus, Eye, ArrowUp, ArrowDown } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { normalizeImageUrl } from "@/lib/school/image-url";
import ImportPanel from "./ImportPanel";
import ImageUploader from "./ImageUploader";

/**
 * Three tabs, on purpose. Everything students consume is produced by the AI
 * import in one pass, so the old one-row-at-a-time forms (Topic / Lesson /
 * Flashcard / Quiz / Case / Tag concept / Bulk JSON) were redundant — none of
 * them had ever created a row. What's left is the import itself, editing
 * content after it's saved, and visuals, which the import doesn't produce.
 */
type Tab = "import" | "edit" | "visual";

interface Props {
  systems: { id: string; slug: string; name_th: string; icon: string }[];
  topics: {
    id: string;
    year: number;
    term?: number | null;
    slug: string;
    name_th: string;
    code?: string | null;
    school_systems?: { slug: string; name_th: string; icon?: string } | null;
  }[];
}

const LAYERS = ["foundation", "anatomy", "physio", "biochem", "path", "pharm", "clinical"];

export default function SchoolAdminPanel({ systems, topics }: Props) {
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
            ["import", "นำเข้าไฟล์ (AI)"],
            ["edit", "แก้ไขเนื้อหา + รูป"],
            ["visual", "Visual"],
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

      {tab === "import" && <ImportPanel topics={topics} systems={systems} />}
      {tab === "edit" && (
        <ContentEditor topics={topics} busy={busy} setBusy={setBusy} notify={notify} />
      )}
      {tab === "visual" && (
        <VisualForm topics={topics} busy={busy} setBusy={setBusy} notify={notify} />
      )}
    </div>
  );
}

type EditKind = "lesson" | "book_chapter";
interface EditItem {
  id: string;
  title: string;
  body_md: string;
  sort_order: number;
}

/**
 * Edit the markdown body of an EXISTING lesson or book chapter, with inline
 * image upload + insert at the cursor. Fills the gap where the other tabs can
 * only create new rows, not edit content already in the database.
 */
function ContentEditor({ topics, busy, setBusy, notify }: { topics: Props["topics"] } & CommonProps) {
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [kind, setKind] = useState<EditKind>("lesson");
  const [items, setItems] = useState<EditItem[]>([]);
  const [selectedId, setSelectedId] = useState("");
  const [body, setBody] = useState("");
  const [loading, setLoading] = useState(false);
  const [preview, setPreview] = useState(false);
  const taRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      if (!topicId) return;
      setLoading(true);
      setItems([]);
      setSelectedId("");
      setBody("");
      try {
        const supabase = createClient();
        let rows: EditItem[] = [];
        if (kind === "lesson") {
          const { data } = await supabase
            .from("school_lessons")
            .select("id, title, body_md, sort_order")
            .eq("topic_id", topicId)
            .order("sort_order");
          rows = (data as EditItem[]) ?? [];
        } else {
          const { data: book } = await supabase
            .from("school_books")
            .select("id")
            .eq("topic_id", topicId)
            .maybeSingle();
          if (book) {
            const { data } = await supabase
              .from("school_book_chapters")
              .select("id, title, body_md, sort_order")
              .eq("book_id", (book as { id: string }).id)
              .order("sort_order");
            rows = (data as EditItem[]) ?? [];
          }
        }
        if (!cancelled) {
          setItems(rows);
          if (rows[0]) {
            setSelectedId(rows[0].id);
            setBody(rows[0].body_md);
          }
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [topicId, kind]);

  function selectItem(id: string) {
    setSelectedId(id);
    const item = items.find((i) => i.id === id);
    setBody(item?.body_md ?? "");
    setPreview(false);
  }

  function insertAtCursor(text: string) {
    const ta = taRef.current;
    if (!ta) {
      setBody((b) => b + text);
      return;
    }
    const start = ta.selectionStart ?? body.length;
    const end = ta.selectionEnd ?? body.length;
    const next = body.slice(0, start) + text + body.slice(end);
    setBody(next);
    requestAnimationFrame(() => {
      ta.focus();
      const pos = start + text.length;
      ta.setSelectionRange(pos, pos);
    });
  }

  async function save() {
    if (!selectedId) return notify("err", "ยังไม่ได้เลือกบท");
    setBusy(true);
    try {
      const supabase = createClient();
      const table = kind === "lesson" ? "school_lessons" : "school_book_chapters";
      const { error } = await supabase
        .from(table)
        .update({ body_md: body })
        .eq("id", selectedId);
      if (error) throw error;
      setItems((prev) =>
        prev.map((i) => (i.id === selectedId ? { ...i, body_md: body } : i))
      );
      notify("ok", "บันทึกเนื้อหาแล้ว");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  // สลับลำดับกับบทข้างเคียง — หน้านักเรียนเรียง "บทที่ N" ตาม sort_order นี้ตรง ๆ
  async function moveItem(dir: -1 | 1) {
    const idx = items.findIndex((i) => i.id === selectedId);
    const swapIdx = idx + dir;
    if (idx === -1 || swapIdx < 0 || swapIdx >= items.length) return;
    const a = items[idx];
    const b = items[swapIdx];
    setBusy(true);
    try {
      const supabase = createClient();
      const table = kind === "lesson" ? "school_lessons" : "school_book_chapters";
      const [{ error: e1 }, { error: e2 }] = await Promise.all([
        supabase.from(table).update({ sort_order: b.sort_order }).eq("id", a.id),
        supabase.from(table).update({ sort_order: a.sort_order }).eq("id", b.id),
      ]);
      if (e1 || e2) throw e1 ?? e2;
      const next = [...items];
      next[idx] = { ...a, sort_order: b.sort_order };
      next[swapIdx] = { ...b, sort_order: a.sort_order };
      next.sort((x, y) => x.sort_order - y.sort_order);
      setItems(next);
      notify("ok", "สลับลำดับแล้ว");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">แก้ไขเนื้อหา + แทรกรูป</h3>
        <p className="text-xs text-muted-foreground">
          เลือกบทเรียน/บทในหนังสือ → กด &quot;อัปโหลด + แทรกรูป&quot; เพื่อวางรูปตรงเคอร์เซอร์
          (แทนที่บรรทัด <code>🖼️ รูปแนะนำ</code> ที่ AI ใส่ไว้) แล้วบันทึก
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <Field label="Topic">
            <TopicPicker topics={topics} value={topicId} onChange={setTopicId} />
          </Field>
          <Field label="ชนิด">
            <select
              value={kind}
              onChange={(e) => setKind(e.target.value as EditKind)}
              className="w-full border rounded p-2 text-sm"
            >
              <option value="lesson">Lesson (Concept Reader)</option>
              <option value="book_chapter">หนังสือ — บท</option>
            </select>
          </Field>
          <Field label={loading ? "กำลังโหลด…" : `เลือกบท (${items.length})`}>
            <div className="flex gap-1">
              <select
                value={selectedId}
                onChange={(e) => selectItem(e.target.value)}
                className="w-full border rounded p-2 text-sm"
                disabled={loading || items.length === 0}
              >
                {items.length === 0 && <option value="">— ไม่มี —</option>}
                {/* หมายเลขบทตรงกับที่นักเรียนเห็นในหน้าวิชา (ลำดับจริงจาก
                    sort_order ไม่ใช่ตัวเลข sort_order เอง ซึ่งอาจมีช่องว่าง) */}
                {items.map((i, idx) => (
                  <option key={i.id} value={i.id}>
                    {idx + 1}. {i.title}
                  </option>
                ))}
              </select>
              <Button
                type="button"
                variant="outline"
                size="icon"
                title="เลื่อนบทนี้ขึ้น"
                disabled={
                  busy || !selectedId || items.findIndex((i) => i.id === selectedId) <= 0
                }
                onClick={() => moveItem(-1)}
              >
                <ArrowUp className="h-4 w-4" />
              </Button>
              <Button
                type="button"
                variant="outline"
                size="icon"
                title="เลื่อนบทนี้ลง"
                disabled={
                  busy ||
                  !selectedId ||
                  items.findIndex((i) => i.id === selectedId) >= items.length - 1
                }
                onClick={() => moveItem(1)}
              >
                <ArrowDown className="h-4 w-4" />
              </Button>
            </div>
          </Field>
        </div>

        {selectedId && (
          <>
            <div className="flex flex-wrap items-center gap-2">
              <ImageUploader
                onUploaded={(url) => insertAtCursor(`\n\n![](${url})\n\n`)}
                label="อัปโหลด + แทรกรูป"
              />
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="gap-2"
                onClick={() => insertAtCursor("\n\n![](วางลิงก์รูปที่นี่)\n\n")}
              >
                <ImagePlus className="h-4 w-4" /> แทรกช่องรูป (วาง URL เอง)
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                className="gap-2"
                onClick={() => setPreview((p) => !p)}
              >
                <Eye className="h-4 w-4" /> {preview ? "แก้ไข" : "ดูตัวอย่าง"}
              </Button>
            </div>

            {preview ? (
              <div className="rounded border p-4 prose prose-sm prose-slate dark:prose-invert max-w-none min-h-[200px]">
                <ReactMarkdown remarkPlugins={[remarkGfm]}>{body}</ReactMarkdown>
              </div>
            ) : (
              <textarea
                ref={taRef}
                value={body}
                onChange={(e) => setBody(e.target.value)}
                className="w-full border rounded p-2 text-sm min-h-[320px] font-mono"
              />
            )}

            <Button onClick={save} disabled={busy}>
              {busy && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              บันทึก
            </Button>
          </>
        )}
      </CardContent>
    </Card>
  );
}

interface CommonProps {
  busy: boolean;
  setBusy: (b: boolean) => void;
  notify: (kind: "ok" | "err", msg: string) => void;
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

function VisualForm({ topics, busy, setBusy, notify }: { topics: Props["topics"] } & CommonProps) {
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [layer, setLayer] = useState("foundation");
  const [title, setTitle] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [caption, setCaption] = useState("");
  const [notesMd, setNotesMd] = useState("");
  const [source, setSource] = useState("");
  const [checks, setChecks] = useState<{ q: string; a: string }[]>([{ q: "", a: "" }]);
  const [linkedCardsText, setLinkedCardsText] = useState("");
  const [availableCards, setAvailableCards] = useState<
    { id: string; front: string }[]
  >([]);

  // Load flashcards for the chosen topic
  useEffect(() => {
    if (!topicId) {
      setAvailableCards([]);
      return;
    }
    let cancelled = false;
    (async () => {
      const supabase = createClient();
      const { data } = await supabase
        .from("school_flashcards")
        .select("id, front")
        .eq("topic_id", topicId)
        .eq("status", "active")
        .limit(100);
      if (!cancelled) {
        setAvailableCards(
          (data as { id: string; front: string }[] | null) ?? []
        );
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [topicId]);

  function setCheck(i: number, k: "q" | "a", v: string) {
    const c = [...checks];
    c[i] = { ...c[i], [k]: v };
    setChecks(c);
  }
  function addCheck() {
    setChecks([...checks, { q: "", a: "" }]);
  }
  function removeCheck(i: number) {
    if (checks.length <= 1) return;
    setChecks(checks.filter((_, x) => x !== i));
  }

  async function save() {
    if (!topicId || !title) {
      notify("err", "ขาด topic หรือ title");
      return;
    }
    const cleanChecks = checks.filter((c) => c.q.trim() && c.a.trim());
    const linkedIds = linkedCardsText
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
    setBusy(true);
    try {
      const supabase = createClient();
      const { error } = await supabase.from("school_visuals").insert({
        topic_id: topicId,
        layer,
        title,
        image_url: imageUrl || null,
        caption: caption || null,
        notes_md: notesMd || null,
        check_questions: cleanChecks,
        linked_flashcard_ids: linkedIds,
        source: source || null,
      });
      if (error) throw error;
      notify("ok", `เพิ่ม visual "${title}" สำเร็จ`);
      setTitle("");
      setImageUrl("");
      setCaption("");
      setNotesMd("");
      setSource("");
      setChecks([{ q: "", a: "" }]);
      setLinkedCardsText("");
    } catch (e) {
      notify("err", e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-3">
        <h3 className="font-bold">เพิ่ม Visual Summary</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
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
        </div>
        <Field label="Title">
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full border rounded p-2 text-sm"
            placeholder="เช่น Cardiac Cycle Overview"
          />
        </Field>
        <Field label="Image URL (optional — วางลิงก์ Drive / IG / Cloudinary หรืออัปโหลดไฟล์)">
          <input
            value={imageUrl}
            onChange={(e) => setImageUrl(normalizeImageUrl(e.target.value))}
            className="w-full border rounded p-2 text-sm"
            placeholder="วางลิงก์ Drive ปกติได้เลย — https://..."
          />
          <div className="mt-1">
            <ImageUploader onUploaded={setImageUrl} label="หรืออัปโหลดรูป" />
          </div>
        </Field>
        <Field label="Caption (1 line)">
          <input
            value={caption}
            onChange={(e) => setCaption(e.target.value)}
            className="w-full border rounded p-2 text-sm"
            placeholder="สรุปสั้นใต้รูป"
          />
        </Field>
        <Field label="Short notes (Markdown bullets)">
          <textarea
            value={notesMd}
            onChange={(e) => setNotesMd(e.target.value)}
            className="w-full border rounded p-2 text-sm min-h-[120px] font-mono"
            placeholder={"- จุดสำคัญที่ 1\n- จุดสำคัญที่ 2\n- ..."}
          />
        </Field>
        <Field label="Quick check questions (เด็กกดเปิดเฉลย)">
          <div className="space-y-2">
            {checks.map((c, i) => (
              <div key={i} className="flex items-start gap-2">
                <span className="text-xs font-bold w-6 mt-2">Q{i + 1}.</span>
                <div className="flex-1 space-y-1">
                  <input
                    value={c.q}
                    onChange={(e) => setCheck(i, "q", e.target.value)}
                    placeholder="คำถาม"
                    className="w-full border rounded p-2 text-sm"
                  />
                  <input
                    value={c.a}
                    onChange={(e) => setCheck(i, "a", e.target.value)}
                    placeholder="คำตอบ"
                    className="w-full border rounded p-2 text-sm bg-muted/30"
                  />
                </div>
                {checks.length > 1 && (
                  <button
                    onClick={() => removeCheck(i)}
                    className="text-muted-foreground hover:text-rose-600 mt-2"
                  >
                    <AlertCircle className="h-4 w-4" />
                  </button>
                )}
              </div>
            ))}
            <Button size="sm" variant="outline" onClick={addCheck}>
              + เพิ่ม
            </Button>
          </div>
        </Field>
        <Field label={`Linked flashcards (comma-separated UUIDs จาก topic นี้ — มี ${availableCards.length} ใบให้เลือก)`}>
          <textarea
            value={linkedCardsText}
            onChange={(e) => setLinkedCardsText(e.target.value)}
            className="w-full border rounded p-2 text-xs min-h-[60px] font-mono"
            placeholder="uuid1, uuid2, uuid3"
          />
          {availableCards.length > 0 && (
            <details className="mt-2 text-xs">
              <summary className="cursor-pointer text-muted-foreground">
                ดู UUIDs ที่มี ({availableCards.length})
              </summary>
              <ul className="mt-1 space-y-0.5 max-h-32 overflow-y-auto bg-muted/30 rounded p-2">
                {availableCards.map((c) => (
                  <li key={c.id} className="font-mono text-[10px] truncate">
                    <button
                      type="button"
                      onClick={() =>
                        setLinkedCardsText(
                          linkedCardsText
                            ? `${linkedCardsText}, ${c.id}`
                            : c.id
                        )
                      }
                      className="text-brand hover:underline"
                    >
                      + {c.id}
                    </button>{" "}
                    — {c.front.slice(0, 50)}
                  </li>
                ))}
              </ul>
            </details>
          )}
        </Field>
        <Field label="Source (optional)">
          <input
            value={source}
            onChange={(e) => setSource(e.target.value)}
            className="w-full border rounded p-2 text-sm"
            placeholder="Robbins Pathology fig 9.2 / Sketchy CVS / Anki deck"
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
