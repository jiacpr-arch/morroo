# แผนระบบเกม morroo — ยกระดับ Code Blue Sim จาก acls-emr

> เป้าหมาย: สร้างระบบเกมแบบ acls-emr (Code Blue Simulator สไตล์ visual novel + เกมด่านตัดสินใจ) บน morroo
> โดย **ดีกว่า** (data-driven, บันทึกผลลง cloud, ต่อกับ XP/Badge/Leaderboard ที่มีอยู่, AI สร้างเคสได้)
> และ **สวยกว่า** (ธีม ER night ที่จูนเข้ากับ design token ของ morroo, งาน motion/cinematic ที่ประณีตขึ้น)

## 1. สิ่งที่มีอยู่แล้ว (ไม่ต้องสร้างใหม่)

### ฝั่ง acls-emr — ของที่ port มาได้เลย
| ของ | ไฟล์ต้นทาง | หมายเหตุ |
|---|---|---|
| Story engine (เกมตัดสินใจ) | `src/game/storyEngine.js` | pure logic ไม่มี DOM — แปลงเป็น TS ได้ตรง ๆ |
| ระบบตัวละคร + สไปรต์ | `src/game/characters.js`, `CharacterSprite.jsx` | image-first + SVG fallback, ขยับปากได้ |
| จอ ECG แบบ canvas | `src/game/EcgStrip.jsx` | flat/VF/NSR + CPR artifact |
| เสียง (Web Audio ไม่ใช้ไฟล์) | `src/utils/sound.js` | shock/ROSC/metronome/beep |
| เคสตัวอย่าง VF arrest | `src/data/codeBlueScenarios.js` | ใช้เป็น seed เคสแรก |
| เกมด่าน BLS + Final Exam gating | `src/data/blsScenarios.js`, `BLSScenario.jsx` | เป็นแม่แบบเกมด่านแบบปลดล็อก |
| Scoring แบบ AHA | `src/utils/scoring.js` | time-to-shock, epi compliance, CCF% |

### ฝั่ง morroo — โครงสร้างพื้นฐานที่เหนือกว่า acls-emr อยู่แล้ว
- **XP/Level/Badge engine**: `lib/school/xp.ts` (`awardXp`, `awardBadge`, `detectBadges`) + ตาราง `school_xp_events`, `school_badges`
- **Leaderboard + Streak**: `app/(morroo)/school/leaderboard`, `lib/school/streak.ts`
- **Auth จริง** (Supabase Auth + LINE LIFF) — acls-emr เป็น anonymous, เกมใหม่จะผูกผลกับ user จริงได้
- **AI**: `lib/anthropic.ts` — ใช้สร้างเคสใหม่อัตโนมัติได้
- **แม่แบบเกม client component**: `components/school/ChallengeRunner.tsx`, `components/firstaid/ScenarioRunner.tsx`
- **เนื้อหา ACLS อยู่แล้ว**: `app/(morroo)/acls-reader/*` — เกมกลายเป็น "ด่านฝึก" ต่อจากบทเรียนได้ทันที

### จุดอ่อนของ acls-emr ที่รอบนี้จะแก้
1. มีเคสเดียว hardcode (`vf-arrest-01`) เล่นซ้ำเหมือนเดิมทุกครั้ง
2. ผลเกมเก็บแค่ localStorage — ครู/แอดมินมองไม่เห็น, ไม่มี leaderboard
3. ใช้ `dangerouslySetInnerHTML` กับเนื้อเรื่อง — อันตรายเมื่อเปิดให้ AI/แอดมินแต่งเคส
4. แผน v2 (physiology model, scenario authoring) เขียน design doc ไว้แล้วแต่ยังไม่ได้สร้าง (`docs/code-blue-sim-v2-plan.md`) — เราจะสร้างบน morroo แทน

## 2. สถาปัตยกรรมที่เสนอ

```
app/(morroo)/sim/                     ← เกมฮับ (fullscreen ไม่มี Navbar ปกติ)
  page.tsx                            ← server: ดึงรายชื่อเคส + สถิติผู้เล่น
  [scenarioId]/page.tsx               ← server: โหลดเคส → ส่งเข้า client runner
  leaderboard/page.tsx                ← อันดับคะแนนเกม (รวมกับ school leaderboard ได้)

components/sim/
  SimRunner.tsx        ("use client") ← จอเกมหลัก: dialog, choice, HUD, debrief
  CharacterSprite.tsx                 ← port จาก acls-emr (image-first + SVG fallback)
  EcgMonitor.tsx                      ← canvas ECG sweep
  ChoiceOverlay.tsx / DebriefCard.tsx / HpGauge.tsx / InterstitialShout.tsx

lib/sim/
  engine.ts                           ← port storyEngine.js → TypeScript + unit test (Vitest)
  types.ts                            ← SimScenario / SimNode / SimRunResult (zod-validate)
  sound.ts                            ← Web Audio (port จาก acls-emr)
  characters.ts                       ← registry ตัวละคร

lib/supabase/queries-sim.ts / mutations-sim.ts   ← ตามแพทเทิร์น queries-school.ts

app/api/sim/
  runs/route.ts                       ← POST บันทึกผลเล่นจบ → award XP/badge
  generate/route.ts                   ← (เฟส 4) AI สร้างเคสจาก lib/anthropic.ts

supabase/migrations/2026xxxx_sim_game.sql
```

### ตาราง DB ใหม่ (สไตล์เดียวกับ migration เดิม: RLS + idempotent seed)
- `sim_scenarios` — เคสเป็น JSONB (`story` nodes), `slug`, `title_th`, `difficulty`, `status(draft/published)`, `created_by`, `source(manual/ai)`
- `sim_runs` — `user_id`, `scenario_id`, `difficulty`, `grade(S/A/B/C/F)`, `score`, `outcome(rosc/died)`, metrics JSONB (time-to-CPR, time-to-shock, wrong count, etco2 trace), `created_at`
- seed badge ใหม่ใน `school_badges`: `sim_first_rosc`, `sim_grade_s`, `sim_no_mistake`, `sim_all_scenarios`

### กติกาความปลอดภัยของเนื้อหา
- เนื้อเรื่องเป็น **plain text + whitelist markup เอง** (เช่น `**bold**` ผ่าน renderer ของเรา) — **ห้าม** `dangerouslySetInnerHTML`
- Schema ของเคส validate ด้วย zod ก่อน publish (ทั้งเคสที่แอดมินแต่งและ AI สร้าง)

## 3. ทำไม "ดีกว่า" acls-emr

| ด้าน | acls-emr | morroo (แผนนี้) |
|---|---|---|
| จำนวนเคส | 1 เคส hardcode | หลายเคสใน DB, แอดมินเพิ่ม/AI สร้างได้ |
| ผลการเล่น | localStorage | `sim_runs` ใน Supabase ผูก user จริง |
| รางวัล | hi-score ในเครื่อง | XP + Badge + Leaderboard ที่มีอยู่แล้ว |
| การเล่นซ้ำ | เนื้อเรื่องเดิมทุกครั้ง | สุ่มสาเหตุแฝง (H's & T's) + สลับ choice ทำให้แต่ละรอบต่างกัน |
| ครู/แอดมิน | มองไม่เห็นผลเกม | dashboard ดูสถิติต่อเคส/ต่อผู้เรียนได้ (เฟส 4) |
| ความปลอดภัย | innerHTML | renderer ปลอดภัย + zod validation |

## 4. ทำไม "สวยกว่า"

- คงสไตล์ **visual novel ER night shift** (จุดแข็งที่สุดของ acls-emr) แต่จูนใหม่ด้วย token ของ morroo: พื้น navy-teal ไล่เฉดจาก `--color-brand-dark`, accent ทอง/emerald, ฟอนต์ Sarabun
- Motion ประณีตขึ้น: typewriter dialog, speed-line ตอนตะโกน "CODE BLUE!!", screen shake/flash ตอนตอบผิด, stamp เกรดตอน debrief — ทำด้วย CSS keyframes + `tw-animate-css` (เคารพ `prefers-reduced-motion` เหมือนต้นฉบับ)
- Debrief สวยขึ้น: กราฟ EtCO₂ ด้วย recharts (มีใน deps แล้ว) + timeline การตัดสินใจ + ปุ่มแชร์ผลผ่าน `ShareResult` เดิมของ school
- ตัวละครใช้ pipeline image-first เดิม → อัปเกรดเป็นภาพ .webp วาดจริงได้ทีหลังโดยไม่แก้โค้ด
- Mobile-first fullscreen (เกมเดิม lock 460px) + haptics (`navigator.vibrate`)

## 5. เฟสการทำงาน

| เฟส | งาน | ประมาณ |
|---|---|---|
| **0. เตรียม** | `npm install` แล้วอ่าน `node_modules/next/dist/docs/` (Next fork มี breaking changes ต้องยึดตาม docs ในเครื่อง) | 0.5 วัน |
| **1. Engine + DB** | port `storyEngine` → `lib/sim/engine.ts` (TS + Vitest), migration `sim_scenarios`/`sim_runs` + seed เคส VF + badges, `queries-sim.ts`/`mutations-sim.ts` | 1–2 วัน |
| **2. เกม UI** | `SimRunner` + sprite/ECG/sound/HUD/choice/debrief, ธีม scoped, หน้า `/sim` hub | 2–3 วัน |
| **3. Integration** | บันทึก run → `awardXp`/`awardBadge`, leaderboard, การ์ดเข้าเกมใน school hub + acls-reader (หลังสอบผ่าน post-test = ปลดล็อกเกม) | 1 วัน |
| **4. Authoring + AI** | หน้าแอดมินแต่ง/แก้เคส, `POST /api/sim/generate` ใช้ Claude สร้างเคสจากหัวข้อ (VF, PEA, bradycardia, tachycardia…), dashboard สถิติ | 2–3 วัน |
| **5. Polish** | เกมด่านแบบ BLS (staged + Final Exam gating) สำหรับ firstaid, e2e Playwright, reduced-motion audit | 1–2 วัน |

MVP ที่เล่นได้จริง = เฟส 0–3 (ราว 1 สัปดาห์)

## 6. คำถามที่ควรตัดสินใจก่อนเริ่มโค้ด

1. **ตำแหน่งเกม**: `/sim` เป็นส่วนของ morroo หลัก (แนะนำ — ต่อกับ acls-reader และ school XP ได้) หรือฝั่ง firstaid ด้วย?
2. **สิทธิ์เข้าถึง**: เล่นฟรีทุกคน, ฟรี 1 เคสที่เหลือ premium, หรือปลดล็อกหลังเรียนจบบท?
3. **เคสชุดแรก**: เอาแค่ VF arrest จาก acls-emr ก่อน หรือให้ AI ร่างเพิ่มอีก 3–4 เคส (PEA, brady, SVT, torsades) ตั้งแต่เฟสแรก?
