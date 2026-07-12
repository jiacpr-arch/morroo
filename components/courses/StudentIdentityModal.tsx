"use client";

import { useState } from "react";
import { v4 as uuidv4 } from "uuid";
import {
  upsertStudent,
  findStudentByStudentId,
  hydrateStudentProgress,
  type LocalStudent,
} from "@/lib/courses/offline/db";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import { useClassStore } from "@/lib/courses/stores/class-store";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";
import { rpcGetStudentProgress } from "@/lib/courses/cohort";
import { track } from "@/lib/analytics";
import { User, X, Check, AlertCircle } from "lucide-react";
import {
  modalOverlay,
  modalPanel,
  textHeadline,
  text2xs,
  btnPrimary,
  btnLg,
  btnBlock,
  inputBase,
  errorBox,
} from "./course-ui";

interface StudentIdentityModalProps {
  open: boolean;
  onClose?: () => void;
  onConfirm?: (student: LocalStudent) => void;
}

export default function StudentIdentityModal({
  open,
  onClose,
  onConfirm,
}: StudentIdentityModalProps) {
  const setActiveStudent = usePreCourseStore((s) => s.setActiveStudent);
  // In a class the server roster keys on student id, so it stays required.
  // Standalone (offline) use never syncs, so the id is optional there.
  const classCode = useClassStore((s) => s.classCode);
  const requireStudentId = !!classCode;
  const [name, setName] = useState("");
  const [studentId, setStudentId] = useState("");
  const [phone, setPhone] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  if (!open) return null;

  const submit = async (e?: React.FormEvent) => {
    e?.preventDefault();
    const n = name.trim();
    const sid = studentId.trim();
    const tel = phone.trim();
    // Phone is optional now — requiring it before the quiz was the biggest
    // drop-off in the funnel. We still keep it (for follow-up) when given, and
    // only validate the format if the student actually typed something.
    if (!n || (requireStudentId && !sid)) {
      setError(requireStudentId ? "กรุณากรอกชื่อ และรหัสนักเรียน" : "กรุณากรอกชื่อ");
      return;
    }
    if (tel && tel.replace(/\D/g, "").length < 9) {
      setError("เบอร์โทรไม่ถูกต้อง");
      return;
    }
    setBusy(true);
    try {
      let existing: LocalStudent | null = sid
        ? ((await findStudentByStudentId(sid)) ?? null)
        : null;
      let restored: Parameters<typeof hydrateStudentProgress>[1] | null = null;

      // No local record on this device — check the cloud in case this
      // student already has progress under this class (different browser,
      // cleared storage, new phone, LINE in-app browser vs. Safari, etc).
      // Restores it into local IndexedDB instead of silently starting over.
      if (!existing && sid && classCode) {
        const { data } = await rpcGetStudentProgress({ code: classCode, studentId: sid });
        if (data?.student) {
          existing = {
            id: data.student.id,
            studentId: data.student.studentId,
            name: data.student.name,
            phone: data.student.phone,
            createdAt: data.student.createdAt,
            syncedAt: new Date().toISOString(),
          };
          restored = {
            lessonProgress: data.lessonProgress,
            quizAttempts: data.quizAttempts,
          };
        }
      }

      // Email is no longer collected here — it's gathered later at the
      // certificate step. Preserve any value a returning student already had.
      const unchanged =
        existing && existing.name === n && (existing.phone ?? null) === (tel || null);
      const record: LocalStudent = existing
        ? {
            ...existing,
            name: n,
            phone: tel || null,
            syncedAt: unchanged ? existing.syncedAt : null,
          }
        : {
            id: uuidv4(),
            studentId: sid,
            name: n,
            phone: tel || null,
            createdAt: new Date().toISOString(),
          };
      await upsertStudent(record);
      if (restored) await hydrateStudentProgress(record.id, restored);
      setActiveStudent(record);
      scheduleFlush();
      // ใช้ UUID เป็น distinct id — ไม่ส่งชื่อ/เบอร์โทร (PDPA)
      track("student_registered", {
        has_student_code: !!sid,
        is_returning: !!existing,
        restored: !!restored,
      });
      onConfirm?.(record);
    } catch (err) {
      setError(err instanceof Error ? err.message : "บันทึกไม่สำเร็จ");
    }
    setBusy(false);
  };

  return (
    <div className={modalOverlay} onClick={onClose}>
      <form onClick={(e) => e.stopPropagation()} onSubmit={submit} className={modalPanel}>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
              <User size={18} strokeWidth={2.2} />
            </div>
            <div>
              <div className={textHeadline}>ระบุตัวผู้เรียน</div>
              <div className={`${text2xs} text-muted-foreground`}>
                ใช้สำหรับบันทึกผลก่อนเริ่ม Quiz
              </div>
            </div>
          </div>
          {onClose && (
            <button
              type="button"
              onClick={onClose}
              className="flex h-8 w-8 items-center justify-center rounded-full text-muted-foreground hover:bg-muted"
              aria-label="Close"
            >
              <X size={18} strokeWidth={2.2} />
            </button>
          )}
        </div>

        <div className="space-y-3">
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">ชื่อ–นามสกุล</span>
            <input
              type="text"
              autoFocus
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="เช่น อนันต์ ใจดี"
              className={`${inputBase} mt-1 text-sm`}
            />
          </label>
          {requireStudentId && (
            <label className="block">
              <span className="text-xs font-semibold text-foreground/80">รหัสนักเรียน</span>
              <input
                type="text"
                value={studentId}
                onChange={(e) => setStudentId(e.target.value)}
                placeholder="เช่น 65001"
                className={`${inputBase} mt-1 text-sm`}
              />
            </label>
          )}
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">
              เบอร์โทร
              <span className="font-normal text-muted-foreground">
                {" "}
                (ถ้ามี — ไว้ส่งผล/ใบประกาศ)
              </span>
            </span>
            <input
              type="tel"
              inputMode="tel"
              autoComplete="tel"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              placeholder="เช่น 081-234-5678"
              className={`${inputBase} mt-1 text-sm tabular-nums`}
            />
          </label>
          {error && (
            <div className={errorBox}>
              <AlertCircle size={14} strokeWidth={2.2} /> {error}
            </div>
          )}
        </div>

        <button type="submit" disabled={busy} className={`${btnPrimary} ${btnLg} ${btnBlock}`}>
          <Check size={16} strokeWidth={2.4} /> ยืนยันและเริ่ม
        </button>
        <p className={`${text2xs} text-center text-muted-foreground`}>
          ระบบจะบันทึกชื่อ–เบอร์ไว้ในเครื่องนี้ (offline)
        </p>
      </form>
    </div>
  );
}
