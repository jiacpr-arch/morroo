"use client";

import { create } from "zustand";

// Progress now lives server-side only (fa_* tables in morroo's Supabase) — the
// old offline-first Dexie/IndexedDB layer and its background sync are gone.
// Reads come from GET /api/firstaid/progress; writes are optimistic in the
// store and fire-and-forget to POST /api/firstaid/progress. A lost write is
// re-derivable (the learner just re-opens the lesson), matching the old app's
// tolerance for unsynced local rows.

export type ExamSummary = {
  kind: "pre" | "post";
  score: number;
  passed: boolean;
  finishedAt?: string;
} | null;

type ProgressState = {
  readLessonIds: Set<string>;
  passedScenarioIds: Set<string>;
  preTestDone: boolean;
  postTestDone: boolean;
  bestPost: ExamSummary;
  loaded: boolean;
  loading: boolean;
  refresh: (learnerId: string | undefined | null) => Promise<void>;
  markRead: (lessonId: string) => void;
  markScenarioPassed: (scenarioId: string) => void;
  markPreTestDone: () => void;
  markPostTestDone: () => void;
};

export const useProgressStore = create<ProgressState>((set) => ({
  readLessonIds: new Set<string>(),
  passedScenarioIds: new Set<string>(),
  preTestDone: false,
  postTestDone: false,
  bestPost: null,
  loaded: false,
  loading: false,
  refresh: async (learnerId) => {
    if (!learnerId) {
      set({
        readLessonIds: new Set(),
        passedScenarioIds: new Set(),
        preTestDone: false,
        postTestDone: false,
        bestPost: null,
        loaded: true,
      });
      return;
    }
    set({ loading: true });
    try {
      const res = await fetch(
        `/api/firstaid/progress?learnerId=${encodeURIComponent(learnerId)}`,
      );
      if (!res.ok) {
        set({ loading: false, loaded: true });
        return;
      }
      const data = (await res.json()) as {
        readLessonIds?: string[];
        passedScenarioIds?: string[];
        bestPre?: ExamSummary;
        bestPost?: ExamSummary;
      };
      set({
        readLessonIds: new Set(data.readLessonIds ?? []),
        passedScenarioIds: new Set(data.passedScenarioIds ?? []),
        preTestDone: !!data.bestPre,
        postTestDone: !!data.bestPost,
        bestPost: data.bestPost ?? null,
        loading: false,
        loaded: true,
      });
    } catch {
      // Network error — keep whatever optimistic state we have; a later
      // refresh (revisit, reconnect) retries.
      set({ loading: false, loaded: true });
    }
  },
  markRead: (lessonId) =>
    set((s) => {
      const next = new Set(s.readLessonIds);
      next.add(lessonId);
      return { readLessonIds: next };
    }),
  markScenarioPassed: (scenarioId) =>
    set((s) => {
      const next = new Set(s.passedScenarioIds);
      next.add(scenarioId);
      return { passedScenarioIds: next };
    }),
  markPreTestDone: () => set({ preTestDone: true }),
  markPostTestDone: () => set({ postTestDone: true }),
}));

type ProgressWrite = {
  learnerId: string;
  lessonRead?: { lessonId: string; readAt: string };
  quizAttempt?: {
    uuid: string;
    lessonId: string;
    correct: number;
    total: number;
    finishedAt: string;
  };
  simulationRun?: {
    uuid: string;
    scenarioId: string;
    endingId: string;
    passed: boolean;
    finishedAt: string;
  };
};

// Fire-and-forget server write (replaces Dexie save + flushSync).
export function pushProgress(write: ProgressWrite) {
  return fetch("/api/firstaid/progress", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(write),
  }).catch(() => undefined);
}
