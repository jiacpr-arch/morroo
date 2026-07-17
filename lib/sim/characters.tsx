// Character registry — Code Blue Sim
//
// ตัวละครทั้งหมดเป็น "ข้อมูล" ไม่ใช่โค้ดเกม:
//   - เกม/โจทย์อ้างถึงตัวละครด้วย charId + pose เท่านั้น
//   - รูปจริงวางที่ public/images/sim/characters/{charId}/{pose}.webp
//     (+ {pose}_talk.webp สำหรับเฟรมปากอ้า — มีหรือไม่มีก็ได้)
//   - ถ้ายังไม่มีรูปจริง CharacterSprite จะ fallback มาใช้ SVG placeholder
//     ในไฟล์นี้ (วาดเป็น JSX ล้วน ไม่มี innerHTML)
//   - เพิ่มตัวละครใหม่ = เพิ่ม entry ที่นี่ + วางรูปในโฟลเดอร์ ไม่ต้องแตะ engine

import type { ReactElement } from "react";
import type { Pose } from "./types";

export const POSES: Pose[] = ["idle", "talk", "panic", "stern", "happy"];

const OUT = "#0E1322";

interface FaceProps {
  pose: Pose;
  /** เฟรมปากอ้าระหว่างพิมพ์บทพูด (สลับโดย CharacterSprite) */
  mouthOpen?: boolean;
}

export interface SimCharacter {
  name: string;
  role: string;
  plate: [string, string];
  Placeholder: (props: FaceProps) => ReactElement;
}

function Eyes({ pose, x1, x2, y, iris }: { pose: Pose; x1: number; x2: number; y: number; iris: string }) {
  if (pose === "happy") {
    return (
      <>
        <path d={`M${x1 - 9},${y} Q${x1},${y - 9} ${x1 + 9},${y}`} stroke={OUT} strokeWidth="3.4" fill="none" strokeLinecap="round" />
        <path d={`M${x2 - 9},${y} Q${x2},${y - 9} ${x2 + 9},${y}`} stroke={OUT} strokeWidth="3.4" fill="none" strokeLinecap="round" />
      </>
    );
  }
  const r = pose === "panic" ? 8.5 : 7;
  const pr = pose === "panic" ? 2.6 : 3.4;
  return (
    <>
      <ellipse cx={x1} cy={y} rx={r} ry={r + 1.5} fill="#fff" stroke={OUT} strokeWidth="2.6" />
      <circle cx={x1} cy={y + 1} r={pr} fill={iris} />
      <circle cx={x1 + 1.5} cy={y - 1.5} r="1.3" fill="#fff" />
      <ellipse cx={x2} cy={y} rx={r} ry={r + 1.5} fill="#fff" stroke={OUT} strokeWidth="2.6" />
      <circle cx={x2} cy={y + 1} r={pr} fill={iris} />
      <circle cx={x2 + 1.5} cy={y - 1.5} r="1.3" fill="#fff" />
    </>
  );
}

function Brows({ pose, x1, x2, y }: { pose: Pose; x1: number; x2: number; y: number }) {
  if (pose === "stern") {
    return (
      <>
        <path d={`M${x1 - 10},${y - 6} L${x1 + 9},${y + 1}`} stroke={OUT} strokeWidth="4" strokeLinecap="round" />
        <path d={`M${x2 + 10},${y - 6} L${x2 - 9},${y + 1}`} stroke={OUT} strokeWidth="4" strokeLinecap="round" />
      </>
    );
  }
  if (pose === "panic") {
    return (
      <>
        <path d={`M${x1 - 9},${y + 1} Q${x1},${y - 8} ${x1 + 9},${y - 2}`} stroke={OUT} strokeWidth="3.6" fill="none" strokeLinecap="round" />
        <path d={`M${x2 + 9},${y + 1} Q${x2},${y - 8} ${x2 - 9},${y - 2}`} stroke={OUT} strokeWidth="3.6" fill="none" strokeLinecap="round" />
      </>
    );
  }
  return (
    <>
      <path d={`M${x1 - 9},${y - 2} Q${x1},${y - 6} ${x1 + 9},${y - 2}`} stroke={OUT} strokeWidth="3.6" fill="none" strokeLinecap="round" />
      <path d={`M${x2 - 9},${y - 2} Q${x2},${y - 6} ${x2 + 9},${y - 2}`} stroke={OUT} strokeWidth="3.6" fill="none" strokeLinecap="round" />
    </>
  );
}

function Mouth({ pose, cx, y, mouthOpen }: { pose: Pose; cx: number; y: number; mouthOpen?: boolean }) {
  if (mouthOpen) {
    return <ellipse cx={cx} cy={y + 2} rx="7" ry="6" fill="#8C3A46" stroke={OUT} strokeWidth="2.8" />;
  }
  if (pose === "panic") return <ellipse cx={cx} cy={y + 3} rx="9" ry="11" fill="#8C3A46" stroke={OUT} strokeWidth="2.8" />;
  if (pose === "happy") return <path d={`M${cx - 12},${y} Q${cx},${y + 13} ${cx + 12},${y}`} fill="#8C3A46" stroke={OUT} strokeWidth="2.8" />;
  if (pose === "stern") return <path d={`M${cx - 10},${y + 4} Q${cx},${y - 2} ${cx + 10},${y + 4}`} stroke={OUT} strokeWidth="3" fill="none" strokeLinecap="round" />;
  return <path d={`M${cx - 8},${y + 2} Q${cx},${y + 6} ${cx + 8},${y + 2}`} stroke={OUT} strokeWidth="3" fill="none" strokeLinecap="round" />;
}

export const SIM_CHARACTERS: Record<string, SimCharacter> = {
  nurse_mint: {
    name: "พยาบาลมิ้นท์",
    role: "Nurse · IV & Drugs",
    plate: ["#2FA8A0", "#17706B"],
    Placeholder({ pose, mouthOpen }: FaceProps) {
      const skin = "#F6CDA8", scrub = "#2FA8A0", scrubD = "#1E7F79", hair = "#2A2233";
      return (
        <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
          <path d="M28,250 L28,206 Q28,172 100,170 Q172,172 172,206 L172,250 Z" fill={scrub} stroke={OUT} strokeWidth="4" />
          <path d="M76,176 L100,200 L124,176 L118,170 L100,186 L82,170 Z" fill={scrubD} stroke={OUT} strokeWidth="3" />
          <rect x="88" y="150" width="24" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
          <path d="M52,100 Q52,42 100,40 Q148,42 148,100 Q148,140 128,152 Q114,161 100,161 Q86,161 72,152 Q52,140 52,100 Z" fill={skin} stroke={OUT} strokeWidth="4" />
          <circle cx="146" cy="58" r="17" fill={hair} stroke={OUT} strokeWidth="3.4" />
          <path d="M48,106 Q42,44 100,34 Q158,44 152,106 Q150,80 138,72 Q120,88 100,66 Q80,88 62,72 Q50,80 48,106 Z" fill={hair} stroke={OUT} strokeWidth="4" />
          <Brows pose={pose} x1={80} x2={120} y={92} />
          <Eyes pose={pose} x1={80} x2={120} y={104} iris="#4A3728" />
          <Mouth pose={pose} cx={100} y={132} mouthOpen={mouthOpen} />
          <path d="M96,112 L104,112" stroke="#E3AC85" strokeWidth="2.6" strokeLinecap="round" />
        </svg>
      );
    },
  },

  boy_compressor: {
    name: "พี่บอย",
    role: "Compressor",
    plate: ["#3E9E52", "#256936"],
    Placeholder({ pose, mouthOpen }: FaceProps) {
      const skin = "#EEB98C", scrub = "#3E9E52", scrubD = "#2A6E39", hair = "#171A21";
      return (
        <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
          <path d="M22,250 L22,204 Q22,168 100,166 Q178,168 178,204 L178,250 Z" fill={scrub} stroke={OUT} strokeWidth="4" />
          <path d="M74,172 L100,198 L126,172 L119,166 L100,184 L81,166 Z" fill={scrubD} stroke={OUT} strokeWidth="3" />
          <rect x="86" y="148" width="28" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
          <path d="M52,102 Q52,44 100,42 Q148,44 148,102 Q148,140 128,152 Q114,160 100,160 Q86,160 72,152 Q52,140 52,102 Z" fill={skin} stroke={OUT} strokeWidth="4" />
          <path d="M50,92 Q52,40 100,32 Q148,40 150,92 L142,90 L146,74 L132,84 L134,64 L118,78 L114,56 L100,74 L86,56 L82,78 L66,64 L68,84 L54,74 L58,90 Z" fill={hair} stroke={OUT} strokeWidth="4" />
          <rect x="54" y="84" width="92" height="10" rx="5" fill="#E5484D" stroke={OUT} strokeWidth="3" />
          <Brows pose={pose} x1={80} x2={120} y={96} />
          <Eyes pose={pose} x1={80} x2={120} y={107} iris="#33261B" />
          <Mouth pose={pose} cx={100} y={134} mouthOpen={mouthOpen} />
          <path d="M60,120 Q58,126 62,130 M140,120 Q142,126 138,130" stroke="#D89B6C" strokeWidth="2.4" fill="none" />
        </svg>
      );
    },
  },

  fon_defib: {
    name: "หมอฝน",
    role: "Defib / Monitor",
    plate: ["#D98A2B", "#96570F"],
    Placeholder({ pose, mouthOpen }: FaceProps) {
      const skin = "#F6CDA8", scrub = "#D98A2B", scrubD = "#A5610E", hair = "#4A2E1E";
      return (
        <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
          <path d="M28,250 L28,206 Q28,172 100,170 Q172,172 172,206 L172,250 Z" fill={scrub} stroke={OUT} strokeWidth="4" />
          <path d="M76,176 L100,200 L124,176 L118,170 L100,186 L82,170 Z" fill={scrubD} stroke={OUT} strokeWidth="3" />
          <rect x="88" y="150" width="24" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
          <path d="M40,120 Q30,180 44,214 L58,208 Q48,170 56,124 Z" fill={hair} stroke={OUT} strokeWidth="3.6" />
          <path d="M160,120 Q170,180 156,214 L142,208 Q152,170 144,124 Z" fill={hair} stroke={OUT} strokeWidth="3.6" />
          <path d="M52,100 Q52,42 100,40 Q148,42 148,100 Q148,140 128,152 Q114,161 100,161 Q86,161 72,152 Q52,140 52,100 Z" fill={skin} stroke={OUT} strokeWidth="4" />
          <path d="M46,110 Q40,42 100,32 Q160,42 154,110 Q152,78 136,68 Q118,84 100,62 Q82,84 64,68 Q48,78 46,110 Z" fill={hair} stroke={OUT} strokeWidth="4" />
          <Brows pose={pose} x1={80} x2={120} y={92} />
          <Eyes pose={pose} x1={80} x2={120} y={104} iris="#5A3A22" />
          <Mouth pose={pose} cx={100} y={132} mouthOpen={mouthOpen} />
        </svg>
      );
    },
  },

  att_dech: {
    name: "อ.เดช",
    role: "Attending",
    plate: ["#8E4FC8", "#5B2E86"],
    Placeholder({ pose, mouthOpen }: FaceProps) {
      const skin = "#EDBE96", coat = "#F4F6FB", coatD = "#C9D2E4", shirt = "#3C4C86", hair = "#3A3F4B";
      return (
        <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
          <path d="M20,250 L20,206 Q20,168 100,166 Q180,168 180,204 L180,250 Z" fill={coat} stroke={OUT} strokeWidth="4" />
          <path d="M84,168 L100,250 L116,168 Q108,176 100,176 Q92,176 84,168 Z" fill={shirt} stroke={OUT} strokeWidth="3.4" />
          <path d="M100,180 L94,192 L100,236 L106,192 Z" fill="#E5484D" stroke={OUT} strokeWidth="2.6" />
          <path d="M60,170 Q76,186 84,168 L74,250 L36,250 Q28,200 60,170 Z" fill={coat} stroke={OUT} strokeWidth="4" />
          <path d="M140,170 Q124,186 116,168 L126,250 L164,250 Q172,200 140,170 Z" fill={coat} stroke={OUT} strokeWidth="4" />
          <path d="M62,176 L74,250 M138,176 L126,250" stroke={coatD} strokeWidth="3" fill="none" />
          <rect x="88" y="148" width="24" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
          <path d="M54,102 Q54,46 100,44 Q146,46 146,102 Q146,138 127,150 Q113,159 100,159 Q87,159 73,150 Q54,138 54,102 Z" fill={skin} stroke={OUT} strokeWidth="4" />
          <path d="M50,96 Q54,40 100,36 Q146,40 150,96 Q146,66 128,62 Q110,74 100,60 Q90,74 72,62 Q54,66 50,96 Z" fill={hair} stroke={OUT} strokeWidth="4" />
          <path d="M54,72 Q62,58 74,56 L70,66 Z" fill="#9BA3B5" />
          <rect x="64" y="96" width="30" height="22" rx="6" fill="none" stroke={OUT} strokeWidth="3.4" />
          <rect x="106" y="96" width="30" height="22" rx="6" fill="none" stroke={OUT} strokeWidth="3.4" />
          <path d="M94,102 L106,102" stroke={OUT} strokeWidth="3.4" />
          <Eyes pose={pose} x1={79} x2={121} y={107} iris="#3A3228" />
          <Brows pose={pose} x1={79} x2={121} y={90} />
          <Mouth pose={pose} cx={100} y={132} mouthOpen={mouthOpen} />
        </svg>
      );
    },
  },

  patient_generic: {
    name: "ผู้ป่วย",
    role: "Patient",
    plate: ["#7A8699", "#5B6675"],
    Placeholder({ pose, mouthOpen }: FaceProps) {
      const skin = "#EBBE96", gown = "#BFD3DE", gownD = "#93AEBD", hair = "#2A2A30";
      return (
        <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
          <path d="M28,250 L28,206 Q28,172 100,170 Q172,172 172,206 L172,250 Z" fill={gown} stroke={OUT} strokeWidth="4" />
          <path d="M76,176 L100,196 L124,176 L118,170 L100,184 L82,170 Z" fill={gownD} stroke={OUT} strokeWidth="3" />
          <path d="M66,192 L78,192 M122,192 L134,192" stroke={gownD} strokeWidth="3" strokeLinecap="round" />
          <rect x="88" y="150" width="24" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
          <path d="M52,100 Q52,42 100,40 Q148,42 148,100 Q148,140 128,152 Q114,161 100,161 Q86,161 72,152 Q52,140 52,100 Z" fill={skin} stroke={OUT} strokeWidth="4" />
          <path d="M50,98 Q50,46 100,40 Q150,46 150,98 Q146,74 132,70 Q116,82 100,68 Q84,82 68,70 Q54,74 50,98 Z" fill={hair} stroke={OUT} strokeWidth="4" />
          <Brows pose={pose} x1={80} x2={120} y={92} />
          <Eyes pose={pose} x1={80} x2={120} y={104} iris="#3A2C1E" />
          <Mouth pose={pose} cx={100} y={132} mouthOpen={mouthOpen} />
        </svg>
      );
    },
  },
};

export function getCharacter(charId: string): SimCharacter | null {
  return SIM_CHARACTERS[charId] || null;
}

export function characterImageUrl(charId: string, pose: Pose, talking = false): string {
  return `/images/sim/characters/${charId}/${pose}${talking ? "_talk" : ""}.webp`;
}

// ---- ตัวละครจากตาราง sim_characters (เพิ่มผ่านหน้าแอดมิน) ------------------

/** ท่าเคลื่อนไหวตอนยืนบนเวที (loop ตลอดที่ตัวละครแสดง) */
export type CharacterMotion = "none" | "bob" | "sway" | "pulse";
export const CHARACTER_MOTIONS: { id: CharacterMotion; label: string }[] = [
  { id: "none", label: "นิ่ง" },
  { id: "bob", label: "ลอยขึ้นลง" },
  { id: "sway", label: "โยกซ้ายขวา" },
  { id: "pulse", label: "เต้นตุบๆ" },
];

export interface SimDbCharacter {
  slug: string;
  name: string;
  role: string | null;
  plate: [string, string];
  /** key = pose หรือ `${pose}_talk` → public URL ใน Supabase Storage */
  images: Record<string, string>;
  /** บุคลิก/วิธีพูด — ใช้ใน prompt ของ AI */
  personality?: string | null;
  motion?: CharacterMotion;
}

/** ข้อมูลตัวละครแบบรวม (built-in หรือจาก DB) ที่ runner/sprite ใช้ render */
export interface ResolvedCharacter {
  name: string;
  plate: [string, string];
  Placeholder?: SimCharacter["Placeholder"];
  images?: Record<string, string>;
  motion: CharacterMotion;
}

export function resolveCharacter(
  charId: string,
  dbCharacters?: Map<string, SimDbCharacter>,
): ResolvedCharacter | null {
  const builtin = SIM_CHARACTERS[charId];
  if (builtin) {
    return {
      name: builtin.name,
      plate: builtin.plate,
      Placeholder: builtin.Placeholder,
      motion: "none",
    };
  }
  const db = dbCharacters?.get(charId);
  if (db) {
    return { name: db.name, plate: db.plate, images: db.images, motion: db.motion ?? "none" };
  }
  return null;
}

/** placeholder กลางสำหรับตัวละคร DB ที่ยังไม่ได้อัปโหลดรูปครบทุกท่า */
export function GenericPlaceholder({ pose, mouthOpen }: FaceProps) {
  const skin = "#EFC49E", scrub = "#7A8699", scrubD = "#5B6675", hair = "#3A3F4B";
  return (
    <svg viewBox="0 0 200 250" xmlns="http://www.w3.org/2000/svg">
      <path d="M28,250 L28,206 Q28,172 100,170 Q172,172 172,206 L172,250 Z" fill={scrub} stroke={OUT} strokeWidth="4" />
      <path d="M76,176 L100,200 L124,176 L118,170 L100,186 L82,170 Z" fill={scrubD} stroke={OUT} strokeWidth="3" />
      <rect x="88" y="150" width="24" height="26" fill={skin} stroke={OUT} strokeWidth="3.4" />
      <path d="M52,100 Q52,42 100,40 Q148,42 148,100 Q148,140 128,152 Q114,161 100,161 Q86,161 72,152 Q52,140 52,100 Z" fill={skin} stroke={OUT} strokeWidth="4" />
      <path d="M48,100 Q46,44 100,36 Q154,44 152,100 Q148,72 132,66 Q116,82 100,64 Q84,82 68,66 Q52,72 48,100 Z" fill={hair} stroke={OUT} strokeWidth="4" />
      <Brows pose={pose} x1={80} x2={120} y={92} />
      <Eyes pose={pose} x1={80} x2={120} y={104} iris="#4A3728" />
      <Mouth pose={pose} cx={100} y={132} mouthOpen={mouthOpen} />
    </svg>
  );
}
