"use client";

import { useEffect } from "react";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";

// Ensures we have an anonymous local learner id even before the user enters their name.
//
// สร้างตัวใหม่ "หลัง persist hydrate เสร็จ" เท่านั้น — ถ้า effect วิ่งก่อน
// rehydration การเช็ค !learner จะเห็น null ชั่วคราวแล้วสร้าง id ใหม่ทับของ
// ผู้ใช้เดิม ทำให้ progress ฝั่ง server หลุดจาก learner id เดิม
export function useEnsureLearner() {
  const learner = useLearnerStore((s) => s.learner);

  useEffect(() => {
    const createIfMissing = () => {
      if (!useLearnerStore.getState().learner) {
        useLearnerStore.getState().setLearner({
          id: crypto.randomUUID(),
          name: "",
          createdAt: new Date().toISOString(),
        });
      }
    };
    const persistApi = useLearnerStore.persist;
    if (!persistApi || persistApi.hasHydrated()) {
      createIfMissing();
      return undefined;
    }
    return persistApi.onFinishHydration(createIfMissing);
  }, []);

  return learner;
}
