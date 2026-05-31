"use client";

import { useState, useRef, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Bot, Loader2, Send, User as UserIcon, BookOpen, Link as LinkIcon, Sparkles } from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";

interface Citation {
  type: "lesson" | "flashcard" | "quiz" | "concept";
  id: string;
  title: string;
  href: string;
}

interface Message {
  role: "user" | "assistant";
  content: string;
  citations?: Citation[];
}

const SUGGESTIONS = [
  "อธิบาย RAAS ทำงานยังไง",
  "ทำไม MI ถึง elevate ST segment?",
  "ความต่างของ Type 1 vs Type 2 DM",
  "Mechanism ของ ACE inhibitor",
];

export default function TutorChat() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const endRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  async function ask(question: string) {
    if (!question.trim() || loading) return;
    const newMessages: Message[] = [
      ...messages,
      { role: "user", content: question },
    ];
    setMessages(newMessages);
    setInput("");
    setLoading(true);
    try {
      const res = await fetch("/api/school/tutor", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          question,
          history: messages,
        }),
      });
      if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.error ?? "Failed");
      }
      const data = (await res.json()) as { answer: string; citations: Citation[] };
      setMessages([
        ...newMessages,
        { role: "assistant", content: data.answer, citations: data.citations },
      ]);
    } catch (e) {
      setMessages([
        ...newMessages,
        {
          role: "assistant",
          content: `ขออภัย — ${e instanceof Error ? e.message : "เกิดข้อผิดพลาด"}`,
        },
      ]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      {messages.length === 0 && (
        <Card className="border-indigo-200 bg-indigo-50/40">
          <CardContent className="p-4">
            <p className="text-sm font-semibold mb-2 flex items-center gap-1">
              <Sparkles className="h-4 w-4 text-indigo-600" /> ลองถาม
            </p>
            <div className="flex flex-wrap gap-2">
              {SUGGESTIONS.map((s) => (
                <button
                  key={s}
                  onClick={() => ask(s)}
                  className="text-xs px-3 py-1.5 rounded-full border bg-background hover:bg-muted/50"
                >
                  {s}
                </button>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      <div className="space-y-3 max-h-[55vh] overflow-y-auto pr-1">
        {messages.map((m, i) => (
          <div
            key={i}
            className={`flex gap-3 ${
              m.role === "user" ? "flex-row-reverse" : ""
            }`}
          >
            <div
              className={`shrink-0 w-8 h-8 rounded-full flex items-center justify-center ${
                m.role === "user"
                  ? "bg-brand text-white"
                  : "bg-indigo-100 text-indigo-700"
              }`}
            >
              {m.role === "user" ? (
                <UserIcon className="h-4 w-4" />
              ) : (
                <Bot className="h-4 w-4" />
              )}
            </div>
            <div className="flex-1 min-w-0">
              <Card>
                <CardContent className="p-3">
                  <div className="prose prose-slate dark:prose-invert prose-sm max-w-none">
                    <ReactMarkdown remarkPlugins={[remarkGfm]}>
                      {m.content}
                    </ReactMarkdown>
                  </div>
                  {m.citations && m.citations.length > 0 && (
                    <div className="mt-3 pt-3 border-t">
                      <p className="text-xs font-semibold mb-2 flex items-center gap-1">
                        <LinkIcon className="h-3 w-3" /> เนื้อหาที่เกี่ยวข้อง
                      </p>
                      <div className="flex flex-wrap gap-1">
                        {m.citations.map((c) => (
                          <a
                            key={`${c.type}-${c.id}`}
                            href={c.href}
                            className="text-xs px-2 py-1 rounded-full border bg-muted/50 hover:bg-muted flex items-center gap-1"
                          >
                            {c.type === "concept" ? "🔗" : <BookOpen className="h-3 w-3" />}
                            {c.title}
                          </a>
                        ))}
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            </div>
          </div>
        ))}
        {loading && (
          <div className="flex gap-3">
            <div className="shrink-0 w-8 h-8 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center">
              <Bot className="h-4 w-4" />
            </div>
            <Card className="flex-1">
              <CardContent className="p-3 flex items-center gap-2 text-sm text-muted-foreground">
                <Loader2 className="h-4 w-4 animate-spin" /> AI กำลังคิด…
              </CardContent>
            </Card>
          </div>
        )}
        <div ref={endRef} />
      </div>

      <div className="border-t pt-3 sticky bottom-0 bg-background">
        <form
          className="flex gap-2"
          onSubmit={(e) => {
            e.preventDefault();
            ask(input);
          }}
        >
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="ถาม AI..."
            className="flex-1 border rounded-md px-3 py-2 text-sm"
            disabled={loading}
          />
          <Button type="submit" disabled={loading || !input.trim()} className="gap-1">
            <Send className="h-4 w-4" />
          </Button>
        </form>
        <p className="text-xs text-muted-foreground mt-1 italic">
          AI ใช้ Claude Sonnet 4.6 — ข้อมูลควรเช็คกับอาจารย์/ตำราจริงอีกที
        </p>
      </div>
    </div>
  );
}
