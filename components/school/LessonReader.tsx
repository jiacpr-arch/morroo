"use client";

import { useMemo, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import {
  CheckCircle,
  XCircle,
  ArrowRight,
  ArrowLeft,
  Sparkles,
  Brain,
  Image as ImageIcon,
} from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import type { SchoolLesson, SchoolQuiz } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { XP, awardXp } from "@/lib/school/xp";
import { splitLessonParts, type InlineQuiz } from "@/lib/school/lesson-parts";
import {
  difficultyLabelTh,
  difficultyBadgeClass,
} from "@/lib/school/difficulty";
import type { SchoolDifficulty } from "@/lib/types-school";
import BookmarkButton from "./BookmarkButton";
import NoteEditor from "./NoteEditor";
import RelatedConcepts from "./RelatedConcepts";
import ImageUploader from "./ImageUploader";
import { figureComponents } from "./LessonFigure";
import { hasFigures, type FigureMeta } from "@/lib/school/figures";
import { track } from "@/lib/analytics";

/** The Visual Summary card linked to this lesson (school_visuals.lesson_id). */
export interface LessonSummaryVisual {
  id: string;
  title: string;
  image_url: string | null;
  caption: string | null;
}

interface Props {
  lesson: SchoolLesson;
  miniQuizzes: SchoolQuiz[];
  /**
   * "mixed" (ค่าเริ่มต้น) = อ่านทีละ Part แล้วต้องตอบ mini quiz ก่อนไปต่อ
   * "read" = อ่านรวดเดียวทั้งบท ไม่มีคำถามคั่น (ยังนับว่าอ่านจบและได้ XP)
   */
  mode?: "mixed" | "read";
  /** ลิงก์ไปโหมดควิซของบทนี้ แสดงตอนอ่านจบ */
  quizHref?: string;
  /** บทถัดไปในวิชาเดียวกัน — เป็นปุ่มหลักตอนเรียนจบ ถ้าไม่มีคือบทสุดท้ายแล้ว */
  nextLesson?: { href: string; title: string } | null;
  /** ลิงก์กลับหน้าวิชา — ทางออกเสมอ แม้จะเป็นบทสุดท้าย */
  topicHref?: string;
  /**
   * รูปสรุปท้ายบท (Visual Summary ที่ผูกกับบทนี้) — โชว์บนการ์ด "เรียนจบ"
   * ให้ทวนก่อนทำ Final Retrieval และลิงก์ไปหน้า visual เต็ม
   */
  summaryVisual?: LessonSummaryVisual | null;
  /**
   * โหมดแอดมิน: ถ้าส่งมา จะมีช่องอัปโหลดรูปคั่นก่อน/หลังทุก Part
   * (gapIndex 0 = ก่อน Part 1, i = หลัง Part i) และปิดการนับ XP/ความก้าวหน้า
   * เพราะแอดมินไม่ได้กำลังเรียน หน้าตาส่วนอื่นเหมือนที่นักเรียนเห็นทุกอย่าง
   * `meta` คือ alt + caption ที่แอดมินกรอกไว้ก่อนอัป
   */
  onInsertImage?: (gapIndex: number, url: string, meta: FigureMeta) => void;
}

/**
 * Reader with mini-quiz interleaving. Authors split lesson body_md into
 * sections using a marker line `## ⏸ Mini Quiz`, and author the quiz for each
 * gate inline right after its marker so it always matches the part above. The
 * reader shows that inline quiz between sections, falling back to a quiz from
 * the topic pool (`miniQuizzes`) only for lessons not yet migrated to inline.
 * Reaching the end marks the lesson as read (XP awarded) and reveals a final
 * retrieval quiz tail.
 */
export default function LessonReader({
  lesson,
  miniQuizzes,
  mode = "mixed",
  quizHref,
  nextLesson,
  topicHref,
  summaryVisual,
  onInsertImage,
}: Props) {
  const adminMode = !!onInsertImage;
  const readOnly = mode === "read";
  const { sections, gateQuizzes } = useMemo(() => {
    const parsed = splitLessonParts(lesson.body_md);
    return { sections: parsed.parts, gateQuizzes: parsed.gateQuizzes };
  }, [lesson.body_md]);
  const totalGates = sections.length - 1;

  // The quiz shown after part `idx`: inline quiz if authored, else fall back to
  // the legacy topic pool so un-migrated lessons keep working.
  const quizForGate = (idx: number): InlineQuiz | null =>
    gateQuizzes[idx] ?? miniQuizzes[idx] ?? null;

  const [step, setStep] = useState(0); // sections[step] currently visible
  const [completed, setCompleted] = useState(false);

  // For each gate, choose a quiz; track answer
  const [picks, setPicks] = useState<Record<number, string>>({});

  async function markCompleted() {
    if (completed) return;
    setCompleted(true);
    if (adminMode) return;
    // has_figures ไว้เทียบว่าบทที่มีรูปจบบทมากกว่าบทตัวหนังสือล้วนไหม
    track("school_lesson_completed", {
      lesson_id: lesson.id,
      mode,
      has_figures: hasFigures(lesson.body_md),
    });
    await awardXp(XP.lessonRead, `lesson:${lesson.id}`);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "lesson",
          unit_id: lesson.id,
          outcome: "good",
          ease_factor: 2.5,
          interval_days: 7,
        });
      }
    } catch {
      // Non-blocking
    }
  }

  function nextSection() {
    if (step + 1 >= sections.length) {
      markCompleted();
      return;
    }
    setStep((s) => s + 1);
    if (step + 1 === sections.length - 1) {
      markCompleted();
    }
  }

  function pickAt(gateIdx: number, label: string) {
    if (picks[gateIdx]) return;
    setPicks({ ...picks, [gateIdx]: label });
  }

  const visibleSections = readOnly ? sections : sections.slice(0, step + 1);
  const finished = readOnly ? completed : step + 1 === sections.length;

  return (
    <div className="space-y-6">
      {adminMode && (
        <ImageInsertSlot onUploaded={(u, meta) => onInsertImage!(0, u, meta)} />
      )}
      {visibleSections.map((sec, idx) => (
        <div key={idx}>
          <Card>
            <CardContent className="p-5">
              <div className="flex items-center gap-2 mb-3">
                <Badge variant="outline" className="text-xs">
                  Part {idx + 1} / {sections.length}
                </Badge>
                <div className="ml-auto">
                  <BookmarkButton unitType="lesson" unitId={lesson.id} />
                </div>
              </div>
              <article className="prose prose-slate dark:prose-invert max-w-none">
                <ReactMarkdown remarkPlugins={[remarkGfm]} components={figureComponents}>
                  {sec}
                </ReactMarkdown>
              </article>
              <RelatedConcepts unitType="lesson" unitId={lesson.id} />
            </CardContent>
          </Card>

          {/* Mini-quiz gate between sections — shown on the current part too
              so the reader can answer it and unlock the Continue button */}
          {!readOnly && idx < totalGates && idx <= step && quizForGate(idx) && (
            <MiniQuizCard
              quiz={quizForGate(idx)!}
              picked={picks[idx] ?? null}
              onPick={(l) => pickAt(idx, l)}
            />
          )}

          {/* Continue button */}
          {!readOnly && idx === step && step + 1 < sections.length && (
            <Button
              onClick={nextSection}
              disabled={idx < totalGates && !!quizForGate(idx) && !picks[idx]}
              className="w-full mt-3 gap-2"
            >
              Part ถัดไป <ArrowRight className="h-4 w-4" />
            </Button>
          )}

          {adminMode && (
            <div className="mt-3">
              <ImageInsertSlot
                onUploaded={(u, meta) => onInsertImage!(idx + 1, u, meta)}
              />
            </div>
          )}
        </div>
      ))}

      {/* อ่านอย่างเดียว: กดยืนยันเองว่าอ่านจบ (โหมด mixed นับให้อัตโนมัติ) */}
      {readOnly && !completed && !adminMode && (
        <Button onClick={markCompleted} className="w-full gap-2">
          อ่านจบแล้ว <ArrowRight className="h-4 w-4" />
        </Button>
      )}

      {finished && !adminMode && (
        <Card className="border-teal-300 bg-teal-50/40">
          <CardContent className="p-5 space-y-3">
            <p className="font-bold flex items-center gap-2 text-teal-700">
              <Sparkles className="h-5 w-5" /> เรียนจบบทนี้แล้ว
            </p>
            <p className="text-sm text-muted-foreground">
              ระบบบันทึกความก้าวหน้า + ให้ XP แล้ว
            </p>
            {summaryVisual && <SummaryCard visual={summaryVisual} />}
            {readOnly && quizHref && (
              <Link href={quizHref}>
                <Button className="w-full gap-2 bg-emerald-600 hover:bg-emerald-700 text-white">
                  <Brain className="h-4 w-4" /> ทำควิซของบทนี้
                </Button>
              </Link>
            )}
            <NoteEditor unitType="lesson" unitId={lesson.id} />
          </CardContent>
        </Card>
      )}

      {/* Final retrieval — pick remaining quizzes not used as gates */}
      {!readOnly && step + 1 === sections.length && miniQuizzes.length > totalGates && (
        <FinalQuiz quizzes={miniQuizzes.slice(totalGates)} />
      )}

      {/* ทางไปต่อ — อยู่ท้ายสุดเสมอ (หลัง final retrieval) เพื่อไม่ให้ดึงคนออก
          จากบทก่อนได้ทบทวน แต่จบแล้วต้องมีปุ่มบอกว่าไปไหนต่อ */}
      {finished && !adminMode && (nextLesson || topicHref) && (
        <NextSteps nextLesson={nextLesson} topicHref={topicHref} />
      )}
    </div>
  );
}

/** ปุ่มไปต่อตอนเรียนจบบท: บทถัดไปเป็นปุ่มหลัก + กลับหน้าวิชาเสมอ */
function NextSteps({
  nextLesson,
  topicHref,
}: {
  nextLesson?: { href: string; title: string } | null;
  topicHref?: string;
}) {
  return (
    <Card>
      <CardContent className="p-5 space-y-3">
        <p className="text-sm font-semibold">ไปต่อ</p>
        {nextLesson ? (
          <Link href={nextLesson.href} className="block">
            <Button className="w-full gap-2 justify-between">
              <span className="truncate text-left">
                บทถัดไป: {nextLesson.title}
              </span>
              <ArrowRight className="h-4 w-4 shrink-0" />
            </Button>
          </Link>
        ) : (
          <p className="text-xs text-muted-foreground">
            บทนี้เป็นบทสุดท้ายของวิชาแล้ว 🎉
          </p>
        )}
        {topicHref && (
          <Link href={topicHref} className="block">
            <Button variant="outline" className="w-full gap-2">
              <ArrowLeft className="h-4 w-4" /> กลับไปหน้าวิชา
            </Button>
          </Link>
        )}
      </CardContent>
    </Card>
  );
}

/** รูปสรุปท้ายบท — ทวน 1 ภาพก่อน Final Retrieval แล้วกดไปหน้า visual เต็มได้ */
function SummaryCard({ visual }: { visual: LessonSummaryVisual }) {
  return (
    <Link
      href={`/school/visual/${visual.id}`}
      className="block overflow-hidden rounded-xl border bg-white transition hover:border-fuchsia-300 hover:shadow-sm"
    >
      {visual.image_url && (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          src={visual.image_url}
          alt={visual.title}
          loading="lazy"
          className="w-full object-contain bg-white"
        />
      )}
      <div className="flex items-center gap-2 p-3">
        <ImageIcon className="h-4 w-4 shrink-0 text-fuchsia-600" />
        <div className="min-w-0 flex-1">
          <p className="truncate text-sm font-semibold">สรุปบทนี้ใน 1 ภาพ</p>
          <p className="truncate text-xs text-muted-foreground">
            {visual.caption ?? visual.title}
          </p>
        </div>
        <ArrowRight className="h-4 w-4 shrink-0 text-muted-foreground" />
      </div>
    </Link>
  );
}

/**
 * ช่องอัปโหลดรูปคั่นระหว่าง Part — เห็นเฉพาะแอดมิน
 * กรอก alt/caption ก่อนกดอัป จะได้ `![alt](url "caption")` ครบตั้งแต่แรก
 */
export function ImageInsertSlot({
  onUploaded,
}: {
  onUploaded: (url: string, meta: FigureMeta) => void;
}) {
  const [alt, setAlt] = useState("");
  const [caption, setCaption] = useState("");
  return (
    <div className="space-y-1.5 rounded-lg border border-dashed bg-muted/20 px-3 py-2">
      <div className="grid gap-1.5 sm:grid-cols-2">
        <input
          value={alt}
          onChange={(e) => setAlt(e.target.value)}
          placeholder="alt (บรรยายรูปสั้น ๆ)"
          className="w-full rounded border bg-background px-2 py-1 text-xs"
        />
        <input
          value={caption}
          onChange={(e) => setCaption(e.target.value)}
          placeholder="caption ใต้รูป (1 ประโยค บอกว่าต้องดูอะไร)"
          className="w-full rounded border bg-background px-2 py-1 text-xs"
        />
      </div>
      <div className="flex items-center gap-2">
        <div className="flex-1 border-t border-dashed" />
        <ImageUploader
          onUploaded={(url) => {
            onUploaded(url, { alt, caption });
            setAlt("");
            setCaption("");
          }}
          label="+ แทรกรูปตรงนี้"
        />
        <div className="flex-1 border-t border-dashed" />
      </div>
    </div>
  );
}

function MiniQuizCard({
  quiz,
  picked,
  onPick,
}: {
  quiz: InlineQuiz;
  picked: string | null;
  onPick: (label: string) => void;
}) {
  return (
    <Card className="mt-3 border-emerald-200 bg-emerald-50/40">
      <CardContent className="p-4 space-y-2">
        <div className="flex items-center gap-2">
          <p className="text-xs font-bold uppercase text-emerald-700">Mini Quiz</p>
          {quiz.difficulty && <DifficultyBadge difficulty={quiz.difficulty} />}
        </div>
        <p className="font-medium text-sm">{quiz.stem}</p>
        <div className="space-y-1">
          {quiz.choices.map((c) => {
            const chosen = picked === c.label;
            const isCorrect = picked && c.label === quiz.correct_answer;
            const isWrong = chosen && !isCorrect;
            return (
              <button
                key={c.label}
                onClick={() => onPick(c.label)}
                disabled={picked !== null}
                className={[
                  "w-full text-left rounded border px-3 py-2 text-sm flex items-start gap-2",
                  isCorrect && "border-emerald-400 bg-emerald-50",
                  isWrong && "border-rose-400 bg-rose-50",
                  picked === null && "hover:bg-muted/50 cursor-pointer",
                ].filter(Boolean).join(" ")}
              >
                <span className="font-semibold w-5 shrink-0">{c.label}.</span>
                <span className="flex-1">{c.text}</span>
                {isCorrect && <CheckCircle className="h-4 w-4 text-emerald-600" />}
                {isWrong && <XCircle className="h-4 w-4 text-rose-600" />}
              </button>
            );
          })}
        </div>
        {picked !== null && quiz.explanation && (
          <p className="text-xs italic text-muted-foreground">
            {quiz.explanation}
          </p>
        )}
      </CardContent>
    </Card>
  );
}

function DifficultyBadge({ difficulty }: { difficulty: SchoolDifficulty }) {
  return (
    <Badge className={`text-[10px] ${difficultyBadgeClass(difficulty)}`}>
      {difficultyLabelTh(difficulty)}
    </Badge>
  );
}

function FinalQuiz({ quizzes }: { quizzes: SchoolQuiz[] }) {
  return (
    <Card className="border-sky-300">
      <CardContent className="p-5 space-y-3">
        <p className="font-bold flex items-center gap-1">
          <CheckCircle className="h-4 w-4 text-sky-600" />
          Final Retrieval ({quizzes.length} ข้อ)
        </p>
        <p className="text-xs text-muted-foreground">
          ทดสอบความเข้าใจตอนจบบท — ใช้ active recall เพื่อ retention
        </p>
        <ul className="space-y-2">
          {quizzes.map((q) => {
            const answerText =
              q.choices.find((c) => c.label === q.correct_answer)?.text ??
              q.correct_answer;
            return (
              <li key={q.id} className="border rounded p-3">
                <div className="mb-2 flex items-start gap-2">
                  <p className="text-sm font-medium flex-1">{q.stem}</p>
                  {q.difficulty && <DifficultyBadge difficulty={q.difficulty} />}
                </div>
                <details>
                  <summary className="text-xs text-muted-foreground cursor-pointer">
                    ดูเฉลย
                  </summary>
                  <div className="mt-2 space-y-1 text-xs">
                    <p className="font-semibold">{answerText}</p>
                    {q.explanation && <p className="text-muted-foreground">{q.explanation}</p>}
                  </div>
                </details>
              </li>
            );
          })}
        </ul>
      </CardContent>
    </Card>
  );
}

