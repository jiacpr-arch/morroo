"use client";

// Instructor cohort dashboard — ported from acls-emr's
// src/pages/InstructorCohort.jsx. Shared between /acls/cohort and
// /bls/cohort (thin per-course page wrappers pass `course`), following the
// same "shared client component, thin per-course page" pattern as
// AclsHub/BlsHub.
//
// Deliberate simplifications vs. the source:
//  - No QR code image for the join link. The source lazily imported the
//    `qrcode` npm package; it isn't installed here and the task scope forbids
//    adding new dependencies. The class code / join link can still be copied
//    and shared manually.
//  - The join link omits `&openExternalBrowser=1` — that param was read by
//    acls-emr's InAppBrowserGuard component, which was never ported to
//    morroo, so the flag would be inert here.
//  - PDF table export uses a small hand-rolled grid renderer instead of
//    `jspdf-autotable` (also not an installed dependency) — see
//    lib/courses/export-cohort.ts.

import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import {
  ChevronLeft,
  Users,
  Download,
  FileText,
  Trash,
  Sparkles,
  Award,
  Cloud,
  CloudOff,
  RefreshCw,
  Copy,
  Check,
  Plus,
  KeyRound,
  Link as LinkIcon,
  Eye,
  EyeOff,
  ShieldCheck,
} from "lucide-react";

import { getCourseMeta, type CourseMode } from "@/lib/courses/config";
import { useClassStore } from "@/lib/courses/stores/class-store";
import {
  rpcGetCohortSummary,
  rpcDeleteCohortStudent,
  type CohortSummaryRow,
} from "@/lib/courses/cohort";
import { getCohortSummary as getLocalCohortSummary, deleteStudent } from "@/lib/courses/offline/db";
import { scheduleFlush, getPendingCount, subscribeToSync } from "@/lib/courses/offline/sync-engine";
import { track } from "@/lib/analytics";

import ClassGateModal from "./ClassGateModal";
import CohortTable, { type CohortTableRow } from "./CohortTable";
import {
  exportCohortCSV,
  exportCohortPDF,
  exportCohortSummaryCSV,
  exportCohortSummaryPDF,
  type CohortOverallExportRow,
} from "@/lib/courses/export-cohort";
import { dashCard, btnGhost, btnPrimary, btnSm, btnMd, btnBlock } from "./course-ui";

import { preCourseLessons as aclsPreCourseLessons } from "@/lib/acls-reader/precourse";
import { preCourseLessons as blsPreCourseLessons } from "@/lib/courses/bls/lessons";
import {
  PRE_TEST_LESSON_ID,
  PRE_TEST_PASS_PERCENT,
  POST_TEST_LESSON_ID as ACLS_POST_TEST_LESSON_ID,
  POST_TEST_PASS_PERCENT as ACLS_POST_TEST_PASS_PERCENT,
} from "@/lib/courses/assessment-ids";
import {
  POST_TEST_LESSON_ID as BLS_POST_TEST_LESSON_ID,
  POST_TEST_PASS_PERCENT as BLS_POST_TEST_PASS_PERCENT,
} from "@/lib/courses/bls/post-test";

interface LessonMeta {
  id: string;
  title: string;
  passingScore: number;
}

interface EntryMeta extends LessonMeta {
  kind?: "pretest" | "posttest" | null;
}

const cohortChipBase =
  "inline-flex items-center gap-1 rounded-full border border-border bg-muted px-2.5 py-1 text-[11px] font-semibold text-muted-foreground transition-colors hover:bg-muted/70";
const cohortChipActiveInfo = "border-sky-500/40 bg-sky-500/15 text-sky-700 dark:text-sky-300";
const cohortChipActiveWarning = "border-amber-500/40 bg-amber-500/15 text-amber-700 dark:text-amber-300";

export default function InstructorCohort({ course }: { course: CourseMode }) {
  const router = useRouter();
  const meta = getCourseMeta(course);
  const isAcls = course === "acls";

  // Stores are persisted in localStorage — gate behind `mounted` so the
  // first client render matches the server-rendered HTML.
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const preCourseLessons: LessonMeta[] = isAcls ? aclsPreCourseLessons : blsPreCourseLessons;
  const postTestLessonId = isAcls ? ACLS_POST_TEST_LESSON_ID : BLS_POST_TEST_LESSON_ID;
  const postTestPassPercent = isAcls ? ACLS_POST_TEST_PASS_PERCENT : BLS_POST_TEST_PASS_PERCENT;

  // Virtual "lessons" so CohortTable + the per-id selector keep working.
  // Pre-test is ACLS-only; Post-test exists in both modes (different content
  // per mode).
  const assessmentEntries = useMemo<EntryMeta[]>(() => {
    const list: EntryMeta[] = [];
    if (isAcls) {
      list.push({
        id: PRE_TEST_LESSON_ID,
        title: "Pre-test",
        passingScore: PRE_TEST_PASS_PERCENT,
        kind: "pretest",
      });
    }
    list.push({
      id: postTestLessonId,
      title: "Post-test",
      passingScore: postTestPassPercent,
      kind: "posttest",
    });
    return list;
  }, [isAcls, postTestLessonId, postTestPassPercent]);

  const allEntries = useMemo<EntryMeta[]>(
    () => [...preCourseLessons.map((l) => ({ ...l, kind: null })), ...assessmentEntries],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [assessmentEntries, course],
  );

  const [selectedId, setSelectedId] = useState<string>(
    preCourseLessons[0]?.id ?? assessmentEntries[0]?.id ?? "",
  );
  const [summary, setSummary] = useState<CohortSummaryRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [reloadKey, setReloadKey] = useState(0);
  const [source, setSource] = useState<"cloud" | "local">("local");
  const [pendingCount, setPendingCount] = useState(0);
  // Class setup happens right here on the instructor page — no need to hunt
  // for the tiny "create class" link buried in the student-facing gate modal.
  const [gateMode, setGateMode] = useState<null | "create" | "join">(null);
  const [copied, setCopied] = useState<null | "code" | "link" | "instructor">(null);
  const [showInstructorCode, setShowInstructorCode] = useState(false);
  // New-style class + no instructor code on this device (e.g. a student
  // opened this page, or the instructor is on a fresh browser).
  const [needInstructorCode, setNeedInstructorCode] = useState(false);

  const classCodeRaw = useClassStore((s) => s.classCode);
  const instructorCodeRaw = useClassStore((s) => s.instructorCode);
  const classNameRaw = useClassStore((s) => s.className);
  const syncDisabledRaw = useClassStore((s) => s.syncDisabled);

  const classCode = mounted ? classCodeRaw : null;
  const instructorCode = mounted ? instructorCodeRaw : null;
  const className = mounted ? classNameRaw : null;
  const syncDisabled = mounted ? syncDisabledRaw : false;

  // Students join by opening this link (course hub's ?join= deep link).
  const joinUrl =
    classCode && typeof window !== "undefined"
      ? `${window.location.origin}${meta.basePath}?join=${classCode}`
      : null;

  useEffect(() => {
    const ids = allEntries.map((l) => l.id);
    let cancelled = false;
    const load = async () => {
      setLoading(true);
      // Prefer cloud data when class is set + online; fall back to local IndexedDB.
      const online = typeof navigator === "undefined" || navigator.onLine !== false;
      if (classCode && !syncDisabled && online) {
        const { data, error } = await rpcGetCohortSummary(ids);
        if (!cancelled && data) {
          setSummary(data);
          setSource("cloud");
          setNeedInstructorCode(false);
          setLoading(false);
          return;
        }
        // New-style class: the student join code no longer unlocks the
        // summary — this device needs the instructor code.
        if (!cancelled && error && !instructorCode && (error.message || "").includes("invalid_code")) {
          setNeedInstructorCode(true);
        }
      }
      const local = await getLocalCohortSummary(ids);
      if (!cancelled) {
        setSummary(local);
        setSource("local");
        setLoading(false);
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
  }, [reloadKey, allEntries, classCode, instructorCode, syncDisabled]);

  const trackedView = useRef(false);
  useEffect(() => {
    if (trackedView.current) return;
    trackedView.current = true;
    track("instructor_cohort_viewed", { course, has_class: !!classCode });
  }, [classCode, course]);

  useEffect(() => {
    let cancelled = false;
    const refreshPending = () => {
      void getPendingCount().then((n) => {
        if (!cancelled) setPendingCount(n);
      });
    };
    refreshPending();
    const unsubscribe = subscribeToSync(refreshPending);
    return () => {
      cancelled = true;
      unsubscribe();
    };
  }, []);

  const refresh = () => setReloadKey((k) => k + 1);

  const handleSyncNow = () => {
    scheduleFlush();
    setTimeout(refresh, 800);
  };

  const copy = (what: "code" | "link" | "instructor", text: string | null) => {
    if (!text) return;
    navigator.clipboard?.writeText(text);
    setCopied(what);
    setTimeout(() => setCopied((c) => (c === what ? null : c)), 1500);
  };

  const selected = allEntries.find((l) => l.id === selectedId) ?? null;
  const isAssessmentView = assessmentEntries.some((e) => e.id === selectedId);

  const rows: CohortTableRow[] = summary.map(({ student, lessons }) => {
    const ls = lessons[selectedId];
    return {
      id: student.id,
      studentId: student.studentId,
      name: student.name,
      phone: student.phone,
      // "read" is meaningless for assessments — show as true.
      read: isAssessmentView ? true : !!ls?.read,
      attemptCount: ls?.attemptCount || 0,
      bestScore: ls?.bestScore ?? null,
      passed: ls?.passed ?? false,
      lastAttemptAt: ls?.lastAttemptAt ?? null,
    };
  });

  const overallRows: CohortOverallExportRow[] = summary.map(({ student, lessons }) => {
    const total = preCourseLessons.length;
    const passedCount = preCourseLessons.filter((l) => lessons[l.id]?.passed).length;
    const readCount = preCourseLessons.filter((l) => lessons[l.id]?.read).length;
    const preTest = lessons[PRE_TEST_LESSON_ID];
    const postTest = lessons[postTestLessonId];
    return {
      id: student.id,
      studentId: student.studentId,
      name: student.name,
      phone: student.phone,
      readCount,
      passedCount,
      total,
      preTestScore: preTest?.bestScore ?? null,
      preTestPassed: preTest?.passed ?? false,
      postTestScore: postTest?.bestScore ?? null,
      postTestPassed: postTest?.passed ?? false,
    };
  });

  const handleDelete = async (r: CohortTableRow) => {
    if (!confirm(`ลบนักเรียน ${r.name} (${r.studentId}) และผลทั้งหมด?`)) return;
    await deleteStudent(r.id);
    if (classCode && !syncDisabled) {
      await rpcDeleteCohortStudent(r.id);
    }
    refresh();
  };

  return (
    <div className="mx-auto max-w-4xl space-y-5 px-4 py-8 sm:px-6 lg:px-8">
      <button onClick={() => router.push(meta.basePath)} className={`${btnGhost} ${btnSm}`}>
        <ChevronLeft size={14} strokeWidth={2.2} /> กลับไป Pre-course
      </button>

      <div className="flex items-center gap-3">
        <div className="inline-flex h-11 w-11 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
          <Users size={22} strokeWidth={2.2} />
        </div>
        <div className="flex-1">
          <h1 className="text-xl font-bold text-foreground">หน้าอาจารย์ — รวมผล Pre-course</h1>
          <p className="text-xs text-muted-foreground">
            {source === "cloud"
              ? `คลาส: ${className || "—"} (${classCode}) · ${summary.length} นักเรียน`
              : `จากเครื่องนี้ · ${summary.length} นักเรียน`}
          </p>
        </div>
        <div className="flex shrink-0 flex-col gap-1">
          <a
            href="/instructor-cohort-guide.pdf"
            target="_blank"
            rel="noopener noreferrer"
            download
            className={`${btnGhost} ${btnSm}`}
          >
            <FileText size={14} strokeWidth={2.2} /> คู่มืออาจารย์ (PDF)
          </a>
          {isAcls && (
            <a
              href="/student-precourse-guide.pdf"
              target="_blank"
              rel="noopener noreferrer"
              download
              className={`${btnGhost} ${btnSm}`}
            >
              <FileText size={14} strokeWidth={2.2} /> คู่มือนักเรียน (PDF)
            </a>
          )}
        </div>
      </div>

      {/* Class card — create / join / share the class code without leaving
          this page. */}
      {classCode ? (
        <div className={`${dashCard} space-y-3`}>
          <div className="flex items-center gap-3">
            <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-sky-500/12 text-sky-600 dark:text-sky-400">
              <Cloud size={18} strokeWidth={2.2} />
            </div>
            <div className="min-w-0 flex-1">
              <div className="truncate text-sm font-semibold text-foreground">คลาส: {className || "—"}</div>
              <div className="text-[11px] text-muted-foreground">นักเรียนเข้าคลาสได้ด้วยรหัสเข้าคลาส</div>
            </div>
          </div>

          <div className="flex items-center gap-3 rounded-lg bg-muted p-3">
            <div className="min-w-0 flex-1">
              <div className="text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
                รหัสเข้าคลาส (แจกนักเรียน)
              </div>
              <div className="font-mono text-2xl font-bold tracking-[0.25em] text-foreground">{classCode}</div>
              <div className="mt-1.5 flex flex-wrap gap-1.5">
                <button onClick={() => copy("code", classCode)} className={`${btnGhost} ${btnSm}`}>
                  {copied === "code" ? (
                    <>
                      <Check size={13} strokeWidth={2.4} /> คัดลอกแล้ว
                    </>
                  ) : (
                    <>
                      <Copy size={13} strokeWidth={2.2} /> รหัส
                    </>
                  )}
                </button>
                <button onClick={() => copy("link", joinUrl)} className={`${btnGhost} ${btnSm}`}>
                  {copied === "link" ? (
                    <>
                      <Check size={13} strokeWidth={2.4} /> คัดลอกแล้ว
                    </>
                  ) : (
                    <>
                      <LinkIcon size={13} strokeWidth={2.2} /> ลิงก์เข้าคลาส
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>

          {instructorCode && (
            <div className="flex items-center justify-between gap-3 rounded-lg border border-amber-500/25 bg-amber-500/8 p-3">
              <div className="min-w-0">
                <div className="inline-flex items-center gap-1 text-[11px] font-semibold uppercase tracking-wider text-amber-600 dark:text-amber-400">
                  <ShieldCheck size={12} strokeWidth={2.4} /> รหัสอาจารย์ (เก็บเป็นความลับ)
                </div>
                <div className="font-mono text-lg font-bold tracking-[0.25em] text-foreground">
                  {showInstructorCode ? instructorCode : "••••••"}
                </div>
              </div>
              <div className="flex shrink-0 gap-1">
                <button
                  onClick={() => setShowInstructorCode((s) => !s)}
                  className={`${btnGhost} ${btnSm}`}
                  aria-label="แสดง/ซ่อนรหัสอาจารย์"
                >
                  {showInstructorCode ? (
                    <EyeOff size={13} strokeWidth={2.2} />
                  ) : (
                    <Eye size={13} strokeWidth={2.2} />
                  )}
                </button>
                <button onClick={() => copy("instructor", instructorCode)} className={`${btnGhost} ${btnSm}`}>
                  {copied === "instructor" ? (
                    <Check size={13} strokeWidth={2.4} />
                  ) : (
                    <Copy size={13} strokeWidth={2.2} />
                  )}
                </button>
              </div>
            </div>
          )}

          {needInstructorCode && (
            <div className="space-y-2 rounded-lg border border-amber-500/30 bg-amber-500/8 p-3">
              <div className="text-xs text-foreground/80">
                คลาสนี้ต้องยืนยันด้วย <b>รหัสอาจารย์</b> จึงจะดูผลรวมจาก cloud ได้
                (รหัสเข้าคลาสของนักเรียนใช้ดูไม่ได้)
              </div>
              <button onClick={() => setGateMode("join")} className={`${btnPrimary} ${btnSm} ${btnBlock}`}>
                <KeyRound size={13} strokeWidth={2.2} /> ใส่รหัสอาจารย์
              </button>
            </div>
          )}

          <div className="grid grid-cols-2 gap-2">
            <button onClick={() => setGateMode("create")} className={`${btnGhost} ${btnSm}`}>
              <Plus size={13} strokeWidth={2.4} /> สร้างคลาสใหม่
            </button>
            <button onClick={() => setGateMode("join")} className={`${btnGhost} ${btnSm}`}>
              <KeyRound size={13} strokeWidth={2.2} /> เชื่อมต่อคลาสอื่น
            </button>
          </div>
          <p className="text-center text-[11px] text-muted-foreground">
            สลับคลาสได้โดยข้อมูลคลาสเดิมไม่หาย — กลับมาเชื่อมต่อด้วยรหัสเดิมได้ตลอด
          </p>
        </div>
      ) : (
        <div className={`${dashCard} space-y-3`}>
          <div className="flex items-center gap-3">
            <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-amber-500/12 text-amber-600 dark:text-amber-400">
              <CloudOff size={18} strokeWidth={2.2} />
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-sm font-semibold text-foreground">ยังไม่ได้เชื่อมต่อคลาส</div>
              <div className="text-[11px] text-muted-foreground">
                สร้างคลาสก่อน ผลของนักเรียนถึงจะรวมมาแสดงหน้านี้
              </div>
            </div>
          </div>
          <ol className="list-none space-y-1 text-xs text-foreground/80">
            {[
              "สร้างคลาส → ได้รหัสเข้าคลาส (แจกนักเรียน) + รหัสอาจารย์ (เก็บส่วนตัว)",
              "แจกรหัสให้นักเรียนใช้ \"เข้าคลาส\" บนเครื่องของตัวเอง",
              "ผลเรียน/คะแนนสอบของทุกคนจะขึ้นหน้านี้อัตโนมัติ",
            ].map((step, i) => (
              <li key={i} className="flex items-start gap-2">
                <span className="mt-px inline-flex h-[18px] w-[18px] shrink-0 items-center justify-center rounded-full bg-sky-600 text-[11px] font-extrabold text-white">
                  {i + 1}
                </span>
                {step}
              </li>
            ))}
          </ol>
          <button onClick={() => setGateMode("create")} className={`${btnPrimary} ${btnBlock} font-bold`}>
            <Plus size={16} strokeWidth={2.4} /> สร้างคลาสใหม่ (สำหรับอาจารย์)
          </button>
          <button
            onClick={() => setGateMode("join")}
            className="inline-flex w-full items-center justify-center gap-1.5 rounded-lg border border-border bg-muted px-3 py-2.5 text-xs font-bold text-foreground/80 hover:bg-muted/70"
          >
            <KeyRound size={14} strokeWidth={2.4} /> มีรหัสอาจารย์อยู่แล้ว? เชื่อมต่อด้วยรหัส
          </button>
        </div>
      )}

      {/* Sync status bar */}
      <div className={`${dashCard} !py-2 flex items-center gap-3`}>
        {source === "cloud" ? (
          <div className="inline-flex items-center gap-1.5 text-xs text-sky-600 dark:text-sky-400">
            <Cloud size={14} strokeWidth={2.2} /> ข้อมูลจาก cloud
          </div>
        ) : (
          <div className="inline-flex items-center gap-1.5 text-xs text-muted-foreground">
            <CloudOff size={14} strokeWidth={2.2} />
            {classCode ? "แสดงข้อมูล cached (offline)" : "โหมด offline เท่านั้น"}
          </div>
        )}
        {pendingCount > 0 && (
          <div className="text-xs text-amber-600 dark:text-amber-400">· ยังไม่ sync {pendingCount} รายการ</div>
        )}
        <div className="flex-1" />
        {classCode && !syncDisabled && (
          <button onClick={handleSyncNow} className={`${btnGhost} ${btnSm}`}>
            <RefreshCw size={13} strokeWidth={2.2} /> Sync ตอนนี้
          </button>
        )}
      </div>

      {/* Overall summary */}
      <div className="overflow-x-auto rounded-xl border border-border bg-card shadow-sm">
        <table className="w-full text-xs">
          <thead className="bg-muted text-foreground/80">
            <tr>
              <th className="px-3 py-2 text-left">รหัส</th>
              <th className="px-3 py-2 text-left">ชื่อ</th>
              <th className="px-3 py-2 text-left">เบอร์โทร</th>
              <th className="px-3 py-2 text-center">บทเรียน อ่าน</th>
              <th className="px-3 py-2 text-center">บทเรียน ผ่าน</th>
              {isAcls && <th className="px-3 py-2 text-center">Pre-test</th>}
              <th className="px-3 py-2 text-center">Post-test</th>
            </tr>
          </thead>
          <tbody>
            {overallRows.length === 0 ? (
              <tr>
                <td colSpan={isAcls ? 7 : 6} className="px-3 py-6 text-center text-muted-foreground">
                  ยังไม่มีนักเรียน
                </td>
              </tr>
            ) : (
              overallRows.map((r) => (
                <tr key={r.id} className="border-t border-border">
                  <td className="px-3 py-2 font-mono text-foreground/80">{r.studentId}</td>
                  <td className="px-3 py-2 text-foreground">{r.name}</td>
                  <td className="px-3 py-2 font-mono text-foreground/80">{r.phone || "-"}</td>
                  <td className="px-3 py-2 text-center text-foreground/80">
                    {r.readCount}/{r.total}
                  </td>
                  <td
                    className={`px-3 py-2 text-center font-bold ${
                      r.passedCount === r.total
                        ? "text-emerald-600 dark:text-emerald-400"
                        : "text-amber-600 dark:text-amber-400"
                    }`}
                  >
                    {r.passedCount}/{r.total}
                  </td>
                  {isAcls && (
                    <td
                      className={`px-3 py-2 text-center font-bold ${
                        r.preTestScore == null
                          ? "text-muted-foreground"
                          : r.preTestPassed
                            ? "text-emerald-600 dark:text-emerald-400"
                            : "text-amber-600 dark:text-amber-400"
                      }`}
                    >
                      {r.preTestScore != null ? `${r.preTestScore}%` : "-"}
                    </td>
                  )}
                  <td
                    className={`px-3 py-2 text-center font-bold ${
                      r.postTestScore == null
                        ? "text-muted-foreground"
                        : r.postTestPassed
                          ? "text-emerald-600 dark:text-emerald-400"
                          : "text-amber-600 dark:text-amber-400"
                    }`}
                  >
                    {r.postTestScore != null ? `${r.postTestScore}%` : "-"}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Overall summary export — the one-file report an instructor submits to a committee */}
      {overallRows.length > 0 && (
        <div className="space-y-1.5">
          <div className="px-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
            ดาวน์โหลดสรุปผลรวม (สำหรับส่งคณะกรรมการ)
          </div>
          <div className="grid grid-cols-2 gap-2">
            <button
              onClick={() => exportCohortSummaryCSV({ rows: overallRows, course, isAcls })}
              className={`${btnGhost} ${btnBlock}`}
            >
              <FileText size={14} strokeWidth={2.2} /> สรุปรวม CSV
            </button>
            <button
              onClick={() => exportCohortSummaryPDF({ rows: overallRows, className, classCode, course, isAcls })}
              className={`${btnPrimary} ${btnBlock}`}
            >
              <Download size={14} strokeWidth={2.2} /> สรุปรวม PDF
            </button>
          </div>
        </div>
      )}

      {/* Per-entry selector */}
      <div className="space-y-2">
        <div className="px-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
          ดูตามรายการ
        </div>
        <div className="flex flex-wrap gap-1.5">
          {allEntries.map((l) => {
            const isAssessment = assessmentEntries.some((e) => e.id === l.id);
            const Icon = l.kind === "pretest" ? Sparkles : l.kind === "posttest" ? Award : null;
            const active = selectedId === l.id;
            return (
              <button
                key={l.id}
                onClick={() => setSelectedId(l.id)}
                className={`${cohortChipBase} ${
                  active ? (isAssessment ? cohortChipActiveWarning : cohortChipActiveInfo) : ""
                }`}
              >
                {Icon && <Icon size={11} strokeWidth={2.4} />}
                {l.title}
              </button>
            );
          })}
        </div>
      </div>

      {loading ? (
        <div className="py-6 text-center text-xs text-muted-foreground">กำลังโหลด…</div>
      ) : (
        <CohortTable rows={rows} lesson={selected} onDeleteStudent={handleDelete} />
      )}

      <div className="space-y-1.5">
        <div className="px-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
          ดาวน์โหลดเฉพาะรายการที่เลือก ({selected?.title || "—"})
        </div>
        <div className="grid grid-cols-2 gap-2">
          <button
            onClick={() => exportCohortCSV({ rows, lesson: selected, course })}
            disabled={!rows.length}
            className={`${btnGhost} ${btnBlock} disabled:opacity-40`}
          >
            <FileText size={14} strokeWidth={2.2} /> รายการนี้ CSV
          </button>
          <button
            onClick={() => exportCohortPDF({ rows, lesson: selected, course })}
            disabled={!rows.length}
            className={`${btnPrimary} ${btnBlock} disabled:opacity-40`}
          >
            <Download size={14} strokeWidth={2.2} /> รายการนี้ PDF
          </button>
        </div>
      </div>

      {summary.length > 0 && (
        <button
          onClick={async () => {
            if (!confirm("ลบนักเรียนและผล Pre-course ทั้งหมดในเครื่องนี้?")) return;
            for (const { student } of summary) {
              await deleteStudent(student.id);
              if (classCode && !syncDisabled) {
                await rpcDeleteCohortStudent(student.id);
              }
            }
            refresh();
          }}
          className={`${btnGhost} ${btnSm} ${btnBlock} text-red-600 dark:text-red-400`}
        >
          <Trash size={13} strokeWidth={2.2} /> ล้างข้อมูลทั้งหมด
        </button>
      )}

      <ClassGateModal
        open={gateMode !== null}
        course={course}
        initialMode={gateMode || "home"}
        instructor
        onClose={() => setGateMode(null)}
      />
    </div>
  );
}
