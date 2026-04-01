"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import ProtectedContent from "@/components/ProtectedContent";
import { createClient } from "@/lib/supabase/client";
import AIGradeButton from "@/components/AIGradeButton";
import {
  ChevronDown,
  ChevronUp,
  ArrowLeft,
  CheckCircle,
  Lightbulb,
  PenLine,
  Star,
  Trophy,
  RotateCcw,
} from "lucide-react";
import type { Exam, ExamPart, Profile } from "@/lib/types";
import { hasMeqAccess } from "@/lib/types";

const SCORE_LABELS = [
  { score: 0, label: "ไม่ได้ตอบ", color: "bg-gray-200 text-gray-600" },
  { score: 1, label: "1", color: "bg-red-100 text-red-700 hover:bg-red-200" },
  { score: 2, label: "2", color: "bg-red-100 text-red-700 hover:bg-red-200" },
  { score: 3, label: "3", color: "bg-orange-100 text-orange-700 hover:bg-orange-200" },
  { score: 4, label: "4", color: "bg-orange-100 text-orange-700 hover:bg-orange-200" },
  { score: 5, label: "5", color: "bg-yellow-100 text-yellow-700 hover:bg-yellow-200" },
  { score: 6, label: "6", color: "bg-yellow-100 text-yellow-700 hover:bg-yellow-200" },
  { score: 7, label: "7", color: "bg-lime-100 text-lime-700 hover:bg-lime-200" },
  { score: 8, label: "8", color: "bg-green-100 text-green-700 hover:bg-green-200" },
  { score: 9, label: "9", color: "bg-emerald-100 text-emerald-700 hover:bg-emerald-200" },
  { score: 10, label: "10", color: "bg-brand/10 text-brand hover:bg-brand/20" },
];

function getGrade(percent: number) {
  if (percent >= 80) return { label: "ดีเยี่ยม", emoji: "🏆", color: "text-brand" };
  if (percent >= 60) return { label: "ดี", emoji: "👍", color: "text-green-600" };
  if (percent >= 40) return { label: "พอใช้", emoji: "📝", color: "text-yellow-600" };
  return { label: "ต้องทบทวน", emoji: "📖", color: "text-red-600" };
}

export default function AnswerClient({
  exam,
  parts,
}: {
  exam: Exam;
  parts: ExamPart[];
}) {
  const [openParts, setOpenParts] = useState<Set<number>>(new Set());
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [studentNotes, setStudentNotes] = useState<Record<number, string>>({});
  const [scores, setScores] = useState<Record<number, number>>({});
  const [aiScores, setAiScores] = useState<Record<number, number>>({});

  useEffect(() => {
    try {
      const savedNotes = localStorage.getItem(`exam-notes-${exam.id}`);
      if (savedNotes) setStudentNotes(JSON.parse(savedNotes));
      const savedScores = localStorage.getItem(`exam-scores-${exam.id}`);
      if (savedScores) setScores(JSON.parse(savedScores));
      const savedAiScores = localStorage.getItem(`exam-ai-scores-${exam.id}`);
      if (savedAiScores) setAiScores(JSON.parse(savedAiScores));
    } catch {}
  }, [exam.id]);

  useEffect(() => {
    if (Object.keys(scores).length > 0) {
      localStorage.setItem(`exam-scores-${exam.id}`, JSON.stringify(scores));
    }
  }, [scores, exam.id]);

  useEffect(() => {
    if (Object.keys(aiScores).length > 0) {
      localStorage.setItem(`exam-ai-scores-${exam.id}`, JSON.stringify(aiScores));
    }
  }, [aiScores, exam.id]);

  useEffect(() => {
    async function loadProfile() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (user) {
        const { data } = await supabase
          .from("profiles")
          .select("*")
          .eq("id", user.id)
          .single();
        setProfile(data);
      }
      setLoading(false);
    }
    loadProfile();
  }, []);

  // Free users can view answer (short) but not Key Points
  // Paid MEQ members see everything
  const isPaidMember =
    !!profile && hasMeqAccess(profile.membership_type, profile.membership_expires_at);

  // hasAccess: can see the answer text (free users too, exam.is_free or always for basic answer)
  const hasAccess = true;

  // hasKeyPoints: only paid MEQ members see Key Points + AI grading
  const hasKeyPoints = exam.is_free || isPaidMember;

  const togglePart = (partNumber: number) => {
    setOpenParts((prev) => {
      const next = new Set(prev);
      if (next.has(partNumber)) next.delete(partNumber);
      else next.add(partNumber);
      return next;
    });
  };

  const toggleAll = () => {
    if (openParts.size === parts.length) {
      setOpenParts(new Set());
    } else {
      setOpenParts(new Set(parts.map((p) => p.part_number)));
    }
  };

  const setScore = (partNumber: number, score: number) => {
    setScores((prev) => ({ ...prev, [partNumber]: score }));
  };

  const scoredParts = Object.keys(scores).length;
  const totalScore = Object.values(scores).reduce((a, b) => a + b, 0);
  const maxScore = parts.length * 10;
  const percent = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 0;
  const allScored = scoredParts === parts.length;
  const grade = getGrade(percent);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-8">
        <Link
          href={`/exams/${exam.id}`}
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับไปหน้าโจทย์
        </Link>
        <h1 className="text-2xl sm:text-3xl font-bold">
          เฉลย: {exam.title}
        </h1>
        <div className="flex items-center gap-2 mt-3">
          <Badge variant="secondary">{exam.category}</Badge>
          {exam.is_free && (
            <Badge className="bg-brand/10 text-brand">ฟรี</Badge>
          )}
        </div>
      </div>

      {loading ? (
        <div className="text-center py-16 text-muted-foreground">
          กำลังโหลด...
        </div>
      ) : (
        <>
          {/* Score Summary Card */}
          {scoredParts > 0 && (
            <Card className="mb-6 border-brand/20 bg-gradient-to-r from-brand/5 to-brand-light/5">
              <CardContent className="py-6">
                <div className="flex flex-col sm:flex-row items-center justify-between gap-4">
                  <div className="flex items-center gap-4">
                    <div className="w-20 h-20 rounded-full bg-white border-4 border-brand/20 flex items-center justify-center">
                      <span className="text-2xl font-bold text-brand">{percent}%</span>
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <Trophy className="h-5 w-5 text-brand" />
                        <h3 className="font-bold text-lg">คะแนนประเมินตนเอง</h3>
                      </div>
                      <p className="text-sm text-muted-foreground mt-1">
                        {totalScore} / {maxScore} คะแนน ({scoredParts}/{parts.length} ตอน)
                      </p>
                      {allScored && (
                        <p className={`text-sm font-semibold mt-1 ${grade.color}`}>
                          {grade.emoji} ระดับ: {grade.label}
                        </p>
                      )}
                    </div>
                  </div>
                  <div className="w-full sm:w-48">
                    <div className="h-3 bg-muted rounded-full overflow-hidden">
                      <div
                        className="h-full bg-brand rounded-full transition-all duration-500"
                        style={{ width: `${percent}%` }}
                      />
                    </div>
                    {allScored && (
                      <Button
                        variant="ghost"
                        size="sm"
                        className="mt-2 text-xs text-muted-foreground gap-1"
                        onClick={() => setScores({})}
                      >
                        <RotateCcw className="h-3 w-3" /> ประเมินใหม่
                      </Button>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Toggle all button */}
          <div className="mb-4 flex justify-end">
            <Button variant="outline" size="sm" onClick={toggleAll}>
              {openParts.size === parts.length
                ? "ปิดเฉลยทั้งหมด"
                : "เปิดเฉลยทั้งหมด"}
            </Button>
          </div>

          {/* Answer parts */}
          <div className="space-y-4">
            {parts.map((part) => {
              const partScore = scores[part.part_number];
              const hasScore = partScore !== undefined;

              return (
                <Card key={part.id}>
                  <CardHeader
                    className="cursor-pointer pb-3"
                    onClick={() => togglePart(part.part_number)}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <h2 className="text-base font-bold">{part.title}</h2>
                        {hasScore && (
                          <Badge
                            className={`text-xs ${
                              partScore >= 8
                                ? "bg-green-100 text-green-700"
                                : partScore >= 5
                                ? "bg-yellow-100 text-yellow-700"
                                : "bg-red-100 text-red-700"
                            }`}
                          >
                            <Star className="h-3 w-3 mr-0.5" />
                            {partScore}/10
                          </Badge>
                        )}
                      </div>
                      {openParts.has(part.part_number) ? (
                        <ChevronUp className="h-5 w-5 text-muted-foreground" />
                      ) : (
                        <ChevronDown className="h-5 w-5 text-muted-foreground" />
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground mt-1">
                      {part.question}
                    </p>
                  </CardHeader>

                  {openParts.has(part.part_number) && (
                    <CardContent className="pt-0 space-y-4">
                        {/* Student's note */}
                        {studentNotes[part.part_number - 1]?.trim() && (
                          <div className="rounded-lg bg-blue-50 border border-blue-200 p-4">
                            <div className="flex items-center gap-2 mb-3">
                              <PenLine className="h-5 w-5 text-blue-600" />
                              <h3 className="font-semibold text-blue-800">
                                คำตอบของคุณ
                              </h3>
                            </div>
                            <div className="text-sm leading-relaxed whitespace-pre-line text-blue-900">
                              {studentNotes[part.part_number - 1]}
                            </div>
                          </div>
                        )}

                        {/* Answer — free users see short version */}
                        <div className="rounded-lg bg-green-50 border border-green-200 p-4">
                          <div className="flex items-center gap-2 mb-3">
                            <CheckCircle className="h-5 w-5 text-green-600" />
                            <h3 className="font-semibold text-green-800">เฉลย</h3>
                            {!isPaidMember && !exam.is_free && (
                              <span className="ml-auto text-xs text-muted-foreground">ฉบับย่อ</span>
                            )}
                          </div>
                          <div className="text-sm leading-relaxed whitespace-pre-line text-green-900">
                            {isPaidMember || exam.is_free
                              ? part.answer
                              : part.answer.split("\n").slice(0, 3).join("\n") + (part.answer.split("\n").length > 3 ? "\n..." : "")}
                          </div>
                        </div>

                        {/* Key Points — paid only */}
                        {part.key_points.length > 0 && (
                          <ProtectedContent hasAccess={hasKeyPoints}>
                            <div className="rounded-lg bg-amber-50 border border-amber-200 p-4">
                              <div className="flex items-center gap-2 mb-3">
                                <Lightbulb className="h-5 w-5 text-amber-600" />
                                <h3 className="font-semibold text-amber-800">Key Points</h3>
                              </div>
                              <ul className="space-y-2">
                                {part.key_points.map((point, i) => (
                                  <li key={i} className="flex items-start gap-2 text-sm text-amber-900">
                                    <span className="font-bold text-amber-600 mt-0.5">•</span>
                                    {point}
                                  </li>
                                ))}
                              </ul>
                            </div>
                          </ProtectedContent>
                        )}

                        {/* Self-assessment + AI — paid members only */}
                        <ProtectedContent hasAccess={hasKeyPoints}>
                          <div className="rounded-lg bg-purple-50 border border-purple-200 p-4">
                            <div className="flex items-center gap-2 mb-3">
                              <Star className="h-5 w-5 text-purple-600" />
                              <h3 className="font-semibold text-purple-800">ประเมินคะแนนตัวเอง</h3>
                            </div>
                            <p className="text-xs text-purple-600 mb-3">
                              เปรียบเทียบคำตอบของคุณกับเฉลย แล้วให้คะแนน 1-10
                            </p>
                            <div className="flex flex-wrap gap-2">
                              {SCORE_LABELS.filter((s) => s.score > 0).map((item) => (
                                <button
                                  key={item.score}
                                  onClick={() => setScore(part.part_number, item.score)}
                                  className={`w-10 h-10 rounded-lg text-sm font-bold transition-all ${
                                    partScore === item.score
                                      ? `${item.color} ring-2 ring-purple-400 scale-110`
                                      : `${item.color} opacity-60`
                                  }`}
                                >
                                  {item.label}
                                </button>
                              ))}
                            </div>
                            {hasScore && (
                              <p className="mt-3 text-sm font-medium text-purple-800">
                                คุณให้คะแนนตอนนี้:{" "}
                                <span className="text-lg font-bold">{partScore}/10</span>
                                {partScore >= 8 && " — ดีมาก! 🎉"}
                                {partScore >= 5 && partScore < 8 && " — พอใช้ได้ 👍"}
                                {partScore < 5 && " — ทบทวนเพิ่มเติม 📖"}
                              </p>
                            )}
                          </div>

                          {isPaidMember && studentNotes[part.part_number - 1]?.trim() && (
                            <AIGradeButton
                              studentAnswer={studentNotes[part.part_number - 1]}
                              correctAnswer={part.answer}
                              keyPoints={part.key_points}
                              question={part.question}
                              partNumber={part.part_number}
                              examId={exam.id}
                              onGraded={(result) => {
                                setAiScores((prev) => ({
                                  ...prev,
                                  [part.part_number]: result.score,
                                }));
                              }}
                            />
                          )}
                        </ProtectedContent>
                    </CardContent>
                  )}
                </Card>
              );
            })}
          </div>

          {/* Final summary after all scored */}
          {allScored && (
            <Card className="mt-8 border-brand bg-gradient-to-br from-brand/5 to-brand-light/10">
              <CardContent className="py-8 text-center space-y-4">
                <div className="text-5xl">{grade.emoji}</div>
                <h2 className="text-2xl font-bold">
                  คะแนนรวม: {totalScore}/{maxScore} ({percent}%)
                </h2>
                <p className={`text-lg font-semibold ${grade.color}`}>
                  ระดับ: {grade.label}
                </p>
                <div className="flex flex-wrap justify-center gap-2 mt-4">
                  {parts.map((part) => {
                    const s = scores[part.part_number] || 0;
                    return (
                      <div
                        key={part.id}
                        className="flex flex-col items-center gap-1"
                      >
                        <div
                          className={`w-12 h-12 rounded-lg flex items-center justify-center text-sm font-bold ${
                            s >= 8
                              ? "bg-green-100 text-green-700"
                              : s >= 5
                              ? "bg-yellow-100 text-yellow-700"
                              : "bg-red-100 text-red-700"
                          }`}
                        >
                          {s}
                        </div>
                        <span className="text-xs text-muted-foreground">
                          ตอน {part.part_number}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="pt-4 flex flex-col sm:flex-row items-center justify-center gap-3">
                  <Link href="/exams">
                    <Button variant="outline">ทำข้อสอบข้ออื่น</Button>
                  </Link>
                  <Link href={`/exams/${exam.id}`}>
                    <Button className="bg-brand hover:bg-brand-light text-white">
                      ทำข้อสอบนี้อีกครั้ง
                    </Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          )}
        </>
      )}
    </div>
  );
}
