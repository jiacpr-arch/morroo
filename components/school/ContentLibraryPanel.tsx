"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { ArrowDown, ArrowUp, ExternalLink, Loader2, RefreshCw, Trash2 } from "lucide-react";

type Supabase = ReturnType<typeof createClient>;

interface TopicOption {
  id: string;
  year: number;
  term?: number | null;
  name_th: string;
  code?: string | null;
  school_systems?: { name_th: string; icon?: string } | null;
}

interface Props {
  topics: TopicOption[];
  busy: boolean;
  setBusy: (b: boolean) => void;
  notify: (kind: "ok" | "err", msg: string) => void;
}

interface TopicCounts {
  lessons: number;
  chapters: number;
  flashcards: number;
  quizzes: number;
}
const ZERO: TopicCounts = { lessons: 0, chapters: 0, flashcards: 0, quizzes: 0 };

interface Sortable {
  id: string;
  sort_order: number;
}
interface LessonRow extends Sortable {
  title: string;
  layer: string;
  estimated_min: number;
  source: string | null;
  status: string;
  created_at: string;
}
interface ChapterRow extends Sortable {
  title: string;
  source: string | null;
  created_at: string;
}
interface FlashcardRow {
  id: string;
  front: string;
  difficulty: string;
  source: string | null;
  status: string;
  created_at: string;
}
interface QuizRow {
  id: string;
  stem: string;
  difficulty: string;
  source: string | null;
  status: string;
  created_at: string;
}

interface TopicDetail {
  lessons: LessonRow[];
  book: { id: string; title: string } | null;
  chapters: ChapterRow[];
  flashcards: FlashcardRow[];
  quizzes: QuizRow[];
}

/** Everything one uploaded file produced (rows share `source` = file name). */
interface Batch {
  source: string | null;
  firstAt: string;
  lessons: LessonRow[];
  flashcards: number;
  quizzes: number;
}

const PAGE = 1000;
const YEARS = [1, 2, 3, 4, 5, 6];

// PostgREST caps a select at 1000 rows; page through so per-subject counts
// stay right once the flashcard bank grows past that.
async function fetchAll<T>(supabase: Supabase, table: string, columns: string): Promise<T[]> {
  const out: T[] = [];
  for (let from = 0; ; from += PAGE) {
    const { data, error } = await supabase
      .from(table)
      .select(columns)
      .range(from, from + PAGE - 1);
    if (error) throw error;
    const rows = (data as T[] | null) ?? [];
    out.push(...rows);
    if (rows.length < PAGE) break;
  }
  return out;
}

function errMsg(e: unknown) {
  if (e && typeof e === "object" && "message" in e && typeof e.message === "string") {
    return e.message;
  }
  return "เกิดข้อผิดพลาด";
}

function fmtDate(iso: string) {
  return new Date(iso).toLocaleDateString("th-TH", {
    day: "numeric",
    month: "short",
    year: "2-digit",
  });
}

function termLabel(term: number | null | undefined) {
  if (term === 3) return "ภาคฤดูร้อน";
  if (term) return `เทอม ${term}`;
  return null;
}

function topicMeta(t: TopicOption) {
  const parts = [`ปี ${t.year}`];
  const term = termLabel(t.term);
  if (term) parts.push(term);
  if (t.code) parts.push(t.code);
  return parts.join(" · ");
}

function sourceLabel(source: string | null) {
  return source ?? "(ไม่ระบุไฟล์ต้นทาง)";
}

export default function ContentLibraryPanel({ topics, busy, setBusy, notify }: Props) {
  const [counts, setCounts] = useState<Record<string, TopicCounts>>({});
  const [countsLoading, setCountsLoading] = useState(true);
  const [year, setYear] = useState<number | null>(null);
  const [showEmpty, setShowEmpty] = useState(false);
  const [topicId, setTopicId] = useState("");
  const [detail, setDetail] = useState<TopicDetail | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);

  const loadCounts = useCallback(async () => {
    setCountsLoading(true);
    try {
      const supabase = createClient();
      const [lessons, flashcards, quizzes, books, chapters] = await Promise.all([
        fetchAll<{ topic_id: string }>(supabase, "school_lessons", "topic_id"),
        fetchAll<{ topic_id: string }>(supabase, "school_flashcards", "topic_id"),
        fetchAll<{ topic_id: string }>(supabase, "school_quizzes", "topic_id"),
        fetchAll<{ id: string; topic_id: string }>(supabase, "school_books", "id, topic_id"),
        fetchAll<{ book_id: string }>(supabase, "school_book_chapters", "book_id"),
      ]);
      const next: Record<string, TopicCounts> = {};
      const bump = (tid: string, key: keyof TopicCounts) => {
        const cur = next[tid] ?? ZERO;
        next[tid] = { ...cur, [key]: cur[key] + 1 };
      };
      lessons.forEach((r) => bump(r.topic_id, "lessons"));
      flashcards.forEach((r) => bump(r.topic_id, "flashcards"));
      quizzes.forEach((r) => bump(r.topic_id, "quizzes"));
      const bookTopic = new Map(books.map((b) => [b.id, b.topic_id]));
      chapters.forEach((c) => {
        const tid = bookTopic.get(c.book_id);
        if (tid) bump(tid, "chapters");
      });
      setCounts(next);
    } catch (e) {
      notify("err", errMsg(e));
    } finally {
      setCountsLoading(false);
    }
  }, [notify]);

  useEffect(() => {
    void loadCounts();
  }, [loadCounts]);

  const loadTopic = useCallback(
    async (id: string) => {
      setDetailLoading(true);
      try {
        const supabase = createClient();
        const [ls, bk, fc, qz] = await Promise.all([
          supabase
            .from("school_lessons")
            .select("id, title, layer, estimated_min, sort_order, source, status, created_at")
            .eq("topic_id", id)
            .order("sort_order")
            .order("created_at"),
          supabase.from("school_books").select("id, title").eq("topic_id", id).maybeSingle(),
          supabase
            .from("school_flashcards")
            .select("id, front, difficulty, source, status, created_at")
            .eq("topic_id", id)
            .order("created_at")
            .limit(PAGE),
          supabase
            .from("school_quizzes")
            .select("id, stem, difficulty, source, status, created_at")
            .eq("topic_id", id)
            .order("created_at")
            .limit(PAGE),
        ]);
        const err = ls.error ?? bk.error ?? fc.error ?? qz.error;
        if (err) throw err;

        const book = (bk.data as { id: string; title: string } | null) ?? null;
        let chapters: ChapterRow[] = [];
        if (book) {
          const { data, error } = await supabase
            .from("school_book_chapters")
            .select("id, title, sort_order, source, created_at")
            .eq("book_id", book.id)
            .order("sort_order")
            .order("created_at");
          if (error) throw error;
          chapters = (data as ChapterRow[] | null) ?? [];
        }

        const next: TopicDetail = {
          lessons: (ls.data as LessonRow[] | null) ?? [],
          book,
          chapters,
          flashcards: (fc.data as FlashcardRow[] | null) ?? [],
          quizzes: (qz.data as QuizRow[] | null) ?? [],
        };
        setDetail(next);
        setCounts((prev) => ({
          ...prev,
          [id]: {
            lessons: next.lessons.length,
            chapters: next.chapters.length,
            flashcards: next.flashcards.length,
            quizzes: next.quizzes.length,
          },
        }));
      } catch (e) {
        notify("err", errMsg(e));
      } finally {
        setDetailLoading(false);
      }
    },
    [notify],
  );

  useEffect(() => {
    if (topicId) void loadTopic(topicId);
  }, [topicId, loadTopic]);

  function selectTopic(id: string) {
    setTopicId(id);
    setDetail(null);
    setDetailLoading(true);
  }

  const visibleTopics = useMemo(
    () =>
      topics.filter((t) => {
        if (year !== null && t.year !== year) return false;
        if (showEmpty) return true;
        const c = counts[t.id];
        return !!c && c.lessons + c.chapters + c.flashcards + c.quizzes > 0;
      }),
    [topics, year, showEmpty, counts],
  );
  const topicsWithContent = useMemo(
    () => topics.filter((t) => counts[t.id]).length,
    [topics, counts],
  );
  const selectedTopic = topics.find((t) => t.id === topicId) ?? null;

  const batches = useMemo<Batch[]>(() => {
    if (!detail) return [];
    const map = new Map<string | null, Batch>();
    const get = (source: string | null, at: string) => {
      let b = map.get(source);
      if (!b) {
        b = { source, firstAt: at, lessons: [], flashcards: 0, quizzes: 0 };
        map.set(source, b);
      }
      if (at < b.firstAt) b.firstAt = at;
      return b;
    };
    detail.lessons.forEach((l) => get(l.source, l.created_at).lessons.push(l));
    detail.flashcards.forEach((f) => {
      get(f.source, f.created_at).flashcards += 1;
    });
    detail.quizzes.forEach((q) => {
      get(q.source, q.created_at).quizzes += 1;
    });
    return Array.from(map.values()).sort((a, b) => (a.firstAt < b.firstAt ? 1 : -1));
  }, [detail]);

  // Renumber the whole list instead of swapping two values: rows from older
  // imports all share sort_order 0, so a plain swap would be a no-op.
  async function reorder<T extends Sortable>(
    table: string,
    list: T[],
    index: number,
    dir: -1 | 1,
  ): Promise<T[] | null> {
    const target = index + dir;
    if (target < 0 || target >= list.length) return null;
    const next = [...list];
    [next[index], next[target]] = [next[target], next[index]];
    const supabase = createClient();
    const updates = next
      .map((row, i) => ({ row, i }))
      .filter(({ row, i }) => row.sort_order !== i)
      .map(({ row, i }) => supabase.from(table).update({ sort_order: i }).eq("id", row.id));
    const results = await Promise.all(updates);
    const failed = results.find((r) => r.error);
    if (failed?.error) throw failed.error;
    return next.map((row, i) => ({ ...row, sort_order: i }));
  }

  async function moveLesson(index: number, dir: -1 | 1) {
    if (!detail) return;
    setBusy(true);
    try {
      const next = await reorder("school_lessons", detail.lessons, index, dir);
      if (next) {
        setDetail({ ...detail, lessons: next });
        notify("ok", "เรียงลำดับบทเรียนใหม่แล้ว");
      }
    } catch (e) {
      notify("err", errMsg(e));
    } finally {
      setBusy(false);
    }
  }

  async function moveChapter(index: number, dir: -1 | 1) {
    if (!detail) return;
    setBusy(true);
    try {
      const next = await reorder("school_book_chapters", detail.chapters, index, dir);
      if (next) {
        setDetail({ ...detail, chapters: next });
        notify("ok", "เรียงลำดับบทหนังสือใหม่แล้ว");
      }
    } catch (e) {
      notify("err", errMsg(e));
    } finally {
      setBusy(false);
    }
  }

  async function removeRow(table: string, id: string, label: string) {
    if (!topicId) return;
    if (!window.confirm(`ลบ "${label}"?\n\nลบแล้วกู้คืนไม่ได้`)) return;
    setBusy(true);
    try {
      const { error } = await createClient().from(table).delete().eq("id", id);
      if (error) throw error;
      notify("ok", "ลบแล้ว");
      await loadTopic(topicId);
    } catch (e) {
      notify("err", errMsg(e));
    } finally {
      setBusy(false);
    }
  }

  async function removeBatch(b: Batch) {
    if (!topicId) return;
    const summary = `บทเรียน ${b.lessons.length} · Flashcards ${b.flashcards} · ข้อสอบ ${b.quizzes}`;
    if (!window.confirm(`ลบทั้งชุด "${sourceLabel(b.source)}"?\n${summary}\n\nลบแล้วกู้คืนไม่ได้`)) {
      return;
    }
    setBusy(true);
    try {
      const supabase = createClient();
      const scoped = (table: string) => {
        const q = supabase.from(table).delete().eq("topic_id", topicId);
        return b.source === null ? q.is("source", null) : q.eq("source", b.source);
      };
      const results = await Promise.all(
        ["school_lessons", "school_flashcards", "school_quizzes"].map(scoped),
      );
      const failed = results.find((r) => r.error);
      if (failed?.error) throw failed.error;
      notify("ok", `ลบชุด "${sourceLabel(b.source)}" แล้ว`);
      await loadTopic(topicId);
    } catch (e) {
      notify("err", errMsg(e));
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardContent className="p-4 space-y-3">
          <div className="flex flex-wrap items-start justify-between gap-2">
            <div>
              <h3 className="font-bold">เนื้อหาที่มีอยู่ในระบบ</h3>
              <p className="text-xs text-muted-foreground">
                {countsLoading
                  ? "กำลังนับเนื้อหาทุกวิชา…"
                  : `มีเนื้อหาแล้ว ${topicsWithContent} วิชา — กดวิชาเพื่อดูรายการ ลบ หรือจัดลำดับบทเรียน`}
              </p>
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => void loadCounts()}
              disabled={countsLoading}
            >
              {countsLoading ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <RefreshCw className="h-4 w-4" />
              )}
              <span className="ml-1">รีเฟรช</span>
            </Button>
          </div>

          <div className="flex flex-wrap items-center gap-1">
            <Chip active={year === null} onClick={() => setYear(null)}>
              ทุกปี
            </Chip>
            {YEARS.map((y) => (
              <Chip key={y} active={year === y} onClick={() => setYear(y)}>
                ปี {y}
              </Chip>
            ))}
            <label className="ml-auto flex items-center gap-1 text-xs text-muted-foreground">
              <input
                type="checkbox"
                checked={showEmpty}
                onChange={(e) => setShowEmpty(e.target.checked)}
              />
              แสดงวิชาที่ยังไม่มีเนื้อหา
            </label>
          </div>

          <div className="overflow-x-auto rounded border">
            <table className="w-full text-sm">
              <thead className="bg-muted/50 text-left text-xs">
                <tr>
                  <th className="px-3 py-2 font-medium">วิชา</th>
                  <th className="px-3 py-2 font-medium text-right">บทเรียน</th>
                  <th className="px-3 py-2 font-medium text-right">บทหนังสือ</th>
                  <th className="px-3 py-2 font-medium text-right">Flashcards</th>
                  <th className="px-3 py-2 font-medium text-right">ข้อสอบ</th>
                </tr>
              </thead>
              <tbody>
                {countsLoading && Object.keys(counts).length === 0 && (
                  <tr>
                    <td colSpan={5} className="px-3 py-6 text-center text-muted-foreground">
                      กำลังโหลด…
                    </td>
                  </tr>
                )}
                {!countsLoading && visibleTopics.length === 0 && (
                  <tr>
                    <td colSpan={5} className="px-3 py-6 text-center text-muted-foreground">
                      ยังไม่มีวิชาที่มีเนื้อหา{year ? ` ในปี ${year}` : ""}
                    </td>
                  </tr>
                )}
                {visibleTopics.map((t) => {
                  const c = counts[t.id] ?? ZERO;
                  const selected = t.id === topicId;
                  return (
                    <tr
                      key={t.id}
                      onClick={() => selectTopic(t.id)}
                      className={`cursor-pointer border-t hover:bg-muted/40 ${
                        selected ? "bg-muted/60" : ""
                      }`}
                    >
                      <td className="px-3 py-2">
                        <div className="flex items-center gap-2">
                          <span className="shrink-0">{t.school_systems?.icon}</span>
                          <div className="min-w-0">
                            <p className={`line-clamp-1 ${selected ? "font-bold" : "font-medium"}`}>
                              {t.name_th}
                            </p>
                            <p className="text-xs text-muted-foreground">{topicMeta(t)}</p>
                          </div>
                        </div>
                      </td>
                      <td className="px-3 py-2 text-right tabular-nums">{c.lessons}</td>
                      <td className="px-3 py-2 text-right tabular-nums">{c.chapters}</td>
                      <td className="px-3 py-2 text-right tabular-nums">{c.flashcards}</td>
                      <td className="px-3 py-2 text-right tabular-nums">{c.quizzes}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {selectedTopic && (
        <Card>
          <CardContent className="p-4 space-y-5">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div>
                <h3 className="font-bold">
                  {selectedTopic.school_systems?.icon} {selectedTopic.name_th}
                </h3>
                <p className="text-xs text-muted-foreground">{topicMeta(selectedTopic)}</p>
              </div>
              <Link
                href={`/school/topic/${selectedTopic.id}`}
                target="_blank"
                className="inline-flex items-center gap-1 text-xs text-brand hover:underline"
              >
                <ExternalLink className="h-3 w-3" /> เปิดหน้าที่นักเรียนเห็น
              </Link>
            </div>

            {detailLoading ? (
              <div className="flex items-center justify-center py-10">
                <Loader2 className="h-6 w-6 animate-spin text-brand" />
              </div>
            ) : !detail ? (
              <p className="py-6 text-center text-sm text-muted-foreground">
                โหลดรายการไม่สำเร็จ — กดวิชาอีกครั้ง
              </p>
            ) : (
              <>
                <section className="space-y-2">
                  <h4 className="text-sm font-semibold">ไฟล์ที่อัปโหลดแล้ว ({batches.length})</h4>
                  <p className="text-xs text-muted-foreground">
                    จัดกลุ่มตามชื่อไฟล์ต้นทาง — &quot;ลบทั้งชุด&quot; จะลบบทเรียน flashcards
                    และข้อสอบที่มาจากไฟล์นั้นพร้อมกัน
                  </p>
                  {batches.length === 0 && (
                    <p className="text-sm text-muted-foreground">ยังไม่มีเนื้อหาในวิชานี้</p>
                  )}
                  <div className="space-y-2">
                    {batches.map((b) => (
                      <div
                        key={b.source ?? "__none__"}
                        className="flex flex-wrap items-center justify-between gap-2 rounded border p-3"
                      >
                        <div className="min-w-0 flex-1">
                          <p className="truncate text-sm font-medium">{sourceLabel(b.source)}</p>
                          <p className="text-xs text-muted-foreground">
                            อัปโหลด {fmtDate(b.firstAt)} · บทเรียน {b.lessons.length} · Flashcards{" "}
                            {b.flashcards} · ข้อสอบ {b.quizzes}
                          </p>
                          {b.lessons.length > 0 && (
                            <p className="line-clamp-1 text-xs text-muted-foreground">
                              {b.lessons.map((l) => l.title).join(" · ")}
                            </p>
                          )}
                        </div>
                        <Button
                          type="button"
                          size="sm"
                          variant="outline"
                          className="text-red-600"
                          disabled={busy}
                          onClick={() => void removeBatch(b)}
                        >
                          <Trash2 className="mr-1 h-4 w-4" /> ลบทั้งชุด
                        </Button>
                      </div>
                    ))}
                  </div>
                </section>

                <section className="space-y-2">
                  <h4 className="text-sm font-semibold">บทเรียน ({detail.lessons.length})</h4>
                  <p className="text-xs text-muted-foreground">
                    ลำดับนี้คือ &quot;บทที่ N&quot; ที่นักเรียนเห็นในหน้าวิชา — กดลูกศรเพื่อสลับ
                  </p>
                  {detail.lessons.length === 0 ? (
                    <p className="text-sm text-muted-foreground">ยังไม่มีบทเรียน</p>
                  ) : (
                    <ol className="divide-y rounded border">
                      {detail.lessons.map((l, i) => (
                        <li key={l.id} className="flex items-center gap-2 p-2">
                          <span className="w-7 shrink-0 text-center text-xs font-bold text-muted-foreground">
                            {i + 1}
                          </span>
                          <div className="min-w-0 flex-1">
                            <p className="truncate text-sm font-medium">{l.title}</p>
                            <p className="truncate text-xs text-muted-foreground">
                              {l.layer} · {l.estimated_min} นาที · {fmtDate(l.created_at)}
                              {l.source ? ` · ${l.source}` : ""}
                            </p>
                          </div>
                          <HiddenBadge status={l.status} />
                          <Link
                            href={`/school/lesson/${l.id}`}
                            target="_blank"
                            title="เปิดหน้านักเรียน"
                            className="text-muted-foreground hover:text-foreground"
                          >
                            <ExternalLink className="h-4 w-4" />
                          </Link>
                          <MoveButtons
                            disabled={busy}
                            isFirst={i === 0}
                            isLast={i === detail.lessons.length - 1}
                            onMove={(dir) => void moveLesson(i, dir)}
                          />
                          <RemoveButton
                            disabled={busy}
                            title="ลบบทเรียน"
                            onClick={() => void removeRow("school_lessons", l.id, l.title)}
                          />
                        </li>
                      ))}
                    </ol>
                  )}
                </section>

                {detail.book && (
                  <section className="space-y-2">
                    <div className="flex flex-wrap items-center justify-between gap-2">
                      <h4 className="text-sm font-semibold">
                        หนังสือ — {detail.book.title} ({detail.chapters.length} บท)
                      </h4>
                      <Link
                        href={`/school/book/${detail.book.id}`}
                        target="_blank"
                        className="inline-flex items-center gap-1 text-xs text-brand hover:underline"
                      >
                        <ExternalLink className="h-3 w-3" /> เปิดหนังสือ
                      </Link>
                    </div>
                    {detail.chapters.length === 0 ? (
                      <p className="text-sm text-muted-foreground">ยังไม่มีบทในหนังสือ</p>
                    ) : (
                      <ol className="divide-y rounded border">
                        {detail.chapters.map((c, i) => (
                          <li key={c.id} className="flex items-center gap-2 p-2">
                            <span className="w-7 shrink-0 text-center text-xs font-bold text-muted-foreground">
                              {i + 1}
                            </span>
                            <div className="min-w-0 flex-1">
                              <p className="truncate text-sm font-medium">{c.title}</p>
                              <p className="truncate text-xs text-muted-foreground">
                                {fmtDate(c.created_at)}
                                {c.source ? ` · ${c.source}` : ""}
                              </p>
                            </div>
                            <MoveButtons
                              disabled={busy}
                              isFirst={i === 0}
                              isLast={i === detail.chapters.length - 1}
                              onMove={(dir) => void moveChapter(i, dir)}
                            />
                            <RemoveButton
                              disabled={busy}
                              title="ลบบทนี้"
                              onClick={() =>
                                void removeRow("school_book_chapters", c.id, c.title)
                              }
                            />
                          </li>
                        ))}
                      </ol>
                    )}
                  </section>
                )}

                <details className="rounded border">
                  <summary className="cursor-pointer px-3 py-2 text-sm font-semibold">
                    Flashcards ({detail.flashcards.length}
                    {detail.flashcards.length >= PAGE ? "+ แสดง 1000 ใบแรก" : ""})
                  </summary>
                  {detail.flashcards.length === 0 ? (
                    <p className="border-t p-3 text-sm text-muted-foreground">ยังไม่มี flashcard</p>
                  ) : (
                    <ul className="max-h-96 divide-y overflow-y-auto border-t">
                      {detail.flashcards.map((f) => (
                        <li key={f.id} className="flex items-center gap-2 p-2">
                          <div className="min-w-0 flex-1">
                            <p className="truncate text-sm">{f.front}</p>
                            <p className="truncate text-xs text-muted-foreground">
                              {f.difficulty}
                              {f.source ? ` · ${f.source}` : ""}
                            </p>
                          </div>
                          <HiddenBadge status={f.status} />
                          <RemoveButton
                            disabled={busy}
                            title="ลบ flashcard"
                            onClick={() => void removeRow("school_flashcards", f.id, f.front)}
                          />
                        </li>
                      ))}
                    </ul>
                  )}
                </details>

                <details className="rounded border">
                  <summary className="cursor-pointer px-3 py-2 text-sm font-semibold">
                    ข้อสอบ ({detail.quizzes.length}
                    {detail.quizzes.length >= PAGE ? "+ แสดง 1000 ข้อแรก" : ""})
                  </summary>
                  {detail.quizzes.length === 0 ? (
                    <p className="border-t p-3 text-sm text-muted-foreground">ยังไม่มีข้อสอบ</p>
                  ) : (
                    <ul className="max-h-96 divide-y overflow-y-auto border-t">
                      {detail.quizzes.map((q) => (
                        <li key={q.id} className="flex items-center gap-2 p-2">
                          <div className="min-w-0 flex-1">
                            <p className="line-clamp-2 text-sm">{q.stem}</p>
                            <p className="truncate text-xs text-muted-foreground">
                              {q.difficulty}
                              {q.source ? ` · ${q.source}` : ""}
                            </p>
                          </div>
                          <HiddenBadge status={q.status} />
                          <RemoveButton
                            disabled={busy}
                            title="ลบข้อสอบ"
                            onClick={() => void removeRow("school_quizzes", q.id, q.stem)}
                          />
                        </li>
                      ))}
                    </ul>
                  )}
                </details>
              </>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}

function Chip({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`rounded-full border px-3 py-1 text-xs transition-colors ${
        active ? "border-brand bg-muted font-semibold text-brand" : "hover:bg-muted"
      }`}
    >
      {children}
    </button>
  );
}

/** Students only ever see status = active; flag anything else so it isn't mistaken for a bug. */
function HiddenBadge({ status }: { status: string }) {
  if (status === "active") return null;
  return (
    <Badge variant="outline" className="shrink-0 text-amber-700">
      ซ่อน ({status})
    </Badge>
  );
}

function MoveButtons({
  disabled,
  isFirst,
  isLast,
  onMove,
}: {
  disabled: boolean;
  isFirst: boolean;
  isLast: boolean;
  onMove: (dir: -1 | 1) => void;
}) {
  return (
    <>
      <Button
        type="button"
        variant="outline"
        size="icon"
        title="เลื่อนขึ้น"
        disabled={disabled || isFirst}
        onClick={() => onMove(-1)}
      >
        <ArrowUp className="h-4 w-4" />
      </Button>
      <Button
        type="button"
        variant="outline"
        size="icon"
        title="เลื่อนลง"
        disabled={disabled || isLast}
        onClick={() => onMove(1)}
      >
        <ArrowDown className="h-4 w-4" />
      </Button>
    </>
  );
}

function RemoveButton({
  disabled,
  title,
  onClick,
}: {
  disabled: boolean;
  title: string;
  onClick: () => void;
}) {
  return (
    <Button
      type="button"
      variant="outline"
      size="icon"
      title={title}
      className="shrink-0 text-red-600"
      disabled={disabled}
      onClick={onClick}
    >
      <Trash2 className="h-4 w-4" />
    </Button>
  );
}
