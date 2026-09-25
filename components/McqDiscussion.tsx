"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import {
  ChevronDown,
  ChevronUp,
  Flag,
  Loader2,
  MessageCircle,
  Pencil,
  ThumbsUp,
  Trash2,
  EyeOff,
} from "lucide-react";
import {
  COMMENT_MAX_LENGTH,
  COMMENT_REPORT_REASONS,
  COMMENT_REPORT_REASON_LABELS,
  relativeTimeTh,
  type CommentReportReason,
  type CommentThread,
  type PublicComment,
} from "@/lib/mcq-comments";

interface McqDiscussionProps {
  questionId: string;
  /** null = not signed in → show a login prompt instead of the thread. */
  userId: string | null;
}

/**
 * Per-question discussion thread. Rendered by McqPractice only after the
 * student has answered, so comments can't spoil the answer.
 */
export default function McqDiscussion({ questionId, userId }: McqDiscussionProps) {
  const [open, setOpen] = useState(false);
  const [threads, setThreads] = useState<CommentThread[] | null>(null);
  const [count, setCount] = useState<number | null>(null);
  const [loadError, setLoadError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      const res = await fetch(
        `/api/mcq/comments?question_id=${encodeURIComponent(questionId)}`
      );
      const json = (await res.json()) as {
        threads?: CommentThread[];
        count?: number;
        error?: string;
      };
      if (!res.ok) {
        setLoadError(json.error ?? "โหลดความคิดเห็นไม่สำเร็จ");
        return;
      }
      setThreads(json.threads ?? []);
      setCount(json.count ?? 0);
      setLoadError(null);
    } catch {
      setLoadError("โหลดความคิดเห็นไม่สำเร็จ");
    }
  }, [questionId]);

  // Fetch once on mount so the header can show the count while collapsed.
  useEffect(() => {
    if (!userId) return;
    void load();
  }, [userId, load]);

  const patchComment = useCallback(
    (id: string, patch: Partial<PublicComment>) => {
      setThreads((prev) =>
        prev
          ? prev.map((t) =>
              t.id === id
                ? { ...t, ...patch }
                : {
                    ...t,
                    replies: t.replies.map((r) => (r.id === id ? { ...r, ...patch } : r)),
                  }
            )
          : prev
      );
    },
    []
  );

  return (
    <Card className="border-dashed">
      <CardContent className="p-0">
        <button
          type="button"
          onClick={() => setOpen((o) => !o)}
          aria-expanded={open}
          className="flex w-full items-center justify-between px-4 py-3 text-left text-sm font-semibold hover:bg-muted/40"
        >
          <span>
            💬 อภิปราย{count !== null ? ` (${count})` : ""}
          </span>
          {open ? (
            <ChevronUp className="h-4 w-4 text-muted-foreground" />
          ) : (
            <ChevronDown className="h-4 w-4 text-muted-foreground" />
          )}
        </button>

        {open && (
          <div className="border-t px-4 py-4 space-y-4">
            {!userId ? (
              <p className="text-sm text-muted-foreground">
                <Link href="/login" className="text-brand underline underline-offset-2">
                  เข้าสู่ระบบ
                </Link>{" "}
                เพื่ออ่านและร่วมอภิปรายข้อนี้กับเพื่อน ๆ
              </p>
            ) : (
              <>
                <Composer
                  questionId={questionId}
                  parentId={null}
                  placeholder="แชร์วิธีคิด เทคนิคจำ หรือถามเพื่อน ๆ เกี่ยวกับข้อนี้…"
                  onPosted={load}
                />

                {loadError && <p className="text-sm text-red-600">{loadError}</p>}

                {threads === null && !loadError ? (
                  <div className="flex justify-center py-4">
                    <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
                  </div>
                ) : threads && threads.length === 0 ? (
                  <p className="text-sm text-muted-foreground text-center py-2">
                    ยังไม่มีใครอภิปรายข้อนี้ — เริ่มเป็นคนแรกเลย!
                  </p>
                ) : (
                  <ul className="space-y-4">
                    {threads?.map((t) => (
                      <li key={t.id} className="space-y-3">
                        <CommentItem
                          comment={t}
                          questionId={questionId}
                          canReply={t.status === "visible"}
                          onChanged={load}
                          onPatch={patchComment}
                        />
                        {t.replies.length > 0 && (
                          <ul className="ml-10 space-y-3 border-l pl-3">
                            {t.replies.map((r) => (
                              <li key={r.id}>
                                <CommentItem
                                  comment={r}
                                  questionId={questionId}
                                  canReply={false}
                                  onChanged={load}
                                  onPatch={patchComment}
                                />
                              </li>
                            ))}
                          </ul>
                        )}
                      </li>
                    ))}
                  </ul>
                )}
              </>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

// ---------------------------------------------------------------------------

function Composer({
  questionId,
  parentId,
  placeholder,
  onPosted,
  onCancel,
  autoFocus,
}: {
  questionId: string;
  parentId: string | null;
  placeholder: string;
  onPosted: () => void | Promise<void>;
  onCancel?: () => void;
  autoFocus?: boolean;
}) {
  const [body, setBody] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const trimmedLength = body.trim().length;

  async function submit() {
    setSubmitting(true);
    setError(null);
    try {
      const res = await fetch("/api/mcq/comments", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ question_id: questionId, parent_id: parentId, body }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        setError(json.error ?? "ส่งไม่สำเร็จ");
        return;
      }
      setBody("");
      await onPosted();
    } catch {
      setError("ส่งไม่สำเร็จ ลองใหม่อีกครั้ง");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="space-y-2">
      <Textarea
        value={body}
        onChange={(e) => setBody(e.target.value)}
        placeholder={placeholder}
        maxLength={COMMENT_MAX_LENGTH}
        rows={parentId ? 2 : 3}
        autoFocus={autoFocus}
      />
      <div className="flex items-center justify-between gap-2">
        <span className="text-xs text-muted-foreground tabular-nums">
          {body.length}/{COMMENT_MAX_LENGTH}
        </span>
        <div className="flex gap-2">
          {onCancel && (
            <Button size="sm" variant="ghost" onClick={onCancel} disabled={submitting}>
              ยกเลิก
            </Button>
          )}
          <Button
            size="sm"
            onClick={submit}
            disabled={submitting || trimmedLength === 0}
            className="gap-1"
          >
            {submitting && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
            {parentId ? "ตอบกลับ" : "โพสต์"}
          </Button>
        </div>
      </div>
      {error && <p className="text-xs text-red-600">{error}</p>}
    </div>
  );
}

// ---------------------------------------------------------------------------

function CommentItem({
  comment,
  questionId,
  canReply,
  onChanged,
  onPatch,
}: {
  comment: PublicComment;
  questionId: string;
  canReply: boolean;
  onChanged: () => void | Promise<void>;
  onPatch: (id: string, patch: Partial<PublicComment>) => void;
}) {
  const [mode, setMode] = useState<"view" | "edit" | "reply" | "report">("view");
  const [editBody, setEditBody] = useState(comment.body);
  const [reason, setReason] = useState<CommentReportReason>("spam");
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [reported, setReported] = useState(false);
  const hidden = comment.status === "hidden";

  async function call(
    url: string,
    init: RequestInit
  ): Promise<{ ok: boolean; json: Record<string, unknown> }> {
    setBusy(true);
    setMessage(null);
    try {
      const res = await fetch(url, {
        ...init,
        headers: { "Content-Type": "application/json" },
      });
      const json = (await res.json().catch(() => ({}))) as Record<string, unknown>;
      if (!res.ok) setMessage((json.error as string) ?? "ทำรายการไม่สำเร็จ");
      return { ok: res.ok, json };
    } catch {
      setMessage("ทำรายการไม่สำเร็จ");
      return { ok: false, json: {} };
    } finally {
      setBusy(false);
    }
  }

  async function toggleVote() {
    // Optimistic — the list isn't re-sorted until the next load so the
    // comment doesn't jump away from under the cursor.
    const prev = { has_voted: comment.has_voted, upvotes: comment.upvotes };
    onPatch(comment.id, {
      has_voted: !prev.has_voted,
      upvotes: prev.upvotes + (prev.has_voted ? -1 : 1),
    });
    const { ok, json } = await call(`/api/mcq/comments/${comment.id}/vote`, {
      method: "POST",
    });
    if (ok) {
      onPatch(comment.id, {
        has_voted: Boolean(json.voted),
        upvotes: Number(json.upvotes ?? 0),
      });
    } else {
      onPatch(comment.id, prev);
    }
  }

  async function saveEdit() {
    const { ok } = await call(`/api/mcq/comments/${comment.id}`, {
      method: "PATCH",
      body: JSON.stringify({ body: editBody }),
    });
    if (ok) {
      setMode("view");
      await onChanged();
    }
  }

  async function remove() {
    if (!window.confirm("ลบความคิดเห็นนี้? (คำตอบกลับทั้งหมดจะถูกลบด้วย)")) return;
    const { ok } = await call(`/api/mcq/comments/${comment.id}`, { method: "DELETE" });
    if (ok) await onChanged();
  }

  async function report() {
    const { ok } = await call(`/api/mcq/comments/${comment.id}/report`, {
      method: "POST",
      body: JSON.stringify({ reason }),
    });
    if (ok) {
      setReported(true);
      setMode("view");
      setMessage("ขอบคุณที่ช่วยดูแลชุมชน — ทีมงานจะตรวจสอบ");
    }
  }

  return (
    <div className="flex gap-2.5">
      <div
        aria-hidden
        className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-brand/10 text-sm font-semibold text-brand"
      >
        {comment.author.initial}
      </div>
      <div className="min-w-0 flex-1 space-y-1">
        <div className="flex flex-wrap items-center gap-x-2 gap-y-0.5 text-xs">
          <span className="font-semibold text-foreground">{comment.author.name}</span>
          {comment.author.is_admin && (
            <span className="rounded bg-brand/10 px-1.5 py-0.5 text-[10px] font-semibold text-brand">
              ทีมงาน
            </span>
          )}
          {comment.is_mine && <span className="text-muted-foreground">(คุณ)</span>}
          <span className="text-muted-foreground">
            {relativeTimeTh(comment.created_at)}
            {comment.edited_at && " · แก้ไขแล้ว"}
          </span>
        </div>

        {hidden && (
          <p className="flex items-center gap-1 text-xs text-amber-700">
            <EyeOff className="h-3.5 w-3.5" />
            ความคิดเห็นนี้ถูกซ่อนเพื่อตรวจสอบ — มีเพียงคุณที่มองเห็น
          </p>
        )}

        {mode === "edit" ? (
          <div className="space-y-2">
            <Textarea
              value={editBody}
              onChange={(e) => setEditBody(e.target.value)}
              maxLength={COMMENT_MAX_LENGTH}
              rows={3}
            />
            <div className="flex gap-2">
              <Button
                size="sm"
                onClick={saveEdit}
                disabled={busy || editBody.trim().length === 0}
              >
                บันทึก
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={() => {
                  setEditBody(comment.body);
                  setMode("view");
                }}
                disabled={busy}
              >
                ยกเลิก
              </Button>
            </div>
          </div>
        ) : (
          <p
            className={`whitespace-pre-wrap break-words text-sm ${
              hidden ? "text-muted-foreground" : ""
            }`}
          >
            {comment.body}
          </p>
        )}

        {mode !== "edit" && (
          <div className="flex flex-wrap items-center gap-1 pt-0.5">
            <Button
              size="xs"
              variant="ghost"
              onClick={toggleVote}
              disabled={busy || comment.is_mine || hidden}
              aria-pressed={comment.has_voted}
              className={`gap-1 ${comment.has_voted ? "text-brand" : "text-muted-foreground"}`}
              title={comment.is_mine ? "โหวตความคิดเห็นของตัวเองไม่ได้" : "มีประโยชน์"}
            >
              <ThumbsUp className={`h-3 w-3 ${comment.has_voted ? "fill-current" : ""}`} />
              <span className="tabular-nums">{comment.upvotes}</span>
            </Button>
            {canReply && (
              <Button
                size="xs"
                variant="ghost"
                onClick={() => setMode(mode === "reply" ? "view" : "reply")}
                className="gap-1 text-muted-foreground"
              >
                <MessageCircle className="h-3 w-3" /> ตอบกลับ
              </Button>
            )}
            {comment.is_mine ? (
              <>
                {!hidden && (
                  <Button
                    size="xs"
                    variant="ghost"
                    onClick={() => {
                      setEditBody(comment.body);
                      setMode("edit");
                    }}
                    className="gap-1 text-muted-foreground"
                  >
                    <Pencil className="h-3 w-3" /> แก้ไข
                  </Button>
                )}
                <Button
                  size="xs"
                  variant="ghost"
                  onClick={remove}
                  disabled={busy}
                  className="gap-1 text-muted-foreground hover:text-red-600"
                >
                  <Trash2 className="h-3 w-3" /> ลบ
                </Button>
              </>
            ) : (
              !hidden &&
              !reported && (
                <Button
                  size="xs"
                  variant="ghost"
                  onClick={() => setMode(mode === "report" ? "view" : "report")}
                  className="gap-1 text-muted-foreground"
                >
                  <Flag className="h-3 w-3" /> รายงาน
                </Button>
              )
            )}
          </div>
        )}

        {mode === "report" && (
          <div className="flex flex-wrap items-center gap-2 rounded-md bg-muted/50 p-2">
            <select
              value={reason}
              onChange={(e) => setReason(e.target.value as CommentReportReason)}
              className="h-7 rounded-md border bg-background px-2 text-xs"
              aria-label="เหตุผลที่รายงาน"
            >
              {COMMENT_REPORT_REASONS.map((r) => (
                <option key={r} value={r}>
                  {COMMENT_REPORT_REASON_LABELS[r]}
                </option>
              ))}
            </select>
            <Button size="xs" variant="destructive" onClick={report} disabled={busy}>
              ส่งรายงาน
            </Button>
            <Button size="xs" variant="ghost" onClick={() => setMode("view")} disabled={busy}>
              ยกเลิก
            </Button>
          </div>
        )}

        {message && <p className="text-xs text-muted-foreground">{message}</p>}

        {mode === "reply" && (
          <div className="pt-1">
            <Composer
              questionId={questionId}
              parentId={comment.id}
              placeholder={`ตอบกลับ ${comment.author.name}…`}
              autoFocus
              onCancel={() => setMode("view")}
              onPosted={async () => {
                setMode("view");
                await onChanged();
              }}
            />
          </div>
        )}
      </div>
    </div>
  );
}
