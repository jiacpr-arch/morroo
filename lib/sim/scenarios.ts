// Code Blue Sim — โจทย์ built-in (story-driven decision game)
//
// โครงนี้คือ "ข้อมูลโจทย์" ล้วนๆ — engine อยู่ที่ lib/sim/engine.ts
// ตัวละครอ้างด้วย charId จาก lib/sim/characters.tsx (who) + สีหน้า (pose)
// เน้นคำด้วย **คำเน้น** (ห้ามใช้ HTML — ดู parseEmphasis ใน types.ts)
//
// โจทย์จากแอดมิน/AI จะเก็บใน Supabase (ตาราง sim_scenarios, คอลัมน์ story
// เป็น jsonb หน้าตาเดียวกันนี้) แล้วโหลดมาเล่นรวมกับ built-in ได้เลย

import type { SimScenario } from "./types";

export const vfArrest: SimScenario = {
  slug: "vf-arrest-01",
  title: "CODE BLUE: ภารกิจกู้ชีพ",
  subtitle: "ชายอายุ 58 ปี เจ็บหน้าอกร้าวลงแขนซ้าย 30 นาที ล้มลงหมดสติต่อหน้าคุณ",
  difficultyTag: "basic",

  story: [
    { say: { who: "nurse_mint", pose: "panic", text: "อาจารย์!! คนไข้เตียง 2 ล้มลงค่ะ!! เมื่อกี้ยังนั่งคุยอยู่เลย!" }, t: 5 },
    { inter: "CODE BLUE!!", drama: "red", t: 0 },
    { say: { who: "att_dech", pose: "stern", text: "ทั้งห้องหันมาที่คุณ… **คุณคือ Team Leader** — คำสั่งแรกของคุณจะกำหนดทุกอย่าง" }, t: 5 },
    {
      choice: {
        q: "คำสั่งแรกของคุณ",
        options: [
          {
            tgt: "YOU", label: "ตรวจการตอบสนอง + เรียกทีม ขอ crash cart", ok: true,
            then: [{ say: { who: "nurse_mint", pose: "talk", text: "เขย่าเรียก… **ไม่ตอบสนองค่ะ!** Crash cart กำลังมา!" }, t: 10 }],
          },
          { tgt: "CPR", label: "กดหน้าอกทันที ไม่ต้องประเมิน", ok: false, why: "ยังไม่ยืนยันว่า arrest — ถ้าเป็นแค่เป็นลม การกดหน้าอกทำอันตรายได้" },
          { tgt: "DRUG", label: "ฉีด Epinephrine ทันที", ok: false, why: "ยังไม่รู้ด้วยซ้ำว่าหัวใจหยุดเต้น — ประเมินก่อนเสมอ" },
        ],
      },
    },
    {
      choice: {
        q: "ไม่ตอบสนอง หายใจเฮือก — ต่อเลย",
        options: [
          {
            tgt: "YOU", label: "คลำ carotid pulse ไม่เกิน 10 วินาที", ok: true,
            then: [
              { inter: "ไม่มีชีพจร!!", drama: "red", t: 8, fx: { alarm: true } },
              { say: { who: "att_dech", pose: "stern", text: "Cardiac arrest ยืนยันแล้ว… นาฬิกาสมองของผู้ป่วยเริ่มนับถอยหลัง **ทุกวินาทีที่ไม่กด สมองตายเพิ่ม**" }, t: 4 },
            ],
          },
          { tgt: "AIRWAY", label: "ฟังเสียงปอดละเอียดๆ สัก 1 นาที", ok: false, why: "นานเกินไป — ทุกนาทีที่ช้า โอกาสรอดหายไป ~10%" },
          { tgt: "MONITOR", label: "ติด 12-lead ECG ก่อน", ok: false, why: "12-lead รอได้ ชีพจรรอไม่ได้" },
        ],
      },
    },
    {
      choice: {
        q: "ทีม 4 คนพร้อม — สั่งใครทำอะไร",
        options: [
          {
            tgt: "CPR", label: "พี่บอย! กดหน้าอกเลย ลึก 5-6 ซม. 100-120/นาที", ok: true,
            then: [{ say: { who: "boy_compressor", pose: "talk", text: "รับทราบครับ! **เริ่มกด!** หนึ่ง-สอง-สาม-สี่…", fx: { cpr: true, firstCPR: true } }, t: 10 }],
          },
          { tgt: "DEFIB", label: "รอเครื่อง defib มาก่อนค่อยเริ่ม", ok: false, why: "ห้ามรอเด็ดขาด — สมองขาดออกซิเจนทุกวินาที", worsen: true },
          { tgt: "AIRWAY", label: "หยุดทุกอย่างเพื่อใส่ท่อช่วยหายใจ", ok: false, why: "CPR มาก่อน advanced airway เสมอในนาทีแรก" },
        ],
      },
    },
    { say: { who: "fon_defib", pose: "talk", text: "Crash cart มาแล้วค่ะ! เครื่อง defib พร้อม!" }, t: 15 },
    {
      choice: {
        q: "ใช้ crash cart ยังไง",
        options: [
          {
            tgt: "MONITOR", label: "แปะ pads ดู rhythm — หยุดกดให้สั้นที่สุด", ok: true,
            then: [
              { inter: "VF — SHOCKABLE!!", drama: "red", t: 8, fx: { rhythm: "vf" } },
              { say: { who: "fon_defib", pose: "panic", text: "จอขึ้น **Ventricular Fibrillation!** หัวใจสั่นพลิ้ว ไม่บีบเลือดเลยค่ะ!" }, t: 4 },
            ],
          },
          { tgt: "DRUG", label: "เปิด IV ฉีด Epi ก่อนดูจอ", ok: false, why: "ต้องรู้ rhythm ก่อน — shockable หรือไม่ เปลี่ยนแผนทั้งหมด" },
          { tgt: "YOU", label: "สั่งหยุดกดนานๆ เพื่อดูจอชัดๆ", ok: false, why: "หยุดกดให้สั้นที่สุด — hands-off time คือศัตรูตัวจริง", worsen: true },
        ],
      },
    },
    {
      choice: {
        q: "VF — เครื่อง defib อยู่ในมือ",
        options: [
          {
            tgt: "DEFIB", label: "Charge 200 J — กดหน้าอกต่อระหว่างรอไฟ", ok: true,
            then: [{ say: { who: "fon_defib", pose: "talk", text: "Charging… **200 จูล พร้อมค่ะ!** เสียงหวีดของเครื่องดังขึ้นเรื่อยๆ" }, t: 8 }],
          },
          { tgt: "DEFIB", label: "ลองพลังงานต่ำ 50 J ก่อน", ok: false, why: "ต่ำเกินไป — VF ผู้ใหญ่ใช้ 120-200 J (biphasic)" },
          { tgt: "DRUG", label: "ให้ Amiodarone ก่อนค่อย shock", ok: false, why: "ไฟฟ้ามาก่อนยาเสมอใน shockable rhythm" },
        ],
      },
    },
    {
      choice: {
        q: "CHARGED — วินาทีชี้ชะตา",
        options: [
          {
            tgt: "DEFIB", label: '"CLEAR!!" กวาดตารอบเตียง — SHOCK!', ok: true,
            then: [
              { inter: "SHOCK!!", t: 5, fx: { shock: true } },
              { say: { who: "boy_compressor", pose: "panic", text: "ตัวผู้ป่วยกระตุกขึ้นจากเตียง… **กดต่อเลยไหมครับ?!**" }, t: 4 },
            ],
          },
          { tgt: "DEFIB", label: "Shock เลย ไม่เสียเวลา clear", ok: false, why: "ไฟ 200 J ลงคนที่ยังแตะเตียง = ทีมของคุณ arrest แทน", worsen: true },
          { tgt: "YOU", label: "ถือไฟค้างไว้ รอดูจออีก 30 วิ", ok: false, why: "ไฟพร้อมต้องปล่อยทันที — VF ยิ่งค้างนานยิ่งดื้อไฟ" },
        ],
      },
    },
    {
      choice: {
        q: "ทันทีหลัง shock",
        options: [
          {
            tgt: "CPR", label: "กดต่อทันที 2 นาที — ไม่เช็คชีพจร", ok: true,
            then: [
              { say: { who: "nurse_mint", pose: "talk", text: "IV ได้แล้วค่ะ! **เส้นพร้อมให้ยา!**", fx: { cpr: true } }, t: 6 },
              { skip: "CPR ต่อเนื่อง — 2 นาทีผ่านไป", t: 110 },
              { say: { who: "fon_defib", pose: "panic", text: "Rhythm check… **ยัง VF ค่ะ!** ดื้อไฟ!" }, t: 6 },
            ],
          },
          { tgt: "YOU", label: "หยุดคลำชีพจรเดี๋ยวนี้", ok: false, why: "หัวใจหลัง shock ยังอ่อนแรง — CPR ต่อทันที 2 นาทีก่อนเช็ค" },
          { tgt: "DRUG", label: "หยุดรอดูผลของไฟก่อน", ok: false, why: 'ไม่มีจังหวะไหนที่ "หยุดรอ" ใน cardiac arrest', worsen: true },
        ],
      },
    },
    {
      choice: {
        q: "VF ดื้อไฟ — รอบนี้ต้องครบชุด",
        options: [
          {
            tgt: "DEFIB", label: "Shock 200 J + Epinephrine 1 mg IV ตามทันที", ok: true,
            then: [
              { inter: "SHOCK!!", t: 5, fx: { shock: true } },
              { say: { who: "nurse_mint", pose: "talk", text: '**"Epi 1 mg in!"** เสียงขานยาดังทั่วห้อง — เข็มที่สองพร้อม', fx: { epi: true, cpr: true } }, t: 6 },
              { skip: "CPR ต่อเนื่อง — 2 นาทีผ่านไป", t: 110 },
              { say: { who: "fon_defib", pose: "stern", text: "Rhythm check… ยัง VF! พี่บอยเหงื่อหยดลงพื้นแล้วค่ะ" }, t: 6 },
            ],
          },
          { tgt: "DRUG", label: "Atropine 1 mg", ok: false, why: "Atropine ไม่มีที่ใน VF — ใช้ใน bradycardia" },
          { tgt: "DRUG", label: "Adenosine 6 mg push เร็วๆ", ok: false, why: "Adenosine ใช้ใน SVT ที่มีชีพจร — ไม่ใช่ที่นี่" },
        ],
      },
    },
    {
      choice: {
        q: "ยาตัวถัดไปของคุณ",
        options: [
          {
            tgt: "DRUG", label: "Shock ครั้งที่ 3 + Amiodarone 300 mg IV bolus", ok: true,
            then: [
              { inter: "SHOCK!!", t: 5, fx: { shock: true } },
              { say: { who: "nurse_mint", pose: "talk", text: '"Amio 300 in!" — สลับคนกด **คุณภาพการกดต้องไม่ตก**', fx: { cpr: true } }, t: 6 },
              { skip: "CPR ต่อเนื่อง — 2 นาทีผ่านไป", t: 110 },
              { say: { who: "fon_defib", pose: "panic", text: "Rhythm check… เดี๋ยวนะ… จอเปลี่ยน… **คลื่นเรียบสม่ำเสมอ… มีชีพจรค่ะ!!**" }, t: 6 },
            ],
          },
          { tgt: "DRUG", label: "Epinephrine 5 mg ให้แรงขึ้นไปเลย", ok: false, why: "ขนาดผิด — Epi ใน arrest คือ 1 mg เสมอ ทุก 3-5 นาที" },
          { tgt: "YOU", label: "ประกาศยุติการกู้ชีพ", ok: false, why: "เร็วเกินไปมาก — VF ที่ยังสั่นคือหัวใจที่ยังสู้อยู่", worsen: true },
        ],
      },
    },
    {
      choice: {
        q: "วินาทีสุดท้าย — คุณจะทำอะไร",
        options: [
          {
            tgt: "YOU", label: "ROSC! หยุด CPR — post-arrest care + 12-lead ด่วน", ok: true,
            then: [
              { inter: "ROSC!!", green: true, t: 5, fx: { rosc: true } },
              { say: { who: "att_dech", pose: "happy", text: "BP 110/70 กลับมาแล้ว… ทั้งห้องถอนหายใจพร้อมกัน **ส่งต่อ Cath lab — เคสนี้เป็นของคุณ**" }, t: 5 },
            ],
          },
          { tgt: "CPR", label: "กดต่ออีก 2 นาทีเผื่อไว้", ok: false, why: "มีชีพจรแล้ว — การกดต่อทำร้ายหัวใจที่เพิ่งกลับมา" },
          { tgt: "DEFIB", label: "Shock ซ้ำอีกทีให้ชัวร์", ok: false, why: "Shock จังหวะปกติ = ทำให้ arrest ซ้ำ อันตรายที่สุด", worsen: true },
        ],
      },
    },
    { end: true },
  ],
};

// เกมเคส (Long Case decision game) — เนื้อหาจากเคส Testicular Torsion
// แปลงเป็นเส้นเรื่องตัดสินใจ: ซักประวัติ → ตรวจร่างกาย → investigation →
// วินิจฉัย → รักษา → debrief teaching points. ไม่ใช้ fx ใดๆ (ไม่มี CPR/shock/rhythm)
export const lcTorsion: SimScenario = {
  slug: "lc-testicular-torsion-01",
  title: "LONG CASE: ปวดท้องร้าวลงอัณฑะ",
  subtitle: "ชาย 19 ปี ปวดท้องน้อยและอัณฑะซ้ายเฉียบพลัน 3 ชม. — คุณคือแพทย์เวร ER",
  difficultyTag: "basic",
  category: "longcase",

  story: [
    { say: { who: "nurse_mint", pose: "panic", text: "คุณหมอคะ! คนไข้ชายอายุ 19 ปี มา ER ด้วย**ปวดอัณฑะซ้ายเฉียบพลัน 3 ชั่วโมง** ดูเจ็บทรมานมากค่ะ" }, t: 5 },
    { inter: "ACUTE SCROTUM", t: 0 },
    { say: { who: "nurse_mint", pose: "talk", text: "V/S: BP 125/75, HR 105, RR 18, T 37.2°C, O₂ sat 99% ค่ะ — ไม่มีไข้" }, t: 5 },
    { say: { who: "att_dech", pose: "stern", text: "คุณคือแพทย์เวร ER คืนนี้ เคสนี้**เวลาคือทุกอย่าง** — ซักประวัติให้ตรงจุด" }, t: 4 },

    {
      choice: {
        q: "จะถามผู้ป่วยเรื่องอะไรก่อน",
        options: [
          {
            tgt: "ASK", label: "ลักษณะและจังหวะการปวด เริ่มตอนไหน เคยเป็นมาก่อนไหม", ok: true,
            then: [{ say: { who: "patient_generic", pose: "panic", text: "ปวดขึ้นมา**ทันที**ตอนตื่นนอนครับ ปวดมากขึ้นเรื่อยๆ… เมื่อ 2 เดือนก่อนเคยปวดแบบนี้แล้ว**หายเอง**" }, t: 8 }],
          },
          { tgt: "ASK", label: "ซักประวัติเพศสัมพันธ์และโรคติดต่อทางเพศอย่างละเอียดก่อน", ok: false, why: "ไม่ผิดที่จะถาม แต่ยังไม่แยกภาวะฉุกเฉิน — onset เฉียบพลันสำคัญกว่าในนาทีนี้" },
          { tgt: "ASK", label: "ถามว่าวันนี้กินอะไรมาบ้าง สงสัยอาหารเป็นพิษ", ok: false, why: "อาการนำอยู่ที่อัณฑะ ไม่ใช่ทางเดินอาหาร — คำถามนี้ไม่ช่วยแยกโรค" },
        ],
      },
    },
    {
      choice: {
        q: "ถามอาการร่วมอะไรต่อเพื่อแยกโรค",
        options: [
          {
            tgt: "ASK", label: "มีปัสสาวะแสบขัด ไข้ หรือปัสสาวะผิดปกติไหม", ok: true,
            then: [{ say: { who: "patient_generic", pose: "talk", text: "**ไม่มี**ปัสสาวะแสบขัด ไม่มีไข้ครับ แต่คลื่นไส้ อาเจียนไป 1 ครั้ง" }, t: 7 }],
          },
          { tgt: "ASK", label: "ซักประวัติการผ่าตัดในอดีตแบบละเอียด 10 นาที", ok: false, worsen: true, why: "เสียเวลาเกินไป — ทุกนาทีที่ผ่านไป โอกาสรักษาอัณฑะลดลง" },
          { tgt: "LAB", label: "ยังไม่ต้องถามต่อ รีบส่งไปทำ CT whole abdomen", ok: false, why: "ยังไม่ถึงขั้นนั้น และ CT ไม่ใช่ investigation แรกของ acute scrotum" },
        ],
      },
    },

    {
      choice: {
        q: "จะเริ่มตรวจร่างกายส่วนไหนก่อน",
        options: [
          {
            tgt: "PE", label: "ตรวจอวัยวะเพศและอัณฑะ (GU exam)", ok: true,
            then: [{ say: { who: "att_dech", pose: "stern", text: "อัณฑะซ้ายบวม แดง กดเจ็บมาก และ**อยู่สูงกว่าปกติ (high-riding testis)**" }, t: 6 }],
          },
          { tgt: "PE", label: "ตรวจหน้าท้องละเอียดหาไส้ติ่งอักเสบก่อน", ok: false, why: "อาการนำอยู่ที่อัณฑะ — GU exam คือสิ่งที่ต้องตรวจก่อน" },
          { tgt: "PE", label: "ตรวจระบบประสาทเต็มรูปแบบ", ok: false, why: "ไม่เกี่ยวกับภาวะนี้ เสียเวลาโดยเปล่าประโยชน์" },
        ],
      },
    },
    {
      choice: {
        q: "อยากยืนยันการวินิจฉัย ตรวจอะไรต่อ",
        options: [
          {
            tgt: "PE", label: "ตรวจ Cremasteric reflex ทั้งสองข้าง", ok: true,
            then: [{ say: { who: "att_dech", pose: "stern", text: "**Cremasteric reflex ซ้ายหายไป** — ข้างขวายังปกติ นี่คือ classic sign" }, t: 6 }],
          },
          { tgt: "PE", label: "ทำ Prehn's sign ถ้ายกแล้วปวดลดลงก็ตัด torsion ออกได้", ok: false, why: "Prehn's sign ไม่ไว/ไม่จำเพาะพอจะตัด torsion ออก — ห้ามใช้ตัดสิน" },
          { tgt: "PE", label: "คลำต่อมน้ำเหลืองขาหนีบอย่างเดียว", ok: false, why: "ไม่ช่วยแยก torsion จาก epididymo-orchitis" },
        ],
      },
    },

    {
      choice: {
        q: "จะสั่ง investigation อะไร",
        options: [
          {
            tgt: "LAB", label: "ส่ง UA + CBC และสั่ง Scrotal Doppler US ควบคู่ปรึกษาศัลย์", ok: true,
            then: [{ say: { who: "nurse_mint", pose: "talk", text: "UA ปกติค่ะ ไม่มีเม็ดเลือดขาวในปัสสาวะ, CBC: WBC 11,200 — ติดต่อศัลย์ให้แล้วค่ะ" }, t: 7 }],
          },
          { tgt: "LAB", label: "สั่ง urine culture แล้วรอผล 48 ชม. ก่อนตัดสินใจ", ok: false, worsen: true, why: "ภาวะฉุกเฉินรอไม่ได้ — 48 ชม. อัณฑะตายแน่นอน" },
          { tgt: "LAB", label: "สั่ง CT abdomen ทั้งระบบเพื่อความชัวร์", ok: false, why: "ไม่ใช่ investigation ของ acute scrotum เสียทั้งเวลาและรังสี" },
        ],
      },
    },
    {
      choice: {
        q: "Doppler US ต้องรอคิวอีก 2 ชั่วโมง — จะทำยังไง",
        options: [
          {
            tgt: "CONSULT", label: "ไม่รอผล US — clinical dx ชัด ปรึกษาศัลย์ explore ทันที", ok: true,
            then: [{ say: { who: "att_dech", pose: "happy", text: "ถูกต้อง! **high clinical suspicion ต้องผ่าตัด ไม่รอ imaging** — US อาจให้ false negative ได้" }, t: 6 }],
          },
          { tgt: "LAB", label: "รอผล Doppler US ให้ชัวร์ก่อนค่อยตัดสินใจผ่าตัด", ok: false, worsen: true, why: "อันตราย — ถ้า suspicion สูง การรอ imaging ทำให้เลย golden period 6 ชม." },
          { tgt: "MGMT", label: "ให้ยาแก้ปวดแล้วนัดทำ US พรุ่งนี้เช้า", ok: false, worsen: true, why: "พลาดร้ายแรง — พรุ่งนี้อัณฑะตายแล้ว" },
        ],
      },
    },

    {
      choice: {
        q: "การวินิจฉัยที่น่าจะเป็นที่สุด",
        options: [
          {
            tgt: "DX", label: "Testicular torsion (อัณฑะบิดขั้ว)", ok: true,
            then: [{ say: { who: "att_dech", pose: "happy", text: "ใช่ — onset เฉียบพลัน + high-riding testis + cremasteric reflex หาย + ประวัติเคยเป็นแล้วหาย = **torsion ชัดเจน**" }, t: 6 }],
          },
          { tgt: "DX", label: "Epididymo-orchitis", ok: false, why: "มักค่อยเป็นค่อยไป มีไข้/ปัสสาวะแสบขัด และ cremasteric reflex ยังอยู่ — ไม่ตรงเคสนี้" },
          { tgt: "DX", label: "Incarcerated inguinal hernia", ok: false, why: "จะคลำได้ก้อนที่ขาหนีบและมีอาการลำไส้อุดตันร่วม — ไม่ตรง" },
        ],
      },
    },

    {
      choice: {
        q: "การรักษาที่ถูกต้อง",
        options: [
          {
            tgt: "MGMT", label: "Emergency surgical exploration + detorsion ภายใน 6 ชม. และ bilateral orchiopexy", ok: true,
            then: [{ say: { who: "att_dech", pose: "stern", text: "ถูกต้อง — เข้าห้องผ่าตัดด่วน ยิ่งเร็วยิ่งดี **รักษาอัณฑะได้ >90% ถ้าภายใน 6 ชม.**" }, t: 6 }],
          },
          { tgt: "MGMT", label: "ให้ยาปฏิชีวนะแล้วนัด follow up 1 สัปดาห์", ok: false, worsen: true, why: "นี่ไม่ใช่การติดเชื้อ — ให้ ATB แล้วปล่อยกลับ = เสียอัณฑะ" },
          { tgt: "MGMT", label: "ประคบเย็นแล้วให้กลับบ้าน", ok: false, worsen: true, why: "เป็นภาวะฉุกเฉินผ่าตัด ห้ามให้กลับบ้านเด็ดขาด" },
        ],
      },
    },
    {
      choice: {
        q: "ทำไมต้อง orchiopexy ทั้งสองข้าง",
        options: [
          {
            tgt: "MGMT", label: "เพราะ bell-clapper deformity เป็น bilateral เสี่ยงบิดอีกข้าง", ok: true,
            then: [{ say: { who: "att_dech", pose: "happy", text: "เยี่ยม — จึงต้อง fix ทั้งสองข้างในคราวเดียว เพื่อป้องกัน contralateral torsion ในอนาคต" }, t: 6 }],
          },
          { tgt: "MGMT", label: "ไม่จำเป็น fix แค่ข้างที่บิดพอ", ok: false, why: "พลาดจุดสำคัญ — อีกข้างเสี่ยงบิดเพราะ anatomy ผิดปกติทั้งคู่" },
          { tgt: "MGMT", label: "ต้องตัดอัณฑะทั้งสองข้างทิ้ง", ok: false, why: "ตัด (orchiectomy) เฉพาะเมื่อเนื้อตายแล้วเท่านั้น ไม่ใช่ทำเป็น routine" },
        ],
      },
    },

    { say: { who: "att_dech", pose: "happy", text: "เคสนี้คุณจัดการได้ดีมาก — Testicular torsion คือ**ภาวะฉุกเฉินที่ต้องผ่าตัดใน 6 ชม.** อย่าให้ imaging มาถ่วงเวลา" }, t: 4 },
    { say: { who: "att_dech", pose: "talk", text: "จำ classic signs ให้ขึ้นใจ: **high-riding testis + cremasteric reflex หาย** และประวัติเจ็บแล้วหาย (intermittent torsion) = สัญญาณเตือนต้อง fix ป้องกัน" }, t: 4 },
    { inter: "เคสสำเร็จ!!", green: true, t: 0 },
    { end: true },
  ],
};

export const SIM_SCENARIOS: SimScenario[] = [vfArrest, lcTorsion];

export function getBuiltinScenario(slug: string): SimScenario | null {
  return SIM_SCENARIOS.find((s) => s.slug === slug) ?? null;
}
