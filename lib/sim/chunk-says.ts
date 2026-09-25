// "อ่านน้อยแต่บ่อย" — บทพูดยาวหลายบรรทัดรบกวนการเรียนรู้ จึงแตกบทพูดที่ยาวเกิน
// เป็นหลาย say สั้นๆ ต่อกัน (แตะทีละท่อน) ตัดที่ช่องว่าง/เครื่องหมายวรรคตอน
// ไม่ตัดกลางคำ และไม่ทำให้ **คำเน้น** ขาดคู่ (ปิดท่อนเดิม แล้วเปิดใหม่ในท่อนถัดไป)

import type { StoryNode } from "./types";

/** ความยาวสูงสุดต่อบทพูด (~2 บรรทัดบนมือถือ) */
export const SAY_MAX_CHARS = 110;

function emphasisOpenAt(text: string): boolean {
  return (text.split("**").length - 1) % 2 === 1;
}

/** แตกข้อความเป็นท่อนละไม่เกิน max ตัวอักษร (ท่อนเดียวที่ไม่มีจุดตัดยอมให้เกิน) */
export function chunkText(text: string, max = SAY_MAX_CHARS): string[] {
  const clean = text.replace(/\s+/g, " ").trim();
  if (clean.length <= max) return [clean];
  // ตัดหลังช่องว่าง — เก็บเครื่องหมายวรรคตอนไว้กับท่อนหน้า
  const words = clean.split(/(?<= )/);
  const chunks: string[] = [];
  let cur = "";
  for (const w of words) {
    if (cur && (cur + w).trim().length > max) {
      chunks.push(cur.trim());
      cur = "";
    }
    cur += w;
  }
  if (cur.trim()) chunks.push(cur.trim());
  // เติม ** ปิด/เปิดให้คำเน้นที่คร่อมรอยตัดยังครบคู่ทุกท่อน
  for (let i = 0; i < chunks.length - 1; i++) {
    if (emphasisOpenAt(chunks[i])) {
      chunks[i] = `${chunks[i]}**`;
      chunks[i + 1] = `**${chunks[i + 1]}`;
    }
  }
  return chunks;
}

/**
 * แตก say ที่ยาวเกินเป็นหลาย say ต่อกัน (คนพูด/ท่าทางเดิม เวลาในเรื่องแบ่งเท่าๆ กัน)
 * ทำทั้ง story และ then ที่ซ้อนอยู่ในตัวเลือก — คืน story ใหม่ ไม่ mutate ของเดิม
 */
export function chunkLongSays(story: StoryNode[], max = SAY_MAX_CHARS): StoryNode[] {
  const out: StoryNode[] = [];
  for (const node of story) {
    if ("say" in node) {
      const parts = chunkText(node.say.text, max);
      if (parts.length === 1) {
        out.push(node);
        continue;
      }
      const t = node.t ? Math.max(1, Math.round(node.t / parts.length)) : undefined;
      parts.forEach((text, i) =>
        out.push({ say: { ...node.say, text, ...(i > 0 ? { fx: undefined } : {}) }, ...(t ? { t } : {}) }),
      );
      continue;
    }
    if ("choice" in node) {
      out.push({
        choice: {
          ...node.choice,
          options: node.choice.options.map((o) => (o.then ? { ...o, then: chunkLongSays(o.then, max) } : o)),
        },
      });
      continue;
    }
    out.push(node);
  }
  return out;
}
