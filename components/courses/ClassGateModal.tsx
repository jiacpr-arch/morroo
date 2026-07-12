"use client";

import { useState } from "react";
import { useClassStore } from "@/lib/courses/stores/class-store";
import type { CourseMode } from "@/lib/courses/config";
import {
  rpcCreateClass,
  rpcVerifyClassCode,
  rpcVerifyInstructorCode,
} from "@/lib/courses/cohort";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";
import { track } from "@/lib/analytics";
import {
  BookOpen,
  KeyRound,
  AlertCircle,
  Check,
  Copy,
  Play,
  ChevronLeft,
  ShieldCheck,
} from "lucide-react";
import {
  modalOverlay,
  modalPanel,
  textHeadline,
  text2xs,
  btnPrimary,
  btnGhost,
  btnMd,
  btnSm,
  btnLg,
  btnBlock,
  inputBase,
  errorBox,
} from "./course-ui";

type GateMode = "home" | "join" | "create";

interface ClassGateModalProps {
  open: boolean;
  onClose?: () => void;
  course: CourseMode;
  initialMode?: GateMode;
  instructor?: boolean;
  initialCode?: string;
}

// Shown on the course hub when no class is selected and the user hasn't
// opted into offline mode.
// Three modes:
//   home   — student-first landing: "start now" (solo) is the primary action,
//            joining a class is a secondary option, creating a class is a small
//            instructor-only link. This split fixes the old equal-weight 3-way
//            choice that made students tap the wrong thing.
//   join   — enter a class code (students with a code from their instructor).
//   create — make a new class (instructors only).
// initialMode lets instructor-facing pages open straight into 'create' or
// 'join', skipping the student-first home screen entirely.
// instructor=true switches join mode to instructor-code verification (the
// code that unlocks the cohort summary; legacy class codes still work).
// initialCode prefills the join input — used by ?join=CODE links.
export default function ClassGateModal({
  open,
  onClose,
  course,
  initialMode = "home",
  instructor = false,
  initialCode = "",
}: ClassGateModalProps) {
  const setClass = useClassStore((s) => s.setClass);
  const disableSync = useClassStore((s) => s.disableSync);

  const [mode, setMode] = useState<GateMode>(initialMode);
  const [code, setCode] = useState(initialCode);
  const [className, setClassName] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [created, setCreated] = useState<{ code: string; instructorCode: string } | null>(
    null,
  );

  // Re-sync to initialMode each time the modal (re)opens, adjusting state
  // during render (https://react.dev/learn/you-might-not-need-an-effect).
  const [prevOpen, setPrevOpen] = useState(open);
  if (open !== prevOpen) {
    setPrevOpen(open);
    if (open) {
      setMode(initialMode);
      setError("");
      setCode(initialCode);
    }
  }

  if (!open) return null;

  // Opened directly into a sub-mode (instructor page): back = close, since
  // the student-first home screen would only confuse an instructor.
  const goHome = () => {
    if (initialMode !== "home") {
      onClose?.();
      return;
    }
    setMode("home");
    setError("");
  };

  const submitJoin = async (e?: React.FormEvent) => {
    e?.preventDefault();
    const normalized = code.trim().toUpperCase();
    if (normalized.length < 4) {
      setError("กรอกรหัสคลาส 6 หลัก");
      return;
    }
    setBusy(true);
    setError("");

    if (instructor) {
      // Instructor reconnect: verify the instructor code (legacy class codes
      // also pass). Returns the student join code so both get stored.
      const { data, error: rpcErr } = await rpcVerifyInstructorCode(normalized);
      if (rpcErr || !data) {
        setBusy(false);
        const msg = rpcErr?.message || "";
        if (msg.includes("invalid_code")) {
          // Common slip: typing the student join code of a new-style class.
          const { data: studentClass } = await rpcVerifyClassCode(normalized);
          if (studentClass) {
            setError(
              'นี่คือรหัสสำหรับนักเรียนเข้าคลาส — การดูผลรวมต้องใช้ "รหัสอาจารย์" ที่ได้ตอนสร้างคลาส',
            );
          } else {
            setError("ไม่พบคลาสนี้ ตรวจสอบรหัสอีกครั้ง");
          }
        } else {
          setError("เชื่อมต่อไม่สำเร็จ: " + msg);
        }
        return;
      }
      setBusy(false);
      if (data.courseMode !== course) {
        setError(`คลาสนี้เป็นของหลักสูตร ${data.courseMode.toUpperCase()} — เปิดผิดเว็บ`);
        return;
      }
      setClass({
        classId: data.classId,
        classCode: data.classCode,
        instructorCode: data.instructorCode,
        className: data.className,
        courseMode: data.courseMode,
      });
      track("instructor_class_connected");
      scheduleFlush();
      onClose?.();
      return;
    }

    const { data, error: rpcErr } = await rpcVerifyClassCode(normalized);
    setBusy(false);
    if (rpcErr || !data) {
      const msg = rpcErr?.message || "";
      if (msg.includes("invalid_code")) setError("ไม่พบคลาสนี้ ตรวจสอบรหัสอีกครั้ง");
      else setError("เชื่อมต่อไม่สำเร็จ: " + msg);
      return;
    }
    if (data.courseMode !== course) {
      setError(`คลาสนี้เป็นของหลักสูตร ${data.courseMode.toUpperCase()} — เปิดผิดเว็บ`);
      return;
    }
    setClass({
      classId: data.classId,
      classCode: normalized,
      className: data.className,
      courseMode: data.courseMode,
    });
    track("class_joined", {
      via: initialCode && normalized === initialCode.toUpperCase() ? "link" : "manual",
    });
    // Push any rows that were created while offline / before class was set
    scheduleFlush();
    onClose?.();
  };

  const submitCreate = async (e?: React.FormEvent) => {
    e?.preventDefault();
    const n = className.trim();
    if (!n) {
      setError("ใส่ชื่อคลาส");
      return;
    }
    setBusy(true);
    setError("");
    const { data, error: rpcErr } = await rpcCreateClass({
      name: n,
      courseMode: course,
    });
    setBusy(false);
    if (rpcErr || !data) {
      setError("สร้างไม่สำเร็จ: " + (rpcErr?.message || ""));
      return;
    }
    setClass({
      classId: data.classId,
      classCode: data.code,
      instructorCode: data.instructorCode,
      className: n,
      courseMode: course,
    });
    track("class_created");
    scheduleFlush();
    setCreated({ code: data.code, instructorCode: data.instructorCode });
  };

  const useOffline = () => {
    disableSync();
    onClose?.();
  };

  if (created) {
    return (
      <div className={modalOverlay}>
        <div className={modalPanel}>
          <div className="flex items-center gap-2">
            <div className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-500/15 text-emerald-600 dark:text-emerald-400">
              <Check size={18} strokeWidth={2.4} />
            </div>
            <div>
              <div className={textHeadline}>สร้างคลาสสำเร็จ</div>
              <div className={`${text2xs} text-muted-foreground`}>
                ได้รหัส 2 ชุด — ใช้คนละหน้าที่
              </div>
            </div>
          </div>

          <div className="rounded-lg bg-muted p-4 text-center">
            <div className={`${text2xs} mb-1 font-semibold uppercase tracking-wider text-muted-foreground`}>
              รหัสเข้าคลาส (แจกนักเรียน)
            </div>
            <div className="font-mono text-3xl font-bold tracking-[0.3em] text-foreground">
              {created.code}
            </div>
            <button
              onClick={() => navigator.clipboard?.writeText(created.code)}
              className={`${btnGhost} ${btnSm} mt-2`}
            >
              <Copy size={13} strokeWidth={2.2} /> คัดลอก
            </button>
          </div>

          <div className="rounded-lg border border-amber-500/30 bg-amber-500/10 p-4 text-center">
            <div className={`${text2xs} mb-1 inline-flex items-center gap-1 font-semibold uppercase tracking-wider text-amber-600 dark:text-amber-400`}>
              <ShieldCheck size={12} strokeWidth={2.4} /> รหัสอาจารย์ (เก็บเป็นความลับ)
            </div>
            <div className="font-mono text-2xl font-bold tracking-[0.3em] text-foreground">
              {created.instructorCode}
            </div>
            <button
              onClick={() => navigator.clipboard?.writeText(created.instructorCode)}
              className={`${btnGhost} ${btnSm} mt-2`}
            >
              <Copy size={13} strokeWidth={2.2} /> คัดลอก
            </button>
            <p className={`${text2xs} mt-1 text-muted-foreground`}>
              ใช้ดูผลรวมทั้งคลาส และเชื่อมต่อคลาสนี้บนเครื่องอื่น — จดเก็บไว้ให้ดี
              อย่าแจกให้นักเรียน
            </p>
          </div>

          <button
            onClick={() => {
              setCreated(null);
              onClose?.();
            }}
            className={`${btnPrimary} ${btnMd} ${btnBlock}`}
          >
            เรียบร้อย
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className={modalOverlay}>
      <div className={modalPanel}>
        {mode === "home" && (
          <>
            <div className="flex items-center gap-2">
              <div className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
                <BookOpen size={18} strokeWidth={2.2} />
              </div>
              <div>
                <div className={textHeadline}>พร้อมเริ่มเรียนแล้ว</div>
                <div className={`${text2xs} text-muted-foreground`}>
                  เริ่มทำข้อสอบได้เลย ไม่ต้องใช้รหัส
                </div>
              </div>
            </div>

            {/* Primary action — the path almost every student wants */}
            <div>
              <button
                onClick={useOffline}
                className={`${btnPrimary} ${btnLg} ${btnBlock} font-bold`}
              >
                <Play size={18} strokeWidth={2.4} /> เริ่มเรียนเลย
              </button>
              <p className={`${text2xs} mt-1.5 text-center text-muted-foreground`}>
                เริ่มทำข้อสอบได้ทันที (ข้อมูลเก็บในเครื่องนี้)
              </p>
            </div>

            <div className="flex items-center gap-2">
              <div className="h-px flex-1 bg-border" />
              <span className={`${text2xs} text-muted-foreground`}>หรือ</span>
              <div className="h-px flex-1 bg-border" />
            </div>

            {/* Secondary — only for students who got a code from their instructor */}
            <button
              onClick={() => {
                setMode("join");
                setError("");
              }}
              className="inline-flex w-full items-center justify-center gap-1.5 rounded-lg border border-border bg-muted px-3 py-2.5 text-xs font-bold text-foreground/80 hover:bg-muted/70"
            >
              <KeyRound size={14} strokeWidth={2.4} />
              มีรหัสคลาสจากอาจารย์? เข้าคลาส
            </button>

            {/* Instructor-only, de-emphasized so students don't tap it by mistake */}
            <div className="border-t border-border pt-3 text-center">
              <button
                onClick={() => {
                  setMode("create");
                  setError("");
                }}
                className={`${text2xs} text-muted-foreground underline underline-offset-2`}
              >
                เป็นอาจารย์? สร้างคลาสใหม่
              </button>
            </div>
          </>
        )}

        {mode === "join" && (
          <>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={goHome}
                className="inline-flex h-8 w-8 items-center justify-center rounded-full text-muted-foreground hover:bg-muted"
                aria-label="ย้อนกลับ"
              >
                <ChevronLeft size={18} strokeWidth={2.4} />
              </button>
              <div>
                <div className={textHeadline}>
                  {instructor ? "เชื่อมต่อคลาส (อาจารย์)" : "เข้าคลาส"}
                </div>
                <div className={`${text2xs} text-muted-foreground`}>
                  {instructor
                    ? "ใช้รหัสอาจารย์ที่ได้ตอนสร้างคลาส (คลาสรุ่นเก่าใช้รหัสคลาสได้)"
                    : "กรอกรหัสที่ได้จากอาจารย์"}
                </div>
              </div>
            </div>

            <form onSubmit={submitJoin} className="space-y-3">
              <label className="block">
                <span className="text-xs font-semibold text-foreground/80">
                  {instructor ? "รหัสอาจารย์ (6 หลัก)" : "รหัสคลาส (6 หลัก)"}
                </span>
                <input
                  type="text"
                  autoFocus
                  value={code}
                  onChange={(e) => setCode(e.target.value.toUpperCase())}
                  placeholder="เช่น K7M2QX"
                  maxLength={6}
                  className={`${inputBase} mt-1 text-center font-mono text-2xl tracking-[0.3em]`}
                />
              </label>
              {error && (
                <div className={errorBox}>
                  <AlertCircle size={14} strokeWidth={2.2} /> {error}
                </div>
              )}
              <button
                type="submit"
                disabled={busy}
                className={`${btnPrimary} ${btnMd} ${btnBlock}`}
              >
                {busy ? "กำลังเชื่อมต่อ…" : "เข้าคลาส"}
              </button>
            </form>
          </>
        )}

        {mode === "create" && (
          <>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={goHome}
                className="inline-flex h-8 w-8 items-center justify-center rounded-full text-muted-foreground hover:bg-muted"
                aria-label="ย้อนกลับ"
              >
                <ChevronLeft size={18} strokeWidth={2.4} />
              </button>
              <div>
                <div className={textHeadline}>สร้างคลาสใหม่</div>
                <div className={`${text2xs} text-muted-foreground`}>
                  สำหรับอาจารย์ — ได้รหัสไว้แจกนักเรียน
                </div>
              </div>
            </div>

            <form onSubmit={submitCreate} className="space-y-3">
              <label className="block">
                <span className="text-xs font-semibold text-foreground/80">ชื่อคลาส</span>
                <input
                  type="text"
                  autoFocus
                  value={className}
                  onChange={(e) => setClassName(e.target.value)}
                  placeholder="เช่น BLS รุ่นที่ 12 / 2025"
                  className={`${inputBase} mt-1 text-sm`}
                />
              </label>
              {error && (
                <div className={errorBox}>
                  <AlertCircle size={14} strokeWidth={2.2} /> {error}
                </div>
              )}
              <button
                type="submit"
                disabled={busy}
                className={`${btnPrimary} ${btnMd} ${btnBlock}`}
              >
                {busy ? "กำลังสร้าง…" : "สร้างคลาส"}
              </button>
            </form>
          </>
        )}
      </div>
    </div>
  );
}
