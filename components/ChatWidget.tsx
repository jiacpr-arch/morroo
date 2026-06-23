"use client";

import { useEffect, useRef, useState } from "react";
import { MessageCircle, X, Send, Stethoscope } from "lucide-react";
import { cn } from "@/lib/utils";
import { useAiHealth } from "@/components/ai/AiHealthProvider";

type Msg = { role: "user" | "assistant"; content: string; streaming?: boolean };

const STORAGE_KEY = "morroo-chat";
const SESSION_KEY = "morroo-chat-session";
const GREETING: Msg = {
  role: "assistant",
  content:
    "สวัสดีครับ! ผมพี่หมอรู้ 🩺 ผู้ช่วย AI ของ MorRoo ✨\nสงสัยอะไรเรื่องข้อสอบ MEQ, MCQ, Long Case หรือเตรียมสอบใบประกอบฯ ถามได้เลยครับ",
};

const QUICK_REPLIES = [
  "มีข้อสอบฟรีไหม?",
  "ราคาเท่าไหร่?",
  "AI ตรวจคำตอบทำงานยังไง?",
  "Long Case คืออะไร?",
];

function getOrCreateSessionId(): string {
  if (typeof window === "undefined") return "";
  let id = localStorage.getItem(SESSION_KEY);
  if (!id) {
    id = crypto.randomUUID();
    localStorage.setItem(SESSION_KEY, id);
  }
  return id;
}

function loadHistory(): Msg[] {
  if (typeof window === "undefined") return [GREETING];
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [GREETING];
    // Strip streaming flag from persisted messages
    const parsed = (JSON.parse(raw) as Msg[]).map(({ streaming: _s, ...m }) => m);
    return Array.isArray(parsed) && parsed.length > 0 ? parsed : [GREETING];
  } catch {
    return [GREETING];
  }
}

/** Render text with auto-linked URLs. */
function renderContent(text: string, streaming?: boolean) {
  const urlRegex = /(https?:\/\/[^\s]+)/g;
  const parts = text.split(urlRegex);
  return (
    <>
      {parts.map((part, i) => {
        if (urlRegex.test(part)) {
          return (
            <a
              key={i}
              href={part}
              target="_blank"
              rel="noopener noreferrer"
              className="underline underline-offset-2 hover:opacity-80"
            >
              {part}
            </a>
          );
        }
        return <span key={i}>{part}</span>;
      })}
      {streaming && (
        <span className="ml-0.5 inline-block h-4 w-0.5 animate-pulse bg-current align-middle opacity-80" />
      )}
    </>
  );
}

export default function ChatWidget() {
  const { reportAiFailure } = useAiHealth();
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState<Msg[]>([GREETING]);
  const [input, setInput] = useState("");
  const [sending, setSending] = useState(false);
  const [unread, setUnread] = useState(false);
  const scrollRef = useRef<HTMLDivElement | null>(null);
  const inputRef = useRef<HTMLTextAreaElement | null>(null);
  const sessionIdRef = useRef<string>("");

  useEffect(() => {
    sessionIdRef.current = getOrCreateSessionId();
    setMessages(loadHistory());
  }, []);

  // Persist history and auto-scroll (skip streaming messages to avoid thrash)
  useEffect(() => {
    const hasStreaming = messages.some((m) => m.streaming);
    if (!hasStreaming && typeof window !== "undefined") {
      localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify(messages.map(({ streaming: _s, ...m }) => m))
      );
    }
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  useEffect(() => {
    if (open) {
      setUnread(false);
      setTimeout(() => inputRef.current?.focus(), 200);
    }
  }, [open]);

  async function send(textOverride?: string) {
    const text = (textOverride ?? input).trim();
    if (!text || sending) return;

    setMessages((m) => [...m, { role: "user", content: text }]);
    setInput("");
    setSending(true);

    // Add an empty streaming placeholder for the assistant reply
    setMessages((m) => [...m, { role: "assistant", content: "", streaming: true }]);

    try {
      const res = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: text, sessionId: sessionIdRef.current }),
      });

      if (!res.ok || !res.body) {
        const data = await res.json().catch(() => ({})) as { error?: string };
        const errMsg =
          data.error ?? "ขอโทษครับ ขณะนี้ระบบมีปัญหาชั่วคราว ลองใหม่อีกครั้งนะครับ";
        reportAiFailure();
        setMessages((m) => {
          const updated = [...m];
          updated[updated.length - 1] = { role: "assistant", content: errMsg };
          return updated;
        });
        if (!open) setUnread(true);
        return;
      }

      // Stream tokens into the last message
      const reader = res.body.getReader();
      const decoder = new TextDecoder();

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        const chunk = decoder.decode(value, { stream: true });
        setMessages((m) => {
          const updated = [...m];
          const last = updated[updated.length - 1];
          updated[updated.length - 1] = {
            ...last,
            content: last.content + chunk,
            streaming: true,
          };
          return updated;
        });
      }

      // Mark streaming complete
      setMessages((m) => {
        const updated = [...m];
        updated[updated.length - 1] = {
          ...updated[updated.length - 1],
          streaming: false,
        };
        return updated;
      });

      if (!open) setUnread(true);
    } catch {
      setMessages((m) => {
        const updated = [...m];
        updated[updated.length - 1] = {
          role: "assistant",
          content: "เชื่อมต่อไม่ได้ครับ เช็กอินเทอร์เน็ตแล้วลองใหม่นะ",
        };
        return updated;
      });
    } finally {
      setSending(false);
    }
  }

  function handleKey(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      send();
    }
  }

  const isStreaming = messages.some((m) => m.streaming);

  return (
    <>
      {/* Launcher bubble */}
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        aria-label={open ? "ปิดแชท" : "เปิดแชทกับพี่หมอรู้"}
        className={cn(
          "fixed bottom-5 right-5 z-50 flex h-14 w-14 items-center justify-center rounded-full text-white shadow-lg transition-all",
          "bg-gradient-to-br from-primary to-primary/70 hover:scale-105 active:scale-95",
          "focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-primary/30"
        )}
      >
        {open ? (
          <X className="h-6 w-6" />
        ) : (
          <>
            <MessageCircle className="h-6 w-6" />
            {unread && (
              <span className="absolute -top-0.5 -right-0.5 flex h-3.5 w-3.5">
                <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-rose-400 opacity-75" />
                <span className="relative inline-flex h-3.5 w-3.5 rounded-full bg-rose-500" />
              </span>
            )}
          </>
        )}
      </button>

      {/* Chat panel */}
      <div
        className={cn(
          "fixed bottom-24 right-5 z-50 flex w-[calc(100vw-2.5rem)] max-w-sm flex-col overflow-hidden rounded-2xl border border-border bg-background shadow-2xl transition-all duration-200 sm:max-w-md",
          open
            ? "pointer-events-auto translate-y-0 opacity-100"
            : "pointer-events-none translate-y-2 opacity-0"
        )}
        style={{ height: "min(560px, calc(100vh - 8rem))" }}
        role="dialog"
        aria-label="แชทกับพี่หมอรู้"
        aria-hidden={!open}
      >
        {/* Header */}
        <div className="flex items-center gap-3 bg-gradient-to-r from-primary to-primary/80 px-4 py-3 text-primary-foreground">
          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-white/20 ring-2 ring-white/30">
            <Stethoscope className="h-5 w-5" />
          </div>
          <div className="flex-1 leading-tight">
            <div className="text-sm font-semibold">พี่หมอรู้</div>
            <div className="flex items-center gap-1.5 text-xs opacity-90">
              <span className="relative flex h-2 w-2">
                <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-300 opacity-75" />
                <span className="relative inline-flex h-2 w-2 rounded-full bg-emerald-400" />
              </span>
              {isStreaming ? "กำลังตอบ…" : "ออนไลน์ • ตอบทันที"}
            </div>
          </div>
          <button
            type="button"
            onClick={() => setOpen(false)}
            aria-label="ปิดแชท"
            className="rounded-md p-1.5 hover:bg-white/15"
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        {/* Messages */}
        <div
          ref={scrollRef}
          className="flex-1 space-y-3 overflow-y-auto bg-muted/30 px-3 py-4"
        >
          {messages.map((m, i) => (
            <div
              key={i}
              className={cn(
                "flex",
                m.role === "user" ? "justify-end" : "justify-start"
              )}
            >
              <div
                className={cn(
                  "max-w-[82%] whitespace-pre-wrap break-words rounded-2xl px-3.5 py-2 text-sm leading-relaxed shadow-sm",
                  m.role === "user"
                    ? "rounded-br-md bg-primary text-primary-foreground"
                    : "rounded-bl-md bg-background text-foreground"
                )}
              >
                {/* Show typing dots only while waiting for first token */}
                {m.streaming && m.content === "" ? (
                  <span className="flex items-center gap-1 py-0.5">
                    <span className="h-2 w-2 animate-bounce rounded-full bg-muted-foreground/60 [animation-delay:-0.3s]" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-muted-foreground/60 [animation-delay:-0.15s]" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-muted-foreground/60" />
                  </span>
                ) : (
                  renderContent(m.content, m.streaming)
                )}
              </div>
            </div>
          ))}

          {/* Quick replies — only show on the very first turn */}
          {messages.length === 1 && !sending && (
            <div className="flex flex-wrap gap-2 pt-1">
              {QUICK_REPLIES.map((q) => (
                <button
                  key={q}
                  type="button"
                  onClick={() => send(q)}
                  className="rounded-full border border-border bg-background px-3 py-1.5 text-xs text-foreground transition-colors hover:bg-muted"
                >
                  {q}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Input */}
        <div className="border-t border-border bg-background p-2">
          <div className="flex items-end gap-2">
            <textarea
              ref={inputRef}
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKey}
              placeholder="พิมพ์ข้อความ…"
              rows={1}
              maxLength={2000}
              className="max-h-32 flex-1 resize-none rounded-xl border border-border bg-background px-3 py-2 text-sm outline-none transition-colors focus:border-primary"
            />
            <button
              type="button"
              onClick={() => send()}
              disabled={!input.trim() || sending || isStreaming}
              aria-label="ส่ง"
              className={cn(
                "flex h-10 w-10 items-center justify-center rounded-xl text-white transition-all",
                "bg-gradient-to-br from-primary to-primary/70",
                "disabled:cursor-not-allowed disabled:opacity-40",
                "hover:scale-105 active:scale-95"
              )}
            >
              <Send className="h-4 w-4" />
            </button>
          </div>
          <div className="mt-1.5 px-1 text-[10px] text-muted-foreground">
            ขับเคลื่อนโดย AI • อาจตอบผิดบ้าง — เช็กกับอาจารย์อีกที
          </div>
        </div>
      </div>
    </>
  );
}
