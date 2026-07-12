"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

// Session state for the pre-course: the identified student plus any exam in
// progress, persisted so a refresh mid-exam doesn't lose answers.

export interface ActiveStudent {
  id: string;
  studentId: string;
  name: string;
  phone?: string | null;
}

export interface LessonAttempt {
  lessonId: string;
  answers: Record<string, string>;
  stepIndex: number;
  startedAt: string;
}

export interface ExamSlot {
  setId: string;
  answers: Record<string, string>;
  currentIndex: number;
  startedAt: string;
}

interface PreCourseStore {
  activeStudent: ActiveStudent | null;
  currentAttempt: LessonAttempt | null;
  currentPostTest: ExamSlot | null;
  currentPreTest: ExamSlot | null;

  setActiveStudent: (student: ActiveStudent | null) => void;
  clearActiveStudent: () => void;

  startAttempt: (lessonId: string) => void;
  setStepIndex: (stepIndex: number) => void;
  answerQuestion: (qId: string, choiceId: string) => void;
  clearAttempt: () => void;

  startPostTest: (setId: string) => void;
  setPostTestIndex: (currentIndex: number) => void;
  answerPostTest: (qId: string, choiceId: string) => void;
  clearPostTest: () => void;

  startPreTest: (setId: string) => void;
  setPreTestIndex: (currentIndex: number) => void;
  answerPreTest: (qId: string, choiceId: string) => void;
  clearPreTest: () => void;
}

export const usePreCourseStore = create<PreCourseStore>()(
  persist(
    (set) => ({
      activeStudent: null,
      currentAttempt: null,
      currentPostTest: null,
      currentPreTest: null,

      setActiveStudent: (student) => set({ activeStudent: student }),
      clearActiveStudent: () =>
        set({
          activeStudent: null,
          currentAttempt: null,
          currentPostTest: null,
          currentPreTest: null,
        }),

      startAttempt: (lessonId) =>
        set({
          currentAttempt: {
            lessonId,
            answers: {},
            stepIndex: 0,
            startedAt: new Date().toISOString(),
          },
        }),
      setStepIndex: (stepIndex) =>
        set((s) => ({
          currentAttempt: s.currentAttempt ? { ...s.currentAttempt, stepIndex } : null,
        })),
      answerQuestion: (qId, choiceId) =>
        set((s) => ({
          currentAttempt: s.currentAttempt
            ? {
                ...s.currentAttempt,
                answers: { ...s.currentAttempt.answers, [qId]: choiceId },
              }
            : null,
        })),
      clearAttempt: () => set({ currentAttempt: null }),

      startPostTest: (setId) =>
        set({
          currentPostTest: {
            setId,
            answers: {},
            currentIndex: 0,
            startedAt: new Date().toISOString(),
          },
        }),
      setPostTestIndex: (currentIndex) =>
        set((s) => ({
          currentPostTest: s.currentPostTest
            ? { ...s.currentPostTest, currentIndex }
            : null,
        })),
      answerPostTest: (qId, choiceId) =>
        set((s) => ({
          currentPostTest: s.currentPostTest
            ? {
                ...s.currentPostTest,
                answers: { ...s.currentPostTest.answers, [qId]: choiceId },
              }
            : null,
        })),
      clearPostTest: () => set({ currentPostTest: null }),

      startPreTest: (setId) =>
        set({
          currentPreTest: {
            setId,
            answers: {},
            currentIndex: 0,
            startedAt: new Date().toISOString(),
          },
        }),
      setPreTestIndex: (currentIndex) =>
        set((s) => ({
          currentPreTest: s.currentPreTest
            ? { ...s.currentPreTest, currentIndex }
            : null,
        })),
      answerPreTest: (qId, choiceId) =>
        set((s) => ({
          currentPreTest: s.currentPreTest
            ? {
                ...s.currentPreTest,
                answers: { ...s.currentPreTest.answers, [qId]: choiceId },
              }
            : null,
        })),
      clearPreTest: () => set({ currentPreTest: null }),
    }),
    { name: "morroo-precourse-session" },
  ),
);
