"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import {
  Trophy,
  BookOpen,
  Sparkles,
  Activity,
  Check,
  Circle,
  ClipboardCheck,
  Download,
  MapPin,
  ChevronRight,
  MessageCircle,
  AlertCircle,
  Video,
} from "lucide-react";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import {
  getLessonProgress,
  getAttemptsForStudent,
  getStudentById,
  upsertStudent,
} from "@/lib/courses/offline/db";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";
import { preCourseLessons } from "@/lib/acls-reader/precourse";
import { getVideoLessons, type VideoLesson } from "@/lib/courses/video-lessons";
import { computeVideoCompletion } from "@/lib/courses/video-progress";
import {
  PRE_TEST_LESSON_ID,
  PRE_TEST_PASS_PERCENT,
  POST_TEST_LESSON_ID,
  POST_TEST_PASS_PERCENT,
} from "@/lib/courses/assessment-ids";
import { EKG_TEST_PASS_PERCENT, EKG_TEST_PASSED_KEY } from "@/lib/acls-reader/ekg-quiz";
import { getCertConfig } from "@/lib/courses/cert/config";
import { getCourseMeta } from "@/lib/courses/config";
import { track } from "@/lib/analytics";
import {
  dashCard,
  btnPrimary,
  btnBlock,
  btnMd,
  btnLg,
  inputBase,
  errorBox,
  COURSE_LINE_URL,
} from "@/components/courses/course-ui";
import { cn } from "@/lib/utils";

const certConfig = getCertConfig("acls");
const courseMeta = getCourseMeta("acls");
const CERT_KEY = `${courseMeta.id}_certification`;

interface CertData {
  studentName?: string;
  studentPhone?: string;
  studentEmail?: string;
  completedAt?: string;
  preTestScore?: number | null;
  postTestScore?: number | null;
  ekgPassed?: boolean | null;
  certId?: string;
  lineFollowed?: boolean;
}

function getCertData(): CertData {
  try {
    return JSON.parse(localStorage.getItem(CERT_KEY) || "{}");
  } catch {
    return {};
  }
}

function saveCertData(data: CertData) {
  localStorage.setItem(CERT_KEY, JSON.stringify(data));
}

interface AttemptLike {
  lessonId: string;
  score: number;
  passed: boolean;
}

export default function CertificationPage() {
  const activeStudent = usePreCourseStore((s) => s.activeStudent);
  const setActiveStudent = usePreCourseStore((s) => s.setActiveStudent);

  const [certData, setCertData] = useState<CertData>({});
  const [studentName, setStudentName] = useState("");
  const [studentPhone, setStudentPhone] = useState("");
  const [studentEmail, setStudentEmail] = useState("");
  const [formError, setFormError] = useState("");
  const [lineUnlocked, setLineUnlocked] = useState(false);
  const [ekgTestDone, setEkgTestDone] = useState(false);
  const [loading, setLoading] = useState(true);
  const [progress, setProgress] = useState<{ lessonId: string; readAt: string }[]>([]);
  const [attempts, setAttempts] = useState<AttemptLike[]>([]);
  const [videoLessons, setVideoLessons] = useState<VideoLesson[]>([]);

  // Hydrate everything that only exists in the browser after mount, to
  // avoid SSR/CSR mismatch (this page has no server data of its own).
  useEffect(() => {
    const data = getCertData();
    setCertData(data);
    setStudentName(data.studentName || activeStudent?.name || "");
    setStudentPhone(data.studentPhone || activeStudent?.phone || "");
    setStudentEmail(data.studentEmail || "");
    setLineUnlocked(!!data.lineFollowed);
    try {
      setEkgTestDone(localStorage.getItem(EKG_TEST_PASSED_KEY) === "true");
    } catch {
      /* ignore */
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      if (!activeStudent) {
        setProgress([]);
        setAttempts([]);
        setLoading(false);
        return;
      }
      setLoading(true);
      const [p, a] = await Promise.all([
        getLessonProgress(activeStudent.id),
        getAttemptsForStudent(activeStudent.id),
      ]);
      if (cancelled) return;
      setProgress(p);
      setAttempts(a as AttemptLike[]);
      setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [activeStudent?.id]);

  // Video-lesson catalog doesn't depend on the active student — fetch once.
  useEffect(() => {
    let cancelled = false;
    getVideoLessons().then((lessons) => {
      if (!cancelled) setVideoLessons(lessons);
    });
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    if (certData.certId && !lineUnlocked) {
      track("cert_line_gate_view", { source: "cert_gate", course: "acls" });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [certData.certId, lineUnlocked]);

  const preCourseStatus = preCourseLessons.map((l: { id: string; title: string }) => {
    const read = progress.some((p) => p.lessonId === l.id);
    const lessonAttempts = attempts.filter((a) => a.lessonId === l.id);
    const best = lessonAttempts.reduce<AttemptLike | null>(
      (b, a) => (a.score > (b?.score ?? -1) ? a : b),
      null,
    );
    return { lesson: l, read, bestScore: best?.score ?? null, passed: best?.passed ?? false };
  });
  const preCourseDone =
    !!activeStudent && preCourseStatus.length > 0 && preCourseStatus.every((s) => s.passed);

  const postTestAttempts = attempts.filter((a) => a.lessonId === POST_TEST_LESSON_ID);
  const postTestBest = postTestAttempts.reduce<AttemptLike | null>(
    (b, a) => (a.score > (b?.score ?? -1) ? a : b),
    null,
  );
  const postTestDone = !!postTestBest?.passed;

  const preTestAttempts = attempts.filter((a) => a.lessonId === PRE_TEST_LESSON_ID);
  const preTestBest = preTestAttempts.reduce<AttemptLike | null>(
    (b, a) => (a.score > (b?.score ?? -1) ? a : b),
    null,
  );
  const preTestDone = !!preTestBest?.passed;

  const videoComp = computeVideoCompletion(videoLessons, progress, attempts);

  // Online theory certification — knowledge gates (pre-test, pre-course,
  // post-test, EKG test, video lessons). Hands-on skills are completed
  // separately at a training center. The video-lesson gate only activates
  // once at least one required video lesson is configured, so it never
  // blocks certs issued before video lessons existed.
  const requirements = [
    {
      label: `ผ่าน Pre-test ≥ ${PRE_TEST_PASS_PERCENT}%`,
      done: preTestDone,
      Icon: Sparkles,
      to: "/acls/test",
    },
    {
      label: "ผ่าน Pre-course (อ่าน + ทำแบบทดสอบผ่านทุกบท)",
      done: preCourseDone,
      Icon: BookOpen,
      to: "/acls/learn",
    },
    {
      label: `ผ่าน Post-test exam ≥ ${POST_TEST_PASS_PERCENT}%`,
      done: postTestDone,
      Icon: ClipboardCheck,
      to: "/acls/test",
    },
    {
      label: `ผ่าน EKG test ≥ ${EKG_TEST_PASS_PERCENT}%`,
      done: ekgTestDone,
      Icon: Activity,
      to: "/acls/ekg",
    },
    ...(videoComp.total > 0
      ? [
          {
            label: `ผ่านบทเรียนวิดีโอ (${videoComp.done}/${videoComp.total})`,
            done: videoComp.allDone,
            Icon: Video,
            to: "/acls/video-lessons",
          },
        ]
      : []),
  ];

  const requirementsLoading = loading;
  const allDone = !requirementsLoading && requirements.every((r) => r.done);
  const progressPct = Math.round(
    (requirements.filter((r) => r.done).length / requirements.length) * 100,
  );

  const generateCertificate = async () => {
    const name = studentName.trim();
    const tel = studentPhone.trim();
    const mail = studentEmail.trim().toLowerCase();
    if (!name) {
      setFormError("กรุณากรอกชื่อ");
      return;
    }
    if (tel.replace(/\D/g, "").length < 9) {
      setFormError("เบอร์โทรไม่ถูกต้อง");
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(mail)) {
      setFormError("อีเมลไม่ถูกต้อง");
      return;
    }
    setFormError("");

    if (activeStudent) {
      try {
        const existing = await getStudentById(activeStudent.id);
        const updated = {
          ...(existing ?? {
            id: activeStudent.id,
            studentId: activeStudent.studentId,
            createdAt: new Date().toISOString(),
          }),
          name,
          phone: tel,
          syncedAt: null,
        };
        await upsertStudent(updated);
        setActiveStudent(updated);
        scheduleFlush();
      } catch {
        /* non-blocking — cert must still issue */
      }
    }

    const data: CertData = {
      studentName: name,
      studentPhone: tel,
      studentEmail: mail,
      completedAt: new Date().toISOString(),
      preTestScore: preTestBest?.score ?? null,
      postTestScore: postTestBest?.score ?? null,
      ekgPassed: ekgTestDone,
      certId: `${certConfig.certIdPrefix}-${Date.now().toString(36).toUpperCase()}`,
    };
    const merged = { ...certData, ...data };
    saveCertData(merged);
    setCertData(merged);

    // Best-effort admin LINE alert + certificates-table record.
    fetch("/api/acls/cert-notify", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        studentName: name,
        studentPhone: tel,
        studentEmail: mail,
        course: "acls",
        courseTitle: certConfig.title,
        certId: data.certId,
        completedAt: data.completedAt,
        preTestScore: data.preTestScore,
        postTestScore: data.postTestScore,
        ekgPassed: data.ekgPassed,
      }),
    }).catch(() => {});
  };

  const unlockDownload = (via: "line" | "skip") => {
    const next = { ...certData, lineFollowed: true };
    saveCertData(next);
    setCertData(next);
    setLineUnlocked(true);
    if (via === "skip") {
      track("cert_line_skip", { source: "cert_gate", course: "acls" });
    }
  };

  const handleAddLine = () => {
    track("cert_line_add", { channel: "line", source: "cert_gate", course: "acls" });
    unlockDownload("line");
  };

  const downloadPDF = async () => {
    track("cert_download", { source: "cert_card", course: "acls" });
    const { exportCertificatePDF } = await import("@/lib/courses/cert/export-certificate");
    await exportCertificatePDF({ cert: certData as never, certConfig });
  };

  const issuedDate = certData.completedAt ? new Date(certData.completedAt) : null;
  const expiresDate = issuedDate ? new Date(issuedDate) : null;
  if (expiresDate) expiresDate.setMonth(expiresDate.getMonth() + (certConfig.validityMonths || 24));
  const fmtDate = (d: Date) =>
    d.toLocaleDateString("en-GB", { year: "numeric", month: "short", day: "2-digit" });

  return (
    <div className="mx-auto max-w-2xl space-y-5 px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex items-center gap-3">
        <div className="inline-flex h-11 w-11 items-center justify-center rounded-lg bg-amber-500/15 text-amber-600 dark:text-amber-400">
          <Trophy size={22} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-2xl font-bold">{certConfig.title}</h1>
          <p className="text-sm text-muted-foreground">
            Track your {courseMeta.shortName} training progress
          </p>
        </div>
      </div>

      {!activeStudent && (
        <div className={cn(dashCard, "text-center text-sm text-muted-foreground")}>
          ระบุตัวผู้เรียนที่หน้าบทเรียนก่อน เพื่อบันทึกความคืบหน้า
        </div>
      )}

      {requirementsLoading ? (
        <div className={cn(dashCard, "text-center text-sm text-muted-foreground")}>
          กำลังตรวจสอบความคืบหน้า...
        </div>
      ) : (
        <>
          {/* Progress */}
          <div className={cn(dashCard, "text-center")}>
            <div
              className={cn(
                "text-5xl font-bold",
                allDone ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400",
              )}
            >
              {progressPct}%
            </div>
            <div className="mt-1 text-sm text-muted-foreground">
              {allDone ? "ครบทุกเงื่อนไขแล้ว!" : "ทำตามเงื่อนไขให้ครบเพื่อรับใบประกาศนียบัตร"}
            </div>
            <div className="mt-3 h-2 overflow-hidden rounded-full bg-muted">
              <div
                className={cn(
                  "h-full rounded-full transition-all",
                  allDone ? "bg-emerald-500" : "bg-blue-500",
                )}
                style={{ width: `${progressPct}%` }}
              />
            </div>
          </div>

          {/* Requirements */}
          <div className="space-y-3">
            {requirements.map((r) => {
              const RIcon = r.Icon;
              return (
                <Link
                  key={r.label}
                  href={r.to}
                  className={cn(
                    dashCard,
                    "!p-3 flex items-center gap-3 transition-colors hover:border-blue-400/40",
                    r.done && "border-emerald-500/40",
                  )}
                >
                  <div
                    className={cn(
                      "inline-flex h-9 w-9 shrink-0 items-center justify-center rounded-lg",
                      r.done
                        ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                        : "bg-muted text-muted-foreground",
                    )}
                  >
                    <RIcon size={16} strokeWidth={2.2} />
                  </div>
                  <span className="flex-1 text-sm font-semibold">{r.label}</span>
                  {r.done ? (
                    <Check size={18} strokeWidth={2.4} className="text-emerald-600 dark:text-emerald-400" />
                  ) : (
                    <Circle size={16} strokeWidth={2} className="text-muted-foreground" />
                  )}
                  <ChevronRight size={16} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
                </Link>
              );
            })}
          </div>
        </>
      )}

      {/* Pre-course breakdown */}
      {activeStudent && !requirementsLoading && (
        <div className={cn(dashCard, "!p-3 space-y-2")}>
          <div className="flex items-center justify-between">
            <div className="text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
              Pre-course — {activeStudent.name}
            </div>
            <span className="font-mono text-[11px] text-muted-foreground">
              {activeStudent.studentId || activeStudent.phone}
            </span>
          </div>
          {preCourseStatus.map(({ lesson, read, bestScore, passed }) => (
            <Link
              key={lesson.id}
              href={`/acls/learn/${lesson.id}`}
              className="-mx-1 flex items-center gap-2 rounded-md px-1 py-0.5 text-sm transition-colors hover:bg-muted"
            >
              <span
                className={cn(
                  "inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-sm",
                  passed
                    ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                    : "bg-muted text-muted-foreground",
                )}
              >
                {passed ? <Check size={12} strokeWidth={2.6} /> : <Circle size={10} strokeWidth={2} />}
              </span>
              <span className="flex-1 truncate text-muted-foreground">{lesson.title}</span>
              <span
                className={cn(
                  "text-[11px] font-bold",
                  passed
                    ? "text-emerald-600 dark:text-emerald-400"
                    : bestScore != null
                      ? "text-amber-600 dark:text-amber-400"
                      : "text-muted-foreground",
                )}
              >
                {bestScore != null ? `${bestScore}%` : read ? "อ่านแล้ว" : "ยังไม่อ่าน"}
              </span>
              <ChevronRight size={14} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
            </Link>
          ))}
        </div>
      )}

      {/* Stats */}
      {!requirementsLoading && (
        <div className="grid grid-cols-3 gap-2">
          <div className={cn(dashCard, "!p-3 text-center")}>
            <div
              className={cn(
                "text-lg font-bold",
                preTestDone ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400",
              )}
            >
              {preTestBest ? `${preTestBest.score}%` : "—"}
            </div>
            <div className="text-[11px] text-muted-foreground">Pre-test</div>
          </div>
          <div className={cn(dashCard, "!p-3 text-center")}>
            <div
              className={cn(
                "text-lg font-bold",
                postTestDone ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400",
              )}
            >
              {postTestBest ? `${postTestBest.score}%` : "—"}
            </div>
            <div className="text-[11px] text-muted-foreground">Post-test</div>
          </div>
          <div className={cn(dashCard, "!p-3 text-center")}>
            <div
              className={cn(
                "text-lg font-bold",
                ekgTestDone ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400",
              )}
            >
              {ekgTestDone ? "ผ่าน" : "—"}
            </div>
            <div className="text-[11px] text-muted-foreground">EKG test</div>
          </div>
        </div>
      )}

      {/* Contact form + generate */}
      {allDone && !certData.certId && (
        <div className={cn(dashCard, "space-y-3")}>
          <div className="flex w-full items-center justify-center gap-2 text-center text-base font-bold text-emerald-600 dark:text-emerald-400">
            <Trophy size={18} strokeWidth={2.4} /> ยินดีด้วย! กรอกข้อมูลเพื่อรับใบประกาศ
          </div>
          <p className="-mt-1 text-center text-[11px] text-muted-foreground">
            ใช้ชื่อบนใบประกาศ และไว้ส่งใบประกาศ/แจ้งเตือนก่อนหมดอายุ
          </p>
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">ชื่อ–นามสกุล (บนใบประกาศ)</span>
            <input
              type="text"
              value={studentName}
              onChange={(e) => setStudentName(e.target.value)}
              placeholder="เช่น อนันต์ ใจดี"
              className={cn(inputBase, "mt-1 text-sm")}
            />
          </label>
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">เบอร์โทร</span>
            <input
              type="tel"
              inputMode="tel"
              autoComplete="tel"
              value={studentPhone}
              onChange={(e) => setStudentPhone(e.target.value)}
              placeholder="เช่น 081-234-5678"
              className={cn(inputBase, "mt-1 text-sm tabular-nums")}
            />
          </label>
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">อีเมล</span>
            <input
              type="email"
              inputMode="email"
              autoComplete="email"
              value={studentEmail}
              onChange={(e) => setStudentEmail(e.target.value)}
              placeholder="เช่น name@email.com"
              className={cn(inputBase, "mt-1 text-sm")}
            />
          </label>
          {formError && (
            <div className={errorBox}>
              <AlertCircle size={14} strokeWidth={2.2} /> {formError}
            </div>
          )}
          <button
            onClick={generateCertificate}
            disabled={!studentName.trim() || !studentPhone.trim() || !studentEmail.trim()}
            className={cn(btnPrimary, btnLg, btnBlock)}
          >
            <Trophy size={16} strokeWidth={2.4} /> ออกใบประกาศนียบัตร
          </button>
        </div>
      )}

      {/* Issued certificate */}
      {certData.certId && (
        <div className={cn(dashCard, "space-y-3 border-2 border-emerald-500/40 !p-6 text-center")}>
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-amber-400 to-amber-600 shadow-lg">
            <Trophy size={28} strokeWidth={2.4} className="text-white" />
          </div>
          <div>
            <div className="text-lg font-bold">{certConfig.title}</div>
            <div className="mt-1 text-sm text-muted-foreground">{certConfig.subtitle}</div>
            <div className="mt-2 text-base font-bold">{certData.studentName}</div>
          </div>
          {certConfig.theoryOnly && certConfig.theoryStatement && (
            <div className="text-sm font-semibold text-emerald-600 dark:text-emerald-400">
              {certConfig.theoryStatement}
            </div>
          )}
          <div className="text-sm text-muted-foreground">
            Pre-test: {certData.preTestScore != null ? `${certData.preTestScore}%` : "—"}
            {" · "}
            Post-test: {certData.postTestScore != null ? `${certData.postTestScore}%` : "—"}
            {" · "}
            EKG: {certData.ekgPassed ? "ผ่าน" : "—"}
          </div>
          <div className="text-sm text-muted-foreground">
            Issued: {issuedDate ? fmtDate(issuedDate) : "—"}
            {expiresDate && ` · Valid through: ${fmtDate(expiresDate)}`}
          </div>
          <div className="font-mono text-[11px] text-blue-600 dark:text-blue-400">
            ID: {certData.certId}
          </div>
          <div className="text-[11px] text-muted-foreground">
            {certConfig.centerName} · {certConfig.centerUrl}
          </div>
          {certConfig.theoryOnly && certConfig.practicalRecommendation && (
            <div className="flex items-start gap-2 rounded-lg border border-blue-500/30 bg-blue-500/10 p-3 text-left text-sm text-blue-700 dark:text-blue-300">
              <MapPin size={15} strokeWidth={2.4} className="mt-0.5 shrink-0" />
              <span>{certConfig.practicalRecommendation}</span>
            </div>
          )}
          {lineUnlocked ? (
            <button onClick={downloadPDF} className={cn(btnPrimary, btnMd, btnBlock, "mt-3")}>
              <Download size={16} strokeWidth={2.4} /> Download PDF Certificate
            </button>
          ) : (
            <div className="mt-3 space-y-3 rounded-lg border border-emerald-500/30 bg-emerald-500/5 p-4 text-left">
              <div className="flex items-start gap-2">
                <MessageCircle size={18} strokeWidth={2.4} className="mt-0.5 shrink-0 text-[#06C755]" />
                <div className="text-sm text-muted-foreground">
                  <span className="font-bold text-foreground">เพิ่มเพื่อน LINE OA เพื่อรับใบประกาศนียบัตร</span>
                  <div className="mt-0.5">
                    รับสิทธิพิเศษส่วนลดคอร์สภาคปฏิบัติ + แจ้งเตือนก่อนใบประกาศนียบัตรหมดอายุ
                  </div>
                </div>
              </div>
              <a
                href={COURSE_LINE_URL}
                target="_blank"
                rel="noopener noreferrer"
                onClick={handleAddLine}
                className={cn(btnBlock, "inline-flex items-center justify-center gap-1.5 rounded-lg px-4 py-2.5 text-sm font-semibold text-white no-underline")}
                style={{ background: "#06C755" }}
              >
                <MessageCircle size={16} strokeWidth={2.4} /> เพิ่มเพื่อน LINE แล้วรับใบประกาศนียบัตร
              </a>
              <button
                onClick={() => unlockDownload("skip")}
                className="block w-full bg-transparent text-center text-sm text-muted-foreground underline"
              >
                ข้ามไปก่อน — ดาวน์โหลดเลย
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
