"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

export type Learner = {
  id: string;
  name: string;
  phone?: string;
  email?: string;
  cohortCode?: string;
  lineUserId?: string;
  lineAdded?: boolean;
  lineSkippedAt?: string | null;
  createdAt?: string;
};

type LearnerState = {
  learner: Learner | null;
  setLearner: (learner: Learner | null) => void;
  updateLearner: (patch: Partial<Learner>) => void;
  clear: () => void;
};

// Active learner identity (anonymous local profile until logged in with LINE).
// The persist key must stay "firstaid.learner" — returning users from the old
// firstaid.morroo.com deployment keep the same learner id (and therefore their
// migrated server-side progress) on the same device.
export const useLearnerStore = create<LearnerState>()(
  persist(
    (set) => ({
      learner: null,
      setLearner: (learner) => set({ learner }),
      updateLearner: (patch) =>
        set((s) => ({ learner: s.learner ? { ...s.learner, ...patch } : null })),
      clear: () => set({ learner: null }),
    }),
    { name: "firstaid.learner" },
  ),
);
