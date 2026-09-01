-- ===============================================================
-- หมอรู้ — Board seed: อายุรศาสตร์ (internal_medicine) — Part 3/4 (Q101-150)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- Apply parts in order: 1, 2, 3, 4
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty (idempotent) ────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('im_clinical_decision', 'อายุรศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'internal_medicine', NULL, 0),
  ('im_basic_science', 'อายุรศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'internal_medicine', NULL, 0),
  ('im_ems_mgmt', 'อายุรศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'internal_medicine', NULL, 0),
  ('im_integrative', 'อายุรศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'internal_medicine', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 50 mcq_questions (Q101-150) ──────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี มา ED ด้วยปวดศีรษะรุนแรง + เหงื่อแตก + ใจสั่น + tremor + คลื่นไส้ paroxysmal episodes มาเป็นเดือน + ความดันเปลี่ยนแปลงรุนแรง

V/S baseline: BP 178/118, HR 124, BP varies 90/60 to 220/130 in 30 min
PE: pallor + diaphoresis during episode, no rash, no goiter, no neck mass

Lab: K 3.6, glucose 162, Cr 1.0, Hb 16 (mild polycythemia)
Plasma free metanephrines: normetanephrine 4.8 nmol/L (high — > 3.5 = positive)
24-hr urine metanephrines + catecholamines: markedly elevated
Clonidine suppression test (if equivocal): not needed here

Localization:
CT abdomen: 5 cm well-enhancing left adrenal mass, central low-attenuation areas, no contralateral mass, no extra-adrenal mass
MIBG scintigraphy: intense uptake left adrenal, no metastasis
Genetic testing pending (RET, VHL, NF1, SDHx — guideline now recommends germline testing all pheochromocytoma due to high inherited rate)', '[{"label":"A","text":"Emergency adrenalectomy without preoperative preparation"},{"label":"B","text":"Pheochromocytoma — Endocrine Society 2014 guideline: (1) **Pre-operative pharmacological preparation MANDATORY** (10-14 days; reduces intraoperative crisis + death): - **Alpha-1 blocker FIRST**: phenoxybenzamine (non-selective, irreversible, long-acting) 10 mg BID titrate up over 2 wk to 1 mg/kg/d divided, target BP < 130/80 supine and mild postural drop standing + nasal congestion (target indicating adequate); doxazosin/prazosin/terazosin (selective, shorter-acting) — alternative + less reflex tachycardia. - **Beta-blocker AFTER alpha is established (NEVER FIRST)**: only if reflex tachycardia or arrhythmia; selective beta-1 (atenolol, metoprolol) or labetalol; START WITH ALPHA UNOPPOSED → otherwise unopposed alpha → hypertensive crisis. - **Calcium channel blocker** (nicardipine, amlodipine): adjunct or alternative if alpha-blocker not tolerated. - **High-salt diet + IV fluid loading** last 2-3 days before surgery — restores volume (chronic catecholamines → vasoconstriction + volume contraction; restoring volume prevents post-op hypotension). - **Tyrosine hydroxylase inhibitor metyrosine**: rarely added for severe / metastatic. (2) Surgery: laparoscopic adrenalectomy preferred for tumors < 6 cm (and select 6-8 cm); open for larger or malignancy. (3) Intra-operative coordination: experienced anesthesia + endocrine surgeon; arterial line + central line; nitroprusside / nicardipine for crisis. (4) Post-operative: hypotension common (vasodilation from alpha-blocker still on board + lost catecholamine surge) — IV fluid + brief vasopressor; hypoglycemia (lost catecholamine-stimulated gluconeogenesis); monitor glucose. (5) Genetic testing for ALL pheochromocytoma (germline mutation 30-40%): RET (MEN2), VHL (von Hippel-Lindau), NF1 (neurofibromatosis), SDHx (paraganglioma syndromes), MAX, TMEM127; cascade family screening. (6) Long-term follow-up: annual biochemical screening for recurrence + metastasis (10-17% — even small benign); imaging based on syndrome. (7) Metastatic pheo/paragangliomas: I-131 MIBG therapy, peptide receptor radionuclide therapy (PRRT — Lu-177-DOTATATE), tyrosine kinase inhibitors (sunitinib), chemotherapy (CVD)"},{"label":"C","text":"Beta-blocker first to control HR"},{"label":"D","text":"Long-term medical management without surgery"},{"label":"E","text":"ACE inhibitor as primary therapy"}]'::jsonb,
  'B', 'Pheochromocytoma — catecholamine-secreting tumor of adrenal medulla (90%) or extra-adrenal paraganglioma (10%); classic episodic triad: headache, sweating, palpitation + hypertension (sustained or paroxysmal). Endocrine Society 2014 + ENS@T + ESE Pheo/Para guideline: (1) Indications for testing: paroxysmal hypertension + symptoms, resistant hypertension, hypertensive crisis during procedure/anesthesia, adrenal incidentaloma, family history of pheo/para syndromes, hereditary syndrome (MEN2, VHL, NF1, SDHx), unexplained orthostatic hypotension. (2) Diagnosis (biochemistry — best sensitivity): - **Plasma free metanephrines + normetanephrines** (high sensitivity 96-100%, lower specificity); supine after 30 min rest; 4× ULN highly diagnostic. - **24-hr urine fractionated metanephrines + catecholamines** (alternative). - Avoid stress, drugs (TCA, MAOI, sympathomimetic, levodopa) that cause false positive. - Clonidine suppression test if equivocal. (3) Localization (only after biochemical confirmation — small chance of catecholamine release from imaging-only incidentalomas misidentified): - CT or MRI abdomen/pelvis (sensitivity 90-100% for adrenal, lower extra-adrenal). - MIBG scintigraphy (123I-MIBG) — functional confirmation, screens extra-adrenal + metastasis. - Ga-68 DOTATATE PET-CT — increasingly preferred (higher sensitivity for SDHx, metastatic). - FDG-PET for poor MIBG uptake / metastatic. (4) Pre-operative preparation (10-14 d): - **Alpha-1 blockade FIRST**: phenoxybenzamine (non-selective, irreversible, long-acting; preferred) 10 mg BID titrate to 1 mg/kg/d; target mild postural drop + nasal stuffiness; alternative doxazosin (selective, shorter; less reflex tachy). - **Beta-blocker only AFTER alpha** (selective beta-1: atenolol, metoprolol; labetalol later) — for reflex tachycardia or arrhythmia; NEVER beta first (unopposed alpha → hypertensive crisis + heart failure). - CCB (nicardipine, amlodipine) adjunct. - High-sodium diet + IV fluid loading last 2-3 days. - Metyrosine (tyrosine hydroxylase inhibitor) rarely. (5) Surgery: laparoscopic adrenalectomy for < 6 cm; open for larger or malignancy or extra-adrenal. (6) Intra-op: experienced team; nitroprusside/nicardipine + magnesium for crisis; postoperative hypotension manage with IV fluid + brief pressor. (7) Hypoglycemia post-op (loss of catecholamine-mediated counterregulation) — monitor glucose. (8) Genetic testing for ALL pheo/para (30-40% germline): RET (MEN2A/B), VHL, NF1, SDHx (SDHB associated with malignant + metastatic; SDHD paternal inheritance), MAX, TMEM127, FH. Cascade family screening. (9) Pregnancy: maternal/fetal mortality high if undiagnosed; alpha-blockade + delivery (C-section or vaginal) + later resection; multidisciplinary. (10) Metastatic (10-17%, higher in extra-adrenal + SDHB): - Surgical debulking if possible. - 131I-MIBG therapy. - 177Lu-DOTATATE (PRRT — peptide receptor radionuclide therapy). - Sunitinib (TKI). - Chemotherapy (CVD — cyclophosphamide, vincristine, dacarbazine). (11) Long-term: lifelong biochemical surveillance (annual) + imaging per syndrome. A ผิด — surgery without prep = high mortality crisis. C ผิด — beta first → unopposed alpha crisis. D ผิด — surgical cure preferred. E ผิด — ACE inhibitor inadequate.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Pheochromocytoma and Paraganglioma 2014; ENSAT/ESE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 38 ปี มา ED ด้วยปวดศีรษะรุนแรง + เหงื่อแตก + ใจสั่น + tremor + คลื่นไส้ paroxysmal episodes มาเป็นเดือน + ความดันเปลี่ยนแปลงรุนแรง

V/S baseline: BP 178/118, HR 124, BP varies 90/60 to 220/130 in 30 min
PE: pallor + diaphoresis during episode, no rash, no goiter, no neck mass

Lab: K 3.6, glucose 162, Cr 1.0, Hb 16 (mild polycythemia)
Plasma free metanephrines: normetanephrine 4.8 nmol/L (high — > 3.5 = positive)
24-hr urine metanephrines + catecholamines: markedly elevated
Clonidine suppression test (if equivocal): not needed here

Localization:
CT abdomen: 5 cm well-enhancing left adrenal mass, central low-attenuation areas, no contralateral mass, no extra-adrenal mass
MIBG scintigraphy: intense uptake left adrenal, no metastasis
Genetic testing pending (RET, VHL, NF1, SDHx — guideline now recommends germline testing all pheochromocytoma due to high inherited rate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 36 ปี ไม่มีโรคประจำตัว มาด้วยปวดศีรษะ + อาการอ่อนเพลีย + ความดันสูง resistant แม้กิน 3 antihypertensives + hypokalemia recurrent

V/S: BP 168/102 on amlodipine 10 mg + lisinopril 40 mg + HCTZ 25 mg (resistant); HR 78, Temp 36.7°C
PE: no edema, no abdominal bruit, no Cushing features, no thyroid

Lab: K 2.8 (low recurrent despite K supplementation), Na 144, Cl 102, HCO3 30 (mild metabolic alkalosis), Cr 0.9, glucose 92, A1c 5.4%
Urinary K appropriately elevated (renal loss), aldosterone:renin ratio (ARR) = 80 (high — > 30 suggestive)
Plasma aldosterone 32 ng/dL (high), Plasma renin activity 0.4 ng/mL/hr (suppressed)
Confirm: oral salt loading test → urinary aldosterone 18 mcg/24h (high — > 12 confirms autonomous), or saline infusion test fails to suppress aldosterone
Adrenal CT: 1.5 cm left adrenal nodule, normal right adrenal
AVS (adrenal venous sampling — gold standard for lateralization): unilateral lateralization left adrenal — ratio left:right > 4
Medications: stop ACEi 4 wk, MRA 6 wk before ARR ideally', '[{"label":"A","text":"Continue current antihypertensives + observe"},{"label":"B","text":"Primary Hyperaldosteronism (Conn syndrome) — unilateral aldosterone-producing adenoma (APA) confirmed by AVS lateralization — Endocrine Society 2016 guideline: (1) Surgical: laparoscopic unilateral adrenalectomy = first-line for confirmed unilateral disease — high cure rate (35-50% complete biochemical + clinical cure; 80-95% improvement in HTN, hypokalemia) per PASO international consensus; (2) Medical (for bilateral disease, refused surgery, surgical contraindication): mineralocorticoid receptor antagonist — spironolactone 12.5-100 mg/d titrate (most common; risk gynecomastia + libido + GI; men intolerant ~ 10%) or eplerenone 25-100 mg BID (selective, less SE, more expensive); newer non-steroidal MRA finerenone (FIDELIO-DKD — primarily for CKD/HF but emerging in primary aldo); (3) Address hypokalemia: K supplement until MRA effective; (4) Monitor for adverse effects: hyperkalemia (esp with ACEi/ARB combo + CKD), gynecomastia (spironolactone), Cr rise; (5) Post-operative follow-up: baseline aldosterone + renin + K + BP at 1, 3, 6, 12 months; many cured of hypokalemia; ~50% cured of HTN; remainder require ongoing antihypertensive; (6) Genetic testing: familial hyperaldosteronism type 1 (GRA — glucocorticoid-remediable, dexamethasone responsive) in early-onset (< 20 yr), family history, intracranial aneurysm; FH-2/3/4 in young; KCNJ5 somatic mutation in APA; (7) Lifestyle: Na restriction (< 2 g/d); weight reduction; alcohol moderation; exercise; (8) Screening indication primary aldosteronism: - Resistant HTN (≥ 3 drugs incl diuretic). - HTN + hypokalemia (spontaneous or diuretic-provoked). - HTN + adrenal incidentaloma. - HTN + family history early HTN/stroke < 40 yr. - HTN + OSA. - First-degree relative of PA patient. (9) Long-term CV risk reduction: PA = higher CV/renal events than essential HTN even at same BP — treat aggressively"},{"label":"C","text":"ACEi + spironolactone combo as first-line medical without surgery"},{"label":"D","text":"Bilateral adrenalectomy without lateralization"},{"label":"E","text":"Beta-blocker monotherapy"}]'::jsonb,
  'B', 'Primary aldosteronism (PA) — autonomous aldosterone excess; aldosterone-producing adenoma (APA, 30-40%) or bilateral adrenal hyperplasia (BAH, 60-65%) or rare familial. Most common cause of secondary HTN (5-15% of HTN). Endocrine Society 2016 + Funder/Lancet PA Cohort: (1) Screening: aldosterone-renin ratio (ARR) > 20-30 (depending on unit) + plasma aldosterone > 10-15 ng/dL. Hold MRA ≥ 6 wk + ACEi/ARB ideally 4 wk + diuretic (can confound); replete K (low K suppresses aldosterone falsely); doxazosin or verapamil for BP during washout. (2) Confirmation (any one — Endocrine Society 4 tests): - Oral salt loading: 24-hr urine aldosterone > 12 mcg after 3-day high-sodium diet. - Saline infusion test: failure to suppress plasma aldosterone < 5-10 ng/dL after 2 L NSS over 4 hr (seated more sensitive than recumbent). - Fludrocortisone suppression test. - Captopril challenge. (3) Subtype testing — Adrenal CT (or MRI) + AVS: - Adrenal CT: may detect nodule but cannot reliably distinguish APA vs non-functional adrenal incidentaloma (especially in older > 35) — sensitivity for APA only 50-70%. - **AVS (adrenal venous sampling) — gold standard for lateralization**, especially > 35 yr (where non-functional incidentaloma common); identify unilateral vs bilateral source. Performed by experienced interventional radiologist; cortisol-corrected ratio. - Some centers omit AVS in young (< 35) + clear unilateral macroadenoma + biochemically severe — clinical judgment. (4) Treatment: - **Unilateral APA**: laparoscopic adrenalectomy — first-line; cure HTN ~50% + biochemical cure ~95%; cardiovascular and renal events reduced. - **Bilateral/familial/refused surgery**: medical management with mineralocorticoid receptor antagonist (MRA). - Spironolactone 12.5-100 mg/d titrate; SE: gynecomastia + libido changes + GI (10-20% men intolerant). - Eplerenone 25-100 mg BID; selective; less SE; expensive. - Finerenone (non-steroidal, newer): emerging. - Adjunct other antihypertensives, K-sparing combo. (5) Adverse + monitor: hyperkalemia (especially with ACEi/ARB + CKD + supplements), Cr rise (10-20% rise acceptable), AKI risk. (6) Post-surgery follow-up: BP + K + aldosterone/renin at intervals; ~50% complete HTN cure; remainder require fewer drugs (predictor: short HTN duration, female, less family Hx, fewer baseline antihypertensives). (7) Familial PA: - FH-1 (glucocorticoid-remediable aldosteronism — GRA): CYP11B1/B2 chimeric gene; dexamethasone responsive; early onset < 20; family history intracranial aneurysm. - FH-2/3/4: various — KCNJ5, CACNA1D, CTNNB1. - Screen all PA < 20 or family history. (8) Indications for PA screening (Endocrine Society): - Sustained BP > 150/100, > 140/90 on ≥ 3 drugs (resistant), controlled BP on ≥ 4 drugs. - HTN + spontaneous or diuretic-provoked hypokalemia. - HTN + adrenal incidentaloma. - HTN + sleep apnea. - HTN + family history of early HTN/CVA < 40. - All hypertensive first-degree relatives of confirmed PA. (9) Cardio-renal events: PA carries higher MACE + AF + renal events at same BP — definitive treatment important. A ผิด — current Rx ineffective. C ผิด — surgery preferred for unilateral. D ผิด — bilateral adrenalectomy = lifelong AI + Nelson risk. E ผิด — BB inadequate.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Primary Aldosteronism 2016; Funder JW et al. J Clin Endocrinol Metab 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 36 ปี ไม่มีโรคประจำตัว มาด้วยปวดศีรษะ + อาการอ่อนเพลีย + ความดันสูง resistant แม้กิน 3 antihypertensives + hypokalemia recurrent

V/S: BP 168/102 on amlodipine 10 mg + lisinopril 40 mg + HCTZ 25 mg (resistant); HR 78, Temp 36.7°C
PE: no edema, no abdominal bruit, no Cushing features, no thyroid

Lab: K 2.8 (low recurrent despite K supplementation), Na 144, Cl 102, HCO3 30 (mild metabolic alkalosis), Cr 0.9, glucose 92, A1c 5.4%
Urinary K appropriately elevated (renal loss), aldosterone:renin ratio (ARR) = 80 (high — > 30 suggestive)
Plasma aldosterone 32 ng/dL (high), Plasma renin activity 0.4 ng/mL/hr (suppressed)
Confirm: oral salt loading test → urinary aldosterone 18 mcg/24h (high — > 12 confirms autonomous), or saline infusion test fails to suppress aldosterone
Adrenal CT: 1.5 cm left adrenal nodule, normal right adrenal
AVS (adrenal venous sampling — gold standard for lateralization): unilateral lateralization left adrenal — ratio left:right > 4
Medications: stop ACEi 4 wk, MRA 6 wk before ARR ideally'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มา ED ด้วยปวดท้องท่อนกลางรุนแรง onset 2 ชม. ก่อน ไม่ตอบ analgesic ปกติ + คลื่นไส้ + อาเจียน + ก่อนหน้านี้กิน AC mass effect + AF on warfarin (recently sub-therapeutic INR 1.4) ขาด dose 2 วัน

V/S: BP 142/88, HR 122 irregularly irregular (AF), RR 24, SpO2 96%, Temp 37.4°C
PE: abdomen soft initially, mild generalized tender — "pain out of proportion to exam" finding classic + no peritonism + no distension yet, normoactive bowel sounds

Lab: WBC 21,000 (very high), Hb 12.4, Plt 220K, Lactate 6.8 (very high — concerning), Cr 1.4, INR 1.4 (sub-therapeutic), K 4.0, glucose 142, ALT 96, AST 88 (mild rise — early ischemia)
ABG: pH 7.30, HCO3 18
Lipase 84 (normal)
No prior abdominal surgery, no IBD, no malignancy known
CT abdomen with IV contrast (with mesenteric angiography phase): SMA (superior mesenteric artery) occlusion at proximal segment, no contrast filling, bowel wall edema + pneumatosis in some segments, no perforation yet, but findings consistent with acute mesenteric ischemia', '[{"label":"A","text":"Observation + nasogastric decompression + IV fluid"},{"label":"B","text":"Acute mesenteric ischemia (AMI) — embolic SMA occlusion (AF + sub-therapeutic anticoagulation = high risk) with bowel wall changes — Surgical emergency: (1) Immediate resuscitation — IV fluid (correct hypovolemia, watch for fluid overload), correct acidemia carefully, broad-spectrum antibiotics (pip-tazo or carbapenem — gut bacterial translocation prophylaxis), IV heparin anticoagulation (full-dose, immediate); NG decompression; foley + arterial line; (2) Urgent surgery + endovascular revascularization — choice depends on bowel viability + center expertise: - Endovascular: mechanical thrombectomy / aspiration ± thrombolytic injection — preferred if viable bowel + no peritonitis + early presentation; - Open: laparotomy + thromboembolectomy (Fogarty catheter from SMA exposed at root) + bypass if atherosclerotic occlusion + resect necrotic bowel + second-look laparotomy 24-48 hr (to reassess marginal segments); (3) Etiology: - Embolic (50%): AF, valve disease, MI, endocarditis — sudden onset, abrupt occlusion, classically near origin of middle colic artery. - Thrombotic (25%): pre-existing atherosclerosis with acute thrombosis at origin — subacute presentation with chronic postprandial pain history. - Non-occlusive (NOMI) (20%): low cardiac output (cardiogenic shock, recent cardiac surgery, sepsis, vasopressors, cocaine) — diffuse vasoconstriction; treat underlying + intra-arterial papaverine. - Mesenteric venous thrombosis (5%): hypercoagulable (factor V Leiden, OCP, antiphospholipid, malignancy, cirrhosis, JAK2 in MPN) — subacute, often manageable with anticoagulation alone if no peritonism. (4) Post-revascularization care: ICU; serial physical exam, lactate, abdominal ultrasonography; second-look laparotomy planned 24-48 hr if any concern; long-term anticoagulation + secondary prevention of underlying cause (rate/rhythm control AF, statin, antiplatelet for atherosclerotic source); (5) Prognosis: high mortality 30-70% even with treatment; early recognition + revascularization within 6-12 hr key"},{"label":"C","text":"Continue current warfarin + IV antibiotic only"},{"label":"D","text":"Surgical biopsy first then medical management"},{"label":"E","text":"Discharge with outpatient cardiology follow-up"}]'::jsonb,
  'B', 'Acute mesenteric ischemia (AMI) — surgical emergency. "Pain out of proportion to physical examination" classic; high mortality (30-70%) due to late recognition. AGA + WSES + Tilsed Br J Surg 2016 AMI guideline: (1) Etiologies: - Embolic SMA (50%): AF, valve disease, recent MI, endocarditis — sudden severe pain. - Thrombotic SMA (25%): pre-existing atherosclerosis acute thrombosis at SMA origin — preceded by chronic postprandial abdominal pain + weight loss (intestinal angina). - Non-occlusive mesenteric ischemia (NOMI) (20%): low-flow state — cardiogenic shock, sepsis, vasopressor, dialysis, cocaine; diffuse vasoconstriction; angiography shows spasm pattern. - Mesenteric venous thrombosis (5%): hypercoagulable (factor V Leiden, OCP, APS, malignancy, MPN, cirrhosis, sepsis); slower onset, may respond to anticoagulation alone if no peritonism. (2) Clinical: - Sudden severe abdominal pain with rapid onset + minimal exam findings initially. - Vomiting, diarrhea, hematochezia later. - Peritonitis = bowel infarction (late, advanced). - Tachycardia + acidemia + leukocytosis + lactic acidosis. - Risk factors history: AF, atherosclerosis, hypercoagulable, low CO. (3) Lab: - Elevated WBC + lactate (often very high, > 4 — sensitive but not specific). - Metabolic acidosis with AG. - LFT mild ↑. - D-dimer ↑ (sensitive, low specificity). - Amylase + lipase can be elevated. (4) Imaging: - **CT angiography (CTA) abdomen-pelvis** — first-line: high sensitivity for arterial occlusion + bowel changes (wall thickening, pneumatosis, portal venous gas, mesenteric edema). - Conventional angiography — diagnostic + therapeutic. - US Doppler — limited. - Plain film — late findings. (5) Management: - Immediate resuscitation: IV fluid, broad-spectrum antibiotics (gut translocation), IV anticoagulation (heparin), NG decompression, foley, art line. - Avoid vasopressors (worsen ischemia). - Treat underlying (rate/rhythm control AF, optimize CO in NOMI). - **Revascularization**: - **Endovascular (preferred when feasible)**: percutaneous mechanical thrombectomy, aspiration, stent — for embolic + thrombotic; if no peritonitis + early; less morbid. - **Open**: laparotomy + SMA embolectomy (Fogarty) + bypass for thrombotic; resect necrotic bowel; second-look laparotomy 24-48 hr (reassess marginal segments). - **Hybrid**: combine if needed. - **Intra-arterial papaverine** for NOMI: vasodilation; treat underlying low-flow. - **Mesenteric venous thrombosis**: anticoagulation alone often sufficient if no infarction; surgery if peritonism. - **Chronic mesenteric ischemia**: postprandial pain, food fear, weight loss; angioplasty/stent OR open bypass. (6) Long-term: - Anticoagulation (lifelong typically). - Source control (AF, atherosclerosis). - Hypercoagulable workup. - Statin, antiplatelet for atherosclerotic. - Bowel rehabilitation; short bowel syndrome if extensive resection. (7) Prognosis: time-critical — outcomes inversely proportional to delay. A ผิด — observation = death. C ผิด — Rx without revascularization fails. D ผิด — no biopsy needed; act. E ผิด — life-threatening.', NULL,
  'hard', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AGA Institute Guideline on Acute Mesenteric Ischemia 2024; WSES Guidelines on Mesenteric Ischemia 2017; Tilsed JV et al. Br J Surg 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มา ED ด้วยปวดท้องท่อนกลางรุนแรง onset 2 ชม. ก่อน ไม่ตอบ analgesic ปกติ + คลื่นไส้ + อาเจียน + ก่อนหน้านี้กิน AC mass effect + AF on warfarin (recently sub-therapeutic INR 1.4) ขาด dose 2 วัน

V/S: BP 142/88, HR 122 irregularly irregular (AF), RR 24, SpO2 96%, Temp 37.4°C
PE: abdomen soft initially, mild generalized tender — "pain out of proportion to exam" finding classic + no peritonism + no distension yet, normoactive bowel sounds

Lab: WBC 21,000 (very high), Hb 12.4, Plt 220K, Lactate 6.8 (very high — concerning), Cr 1.4, INR 1.4 (sub-therapeutic), K 4.0, glucose 142, ALT 96, AST 88 (mild rise — early ischemia)
ABG: pH 7.30, HCO3 18
Lipase 84 (normal)
No prior abdominal surgery, no IBD, no malignancy known
CT abdomen with IV contrast (with mesenteric angiography phase): SMA (superior mesenteric artery) occlusion at proximal segment, no contrast filling, bowel wall edema + pneumatosis in some segments, no perforation yet, but findings consistent with acute mesenteric ischemia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว ตั้งครรภ์ GA 28 weeks มา OPD พบ glucose ใน OGTT screening เกินขีด → diagnosed gestational diabetes mellitus (GDM)

Fasting glucose 110 (cutoff > 92), 1-hr 188 (cutoff > 180), 2-hr 168 (cutoff > 153) — 75g OGTT IADPSG criteria, 2 of 3 abnormal confirms GDM
A1c 5.8% (normal)
BMI 28, weight gain ตามเกณฑ์
Family Hx: mother T2DM
BP 124/76, no proteinuria, fetus AGA on US
No prior GDM in earlier pregnancy', '[{"label":"A","text":"Strict insulin therapy from diagnosis regardless"},{"label":"B","text":"GDM diagnosis (IADPSG 2010 + ADA 2024 + ACOG): (1) Initial: medical nutrition therapy + lifestyle — registered dietitian counseling, carbohydrate counting, distribution across 3 meals + 2-3 snacks (45-50% carb, 20% protein, 30% fat); moderate exercise (walking 30 min post-meals); SMBG (self-monitored blood glucose) 4× daily — fasting + 1 or 2 hr post-meal; target: fasting < 95, 1-hr post < 140, 2-hr post < 120 (some recommend tighter < 90/< 130/<110); (2) Pharmacotherapy if MNT inadequate (target glucose not achieved after 1-2 weeks): - **Insulin** = first-line pharmacotherapy per ADA + ACOG (does not cross placenta, predictable, titratable): basal NPH or detemir bedtime + prandial regular or aspart pre-meal; insulin glargine acceptable but historically off-label (now broadly accepted); needs significant patient education. - **Metformin** + **glyburide**: cross placenta — some safety concerns long-term offspring (metformin: small studies suggest minimal risk, ACOG accepts as alternative; glyburide: neonatal hypoglycemia + macrosomia higher than insulin per MiTy + RCT data — generally avoid as first-line). - **Metformin acceptable alternative** for patient reluctance to insulin + after counseling about long-term unknowns. (3) Monitor: SMBG, A1c every trimester (less useful than SMBG in pregnancy), fetal growth US monthly, antepartum testing (NST, BPP) from 32-34 wk; (4) Delivery timing: 39-40 weeks if well-controlled + no other complications; earlier (38-39 wk) if poor control, macrosomia, polyhydramnios, other complications; 38 wk for medication-requiring; (5) Intrapartum glucose control: maintain glucose 70-110-130 to avoid neonatal hypoglycemia; insulin drip if labor + persistent hyperglycemia; (6) Postpartum: stop pharmacotherapy immediately (often hyperglycemia resolves); breastfeeding encouraged (reduces future T2DM risk in mother + infant); **75g 2-hr OGTT at 4-12 weeks postpartum to detect persistent diabetes / impaired glucose tolerance** (50% of GDM develop T2DM within 10 yr — major risk); annual diabetes screening lifelong; weight management; future pregnancy: GDM screen early (12-16 wk) due to recurrence ~ 50%"},{"label":"C","text":"Discharge home + recheck glucose at term"},{"label":"D","text":"Empirical metformin only without monitoring"},{"label":"E","text":"Plan early delivery at 32 weeks"}]'::jsonb,
  'B', 'Gestational diabetes mellitus (GDM) — diagnosed during pregnancy (excluding pre-existing diabetes). ADA Standards of Care 2024 + ACOG Practice Bulletin 190 + IADPSG/HAPO/Crowther/Landon trials: (1) Screening + diagnosis: - **One-step approach (IADPSG, ADA recommended)**: 75g 2-hr OGTT at 24-28 wk; GDM if any one of fasting ≥ 92, 1-hr ≥ 180, 2-hr ≥ 153. - **Two-step approach (Carpenter-Coustan, ACOG long-standing)**: 50g glucose challenge non-fasting; if 1-hr ≥ 130 or 140, then 100g 3-hr OGTT (fasting ≥ 95, 1-hr ≥ 180, 2-hr ≥ 155, 3-hr ≥ 140); ≥ 2 abnormal = GDM. - First-trimester screening for high-risk (obesity, prior GDM, family Hx, PCOS, A1c ≥ 5.7%, ethnic) — to detect overt diabetes. (2) Management cornerstone — medical nutrition therapy (MNT) + lifestyle: - Carbohydrate counting + distribution. - Moderate exercise (walking post-meals). - SMBG 4× (fasting + post-meals). - Target glucose: fasting < 95, 1-hr < 140, 2-hr < 120 (some recommend tighter). - Weight gain per IOM guidelines. (3) Pharmacotherapy if targets not met in 1-2 wk MNT trial: - **Insulin = first-line per ADA + ACOG** — no placental crossing, predictable, titratable; NPH/detemir basal + regular/aspart prandial; glargine acceptable. - Metformin: alternative; crosses placenta; some long-term offspring concerns; MiTy + recent trials suggest acceptable; ACOG accepts; ADA reserves for those declining insulin. - Glyburide: crosses placenta; ↑ macrosomia, neonatal hypoglycemia (Hebrew Univ JAMA 2015 + RCTs) — avoid first-line per ADA + ACOG; reserved as last option. - Other oral agents not used in pregnancy. (4) Antenatal monitoring: - SMBG. - Fetal growth ultrasound monthly. - Antepartum testing (NST, BPP) from 32-34 wk for medication-requiring; from 36 wk for diet-controlled. (5) Delivery timing (ACOG): - Diet-controlled, well-controlled: 39-40 wk. - Medication-requiring, well-controlled: 39 wk. - Poor control: 36-39 wk based on assessment. - Macrosomia (EFW > 4500): C-section discussion (LGA = shoulder dystocia, birth injury). (6) Intrapartum: maintain glucose 70-110-130; insulin drip if labor + hyperglycemic. (7) Postpartum: - Stop insulin/oral agents at delivery (often resolves). - 75g 2-hr OGTT at 4-12 wk postpartum: 5-15% will have persistent diabetes/IGT. - Lifelong annual diabetes screening (50% develop T2DM within 5-10 yr — major life-long risk). - Breastfeeding (reduces future T2DM in mother + childhood obesity in infant). - Weight management, lifestyle. - Future pregnancy: early screen 12-16 wk (recurrence ~50%). - Counsel re cardiovascular risk lifetime. (8) Neonatal: monitor hypoglycemia (1st hour onwards), hypocalcemia, polycythemia, jaundice, birth trauma; pediatric care plan. A ผิด — insulin not first; MNT first. C ผิด — neglects critical Rx. D ผิด — no monitoring inadequate. E ผิด — preterm not indicated.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ADA Standards of Care 2024 (Management of Diabetes in Pregnancy); ACOG Practice Bulletin 190: GDM; IADPSG Criteria 2010; MiTy Trial Lancet 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว ตั้งครรภ์ GA 28 weeks มา OPD พบ glucose ใน OGTT screening เกินขีด → diagnosed gestational diabetes mellitus (GDM)

Fasting glucose 110 (cutoff > 92), 1-hr 188 (cutoff > 180), 2-hr 168 (cutoff > 153) — 75g OGTT IADPSG criteria, 2 of 3 abnormal confirms GDM
A1c 5.8% (normal)
BMI 28, weight gain ตามเกณฑ์
Family Hx: mother T2DM
BP 124/76, no proteinuria, fetus AGA on US
No prior GDM in earlier pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี underlying HT, dyslipidemia, smoking มา ED ด้วยเจ็บอกใหม่ pressure-like rest pain 20 นาที × 3 ตอนใน 24 ชม. (crescendo)

V/S: BP 142/86, HR 92, RR 18, SpO2 96%
PE: clear lungs, no S3, no edema

EKG: T wave inversion V2-V5 (anterior territory), no ST elevation
Troponin-I: initial 0.08 (mildly elevated, ULN 0.04), 3 hr 0.18 (rising), 6 hr 0.26
Lab: Cr 1.1, Hb 13.0, glucose 130, K 4.1
No bleeding, no contraindication to anticoag', '[{"label":"A","text":"Discharge with outpatient stress test"},{"label":"B","text":"NSTEMI (positive troponin + ischemic EKG without ST elevation) — Management: (1) DAPT load (ASA 162-325 mg chew + P2Y12 inhibitor ticagrelor 180 mg or clopidogrel 600 mg); (2) Anticoagulation: enoxaparin 1 mg/kg SC q12h OR UFH bolus + infusion OR fondaparinux; (3) Anti-ischemic: beta-blocker, nitrate, statin (high-intensity atorvastatin 80 mg); (4) Risk stratification (GRACE, TIMI) — high risk (rising troponin, dynamic EKG, hemodynamic, ongoing pain) → early invasive within 24 hr; intermediate within 24-72 hr; (5) Coronary angiography + revascularization (PCI preferred for single/double vessel; CABG for left main + multivessel especially with DM/reduced EF); (6) Secondary prevention: DAPT × 12 mo (extended if high ischemic risk, shortened if bleeding risk per MASTER-DAPT, TWILIGHT), statin, ACEi/ARB, beta-blocker, lifestyle, cardiac rehab"},{"label":"C","text":"Thrombolytic IV tPA"},{"label":"D","text":"Conservative medical management indefinitely"},{"label":"E","text":"ASA monotherapy + observation"}]'::jsonb,
  'B', 'NSTEMI (Type 1 by 4th UDMI 2018) — ACS without ST elevation, positive troponin. ACC/AHA 2014 (update 2023) + ESC 2023 NSTE-ACS: (1) Dual antiplatelet (DAPT): ASA + P2Y12 (ticagrelor preferred over clopidogrel — PLATO; prasugrel if proceeding to PCI + no stroke Hx). (2) Anticoagulation: enoxaparin, UFH, fondaparinux, bivalirudin. (3) Anti-ischemic + lipid: beta-blocker, nitrate, statin high-intensity. (4) Risk: GRACE, TIMI; very-high (instability, refractory) → immediate < 2 hr; high (rising troponin, dynamic EKG) → < 24 hr; intermediate → < 72 hr; conservative if low GRACE + ischemia-guided. (5) PCI vs CABG: PCI for 1-2 vessel; CABG for LM, complex 3-vessel with diabetes/low EF (SYNTAX score guides). (6) Secondary prevention: DAPT 12 mo (extended if ischemic risk per DAPT score; shortened per MASTER-DAPT, TWILIGHT if bleeding risk), statin, ACEi/ARB if HFrEF/HT/DM/CKD, beta-blocker, ICD if LVEF < 35% > 40 d post-MI, cardiac rehab. Thrombolytics not used in NSTEMI (no clear ST elevation thrombus burden + bleeding risk without mortality benefit).', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA 2014 NSTE-ACS Guideline (update 2023); ESC 2023 NSTE-ACS Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 65 ปี underlying HT, dyslipidemia, smoking มา ED ด้วยเจ็บอกใหม่ pressure-like rest pain 20 นาที × 3 ตอนใน 24 ชม. (crescendo)

V/S: BP 142/86, HR 92, RR 18, SpO2 96%
PE: clear lungs, no S3, no edema

EKG: T wave inversion V2-V5 (anterior territory), no ST elevation
Troponin-I: initial 0.08 (mildly elevated, ULN 0.04), 3 hr 0.18 (rising), 6 hr 0.26
Lab: Cr 1.1, Hb 13.0, glucose 130, K 4.1
No bleeding, no contraindication to anticoag'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี obese BMI 36, มาด้วย excessive daytime sleepiness + snoring loud + กลางคืน apnea เห็นโดย partner + เช้าตื่นปวดศีรษะ + nocturia + irritability

V/S: BP 152/92 (resistant HT), HR 78, neck circumference 44 cm
Mallampati class IV, large tongue, retrognathia
Epworth Sleepiness Scale 18 (severe; > 15 severe)

Lab: Hb 16.4 (mild polycythemia from chronic hypoxia), TSH 1.8, glucose 142, A1c 6.4%
In-lab polysomnography: AHI (apnea-hypopnea index) = 48/hr (severe; > 30 severe), oxygen nadir 76%, total sleep time spent SpO2 < 90% = 28%
No central apnea predominance', '[{"label":"A","text":"Observation alone + weight loss counseling"},{"label":"B","text":"Severe obstructive sleep apnea (OSA) — AHI > 30 + symptoms — (1) **CPAP therapy** = first-line definitive: titrated pressure, autoPAP (APAP) or BPAP if pressure intolerance; reduces daytime sleepiness, BP, CV events, MVA risk; (2) Adherence support — humidification, mask fit (nasal vs full-face), education + follow-up; track usage (≥ 4 hr/night ≥ 70% nights); (3) Adjunct/alternative: mandibular advancement device (mild-moderate; alternative for CPAP-intolerant); positional therapy (positional OSA); weight reduction (cornerstone — bariatric surgery if BMI ≥ 35 + comorbid); (4) Surgical: UPPP (limited evidence), maxillomandibular advancement, hypoglossal nerve stimulation (Inspire — for moderate-severe AHI 15-65, BMI < 40, failed CPAP); (5) Address comorbidity: HT (often resistant; CPAP improves BP), diabetes, dyslipidemia, AF (CPAP reduces recurrence post-cardioversion + ablation); avoid sedatives + alcohol; (6) Driving safety: counsel re drowsy driving; clearance after adequate treatment; (7) Pre-operative concerns: difficult airway, post-op respiratory; STOP-BANG questionnaire; (8) Pediatric/pregnancy considerations distinct"},{"label":"C","text":"Modafinil monotherapy"},{"label":"D","text":"Tracheostomy first-line"},{"label":"E","text":"Oxygen alone at night"}]'::jsonb,
  'B', 'Severe OSA. AASM + ATS + AHA OSA guideline: (1) Diagnosis: PSG (gold standard) — AHI ≥ 5 + symptoms, ≥ 15 alone. Home sleep apnea test (HSAT) for high pre-test probability moderate-severe without complex comorbid. (2) Severity: mild AHI 5-15, moderate 15-30, severe > 30. (3) CPAP cornerstone: improves sleepiness, QoL, BP (especially resistant HT), CV events (observational; SAVE neutral but underpowered for CV); reduces MVA risk. APAP if pressure variability; BPAP if pressure intolerance or hypoventilation. (4) Adherence often suboptimal (40-60% < 4 hr) — interventions critical. (5) Weight reduction: cornerstone; bariatric surgery for BMI ≥ 35 with comorbid OSA. (6) Mandibular advancement device: mild-moderate, CPAP-intolerant; titrate by dentist. (7) Positional therapy. (8) Hypoglossal nerve stimulation (Inspire) — moderate-severe, AHI 15-65, BMI < 40, failed CPAP, non-concentric collapse on DISE. (9) Surgical UPPP limited; maxillomandibular advancement effective for selected. (10) Comorbid: HT, AF (CPAP reduces post-cardioversion recurrence), HFrEF, T2DM, dyslipidemia, depression. (11) Anesthesia + perioperative considerations.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'AASM Clinical Practice Guideline for Diagnosis and Treatment of OSA 2017/2019; ATS/ACCP Guideline 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี obese BMI 36, มาด้วย excessive daytime sleepiness + snoring loud + กลางคืน apnea เห็นโดย partner + เช้าตื่นปวดศีรษะ + nocturia + irritability

V/S: BP 152/92 (resistant HT), HR 78, neck circumference 44 cm
Mallampati class IV, large tongue, retrognathia
Epworth Sleepiness Scale 18 (severe; > 15 severe)

Lab: Hb 16.4 (mild polycythemia from chronic hypoxia), TSH 1.8, glucose 142, A1c 6.4%
In-lab polysomnography: AHI (apnea-hypopnea index) = 48/hr (severe; > 30 severe), oxygen nadir 76%, total sleep time spent SpO2 < 90% = 28%
No central apnea predominance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยไอเรื้อรัง + dyspnea + ผิวมีก้อนแดงๆ (erythema nodosum) + ปวดข้อ + อ่อนเพลีย 3 เดือน + uveitis 1 episode

V/S: BP 124/76, HR 88, RR 18, SpO2 95%, Temp 37.4°C
PE: scattered erythema nodosum tibial, no rash other, no synovitis, no organomegaly

Lab: Hb 11.4, WBC 8,200, Plt 280K, ESR 48, CRP 22, Ca 10.8 (mild hyperCa), ACE 110 (elevated), 25-OH vit D 12 (low; converted to 1,25 by activated macrophages)
CXR: bilateral hilar lymphadenopathy + parenchymal reticular opacities (Scadding stage II)
HRCT: bilateral hilar + mediastinal LAN + perilymphatic micronodules + ground-glass
PFT: restrictive mild + DLCO 70%
EBUS-TBNA biopsy from mediastinal node: non-caseating granuloma + epithelioid + giant cells; AFB stain negative, culture negative; fungal stain negative — confirms sarcoidosis
No TB exposure, no histoplasmosis exposure', '[{"label":"A","text":"Anti-TB therapy 6 months empiric"},{"label":"B","text":"Pulmonary + cutaneous + ophthalmic sarcoidosis (Scadding stage II) — Treatment guided by severity, organ involvement, and symptoms (many self-resolve): (1) Asymptomatic stage I-II without organ-threatening: observation + monitoring (60-70% spontaneous remission); (2) Symptomatic pulmonary, progressive PFT decline, severe extrapulmonary (cardiac, neurological, ocular, hypercalcemia, renal): oral prednisolone 20-40 mg/d × 4-6 weeks then taper slowly over 6-12 months; (3) Steroid-sparing in chronic + refractory: methotrexate (most evidence), azathioprine, mycophenolate, leflunomide; biologic anti-TNF (infliximab, adalimumab) for refractory/severe especially cardiac + neurosarcoidosis + lupus pernio; (4) Skin: topical/intralesional steroid; hydroxychloroquine for chronic; (5) Hypercalcemia: low calcium + low vit D diet, avoid sunlight, hydration, steroid (suppresses macrophage 1α-hydroxylase); (6) Cardiac sarcoidosis: cardiac MRI + FDG-PET; treat with steroid + immunosuppressant; ICD for ventricular arrhythmia (Class I) + advanced AV block; (7) Neurosarcoidosis: aggressive immunosuppression; rituximab option; (8) Uveitis: ophthalmology — topical/systemic steroid + immunosuppressive; (9) Pulmonary rehab; (10) Monitor: serial PFT, CXR + chest HRCT, ACE serum (limited utility), Ca, organ-specific; (11) End-stage fibrosis: lung transplant"},{"label":"C","text":"Cyclophosphamide IV pulse"},{"label":"D","text":"Surgical removal of granuloma"},{"label":"E","text":"Antifungal therapy empirical"}]'::jsonb,
  'B', 'Sarcoidosis — systemic granulomatous disease of unknown cause. Diagnostic: clinical features + non-caseating granuloma + exclusion of alternative cause (TB, fungal, hypersensitivity, malignancy). ATS/ERS/WASOG 2020 + Crouser sarcoidosis guideline: (1) Common manifestations: pulmonary (90%), skin (25%), eye (25%), lymphadenopathy, liver, joint, hypercalcemia, neuro, cardiac. (2) Löfgren syndrome: erythema nodosum + bilateral hilar LAN + arthritis + fever — high spontaneous remission (90%), supportive NSAIDs. (3) Heerfordt syndrome: uveitis + parotitis + fever + facial palsy. (4) Scadding stages (CXR): 0 normal, I hilar LAN only, II hilar LAN + parenchymal, III parenchymal only, IV fibrosis. (5) Treatment decisions based on symptoms + organ-threatening involvement, not stage alone: - Stage I asymptomatic: observe (60-90% spontaneous remission). - Symptomatic / progressive / extrapulmonary major: prednisolone 0.5 mg/kg/d × 4-6 wk then taper over 6-12 mo. - Steroid-sparing: MTX, AZA, MMF, leflunomide. - Refractory + severe (cardiac, neuro, lupus pernio, ocular): infliximab, adalimumab. - Hydroxychloroquine for cutaneous + hypercalcemia. (6) Hypercalcemia: 1,25-vit D-mediated (macrophage activation); avoid sunlight, vit D supplements; treat with steroid. (7) Cardiac sarcoid: arrhythmia, conduction block, HF; cMR + FDG-PET; aggressive immunosuppression + ICD for sustained VT or LVEF < 35% even after Rx. (8) Neurosarcoid: aggressive, often refractory; methylpred + cyclophosphamide or rituximab. (9) Ocular: ophth eval; topical + systemic. (10) Monitor: PFT q3-6mo, imaging, organ-specific. (11) Lung transplant for end-stage fibrotic. (12) Differential: TB (always rule out before steroid in high-prevalence area like Thailand), fungal, beryllium, hypersensitivity, lymphoma.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS/WASOG Statement on Sarcoidosis 2020; Crouser ED et al. Am J Respir Crit Care Med 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยไอเรื้อรัง + dyspnea + ผิวมีก้อนแดงๆ (erythema nodosum) + ปวดข้อ + อ่อนเพลีย 3 เดือน + uveitis 1 episode

V/S: BP 124/76, HR 88, RR 18, SpO2 95%, Temp 37.4°C
PE: scattered erythema nodosum tibial, no rash other, no synovitis, no organomegaly

Lab: Hb 11.4, WBC 8,200, Plt 280K, ESR 48, CRP 22, Ca 10.8 (mild hyperCa), ACE 110 (elevated), 25-OH vit D 12 (low; converted to 1,25 by activated macrophages)
CXR: bilateral hilar lymphadenopathy + parenchymal reticular opacities (Scadding stage II)
HRCT: bilateral hilar + mediastinal LAN + perilymphatic micronodules + ground-glass
PFT: restrictive mild + DLCO 70%
EBUS-TBNA biopsy from mediastinal node: non-caseating granuloma + epithelioid + giant cells; AFB stain negative, culture negative; fungal stain negative — confirms sarcoidosis
No TB exposure, no histoplasmosis exposure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวเดิม มาด้วย dyspnea on exertion progressive 6 เดือน + ขาบวมเล็กน้อย + chest tightness exertional + syncope 1 ครั้ง

V/S: BP 110/72, HR 96, RR 22, SpO2 92% RA, Temp 36.8°C
PE: loud P2, RV heave, parasternal lift, JVP raised with prominent V waves, mild leg edema, no clubbing, no ascites

Lab: CBC normal, BNP 480, TSH 1.6, ANA negative
ABG: PaO2 64, PaCO2 32 (hyperventilation)
CXR: prominent main PA + RV enlargement, peripheral pruning
ECHO: RV dilated + dysfunction, estimated PASP 68 mmHg, no significant LV dysfunction, no significant valvular disease, septal flattening (D-shape LV)
Right heart catheterization (gold standard): mPAP 42 mmHg, PCWP 8, PVR 8 Wood units, CO 3.2 L/min, vasoreactivity test negative
VQ scan: low-probability for PE
CTPA: no PE, no parenchymal lung disease, normal LV
HIV, HCV, antinuclear, anti-centromere, schistosomiasis: all negative
No drug use (no anorexigen, no methamphetamine), no familial PAH history (limited info)', '[{"label":"A","text":"Loop diuretic alone + lifestyle modification"},{"label":"B","text":"Idiopathic Pulmonary Arterial Hypertension (Group 1 PAH) — ESC/ERS 2022 PH guideline: (1) Confirmed by RHC: mPAP > 20 mmHg + PCWP ≤ 15 + PVR > 2 WU (new definition, lower thresholds); (2) Risk stratification (4-variable REVEAL Lite 2 or 3-strata ESC: low/intermediate/high) — guides aggressive treatment; (3) Goals-of-therapy approach: treat to reach + maintain low-risk status; (4) Initial combination therapy preferred for newly diagnosed (AMBITION trial): - **Endothelin receptor antagonist (ERA)** — ambrisentan, bosentan, macitentan (MAESTRO, SERAPHIN). - **PDE5 inhibitor** — sildenafil, tadalafil (PHIRST, SUPER). - Upfront ambrisentan + tadalafil dual combo standard. - **Riociguat** (soluble guanylate cyclase stimulator) — for CTEPH (Group 4) post-PEA and Group 1; do NOT combine with PDE5i (synergistic hypotension). (5) For high-risk or inadequate response: add **prostanoid** (subcutaneous treprostinil, IV epoprostenol, inhaled iloprost, oral selexipag — GRIPHON trial); (6) **Sotatercept** (activin signaling inhibitor) — FDA approved 2024 for adult PAH (STELLAR — first disease-modifying); (7) Vasoreactivity testing: positive (mPAP drops ≥ 10 to < 40 + maintained CO) → calcium channel blocker (high-dose nifedipine, diltiazem, amlodipine) chronic; rare (~10%); (8) Supportive: diuretic for RV failure + edema; oxygen if SpO2 < 90%; anticoagulation in IPAH controversial — no longer routinely; exercise + rehabilitation; avoid pregnancy (high maternal mortality 30-50% — counsel contraception); avoid high altitude > 1500-2000 m; (9) Atrial septostomy or Potts shunt as palliation; (10) Lung transplant for refractory + class IV; (11) Multidisciplinary PH expert center referral essential; (12) Avoid β-blocker (decreases RV CO) unless specific indication"},{"label":"C","text":"Anticoagulation alone"},{"label":"D","text":"Sildenafil monotherapy long-term"},{"label":"E","text":"Lung biopsy first before treatment"}]'::jsonb,
  'B', 'Pulmonary arterial hypertension (PAH) — Group 1 of WHO PH classification. ESC/ERS 2022 PH guideline (major update): (1) New mPAP threshold > 20 mmHg (was 25); pre-capillary if PCWP ≤ 15 + PVR > 2 WU. (2) Groups: 1 PAH; 2 left heart disease (most common); 3 lung disease/hypoxia; 4 CTEPH; 5 multifactorial/unclear. (3) Group 1 subgroups: idiopathic, heritable (BMPR2, EIF2AK4), drug-induced (anorexigen, methamphetamine, dasatinib), CTD-associated (SSc), HIV, portal-pulmonary, congenital heart, schistosomiasis. (4) Diagnosis: TTE screen → RHC confirm + classify. (5) Acute vasoreactivity test (during RHC) only in idiopathic, heritable, drug-induced — positive (~10%) → CCB (high-dose). (6) Risk stratification (3-strata ESC) using NYHA, BNP, 6MWT, RV function — guides therapy aggression. (7) PAH-specific therapy classes: - Endothelin receptor antagonist (ERA): bosentan, ambrisentan, macitentan. - PDE5 inhibitor: sildenafil, tadalafil. - Soluble guanylate cyclase stimulator: riociguat (CTEPH + selected PAH; not with PDE5i). - Prostanoid: epoprostenol (IV), treprostinil (SC/IV/inhaled), iloprost (inhaled), selexipag (oral). - Activin signaling inhibitor: sotatercept (newer, STELLAR 2023 NEJM — disease-modifying). (8) Initial dual oral (ERA + PDE5i) for most; triple including parenteral prostanoid for high-risk; goal = low-risk. (9) Supportive: diuretic + low Na for RV failure, O2 for hypoxemia, anticoagulation reduced (no longer routine in IPAH), exercise rehab, vaccinations, mental health. (10) Avoid pregnancy (mortality 30-50%); contraception counseling — barrier + non-estrogen progestin/IUD. (11) Avoid altitude > 1500 m; commercial air OK with O2. (12) BB only if cardiac comorbid requires. (13) End-stage: atrial septostomy (palliation), Potts shunt, lung transplant.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC/ERS 2022 Guidelines for the Diagnosis and Treatment of Pulmonary Hypertension; AMBITION NEJM 2015; STELLAR Sotatercept NEJM 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวเดิม มาด้วย dyspnea on exertion progressive 6 เดือน + ขาบวมเล็กน้อย + chest tightness exertional + syncope 1 ครั้ง

V/S: BP 110/72, HR 96, RR 22, SpO2 92% RA, Temp 36.8°C
PE: loud P2, RV heave, parasternal lift, JVP raised with prominent V waves, mild leg edema, no clubbing, no ascites

Lab: CBC normal, BNP 480, TSH 1.6, ANA negative
ABG: PaO2 64, PaCO2 32 (hyperventilation)
CXR: prominent main PA + RV enlargement, peripheral pruning
ECHO: RV dilated + dysfunction, estimated PASP 68 mmHg, no significant LV dysfunction, no significant valvular disease, septal flattening (D-shape LV)
Right heart catheterization (gold standard): mPAP 42 mmHg, PCWP 8, PVR 8 Wood units, CO 3.2 L/min, vasoreactivity test negative
VQ scan: low-probability for PE
CTPA: no PE, no parenchymal lung disease, normal LV
HIV, HCV, antinuclear, anti-centromere, schistosomiasis: all negative
No drug use (no anorexigen, no methamphetamine), no familial PAH history (limited info)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 56 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดข้อทั้งสองมือ + เข่า + ผื่นที่หน้าและคอ photosensitive + Raynaud + difficulty climbing stairs (proximal muscle weakness)

V/S: BP 124/78, HR 88, Temp 37.0°C
PE: heliotrope rash (purple eyelid discoloration), Gottron papules (violet papules over MCPs + PIPs + elbows), shawl sign, V-sign, mechanic hands (cracked fingertips), proximal muscle weakness 4/5 shoulder/hip girdle; no goiter; lung clear

Lab: CK 4,200 (high), aldolase 28 (high), LDH 540, ALT 156, AST 188, normal CRP, ESR 64, ANA 1:640 speckled
Myositis-specific antibodies: anti-Jo-1 negative; anti-MDA5 POSITIVE (associated with rapidly progressive ILD + skin); anti-TIF1-γ positive (cancer association)
EMG: irritable myopathy with fibrillation + short duration MUAP
Muscle biopsy: perifascicular atrophy + endomysial mononuclear inflammation + interface vasculopathy
MRI thigh: muscle edema STIR hyperintensity bilateral
Malignancy screening (PET-CT, mammogram, colonoscopy, gyn, dermatology): pending
PFT: FVC 80%, DLCO 65% (mild restriction)
HRCT chest: mild bibasilar ground-glass + early NSIP-like — early ILD', '[{"label":"A","text":"NSAID + observation"},{"label":"B","text":"Dermatomyositis (DM) with skin + muscle + early ILD + cancer-association antibody (anti-TIF1-γ) — Multidisciplinary management: (1) Induction immunosuppression: high-dose prednisolone 1 mg/kg/d (max 80 mg) × 4-6 weeks then taper; pulse IV methylprednisolone 1 g × 3 d if severe (severe weakness, dysphagia, respiratory, cardiac); + concurrent steroid-sparing: methotrexate or azathioprine standard; mycophenolate or tacrolimus for ILD-predominant; rituximab (RIM trial — effective in refractory); IVIG (ProDERM trial — adjunct + first-line option per recent ProDERM 2022 NEJM); cyclophosphamide for severe ILD especially anti-MDA5 (rapidly progressive ILD with high mortality); (2) Skin: hydroxychloroquine + topical steroid + sunscreen + dermatology; (3) ILD monitoring: serial HRCT + PFT every 3-6 mo; aggressive for anti-MDA5 + anti-synthetase positive; consider IVIG + JAK inhibitor + early multitarget therapy for anti-MDA5 rapidly progressive; (4) **Cancer screening MANDATORY** at diagnosis + every 6-12 mo for 3 yr (especially anti-TIF1-γ — 50% cancer association; ovarian, breast, lung, GI, lymphoma, nasopharyngeal): age-appropriate (mammogram, colonoscopy, gyn, prostate, PET-CT) + targeted by symptoms; (5) Physical therapy + rehab; (6) Pneumocystis prophylaxis (high-dose pred + immunosuppression); (7) Vaccinations; (8) DVT prophylaxis (immobility); (9) Cardiac evaluation (myocarditis risk); (10) Dysphagia screening + speech-language pathology; aspiration precautions"},{"label":"C","text":"Pyridostigmine for muscle weakness"},{"label":"D","text":"Antibiotic empirical"},{"label":"E","text":"Only topical therapy for rash"}]'::jsonb,
  'B', 'Dermatomyositis (DM) — idiopathic inflammatory myopathy with characteristic skin features. EULAR/ACR 2017 IIM classification + Bohan-Peter (historical). Subtypes: DM, PM (polymyositis), IBM (inclusion body myositis), immune-mediated necrotizing myopathy (IMNM — anti-SRP, anti-HMGCR), antisynthetase syndrome (anti-Jo-1, anti-PL-7, anti-PL-12; mechanic hands, ILD, arthritis), DM with anti-MDA5 (rapidly progressive ILD, ulcerative skin; high mortality), anti-TIF1-γ (cancer association), juvenile DM. (1) Diagnosis: clinical + CK + EMG + MRI + biopsy + autoantibodies (myositis-specific + myositis-associated). (2) Classic skin DM: heliotrope, Gottron papules, shawl/V-sign, holster sign, mechanic hands (anti-synthetase), ulcerative palmar/digital (anti-MDA5), poikiloderma. (3) Treatment: - **Glucocorticoid**: induction 1 mg/kg/d (max 80) × 4-6 wk then slow taper over 6-12 mo. IV methylpred pulse for severe. - **Steroid-sparing initial**: MTX (often first), AZA, MMF, tacrolimus. - **IVIG**: ProDERM NEJM 2022 — first FDA-approved IVIG for DM; effective adjunct, first-line option. - **Rituximab**: RIM trial — refractory PM/DM. - **Cyclophosphamide**: severe ILD especially anti-MDA5. - **Tofacitinib + JAK inhibitor**: emerging for refractory DM + anti-MDA5 ILD. - **Hydroxychloroquine + topical** for skin. - **Sunscreen** + photoprotection. (4) ILD-predominant: aggressive immunosuppression; consider MMF, calcineurin inhibitor, cyclophosphamide, rituximab. Anti-MDA5 ILD = often rapidly progressive + high mortality → multitarget therapy (steroid + tacrolimus/CsA + cyclophosphamide + IVIG + tofacitinib + plasma exchange) early. (5) **Cancer screening — MANDATORY** at diagnosis + repeated 6-12 mo × 3 yr: - Anti-TIF1-γ: 50% cancer (ovary, breast, lung, NPC in Asians especially, GI, lymphoma); age + targeted workup + PET-CT. - Anti-NXP2: also cancer associated. - Anti-MDA5: lower cancer association. - Anti-synthetase: typically not cancer-associated but ILD. - Screening: age-appropriate (mammogram, colonoscopy, gyn, prostate, skin) + PET-CT in high-risk; in Thailand, especially screen nasopharyngeal CA (high prevalence). (6) PM (polymyositis): rare, must distinguish from IMNM, IBM (which is steroid-refractory; consider IVIG). IBM: > 50 yr, finger flexor + quadriceps wasting, slowly progressive, biopsy rimmed vacuoles. (7) IMNM: severe, persistent CK ↑, refractory; anti-SRP / anti-HMGCR (statin-associated); treat with IVIG + immunosuppression. (8) Adjunctive: PCP prophylaxis, vaccinations, PT/OT, cardiac monitor, dysphagia eval, calcium + vit D + bisphosphonate, mental health.', NULL,
  'hard', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'EULAR/ACR 2017 Classification Criteria IIM; ProDERM IVIG NEJM 2022; 2022 EULAR Update on Idiopathic Inflammatory Myopathies', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 56 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดข้อทั้งสองมือ + เข่า + ผื่นที่หน้าและคอ photosensitive + Raynaud + difficulty climbing stairs (proximal muscle weakness)

V/S: BP 124/78, HR 88, Temp 37.0°C
PE: heliotrope rash (purple eyelid discoloration), Gottron papules (violet papules over MCPs + PIPs + elbows), shawl sign, V-sign, mechanic hands (cracked fingertips), proximal muscle weakness 4/5 shoulder/hip girdle; no goiter; lung clear

Lab: CK 4,200 (high), aldolase 28 (high), LDH 540, ALT 156, AST 188, normal CRP, ESR 64, ANA 1:640 speckled
Myositis-specific antibodies: anti-Jo-1 negative; anti-MDA5 POSITIVE (associated with rapidly progressive ILD + skin); anti-TIF1-γ positive (cancer association)
EMG: irritable myopathy with fibrillation + short duration MUAP
Muscle biopsy: perifascicular atrophy + endomysial mononuclear inflammation + interface vasculopathy
MRI thigh: muscle edema STIR hyperintensity bilateral
Malignancy screening (PET-CT, mammogram, colonoscopy, gyn, dermatology): pending
PFT: FVC 80%, DLCO 65% (mild restriction)
HRCT chest: mild bibasilar ground-glass + early NSIP-like — early ILD'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดศีรษะ + เหนื่อย + ปวดข้อ + ไอเป็นเลือด + ปัสสาวะมีเลือดและฟอง 1 เดือน progressive

V/S: BP 156/96, HR 88, Temp 37.4°C
PE: saddle nose mild deformity, ulcer in nasal mucosa with crusting, lung crackles bilateral, no rash; arthralgia without synovitis

Lab: Hb 9.4, Cr 3.6 (rising from 1.0 over 3 wk), K 4.4, BUN 56, Albumin 3.0
UA: protein 2+, blood 3+, RBC casts +, dysmorphic RBC — active urinary sediment
24-hr urine protein 2.4 g
ESR 88, CRP 56, RF positive low titer, ANA negative
c-ANCA / anti-PR3 (proteinase 3) HIGH POSITIVE → Granulomatosis with polyangiitis (GPA)
CXR + chest CT: bilateral cavitary lung nodules + ground-glass + nodular infiltrate
Kidney biopsy: pauci-immune crescentic glomerulonephritis with crescents in 60% glomeruli, focal necrosis, no immune deposits on IF (pauci-immune)
Neg: anti-GBM, ANA, dsDNA, RF high titer
IgG normal, complement normal', '[{"label":"A","text":"NSAID + monitoring"},{"label":"B","text":"Granulomatosis with Polyangiitis (GPA, c-ANCA/anti-PR3+) with kidney + lung + ENT involvement, organ-threatening (RPGN — rapidly progressive GN with crescents > 50%) — ACR/VF 2021 + EULAR/ERA 2024 AAV guideline: (1) Induction (3-6 months): - **Rituximab** 375 mg/m² weekly × 4 (RAVE, RITUXVAS trials) — non-inferior to cyclophosphamide + safer profile in young + relapsing; PREFERRED first-line per 2024 EULAR. - OR **cyclophosphamide** IV pulse 15 mg/kg q2-3 wk × 6 doses (Euro-Lupus-like) OR oral 2 mg/kg/d × 3-6 mo. - + IV methylprednisolone pulse 500-1000 mg × 3 d → oral prednisolone 1 mg/kg/d taper over 6 mo (more rapid taper supported by PEXIVAS data); - **Avacopan** (C5a receptor antagonist, ADVOCATE trial 2021) — steroid-sparing add-on; allows much lower steroid dose; FDA approved for severe AAV. - **Plasma exchange (PLEX)** — PEXIVAS trial showed no overall benefit on death/ESRD; restricted to: severe diffuse alveolar hemorrhage with respiratory failure, anti-GBM co-positive (double-positive), severe AKI with Cr > 5.7 (selected). (2) Maintenance (2-4 yr after induction): rituximab 500 mg q6mo (MAINRITSAN, MAINRITSAN-2) PREFERRED over azathioprine 2 mg/kg/d or methotrexate; (3) Adjuncts: - PCP prophylaxis (TMP-SMX) — also has anti-relapse effect in nasal carriage Staph aureus. - Bone health (Ca, Vit D, bisphosphonate). - Cardiovascular risk reduction. - Vaccinations (pre-rituximab if possible; inactivated). - Infection vigilance. - Pregnancy counseling (cyclophosphamide infertility risk — cryopreservation considerations). (4) Disease activity monitoring: BVAS, organ-specific, urine sediment, Cr, ANCA titer (rises may precede relapse but unreliable). (5) Subspecialty MDT: nephro + pulm + rheum + ENT + ophth (ophthalmic involvement). (6) Long-term: relapse ~50% within 5 yr; surveillance; secondary cancer + cardiovascular long-term risk; ESRD ~20%; transplant after at least 1 yr remission"},{"label":"C","text":"ACE inhibitor alone"},{"label":"D","text":"Methotrexate alone first-line"},{"label":"E","text":"Plasmapheresis alone without immunosuppression"}]'::jsonb,
  'B', 'Granulomatosis with polyangiitis (GPA, formerly Wegener) — ANCA-associated vasculitis (AAV); small vessel; classic triad: upper respiratory (sinusitis, nasal crust, saddle nose, subglottic stenosis), lower respiratory (cavitary nodules, hemoptysis, DAH), kidney (pauci-immune crescentic GN). EGPA (eosinophilic GPA, Churg-Strauss) — asthma + eosinophilia + neuropathy + p-ANCA (MPO) in 40%. MPA (microscopic polyangiitis) — kidney + lung; p-ANCA/MPO. ACR/VF 2021 + KDIGO + EULAR 2024 AAV guideline: (1) Diagnosis: clinical + biopsy + ANCA + exclude mimics (drug-induced — propylthiouracil, hydralazine, cocaine; infection — endocarditis, TB; CTD). (2) Severity: organ-threatening (RPGN, DAH, CNS, ischemia, severe ENT) vs non-organ-threatening. (3) Induction (organ-threatening): - Rituximab (preferred 2024 EULAR; RAVE, RITUXVAS; safer + equally effective vs cyclophosphamide; preferred in young, relapsing, fertility concerns, women). - Cyclophosphamide (IV pulse Euro-Lupus-like 15 mg/kg q2-3wk × 6 + tapered oral, or daily oral 2 mg/kg/d × 3-6 mo). - Concurrent IV methylpred pulse 500-1000 mg × 3 d → oral pred 1 mg/kg/d with rapid taper (PEXIVAS supports lower-dose steroid arm — non-inferior efficacy, less infection). - Avacopan (C5a receptor antagonist; ADVOCATE NEJM 2021) — steroid-sparing add-on; FDA approved 2021 for severe AAV. (4) Plasma exchange (PLEX) restricted post-PEXIVAS: - Severe DAH with respiratory failure. - Anti-GBM co-positive (double-positive 5-10% of AAV-RPGN). - Severe AKI Cr > 5.7 (selected by individualized assessment). - Not routine for all RPGN. (5) Maintenance: - Rituximab 500 mg q6mo × 18-24 mo (MAINRITSAN, MAINRITSAN-2 — superior to AZA for relapse prevention). - Azathioprine 2 mg/kg/d alternative. - Methotrexate 20-25 mg/wk (mild disease, no renal). - Duration 2-4 yr post-induction, individualized. (6) Mild/limited: methotrexate or mycophenolate + lower-dose pred. (7) Adjuncts: TMP-SMX (PCP prophylaxis + anti-relapse for nasal Staph aureus carriage), Ca + Vit D + bisphosphonate, BP control, lipid + CV, vaccinations, PT, mental health. (8) Pregnancy planning: counsel; CYC = infertility risk (cryopreservation); switch to non-teratogen pre-conception. (9) Surveillance: BVAS, urine, ANCA (limited utility — titer rise may herald relapse but not 1:1). (10) Long-term: 50% relapse < 5 yr; transplant after ≥ 1 yr remission; ESRD 20%; secondary cancer + CV risk. (11) ENT: nasal lavage, antibiotic for chronic Staph; subglottic stenosis — dilation, intralesional steroid, surgery rarely.', NULL,
  'hard', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'ACR/VF 2021 Guideline for the Management of AAV; EULAR/ERA 2024 Update on AAV; PEXIVAS NEJM 2020; ADVOCATE Avacopan NEJM 2021; RAVE NEJM 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 65 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดศีรษะ + เหนื่อย + ปวดข้อ + ไอเป็นเลือด + ปัสสาวะมีเลือดและฟอง 1 เดือน progressive

V/S: BP 156/96, HR 88, Temp 37.4°C
PE: saddle nose mild deformity, ulcer in nasal mucosa with crusting, lung crackles bilateral, no rash; arthralgia without synovitis

Lab: Hb 9.4, Cr 3.6 (rising from 1.0 over 3 wk), K 4.4, BUN 56, Albumin 3.0
UA: protein 2+, blood 3+, RBC casts +, dysmorphic RBC — active urinary sediment
24-hr urine protein 2.4 g
ESR 88, CRP 56, RF positive low titer, ANA negative
c-ANCA / anti-PR3 (proteinase 3) HIGH POSITIVE → Granulomatosis with polyangiitis (GPA)
CXR + chest CT: bilateral cavitary lung nodules + ground-glass + nodular infiltrate
Kidney biopsy: pauci-immune crescentic glomerulonephritis with crescents in 60% glomeruli, focal necrosis, no immune deposits on IF (pauci-immune)
Neg: anti-GBM, ANA, dsDNA, RF high titer
IgG normal, complement normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี ไม่มีโรคประจำตัว มา OPD ด้วย galactorrhea + amenorrhea 1 ปี + headache + visual field defect (bitemporal hemianopia)

V/S: BP 116/72, HR 76, Temp 36.8°C
PE: galactorrhea bilateral, bitemporal hemianopia confirmed, otherwise non-focal neuro

Lab: Prolactin 380 ng/mL (markedly elevated; normal F < 25), TSH 1.6, FT4 1.0, beta-hCG negative, Cr 0.9, LH 1.2, FSH 2.4, estradiol low
MRI pituitary with contrast: 18 mm pituitary macroadenoma compressing optic chiasm + extension to suprasellar
Ophthalmology: bitemporal hemianopia confirmed; visual acuity preserved
Medication history: no antipsychotic, no SSRI, no metoclopramide, no opioid (drug-induced ruled out)
No renal/liver/thyroid dysfunction
Family history: no MEN1', '[{"label":"A","text":"Transsphenoidal surgery first regardless"},{"label":"B","text":"Pituitary macroprolactinoma with visual compromise — **Dopamine agonist** first-line (rare exception in pituitary surgery where medical therapy preferred): (1) **Cabergoline** 0.5 mg twice weekly initial, titrate every 4 wk to normalize prolactin + tumor shrinkage; preferred over bromocriptine — better efficacy, tolerability, twice-weekly dosing; (2) Bromocriptine 2.5-15 mg/d divided alternative (cheaper, more GI SE); (3) Mechanism: dopamine D2 agonist suppresses prolactin synthesis + secretion + tumor cell proliferation; (4) Tumor shrinkage in 80-90% within months → vision improvement; (5) Monitor: prolactin every 1-2 mo until normalized then q6-12mo; MRI 6-12 mo; visual fields if compression; (6) Goal: normalize prolactin + ≥ 50% tumor shrinkage; restore gonadal function + galactorrhea + bone health; (7) Withdrawal trial after ≥ 2 yr normal prolactin + tumor not visible — 30-40% sustained remission; (8) Side effects: GI nausea (take with food, bedtime), orthostatic hypotension, fatigue, psychiatric (dopamine dysregulation, impulse control — gambling/hypersexuality on high-dose for Parkinson; less in prolactinoma low-dose); cardiac valvulopathy with high-dose cabergoline (Parkinson dose > 3 mg/d; prolactinoma doses much lower — risk minimal; echo if > 2 mg/wk or chronic > 5 yr controversial); (9) Surgery (transsphenoidal): reserved for — DA resistance/intolerance, persistent/progressive symptoms despite DA, severe visual deterioration without prompt DA response, apoplexy, CSF leak; (10) Pregnancy: DA-induced restoration of fertility common; counsel; usually safe to stop DA in pregnancy in microadenoma (only 1-3% growth); macroadenoma higher risk — visual field monitoring; (11) Stalk effect: large non-prolactinoma sellar mass can elevate prolactin to 50-150 (compresses dopamine inhibition) — distinguish from true prolactinoma (typically > 200 for macro); hook effect (very high prolactin > 1000 saturates assay → falsely low) — dilution test; (12) Other pituitary hormones evaluation: GH, TSH, cortisol, gonadal — replace deficiencies (cortisol critical)"},{"label":"C","text":"Stereotactic radiosurgery as first-line"},{"label":"D","text":"Estrogen replacement therapy"},{"label":"E","text":"Watchful waiting"}]'::jsonb,
  'B', 'Prolactinoma — pituitary adenoma most common functional type. Macroprolactinoma ≥ 10 mm; microprolactinoma < 10 mm. Endocrine Society 2011 + Pituitary Society + AACE guideline: (1) Diagnosis: prolactin level (microprolactinoma 30-100, macroprolactinoma typically > 200 ng/mL; > 500 highly suggestive macroprolactinoma). Rule out: pregnancy, hypothyroidism, drugs (antipsychotic, metoclopramide, SSRI, opioid, verapamil, cocaine, estrogen high-dose), CKD, cirrhosis, stalk effect (non-prolactinoma sellar mass compressing stalk — typically prolactin 30-150), macroprolactin (biologically inactive, false elevation — PEG precipitation), hook effect (very high prolactin saturates assay falsely low — request dilution). (2) Imaging: MRI pituitary with contrast — sensitivity high for macro; micro may be subtle. (3) Visual fields + ophth eval for macro with suprasellar extension. (4) Treatment — **Dopamine agonist (DA) FIRST-LINE for almost all prolactinoma (including most macros)**: - **Cabergoline 0.25-0.5 mg twice weekly initial, titrate to 1-3 mg/wk** based on prolactin response — preferred (higher efficacy 80-95%, better tolerated, twice-weekly). - Bromocriptine 1.25-2.5 mg/d initial, up to 15-20 mg/d — older, more GI SE, multiple daily dosing. - Side effects: GI nausea (with food, bedtime), orthostasis, headache, psychiatric (impulse control disorders — gambling, hypersexuality at high doses; less in prolactinoma low-doses), nasal stuffiness, cardiac valvulopathy (high-dose cabergoline > 3 mg/d in Parkinson — prolactinoma doses typically far below; echo screening > 2 mg/wk or long-term > 5 yr — controversial; ES does not require routine echo for prolactinoma doses). - Tumor shrinkage 80-90% in macroprolactinoma; visual improvement within weeks. - Microprolactinoma in non-pregnant non-symptomatic with normal gonadal function may be observed; treat if menstrual/fertility/bone concerns. - DA resistance: 10-15% — escalate dose, switch agent, then consider surgery/RT. - Withdrawal after ≥ 2 yr normal prolactin + tumor not visible on MRI: 30-40% sustained remission; trial withdrawal reasonable. (5) Surgery (transsphenoidal): - DA intolerance/resistance. - Apoplexy. - CSF leak from tumor erosion. - Severe progressive visual compromise without prompt DA response (DA can often shrink tumor within days-weeks). - Cystic prolactinoma DA-resistant. (6) Radiation: rare; refractory after surgery + DA failure; stereotactic radiosurgery preferred over conventional. (7) Pregnancy: - Fertility often restored with DA. - Macroprolactinoma: continue DA pre-conception; stop when pregnant if microprolactinoma; macro — controversial, often continue OR stop with close monitor; risk tumor growth in pregnancy 5-30% macro; visual field testing each trimester; emergency surgery for visual decline. - Bromocriptine has longer pregnancy safety record; cabergoline accumulating data — safe. (8) Co-secreting tumors (mixed GH/PRL): manage GH excess primarily. (9) Pituitary hormone evaluation + replacement (cortisol critical, thyroid, gonadal). (10) Genetic: MEN1 (parathyroid, pancreas, pituitary), AIP gene (familial isolated pituitary), MEN4 (CDKN1B) — if young, family history, multiple syndromes.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Hyperprolactinemia 2011; Pituitary Society Consensus Statement on Diagnosis and Management of Prolactinoma 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 35 ปี ไม่มีโรคประจำตัว มา OPD ด้วย galactorrhea + amenorrhea 1 ปี + headache + visual field defect (bitemporal hemianopia)

V/S: BP 116/72, HR 76, Temp 36.8°C
PE: galactorrhea bilateral, bitemporal hemianopia confirmed, otherwise non-focal neuro

Lab: Prolactin 380 ng/mL (markedly elevated; normal F < 25), TSH 1.6, FT4 1.0, beta-hCG negative, Cr 0.9, LH 1.2, FSH 2.4, estradiol low
MRI pituitary with contrast: 18 mm pituitary macroadenoma compressing optic chiasm + extension to suprasellar
Ophthalmology: bitemporal hemianopia confirmed; visual acuity preserved
Medication history: no antipsychotic, no SSRI, no metoclopramide, no opioid (drug-induced ruled out)
No renal/liver/thyroid dysfunction
Family history: no MEN1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มา OPD ด้วยอาการเหนื่อยเพลีย + ทนเย็นไม่ได้ + น้ำหนักขึ้น + ผิวแห้ง + ผม-คิ้วบาง + ประจำเดือนมากผิดปกติ + dyspnea on exertion 6 เดือน

V/S: BP 108/68, HR 56, Temp 35.8°C
PE: dry skin, periorbital puffiness, delayed reflex relaxation (Achilles), mild goiter, no eye signs, no tremor

Lab: TSH 28 (high — primary hypothyroid), Free T4 0.4 (low), Free T3 1.4 (low-normal), anti-TPO antibody very high (Hashimoto)
Lipid: TC 286, LDL 192, TG 180
CBC: mild normocytic anemia Hb 10.6
Cr 0.9, Na 134, K 4.0
CK 380 (mild elevation)
EKG: low voltage, bradycardia, no ischemia
Not pregnant', '[{"label":"A","text":"Levothyroxine 100 mcg/d aggressive starting + statin"},{"label":"B","text":"Primary hypothyroidism (Hashimoto''s autoimmune thyroiditis) — ATA 2014 + Endocrine Society + AACE guideline: (1) **Levothyroxine (LT4) replacement**: weight-based starting 1.6 mcg/kg/d in healthy young adults (~ 75-100 mcg in this patient); start lower 25-50 mcg in elderly + cardiac disease (avoid precipitating angina/AF); take fasting (30-60 min before food/coffee/iron/calcium/PPI — affect absorption); same time daily; avoid generic switching (bioequivalence variability); (2) Titrate based on TSH every 6-8 wk (steady state); target TSH 0.5-2.5 mIU/L (or lower half of normal range); higher target (4-6) in elderly > 70-80 + cardiac disease + frail; (3) Pregnancy: increase LT4 dose by 30% upon confirmation of pregnancy; target TSH < 2.5 in 1st trimester, < 3.0 thereafter; (4) Monitor T4/free T4 also; TSH may lag; (5) Avoid: T3 monotherapy or T3/T4 combo not better than T4 alone for most (controversial); desiccated thyroid (Armour) — variable composition; (6) Address comorbid: dyslipidemia may resolve with euthyroidism (recheck lipid 3-6 mo before statin decision); (7) Subclinical hypothyroidism (TSH 5-10, normal T4): treat if symptoms, pregnancy/trying, goiter, antibody positive young, hyperlipidemia, depression, infertility, CV risk; observe in elderly asymptomatic; TRUST trial questioned routine; (8) Iodine adequacy; (9) Other autoimmune polyendocrine screen (Addison, T1DM, vitiligo, pernicious anemia, celiac); (10) Patient education: lifelong; symptoms of over/under; medication interactions; (11) Myxedema coma is severe form requiring IV LT4/T3 + steroid (already covered)"},{"label":"C","text":"T3 monotherapy"},{"label":"D","text":"Iodine supplementation alone"},{"label":"E","text":"Observation only — TSH may normalize"}]'::jsonb,
  'B', 'Primary hypothyroidism — Hashimoto thyroiditis most common cause in iodine-replete areas. ATA 2014 + Endocrine Society + AACE 2018 hypothyroidism guideline: (1) Diagnosis: TSH (most sensitive in primary), free T4. Primary: TSH ↑, free T4 ↓. Subclinical: TSH ↑, free T4 normal. Secondary (pituitary): TSH normal-low, free T4 ↓. Anti-TPO antibody confirms Hashimoto (+ anti-Tg). (2) Treatment: - **Levothyroxine (LT4)** monotherapy — synthetic T4; deiodinated peripherally to T3; physiological. - Start dose: 1.6 mcg/kg/d full replacement in young healthy (typically 75-150 mcg). - Lower start (25-50 mcg) in elderly > 65, cardiac disease (CAD, AF) — avoid precipitating ischemia/arrhythmia; titrate q4-6 wk. - Administration: fasting, 30-60 min before food (especially calcium, iron, PPI, coffee, soy, fiber — reduce absorption); consistent timing; bedtime acceptable if 3 hr post-meal. - Avoid generic switching (slight bioequivalence variability can affect TSH). (3) Monitor: TSH q6-8 wk (steady state at 4-6 wk) until stable; then q6-12 mo lifelong. Adjust dose 12.5-25 mcg increments. (4) Targets: - General: TSH 0.5-2.5 (or normal range center). - Pregnancy 1st tri: < 2.5. - Pregnancy 2nd-3rd tri: < 3.0. - Elderly > 70-80: 4-6 acceptable to avoid AF, osteoporosis, frailty. (5) Pregnancy: ↑ LT4 by 30% upon confirmation; monitor q4-6 wk. (6) T3 monotherapy or T3/T4 combo: not superior to T4 alone in most (debate; multiple RCTs negative; some patients with DIO2 polymorphism may benefit — emerging). (7) Desiccated thyroid (Armour, NP Thyroid): variable T3:T4 ratio; less stable; not preferred. (8) Subclinical: treat if pregnancy/planning, TSH > 10, symptoms attributable, goiter, anti-TPO +, infertility, depression, hyperlipidemia not LDL-target. TRUST trial showed no symptom benefit in elderly mild TSH 5-7 — guidelines moving toward not treating mild elderly subclinical. (9) Drugs affecting LT4: bile sequestrant, iron, calcium, PPI, magnesium, fiber, soy, sucralfate, raloxifene, estrogen (↑ TBG → ↑ dose), tyrosine kinase inhibitors, amiodarone (complex), lithium, anti-epileptic. (10) Causes of primary hypothyroidism: Hashimoto, post-thyroidectomy, post-RAI, transient (postpartum, subacute, silent thyroiditis), iodine deficiency or excess, drug-induced (amiodarone, lithium, IFN-α, immune checkpoint inhibitor), congenital. (11) Other autoimmune polyglandular screen: T1DM, Addison, vitiligo, pernicious anemia, celiac.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Guidelines for the Treatment of Hypothyroidism 2014; Endocrine Society Clinical Practice Guideline on Hypothyroidism; AACE/ATA 2018 Updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มา OPD ด้วยอาการเหนื่อยเพลีย + ทนเย็นไม่ได้ + น้ำหนักขึ้น + ผิวแห้ง + ผม-คิ้วบาง + ประจำเดือนมากผิดปกติ + dyspnea on exertion 6 เดือน

V/S: BP 108/68, HR 56, Temp 35.8°C
PE: dry skin, periorbital puffiness, delayed reflex relaxation (Achilles), mild goiter, no eye signs, no tremor

Lab: TSH 28 (high — primary hypothyroid), Free T4 0.4 (low), Free T3 1.4 (low-normal), anti-TPO antibody very high (Hashimoto)
Lipid: TC 286, LDL 192, TG 180
CBC: mild normocytic anemia Hb 10.6
Cr 0.9, Na 134, K 4.0
CK 380 (mild elevation)
EKG: low voltage, bradycardia, no ischemia
Not pregnant'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี underlying sickle cell disease HbSS (compound heterozygous of mother HbS + father α-thal, presenting moderate disease) มา ED ด้วยปวดมาก hands + feet + chest + back หลังจาก exposure ต่ออากาศเย็น + dehydration 24 ชม.

V/S: BP 124/76, HR 108, RR 22, SpO2 94%, Temp 38.4°C
PE: in distress, no focal organ findings on chest exam, no neuro deficit

Lab: Hb 7.2 (baseline 8.0 — mild drop), retic 12%, WBC 14,000 (chronic mild leukocytosis), Plt 420K, peripheral smear: sickle cells + target cells + Howell-Jolly bodies (functional asplenia)
LDH 480 (elevated chronic hemolysis baseline)
Cr 0.9, no AKI, K 4.2
ABG: pH 7.36, PaO2 86, PaCO2 36
CXR: clear, no infiltrate
Pain scale 9/10
No focal infection identified', '[{"label":"A","text":"Discharge home with oral analgesic"},{"label":"B","text":"Vaso-occlusive crisis (VOC) in sickle cell disease — Comprehensive management per NHLBI 2014 + ASH 2020 + Thai SCD guideline: (1) Pain control IMMEDIATELY — within 30 min of arrival; opioid IV (morphine 0.1-0.15 mg/kg, hydromorphone) titrate to pain; PCA pump for moderate-severe; avoid meperidine (neurotoxicity); adjunct: acetaminophen + NSAID (avoid in AKI), low-dose ketamine; (2) IV fluid — NSS or LR maintenance to address dehydration but avoid over-hydration (risk pulmonary edema, ACS); (3) Oxygen if SpO2 < 95% or symptomatic; (4) Identify + treat precipitant: infection (broad-spectrum antibiotic if febrile / suspected — functional asplenia = encapsulated organism risk; pip-tazo or ceftriaxone empirical), cold, dehydration, acidosis, stress; (5) Watch for complications: - **Acute chest syndrome (ACS)** — new infiltrate + chest symptom: cefuroxime/azithromycin + RBC transfusion / exchange + bronchodilator + incentive spirometry. - Stroke: emergent imaging + exchange transfusion. - Splenic sequestration: aggressive transfusion. - Priapism: aspiration + epinephrine intracorporeal. - AKI, MOF. (6) **Transfusion**: simple RBC if Hb significantly below baseline + symptomatic; exchange transfusion for severe ACS / stroke / multi-organ failure (target HbS < 30%); chronic transfusion for stroke prevention (STOP), severe pain crisis prevention. (7) **Hydroxyurea**: first-line disease-modifying — increases HbF, reduces crises (MSH trial), ACS, transfusion need, mortality; start 15 mg/kg/d titrate; monitor CBC + reticulocyte; benefit in HbSS + HbSβ⁰; (8) **L-glutamine** (Endari) — adjunctive, reduces pain crisis; (9) **Crizanlizumab** (anti-P-selectin mAb) — reduces pain crises (SUSTAIN); (10) **Voxelotor** (HbS polymerization inhibitor) — increases Hb (HOPE); (11) **Curative**: allogeneic HSCT (HLA-matched sibling — best in children + young); gene therapy (lentiviral β-globin LentiGlobin — bluebird bio bb1111; CRISPR gene editing exa-cel for BCL11A — FDA approved 2023 — emerging cure); (12) Long-term: pneumococcal/H. influenzae/meningococcal vaccination, penicillin prophylaxis childhood, folic acid supplement, retinal screen, TCD for stroke screen in pediatric, pulmonary hypertension screen, renal disease monitoring, mental health support, transition of care, pain management plan + functional support"},{"label":"C","text":"Routine exchange transfusion without indication"},{"label":"D","text":"Anticoagulation with heparin"},{"label":"E","text":"Steroid IV high-dose monotherapy"}]'::jsonb,
  'B', 'Vaso-occlusive crisis (VOC) — most common cause SCD ED visits + hospitalization. Pathophysiology: HbS polymerization in deoxygenated state → sickled RBC → vaso-occlusion + ischemia + inflammation + endothelial dysfunction + chronic hemolysis. NHLBI 2014 + ASH 2020 sickle cell + Thai Hemato Soc guideline: (1) Pain: opioid IV early + frequent reassessment + adjunct (acetaminophen, ketorolac avoid in AKI, low-dose ketamine, gabapentin); PCA pump for moderate-severe; avoid meperidine (neurotoxic metabolite); home pain plan for chronic. (2) IV fluid: maintenance + correct dehydration; avoid over-hydration (pulmonary edema, ACS risk). (3) Oxygen: only if hypoxemic; routine high-dose O2 not beneficial. (4) Precipitants: infection (functional asplenia → encapsulated organism); cold; dehydration; acidosis; stress; pregnancy; surgery; altitude. (5) Empirical antibiotic if febrile: ceftriaxone (or pip-tazo if severe); penicillin prophylaxis childhood (PROPS); pneumococcal/Hib/meningococcal vaccines. (6) Complications: - Acute chest syndrome (ACS): new pulmonary infiltrate + chest sx ± fever — leading cause of death adult SCD; transfusion (simple or exchange depending on severity), broad-spectrum (cefuroxime + azithromycin for atypical), bronchodilator, incentive spirometry. - Stroke (ischemic in pediatric; hemorrhagic + ischemic in adult): emergent imaging + exchange transfusion. - Splenic sequestration: pediatric; aggressive PRC + IV fluid; splenectomy may be needed. - Aplastic crisis: parvovirus B19 → reticulocytopenia; supportive. - Priapism: aspiration + intracavernosal epinephrine. - AKI: hydration; avoid contrast/NSAID. - Avascular necrosis: hip, shoulder. - Cholelithiasis. - Leg ulcers. - Pulmonary hypertension. - Renal: glomerulopathy, papillary necrosis. (7) Disease-modifying: - Hydroxyurea: HbF-inducing; reduces VOC, ACS, transfusion, mortality (MSH NEJM 1995; PEAR Lancet Child); start 15 mg/kg/d titrate to 35; benefit HbSS, HbSβ⁰. - L-glutamine (Endari): reduces VOC. - Crizanlizumab (anti-P-selectin): SUSTAIN — reduces VOC. - Voxelotor (HbS polymerization inhibitor): ↑ Hb (HOPE); withdrawn 2024 after post-marketing safety. (8) Transfusion: - Simple for severe anemia symptomatic. - Exchange for: severe ACS, stroke, multiorgan failure, pre-surgery; target HbS < 30%. - Chronic transfusion: stroke prevention high TCD (STOP); severe VOC prevention; pregnancy in select. - Iron overload management: chelation (deferasirox, deferoxamine, deferiprone). - Alloimmunization risk; matched RBC (Rh, Kell). (9) Curative: - HSCT: matched sibling — high success in children; expanding to adults + haploidentical. - Gene therapy: LentiGlobin BB305 (bb1111); FDA-approved exa-cel (Casgevy, CRISPR Cas9 editing BCL11A reactivating HbF) 2023 — first CRISPR-approved; lovo-cel (Lyfgenia) 2023. (10) Long-term care: vaccinations, prophylaxis, folate, retinal screen, TCD pediatric, pulm HT screen, renal, AVN screen, mental health, pain management plan, transition to adult care.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NHLBI Evidence-Based Management of Sickle Cell Disease 2014; ASH 2020 Sickle Cell Disease Guideline; Thai Hematology Society SCD Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 24 ปี underlying sickle cell disease HbSS (compound heterozygous of mother HbS + father α-thal, presenting moderate disease) มา ED ด้วยปวดมาก hands + feet + chest + back หลังจาก exposure ต่ออากาศเย็น + dehydration 24 ชม.

V/S: BP 124/76, HR 108, RR 22, SpO2 94%, Temp 38.4°C
PE: in distress, no focal organ findings on chest exam, no neuro deficit

Lab: Hb 7.2 (baseline 8.0 — mild drop), retic 12%, WBC 14,000 (chronic mild leukocytosis), Plt 420K, peripheral smear: sickle cells + target cells + Howell-Jolly bodies (functional asplenia)
LDH 480 (elevated chronic hemolysis baseline)
Cr 0.9, no AKI, K 4.2
ABG: pH 7.36, PaO2 86, PaCO2 36
CXR: clear, no infiltrate
Pain scale 9/10
No focal infection identified'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการอ่อนเพลีย + lymphadenopathy generalized 6 เดือน + ไข้ low + เหงื่อกลางคืน + น้ำหนักลด 7 kg ใน 3 เดือน + abdominal fullness

PE: cervical + axillary + inguinal lymphadenopathy non-tender 1-3 cm; spleen 6 cm below costal margin; hepatomegaly 4 cm

Lab: Hb 9.4, MCV 90, WBC 92,000 (very high lymphocytosis), Plt 110K
Peripheral smear: > 80% small mature lymphocytes + smudge cells (typical CLL)
Flow cytometry: CD5+, CD19+, CD20+ (dim), CD23+, kappa light chain restricted; clonal B-cell — CLL phenotype
LDH 380, β2 microglobulin 4.8 (elevated), Coombs negative
IgG 580 (low — hypogammaglobulinemia)
FISH: del(17p) detected (high-risk), TP53 mutation positive (high-risk) — adverse cytogenetic
IGHV: unmutated (adverse)
No hyperleukocytosis symptoms, no AIHA, no ITP
Bone marrow: > 30% mature lymphocyte infiltration
Rai stage III (anemia), Binet stage C — symptomatic, treatment indication
No allogeneic donor identified', '[{"label":"A","text":"Watchful waiting indefinitely"},{"label":"B","text":"CLL with high-risk features (del 17p + TP53 mutation + unmutated IGHV) symptomatic Rai III — NCCN 2024 + iwCLL + ESMO CLL guideline: (1) Treatment indication (iwCLL): symptomatic disease — anemia (Hb < 10), thrombocytopenia (Plt < 100K), bulky lymphadenopathy, massive/progressive splenomegaly, autoimmune cytopenia refractory, constitutional symptoms (weight loss > 10%, fever > 38, night sweats, fatigue), rapidly doubling lymphocyte count, threatened organ function; (2) Targeted therapy preferred (replacing chemoimmunotherapy in most): - **BTK inhibitor**: zanubrutinib (preferred — selective, better tolerated than ibrutinib; ALPINE, SEQUOIA) OR acalabrutinib (ASCEND) OR ibrutinib (RESONATE — first-gen, more AF + bleeding + HT + arthralgia) — continuous treatment until progression/intolerance. - **BCL2 inhibitor venetoclax + obinutuzumab** (fixed-duration 12 mo; CLL14 in older + comorbid) — alternative; allows treatment-free remission; tumor lysis syndrome (TLS) prophylaxis essential (ramp-up dosing, IV fluid, allopurinol, frequent labs); - **Combination venetoclax + ibrutinib** (CAPTIVATE) — fixed-duration MRD-guided. - **Chemoimmunotherapy (FCR — fludarabine + cyclophosphamide + rituximab)**: superseded for most; reserved for young fit IGHV-mutated no TP53 abnormality — possible cure (CLL8); avoid in del 17p (no benefit, toxic). - **17p/TP53 patients**: chemoimmunotherapy CONTRAINDICATED — always use targeted (BTKi or venetoclax-based). (3) Chemoimmunotherapy historical: BR (bendamustine + rituximab) for older fit; FCR for young; now superseded. (4) Supportive: - Infection prophylaxis: IVIG for recurrent infection + hypogamma; PCP prophylaxis (TMP-SMX) on BTKi + venetoclax + chemoimmunotherapy; antiviral acyclovir; antifungal in selected. - Vaccinations (pneumococcal PCV20 + booster PPSV23, influenza, COVID, RSV, shingles); avoid live; reduced response to vaccines. - Tumor lysis prophylaxis venetoclax: ramp-up dosing 20 → 50 → 100 → 200 → 400 mg weekly; allopurinol; hydration; frequent monitoring. - Autoimmune complications: AIHA (warm Coombs +), ITP — steroid, rituximab. - Hypogammaglobulinemia: IVIG 0.3-0.5 g/kg/mo if severe + recurrent infection. - Second cancer surveillance: skin, breast, prostate per age; Richter transformation (DLBCL, Hodgkin) — aggressive lymphoma transformation. (5) Allogeneic HSCT: rare modern era; for double-refractory + young fit + matched donor + high-risk; emerging CAR-T (lisocabtagene maraleucel + others for B-cell)"},{"label":"C","text":"Fludarabine-based chemoimmunotherapy"},{"label":"D","text":"Splenectomy first-line"},{"label":"E","text":"Radiation therapy to lymph nodes"}]'::jsonb,
  'B', 'Chronic Lymphocytic Leukemia (CLL) — most common adult leukemia in West; clonal B-cell. Diagnosis: > 5,000 monoclonal B cells/μL × ≥ 3 mo + characteristic immunophenotype (CD5+ CD19+ CD20dim CD23+ kappa/lambda restricted; FMC7-, sIg dim — distinguishes from MCL [CD5+ CD23-] and other B-cell lymphomas). Small lymphocytic lymphoma (SLL) = same disease, tissue-based without significant blood lymphocytosis. NCCN 2024 + iwCLL 2018 + ESMO 2020 CLL guideline: (1) Diagnosis: flow cytometry of peripheral blood (no bone marrow needed typically); FISH for del(13q), del(11q), del(17p), trisomy 12, complex karyotype; TP53 mutation (sequencing); IGHV mutational status. (2) Risk stratification: - Rai (US): 0 — lymphocytosis; I — LAN; II — organomegaly; III — anemia; IV — thrombocytopenia. - Binet (Europe): A — < 3 lymphoid areas; B — ≥ 3; C — anemia/thrombocytopenia. - CLL-IPI: TP53, IGHV mutational, β2-microglobulin, age, stage. - High-risk genetics: del(17p), TP53 mutation, complex karyotype, unmutated IGHV. (3) Treatment indication (iwCLL active disease): - Significant marrow failure (anemia, thrombocytopenia). - Massive/progressive/symptomatic splenomegaly or LAN. - Lymphocyte doubling < 6 mo or > 50% increase in 2 mo (in WBC > 30,000). - Autoimmune cytopenia refractory. - Constitutional symptoms (weight loss > 10%/6 mo, fever > 38 × 2 wk, night sweats > 1 mo, fatigue ECOG ≥ 2). - Asymptomatic early stage: WATCH AND WAIT — no benefit from earlier treatment (CLL12 venetoclax not yet adopted; LLC7 ibrutinib in high-risk under study). (4) First-line treatment (NCCN 2024 + iwCLL 2024): - **High-risk (del 17p or TP53 mut)**: BTK inhibitor (zanubrutinib, acalabrutinib, ibrutinib) continuous; OR venetoclax + obinutuzumab; chemoimmunotherapy CONTRAINDICATED. - **Standard-risk**: BTKi OR venetoclax-obinutuzumab OR (older fit + IGHV-mutated + no TP53 abnormality) FCR (potentially curative in selected per CLL8/CLL10). - Older comorbid: venetoclax + obinutuzumab (CLL14) or BTKi. - Goal: MRD-negative (deep response, durable). (5) BTKi: - Zanubrutinib (preferred — selective, fewer AF/HT/arthralgia/bleeding). - Acalabrutinib (selective, AF lower than ibrutinib). - Ibrutinib (first-gen; AF 5-15%, HT, bleeding, arthralgia, infection — significant). - Pirtobrutinib (non-covalent — for BTKi-resistant). (6) BCL2 inhibitor venetoclax: - Tumor lysis prophylaxis essential (ramp-up dosing 20 → 50 → 100 → 200 → 400 mg weekly; allopurinol; IV hydration; monitor TLS labs). - Hospitalization for high-burden first dose escalations. - Fixed-duration combination with obinutuzumab × 12 mo. (7) Refractory: - BTKi-refractory → venetoclax + rituximab (MURANO). - Double-refractory → pirtobrutinib, CAR-T (lisocabtagene maraleucel — emerging for CLL). - Allogeneic HSCT — rare modern era; for selected young fit double-refractory. (8) Richter transformation (5-10%): clonally related DLBCL (most) or Hodgkin (rare); aggressive; poor prognosis; treat as DLBCL ± SCT. (9) Supportive: - Hypogammaglobulinemia + recurrent infection: IVIG 0.3-0.5 g/kg/mo. - Vaccinations (pre-treatment if possible; avoid live; response often suboptimal). - Infection prophylaxis: PCP (TMP-SMX), HSV/VZV (acyclovir) on chemotherapy/BTKi/venetoclax. - Autoimmune cytopenia: corticosteroid, rituximab. - Second cancer surveillance: skin (frequent), solid (lung, GI, prostate, breast). (10) iwCLL 2018 response criteria: CR, PR, SD, PD; MRD assessment by flow.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Guidelines for CLL/SLL 2024; iwCLL 2018 Update + 2024 Update; ESMO Clinical Practice Guidelines for CLL 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการอ่อนเพลีย + lymphadenopathy generalized 6 เดือน + ไข้ low + เหงื่อกลางคืน + น้ำหนักลด 7 kg ใน 3 เดือน + abdominal fullness

PE: cervical + axillary + inguinal lymphadenopathy non-tender 1-3 cm; spleen 6 cm below costal margin; hepatomegaly 4 cm

Lab: Hb 9.4, MCV 90, WBC 92,000 (very high lymphocytosis), Plt 110K
Peripheral smear: > 80% small mature lymphocytes + smudge cells (typical CLL)
Flow cytometry: CD5+, CD19+, CD20+ (dim), CD23+, kappa light chain restricted; clonal B-cell — CLL phenotype
LDH 380, β2 microglobulin 4.8 (elevated), Coombs negative
IgG 580 (low — hypogammaglobulinemia)
FISH: del(17p) detected (high-risk), TP53 mutation positive (high-risk) — adverse cytogenetic
IGHV: unmutated (adverse)
No hyperleukocytosis symptoms, no AIHA, no ITP
Bone marrow: > 30% mature lymphocyte infiltration
Rai stage III (anemia), Binet stage C — symptomatic, treatment indication
No allogeneic donor identified'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 70 ปี underlying T2DM, HT, prior MI on ASA, atorvastatin มาด้วยอาการสับสนเริ่ม 4 ชม. + dyspnea + เป็นไข้ 38.6°C จากการสัมผัสกับหลานหลังโรงเรียน 

V/S: BP 132/82, HR 112, RR 22, SpO2 92% RA, Temp 38.6°C, GCS 14
PE: confused intermittent, mild dehydration, lung crackles bilateral, no JVP, no edema

Lab: WBC 8,400, Hb 11.4, Plt 188K, Cr 1.4 (baseline 1.0), Na 138, K 4.4, glucose 162, Lactate 1.8, procalcitonin 0.4
ABG: PaO2 64, PaCO2 32
Influenza rapid test: positive A
COVID PCR: negative
CXR: bilateral mild interstitial infiltrate (viral pneumonia pattern)
SARS-CoV-2 negative
Onset of illness: 6 hr ago
No penicillin allergy', '[{"label":"A","text":"Antipyretic + observation alone"},{"label":"B","text":"Influenza A infection in high-risk elderly with comorbidities (DM, prior MI) + mild pneumonia features — Management: (1) **Oseltamivir 75 mg PO BID × 5 days** — start ASAP within 48 hr ideal (most benefit), but consider beyond 48 hr in severe/hospitalized/high-risk (Cochrane: modest benefit in symptom duration; greater in severe + elderly + complications); dose adjusted for CKD (75 mg q24h if CrCl 30-60; q48h if < 30); inhaled zanamivir or IV peramivir alternatives; baloxavir (single dose oral) — emerging alternative; (2) Risk stratification: high-risk groups (age ≥ 65, pregnant + post-partum 2 wk, chronic medical conditions — DM, cardiac, pulmonary, renal, hepatic, neuro, hematologic, immune-compromised, BMI ≥ 40, residents of long-term care, age < 2) — treat regardless of timing; (3) Supportive: hydration, antipyretic acetaminophen, oxygen for hypoxia, address comorbid; (4) Watch for complications: bacterial pneumonia (post-influenza Strep pneumo + Staph aureus including MRSA — empirical antibiotic if clinical worsening + leukocytosis + new infiltrate + procalcitonin ↑; ceftriaxone + vancomycin/linezolid if MRSA risk), myocarditis, encephalitis, rhabdomyolysis, ARDS, MOF; (5) Isolation droplet precautions × 7 d from symptom onset (or 24 hr afebrile without antipyretic); (6) Post-exposure chemoprophylaxis with oseltamivir 75 mg/d × 7-10 d for high-risk close contacts (not vaccinated, immunocompromised); (7) Annual influenza vaccination — high-dose or adjuvanted preferred ≥ 65 yr; quadrivalent recombinant alternative; (8) Patient education on transmission, hand hygiene, respiratory etiquette, return precautions"},{"label":"C","text":"Ceftriaxone IV only without antiviral"},{"label":"D","text":"Steroid IV high-dose monotherapy"},{"label":"E","text":"Antiretroviral for HIV empiric"}]'::jsonb,
  'B', 'Seasonal influenza in high-risk elderly with comorbidity + mild pneumonia features. IDSA 2018 + WHO Influenza + CDC ACIP guideline: (1) Diagnosis: rapid antigen test (sensitivity 50-80%), molecular RT-PCR (gold standard, NAAT). NAAT preferred where available — higher sensitivity + distinguishes influenza A vs B + subtype. (2) Antiviral therapy: - **Oseltamivir** (Tamiflu) 75 mg PO BID × 5 d — most common; renal dose adjustment. - Zanamivir inhaled 10 mg BID × 5 d — avoid in asthma/COPD (bronchospasm). - Peramivir 600 mg IV × 1 — for hospitalized unable PO; less data. - Baloxavir marboxil 40-80 mg PO × 1 — single dose; CAPSTONE trials; emerging resistance concern, drug interaction with cation. - Initiate < 48 hr of symptom onset = greatest benefit (reduces duration by ~1 day in healthy; greater in severe + high-risk). - Treat beyond 48 hr in severe/hospitalized/high-risk + clinical benefit demonstrated. (3) Indications for antiviral (IDSA 2018): - Symptomatic with severe, complicated, progressive illness or hospitalized — any time. - High-risk outpatient (any duration ideal < 48 hr): - Age ≥ 65 or < 2. - Pregnant + 2 wk post-partum. - Chronic conditions (lung, cardio, renal, hepatic, neuro, metabolic, hematologic, immunocompromised). - BMI ≥ 40. - Residents of long-term care. - American Indian/Alaska Native. - Symptomatic, not high-risk, < 48 hr — discuss benefit/cost. (4) Resistance: M2 inhibitor (amantadine, rimantadine) — universal resistance to currently circulating; not used. Neuraminidase inhibitor resistance < 1% baseline. (5) Complications: - Bacterial pneumonia (post-influenza — Strep pneumo, Staph aureus inc MRSA, Strep pyogenes, H. influenzae): suspect with biphasic illness, worsening, new infiltrate, leukocytosis, procalcitonin rise; empirical antibiotic — ceftriaxone + azithromycin (Strep pneumo) ± vancomycin/linezolid if MRSA risk. - Cardiac: myocarditis, MI (post-influenza ↑ MI risk weeks). - CNS: encephalitis, encephalopathy. - Muscular: myositis, rhabdomyolysis. - Respiratory: ARDS, secondary bacterial pneumonia. (6) Supportive: hydration, antipyretic (acetaminophen; avoid ASA in children + adolescents — Reye syndrome), oxygen, monitor. (7) Infection control: droplet precaution × 7 d from onset (or 24 hr afebrile without antipyretic in immunocompetent); N95 for aerosol-generating procedures; chemoprophylaxis for high-risk close contacts unvaccinated or immunocompromised — oseltamivir 75 mg/d × 7-10 d post-exposure. (8) Prevention — annual vaccination: - Inactivated influenza vaccine (IIV4 quadrivalent) — most common. - **High-dose inactivated** (Fluzone HD): preferred ≥ 65 yr; improved efficacy in elderly. - Adjuvanted (Fluad): alternative ≥ 65 yr. - Recombinant (Flublok): egg-free; cell-based (Flucelvax). - Live attenuated (FluMist): 2-49 yr healthy, intranasal. - Pregnant: any inactivated vaccine, any trimester. - Egg allergy no longer contraindication (per CDC). (9) Other respiratory viruses (consider co-test): COVID-19, RSV (now adult ≥ 60 vaccinated; nirsevimab infant), human metapneumovirus, adenovirus.', NULL,
  'easy', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Clinical Practice Guidelines on Seasonal Influenza 2018; CDC ACIP Annual Influenza Recommendations; WHO Influenza Antivirals 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 70 ปี underlying T2DM, HT, prior MI on ASA, atorvastatin มาด้วยอาการสับสนเริ่ม 4 ชม. + dyspnea + เป็นไข้ 38.6°C จากการสัมผัสกับหลานหลังโรงเรียน 

V/S: BP 132/82, HR 112, RR 22, SpO2 92% RA, Temp 38.6°C, GCS 14
PE: confused intermittent, mild dehydration, lung crackles bilateral, no JVP, no edema

Lab: WBC 8,400, Hb 11.4, Plt 188K, Cr 1.4 (baseline 1.0), Na 138, K 4.4, glucose 162, Lactate 1.8, procalcitonin 0.4
ABG: PaO2 64, PaCO2 32
Influenza rapid test: positive A
COVID PCR: negative
CXR: bilateral mild interstitial infiltrate (viral pneumonia pattern)
SARS-CoV-2 negative
Onset of illness: 6 hr ago
No penicillin allergy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี alcoholic (heavy drinker 30 yr, abstinent 2 yr), HIV-negative, ไม่มีโรคประจำตัวอื่น มาด้วยอาการอ่อนเพลีย + skin pigmentation (slate-gray) + ปวดข้อ + impotence + glucose intolerance + cirrhosis suspected

V/S: BP 124/76, HR 78
PE: bronze pigmentation diffuse, hepatomegaly firm, no spider angioma, no ascites, no asterixis, joint MCP square swelling

Lab: Hb 13.8, Plt 184K, AST 86, ALT 92, ALP 110, Bili 1.2, Albumin 3.6
Ferritin 2,840 (very high), Transferrin saturation 96% (very high — > 45% suggests Fe overload)
Fasting glucose 168 (DM new); A1c 7.4%
LH/FSH low, testosterone low (hypogonadotropic from Fe in pituitary)
Fibroscan 16 kPa (F4)
Genetic testing: HFE gene C282Y homozygous → confirms hereditary hemochromatosis (type 1)
MRI liver T2*: severe iron overload R2-MRI
HbsAg negative, anti-HCV negative
Echo normal, EKG normal', '[{"label":"A","text":"Iron supplementation for symptom"},{"label":"B","text":"Hereditary hemochromatosis (HFE C282Y homozygous) with end-organ damage (cirrhosis, DM, hypogonadism, arthropathy) — AASLD 2019 + EASL 2010 hemochromatosis guideline: (1) **Therapeutic phlebotomy** = first-line: 500 mL whole blood (~ 200-250 mg iron) weekly initially; target serum ferritin 50-100 ng/mL + transferrin saturation < 50%; reduces hepatic iron, may stabilize/reverse fibrosis, normalizes glycemic control + cardiac function (in cardiomyopathy), pigmentation may fade; once iron normalized, maintenance phlebotomy every 2-4 months lifelong; (2) Iron chelation (deferasirox, deferoxamine, deferiprone) — reserved for those who cannot tolerate phlebotomy (CHF, severe cardiomyopathy with low output, anemia, intolerance); (3) Avoid iron supplementation + vitamin C high-dose (enhances absorption + iron release from ferritin); avoid raw shellfish (Vibrio vulnificus risk in Fe overload); avoid alcohol (synergistic hepatotoxicity); (4) HCC surveillance: cirrhosis = ultrasound + AFP every 6 mo lifelong; (5) Address organ damage: diabetes (insulin often needed; partial reversal with iron removal); hypogonadism (testosterone replacement consideration); cardiomyopathy management; osteoporosis screening + treatment; (6) Cardiac MRI T2* for cardiac iron + serial echo for cardiomyopathy; (7) **Family screening — first-degree relatives**: HFE genotype + iron studies; counsel + treat presymptomatic; (8) Other Fe overload causes: secondary (transfusional in thalassemia, MDS, chronic anemia), juvenile hemochromatosis (HJV, HAMP — severe, young), aceruloplasminemia, atransferrinemia, dietary; (9) Vaccinations: HBV (if susceptible — cirrhosis), HAV; pneumococcal"},{"label":"C","text":"Liver transplant immediately regardless of severity"},{"label":"D","text":"Antiviral therapy"},{"label":"E","text":"Diuretic alone for fluid management"}]'::jsonb,
  'B', 'Hereditary hemochromatosis (HH) — autosomal recessive iron overload; HFE gene mutations most common in Northern European descent; rarer in Asian populations but possible. Pathophysiology: hepcidin deficiency (HFE / TFR2 / HJV / HAMP / SLC40A1 mutations) → unregulated intestinal iron absorption + Fe deposition in liver, pancreas, heart, pituitary, joints, skin. AASLD 2019 + EASL 2010 + EurJ Haematology hemochromatosis guideline: (1) Diagnosis: - Elevated transferrin saturation > 45% (often > 80% in advanced). - Elevated ferritin (though non-specific; also elevated in inflammation, NAFLD, alcohol). - Confirmatory: HFE genotype (C282Y homozygous = classic Type 1; H63D + C282Y compound heterozygous mild; H63D homozygous mild). - Non-HFE in young + severe: HJV, HAMP, TFR2, SLC40A1 (ferroportin disease). - MRI T2* / R2-MRI for tissue iron quantification — non-invasive, replacing liver biopsy in most. - Liver biopsy: severe + atypical, HFE-negative, fibrosis assessment + iron quantification. (2) Classification stages: Stage 0 — genetic predisposition only; Stage 1 — biochemical iron overload (Fe biomarkers); Stage 2 — iron deposition without organ damage; Stage 3 — organ damage (cirrhosis, DM, cardiomyopathy, hypogonadism, arthropathy, pigmentation). (3) Treatment: - **Therapeutic phlebotomy** = first-line; remove 1 unit (500 mL ~ 200-250 mg Fe) weekly initial → target ferritin 50-100 + TSAT < 50%; maintenance q2-4 mo lifelong. - Iron chelation (deferasirox, deferoxamine, deferiprone): for CHF + cardiomyopathy + low CO + anemia + intolerance to phlebotomy. - Erythrocytapheresis: alternative; removes more iron per session. - Avoid iron supplements + high-dose vit C (enhances absorption + Fe release); alcohol (synergistic liver injury); raw shellfish (V. vulnificus risk). (4) End-organ management: - Cirrhosis: HCC surveillance (US + AFP q6 mo); decompensation management. - Diabetes ("bronze diabetes"): insulin often required; partial improvement with iron depletion. - Cardiac: monitor with echo, MRI T2*. - Hypogonadism: gonadal hormone replacement consideration (after Fe normalization may improve). - Arthropathy: NSAID, intra-articular steroid; bisphosphonate for osteoporosis. - Skin: pigmentation may fade. (5) Family screening — first-degree relatives ≥ 18 yr: HFE genotype + iron studies; counsel + monitor + treat presymptomatic. (6) Other Fe overload: secondary (transfusional in thalassemia, MDS, chronic anemia, SCD), juvenile hemochromatosis (HJV, HAMP — severe, young < 30 yr cardiac death), aceruloplasminemia, atransferrinemia, dietary (rare). (7) Genetic counseling for pregnancy planning. (8) Vaccinations: HBV if susceptible, HAV, pneumococcal, COVID. (9) Liver transplant: end-stage cirrhosis or HCC; outcomes good though slightly worse than other etiologies; iron depletion pre-transplant. A ผิด — opposite of needed. C ผิด — transplant only end-stage. D ผิด — no viral. E ผิด — diuretic for ascites if present, not primary.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Practice Guidance on the Diagnosis and Management of Hemochromatosis 2019; EASL Clinical Practice Guidelines on HFE Hemochromatosis 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 50 ปี alcoholic (heavy drinker 30 yr, abstinent 2 yr), HIV-negative, ไม่มีโรคประจำตัวอื่น มาด้วยอาการอ่อนเพลีย + skin pigmentation (slate-gray) + ปวดข้อ + impotence + glucose intolerance + cirrhosis suspected

V/S: BP 124/76, HR 78
PE: bronze pigmentation diffuse, hepatomegaly firm, no spider angioma, no ascites, no asterixis, joint MCP square swelling

Lab: Hb 13.8, Plt 184K, AST 86, ALT 92, ALP 110, Bili 1.2, Albumin 3.6
Ferritin 2,840 (very high), Transferrin saturation 96% (very high — > 45% suggests Fe overload)
Fasting glucose 168 (DM new); A1c 7.4%
LH/FSH low, testosterone low (hypogonadotropic from Fe in pituitary)
Fibroscan 16 kPa (F4)
Genetic testing: HFE gene C282Y homozygous → confirms hereditary hemochromatosis (type 1)
MRI liver T2*: severe iron overload R2-MRI
HbsAg negative, anti-HCV negative
Echo normal, EKG normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี underlying chronic alcoholic cirrhosis Child-Pugh B (MELD 14), ascites + esophageal varices known มา ED ด้วยอาการสับสน + พฤติกรรมเปลี่ยน + asterixis 2 วัน + ไม่ใช่ครั้งแรก ก่อนหน้านี้ถ่ายอุจจาระน้อย

V/S: BP 124/76, HR 92, RR 18, SpO2 96%, Temp 37.0°C, GCS 13 (E3V4M6)
PE: jaundice, asterixis bilateral, fetor hepaticus, ascites moderate (no signs of SBP — afebrile, no peritonitis), GI bleeding ruled out (no melena, NGT clear), spider angioma, palmar erythema

Lab: Hb 11.2, WBC 8,400, Plt 88K, Cr 1.0, Na 132, K 3.4, glucose 92, ALT 56, AST 88, ALP 140, Bili 3.4, Albumin 2.6, INR 1.6, ammonia 142 (high)
Urine: ketones negative
No benzo/opioid use
US abdomen: cirrhosis + moderate ascites, no thrombosis portal vein, no mass; paracentesis: PMN 80 (no SBP)', '[{"label":"A","text":"Stop all medications + observation only"},{"label":"B","text":"Hepatic encephalopathy (overt, West Haven Grade 2) in known cirrhosis — Identify + treat precipitant + reduce ammonia: (1) **Lactulose** (non-absorbable disaccharide) — first-line: 30-45 mL PO/NG q1-2h until ≥ 2-3 soft bowel movements per day, then titrate to maintain; mechanism: lowers colonic pH → traps NH4+ + cathartic + alters microbiome; can give via NGT in obtunded + rectal enema (300 mL in 700 mL water q4-6h) if no oral; (2) **Rifaximin** 550 mg PO BID added — non-absorbable antibiotic; reduces ammonia-producing gut flora; reduces recurrence (HORIZON; Bass NEJM 2010); especially helpful for prevention after first episode; (3) Identify + correct precipitants: - **GI bleeding** (rule out — endoscopy if suspected). - **Infection** (SBP, UTI, pneumonia — culture + empirical antibiotic). - **Electrolyte** (hypokalemia/alkalosis ↑ NH3; hyponatremia). - **Constipation**. - **Sedatives** (benzo, opioid). - **Dehydration** (excessive diuresis, paracentesis). - **Renal failure / azotemia**. - **Dietary protein excess** (moderate restriction ≤ 30 g, not severe — adequate protein needed). - **Portosystemic shunt** (TIPS). - **HCC**. (4) Supportive: airway protection if obtunded (GCS < 8 — intubation), aspiration precautions; IV fluid + electrolyte correction; nutrition (1.2-1.5 g/kg/d protein, avoid severe restriction); zinc supplement; (5) Avoid: benzodiazepine + opioid + over-diuresis + non-cardio-selective beta-blocker excess + nephrotoxic; (6) Refractory: - L-ornithine-L-aspartate (LOLA) — increases ureagenesis, ammonia scavenger. - Polyethylene glycol — alternative to lactulose (HELP trial). - Sodium benzoate, glycerol phenylbutyrate — ammonia scavengers. - Albumin infusion if hypoalbuminemic. - TIPS revision/embolization if portosystemic shunt source. - Liver transplant evaluation — strong indication; HE = decompensation marker, survival ↓; consider listing if recurrent + advancing; (7) Outpatient: lifelong lactulose + rifaximin combo for recurrence prevention; education + family (subtle signs); driving counseling (covert HE impairs cognitive — psychometric testing PHES, Stroop, animal naming); (8) Cirrhosis comprehensive: HCC surveillance, varices surveillance + primary/secondary prophylaxis (NSBB carvedilol/propranolol or band ligation), albumin for SBP/large-volume paracentesis, vaccinations, alcohol cessation lifelong, nutrition"},{"label":"C","text":"Branched-chain amino acid supplementation alone"},{"label":"D","text":"Severe protein restriction long-term"},{"label":"E","text":"Magnesium IV bolus alone"}]'::jsonb,
  'B', 'Hepatic encephalopathy (HE) — neuropsychiatric complication of liver failure; reversible with treatment. AASLD/EASL 2014 HE guideline + 2019 update: (1) Classification (West Haven): - Grade 0 (covert): minimal HE — subtle psychometric deficit only, needs testing. - Grade 1 (covert): trivial lack of awareness, euphoria, anxiety, attention. - Grade 2 (overt): lethargy, disorientation time, asterixis, personality change. - Grade 3 (overt): somnolence to semi-stupor, confusion, gross disorientation. - Grade 4 (overt): coma. (2) Type A (acute liver failure), B (portosystemic bypass), C (cirrhosis — most common). (3) Episodic, recurrent, persistent. (4) Diagnosis: clinical (asterixis, fetor, mental status); ammonia level supports but neither specific nor reliable alone (correlate with clinical); rule out alternative cause of altered mental status (sepsis, hypoglycemia, electrolyte, intracranial, drug); ABG (alkalosis ↑ ammonia). (5) Treatment: - **Treat precipitant** (most important — HE rarely spontaneous in stable cirrhosis): - GI bleed: endoscopy + treatment. - Infection (SBP, UTI, pneumonia): paracentesis + culture + empirical antibiotic. - Hypokalemia + alkalosis (↑ NH3 production + transport across BBB): correct. - Constipation: laxative. - Sedative use (benzo, opioid). - Dehydration / azotemia. - Dietary protein excess. - Portosystemic shunt (TIPS, surgical). - HCC. - Renal failure. - **Lactulose** 30-45 mL PO/NG q1-2h until 2-3 soft BMs/d then titrate; reduces colonic pH → traps NH4+; alters microbiome; rectal enema for unable to take PO; first-line. - **Rifaximin** 550 mg BID added (HORIZON, Bass NEJM 2010) — reduces recurrence; particularly effective after first overt episode for secondary prevention; expensive. - Other: L-ornithine-L-aspartate (LOLA), polyethylene glycol (HELP), sodium benzoate, glycerol phenylbutyrate, branched-chain AA; albumin infusion if hypoalbuminemic. - Zinc supplementation. - Probiotics (not standard). - FMT (emerging). - TIPS revision/embolization for shunt-related. (6) Nutrition: NOT severe protein restriction (worsens malnutrition); 1.2-1.5 g/kg/d adequate protein; vegetable + dairy protein source; small frequent meals + late evening snack (BCAA-enriched in some). (7) Airway protection: GCS < 8 — intubation; aspiration precautions. (8) Prevention: lactulose + rifaximin lifelong after first episode; education; recognize early signs; avoid precipitants; covert HE screening (PHES, EncephalApp Stroop, animal naming, ICT) — affects driving + work. (9) Liver transplant: HE = decompensation marker; survival decreased; refer for transplant evaluation; HE can resolve post-transplant. (10) Driving + cognitive impact: significant; counsel patient + family. (11) Comprehensive cirrhosis care: HCC surveillance, varices, ascites/SBP, nutrition, alcohol cessation, vaccinations.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD/EASL Practice Guideline on Hepatic Encephalopathy 2014 + 2019 update; Bass NM et al. NEJM 2010 (Rifaximin)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 60 ปี underlying chronic alcoholic cirrhosis Child-Pugh B (MELD 14), ascites + esophageal varices known มา ED ด้วยอาการสับสน + พฤติกรรมเปลี่ยน + asterixis 2 วัน + ไม่ใช่ครั้งแรก ก่อนหน้านี้ถ่ายอุจจาระน้อย

V/S: BP 124/76, HR 92, RR 18, SpO2 96%, Temp 37.0°C, GCS 13 (E3V4M6)
PE: jaundice, asterixis bilateral, fetor hepaticus, ascites moderate (no signs of SBP — afebrile, no peritonitis), GI bleeding ruled out (no melena, NGT clear), spider angioma, palmar erythema

Lab: Hb 11.2, WBC 8,400, Plt 88K, Cr 1.0, Na 132, K 3.4, glucose 92, ALT 56, AST 88, ALP 140, Bili 3.4, Albumin 2.6, INR 1.6, ammonia 142 (high)
Urine: ketones negative
No benzo/opioid use
US abdomen: cirrhosis + moderate ascites, no thrombosis portal vein, no mass; paracentesis: PMN 80 (no SBP)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 48 ปี ไม่มีโรคประจำตัว มาด้วยอาการกระวนกระวาย + tremor + พูดช้าลง + เดินช้า + brady-kinesia + อาการแย่ลง 2 ปี ระยะหลังเริ่ม freezing of gait + คนรอบข้างสังเกตเห็นเปลี่ยนพฤติกรรม

V/S: BP 124/76, HR 78, Temp 36.7°C
PE: pill-rolling resting tremor right > left arm, cogwheel rigidity, bradykinesia, mask facies, decreased arm swing right > left, stooped posture, no postural instability yet, normal cognition + memory, no oculomotor abnormality, no significant orthostasis, no cerebellar findings, no early autonomic, no early dementia

Lab: routine normal, B12 + RPR normal, thyroid normal
MRI brain: normal substantia nigra appearance (cannot distinguish PD vs MSA on routine MRI alone); rule out vascular + structural
DAT-SPECT (DaTscan, F-DOPA PET) if needed: shows reduced striatal dopamine uptake bilateral (asymmetric — confirms nigrostriatal dopaminergic deficit)
Response to levodopa trial: marked symptomatic improvement (supports IPD diagnosis vs atypical Parkinsonism)
No medication causing parkinsonism (no antipsychotic, no metoclopramide chronic)', '[{"label":"A","text":"Anticholinergic monotherapy benztropine"},{"label":"B","text":"Idiopathic Parkinson disease (clinical diagnosis supported by levodopa response + asymmetric onset + classic features + DAT scan if needed) — MDS criteria; MDS/EAN/AAN PD management: (1) Initial pharmacotherapy choice individualized by age, occupation, comorbidities, severity, patient preference: - **Levodopa + carbidopa** (Sinemet IR 25/100 mg TID titrate to QID or higher; controlled-release versions): MOST EFFECTIVE; first-line in older patients ≥ 65-70 + significant functional impairment; concerns of motor fluctuations + dyskinesia long-term (5-10 yr; lower risk lower dose, shorter duration). - **Dopamine agonist** (pramipexole, ropinirole, rotigotine patch): younger < 65-70 + mild-moderate; delays motor complications but: ↑ impulse control disorder (gambling, hypersexuality, compulsive eating/shopping — 17%), excessive daytime sleepiness, sudden onset sleep attacks (driving), edema, hallucination especially elderly. - **MAO-B inhibitor** (selegiline, rasagiline, safinamide): mild disease symptomatic + neuroprotective claim controversial (ADAGIO trial — unclear); adjunct for motor fluctuations. - **COMT inhibitor** (entacapone, tolcapone, opicapone) — extend levodopa half-life; used with levodopa for wearing-off; tolcapone hepatotoxicity. - **Amantadine** (NMDA antagonist) — for dyskinesia or tremor predominant. - **Anticholinergic** (trihexyphenidyl, benztropine) — rarely now; tremor predominant young; avoid elderly (cognitive). (2) Disease progression: - Wearing off: shorten interval, add COMT/MAO-B inhibitor, switch to extended-release, add agonist, infusion therapy (apomorphine pump, levodopa-carbidopa intestinal gel/duodopa). - Dyskinesia: reduce levodopa dose if possible, fractionate, amantadine, deep brain stimulation. - On-off phenomenon: rescue apomorphine, inhaled levodopa (Inbrija). (3) Advanced therapy: deep brain stimulation (DBS) of STN (subthalamic nucleus) or GPi (globus pallidus internus) — for motor fluctuations + dyskinesia + tremor refractory to medication; selected patient — preserved cognition, good Levodopa response, age < 70 (some). MR-guided FUS (focused ultrasound) thalamotomy for unilateral tremor. (4) Non-motor symptoms: - Constipation (very common, often precedes motor): polyethylene glycol, prucalopride, lubiprostone. - REM sleep behavior disorder (often pre-motor; melatonin, low-dose clonazepam). - Orthostasis: midodrine, droxidopa, fludrocortisone. - Urinary: mirabegron preferred over antimuscarinic (cognitive). - Depression/anxiety: SSRI (avoid TCA with autonomic), SNRI. - Cognitive: rivastigmine (FDA approved for PD dementia). - Psychosis: quetiapine (avoid risperidone, olanzapine, halo — worsen motor); pimavanserin (no D2 effect — safer). - Drooling: glycopyrrolate, botulinum toxin. - Sleep disorder. (5) Non-pharm: PT/OT/speech therapy (LSVT BIG + LOUD), exercise (aerobic + resistance), tai chi/yoga, deep brain stim, FUS; cardiac/safety (fall prevention); driving evaluation in advancing disease. (6) Differential atypical: MSA (early autonomic, cerebellar), PSP (early falls, vertical gaze palsy), CBD (asymmetric apraxia, alien limb), DLB (early dementia, visual hallucination, fluctuation, RBD), vascular parkinsonism (stepwise, lower-body, vascular MRI), drug-induced (antipsychotic, metoclopramide, valproate), normal pressure hydrocephalus (gait + cognition + urinary; LP test)"},{"label":"C","text":"Acetylcholinesterase inhibitor first-line"},{"label":"D","text":"Botulinum toxin only"},{"label":"E","text":"Watchful waiting indefinitely"}]'::jsonb,
  'B', 'Idiopathic Parkinson disease (PD) — neurodegenerative; nigrostriatal dopaminergic neuron loss + Lewy body (alpha-synuclein) pathology. MDS Clinical Diagnostic Criteria 2015: parkinsonism (bradykinesia + tremor or rigidity) + supportive features + absence of red flags. AAN + MDS + EAN PD guideline: (1) Diagnosis primarily clinical: - Cardinal: bradykinesia + rest tremor (4-6 Hz, pill-rolling, asymmetric) + rigidity (cogwheel) + postural instability (late). - Supportive: asymmetric onset, levodopa response, hyposmia, RBD. - Red flags for atypical: early falls, rapid progression, no levodopa response, early autonomic, early dementia, vertical gaze palsy, cerebellar, pyramidal, symmetric. - Imaging: MRI normal in IPD (rule out vascular, structural, NPH); DAT-SPECT (Datscan) or F-DOPA PET — shows nigrostriatal deficit (does not distinguish IPD vs atypical PD; distinguishes from essential tremor, drug-induced, psychogenic). - Levodopa challenge: ≥ 30% improvement supports IPD vs atypical. - α-synuclein RT-QuIC (CSF or skin biopsy) — emerging biomarker. (2) Initial pharmacotherapy: - Levodopa + carbidopa: most effective; in elderly + significant disability; ≥ 70 yr. - Dopamine agonist (pramipexole, ropinirole, rotigotine): younger patients to delay motor complications; risk impulse control, sleep attacks, hallucination. - MAO-B inhibitor (rasagiline, selegiline, safinamide): mild disease, adjunct. - LEAP, PD MED trial: levodopa upfront in elderly better QoL than delayed strategy. (3) Advanced motor fluctuations + dyskinesia: - Wearing off: COMT inhibitor (entacapone, opicapone, tolcapone), MAO-B, extended-release levodopa, fractionate. - Dyskinesia: amantadine, lower dose more frequent, DBS. - On-off, freezing: apomorphine SC rescue, inhaled levodopa, DBS. - DBS (STN or GPi): selected — preserved cognition, good levodopa response, age < 70 typically; ↑ QoL motor; cognitive + mood side effects in some. - Levodopa-carbidopa intestinal gel (LCIG / Duopa via PEG-J): continuous infusion for advanced. - Subcutaneous apomorphine pump. - MR-guided FUS thalamotomy for unilateral tremor. (4) Non-motor: - Constipation (very common, may precede motor): PEG, prucalopride. - RBD: melatonin, low-dose clonazepam. - Orthostatic hypotension: midodrine, droxidopa, fludrocortisone. - Urinary urgency: mirabegron (avoid antimuscarinic — cognitive). - Sialorrhea: glycopyrrolate, botulinum. - Depression/anxiety: SSRI, SNRI, mirtazapine. - Cognitive impairment / PD dementia: rivastigmine (FDA approved), donepezil. - Psychosis (visual hallucination, paranoia): pimavanserin (selective 5HT2A, no D2 effect — preferred); quetiapine (low D2); avoid risperidone, olanzapine, typical antipsychotic (worsens motor). - Sleep: trazodone, CPAP for OSA, melatonin. (5) Non-pharm: PT (LSVT BIG), OT, speech (LSVT LOUD), exercise (aerobic + resistance + tai chi + dance), nutrition, mental health, social, caregiver. (6) Atypical (red flags): MSA (autonomic, cerebellar, parkinsonism; MSA-P/MSA-C), PSP (vertical gaze palsy, early falls, axial rigidity), CBD (apraxia, alien limb), DLB (visual hallucination, fluctuation, RBD, dementia early). (7) Drug-induced parkinsonism: antipsychotic (typical, atypical risperidone, olanzapine), metoclopramide, valproate, calcium channel blocker (flunarizine); reversible after withdrawal (months). (8) Pre-motor PD: hyposmia, RBD, constipation, depression — research area for early intervention.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'MDS Clinical Diagnostic Criteria for Parkinson Disease 2015; AAN Practice Guideline on Initial Pharmacological Therapy in PD 2021; MDS Evidence-Based Medicine Review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 48 ปี ไม่มีโรคประจำตัว มาด้วยอาการกระวนกระวาย + tremor + พูดช้าลง + เดินช้า + brady-kinesia + อาการแย่ลง 2 ปี ระยะหลังเริ่ม freezing of gait + คนรอบข้างสังเกตเห็นเปลี่ยนพฤติกรรม

V/S: BP 124/76, HR 78, Temp 36.7°C
PE: pill-rolling resting tremor right > left arm, cogwheel rigidity, bradykinesia, mask facies, decreased arm swing right > left, stooped posture, no postural instability yet, normal cognition + memory, no oculomotor abnormality, no significant orthostasis, no cerebellar findings, no early autonomic, no early dementia

Lab: routine normal, B12 + RPR normal, thyroid normal
MRI brain: normal substantia nigra appearance (cannot distinguish PD vs MSA on routine MRI alone); rule out vascular + structural
DAT-SPECT (DaTscan, F-DOPA PET) if needed: shows reduced striatal dopamine uptake bilateral (asymmetric — confirms nigrostriatal dopaminergic deficit)
Response to levodopa trial: marked symptomatic improvement (supports IPD diagnosis vs atypical Parkinsonism)
No medication causing parkinsonism (no antipsychotic, no metoclopramide chronic)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัวเดิม เพิ่งคลอดบุตรปกติ 5 วันก่อน มาด้วย dyspnea + cough + pink frothy sputum + เหนื่อย rapidly progressive 12 ชม. หลังคลอด

V/S: BP 102/64, HR 124, RR 32, SpO2 84% RA → 92% on NRB, Temp 37.0°C
PE: bibasilar crackles + S3 gallop + JVP elevated + mild lower limb edema; lung diffuse crackles; cardiomegaly

Lab: BNP 4,200 (very high), Troponin 0.18 (mildly elevated), Cr 1.0, lactate 2.4
EKG: sinus tach 124, no ST elevation, lateral T inversion
CXR: bilateral alveolar infiltrate + cardiomegaly
Echo: LVEF 28% (severely reduced), global hypokinesis, dilated LV, no thrombus visualized, no valve disease, no pericardial effusion
Coronary angio (later): normal coronaries
No prior cardiac history, healthy pre-pregnancy
CBC normal, no infection, no PE on CTPA', '[{"label":"A","text":"Defer treatment until breast-feeding completed"},{"label":"B","text":"Peripartum cardiomyopathy (PPCM) — newly diagnosed within last month of pregnancy or 5 mo postpartum, LVEF < 45% without other identifiable cause — ESC + AHA + Heart Failure Society of America PPCM guideline: (1) Acute decompensated HF management: IV diuretic (furosemide) for congestion; IV nitroglycerin for afterload reduction; oxygen + NIV/intubation if severe respiratory failure; pressors for cardiogenic shock (dobutamine, norepinephrine carefully); IABP or VA-ECMO for refractory shock; cardiac transplant evaluation if severe + persistent; (2) Guideline-directed medical therapy (modified for postpartum + breastfeeding): - **ACEi / ARB** — START postpartum; safe in breastfeeding (enalapril, captopril shorter half-life preferred); contraindicated during pregnancy (teratogenic). - **Beta-blocker** (carvedilol, metoprolol succinate) — start postpartum; carvedilol preferred (negative chronotropy + anti-remodel); titrate to maximum tolerated. - **Mineralocorticoid receptor antagonist** (spironolactone) — postpartum; not in pregnancy. - **SGLT2 inhibitor** (dapagliflozin, empagliflozin) — emerging for HFrEF; postpartum + non-breastfeeding (limited safety data breast milk); use as indicated. - **Hydralazine + nitrate** — alternative for pregnant patient or instead of ACEi when breastfeeding concern. - **Sacubitril/valsartan** — after stabilization on ACEi; not in pregnancy. (3) **Bromocriptine** (dopamine agonist, prolactin suppression) — emerging therapy per German PPCM Registry + IPAC + IROC studies; suppresses cleaved prolactin (16 kDa) implicated in pathogenesis; 2.5 mg BID × 1 week then daily × 6 weeks; combined with HF therapy improved LVEF recovery + reduced morbidity/mortality. Requires breast-feeding cessation. (4) **Anticoagulation**: peripartum CM = highly thrombogenic state (pregnancy + low EF + atrial enlargement + bromocriptine — synergistic); LMWH or DOAC postpartum; warfarin if breast-feeding-compatible; anticoagulate at least until LVEF improves to ≥ 35% (ESC). (5) **ICD/wearable cardioverter-defibrillator** (LifeVest) considered while awaiting recovery (50% recover within 6-12 mo). (6) Counsel future pregnancy: high recurrence risk (30-50% if LVEF not normalized); counsel contraception; risk + benefit; avoid combined OCP (estrogen + thrombotic risk in low EF); progestin-only or IUD. (7) Recovery monitoring: serial echo q3-6 mo until recovery or 1 yr; many recover to normal LVEF within 6-12 mo. (8) Mechanical support / heart transplant: refractory + non-recovering with end-stage HF; outcomes good. (9) Multidisciplinary: cardiology + cardio-obstetric + OB + neonatology"},{"label":"C","text":"Inotrope alone without HF guidelines therapy"},{"label":"D","text":"Long-term high-dose steroid"},{"label":"E","text":"Coronary stent placement for occult ischemia"}]'::jsonb,
  'B', 'Peripartum cardiomyopathy (PPCM) — uncommon but serious cause of HFrEF in pregnancy/postpartum. Definition (ESC 2010): idiopathic cardiomyopathy with new-onset systolic dysfunction (LVEF < 45%) presenting last month of pregnancy or first 5 mo postpartum, without other identifiable cause. Pathophysiology: oxidative stress + cleaved 16-kDa prolactin + sFlt-1 + cathepsin D + genetic predisposition (TTN, MYH7, others). ESC 2018 cardiovascular in pregnancy + AHA + IRoC + ESC PPCM 2019 guideline: (1) Risk factors: African ancestry, age > 30, multiparity, multifetal gestation, preeclampsia + HT, advanced maternal age, nutritional deficit, prolonged tocolysis, ethnicity (Haiti, Nigeria, South Africa, parts of US). (2) Diagnosis: clinical HF + echo (LVEF < 45%) + exclude alternative (PE, MI, sepsis, pre-existing CM, severe HT, valvular). (3) Acute management: - IV diuretic for congestion (furosemide). - Vasodilator (nitroglycerin) for afterload reduction. - Oxygen, NIV, intubation as needed. - Inotrope (dobutamine) for low CO + shock. - Vasopressor (norepi) for hypotension + shock. - Advanced MCS: IABP, VA-ECMO, LVAD/RVAD; cardiac transplant evaluation. (4) GDMT for HFrEF (modified for pregnancy/postpartum/breastfeeding): - **ACEi / ARB**: safe postpartum + breastfeeding (enalapril, captopril); CONTRAINDICATED in pregnancy. - **Beta-blocker** (carvedilol — preferred, also alpha block; metoprolol succinate): both pregnancy + postpartum + breastfeeding generally safe. - **Spironolactone**: postpartum; not in pregnancy (teratogen risk, antiandrogen). - **SGLT2 inhibitor** (dapagliflozin, empagliflozin): HFrEF benefit; postpartum non-breastfeeding (insufficient breast milk data). - **Sacubitril-valsartan**: after stabilization; not in pregnancy. - **Hydralazine + isosorbide dinitrate**: alternative in pregnancy or breastfeeding ACEi concern. (5) **Bromocriptine** (dopamine agonist suppressing prolactin) — promising therapy: 2.5 mg BID × 1 wk → 2.5 mg daily × 6 wk; German PPCM registry + IPAC + IROC trials suggest improved LVEF recovery + reduced morbidity/mortality; mechanism: suppresses cleaved 16-kDa prolactin pathogen; ESC 2019 supports use; needs breastfeeding cessation; consider in moderate-severe LV dysfunction or no recovery 1-2 wk; balance against thromboembolic risk (anticoagulate). (6) **Anticoagulation**: prophylactic LMWH postpartum at least until LV recovery; pregnancy = LMWH preferred (no warfarin 1st trimester); thrombus identified → therapeutic anticoagulation. (7) **ICD/CRT consideration**: LVEF persistently < 35% > 3-6 mo despite optimal GDMT; wearable defibrillator (LifeVest) during recovery window. (8) **Cardiac recovery**: 50-80% recover LVEF to > 50% within 6-12 mo; better recovery if presenting LVEF ≥ 30%; serial echo q3-6 mo. (9) **Future pregnancy counseling**: high recurrence risk (30-50% with non-recovered LVEF); 10-20% even with normalized; counsel against if not recovered; reliable contraception (avoid combined OCP — estrogen thrombotic risk in low EF; progestin-only or IUD). (10) **Multidisciplinary**: cardio-obstetric + cardiology + OB + NICU + maternal-fetal med. (11) **Maternal mortality**: 5-15%; depending on severity + access to care + recovery. (12) **Differential**: tachy-cardiomyopathy (AF/SVT during pregnancy), familial DCM unmasked, ischemic (SCAD in pregnancy), hypertensive (preeclampsia/eclampsia), HCM unmasked, viral myocarditis, peripartum amniotic fluid embolism.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC Guidelines on Cardiovascular Diseases during Pregnancy 2018; HFSA + ESC PPCM Position Statement 2019; IPAC Trial 2015; Bromocriptine Trial JACC 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัวเดิม เพิ่งคลอดบุตรปกติ 5 วันก่อน มาด้วย dyspnea + cough + pink frothy sputum + เหนื่อย rapidly progressive 12 ชม. หลังคลอด

V/S: BP 102/64, HR 124, RR 32, SpO2 84% RA → 92% on NRB, Temp 37.0°C
PE: bibasilar crackles + S3 gallop + JVP elevated + mild lower limb edema; lung diffuse crackles; cardiomegaly

Lab: BNP 4,200 (very high), Troponin 0.18 (mildly elevated), Cr 1.0, lactate 2.4
EKG: sinus tach 124, no ST elevation, lateral T inversion
CXR: bilateral alveolar infiltrate + cardiomegaly
Echo: LVEF 28% (severely reduced), global hypokinesis, dilated LV, no thrombus visualized, no valve disease, no pericardial effusion
Coronary angio (later): normal coronaries
No prior cardiac history, healthy pre-pregnancy
CBC normal, no infection, no PE on CTPA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี underlying HT มา ED ด้วย BP 222/128 พบเฉยๆ ตอน routine check; ไม่มี symptom (no headache, no chest pain, no neuro deficit, no visual change, no dyspnea); recently missed medication 1 wk

V/S: BP 222/128, HR 84, RR 16, SpO2 98%
PE: no focal neuro, no papilledema, lungs clear, no S3, no edema

Lab: Cr 1.0 baseline, no rise; UA: trace protein, no blood; EKG: LVH, no acute change; CXR: no congestion; troponin neg', '[{"label":"A","text":"Sublingual nifedipine for rapid BP drop"},{"label":"B","text":"IV labetalol drip with target SBP < 140 within 1 hr"},{"label":"C","text":"Hypertensive urgency (severe HT without acute end-organ damage) — restart/resume home antihypertensive (or adjust), oral agents (amlodipine, ACEi/ARB, beta-blocker, diuretic combination), lower BP gradually over 24-48 hr to < 160/100 then to target; outpatient follow-up 1-7 days; avoid IV agents + aggressive lowering (no benefit, risk ischemic complications); address adherence, identify secondary HT screen if young/refractory; lifestyle counseling"},{"label":"D","text":"Admit ICU + IV nitroprusside"},{"label":"E","text":"Discharge without medication adjustment"}]'::jsonb,
  'C', 'Hypertensive urgency = severe HT (SBP > 180 or DBP > 120) WITHOUT acute end-organ damage. Hypertensive emergency = same BP + end-organ damage (acute kidney injury, encephalopathy, retinopathy with papilledema, ACS, pulmonary edema, aortic dissection, eclampsia, intracranial bleed). ACC/AHA 2017 + JNC HT guideline: (1) Urgency: oral antihypertensive, gradual lowering over hours-days, target < 160/100 then to goal over weeks; outpatient management. (2) Avoid sublingual nifedipine (uncontrolled rapid drop → ischemic stroke/MI). (3) IV agents only for true emergency. (4) Address adherence, identify white-coat, secondary HT (Conn, pheo, OSA, renovascular). (5) Resume home regimen + reassess; outpatient follow-up.', NULL,
  'easy', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA 2017 Guideline on High Blood Pressure; ESC/ESH 2018 HT Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 65 ปี underlying HT มา ED ด้วย BP 222/128 พบเฉยๆ ตอน routine check; ไม่มี symptom (no headache, no chest pain, no neuro deficit, no visual change, no dyspnea); recently missed medication 1 wk

V/S: BP 222/128, HR 84, RR 16, SpO2 98%
PE: no focal neuro, no papilledema, lungs clear, no S3, no edema

Lab: Cr 1.0 baseline, no rise; UA: trace protein, no blood; EKG: LVH, no acute change; CXR: no congestion; troponin neg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 25 ปี ไม่มีโรค มา ED ด้วยใจสั่น + วิงเวียน 2 ชม. ไม่มี syncope

V/S: BP 118/76, HR 168 regular narrow QRS, RR 18, SpO2 98%
EKG: regular narrow complex tachycardia ~ 170, P waves not clearly visible (retrograde or buried), QRS narrow, ST/T normal
No prior history, no medications, no thyroid hx', '[{"label":"A","text":"DC cardioversion ทันที"},{"label":"B","text":"Stable SVX (likely AVNRT) — (1) Vagal maneuver: Valsalva (modified REVERT — supine + leg raise), carotid sinus massage (auscultate bruit first; avoid in elderly + carotid disease); (2) IV adenosine 6 mg rapid push + 20 mL saline flush via large vein → 12 mg if no response → 12 mg; warn re flushing + chest pain + brief asystole; (3) If unresponsive: IV diltiazem or verapamil (avoid in suspected pre-excitation/WPW) OR IV beta-blocker; (4) Long-term EP study + ablation for recurrent or symptomatic (catheter ablation curative ~95% AVNRT); (5) Avoid AV-blockers in pre-excited AF (WPW with AF — wide irregular tachy = procainamide or DC cardioversion)"},{"label":"C","text":"Amiodarone IV bolus first-line"},{"label":"D","text":"Digoxin loading dose"},{"label":"E","text":"Heparin anticoagulation"}]'::jsonb,
  'B', 'Paroxysmal supraventricular tachycardia (PSVT) — AVNRT most common (60%), AVRT (WPW), atrial tachycardia. ACC/AHA/HRS 2015 + ESC 2019 SVT guideline: (1) Stable: vagal maneuver (modified Valsalva REVERT trial higher success), adenosine 6→12→12 mg; (2) Refractory stable: IV CCB (diltiazem, verapamil — avoid in pre-excitation), beta-blocker; (3) Unstable: synchronized DC cardioversion; (4) Long-term: catheter ablation curative ~95% AVNRT, AVRT; medical (BB, CCB) alternative; (5) WPW + AF (wide irregular): procainamide or DC cardioversion; AVOID AV-blockers (can paradoxically increase ventricular rate via accessory pathway → VF).', NULL,
  'easy', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA/HRS 2015 SVT Guideline; ESC 2019 SVT Guidelines; REVERT Trial Lancet 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 25 ปี ไม่มีโรค มา ED ด้วยใจสั่น + วิงเวียน 2 ชม. ไม่มี syncope

V/S: BP 118/76, HR 168 regular narrow QRS, RR 18, SpO2 98%
EKG: regular narrow complex tachycardia ~ 170, P waves not clearly visible (retrograde or buried), QRS narrow, ST/T normal
No prior history, no medications, no thyroid hx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี underlying alcohol use มา ED ด้วยอ่อนเพลีย + ขาบวม + คลื่นไส้ + ปวดข้อ + ลิ้นแสบ

Lab: Hb 8.4 macrocytic MCV 112, MCH 36, reticulocyte 1.2% (low), WBC 4,200, Plt 130K, smear hypersegmented neutrophil + macrocytes
Folate < 2 (low), B12 380 (normal — rule out B12 deficiency), homocysteine elevated, MMA normal (B12 OK)
LDH 480, indirect bilirubin 1.6
Alcohol use 200 g/day, poor diet', '[{"label":"A","text":"B12 IM + iron supplementation"},{"label":"B","text":"Folate deficiency (megaloblastic anemia) from alcohol + poor intake — (1) Oral folic acid 1-5 mg/d × 1-4 mo until normalized + ongoing maintenance; (2) Always check B12 BEFORE folate replacement (folate alone in B12 deficient = neurologic worsening); (3) Address alcohol use disorder — abstinence + nutrition counseling + thiamine + B-complex; (4) Investigate other deficiencies (iron, B12, zinc); (5) Address comorbidities (cirrhosis if present, pancreatitis); reticulocytosis at 5-10 d + Hb normalization 4-8 wk"},{"label":"C","text":"Bone marrow biopsy first"},{"label":"D","text":"Erythropoietin therapy"},{"label":"E","text":"Blood transfusion + corticosteroid"}]'::jsonb,
  'B', 'Folate deficiency — alcohol + poor nutrition common cause; pregnancy/lactation, hemolysis, drugs (MTX, phenytoin, sulfa, TMP), celiac. Distinguish from B12: MMA elevated only in B12 deficiency; homocysteine elevated in both. Replace with oral folic acid 1-5 mg/d. Always confirm B12 not deficient first (folate alone in B12 def = neurologic deterioration despite hematologic improvement). Address underlying cause. Reticulocytosis day 5-10 confirms response.', NULL,
  'easy', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'BSH Cobalamin and Folate Deficiency Guideline 2014; Antony AC — Folate', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี underlying alcohol use มา ED ด้วยอ่อนเพลีย + ขาบวม + คลื่นไส้ + ปวดข้อ + ลิ้นแสบ

Lab: Hb 8.4 macrocytic MCV 112, MCH 36, reticulocyte 1.2% (low), WBC 4,200, Plt 130K, smear hypersegmented neutrophil + macrocytes
Folate < 2 (low), B12 380 (normal — rule out B12 deficiency), homocysteine elevated, MMA normal (B12 OK)
LDH 480, indirect bilirubin 1.6
Alcohol use 200 g/day, poor diet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย + jaundice + ปัสสาวะสีโคล่า 1 สัปดาห์ + เพิ่งได้ ceftriaxone 7 d สำหรับ pneumonia

Lab: Hb 7.4 (normocytic), MCV 92, reticulocyte 12%, smear: spherocytes + polychromasia, no schistocytes
Indirect bilirubin 5.4, LDH 1,820, haptoglobin < 10 (consumed)
DAT/Coombs positive IgG + C3, monospecific IgG strong (warm AIHA pattern)
Cold agglutinin titer low
ANA negative, no SLE features, viral hepatitis negative', '[{"label":"A","text":"Continue ceftriaxone + observe"},{"label":"B","text":"Warm autoimmune hemolytic anemia (AIHA) — possibly drug-induced (ceftriaxone — implicated DDAIHA) — (1) Stop suspected drug (ceftriaxone); (2) Prednisolone 1 mg/kg/d × 3-4 wk then slow taper over months — first-line; 75% respond; (3) Folic acid supplement (high RBC turnover); (4) Transfusion for life-threatening anemia (use least-incompatible PRC; coordinate with blood bank); (5) Refractory: rituximab (preferred 2nd-line per ASH 2019), splenectomy (delayed at least 1 yr), immunosuppressive (azathioprine, mycophenolate, cyclophosphamide); (6) Newer: fostamatinib (SYK inhibitor — FDA for warm AIHA refractory), sutimlimab (anti-C1s — cold AIHA), complement inhibitors; (7) VTE prophylaxis (AIHA = ↑ thrombosis); (8) Vaccinations pre-immunosuppression; investigate secondary cause (lymphoma, SLE, HIV, drug)"},{"label":"C","text":"Splenectomy first-line"},{"label":"D","text":"Plasma exchange"},{"label":"E","text":"Heparin anticoagulation"}]'::jsonb,
  'B', 'Warm autoimmune hemolytic anemia — IgG ± C3 on RBC (DAT+), spherocytes, ↑ retic, ↑ indirect bili, ↑ LDH, ↓ haptoglobin. Causes: primary idiopathic; secondary — lymphoproliferative (CLL, lymphoma), SLE, drug (penicillin, ceftriaxone, methyldopa, fludarabine, checkpoint inhibitor), HIV. ASH 2019 + BSH AIHA guideline: (1) Stop offending drug; (2) Prednisolone 1 mg/kg/d × 3-4 wk taper; (3) Rituximab preferred 2nd-line (BSH); (4) Splenectomy after ≥ 1 yr trial of medical; (5) Immunosuppression in refractory (AZA, MMF, CYC, fostamatinib); (6) Sutimlimab for cold AIHA (CAD); (7) Transfusion: least-incompatible; (8) Investigate underlying. Cold AIHA: IgM, C3 only on DAT, RBC agglutination, Raynaud, mycoplasma/EBV — treat differently (rituximab + sutimlimab; avoid splenectomy ineffective; warm patient).', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ASH 2019 Guideline AIHA; BSH AIHA Guideline 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย + jaundice + ปัสสาวะสีโคล่า 1 สัปดาห์ + เพิ่งได้ ceftriaxone 7 d สำหรับ pneumonia

Lab: Hb 7.4 (normocytic), MCV 92, reticulocyte 12%, smear: spherocytes + polychromasia, no schistocytes
Indirect bilirubin 5.4, LDH 1,820, haptoglobin < 10 (consumed)
DAT/Coombs positive IgG + C3, monospecific IgG strong (warm AIHA pattern)
Cold agglutinin titer low
ANA negative, no SLE features, viral hepatitis negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี ไม่มีโรค พบ incidentally Hb 19, Hct 58, WBC 12K, Plt 580K from CBC routine check + พบ facial flushing + pruritus หลังอาบน้ำร้อน + splenomegaly mild + history of DVT 2 ปีก่อน

Lab: Hb 19, Hct 58 (M > 49% diagnostic threshold lowered 2016 WHO), WBC 12K (mild), Plt 580K, EPO low, JAK2 V617F mutation positive
O2 sat normal 98%, no smoking, no chronic lung disease, no cardiac source, no high altitude
Bone marrow biopsy: hypercellular, panmyelosis with megakaryocyte clustering — consistent with PV
No myelodysplasia, no fibrosis significant', '[{"label":"A","text":"Anticoagulation alone"},{"label":"B","text":"Polycythemia Vera (PV, JAK2 mutated) with prior thrombosis (high-risk) — WHO 2022 + NCCN: (1) **Phlebotomy** to maintain Hct < 45% (CYTO-PV trial — reduces thrombosis); aggressive initially (q 2-3 d) then maintenance q 2-3 mo; (2) **Low-dose aspirin** 81 mg/d — reduces thrombosis (ECLAP); not for prior major bleed; (3) **Cytoreductive therapy** for high-risk (age > 60 or prior thrombosis): **hydroxyurea** 500-1000 mg/d titrate; alternative IFN-α (pegylated; younger, pregnancy, intolerance); ropeginterferon (PROUD-PV — recent); (4) **Ruxolitinib** (JAK1/2 inhibitor): for HU-resistant/intolerant (RESPONSE trial); (5) Address symptoms: aquagenic pruritus (antihistamine, SSRI paroxetine, JAK inhibitor); erythromelalgia (aspirin); microvascular (aspirin); (6) Monitor for progression: myelofibrosis (10-20% / 10 yr), AML transformation (5-10% / 20 yr); (7) Anticoagulation if active thrombosis or AF; (8) Treat cardiovascular risk; (9) Vaccinations"},{"label":"C","text":"Bone marrow transplant immediately"},{"label":"D","text":"Watchful waiting indefinitely"},{"label":"E","text":"Iron supplementation"}]'::jsonb,
  'B', 'Polycythemia vera (PV) — myeloproliferative neoplasm; JAK2 V617F (96%) or JAK2 exon 12 mutations. WHO 2022 + NCCN + ELN guidelines: (1) Diagnosis: Hb > 16.5 M / > 16 F (or Hct > 49 M / > 48 F) + JAK2 mutation + low EPO + bone marrow showing hypercellularity. (2) Risk stratification: high-risk (age > 60 OR prior thrombosis) vs low-risk. (3) Treatment all: phlebotomy to Hct < 45 + low-dose aspirin (ECLAP, CYTO-PV trials). (4) Cytoreduction for high-risk: hydroxyurea or pegylated IFN-α (PROUD-PV — ropeginterferon alfa-2b approved). (5) HU-resistant/intolerant: ruxolitinib (RESPONSE — efficacy in symptoms, hematocrit control, spleen). (6) Pruritus: H1+H2 blocker, SSRI (paroxetine), ruxolitinib. (7) Pregnancy: aspirin + LMWH + phlebotomy + IFN-α. (8) Monitor for myelofibrosis (10-20%), AML (5%, higher with HU long-term). (9) Surveillance CBC, JAK2 allele burden, symptom assessment. (10) Differential erythrocytosis: secondary (smoking, COPD, OSA, high altitude, cardiac shunt, renal/hepatic tumor producing EPO, exogenous testosterone), congenital (high oxygen affinity Hb), Chuvash polycythemia.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'WHO Classification of Myeloid Neoplasms 2022; NCCN MPN Guideline 2024; CYTO-PV NEJM 2013; RESPONSE NEJM 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรค พบ incidentally Hb 19, Hct 58, WBC 12K, Plt 580K from CBC routine check + พบ facial flushing + pruritus หลังอาบน้ำร้อน + splenomegaly mild + history of DVT 2 ปีก่อน

Lab: Hb 19, Hct 58 (M > 49% diagnostic threshold lowered 2016 WHO), WBC 12K (mild), Plt 580K, EPO low, JAK2 V617F mutation positive
O2 sat normal 98%, no smoking, no chronic lung disease, no cardiac source, no high altitude
Bone marrow biopsy: hypercellular, panmyelosis with megakaryocyte clustering — consistent with PV
No myelodysplasia, no fibrosis significant'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ไม่มีโรค มา ED ด้วยอาการแขนซ้ายชา + อ่อนแรง + พูดไม่ชัด onset 2 ชม. resolved spontaneously 30 นาที before arrival; ก่อนหน้านี้ปกติ

V/S: BP 142/86, HR 78, no AF on telemetry
Neuro: now back to baseline; ABCD2 score = 5 (high risk)
MRI brain DWI: small acute infarct left MCA territory cortical → confirms ischemic stroke (transient symptoms but radiographic infarct = stroke not TIA per recent definition)
Carotid Doppler: 80% stenosis left ICA + atheromatous plaque (symptomatic side)
Lab: lipid panel TC 280 LDL 192, A1c 5.6%, normal CBC + coag', '[{"label":"A","text":"Aspirin alone + outpatient follow-up"},{"label":"B","text":"Symptomatic carotid stenosis 70-99% with recent stroke — Carotid endarterectomy (CEA) within 14 days (NASCET — 50% RRR stroke at 2 yr in 70-99% stenosis) OR carotid artery stenting (CAS) selected (high-surgical-risk, neck irradiation, restenosis post-CEA); MORE BENEFIT EARLY (within 2 wk) — TIA/stroke + > 50% (symptomatic) with low surgical risk → revascularize; concurrent: dual antiplatelet (CHANCE/POINT short-term 21 d ASA + clopidogrel for minor stroke/TIA) then ASA mono; high-intensity statin (atorvastatin 80 mg, target LDL < 70); BP control < 130/80 ACEi; glycemic; smoking; lifestyle; investigate other stroke sources (AF on telemetry/Holter, echo for cardiac source, hypercoagulable young, PFO in young, vasculitis, dissection)"},{"label":"C","text":"Long-term warfarin anticoagulation"},{"label":"D","text":"Asymptomatic carotid screening only"},{"label":"E","text":"Defer intervention indefinitely"}]'::jsonb,
  'B', 'Symptomatic carotid stenosis with recent stroke. AHA/ASA 2021 Secondary Stroke Prevention + SVS guideline: (1) Workup TIA/stroke: imaging (MRI/CT), carotid Doppler (or CTA/MRA), echo, telemetry/Holter (AF), labs (lipid, glucose, coag, hypercoag young). (2) Indication for revascularization (symptomatic — TIA or stroke + carotid stenosis): - 70-99%: CEA strongly indicated (NASCET — 50% RRR over medical therapy); 50-69%: moderate benefit (NASCET). - Asymptomatic 60-99%: less clear benefit; CEA may help in selected (ACAS, ACST) — recent trials suggest medical therapy may be equivalent (SPACE-2). (3) Timing: within 2 wk of event for max benefit (RR-best within 14 d; less after that). (4) CEA preferred over CAS for most (CREST — CEA lower stroke, CAS lower MI; ICSS — CEA better at long-term). CAS for high surgical risk, restenosis, radiation neck, anatomical access difficulty. (5) Medical: high-intensity statin (LDL target < 70 or even < 55 ESC), DAPT short-term (ASA + clopidogrel 21 d per CHANCE/POINT for minor stroke/TIA), BP control (ACEi/ARB), glycemic, smoking, lifestyle. (6) Stroke etiology workup: cardioembolic (AF — DOAC; PFO — close in selected per CLOSE, RESPECT), large artery (carotid, intracranial), small vessel, cryptogenic, other (dissection — anticoagulation 3-6 mo, then antiplatelet; vasculitis; hypercoagulable). (7) TIA = transient symptoms without infarct; if MRI DWI infarct = stroke regardless of resolution.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Secondary Stroke Prevention Guideline 2021; NASCET NEJM 1991; CREST NEJM 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 32 ปี ไม่มีโรค มา ED ด้วยอาการแขนซ้ายชา + อ่อนแรง + พูดไม่ชัด onset 2 ชม. resolved spontaneously 30 นาที before arrival; ก่อนหน้านี้ปกติ

V/S: BP 142/86, HR 78, no AF on telemetry
Neuro: now back to baseline; ABCD2 score = 5 (high risk)
MRI brain DWI: small acute infarct left MCA territory cortical → confirms ischemic stroke (transient symptoms but radiographic infarct = stroke not TIA per recent definition)
Carotid Doppler: 80% stenosis left ICA + atheromatous plaque (symptomatic side)
Lab: lipid panel TC 280 LDL 192, A1c 5.6%, normal CBC + coag'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี diagnosed multiple sclerosis (relapsing-remitting) 2 ปีก่อน on dimethyl fumarate มา ED ด้วยอาการมองเห็นไม่ชัดข้างขวา + ตามัว + ปวดเมื่อขยับตา 5 วัน + อ่อนแรงขาขวา mild

V/S: BP 124/76, HR 78, Temp 36.8°C
PE: right RAPD (Marcus Gunn pupil), visual acuity 6/60 right (was 6/9), pain on extraocular movement, color desaturation, fundoscopy: optic disc swelling mild; mild right leg weakness 4+/5; sensory mild paresthesia; intact cerebellar, no encephalopathy

MRI brain + spine: new T2/FLAIR lesion right optic nerve enhancing + 2 new white matter periventricular lesions + 1 new cervical cord lesion
No fever, no infection workup positive', '[{"label":"A","text":"Increase dimethyl fumarate dose"},{"label":"B","text":"Multiple sclerosis acute relapse with optic neuritis + new lesions = clinical + radiologic activity: (1) **High-dose corticosteroid** — IV methylprednisolone 1 g/d × 3-5 d (oral high-dose equivalent 1250 mg/d × 5 d non-inferior per UK trial); shortens relapse duration, does not affect long-term disability; (2) Plasma exchange (PLEX) for steroid-refractory severe relapse (acute severe optic neuritis, transverse myelitis); (3) Address current DMT inadequacy — switch to higher-efficacy: anti-CD20 (ocrelizumab, ofatumumab, ublituximab), natalizumab (anti-α4-integrin; PML risk JCV+), S1P modulator (fingolimod, siponimod, ozanimod, ponesimod), cladribine, alemtuzumab; recent trend toward early high-efficacy DMT in active MS (OPERA, ASCLEPIOS, MS-PATHS); (4) Symptomatic: spasticity (baclofen, tizanidine), neuropathic pain (gabapentin, pregabalin), fatigue (amantadine, modafinil), urinary (mirabegron); (5) Lifestyle: vitamin D, exercise, smoking cessation; (6) Vaccinations pre-DMT; JCV antibody for natalizumab; (7) MRI surveillance q6-12mo; (8) Counsel pregnancy planning (washout periods vary by DMT); (9) Multidisciplinary: neuro + ophth + PT/OT + mental health"},{"label":"C","text":"Antibiotic IV empirically"},{"label":"D","text":"Long-term oral steroid taper monotherapy"},{"label":"E","text":"IVIG monotherapy"}]'::jsonb,
  'B', 'MS acute relapse — clinical + radiologic activity (new T2/Gd-enhancing lesions). McDonald 2017 + AAN MS + ECTRIMS-EAN guideline: (1) Acute relapse: IV methylpred 1 g/d × 3-5 d shortens duration, does not change long-term outcomes. Oral high-dose equivalent (1250 mg/d) non-inferior (UK trial). PLEX for severe steroid-refractory. (2) DMT classes by efficacy: - Moderate: interferon-β (IM/SC), glatiramer, teriflunomide, dimethyl fumarate, fingolimod, ozanimod, ponesimod, cladribine. - High: anti-CD20 (ocrelizumab, ofatumumab, ublituximab), natalizumab, S1P modulator (fingolimod variants), alemtuzumab. (3) Trend: early high-efficacy DMT in active RRMS — better disability outcomes (OPERA, ASCLEPIOS, TREAT-MS). (4) Active disease on moderate DMT (new lesion, relapse, EDSS progression) = switch to higher efficacy. (5) Specific considerations: - Natalizumab: PML risk in JCV+ patients > 2 yr — monitor antibody index. - Anti-CD20: ↑ infection, ↓ vaccine response — pre-vaccination. - Fingolimod: cardiac monitoring first dose, macular edema, varicella. - Alemtuzumab: secondary autoimmunity (thyroid, ITP, GBM), infection. (6) Symptomatic: spasticity (baclofen, tizanidine, Sativex), pain (gabapentin), fatigue (amantadine, modafinil), urinary (mirabegron, antimuscarinic), depression. (7) Lifestyle: vit D supplementation, smoking cessation, exercise. (8) Pregnancy planning: washout periods vary (teriflunomide longest), select DMT for breastfeeding. (9) Multidisciplinary care. (10) Differential: NMO/MOGAD (longitudinally extensive transverse myelitis, severe optic neuritis, aquaporin-4 or MOG antibody — different treatment, eculizumab/satralizumab for NMO).', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'McDonald Criteria for MS 2017; AAN Practice Guideline on DMT in MS 2018; ECTRIMS-EAN MS Treatment Guideline 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี diagnosed multiple sclerosis (relapsing-remitting) 2 ปีก่อน on dimethyl fumarate มา ED ด้วยอาการมองเห็นไม่ชัดข้างขวา + ตามัว + ปวดเมื่อขยับตา 5 วัน + อ่อนแรงขาขวา mild

V/S: BP 124/76, HR 78, Temp 36.8°C
PE: right RAPD (Marcus Gunn pupil), visual acuity 6/60 right (was 6/9), pain on extraocular movement, color desaturation, fundoscopy: optic disc swelling mild; mild right leg weakness 4+/5; sensory mild paresthesia; intact cerebellar, no encephalopathy

MRI brain + spine: new T2/FLAIR lesion right optic nerve enhancing + 2 new white matter periventricular lesions + 1 new cervical cord lesion
No fever, no infection workup positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 68 ปี postmenopausal × 18 yr, no HRT, ไม่มีโรค underlying มาด้วยปวดหลังลำสันหลังเฉียบพลัน + height loss 4 cm จาก young adult height + fragility fracture vertebral L1 (compression fracture from minor fall)

Lab: Ca 9.4, P 3.4, Vit D 18 (low), PTH 56 (normal), TSH 1.6, CBC normal, Cr 0.9, ALP 88
24h urine Ca normal, no celiac/hyperthyroid/cortisol/myeloma evidence (CBC + chem + SPEP normal)
DXA: T-score lumbar -3.4, femoral neck -3.1, total hip -3.0 (osteoporosis severe + previous fragility fracture)
FRAX 10-yr major OF 28%, hip 14% (very high risk)', '[{"label":"A","text":"Calcium + Vit D supplementation alone"},{"label":"B","text":"Severe osteoporosis with vertebral fragility fracture + very high fracture risk — Endocrine Society 2020 + AACE/ACE + NOF guideline: (1) **Anabolic agent first-line for very high-risk** (recent fragility fracture, T-score < -3.0, FRAX hip > 4.5% or major > 30%): - **Romosozumab** (sclerostin inhibitor — anti-Wnt) — FRAME, ARCH; monthly SC × 12 mo then sequential antiresorptive (alendronate or denosumab); CV black box — caution recent MI/stroke. - **Teriparatide** (recombinant PTH 1-34) or **abaloparatide** (PTH-rP analog) — daily SC × 2 yr maximum (osteosarcoma rat — humans not seen but lifetime limit); follow with antiresorptive to maintain. - Sequence anabolic → antiresorptive (loss of bone if anabolic stopped without follow-up). (2) **Antiresorptive standard**: - Bisphosphonate: alendronate, risedronate (oral weekly), zoledronate IV annually (3-5 yr then drug holiday assess in low-moderate risk; longer in high risk). - Denosumab (anti-RANKL): 60 mg SC q6mo; effective; but discontinuation = rebound multi-vertebral fracture (must transition to bisphosphonate). - Raloxifene (SERM): postmenopausal vertebral fracture prevention; ↑ VTE + hot flashes; reduces breast cancer; not for non-vertebral. - HRT: postmenopausal symptoms; thrombosis + breast cancer concerns. (3) Calcium 1000-1200 mg/d + Vit D 800-2000 IU/d to maintain 25-OH > 30 ng/mL; (4) Fall prevention: PT/OT, home safety, vision, vestibular, medication review (deprescribe sedative, anticholinergic), exercise (resistance + balance); (5) Bone health: smoking + alcohol moderation, weight-bearing exercise, nutrition; (6) Vertebral fracture acute: pain control, vertebroplasty/kyphoplasty (controversial; selected severe persistent pain); brace; PT; (7) Secondary osteoporosis screen (already done — normal): hyperPT, thyroid, vit D, multiple myeloma, celiac, hypogonadism, drug (steroid, anti-epileptic, PPI long-term, SSRI, glitazone); (8) Monitor: DXA q2 yr (less frequent if stable); CTX/P1NP for compliance"},{"label":"C","text":"Long-term bisphosphonate alone × 5 yr"},{"label":"D","text":"Calcitonin nasal spray"},{"label":"E","text":"Watchful waiting"}]'::jsonb,
  'B', 'Osteoporosis with fragility fracture = severe; very high risk requires anabolic-first. Endocrine Society 2020 + AACE/ACE 2020 + NOF Clinician''s Guide + Bone Health Foundation: (1) Diagnosis: DXA T-score ≤ -2.5 OR fragility fracture (any T-score; vertebral on imaging counts). (2) Risk: FRAX, T-score, fragility fracture history. Very high risk = fracture in past 12 mo + T < -3 + FRAX hip > 3-4.5% or major > 20-30%. (3) Treatment: - Lifestyle: Ca, Vit D, exercise, fall prevention, smoking/alcohol moderation. - First-line antiresorptive (moderate-high risk): bisphosphonate (alendronate, risedronate, zoledronate) — duration 3-5 yr oral or 3 yr IV then drug holiday assess. - Denosumab: anti-RANKL; effective; discontinuation = rebound vertebral fracture risk → must transition to bisphosphonate. - Anabolic first for very high risk: romosozumab (anti-sclerostin) 12 mo → antiresorptive; teriparatide or abaloparatide 2 yr (lifetime limit) → antiresorptive. - SERM (raloxifene): postmenopausal vertebral; VTE risk. - HRT: limited role. - Calcitonin: rarely used now (limited efficacy + cancer concern). (4) Vit D > 30 ng/mL goal; Ca 1000-1200 mg/d. (5) Bisphosphonate adverse: GI (oral), osteonecrosis of jaw (rare, dental clearance), atypical femur fracture (long-term > 5 yr), uveitis (IV). (6) Denosumab adverse: rebound vertebral fracture on stop, hypocalcemia. (7) Drug holiday after 3-5 yr bisphosphonate if low-moderate risk (T > -2.5, no new fracture); continue in high-risk. (8) Secondary osteoporosis: hyperPT, thyroid, hypogonadism, GI/celiac, MM, drugs (steroid, AED, PPI long-term, SSRI, TZD), CKD. (9) Vertebroplasty/kyphoplasty controversial — selected. (10) Fall prevention + bone health holistic.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society 2020 Pharmacologic Management of Osteoporosis; AACE/ACE 2020 Osteoporosis Guidelines; NOF Clinician''s Guide', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 68 ปี postmenopausal × 18 yr, no HRT, ไม่มีโรค underlying มาด้วยปวดหลังลำสันหลังเฉียบพลัน + height loss 4 cm จาก young adult height + fragility fracture vertebral L1 (compression fracture from minor fall)

Lab: Ca 9.4, P 3.4, Vit D 18 (low), PTH 56 (normal), TSH 1.6, CBC normal, Cr 0.9, ALP 88
24h urine Ca normal, no celiac/hyperthyroid/cortisol/myeloma evidence (CBC + chem + SPEP normal)
DXA: T-score lumbar -3.4, femoral neck -3.1, total hip -3.0 (osteoporosis severe + previous fragility fracture)
FRAX 10-yr major OF 28%, hip 14% (very high risk)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี HIV+ on ART 1 ปี VL undetectable, CD4 300, มาด้วยไข้ + เหนื่อย + ไอแห้ง 3 สัปดาห์ + dyspnea on exertion progressive

V/S: SpO2 88% RA → 93% on 2L NC, RR 26, T 38.2°C
PE: clear lungs on exam (paradoxical to hypoxia), no rash, no LAN

Lab: WBC 4,200, Hb 12, LDH 480 (elevated), Cr 1.0
CXR: bilateral perihilar interstitial reticulonodular infiltrate ("bat-wing")
HRCT: bilateral ground-glass + reticular, no consolidation, no LAN, no pleural
ABG room air: PaO2 62, A-a gradient 48 (widened)
BAL + PCR: Pneumocystis jirovecii positive; immunofluorescence positive
Co-tests negative TB, fungal, CMV', '[{"label":"A","text":"Vancomycin + cefepime empirical"},{"label":"B","text":"Moderate-severe Pneumocystis jirovecii pneumonia (PJP, formerly PCP) in HIV+ patient (A-a > 35 or PaO2 < 70 = moderate-severe): (1) **TMP-SMX 15-20 mg/kg/d TMP component divided q6-8h IV** × 21 days — first-line; switch to oral when stable; (2) **Adjunctive corticosteroid for moderate-severe (PaO2 < 70 or A-a > 35)**: prednisolone 40 mg BID × 5 d → 40 mg/d × 5 d → 20 mg/d × 11 d (total 21 d); reduces mortality + respiratory failure; (3) Alternative if TMP-SMX intolerance/sulfa allergy: pentamidine IV (nephrotoxic, pancreatitis, hypoglycemia, dysrhythmia), atovaquone (mild only), clindamycin + primaquine (G6PD screen — primaquine contraindicated if deficient), dapsone + TMP, trimetrexate; (4) ART continuation (don''t interrupt; if newly diagnosed, start ART within 2 weeks; in PJP — IRIS less concern than TB/crypto); (5) Secondary prophylaxis after acute Rx: TMP-SMX 1 DS daily or TIW until CD4 > 200 for > 3-6 mo on ART; (6) Primary prophylaxis: CD4 < 200 or oropharyngeal candidiasis (in HIV+); also in solid organ transplant, hematologic malignancy, prolonged high-dose steroid, certain immunosuppressives (rituximab, idelalisib); (7) Other adjuncts: respiratory support (NIV or intubation if severe), supplemental O2, address comorbidity"},{"label":"C","text":"Antifungal voriconazole"},{"label":"D","text":"Influenza antiviral"},{"label":"E","text":"Discharge with outpatient antibiotic"}]'::jsonb,
  'B', 'Pneumocystis jirovecii pneumonia (PJP) — most common opportunistic pneumonia HIV+. Risk: CD4 < 200, malignancy, transplant, chronic steroid, immunosuppressive (rituximab, TNF inhibitor). Clinical: subacute dyspnea, fever, dry cough, hypoxia out of proportion to exam; LDH ↑; HIV-PJP slower onset (weeks) vs non-HIV faster + severe. CDC/IDSA/HIVMA + ATS PJP guideline: (1) Diagnosis: BAL (90% sensitivity) + immunofluorescence/PCR; induced sputum (50-90%); serum β-D-glucan elevated. HRCT: bilateral ground-glass + perihilar; pneumothorax + cyst characteristic. (2) Treatment: - TMP-SMX 15-20 mg/kg/d TMP IV (or oral) divided q6-8h × 21 d — first-line. - Severe (PaO2 < 70 or A-a > 35): + corticosteroid (prednisolone 40 mg BID × 5d → 40/d × 5d → 20/d × 11d) — mortality reduction. - Alternatives (TMP-SMX intolerance): - Pentamidine IV: nephrotoxic, pancreatitis, hypoglycemia, dysrhythmia, hypotension. - Atovaquone suspension: mild only. - Clindamycin + primaquine: G6PD test (primaquine contraindicated if deficient). - Dapsone + TMP: G6PD test. - Trimetrexate. (3) ART: continue in HIV; start within 2 weeks of PJP diagnosis (PJP IRIS less common than other OI). (4) Prophylaxis: - Primary: HIV CD4 < 200, or oropharyngeal candidiasis; solid organ + heme transplant; chronic high-dose steroid + lymphoid malignancy; certain biologics. - TMP-SMX 1 DS daily or TIW (preferred); dapsone, atovaquone, pentamidine inhaled. - Secondary: after acute PJP until CD4 > 200 for > 3-6 mo. (5) Atypical: pneumothorax (PCP cyst rupture), DLCO low, sulfa allergy + desensitization. (6) Differentiate from CMV, fungal, TB.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'CDC/IDSA/HIVMA OI Guidelines 2023; ATS Statement on Treatment of PJP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี HIV+ on ART 1 ปี VL undetectable, CD4 300, มาด้วยไข้ + เหนื่อย + ไอแห้ง 3 สัปดาห์ + dyspnea on exertion progressive

V/S: SpO2 88% RA → 93% on 2L NC, RR 26, T 38.2°C
PE: clear lungs on exam (paradoxical to hypoxia), no rash, no LAN

Lab: WBC 4,200, Hb 12, LDH 480 (elevated), Cr 1.0
CXR: bilateral perihilar interstitial reticulonodular infiltrate ("bat-wing")
HRCT: bilateral ground-glass + reticular, no consolidation, no LAN, no pleural
ABG room air: PaO2 62, A-a gradient 48 (widened)
BAL + PCR: Pneumocystis jirovecii positive; immunofluorescence positive
Co-tests negative TB, fungal, CMV'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี ไม่มีโรคประจำตัว มาด้วยอาการเหนื่อย + jaundice + ปัสสาวะสีโคล่า 2 วัน หลังจากกินยา primaquine (จาก outpatient เพื่อ malaria prophylaxis) + ก่อนหน้านี้กิน fava beans crashes prior

Lab: Hb 6.4 (drop from 14 baseline), MCV 92, reticulocyte 12% (high), smear: bite cells + blister cells + Heinz bodies on supravital stain
Indirect bili 6.4, LDH 1,840, haptoglobin 0, Coombs negative
UA: hemoglobinuria
G6PD activity 4% (severely deficient — diagnostic)
No splenomegaly', '[{"label":"A","text":"Continue primaquine + transfusion"},{"label":"B","text":"Acute hemolytic anemia in G6PD deficiency (Mediterranean variant likely — severe phenotype) triggered by primaquine + fava beans — (1) **STOP triggering agent (primaquine)** + avoid in future; (2) Supportive: IV fluid to maintain renal perfusion (hemoglobinuria → AKI risk), bicarbonate alkalinization controversial; (3) **Blood transfusion** if Hb < 6-7 or symptomatic — usually one-time event, hemolysis self-limited as susceptible RBCs cleared; (4) Folic acid supplement (high turnover); (5) Avoid future triggers: oxidant drugs (sulfa — sulfonamide, sulfasalazine, dapsone; nitrofurantoin; primaquine, tafenoquine; rasburicase; methylene blue; phenazopyridine; chloramphenicol; high-dose ASA; vit K), fava beans, mothballs (naphthalene), henna, infection (Hep A, B, typhoid); (6) Newborn screening + family screening (X-linked recessive — males affected, females carriers; heterozygotes can have variable phenotype due to lyonization); (7) Patient education + medical alert + medication list; (8) G6PD activity test BEFORE primaquine for malaria treatment (vivax/ovale) and in any region with high G6PD prevalence; quantitative + qualitative test variability — quantitative preferred; (9) Tafenoquine (single dose 300 mg for P. vivax radical cure) requires G6PD testing first — severe deficiency contraindicated, intermediate cautious; (10) Methemoglobinemia avoidance"},{"label":"C","text":"Splenectomy"},{"label":"D","text":"Long-term corticosteroid therapy"},{"label":"E","text":"Bone marrow biopsy"}]'::jsonb,
  'B', 'G6PD deficiency — X-linked recessive RBC enzyme deficiency; protects against malaria (selection pressure). Most common enzymopathy worldwide; variants: African A- (mild, hemolysis only during oxidative stress); Mediterranean (severe, even fava beans); Asian variants. Acute hemolysis: episodic, oxidant-triggered, self-limited (succeptible old RBCs cleared, young RBCs more resistant). Chronic hemolytic form rare (Class I severe). WHO + Beutler G6PD guideline: (1) Diagnosis: G6PD activity quantitative (preferred — variants have residual activity differences) or qualitative fluorescent spot test; not during acute hemolysis (reticulocytes have high enzyme activity, falsely normal — test after recovery 2-4 wk or genetic testing). (2) Triggers: - Drugs: primaquine, tafenoquine, dapsone, sulfonamide, nitrofurantoin, rasburicase, methylene blue, phenazopyridine, chloramphenicol, henna, high-dose ASA, vit K (menadione). Lists vary; recent risk reassessment for some. - Foods: fava beans (Mediterranean variant). - Mothballs (naphthalene). - Infections: hepatitis A/B, typhoid, S. pneumoniae. (3) Management: stop trigger; supportive (fluid for hemoglobinuria + AKI prevention); transfusion if severe (Hb < 6-7 or symptomatic); folate. (4) Avoid future triggers: medical alert, medication review; pre-prescribing G6PD test for primaquine, tafenoquine, dapsone, rasburicase. (5) Primaquine (P. vivax/P. ovale radical cure): standard 30 mg/d × 14 d; G6PD deficient cannot tolerate; alternative weekly 45-60 mg × 8 wk (slower hemolysis); tafenoquine single dose 300 mg requires G6PD activity > 70%. (6) Heterozygous female: variable phenotype (lyonization — random X inactivation); may have mosaic enzyme activity; usually milder + carrier. (7) Neonatal: jaundice + kernicterus risk in G6PD deficient newborn — screening. (8) Methemoglobinemia (e.g., dapsone): G6PD deficient cannot reduce methemoglobin via NADPH-dependent pathway; methylene blue (treatment) is itself oxidant → cannot use; alternative ascorbic acid + supportive; cimetidine prevention dapsone-methemoglobinemia. (9) Family screening; genetic counseling.', NULL,
  'easy', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'WHO G6PD Deficiency Guideline; Beutler E — G6PD Blood; CDC Malaria Treatment Guidelines re Primaquine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 22 ปี ไม่มีโรคประจำตัว มาด้วยอาการเหนื่อย + jaundice + ปัสสาวะสีโคล่า 2 วัน หลังจากกินยา primaquine (จาก outpatient เพื่อ malaria prophylaxis) + ก่อนหน้านี้กิน fava beans crashes prior

Lab: Hb 6.4 (drop from 14 baseline), MCV 92, reticulocyte 12% (high), smear: bite cells + blister cells + Heinz bodies on supravital stain
Indirect bili 6.4, LDH 1,840, haptoglobin 0, Coombs negative
UA: hemoglobinuria
G6PD activity 4% (severely deficient — diagnostic)
No splenomegaly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี ไม่มีโรค post-thyroidectomy 2 d ก่อน สำหรับ thyroid cancer มา ED ด้วยมือชา + ปากชา + Chvostek sign + Trousseau sign + tetanic spasm + perioral paresthesia

V/S: BP 124/76, HR 92, RR 18, Temp 36.7°C
PE: positive Chvostek (facial twitch tapping ใต้กระดูกแก้ม), Trousseau (carpopedal spasm with BP cuff > systolic for 3 min), no laryngeal stridor

Lab: Ca total 6.4 (severe; corrected 6.8 for albumin 3.8), ionized Ca 0.78 (very low), Phosphate 5.4 (high), Mg 1.6, K 4.0, Albumin 3.8, Cr 0.9
PTH < 5 (severely suppressed — hypoparathyroidism)
25-OH vit D 16 (low)
EKG: prolonged QT 520 ms', '[{"label":"A","text":"Oral calcium tablet alone"},{"label":"B","text":"Severe symptomatic hypocalcemia from post-surgical hypoparathyroidism (transient or permanent): (1) **IV calcium gluconate** 1-2 g (10-20 mL of 10% solution) in 100 mL D5W slow over 10-20 min for symptomatic/severe (avoid bolus — arrhythmia risk); maintenance drip 1-3 mg/kg/hr (50-100 mg/kg/24h) elemental Ca; monitor Ca q4-6h initial; AVOID extravasation (tissue necrosis — central preferred); (2) Replenish **magnesium** — Mg < 1.6 hampers PTH release + action (functional hypopara); IV MgSO4 1-2 g; (3) **Calcitriol (active vit D, 1,25-OH)** 0.25-1 mcg PO/IV (or alfacalcidol) — bypasses 1α-hydroxylation (PTH-dependent); start before discharge for maintenance; (4) Oral calcium carbonate (1-2 g elemental Ca TID with meals — best absorption with food, acid environment); citrate alternative; (5) Vitamin D supplementation 1000-2000 IU/d + 25-OH replete; (6) Treat underlying: hypoparathyroid often transient (3-6 mo) after total thyroidectomy; permanent in 1-3%; (7) Monitor: serum Ca + Phos + Mg + Cr daily initial; 24h urine Ca (avoid hypercalciuria → nephrocalcinosis on Rx); (8) **PTH replacement** (recombinant teriparatide [PTH 1-34] or palopegteriparatide [TransCon PTH, FDA 2024]) for refractory chronic hypoparathyroidism; (9) Avoid loop diuretic (hypercalciuria worsens); thiazide reduces urine Ca; (10) Surgeon notification for hematoma/airway concern; (11) Avoid factors worsening: high phosphate, alkalemia (reduces ionized Ca)"},{"label":"C","text":"Bisphosphonate IV"},{"label":"D","text":"Vitamin D3 25,000 IU daily"},{"label":"E","text":"Total parathyroidectomy"}]'::jsonb,
  'B', 'Hypocalcemia — post-thyroidectomy hypoparathyroidism. Other causes: surgical, autoimmune, congenital (DiGeorge 22q11), pseudohypoparathyroidism (PTH resistance), severe vit D deficiency, hyperphosphatemia (CKD, rhabdo, tumor lysis), pancreatitis, magnesium deficiency, sepsis, transfusion (citrate). Endocrine Society + ES Hypopara guideline: (1) Diagnosis: serum Ca corrected for albumin (or ionized Ca preferred — more accurate); confirm with PTH (low = hypopara; high = secondary/resistance). Phos, Mg, Cr, Vit D, Mg. EKG: prolonged QT. (2) Acute symptomatic: IV calcium gluconate 1-2 g over 10-20 min, then drip 50-100 mg/kg/24h elemental Ca; monitor q4-6h. Avoid central preference (extravasation tissue necrosis). (3) Mg replete (Mg < 1.6 hampers PTH); 1-2 g IV MgSO4. (4) Active vit D (calcitriol 0.25-1 mcg PO/IV; alfacalcidol) — bypasses 1α-hydroxylase (PTH-dependent in renal). (5) Oral calcium 1-2 g elemental TID (carbonate cheap, with food; citrate without food + PPI users). (6) 25-OH vit D supplement + replete. (7) Long-term hypoparathyroidism: - Target serum Ca low-normal 8.0-8.5 (corrected); avoid hypercalciuria (nephrocalcinosis, stones). - Calcium + active vit D + 24h urine Ca monitoring. - Thiazide diuretic to reduce urine Ca if hypercalciuric. - PTH replacement: rhPTH (teriparatide PTH 1-34) for refractory; palopegteriparatide (TransCon PTH, FDA 2024) — sustained release; preserves renal function. (8) Avoid loop diuretic (hypercalciuria), bisphosphonate, denosumab (severe hypocalcemia risk). (9) Genetic: 22q11 (DiGeorge — also cardiac, immune), AIRE (APS-1 with Addison + mucocutaneous candidiasis), autoimmune. (10) Pseudohypoparathyroidism: PTH resistance — Ca low, PTH HIGH, signs of AHO. (11) Monitor + adjust based on Ca, urine Ca, Cr, eGFR, BMD.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Hypoparathyroidism Guideline 2016; First International Workshop on Hypoparathyroidism JCEM 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรค post-thyroidectomy 2 d ก่อน สำหรับ thyroid cancer มา ED ด้วยมือชา + ปากชา + Chvostek sign + Trousseau sign + tetanic spasm + perioral paresthesia

V/S: BP 124/76, HR 92, RR 18, Temp 36.7°C
PE: positive Chvostek (facial twitch tapping ใต้กระดูกแก้ม), Trousseau (carpopedal spasm with BP cuff > systolic for 3 min), no laryngeal stridor

Lab: Ca total 6.4 (severe; corrected 6.8 for albumin 3.8), ionized Ca 0.78 (very low), Phosphate 5.4 (high), Mg 1.6, K 4.0, Albumin 3.8, Cr 0.9
PTH < 5 (severely suppressed — hypoparathyroidism)
25-OH vit D 16 (low)
EKG: prolonged QT 520 ms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี underlying T2DM, prior MI on ASA + statin มา ED ด้วยอาการถ่ายอุจจาระดำเหนียว + อ่อนเพลีย 2 d + ไม่มี hematemesis

V/S: BP 102/68 (orthostatic +), HR 108, RR 18, SpO2 97%
PE: pale, melena confirmed rectal exam, no tenderness, no peritonitis

Lab: Hb 8.2 (drop from 13.5 baseline), MCV 86, Plt 240K, BUN 56 (high — UGIB), Cr 1.2, INR 1.0
Glasgow-Blatchford score 12 (high risk)
EGD: 2 cm clean-base posterior duodenal ulcer Forrest III + no other lesions; biopsy H. pylori negative
Medication: aspirin 81 mg daily + atorvastatin (no NSAID)', '[{"label":"A","text":"Stop aspirin permanently"},{"label":"B","text":"Bleeding peptic ulcer Forrest III (clean base = lowest rebleed risk 5%) in patient on aspirin for secondary CV prevention: (1) Acute: resuscitation (PRC if Hb < 7 + symptomatic per Villanueva — restrictive); IV PPI (no benefit + cost — PPI infusion for high-risk Forrest Ia-IIb after endoscopic therapy; here Forrest III standard dose oral PPI 8 wk healing); (2) **Continue aspirin** for secondary CV prevention — restart within 1-3 days (or never stop if low-risk endoscopic stigmata) per ESGE/AGA — discontinuation = 7× MACE risk; benefit of CV prevention outweighs rebleed risk; (3) Concurrent PPI 8 wk healing + indefinite (with aspirin if at risk); (4) H. pylori test (here negative) + treat if positive; (5) NSAID avoidance; if must continue NSAID — COX-2 + PPI; (6) Address cause: aspirin alone (no NSAID, no H. pylori) = idiopathic / aspirin-related — minimize concurrent risk factors; (7) Discharge planning: outpatient follow-up; avoid NSAID; H. pylori + repeat if relapse; (8) Repeat EGD only for gastric ulcer (rule out malignancy)"},{"label":"C","text":"Surgical resection"},{"label":"D","text":"Stop statin"},{"label":"E","text":"Long-term clopidogrel monotherapy"}]'::jsonb,
  'B', 'PUD bleeding in patient on aspirin for secondary CV prevention. Key tension: CV benefit of antiplatelet vs bleeding risk. ESGE 2021 + AGA 2022 + ACG 2021 antiplatelet/GIB guideline: (1) Acute: resuscitation, restrictive transfusion Hb 7-8, IV PPI for high-risk endoscopy Forrest Ia-IIb (80 mg bolus + 8 mg/hr × 72 hr) — not for Forrest III clean base. (2) Antiplatelet management: - **Secondary prevention indication**: continue or restart aspirin within 1-3 days post-hemostasis — discontinuation associated with 7× MACE risk; benefit outweighs rebleed for most. Sung BMJ 2018 (aspirin + PPI vs stopping) — continuation reduced mortality. - Primary prevention only: more discretion to stop, less clear-cut benefit. - DAPT in recent PCI: continue both ASA + P2Y12 if possible; consider short interruption of P2Y12 (1-7 d) for active bleed if drug-eluting stent > 30 d; restart ASAP. - Anticoagulation (warfarin, DOAC) for AF: balance stroke risk vs bleeding; restart after hemostasis based on indication. (3) PPI for healing 8 wk + maintenance with antiplatelet/NSAID. (4) H. pylori test + treat. (5) NSAID avoidance / COX-2 + PPI if needed. (6) Lifestyle. (7) Repeat EGD only for gastric ulcer (rule out malignancy 8-12 wk). (8) Mortality from MI > mortality from GIB in most secondary prevention.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ESGE Guideline on Endoscopic Diagnosis and Management of Nonvariceal UGIB 2021; AGA Guideline on Management of PUD Bleeding 2022; Sung JJ et al. BMJ 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 65 ปี underlying T2DM, prior MI on ASA + statin มา ED ด้วยอาการถ่ายอุจจาระดำเหนียว + อ่อนเพลีย 2 d + ไม่มี hematemesis

V/S: BP 102/68 (orthostatic +), HR 108, RR 18, SpO2 97%
PE: pale, melena confirmed rectal exam, no tenderness, no peritonitis

Lab: Hb 8.2 (drop from 13.5 baseline), MCV 86, Plt 240K, BUN 56 (high — UGIB), Cr 1.2, INR 1.0
Glasgow-Blatchford score 12 (high risk)
EGD: 2 cm clean-base posterior duodenal ulcer Forrest III + no other lesions; biopsy H. pylori negative
Medication: aspirin 81 mg daily + atorvastatin (no NSAID)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี ไม่มีโรค มา ED ด้วยไอเป็นเลือดสด > 200 mL × 4 ครั้งใน 6 ชม. + เหนื่อย + รู้สึก suffocating; ก่อนหน้านี้ไอเรื้อรัง 6 เดือน + น้ำหนักลด + ไอเรื้อรังคล้าย bronchiectasis

V/S: BP 102/64, HR 124, RR 28, SpO2 90% RA → 94% NRB, Temp 37.4°C
PE: pale, blood in mouth + suctioned from airway, decreased breath sounds RUL, scattered crackles

Lab: Hb 9.2 (acute drop), Plt 220K, INR 1.0, Cr 1.0
CXR + chest CT (rapid CTA): RUL cavitary lesion + bronchiectasis + bronchial artery hypertrophy on right; suspect TB-related cavitary lesion with bronchial artery aneurysm bleeding
Sputum AFB pending; CT angio shows tortuous hypertrophied bronchial artery from right intercostal branch
Not on anticoagulant', '[{"label":"A","text":"Discharge with cough suppressant"},{"label":"B","text":"Massive hemoptysis (> 500 mL/24 hr or > 100 mL/hr or hemodynamic compromise or respiratory failure from blood) — Life-threatening emergency from drowning > exsanguination: (1) Immediate: airway protection (intubate with large-bore tube 8.0 ETT, side of bleeding DOWN to prevent contralateral lung soiling — \"good lung up\"); selective bronchial intubation or double-lumen tube if available; suction + cough suppression; (2) **Bronchial artery embolization (BAE)** — first-line definitive: interventional radiology; identify + embolize hypertrophied bronchial artery (most common source 90%); high success ~85%; recurrence in 20-30% may need re-embolization; (3) Rigid bronchoscopy if BAE delayed: tamponade with balloon or topical hemostatic (cold saline lavage, epinephrine, thrombin) + visualize source; (4) Surgical resection (lobectomy/pneumonectomy) — for failed embolization or specific etiology (aspergilloma, malignancy with isolated source); (5) Reverse coagulopathy if any; TXA may have role; (6) Address underlying: TB (anti-TB therapy if confirmed; even after BAE), bronchiectasis (treat colonization, mucolytic, vaccination), malignancy (oncologic management), aspergilloma (antifungal + surgery), vasculitis, cystic fibrosis, AVM (embolize); (7) Massive hemoptysis = high mortality (especially without urgent intervention 50%+)"},{"label":"C","text":"Long-term oral antibiotic outpatient"},{"label":"D","text":"Anticoagulation"},{"label":"E","text":"Watchful waiting"}]'::jsonb,
  'B', 'Massive hemoptysis (life-threatening). Definitions vary: > 500 mL/24h, > 100 mL/hr, hemodynamic compromise, respiratory failure from blood. Most common cause Asia/Thailand: TB-related (cavitary, bronchiectasis, aspergilloma in cavity); also bronchiectasis (non-TB), malignancy, vasculitis (anti-GBM, ANCA), CF, PE, AVM. Death usually from asphyxia (blood in airway), not exsanguination. ATS/CHEST + ERS hemoptysis guideline: (1) Stabilize airway — intubate if respiratory compromise; large-bore ETT (8.0); position bleeding side DOWN (gravity protects contralateral lung); selective intubation; double-lumen tube if expertise; rigid bronchoscopy for tamponade balloon. (2) **Bronchial artery embolization (BAE)** — first-line definitive for non-surgical: high success ~85%; bronchial artery hypertrophy (systemic circulation, high pressure — 90% source); pulmonary artery source 10% (different). Recurrence 20-30%. (3) Rigid bronchoscopy adjunct: balloon tamponade, topical hemostatic (cold saline lavage, epinephrine, thrombin, fibrin glue). (4) Surgery: failed BAE, specific anatomic source (aspergilloma, AVM, malignancy localized), persistent bleed. (5) Address underlying: TB treatment (anti-TB regimen), aspergilloma (antifungal + surgery), bronchiectasis (airway clearance, antibiotics, vaccinations), vasculitis (immunosuppression — RPGN + DAH = anti-GBM, AAV; cyclophosphamide + steroid + PLEX), malignancy. (6) Coagulopathy reversal. TXA (HALT-IT-like) some evidence in hemoptysis. (7) Mortality high without intervention — > 50% massive untreated. (8) Workup: CT-A chest with contrast (identifies source + extent), bronchoscopy (visualize + biopsy if able), sputum AFB + culture, ANCA + anti-GBM if vasculitis suspected.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/CHEST Guidelines on Management of Hemoptysis; ERS Statement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรค มา ED ด้วยไอเป็นเลือดสด > 200 mL × 4 ครั้งใน 6 ชม. + เหนื่อย + รู้สึก suffocating; ก่อนหน้านี้ไอเรื้อรัง 6 เดือน + น้ำหนักลด + ไอเรื้อรังคล้าย bronchiectasis

V/S: BP 102/64, HR 124, RR 28, SpO2 90% RA → 94% NRB, Temp 37.4°C
PE: pale, blood in mouth + suctioned from airway, decreased breath sounds RUL, scattered crackles

Lab: Hb 9.2 (acute drop), Plt 220K, INR 1.0, Cr 1.0
CXR + chest CT (rapid CTA): RUL cavitary lesion + bronchiectasis + bronchial artery hypertrophy on right; suspect TB-related cavitary lesion with bronchial artery aneurysm bleeding
Sputum AFB pending; CT angio shows tortuous hypertrophied bronchial artery from right intercostal branch
Not on anticoagulant'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ไม่มีโรค มาด้วยอาการตื่นมาแขนซ้ายอ่อนแรง ระยะ 3 ชม. + ปวดศีรษะรุนแรง 1 วันก่อน + เพิ่งเดินทางเครื่องบินยาว 12 ชม. + เกิดอาการสะดุดกระแทกคอเมื่อเล่นกีฬาหลังจากไม่กี่วันก่อน

V/S: BP 132/82, HR 78
Neuro: left hemiparesis 3/5, left facial droop, left neglect, NIHSS 14
No AF, no carotid bruit, normal cardiac auscultation

CT brain: no hemorrhage; CTA neck: dissection of right ICA with intramural thrombus + flame-shaped narrowing
Lab: normal coag, normal CBC, lipid panel normal, ANA neg
Family history: no early stroke/connective tissue, no Marfan or Ehlers-Danlos features', '[{"label":"A","text":"Aspirin 81 mg long-term only"},{"label":"B","text":"Cervical artery dissection causing stroke (carotid in this case; vertebral artery dissection also common in young stroke) — neck trauma + travel + sports likely precipitants: (1) Acute management: IV tPA within 4.5 hr eligible (CADISS, CADISP — safety acceptable); endovascular thrombectomy if LVO + within window; (2) Antithrombotic — antiplatelet (aspirin) vs anticoagulation (warfarin/LMWH) for stroke prevention 3-6 mo until vessel heals: CADISS trial showed equivalence — antiplatelet typically preferred (simpler, fewer complications); duration 3-6 mo then reimage; (3) Long-term antiplatelet (aspirin) maintenance after vessel healing; (4) Avoid mechanical neck manipulation (chiropractic, sports); (5) Investigate connective tissue disorder if young/recurrent (Ehlers-Danlos vascular type COL3A1, Marfan, fibromuscular dysplasia, Loeys-Dietz); (6) Risk factors: cervical trauma, hyperextension/rotation, recent infection, hypertension, migraine, OCP; (7) Follow-up imaging at 3-6 mo to assess healing; consider stenting only refractory or pseudoaneurysm; (8) Rehabilitation, secondary prevention (BP, lipid, smoking)"},{"label":"C","text":"Long-term high-dose statin only"},{"label":"D","text":"Carotid endarterectomy emergency"},{"label":"E","text":"Steroid IV pulse"}]'::jsonb,
  'B', 'Cervical artery dissection (CAD) — common cause of stroke in young (~20% in age < 50). Mechanism: tear in arterial wall → intramural hematoma → narrowing/occlusion ± embolization to brain. Vertebral or carotid (extracranial typically); intracranial less common. Triggers: minor trauma (sports, chiropractic, motor vehicle accident, head/neck movement), recent infection, connective tissue (Ehlers-Danlos vascular IV, Marfan, FMD, Loeys-Dietz), pregnancy, HT. Clinical: head/neck pain, ipsilateral Horner (carotid sympathetic), TIA/stroke (delayed hours-days), tinnitus (carotid). Imaging: MRA/CTA neck (luminal narrowing, flame-shape, double lumen, intramural hematoma on T1 fat-sat MRI), conventional angio rarely needed. AHA/ASA + ESO + AAN CAD guideline: (1) Acute stroke: IV tPA within window (CADISS suggested safety; no excess hemorrhage); endovascular thrombectomy for LVO. (2) Antithrombotic prevention 3-6 mo: CADISS RCT showed no difference between antiplatelet (ASA) and anticoagulation (warfarin/LMWH) — most use antiplatelet (simpler, fewer complications). Some still favor anticoagulation for thrombus-rich appearance or recurrent symptoms. (3) Long-term ASA after vessel healing. (4) Follow-up imaging at 3-6 mo. (5) Stenting: rare; refractory or pseudoaneurysm + recurrence. (6) Connective tissue workup if young/recurrent/family history: COL3A1 (vascular Ehlers-Danlos), Marfan, FMD, Loeys-Dietz. (7) Avoid neck manipulation (chiropractic association controversial — likely revealing rather than causing). (8) Risk factors: HT, smoking, OCP, migraine, recent URI. (9) Pregnancy + postpartum increased risk. (10) Recurrence rare (1% per yr); family history may indicate underlying disorder.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Statement on Management of Cervical Artery Dissection 2024; CADISS Trial Lancet Neurol 2015; CADISP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี ไม่มีโรค มาด้วยอาการตื่นมาแขนซ้ายอ่อนแรง ระยะ 3 ชม. + ปวดศีรษะรุนแรง 1 วันก่อน + เพิ่งเดินทางเครื่องบินยาว 12 ชม. + เกิดอาการสะดุดกระแทกคอเมื่อเล่นกีฬาหลังจากไม่กี่วันก่อน

V/S: BP 132/82, HR 78
Neuro: left hemiparesis 3/5, left facial droop, left neglect, NIHSS 14
No AF, no carotid bruit, normal cardiac auscultation

CT brain: no hemorrhage; CTA neck: dissection of right ICA with intramural thrombus + flame-shaped narrowing
Lab: normal coag, normal CBC, lipid panel normal, ANA neg
Family history: no early stroke/connective tissue, no Marfan or Ehlers-Danlos features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี ไม่มีโรค มา ED ด้วยอาการ epigastric pain rapidly progressive + คลื่นไส้ + อาเจียน 2 ชม. + recent NSAID use + heavy alcohol 1 d ก่อน

V/S: BP 96/58, HR 124, RR 24, SpO2 96%, Temp 38.0°C
PE: abdomen tense, rigid, board-like, rebound + guarding diffuse, absent bowel sounds — peritonitis

Lab: WBC 18,400, Hb 13.4, Lactate 3.4, Cr 1.4, Lipase 88 (normal — rules out severe pancreatitis as primary; pancreatitis can be secondary)
CXR upright: subdiaphragmatic free air RIGHT — pneumoperitoneum
CT abdomen: free intraperitoneal air + fluid + small contained perforation duodenal bulb (perforated peptic ulcer)
No prior PUD history clinically', '[{"label":"A","text":"Observation + NPO + IV PPI"},{"label":"B","text":"Perforated peptic ulcer with peritonitis — surgical emergency: (1) Resuscitation: 2 large-bore IV, crystalloid bolus, foley + arterial line, NG tube; (2) IV broad-spectrum antibiotics within 1 hr — gut flora (gram-neg + anaerobe) — pip-tazo or ceftriaxone + metronidazole; sepsis bundle; (3) IV PPI infusion; (4) **Emergent surgery (laparotomy or laparoscopic) — primary repair with omental patch (Graham patch)** of duodenal/gastric perforation + peritoneal lavage; (5) Selective non-operative management (only for stable patient + sealed perforation on imaging + minimal peritonitis + good response to medical Rx — controversial Taylor approach, small ulcers in young healthy); (6) Post-op: H. pylori test + treat; biopsy of gastric ulcer to rule out malignancy at surgery; (7) Identify precipitant: NSAID + alcohol — counsel cessation; stress (steroid, ICU patient); H. pylori; Zollinger-Ellison (recurrent atypical); (8) Long-term PPI; (9) Avoid NSAID; (10) Reassess: if gastric ulcer — repeat EGD 8-12 wk + biopsy for malignancy"},{"label":"C","text":"Continuous oral nutrition"},{"label":"D","text":"Anticoagulation"},{"label":"E","text":"Outpatient PPI"}]'::jsonb,
  'B', 'Perforated peptic ulcer — surgical emergency. Mortality 5-25%. Causes: H. pylori, NSAID + alcohol, smoking, stress (ICU), Zollinger-Ellison. ACG + EAES + WSES perforated PUD guideline: (1) Diagnosis: sudden severe epigastric pain, peritoneal signs, pneumoperitoneum on imaging (upright CXR shows subdiaphragmatic air 80%; CT more sensitive — can detect minimal free air + fluid). (2) Resuscitation: IV fluid, antibiotics within 1 hr (gram-neg + anaerobe coverage: pip-tazo, ceftriaxone + metronidazole), IV PPI, NG, analgesia. (3) Surgery: - Open or laparoscopic repair: primary suture + omental (Graham) patch — most common. - Definitive ulcer surgery (vagotomy + drainage) — rarely needed now (H. pylori era). - Gastric ulcer: biopsy for malignancy at surgery. (4) Non-operative (Taylor regimen): selected stable + sealed + minimal peritonitis + good response to medical Rx in 24 hr — controversial. (5) Post-op: H. pylori test + eradicate; long-term PPI; avoid NSAID; alcohol/smoking cessation. (6) Mortality predictors: age, comorbid, delay, perforation site, peritonitis severity (Boey score), sepsis. (7) Other PUD complications: bleeding (already covered), gastric outlet obstruction (rare), penetration into adjacent organs (pancreas, liver).', NULL,
  'easy', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Guideline PUD; EAES/WSES Guidelines on Perforated PUD 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 50 ปี ไม่มีโรค มา ED ด้วยอาการ epigastric pain rapidly progressive + คลื่นไส้ + อาเจียน 2 ชม. + recent NSAID use + heavy alcohol 1 d ก่อน

V/S: BP 96/58, HR 124, RR 24, SpO2 96%, Temp 38.0°C
PE: abdomen tense, rigid, board-like, rebound + guarding diffuse, absent bowel sounds — peritonitis

Lab: WBC 18,400, Hb 13.4, Lactate 3.4, Cr 1.4, Lipase 88 (normal — rules out severe pancreatitis as primary; pancreatitis can be secondary)
CXR upright: subdiaphragmatic free air RIGHT — pneumoperitoneum
CT abdomen: free intraperitoneal air + fluid + small contained perforation duodenal bulb (perforated peptic ulcer)
No prior PUD history clinically'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี ไม่มีโรคประจำตัว มาด้วย rapidly enlarging cervical lymphadenopathy + fever + night sweats + weight loss 8 kg ใน 2 เดือน + ปวดหลังเล็กน้อย

PE: cervical + supraclavicular + inguinal LAN > 3 cm rubbery non-tender; hepatosplenomegaly mild
Lab: Hb 10.4, LDH 820 (high), beta-2 microglobulin 4.6, normal Cr + LFT, HIV negative
Excisional LN biopsy: large B-cell lymphoma — Diffuse Large B-Cell Lymphoma (DLBCL) confirmed; immunophenotype CD20+, CD19+, CD79a+; Hans algorithm — GCB subtype; FISH negative MYC rearrangement (no double/triple hit)
PET-CT: stage III (above + below diaphragm + bulky disease 8 cm); BM biopsy negative
IPI 3 (high-intermediate)
Echo LVEF 55%; HBsAg negative; HCV negative', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"DLBCL, GCB subtype, stage III high-intermediate IPI — Polatuzumab vedotin + R-CHP (rituximab + cyclophosphamide + doxorubicin + prednisone × 6 cycles) — POLARIX trial 2022 superior to R-CHOP in PFS for IPI ≥ 2 patients; OR R-CHOP × 6 cycles (still acceptable standard); + intrathecal MTX CNS prophylaxis if CNS-IPI ≥ 4-6 or high-risk (testicular, paranasal, kidney/adrenal, double/triple hit); + tumor lysis prophylaxis (allopurinol, hydration); +/- radiation for bulky disease ≥ 7.5 cm post-chemo; HBV screening + prophylactic entecavir/TDF if HBsAg+ or anti-HBc+ (R-induced reactivation risk); HCC if HBV/HCV; vaccinations pre-Rx; supportive: G-CSF, antiemetic, PPI, infection prophylaxis (PCP, antiviral); response assessment PET-CT after 2-4 cycles + end-of-treatment; relapsed/refractory: CAR-T (axi-cel, liso-cel, tisa-cel — ZUMA-7, TRANSFORM, BELINDA showed CAR-T 2nd-line superior to autoSCT), bispecific (epcoritamab, glofitamab), R-DHAP/R-ICE salvage + autoSCT historically"},{"label":"C","text":"Single-agent rituximab"},{"label":"D","text":"Bone marrow transplant first-line"},{"label":"E","text":"Radiation alone"}]'::jsonb,
  'B', 'DLBCL — most common aggressive NHL. NCCN + ESMO + Lugano + POLARIX: (1) Subtypes (Hans algorithm by IHC): GCB (better prognosis), non-GCB/ABC; molecular subtypes (gene expression). Double/triple-hit (MYC + BCL2 ± BCL6 rearrangement) = high-grade B-cell lymphoma — worse prognosis, needs more intensive (DA-EPOCH-R). (2) Staging: Lugano (Ann Arbor modified) + PET-CT. (3) Risk: IPI (age, LDH, stage, ECOG, extranodal); CNS-IPI for CNS prophylaxis selection. (4) Frontline: - **Polatuzumab + R-CHP × 6** (POLARIX) — IPI ≥ 2, NCCN preferred 2024. - R-CHOP × 6 still standard especially IPI 0-1. - DA-EPOCH-R for double/triple-hit, HIV, primary mediastinal. (5) Adjuncts: - Intrathecal MTX or HD-MTX for CNS prophylaxis (CNS-IPI ≥ 4-6, testicular, paranasal, breast, kidney/adrenal, double/triple-hit). - Tumor lysis prophylaxis. - HBV reactivation: HBsAg + anti-HBc — entecavir/TDF prophylaxis. - G-CSF, antiemetic, PCP prophylaxis. - RT for bulky residual ≥ 7.5 cm. (6) Response: PET-CT interim + end-of-treatment (Deauville score). (7) Relapsed/refractory: - 1st salvage now CAR-T (axi-cel, liso-cel) for early relapsers within 12 mo (ZUMA-7, TRANSFORM). - Late relapse: R-DHAP/R-ICE + auto-SCT. - 3rd line+: bispecific (epcoritamab, glofitamab — CD20×CD3), tafasitamab + lenalidomide, polatuzumab + BR, loncastuximab tesirine. (8) Survivorship: cardiomyopathy (doxorubicin), secondary malignancy, hypothyroidism, fertility.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Guidelines for B-cell Lymphomas 2024; POLARIX NEJM 2022; ZUMA-7 NEJM 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 62 ปี ไม่มีโรคประจำตัว มาด้วย rapidly enlarging cervical lymphadenopathy + fever + night sweats + weight loss 8 kg ใน 2 เดือน + ปวดหลังเล็กน้อย

PE: cervical + supraclavicular + inguinal LAN > 3 cm rubbery non-tender; hepatosplenomegaly mild
Lab: Hb 10.4, LDH 820 (high), beta-2 microglobulin 4.6, normal Cr + LFT, HIV negative
Excisional LN biopsy: large B-cell lymphoma — Diffuse Large B-Cell Lymphoma (DLBCL) confirmed; immunophenotype CD20+, CD19+, CD79a+; Hans algorithm — GCB subtype; FISH negative MYC rearrangement (no double/triple hit)
PET-CT: stage III (above + below diaphragm + bulky disease 8 cm); BM biopsy negative
IPI 3 (high-intermediate)
Echo LVEF 55%; HBsAg negative; HCV negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี ไม่มีโรค ตรวจสุขภาพ พบ LFT มี AST 88 + ALT 124 mild + ตัวเหลืองเล็กน้อย + tremor + dysarthria + พฤติกรรมเปลี่ยน + ปวดข้อ + ฮีโมจลบินูเรีย

PE: Kayser-Fleischer ring (slit lamp confirmed brown ring on cornea), mild tremor + dysarthria, mild splenomegaly
Lab: AST 88, ALT 124, ALP 65 (low), Bilirubin 2.4, INR 1.2, Albumin 3.6, Hb 10.2 (Coombs neg hemolysis), Cr 0.9
Ceruloplasmin 8 (low; normal 20-40), 24-hr urine copper 320 mcg (high; normal < 40), serum copper variable
Liver biopsy: hepatic copper > 250 mcg/g dry weight (high)
Genetic: ATP7B mutations (autosomal recessive)
MRI brain: T2 hyperintensity basal ganglia + brainstem (face of giant panda sign)
No family history (recessive)', '[{"label":"A","text":"Hemochromatosis treatment with phlebotomy"},{"label":"B","text":"Wilson disease (autosomal recessive ATP7B mutation → copper accumulation) — (1) **Copper chelation**: - First-line **D-penicillamine** (with pyridoxine to prevent B6 deficiency); titrate 250 mg → 1.5-2 g/d; effective but SE (myelosuppression, nephrotic syndrome, autoimmune, neurologic worsening 20-50% paradoxical initial). - Alternative **trientine** (TETA, 750-2000 mg/d) — better tolerated; preferred in many initial. - **Zinc acetate** (50 mg TID) — maintenance + presymptomatic; blocks intestinal absorption (induces metallothionein); not for acute fulminant. - Newer: tetrathiomolybdate, ALXN1840 (bis-choline tetrathiomolybdate). (2) Acute fulminant Wilson with hemolysis + ALF: liver transplant (cure); high mortality without; copper removal by plasmapheresis/MARS as bridge; (3) Avoid copper-rich foods (organ meats, shellfish, nuts, chocolate, mushroom); avoid copper cookware/water; (4) Family screening — first-degree relatives — clinical + biochem + genetic + slit lamp; presymptomatic siblings treated to prevent disease; (5) Pregnancy: continue chelation reduced dose; (6) Long-term: monitor 24h urine copper (target 200-500 on chelation; lower < 75 on maintenance), serum free copper (non-ceruloplasmin), LFT, CBC, urine analysis, neuro; (7) Multidisciplinary: hepatology + neurology + genetics + dietary; (8) Failure to treat = progression + death by age 40 typically; cure with transplant"},{"label":"C","text":"Iron chelation deferasirox"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Bisphosphonate"}]'::jsonb,
  'B', 'Wilson disease (hepatolenticular degeneration) — autosomal recessive ATP7B mutation; impaired biliary copper excretion + ceruloplasmin incorporation → copper accumulation in liver, brain, eye, kidney, joints. AASLD + EASL Wilson + Liver disease 2023 guideline: (1) Presentation age 5-35 typically: - Hepatic: chronic hepatitis, cirrhosis, acute liver failure (with Coombs-negative hemolysis + ↑ bilirubin/ALT ratio characteristic). - Neurologic: tremor, dysarthria, dystonia, parkinsonism, dysphagia, ataxia, behavioral, depression, mood. - Ocular: Kayser-Fleischer ring (Descemet membrane copper, slit lamp 95% neurologic, 50% hepatic-only). - Renal: Fanconi (proximal RTA), hypercalciuria, stones. - Hematologic: Coombs-neg hemolysis, AIHA mimic. - Cardiac: rare cardiomyopathy. - Skeletal/joint: arthritis, osteoporosis. (2) Diagnosis: Leipzig score combining KF ring, neuro Sx, ceruloplasmin, urine Cu, liver Cu, hemolysis. - Ceruloplasmin < 20 (low) — but 5-15% Wilson have normal; not pathognomonic. - 24h urine Cu > 100 (often > 200). - Hepatic Cu > 250 mcg/g dry weight (gold standard). - Genetic: ATP7B sequencing — > 500 mutations; many compound heterozygous. - MRI brain: T2 hyperintensity basal ganglia, brainstem, thalamus; "face of giant panda" midbrain. (3) Treatment: - Chelator first-line in symptomatic: D-penicillamine (older, effective but high SE) or trientine (better tolerated). Start low dose, titrate; pyridoxine with penicillamine. - Neurologic worsening with chelator (paradoxical) 20-50% — switch to trientine; some advocate trientine first in neuro-predominant. - Zinc: maintenance after chelator-induced decoppering; presymptomatic siblings; pregnancy (single agent). - Tetrathiomolybdate, ALXN1840 — newer copper chelators. - Acute fulminant: transplant; PLEX/MARS as bridge. (4) Diet: low copper (avoid liver, shellfish, nuts, chocolate, mushrooms, soy); copper-free vitamins; check water source. (5) Family screening: first-degree relatives; presymptomatic Rx prevents disease — saves lives. (6) Monitoring: urine Cu (target 200-500 on chelator; < 75 on Zn maintenance), serum free Cu (non-ceruloplasmin), LFT, CBC, urine analysis. (7) Pregnancy + breastfeeding: continue chelator at reduced dose. (8) Curative: liver transplant for fulminant or end-stage; corrects metabolic defect. (9) Differential: NASH, AIH, viral, drug, hemochromatosis (KF ring + low ceruloplasmin + hemolysis distinguishes).', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Practice Guideline on Wilson Disease 2023; EASL Wilson Disease Guideline 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 22 ปี ไม่มีโรค ตรวจสุขภาพ พบ LFT มี AST 88 + ALT 124 mild + ตัวเหลืองเล็กน้อย + tremor + dysarthria + พฤติกรรมเปลี่ยน + ปวดข้อ + ฮีโมจลบินูเรีย

PE: Kayser-Fleischer ring (slit lamp confirmed brown ring on cornea), mild tremor + dysarthria, mild splenomegaly
Lab: AST 88, ALT 124, ALP 65 (low), Bilirubin 2.4, INR 1.2, Albumin 3.6, Hb 10.2 (Coombs neg hemolysis), Cr 0.9
Ceruloplasmin 8 (low; normal 20-40), 24-hr urine copper 320 mcg (high; normal < 40), serum copper variable
Liver biopsy: hepatic copper > 250 mcg/g dry weight (high)
Genetic: ATP7B mutations (autosomal recessive)
MRI brain: T2 hyperintensity basal ganglia + brainstem (face of giant panda sign)
No family history (recessive)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปากแห้ง + ตาแห้ง + กลืนแห้ง + ปวดข้อ + อ่อนเพลีย 2 ปี + recurrent dental caries + recurrent parotid swelling

PE: dry mouth + sticky saliva, dry eyes + decreased tear, parotid mild bilateral swelling, no synovitis active
Lab: ANA 1:320, anti-SSA (Ro) positive, anti-SSB (La) positive, RF positive, IgG 2,400 (elevated), ESR 56, CRP 8
Schirmer test < 5 mm (positive ocular)
Sialography: sialectasis
Minor salivary gland biopsy (lip): focus score ≥ 1 (≥ 50 lymphocytes per 4 mm²)
No Raynaud, no rash, no lung involvement currently, no peripheral neuropathy, no CNS
No hepatitis, no HIV, no IgG4 disease, no SLE features
Fulfills ACR/EULAR 2016 Sjögren classification', '[{"label":"A","text":"Antibiotics chronic"},{"label":"B","text":"Primary Sjögren syndrome — Symptomatic + complication management (no disease-modifying cure): (1) **Ocular dryness**: artificial tears (preservative-free preferred); topical cyclosporine (Restasis) or lifitegrast — for chronic; punctal plug; humidifier; (2) **Oral dryness (xerostomia)**: sialagogue — pilocarpine 5 mg QID or cevimeline 30 mg TID (muscarinic agonists); saliva substitute; sugar-free gum/lozenge; meticulous oral hygiene + dental visit every 3-4 mo (high caries); avoid smoking + alcohol + drying meds; (3) **Hydroxychloroquine** — first-line systemic for arthritis, fatigue, glandular symptoms; modest evidence; ophthalmologic monitoring; (4) **Systemic disease**: arthritis (HCQ + MTX + low-dose pred), interstitial lung disease (steroid + azathioprine/MMF; rituximab for refractory), peripheral neuropathy (IVIG, rituximab), renal tubular acidosis (bicarb + K replacement), vasculitis (steroid + cyclophosphamide), CNS involvement (steroid + cyclophosphamide); (5) **Rituximab** for refractory/severe extraglandular (controversial efficacy in pure sicca; better for severe parotid, vasculitis, lymphoma); (6) Cancer surveillance: 4-44× ↑ MALT lymphoma + DLBCL risk — monitor lymphadenopathy + persistent salivary swelling + cytopenia + cryoglobulin + ↓ C4; suspect/biopsy persistent enlargement (7) Address comorbid autoimmune (thyroid, AIH, PBC, celiac); (8) Pregnancy planning: anti-SSA/SSB cross placenta → congenital heart block (1-2%) + neonatal lupus rash; serial fetal echo from 16-26 wk; HCQ continued in pregnancy"},{"label":"C","text":"Cyclophosphamide alone first-line"},{"label":"D","text":"Anti-TNF therapy"},{"label":"E","text":"Salivary gland radiation therapy"}]'::jsonb,
  'B', 'Sjögren syndrome — chronic autoimmune exocrinopathy + extraglandular manifestations. Primary (alone) vs secondary (with RA, SLE, scleroderma). ACR/EULAR 2016 criteria: focus score ≥ 1, anti-SSA/SSB, Schirmer, salivary flow, OSS staining. EULAR 2020 Sjögren management: (1) Sicca symptoms: - Ocular: artificial tears (preservative-free), topical cyclosporine, lifitegrast, punctal plug, ophth eval; - Oral: pilocarpine 5 mg QID or cevimeline 30 mg TID (muscarinic agonist); avoid antimuscarinic; saliva substitute; meticulous oral hygiene; (2) Systemic: - HCQ first-line for arthritis, fatigue, glandular; modest evidence; ophth monitor. - Arthritis: HCQ + MTX + low-dose pred. - ILD: MMF, AZA, rituximab; pirfenidone/nintedanib emerging. - PNS: IVIG, rituximab, steroid. - CNS: steroid, cyclophosphamide, rituximab. - RTA: bicarbonate + K. - Vasculitis: steroid + cyclophosphamide. (3) Refractory: rituximab (mixed efficacy; severe extraglandular better); abatacept; ianalumab (anti-BAFF — promising in trials). (4) Lymphoma risk: 4-44× ↑ MALT (parotid) + DLBCL; surveillance for persistent salivary swelling, lymphadenopathy, cryoglobulinemia, low C4, RF rise; biopsy persistent enlargement. (5) Pregnancy: anti-SSA/SSB → congenital heart block 1-2% + neonatal lupus rash; fetal echo serial 16-26 wk; HCQ continued, may reduce CHB recurrence. (6) Comorbid: hypothyroidism, AIH, PBC, celiac, fibromyalgia. (7) Avoid antimuscarinic + tricyclic.', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR/EULAR Classification Criteria for Sjögren 2016; EULAR Recommendations for Management of Sjögren 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปากแห้ง + ตาแห้ง + กลืนแห้ง + ปวดข้อ + อ่อนเพลีย 2 ปี + recurrent dental caries + recurrent parotid swelling

PE: dry mouth + sticky saliva, dry eyes + decreased tear, parotid mild bilateral swelling, no synovitis active
Lab: ANA 1:320, anti-SSA (Ro) positive, anti-SSB (La) positive, RF positive, IgG 2,400 (elevated), ESR 56, CRP 8
Schirmer test < 5 mm (positive ocular)
Sialography: sialectasis
Minor salivary gland biopsy (lip): focus score ≥ 1 (≥ 50 lymphocytes per 4 mm²)
No Raynaud, no rash, no lung involvement currently, no peripheral neuropathy, no CNS
No hepatitis, no HIV, no IgG4 disease, no SLE features
Fulfills ACR/EULAR 2016 Sjögren classification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี ไม่มีโรค มาด้วยอาการปวดท้องเรื้อรัง + ท้องเสียสลับท้องผูก + bloating > 6 เดือน + ดีขึ้นหลังถ่าย

No alarm: no weight loss, no rectal bleeding, no nocturnal symptom, no family history CRC/IBD, no anemia
No onset > 50 yr

Lab: CBC normal, ESR normal, CRP normal, TSH normal, celiac serology negative, fecal calprotectin 25 (normal — rules out IBD), stool ova/parasite + C. diff negative
Colonoscopy not indicated (no alarm)', '[{"label":"A","text":"Colonoscopy mandatory + biopsy"},{"label":"B","text":"Irritable Bowel Syndrome (Rome IV diagnostic, mixed type IBS-M): (1) Establish positive diagnosis (Rome IV: recurrent abdominal pain ≥ 1 d/wk × 3 mo + ≥ 2 of: relation to defecation, change in stool frequency, change in stool form) + exclude alarm features; (2) Strong therapeutic relationship + education + reassurance — Rx benefit; (3) Diet: - Low-FODMAP diet × 4-6 wk → reintroduce challenge; effective 50-75%. - Soluble fiber (psyllium) — IBS-C; insoluble (bran) may worsen. - Avoid trigger foods (caffeine, alcohol, fatty, gas-producing). - Lactose-free trial. (4) Pharm by predominant: - **IBS-C** (constipation): psyllium, PEG 3350, linaclotide (GC-C agonist), plecanatide, lubiprostone, tenapanor; - **IBS-D** (diarrhea): loperamide PRN, rifaximin × 14 d (TARGET trials — non-absorbable, alters microbiome), eluxadoline, bile acid sequestrant (cholestyramine if BAM); - **IBS-M** (mixed): individualized + may try both. - Pain: antispasmodic (hyoscine, dicyclomine, peppermint oil); TCA low-dose (amitriptyline, nortriptyline 10-50 mg qhs); SSRI/SNRI (fluoxetine, duloxetine); - Probiotics: limited evidence. (5) Psychological: CBT, gut-directed hypnotherapy — efficacious; for refractory + anxiety/depression comorbid. (6) Refractory: refer GI; consider further workup if new alarm features; revisit dx"},{"label":"C","text":"Long-term opioid for pain"},{"label":"D","text":"Empirical antibiotic"},{"label":"E","text":"Surgical bowel resection"}]'::jsonb,
  'B', 'Irritable Bowel Syndrome (IBS) — functional GI disorder; positive diagnosis with Rome IV. ACG 2021 IBS + Lacy Gastroenterology guideline: (1) Rome IV criteria + alarm features absent. (2) Alarm features warrant workup: age ≥ 50 onset, family Hx CRC/IBD/celiac, rectal bleeding, weight loss, anemia, nocturnal symptom, fever, abnormal physical exam. (3) Initial workup minimal in absent alarm: CBC, CRP, TSH, celiac serology, fecal calprotectin (< 50 effectively rules out IBD). (4) Colonoscopy not routine; reserved for alarm features or age-appropriate CRC screening. (5) Subtypes: IBS-D (diarrhea), IBS-C (constipation), IBS-M (mixed), IBS-U (unclassified). (6) Treatment by predominant: - IBS-C: psyllium, PEG, linaclotide, plecanatide, lubiprostone, tenapanor. - IBS-D: loperamide PRN, rifaximin 550 mg TID × 14 d (TARGET), eluxadoline (avoid in cholecystectomy + pancreatitis), cholestyramine (BAM). - IBS-M: combined approach. - Pain: antispasmodic (hyoscine, dicyclomine, peppermint oil), TCA low-dose, SSRI/SNRI. - Diet: low-FODMAP × 4-6 wk → reintroduce; soluble fiber. - Psychological: CBT, gut-directed hypnotherapy. (7) Avoid: long-term opioid (constipation, narcotic bowel syndrome). (8) Comorbid: anxiety, depression, fibromyalgia, migraine — manage. (9) Multifactorial: gut-brain axis, microbiome, visceral hypersensitivity, motility, immune.', NULL,
  'easy', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guideline: IBS 2021; AGA Guideline; Lacy BE et al. Rome IV', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 35 ปี ไม่มีโรค มาด้วยอาการปวดท้องเรื้อรัง + ท้องเสียสลับท้องผูก + bloating > 6 เดือน + ดีขึ้นหลังถ่าย

No alarm: no weight loss, no rectal bleeding, no nocturnal symptom, no family history CRC/IBD, no anemia
No onset > 50 yr

Lab: CBC normal, ESR normal, CRP normal, TSH normal, celiac serology negative, fecal calprotectin 25 (normal — rules out IBD), stool ova/parasite + C. diff negative
Colonoscopy not indicated (no alarm)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี ไม่มีโรค post-major abdominal surgery 5 d ago, on TPN ด้วย central line, broad-spectrum antibiotic × 7 d มา ED ด้วยไข้ + chills + ไม่ตอบ antibiotic + low BP

V/S: BP 96/58, HR 124, RR 22, SpO2 96%, Temp 38.6°C
Lab: WBC 18,200, Hb 11, Plt 188K, Cr 1.4, Lactate 2.6, procalcitonin 4
Blood culture × 2 (1 from peripheral + 1 from central line): both positive Candida albicans by MALDI-TOF; pending sensitivity; (1,3)-β-D-glucan 380 (elevated)
Fundoscopy: no chorioretinitis active currently
No prior antifungal
Echo: no vegetation', '[{"label":"A","text":"Fluconazole oral 200 mg/d"},{"label":"B","text":"Candidemia — IDSA 2016 candidiasis guideline: (1) **Echinocandin first-line**: caspofungin 70 mg LD then 50 mg/d, micafungin 100 mg/d, anidulafungin 200 mg LD then 100 mg/d — broad-spectrum + fungicidal + good safety + cover non-albicans + activity vs biofilm; (2) Step-down to fluconazole 400-800 mg/d after isolate identified as susceptible (most C. albicans, C. parapsilosis) + clinical improvement + negative repeat cultures; (3) Voriconazole or amphotericin B alternative; new agents — rezafungin (weekly), ibrexafungerp; (4) **Catheter removal** for catheter-associated candidemia (high recurrence + endocarditis risk if retained); if cannot remove, lock therapy + echinocandin; (5) Duration: 14 days from first negative blood culture + clinical resolution (uncomplicated); longer for: endocarditis (6 wk + surgery), endophthalmitis (4-6 wk), CNS, deep-seated, persistent fungemia; (6) Daily blood culture until negative; (7) Ophthalmology consult — fundoscopy week 1 (5-10% chorioretinitis — can affect duration + treatment choice — voriconazole or AmB if endophthalmitis); (8) Echo TTE/TEE — endocarditis screen especially if persistent + prosthetic valve; (9) Identify source (central line + GI + IV drug use + neutropenia); (10) De-escalate broad-spectrum antibacterial if possible (selection pressure); (11) Repeat imaging if persistent (hepatosplenic candidiasis common in neutropenic — hepatic abscess on US/CT); (12) Resistance considerations: C. glabrata + C. krusei — fluconazole-resistant; C. auris emerging multi-drug resistant"},{"label":"C","text":"Continue same antibiotic + observe"},{"label":"D","text":"Vancomycin + cefepime"},{"label":"E","text":"Antifungal not indicated"}]'::jsonb,
  'B', 'Candidemia — among most common hospital-acquired BSI; mortality 20-50%. IDSA 2016 candidiasis + ESCMID guideline: (1) Risk: prolonged ICU, central line, TPN, broad-spectrum antibiotics, abdominal surgery, neutropenia, immunosuppression, hemodialysis, diabetes. (2) Initial empirical antifungal (suspected): echinocandin until species + susceptibility known. (3) Definitive: - Echinocandin (caspofungin, micafungin, anidulafungin) — preferred for severe + non-albicans + critically ill. - Fluconazole 400-800 mg/d step-down for stable + susceptible (C. albicans, C. parapsilosis). - Voriconazole — alternative + endophthalmitis. - Amphotericin B (lipid form) — endocarditis, CNS, salvage. - Newer: rezafungin (weekly echinocandin), ibrexafungerp (oral), fosmanogepix. (4) Catheter removal — central line if catheter-associated; retention only if unable to remove + then echinocandin + lock. (5) Duration: 14 d from first negative blood culture + clinical resolution for uncomplicated; longer for deep-seated. (6) Daily blood culture until negative. (7) Ophthalmology (5-10% chorioretinitis), echo (endocarditis screen), imaging hepatosplenic candidiasis especially in neutropenic. (8) Species + resistance: C. glabrata (fluconazole resistant), C. krusei (intrinsic fluconazole resistance), C. parapsilosis (echinocandin less effective historically — recent data variable), C. auris (multi-drug resistant — increasing global), C. tropicalis. (9) Source: line, gut (translocation), UTI (urine candidiasis less serious; treat if symptomatic / pre-procedure / obstruction / immunocompromised), endocarditis (high mortality, requires surgery + long Rx). (10) Prophylaxis: high-risk surgical (recurrent GI perforation), hematologic malignancy + neutropenia (fluconazole or posaconazole), allogeneic SCT.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Clinical Practice Guideline for the Management of Candidiasis 2016; ESCMID Candida Guidelines 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 55 ปี ไม่มีโรค post-major abdominal surgery 5 d ago, on TPN ด้วย central line, broad-spectrum antibiotic × 7 d มา ED ด้วยไข้ + chills + ไม่ตอบ antibiotic + low BP

V/S: BP 96/58, HR 124, RR 22, SpO2 96%, Temp 38.6°C
Lab: WBC 18,200, Hb 11, Plt 188K, Cr 1.4, Lactate 2.6, procalcitonin 4
Blood culture × 2 (1 from peripheral + 1 from central line): both positive Candida albicans by MALDI-TOF; pending sensitivity; (1,3)-β-D-glucan 380 (elevated)
Fundoscopy: no chorioretinitis active currently
No prior antifungal
Echo: no vegetation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี ไม่มีโรค มาด้วย bone marrow aspirate: > 70% myeloblasts; flow: CD33+ CD13+ CD117+; cytogenetics t(8;21) RUNX1-RUNX1T1 fusion (core-binding factor AML, favorable cytogenetic); FLT3 + NPM1 negative

PB: WBC 56K with blasts 78%, Hb 7.4, Plt 28K; DIC panel normal; lipase normal; LDH 920, uric acid 9.6, K 5.0
Lumbar puncture: no blast in CSF
Echo LVEF 55%; HBsAg negative; HIV negative
No organ dysfunction
No recent infection', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Acute Myeloid Leukemia — Core-Binding Factor AML (favorable cytogenetic t(8;21)): (1) **Induction \"7+3\"**: cytarabine 100-200 mg/m²/d × 7 d (continuous infusion) + anthracycline (daunorubicin 60-90 mg/m²/d × 3 d or idarubicin 12 mg/m²/d × 3 d); add **gemtuzumab ozogamicin** (anti-CD33 ADC, GO) for favorable + intermediate risk (ALFA-0701 — improves OS in CBF AML); (2) Tumor lysis prophylaxis (allopurinol 300 mg, rasburicase for high WBC, hydration, monitor K/Phos/Uric/Ca); (3) **Hyperleukocytosis** (WBC > 100K, or > 50K with symptoms) — leukoreduction with hydroxyurea + leukapheresis if symptomatic; (4) Supportive: PRBC for Hb < 7-8 + symptomatic, platelet transfusion for Plt < 10K (or higher if bleeding/fever); antimicrobial prophylaxis (fluoroquinolone — controversial, fluconazole/posaconazole, acyclovir); neutropenic precautions; growth factor controversial post-induction (some advocate G-CSF for neutropenia); (5) Day 14 BM assessment + day 28 for remission; (6) **Consolidation high-dose cytarabine (HiDAC)** × 3-4 cycles for favorable (no transplant in CR1 needed); intermediate-risk: HiDAC × 3-4 OR allogeneic SCT in CR1; adverse risk: allogeneic SCT in CR1; (7) FLT3-mutated: add midostaurin (RATIFY) during induction + maintenance; quizartinib added 2023; (8) NPM1-mutated favorable: HiDAC consolidation. IDH1/IDH2 inhibitors (ivosidenib, enasidenib) in mutated; (9) Older/unfit: venetoclax + azacitidine/decitabine (VIALE-A trial — superior to HMA alone) — new standard for older/unfit; (10) MRD monitoring (FLT3, NPM1, CBF) qPCR — guides intensification + transplant; (11) Maintenance: oral azacitidine (CC-486, QUAZAR — older patients), midostaurin (FLT3) per protocol; (12) Acute Promyelocytic Leukemia (APL — t(15;17)) DIFFERENT: ATRA + arsenic, not 7+3 (already covered in batch 1)"},{"label":"C","text":"Single-agent imatinib"},{"label":"D","text":"Radiation therapy"},{"label":"E","text":"Outpatient observation"}]'::jsonb,
  'B', 'AML non-APL — standard 7+3 induction. ELN 2022 + NCCN AML + Döhner Blood guideline: (1) Diagnosis: PB or BM ≥ 20% blasts; flow + cytogenetics + molecular essential. (2) Risk stratification (ELN 2022): - Favorable: t(8;21), inv(16)/t(16;16) (CBF AML), NPM1 mutated without FLT3-ITD or with FLT3-ITD low ratio, biallelic CEBPA. - Intermediate: NPM1 + FLT3-ITD high ratio, no adverse, no favorable. - Adverse: complex karyotype, monosomy 5/7, MECOM, TP53, RUNX1, ASXL1, FLT3-ITD without NPM1, others. (3) Induction (fit): - 7+3 (cytarabine + daunorubicin/idarubicin). - Add GO (gemtuzumab ozogamicin, anti-CD33) for favorable + intermediate (ALFA-0701). - Add midostaurin (FLT3i) for FLT3-mutated (RATIFY). - Quizartinib for FLT3-ITD (QuANTUM-First). - CPX-351 (liposomal cytarabine + daunorubicin) for t-AML + AML-MRC. (4) Day 14 BM check + adjust; day 28 documented CR. (5) Consolidation (after CR): - Favorable: HiDAC × 3-4. - Intermediate: HiDAC or allo-SCT. - Adverse: allo-SCT in CR1. - FLT3+: ± maintenance midostaurin. (6) Older/unfit: venetoclax + azacitidine/decitabine (VIALE-A NEJM 2020) — new standard; or low-dose cytarabine + venetoclax. IDH inhibitors (ivosidenib, enasidenib) for IDH-mutated. (7) Supportive: TLS prophylaxis (allopurinol, rasburicase, hydration), transfusion (Hb < 7-8, Plt < 10K), antimicrobial prophylaxis, neutropenic precautions. (8) Hyperleukocytosis: leukapheresis + hydroxyurea + induction; ATRA for APL. (9) APL different: t(15;17) PML-RARA → ATRA + ATO ± anthracycline; DIC management. (10) MRD: NPM1, FLT3-ITD, CBF (RUNX1-RUNX1T1, CBFB-MYH11) by qPCR; flow cytometry. (11) Maintenance: oral azacitidine (CC-486, QUAZAR) in older CR1; midostaurin for FLT3; IDH inhibitors for IDH mutated. (12) Relapse: allo-SCT if not done; CPX-351; venetoclax-based; FLT3 inhibitor (gilteritinib — ADMIRAL); CAR-T trials.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ELN 2022 Recommendations for AML; NCCN Guidelines for AML 2024; VIALE-A NEJM 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี ไม่มีโรค มาด้วย bone marrow aspirate: > 70% myeloblasts; flow: CD33+ CD13+ CD117+; cytogenetics t(8;21) RUNX1-RUNX1T1 fusion (core-binding factor AML, favorable cytogenetic); FLT3 + NPM1 negative

PB: WBC 56K with blasts 78%, Hb 7.4, Plt 28K; DIC panel normal; lipase normal; LDH 920, uric acid 9.6, K 5.0
Lumbar puncture: no blast in CSF
Echo LVEF 55%; HBsAg negative; HIV negative
No organ dysfunction
No recent infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก reentry ใน AVNRT คืออะไร? และทำไม adenosine จึงหยุด arrhythmia ได้?"', '[{"label":"A","text":"AVNRT เกิดจาก ectopic pacemaker ใน atrium; adenosine หยุดผ่าน β-receptor"},{"label":"B","text":"AVNRT = reentrant circuit ใน AV node ด้วย fast + slow pathway (typical slow-fast: anterograde slow, retrograde fast); adenosine activates A1 adenosine receptor at AV node → opens K(ACh) channels → hyperpolarization + ↓ Ca current → transient AV nodal block (5-10 sec) → breaks reentry; SVT terminates; sinus rhythm restored; mechanism similar in AVRT (orthodromic via accessory pathway)"},{"label":"C","text":"Adenosine เป็น β-blocker"},{"label":"D","text":"AVNRT มาจาก ventricular focus"},{"label":"E","text":"Adenosine ทำให้ sodium channels เปิดมากขึ้น"}]'::jsonb,
  'B', 'AVNRT pathophysiology + adenosine mechanism: (1) AVNRT = most common PSVT (60%); reentrant circuit within AV node region uses dual pathways: slow pathway (anterograde) + fast pathway (retrograde) — "slow-fast typical AVNRT" 90%; atypical "fast-slow" 10%. (2) Adenosine: endogenous purine nucleoside; binds A1 adenosine receptors at AV node → Gi protein → opens IK(ACh) potassium channels → membrane hyperpolarization + ↓ slow inward Ca current → transient AV nodal conduction block lasting 5-10 sec → interrupts reentrant circuit. (3) Result: SVT terminates (effective in AVNRT + orthodromic AVRT — circuits involving AV node); some atrial tachycardias non-responsive; ventricular tachycardia not responsive (different mechanism + circuit). (4) Side effects: chest pain/discomfort, flushing, dyspnea, sense of impending doom, bronchospasm in asthma, AV block prolonged in patients on AV-blocker. Short half-life (10 sec) — give rapid IV bolus 6 mg followed by saline flush (large vein, central preferred). (5) Diagnostic value: when adenosine doesn''t terminate but slows conduction, may reveal underlying flutter waves or atrial tachycardia — diagnostic.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'basic_science', 'cardiovascular', 'adult',
  'Goodman & Gilman''s Pharmacology; Ganong''s Physiology; Issa Z. Clinical Arrhythmology and Electrophysiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก reentry ใน AVNRT คืออะไร? และทำไม adenosine จึงหยุด arrhythmia ได้?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไกการดื้อยา β-lactam ใน Gram-negative bacteria เช่น ESBL + carbapenemase คืออะไร?"', '[{"label":"A","text":"Drug efflux pump เท่านั้น"},{"label":"B","text":"ESBL (Extended-Spectrum β-Lactamases): plasmid-encoded enzymes hydrolyze penicillins + 3rd-gen cephalosporins + monobactam (aztreonam); inhibited by clavulanate + tazobactam + avibactam. Common families: TEM, SHV, CTX-M (most prevalent). E. coli + Klebsiella main producers. Carbapenemase (Carbapenem-Resistant Enterobacterales — CRE): hydrolyze almost all β-lactams including carbapenems; classes — Class A serine (KPC), Class B metallo-β-lactamase (NDM, IMP, VIM — divalent zinc; not inhibited by clavulanate or avibactam), Class D OXA-48-type serine (oxacillinase). Treatment: ESBL — carbapenem (meropenem) or ceftolozane-tazobactam; CRE — ceftazidime-avibactam (KPC + OXA-48), meropenem-vaborbactam (KPC), imipenem-relebactam (KPC), cefiderocol (siderophore cephalosporin, broad CRE + Pseudomonas + Stenotrophomonas + Acinetobacter), polymyxin (colistin — nephrotoxic; combination), tigecycline (Stenotrophomonas, complicated abd/skin), aztreonam + avibactam for MBL. Other resistance: porin loss (OmpF/OmpK35), efflux pump (AcrAB-TolC), modified PBP"},{"label":"C","text":"Methylation of 23S rRNA"},{"label":"D","text":"Aminoglycoside-modifying enzymes"},{"label":"E","text":"Vancomycin resistance via vanA"}]'::jsonb,
  'B', 'β-lactam resistance mechanisms — major focus in MDR Gram-negative crisis (CRE, MDR Pseudomonas, Acinetobacter). Mechanisms: (1) β-lactamase enzymes (most common): - Class A (serine): ESBL (TEM, SHV, CTX-M), KPC carbapenemase. - Class B (metallo, MBL, zinc-dependent): NDM, VIM, IMP — hydrolyze all β-lactams except aztreonam; resistant to clavulanate, avibactam, vaborbactam. - Class C (AmpC, serine): chromosomal in many Enterobacterales; inducible (CESP — Citrobacter, Enterobacter, Serratia, Providencia). - Class D (serine): OXA-48-type carbapenemase (Klebsiella); OXA-23/40/58 in Acinetobacter. (2) Porin loss (OmpC, OmpF, OmpK35/36) — reduced antibiotic penetration; common with ESBL + AmpC. (3) Efflux pumps: AcrAB-TolC (Enterobacterales), MexAB-OprM (Pseudomonas). (4) Modified PBP: low affinity (PBP3 modification in some). Treatment options: - ESBL: carbapenem (meropenem) preferred; ceftolozane-tazobactam alternative. - CRE: ceftazidime-avibactam (KPC, OXA-48; NOT MBL alone), meropenem-vaborbactam (KPC), imipenem-relebactam (KPC), cefiderocol (broad CRE inc MBL, MDR Pseudo + Acinetobacter), polymyxin (colistin — last-line, nephrotoxic, combination), tigecycline (Stenotrophomonas, complicated abdominal). - MBL: aztreonam + avibactam combo (avibactam protects aztreonam from MBL hydrolysis; aztreonam not hydrolyzed by MBL). - Antimicrobial stewardship + source control + infection prevention essential.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'IDSA Antibiotic-Resistant Gram-Negative Infection Treatment Guidance 2023; Bush K — β-lactamase classification + carbapenemase review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไกการดื้อยา β-lactam ใน Gram-negative bacteria เช่น ESBL + carbapenemase คืออะไร?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก insulin resistance ใน type 2 DM + obesity คืออะไร? และทำไม metformin + SGLT2i จึงมีประสิทธิภาพต่างกัน?"', '[{"label":"A","text":"Pancreatic beta-cell autoimmune destruction"},{"label":"B","text":"T2DM pathophysiology = (1) Insulin resistance (peripheral muscle + liver + adipose): reduced insulin signaling — defective IRS-1/2 phosphorylation, PI3K/AKT pathway impairment; ectopic lipid accumulation (intramyocellular triglyceride, hepatic steatosis) → lipotoxicity → ↓ GLUT4 translocation to membrane → ↓ glucose uptake; adipose inflammation (M1 macrophage infiltration, TNF-α, IL-6, adipokines — leptin resistance, low adiponectin) → systemic insulin resistance; hyperinsulinemia compensatory then beta-cell failure (apoptosis, dedifferentiation). (2) Hepatic glucose production unsuppressed → fasting hyperglycemia. (3) Incretin defect (GLP-1, GIP) reduced. (4) Renal glucose reabsorption increased (SGLT2 upregulated). **Metformin**: activates AMPK → suppresses hepatic gluconeogenesis (primary mechanism) + ↑ peripheral insulin sensitivity; minimal direct insulin effect; no hypoglycemia; weight neutral/mild loss; CV neutral-favorable. **SGLT2 inhibitors** (dapagliflozin, empagliflozin, canagliflozin): block SGLT2 in proximal tubule → glucosuria → ↓ blood glucose + osmotic diuresis + natriuresis → weight loss + BP ↓; INDEPENDENT of insulin (works regardless of insulin sensitivity/secretion); CV + renal protection (DAPA-HF, EMPA-REG, EMPA-KIDNEY, DAPA-CKD trials) — possibly via myocardial energy substrate shift, anti-inflammatory, anti-fibrotic, sympathetic, RAAS modulation, ketone metabolism; SE: UTI/GU mycotic infection, euglycemic DKA (rare), volume depletion, fournier gangrene, fracture (canagliflozin)"},{"label":"C","text":"Acetylcholine deficiency"},{"label":"D","text":"Adrenal hyperplasia"},{"label":"E","text":"Thyroid hormone excess"}]'::jsonb,
  'B', 'T2DM pathophysiology + mechanisms of metformin + SGLT2i. Ominous Octet (DeFronzo): (1) β-cell dysfunction; (2) muscle insulin resistance; (3) hepatic insulin resistance + ↑ HGP; (4) adipose lipolysis ↑; (5) incretin effect ↓ (GLP-1, GIP); (6) α-cell glucagon ↑; (7) renal glucose reabsorption ↑; (8) neurotransmitter dysfunction. Insulin signaling cascade: insulin → IR receptor tyrosine kinase → IRS-1/2 → PI3K → AKT → GLUT4 translocation; defect anywhere causes resistance. Lipotoxicity: ectopic triglyceride (muscle, liver) impairs signaling. Inflammation: TNF-α, IL-6, MCP-1 from adipose macrophages → systemic IR. Adipokines: leptin (resistance), adiponectin (↓), resistin. Metformin: biguanide; activates AMPK → ↓ hepatic gluconeogenesis (suppress G6Pase + PEPCK), ↓ FA synthesis, ↑ FA oxidation, ↑ insulin sensitivity peripherally; mild GLP-1 effect; no hypoglycemia; vit B12 deficiency long-term; lactic acidosis very rare (avoid in eGFR < 30); preferred first-line oral. SGLT2 inhibitor: blocks proximal tubule SGLT2 → glucosuria 60-80 g/d → ↓ glucose + weight + BP; cardiovascular + renal protection (multiple trials — mechanism via natriuresis, preload ↓, sympathetic, ketone, anti-fibrotic, energy substrate); approved HFrEF, HFpEF, CKD, T2DM, prevent T2DM. Adverse: GU infection (UTI, candidiasis), volume depletion, euglycemic DKA (with insulin reduction, illness, surgery, dehydration), Fournier gangrene (rare), foot amputation + fracture (canagliflozin signal). GLP-1 RA + dual/triple incretin therapy (semaglutide, tirzepatide, retatrutide — emerging) — different mechanism (incretin, weight, CV, renal).', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'DeFronzo RA — Ominous Octet Diabetes 2009; ADA Pathogenesis of T2DM; Kahn SE Diabetes; Verma S + McMurray DM Lancet 2019 (SGLT2i mechanisms)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก insulin resistance ใน type 2 DM + obesity คืออะไร? และทำไม metformin + SGLT2i จึงมีประสิทธิภาพต่างกัน?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไกของ thalassemia + กรณีของ alpha vs beta thalassemia ในคนไทยและ Asian population — molecular basis + clinical phenotype distinction?"', '[{"label":"A","text":"Thalassemia เกิดจาก iron deficiency"},{"label":"B","text":"Thalassemia = quantitative defect of globin chain production. **α-thalassemia**: defect in α-globin gene (chromosome 16); 4 α-genes (αα/αα); deletion is common: silent carrier (-α/αα), α-thal trait (--/αα or -α/-α), HbH disease (--/-α — 3 deletions, moderate-severe hemolytic anemia + β4 tetramer HbH precipitates), Hb Bart hydrops fetalis (--/-- 4 deletions, intrauterine death from γ4 tetramer). Common in SE Asia + Mediterranean + Africa. **β-thalassemia**: defect in β-globin gene (chromosome 11); mutations include point mutation (most common), promoter, splice, frameshift, nonsense. Heterozygous = β-thal trait (β/β⁰ or β/β⁺) — mild anemia + microcytosis + ↑ HbA2 (> 3.5%). Homozygous severe β-thal major (Cooley) = transfusion-dependent + iron overload + extramedullary hematopoiesis + bony deformity. β-thal intermedia = moderate. Hb E/β-thal = common in Thailand (Hb E from β-globin gene mutation E26K + β-thal trans-heterozygote) — clinically severe variable phenotype. Diagnosis: CBC + indices (microcytosis MCV < 80 + elevated RBC count + Mentzer index MCV/RBC < 13 favors thal), Hb electrophoresis or HPLC (HbA2, HbF, HbE, HbH), DNA analysis. Management: transfusion + iron chelation (deferasirox, deferoxamine, deferiprone), hydroxyurea (HbF inducer for β-thal intermedia + HbE/β), splenectomy selected, allogeneic SCT (curative pediatric), luspatercept (TGF-β superfamily ligand trap — REBLOZYL — transfusion-dependent β-thal), gene therapy/editing (Casgevy CRISPR exa-cel for transfusion-dependent β-thal — FDA 2024), prenatal screening + counseling in high-prevalence areas (Thailand National Thalassemia Prevention Program)"},{"label":"C","text":"Thalassemia เกิดจาก autoimmune RBC destruction"},{"label":"D","text":"Defect ใน hepcidin synthesis"},{"label":"E","text":"Bone marrow failure"}]'::jsonb,
  'B', 'Thalassemia — heritable hemoglobinopathy; quantitative globin chain imbalance. Crucial topic in Thai medical board given high prevalence in SE Asia. (1) Globin genetics: α-genes — 2 copies each on chromosome 16 (4 total αα/αα); β-gene — 1 copy each on chromosome 11 (2 total β/β). (2) α-thalassemia (mostly deletions): - Silent carrier (-α/αα): asymptomatic, normal CBC. - α-thal trait (--/αα or -α/-α): mild microcytic anemia, MCV ↓, RBC count ↑. - HbH disease (--/-α): moderate hemolytic anemia + HbH (β4 tetramer) inclusion bodies; bone changes mild. - Hb Bart hydrops fetalis (--/--): intrauterine death from γ4 tetramer; high-affinity, can''t deliver O2. - SE Asia high prevalence; cis-deletion (--/) Asian; trans (-α/-α) African. (3) β-thalassemia (mostly point mutations): - β-thal trait (β/β⁺ or β/β⁰): mild microcytic anemia, ↑ RBC, ↑ HbA2 (> 3.5%), normal-↑ HbF; usually asymptomatic. - β-thal intermedia: moderate anemia, transfusion-independent or rare; clinical phenotype variable. - β-thal major (Cooley): severe transfusion-dependent (from infancy), bony deformity, extramedullary hematopoiesis, hepatosplenomegaly, growth retardation, iron overload from transfusion → death without chelation. - HbE/β-thal (compound heterozygote): COMMON in Thailand; phenotype variable mild to severe; HbE = β26 Glu→Lys mutation reducing β chain synthesis + structural defect. (4) Diagnosis: - CBC: microcytosis MCV < 80, normochromic-hypochromic, ↑ RBC count, Mentzer index < 13. - Hb electrophoresis/HPLC: distinguishes HbA, HbA2, HbF, HbE, HbS, HbC, HbH. - DNA analysis: PCR for common α-deletions; sequencing for β-mutations. - Iron studies (rule out coexistent IDA which masks thalassemia indices). (5) Management: - Transfusion (β-thal major): maintain Hb > 9-10 to suppress erythropoiesis + prevent bony changes. - Iron chelation (essential with transfusion): deferasirox PO (Exjade, Jadenu), deferoxamine SC (slow), deferiprone PO (agranulocytosis risk). - Splenectomy: selected hypersplenism + ↑ transfusion need. - Hydroxyurea: HbF inducer; some benefit in β-thal intermedia, HbE/β, HbH. - Luspatercept (Reblozyl): TGF-β ligand trap; reduces transfusion in transfusion-dependent β-thal. - Allogeneic SCT: curative in children with matched sibling. - Gene therapy: betibeglogene autotemcel (Zynteglo) for non-β⁰/β⁰ TDT; CRISPR Cas9 exagamglogene autotemcel (Casgevy) for TDT — FDA 2024. - Vaccination + endocrine surveillance (chelation effective era — heart, liver, pancreas iron) - DXA. (6) Prenatal screening: Thailand National Program — couples screened (MCV, Hb typing); at-risk offered fetal sampling + selective termination prevents β-thal major + Hb Bart hydrops; major public health success.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'TIF Guidelines Thalassemia Major 2022; Thai Hemoglobinopathy Guideline; Weatherall DJ — Thalassemia syndromes', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไกของ thalassemia + กรณีของ alpha vs beta thalassemia ในคนไทยและ Asian population — molecular basis + clinical phenotype distinction?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก renal acid-base — distal RTA Type 1, proximal RTA Type 2, Type 4 distinguishing features?"', '[{"label":"A","text":"All RTA same pathophysiology + treatment"},{"label":"B","text":"**RTA Type 1 (distal)**: α-intercalated cell defect → impaired H+ secretion → urine cannot acidify (urine pH > 5.5 with acidemia); hypokalemia (K wasting from Na+/K+ exchange compensation); hypercalciuria + nephrolithiasis + nephrocalcinosis; metabolic acidosis with **normal anion gap** (hyperchloremic); positive urine anion gap (Na + K - Cl positive = low NH4+ excretion); etiology — Sjögren syndrome (most common acquired), RA, SLE, ethylene glycol, amphotericin, lithium, hereditary (SLC4A1, ATP6V1B1/V0A4). Tx: alkali therapy (sodium bicarbonate or potassium citrate). **RTA Type 2 (proximal)**: proximal tubular HCO3 reabsorption defect → bicarbonate wasting + secondary hypokalemia; urine pH can acidify (urine pH < 5.5 when bicarb low); hyperchloremic acidosis; often part of Fanconi syndrome (glucosuria, aminoaciduria, phosphaturia, uricosuria, low molecular weight proteinuria); etiology — multiple myeloma (light chain), drugs (acetazolamide, tenofovir, cidofovir, ifosfamide, valproate, expired tetracycline), heavy metals (lead, mercury, cadmium), Wilson disease, cystinosis, hereditary. Tx: large doses of bicarbonate (10-25 mEq/kg/d — high dose because of wasting) + K replacement + thiazide (paradoxical to lower urine bicarb loss). **RTA Type 4 (hypoaldosteronism)**: aldosterone deficiency or resistance → impaired Na+ reabsorption + H+ + K+ secretion → hyperkalemia + mild hyperchloremic acidosis; urine pH variable usually < 5.5; etiology — DM (most common; hyporenin hypoaldosteronism), ACEi/ARB, MRA (spironolactone), heparin, calcineurin inhibitor (cyclosporine, tacrolimus), TMP, NSAID, primary adrenal insufficiency, hereditary (pseudohypoaldosteronism type 1). Tx: fludrocortisone if mineralocorticoid deficient; loop diuretic + dietary K restriction + K binders; stop offending drugs"},{"label":"C","text":"All RTA cause hyperkalemia"},{"label":"D","text":"All RTA cause respiratory acidosis"},{"label":"E","text":"All RTA managed identically with bicarbonate alone"}]'::jsonb,
  'B', 'Renal tubular acidosis (RTA) — disorders of acid handling causing normal anion gap (hyperchloremic) metabolic acidosis. Key differentiation: (1) **Type 1 (distal, hypokalemic)**: α-intercalated cell defect → impaired H+ secretion → urine pH > 5.5 despite acidemia. Hypokalemia. Hypercalciuria + nephrocalcinosis + stones. Positive UAG (urine Na + K - Cl > 0 = low NH4+ excretion). Causes: Sjögren (most common acquired), autoimmune (RA, SLE), drugs (lithium, amphotericin), hereditary (SLC4A1 AE1, V-ATPase subunit). Tx: alkali (K citrate preferred — replaces K + provides alkali; or NaHCO3 0.5-2 mEq/kg/d). (2) **Type 2 (proximal)**: proximal tubular HCO3 reabsorption defect → wasting + secondary hypokalemia. Urine pH can acidify when serum bicarb low (< 17). Hyperchloremic acidosis. Often part of Fanconi (glucosuria with normal blood sugar, aminoaciduria, phosphaturia, uricosuria, LMW proteinuria). Causes: multiple myeloma (light chain), drugs (acetazolamide, tenofovir, cidofovir, ifosfamide, valproate, expired tetracycline), heavy metals (lead, mercury, cadmium), Wilson, cystinosis, hereditary. Tx: high-dose bicarb (10-25 mEq/kg/d), K replacement, thiazide (paradoxical — induces volume contraction → ↓ urine bicarb loss). (3) **Type 4 (hyperkalemic, hypoaldosteronism)**: aldosterone deficiency or resistance → ↓ Na reabsorption + ↓ H+/K+ secretion. Hyperkalemia. Mild acidosis. Urine pH variable. Causes: diabetic kidney (hyporenin hypoaldosteronism — most common), ACEi/ARB, MRA, heparin, calcineurin inhibitor (cyclosporine, tacrolimus), TMP, NSAID, adrenal insufficiency, pseudohypoaldosteronism. Tx: fludrocortisone if mineralocorticoid deficient; loop diuretic + K restriction + K binders (patiromer, sodium zirconium cyclosilicate); stop offending drugs. (4) Diagnostic workup: serum chemistry (Na, K, Cl, HCO3, glucose), urine pH (after acid loading if equivocal), urine anion gap (UAG), urine osmolal gap, fractional excretion of bicarbonate (FE-HCO3), serum aldosterone + renin, autoimmune workup. (5) Type 3 RTA — combined proximal + distal; rare; in carbonic anhydrase II deficiency (osteopetrosis with renal stones + cerebral calcification). (6) Workup any normal anion gap acidosis: confirm with bicarbonate gap calculation, urine anion gap, urine pH; consider RTA + GI losses (diarrhea — UAG negative).', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'basic_science', 'renal_gu', 'adult',
  'Kraut JA + Madias NE NEJM 2014 — Metabolic Acidosis; Brenner & Rector''s The Kidney; Soriano JR Pediatric RTA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก renal acid-base — distal RTA Type 1, proximal RTA Type 2, Type 4 distinguishing features?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก coagulation cascade + thrombophilia (factor V Leiden, prothrombin G20210A, protein C/S, antithrombin, antiphospholipid)?"', '[{"label":"A","text":"Coagulation มี 1 pathway เท่านั้น"},{"label":"B","text":"Coagulation cascade: classic teaching = extrinsic (tissue factor → VIIa) + intrinsic (XII → XIa → IXa) → common (Xa + Va → thrombin (IIa) → fibrin from fibrinogen); cell-based model — initiation (TF on extravascular cell), amplification (platelet activation, thrombin burst), propagation (massive fibrin generation). Anticoagulant systems: antithrombin (inhibits IIa, IXa, Xa, XIa — enhanced by heparin), protein C/S (activated by thrombin-thrombomodulin → degrades Va, VIIIa), TFPI (tissue factor pathway inhibitor — inhibits TF/VIIa/Xa). Fibrinolysis: tPA → plasminogen → plasmin → fibrin degradation. **Thrombophilia**: (1) Factor V Leiden — G1691A mutation; activated protein C resistance (Va not degraded); heterozygous 5× VTE, homozygous 50-80×; common European Caucasian, rare Asian. (2) Prothrombin G20210A — 3'' UTR mutation → ↑ prothrombin; 3× VTE. (3) Protein C deficiency: autosomal dominant; warfarin-induced skin necrosis if started without heparin (transient procoagulant state). (4) Protein S deficiency: vit K dependent. (5) Antithrombin deficiency: severe form rare; heparin resistance. (6) Antiphospholipid syndrome (APS): acquired; lupus anticoagulant, anti-cardiolipin, anti-β2-GP1 (× 2 separated 12 wk); arterial + venous thrombosis + recurrent pregnancy loss; treat with warfarin (DOAC inferior per TRAPS in triple-positive). (7) Other: dysfibrinogenemia, MPN (JAK2), PNH, MTHFR variants (controversial), hyperhomocysteinemia, OCP/HRT/pregnancy. Workup timing: 2-4 wk after acute event, off DOAC ≥ 2 wk, off warfarin ≥ 3-4 wk; protein C/S unreliable during acute thrombosis or warfarin. Indications: unprovoked < 50 yr, family Hx, recurrent VTE, unusual sites (cerebral, splanchnic), pregnancy/OCP/HRT-related, multiple losses, arterial thrombosis in young"},{"label":"C","text":"Factor V Leiden เพิ่ม fibrinolysis"},{"label":"D","text":"APS เป็น hemorrhage syndrome"},{"label":"E","text":"Protein C/S activate clotting"}]'::jsonb,
  'B', 'Coagulation cascade + thrombophilia — core hematology topic. (1) Coagulation cell-based model (modern): - Initiation: TF on subendothelial fibroblast/extravascular cell binds VIIa → activates X and IX → small Xa → small thrombin. - Amplification: small thrombin activates platelets, V → Va, VIII → VIIIa, XI → XIa. - Propagation: on activated platelet surface, IXa + VIIIa = tenase → activates X massively; Xa + Va = prothrombinase → thrombin burst → fibrinogen → fibrin → cross-linked fibrin by XIIIa. (2) Anticoagulant systems: - Antithrombin (AT): serine protease inhibitor; inhibits IIa, IXa, Xa, XIa, XIIa; heparin enhances 1000×. - Protein C (vit K dependent zymogen): activated by thrombin-thrombomodulin (endothelial) → APC degrades Va, VIIIa; requires Protein S cofactor. - TFPI: inhibits TF/VIIa/Xa. (3) Fibrinolysis: plasminogen (endothelial) → plasmin (by tPA + urokinase) → degrades fibrin → FDP + D-dimer. (4) Inherited thrombophilia: - Factor V Leiden (FVL): G1691A → R506Q; FVa resistant to APC; heterozygous prevalence 5-7% Caucasian; 5× VTE risk; homozygous 50-80×. - Prothrombin G20210A: 3''UTR mutation; ↑ prothrombin level; 3× VTE. - Protein C deficiency (heterozygous): autosomal dominant; warfarin skin necrosis if started without heparin bridging (transient procoagulant from earlier protein C drop). - Protein S deficiency: vit K dependent cofactor of protein C. - Antithrombin deficiency: severe; heparin resistance (need higher dose). - Dysfibrinogenemia. (5) Acquired thrombophilia: - Antiphospholipid syndrome: arterial + venous thrombosis + pregnancy loss; criteria — clinical (thrombosis or pregnancy morbidity) + lab (lupus anticoagulant, anti-cardiolipin IgG/IgM, anti-β2-GP1 IgG/IgM) × 2 separated 12 wk; warfarin INR 2-3 (TRAPS — DOAC inferior in triple-positive arterial APS); LMWH + aspirin in pregnancy. - MPN (JAK2 — splanchnic thrombosis). - PNH (CD55/CD59 deficient — Bjorndal triad: thrombosis, hemolysis, marrow failure; eculizumab). - Active malignancy. - Hormonal: pregnancy, OCP, HRT, tamoxifen. - HIT (heparin-induced thrombocytopenia type II — antibody to PF4/heparin complex; severe paradoxical thrombosis). - Sticky platelet syndrome. (6) Investigation timing + indication: - 2-4 wk after acute event (acute consumption); off DOAC ≥ 2 wk; off warfarin ≥ 3-4 wk (protein C/S unreliable during warfarin). - Indications: unprovoked age < 50, strong family Hx, recurrent VTE, unusual sites (splanchnic, cerebral), pregnancy/OCP/HRT-related, recurrent pregnancy loss, arterial thrombosis in young, multiple losses. - APS testing: include all three; thrombosis + pregnancy criteria. (7) MTHFR + hyperhomocysteinemia: controversial; routine testing not recommended (insufficient evidence for VTE association after lipid + B vit correction).', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'Hoffman M + Monroe DM — Cell-based model of hemostasis; ASH Education thrombophilia; Sciascia S APS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก coagulation cascade + thrombophilia (factor V Leiden, prothrombin G20210A, protein C/S, antithrombin, antiphospholipid)?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก hypersensitivity reactions (Gell-Coombs I-IV) + clinical examples and management approach?"', '[{"label":"A","text":"All hypersensitivity is the same"},{"label":"B","text":"Gell-Coombs classification: **Type I (immediate, IgE-mediated)**: IgE bound to mast cell/basophil; antigen cross-linking → degranulation → histamine + leukotrienes + tryptase → vasodilation, bronchospasm, urticaria, anaphylaxis; onset minutes; e.g., anaphylaxis to penicillin/peanut/insect sting, allergic rhinitis, asthma, atopic dermatitis. Treatment: epinephrine IM (anaphylaxis), H1/H2 blockers, glucocorticoid, β2-agonist, airway. **Type II (cytotoxic, IgG/IgM)**: antibody binds cell surface antigen → complement-mediated lysis, opsonization, ADCC; e.g., AIHA (warm + cold), ITP, drug-induced cytopenia (penicillin, methyldopa), HDFN (Rh, ABO), Goodpasture (anti-GBM), Graves (TSI), MG (AchR Ab), pemphigus. Treatment: steroid, IVIG, plasmapheresis, rituximab. **Type III (immune complex)**: Ag-Ab complexes deposit in tissue → complement + neutrophil → inflammation; e.g., serum sickness, SLE, post-streptococcal GN, hypersensitivity pneumonitis, Henoch-Schönlein purpura (IgA vasculitis); onset 1-3 wk. Treatment: steroid + immunosuppression + plasmapheresis selected. **Type IV (delayed, T-cell mediated)**: sensitized T cells release cytokines → macrophage activation, CD8 cytotoxicity; onset 48-72 hr (delayed); e.g., contact dermatitis (poison ivy, nickel), tuberculin skin test/Mantoux, Type 1 DM (β-cell), MS, RA, GVHD, allograft rejection, SJS/TEN, DRESS, AGEP. Treatment: avoidance + topical/systemic steroid + identification trigger + drug avoidance + desensitization for some severe SCAR (Stevens-Johnson Syndrome/Toxic Epidermal Necrolysis — withdrawal + supportive ICU + immunoglobulin/cyclosporine — high mortality)"},{"label":"C","text":"Type I = delayed reaction"},{"label":"D","text":"Type IV = IgE-mediated"},{"label":"E","text":"All managed with antihistamine alone"}]'::jsonb,
  'B', 'Gell-Coombs hypersensitivity classification — core immunology. Modern adaptations include sub-classification but classical 4 types essential. (1) **Type I (immediate, IgE-mediated)**: Mechanism: IgE bound to mast cell/basophil FcεRI; antigen cross-linking → degranulation → histamine + LTC4/D4/E4 + PGD2 + tryptase + cytokines → vasodilation, ↑ vascular permeability, smooth muscle contraction, mucus, leukocyte recruitment. Onset: minutes (immediate); late phase 4-24 hr. Examples: anaphylaxis (peanut, penicillin, latex, hymenoptera, contrast), allergic rhinitis, allergic asthma, atopic dermatitis, urticaria. Diagnosis: skin prick test, specific IgE (RAST), tryptase (anaphylaxis acute + baseline ratio in mastocytosis). Treatment: avoidance, antihistamine (H1 + H2), epinephrine IM 0.3-0.5 mg q5-15 min for anaphylaxis, glucocorticoid, β2-agonist for bronchospasm, immunotherapy (allergen desensitization for select), biologic (omalizumab anti-IgE; mepolizumab anti-IL5). (2) **Type II (cytotoxic, antibody-mediated)**: Mechanism: IgG/IgM binds cell-surface antigen → complement activation (MAC), opsonization, ADCC by NK/macrophage, receptor activation/blockade. Examples: AIHA (warm, cold), drug-induced cytopenia (penicillin → AIHA; quinine → ITP; methyldopa), HDFN (anti-D, ABO), Goodpasture (anti-GBM type IV collagen α3), Graves (TSI agonist), MG (AchR Ab blocking + degrading), pemphigus vulgaris (anti-desmoglein), pernicious anemia (anti-IF, anti-parietal cell), rheumatic fever cross-reactivity, hyperacute transplant rejection. Diagnosis: direct Coombs (DAT), specific Ab. Treatment: steroid, IVIG, plasmapheresis, rituximab, splenectomy (AIHA), anti-complement (eculizumab for some). (3) **Type III (immune complex)**: Mechanism: Ag-Ab soluble complexes deposit in vessels, glomeruli, joints, alveoli → complement + neutrophil → vasculitis/inflammation. Examples: serum sickness (foreign protein, hetero-Ig — onset 1-3 wk; arthralgia, urticaria, lymphadenopathy, GN), SLE (multiple deposit sites — kidney, skin, joints, CNS), post-streptococcal GN, IgA nephropathy/HSP, hypersensitivity pneumonitis (acute), cryoglobulinemia (with HCV), Arthus reaction (local). Diagnosis: complement (↓C3, ↓C4), specific Ab, immune complex assays, biopsy with IF. Treatment: avoid antigen, steroid + immunosuppression, plasmapheresis selective. (4) **Type IV (delayed, T-cell mediated)**: Mechanism: sensitized CD4 Th1 cells release cytokines (IFN-γ, TNF) → macrophage activation; CD8 cytotoxic T cells; granuloma in chronic. Onset 48-72 hr (delayed). Subtypes: IVa (Th1/macrophage — contact, tuberculin), IVb (Th2/eosinophil — chronic asthma, atopic dermatitis chronic), IVc (cytotoxic T — SJS/TEN), IVd (Th17/neutrophil — AGEP). Examples: contact dermatitis (nickel, poison ivy), tuberculin/Mantoux/IGRA, granulomatous (TB, sarcoidosis), Type 1 DM β-cell autoimmunity, MS, RA (Th17), GVHD, chronic graft rejection, SJS/TEN, DRESS (drug — anticonvulsant, allopurinol, sulfa), AGEP, fixed drug eruption. Diagnosis: patch testing (delayed reaction), IGRA, histology granuloma, drug eosinophilia + organ involvement (DRESS). Treatment: avoid trigger, topical/systemic steroid, immunosuppression, biologic (TNF-i, IL-17 etc.); SJS/TEN/DRESS — drug withdrawal + ICU supportive + IVIG/cyclosporine/etanercept (severe SCAR); HLA testing for high-risk drugs (carbamazepine + HLA-B*1502 Asian; allopurinol + HLA-B*5801 Asian — pre-prescription screening recommended).', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'Janeway''s Immunobiology; Gell PGH + Coombs RRA Classification; Abbas + Lichtman Cellular and Molecular Immunology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก hypersensitivity reactions (Gell-Coombs I-IV) + clinical examples and management approach?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก lipid metabolism + statin + PCSK9 inhibitor — molecular mechanism + why high-intensity statin reduces ASCVD events?"', '[{"label":"A","text":"Statin works as anti-inflammatory only"},{"label":"B","text":"Lipid metabolism: exogenous (dietary fat) → chylomicron → CM remnant → liver; endogenous — liver synthesizes VLDL (TG-rich) → IDL → LDL (cholesterol-rich) → cellular LDL receptor uptake; reverse cholesterol transport — HDL picks up peripheral cholesterol → liver via SR-B1 + LCAT esterification → biliary excretion. **Statin** (HMG-CoA reductase inhibitor): blocks cholesterol biosynthesis (mevalonate pathway) → ↓ intracellular cholesterol → ↑ hepatic LDL receptor expression (SREBP-2 transcription factor up) → ↑ LDL clearance from plasma → ↓ LDL-C 30-50% (moderate) to ≥ 50% (high-intensity). Pleiotropic effects: anti-inflammatory (↓ CRP), endothelial function, plaque stabilization, anti-thrombotic. Adverse: myalgia (common but rare true myopathy < 1%; rhabdomyolysis very rare), LFT (rare hepatic injury), modest DM incidence (benefit outweighs in indicated), drug interactions (CYP3A4 — simvastatin, atorvastatin with macrolide, antifungal, calcium channel blocker, grapefruit). **Ezetimibe**: blocks intestinal cholesterol absorption (NPC1L1) → ↓ LDL 13-20%; IMPROVE-IT trial — additive benefit. **PCSK9 inhibitor** (alirocumab, evolocumab): monoclonal Ab against PCSK9; PCSK9 normally binds LDLR + targets for lysosomal degradation; blocking PCSK9 → ↑ LDLR recycling → ↑ LDL clearance → LDL ↓ 60% additional to statin; CV outcome trials FOURIER (evolocumab), ODYSSEY (alirocumab) — additional 15-20% MACE reduction. **Inclisiran** (siRNA against PCSK9 mRNA): hepatic delivery via GalNAc; long-acting 6-monthly SC dose. **Bempedoic acid**: ATP-citrate lyase inhibitor upstream of HMG-CoA reductase; statin-intolerant; CLEAR Outcomes — CV reduction. **Icosapent ethyl (EPA)**: REDUCE-IT trial in TG 135-499 + statin + ASCVD/DM — 25% MACE reduction. **Mipomersen, lomitapide**: HoFH. **PCSK9-gene editing (VERVE-101)**: in vivo CRISPR — emerging"},{"label":"C","text":"Statin works by binding LDL receptor directly"},{"label":"D","text":"PCSK9 = pro-clotting protein"},{"label":"E","text":"Inclisiran = humanized antibody"}]'::jsonb,
  'B', 'Lipid metabolism + statin + PCSK9 mechanism — high-yield. (1) Lipid metabolism pathways: - Exogenous: dietary fat absorbed as chylomicron → CM remnant (apoE removed → uptake by liver LDLR-related). - Endogenous: liver VLDL (TG-rich, apoB-100) → IDL → LDL (cholesterol ester core); cellular uptake via LDLR (apoB-100 + apoE ligand). - Reverse: HDL (apoA-I; nascent → CETP, LCAT esterification, SR-B1 → liver → bile). (2) Cholesterol biosynthesis: acetyl-CoA → HMG-CoA → HMG-CoA reductase (rate-limiting) → mevalonate → isoprenoids → cholesterol; also feeds into other biology (steroid, vit D, ubiquinone, dolichol, isoprenoid prenylation of Ras/Rho). (3) Statin (HMG-CoA reductase inhibitor): - Blocks cholesterol synthesis → ↓ intracellular pool → SREBP-2 activates LDLR transcription → ↑ LDLR on liver → ↑ LDL clearance from plasma → ↓ LDL-C 30-50% moderate, ≥ 50% high-intensity (atorvastatin 40-80, rosuvastatin 20-40). - Pleiotropic: anti-inflammatory (↓ CRP), endothelial, plaque stabilization, anti-thrombotic, lower MACE. - Adverse: myalgia (common but rare myopathy < 1%; SAMS — statin-associated muscle symptoms 5-10% clinical; rhabdomyolysis very rare; CK > 10× ULN), LFT mild ↑ rare hepatic injury, modest ↑ DM incidence (benefits outweigh in indicated). - Drug interactions: CYP3A4 (simvastatin, lovastatin, atorvastatin — caution with macrolide, azole antifungal, CCB, grapefruit, cyclosporine). - Specific: pravastatin + rosuvastatin not CYP3A4 (safer in CKD, polypharmacy). (4) Ezetimibe: inhibits NPC1L1 cholesterol transporter in intestine + biliary; ↓ LDL 13-20%; IMPROVE-IT trial; safe + simple combo. (5) PCSK9 inhibitors (alirocumab, evolocumab): - Mechanism: PCSK9 normally binds LDLR extracellular → targets for lysosomal degradation; blocking PCSK9 with mAb → ↑ LDLR recycling → ↑ LDL clearance; additional ↓ LDL 60% on statin. - CV trials: FOURIER (evolocumab), ODYSSEY OUTCOMES (alirocumab) — 15-20% MACE reduction; especially benefit in very-high risk. - Indication: ASCVD + LDL not at goal on max statin + ezetimibe; FH (familial hypercholesterolemia). - Safe; injection site reaction; no LFT/CK/cognitive concerns (early concern unfounded). (6) Inclisiran (Leqvio): siRNA against PCSK9 mRNA; GalNAc conjugated for hepatic delivery; SC q6mo (after loading); ORION trials — durable LDL ↓ 50%. (7) Bempedoic acid (Nexletol): ATP-citrate lyase inhibitor upstream of HMG-CoA reductase; not muscle-active (liver-only activation) → low muscle SE; for statin intolerance; CLEAR Outcomes CV reduction. (8) Icosapent ethyl (Vascepa, EPA only — pure): REDUCE-IT trial in TG 135-499 + statin + ASCVD/DM — 25% MACE reduction; mechanism beyond TG lowering (anti-inflammatory, anti-thrombotic, membrane). Not Lovaza (mixed EPA/DHA) — STRENGTH negative. (9) PCSK9 vaccine + in vivo CRISPR editing (VERVE-101 — base editing PCSK9 inactivation) — emerging "one-shot" therapy. (10) HoFH (homozygous FH): LDL very high; need lomitapide (MTP inhibitor), evinacumab (anti-ANGPTL3), LDL apheresis, liver transplant. (11) HDL therapeutics CETP inhibitors mixed historically; obicetrapib emerging. (12) ApoCIII inhibitor volanesorsen + olezarsen for severe hypertriglyceridemia. (13) Niacin no longer recommended (HPS2-THRIVE, AIM-HIGH negative).', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'basic_science', 'cardiovascular', 'adult',
  'Brown MS + Goldstein JL — Cholesterol metabolism; FOURIER NEJM 2017; ORION-10/11 NEJM 2020; CLEAR Outcomes NEJM 2023; REDUCE-IT NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก lipid metabolism + statin + PCSK9 inhibitor — molecular mechanism + why high-intensity statin reduces ASCVD events?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก mRNA + viral vector COVID vaccine + ทำไม mRNA จึงนวัตกรรมสำคัญ?"', '[{"label":"A","text":"mRNA vaccine = live attenuated"},{"label":"B","text":"**mRNA vaccine** (Pfizer-BioNTech BNT162b2, Moderna mRNA-1273): lipid nanoparticle (LNP) carrying nucleoside-modified mRNA encoding spike protein; LNP fuses with cell membrane → mRNA released into cytoplasm → ribosome translates spike protein → MHC class I presentation → CD8 T-cell + spike protein secreted → CD4 T-cell + B cell → antibody. Pseudouridine modification reduces innate immune sensing + ↑ translation efficiency. mRNA degrades in days (not integrating into genome). Cold chain (Pfizer -70°C, Moderna -20°C). Advantages: rapid design (days from genome sequence), high efficacy (95% Phase 3), versatile (cancer, infectious disease pipeline). Adverse: local reactogenicity, fever, myopericarditis (rare, young males, dose 2 — overall benefit > risk in indicated). **Viral vector** (AstraZeneca ChAdOx1, Janssen Ad26.COV2.S): replication-incompetent adenovirus carrying spike DNA → nucleus → transcribed to mRNA → spike protein → immunity. SE: TTS (thrombosis with thrombocytopenia syndrome — anti-PF4 antibody mediated, similar to HIT mechanism; rare ~1-10/million; CVST especially in young women); pre-existing immunity to adenovirus may blunt response. **Protein subunit** (Novavax NVX-CoV2373): recombinant spike protein + Matrix-M adjuvant. **Inactivated** (Sinovac CoronaVac, Sinopharm BBIBP-CorV): whole-virion. Vaccine evaluation: efficacy (Phase 3), VE (real-world), safety, immunogenicity (neutralizing antibody, T-cell response, durability), breakthrough, variant escape (Omicron escape from earlier mRNA; updated bivalent + monovalent XBB.1.5 boosters)"},{"label":"C","text":"All vaccines work via same mechanism"},{"label":"D","text":"mRNA integrates into DNA permanently"},{"label":"E","text":"Adenoviral vector = live virus"}]'::jsonb,
  'B', 'Vaccine immunology + COVID vaccines — revolutionary platforms. (1) mRNA vaccines (revolutionary): lipid nanoparticle delivery of nucleoside-modified (pseudouridine) mRNA encoding spike; cytoplasmic translation, MHC I + II presentation, B + T-cell response; rapid platform; technology now in cancer (BioNTech personalized neoantigen, mRNA-4157 for melanoma). (2) Viral vector (Ad26, ChAdOx1): replication-incompetent adenovirus carrying transgene; nucleus delivery; pre-existing immunity to vector limits boosters; TTS adverse (anti-PF4 like HIT). (3) Protein subunit (Novavax): recombinant + adjuvant (Matrix-M). (4) Inactivated (Sinovac, Sinopharm): traditional; rapid availability. (5) Live attenuated (FluMist intranasal, oral polio Sabin, MMR, varicella, yellow fever, BCG): can''t use in immunocompromised/pregnant. (6) Conjugate vaccines (PCV20, Hib, MenACWY): polysaccharide attached to protein carrier → T-cell-dependent response, memory; for encapsulated organisms. (7) Adjuvants: aluminum (alum — traditional), AS01 (shingles Shingrix), AS04 (HPV Cervarix), Matrix-M (Novavax). (8) Vaccine evaluation: efficacy (Phase 3 RCT), VE (real-world), safety, immunogenicity (nAb, T-cell, durability), variant escape. (9) Immunocompromised: lower response → additional doses (3rd primary + booster); avoid live; passive immunoglobulin in some. (10) Pregnancy: inactivated/mRNA/subunit safe; live avoided.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'Polack FP et al. NEJM 2020 (BNT162b2); Baden LR et al. NEJM 2021 (mRNA-1273); Plotkin''s Vaccines 7th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก mRNA + viral vector COVID vaccine + ทำไม mRNA จึงนวัตกรรมสำคัญ?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก heart failure ในระดับ neurohumoral activation — RAAS + SNS + natriuretic peptide + ทำไม sacubitril/valsartan + SGLT2i จึงดี?"', '[{"label":"A","text":"Heart failure เกิดจาก infection อย่างเดียว"},{"label":"B","text":"Heart failure pathophysiology: initial myocardial injury (ischemia, HT, valvular, genetic) → reduced cardiac output → neurohumoral activation: (1) **RAAS** activation: ↓ renal perfusion → renin → angiotensin I → ACE → angiotensin II (vasoconstriction, aldosterone, ADH, sympathetic, growth/fibrosis); aldosterone → Na+H2O retention + K+H+ excretion + fibrosis; → preload + afterload + remodeling. (2) **Sympathetic nervous system**: ↑ HR, contractility (initially compensatory) → chronically myocardial damage + downregulation β-receptor + arrhythmogenesis. (3) **Natriuretic peptide system** (ANP, BNP — atrial/ventricular stretch): vasodilation + natriuresis + RAAS suppression + anti-fibrotic — COUNTER-REGULATORY but inadequate; degraded by neprilysin. (4) **Endothelin**, **vasopressin**, **inflammation cytokines** (TNF, IL-6) — adverse remodeling. **Sacubitril/valsartan** (ARNI): neprilysin inhibitor sacubitril (↑ NP — vasodilation, natriuresis, anti-RAAS) + valsartan (ARB blocks AT1); PARADIGM-HF (NEJM 2014) — 20% RR for HF death/hosp vs enalapril; preferred in HFrEF (Class I). **SGLT2 inhibitor** (dapa, empa): originally for DM; CV trials EMPA-REG, DAPA-HF, EMPEROR-Reduced/Preserved show benefit in HFrEF + HFpEF + CKD + non-DM; mechanisms — natriuresis + osmotic diuresis (preload), BP ↓, ketone/myocardial energy substrate, anti-inflammatory, anti-fibrotic, sympathetic modulation, RAAS effect. **Four pillars GDMT HFrEF** (rapid up-titration): ARNI + BB + MRA + SGLT2i — added ivabradine (SR if HR > 70, sinus), vericiguat (sGC stimulator), digoxin (symptomatic). HFpEF: SGLT2i + MRA (spironolactone in TOPCAT subgroup; finerenone in FINEARTS-HF 2024); ARNI emerging"},{"label":"C","text":"Beta-blocker ทำให้ HF แย่ลงเสมอ"},{"label":"D","text":"Digoxin = mortality benefit primary"},{"label":"E","text":"Aldosterone = vasoconstrictor only"}]'::jsonb,
  'B', 'Heart failure neurohumoral activation + GDMT mechanisms. Key concept: neurohumoral activation initially compensatory but maladaptive chronically → myocardial damage + remodeling. Pharmacologic blocking of these systems improves outcomes. (1) Pathways: RAAS (vasoconstriction, Na retention, fibrosis), SNS (HR, contractility, arrhythmia, damage), NP (counter-regulatory but inadequate; neprilysin degrades), endothelin, vasopressin, inflammation, oxidative stress. (2) HFrEF GDMT 4 pillars (rapid up-titration vs stepwise — STRONG-HF supports rapid): - ARNI (sacubitril/valsartan) replace ACEi/ARB; PARADIGM-HF; if ACEi → wait 36 hr before ARNI (angioedema). - Beta-blocker (carvedilol, metoprolol succinate, bisoprolol): up-titrate gradually; avoid in unstable acute. - MRA (spironolactone, eplerenone, finerenone): K monitoring; gynecomastia spironolactone vs eplerenone selective. - SGLT2i (dapagliflozin, empagliflozin): both DM + non-DM HFrEF + HFpEF. - Additional: ivabradine (HR > 70 sinus on max BB — SHIFT), vericiguat (sGC stimulator — VICTORIA), digoxin (symptomatic, not mortality), nitrate-hydralazine (Black ancestry HFrEF — A-HeFT), omecamtiv mecarbil (cardiac myosin activator — GALACTIC-HF). (3) HFpEF: SGLT2i (Class I — EMPEROR-Preserved, DELIVER); MRA (spironolactone — TOPCAT subgroup analyses; finerenone FINEARTS-HF 2024 NEJM); diuretic for congestion; manage comorbidities (HT, AF, obesity, OSA, CAD); semaglutide for obese (STEP-HFpEF). (4) Acute decompensated: IV diuretic, vasodilator (NTG) for SBP > 100, inotrope for low CO, MCS (IABP, LVAD) for refractory. (5) Device + advanced: CRT (LVEF < 35 + LBBB QRS > 130-150 ms), ICD primary prevention (LVEF < 35 > 40 d post-MI > 90 d post revasc + NYHA II-III on GDMT), LVAD/transplant for end-stage. (6) Education + self-management + cardiac rehab + multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'basic_science', 'cardiovascular', 'adult',
  'PARADIGM-HF NEJM 2014; DAPA-HF NEJM 2019; STRONG-HF Lancet 2022; FINEARTS-HF NEJM 2024; AHA/ACC/HFSA 2022 HF Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก heart failure ในระดับ neurohumoral activation — RAAS + SNS + natriuretic peptide + ทำไม sacubitril/valsartan + SGLT2i จึงดี?"'
  );

commit;

-- verify partial progress
select board_section, count(*) from public.mcq_questions
where board_specialty = 'internal_medicine' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
