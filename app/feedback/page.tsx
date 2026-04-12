"use client";

import { useState } from "react";
import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { MessageSquare, CheckCircle, ArrowLeft } from "lucide-react";

const CATEGORIES = [
  { value: "bug", label: "แจ้งปัญหา / Bug" },
  { value: "feature", label: "แนะนำฟีเจอร์ใหม่" },
  { value: "content", label: "เนื้อหา / ข้อสอบ" },
  { value: "payment", label: "การชำระเงิน" },
  { value: "other", label: "อื่นๆ" },
];

const RATINGS = [
  { value: 5, emoji: "😍", label: "ดีมาก" },
  { value: 4, emoji: "😊", label: "ดี" },
  { value: 3, emoji: "😐", label: "ปานกลาง" },
  { value: 2, emoji: "😕", label: "ต้องปรับปรุง" },
  { value: 1, emoji: "😞", label: "ไม่พอใจ" },
];

export default function FeedbackPage() {
  const [category, setCategory] = useState("");
  const [rating, setRating] = useState<number | null>(null);
  const [message, setMessage] = useState("");
  const [email, setEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!message.trim()) {
      setError("กรุณากรอกข้อความ");
      return;
    }
    setError("");
    setSubmitting(true);

    try {
      const res = await fetch("/api/feedback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          category: category || "other",
          rating,
          message: message.trim(),
          email: email.trim() || null,
        }),
      });

      if (!res.ok) throw new Error("Failed to submit");
      setSubmitted(true);
    } catch {
      setError("เกิดข้อผิดพลาด กรุณาลองอีกครั้ง");
    } finally {
      setSubmitting(false);
    }
  };

  if (submitted) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <CheckCircle className="h-16 w-16 text-green-500 mx-auto mb-4" />
        <h1 className="text-2xl font-bold mb-2">ขอบคุณสำหรับ Feedback!</h1>
        <p className="text-muted-foreground mb-6">
          เราจะนำความคิดเห็นของคุณไปปรับปรุงให้ดียิ่งขึ้น
        </p>
        <div className="flex justify-center gap-3">
          <Link
            href="/"
            className="rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90 transition-colors"
          >
            กลับหน้าแรก
          </Link>
          <button
            onClick={() => {
              setSubmitted(false);
              setCategory("");
              setRating(null);
              setMessage("");
              setEmail("");
            }}
            className="rounded-lg border px-5 py-2 text-sm font-medium hover:bg-muted transition-colors"
          >
            ส่งอีกครั้ง
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-lg px-4 py-12 sm:px-6">
      <Link
        href="/"
        className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-6"
      >
        <ArrowLeft className="h-4 w-4" /> กลับหน้าแรก
      </Link>

      <div className="flex items-center gap-3 mb-6">
        <div className="w-10 h-10 rounded-lg bg-brand/10 flex items-center justify-center">
          <MessageSquare className="h-5 w-5 text-brand" />
        </div>
        <div>
          <h1 className="text-2xl font-bold">ส่ง Feedback</h1>
          <p className="text-sm text-muted-foreground">ช่วยเราปรับปรุงหมอรู้ให้ดียิ่งขึ้น</p>
        </div>
      </div>

      <form onSubmit={handleSubmit}>
        <Card>
          <CardContent className="pt-6 space-y-6">
            {/* Rating */}
            <div>
              <label className="text-sm font-medium mb-2 block">ให้คะแนนประสบการณ์ใช้งาน</label>
              <div className="flex gap-2">
                {RATINGS.map((r) => (
                  <button
                    key={r.value}
                    type="button"
                    onClick={() => setRating(r.value)}
                    className={`flex-1 flex flex-col items-center gap-1 rounded-lg border p-3 transition-colors ${
                      rating === r.value
                        ? "border-brand bg-brand/10"
                        : "hover:bg-muted"
                    }`}
                  >
                    <span className="text-2xl">{r.emoji}</span>
                    <span className="text-xs text-muted-foreground">{r.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Category */}
            <div>
              <label className="text-sm font-medium mb-2 block">หมวดหมู่</label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="w-full rounded-lg border px-3 py-2 text-sm bg-white"
              >
                <option value="">เลือกหมวดหมู่</option>
                {CATEGORIES.map((c) => (
                  <option key={c.value} value={c.value}>
                    {c.label}
                  </option>
                ))}
              </select>
            </div>

            {/* Message */}
            <div>
              <label className="text-sm font-medium mb-2 block">
                ข้อความ <span className="text-red-500">*</span>
              </label>
              <textarea
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="บอกเราว่าคุณคิดอย่างไร หรือมีปัญหาอะไร..."
                rows={5}
                className="w-full rounded-lg border px-3 py-2 text-sm resize-none"
                required
              />
            </div>

            {/* Email */}
            <div>
              <label className="text-sm font-medium mb-2 block">
                Email (ไม่บังคับ — ถ้าต้องการให้ตอบกลับ)
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@email.com"
                className="w-full rounded-lg border px-3 py-2 text-sm"
              />
            </div>

            {error && <p className="text-sm text-red-500">{error}</p>}

            <Button type="submit" disabled={submitting} className="w-full">
              {submitting ? "กำลังส่ง..." : "ส่ง Feedback"}
            </Button>
          </CardContent>
        </Card>
      </form>
    </div>
  );
}
