// Guard: ห้ามอ่านคอลัมน์เฉลยของ mcq_questions ผ่าน client ของผู้ใช้
//
// supabase/migrations/20260927_hide_mcq_answers.sql revoke select คอลัมน์เฉลย
// (correct_answer, explanation, detailed_explanation, ai_notes) จาก anon/authenticated
// query แบบ select("*") หรือ select เฉลย ผ่าน lib/supabase/server.ts / client.ts
// จะพังทันทีที่ลง migration (และก่อนหน้านั้นคือรั่วเฉลย) — test นี้สแกนซอร์สแบบ static
// ให้ทุก query แบบนั้นต้องมาจาก service role (ตัวแปรชื่อ `admin` หรือไฟล์ที่อนุญาต)

import fs from "node:fs";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { MCQ_HIDDEN_COLUMNS, MCQ_PUBLIC_COLUMN_LIST } from "./mcq-public";

const ROOT = path.resolve(__dirname, "..");
const SCAN_DIRS = ["app", "components", "lib"];

/**
 * ไฟล์ที่รับ SupabaseClient เป็นพารามิเตอร์ชื่ออื่นที่ไม่ใช่ `admin` แต่ผู้เรียก
 * ทุกคนส่ง service role มา — เพิ่มเข้ามาต้องมีเหตุผล
 */
const SERVICE_ROLE_FILES: Record<string, string> = {
  // loadDailyQuestion/loadHardQuestion — เรียกจาก LINE webhook + daily-reminder ด้วย createAdminClient()
  "lib/daily-mcq-line.ts": "LINE daily quiz grades on the server (admin client passed in)",
  // cron route ที่ใช้ createAdminClient() ตั้งชื่อตัวแปรว่า supabase
  "app/api/line/daily-reminder/route.ts": "cron, createAdminClient()",
};

/** ไฟล์ที่ embed mcq_questions(<เฉลย>) ผ่าน table อื่น — ต้องเป็น service role */
const EMBED_ALLOWED_FILES: Record<string, string> = {
  "app/api/admin/mcq/reports/route.ts": "requireAdmin + createAdminClient()",
};

/** select arg ที่เป็นตัวแปร/นิพจน์ที่รู้ว่าปลอดภัย (มีแต่คอลัมน์สาธารณะ) */
const SAFE_SELECT_IDENTIFIERS = new Set(["MCQ_PUBLIC_SELECT", "MCQ_PUBLIC_COLUMNS"]);

export interface Violation {
  file: string;
  line: number;
  reason: string;
}

function lineOf(src: string, index: number): number {
  return src.slice(0, index).split("\n").length;
}

/** เนื้อในวงเล็บที่เปิดที่ openIdx (src[openIdx] === "(") แบบนับวงเล็บ */
function balanced(src: string, openIdx: number): string {
  let depth = 0;
  for (let i = openIdx; i < src.length; i++) {
    const ch = src[i];
    if (ch === "(") depth++;
    else if (ch === ")") {
      depth--;
      if (depth === 0) return src.slice(openIdx + 1, i);
    }
  }
  return src.slice(openIdx + 1);
}

/** argument แรกของ select(...) (ตัดที่ comma ระดับบนสุด) */
function firstArg(args: string): string {
  let depth = 0;
  let quote: string | null = null;
  for (let i = 0; i < args.length; i++) {
    const ch = args[i];
    if (quote) {
      if (ch === quote && args[i - 1] !== "\\") quote = null;
      continue;
    }
    if (ch === '"' || ch === "'" || ch === "`") quote = ch;
    else if (ch === "(" || ch === "{" || ch === "[") depth++;
    else if (ch === ")" || ch === "}" || ch === "]") depth--;
    else if (ch === "," && depth === 0) return args.slice(0, i).trim();
  }
  return args.trim();
}

const HIDDEN_RE = new RegExp(`\\b(${MCQ_HIDDEN_COLUMNS.join("|")})\\b`);

/** true = select นี้อาจดึงเฉลย (*, คอลัมน์เฉลย หรือนิพจน์ที่ตรวจไม่ได้) */
function selectMayExposeAnswers(arg: string): boolean {
  if (arg === "") return true; // select() ว่าง = ทุกคอลัมน์
  if (SAFE_SELECT_IDENTIFIERS.has(arg)) return false;
  const literal = /^(["'`])([\s\S]*)\1$/.exec(arg);
  if (!literal) return true; // ตัวแปร/นิพจน์อื่น — ถือว่าไม่ปลอดภัย
  const body = literal[2];
  if (body.includes("${")) {
    // template: อนุญาตเฉพาะ ${MCQ_PUBLIC_COLUMNS}/${MCQ_PUBLIC_SELECT} + ส่วนที่ปลอดภัย
    const rest = body.replace(/\$\{\s*(MCQ_PUBLIC_COLUMNS|MCQ_PUBLIC_SELECT)\s*\}/g, "");
    if (rest.includes("${")) return true;
    return rest.includes("*") || HIDDEN_RE.test(rest);
  }
  // ตัด embed ของ table อื่น (เช่น mcq_subjects(name_th)) ออกก่อนตรวจ *
  return body.includes("*") || HIDDEN_RE.test(body);
}

/** วิเคราะห์ซอร์สไฟล์เดียว — export ไว้ให้ test ตัวเองได้ */
export function findMcqAnswerLeaks(file: string, src: string): Violation[] {
  const out: Violation[] = [];
  const fromRe = /\.from\(\s*["'`]mcq_questions["'`]\s*\)/g;
  for (let m = fromRe.exec(src); m; m = fromRe.exec(src)) {
    // ปลาย statement — select ต้องอยู่ใน chain เดียวกัน
    const end = src.indexOf(";", m.index);
    const chain = src.slice(m.index, end === -1 ? undefined : end);
    const selIdx = chain.search(/\.select\(/);
    if (selIdx === -1) continue; // insert/update/delete แบบไม่ return — ไม่อ่านเฉลย
    const openIdx = m.index + selIdx + chain.slice(selIdx).indexOf("(");
    const arg = firstArg(balanced(src, openIdx));
    if (!selectMayExposeAnswers(arg)) continue;

    const before = src.slice(0, m.index).replace(/\s+$/, "");
    const receiver = /([A-Za-z_$][\w$]*)(\(\))?$/.exec(before);
    const receiverName = receiver?.[1] ?? "";
    const isAdminReceiver =
      receiverName === "admin" || (receiverName === "createAdminClient" && !!receiver?.[2]);
    if (isAdminReceiver || SERVICE_ROLE_FILES[file]) continue;
    out.push({
      file,
      line: lineOf(src, m.index),
      reason: `mcq_questions select(${arg.slice(0, 80)}) on "${receiverName}" may expose answer columns — use MCQ_PUBLIC_SELECT or the service-role client named \`admin\``,
    });
  }

  // embed ผ่าน table อื่น: "... mcq_questions(...)" / "mcq_questions!inner(...)"
  const embedRe = /mcq_questions(?:![\w]+)?\(/g;
  for (let m = embedRe.exec(src); m; m = embedRe.exec(src)) {
    const openIdx = m.index + m[0].length - 1;
    const inner = balanced(src, openIdx);
    if (!inner.includes("*") && !HIDDEN_RE.test(inner)) continue;
    if (EMBED_ALLOWED_FILES[file]) continue;
    out.push({
      file,
      line: lineOf(src, m.index),
      reason: `embedded mcq_questions(${inner.slice(0, 60)}) exposes answer columns`,
    });
  }
  return out;
}

function walk(dir: string, acc: string[]): string[] {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === "node_modules" || entry.name.startsWith(".")) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full, acc);
    else if (/\.(ts|tsx)$/.test(entry.name) && !/\.test\.tsx?$/.test(entry.name)) acc.push(full);
  }
  return acc;
}

describe("mcq_questions answer columns guard", () => {
  it("no user-scoped query selects answer columns or *", () => {
    const files = SCAN_DIRS.flatMap((d) => walk(path.join(ROOT, d), []));
    expect(files.length).toBeGreaterThan(50);
    const violations = files.flatMap((full) => {
      const rel = path.relative(ROOT, full).split(path.sep).join("/");
      return findMcqAnswerLeaks(rel, fs.readFileSync(full, "utf8"));
    });
    expect(violations.map((v) => `${v.file}:${v.line} ${v.reason}`)).toEqual([]);
  });

  it("browser code never reads answer columns, even via an `admin`-named variable", () => {
    const files = SCAN_DIRS.flatMap((d) => walk(path.join(ROOT, d), []));
    const offenders = files
      .map((full) => ({ full, src: fs.readFileSync(full, "utf8") }))
      .filter(({ src }) => /^\s*["']use client["']/.test(src))
      .filter(({ src }) => /\.from\(\s*["'`]mcq_questions["'`]\s*\)/.test(src))
      .flatMap(({ full, src }) => {
        const rel = path.relative(ROOT, full).split(path.sep).join("/");
        // ตัด receiver ออก ให้ทุก select ถูกตรวจเหมือน client ของผู้ใช้
        return findMcqAnswerLeaks(rel, src.replace(/\badmin\b/g, "browserClient"));
      });
    expect(offenders).toEqual([]);
  });

  it("allowlisted files still exist (prune stale entries)", () => {
    for (const rel of [...Object.keys(SERVICE_ROLE_FILES), ...Object.keys(EMBED_ALLOWED_FILES)]) {
      expect(fs.existsSync(path.join(ROOT, rel)), rel).toBe(true);
    }
  });

  it("public column list matches the migration grant", () => {
    const sql = fs.readFileSync(
      path.join(ROOT, "supabase/migrations/20260927_hide_mcq_answers.sql"),
      "utf8",
    );
    const grant = /grant select \(([\s\S]*?)\) on public\.mcq_questions/i.exec(sql);
    expect(grant).not.toBeNull();
    const cols = grant![1].split(",").map((c) => c.trim()).filter(Boolean);
    expect(cols).toEqual([...MCQ_PUBLIC_COLUMN_LIST]);
    for (const hidden of MCQ_HIDDEN_COLUMNS) expect(cols).not.toContain(hidden);
  });
});

describe("findMcqAnswerLeaks (analyzer self-test)", () => {
  const f = "lib/example.ts";

  it("flags select('*') on a user client", () => {
    const src = `const { data } = await supabase\n  .from("mcq_questions")\n  .select("*, mcq_subjects(name)")\n  .eq("id", id);`;
    expect(findMcqAnswerLeaks(f, src)).toHaveLength(1);
  });

  it("flags hidden columns on a user client", () => {
    const src = `await supabase.from("mcq_questions").select("id, correct_answer").eq("id", id);`;
    expect(findMcqAnswerLeaks(f, src)[0]?.line).toBe(1);
  });

  it("flags an empty select and unknown select expressions", () => {
    expect(findMcqAnswerLeaks(f, `await supabase.from("mcq_questions").select();`)).toHaveLength(1);
    expect(findMcqAnswerLeaks(f, `await supabase.from("mcq_questions").select(cols);`)).toHaveLength(1);
  });

  it("flags embedded answer columns", () => {
    const src = `await supabase.from("mcq_question_reports").select("id, mcq_questions(scenario, correct_answer)");`;
    expect(findMcqAnswerLeaks(f, src)).toHaveLength(1);
    const inner = `await supabase.from("mcq_attempts").select("id, mcq_questions!inner(*)");`;
    expect(findMcqAnswerLeaks(f, inner)).toHaveLength(1);
  });

  it("allows public columns, MCQ_PUBLIC_SELECT and writes without select", () => {
    const src = [
      `await supabase.from("mcq_questions").select("id, scenario, choices, mcq_subjects(name_th)");`,
      `await supabase.from("mcq_questions").select(MCQ_PUBLIC_SELECT).eq("status", "active");`,
      "await supabase.from(\"mcq_questions\").select(`${MCQ_PUBLIC_COLUMNS}, mcq_subjects(icon)`);",
      `await supabase.from("mcq_questions").select("id", { count: "exact", head: true });`,
      `await supabase.from("mcq_questions").update({ correct_answer: "A" }).eq("id", id);`,
      `await supabase.from("mcq_questions").insert(row).select("id").single();`,
      `await supabase.from("mcq_attempts").select("id, mcq_questions!inner(subject_id, audience)");`,
    ].join("\n");
    expect(findMcqAnswerLeaks(f, src)).toEqual([]);
  });

  it("allows answer columns on the service-role client", () => {
    const src = [
      `const admin = createAdminClient();`,
      `await admin\n  .from("mcq_questions")\n  .select("id, correct_answer, explanation")\n  .in("id", ids);`,
      `await createAdminClient().from("mcq_questions").select("*");`,
    ].join("\n");
    expect(findMcqAnswerLeaks(f, src)).toEqual([]);
  });
});
