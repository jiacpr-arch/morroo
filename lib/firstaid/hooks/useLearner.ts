"use client";

import { useEffect } from "react";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";

// Ensures we have an anonymous local learner id even before the user enters their name.
export function useEnsureLearner() {
  const learner = useLearnerStore((s) => s.learner);
  const setLearner = useLearnerStore((s) => s.setLearner);

  useEffect(() => {
    if (!learner) {
      const fresh = {
        id: crypto.randomUUID(),
        name: "",
        createdAt: new Date().toISOString(),
      };
      setLearner(fresh);
    }
  }, [learner, setLearner]);

  return learner;
}
