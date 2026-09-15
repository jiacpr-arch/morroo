// เลือกว่าจะใช้ตัวอย่างระดับ slug หรือ category มาคิด percentile ท้ายเกมเคส
// (ดูเหตุผลเต็มใน app/api/casegame/rank/route.ts) — pure ทั้งไฟล์

export interface PercentileRow {
  scope: "slug" | "category";
  sample: number;
  below: number;
  tie: number;
}

export interface PickedRank {
  scope: "slug" | "category" | null;
  sample: number;
  below: number;
  tie: number;
}

/**
 * เคสส่วนใหญ่มีคนเล่นน้อย (~157 เคส หาร completes/สัปดาห์) ตัวอย่างระดับ slug
 * อย่างเดียวจึงมักไม่พอให้เชื่อถือได้ — เลือก slug ก่อนถ้าตัวอย่างพอ (>= minSample)
 * ไม่งั้น fallback ไปหมวด (category) ซึ่งมีตัวอย่างมากกว่ามาก ถ้ายังไม่พอทั้งคู่
 * คืน scope null แต่ยังเก็บ sample ของ slug ไว้ให้ UI ใช้ทำ "คนที่ N" ได้
 */
export function pickRankScope(rows: readonly PercentileRow[], opts: { minSample?: number } = {}): PickedRank {
  const minSample = opts.minSample ?? 30;
  const slugRow = rows.find((r) => r.scope === "slug") ?? null;
  const categoryRow = rows.find((r) => r.scope === "category") ?? null;

  if (slugRow && slugRow.sample >= minSample) {
    return { scope: "slug", sample: slugRow.sample, below: slugRow.below, tie: slugRow.tie };
  }
  if (categoryRow && categoryRow.sample >= minSample) {
    return { scope: "category", sample: categoryRow.sample, below: categoryRow.below, tie: categoryRow.tie };
  }
  return {
    scope: null,
    sample: slugRow?.sample ?? 0,
    below: slugRow?.below ?? 0,
    tie: slugRow?.tie ?? 0,
  };
}
