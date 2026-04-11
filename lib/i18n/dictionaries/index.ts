import type { LocaleCode } from "../config";
import type { Dictionary } from "./th";

const dictionaries: Record<LocaleCode, () => Promise<Dictionary>> = {
  th: () => import("./th").then((m) => m.default),
  en: () => import("./en").then((m) => m.default),
  my: () => import("./my").then((m) => m.default),
  lo: () => import("./lo").then((m) => m.default),
  km: () => import("./km").then((m) => m.default),
  zh: () => import("./zh").then((m) => m.default),
  vi: () => import("./vi").then((m) => m.default),
  hi: () => import("./hi").then((m) => m.default),
  ja: () => import("./ja").then((m) => m.default),
  ko: () => import("./ko").then((m) => m.default),
};

export async function getDictionary(locale: LocaleCode): Promise<Dictionary> {
  return dictionaries[locale]();
}

// Synchronous import for client-side (all loaded eagerly for instant switch)
export { default as th } from "./th";
export { default as en } from "./en";
export { default as my } from "./my";
export { default as lo } from "./lo";
export { default as km } from "./km";
export { default as zh } from "./zh";
export { default as vi } from "./vi";
export { default as hi } from "./hi";
export { default as ja } from "./ja";
export { default as ko } from "./ko";
