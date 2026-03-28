-- Long Case Schema for Morroo
-- Run this in Supabase SQL Editor

-- ============================================================
-- TABLE: long_cases
-- ============================================================
CREATE TABLE IF NOT EXISTS public.long_cases (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  specialty     TEXT NOT NULL,
  difficulty    TEXT NOT NULL DEFAULT 'medium', -- easy | medium | hard
  week_number   INT,
  is_weekly     BOOLEAN DEFAULT FALSE,
  is_published  BOOLEAN DEFAULT TRUE,
  published_at  TIMESTAMPTZ DEFAULT NOW(),

  -- Patient info shown at start (NO chief complaint)
  patient_info      JSONB NOT NULL DEFAULT '{}',
  -- Full history script for AI patient (student never sees)
  history_script    JSONB NOT NULL DEFAULT '{}',
  -- PE findings by system — revealed only when student selects
  pe_findings       JSONB NOT NULL DEFAULT '{}',
  -- Lab/imaging results — revealed only when ordered
  lab_results       JSONB NOT NULL DEFAULT '{}',
  imaging_results   JSONB,

  -- Answer key
  correct_diagnosis   TEXT NOT NULL DEFAULT '',
  accepted_ddx        JSONB NOT NULL DEFAULT '[]',
  management_plan     TEXT NOT NULL DEFAULT '',
  teaching_points     JSONB NOT NULL DEFAULT '[]',

  -- Examiner
  examiner_questions  JSONB NOT NULL DEFAULT '[]',
  scoring_rubric      JSONB NOT NULL DEFAULT '{}',

  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: long_case_sessions
-- ============================================================
CREATE TABLE IF NOT EXISTS public.long_case_sessions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  case_id     UUID NOT NULL REFERENCES public.long_cases(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Progress
  phase       TEXT NOT NULL DEFAULT 'history', -- history | pe | lab | ddx | management | examiner | done

  -- Student answers
  history_chat    JSONB DEFAULT '[]',
  pe_selected     JSONB DEFAULT '[]',
  lab_ordered     JSONB DEFAULT '[]',
  student_ddx     TEXT,
  student_mgmt    TEXT,
  examiner_chat   JSONB DEFAULT '[]',

  -- Scores (0–100 each)
  score_history     INT,
  score_pe          INT,
  score_lab         INT,
  score_ddx         INT,
  score_management  INT,
  score_examiner    INT,
  score_total_pct   INT,

  feedback    TEXT,
  started_at  TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,

  UNIQUE(case_id, user_id)  -- one session per case per user (latest attempt)
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_long_cases_published ON public.long_cases(is_published, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_long_cases_weekly ON public.long_cases(is_weekly, week_number DESC);
CREATE INDEX IF NOT EXISTS idx_long_case_sessions_user ON public.long_case_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_long_case_sessions_case ON public.long_case_sessions(case_id);

-- ============================================================
-- RLS Policies
-- ============================================================
ALTER TABLE public.long_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.long_case_sessions ENABLE ROW LEVEL SECURITY;

-- long_cases: anyone can read published cases
CREATE POLICY "Published cases are viewable by all"
  ON public.long_cases FOR SELECT
  USING (is_published = TRUE);

-- long_cases: only service_role can insert/update/delete
CREATE POLICY "Service role manages cases"
  ON public.long_cases FOR ALL
  USING (auth.role() = 'service_role');

-- long_case_sessions: users can only see their own sessions
CREATE POLICY "Users can view own sessions"
  ON public.long_case_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own sessions"
  ON public.long_case_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions"
  ON public.long_case_sessions FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================================
-- SEED: 3 Initial Long Cases
-- ============================================================
INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES

-- Case 1: Testicular Torsion
(
  'ชาย 19 ปี ปวดท้องร้าวลงอัณฑะ',
  'Surgery',
  'hard',
  1,
  TRUE,
  '{"name":"นายสมชาย ใจดี","age":19,"gender":"ชาย","underlying":[],"allergies":[],"vitals":{"bp":"125/75","hr":105,"rr":18,"temp":37.2,"o2sat":99}}',
  '{"cc":"ปวดท้องและปวดอัณฑะซ้ายเฉียบพลัน 3 ชั่วโมง","onset":"เจ็บปวดฉับพลัน ขณะตื่นนอน ปวดมากขึ้นเรื่อยๆ","pi":"เจ็บปวดอัณฑะซ้ายรุนแรง ร้าวขึ้นท้องน้อยซ้าย คลื่นไส้อาเจียน 1 ครั้ง ไม่มีไข้ ไม่ปวดแสบปัสสาวะ ไม่มีปัญหาเกี่ยวกับปัสสาวะ เคยมีอาการคล้ายกันและหายเองเมื่อ 2 เดือนก่อน","pmh":"ไม่มีโรคประจำตัว","sh":"นักศึกษา ไม่สูบบุหรี่ ไม่ดื่มเหล้า"}',
  '{"GA":"ชายหนุ่ม ดูเจ็บปวดมาก กระสับกระส่าย","Abdomen":"กดเจ็บท้องน้อยซ้ายเล็กน้อย ไม่มี rebound tenderness","GU":"อัณฑะซ้ายบวม แดง กดเจ็บมาก อยู่สูงกว่าปกติ (high-riding testis) Cremasteric reflex ซ้ายหายไป","Heart":"Regular, no murmur","Lung":"Clear"}',
  '{"UA":{"value":"Normal, no pyuria, no hematuria","isAbnormal":false},"CBC":{"value":"WBC 11,200, Hb 14.8, Plt 285,000","isAbnormal":true},"Scrotal US":{"value":"Decreased blood flow to left testis on Doppler, heterogeneous echotexture","isAbnormal":true}}',
  'Testicular Torsion (ลูกอัณฑะบิดขั้ว)',
  '["Testicular Torsion","Epididymo-orchitis","Incarcerated hernia"]',
  'Emergency surgical exploration and detorsion within 6 hours; bilateral orchiopexy; ถ้าเนื้อตายต้องทำ orchiectomy',
  '["Testicular torsion = surgical emergency ต้องผ่าตัดภายใน 6 ชม. จะรักษาอัณฑะได้ >90%","High-riding testis + absent cremasteric reflex = classic signs","ห้าม delay โดยรอผล Doppler US ถ้า clinical suspicion สูง","ประวัติ intermittent torsion (เจ็บแล้วหาย) = ต้องผ่าตัดป้องกัน","Bell-clapper deformity = bilateral anatomical abnormality"]',
  '[{"question":"บอกสาเหตุที่ cremasteric reflex หายไปในเคสนี้","modelAnswer":"Testicular torsion ทำให้เส้นประสาทและหลอดเลือดที่ spermatic cord ถูกบิด ทำให้ reflex arc ขาดออก","points":15},{"question":"ถ้า Doppler US ปกติ คุณจะยังผ่าตัดไหม เหตุผลอะไร","modelAnswer":"ใช่ เพราะ clinical diagnosis of torsion มีความสำคัญกว่า imaging ถ้า high clinical suspicion ควร surgical exploration ทันที Doppler อาจให้ false negative ได้","points":20},{"question":"bilateral orchiopexy ทำไมต้องทำทั้งสองข้าง","modelAnswer":"Bell-clapper deformity เป็น bilateral anatomical abnormality เสี่ยง contralateral torsion ได้ จึงต้อง orchiopexy ทั้งสองข้างในคราวเดียว","points":15},{"question":"ถ้ามาหลัง 24 ชั่วโมง ผลของ testis จะเป็นอย่างไร","modelAnswer":"Testicular atrophy หรือ necrosis สูง ต้องทำ orchiectomy อัตราการรักษาอัณฑะได้ต่ำมาก <10% หลัง 24 ชม.","points":10}]',
  '{"history":25,"pe":20,"lab":15,"ddx":20,"management":20}'
),

-- Case 2: Ectopic Pregnancy
(
  'หญิง 26 ปี ปวดท้องน้อยและเป็นลม',
  'Obstetrics',
  'hard',
  2,
  TRUE,
  '{"name":"นางสาวมาลี สวยงาม","age":26,"gender":"หญิง","underlying":[],"allergies":[],"vitals":{"bp":"85/55","hr":128,"rr":22,"temp":37.0,"o2sat":97}}',
  '{"cc":"ปวดท้องน้อยเฉียบพลัน วูบเป็นลม","onset":"ปวดท้องน้อยซ้ายมา 6 ชั่วโมง เพิ่งวูบเกือบเป็นลม","pi":"ประจำเดือนขาด 7 สัปดาห์ ตรวจ urine pregnancy test เป็นบวกที่บ้านเมื่อ 2 สัปดาห์ก่อน มีเลือดออกทางช่องคลอดสีน้ำตาลเล็กน้อย 3 วัน ปวดท้องน้อยซ้ายมาก ร้าวขึ้นไหล่ซ้าย (shoulder tip pain) เป็นลมเมื่อลุกเร็ว","pmh":"ประวัติ PID รักษาแล้ว 2 ปีก่อน","sh":"โสด ทำงานออฟฟิศ"}',
  '{"GA":"หญิงสาว ดูซีด เหงื่อแตก กระสับกระส่าย","Abdomen":"กดเจ็บท้องน้อยซ้ายมาก มี rebound tenderness, guarding ท้องน้อยซ้าย","GU":"Uterus normal size, left adnexal mass + tenderness, cervical motion tenderness (+), cul-de-sac fullness"}',
  '{"UPT":{"value":"Positive","isAbnormal":true},"serum Beta-hCG":{"value":"3,840 mIU/mL (ไม่สัมพันธ์กับ GA 7 weeks)","isAbnormal":true},"CBC":{"value":"WBC 13,500, Hb 9.2↓, Plt 320,000","isAbnormal":true},"Transvaginal US":{"value":"Empty uterus, left adnexal mass 3.2 cm, free fluid in cul-de-sac","isAbnormal":true}}',
  'Ruptured Ectopic Pregnancy',
  '["Ruptured Ectopic Pregnancy","Threatened Abortion","Ovarian cyst torsion/rupture"]',
  'Emergency laparoscopic/open salpingectomy; IV fluid resuscitation; blood transfusion; ปรึกษา OB/GYN STAT',
  '["Ruptured ectopic = hemodynamic emergency ผ่าตัดทันที","Shoulder tip pain = referred pain จาก diaphragm irritation ด้วย hemoperitoneum","Empty uterus + hCG 3,840 + adnexal mass = ectopic จนกว่าจะพิสูจน์ว่าไม่ใช่","Discriminatory zone: ถ้า hCG >1,500-2,000 ควรเห็น gestational sac ใน uterus ด้วย TVUS","Risk factors: PID, previous ectopic, IUD"]',
  '[{"question":"Discriminatory zone คืออะไร และสำคัญอย่างไรในเคสนี้","modelAnswer":"Discriminatory zone คือระดับ serum hCG (~1,500-2,000 mIU/mL) ที่ควรเห็น gestational sac ใน uterus ด้วย TVUS เคสนี้ hCG 3,840 แต่ empty uterus บ่งชี้ ectopic pregnancy","points":20},{"question":"Shoulder tip pain เกิดจากอะไร","modelAnswer":"เลือดออก (hemoperitoneum) ระคายเคือง diaphragm ทำให้ปวดร้าวไปที่ไหล่ผ่าน phrenic nerve (C3-C5)","points":15},{"question":"ถ้าผู้ป่วย hemodynamically stable และ hCG ต่ำ จะมีทางเลือกอื่นนอกจากผ่าตัดไหม","modelAnswer":"ใช่ ถ้า unruptured ectopic, hemodynamically stable, hCG <5,000, no cardiac activity on US, ขนาด <3.5 cm อาจใช้ Methotrexate (MTX) ได้","points":15},{"question":"หลังรักษา ควรแนะนำเรื่องการตั้งครรภ์ครั้งต่อไปอย่างไร","modelAnswer":"ความเสี่ยง recurrent ectopic ~10-15%; ต้องทำ early US เมื่อทราบว่าตั้งครรภ์; ตรวจ serum hCG serial เพื่อ confirm IUP","points":10}]',
  '{"history":25,"pe":20,"lab":20,"ddx":20,"management":15}'
),

-- Case 3: Inferior STEMI
(
  'ชาย 58 ปี เจ็บแน่นหน้าอกร้าวกราม',
  'Cardiology',
  'medium',
  3,
  TRUE,
  '{"name":"นายประสิทธิ์ ดีงาม","age":58,"gender":"ชาย","underlying":["DM type 2","HT","Dyslipidemia"],"allergies":["Aspirin allergy denied"],"vitals":{"bp":"100/70","hr":52,"rr":20,"temp":37.1,"o2sat":94}}',
  '{"cc":"เจ็บแน่นหน้าอกรุนแรง 2 ชั่วโมง","onset":"เจ็บแน่นกลางอกร้าวขากรรไกรซ้ายและแขนซ้าย เริ่ม 2 ชั่วโมงก่อน","pi":"เจ็บแน่นหนักๆ กลางอก คะแนน 9/10 ไม่ดีขึ้นเลย มีเหงื่อแตก คลื่นไส้ อาเจียน 1 ครั้ง หายใจหน่อยเหนื่อย ไม่เคยเจ็บแบบนี้มาก่อน ทานยา DM HT Statin อยู่","pmh":"DM 10 ปี, HT 8 ปี, Dyslipidemia","sh":"สูบบุหรี่ 20 ปี ปัจจุบันเลิกแล้ว 5 ปี ดื่มเบียร์นานๆ ครั้ง"}',
  '{"GA":"ชายวัยกลางคน เหงื่อแตก ดูเจ็บปวด agitated","Heart":"Bradycardia, regular rhythm, S1S2 normal, no murmur","Lung":"Few bibasal crepitations","Neck":"JVP elevated 5 cm","Extremities":"Cool, diaphoretic"}',
  '{"12-lead ECG":{"value":"ST elevation 2-3mm in leads II, III, aVF; reciprocal ST depression in I, aVL; AV block 1st degree; HR 52","isAbnormal":true},"Troponin I":{"value":"8.5 ng/mL↑↑ (normal <0.04)","isAbnormal":true},"CBC":{"value":"WBC 14,200, Hb 13.8, Plt 310,000","isAbnormal":false},"BMP":{"value":"Na 138, K 4.8, Cr 1.1, Glu 210","isAbnormal":true},"CXR":{"value":"Mild cardiomegaly, early pulmonary edema","isAbnormal":true}}',
  'Inferior STEMI (RCA territory)',
  '["Inferior STEMI","NSTEMI","Aortic dissection","Pulmonary embolism"]',
  'Aspirin 300mg + Clopidogrel 600mg loading; Heparin IV; ห้ามให้ Nitrate (RV infarct risk); Primary PCI ASAP; Atropine ถ้า symptomatic bradycardia; IV fluid cautiously',
  '["Inferior STEMI = ST elevation ใน II, III, aVF จาก RCA occlusion","ต้องทำ right-sided ECG (V3R-V4R) เพื่อ detect RV infarction (ST elevation V4R)","RV infarct contraindication: Nitrate, diuretic (preload dependent)","Killip classification ช่วย stratify severity","Primary PCI < 90 min door-to-balloon time","Bradycardia ใน inferior MI มักจาก Bezold-Jarisch reflex"]',
  '[{"question":"ทำไม Nitrate ถึง contraindicated ในเคสนี้","modelAnswer":"ต้องสงสัย RV infarction (inferior STEMI จาก RCA) ผู้ป่วยมี hypotension + bradycardia RV infarct พึ่ง preload ถ้าให้ Nitrate จะลด venous return ทำให้ BP ตกรุนแรง","points":20},{"question":"อธิบาย right-sided ECG และบอกว่าจะทำอย่างไร","modelAnswer":"ทำ V4R (V4 position แต่ด้านขวา): ST elevation ≥1mm = RV infarct ควรทำใน inferior STEMI ทุกราย","points":15},{"question":"Killip class ของผู้ป่วยรายนี้คือเท่าไร","modelAnswer":"Killip Class II: มี S3 gallop หรือ bibasal crepitation (lung rales <50% of lung fields) indicating mild heart failure","points":15},{"question":"Door-to-balloon time คืออะไร ทำไมสำคัญ","modelAnswer":"เวลาตั้งแต่ผู้ป่วยถึง ER จนถึง balloon inflation ใน PCI เป้าหมาย <90 นาที แต่ละนาทีที่ delay = myocardium loss เพิ่มขึ้น","points":10}]',
  '{"history":20,"pe":20,"lab":25,"ddx":20,"management":15}'
);
