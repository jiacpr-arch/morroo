"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, CheckCircle2, Trophy } from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import Link from "next/link";
import type { SchoolCaseStage } from "@/lib/types-school";
import { XP, awardXp } from "@/lib/school/xp";
import ShareResult from "./ShareResult";
import RewardBadge from "./RewardBadge";

const LAYER_BADGE: Record<string, string> = {
  anatomy: "bg-rose-100 text-rose-700",
  physio: "bg-sky-100 text-sky-700",
  biochem: "bg-amber-100 text-amber-700",
  path: "bg-purple-100 text-purple-700",
  pharm: "bg-emerald-100 text-emerald-700",
  clinical: "bg-orange-100 text-orange-700",
  foundation: "bg-slate-100 text-slate-700",
};

interface Props {
  caseId: string;
  caseTitle: string;
  stages: SchoolCaseStage[];
}

export default function CaseWalker({ caseId, caseTitle, stages }: Props) {
  const [idx, setIdx] = useState(0);
  const [picked, setPicked] = useState<string | null>(null);
  const [correct, setCorrect] = useState(0);
  const [xpEarned, setXpEarned] = useState(0);

  const stage = stages[idx];
  const done = !stage;

  async function pickMini(label: string) {
    if (picked || !stage?.mini_quiz_answer) return;
    setPicked(label);
    const isRight = label === stage.mini_quiz_answer;
    if (isRight) {
      setCorrect((c) => c + 1);
      setXpEarned((x) => x + XP.quizMedium);
      await awardXp(XP.quizMedium, "case:mini-quiz");
    } else {
      setXpEarned((x) => x + XP.quizWrong);
      await awardXp(XP.quizWrong, "case:mini-quiz:wrong");
    }
  }

  async function next() {
    setPicked(null);
    if (idx + 1 >= stages.length) {
      setXpEarned((x) => x + 30);
      await awardXp(30, "case:complete");
    }
    setIdx((i) => i + 1);
  }

  if (done) {
    const totalMini = stages.filter((s) => s.mini_quiz_answer).length;
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <Trophy className="h-12 w-12 text-amber-500 mx-auto" />
          <h2 className="text-2xl font-bold">เรียนจบ Case แล้ว!</h2>
          <p className="text-muted-foreground">
            ตอบ mini-quiz ถูก {correct}/{totalMini} · +{xpEarned} XP
          </p>
          <div>
            <RewardBadge />
          </div>
          <div className="pt-3">
            <p className="text-sm font-semibold mb-2">แชร์ให้เพื่อน</p>
            <ShareResult
              topicName={caseTitle}
              score={correct}
              total={totalMini}
              xpEarned={xpEarned}
            />
          </div>
          <div className="flex gap-3 justify-center pt-2">
            <Link href="/school/cases">
              <Button variant="outline">Case อื่น</Button>
            </Link>
            <Link href="/school">
              <Button>กลับ School</Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      {/* Stage stepper */}
      <div className="flex items-center gap-1 overflow-x-auto pb-1">
        {stages.map((s, i) => (
          <div
            key={s.id}
            className={`shrink-0 text-xs px-2 py-1 rounded ${
              i < idx
                ? "bg-emerald-100 text-emerald-700"
                : i === idx
                  ? "bg-orange-100 text-orange-700"
                  : "bg-muted text-muted-foreground"
            }`}
          >
            {i < idx && <CheckCircle2 className="h-3 w-3 inline mr-1" />}
            {i + 1}. {s.layer}
          </div>
        ))}
      </div>

      <Card>
        <CardContent className="p-6">
          <div className="flex items-center gap-2 mb-3">
            <Badge className={LAYER_BADGE[stage.layer] ?? "bg-slate-100 text-slate-700"}>
              {stage.layer}
            </Badge>
            <Badge variant="outline" className="text-xs">
              Stage {idx + 1} / {stages.length}
            </Badge>
          </div>
          <h2 className="text-xl font-bold mb-3">{stage.title}</h2>
          <article className="prose prose-slate dark:prose-invert max-w-none text-sm">
            <ReactMarkdown remarkPlugins={[remarkGfm]}>{stage.body_md}</ReactMarkdown>
          </article>

          {stage.mini_quiz_stem && stage.mini_quiz_choices && (
            <div className="mt-6 pt-4 border-t space-y-3">
              <p className="text-xs font-bold uppercase text-muted-foreground">Mini Quiz</p>
              <p className="font-medium">{stage.mini_quiz_stem}</p>
              <div className="space-y-2">
                {stage.mini_quiz_choices.map((c) => {
                  const chosen = picked === c.label;
                  const isCorrectAns = picked && c.label === stage.mini_quiz_answer;
                  const isWrong = chosen && !isCorrectAns;
                  return (
                    <button
                      key={c.label}
                      onClick={() => pickMini(c.label)}
                      disabled={picked !== null}
                      className={[
                        "w-full text-left rounded-lg border px-4 py-2 flex items-start gap-3 text-sm",
                        isCorrectAns && "border-emerald-400 bg-emerald-50",
                        isWrong && "border-rose-400 bg-rose-50",
                        picked === null && "hover:border-brand/40 hover:bg-muted/50 cursor-pointer",
                      ].filter(Boolean).join(" ")}
                    >
                      <span className="font-semibold w-6 shrink-0">{c.label}.</span>
                      <span className="flex-1">{c.text}</span>
                    </button>
                  );
                })}
              </div>
              {picked !== null && stage.mini_quiz_explanation && (
                <div className="rounded-lg p-3 border text-sm bg-muted/30">
                  <p className="font-semibold mb-1">เฉลย: {stage.mini_quiz_answer}</p>
                  <p className="whitespace-pre-wrap">{stage.mini_quiz_explanation}</p>
                </div>
              )}
            </div>
          )}
        </CardContent>
      </Card>

      {(picked !== null || !stage.mini_quiz_stem) && (
        <Button onClick={next} className="w-full gap-2">
          {idx + 1 < stages.length ? "Stage ถัดไป" : "เรียนจบ"}{" "}
          <ArrowRight className="h-4 w-4" />
        </Button>
      )}
    </div>
  );
}
