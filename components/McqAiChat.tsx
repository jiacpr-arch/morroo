"use client";

import { useState, useRef, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  MessageCircleQuestion,
  Send,
  Loader2,
  ChevronDown,
  ChevronUp,
  Bot,
  User,
  Sparkles,
  Lock,
} from "lucide-react";
import Link from "next/link";
import type { McqQuestion } from "@/lib/types-mcq";

interface McqAiChatProps {
  question: McqQuestion;
  selectedAnswer: string | null;
  isPremium?: boolean;
}

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}

const SUGGESTED_QUESTIONS = [
  "ทำไมตัวเลือกอื่นถึงไม่ถูก?",
  "ช่วยอธิบายเพิ่มเติมได้ไหม?",
  "มีหลักการจำง่ายๆ ไหม?",
];

export default function McqAiChat({
  question,
  selectedAnswer,
  isPremium = false,
}: McqAiChatProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Reset chat when question changes
  useEffect(() => {
    setMessages([]);
    setInput("");
    setIsOpen(false);
    setIsLoading(false);
  }, [question.id]);

  // Scroll to bottom on new messages
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const sendMessage = async (text: string) => {
    if (!text.trim() || isLoading) return;

    const userMsg: ChatMessage = { role: "user", content: text.trim() };
    setMessages((prev) => [...prev, userMsg]);
    setInput("");
    setIsLoading(true);

    try {
      const res = await fetch("/api/ai/mcq-chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          question: {
            scenario: question.scenario,
            choices: question.choices,
            correct_answer: question.correct_answer,
            explanation: question.explanation,
            detailed_explanation: question.detailed_explanation,
          },
          userMessage: text.trim(),
        }),
      });

      if (!res.ok) {
        throw new Error("Failed to get response");
      }

      const data = await res.json();
      setMessages((prev) => [
        ...prev,
        { role: "assistant", content: data.reply },
      ]);
    } catch {
      setMessages((prev) => [
        ...prev,
        {
          role: "assistant",
          content: "ขออภัย ไม่สามารถตอบได้ในขณะนี้ กรุณาลองใหม่อีกครั้ง",
        },
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    sendMessage(input);
  };

  const handleSuggestedQuestion = (q: string) => {
    // If the student selected a wrong answer, customize the question
    if (
      q === "ทำไมตัวเลือกอื่นถึงไม่ถูก?" &&
      selectedAnswer &&
      selectedAnswer !== question.correct_answer
    ) {
      sendMessage(
        `ทำไมข้อ ${selectedAnswer} ถึงไม่ถูก? แล้วข้อ ${question.correct_answer} ถูกเพราะอะไร?`
      );
    } else {
      sendMessage(q);
    }
  };

  // Non-premium CTA
  if (!isPremium) {
    return (
      <Card className="mt-4 border-purple-200 bg-gradient-to-r from-purple-50 to-indigo-50">
        <CardContent className="p-4 flex items-center gap-4">
          <div className="flex-shrink-0 w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center">
            <Bot className="h-5 w-5 text-purple-600" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-semibold text-purple-900">ถาม AI อาจารย์ได้ทุกข้อ</p>
            <p className="text-xs text-purple-600 mt-0.5">สงสัยทำไมถึงผิด? ให้ AI อธิบายเหตุผลทางการแพทย์</p>
          </div>
          <Link href="/pricing" className="flex-shrink-0">
            <Button size="sm" className="bg-purple-600 hover:bg-purple-700 text-white gap-1.5 text-xs">
              <Sparkles className="h-3.5 w-3.5" />
              ฿199/เดือน
            </Button>
          </Link>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="mt-4">
      <button
        onClick={() => {
          setIsOpen(!isOpen);
          if (!isOpen) {
            setTimeout(() => inputRef.current?.focus(), 100);
          }
        }}
        className="flex items-center gap-2 text-sm font-medium text-purple-600 hover:text-purple-700 hover:underline"
      >
        <MessageCircleQuestion className="h-4 w-4" />
        {isOpen ? (
          <ChevronUp className="h-4 w-4" />
        ) : (
          <ChevronDown className="h-4 w-4" />
        )}
        {isOpen ? "ซ่อนช่องถาม AI" : "สงสัยอะไร? ถาม AI ได้เลย"}
      </button>

      {isOpen && (
        <Card className="mt-3 border-purple-200 bg-purple-50/30">
          <CardContent className="p-4 space-y-3">
            {/* Suggested quick questions */}
            {messages.length === 0 && (
              <div className="space-y-2">
                <p className="text-xs text-muted-foreground">
                  ลองถามคำถามเหล่านี้:
                </p>
                <div className="flex flex-wrap gap-2">
                  {SUGGESTED_QUESTIONS.map((q) => (
                    <button
                      key={q}
                      onClick={() => handleSuggestedQuestion(q)}
                      className="text-xs px-3 py-1.5 rounded-full border border-purple-200 bg-white text-purple-700 hover:bg-purple-50 transition-colors"
                    >
                      {q}
                    </button>
                  ))}
                  {selectedAnswer &&
                    selectedAnswer !== question.correct_answer && (
                      <button
                        onClick={() =>
                          sendMessage(
                            `ทำไมข้อ ${selectedAnswer} ถึงผิด?`
                          )
                        }
                        className="text-xs px-3 py-1.5 rounded-full border border-red-200 bg-white text-red-600 hover:bg-red-50 transition-colors"
                      >
                        ทำไมข้อ {selectedAnswer} ถึงผิด?
                      </button>
                    )}
                </div>
              </div>
            )}

            {/* Chat messages */}
            {messages.length > 0 && (
              <div className="max-h-64 overflow-y-auto space-y-3 pr-1">
                {messages.map((msg, i) => (
                  <div
                    key={i}
                    className={`flex gap-2 ${msg.role === "user" ? "justify-end" : "justify-start"}`}
                  >
                    {msg.role === "assistant" && (
                      <div className="flex-shrink-0 w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center mt-1">
                        <Bot className="h-3.5 w-3.5 text-purple-600" />
                      </div>
                    )}
                    <div
                      className={`max-w-[85%] rounded-lg px-3 py-2 text-sm leading-relaxed ${
                        msg.role === "user"
                          ? "bg-brand text-white"
                          : "bg-white border border-purple-100"
                      }`}
                    >
                      <p className="whitespace-pre-line">{msg.content}</p>
                    </div>
                    {msg.role === "user" && (
                      <div className="flex-shrink-0 w-6 h-6 rounded-full bg-brand/10 flex items-center justify-center mt-1">
                        <User className="h-3.5 w-3.5 text-brand" />
                      </div>
                    )}
                  </div>
                ))}
                {isLoading && (
                  <div className="flex gap-2">
                    <div className="flex-shrink-0 w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center mt-1">
                      <Bot className="h-3.5 w-3.5 text-purple-600" />
                    </div>
                    <div className="bg-white border border-purple-100 rounded-lg px-3 py-2">
                      <Loader2 className="h-4 w-4 animate-spin text-purple-400" />
                    </div>
                  </div>
                )}
                <div ref={messagesEndRef} />
              </div>
            )}

            {/* Input */}
            <form onSubmit={handleSubmit} className="flex gap-2">
              <input
                ref={inputRef}
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="พิมพ์คำถามที่สงสัย..."
                disabled={isLoading}
                className="flex-1 text-sm px-3 py-2 rounded-lg border border-purple-200 bg-white focus:outline-none focus:ring-2 focus:ring-purple-300 disabled:opacity-50"
              />
              <Button
                type="submit"
                size="sm"
                disabled={!input.trim() || isLoading}
                className="bg-purple-600 hover:bg-purple-700 text-white px-3"
              >
                <Send className="h-4 w-4" />
              </Button>
            </form>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
