"use client";

import { useState } from "react";
import { Bot, CheckCircle2, Loader2, Sparkles, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

interface AIGradeResult {
  score: number;
  feedback: string;
  matched_points: number[];
}

interface AIGradeButtonProps {
  studentAnswer: string;
  correctAnswer: string;
  keyPoints: string[];
  question: string;
  partNumber: number;
  examId: string;
  onGraded?: (result: AIGradeResult) => void;
}

export default function AIGradeButton({
  studentAnswer,
  correctAnswer,
  keyPoints,
  question,
  partNumber,
  examId,
  onGraded,
}: AIGradeButtonProps) {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<AIGradeResult | null>(() => {
    // Load cached result from localStorage
    try {
      const cached = localStorage.getItem(
        `ai-grade-${examId}-${partNumber}`
      );
      if (cached) return JSON.parse(cached);
    } catch {}
    return null;
  });
  const [error, setError] = useState<string | null>(null);

  const handleGrade = async () => {
    if (!studentAnswer.trim()) {
      setError("ไม่มีคำตอบที่จะตรวจ กรุณาเขียนคำตอบก่อน");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const response = await fetch("/api/grade", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          studentAnswer,
          correctAnswer,
          keyPoints,
          question,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        setError(data.error || "เกิดข้อผิดพลาด กรุณาลองใหม่");
        return;
      }

      const gradeResult: AIGradeResult = {
        score: data.score,
        feedback: data.feedback,
        matched_points: data.matched_points,
      };

      setResult(gradeResult);

      // Save to localStorage
      try {
        localStorage.setItem(
          `ai-grade-${examId}-${partNumber}`,
          JSON.stringify(gradeResult)
        );
      } catch {}

      onGraded?.(gradeResult);
    } catch {
      setError("ไม่สามารถเชื่อมต่อกับ AI ได้ กรุณาลองใหม่");
    } finally {
      setLoading(false);
    }
  };

  const getScoreColor = (score: number) => {
    if (score >= 8) return "text-green-700";
    if (score >= 5) return "text-yellow-700";
    return "text-red-700";
  };

  const getScoreBg = (score: number) => {
    if (score >= 8) return "bg-green-100 border-green-200";
    if (score >= 5) return "bg-yellow-100 border-yellow-200";
    return "bg-red-100 border-red-200";
  };

  // Not yet graded — show button
  if (!result) {
    return (
      <div className="space-y-2">
        <Button
          onClick={handleGrade}
          disabled={loading || !studentAnswer.trim()}
          className="bg-[#16A085] hover:bg-[#138D75] text-white gap-2 w-full sm:w-auto"
        >
          {loading ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" />
              AI กำลังตรวจ...
            </>
          ) : (
            <>
              <Sparkles className="h-4 w-4" />
              AI ตรวจคำตอบ
            </>
          )}
        </Button>
        {error && (
          <div className="flex items-start gap-2 text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg p-3">
            <XCircle className="h-4 w-4 mt-0.5 shrink-0" />
            {error}
          </div>
        )}
      </div>
    );
  }

  // Show result
  return (
    <div
      className={`rounded-lg border p-4 space-y-3 ${getScoreBg(result.score)}`}
    >
      {/* Header with AI badge */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Bot className="h-5 w-5 text-[#16A085]" />
          <h3 className="font-semibold text-[#16A085]">AI ตรวจคำตอบ</h3>
        </div>
        <div
          className={`text-2xl font-bold ${getScoreColor(result.score)}`}
        >
          {result.score}/10
        </div>
      </div>

      {/* Feedback */}
      <p className="text-sm leading-relaxed">{result.feedback}</p>

      {/* Matched key points */}
      {keyPoints.length > 0 && (
        <div className="space-y-1.5">
          <p className="text-xs font-semibold text-gray-600">
            Key Points ที่ตอบได้:
          </p>
          <ul className="space-y-1">
            {keyPoints.map((point, i) => {
              const isMatched = result.matched_points.includes(i + 1);
              return (
                <li
                  key={i}
                  className={`flex items-start gap-2 text-sm ${
                    isMatched ? "text-green-700" : "text-gray-400"
                  }`}
                >
                  {isMatched ? (
                    <CheckCircle2 className="h-4 w-4 mt-0.5 shrink-0 text-green-600" />
                  ) : (
                    <XCircle className="h-4 w-4 mt-0.5 shrink-0 text-gray-300" />
                  )}
                  <span className={isMatched ? "" : "line-through"}>
                    {point}
                  </span>
                </li>
              );
            })}
          </ul>
        </div>
      )}

      {/* Re-grade button */}
      <Button
        variant="ghost"
        size="sm"
        onClick={() => {
          setResult(null);
          try {
            localStorage.removeItem(`ai-grade-${examId}-${partNumber}`);
          } catch {}
        }}
        className="text-xs text-gray-500 gap-1"
      >
        <Sparkles className="h-3 w-3" />
        ตรวจใหม่อีกครั้ง
      </Button>
    </div>
  );
}
