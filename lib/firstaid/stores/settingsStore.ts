"use client";

import { create } from "zustand";
import { persist } from "zustand/middleware";

type SettingsState = {
  theme: "system" | "light" | "dark";
  fontScale: number;
  houseAdDismissedAt: number;
  setTheme: (theme: SettingsState["theme"]) => void;
  setFontScale: (fontScale: number) => void;
  dismissHouseAd: () => void;
};

export const useSettingsStore = create<SettingsState>()(
  persist(
    (set) => ({
      theme: "system",
      fontScale: 1,
      houseAdDismissedAt: 0,
      setTheme: (theme) => set({ theme }),
      setFontScale: (fontScale) => set({ fontScale }),
      dismissHouseAd: () => set({ houseAdDismissedAt: Date.now() }),
    }),
    { name: "firstaid.settings" },
  ),
);
