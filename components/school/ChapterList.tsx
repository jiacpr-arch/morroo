"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { lessonHref } from "@/lib/school/ids";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import {
  BookOpen,
  Brain,
  CheckCircle2,
  ChevronRight,
  Circle,
  Lock,
  Zap,
} from "lucide-react";

export type LearnMode = "read" | "quiz" | "mixed";

export interface Chapter {
  id: string;
  title: string;
  estimated_min: number;
  /** จำนวนข้อสอบของบทนี้ (mini quiz ที่ฝังในบท + คลังข้อสอบของวิชา) */
  quizCount: number;
  read: boolean;
  /** รูปแรกของบท (hero) ใช้เป็น thumbnail ให้ลิสต์ไม่เป็นตัวหนังสือล้วน */
  thumb?: string | null;
  /**
   * ผู้ใช้ยังไม่มีสิทธิ์อ่านบทนี้ — ยังลิงก์ไปหน้าบทเรียนตามเดิม (หน้านั้น
   * เป็นที่กั้นจริงและแสดงการ์ดซื้อ) ที่นี่แค่บอกล่วงหน้าว่าล็อกอยู่
   */
  locked?: boolean;
  /** บทตัวอย่างที่เปิดให้อ่านฟรี — ติดป้ายเฉพาะเมื่อบทอื่นในวิชายังล็อก */
  freeSample?: boolean;
}

interface Props {
  chapters: Chapter[];
}

const MODES: {
  key: LearnMode;
  label: string;
  hint: string;
  icon: typeof BookOpen;
  activeClass: string;
}[] = [
  {
    key: "mixed",
    label: "อ่าน + ควิซ",
    hint: "อ่านทีละส่วนสั้น ๆ แบบ mini class ตอบคำถามท้ายส่วนก่อนไปต่อ (แนะนำ)",
    icon: Zap,
    activeClass: "border-violet-500 bg-violet-50 text-violet-700",
  },
  {
    key: "read",
    label: "อ่านอย่างเดียว",
    hint: "อ่านทีละส่วนเหมือนกัน แต่ข้ามคำถามท้ายส่วนได้",
    icon: BookOpen,
    activeClass: "border-teal-500 bg-teal-50 text-teal-700",
  },
  {
    key: "quiz",
    label: "ควิซอย่างเดียว",
    hint: "ข้ามเนื้อหา ทำข้อสอบของบทนี้ทั้งหมดรวดเดียว",
    icon: Brain,
    activeClass: "border-emerald-500 bg-emerald-50 text-emerald-700",
  },
];

const STORAGE_KEY = "school:learn-mode";

/**
 * รายการบทของวิชา พร้อมสวิตช์เลือกว่าจะเรียนแบบไหน — ตัวเลือกจำไว้ใน
 * localStorage เพื่อไม่ต้องเลือกใหม่ทุกบท และส่งต่อเป็น ?mode= ให้หน้าบทเรียน
 */
export default function ChapterList({ chapters }: Props) {
  const [mode, setMode] = useState<LearnMode>("mixed");

  useEffect(() => {
    const saved = window.localStorage.getItem(STORAGE_KEY);
    if (saved === "read" || saved === "quiz" || saved === "mixed") {
      setMode(saved);
    }
  }, []);

  function choose(next: LearnMode) {
    setMode(next);
    window.localStorage.setItem(STORAGE_KEY, next);
  }

  const active = MODES.find((m) => m.key === mode)!;
  // Skip any chapter without a real id so we never link to /school/lesson/null.
  const rows = chapters.flatMap((c) => {
    const href = lessonHref(c.id, `mode=${mode}`);
    return href ? [{ ...c, href }] : [];
  });

  return (
    <div className="space-y-4">
      <div>
        <p className="text-sm font-semibold mb-2">อยากเรียนแบบไหน?</p>
        <div className="grid grid-cols-3 gap-2">
          {MODES.map((m) => {
            const Icon = m.icon;
            const on = m.key === mode;
            return (
              <button
                key={m.key}
                onClick={() => choose(m.key)}
                aria-pressed={on}
                className={[
                  "rounded-lg border-2 p-3 text-center transition-colors",
                  on
                    ? m.activeClass
                    : "border-muted text-muted-foreground hover:bg-muted/50",
                ].join(" ")}
              >
                <Icon className="h-5 w-5 mx-auto mb-1" />
                <span className="text-xs font-semibold block leading-tight">
                  {m.label}
                </span>
              </button>
            );
          })}
        </div>
        <p className="text-xs text-muted-foreground mt-2">{active.hint}</p>
      </div>

      {rows.length === 0 ? (
        <Card>
          <CardContent className="p-6 text-center text-sm text-muted-foreground">
            วิชานี้ยังไม่มีบทเรียน — รอเนื้อหาเร็วๆ นี้
          </CardContent>
        </Card>
      ) : (
        <ul className="space-y-2">
          {rows.map((c, i) => (
            <li key={c.id}>
              <Link
                href={c.href}
                className="flex items-center gap-3 rounded-lg border p-4 hover:bg-muted/50 transition-colors"
              >
                {c.locked ? (
                  <Lock className="h-5 w-5 text-muted-foreground shrink-0" />
                ) : c.read ? (
                  <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0" />
                ) : (
                  <Circle className="h-5 w-5 text-muted-foreground shrink-0" />
                )}
                {c.thumb && (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={c.thumb}
                    alt=""
                    loading="lazy"
                    className="h-14 w-20 shrink-0 rounded-md border bg-white object-cover"
                  />
                )}
                <div className="flex-1 min-w-0">
                  <p className="font-medium leading-snug">
                    บทที่ {i + 1} · {c.title}
                  </p>
                  <div className="flex gap-3 mt-1 text-xs text-muted-foreground">
                    {mode !== "quiz" && <span>อ่าน ~{c.estimated_min} นาที</span>}
                    {mode !== "read" && c.quizCount > 0 && (
                      <span className="flex items-center gap-1">
                        <Brain className="h-3 w-3" /> {c.quizCount} ข้อ
                      </span>
                    )}
                  </div>
                </div>
                {c.locked ? (
                  <Badge variant="secondary" className="text-[10px] shrink-0">
                    ต้องปลดล็อก
                  </Badge>
                ) : c.freeSample ? (
                  <Badge className="bg-sky-100 text-sky-700 text-[10px] shrink-0">
                    อ่านฟรี
                  </Badge>
                ) : null}
                {mode === "quiz" && c.quizCount === 0 && (
                  <Badge variant="secondary" className="text-[10px]">
                    ยังไม่มีข้อสอบ
                  </Badge>
                )}
                <ChevronRight className="h-4 w-4 text-muted-foreground shrink-0" />
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
