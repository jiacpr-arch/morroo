// Percentile ท้าย Mock Exam ("ดีกว่า X% ของผู้ที่ทำชุดนี้") — pure ทั้งไฟล์
// ตัวเลขดิบมาจาก RPC get_mock_percentile
// (supabase/migrations/20260925_mock_percentile.sql, ล่าสุด 20260926_mock_server_graded.sql
// ที่นับเฉพาะผลที่ server ตรวจ) ซึ่งคืน 2 scope:
//   size  = mock ประเภทเดียวกัน จำนวนข้อเท่ากัน (เทียบตรงที่สุด)
//   track = mock ประเภทเดียวกันทุกขนาด (fallback เมื่อ size ตัวอย่างบาง)

export type MockPercentileScope = "size" | "track";

export interface MockPercentileRow {
  scope: MockPercentileScope;
  sample: number;
  /** null เมื่อ sample ต่ำกว่าเกณฑ์ขั้นต่ำฝั่ง DB (กันเดาคะแนนรายคน) */
  below: number | null;
  tie: number | null;
}

export type MockRank =
  | { status: "ranked"; scope: MockPercentileScope; sample: number; percentile: number }
  | { status: "insufficient"; sample: number };

/** ต่ำกว่านี้ไม่โชว์ % — ตัวอย่างน้อยเกินจะมีความหมาย และ DB ก็ไม่คืน below ให้อยู่แล้ว */
export const MOCK_PERCENTILE_MIN_SAMPLE = 10;

/**
 * ขนาด mock ใหญ่สุดที่ถือว่าเป็นไปได้ (board = 200 ข้อ) — ต้องตรงกับเงื่อนไข
 * plausibility ใน get_mock_percentile (supabase/migrations/20260926_mock_percentile_fix.sql)
 */
export const MOCK_MAX_QUESTIONS = 300;

/**
 * คะแนน mock ที่เป็นไปได้: 1..MOCK_MAX_QUESTIONS ข้อ และ 0 <= ถูก <= ทั้งหมด
 * ตรงกับเงื่อนไขใน RPC — ตอนนี้แถวที่นับต้อง graded_by_server ด้วย (บันทึกโดย
 * /api/mcq/mock/submit เท่านั้น ดู 20260926_mock_server_graded.sql) เงื่อนไขนี้จึง
 * เหลือเป็นแค่ด่านสำรอง
 */
export function isPlausibleMockScore(totalQuestions: number, correctCount: number): boolean {
  return (
    Number.isInteger(totalQuestions) &&
    Number.isInteger(correctCount) &&
    totalQuestions >= 1 &&
    totalQuestions <= MOCK_MAX_QUESTIONS &&
    correctCount >= 0 &&
    correctCount <= totalQuestions
  );
}

function isUsable(row: MockPercentileRow | undefined, minSample: number): row is MockPercentileRow & { below: number } {
  return !!row && row.sample >= minSample && typeof row.below === "number" && row.below >= 0;
}

/**
 * เลือก scope ที่ใช้โชว์: size ก่อนถ้าตัวอย่างพอ ไม่งั้น fallback track
 * ถ้าไม่พอทั้งคู่ คืน insufficient พร้อม sample ที่มากที่สุดไว้ให้ UI บอกว่า
 * "มีผู้สอบอีก N คน" ได้
 *
 * percentile = สัดส่วนคนที่ได้คะแนน "ต่ำกว่า" จริง (ไม่นับคนที่เท่ากัน) ให้ตรงกับ
 * ถ้อยคำ "ดีกว่า X%" — ปัดลง ไม่ให้ขึ้น 100% ถ้ายังมีคนเสมอหรือเหนือกว่า
 */
export function pickMockRank(
  rows: readonly MockPercentileRow[] | null | undefined,
  opts: { minSample?: number } = {},
): MockRank {
  const minSample = Math.max(1, opts.minSample ?? MOCK_PERCENTILE_MIN_SAMPLE);
  const list = rows ?? [];
  const size = list.find((r) => r.scope === "size");
  const track = list.find((r) => r.scope === "track");

  const picked = isUsable(size, minSample) ? size : isUsable(track, minSample) ? track : null;
  if (!picked) {
    const sample = Math.max(0, size?.sample ?? 0, track?.sample ?? 0);
    return { status: "insufficient", sample };
  }

  const below = Math.min(picked.below, picked.sample);
  const percentile = Math.floor((below / picked.sample) * 100);
  return { status: "ranked", scope: picked.scope, sample: picked.sample, percentile };
}

/** ข้อความหลักบนการ์ดผล */
export function mockRankHeadline(rank: MockRank): string {
  if (rank.status === "insufficient") {
    return rank.sample > 0
      ? `ตอนนี้มีผู้ทำชุดนี้อีก ${rank.sample} คน — รอให้ครบ ${MOCK_PERCENTILE_MIN_SAMPLE} คนก่อนจึงจะจัดอันดับได้`
      : "คุณเป็นกลุ่มแรกที่ทำชุดนี้ — ยังไม่มีคนอื่นให้เทียบ";
  }
  return `คุณทำคะแนนได้ดีกว่า ${rank.percentile}% ของผู้ที่ทำชุดนี้`;
}

/** บอกว่าเทียบกับใคร เช่น "เทียบกับผู้ทำ Mock NL 50 ข้อ 128 คน" */
export function mockRankCohortLabel(rank: MockRank, opts: { label: string; totalQuestions: number }): string | null {
  if (rank.status !== "ranked") return null;
  const who = rank.scope === "size" ? `${opts.label} ${opts.totalQuestions} ข้อ` : `${opts.label} (ทุกจำนวนข้อ)`;
  return `เทียบกับผู้ทำ ${who} ${rank.sample.toLocaleString("th-TH")} คน · นับรอบล่าสุดของแต่ละคน`;
}

/** ข้อความแชร์ — เดินตามแพทเทิร์น components/school/ShareResult.tsx (copy / navigator.share) */
export function mockShareText(opts: {
  label: string;
  correct: number;
  total: number;
  rank: MockRank | null;
  url: string;
}): string {
  const pct = opts.total > 0 ? Math.round((opts.correct / opts.total) * 100) : 0;
  const lines = [`📝 ${opts.label} — ฉันทำได้ ${opts.correct}/${opts.total} (${pct}%) บน Morroo`];
  if (opts.rank?.status === "ranked") {
    lines.push(`🏆 ดีกว่า ${opts.rank.percentile}% ของผู้ที่ทำชุดนี้`);
  }
  lines.push("", `มาลองจำลองสอบกันที่ ${opts.url}`);
  return lines.join("\n");
}
