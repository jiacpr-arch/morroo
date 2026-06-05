// Helper: merges a JS array `NEW` (from --batch <path>) into surgery.json
// Usage: node scripts/board-seed-data/_append_questions.mjs <batch.mjs>
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const TARGET = join(HERE, "surgery.json");

const batchPath = resolve(process.argv[2]);
const mod = await import(pathToFileURL(batchPath).href);
const NEW = mod.default;
if (!Array.isArray(NEW)) throw new Error("batch must default-export an array");

const existing = JSON.parse(readFileSync(TARGET, "utf8"));
const merged = [...existing, ...NEW];
writeFileSync(TARGET, JSON.stringify(merged, null, 2) + "\n", "utf8");
console.log(`Appended ${NEW.length}. Total now: ${merged.length}`);
