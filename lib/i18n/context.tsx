"use client";

import { createContext, useContext, useState, useEffect, useCallback } from "react";
import type { LocaleCode } from "./config";
import { defaultLocale, LOCALE_COOKIE } from "./config";
import type { Dictionary } from "./dictionaries/th";
import * as dicts from "./dictionaries";

interface LocaleContextValue {
  locale: LocaleCode;
  setLocale: (locale: LocaleCode) => void;
  t: Dictionary;
}

const LocaleContext = createContext<LocaleContextValue | null>(null);

const allDicts: Record<LocaleCode, Dictionary> = {
  th: dicts.th,
  en: dicts.en,
  my: dicts.my,
  lo: dicts.lo,
  km: dicts.km,
  zh: dicts.zh,
  vi: dicts.vi,
  hi: dicts.hi,
  ja: dicts.ja,
  ko: dicts.ko,
};

function getStoredLocale(): LocaleCode {
  if (typeof document === "undefined") return defaultLocale;
  const match = document.cookie.match(new RegExp(`(?:^|; )${LOCALE_COOKIE}=([^;]*)`));
  const stored = match?.[1] as LocaleCode | undefined;
  if (stored && stored in allDicts) return stored;
  return defaultLocale;
}

export function LocaleProvider({ children }: { children: React.ReactNode }) {
  const [locale, setLocaleState] = useState<LocaleCode>(defaultLocale);

  useEffect(() => {
    setLocaleState(getStoredLocale());
  }, []);

  const setLocale = useCallback((code: LocaleCode) => {
    setLocaleState(code);
    document.cookie = `${LOCALE_COOKIE}=${code};path=/;max-age=${60 * 60 * 24 * 365};samesite=lax`;
    document.documentElement.lang = code === "zh" ? "zh-CN" : code;
  }, []);

  return (
    <LocaleContext value={{ locale, setLocale, t: allDicts[locale] }}>
      {children}
    </LocaleContext>
  );
}

export function useTranslation() {
  const ctx = useContext(LocaleContext);
  if (!ctx) throw new Error("useTranslation must be used within LocaleProvider");
  return ctx;
}
