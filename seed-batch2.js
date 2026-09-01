const { createClient } = require("@supabase/supabase-js");

const supabase = createClient(
  "https://knxidnzexqehusndquqg.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtueGlkbnpleHFlaHVzbmRxdXFnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDM2OTA3NiwiZXhwIjoyMDg5OTQ1MDc2fQ.t47-1W_kcZL9215ZA9vFEf51sptFWMyUsdHrOCkzPCQ"
);

// ============================================================
// 5 Medical Exams — Batch 2
// ============================================================

const exams = [
  {
    title: "โรคซึมเศร้า (Major Depressive Disorder)",
    category: "จิตเวชศาสตร์",
    difficulty: "medium",
    is_free: true,
    status: "published",
    publish_date: "2026-04-06",
    created_by: "admin",
    parts: [
      {
        part_number: 1,
        title: "ส่วนที่ 1: การซักประวัติทางจิตเวชและ Mental Status Examination",
        scenario:
          "หญิงไทย อายุ 35 ปี อาชีพพนักงานบริษัท มาพบแพทย์ด้วยอาการอารมณ์ซึมเศร้า นอนไม่หลับ เบื่ออาหาร น้ำหนักลด 4 กิโลกรัมใน 2 เดือน เริ่มมีความคิดอยากตาย สามีพามา\n\nสัญญาณชีพ: BT 36.5°C, HR 78/min, BP 118/72 mmHg, RR 16/min\nน้ำหนัก 48 kg (ลดจาก 52 kg), BMI 18.7\n\nMSE: Appearance - แต่งตัวสะอาดแต่ดูเหนื่อยล้า ไม่แต่งหน้า, Behavior - psychomotor retardation เล็กน้อย eye contact ไม่ดี, Speech - slow rate, low tone, Mood - 'รู้สึกเบื่อทุกอย่าง ไม่อยากมีชีวิตอยู่', Affect - constricted, congruent with depressed mood, Thought process - logical but slow, Thought content - passive suicidal ideation ไม่มี plan, Perception - ไม่มี hallucination, Cognition - intact, Insight - fair",
        question:
          "จงระบุ psychiatric history ที่สำคัญที่ต้องซักเพิ่มเติม และแปลผล MSE ว่าสนับสนุน diagnosis อะไร",
        answer:
          "Psychiatric history ที่ต้องซักเพิ่มเติม:\n1. ประวัติ depressive symptoms ตาม DSM-5: อารมณ์ซึมเศร้า, anhedonia, sleep disturbance (insomnia/hypersomnia), appetite/weight change, fatigue, psychomotor changes, worthlessness/guilt, concentration difficulties, suicidal ideation\n2. Duration และ onset: อาการเริ่มเมื่อไร มี precipitating factors หรือไม่\n3. ประวัติ manic/hypomanic episodes: เพื่อแยก Bipolar disorder\n4. ประวัติ substance use: alcohol, drugs\n5. Past psychiatric history: เคยมีอาการแบบนี้มาก่อนหรือไม่\n6. Family psychiatric history: โดยเฉพาะ mood disorders, suicide\n7. ประวัติ medical illness: hypothyroidism, anemia ที่อาจเลียนแบบ depression\n8. Suicide risk assessment เพิ่มเติม: previous attempts, access to means, protective factors\n\nการแปลผล MSE:\n- Psychomotor retardation, poor eye contact → neurovegetative signs ของ depression\n- Slow speech, constricted affect → สอดคล้องกับ depressed mood\n- Passive suicidal ideation without plan → moderate suicide risk\n- Intact cognition, fair insight → สามารถ engage ใน outpatient treatment ได้\n- สนับสนุน diagnosis: Major Depressive Disorder, single episode, moderate to severe severity",
        key_points: [
          "ต้องซักประวัติ manic/hypomanic episodes ทุกรายเพื่อแยก Bipolar disorder",
          "Passive suicidal ideation ต้องประเมิน risk factors เพิ่มเติมเสมอ",
          "MSE เป็นเครื่องมือสำคัญในการประเมินผู้ป่วยจิตเวช ต้องบันทึกครบทุกหัวข้อ",
          "Neurovegetative symptoms (นอนไม่หลับ เบื่ออาหาร น้ำหนักลด) สนับสนุน biological depression",
        ],
        time_minutes: 10,
      },
      {
        part_number: 2,
        title: "ส่วนที่ 2: การประเมิน PHQ-9 และ Suicide Risk Assessment",
        scenario:
          "ผลการประเมิน PHQ-9:\n1. Little interest or pleasure: 3 (nearly every day)\n2. Feeling down, depressed: 3\n3. Trouble sleeping: 3\n4. Feeling tired: 2 (more than half the days)\n5. Poor appetite: 3\n6. Feeling bad about yourself: 2\n7. Trouble concentrating: 2\n8. Moving or speaking slowly: 2\n9. Thoughts of being better off dead: 2\nTotal PHQ-9 = 22/27 (Severe depression)\n\nSuicide risk assessment:\n- Passive suicidal ideation มา 2 สัปดาห์ 'คิดว่าถ้าตายไปคงดี'\n- ไม่มี specific plan หรือ intent\n- ไม่มี previous suicide attempts\n- Risk factors: หญิง, อายุ 30-40, social isolation (ห่างเหินเพื่อน), ทะเลาะกับสามีบ่อย\n- Protective factors: มีลูก 2 คน, สามียังดูแล, ไม่มี access to lethal means, มี religious belief",
        question:
          "จงแปลผล PHQ-9 และประเมินระดับ suicide risk พร้อมบอกแผนการดูแลที่เหมาะสม",
        answer:
          "การแปลผล PHQ-9:\n- Total score 22/27 = Severe depression\n- PHQ-9 scoring: 0-4 (minimal), 5-9 (mild), 10-14 (moderate), 15-19 (moderately severe), 20-27 (severe)\n- ข้อ 9 ได้ 2 คะแนน (suicidal ideation more than half the days) → ต้อง assess เพิ่ม\n\nSuicide risk assessment:\n- Risk level: MODERATE\n- มี suicidal ideation แต่ไม่มี plan/intent → ลด risk ลงจาก high\n- Risk factors ที่มี: depressed mood, social isolation, interpersonal conflict\n- Protective factors ที่แข็งแรง: มีลูก (reason to live), มีสามีดูแล, religious belief, ไม่มี access to lethal means\n- Columbia Suicide Severity Rating Scale (C-SSRS): Category 2 - Non-specific active suicidal thoughts\n\nแผนการดูแล:\n1. Safety planning: สร้าง safety plan ร่วมกับผู้ป่วย\n   - Warning signs ที่ต้องระวัง\n   - Coping strategies\n   - Contact numbers (สายด่วนสุขภาพจิต 1323)\n2. สามารถรักษาแบบ outpatient ได้ เพราะไม่มี imminent risk\n3. นัดติดตามภายใน 1 สัปดาห์\n4. แจ้งสามีเรื่อง warning signs และ crisis management\n5. ถ้าอาการแย่ลง (มี plan, intent) → admit ทันที\n6. เริ่มยา antidepressant + psychotherapy",
        key_points: [
          "PHQ-9 >= 20 จัดเป็น severe depression ต้องพิจารณาเริ่มยาร่วมกับ psychotherapy",
          "ข้อ 9 ของ PHQ-9 เกี่ยวกับ suicidal ideation ต้อง assess เพิ่มเสมอ",
          "Safety planning เป็นขั้นตอนสำคัญในผู้ป่วยที่มี suicidal ideation",
          "Protective factors ช่วยลดความเสี่ยง แต่ไม่ได้หมายความว่าจะไม่ attempt suicide",
        ],
        time_minutes: 10,
      },
      {
        part_number: 3,
        title: "ส่วนที่ 3: การวินิจฉัยตามเกณฑ์ DSM-5",
        scenario:
          "จากการซักประวัติเพิ่มเติม:\n- อาการเริ่มมา 2 เดือนหลังจากย้ายงานใหม่ที่กดดันมาก\n- มีอาการครบ: depressed mood, anhedonia, insomnia (initial + middle insomnia), decreased appetite with weight loss 4 kg, fatigue, psychomotor retardation, feelings of worthlessness, poor concentration, passive suicidal ideation\n- ไม่เคยมี manic/hypomanic episodes\n- ไม่มี substance use\n- ไม่เคยมีประวัติ psychiatric illness มาก่อน\n- Family history: มารดาเคยมีอาการซึมเศร้าหลังคลอด\n\nผล lab (เพื่อแยก organic causes):\n- CBC: ปกติ, Hb 12.8 g/dL\n- TFT: TSH 2.1 mIU/L (ปกติ 0.4-4.0), Free T4 1.2 ng/dL (ปกติ)\n- Fasting glucose: 92 mg/dL\n- Vitamin B12, Folate: ปกติ",
        question:
          "จงวินิจฉัยโรคตามเกณฑ์ DSM-5 อย่างเป็นระบบ พร้อมระบุ severity และ differential diagnosis",
        answer:
          "การวินิจฉัยตามเกณฑ์ DSM-5 — Major Depressive Disorder:\n\nCriterion A: มี >= 5 อาการใน 2 สัปดาห์ (ต้องมีข้อ 1 หรือ 2 อย่างน้อย 1 ข้อ):\n1. ✓ Depressed mood — อารมณ์ซึมเศร้า\n2. ✓ Anhedonia — เบื่อทุกอย่าง ไม่สนใจสิ่งที่เคยชอบ\n3. ✓ Weight loss — ลด 4 kg ใน 2 เดือน (>5% body weight change)\n4. ✓ Insomnia — initial + middle insomnia\n5. ✓ Psychomotor retardation — observed ใน MSE\n6. ✓ Fatigue — เหนื่อยล้าตลอดเวลา\n7. ✓ Worthlessness — รู้สึกตัวเองไร้ค่า\n8. ✓ Poor concentration — สมาธิแย่ลง\n9. ✓ Suicidal ideation — passive type\nรวม 9/9 อาการ ✓\n\nCriterion B: อาการทำให้เกิด significant distress หรือ impairment ในการทำงานและสัมพันธภาพ ✓\nCriterion C: ไม่ได้เกิดจาก substance หรือ medical condition ✓ (lab ปกติ)\nCriterion D: ไม่สามารถอธิบายด้วย psychotic disorders ✓\nCriterion E: ไม่เคยมี manic/hypomanic episode ✓\n\nDiagnosis: Major Depressive Disorder, Single Episode, Severe without psychotic features (F32.2)\n\nSeverity: Severe — เพราะมีอาการเกือบครบทุกข้อ มี suicidal ideation และ functional impairment มาก\n\nDifferential diagnosis ที่แยกออกแล้ว:\n1. Bipolar disorder — ไม่มี manic/hypomanic episodes\n2. Hypothyroidism — TFT ปกติ\n3. Anemia — CBC ปกติ\n4. Adjustment disorder — อาการรุนแรงเกินและมี criteria ครบ MDD\n5. Persistent depressive disorder (Dysthymia) — อาการเริ่มมา 2 เดือน ไม่ถึง 2 ปี",
        key_points: [
          "DSM-5 ต้องมีอย่างน้อย 5 อาการใน 2 สัปดาห์ โดยต้องมี depressed mood หรือ anhedonia",
          "ต้องส่ง lab แยก organic causes ทุกราย เช่น TFT, CBC, glucose",
          "Severity แบ่งเป็น mild, moderate, severe ตามจำนวนอาการและ functional impairment",
          "ต้องแยก Bipolar disorder ก่อนเริ่มยา antidepressant เสมอ",
        ],
        time_minutes: 10,
      },
      {
        part_number: 4,
        title: "ส่วนที่ 4: การเริ่มยา SSRI และ Pharmacotherapy",
        scenario:
          "แพทย์วินิจฉัย Major Depressive Disorder, Single Episode, Severe และตัดสินใจเริ่มยา antidepressant\n\nผู้ป่วยไม่มี drug allergy, ไม่ได้ใช้ยาอื่น\nLFT: AST 22 U/L, ALT 18 U/L (ปกติ)\nRenal function: ปกติ\nECG: Normal sinus rhythm, QTc 410 ms\n\nแพทย์เลือกเริ่ม Sertraline (Zoloft) 50 mg/day",
        question:
          "จงอธิบายเหตุผลในการเลือก Sertraline, กลไกการออกฤทธิ์, วิธีการให้ยา และสิ่งที่ต้องแจ้งผู้ป่วย",
        answer:
          "เหตุผลในการเลือก Sertraline:\n1. SSRI เป็น first-line treatment สำหรับ MDD ตาม guidelines (APA, NICE, CANMAT)\n2. Sertraline มี evidence base ดี มี favorable side effect profile\n3. เหมาะกับ first episode depression\n4. มี anxiolytic properties ดี ซึ่งผู้ป่วยอาจมี anxiety ร่วม\n5. ราคาไม่แพง มีในบัญชียาหลัก\n\nกลไกการออกฤทธิ์:\n- Selective Serotonin Reuptake Inhibitor (SSRI)\n- ยับยั้ง serotonin transporter (SERT) ที่ presynaptic neuron\n- เพิ่มระดับ serotonin ใน synaptic cleft\n- ผลทาง therapeutic ใช้เวลา 2-4 สัปดาห์ (neuroplasticity changes, receptor downregulation)\n\nวิธีการให้ยา:\n- เริ่ม Sertraline 50 mg/day รับประทานเช้า (พร้อมอาหาร)\n- นัดติดตาม 1-2 สัปดาห์ ประเมินอาการข้างเคียงและ suicidal risk\n- ถ้าทน side effects ได้แต่ยังไม่ดีขึ้นใน 4 สัปดาห์ → เพิ่มเป็น 100 mg/day\n- Maximum dose: 200 mg/day\n- ระยะเวลารักษา: อย่างน้อย 6-9 เดือนหลัง remission (first episode)\n\nสิ่งที่ต้องแจ้งผู้ป่วย:\n1. ยาใช้เวลา 2-4 สัปดาห์กว่าจะเห็นผล — อย่าหยุดยาเอง\n2. อาการข้างเคียงที่พบบ่อย: คลื่นไส้, ปวดศีรษะ, นอนไม่หลับ/ง่วง มักดีขึ้นใน 1-2 สัปดาห์\n3. FDA black box warning: เฝ้าระวัง worsening depression/suicidal thoughts โดยเฉพาะ 2 สัปดาห์แรก\n4. ห้ามหยุดยาทันที (abrupt discontinuation) → withdrawal symptoms\n5. หลีกเลี่ยง alcohol\n6. แจ้งให้สามีสังเกตอาการผิดปกติ",
        key_points: [
          "SSRI เป็น first-line pharmacotherapy สำหรับ MDD ทุก guidelines",
          "ยา antidepressant ใช้เวลา 2-4 สัปดาห์กว่าจะเห็น therapeutic effect",
          "FDA black box warning: เฝ้าระวัง suicidality ในช่วง 2 สัปดาห์แรก โดยเฉพาะในอายุ < 25 ปี",
          "ต้องรักษาต่อเนื่องอย่างน้อย 6-9 เดือนหลัง remission เพื่อป้องกัน relapse",
        ],
        time_minutes: 10,
      },
      {
        part_number: 5,
        title: "ส่วนที่ 5: การจัดการผลข้างเคียงและการติดตาม",
        scenario:
          "ผู้ป่วยกลับมาพบแพทย์หลังจากใช้ยา Sertraline 50 mg มา 2 สัปดาห์:\n- อาการข้างเคียง: คลื่นไส้เล็กน้อยช่วง 3 วันแรก (ดีขึ้นแล้ว), นอนไม่ค่อยหลับ (initial insomnia)\n- อารมณ์ดีขึ้นเล็กน้อย PHQ-9 = 18 (ลดจาก 22)\n- ไม่มี suicidal ideation เพิ่มขึ้น\n- แต่ยังมีอาการเบื่ออาหาร เหนื่อยล้า สมาธิไม่ดี\n\n4 สัปดาห์ต่อมา (รวม 6 สัปดาห์):\n- PHQ-9 = 14 (ลดจาก 18)\n- ยังมีอาการ residual symptoms: นอนหลับยาก, เหนื่อยตอนเช้า\n- มีปัญหา sexual dysfunction: decreased libido",
        question:
          "จงวางแผนการจัดการผลข้างเคียงและตัดสินใจว่าควรปรับยาอย่างไร",
        answer:
          "การประเมินการตอบสนองต่อยา:\n- 2 สัปดาห์: PHQ-9 ลดจาก 22 → 18 (ลด 4 คะแนน) = early response ดี\n- 6 สัปดาห์: PHQ-9 ลดจาก 22 → 14 (ลด 8 คะแนน = 36% reduction)\n- Response คือลด >= 50% จาก baseline → ยังไม่ถือว่า full response\n- Remission คือ PHQ-9 < 5 → ยังไม่ถึง\n\nการจัดการผลข้างเคียง:\n1. Initial insomnia:\n   - เปลี่ยนเวลาทานยาจากเช้าเป็น afternoon (ก่อนบ่าย)\n   - Sleep hygiene education\n   - ถ้ายังไม่ดีขึ้น: เพิ่ม Trazodone 25-50 mg ก่อนนอน เป็น adjunct\n\n2. Sexual dysfunction (decreased libido):\n   - พบได้ 25-73% ของผู้ใช้ SSRI\n   - เป็น dose-dependent side effect\n   - ทางเลือก: (a) รอดูอาการ อาจดีขึ้นเอง (b) ลดขนาดยาหากอาการดีพอ (c) เพิ่ม Bupropion SR 150 mg/day เป็น adjunct (d) switch เป็น Bupropion หรือ Mirtazapine ถ้า sexual dysfunction รุนแรงมาก\n\nการปรับยา:\n- Partial response ที่ 6 สัปดาห์ → เพิ่มขนาด Sertraline เป็น 100 mg/day\n- นัดติดตามอีก 2-4 สัปดาห์\n- ถ้ายังไม่ดีขึ้น (PHQ-9 ไม่ลดเพิ่ม) → พิจารณา:\n  - Augmentation: เพิ่ม Aripiprazole 2-5 mg หรือ Lithium 300-600 mg\n  - Switch: เปลี่ยนเป็น SNRI (Venlafaxine, Duloxetine) หรือ Mirtazapine\n- เป้าหมาย: remission (PHQ-9 < 5) ไม่ใช่แค่ response",
        key_points: [
          "Response คือ PHQ-9 ลด >= 50% จาก baseline, Remission คือ PHQ-9 < 5",
          "SSRI sexual dysfunction พบบ่อย เป็นสาเหตุหลักที่ผู้ป่วยหยุดยาเอง",
          "ถ้า partial response ที่ 4-6 สัปดาห์ ควรเพิ่มขนาดยาก่อน switch",
          "เป้าหมายการรักษาคือ remission ไม่ใช่แค่ response เพราะลด relapse rate",
        ],
        time_minutes: 10,
      },
      {
        part_number: 6,
        title: "ส่วนที่ 6: Psychotherapy และการป้องกันการกลับเป็นซ้ำ",
        scenario:
          "หลังจากเพิ่ม Sertraline เป็น 100 mg/day มา 8 สัปดาห์:\n- PHQ-9 = 6 (ลดจาก 22 เริ่มต้น) → near remission\n- อารมณ์ดีขึ้นมาก กลับไปทำงานได้\n- นอนหลับดีขึ้น (ใช้ Trazodone 25 mg ก่อนนอน)\n- ยังมี residual: ขาดความมั่นใจ กลัวจะกลับมาเป็นอีก\n- สัมพันธภาพกับสามีดีขึ้น\n\nแพทย์แนะนำให้เริ่ม psychotherapy ร่วม",
        question:
          "จงอธิบายแผน psychotherapy ที่เหมาะสม, ระยะเวลาการใช้ยาต่อเนื่อง, และแผนป้องกัน relapse",
        answer:
          "แผน Psychotherapy:\n1. Cognitive Behavioral Therapy (CBT) — first-line psychotherapy สำหรับ MDD\n   - ระยะเวลา: 12-16 sessions (สัปดาห์ละ 1 ครั้ง)\n   - หลักการ: แก้ไข negative automatic thoughts และ cognitive distortions\n   - เทคนิค: cognitive restructuring, behavioral activation, thought records\n   - เหมาะกับผู้ป่วยที่มี residual symptoms เรื่อง low self-esteem, fear of relapse\n\n2. ทางเลือกอื่น:\n   - Interpersonal Therapy (IPT): เน้น interpersonal conflicts (เหมาะกับผู้ป่วยที่มีปัญหาสัมพันธภาพ)\n   - Mindfulness-Based Cognitive Therapy (MBCT): เหมาะสำหรับ relapse prevention\n\nระยะเวลาการใช้ยาต่อเนื่อง:\n- Acute phase: 6-12 สัปดาห์ (ผ่านมาแล้ว)\n- Continuation phase: 4-9 เดือนหลัง remission — ให้ยาเท่าเดิม (Sertraline 100 mg)\n  - ลด relapse rate จาก 50% เหลือ 20%\n- Maintenance phase: พิจารณาใน recurrent depression (>= 3 episodes) หรือ severe first episode\n  - เนื่องจากเป็น first episode ที่ severe → อาจพิจารณา maintenance 1-2 ปี\n\nแผนป้องกัน relapse:\n1. ห้ามหยุดยาเอง — ต้อง taper gradually (ลดขนาดยาทุก 2-4 สัปดาห์)\n2. รู้จัก early warning signs: นอนไม่หลับ, เบื่อหน่าย, social withdrawal\n3. Relapse prevention plan:\n   - รู้จัก triggers (work stress, interpersonal conflict)\n   - Coping strategies ที่เรียนรู้จาก CBT\n   - Regular exercise (150 min/week moderate intensity)\n   - Sleep hygiene\n   - Social support network\n4. Follow-up schedule: ทุก 1-3 เดือน ใน continuation phase\n5. PHQ-9 monitoring ทุกครั้งที่มาพบแพทย์\n6. Lifestyle modifications: ออกกำลังกาย, mindfulness meditation, ลด alcohol",
        key_points: [
          "CBT เป็น first-line psychotherapy สำหรับ MDD มี evidence เทียบเท่ายาในระดับ moderate",
          "Continuation phase อย่างน้อย 4-9 เดือนหลัง remission เพื่อป้องกัน relapse",
          "การหยุดยาต้อง taper gradually เพื่อป้องกัน discontinuation syndrome",
          "Combined treatment (ยา + psychotherapy) ได้ผลดีกว่ายาอย่างเดียวใน severe depression",
        ],
        time_minutes: 10,
      },
    ],
  },
  {
    title: "ภาวะเลือดเป็นกรดจากเบาหวาน (Diabetic Ketoacidosis)",
    category: "อายุรศาสตร์",
    difficulty: "hard",
    is_free: false,
    status: "published",
    publish_date: "2026-04-08",
    created_by: "admin",
    parts: [
      {
        part_number: 1,
        title: "ส่วนที่ 1: การประเมินเบื้องต้นและ ABG",
        scenario:
          "หญิงไทย อายุ 22 ปี ประวัติ DM type 1 มา 5 ปี ใช้ insulin lispro + insulin glargine ถูกนำส่ง ER ด้วยอาการคลื่นไส้อาเจียน 1 วัน หายใจหอบลึก (Kussmaul breathing) ซึมลง ปัสสาวะมาก สามีให้ประวัติว่าหยุดฉีด insulin 2 วันเนื่องจากท้องเสียกินอาหารไม่ได้\n\nสัญญาณชีพ: BT 37.8°C, HR 118/min, BP 95/60 mmHg, RR 28/min (deep), SpO2 99%\nGCS: E3V4M6 = 13\nตรวจร่างกาย: dehydrated, dry mucous membranes, fruity breath odor, poor skin turgor, abdomen soft mild diffuse tenderness\n\nผล lab เบื้องต้น:\n- Capillary blood glucose: 480 mg/dL\n- ABG: pH 7.12, pCO2 18 mmHg, pO2 98 mmHg, HCO3 6 mEq/L\n- Na 131 mEq/L, K 5.8 mEq/L, Cl 98 mEq/L\n- BUN 32 mg/dL, Cr 1.6 mg/dL\n- Serum ketones: strongly positive\n- Anion gap = 131 - (98 + 6) = 27 (สูง)",
        question:
          "จงแปลผล ABG อย่างเป็นระบบ, คำนวณ corrected sodium, และจัดความรุนแรงของ DKA",
        answer:
          "การแปลผล ABG อย่างเป็นระบบ:\n1. pH 7.12 → severe acidemia (ปกติ 7.35-7.45)\n2. Primary disorder: HCO3 6 mEq/L → severe metabolic acidosis\n3. Anion gap = Na - (Cl + HCO3) = 131 - (98+6) = 27 → High anion gap metabolic acidosis (HAGMA)\n4. Expected pCO2 = 1.5 × HCO3 + 8 (±2) = 1.5 × 6 + 8 = 17 (±2) → Measured pCO2 18 → adequate respiratory compensation (Kussmaul breathing)\n5. Delta-delta ratio = (27-12)/(24-6) = 15/18 = 0.83 → อยู่ระหว่าง 0.4-0.8 หรือเกือบ 1 → pure HAGMA (ไม่มี non-anion gap component ร่วม)\n\nCorrected sodium:\n- สูตร: Corrected Na = Measured Na + 1.6 × [(glucose - 100)/100]\n- = 131 + 1.6 × [(480-100)/100]\n- = 131 + 1.6 × 3.8 = 131 + 6.08 = 137 mEq/L\n- Corrected Na ปกติ → เมื่อ glucose ลดลง Na จะสูงขึ้น\n\nK 5.8 mEq/L: แม้สูงในเลือด แต่ total body K ต่ำ เนื่องจาก acidosis ดัน K ออกนอกเซลล์ (transcellular shift) เมื่อแก้ acidosis แล้ว K จะลดลงอย่างรวดเร็ว\n\nการจัดความรุนแรงของ DKA (ADA criteria):\n- Mild: pH 7.25-7.30, HCO3 15-18, alert\n- Moderate: pH 7.00-7.24, HCO3 10-14, drowsy\n- Severe: pH < 7.00, HCO3 < 10, stupor/coma\n→ ผู้ป่วยรายนี้: pH 7.12, HCO3 6, GCS 13 (drowsy) = Severe DKA",
        key_points: [
          "DKA = hyperglycemia + ketonemia + high anion gap metabolic acidosis",
          "ต้องคำนวณ corrected sodium เสมอเพราะ hyperglycemia ทำให้ Na ลดลงเทียม",
          "K ในเลือดสูงแต่ total body K ต่ำ เป็น pitfall สำคัญของ DKA",
          "Kussmaul breathing เป็น respiratory compensation ของ severe metabolic acidosis",
        ],
        time_minutes: 10,
      },
      {
        part_number: 2,
        title: "ส่วนที่ 2: Fluid Resuscitation Protocol",
        scenario:
          "ผู้ป่วยได้รับการวินิจฉัย Severe DKA น้ำหนัก 55 kg ประเมิน dehydration ประมาณ 10% (= deficit 5.5 L)\n\nCurrent status:\n- BP 95/60 mmHg, HR 118/min (tachycardia)\n- Urine output: < 0.5 mL/kg/hr (oliguria)\n- Capillary refill > 3 seconds\n- BUN/Cr = 32/1.6 (prerenal pattern)\n\nIV access: 2 large bore IV (18G) ได้แล้ว\nMonitor: cardiac monitoring ต่อแล้ว\nFoley catheter ใส่แล้ว",
        question:
          "จงวางแผน fluid resuscitation อย่างละเอียดสำหรับ 24 ชั่วโมงแรก ระบุชนิดสารน้ำ อัตรา และ monitoring",
        answer:
          "Fluid Resuscitation Protocol สำหรับ DKA:\n\nชั่วโมงที่ 1 (Initial bolus):\n- 0.9% Normal Saline (NSS) 1,000-1,500 mL IV bolus (15-20 mL/kg)\n- ผู้ป่วย 55 kg → ให้ NSS 1,000 mL ใน 1 ชั่วโมงแรก\n- เป้าหมาย: แก้ hemodynamic instability\n\nชั่วโมงที่ 2-4:\n- ประเมิน corrected Na:\n  - ถ้า corrected Na ปกติหรือสูง → เปลี่ยนเป็น 0.45% NSS (half saline)\n  - ถ้า corrected Na ต่ำ → ให้ 0.9% NSS ต่อ\n- ผู้ป่วยรายนี้ corrected Na 137 (ปกติ) → เปลี่ยนเป็น 0.45% NSS\n- อัตรา: 250-500 mL/hr (4-14 mL/kg/hr)\n\nเมื่อ glucose ลดลงถึง 200-250 mg/dL:\n- เปลี่ยนเป็น D5W + 0.45% NSS (dextrose 5% in half saline)\n- อัตรา: 150-250 mL/hr\n- เป้าหมาย: รักษา glucose ที่ 150-200 mg/dL เพื่อป้องกัน cerebral edema\n- ห้ามลด glucose เร็วเกินไป (ไม่เกิน 50-75 mg/dL/hr)\n\nTotal fluid ใน 24 ชั่วโมง:\n- ประมาณ 4-6 ลิตร (replace deficit + maintenance)\n- แก้ deficit 50% ใน 12 ชั่วโมงแรก, ส่วนที่เหลือใน 12-24 ชั่วโมงถัดไป\n\nMonitoring:\n1. Vital signs ทุก 1 ชั่วโมง\n2. Urine output ทุก 1 ชั่วโมง (เป้าหมาย >= 0.5 mL/kg/hr)\n3. Capillary glucose ทุก 1 ชั่วโมง\n4. Electrolytes (Na, K, Cl, HCO3) ทุก 2-4 ชั่วโมง\n5. ABG ทุก 2-4 ชั่วโมง จนกว่า pH > 7.3\n6. Serum ketones ทุก 4 ชั่วโมง (หรือ beta-hydroxybutyrate)\n7. Neurological status (GCS) ทุก 1 ชั่วโมง: เฝ้าระวัง cerebral edema\n8. Fluid balance chart: input/output ทุกชั่วโมง",
        key_points: [
          "เริ่ม 0.9% NSS bolus 15-20 mL/kg ในชั่วโมงแรกเพื่อแก้ hypovolemia",
          "เปลี่ยนเป็น 0.45% NSS เมื่อ corrected Na ปกติหรือสูง",
          "เติม dextrose เมื่อ glucose ถึง 200-250 mg/dL เพื่อป้องกัน cerebral edema",
          "ห้ามลด glucose เร็วเกิน 50-75 mg/dL/hr เพราะเสี่ยง cerebral edema",
        ],
        time_minutes: 10,
      },
      {
        part_number: 3,
        title: "ส่วนที่ 3: Insulin Drip และ K+ Monitoring",
        scenario:
          "หลังให้ NSS 1,000 mL bolus:\n- BP ดีขึ้น: 105/68 mmHg, HR 102/min\n- Glucose: 450 mg/dL (ลดจาก 480)\n\nK ก่อนเริ่ม insulin: 5.8 mEq/L\nECG: tall peaked T waves, normal QRS\n\nแพทย์สั่ง Regular Insulin (RI) drip",
        question:
          "จงอธิบาย insulin drip protocol, การเติม K+, และเกณฑ์ในการปรับอัตรา insulin",
        answer:
          "Insulin Drip Protocol สำหรับ DKA:\n\nPre-insulin checklist:\n- K+ ต้อง >= 3.3 mEq/L ก่อนเริ่ม insulin (ถ้า < 3.3 → ให้ K ก่อน)\n- ผู้ป่วย K 5.8 → เริ่ม insulin ได้ แต่ยังไม่ต้องเติม K\n\nInsulin protocol:\n1. Initial bolus: Regular Insulin 0.1 unit/kg IV bolus = 55 × 0.1 = 5.5 units (หรือ 0.14 unit/kg/hr ไม่ต้อง bolus ก็ได้)\n2. Continuous infusion: RI 0.1 unit/kg/hr = 5.5 units/hr\n   - ผสม RI 50 units ใน NSS 50 mL (1 unit/mL) drip rate 5.5 mL/hr\n3. เป้าหมาย: glucose ลดลง 50-75 mg/dL/hr\n\nการปรับ insulin rate:\n- ถ้า glucose ลดลง < 50 mg/dL/hr → เพิ่ม insulin rate เป็น 2 เท่า\n- ถ้า glucose ลดลง > 75 mg/dL/hr → ลด insulin rate 50%\n- เมื่อ glucose ถึง 200-250 mg/dL → ลด insulin เหลือ 0.02-0.05 unit/kg/hr และเติม D5W\n- ห้ามหยุด insulin drip จนกว่า anion gap จะปิด (AG < 12) และ HCO3 >= 15\n\nPotassium replacement protocol:\n- K > 5.2 mEq/L: ไม่ต้องเติม K (ผู้ป่วยรายนี้ K 5.8 → ยังไม่เติม)\n  - แต่ ECG มี peaked T waves → monitor closely\n- K 3.3-5.2 mEq/L: เติม KCl 20-30 mEq ในสารน้ำทุกลิตร\n  - เป้าหมาย K 4-5 mEq/L\n- K < 3.3 mEq/L: หยุด insulin! ให้ KCl 40 mEq/hr จนกว่า K > 3.3 แล้วจึงเริ่ม insulin ใหม่\n\nMonitoring ทุก 1-2 ชั่วโมง:\n- Capillary glucose ทุก 1 ชั่วโมง\n- Serum K ทุก 2 ชั่วโมง (สำคัญมาก!)\n- ECG monitoring ต่อเนื่อง: ดู T wave changes, QT interval\n- Phosphate: อาจต่ำลง ให้ทดแทนถ้า < 1 mg/dL\n\nข้อควรระวัง:\n- K จะลดลงอย่างรวดเร็วเมื่อเริ่ม insulin + fluid (shift K เข้าเซลล์)\n- Hypokalemia เป็นสาเหตุการเสียชีวิตที่ป้องกันได้ใน DKA",
        key_points: [
          "ต้องเช็ค K >= 3.3 mEq/L ก่อนเริ่ม insulin drip เสมอ",
          "เป้าหมาย glucose ลด 50-75 mg/dL/hr ห้ามเร็วเกินไป",
          "ห้ามหยุด insulin จนกว่า anion gap จะปิด แม้ glucose จะปกติแล้ว",
          "Hypokalemia เป็น preventable cause of death ที่สำคัญที่สุดใน DKA treatment",
        ],
        time_minutes: 10,
      },
      {
        part_number: 4,
        title: "ส่วนที่ 4: ภาวะแทรกซ้อน Cerebral Edema",
        scenario:
          "หลัง treatment 6 ชั่วโมง:\n- Glucose ลดจาก 480 → 185 mg/dL\n- pH ดีขึ้น: 7.28, HCO3 14 mEq/L, AG 16\n- K 4.2 mEq/L (กำลังเติม KCl 20 mEq/L ในสารน้ำ)\n- สารน้ำที่ให้ไปแล้ว: 3,500 mL\n\nแต่ทันใดนั้น:\n- ผู้ป่วยเริ่มปวดศีรษะมาก อาเจียน\n- GCS ลดลงจาก 13 → 9 (E2V3M4)\n- Pupil: right 4 mm sluggish, left 3 mm reactive\n- HR ลดลงเป็น 55/min (จากเดิม 102/min = Cushing reflex)\n- BP สูงขึ้นเป็น 155/95 mmHg",
        question:
          "จงวินิจฉัยภาวะแทรกซ้อนนี้และอธิบายการจัดการฉุกเฉินทันที",
        answer:
          "การวินิจฉัย: Cerebral edema จาก DKA treatment\n\nหลักฐานสนับสนุน:\n1. GCS ลดลงอย่างรวดเร็ว (13 → 9) ระหว่าง treatment\n2. ปวดศีรษะรุนแรง + อาเจียน = signs of raised ICP\n3. Unilateral pupil dilation (R > L) → uncal herniation\n4. Cushing reflex: bradycardia + hypertension = brainstem compression\n5. Risk factors: อายุน้อย (22 ปี), severe DKA, glucose ลดเร็ว (295 mg/dL ใน 6 ชม. = ~49 mg/dL/hr)\n\nPathophysiology:\n- Rapid osmolality change → water shift เข้า brain cells\n- ลด glucose เร็วเกินไป → osmotic gradient สูง → cerebral edema\n- พบ 0.5-1% ของ DKA, mortality สูงถึง 20-25%\n\nการจัดการฉุกเฉิน (ABCDE approach):\n\n1. ทันที (ภายใน 5 นาที):\n   - ยกหัวเตียง 30 องศา\n   - ลด IV fluid rate ลง 1/3\n   - ลด insulin drip rate ลง 50%\n   - Call neurosurgery STAT\n\n2. Hyperosmolar therapy:\n   - First-line: Mannitol 20% 0.5-1 g/kg IV bolus over 15-20 min\n     = 55 × 1 = 55 g → Mannitol 20% 275 mL IV over 20 min\n   - Alternative: Hypertonic saline 3% NaCl 5 mL/kg IV over 30 min\n     = 275 mL IV over 30 min\n   - สามารถให้ซ้ำได้ถ้า GCS ไม่ดีขึ้นใน 30 นาที\n\n3. Intubation:\n   - ถ้า GCS <= 8 หรือไม่ protect airway → RSI intubation\n   - ระวัง: ห้ามให้ hyperventilate มากเกินไป (เป้าหมาย pCO2 30-35 mmHg)\n\n4. Imaging:\n   - CT brain urgent (ถ้า stable พอจะไป CT)\n   - อาจพบ: diffuse cerebral edema, small ventricles, loss of sulci\n\n5. Monitoring:\n   - GCS ทุก 15 นาที\n   - Pupil check ทุก 15 นาที\n   - อาจต้อง ICP monitoring ใน ICU\n\n6. ย้ายเข้า ICU ทันที",
        key_points: [
          "Cerebral edema เป็นภาวะแทรกซ้อนร้ายแรงที่สุดของ DKA โดยเฉพาะในผู้ป่วยอายุน้อย",
          "Cushing reflex (bradycardia + hypertension) บ่งชี้ raised ICP ต้องรีบรักษาทันที",
          "Mannitol 20% 0.5-1 g/kg IV เป็น first-line treatment สำหรับ cerebral edema",
          "ป้องกันได้โดยไม่ลด glucose เร็วเกิน 50-75 mg/dL/hr และให้สารน้ำอย่างระมัดระวัง",
        ],
        time_minutes: 10,
      },
      {
        part_number: 5,
        title: "ส่วนที่ 5: Transition to Subcutaneous Insulin",
        scenario:
          "หลังจากให้ Mannitol และดูแลใน ICU 2 วัน ผู้ป่วยดีขึ้น:\n- GCS 15, pupils equal and reactive\n- CT brain: mild cerebral edema resolved\n\nDKA resolved:\n- pH 7.38, HCO3 22 mEq/L, AG 10\n- Glucose 165 mg/dL (on insulin drip 2 units/hr + D5W)\n- K 4.0 mEq/L\n- Serum ketones: trace\n- ทานอาหารได้แล้ว\n\nต้องเปลี่ยนจาก insulin drip เป็น subcutaneous insulin",
        question:
          "จงอธิบายขั้นตอนการ transition จาก insulin drip เป็น subcutaneous insulin อย่างปลอดภัย",
        answer:
          "Transition Protocol จาก IV insulin drip เป็น Subcutaneous Insulin:\n\nเกณฑ์ก่อน transition (ต้องครบทุกข้อ):\n1. ✓ pH > 7.3 (ผู้ป่วย pH 7.38)\n2. ✓ HCO3 >= 18 mEq/L (ผู้ป่วย HCO3 22)\n3. ✓ Anion gap ปกติ (ผู้ป่วย AG 10)\n4. ✓ Glucose < 200 mg/dL\n5. ✓ ทานอาหารได้\n6. ✓ Alert, oriented (GCS 15)\n\nขั้นตอนการ transition:\n\nStep 1: คำนวณ Total Daily Dose (TDD)\n- จาก IV insulin rate ที่ใช้อยู่: 2 units/hr\n- TDD = IV rate × 24 × 0.8 (ลด 20% สำหรับ safety)\n- = 2 × 24 × 0.8 = 38.4 units/day → ปรับเป็น 38 units/day\n- หรือใช้ TDD เดิมของผู้ป่วย (ถ้ามีประวัติ) เป็น reference\n\nStep 2: แบ่ง insulin regimen (Basal-Bolus)\n- Basal (50% of TDD): Insulin Glargine 19 units SC once daily (ก่อนนอน)\n- Bolus (50% of TDD แบ่ง 3 มื้อ): Insulin Lispro 6-6-7 units SC ก่อนอาหาร 3 มื้อ\n\nStep 3: การ overlap (สำคัญมาก!)\n- ฉีด SC basal insulin อย่างน้อย 2-4 ชั่วโมงก่อนหยุด IV drip\n  - ฉีด Glargine → รอ 2-4 ชั่วโมง → หยุด IV insulin drip\n  - เหตุผล: Glargine ใช้เวลา onset 2-4 ชั่วโมง ถ้าหยุด IV ก่อน → rebound DKA\n- ห้ามหยุด IV insulin drip ทันทีหลังฉีด SC!\n\nStep 4: Monitoring หลัง transition\n- Check glucose ก่อนอาหาร 3 มื้อ + ก่อนนอน (QID)\n- เป้าหมาย: fasting 80-130 mg/dL, pre-meal < 180 mg/dL\n- Correction dose: sliding scale RI สำหรับ hyperglycemia\n- Serum ketones ทุก 12 ชั่วโมง อีก 24-48 ชั่วโมง\n\nStep 5: ปรับ dose\n- ปรับ basal insulin ตาม fasting glucose\n- ปรับ bolus insulin ตาม pre-meal/post-meal glucose\n- ใช้ insulin-to-carbohydrate ratio เมื่อผู้ป่วยทานอาหารปกติ",
        key_points: [
          "ต้อง overlap SC basal insulin กับ IV drip อย่างน้อย 2-4 ชั่วโมงก่อนหยุด drip",
          "เกณฑ์ transition: pH > 7.3, HCO3 >= 18, AG ปกติ, glucose < 200, ทานอาหารได้",
          "TDD คำนวณจาก IV rate × 24 × 0.8 แบ่งเป็น 50% basal + 50% bolus",
          "ห้ามหยุด IV insulin drip ทันที เพราะจะเกิด rebound hyperglycemia/DKA",
        ],
        time_minutes: 10,
      },
      {
        part_number: 6,
        title: "ส่วนที่ 6: Discharge Planning และ DKA Prevention Education",
        scenario:
          "ผู้ป่วยอยู่โรงพยาบาล 5 วัน อาการดีขึ้นมาก:\n- Glucose control: fasting 110-140 mg/dL, post-meal < 200 mg/dL\n- Insulin regimen: Glargine 20 units hs + Lispro 6-6-7 units ac\n- HbA1c (ส่งตอน admit): 11.2% (ควบคุมไม่ดี)\n- ไม่มี neurological sequelae\n\nต้องวางแผน discharge และให้ DKA prevention education",
        question:
          "จงวางแผน discharge education ครอบคลุม DKA prevention, sick day rules, และ long-term DM management",
        answer:
          "Discharge Education Plan:\n\n1. DKA Prevention Education:\n- ห้ามหยุด insulin เอง แม้จะทานอาหารไม่ได้ — นี่คือสาเหตุ DKA ครั้งนี้\n- DM type 1 ต้องใช้ insulin ตลอดชีวิต basal insulin ต้องฉีดทุกวัน\n- เรียนรู้ warning signs ของ DKA: คลื่นไส้ อาเจียน ปวดท้อง หายใจหอบลึก ปัสสาวะมาก\n- ซื้อ urine ketone strips สำหรับตรวจ ketones ที่บ้าน\n\n2. Sick Day Rules (สำคัญมาก!):\n- Never stop insulin: ลด bolus ได้แต่ห้ามหยุด basal insulin\n- Check glucose ทุก 2-4 ชั่วโมง\n- Check urine ketones ถ้า glucose > 250 mg/dL\n- ดื่มน้ำมากๆ (250 mL ทุกชั่วโมง)\n- ถ้าทานอาหารแข็งไม่ได้ → ทานอาหารเหลว/น้ำหวาน\n- Contact doctor ถ้า: glucose > 300 mg/dL ที่ไม่ลดลง, ketones positive, อาเจียนไม่หยุด, หายใจเร็ว\n- ไปห้องฉุกเฉินทันที ถ้า: อาเจียนไม่สามารถทานยา/น้ำได้, ซึมลง, หายใจหอบ\n\n3. Insulin Management:\n- สอน insulin injection technique ซ้ำ (rotation sites, storage)\n- สอน blood glucose monitoring: ก่อนอาหาร 3 มื้อ + ก่อนนอน\n- Insulin-to-carbohydrate ratio: 1 unit per 10-15 g carbohydrate\n- Correction factor: 1 unit ลด glucose ประมาณ 30-50 mg/dL\n- เป้าหมาย HbA1c < 7%\n\n4. Long-term DM Management:\n- นัด Endocrinologist ภายใน 1-2 สัปดาห์\n- พิจารณา Continuous Glucose Monitor (CGM) เช่น FreeStyle Libre\n- พิจารณา Insulin pump ถ้าเหมาะสม\n- Annual screening: HbA1c ทุก 3 เดือน, fundoscopy, urine albumin, foot exam, lipid profile\n- Nutrition counseling: carbohydrate counting\n- Exercise counseling: ระวัง hypoglycemia ขณะออกกำลังกาย\n\n5. Follow-up appointments:\n- 1 สัปดาห์: ตรวจ glucose log, ปรับ insulin dose\n- 1 เดือน: HbA1c, renal function\n- ทุก 3 เดือน: HbA1c, glucose log review\n\n6. Emergency contact:\n- สายด่วน 1669 หรือมาห้องฉุกเฉินทันทีถ้ามี warning signs ของ DKA",
        key_points: [
          "Sick day rules: ห้ามหยุด basal insulin เด็ดขาด แม้จะทานอาหารไม่ได้",
          "ผู้ป่วย DM type 1 ควรมี urine ketone strips ที่บ้านสำหรับ self-monitoring",
          "HbA1c 11.2% บ่งชี้ poor glycemic control ต้องปรับ treatment plan ทั้งหมด",
          "การ educate ผู้ป่วยเรื่อง DKA prevention เป็นสิ่งสำคัญที่สุดก่อน discharge",
        ],
        time_minutes: 10,
      },
    ],
  },
  {
    title: "ถุงน้ำดีอักเสบเฉียบพลัน (Acute Cholecystitis)",
    category: "ศัลยศาสตร์",
    difficulty: "medium",
    is_free: false,
    status: "published",
    publish_date: "2026-04-10",
    created_by: "admin",
    parts: [
      {
        part_number: 1,
        title: "ส่วนที่ 1: การซักประวัติ ตรวจร่างกาย และ Murphy's Sign",
        scenario:
          "หญิงไทย อายุ 50 ปี น้ำหนัก 85 kg ส่วนสูง 158 cm (BMI 34) อาชีพแม่บ้าน มาห้องฉุกเฉินด้วยอาการปวดท้องขวาบน (right upper quadrant) มา 6 ชั่วโมง เริ่มหลังกินอาหารมัน (ข้าวขาหมู) ปวดร้าวไปที่สะบักขวา (right scapula) คลื่นไส้อาเจียน 3 ครั้ง มีไข้ ไม่มีตัวเหลืองตาเหลือง\n\nประวัติเดิม: เคยปวดท้องขวาบนหลังกินอาหารมันมาก่อน 3-4 ครั้ง แต่หายเองใน 1-2 ชั่วโมง\nRisk factors: Female, Forty (50), Fat (BMI 34), Fertile (มีลูก 3 คน)\n\nสัญญาณชีพ: BT 38.5°C, HR 96/min, BP 140/85 mmHg, RR 18/min\nตรวจร่างกาย: mild jaundice (-), RUQ tenderness (+), voluntary guarding (+), Murphy's sign (+) — ผู้ป่วยหยุดหายใจเข้าเมื่อกดใต้ชายโครงขวา, Bowel sounds: normal, ไม่มี peritoneal signs",
        question:
          "จงให้ differential diagnosis และอธิบายความสำคัญของ Murphy's sign พร้อมบอก laboratory ที่ควรส่ง",
        answer:
          "Differential Diagnosis:\n1. Acute cholecystitis — most likely จาก classic presentation: RUQ pain หลังอาหารมัน, Murphy's sign (+), ไข้, 4F risk factors\n2. Biliary colic — ปวด RUQ แต่ไม่มีไข้ หายเองใน 1-6 ชม. (ประวัติเดิมของผู้ป่วย)\n3. Choledocholithiasis — CBD stone ทำให้ปวด RUQ + jaundice + ↑ALP/bilirubin\n4. Acute cholangitis — Charcot's triad (pain, fever, jaundice) ± Reynold's pentad\n5. Peptic ulcer perforation — sudden onset epigastric pain, peritoneal signs\n6. Acute pancreatitis — epigastric pain ร้าวหลัง, ↑amylase/lipase\n\nMurphy's Sign:\n- วิธีทำ: วางมือใต้ชายโครงขวา (RUQ) กดค้างไว้ ให้ผู้ป่วยหายใจเข้าลึก\n- Positive: ผู้ป่วยหยุดหายใจเข้ากะทันหัน (inspiratory arrest) เนื่องจาก inflamed gallbladder เคลื่อนลงมาชนมือที่กด → เจ็บ\n- Sensitivity 65%, Specificity 87% สำหรับ acute cholecystitis\n- Sonographic Murphy's sign: กด transducer ที่ gallbladder แล้วเจ็บ → specificity สูงขึ้น\n\nLaboratory ที่ควรส่ง:\n1. CBC: WBC count, neutrophil (expect leukocytosis)\n2. LFT: AST, ALT, ALP, GGT, total/direct bilirubin (แยก choledocholithiasis)\n3. Amylase/Lipase: แยก acute pancreatitis\n4. CRP: inflammatory marker\n5. BUN, Cr, Electrolytes: baseline\n6. PT/INR: pre-operative assessment\n7. Blood culture: ถ้าสงสัย cholangitis (ไข้สูงมาก, rigors)\n8. Urine pregnancy test (ถ้ายังมีประจำเดือน)",
        key_points: [
          "4F risk factors: Female, Forty, Fat, Fertile เป็น classic risk สำหรับ gallstone disease",
          "Murphy's sign positive มี high specificity สำหรับ acute cholecystitis",
          "ต้องส่ง LFT เพื่อแยก choledocholithiasis และ cholangitis",
          "ประวัติปวดท้องหลังอาหารมันที่หายเองก่อนหน้า → biliary colic ที่ progress เป็น cholecystitis",
        ],
        time_minutes: 10,
      },
      {
        part_number: 2,
        title: "ส่วนที่ 2: ผล Ultrasound และ Laboratory Findings",
        scenario:
          "ผล Laboratory:\n- CBC: WBC 15,200/mm³ (N 85%), Hb 13.1 g/dL, Plt 245,000\n- LFT: AST 42 U/L, ALT 55 U/L, ALP 135 U/L (↑เล็กน้อย), GGT 68 U/L\n- Total bilirubin 1.4 mg/dL, Direct bilirubin 0.6 mg/dL (ปกติ)\n- Amylase 85 U/L (ปกติ), Lipase 42 U/L (ปกติ)\n- CRP 78 mg/L (↑)\n- Cr 0.8 mg/dL, BUN 14 mg/dL\n\nผล Right Upper Quadrant Ultrasound:\n- Gallbladder: distended, wall thickening 5 mm (ปกติ < 3 mm)\n- Multiple gallstones ขนาด 5-15 mm\n- Pericholecystic fluid (+)\n- Sonographic Murphy's sign: positive\n- Common bile duct (CBD): diameter 5 mm (ปกติ < 6 mm)\n- ไม่พบ intrahepatic duct dilatation\n- Liver: normal echogenicity\n- Pancreas: ปกติเท่าที่เห็น",
        question:
          "จงแปลผล lab และ ultrasound ว่าสนับสนุน diagnosis อะไร พร้อมบอกเกณฑ์การวินิจฉัย",
        answer:
          "การแปลผล:\n\nLaboratory:\n- Leukocytosis (WBC 15,200 + N 85%): acute inflammation/infection\n- LFT: mild ↑AST/ALT, ↑ALP/GGT → อาจมี biliary inflammation แต่ bilirubin ปกติ → ไม่มี CBD obstruction\n- Amylase/Lipase ปกติ → แยก pancreatitis ออก\n- CRP 78 → significant inflammation\n\nUltrasound:\n- Gallstones + wall thickening (5mm) + pericholecystic fluid + Sonographic Murphy's sign (+) → classic findings ของ acute cholecystitis\n- CBD 5 mm ปกติ + bilirubin ปกติ → ไม่มี choledocholithiasis\n- Ultrasound sensitivity 81%, specificity 83% สำหรับ acute cholecystitis\n\nDiagnosis: Acute Calculous Cholecystitis\n\nเกณฑ์การวินิจฉัย (Tokyo Guidelines 2018 - TG18):\nA. Local signs of inflammation:\n  ✓ A1: Murphy's sign positive\n  ✓ A2: RUQ mass/pain/tenderness\nB. Systemic signs of inflammation:\n  ✓ B1: Fever (38.5°C)\n  ✓ B2: Elevated CRP (78 mg/L)\n  ✓ B3: Elevated WBC (15,200)\nC. Imaging findings:\n  ✓ Characteristic findings ของ acute cholecystitis บน US\n\nDefinite diagnosis: มี A item + B item + C item → confirmed\n\nUS findings ที่สนับสนุน acute cholecystitis:\n1. ✓ Gallstones (causative factor)\n2. ✓ Gallbladder wall thickening > 4 mm\n3. ✓ Pericholecystic fluid\n4. ✓ Sonographic Murphy's sign (+)\n5. Gallbladder distension (> 8 cm long axis หรือ > 4 cm short axis)",
        key_points: [
          "US findings: gallstones + wall thickening > 4mm + pericholecystic fluid = acute cholecystitis",
          "Tokyo Guidelines 2018 เป็น standard สำหรับ diagnosis และ severity grading",
          "CBD ปกติ + bilirubin ปกติ ช่วยแยก choledocholithiasis ออก",
          "Sonographic Murphy's sign มี sensitivity สูงกว่า clinical Murphy's sign",
        ],
        time_minutes: 10,
      },
      {
        part_number: 3,
        title: "ส่วนที่ 3: Tokyo Guidelines Severity Grading",
        scenario:
          "สรุปข้อมูลผู้ป่วย:\n- อายุ 50 ปี, BMI 34, ไม่มีโรคประจำตัว\n- BT 38.5°C, HR 96/min, BP 140/85 mmHg\n- WBC 15,200, CRP 78\n- ไม่มี organ dysfunction:\n  - Cr 0.8 (ปกติ), consciousness ปกติ\n  - ไม่มี coagulopathy, ไม่มี hypotension\n  - Platelet ปกติ\n- US: acute cholecystitis without abscess or gangrene\n- อาการเริ่มมา 6 ชั่วโมง\n\nGeneral surgery team มาปรึกษาแล้ว",
        question:
          "จงจัด severity grading ตาม Tokyo Guidelines 2018 และวางแผน management ตาม grade",
        answer:
          "Tokyo Guidelines 2018 (TG18) Severity Grading:\n\nGrade III (Severe) — acute cholecystitis ร่วมกับ organ dysfunction:\n- Cardiovascular: hypotension ต้องการ vasopressor\n- Neurological: decreased consciousness\n- Respiratory: PaO2/FiO2 < 300\n- Renal: oliguria, Cr > 2.0\n- Hepatic: PT-INR > 1.5\n- Hematological: Platelet < 100,000\n→ ผู้ป่วยไม่มี organ dysfunction → ไม่ใช่ Grade III\n\nGrade II (Moderate) — มี 1 ข้อขึ้นไป:\n- WBC > 18,000\n- Palpable tender RUQ mass\n- Duration > 72 ชั่วโมง\n- Marked local inflammation (gangrenous, pericholecystic abscess, hepatic abscess, biliary peritonitis, emphysematous cholecystitis)\n→ ผู้ป่วย WBC 15,200 (< 18,000), ไม่มี palpable mass, duration 6 ชม. (< 72), ไม่มี marked local inflammation → ไม่ใช่ Grade II\n\nGrade I (Mild) — ไม่เข้า Grade II หรือ III\n→ ผู้ป่วยรายนี้ = Grade I (Mild) Acute Cholecystitis ✓\n\nManagement ตาม TG18 Grade I:\n\n1. Initial management:\n   - NPO\n   - IV fluid: NSS 1,000 mL then maintenance\n   - IV antibiotics: Ceftriaxone 2 g IV OD + Metronidazole 500 mg IV q8h\n     หรือ Ampicillin-Sulbactam 3 g IV q6h\n   - Pain management: Paracetamol 1 g IV q6h + Morphine 2-4 mg IV PRN\n   - NG tube ถ้าอาเจียนมาก\n\n2. Definitive treatment:\n   - Early laparoscopic cholecystectomy ภายใน 72 ชั่วโมง (ดีที่สุดภายใน 24 ชม.)\n   - Grade I + low surgical risk → direct surgery\n   - ไม่จำเป็นต้อง percutaneous drainage ก่อน\n\n3. Timing:\n   - Early cholecystectomy (ภายใน 72 ชม.) ดีกว่า delayed (6-8 สัปดาห์) เพราะ:\n     - ลด total hospital stay\n     - ลด morbidity\n     - ลดค่าใช้จ่าย\n     - ลดอัตรา readmission\n\n4. Pre-operative assessment:\n   - ASA classification: ASA II (mild systemic disease - obesity)\n   - Informed consent\n   - DVT prophylaxis: enoxaparin 40 mg SC (BMI > 30)\n   - Blood type and crossmatch",
        key_points: [
          "Tokyo Guidelines 2018 แบ่ง severity เป็น 3 grades: mild, moderate, severe",
          "Grade I (mild) ควรทำ early laparoscopic cholecystectomy ภายใน 72 ชั่วโมง",
          "Early surgery ดีกว่า delayed surgery ในแง่ hospital stay และ morbidity",
          "IV antibiotics ที่ครอบคลุม gram-negative และ anaerobe ต้องเริ่มทันที",
        ],
        time_minutes: 10,
      },
      {
        part_number: 4,
        title: "ส่วนที่ 4: การวางแผน Laparoscopic Cholecystectomy",
        scenario:
          "ศัลยแพทย์วางแผนทำ Laparoscopic Cholecystectomy ในวันรุ่งขึ้น (ภายใน 18 ชั่วโมงหลัง admit)\n\nPre-operative status:\n- ผู้ป่วยไข้ลง (BT 37.6°C) หลังได้ antibiotics\n- Pain score ลดลง 4/10 หลังได้ analgesics\n- NPO 8 ชั่วโมง\n- CBC, coagulation profile ปกติ\n- ASA II (obesity)\n- Informed consent ลงนามแล้ว\n- DVT prophylaxis: SCDs + Enoxaparin 40 mg SC",
        question:
          "จงอธิบายขั้นตอนสำคัญของ laparoscopic cholecystectomy รวมถึง Critical View of Safety และ bail-out strategies",
        answer:
          "Laparoscopic Cholecystectomy — Key Steps:\n\n1. Patient positioning & setup:\n   - General anesthesia + endotracheal intubation\n   - Supine, reverse Trendelenburg (head up 15-20°), left tilt\n   - Foley catheter, OG tube\n   - Prophylactic antibiotics within 60 min ก่อนลงมีด\n\n2. Port placement (French technique):\n   - Umbilical 10 mm (camera) — open/Hasson technique\n   - Epigastric 10 mm (working port - right hand)\n   - Right anterior axillary 5 mm (fundus retraction)\n   - Right midclavicular 5 mm (Hartmann's pouch retraction)\n   - CO2 pneumoperitoneum: 12-15 mmHg\n\n3. Exposure and dissection:\n   - Retract fundus cephalad → expose Calot's triangle\n   - Retract Hartmann's pouch laterally\n   - Dissect hepatocystic triangle (Calot's triangle)\n\n4. Critical View of Safety (CVS) — สำคัญที่สุด!\n   CVS criteria (Strasberg) ต้องได้ครบ 3 ข้อ:\n   a) Hepatocystic triangle cleared of fat and fibrous tissue\n   b) Lower 1/3 of gallbladder separated from liver (cystic plate)\n   c) Two and only two structures seen entering gallbladder (cystic duct + cystic artery)\n   - ต้องได้ CVS ก่อน clip/cut ใดๆ ทั้งสิ้น!\n   - ถ้าไม่สามารถทำ CVS ได้ → bail-out strategy\n\n5. Clipping and division:\n   - Cystic artery: 2 clips proximal + 1 clip distal → cut\n   - Cystic duct: 2 clips proximal + 1 clip distal → cut\n   - Retrograde dissection of gallbladder from liver bed\n   - Hemostasis ของ liver bed\n\n6. Extraction:\n   - ใส่ specimen bag\n   - Remove via umbilical port\n   - ส่ง specimen ไป pathology\n\nBail-out strategies (เมื่อไม่สามารถทำ CVS ได้):\n1. Subtotal cholecystectomy: ตัดเฉพาะ body และ fundus เหลือ Hartmann's pouch\n2. Fundus-first (top-down) technique: เริ่มจาก fundus แล้วค่อยๆ ลงมา\n3. Intraoperative cholangiography (IOC): ฉีดสี delineate anatomy\n4. Conversion to open cholecystectomy: ไม่ถือว่าเป็น failure แต่เป็น good surgical judgment\n   - Indications: dense adhesion, unclear anatomy, uncontrolled bleeding, bile duct injury",
        key_points: [
          "Critical View of Safety (CVS) ต้องได้ครบ 3 criteria ก่อน clip/cut ใดๆ",
          "Conversion to open ไม่ใช่ failure แต่เป็น sound surgical judgment เมื่อ anatomy ไม่ชัด",
          "Bail-out strategies: subtotal cholecystectomy, fundus-first, IOC, conversion",
          "Prophylactic antibiotics ต้องให้ภายใน 60 นาทีก่อน skin incision",
        ],
        time_minutes: 10,
      },
      {
        part_number: 5,
        title: "ส่วนที่ 5: ภาวะแทรกซ้อน Bile Duct Injury",
        scenario:
          "ระหว่างผ่าตัด Laparoscopic Cholecystectomy:\n- พบ severe inflammation รอบ Calot's triangle\n- มี adhesion หนาแน่น ระหว่าง gallbladder กับ duodenum\n- ศัลยแพทย์ dissect ยากมาก ใช้เวลานาน\n\nหลังผ่าตัดวันที่ 2:\n- ผู้ป่วยมีไข้ขึ้นอีก BT 38.8°C\n- ปวดท้องมากขึ้น diffuse abdominal tenderness\n- มี bilious fluid ออกทาง drain ประมาณ 200 mL/day (สีเขียวเข้ม)\n- Lab: WBC 18,500, Total bilirubin 3.2 mg/dL (↑), Direct bilirubin 2.1 mg/dL (↑)\n- ALP 280 U/L (↑↑), GGT 185 U/L (↑↑)\n- Amylase in drain fluid: 45 U/L (ต่ำ = bile ไม่ใช่ pancreatic juice)",
        question:
          "จงวินิจฉัยภาวะแทรกซ้อนนี้ จำแนก classification และวางแผนการจัดการ",
        answer:
          "การวินิจฉัย: Bile Duct Injury (BDI) หลัง Laparoscopic Cholecystectomy\n\nหลักฐาน:\n- Bilious drainage 200 mL/day → bile leak\n- Rising bilirubin, ALP, GGT → biliary obstruction/leak\n- Post-operative fever + abdominal pain → bile peritonitis\n- Risk factors: severe inflammation, dense adhesion\n- อุบัติการณ์: 0.3-0.7% ของ laparoscopic cholecystectomy\n\nStrasberg Classification of Bile Duct Injuries:\n- Type A: Cystic duct leak หรือ leak จาก minor hepatic duct in liver bed\n- Type B: Occlusion of aberrant right hepatic duct\n- Type C: Transection of aberrant right hepatic duct (leak without occlusion)\n- Type D: Lateral injury to common bile duct (CBD)\n- Type E: Transection of CBD (sub-classified E1-E5 ตาม Bismuth)\n  - E1: CBD transection > 2 cm from confluence\n  - E2: CBD transection < 2 cm from confluence\n  - E3: At confluence, right and left duct communicate\n  - E4: At confluence, right and left duct separated\n  - E5: Combined with aberrant right hepatic duct injury\n\nผู้ป่วยรายนี้: น่าจะเป็น Type A (cystic duct leak) หรือ Type D (lateral CBD injury) ต้อง investigate เพิ่ม\n\nการจัดการ:\n\n1. Immediate:\n   - Keep drain in place (drainage ของ bile)\n   - IV antibiotics: broaden coverage (Piperacillin-Tazobactam)\n   - NPO, IV fluid\n   - Pain management\n\n2. Investigations:\n   - CT abdomen with contrast: ดู fluid collection, biloma\n   - MRCP: delineate biliary anatomy และระดับ injury\n   - ERCP (diagnostic + therapeutic): gold standard สำหรับ bile leak\n\n3. Treatment ตาม type:\n   - Type A (cystic duct leak): ERCP + biliary stent (ลด pressure ใน CBD → leak หยุด)\n     - Sphincterotomy ± stent placement\n     - Success rate > 90%\n   - Type D (lateral CBD injury): ERCP + stent อาจเพียงพอ\n   - Type E (complete transection): ต้อง surgical repair\n     - Roux-en-Y hepaticojejunostomy โดย experienced hepatobiliary surgeon\n     - ควรทำใน tertiary center\n\n4. Percutaneous drainage:\n   - ถ้ามี biloma/abscess → CT-guided drainage\n\n5. Refer hepatobiliary surgery:\n   - ถ้า injury รุนแรง (Type E) หรือ ERCP ไม่สำเร็จ",
        key_points: [
          "Bile duct injury พบ 0.3-0.7% ของ laparoscopic cholecystectomy เป็นภาวะแทรกซ้อนที่ร้ายแรง",
          "Strasberg classification ช่วยจำแนกและวางแผนการรักษา BDI",
          "ERCP + stent เป็น first-line treatment สำหรับ bile leak (Type A, D)",
          "Complete CBD transection (Type E) ต้อง Roux-en-Y hepaticojejunostomy โดย specialist",
        ],
        time_minutes: 10,
      },
      {
        part_number: 6,
        title: "ส่วนที่ 6: การดูแลหลังผ่าตัดและคำแนะนำด้านอาหาร",
        scenario:
          "สมมุติว่าผู้ป่วยไม่มี bile duct injury (ผ่าตัดเรียบร้อย):\n- Operative findings: acute cholecystitis, CVS achieved, no complications\n- Operative time: 65 minutes\n- EBL: 30 mL\n- หลังผ่าตัด 6 ชั่วโมง: ทนปวดได้, flatus (+), ทานน้ำได้\n- วันรุ่งขึ้น: BT 37.2°C, pain score 3/10, ทานอาหารอ่อนได้, เดินได้\n- แผล: แห้งดี ไม่มี sign of infection\n- Pathology: acute cholecystitis with cholelithiasis, no malignancy",
        question:
          "จงวางแผน post-operative care, เกณฑ์ discharge, และคำแนะนำด้านอาหารหลังตัดถุงน้ำดี",
        answer:
          "Post-operative Care:\n\n1. Pain management:\n   - Paracetamol 1 g PO q6h (scheduled)\n   - Ibuprofen 400 mg PO q8h PRN (ถ้าไม่มี contraindication)\n   - Tramadol 50 mg PO q6h PRN สำหรับ breakthrough pain\n   - ลด/หยุด opioids ให้เร็วที่สุด\n\n2. Activity:\n   - Early ambulation (เดินวันแรกหลังผ่าตัด)\n   - ยกของหนัก > 5 kg หลีกเลี่ยง 2-4 สัปดาห์\n   - กลับไปทำงานเบาได้ภายใน 1 สัปดาห์\n   - ออกกำลังกายเต็มที่ได้หลัง 4 สัปดาห์\n\n3. Wound care:\n   - Steri-strips ที่แผล: ปล่อยให้หลุดเอง\n   - อาบน้ำได้หลัง 24-48 ชั่วโมง ซับแห้ง\n   - ไม่ต้องตัดไหม (dissolvable sutures)\n\nDischarge Criteria (Enhanced Recovery After Surgery — ERAS):\n1. ✓ ทน oral intake ได้ดี (ของเหลว → อาหารอ่อน)\n2. ✓ Pain controlled ด้วย oral analgesics\n3. ✓ Afebrile > 24 ชั่วโมง\n4. ✓ Ambulatory (เดินได้ด้วยตนเอง)\n5. ✓ ผ่านลม (flatus) หรือ bowel function กลับ\n6. ✓ Urine output ปกติ\n7. ไม่มี surgical complications\n→ ผู้ป่วย discharge ได้วันรุ่งขึ้นหลังผ่าตัด (day 1)\n\nคำแนะนำด้านอาหารหลังตัดถุงน้ำดี:\n\nระยะแรก (1-4 สัปดาห์):\n- เริ่มด้วยอาหารอ่อน low-fat\n- หลีกเลี่ยงอาหารมัน ทอด กะทิ เนย ครีม\n- ทานมื้อเล็กแต่บ่อย (5-6 มื้อ/วัน)\n- หลีกเลี่ยง spicy food, caffeine, alcohol\n- เพิ่ม fiber ค่อยๆ (ผัก ผลไม้ whole grains)\n\nระยะยาว:\n- Bile ยังคงไหลจาก liver ผ่าน CBD สู่ duodenum โดยตรง\n- ไม่มี gallbladder เก็บ bile → bile ไหลต่อเนื่อง\n- ร่างกายจะปรับตัวได้ใน 4-8 สัปดาห์\n- Post-cholecystectomy diarrhea พบ 10-20%: อาจต้องใช้ Cholestyramine ถ้าเป็นมาก\n- ส่วนใหญ่สามารถทาน diet ปกติได้หลัง 4-6 สัปดาห์\n\nFollow-up:\n- นัด 1-2 สัปดาห์หลัง discharge: ตรวจแผล, review pathology\n- Warning signs ให้กลับมา: ไข้, ปวดท้องมาก, ตัวเหลือง, แผลบวมแดงมีหนอง",
        key_points: [
          "Laparoscopic cholecystectomy สามารถ discharge ได้ใน 1 วัน (day surgery หรือ day 1)",
          "Post-cholecystectomy diarrhea พบ 10-20% เนื่องจาก bile ไหลต่อเนื่องไม่มี storage",
          "อาหาร low-fat ในระยะแรก 4 สัปดาห์ แล้วค่อยๆ เพิ่ม diet ปกติ",
          "ERAS protocol ช่วยให้ recovery เร็วขึ้นและลด hospital stay",
        ],
        time_minutes: 10,
      },
    ],
  },
  {
    title: "หลอดลมฝอยอักเสบในทารก (Bronchiolitis)",
    category: "กุมารเวชศาสตร์",
    difficulty: "easy",
    is_free: true,
    status: "published",
    publish_date: "2026-04-12",
    created_by: "admin",
    parts: [
      {
        part_number: 1,
        title: "ส่วนที่ 1: การประเมินเบื้องต้นและ Wang Clinical Severity Score",
        scenario:
          "ทารกชาย อายุ 6 เดือน น้ำหนัก 7.5 kg มารดาพามาห้องฉุกเฉินด้วยอาการไข้ต่ำ ไอ น้ำมูก 3 วัน หายใจเร็ว หายใจมีเสียงวี้ด ดูดนมได้ลดลง\n\nประวัติ: คลอดครบกำหนด น้ำหนักแรกเกิด 3.2 kg ไม่มีโรคประจำตัว vaccine ตามเกณฑ์ พี่สาวอายุ 4 ปีเป็นหวัดก่อนหน้า 5 วัน\n\nสัญญาณชีพ: BT 37.8°C, HR 152/min, RR 56/min, SpO2 93% room air\nน้ำหนัก 7.5 kg (P50)\n\nตรวจร่างกาย: alert, mild subcostal retractions, nasal flaring, bilateral diffuse wheezing และ fine crackles, ไม่มี stridor, hydration status ดี, anterior fontanelle flat",
        question:
          "จงประเมินความรุนแรงโดยใช้ Wang Clinical Severity Score และบอก initial management",
        answer:
          "Wang Clinical Severity Score:\n\n1. Respiratory Rate:\n   - 0 = < 30/min\n   - 1 = 31-45/min\n   - 2 = 46-60/min\n   - 3 = > 60/min\n   → ผู้ป่วย RR 56/min = 2 คะแนน\n\n2. Wheezing:\n   - 0 = none\n   - 1 = terminal expiratory/with stethoscope only\n   - 2 = entire expiration/audible on auscultation\n   - 3 = audible without stethoscope (both inspiration and expiration)\n   → ผู้ป่วย bilateral diffuse wheezing on auscultation = 2 คะแนน\n\n3. Retractions:\n   - 0 = none\n   - 1 = intercostal only\n   - 2 = tracheosternal (subcostal)\n   - 3 = severe with nasal flaring\n   → ผู้ป่วย subcostal retractions + nasal flaring = 3 คะแนน\n\n4. General condition:\n   - 0 = normal\n   - 1 = mildly decreased activity\n   - 2 = decreased activity, poor feeding\n   - 3 = looks toxic, lethargic\n   → ผู้ป่วย alert แต่ดูดนมลดลง = 1-2 คะแนน\n\nTotal Wang Score = 2 + 2 + 3 + 1 = 8/12\nInterpretation: Mild 0-3, Moderate 4-8, Severe 9-12\n→ ผู้ป่วย score 8 = Moderate bronchiolitis\n\nInitial Management:\n1. Admit to ward (ไม่ใช่ PICU เพราะยังไม่ severe)\n2. SpO2 monitoring ต่อเนื่อง\n3. Supplemental O2: nasal cannula เริ่ม 1-2 L/min เป้าหมาย SpO2 >= 92%\n4. Maintain hydration:\n   - ลองดูดนมได้ถ้า RR < 60 และไม่มี respiratory distress มาก\n   - ถ้าดูดนมไม่ได้ → NG tube feeding หรือ IV fluid (D5 1/4 NSS at maintenance rate)\n5. Nasal suction: gentle bulb suction ก่อนให้นมและก่อนนอน\n6. Antipyretic: Paracetamol 15 mg/kg/dose PRN (= 112.5 mg) ถ้าไข้ >= 38.5°C\n7. ไม่แนะนำ: bronchodilators, systemic corticosteroids, antibiotics (ไม่มี evidence ใน bronchiolitis)",
        key_points: [
          "Wang score 4-8 = moderate bronchiolitis ต้อง admit สังเกตอาการ",
          "SpO2 < 92% เป็น threshold สำหรับ supplemental oxygen ตาม AAP guidelines",
          "Bronchodilators และ corticosteroids ไม่แนะนำใน typical bronchiolitis",
          "Supportive care (O2, hydration, suction) เป็นหลักการรักษาหลัก",
        ],
        time_minutes: 10,
      },
      {
        part_number: 2,
        title: "ส่วนที่ 2: RSV Testing และ Chest X-ray",
        scenario:
          "แพทย์สั่ง investigation:\n\nRSV rapid antigen test (nasopharyngeal swab): Positive\n\nChest X-ray (AP view):\n- Hyperinflation: increased AP diameter, flattened diaphragm, > 8 posterior ribs visible\n- Bilateral perihilar peribronchial thickening (peribronchial cuffing)\n- Patchy atelectasis ที่ right middle lobe\n- No consolidation, no pleural effusion\n- Heart size ปกติ\n\nCBC: WBC 9,800/mm³ (Lymphocyte 62%, Neutrophil 28%), Hb 11.2 g/dL\nCRP: 8 mg/L (เล็กน้อย)",
        question:
          "จงแปลผล RSV test และ CXR พร้อมอธิบายว่าจำเป็นต้องส่ง investigation เหล่านี้หรือไม่ในผู้ป่วย bronchiolitis",
        answer:
          "การแปลผล:\n\nRSV rapid antigen test:\n- Positive → ยืนยัน RSV เป็น causative agent\n- RSV (Respiratory Syncytial Virus) เป็นสาเหตุหลักของ bronchiolitis (50-80%)\n- Sensitivity ประมาณ 80-90% ในเด็ก, Specificity > 95%\n- สาเหตุอื่น: Rhinovirus, Parainfluenza, Human metapneumovirus, Adenovirus\n\nChest X-ray:\n- Hyperinflation = air trapping จาก small airway obstruction → classic finding\n- Peribronchial cuffing = inflammation รอบ bronchioles\n- Atelectasis = mucous plugging ทำให้บาง segment collapse\n- ไม่มี consolidation → แยก bacterial pneumonia ออกได้\n\nCBC:\n- Lymphocyte predominance (62%) สอดคล้องกับ viral infection\n- WBC ปกติ ไม่สนับสนุน bacterial superinfection\n- CRP 8 mg/L (เล็กน้อย) → สอดคล้องกับ viral etiology\n\nจำเป็นต้องส่งหรือไม่?\n\nRSV test:\n- AAP 2014 guidelines: ไม่จำเป็นต้องส่ง routinely\n- ประโยชน์: (1) infection control — cohorting ผู้ป่วย RSV+ (2) ลดการใช้ antibiotics (3) epidemiological surveillance\n- ส่งได้ถ้ามี cohorting benefit หรือ uncertain diagnosis\n\nChest X-ray:\n- AAP guidelines: ไม่แนะนำ routine CXR ใน typical bronchiolitis\n- ข้อบ่งชี้: atypical presentation, suspected complications (pneumothorax, cardiac disease), severe disease, ไม่ดีขึ้นตามคาด\n- Pitfall: CXR ที่มี atelectasis มักถูก misread เป็น pneumonia → นำไปสู่ unnecessary antibiotics\n\nCBC/CRP:\n- ไม่จำเป็นต้องส่ง routine\n- ส่งเมื่อสงสัย bacterial superinfection หรือมีไข้สูงมาก\n\nสรุป: ในกรณีนี้ RSV test มีประโยชน์สำหรับ cohorting แต่ CXR และ blood tests ไม่จำเป็นต้องส่ง routine",
        key_points: [
          "RSV เป็นสาเหตุ 50-80% ของ bronchiolitis ในเด็กอายุ < 2 ปี",
          "AAP guidelines ไม่แนะนำ routine CXR ใน typical bronchiolitis",
          "CXR findings: hyperinflation + peribronchial cuffing + atelectasis เป็น classic pattern",
          "Lymphocyte predominance ใน CBC สอดคล้องกับ viral infection",
        ],
        time_minutes: 10,
      },
      {
        part_number: 3,
        title: "ส่วนที่ 3: Supportive Care — O2, Feeding, Suction",
        scenario:
          "ผู้ป่วย admit ในหอผู้ป่วยเด็ก:\n- ให้ O2 nasal cannula 1 L/min → SpO2 ขึ้นเป็น 95%\n- Nasal suction ก่อนให้นม → ช่วยให้ดูดนมดีขึ้น\n- ยังดูดนมได้ประมาณ 70% ของปกติ\n\n6 ชั่วโมงต่อมา:\n- RR เพิ่มเป็น 62/min\n- ดูดนมได้ลดลงเหลือ 40% ของปกติ\n- SpO2 บน O2 1 L/min = 94%\n- Retractions เพิ่มขึ้น: subcostal + intercostal\n- ไม่มี apnea\n- Urine output: 4 wet diapers ใน 6 ชั่วโมง (ยังพอรับได้)",
        question:
          "จงวางแผน supportive care อย่างละเอียดสำหรับ O2, feeding, และ nasal suction",
        answer:
          "Supportive Care Plan:\n\n1. Oxygen therapy:\n- เพิ่ม nasal cannula เป็น 2 L/min (เป้าหมาย SpO2 >= 92%)\n- Maximum nasal cannula flow ในทารก: 2 L/min\n- ถ้า SpO2 ยังไม่ถึงเป้าหมายหรือ work of breathing เพิ่ม → พิจารณา High-Flow Nasal Cannula (HFNC)\n- Continuous pulse oximetry monitoring\n- SpO2 target: >= 92% (AAP) หรือ >= 90% (UK NICE guidelines)\n- ไม่จำเป็นต้องให้ O2 ต่อเนื่องถ้า SpO2 stable >= 92% → อาจ wean ได้\n\n2. Feeding management:\n- RR 62/min → ดูดนม unsafe (aspiration risk เมื่อ RR > 60)\n- เปลี่ยนเป็น NG tube feeding:\n  - Bolus feeds: expressed breast milk หรือ formula\n  - ปริมาณ: 120-150 mL/kg/day = 7.5 × 130 = ~975 mL/day\n  - แบ่งให้ทุก 3 ชั่วโมง: ~120 mL per feed (8 feeds/day)\n  - ถ้า tolerate → ลองดูดนมได้เมื่อ RR < 60\n- ถ้า vomiting มากหรือ NG feed intolerance → IV fluid:\n  - D5 0.225% NSS (D5 1/4 NSS) at maintenance rate\n  - Holliday-Segar: 7.5 kg → (100 × 7.5) = 750 mL/day = ~31 mL/hr\n  - ระวัง fluid overload → ให้ 80% maintenance ถ้ามี concerns\n\n3. Nasal suction:\n- Gentle bulb syringe suction หรือ mechanical suction (low pressure < 80 mmHg)\n- Timing: ก่อนให้นม, ก่อนนอน, และเมื่อ secretions มาก\n- อาจหยด NSS 1-2 drops per nostril ก่อน suction เพื่อ loosen secretions\n- Deep suction ไม่แนะนำ (ทำให้ mucosal edema แย่ลง)\n- Suction เฉพาะ superficial (ปากจมูก, nasopharynx)\n\n4. อื่นๆ:\n- Positioning: elevate head 30 degrees\n- Minimal handling: ลดการรบกวน ให้พักผ่อน\n- Monitor: SpO2, HR, RR, work of breathing ทุก 1-2 ชั่วโมง\n- Reassess Wang score ทุก 4-6 ชั่วโมง\n- I&O chart: ดู urine output >= 1 mL/kg/hr",
        key_points: [
          "ห้ามให้ดูดนมถ้า RR > 60/min เพราะเสี่ยง aspiration → ใช้ NG tube feeding แทน",
          "Nasal suction ก่อนให้นมช่วยให้ทารก feed ได้ดีขึ้น เป็น simple but effective intervention",
          "O2 target >= 92% ใน bronchiolitis ไม่จำเป็นต้อง maintain 100%",
          "IV fluid ให้เมื่อ NG feeding ไม่ได้ โดยให้ 80-100% maintenance rate",
        ],
        time_minutes: 10,
      },
      {
        part_number: 4,
        title: "ส่วนที่ 4: Deterioration และการย้ายเข้า PICU",
        scenario:
          "12 ชั่วโมงหลัง admit (วันที่ 2):\n- ผู้ป่วยแย่ลง: RR 72/min, HR 170/min\n- SpO2 88% on O2 nasal cannula 2 L/min\n- Severe subcostal, intercostal, suprasternal retractions\n- Head bobbing (+), grunting (+)\n- ซึมลง ร้องเสียงเบา ไม่ค่อยตอบสนอง\n- ดูดนมไม่ได้เลย\n- Auscultation: markedly decreased air entry bilaterally (silent chest เริ่มเป็น)\n- Capillary refill 3 seconds\n\nWang score: 3 + 3 + 3 + 3 = 12/12 (Severe)\n\nABG (capillary): pH 7.28, pCO2 58 mmHg, HCO3 22 mEq/L → respiratory acidosis",
        question:
          "จงระบุเกณฑ์การย้ายเข้า PICU และ immediate management ที่ต้องทำ",
        answer:
          "เกณฑ์การย้ายเข้า PICU (ผู้ป่วยเข้าได้หลายข้อ):\n1. ✓ SpO2 < 90% ที่ไม่ตอบสนองต่อ O2 nasal cannula\n2. ✓ Severe respiratory distress: RR > 70, severe retractions, grunting\n3. ✓ Impending respiratory failure: rising pCO2 (58 mmHg), respiratory acidosis\n4. ✓ Decreased consciousness (ซึมลง)\n5. ✓ Silent chest → บ่งชี้ severe obstruction อากาศเข้าไม่ได้\n6. ✓ Hemodynamic instability (tachycardia 170, delayed capillary refill)\n7. Apnea episodes (ยังไม่มี แต่ต้องเฝ้าระวัง)\n8. Failure to maintain adequate hydration\n\nImmediate Management (ABCDE approach):\n\nA — Airway:\n- Suction nasopharynx ทันที\n- Position: sniffing position, head elevated\n\nB — Breathing:\n- Increase O2: non-rebreather mask 10-15 L/min (bridge therapy)\n- Start High-Flow Nasal Cannula (HFNC) ทันที:\n  - เริ่มที่ 2 L/kg/min = 15 L/min\n  - FiO2 titrate เพื่อ SpO2 >= 92%\n  - HFNC ลด work of breathing, ให้ PEEP effect, warm humidified O2\n- ถ้า HFNC ไม่เพียงพอ → CPAP 5-7 cmH2O\n- ถ้า pCO2 ยังสูงขึ้น / GCS ลดลง → intubation\n  - ETT size: (age/4) + 3.5 = 3.5 mm uncuffed\n  - ระวัง: ETT size อาจต้อง smaller กว่าปกติเพราะ airway edema\n\nC — Circulation:\n- IV access (ถ้ายังไม่มี)\n- NSS 10-20 mL/kg bolus ถ้ามี poor perfusion\n- Maintenance IV fluid: D5 0.225% NSS\n\nD — Disability:\n- GCS/AVPU assessment ทุก 30 นาที\n- Blood glucose check (เด็กเล็กเสี่ยง hypoglycemia)\n\nE — Exposure:\n- Temperature control\n- Full examination for other causes\n\nInvestigations:\n- ABG/VBG ทุก 2-4 ชั่วโมง\n- Monitor CO2 trend (capnography ถ้ามี)\n- Blood glucose\n- Electrolytes\n- CXR เฉพาะถ้าสงสัย complication (pneumothorax, secondary bacterial infection)",
        key_points: [
          "Silent chest ใน bronchiolitis บ่งชี้ severe obstruction เป็น ominous sign",
          "Rising pCO2 (respiratory acidosis) บ่งชี้ impending respiratory failure",
          "HFNC 2 L/kg/min เป็น first-line respiratory support ก่อน CPAP/intubation",
          "เด็กเล็กที่ respiratory failure ต้องเช็ค blood glucose เสมอ เพราะเสี่ยง hypoglycemia",
        ],
        time_minutes: 10,
      },
      {
        part_number: 5,
        title: "ส่วนที่ 5: High-Flow Nasal Cannula Management",
        scenario:
          "ผู้ป่วยย้ายเข้า PICU เริ่ม HFNC:\n- Flow: 15 L/min (2 L/kg/min), FiO2 0.50\n\n2 ชั่วโมงหลังเริ่ม HFNC:\n- SpO2 94%, RR ลดเป็น 52/min\n- Retractions ลดลง: mild subcostal only\n- HR 145/min (ลดลง)\n- ดูอาการดีขึ้น สังเกตสิ่งรอบข้างมากขึ้น\n- ABG: pH 7.34, pCO2 45 mmHg, HCO3 23 → improved\n\n6 ชั่วโมงหลัง HFNC:\n- SpO2 96% on FiO2 0.40\n- RR 44/min, mild work of breathing\n- NG feeding resumed: tolerate 80 mL q3h",
        question:
          "จงอธิบาย HFNC mechanism of action, การ titrate, และเกณฑ์ weaning",
        answer:
          "HFNC (High-Flow Nasal Cannula) — Mechanism of Action:\n\n1. Washout of dead space:\n   - High flow flush CO2 ออกจาก nasopharyngeal dead space\n   - ลด work of breathing, improve CO2 clearance\n\n2. CPAP effect (low-level PEEP):\n   - Generate 2-5 cmH2O positive pressure\n   - Splint airways open, reduce air trapping\n   - Improve functional residual capacity (FRC)\n\n3. Heated humidified gas:\n   - ลด mucosal drying, improve mucociliary clearance\n   - ลด metabolic cost ของ conditioning inspired gas\n   - Improve comfort → ลด agitation\n\n4. Reduction in inspiratory resistance:\n   - Match/exceed peak inspiratory flow → ลด resistance\n\nHFNC Settings สำหรับทารก:\n- Starting flow: 2 L/kg/min (ผู้ป่วย 7.5 kg = 15 L/min)\n- FiO2: titrate เพื่อ SpO2 >= 92%\n- Maximum flow: ทั่วไป 2-3 L/kg/min (สูงสุด ~25 L/min ในทารก)\n\nการ titrate:\n- ถ้า SpO2 ยังต่ำ → เพิ่ม FiO2 ก่อน (ง่ายกว่า)\n- ถ้า work of breathing ยังมาก → เพิ่ม flow\n- เป้าหมาย: SpO2 >= 92%, RR ลดลงตาม age-appropriate, ลด work of breathing\n\nSigns of HFNC failure (ต้อง escalate ไป CPAP/intubation):\n- SpO2 < 92% แม้ FiO2 > 0.6\n- RR ไม่ลดลงใน 60-90 นาที\n- pCO2 rising\n- Worsening retractions\n- Apnea episodes\n- Decreased consciousness\n\nWeaning protocol:\n1. เมื่ออาการดีขึ้น (RR ลดลง, work of breathing ลดลง) → ลด FiO2 ก่อน\n   - ลด FiO2 ทีละ 0.05-0.10 ทุก 2-4 ชั่วโมง\n   - เป้าหมาย FiO2 0.21 (room air)\n2. เมื่อ FiO2 <= 0.30 และอาการ stable → เริ่มลด flow\n   - ลด flow ทีละ 1-2 L/min ทุก 2-4 ชั่วโมง\n3. เมื่อ flow ถึง 4-6 L/min + FiO2 0.21-0.25 + stable → trial off HFNC\n   - เปลี่ยนเป็น standard nasal cannula 1-2 L/min\n4. เมื่อ SpO2 >= 92% on room air > 4 ชั่วโมง → หยุด O2\n\nMonitoring ระหว่าง weaning:\n- SpO2, RR, HR ทุก 1-2 ชั่วโมง\n- Work of breathing assessment\n- Feeding tolerance",
        key_points: [
          "HFNC ทำงาน 4 กลไก: dead space washout, CPAP effect, humidification, reduce resistance",
          "Wean FiO2 ก่อน แล้วค่อย wean flow เป็นหลักการสำคัญ",
          "HFNC failure ต้อง escalate ภายใน 60-90 นาที ถ้าไม่ดีขึ้น",
          "เป้าหมาย weaning off HFNC เมื่อ FiO2 <= 0.30 และ flow ต่ำ + clinical stable",
        ],
        time_minutes: 10,
      },
      {
        part_number: 6,
        title: "ส่วนที่ 6: Discharge Criteria และ Prevention (Palivizumab)",
        scenario:
          "ผู้ป่วยอยู่ PICU 3 วัน ward 2 วัน อาการดีขึ้นมาก:\n- Day 5: SpO2 97% room air > 12 ชั่วโมง\n- RR 36/min (ปกติสำหรับอายุ 6 เดือน)\n- ดูดนมได้ดี > 75% ของปกติ\n- ไม่มี retractions, ไข้หมดแล้ว 2 วัน\n- มารดากังวลว่าจะเป็นอีก อยากทราบวิธีป้องกัน\n\nข้อมูลเพิ่มเติม:\n- ทารกรายนี้คลอดครบกำหนด ไม่มีโรคหัวใจ ไม่มีโรคปอดเรื้อรัง\n- มีน้องฝาแฝดอีกคนอายุ 6 เดือนเหมือนกัน",
        question:
          "จงระบุ discharge criteria, ให้คำแนะนำแก่มารดา, และอธิบายเรื่อง Palivizumab prophylaxis",
        answer:
          "Discharge Criteria สำหรับ Bronchiolitis:\n1. ✓ SpO2 >= 92% on room air ติดต่อกัน >= 4 ชั่วโมง (รวม sleep)\n2. ✓ RR ปกติตามอายุ (< 6 เดือน: < 60, 6-12 เดือน: < 50)\n3. ✓ Adequate oral intake >= 75% ของปกติ\n4. ✓ Clinically improving: ลดลงของ work of breathing\n5. ✓ Afebrile >= 24 ชั่วโมง\n6. ✓ มารดาเข้าใจ warning signs ที่ต้องกลับมา\n7. ✓ Home environment เหมาะสม (มีผู้ดูแล, access to hospital)\n→ ผู้ป่วย discharge ได้\n\nคำแนะนำแก่มารดา:\n\n1. Natural course:\n   - อาการไอ น้ำมูก อาจนาน 2-3 สัปดาห์ ค่อยๆ ดีขึ้น\n   - Peak severity มักอยู่ day 3-5 (ผ่านไปแล้ว)\n   - Post-bronchiolitis wheezing อาจเกิดได้อีก 4-8 สัปดาห์\n\n2. Home care:\n   - Nasal saline drops + gentle suction ก่อนให้นมและก่อนนอน\n   - ให้นมบ่อยขึ้น มื้อเล็กลง\n   - Elevate head slightly ขณะนอน\n   - หลีกเลี่ยง secondhand smoke (ห้ามสูบบุหรี่ในบ้าน)\n   - Handwashing ล้างมือบ่อยๆ\n   - หลีกเลี่ยงสถานที่แออัด\n\n3. Warning signs กลับมาพบแพทย์ทันที:\n   - หายใจเร็ว/หายใจลำบากมาก\n   - หน้าอกบุ๋ม (retractions)\n   - ปากเขียว ตัวเขียว (cyanosis)\n   - ดูดนมไม่ได้เลย/ดูดได้น้อยมาก\n   - ซึมลง ไม่ตอบสนอง\n   - หยุดหายใจ (apnea)\n\nPalivizumab Prophylaxis:\n\n- Palivizumab (Synagis) = humanized monoclonal antibody ต่อ RSV F protein\n- ให้ IM 15 mg/kg ทุกเดือน ในช่วง RSV season (5 doses)\n\nIndications (AAP 2014):\n1. Premature infants < 29 weeks gestational age และอายุ < 12 เดือน ตอนเริ่ม RSV season\n2. Chronic Lung Disease of prematurity (BPD) อายุ < 24 เดือน ที่ยังต้องการ treatment\n3. Hemodynamically significant congenital heart disease อายุ < 12 เดือน\n4. Neuromuscular disease หรือ pulmonary abnormality ที่มี impaired airway clearance\n5. Immunocompromised children อายุ < 24 เดือน\n\nผู้ป่วยรายนี้:\n- คลอดครบกำหนด ไม่มีโรคหัวใจ ไม่มีโรคปอด\n- ไม่เข้าเกณฑ์สำหรับ Palivizumab prophylaxis\n- น้องฝาแฝดก็ไม่เข้าเกณฑ์เช่นกัน\n- ป้องกันโดย: hand hygiene, avoid sick contacts, breastfeeding\n\nRSV vaccine update:\n- RSV vaccine สำหรับหญิงตั้งครรภ์ (Abrysvo) ได้รับ FDA approval 2023\n- Nirsevimab (Beyfortus) = long-acting monoclonal antibody dose เดียว สำหรับทารกทุกราย",
        key_points: [
          "Discharge เมื่อ SpO2 >= 92% room air, adequate feeding, clinically improving",
          "Palivizumab สำหรับ high-risk infants เท่านั้น: premature < 29 wk, BPD, CHD",
          "ทารกปกติคลอดครบกำหนดไม่เข้าเกณฑ์ Palivizumab → ป้องกันด้วย hand hygiene",
          "Nirsevimab (Beyfortus) เป็น long-acting mAb ที่ให้ dose เดียวสำหรับทารกทุกราย",
        ],
        time_minutes: 10,
      },
    ],
  },
  {
    title: "ท้องนอกมดลูก (Ectopic Pregnancy)",
    category: "สูติศาสตร์-นรีเวชวิทยา",
    difficulty: "hard",
    is_free: false,
    status: "published",
    publish_date: "2026-04-14",
    created_by: "admin",
    parts: [
      {
        part_number: 1,
        title: "ส่วนที่ 1: การซักประวัติ ตรวจร่างกาย และ Beta-hCG",
        scenario:
          "หญิงไทย อายุ 30 ปี G2P1 มาห้องฉุกเฉินด้วยอาการปวดท้องน้อยด้านขวา 2 วัน ประจำเดือนขาด 6 สัปดาห์ มีเลือดออกทางช่องคลอดกะปริดกะปรอยสีน้ำตาลเข้ม 3 วัน\n\nประวัติ: LMP 6 สัปดาห์ก่อน ประจำเดือนมาสม่ำเสมอ cycle 28 วัน เคยผ่าตัด appendectomy 5 ปีก่อน เคยเป็น PID (Pelvic Inflammatory Disease) รักษาด้วยยาปฏิชีวนะ 2 ปีก่อน ไม่ได้คุมกำเนิด\n\nสัญญาณชีพ: BT 37.0°C, HR 92/min, BP 110/70 mmHg, RR 16/min\nตรวจร่างกาย: abdomen soft, mild tenderness RLQ, no peritoneal signs\nPelvic exam: cervical motion tenderness (+), right adnexal tenderness (+), no palpable mass, small amount dark blood in vagina, cervical os closed\n\nUrine pregnancy test: Positive\nSerum beta-hCG: 1,800 mIU/mL",
        question:
          "จงวิเคราะห์ risk factors, ให้ differential diagnosis, และอธิบายความสำคัญของระดับ beta-hCG",
        answer:
          "Risk Factors สำหรับ Ectopic Pregnancy ในผู้ป่วยรายนี้:\n1. ✓ ประวัติ PID — สาเหตุหลักของ tubal damage, เพิ่ม risk 6-10 เท่า\n2. ✓ Previous abdominal surgery (appendectomy) — pelvic adhesion\n3. อายุ > 35 ปี (ผู้ป่วย 30 ปี — borderline)\n4. Risk factors อื่นที่ต้องถาม: previous ectopic pregnancy, IUD use, infertility treatment, smoking, endometriosis\n\nDifferential Diagnosis:\n1. Ectopic pregnancy — most likely: ปวดท้องน้อยข้างเดียว + amenorrhea + vaginal bleeding + risk factors + cervical motion tenderness\n2. Threatened abortion — intrauterine pregnancy ที่มี bleeding แต่ cervix ยังปิด\n3. Complete/incomplete abortion — มักมี heavier bleeding + cervix open\n4. Corpus luteum cyst rupture — ปวดท้องน้อยข้างเดียว + positive pregnancy test ได้\n5. Heterotopic pregnancy — rare แต่พบมากขึ้นใน IVF patients\n\nความสำคัญของ Beta-hCG:\n- ระดับ 1,800 mIU/mL\n- Discriminatory zone:\n  - Transvaginal ultrasound (TVUS) ควรเห็น intrauterine gestational sac เมื่อ beta-hCG >= 1,500-2,000 mIU/mL (บาง center ใช้ 3,500)\n  - ถ้า beta-hCG > discriminatory zone แต่ไม่เห็น IUP บน TVUS → สูงสุงสัย ectopic pregnancy\n- ผู้ป่วย beta-hCG 1,800 → อยู่ใน discriminatory zone → ต้องทำ TVUS ทันที\n- Normal IUP: beta-hCG เพิ่มขึ้น >= 35% ทุก 48 ชั่วโมง (ก่อนหน้าใช้ 53% doubling time)\n- ถ้า beta-hCG ไม่เพิ่มตามปกติ (suboptimal rise) → สงสัย ectopic หรือ nonviable IUP\n- ถ้า beta-hCG ลดลง → อาจเป็น complete abortion หรือ resolving ectopic\n\nImmediate plan:\n1. TVUS ทันที\n2. CBC: baseline Hb/Hct\n3. Blood type + Rh + crossmatch (เตรียมเลือด)\n4. Coagulation profile\n5. ถ้า Rh negative → ต้องให้ Anti-D immunoglobulin",
        key_points: [
          "Classic triad ของ ectopic pregnancy: amenorrhea + vaginal bleeding + abdominal pain",
          "PID เป็น risk factor หลักของ ectopic pregnancy เพิ่ม risk 6-10 เท่า",
          "Discriminatory zone: beta-hCG >= 1,500-2,000 ควรเห็น IUP บน TVUS",
          "ถ้า beta-hCG above discriminatory zone แต่ไม่เห็น IUP → highly suspicious for ectopic",
        ],
        time_minutes: 10,
      },
      {
        part_number: 2,
        title: "ส่วนที่ 2: Transvaginal Ultrasound Findings",
        scenario:
          "ผล Transvaginal Ultrasound (TVUS):\n- Uterus: anteverted, normal size, endometrium thickened 12 mm\n- No intrauterine gestational sac seen\n- No intrauterine pregnancy\n- Right adnexa: พบ inhomogeneous mass ขนาด 3.2 × 2.5 cm ข้าง right ovary แต่แยกจาก ovary ได้\n  - มี echogenic ring ('tubal ring' หรือ 'bagel sign')\n  - มี yolk sac เห็นภายใน mass\n  - ไม่เห็น fetal cardiac activity\n- Left adnexa: normal, corpus luteum cyst 2 cm ที่ left ovary\n- Cul-de-sac: small amount of free fluid (minimal)\n- No hemoperitoneum\n\nCBC: Hb 11.8 g/dL, Hct 35%, WBC 8,200, Plt 245,000\nBlood type: A Rh positive",
        question:
          "จงแปลผล TVUS และ classify ectopic pregnancy ตามตำแหน่งและ staging",
        answer:
          "การแปลผล TVUS:\n\n1. No intrauterine pregnancy (IUP) ที่ beta-hCG 1,800 (above discriminatory zone)\n   → แยก viable IUP ออกได้\n\n2. Right adnexal mass 3.2 × 2.5 cm:\n   - Tubal ring sign (bagel sign) = echogenic ring รอบ gestational sac นอก uterus\n   - Yolk sac visible → ยืนยัน ectopic pregnancy\n   - แยกจาก ovary ได้ → tubal ectopic (ไม่ใช่ ovarian)\n   - No cardiac activity → non-viable ectopic\n\n3. Free fluid เล็กน้อย → อาจมี minimal bleeding แต่ยังไม่ rupture\n\n4. Corpus luteum cyst ที่ left ovary → ปกติพบใน early pregnancy\n   - ต้องแยกจาก ectopic: corpus luteum อยู่ใน ovary, ectopic อยู่นอก ovary\n\nDiagnosis: Unruptured Right Tubal Ectopic Pregnancy\n\nClassification ตามตำแหน่ง:\n1. Tubal (95-97%): ✓ ผู้ป่วยรายนี้\n   - Ampullary (70%) — พบบ่อยที่สุด\n   - Isthmic (12%)\n   - Fimbrial (11%)\n   - Interstitial/Cornual (2-3%) — อันตราย rupture รุนแรง\n2. Ovarian (1-3%)\n3. Cervical (< 1%)\n4. Abdominal (1.4%)\n5. Cesarean scar ectopic (rare)\n6. Heterotopic (1 in 30,000 natural, 1 in 100 ART)\n\nStaging/Severity assessment:\n- ผู้ป่วย hemodynamically stable (BP 110/70, HR 92)\n- Mass ขนาด 3.2 cm (< 3.5-4 cm)\n- No fetal cardiac activity\n- Minimal free fluid (no significant hemoperitoneum)\n- Hb 11.8 → ไม่มี significant blood loss\n- beta-hCG 1,800 mIU/mL\n→ Unruptured ectopic, hemodynamically stable\n→ เป็น candidate สำหรับทั้ง medical treatment (Methotrexate) หรือ surgery",
        key_points: [
          "Tubal ring sign (bagel sign) บน TVUS เป็น classic finding ของ tubal ectopic",
          "Tubal ectopic pregnancy พบ 95-97% โดย ampullary location พบบ่อยที่สุด",
          "ต้องแยก corpus luteum cyst จาก ectopic pregnancy — CL อยู่ใน ovary",
          "Free fluid เล็กน้อยอาจปกติ แต่ถ้ามากต้องสงสัย rupture",
        ],
        time_minutes: 10,
      },
      {
        part_number: 3,
        title: "ส่วนที่ 3: Methotrexate vs Surgical Decision",
        scenario:
          "สรุปข้อมูลผู้ป่วย:\n- อายุ 30 ปี G2P1 ต้องการมีบุตรอีก\n- Right tubal ectopic pregnancy, unruptured\n- Hemodynamically stable\n- Beta-hCG 1,800 mIU/mL\n- Mass 3.2 cm\n- No fetal cardiac activity\n- Minimal free fluid\n\nLab เพิ่มเติม:\n- LFT: AST 22, ALT 18 (ปกติ)\n- Cr 0.7 mg/dL (ปกติ)\n- CBC: Hb 11.8, WBC 8,200, Plt 245,000 (ปกติ)\n- Blood type: A Rh positive",
        question:
          "จงเปรียบเทียบ Methotrexate treatment กับ surgical management พร้อมอธิบาย criteria ในการเลือก",
        answer:
          "เปรียบเทียบ Methotrexate (MTX) vs Surgery:\n\nMethotrexate — Medical Management:\n\nCriteria ที่เหมาะสำหรับ MTX (ต้องครบทุกข้อ):\n1. ✓ Hemodynamically stable\n2. ✓ Unruptured ectopic\n3. ✓ beta-hCG < 5,000 mIU/mL (ดีที่สุดถ้า < 3,000)\n4. ✓ Mass < 3.5-4 cm\n5. ✓ No fetal cardiac activity\n6. ✓ สามารถ follow-up ได้สม่ำเสมอ\n7. ✓ LFT, CBC, renal function ปกติ\n8. ไม่มี contraindications: immunodeficiency, blood dyscrasia, active PUD, liver/renal disease, breastfeeding\n\n→ ผู้ป่วยรายนี้ เข้าเกณฑ์ MTX ✓\n\nMTX Protocol — Single-dose regimen:\n- MTX 50 mg/m² IM (single dose)\n- BSA calculation: ใช้ nomogram หรือ Mosteller formula\n- Day 1: ให้ MTX + ตรวจ beta-hCG baseline\n- Day 4: ตรวจ beta-hCG (อาจเพิ่มขึ้นได้ → ปกติ)\n- Day 7: ตรวจ beta-hCG → ต้องลดลง >= 15% จาก Day 4\n  - ถ้าลด >= 15% → follow weekly จนกว่า < 5 mIU/mL\n  - ถ้าลด < 15% → ให้ MTX dose ที่ 2\n- Success rate: 82-94% สำหรับ single dose (ถ้า beta-hCG < 5,000)\n\nSide effects ของ MTX:\n- คลื่นไส้ อาเจียน, stomatitis, ปวดท้อง (separation pain วันที่ 3-7)\n- Transient LFT elevation\n- Bone marrow suppression (rare ในระดับ dose นี้)\n- ห้ามตั้งครรภ์ 3 เดือนหลังให้ MTX (teratogenic)\n\nSurgical Management — Laparoscopic Salpingectomy/Salpingotomy:\n\nIndications สำหรับ surgery:\n- Hemodynamically unstable (ruptured ectopic)\n- beta-hCG > 5,000 mIU/mL\n- Mass > 4 cm\n- Fetal cardiac activity present\n- Contraindication to MTX\n- ไม่สามารถ follow-up ได้\n- MTX failure\n\nSalpingectomy vs Salpingotomy:\n- Salpingectomy (ตัด tube ออก): recommended ถ้า contralateral tube ปกติ\n  - ลด risk ของ persistent ectopic\n  - ลด risk ของ recurrent ectopic ใน tube เดิม\n- Salpingotomy (เปิด tube เอา ectopic ออก): พิจารณาถ้า contralateral tube damaged หรือ absent\n  - เก็บ tube ไว้เพื่อ future fertility\n  - Risk: persistent trophoblastic tissue 5-20% → ต้อง follow beta-hCG\n\nสำหรับผู้ป่วยรายนี้:\n- เข้าเกณฑ์ MTX ทุกข้อ\n- ต้องการมีบุตรอีก → MTX เป็น first-line เพราะ conserve tube\n- แนะนำ: MTX single-dose protocol\n- Plan B: ถ้า MTX fail → laparoscopic surgery",
        key_points: [
          "MTX criteria: stable, unruptured, beta-hCG < 5,000, mass < 4 cm, no FHB, normal labs",
          "MTX single-dose: 50 mg/m² IM ตรวจ beta-hCG day 4 และ 7 ต้องลด >= 15%",
          "Salpingectomy แนะนำถ้า contralateral tube ปกติ, salpingotomy ถ้า tube เดียว",
          "ห้ามตั้งครรภ์ 3 เดือนหลัง MTX เนื่องจาก teratogenic effect",
        ],
        time_minutes: 10,
      },
      {
        part_number: 4,
        title: "ส่วนที่ 4: Laparoscopic Salpingectomy",
        scenario:
          "สมมุติว่าผู้ป่วยเลือก surgical management (หรือ MTX fail):\n\nPre-operative:\n- Hemodynamically stable\n- Informed consent: อธิบายเรื่อง salpingectomy vs salpingotomy\n- ผู้ป่วยเลือก salpingectomy เนื่องจาก contralateral tube ปกติบน US\n\nIntra-operative findings:\n- Right fallopian tube: ampullary region ขยายขนาด 3 × 2.5 cm สีม่วงคล้ำ\n- ไม่มี rupture แต่มี hematosalpinx (เลือดใน tube)\n- Left tube: ปกติ\n- Both ovaries: ปกติ\n- Uterus: ปกติ\n- Minimal blood in cul-de-sac (~30 mL)\n- ไม่พบ adhesion ที่รุนแรง",
        question:
          "จงอธิบายขั้นตอนสำคัญของ laparoscopic salpingectomy และ complications ที่ต้องระวัง",
        answer:
          "Laparoscopic Salpingectomy — Key Steps:\n\n1. Patient setup:\n   - General anesthesia, supine, Trendelenburg position (15-20°)\n   - Foley catheter\n   - Uterine manipulator (ช่วย expose adnexa)\n\n2. Port placement:\n   - Umbilical 10 mm (camera — Hasson open technique)\n   - Left lower quadrant 5 mm (working port)\n   - Suprapubic 5 mm (additional working port)\n   - CO2 pneumoperitoneum 12-15 mmHg\n\n3. Survey:\n   - ตรวจดู pelvis ทั้งหมด: tubes, ovaries, uterus, cul-de-sac\n   - ยืนยัน ectopic site: right ampullary tubal ectopic\n   - ตรวจ contralateral tube ว่าปกติ\n   - Aspirate fluid/blood ใน cul-de-sac\n\n4. Salpingectomy technique:\n   - Identify mesosalpinx (mesentery ของ tube)\n   - Coagulate mesosalpinx จาก fimbrial end ไปหา cornual end\n     - ใช้ bipolar electrocautery หรือ harmonic scalpel\n     - ระวัง: ovarian vessels อยู่ใกล้ tube → เก็บ ovary ไว้\n   - Coagulate tube ที่ isthmic region ใกล้ uterine cornu\n   - Transect tube: ตัดที่ proximal end (ใกล้ uterus)\n     - ใช้ scissors หรือ harmonic scalpel\n   - Remove specimen ใน endobag\n   - Hemostasis check: ดู cornual stump, mesosalpinx\n\n5. Specimen:\n   - ส่ง pathology: ยืนยัน ectopic pregnancy (chorionic villi ใน tube)\n\n6. Closure:\n   - Release pneumoperitoneum\n   - Close fascial defect ที่ umbilical port\n   - Skin closure\n\nComplications ที่ต้องระวัง:\n\n1. Intra-operative:\n   - Hemorrhage จาก mesosalpingeal vessels\n   - Injury to ovarian blood supply → ต้อง preserve ovary\n   - Bowel/bladder injury จาก port insertion\n   - Incomplete removal → persistent ectopic (ต้อง follow beta-hCG)\n\n2. Post-operative:\n   - Persistent trophoblastic tissue: ถ้า beta-hCG ไม่ลดลงเป็นศูนย์ → อาจต้อง MTX\n   - Wound infection\n   - Port-site hernia (umbilical)\n   - Adhesion formation → อาจส่งผลต่อ future fertility\n\n3. Long-term:\n   - Recurrent ectopic pregnancy (10-15% risk)\n   - Reduced fertility (แต่ยังมีโอกาสตั้งครรภ์ปกติ ~60% ด้วย tube เดียว)\n   - Grief/emotional impact จากการสูญเสียการตั้งครรภ์",
        key_points: [
          "Salpingectomy ตัด tube ที่ isthmic region ใช้ bipolar/harmonic coagulate mesosalpinx",
          "ต้อง preserve ovary อย่างระวัง ovarian blood supply ขณะตัด tube",
          "ส่ง specimen pathology ยืนยัน chorionic villi ใน tube เสมอ",
          "Recurrent ectopic risk 10-15% ต้อง counsel ผู้ป่วยเรื่องนี้",
        ],
        time_minutes: 10,
      },
      {
        part_number: 5,
        title: "ส่วนที่ 5: Post-op Monitoring และ Beta-hCG Follow-up",
        scenario:
          "หลังผ่าตัด Laparoscopic Right Salpingectomy:\n- Operative time: 45 minutes\n- EBL: 50 mL\n- ผ่าตัดราบรื่น ไม่มี complications\n\nPost-op Day 1:\n- Vital signs stable, afebrile\n- Pain score 3/10 on oral analgesics\n- Tolerating oral intake\n- Ambulating\n- Beta-hCG: 1,200 mIU/mL (ลดจาก 1,800 pre-op)\n\nPathology (preliminary): chorionic villi identified in right fallopian tube specimen — confirmed ectopic pregnancy\n\nPost-op Day 7:\n- Beta-hCG: 85 mIU/mL\n- แผลหายดี ไม่มี infection",
        question:
          "จงอธิบาย beta-hCG monitoring protocol หลังผ่าตัด และการจัดการถ้า beta-hCG ไม่ลดเป็นศูนย์",
        answer:
          "Beta-hCG Monitoring Protocol หลัง Salpingectomy:\n\nExpected beta-hCG decline:\n- Beta-hCG ควรลดลง > 50% ทุก 48 ชั่วโมง หลังผ่าตัด\n- ผู้ป่วย: 1,800 → 1,200 (Day 1) = ลด 33% — ยังน้อยไป observe ต่อ\n- Day 7: 85 mIU/mL = ลด 95% จาก pre-op → ตอบสนองดี\n- คาดว่าจะถึง < 5 mIU/mL ภายใน 2-3 สัปดาห์หลังผ่าตัด\n\nFollow-up schedule:\n1. Day 1 post-op: beta-hCG (baseline post-op)\n2. Day 7: beta-hCG (ตรวจ)\n3. Weekly beta-hCG จนกว่า < 5 mIU/mL (undetectable)\n4. เมื่อ beta-hCG < 5 → ถือว่า resolved → หยุด follow\n\nสำหรับผู้ป่วยรายนี้:\n- Day 1: 1,200 → Day 7: 85 → คาดว่า Day 14: < 5 mIU/mL\n- Trend ดีมาก → likely complete resolution\n\nการจัดการถ้า beta-hCG ไม่ลดเป็นศูนย์:\n\nPersistent Trophoblastic Tissue:\n- Definition: beta-hCG plateau (ไม่ลดลง) หรือเพิ่มขึ้นหลังผ่าตัด\n- พบ 5-20% หลัง salpingotomy, < 5% หลัง salpingectomy\n\nถ้า beta-hCG plateau หรือเพิ่มขึ้น:\n1. ตรวจ TVUS: ดูว่ามี residual mass หรือไม่\n2. ถ้า hemodynamically stable:\n   - Methotrexate 50 mg/m² IM single dose\n   - Follow beta-hCG weekly จนกว่า < 5\n3. ถ้ามี signs of rupture/active bleeding:\n   - Emergency surgery\n   - Re-laparoscopy: cornual stump excision\n\nRed flags ที่ต้องกลับมาทันที:\n- ปวดท้องรุนแรง\n- เลือดออกทางช่องคลอดมาก\n- เวียนศีรษะ เป็นลม (signs of internal bleeding)\n- ไข้ > 38°C (surgical site infection)\n\nMonitoring ระหว่าง follow-up:\n- Hb/Hct ถ้ามี vaginal bleeding มาก\n- Rh status: ผู้ป่วย A Rh positive → ไม่ต้องให้ Anti-D\n- ถ้าเป็น Rh negative → ต้องให้ Anti-D immunoglobulin 300 mcg IM",
        key_points: [
          "Beta-hCG ต้อง follow weekly จนกว่า < 5 mIU/mL หลังผ่าตัด",
          "Persistent trophoblast (beta-hCG ไม่ลด) รักษาด้วย MTX 50 mg/m² IM",
          "Salpingectomy มี persistent trophoblast rate < 5% ต่ำกว่า salpingotomy",
          "Rh-negative ผู้ป่วยต้องได้ Anti-D immunoglobulin ทุกราย",
        ],
        time_minutes: 10,
      },
      {
        part_number: 6,
        title: "ส่วนที่ 6: Future Fertility Counseling และ Contraception",
        scenario:
          "2 สัปดาห์หลังผ่าตัด:\n- Beta-hCG: < 5 mIU/mL (undetectable) → resolved\n- แผลหายสนิท\n- ผู้ป่วยกลับมาพบแพทย์เพื่อรับคำปรึกษาเรื่อง:\n  1. โอกาสตั้งครรภ์ในอนาคต\n  2. ความเสี่ยงเป็นท้องนอกมดลูกซ้ำ\n  3. การคุมกำเนิดที่เหมาะสม\n  4. เมื่อไรจะตั้งครรภ์ได้อีก\n\nประวัติเพิ่มเติม:\n- สามีอายุ 32 ปี แข็งแรงดี\n- มีลูก 1 คน อายุ 3 ปี (ตั้งครรภ์เองไม่มีปัญหา)\n- เหลือ left tube ปกติ, both ovaries ปกติ",
        question:
          "จงให้คำปรึกษาเรื่อง fertility, ความเสี่ยงท้องนอกมดลูกซ้ำ, การคุมกำเนิด, และ timing ของการตั้งครรภ์ครั้งต่อไป",
        answer:
          "Fertility Counseling:\n\n1. โอกาสตั้งครรภ์ในอนาคต:\n- มี left tube ปกติ + both ovaries ปกติ → ยังตั้งครรภ์ได้\n- Intrauterine pregnancy rate หลัง salpingectomy: ประมาณ 56-65%\n- Ovulation เกิดสลับข้างทุกเดือน (ไม่จริงเสมอไป)\n- Transperitoneal egg migration: ไข่จาก right ovary สามารถถูก pick up โดย left tube ได้ (cross-migration)\n- ถ้าผ่าน 12 เดือนไม่ตั้งครรภ์ → ส่งพบ reproductive endocrinologist\n- อาจพิจารณา HSG (hysterosalpingography) ก่อนเพื่อยืนยัน left tube patent\n\n2. ความเสี่ยงท้องนอกมดลูกซ้ำ:\n- Recurrent ectopic pregnancy rate: 10-15% (สูงกว่า population ทั่วไปที่ 1-2%)\n- Risk factors ที่ยังมี: ประวัติ PID, previous ectopic\n- ท้องนอกมดลูกซ้ำสามารถเกิดที่ left tube ได้\n- ครรภ์ถัดไปต้อง early US ยืนยัน location ทันทีที่ urine pregnancy test positive\n  - First TVUS ที่ 5-6 สัปดาห์ (beta-hCG 1,500-2,000) เพื่อยืนยัน IUP\n\n3. การคุมกำเนิดที่เหมาะสม:\n- เลือกได้ทุกวิธี (ไม่มี specific contraindication จาก ectopic pregnancy)\n- แนะนำ:\n  a) Combined OCP (ยาเม็ดคุมกำเนิด): เริ่มได้ทันทีหลัง beta-hCG = 0\n  b) IUD (Copper หรือ Levonorgestrel): ปลอดภัย ไม่เพิ่ม ectopic risk\n     - IUD ลด ectopic risk เพราะลด overall pregnancy rate\n     - ถ้า conceive with IUD → higher proportion ectopic (ไม่ใช่เพิ่ม absolute risk)\n  c) Progesterone-only methods: implant (Implanon), DMPA injection\n  d) Barrier methods: condom (ลด PID risk ด้วย)\n- คุมกำเนิดจนกว่าพร้อมตั้งครรภ์อีก\n\n4. Timing ของการตั้งครรภ์ครั้งต่อไป:\n- หลัง salpingectomy (ไม่ได้ MTX): รอประจำเดือนมาปกติ 1-2 รอบ (ประมาณ 2-3 เดือน)\n- ถ้าเคยได้ MTX: รออย่างน้อย 3 เดือนหลัง last dose (MTX teratogenic)\n- ผู้ป่วยรายนี้ไม่ได้ MTX → รอ 2-3 เดือน\n- เริ่ม folic acid 400-800 mcg/day อย่างน้อย 1 เดือนก่อนตั้งครรภ์\n\n5. Emotional support:\n- Acknowledge grief จากการสูญเสียการตั้งครรภ์\n- Offer counseling/support group ถ้าต้องการ\n- Reassure ว่ามีโอกาสตั้งครรภ์ปกติได้\n- Partner counseling ร่วมด้วย\n\n6. Plan for next pregnancy:\n- Early beta-hCG เมื่อ pregnancy test positive\n- Early TVUS ที่ 5-6 สัปดาห์ ยืนยัน IUP\n- Close follow-up ใน first trimester",
        key_points: [
          "Intrauterine pregnancy rate หลัง unilateral salpingectomy ประมาณ 56-65%",
          "Recurrent ectopic pregnancy risk 10-15% ต้อง early US ยืนยัน location ทุกครรภ์",
          "หลัง salpingectomy (ไม่ได้ MTX) รอ 2-3 เดือนก่อนตั้งครรภ์อีก",
          "IUD ไม่เพิ่ม absolute risk ของ ectopic pregnancy ปลอดภัยใช้ได้",
        ],
        time_minutes: 10,
      },
    ],
  },
];

// ============================================================
// Main seeding function
// ============================================================

async function main() {
  console.log("=== Seed Batch 2: 5 Exams × 6 Parts ===\n");

  for (const exam of exams) {
    const { parts, ...examData } = exam;

    // 1. Insert exam
    console.log(`Creating exam: ${examData.title}`);
    const { data: insertedExam, error: examError } = await supabase
      .from("exams")
      .insert(examData)
      .select("id, title")
      .single();

    if (examError) {
      console.error(`  ERROR inserting exam:`, examError);
      process.exit(1);
    }

    const examId = insertedExam.id;
    console.log(`  ✓ Exam created: ${examId}`);

    // 2. Insert 6 parts
    const rows = parts.map((p) => ({
      exam_id: examId,
      part_number: p.part_number,
      title: p.title,
      scenario: p.scenario,
      question: p.question,
      answer: p.answer,
      key_points: p.key_points,
      time_minutes: p.time_minutes,
    }));

    const { data: insertedParts, error: partsError } = await supabase
      .from("exam_parts")
      .insert(rows)
      .select("id, part_number");

    if (partsError) {
      console.error(`  ERROR inserting parts:`, partsError);
      process.exit(1);
    }

    console.log(`  ✓ ${insertedParts.length} parts created`);
  }

  console.log("\n=== Done! 5 exams with 30 parts total seeded ===");
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
