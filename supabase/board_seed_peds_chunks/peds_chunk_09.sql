-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 9/10
-- Questions 161-180 of 200
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- Can run chunks in ANY order. Dedup by scenario.
-- ===============================================================

begin;

-- subjects (idempotent, same on every chunk)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('peds_clinical_decision', 'กุมารเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pediatrics', NULL, 0),
  ('peds_basic_science', 'กุมารเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pediatrics', NULL, 0),
  ('peds_ems_mgmt', 'กุมารเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pediatrics', NULL, 0),
  ('peds_integrative', 'กุมารเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'pediatrics', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกหญิงอายุ 6 mo ตอนคลอดพ่อแม่สังเกตว่ามี hypomelanotic macules (ash-leaf spots) หลายจุด — สังเกตได้ด้วย Wood''s lamp; ตอนนี้ infantile spasms (hypsarrhythmia EEG +) เริ่ม 4 mo + developmental regression + cardiac murmur ที่เคยตรวจ pre-natal มี rhabdomyoma

PE: > 3 hypomelanotic macules trunk + extremities, shagreen patch lumbar back, no facial angiofibroma yet (too young)
Echo: multiple cardiac rhabdomyomas (non-obstructive)
Brain MRI: multiple cortical tubers + subependymal nodules + subependymal giant cell astrocytoma (SEGA) borderline size
US renal: small angiomyolipomas + cysts bilateral
Genetics: TSC2 mutation positive', '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Tuberous Sclerosis Complex (TSC, autosomal dominant TSC1/TSC2 gene → hyperactive mTOR pathway): multidisciplinary lifelong care — neurology + cardiology + nephrology + dermatology + ophthalmology + neuropsychology + special education + genetics; INFANTILE SPASMS treatment — first-line VIGABATRIN (preferred in TSC, evidence superior to ACTH in TSC), monitor retinal toxicity (vigabatrin retinal field defect); alternative ACTH; ketogenic diet adjunct; epilepsy surgery if focal resistant; CONTROL EPILEPSY critical for cognitive outcome; mTOR INHIBITORS — Everolimus (FDA-approved for SEGA, renal angiomyolipoma, refractory epilepsy in TSC ≥ 1 yr) revolutionized treatment + can shrink tumors; SEGA surveillance — MRI annual + watch growth, hydrocephalus, neuro symptoms — surgical resection vs everolimus (decision per anatomy + symptoms); RENAL angiomyolipomas — surveillance + bleeding risk (large > 3 cm), everolimus or embolization or partial nephrectomy; CARDIAC rhabdomyoma — most regress spontaneously childhood, surgery rarely needed unless obstruction/arrhythmia; SKIN — facial angiofibromas topical sirolimus, surgical/laser for cosmesis; DENTAL — pitting/enamel; PULMONARY — lymphangioleiomyomatosis (LAM) women adolescence/adult; INTELLECTUAL DISABILITY 50% — early intervention + IEP; AUTISM spectrum 30-60% — early intervention; PSYCHIATRIC + ADHD common; CANCER surveillance — renal cell carcinoma + others; FAMILY genetic counseling (AD, 25-67% sporadic vs inherited); transition adult care; updated TSC consensus 2021 + 2024"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Single antiepileptic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'TSC = autosomal dominant, mTOR pathway. Multisystem: brain (tubers, SEGA, infantile spasms, autism, LD), cardiac (rhabdomyoma — regress), renal (AML, cysts), skin, eye, lung (LAM adults). Vigabatrin first-line for infantile spasms in TSC. mTOR inhibitor everolimus revolutionized. Multidisciplinary lifelong.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'TSC Consensus Conference 2012 + 2021 updates; PES Pediatric Neurology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกหญิงอายุ 6 mo ตอนคลอดพ่อแม่สังเกตว่ามี hypomelanotic macules (ash-leaf spots) หลายจุด — สังเกตได้ด้วย Wood''s lamp; ตอนนี้ infantile spasms (hypsarrhythmia EEG +) เริ่ม 4 mo + developmental regression + cardiac murmur ที่เคยตรวจ pre-natal มี rhabdomyoma

PE: > 3 hypomelanotic macules trunk + extremities, shagreen patch lumbar back, no facial angiofibroma yet (too young)
Echo: multiple cardiac rhabdomyomas (non-obstructive)
Brain MRI: multiple cortical tubers + subependymal nodules + subependymal giant cell astrocytoma (SEGA) borderline size
US renal: small angiomyolipomas + cysts bilateral
Genetics: TSC2 mutation positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 1 (age 14 ชม), แม่ GBS+ ได้ IAP intrapartum penicillin > 4 hr ก่อนคลอด ตอนนี้ทารกอาการแย่ลง — temperature instability + respiratory distress + cyanosis + poor feeding + lethargy

V/S: HR 184, RR 78, Temp 35.8°C (hypothermia), SpO2 88%, capillary refill 5 sec
Gen: lethargic, mottled, weak pulses, mild grunting, retractions, jaundice mild

CBC: WBC 28,000 + immature/total ratio 0.4 (HIGH), Plt 78,000, glucose 38, lactate 5.2
ABG: pH 7.18, BE -12
CXR: bilateral patchy infiltrate
Blood culture × 2 pending; LP pending; CRP 95', '[{"label":"A","text":"Wait for culture results"},{"label":"B","text":"Early-Onset Neonatal Sepsis (likely GBS despite IAP — IAP reduces but doesn''t eliminate): IMMEDIATE recognition + treat as septic shock; ABC — airway + breathing (consider intubation given respiratory distress + impending failure); CIRCULATION — IV/IO access × 2 within minutes; aggressive fluid resuscitation 10-20 mL/kg NSS BOLUS over 5-10 min repeat as needed reassessing after each (target normal perfusion); empiric BROAD-SPECTRUM IV antibiotic within FIRST HOUR — Ampicillin 100-150 mg/kg/dose q6h + Gentamicin 4 mg/kg/dose q24h IV (covers GBS, E. coli, Listeria, gram-negatives); if meningitis confirmed (LP after stabilization, NOT delaying antibiotic) → add Cefotaxime 50 mg/kg/dose q6-8h + extend duration; correct hypoglycemia D10W 2 mL/kg bolus + ongoing infusion; correct acidosis (volume + antibiotic), electrolytes; VASOPRESSOR if fluid-refractory shock — DOPAMINE 5-15 mcg/kg/min OR EPINEPHRINE 0.05-0.3 mcg/kg/min (preferred cold shock — neonates often cold); HYDROCORTISONE if catecholamine-resistant; NEONATAL ICU; monitor for DIC (FFP + platelet if active bleed/severe consumption); intubation + surfactant if respiratory failure; ECMO selected refractory; serial lactate + perfusion; antibiotic duration 10 d uncomplicated bacteremia, 14-21 d meningitis (GBS), longer for complications; supportive — temp regulation, glucose, electrolytes, nutrition, family support; vaccine on schedule once recovered; audiology + neuroimaging + developmental follow-up; counsel family — outcome variable, prevention via IAP + new maternal GBS vaccine in development"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Single antibiotic narrow spectrum"}]'::jsonb,
  'B', 'Early-onset sepsis = leading cause neonatal mortality. GBS most common despite IAP (reduces but doesn''t eliminate). Recognize signs (temp instability, respiratory, poor feeding, lethargy, mottling). Empiric ampicillin + gentamicin within 1 hr. Aggressive fluid + vasopressor + ICU. Antibiotic duration per Dx. Long-term sequelae.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP COFN/COID Sepsis in Newborns 2018; Surviving Sepsis Pediatric 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 1 (age 14 ชม), แม่ GBS+ ได้ IAP intrapartum penicillin > 4 hr ก่อนคลอด ตอนนี้ทารกอาการแย่ลง — temperature instability + respiratory distress + cyanosis + poor feeding + lethargy

V/S: HR 184, RR 78, Temp 35.8°C (hypothermia), SpO2 88%, capillary refill 5 sec
Gen: lethargic, mottled, weak pulses, mild grunting, retractions, jaundice mild

CBC: WBC 28,000 + immature/total ratio 0.4 (HIGH), Plt 78,000, glucose 38, lactate 5.2
ABG: pH 7.18, BE -12
CXR: bilateral patchy infiltrate
Blood culture × 2 pending; LP pending; CRP 95'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 11 ปี เริ่มกิน carbamazepine สำหรับ seizure 4 wk ก่อน ตอนนี้ ไข้สูง + ผื่นแดงทั่วตัว morbilliform → expanding + facial edema + lymphadenopathy generalized + เหนื่อย + คลื่นไส้ + เริ่ม dark urine

V/S: HR 122, BP 102/68, RR 24, Temp 39.4°C, BW 36 kg
PE: erythroderma-like rash > 50% BSA, facial edema, generalized lymphadenopathy, hepatomegaly tender, no mucous involvement to suggest SJS

CBC: WBC 18,000 with eosinophils 4,200 (15% — HIGH), atypical lymphocytes
LFT: ALT 480, AST 520 (high — hepatitis), bilirubin elevated
Cr 1.4 (mild AKI), proteinuria + LE +
Viral HHV-6 reactivation common — PCR pending
DRESS RegiSCAR score: definite', '[{"label":"A","text":"Continue carbamazepine"},{"label":"B","text":"DRESS (Drug Reaction with Eosinophilia + Systemic Symptoms — severe SCAR — Severe Cutaneous Adverse Reaction): IMMEDIATE DISCONTINUE OFFENDING DRUG (carbamazepine + cross-reactive aromatic antiepileptics — phenytoin, phenobarbital, lamotrigine — switch to non-aromatic levetiracetam, valproate); admit + multidisciplinary (dermatology + ID + nephrology + hepatology + cardiology + pulmonology — multi-organ involvement); SUPPORTIVE — fluid balance, electrolytes, nutrition; SYSTEMIC CORTICOSTEROIDS — prednisolone 1-2 mg/kg/d IV/PO (start higher in severe/visceral involvement) + slow taper over weeks-months (rapid taper → relapse); TOPICAL corticosteroid + emollient for skin; refractory + life-threatening → consider IVIG OR cyclosporine OR rituximab; monitor — VISCERAL INVOLVEMENT (liver, kidney, heart, lung, brain, pancreas, thyroid) recurrent flares + organ-specific (LFT q daily, Cr, ECG, echo, lipase) + autoimmune sequelae long-term (autoimmune thyroiditis, T1DM, lupus, AIHA developing months-years post — long-term follow-up); supportive other organ management; AVOID future re-exposure offending drug + cross-reactive drugs (lifelong, medical alert bracelet, document allergy); HLA TESTING — HLA-B*15:02 (carbamazepine SJS/DRESS in Asians especially Han Chinese, Thai, Indonesian — FDA + Thai Ministry of Health recommend screening before carbamazepine), HLA-B*58:01 (allopurinol), HLA-B*57:01 (abacavir); family + sibling considered for testing depending; report to drug safety authority; mortality ~10% DRESS"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', 'DRESS = severe adverse drug reaction. Carbamazepine, phenytoin, allopurinol, sulfa, vancomycin common triggers. Latency 2-6 wk. Fever + rash + facial edema + LN + eosinophilia + multi-organ. STOP drug + systemic steroid + long taper. HLA-B*15:02 screening before carbamazepine in Asians (Thai). Late autoimmune sequelae.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'RegiSCAR DRESS Criteria; AAD Severe Cutaneous Adverse Reactions Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 11 ปี เริ่มกิน carbamazepine สำหรับ seizure 4 wk ก่อน ตอนนี้ ไข้สูง + ผื่นแดงทั่วตัว morbilliform → expanding + facial edema + lymphadenopathy generalized + เหนื่อย + คลื่นไส้ + เริ่ม dark urine

V/S: HR 122, BP 102/68, RR 24, Temp 39.4°C, BW 36 kg
PE: erythroderma-like rash > 50% BSA, facial edema, generalized lymphadenopathy, hepatomegaly tender, no mucous involvement to suggest SJS

CBC: WBC 18,000 with eosinophils 4,200 (15% — HIGH), atypical lymphocytes
LFT: ALT 480, AST 520 (high — hepatitis), bilirubin elevated
Cr 1.4 (mild AKI), proteinuria + LE +
Viral HHV-6 reactivation common — PCR pending
DRESS RegiSCAR score: definite'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี เริ่ม TMP-SMX 8 วันก่อนสำหรับ UTI ตอนนี้ ไข้ + ผื่นแดง dusky พอง + slipped skin sheets + ปาก + ตา + อวัยวะเพศ involvement + เจ็บปาก + กลืนไม่ได้ + ตาเปิดไม่ได้ + dysuria — sloughing < 10% BSA

V/S: HR 122, BP 102/68, RR 24, Temp 39.2°C, BW 40 kg
Gen: ill-looking, dehydrated, skin: dusky red macules + blisters + epidermal detachment + Nikolsky sign positive, severe mucositis oral + ocular + genital; involvement < 10% BSA = SJS

Lab: ALT 240, leukopenia 2,800, electrolyte abnormalities
HLA-B testing pending; biopsy: full-thickness epidermal necrosis + few lymphocytic infiltrate = consistent', '[{"label":"A","text":"Continue TMP-SMX"},{"label":"B","text":"Stevens-Johnson Syndrome (SJS, severe cutaneous adverse reaction, < 10% BSA detachment; SJS-TEN overlap 10-30%; TEN > 30%) — DERMATOLOGIC EMERGENCY: IMMEDIATE DISCONTINUE OFFENDING DRUG (TMP-SMX + cross-reactive sulfa) + ANY other non-essential medications; TRANSFER to burn unit / specialized SJS center (mortality 5% SJS, 30% TEN, treatment effectiveness depends on early specialty care); SUPPORTIVE care = priority (Burn-unit style) — temperature regulation (lose thermoregulation), fluid resuscitation (Parkland-like formula but typically less aggressive than burn — adjust by ins/outs, mucosal losses), electrolytes + nutrition (consider TPN, mucositis severe), pain management (IV opioid), prevent infection — sterile environment, gentle wound care (non-adherent dressings, biosynthetic skin substitutes), avoid empiric antibiotic (mask infection — culture-directed only); MUCOSAL CARE multidisciplinary — ophthalmology DAILY (prevent corneal scarring/blindness — lubrication + topical steroid + amniotic membrane transplant for severe), oral hygiene, GU care, GI/respiratory mucosa involvement; SPECIFIC therapy CONTROVERSIAL evidence — options: cyclosporine 3-5 mg/kg/d (most evidence + best outcome data in TEN/SJS, immunomodulator), IVIG (controversial, some studies + some no benefit), corticosteroid (controversial — high-dose pulse early may help, prolonged use ↑ infection risk, recent meta-analyses suggest benefit early steroid); etanercept (anti-TNF) emerging promising; AVOID NSAID, prophylactic systemic antibiotic; long-term — skin (pigmentation), ocular sequelae (visual impairment 35%, dry eye, scarring, blindness — LIFELONG ophtho follow-up), pulmonary (bronchiolitis obliterans), genitourinary stricture, psychological PTSD, oral/dental long-term; AVOID OFFENDING + CROSS-REACTIVE DRUG lifelong + medical alert + document; HLA testing for genetic susceptibility identification; family + reproductive counseling; reportable adverse event"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic IV broad-spectrum prophylactic"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', 'SJS/TEN = severe drug reaction, skin emergency. STOP drug + transfer burn/specialized unit. Supportive Burn-like + mucosal care + ophtho daily. Cyclosporine best evidence specific therapy. Steroid controversial. Long-term ocular + pulmonary + skin sequelae. HLA testing. Lifelong drug avoidance.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAD SJS/TEN Practice Statement; RegiSCAR Network', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 14 ปี เริ่ม TMP-SMX 8 วันก่อนสำหรับ UTI ตอนนี้ ไข้ + ผื่นแดง dusky พอง + slipped skin sheets + ปาก + ตา + อวัยวะเพศ involvement + เจ็บปาก + กลืนไม่ได้ + ตาเปิดไม่ได้ + dysuria — sloughing < 10% BSA

V/S: HR 122, BP 102/68, RR 24, Temp 39.2°C, BW 40 kg
Gen: ill-looking, dehydrated, skin: dusky red macules + blisters + epidermal detachment + Nikolsky sign positive, severe mucositis oral + ocular + genital; involvement < 10% BSA = SJS

Lab: ALT 240, leukopenia 2,800, electrolyte abnormalities
HLA-B testing pending; biopsy: full-thickness epidermal necrosis + few lymphocytic infiltrate = consistent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 13 ปี (post-menarche 1 yr) เลือดประจำเดือนมาก 8 วัน + เปลี่ยน pad q1-2 hr + Hb ลด + เลือดกำเดาหลายครั้ง + bruise ง่าย + เลือดออกหลังถอนฟัน นานกว่าปกติ 3 เดือน ก่อน

Family: mother มี heavy menses + brother บางครั้ง easy bruise
V/S: HR 102, BP 102/68, BW 50 kg

Lab: Hb 9.2, MCV 76 (microcytic — IDA), Ferritin LOW, Plt 280,000, PT normal, aPTT mildly prolonged 38 sec (normal 25-35), bleeding time prolonged
vWF antigen LOW (40%, normal 50-150), vWF activity (RCo) LOW, FVIII modestly LOW (subset of vWD), multimer analysis normal pattern = Type 1 vWD', '[{"label":"A","text":"Aspirin"},{"label":"B","text":"Type 1 von Willebrand Disease (most common inherited bleeding disorder, AD, partial quantitative deficiency) + heavy menstrual bleeding + IDA: hematology consultation; ACUTE bleeding (heavy menses now) — antifibrinolytic Tranexamic acid (TXA) 25 mg/kg/dose q8h PO during menses (effective for heavy bleeding); DESMOPRESSIN (DDAVP) — releases stored vWF + FVIII from endothelium — INTRANASAL Stimate 150 mcg/spray 1 spray each nostril q12-24h OR IV 0.3 mcg/kg infusion q12h — FOR Type 1 vWD with documented response (test response with stimation first); monitor for hyponatremia + seizure (fluid restriction during DDAVP); avoid > 3 doses (tachyphylaxis); ESTROGEN-PROGESTIN combined oral contraceptive — effective for menstrual control (also pregnancy prevention) ± LNG-IUD; vWF/FVIII CONCENTRATE (Humate-P, Wilate, recombinant) for severe bleeding, surgery, refractory bleeding; LONG-TERM management — vary intervention by need + lifestyle; AVOID — aspirin, NSAID, antiplatelet (worsen bleeding); MEDICAL ALERT bracelet + dental procedure pre-op planning (DDAVP, TXA, factor concentrate as needed); IRON replacement for IDA (oral or IV depending severity); FAMILY screening (AD, screen first-degree relatives, prenatal/PGD selected); long-term follow-up hematology + gyn + dental; education + transition adult; pregnancy planning — vWF normalizes 2nd-3rd trimester in many but post-partum hemorrhage risk → hematology coordination; emicizumab not vWD indicated"},{"label":"C","text":"NSAID"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Surgery alone"}]'::jsonb,
  'B', 'vWD = most common inherited bleeding disorder. Type 1 mild quantitative most common. Menorrhagia common presenting in adolescents. DDAVP + TXA + COC + factor concentrate per scenario. Avoid antiplatelet/NSAID. Iron supplement + family screen. Medical alert + dental planning.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH/ISTH/NHF/WFH 2021 vWD Guidelines; Pediatric Hematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 13 ปี (post-menarche 1 yr) เลือดประจำเดือนมาก 8 วัน + เปลี่ยน pad q1-2 hr + Hb ลด + เลือดกำเดาหลายครั้ง + bruise ง่าย + เลือดออกหลังถอนฟัน นานกว่าปกติ 3 เดือน ก่อน

Family: mother มี heavy menses + brother บางครั้ง easy bruise
V/S: HR 102, BP 102/68, BW 50 kg

Lab: Hb 9.2, MCV 76 (microcytic — IDA), Ferritin LOW, Plt 280,000, PT normal, aPTT mildly prolonged 38 sec (normal 25-35), bleeding time prolonged
vWF antigen LOW (40%, normal 50-150), vWF activity (RCo) LOW, FVIII modestly LOW (subset of vWD), multimer analysis normal pattern = Type 1 vWD'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี known T1DM (Dx 2 yr ago) มา ED ด้วย vomiting + abdominal pain + polyuria after missed insulin 24 ชม

V/S: HR 122, BP 102/68, RR 28 (Kussmaul), SpO2 98%, BW 36 kg
Gen: alert, ill-appearing, mild dehydration

Lab: pH 7.20, HCO3 12 (moderate DKA), AG 24, Glucose 480, K 4.8 (corrected), Na 132, BUN 22, Cr 0.8, ketone urine 3+, lactate 2.5 (mild), Cl 100
No neuro deficit, no headache, no signs cerebral edema', '[{"label":"A","text":"Insulin bolus + sodium bicarb"},{"label":"B","text":"Pediatric DKA moderate (ISPAD 2022): IV access; fluid resuscitation CAUTIOUS — 10-20 mL/kg NSS bolus over 30-60 min (avoid > 50 mL/kg first 4 hr — cerebral edema risk in peds, prefer SLOWER vs adult), then maintenance + deficit over 24-48 hr (NOT 24 hr alone); insulin AT LEAST 1 hr after starting fluid (not immediately, allows initial fluid resuscitation), then continuous IV regular insulin 0.05-0.1 U/kg/hr (NO BOLUS in peds DKA — bolus = no benefit, increased cerebral edema risk); POTASSIUM REPLACEMENT — add K to fluid (KCl 20-40 mEq/L) once K < 5.5 + UO established, even if serum K initially normal/high (total body deficit); monitor K q1-2h initially; BICARBONATE only if pH < 6.9 + CV compromise (controversial otherwise + cerebral edema risk); GLUCOSE monitor hourly — DEXTROSE add to fluid once glucose drops to ~250-300 (D5 then D10 if needed, continue insulin to clear ketones not just glucose); transition SC insulin when bicarbonate > 18, pH > 7.3, AG normal, glucose < 200, eating; OVERLAP IV + SC insulin (give SC dose 15-30 min before STOP IV insulin); GLUCOSE + electrolytes q1-2 hr; serum osmolality corrected sodium trend (paradoxical Na rise as glucose falls = appropriate; FALL = cerebral edema warning); MONITOR for CEREBRAL EDEMA — most feared, > 80% pediatric DKA deaths — signs: headache, vomiting (after initial improvement), AMS, papilledema, Cushing reflex, paradoxical Na rise; manage if detected — IMMEDIATE hypertonic saline OR mannitol, reduce fluid rate; identify TRIGGER — missed insulin most common adolescents, intercurrent illness (viral, UTI, GE), insulin pump failure; PSYCHOSOCIAL — adherence issues common adolescent (mental health, family conflict, eating disorder); patient education + family + transition adult; CGM + insulin pump consideration"},{"label":"C","text":"Restrict all fluid"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral hypoglycemic"}]'::jsonb,
  'B', 'Pediatric DKA = ISPAD 2022 cautious approach (cerebral edema risk). NO insulin bolus, delayed insulin (after fluid), gradual fluid over 48 hr, K replacement, monitor for cerebral edema warning signs (HA, AMS, paradoxical Na rise). Address trigger + psychosocial.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD Clinical Practice Consensus Guideline DKA 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี known T1DM (Dx 2 yr ago) มา ED ด้วย vomiting + abdominal pain + polyuria after missed insulin 24 ชม

V/S: HR 122, BP 102/68, RR 28 (Kussmaul), SpO2 98%, BW 36 kg
Gen: alert, ill-appearing, mild dehydration

Lab: pH 7.20, HCO3 12 (moderate DKA), AG 24, Glucose 480, K 4.8 (corrected), Na 132, BUN 22, Cr 0.8, ketone urine 3+, lactate 2.5 (mild), Cl 100
No neuro deficit, no headache, no signs cerebral edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 ปี known sickle cell disease (HbSS) อาการเริ่ม 2 ชม ก่อน — สูญเสีย speech + right hemiparesis + facial droop + altered mental status

V/S: HR 112, BP 132/78, Temp 37.0°C, BW 22 kg
Gen: alert but dysarthric, expressive aphasia, right facial droop, right arm + leg weakness 2/5 strength, sensory loss right side, no seizure

CT head non-contrast: subtle hypodensity left MCA territory + dense MCA sign
MRI + DWI: large left MCA stroke + ADC restriction = acute ischemic stroke
TCD: previously high velocities suggesting stenosis; CBC: Hb 7.8, retic 8%; recent transfusion 1 month ago', '[{"label":"A","text":"Wait 24 hr observation"},{"label":"B","text":"Acute Ischemic Stroke in Sickle Cell Disease (peds stroke incidence 11% in SCD by 20 yr) — peds stroke emergency: ABC + neurologic exam + emergent CT/MRI confirmed; EXCHANGE TRANSFUSION urgent — reduce HbS to < 30% — most effective acute intervention to halt ongoing stroke + reduce extension (manual or automated exchange, preferred over simple transfusion); pediatric neurology + hematology + interventional radiology + ICU; IV ALTEPLASE (tPA) — generally NOT recommended in SCD (different pathophysiology — vasculopathy + sludge rather than thromboembolic, no good evidence) + selected major centers offer in SCD adult, adult/peds general criteria <4.5 hr; pediatric tPA non-SCD: limited data, selected centers for older adolescents extrapolated adult criteria; thrombectomy — emerging in pediatric LVO stroke (limited data, selected centers); SUPPORTIVE — maintain euvolemia + normal glucose + normal Na + normal temp + adequate oxygenation + treat seizure if present + manage ICP if increased; OPTIMIZE OXYGEN delivery (transfuse Hb > 10), avoid hypoxia + hyperthermia; antiplatelet (aspirin 1-5 mg/kg/d) considered after acute phase + once exchange completed (delayed); EARLY rehab; INVESTIGATIONS — TCD historical, baseline + post-stroke MRA/cervical vessels (vasculopathy moyamoya in SCD), echo (cardioembolic), prothrombotic workup (anti-phospholipid, factor V Leiden, protein C/S — selective); secondary stroke prevention — CHRONIC TRANSFUSION program (target HbS < 30% lifelong) OR Hydroxyurea (alternative — STOP study + TWiTCH trial); long-term — hematopoietic stem cell transplant (HLA-matched sibling), GENE THERAPY (newer FDA-approved SCD), rehab, neuropsych, school IEP, family"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Aspirin alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', 'Pediatric stroke in SCD = urgent exchange transfusion (reduce HbS < 30%). tPA generally NOT used in SCD (different pathophysiology). Secondary prevention: chronic transfusion or hydroxyurea + monitor TCD. HSCT or gene therapy curative options. Rehab + neuropsych long-term.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AHA/ASA Pediatric Stroke Guideline 2019; ASH SCD Stroke Prevention Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 ปี known sickle cell disease (HbSS) อาการเริ่ม 2 ชม ก่อน — สูญเสีย speech + right hemiparesis + facial droop + altered mental status

V/S: HR 112, BP 132/78, Temp 37.0°C, BW 22 kg
Gen: alert but dysarthric, expressive aphasia, right facial droop, right arm + leg weakness 2/5 strength, sensory loss right side, no seizure

CT head non-contrast: subtle hypodensity left MCA territory + dense MCA sign
MRI + DWI: large left MCA stroke + ADC restriction = acute ischemic stroke
TCD: previously high velocities suggesting stenosis; CBC: Hb 7.8, retic 8%; recent transfusion 1 month ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี newly diagnosed ALL ตรวจ initial WBC 380,000 (hyperleukocytosis > 100K) + clinical symptoms — confusion, dyspnea, retinal hemorrhages, headache + petechiae

V/S: HR 132, BP 102/72, RR 32, SpO2 92%, Temp 37.6°C, BW 24 kg
Gen: confused, mild distress, retinal hemorrhages, splenomegaly 5 cm

Lab: WBC 380,000 (blasts 85% — pre-B ALL), Hb 6.5, Plt 24,000, K 6.2, P 9.0, Ca 7.2, uric acid 18 (HIGH), LDH 4,820, Cr 1.4, AGMA mild, INR 1.4, fibrinogen 180 (DIC borderline)', '[{"label":"A","text":"Wait — start chemo slowly"},{"label":"B","text":"Hyperleukocytosis (WBC > 100K) + Leukostasis + Tumor Lysis Syndrome (TLS) imminent — pediatric oncology emergency: admit ICU + ped-onc team; AGGRESSIVE TLS prophylaxis + treatment — IV HYDRATION 2-3× maintenance (3 L/m²/d crystalloid, no K addition initially); RASBURICASE 0.15-0.2 mg/kg IV daily × 1-5 days (recombinant urate oxidase — preferred over allopurinol for high uric acid > 8 mg/dL OR rapidly rising OR organ dysfunction — converts uric acid to allantoin, rapid + effective; CAUTION G6PD deficient — methemoglobinemia + hemolysis, screen if Asian/African/Mediterranean); alternative ALLOPURINOL 10 mg/kg/d for less severe TLS risk; ALKALINIZATION controversial (urate easier excretion but increases calcium phosphate precipitation — most centers now avoid with rasburicase); CORRECT ELECTROLYTES — K (Ca gluconate IV cardiac protection + insulin/glucose + albuterol + sodium polystyrene + dialysis), P (binders + dialysis), Ca (treat hypocalcemia only if symptomatic — concern Ca-P precipitation); LEUKAPHERESIS — selected case (HOLD if asymptomatic), benefit unclear in ALL hyperleukocytosis (vs AML where established) — generally not first-line in peds ALL because rapid response to cytoreduction with steroid alone; STEROID — start prednisolone 60 mg/m²/d (initial cytoreduction prior to full chemo, gentle dose increase to avoid TLS); RAPID PROGRESSION TO CHEMOTHERAPY — induction (vincristine + steroid + asparaginase ± anthracycline) once initial stabilization; PRBC transfusion only if severe symptomatic anemia (avoid increasing viscosity → worsen leukostasis); platelet transfusion for active bleed or < 20 (NOT prophylactic transfusion may aggravate); RRT/dialysis indication — severe TLS refractory hyperK/AKI/hyperP; coagulopathy management (cryo if fibrinogen low, FFP); central line + supportive; intrathecal chemo + CNS prophylaxis later; counsel family — newer molecular subtyping + risk stratification + immunotherapy (blinatumomab, CAR-T for relapse) revolutionized outcomes (cure > 90% pre-B ALL pediatric); long-term: late effects monitoring + comprehensive cancer survivorship"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Transfuse aggressively"}]'::jsonb,
  'B', 'Hyperleukocytosis + TLS = oncologic emergency. Aggressive hydration + rasburicase (or allopurinol) + correct electrolytes (K, P, Ca, uric acid). Avoid alkalinization with rasburicase. Steroid cytoreduction + rapid chemo. Leukapheresis selective. Avoid excessive PRBC (increases viscosity). Multidisciplinary ICU.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG ALL Protocols; Cairo-Bishop TLS Classification 2010; Coiffier JCO 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี newly diagnosed ALL ตรวจ initial WBC 380,000 (hyperleukocytosis > 100K) + clinical symptoms — confusion, dyspnea, retinal hemorrhages, headache + petechiae

V/S: HR 132, BP 102/72, RR 32, SpO2 92%, Temp 37.6°C, BW 24 kg
Gen: confused, mild distress, retinal hemorrhages, splenomegaly 5 cm

Lab: WBC 380,000 (blasts 85% — pre-B ALL), Hb 6.5, Plt 24,000, K 6.2, P 9.0, Ca 7.2, uric acid 18 (HIGH), LDH 4,820, Cr 1.4, AGMA mild, INR 1.4, fibrinogen 180 (DIC borderline)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ครอบครัวคลำพบก้อน RUQ ขนาดใหญ่ + abdominal distension + เริ่มเบื่ออาหาร + น้ำหนักลด 1 kg ใน 2 mo + early puberty (signs virilization)

V/S: BW 11 kg, abdominal distension + large RUQ mass firm, no jaundice, splenomegaly absent

Lab: AFP 480,000 (extremely high — characteristic), bilirubin normal, ALT mildly elevated, hCG mildly elevated (paraneoplastic), no jaundice
US: large 12 cm hepatic mass right lobe
CT chest/abdomen: well-defined heterogeneous hepatic mass, no metastasis lung, no portal vein invasion
Biopsy: hepatoblastoma fetal/embryonal type
PRETEXT staging: III (limited resection feasibility)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Hepatoblastoma (most common pediatric primary liver cancer, peak 1-3 yr, very high AFP, virilization rare from beta-hCG) — multimodal: pediatric oncology + hepatobiliary surgery + transplant team coordinated; ALL hepatoblastoma treated per international protocols (COG/SIOPEL); NEOADJUVANT CHEMOTHERAPY — cisplatin-based (PLADO: cisplatin + doxorubicin or C5VD or as per protocol) × 4-6 cycles — shrinks tumor to allow resection; reassess RESECTABILITY POST-CHEMO with imaging; SURGICAL RESECTION — partial hepatectomy if confined to resectable anatomy (PRETEXT I, II, post-chemo III); LIVER TRANSPLANTATION (orthotopic) — for unresectable PRETEXT III/IV without extrahepatic disease — pediatric transplant center, requires donor evaluation, immunosuppression lifelong, EXCELLENT outcomes with appropriate selection (5-yr survival ~70-90%); ADJUVANT CHEMOTHERAPY post-surgery; monitor AFP — drops with effective treatment, rises with recurrence; LONG-TERM follow-up — recurrence (most within 2 yr), hearing (cisplatin ototoxicity audiology long-term), renal + cardiac (doxorubicin), secondary malignancy, growth + developmental; transition adult; PROGNOSIS — overall 5-yr survival 80%, depends on PRETEXT stage + histology + alpha-fetoprotein response + complete resection; family education + comprehensive cancer survivorship clinic; investigate associated conditions — Beckwith-Wiedemann, FAP (APC mutation), prematurity + low birth weight + parenteral nutrition risk factors"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Surgery without chemo"}]'::jsonb,
  'B', 'Hepatoblastoma = most common pediatric primary liver cancer. PRETEXT staging. Cisplatin-based neoadjuvant chemo + surgery (or transplant for unresectable) excellent outcomes. AFP marker. Cisplatin ototoxicity monitor. Associated: BWS, FAP, prematurity.', NULL,
  'medium', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG/SIOPEL Hepatoblastoma Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ครอบครัวคลำพบก้อน RUQ ขนาดใหญ่ + abdominal distension + เริ่มเบื่ออาหาร + น้ำหนักลด 1 kg ใน 2 mo + early puberty (signs virilization)

V/S: BW 11 kg, abdominal distension + large RUQ mass firm, no jaundice, splenomegaly absent

Lab: AFP 480,000 (extremely high — characteristic), bilirubin normal, ALT mildly elevated, hCG mildly elevated (paraneoplastic), no jaundice
US: large 12 cm hepatic mass right lobe
CT chest/abdomen: well-defined heterogeneous hepatic mass, no metastasis lung, no portal vein invasion
Biopsy: hepatoblastoma fetal/embryonal type
PRETEXT staging: III (limited resection feasibility)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 10 ปี Trauma ขณะเล่นจักรยานชน handlebar เข้าท้อง 2 วันก่อน ตอนนี้ ปวดท้องรุนแรง upper abdomen + radiating to back + คลื่นไส้อาเจียน + ไข้ต่ำ

V/S: HR 122, BP 102/68, RR 22, Temp 38.0°C, BW 30 kg
Gen: distress, abdominal tenderness epigastric + RUQ, mild rebound, hypoactive bowel sounds, no peritonitis severe

Lab: lipase 3,200 (high, > 3× normal), amylase 1,840, CBC WBC 14,500, glucose 110, Cr normal, LFT mildly elevated, calcium 8.4
US abdomen + contrast CT: pancreatic edema + peripancreatic fluid + no necrosis on early CT (may evolve)', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Pediatric Pancreatitis (trauma-related — handlebar injury common cause peds): admit + ICU consideration if severe (organ dysfunction); SUPPORTIVE — primary treatment, NO specific therapy curative; FLUID resuscitation — IV crystalloid LR 1.5-2× maintenance first 24-48 hr (most important — prevents pancreatic ischemia + necrosis) — guide by clinical perfusion + UO + Hct trend, AVOID over-resuscitation; ANALGESIA — IV opioid (morphine 0.05-0.1 mg/kg q3-4h, contrary to old myth about Oddi spasm — modern evidence supports morphine + ketorolac); ANTIEMETIC; NUTRITION — EARLY ENTERAL feeding within 24-72 hr (oral or NG/NJ if cannot tolerate) — improves outcomes vs prolonged NPO (older paradigm) — start clear liquid → soft → regular; if cannot enteral → TPN; AVOID PROPHYLACTIC ANTIBIOTIC (no benefit, increased resistance); ANTIBIOTIC only for: documented infection, infected necrosis (FNA-guided), cholangitis; INVESTIGATIONS — exclude causes — trauma here, but consider gallstones (US), hypertriglyceridemia (lipid), hypercalcemia, drugs (asparaginase, valproate, steroid, thiazide), genetic (PRSS1, CFTR, SPINK1, CTRC — selected); MRCP if structural concern; ERCP for sphincterotomy/stone removal if obstructive; monitor for complications — pseudocyst (drain if symptomatic or > 6 cm + > 6 wk), necrosis (FNA + debridement step-up approach), abscess (drainage), AKI, ARDS, abdominal compartment syndrome; CHRONIC PANCREATITIS pediatric (recurrent acute → chronic) — multidisciplinary genetic + nutritional + endocrine evaluation; long-term — exocrine + endocrine insufficiency (DM, malabsorption) monitor; family education + dietary; PEDIATRIC pancreatitis usually resolves with supportive care + treat cause"},{"label":"C","text":"Restrict all food + fluid weeks"},{"label":"D","text":"Prophylactic antibiotic IV"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Pediatric pancreatitis = supportive care primary. Aggressive IV fluid first 24-48 hr (prevent ischemia). EARLY enteral feeding (improves outcomes). Adequate analgesia (morphine OK). Avoid prophylactic antibiotic. Investigate cause. Trauma + biliary + drug + genetic. Complications surveillance. Long-term: chronic pancreatitis if recurrent.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN Pediatric Pancreatitis Position Paper 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 10 ปี Trauma ขณะเล่นจักรยานชน handlebar เข้าท้อง 2 วันก่อน ตอนนี้ ปวดท้องรุนแรง upper abdomen + radiating to back + คลื่นไส้อาเจียน + ไข้ต่ำ

V/S: HR 122, BP 102/68, RR 22, Temp 38.0°C, BW 30 kg
Gen: distress, abdominal tenderness epigastric + RUQ, mild rebound, hypoactive bowel sounds, no peritonitis severe

Lab: lipase 3,200 (high, > 3× normal), amylase 1,840, CBC WBC 14,500, glucose 110, Cr normal, LFT mildly elevated, calcium 8.4
US abdomen + contrast CT: pancreatic edema + peripancreatic fluid + no necrosis on early CT (may evolve)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี ก่อนหน้านี้ healthy เริ่มมีปวดท้อง severe colicky 3 วันก่อน + อาเจียน + bloody stool + palpable purpura ทั้ง 2 ขา + ปวดข้อหลายข้อย้ายที่ + ปัสสาวะปริมาณน้อย dark urine

V/S: BP 132/86 (HT in child), HR 102, BW 32 kg, mild edema
PE: extensive palpable purpura buttocks + lower legs, scrotal swelling + tenderness (HSP-orchitis), abdominal tender diffuse no peritonitis, knee + ankle effusion mild bilateral

Lab: Plt 380,000 normal, CBC mild leukocytosis, BUN 32, Cr 1.4 (high), UA — RBC casts + protein 3+, urine P:Cr 5.0 (nephrotic-range proteinuria!), albumin 2.4, complement normal
ABD US: intussusception ileo-ileal R sided + bowel wall edema; testicular US: orchitis only no torsion', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"IgA Vasculitis (HSP) with multiple severe complications — intussusception, severe abdominal pain, nephritis nephrotic-range, scrotal involvement: admit ICU monitoring; abdominal management — surgical consultation for intussusception ileo-ileal (usually doesn''t reduce with enema; surgery if persistent + symptomatic, often resolves spontaneously in HSP); IV fluid resuscitation + bowel rest if severe abdominal pain + analgesia; SYSTEMIC CORTICOSTEROID — prednisolone 1-2 mg/kg/d IV or PO (max 60 mg/d) — INDICATIONS in HSP: severe abdominal pain, GI bleeding, intussusception, scrotal involvement, severe arthritis, evidence of severe nephritis — given for these severe complications (no clear evidence for routine cutaneous/mild disease); SEVERE NEPHRITIS (this patient — RPGN-like, nephrotic-range, AKI) — escalate immunosuppression: corticosteroid pulse methylprednisolone 30 mg/kg/d × 3 d then prednisolone; ADD cyclophosphamide IV monthly × 6 mo OR mycophenolate mofetil OR rituximab for severe progressive; ACEI/ARB for proteinuria once stable; renal biopsy CONSIDERED for severe nephritis to guide therapy + prognosis (ISKDC classification); MANAGE HT carefully (CCB or labetalol acute, ACEI/ARB long-term once stable); ORCHITIS/SCROTAL — supportive care, scrotal support, NSAID (caution renal), corticosteroid; MONITOR — BP, UA, Cr, intussusception clinical + serial US (q12-24h), GI bleeding; long-term followup — UA + BP + Cr q monthly × 6 mo (nephritis up to 6 mo post), then less frequent; chronic kidney disease 1-5% even with treatment; PROGNOSIS depend on renal involvement severity; family education recurrence 30%"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery first immediately"}]'::jsonb,
  'B', 'HSP/IgAV with severe complications (intussusception, nephritis, scrotal) = treat aggressively with steroid + escalated immunosuppression if severe nephritis. Intussusception in HSP often ileo-ileal + doesn''t reduce with enema, may resolve spontaneously. Long-term renal monitoring 6 mo. Multidisciplinary.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'SHARE Initiative HSP Management 2019; EULAR/PRINTO/PReS Criteria 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 11 ปี ก่อนหน้านี้ healthy เริ่มมีปวดท้อง severe colicky 3 วันก่อน + อาเจียน + bloody stool + palpable purpura ทั้ง 2 ขา + ปวดข้อหลายข้อย้ายที่ + ปัสสาวะปริมาณน้อย dark urine

V/S: BP 132/86 (HT in child), HR 102, BW 32 kg, mild edema
PE: extensive palpable purpura buttocks + lower legs, scrotal swelling + tenderness (HSP-orchitis), abdominal tender diffuse no peritonitis, knee + ankle effusion mild bilateral

Lab: Plt 380,000 normal, CBC mild leukocytosis, BUN 32, Cr 1.4 (high), UA — RBC casts + protein 3+, urine P:Cr 5.0 (nephrotic-range proteinuria!), albumin 2.4, complement normal
ABD US: intussusception ileo-ileal R sided + bowel wall edema; testicular US: orchitis only no torsion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี ในช่วง maintenance phase ALL (treatment 2 yr) เริ่มปวดศีรษะ + อาเจียน morning + diplopia + papilledema bilateral 1 wk

V/S: BP 112/68, HR 92, BW 26 kg
PE: papilledema bilateral, 6th nerve palsy bilateral (false localizing), no other focal deficit, alert

Lab: CBC stable (no marrow relapse currently — Plt 220, WBC 4,200 no blasts), LFT normal, Cr normal
MRI brain + spine: leptomeningeal enhancement + multiple lesions in brain parenchyma + spinal cord
LP: WBC 35 (all blasts on cytospin), Protein elevated, Glucose normal, BLASTS confirmed = isolated CNS relapse', '[{"label":"A","text":"Discharge no further treatment"},{"label":"B","text":"Isolated CNS Relapse Pediatric ALL — pediatric oncology emergency + new treatment paradigm: pediatric oncology + radiation oncology + neurology + neurosurgery + BMT team; INTRATHECAL CHEMOTHERAPY (triple therapy: methotrexate + cytarabine + hydrocortisone) intensified frequency (twice weekly × 4-6 wk then weekly × 4-8 wk to clear blasts); SYSTEMIC reinduction — high-intensity chemotherapy (high-dose methotrexate to cross BBB + dexamethasone + asparaginase + vincristine ± additional agents per protocol); CNS RADIATION THERAPY — craniospinal RT (typical 18 Gy cranial + spinal lower) AFTER chemo control + once approach end of treatment plan — irradiation reduces CNS recurrence but neurocognitive cost especially young children — modern trials reduce/omit RT if molecular/MRD control achievable + extensive chemo CNS-directed; HEMATOPOIETIC STEM CELL TRANSPLANT (allogeneic) — strongly considered for early CNS relapse < 18 mo from initial Dx + selected high-risk; CAR-T cell therapy (tisagenlecleucel — FDA approved relapsed/refractory pediatric ALL) — emerging for relapse + can penetrate CNS; blinatumomab (BiTE — anti-CD19/CD3) emerging; SUPPORTIVE — manage increased ICP with steroid (dexamethasone) + hyperosmolar therapy if symptomatic; monitor MRD (minimal residual disease) — quantitative response to therapy guides intensity; INVESTIGATIONS — exclude marrow relapse (BMA), molecular characterization (BCR-ABL, MLL, others); long-term — neurocognitive deficits from CNS RT + IT therapy (especially young), endocrinopathy from CNS RT, growth + puberty delay, secondary malignancy, cardiac (anthracycline cumulative); psychosocial + family + transition adult; treatment intensity + prognosis depend on timing relapse, MRD, immunophenotype, age; comprehensive cancer survivorship"},{"label":"C","text":"Single intrathecal dose"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', 'Isolated CNS relapse ALL = aggressive multimodal treatment with high CR rate but worse than initial. Intensified IT + high-dose systemic + CNS-directed RT + HSCT or CAR-T for selected. Early relapse worse prognosis. Multidisciplinary cancer survivorship long-term.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG ALL Relapse Protocols; CIBMTR Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี ในช่วง maintenance phase ALL (treatment 2 yr) เริ่มปวดศีรษะ + อาเจียน morning + diplopia + papilledema bilateral 1 wk

V/S: BP 112/68, HR 92, BW 26 kg
PE: papilledema bilateral, 6th nerve palsy bilateral (false localizing), no other focal deficit, alert

Lab: CBC stable (no marrow relapse currently — Plt 220, WBC 4,200 no blasts), LFT normal, Cr normal
MRI brain + spine: leptomeningeal enhancement + multiple lesions in brain parenchyma + spinal cord
LP: WBC 35 (all blasts on cytospin), Protein elevated, Glucose normal, BLASTS confirmed = isolated CNS relapse'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 9 ปี diagnosis ITP 14 mo ago + ได้รับ IVIG + steroid + รักษาแล้ว ตอนนี้ Plt count vary 8,000-30,000 chronic ITP > 12 mo + petechiae + minor bleeding + บางครั้ง heavy menses (post-menarche 1 yr) + ผลกระทบ activity

V/S: BW 32 kg, intermittent petechiae + bruising, no severe bleeding currently

CBC: Hb 11.0, WBC normal, Plt 12,000
Bone marrow biopsy (done 1 yr ago): normal megakaryocytes, no abnormality = ITP
No connective tissue disease evidence (ANA negative, normal complement)', '[{"label":"A","text":"Continue steroid forever"},{"label":"B","text":"Chronic Pediatric ITP (> 12 mo duration, intermittent bleeding, impacts quality of life) — beyond first-line: pediatric hematology specialist + ASH 2019 + 2024 updates; INDICATIONS to treat (vs observe) — significant bleeding, lifestyle impact, contact sports involvement, surgery planning; FIRST-LINE for chronic ITP — TPO RECEPTOR AGONISTS (revolutionized — non-immunosuppressive, oral, well-tolerated): ELTROMBOPAG ≥ 1 yr FDA-approved (25-75 mg/d oral, take fasting + 4 hr after polyvalent cations, monitor LFT cataract eye exam) OR ROMIPLOSTIM ≥ 1 yr (SC weekly injection, dose-adjusted by platelet response); ~70-80% response rate; PREDNISOLONE pulses (rather than chronic) — short courses for bleeds or surgeries; IVIG — short-term boost for severe bleed or pre-surgery (rapid effect); RITUXIMAB (anti-CD20) — second-line, durable response 30-40%, side effects + immunosuppression; FOSTAMATINIB (SYK inhibitor) — oral newer alternative; SPLENECTOMY — historically curative ~70%, but now reserved for refractory after TPO-RA fail + > 6 yr age (immune maturity) + counseling about lifelong infection risk + vaccinations pre + post (pneumococcal, meningococcal, Hib, influenza) + penicillin prophylaxis 5+ yr; HEAVY MENSES — TXA + COC (combined OCP) for menstrual control; ACTIVITY — generally allow normal activity with awareness, avoid contact sports if Plt < 30K; MEDICAL ALERT bracelet; FAMILY education emergency response + when to seek care; long-term watch for chronic disease, autoimmune comorbidity, secondary malignancy considerations; psychosocial support adolescent + transition adult"},{"label":"C","text":"Splenectomy immediately"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', 'Chronic pediatric ITP (> 12 mo) — TPO receptor agonists (eltrombopag, romiplostim) revolutionized (oral, non-immunosuppressive, ~70-80% response). Rituximab + fostamatinib alternatives. Splenectomy reserved + delayed > 6 yr. Treat based on bleeding/lifestyle, not just count. ASH 2019/2024.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH 2019 ITP Guidelines; Updates Neunert + Provan', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 9 ปี diagnosis ITP 14 mo ago + ได้รับ IVIG + steroid + รักษาแล้ว ตอนนี้ Plt count vary 8,000-30,000 chronic ITP > 12 mo + petechiae + minor bleeding + บางครั้ง heavy menses (post-menarche 1 yr) + ผลกระทบ activity

V/S: BW 32 kg, intermittent petechiae + bruising, no severe bleeding currently

CBC: Hb 11.0, WBC normal, Plt 12,000
Bone marrow biopsy (done 1 yr ago): normal megakaryocytes, no abnormality = ITP
No connective tissue disease evidence (ANA negative, normal complement)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี persistent microscopic hematuria > 1 yr + intermittent gross hematuria after URI + mild proteinuria new + family Hx — มี uncle (mother''s brother) ESRD age 25 with bilateral sensorineural hearing loss + cousin had similar

V/S: BP 110/72 normal, BW 26 kg
PE: anterior lenticonus on slit-lamp + retinal flecks, normal exam otherwise
Audiometry: bilateral high-frequency sensorineural hearing loss

Lab: Cr 0.7 normal, UA — RBC 50+, dysmorphic, mild protein 1+, UP/UCr 0.4, complement normal
Family Hx + clinical features = X-linked Alport syndrome
Kidney biopsy + EM: basement membrane splitting + lamellation + thinning = Alport
Genetic testing: COL4A5 mutation positive (X-linked)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Alport Syndrome (X-linked, COL4A5 type IV collagen — affects glomerular basement membrane, cochlea, lens) — long-term progressive renal disease management: nephrology + ophthalmology + audiology + genetics + multidisciplinary; RENIN-ANGIOTENSIN-ALDOSTERONE SYSTEM (RAAS) blockade EARLY — ACEI (lisinopril, enalapril, ramipril) titrated to maximum tolerated dose (proteinuria reduction primary) — STARTING when proteinuria detected, slows progression; ARB if ACEI not tolerated; spironolactone aldosterone receptor antagonist add-on; SGLT2 inhibitor (dapagliflozin, empagliflozin) emerging — recent evidence reduces progression in CKD including Alport; bardoxolone (Nrf2 activator) — recent FDA approval emerging; counsel about lifelong progression to ESRD (males X-linked 90% by age 30); ANNUAL — BP monitoring + UA + Cr + GFR + audiology + ophtho (cataract + anterior lenticonus); HYPERTENSION management — RAAS blockade + diuretics + add as needed; AVOID nephrotoxin (NSAID, aminoglycoside, contrast); HEARING aids when indicated; ophthalmology for lenticonus + cataract; PREPARE FOR ESRD — late teens to adult — dialysis + KIDNEY TRANSPLANT (preferred — successful long-term, but risk of post-transplant anti-GBM antibodies in some — rare complication needing monitoring + immunosuppression coordination); GENETIC COUNSELING + family screen — X-linked (males severe, females carrier — variable severity), AR + AD forms exist (COL4A3/COL4A4 — Alport variant); prenatal/preimplantation diagnosis available; education adolescence + transition adult nephrology; psychosocial support; gene therapy in development"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', 'Alport syndrome = inherited basement membrane disease (X-linked most). Progressive nephritis + sensorineural hearing loss + ocular changes. Early ACEI/ARB slow progression. SGLT2i emerging. Most males progress to ESRD → transplant. Genetic counseling. Family screen. Multispecialty.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases 2021; Alport Syndrome Foundation Clinical Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี persistent microscopic hematuria > 1 yr + intermittent gross hematuria after URI + mild proteinuria new + family Hx — มี uncle (mother''s brother) ESRD age 25 with bilateral sensorineural hearing loss + cousin had similar

V/S: BP 110/72 normal, BW 26 kg
PE: anterior lenticonus on slit-lamp + retinal flecks, normal exam otherwise
Audiometry: bilateral high-frequency sensorineural hearing loss

Lab: Cr 0.7 normal, UA — RBC 50+, dysmorphic, mild protein 1+, UP/UCr 0.4, complement normal
Family Hx + clinical features = X-linked Alport syndrome
Kidney biopsy + EM: basement membrane splitting + lamellation + thinning = Alport
Genetic testing: COL4A5 mutation positive (X-linked)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 mo คุณแม่กังวล — coarse facial features + recurrent URI + macrocephaly + corneal clouding + hepatosplenomegaly + cardiac murmur + delayed development + stiff joints + claw hand + กระดูกอ่อนผิดรูป (dysostosis multiplex)

PE: characteristic coarse face, large tongue, depressed nasal bridge, hepatosplenomegaly, lumbar gibbus, corneal clouding bilateral mild, joint contractures hands, BW + height < 3rd percentile

Lab: urine glycosaminoglycans (GAGs) markedly elevated; alpha-L-iduronidase enzyme: severely deficient → Hurler syndrome (MPS-I, severe form, IDUA gene autosomal recessive)
Echo: thickened mitral + aortic valves + mild LVH', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Mucopolysaccharidosis Type I Hurler (severe form, IDUA deficiency — autosomal recessive) — multidisciplinary lifelong care: HEMATOPOIETIC STEM CELL TRANSPLANTATION (HSCT, allogeneic) — best treatment if performed EARLY (< 2 yr ideally, before significant CNS damage) — donor cells produce enzyme + provide enzyme delivery to CNS via crossing BBB (limited but partial), improves longevity + cognition + organomegaly — DECISION POINT NOW given age + severe form; ENZYME REPLACEMENT THERAPY (ERT) — Laronidase (Aldurazyme) IV weekly — does NOT cross BBB so does NOT prevent CNS deterioration in severe form (Hurler), but improves visceral disease + reduces airway/hepatosplenomegaly — typically GIVEN PERIOPERATIVELY when planning HSCT and continued long-term as adjunct; SUPPORTIVE — multispecialty annual evaluation: cardiology (valve disease — surgery may be needed), ENT (airway, AOM, hearing loss, OSA — adenotonsillectomy), ophtho (corneal clouding, glaucoma, retinopathy), neurology (cervical cord compression — RISK ANESTHESIA), orthopedic (carpal tunnel, hip dysplasia, kyphosis), neurosurgery (hydrocephalus → VP shunt), pulmonology (restrictive lung), gastroenterology, audiology, dental; PHYSICAL + OCCUPATIONAL therapy; ANESTHESIA CARE — extremely high risk (airway difficult, cervical instability, restrictive lung, valve disease) — anesthesia consult before procedures; ATTAINTIVES — gene therapy clinical trials emerging (autologous transduced HSC); substrate reduction therapy + intrathecal ERT investigational; FAMILY genetic counseling + carrier testing siblings; prenatal/preimplantation testing for future pregnancy; psychosocial support; transition adult metabolic — though severe Hurler historically died by age 5-10 without treatment, modern HSCT + ERT improves longevity"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Surgery alone"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', 'MPS Hurler = severe form, IDUA deficiency. Multisystem (face, viscera, joints, eye, brain, cardiac, airway). HSCT early (< 2 yr) for severe + ERT (laronidase) for visceral but limited CNS. High anesthesia risk. Gene therapy emerging. Multidisciplinary lifelong + family genetic counseling.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'MPS Society Clinical Care Guidelines; Pediatric Metabolic Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 mo คุณแม่กังวล — coarse facial features + recurrent URI + macrocephaly + corneal clouding + hepatosplenomegaly + cardiac murmur + delayed development + stiff joints + claw hand + กระดูกอ่อนผิดรูป (dysostosis multiplex)

PE: characteristic coarse face, large tongue, depressed nasal bridge, hepatosplenomegaly, lumbar gibbus, corneal clouding bilateral mild, joint contractures hands, BW + height < 3rd percentile

Lab: urine glycosaminoglycans (GAGs) markedly elevated; alpha-L-iduronidase enzyme: severely deficient → Hurler syndrome (MPS-I, severe form, IDUA gene autosomal recessive)
Echo: thickened mitral + aortic valves + mild LVH'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี multiple system involvement — developmental regression starting 2 yr + episodic vomiting + lactic acidosis episodes + ptosis bilateral + exercise intolerance + hearing loss bilateral + retinopathy + short stature + lactic acidemia

V/S: BW 14 kg (< 3rd %), HR mildly tachycardic, no acute distress
PE: ptosis bilateral, ophthalmoplegia, retinopathy on fundoscopy, sensorineural hearing loss bilateral, no rash

Lab: lactate 6.2 (HIGH chronic), pyruvate elevated, lactate/pyruvate ratio elevated, plasma amino acids — alanine high (chronic acidosis), urine organic acids — Krebs cycle intermediates abnormal; CK mildly elevated; CSF lactate elevated
Muscle biopsy: ragged red fibers + decreased COX staining + abnormal mitochondria EM; mtDNA testing: large deletion confirmed (Kearns-Sayre vs other)', '[{"label":"A","text":"Single drug cure"},{"label":"B","text":"Mitochondrial Disease (multisystemic — features overlap Kearns-Sayre/Leigh syndrome/MELAS): NO CURATIVE TREATMENT — symptomatic + supportive multidisciplinary lifelong; AVOID precipitants — STARVATION (frequent meals, avoid fasting > 4-6 hr, complex carbs at bedtime), DEHYDRATION (adequate hydration always), METABOLIC STRESS (illness/fever — early aggressive treatment with IV fluid + glucose); AVOID drugs that impair mitochondrial function — VALPROIC ACID (HEPATOTOXICITY in mitochondrial), aminoglycosides (deafness), high-dose steroid, anesthetic ketamine + thiopental + nitrous (use propofol total IV anesthesia with caution, avoid prolonged propofol — PRIS); SUPPLEMENT ''MITO COCKTAIL'' (evidence variable but commonly used): COENZYME Q10 (ubiquinone) 5-10 mg/kg/d, CARNITINE 50-100 mg/kg/d (if low), VITAMIN C + E (antioxidants), B vitamins (riboflavin 100 mg/d, thiamine, B12, folate), ARGININE (especially MELAS for stroke-like episodes — 0.5 g/kg orally daily prophylactic, 0.5 g/kg IV acute episode); CREATINE supplementation; address ACUTE LACTIC ACIDOSIS — IV fluid + dextrose, BICARBONATE only severe symptomatic (controversial); DIETARY — frequent small meals, complex carb at bedtime, may benefit from ketogenic diet (selected complex I deficiency); EXERCISE — moderate aerobic exercise improves mitochondrial biogenesis (paradoxically); MULTISYSTEM management — cardiology (cardiomyopathy, conduction defects — Kearns-Sayre block — PACEMAKER may be needed), ophthalmology (PEO, retinopathy), audiology (hearing aids), endocrine (diabetes, hypothyroid, growth issues), neurology (stroke-like episodes, epilepsy, dystonia), GI (dysmotility), nephrology (Fanconi); PT/OT; nutritional support — G-tube selected; genetic counseling — mitochondrial inheritance (mtDNA = maternal, heteroplasmy variable transmission; nDNA = autosomal); EMERGING — gene therapy + mitochondrial replacement therapy (legal in some countries); family support + transition adult"},{"label":"C","text":"Valproic acid"},{"label":"D","text":"Surgery curative"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', 'Mitochondrial disease = heterogeneous multisystem disorders. No cure. Supportive + ''mito cocktail'' (CoQ10, carnitine, vit B/C/E, arginine for MELAS). AVOID valproate (hepatotoxic), aminoglycosides, prolonged anesthetics. Avoid metabolic stress. Multidisciplinary. Mitochondrial inheritance counseling.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'Mitochondrial Medicine Society Practice Patient Care Standards 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี multiple system involvement — developmental regression starting 2 yr + episodic vomiting + lactic acidosis episodes + ptosis bilateral + exercise intolerance + hearing loss bilateral + retinopathy + short stature + lactic acidemia

V/S: BW 14 kg (< 3rd %), HR mildly tachycardic, no acute distress
PE: ptosis bilateral, ophthalmoplegia, retinopathy on fundoscopy, sensorineural hearing loss bilateral, no rash

Lab: lactate 6.2 (HIGH chronic), pyruvate elevated, lactate/pyruvate ratio elevated, plasma amino acids — alanine high (chronic acidosis), urine organic acids — Krebs cycle intermediates abnormal; CK mildly elevated; CSF lactate elevated
Muscle biopsy: ragged red fibers + decreased COX staining + abnormal mitochondria EM; mtDNA testing: large deletion confirmed (Kearns-Sayre vs other)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ตรวจ routine CBC พบ Hb 10.2 (mild anemia) + MCV 65 (microcytic), MCH 21, MCHC normal, RDW 12.5 (NORMAL, not elevated), Plt + WBC normal, Retic 1.8% (normal)

Dietary: balanced, adequate iron-rich foods, breastfed first year + appropriate formula transition, no excessive milk, no recent illness
Family: parents both alpha-thalassemia trait, paternal grandfather Mediterranean origin

Iron studies normal — ferritin 65, TSAT 24%, iron + TIBC normal
Hb electrophoresis: HbA 95%, HbA2 normal, HbF normal (alpha-thalassemia electrophoresis often normal — DNA testing needed)
DNA testing α-globin: alpha-thalassemia trait (heterozygous α/-- or --SEA confirmed)', '[{"label":"A","text":"Iron supplementation indefinite"},{"label":"B","text":"Alpha Thalassemia Trait (alpha-thal carrier, --SEA common Thai/Southeast Asian): NO TREATMENT NEEDED for trait/carrier; reassurance — life expectancy normal, mild microcytosis lifelong, no clinical consequence to individual; DIFFERENTIATE from iron deficiency anemia (similar microcytic but iron studies + normal RDW + family hx + DNA help distinguish — KEY: IDA = high RDW + low ferritin + low TSAT; alpha-thal trait = normal/low normal RDW + normal iron studies + family history); AVOID UNNECESSARY iron supplementation — does not help thalassemia trait + can cause iron overload long-term; counsel family about INHERITANCE — autosomal recessive, both parents trait → 25% offspring may have Hb H disease (3 gene deletion — moderate disease, lifelong) OR Hb Bart hydrops fetalis (4 gene deletion --/-- = lethal in utero — severe consequence!); PREMARITAL / PRECONCEPTION COUNSELING crucial for couple with both alpha-thal trait — option of prenatal diagnosis (CVS, amnio) + preimplantation genetic diagnosis (PGD); national screening program Thai for thalassemia common (high prevalence Thailand 30-40% trait); reproductive education for the patient when older; OTHER ASIAN COUNTRY screening similar; recognize the family genetic implications + offer testing siblings + family; routine pediatric care otherwise; CBC follow-up; routine vaccinations; document allergy + thalassemia trait medical record; consider HPLC + DNA confirmation if uncertain"},{"label":"C","text":"Blood transfusion"},{"label":"D","text":"Splenectomy"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'Alpha-thal trait = common in Southeast Asia, Mediterranean. Asymptomatic carrier. NO TREATMENT needed. Important: DIFFERENTIATE from IDA (RDW + iron studies). Avoid unnecessary iron. CRITICAL: GENETIC COUNSELING for couples — both trait → 25% Hb H disease or HYDROPS FETALIS (lethal). Premarital screening + prenatal diagnosis.', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'Thai National Thalassemia Network; TIF Guidelines for the Management of Non-Transfusion-Dependent Thalassemia 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ตรวจ routine CBC พบ Hb 10.2 (mild anemia) + MCV 65 (microcytic), MCH 21, MCHC normal, RDW 12.5 (NORMAL, not elevated), Plt + WBC normal, Retic 1.8% (normal)

Dietary: balanced, adequate iron-rich foods, breastfed first year + appropriate formula transition, no excessive milk, no recent illness
Family: parents both alpha-thalassemia trait, paternal grandfather Mediterranean origin

Iron studies normal — ferritin 65, TSAT 24%, iron + TIBC normal
Hb electrophoresis: HbA 95%, HbA2 normal, HbF normal (alpha-thalassemia electrophoresis often normal — DNA testing needed)
DNA testing α-globin: alpha-thalassemia trait (heterozygous α/-- or --SEA confirmed)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 13 ปี vaccine ไม่ครบ (missed MMR booster) ปวด + บวม parotid gland bilateral + ไข้ + ปวดศีรษะ + ตึงคอ × 4 d, ตอนนี้ ปวด testicle ข้างขวา + บวมแดง 24 ชม + ไข้สูง ใหม่

V/S: HR 102, RR 22, Temp 38.8°C, BW 38 kg
PE: bilateral parotid swelling + tender, right scrotal swelling + erythema + tender testicle (epididymo-orchitis), no peritoneal sign, no meningeal stiffness severe

Lab: amylase elevated (parotitis), lipase normal (pancreas not), CBC mild lymphocytosis
Mumps IgM positive + RT-PCR positive; HSV negative; bacterial culture negative', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Mumps with Orchitis (post-pubertal complication 15-30% males): supportive care — no specific antiviral (viral self-limited); pain control — acetaminophen, ibuprofen, scrotal support + ice; bed rest, hydration; antiviral — interferon-alpha investigational, not standard; ISOLATION — droplet precautions until 5 days after parotitis onset (highly contagious); steroid use for orchitis controversial — some recommend short course prednisolone 1 mg/kg/d × 3-5 d for severe orchitis to reduce pain + possible fertility impact (evidence limited); WATCH for OTHER COMPLICATIONS — meningitis/encephalitis (1-10%, CSF mononuclear pleocytosis), oophoritis (post-pubertal females), pancreatitis (5%), deafness (sensorineural, sudden 5/10,000), arthritis, myocarditis, thyroiditis; LP if meningoencephalitis suspected (severe HA + AMS + nuchal rigidity); audiogram follow-up at recovery + 3 mo (hearing loss); FERTILITY counsel — orchitis MAY cause testicular atrophy + reduced fertility in 15-30% of orchitis cases, BILATERAL infrequent but more concerning, true sterility rare (~13% unilateral, < 30% bilateral); REPORT — public health (reportable disease); CONTACTS — vaccinate susceptible contacts within 72 hr (MMR), counsel pregnancy contact (vaccine contraindicated pregnancy + immunocompromised); PREVENTION — MMR vaccine 2 dose (Thai EPI + CDC) — outbreaks in undervaccinated communities (booster recommended outbreak settings, third MMR can boost waning immunity per CDC outbreak guidance); long-term — most fully recover, document immunity status for family + patient + reproductive counseling"},{"label":"C","text":"Discharge home no precautions"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Steroid only"}]'::jsonb,
  'B', 'Mumps + orchitis = post-pubertal complication (testicular atrophy + reduced fertility, rare bilateral sterility). Supportive treatment, scrotal support + analgesia, droplet isolation 5 d post-parotitis. Watch other complications (meningitis, deafness, pancreatitis). MMR 2-dose prevention + outbreak boost. Reportable.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Mumps; CDC ACIP Mumps Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 13 ปี vaccine ไม่ครบ (missed MMR booster) ปวด + บวม parotid gland bilateral + ไข้ + ปวดศีรษะ + ตึงคอ × 4 d, ตอนนี้ ปวด testicle ข้างขวา + บวมแดง 24 ชม + ไข้สูง ใหม่

V/S: HR 102, RR 22, Temp 38.8°C, BW 38 kg
PE: bilateral parotid swelling + tender, right scrotal swelling + erythema + tender testicle (epididymo-orchitis), no peritoneal sign, no meningeal stiffness severe

Lab: amylase elevated (parotitis), lipase normal (pancreas not), CBC mild lymphocytosis
Mumps IgM positive + RT-PCR positive; HSV negative; bacterial culture negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี เริ่มซีดอย่างรวดเร็ว + เหนื่อย + ปัสสาวะสีโคล่า dark + ตาเหลือง 3 วัน ก่อนหน้านี้เป็น viral URI 1 สัปดาห์

V/S: HR 132, BP 102/68, RR 24, Temp 37.6°C, BW 20 kg, jaundice
PE: pallor, jaundice, splenomegaly 2 cm BCM, no lymphadenopathy, no organomegaly other

Lab: Hb 5.2 (acute drop from baseline 12), MCV 105 (macrocytic — reticulocytosis), retic 18% (HIGH), LDH 980, haptoglobin LOW, indirect bilirubin 6.2 elevated, direct Coombs POSITIVE (warm IgG), no schistocytes, Plt + WBC normal
Negative ANA, normal complement, no recent drug, viral panel positive Mycoplasma + EBV recent', '[{"label":"A","text":"Iron supplementation alone"},{"label":"B","text":"Acute Autoimmune Hemolytic Anemia warm-IgG (post-viral/Mycoplasma + EBV-associated): admit; ABC + monitor; supportive — adequate hydration (alkalinize urine to prevent renal damage from hemolysis), monitor renal function + electrolytes; PRBC TRANSFUSION carefully if symptomatic severe anemia (Hb < 5 or symptomatic) — challenge: ALL units may be incompatible due to autoantibody panreactive — emergency ''least incompatible'' units selected by blood bank in consultation; slow transfusion with vigilant monitoring; FIRST-LINE — CORTICOSTEROID — prednisolone 1-2 mg/kg/d (max 60 mg) PO OR methylprednisolone IV equivalent — typically 70-80% response, slow taper over months once Hb stabilizes; AVOID PREMATURE STEROID TAPER (relapse common); IVIG 1-2 g/kg in selected cases — short-term boost or if hemolysis severe; FOLIC ACID 1 mg/d (increased demand); REFRACTORY OR RELAPSED — second-line — rituximab (anti-CD20) increasingly first-line or early second in AIHA (especially pediatric — fewer side effects than long-term steroid, durable response); other options: cyclosporine, MMF, azathioprine, danazol; SPLENECTOMY rarely needed kids (long-term infection risk + many spontaneous remission); investigate UNDERLYING — viral (EBV, CMV, Mycoplasma — supportive), drug-induced (review meds), autoimmune (ANA, lupus serology), lymphoproliferative (rare child but consider if persistent), Evans syndrome (AIHA + ITP); thromboprophylaxis selected (AIHA + LE/APS + immobile); patient + family education + monitor recovery; isolation if Mycoplasma or other infectious cause; long-term most children RECOVER with treatment (vs adult AIHA which can be chronic)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery first"}]'::jsonb,
  'B', 'AIHA pediatric usually warm-IgG, often post-viral. Coombs+, hemolysis labs, splenomegaly. Treat with steroid first-line + RBC transfusion carefully (least incompatible). Rituximab second-line increasingly first-line in pediatrics. Long-term recovery typical in kids. Investigate underlying viral/autoimmune.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH Pediatric AIHA; British Society Haematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี เริ่มซีดอย่างรวดเร็ว + เหนื่อย + ปัสสาวะสีโคล่า dark + ตาเหลือง 3 วัน ก่อนหน้านี้เป็น viral URI 1 สัปดาห์

V/S: HR 132, BP 102/68, RR 24, Temp 37.6°C, BW 20 kg, jaundice
PE: pallor, jaundice, splenomegaly 2 cm BCM, no lymphadenopathy, no organomegaly other

Lab: Hb 5.2 (acute drop from baseline 12), MCV 105 (macrocytic — reticulocytosis), retic 18% (HIGH), LDH 980, haptoglobin LOW, indirect bilirubin 6.2 elevated, direct Coombs POSITIVE (warm IgG), no schistocytes, Plt + WBC normal
Negative ANA, normal complement, no recent drug, viral panel positive Mycoplasma + EBV recent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี กำลังกินขนมเชอรี่ + พูด + จู่ ๆ ก็เริ่มไอ + grasps throat + ไม่สามารถพูดได้ + cyanosis เริ่ม + ไม่สามารถหายใจ

Conscious + standing + alert + signs choking universal sign (clutching throat)
ไม่สามารถ cry, no air movement, สีฟ้า

สถานการณ์ critical airway obstruction full', '[{"label":"A","text":"Wait — child usually self-resolves"},{"label":"B","text":"Conscious child with foreign body airway obstruction (FBAO) complete — AHA BLS algorithm: assess universal sign of choking + inability to speak/cough/breathe = COMPLETE OBSTRUCTION; for CONSCIOUS child > 1 yr → ABDOMINAL THRUSTS (Heimlich maneuver) — stand or kneel behind child, place fist (thumb-side) above navel + below ribcage, grasp with other hand, quick upward thrusts × 5 + reassess + repeat until expelled OR unconscious; for INFANT < 1 yr (different) → 5 back blows (between scapulae) + 5 chest thrusts (sternum compression), alternating until expelled or unconscious; if UNCONSCIOUS → start CPR, lower onto firm surface, BEGIN compressions first (per current AHA — compressions may expel FB), 30 compressions then look in mouth for visible FB before breaths (DO NOT blind finger sweep), if FB visible — remove with finger, then 2 breaths if possible, continue CPR; call EMS 1669 (Thailand) immediately; transport once secured (FB removed or in ALS hands); after expulsion → assess + observe (may have lower airway/post-obstruction issues), seek medical care for airway trauma, residual aspiration, swallowing/respiratory function evaluation; AVOID — back blows in standing conscious > 1 yr (per current AHA peds — abdominal thrusts preferred), blind finger sweep (may push FB deeper); PREVENTION — choking-hazard foods (round/hard/smooth — grapes, nuts, hot dogs, hard candy, popcorn, marshmallow), supervise during meals, no eating + running, age-appropriate food, food cut into small pieces, parent CPR training, choking awareness; for severe cases beyond BLS → ALS, emergency cricothyroidotomy (last resort), rigid bronchoscopy if at hospital"},{"label":"C","text":"Wait — observe at home"},{"label":"D","text":"Mouth-to-mouth without addressing"},{"label":"E","text":"Discharge home no assessment"}]'::jsonb,
  'B', 'FBAO = AHA BLS algorithm. Conscious > 1 yr — abdominal thrusts (Heimlich). Infant < 1 yr — back blows + chest thrusts. Unconscious — CPR (compressions first), check mouth between cycles (no blind sweep). Call EMS. Prevention — supervised meals, no choking hazard foods.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AHA BLS Pediatric Guidelines 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี กำลังกินขนมเชอรี่ + พูด + จู่ ๆ ก็เริ่มไอ + grasps throat + ไม่สามารถพูดได้ + cyanosis เริ่ม + ไม่สามารถหายใจ

Conscious + standing + alert + signs choking universal sign (clutching throat)
ไม่สามารถ cry, no air movement, สีฟ้า

สถานการณ์ critical airway obstruction full'
  );

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
