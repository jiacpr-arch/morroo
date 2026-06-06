-- ===============================================================
-- UPDATE chunk 3/8: surgery (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + serial neurological exam"},{"label":"B","text":"Severe TBI + acute SDH with uncal herniation — neurosurgical emergency"},{"label":"C","text":"Steroid IV high dose"},{"label":"D","text":"Aggressive hyperventilation PaCO2 < 25 sustained"},{"label":"E","text":"Wait CT repeat tomorrow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe TBI + acute SDH with uncal herniation — neurosurgical emergency**: (1) **ABC + protect airway** — RSI intubation (cervical spine precaution) with neuroprotective induction (avoid hypotension + hypoxia which double mortality); (2) **Maintain CPP > 60-70 mmHg**, MAP > 80, avoid hypotension (SBP > 110 if no other contraindication per BTF 4th ed), avoid hypoxia (SpO2 > 94%); (3) **Temporary measures for raised ICP / herniation**: - **Head of bed 30°**, head midline (jugular drainage) - **Hyperventilation TARGET PaCO2 30-35** (briefly, for impending herniation — vasoconstriction reduces ICP; not prolonged → ischemia) - **Mannitol 1 g/kg IV OR hypertonic saline 3% bolus 250 mL** — osmotic ICP reduction - **Sedation + analgesia**; paralytic if needed for asynchrony; (4) **Emergent neurosurgical decompression** — craniotomy + SDH evacuation ± decompressive craniectomy; (5) **ICP monitoring** post-op (intraventricular catheter preferred — diagnostic + therapeutic CSF drainage); (6) **TXA** — CRASH-3 trial: IV TXA within 3h of mild-moderate TBI reduces head injury death; (7) **Avoid steroids** (CRASH-1 — increased mortality in TBI); (8) **Anti-seizure** prophylaxis 7 days (levetiracetam preferred); (9) **DVT prophylaxis** — mechanical until 24-72h post-stable head CT, then chemical; (10) ICU + multidisciplinary

---

Severe TBI management — Brain Trauma Foundation (BTF) 4th edition + ATLS: **Primary brain injury** (initial trauma) + **secondary brain injury** (hypotension, hypoxia, ↑ICP, hypoglycemia, hyperthermia, seizures) — preventable secondary injury is target. **Severe TBI**: GCS ≤ 8 — intubate, ICP monitoring **Surgical SDH evacuation indications**: > 10 mm thickness OR midline shift > 5 mm OR GCS deteriorating OR pupillary abnormality OR ICP > 20 mmHg sustained **CPP** (Cerebral Perfusion Pressure = MAP - ICP): target 60-70 (BTF) — too high → ARDS risk; too low → ischemia **ICP** management tiered: 1. Head elevation, sedation, normothermia, normoglycemia 2. Osmotic therapy: mannitol 0.25-1 g/kg OR hypertonic saline 3. CSF drainage via EVD 4. Hyperventilation (rescue — brief) PaCO2 30-35; avoid PaCO2 < 30 (ischemia) 5. Decompressive craniectomy 6. Barbiturate coma (last resort) **CRASH-3** trial 2019: TXA within 3h of mild-moderate TBI reduces head injury-related death. **Glucose**: 140-180 target — avoid hyperglycemia + hypoglycemia. **Avoid**: prolonged severe hyperventilation, steroids, hypotension, hypoxia. A C E ผิดอย่างยิ่ง. D ผิด — brief PaCO2 30-35 OK, not < 25 sustained.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 22 ปี ดื่มเหล้าหนัก พบในที่เกิดเหตุไม่รู้สึกตัว มี alcohol smell ตกบันได

GCS = 6 (E1V2M3), pupils unequal — right 5mm fixed dilated, left 3mm reactive; ทั่วศีรษะมี laceration + scalp hematoma right side
V/S: BP 168/96, HR 56, RR 12 irregular (Cushing''s reflex)
No other obvious injury

CT brain: right acute subdural hematoma 12 mm + midline shift 8 mm + uncal herniation

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Thyroid lobectomy alone, no node dissection"},{"label":"B","text":"Papillary thyroid carcinoma cT2N1b (lateral nodal disease) — extensive surgery"},{"label":"C","text":"Active surveillance only"},{"label":"D","text":"Chemotherapy first-line"},{"label":"E","text":"Radiation alone, no surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Papillary thyroid carcinoma cT2N1b (lateral nodal disease) — extensive surgery**: (1) **Total thyroidectomy** — indicated for tumors > 4 cm, gross extrathyroidal extension, clinically apparent nodal disease, distant metastases, prior head/neck radiation; this patient: nodal disease present → total thyroidectomy preferred over lobectomy; (2) **Central compartment lymph node dissection (level VI)** — therapeutic for clinically positive central nodes; prophylactic for select high-risk; (3) **Modified radical neck dissection (lateral compartment levels II-V)** — therapeutic for biopsy-proven lateral nodal disease (functional dissection preserving SCM, IJ, spinal accessory n. when possible); (4) **Postop**: serum thyroglobulin (Tg) + anti-Tg Ab — surveillance marker; calcium monitoring (hypoparathyroidism risk); recurrent laryngeal n. evaluation; (5) **Radioactive iodine (RAI I-131) ablation** — indicated for higher risk: > 4 cm, extrathyroidal extension, nodal disease (esp. > 5 nodes OR > 1 cm OR extranodal extension), distant metastases; dose 30-150 mCi; (6) **TSH suppression** with levothyroxine — target TSH < 0.1 in high-risk, 0.1-0.5 intermediate, 0.5-2 low-risk; (7) **Long-term surveillance**: serum Tg, neck US, possible whole-body scan; (8) Genetic counseling if family history

---

Papillary Thyroid Carcinoma (PTC) — most common (80-85% of thyroid Ca). Excellent prognosis overall (10-year survival > 95% in localized). **ATA Risk stratification** (2015 guidelines): - **Low risk**: intrathyroidal PTC ≤ 4 cm, no nodal/distant mets, no aggressive variant - **Intermediate**: gross extrathyroidal extension, vascular invasion, > 5 LN involved (small), aggressive histology - **High**: gross extrathyroidal invasion, incomplete resection, distant mets, large nodal disease **Surgical extent**: - **Lobectomy** for ≤ 4 cm, intrathyroidal, no nodes, low-risk — recent trend - **Total thyroidectomy** for: > 4 cm, gross ETE, distant mets, nodal disease, bilateral, prior H&N RT, contralateral nodule **Lymph node dissection**: - Therapeutic central (VI) for clinically involved central nodes - Therapeutic lateral (II-V) for biopsy-proven lateral nodes (modified radical) - Prophylactic central — controversial; consider T3/T4 **RAI ablation**: post-total thyroidectomy, intermediate-high risk — destroys residual + treats microscopic + mets **TSH suppression** with LT4 reduces recurrence in higher risk **Active surveillance** — selected microcarcinoma (≤ 1 cm) no node/ETE — not appropriate here (2 cm, N1b) A ผิด — N1 + 2cm ต้อง total + dissection. C ผิด — N1 disease ไม่ใช่ active surveillance candidate. D ผิด — chemo ไม่ใช่ first-line PTC. E ผิด — RAI not external RT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 25 ปี ไม่มีโรคประจำตัว มาด้วยอาการ neck mass บริเวณ thyroid โตขึ้น 6 เดือน ไม่มี hyperthyroid symptoms

Examination: 2 cm hard nodule right lobe + cervical lymphadenopathy ipsilateral
US thyroid: 2 cm hypoechoic solid nodule with microcalcifications + irregular margin + taller-than-wide + TIRADS 5
FNA: papillary thyroid carcinoma (PTC)

TFTs: euthyroid; calcitonin normal
Staging CT neck: no distant metastasis, several ipsilateral central + lateral compartment lymph nodes suspicious';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue medical therapy only"},{"label":"B","text":"Critical limb-threatening ischemia (CLTI, formerly CLI) — limb salvage approach"},{"label":"C","text":"Primary amputation"},{"label":"D","text":"Beta-blocker + observation"},{"label":"E","text":"Anticoagulation alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Critical limb-threatening ischemia (CLTI, formerly CLI) — limb salvage approach**: (1) **Risk factor modification + medical optimization**: smoking cessation (most important), statin (high-intensity), antiplatelet (aspirin or clopidogrel; consider DOAC + aspirin per VOYAGER PAD — rivaroxaban 2.5 BID + ASA), BP control, glycemic control, supervised exercise (claudication only); (2) **Revascularization** indicated for CLTI — improves limb salvage + survival: - **Endovascular**: angioplasty ± stent (drug-eluting), atherectomy — preferred first in many; appropriate for short-segment, focal disease - **Open bypass**: femoropopliteal, fem-distal bypass with autologous vein (saphenous) — better long-term patency for long-segment disease; prosthetic if vein unavailable - **BEST-CLI trial (NEJM 2022)**: surgical bypass with adequate vein conduit superior to endovascular for major adverse limb events + need for re-intervention in CLTI; endovascular alternative if no good vein; (3) **Wound care + offloading** for foot ulcer; podiatry; (4) **Multidisciplinary** vascular surgery + IR + wound care + diabetes + podiatry; (5) **Amputation only if not revascularizable / non-salvageable limb**; (6) Lifelong surveillance + medical therapy

---

**Peripheral Artery Disease (PAD)** classification (Rutherford / Fontaine): - **Claudication (Rutherford 1-3 / Fontaine II)**: pain with exertion - **CLTI (Rutherford 4-6 / Fontaine III-IV)**: rest pain (4), ulceration (5), gangrene (6) — limb-threatening **Diagnosis**: ABI (0.9-1.4 normal; < 0.9 PAD; < 0.4 severe); TBI in non-compressible (DM, ESRD — vessel calcification); duplex; CT/MR angio; conventional angio. **ABI > 1.4** suggests non-compressible — get TBI/PVR. **CLTI Management** (ESVS + AHA 2022 + Global Vascular Guidelines): - Medical: smoking cessation, statin, antiplatelet, glycemic, BP - Revascularization always considered if limb salvageable - WIfI score (Wound, Ischemia, foot Infection) — stratify - **BEST-CLI (NEJM 2022)**: bypass with adequate vein > endovascular for MALE outcomes in CLTI with single-segment GSV - **BASIL-2 (Lancet 2023)**: endovascular non-inferior in some subgroups - **Antithrombotic** — VOYAGER PAD: rivaroxaban 2.5 BID + ASA reduces MALE post-revascularization; COMPASS regimen for stable PAD **Claudication only** (not CLTI): - First-line: supervised exercise + medical + risk factor - Revascularization if lifestyle-limiting after trial - Cilostazol — phosphodiesterase inhibitor for symptoms A ผิด — CLTI ต้อง revascularize. C ผิด — limb still salvageable. D E ผิด — ไม่พอ.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 68 ปี smoker 60 pack-yr มาด้วยอาการปวดน่อง ขณะเดิน 100 เมตร 6 เดือน รุนแรงขึ้นเป็น 50 เมตร 2 สัปดาห์ ขาขวาเย็น ปวดเวลานอน

Examination: cool right foot, absent right popliteal + dorsalis pedis + posterior tibial pulses, capillary refill > 4 sec, ulcer 1 cm at heel non-healing
ABI: right 0.32 (severe), left 0.78 (mild-moderate)
Doppler: monophasic flow right SFA + popliteal
CT angiography: long-segment SFA occlusion right + multilevel atherosclerosis

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency pyloromyotomy immediately"},{"label":"B","text":"Hypertrophic pyloric stenosis — surgical disease but MEDICAL EMERGENCY of correcting metabolic alkalosis + dehydration FIRST"},{"label":"C","text":"Oral rehydration + delay surgery 1 week"},{"label":"D","text":"Surgery without fluid correction"},{"label":"E","text":"Atropine medical therapy only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hypertrophic pyloric stenosis — surgical disease but MEDICAL EMERGENCY of correcting metabolic alkalosis + dehydration FIRST**: (1) **NPO + NG decompression**; (2) **IV fluid resuscitation + electrolyte correction** — D5 ½NS with 20-40 mEq KCl/L after urine output established; goal: correct dehydration, normalize Cl > 100, HCO3 < 30, K > 3.5, urine output > 1 mL/kg/hr — usually takes 24-48 hr; (3) **Then surgery**: Ramstedt **pyloromyotomy** (open or laparoscopic) — split serosa + muscularis longitudinally without breaching mucosa; (4) **Postop feeding**: ad lib feeding within hours (recent evidence) OR scheduled advance; vomiting common 24-48h then resolves; (5) **Avoid emergency surgery before correction** — anesthesia in alkalotic patient → hypoventilation + respiratory acidosis + hypoxia + apnea; mortality risk; (6) **Outcome**: excellent — > 99% cure

---

**Hypertrophic Pyloric Stenosis (HPS)** — 2-12 weeks of age, more common in firstborn males. Etiology multifactorial — genetic + environmental (macrolides in infancy assoc), idiopathic muscle hypertrophy. **Classic presentation**: non-bilious projectile vomiting + visible peristalsis + palpable ''olive'' RUQ + dehydration + failure to thrive. **Lab signature**: hypochloremic hypokalemic metabolic alkalosis (loss of HCl from vomiting; renal compensation by H+ retention worsens alkalosis; paradoxical aciduria when severe). **Imaging**: US gold standard — muscle thickness ≥ 4 mm, length ≥ 16 mm, target/donut sign, elongated channel **Management critical principle**: PYLORIC STENOSIS IS NOT A SURGICAL EMERGENCY — IT IS A MEDICAL EMERGENCY OF FLUID + ELECTROLYTE CORRECTION FIRST. - Anesthesia + surgery in alkalotic patient = postop apnea (CNS depression from alkalosis + hypoventilation compensation) - Correct: Cl > 100, HCO3 < 30, K > 3.5, normal urine output - Usually 24-48 hours of IV resuscitation **Surgery**: Ramstedt pyloromyotomy — extramucosal splitting; laparoscopic = open in modern era for outcomes. Atropine medical therapy — historical, rarely used now. A ผิด — ห้ามผ่าตัดก่อน correct lab. C ผิด — IV ไม่ใช่ oral. D ผิดอย่างยิ่ง — anesthetic risk. E ผิด — surgery definitive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'เด็กชายไทยอายุ 6 สัปดาห์ มาด้วยอาเจียนพุ่งเป็นน้ำนม 2 สัปดาห์ น้ำหนักลด ตาลึก ปัสสาวะน้อย

Exam: alert but lethargic, dehydrated, palpable olive-shaped mass RUQ, visible peristalsis epigastric
Weight 4.0 kg (10th percentile)

Lab: Na 128, K 2.8, Cl 84, HCO3 36, BUN 22, Cr 0.6, glucose 76
ABG: pH 7.52, PaCO2 48, HCO3 38 (hypochloremic hypokalemic metabolic alkalosis)
US: pyloric muscle thickness 5 mm, length 18 mm, target sign — diagnosis of pyloric stenosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency laparotomy"},{"label":"B","text":"Ileocolic intussusception in pediatric patient — air enema reduction first-line if stable"},{"label":"C","text":"Observation 24 hr without intervention"},{"label":"D","text":"Oral contrast study only"},{"label":"E","text":"Discharge home with follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Ileocolic intussusception in pediatric patient — air enema reduction first-line if stable**: (1) **Resuscitation** + IV fluid + NG decompression + surgical consultation on standby; (2) **Air (pneumatic) enema reduction** under fluoroscopy — preferred over hydrostatic (barium/saline) due to better visualization, less mess if perforation, equally effective; success rate 80-90% (lower if symptoms > 24h, small bowel only); contraindications: peritonitis, perforation, hemodynamic instability; (3) **Hydrostatic enema** alternative (US-guided saline) — also effective, no radiation; (4) **Confirm reduction** — air through ileocecal valve into ileum + clinical improvement; observe 24h for recurrence (5-10%); (5) **Surgery** indicated for: failed enema reduction, peritonitis, perforation, pathological lead point (Meckel''s, polyp, lymphoma — older child > 5 yr suspect lead point), recurrence > 3 times → laparoscopic / open reduction + resection if non-viable / lead point; (6) **Postop care + follow-up**

---

**Intussusception** — invagination of bowel into distal segment. Most common < 2 years, peak 5-9 months. Ileocolic most common. **Etiology**: idiopathic (peak age 3 mo - 3 yr) — viral-induced lymphoid hyperplasia (Peyer''s patches); rotavirus vaccine RotaShield withdrawn 1999. **Pathological lead point** more likely > 5 yr — Meckel''s, polyp, lymphoma, duplication, cyst. **Classic triad** (only 25%): crying spells + vomiting + currant jelly stool **Dance sign**: empty RLQ + sausage RUQ. **US** investigation of choice (target/donut, pseudokidney). **Reduction**: - **Air enema** preferred (pneumatic) — fluoroscopy-guided air insufflation; 80-90% success; perforation risk 0.4-2.5% - **Hydrostatic** (saline/water-soluble contrast under US, OR barium under fluoroscopy) — alternative - Contraindications: peritonitis, free air, hemodynamic instability, prolonged symptoms with signs of ischemia **Surgery indications**: failed non-operative reduction, peritonitis, perforation, lead point, recurrence (3+). **Recurrence** ~5-10% — usually within 24h. A ผิด — first-line non-operative. C ผิด — delay = ischemia. D ผิด — therapeutic enema. E ผิดอย่างยิ่ง.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'เด็กชายไทยอายุ 9 เดือน มาด้วยอาการร้องไห้เป็นพักๆ ทุก 15-30 นาที + อาเจียน 6 ชั่วโมง + ถ่ายเป็นเลือดสีน้ำตาลแดง currant jelly stool 2 ครั้ง

Exam: lethargic between crying spells, palpable sausage-shaped mass RUQ, dance''s sign (empty RLQ)
VS: BP 80/50, HR 144, RR 30, Temp 37.6°C

US abdomen: target sign / pseudokidney sign at ileocolic region — intussusception confirmed; no signs of perforation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + NG decompression only"},{"label":"B","text":"Neonatal midgut volvulus with malrotation — SURGICAL EMERGENCY"},{"label":"C","text":"Outpatient referral pediatric surgery"},{"label":"D","text":"Contrast enema"},{"label":"E","text":"Endoscopic correction"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Neonatal midgut volvulus with malrotation — SURGICAL EMERGENCY**: (1) **Immediate resuscitation**: NG decompression, IV fluid bolus, broad-spectrum antibiotic, type & crossmatch; (2) **EMERGENT laparotomy** (within hours) for **Ladd''s procedure**: (a) detorsion (counterclockwise) of volvulus, (b) division of Ladd''s bands (peritoneal bands compressing duodenum), (c) widening of mesenteric base, (d) appendectomy (because appendix ends up LUQ → future atypical presentation), (e) place small bowel right, colon left; (3) **Assess bowel viability** — non-viable bowel resection; massive necrosis → damage control + second look 24-48h; (4) **Postop**: ICU, NG, gradual enteral; (5) **Time-critical** — bowel ischemia within hours → short gut syndrome if extensive necrosis or death

---

**Midgut volvulus with malrotation** — true surgical emergency in newborn. Embryologic basis: incomplete rotation of midgut (270° CCW) + fixation → narrow mesenteric base around SMA → volvulus risk. **Presentation**: bilious vomiting in newborn = malrotation with volvulus until proven otherwise → emergent workup. **Classic age**: 50% within 1 month, 75% within 1 year, can occur any age. **Diagnosis**: - **Upper GI series gold standard**: duodenojejunal junction (DJJ) right of midline / inferior to pylorus = malrotation; ''corkscrew'' duodenum + jejunum = volvulus - US — SMA/SMV relationship reversal supportive - X-ray: limited, may show double bubble; some atypical **Time = bowel**: every hour of volvulus → more ischemia → catastrophic short gut syndrome (massive resection → lifelong TPN) **Ladd''s procedure**: 1. Counterclockwise detorsion 2. Lyse Ladd''s bands 3. Widen mesentery 4. Appendectomy (anatomic relocation) 5. Place bowel in non-rotation position **Appendectomy** because cecum + appendix moved → atypical pain location later. A ผิดอย่างยิ่ง — emergency. C D E ผิด.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ทารกแรกเกิดอายุ 1 วัน term, มาด้วยอาเจียน bilious + ท้องอืดเล็กน้อย ผ่าน meconium ปกติ 12 ชั่วโมงแรก

VS stable, abdomen non-distended, no peritonitis
Upper GI series: ''corkscrew'' appearance of duodenum + small bowel — concerning for malrotation with midgut volvulus';

update public.mcq_questions
set choices = '[{"label":"A","text":"Large fluid bolus 2L NSS"},{"label":"B","text":"Post-operative oliguria — systematic evaluation + fluid challenge"},{"label":"C","text":"Furosemide IV bolus 80 mg"},{"label":"D","text":"Renal replacement therapy immediately"},{"label":"E","text":"Stop all fluids"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-operative oliguria — systematic evaluation + fluid challenge**: (1) **Differential**: pre-renal (hypovolemia, hypotension, anemia, low cardiac output), renal (ATN from hypotension, sepsis, contrast, drugs, transfusion), post-renal (bladder/ureter obstruction, kink, catheter); (2) **Assess volume status**: dynamic measures preferred — passive leg raise, pulse pressure variation, SVV (if ventilated), bedside US (IVC, lung B-lines), urine sodium / osmolality / FENa < 1% = pre-renal; (3) **Confirm Foley patency** — bladder scan done (catheter functional), rule out kink/blockage; (4) **Modest fluid challenge** 250-500 mL crystalloid + reassess UO/HD parameters — avoid large bolus that worsens edema (third spacing, prolonged ileus); (5) **Optimize**: correct anemia (transfuse if Hb < 7 standard, < 8 cardiac), maintain MAP > 65, treat pain, check medications (NSAIDs, nephrotoxic); (6) **Goal-directed therapy** ERAS-aligned — avoid liberal fluid (causes worse outcomes per ERAS evidence + Shin CH NEJM 2018); restrictive moderate strategy; (7) **Persistent oliguria** → nephrology consult, consider AKI workup, renal US, urine studies; (8) **Monitor Cr trend**

---

**Postoperative oliguria** — UO < 0.5 mL/kg/hr × > 6h (KDIGO AKI Stage 1 criterion). Don''t reflex bolus. Modern ERAS + perioperative fluid management has shifted away from liberal fluids toward goal-directed + restrictive. **Differential**: 1. **Pre-renal**: hypovolemia (intraop loss, third space), low cardiac output, vasodilation (sepsis, anesthetic) 2. **Renal (intrinsic)**: ATN from prolonged hypotension/hypovolemia, drug-induced (NSAID, contrast, aminoglycoside), interstitial nephritis (antibiotics), rhabdomyolysis 3. **Post-renal**: catheter obstruction (kink, clot), bladder outlet, ureteral injury intraop (esp pelvic/colorectal — 0.5-1%) **Assessment**: - Check Foley patency, bladder scan - Vital signs trend - Fluid balance, weight - Lab: Cr, BUN/Cr ratio, electrolytes - Urine: Na, osmolality, FENa - Hemodynamics: dynamic measures preferred over CVP (CVP poorly predicts fluid responsiveness) - Bedside US: IVC, lung B-lines, cardiac function **Modern goal-directed**: small fluid challenges with reassessment, avoid over-resuscitation. **Avoid loop diuretics** for pre-renal oliguria — worsens AKI. Use only after volume optimized + persistent fluid overload. **Avoid contrast** for imaging if possible in AKI. A ผิด — large bolus harmful. C ผิด — loop in pre-renal harmful. D ผิด — RRT for refractory severe AKI. E ผิด — need maintenance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 65 ปี ผ่า colorectal cancer (sigmoid) ผ่านไป 6 ชั่วโมง post-op ผู้ป่วยมา ICU vitals stable แต่สังเกตเห็น oliguria 0.2 mL/kg/hr × 4 ชั่วโมง

VS: BP 118/72, HR 96, RR 16, Temp 37.0°C
Lab: Hb 9.8 stable, Cr 1.6 (baseline 1.0), K 4.2, lactate 2.4
Fluid balance + 2 L positive intraop + 800 mL post-op
UO 80 mL last 4 hr
US Bladder: 60 mL urine in catheter functional

คำถาม: management of oliguria';

update public.mcq_questions
set choices = '[{"label":"A","text":"Electrical cardioversion immediately"},{"label":"B","text":"Postoperative new-onset atrial fibrillation (POAF) with rapid ventricular response + borderline hemodynamics"},{"label":"C","text":"Digoxin alone for rate control"},{"label":"D","text":"Observation only"},{"label":"E","text":"Warfarin start immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postoperative new-onset atrial fibrillation (POAF) with rapid ventricular response + borderline hemodynamics**: (1) **Identify + correct precipitants** — common: pain, hypoxia, electrolyte derangements (K, Mg), hypovolemia/overload, anemia, sepsis, MI, PE, withdrawal; replete K to 4-4.5, Mg to > 2; (2) **Rate vs rhythm control**: hemodynamically stable enough to attempt rate control first — **IV beta-blocker (metoprolol 5 mg q5 min × 3 doses)** OR **diltiazem 10-20 mg bolus then infusion** — caution in HFrEF (diltiazem CI); avoid amiodarone first in stable rate control (more pro-arrhythmic, hypotension); (3) **Hemodynamically unstable** (severe hypotension, ischemia, severe HF) → **synchronized DC cardioversion** 120-200 J biphasic + sedation; (4) **Rhythm control with amiodarone IV** consider if rate control inadequate or rhythm desired (150 mg load, then drip) — also good in critically ill; (5) **Anticoagulation**: CHA2DS2-VASc score in POAF — controversial; transient POAF may not warrant long-term AC but risk of stroke during episode + recurrence high; consult per guidelines + bleeding risk balance; postop bleeding risk weigh; (6) **Address underlying causes**, optimize hemodynamics; (7) Cardiology consult; (8) Outpatient follow-up — many POAF persistent or recurrent

---

**Postoperative Atrial Fibrillation (POAF)** — incidence 10-30% post non-cardiac surgery, 30-50% post cardiac. Risk factors: age, HT, valvular disease, COPD, electrolyte disturbance, intraop volume shifts. **Management**: 1. **Identify precipitants**: pain, hypoxia, K/Mg deficiency, anemia, sepsis, fluid status, MI, PE 2. **Hemodynamic stability assessment**: - Stable: rate vs rhythm control - Unstable: synchronized cardioversion immediately 3. **Rate control**: - First-line: beta-blocker (metoprolol, esmolol) OR non-DHP CCB (diltiazem, verapamil) — caution in HFrEF - Digoxin: slow onset, less effective in stress states; adjunct only - Amiodarone: rhythm + rate; reasonable in critically ill, HF 4. **Rhythm control**: amiodarone IV; ibutilide; cardioversion 5. **Anticoagulation** in POAF: - CHA2DS2-VASc + HAS-BLED - Postop bleeding risk → individualized - Recent meta-analyses: POAF assoc with long-term AF recurrence + stroke risk — increasing recognition to anticoagulate persistent POAF beyond initial episode 6. **Long-term**: outpatient follow-up; many persist or recur **Special**: post-cardiac surgery — prophylactic beta-blocker, amiodarone proven to reduce POAF (PAPABEAR, others). A ผิด — stable enough for rate control trial. C ผิด — digoxin slow. D ผิด — RVR + hypotension. E ผิด — long-term decision later.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 72 ปี post-op day 1 right hemicolectomy for cecal mass admit ICU มาขอ consultation ว่าผู้ป่วยมี atrial fibrillation new onset HR 140 BP 95/60

VS: BP 96/58, HR 142 irregular, RR 22, SpO2 94% room air, Temp 37.8°C
Gen: dyspneic
Lab: Hb 9.6, K 3.4, Mg 1.6, troponin negative, TSH normal

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + bed rest"},{"label":"B","text":"Acute proximal DVT + segmental PE (low-risk by Hestia/sPESI, hemodynamically stable, normal RV function) → therapeutic anticoagulation"},{"label":"C","text":"Surgical thrombectomy"},{"label":"D","text":"Systemic thrombolytics for all PE"},{"label":"E","text":"Aspirin only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute proximal DVT + segmental PE (low-risk by Hestia/sPESI, hemodynamically stable, normal RV function) → therapeutic anticoagulation**: (1) **Anticoagulation initiation** — choices: - **DOAC** (apixaban 10 mg BID × 7 days then 5 mg BID; OR rivaroxaban 15 mg BID × 21 days then 20 mg daily) — first-line per ACCP + CHEST; no overlap needed; - **LMWH** (enoxaparin 1 mg/kg q12h or 1.5 mg/kg daily) — for early use, particularly if uncertain bleeding risk, pregnancy, severe renal dz, cancer (LMWH historically preferred for cancer, now DOAC also acceptable per CLOT/Caravaggio); - **UFH IV** if hemodynamic concern, severe renal impairment, planned procedure; - Warfarin requires bridging with LMWH/UFH until INR 2-3 — rarely first choice now; (2) **Duration**: provoked (surgery-associated) → 3 months; unprovoked or persistent risk → consider extended; (3) **Postop bleeding risk** assessment — recent surgery 3 days = bleeding risk; balance vs PE/DVT mortality; usually proceed with anticoagulation with monitoring; (4) **Bleeding**: monitor wound, Hb, drains; consider IVC filter if true contraindication to anticoagulation (recent intracranial surgery, active bleeding) — retrievable filter; (5) **Outpatient management** acceptable for low-risk PE per HoT-PE / others — if reliable patient + outpatient anticoagulation feasible; (6) **No thrombolytics** for low-risk PE (only massive/hemodynamic instability or selected submassive with RV dysfunction)

---

**VTE management** — anticoagulation cornerstone. **Risk stratification of PE** (PESI / sPESI / Hestia): - Low risk: stable, no RV dysfunction, no biomarker elevation, no comorbidities — outpatient OR short observation - Intermediate-low: RV dysfunction OR biomarker elevation alone - Intermediate-high: BOTH RV dysfunction AND biomarker elevation - High (massive) PE: shock/hypotension SBP < 90 → thrombolytics, embolectomy, ECMO **Anticoagulation choice**: - **DOAC** first-line for most (CHEST 2021): apixaban, rivaroxaban (initial loading); dabigatran, edoxaban (require initial parenteral) - **LMWH** — pregnancy, cancer (alternative to DOAC), severe renal dz - **UFH** — hemodynamic instability, procedure planned, severe renal - **VKA** — historical, mechanical valves, antiphospholipid syndrome (recent evidence) **Duration**: - Provoked (surgery, immobilization): 3 months - Unprovoked: 3 months minimum; consider extended (D-dimer, sex, residual thrombus) - Active cancer: indefinite while active - Recurrent unprovoked: indefinite **Thrombolytics**: only for high-risk (massive) PE OR selected intermediate-high with deterioration. **IVC filter**: only if true contraindication to anticoagulation; retrievable preferred; not for prophylaxis. **Postop VTE** — provoked but high recurrence risk if cancer-associated; weigh bleeding. A ผิด — ต้อง anticoagulate. C ผิด — selected only. D ผิด — low-risk PE no thrombolytics. E ผิด — aspirin ไม่พอ.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 40 ปี ทำงานก่อสร้าง post-op day 3 elective open inguinal hernia repair (mesh) มาด้วยอาการ shortness of breath ตื่นปวด chest, calf swelling left leg

VS: BP 124/82, HR 116, RR 24, SpO2 89% room air, Temp 37.4°C
Leg: left calf swollen 3 cm > right + tender + Homan''s positive
Chest: clear, mild tachypnea

Lab: Hb 13.8, D-dimer 4,200 (elevated)
CT pulmonary angiography: bilateral segmental PE; right ventricle:left ventricle ratio 0.9 (normal)
US Doppler legs: extensive DVT left femoropopliteal
Well''s score for PE high, Hestia low risk (no shock, no RV strain)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency cholecystectomy"},{"label":"B","text":"Symptomatic cholelithiasis without acute cholecystitis (biliary colic) → elective laparoscopic cholecystectomy"},{"label":"C","text":"Observation + reassurance lifelong"},{"label":"D","text":"Oral ursodeoxycholic acid lifelong only"},{"label":"E","text":"ERCP first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Symptomatic cholelithiasis without acute cholecystitis (biliary colic) → elective laparoscopic cholecystectomy**: (1) symptomatic gallstones — typical biliary colic episodes; (2) discuss timing — symptoms recurrent + risk of complications (cholecystitis, pancreatitis, cholangitis) → recommend elective laparoscopic cholecystectomy within weeks; (3) pre-op: low-fat diet, analgesia, anti-emetic; (4) laparoscopic preferred — gold standard, lower morbidity vs open; (5) intraoperative cholangiography selective vs routine — based on risk factors for CBD stones (LFTs, dilated CBD on US, history pancreatitis); (6) post-op: rapid recovery, return to normal diet

---

Asymptomatic gallstones — observation generally; intervention for selected (DM, transplant, sickle cell, porcelain GB, anticipated bariatric). Symptomatic gallstones (biliary colic without acute cholecystitis) — elective laparoscopic cholecystectomy due to ~20% risk of complications/year + recurrent attacks. UDCA medical dissolution — only small (< 5 mm) cholesterol stones in functioning GB with mild symptoms; high recurrence. Acute cholecystitis (Tokyo 2018): early laparoscopic cholecystectomy within 7 days preferred over delayed (CHOCOLATE, ACDC trials); percutaneous cholecystostomy if non-operative candidate.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 42 ปี BMI 32 มาด้วยอาการปวด RUQ หลังกินอาหารมันๆ 6 ชั่วโมง ไม่มีไข้

VS: BP 124/78, HR 92, RR 16, Temp 37.0°C
Abdomen: tender RUQ, Murphy''s sign negative, no peritonitis
Lab: WBC 9,200, ALP normal, total bili 0.8, AST/ALT normal, lipase 38 (normal)
US abdomen: multiple gallstones in GB, GB wall 2 mm (normal), no pericholecystic fluid, CBD 5 mm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Post-cholecystectomy bile leak + retained CBD stone — multimodal management"},{"label":"C","text":"Re-operation laparotomy immediately for all leaks"},{"label":"D","text":"Oral antibiotics + outpatient"},{"label":"E","text":"Liver transplantation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-cholecystectomy bile leak + retained CBD stone — multimodal management**: (1) **ERCP with sphincterotomy + stone extraction + biliary stent** — addresses both: relieves CBD obstruction, decompresses biliary tree, allows leak to seal (lower pressure system); (2) **Percutaneous drainage** of biloma if symptomatic localized collection; (3) **IV antibiotic** (covering biliary flora — ceftriaxone + metronidazole or piperacillin-tazobactam); (4) **Monitor LFTs**, repeat imaging; remove stent 4-8 wk later; (5) **Re-operation** if: large duct injury (Bismuth-Strasberg classification — E1-E5 hilar injuries need hepaticojejunostomy), failed ERCP/PTC drainage, peritonitis, severe sepsis; (6) **Strasberg classification of bile duct injuries**: A — cystic duct or aberrant duct leak, B/C — aberrant right duct, D — lateral injury of CBD, E1-E5 hilar injuries (more complex); (7) Tertiary HPB referral for major injuries

---

Bile duct injury post-laparoscopic cholecystectomy — 0.3-0.6% incidence. Cystic duct stump leak (Strasberg A) — most common; managed with ERCP + stent (relieves resistance), drain if collection. Major duct injury (Strasberg E1-E5) — need hepaticojejunostomy (Roux-en-Y) by HPB surgeon, ideally referred to tertiary center. Retained CBD stones — incidence 5-15%; ERCP + sphincterotomy gold standard. Strasberg-Bismuth classification systematizes injury type + guides management. Early recognition + appropriate management critical — delayed/missed injuries → biliary cirrhosis, recurrent cholangitis, death.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 60 ปี post-laparoscopic cholecystectomy day 1 มาด้วยอาการตัวเหลือง ปวด RUQ ไข้ขึ้น

VS: BP 118/76, HR 102, Temp 38.4°C
Lab: Total bili 3.8 (preop 0.6), Direct 2.9, ALP 380, AST 180, ALT 142
US: free fluid RUQ + dilated CBD 9 mm, no GB (s/p removal)
MRCP: leak from cystic duct stump + dilated intrahepatic ducts + retained CBD stone 8 mm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Upfront Whipple immediately"},{"label":"B","text":"Borderline resectable pancreatic adenocarcinoma — neoadjuvant + restaging approach"},{"label":"C","text":"Sorafenib"},{"label":"D","text":"Liver transplant"},{"label":"E","text":"Palliative care only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Borderline resectable pancreatic adenocarcinoma — neoadjuvant + restaging approach**: (1) **Multidisciplinary tumor board** — pancreatic surgery + medical oncology + radiation + IR + GI; (2) **Biliary decompression** if jaundice severe + chemotherapy planned — endoscopic biliary stent (metal stent preferred per recent evidence, vs plastic — longer patency); avoid pre-op stenting in clearly resectable to prevent infection (PreVerstent trial considerations); (3) **Neoadjuvant chemotherapy** — modified FOLFIRINOX (preferred fit patients) OR gemcitabine + nab-paclitaxel × 3-6 months — improves R0 resection rate, treats micro-mets, identifies aggressive biology; (4) **Restaging** post-neoadjuvant — CT, CA 19-9 (response marker), PET if uncertain; (5) **Resection** if response/stable + remains technically resectable: pancreaticoduodenectomy (Whipple) — pylorus-preserving or classic + standard lymphadenectomy; vascular reconstruction (SMV/PV resection) as needed; (6) **Adjuvant chemo** completion (6 mo total perioperative); (7) **Adjuvant RT** considered selected R1 / positive margins; (8) **Surveillance** post-op: CA 19-9 + CT q3 mo × 2 yr; (9) **Genetic testing** considered (BRCA, Lynch — PALB2, ATM — actionable)

---

Pancreatic adenocarcinoma resectability (NCCN): - Resectable: no arterial contact, ≤ 180° venous contact without irregularity - Borderline resectable: SMA/CHA/celiac ≤ 180°, SMV/PV > 180° contact with reconstruction possible, short occlusion reconstructible - Locally advanced: SMA/celiac > 180°, unreconstructible venous, aortic involvement - Metastatic: distant disease Neoadjuvant FOLFIRINOX has shifted paradigm — better R0 rate, OS in borderline resectable (PRODIGE/SWOG, PREOPANC, A021501 trials). Adjuvant FOLFIRINOX × 6 mo standard for resected (PRODIGE 24). Median OS resected ~ 36 mo vs 12-16 mo non-resected with chemo. Courvoisier sign: palpable non-tender GB + jaundice → suggests malignant biliary obstruction (not gallstones, which scar GB).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 58 ปี ตัวเหลืองมา 3 สัปดาห์ + คันตามตัว + น้ำหนักลด 6 kg ใน 2 เดือน + ปวดท้องตื้อๆ + Courvoisier sign + (palpable non-tender GB)

VS stable
Lab: Total bili 16, Direct 13, ALP 680, GGT 540, CA 19-9 240
CT abdomen: 3 cm mass at pancreatic head + dilated CBD + dilated PD (double duct sign) + atrophic distal pancreas + no liver/peritoneal metastases + SMA + SMV: ≤ 180° contact = borderline resectable; CA + celiac artery free
FNA: pancreatic adenocarcinoma';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue medical therapy only"},{"label":"B","text":"Chronic pancreatitis with dilated MPD, intraductal stones, intractable pain + complications"},{"label":"C","text":"Total pancreatectomy + islet cell autotransplantation immediately"},{"label":"D","text":"Pancreatic resection for all chronic pancreatitis"},{"label":"E","text":"Opioid escalation only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Chronic pancreatitis with dilated MPD, intraductal stones, intractable pain + complications**: (1) **Optimize medical first**: pain control multimodal (avoid chronic opioids if possible; gabapentinoids, TCA, multimodal), pancreatic enzyme replacement (PERT — 25,000-50,000 units lipase per meal), DM control (insulin), nutritional support, alcohol cessation absolute, smoking cessation, fat-soluble vitamins (ADEK); (2) **Endoscopic therapy** trial first for select: ERCP + sphincterotomy + stone extraction ± lithotripsy + PD stent — symptom relief 50-65% short-term; less invasive; (3) **Surgical drainage / resection** for: failed endoscopic, large MPD ≥ 6 mm + intractable pain, inflammatory mass head — options: - **Puestow procedure (lateral pancreaticojejunostomy Roux-en-Y)** — for diffusely dilated MPD; pain relief 70-80% - **Frey procedure** — core excision of pancreatic head + LPJ; for head-dominant disease - **Beger procedure** — duodenum-preserving pancreatic head resection; for inflammatory head mass - **Pancreaticoduodenectomy (Whipple)** — when suspect malignancy; (4) **Pseudocyst management**: > 6 cm, symptomatic, complications → endoscopic cyst gastrostomy / cystoduodenostomy OR surgical drainage; (5) **Surveillance for HCC and pancreatic cancer** elevated risk; (6) Multidisciplinary chronic pain management

---

Chronic pancreatitis surgical management — pain + complications when medical inadequate. ESCAPE trial (NEJM 2020) — early surgery (< 18 mo symptoms) > endoscopic-first approach for pain. Procedure selection by anatomy: - Dilated MPD (≥ 6 mm) diffuse → Puestow/LPJ - Head-dominant + dilated duct → Frey - Inflammatory head mass + suspect malignancy → Beger or Whipple - Small duct + diffuse → consider total pancreatectomy + islet auto-tx in select centers Cambridge classification of CP severity. Total pancreatectomy with islet cell autotransplantation — for refractory severe pain in select younger patients with diffuse disease. Pseudocyst drainage when symptomatic / > 6 cm / complications. PERT essential for exocrine insufficiency. Insulin for type 3c DM. Risk of pancreatic Ca increased 2-3x in CP — surveillance considered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 65 ปี alcoholic chronic pancreatitis ปวดท้องเรื้อรัง 10 ปี + steatorrhea + DM type 3c + น้ำหนักลด

MRCP: dilated main pancreatic duct 9 mm with multiple stones + atrophic parenchyma; pseudocyst 4 cm; no malignancy
CA 19-9 normal

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical resection"},{"label":"B","text":"Advanced HCC (BCLC C — portal vein invasion) — systemic therapy first-line"},{"label":"C","text":"TACE alone"},{"label":"D","text":"Liver transplant immediately"},{"label":"E","text":"Observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Advanced HCC (BCLC C — portal vein invasion) — systemic therapy first-line**: (1) **Atezolizumab + bevacizumab** — first-line per IMbrave150 (NEJM 2020): improved OS + PFS vs sorafenib; caveats — esophageal varices must be screened + treated (bevacizumab bleeding risk); Child-Pugh A optimal, B with caution; (2) **Durvalumab + tremelimumab (STRIDE)** — alternative first-line per HIMALAYA, avoids bevacizumab in varices; (3) **Lenvatinib** — alternative if immunotherapy contraindicated; (4) **Sorafenib** — historical first-line; (5) **Treat underlying HBV** — antiviral (entecavir, tenofovir) lifelong — slow cirrhosis progression + reduces HCC recurrence; (6) **Treat portal HTN complications**: beta-blocker (carvedilol preferred in compensated, caution decompensated), variceal surveillance + banding, ascites diuretic + sodium restriction; (7) **Liver transplant consideration**: outside Milan due to vascular invasion → typically excluded; downstaging protocols (TACE/Y90) may allow listing if response + size criteria met; (8) **TACE/Y90** for select macrovascular invasion but reduced efficacy; (9) **Surgical resection contraindicated** typically — portal vein invasion = BCLC C; (10) **Palliative care integration**

---

BCLC C HCC (advanced) — portal vein invasion, lymph node, distant mets, ECOG 1-2. Standard first-line: - Atezolizumab + bevacizumab (IMbrave150) — preferred Child-Pugh A; OS 19.2 mo - Durvalumab + tremelimumab STRIDE (HIMALAYA) — alternative, no bev → safer with varices - Lenvatinib (REFLECT) — non-inferior to sorafenib - Sorafenib — historic Second-line: regorafenib, cabozantinib, ramucirumab (AFP > 400), nivolumab/pembrolizumab. Liver transplant criteria: Milan (1 ≤ 5 cm OR 2-3 ≤ 3 cm) — gold standard. Expanded (UCSF) sometimes used. Vascular invasion typically excluded. Downstaging with TACE/Y90 in selected protocols. HBV antiviral therapy reduces HCC recurrence post-treatment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 55 ปี HBV chronic + cirrhosis Child-Pugh B7 + portal HTN — Ascites moderate, prior variceal bleed banded; HCC 5 cm at segment IV + portal vein branch invasion + AFP 8,000

MELD 14; no extrahepatic disease; Child-Pugh B (bili 2.4, albumin 2.9, INR 1.5, ascites moderate, no encephalopathy)

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery alone (esophagectomy)"},{"label":"B","text":"Locally advanced esophageal SCC (cT3N1) — multimodal treatment"},{"label":"C","text":"Chemo alone"},{"label":"D","text":"Radiation alone"},{"label":"E","text":"Endoscopic mucosal resection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Locally advanced esophageal SCC (cT3N1) — multimodal treatment**: (1) **Neoadjuvant chemoradiotherapy (CRT) then surgery** — CROSS regimen: carboplatin + paclitaxel + concurrent RT 41.4 Gy/23 fractions × 5 weeks; improves OS + R0 rate (van Hagen NEJM 2012); (2) **Restaging** 4-6 weeks post-CRT — CT, EUS, PET; (3) **Esophagectomy** — Ivor Lewis (right thoracotomy + abdominal) for distal/mid-esophageal; transhiatal or McKeown (3-field) for upper; minimally invasive (MIE) acceptable; (4) **Lymphadenectomy** — 2-field (mediastinal + abdominal) standard; 3-field (cervical) for upper esophageal SCC selected centers; (5) **Reconstruction** — gastric conduit standard; jejunum or colon if stomach unsuitable; (6) **Adjuvant** — nivolumab × 1 year post-resection if residual disease after neoadjuvant (CheckMate 577); (7) **Definitive CRT** alternative for cervical SCC OR non-surgical candidates; (8) **Surveillance** + nutritional optimization (J-tube during/post)

---

Esophageal cancer — SCC (upper-mid, alcohol/smoking risk) vs adenocarcinoma (distal, Barrett''s, GERD, obesity). Staging: EUS for T/N, CT chest/abd for distant, PET selectively. Trimodality (CRT + surgery) per CROSS for locally advanced (T2N+/T3-4 any N) — improves OS 5-yr 47% vs 33% surgery alone. CheckMate 577 — adjuvant nivolumab × 1 yr for incomplete pathologic response after neoadjuvant CRT — improves DFS. Definitive CRT (50-50.4 Gy + chemo) — cervical SCC, refusal/unfit for surgery. Esophagectomy approaches: - Ivor Lewis: distal/mid - McKeown 3-field: mid/upper - Transhiatal: avoid thoracotomy MIE associated with less morbidity (TIME trial).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 50 ปี smoker, dysphagia 3 เดือน รุนแรงขึ้น น้ำหนักลด 8 kg

EGD: ulcerative mass at mid-esophagus 32 cm from incisors, biopsy = squamous cell carcinoma
EUS: T3 invading muscularis propria, N1 (2 periesophageal nodes); no celiac nodes
CT chest/abd: no distant mets
PET: localized disease + 1 supraclavicular node SUV 4 (equivocal) — FNA negative

Clinical T3 N1 M0 — Stage III esophageal SCC';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + PPI"},{"label":"B","text":"Symptomatic large paraesophageal hernia (type III) with gastric volvulus + complications (Cameron erosions, anemia, dysphagia) — surgical repair"},{"label":"C","text":"Endoscopic dilation only"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"Heller myotomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Symptomatic large paraesophageal hernia (type III) with gastric volvulus + complications (Cameron erosions, anemia, dysphagia) — surgical repair**: (1) **Laparoscopic paraesophageal hernia repair** (gold standard — Stylopoulos vs open): - Sac dissection + reduction of stomach into abdomen - Crural repair (primary suture; mesh reinforcement controversial — biological mesh selected, synthetic avoid for erosion risk) - Fundoplication (Nissen 360° or Toupet 270°) to address reflux + prevent recurrence - Consider gastropexy in selected; (2) **Type III PEH**: combined sliding + paraesophageal — GEJ above diaphragm + portion of stomach beside esophagus; (3) **Indications for elective repair**: symptomatic (reflux, dysphagia, anemia, obstruction), large hernia > 50% intrathoracic, volvulus, recurrent complications; (4) **Emergent indications**: incarceration, strangulation, perforation, obstruction — high mortality 15-20% if delayed; (5) **Pre-op**: PPI, anemia workup, transfuse PRBC if symptomatic; nutritional optimization; (6) **Post-op**: gastric reflux still possible; recurrence rate 10-25% at 5 years (less with mesh); (7) Risk-benefit discussion — elderly + comorbid → balance

---

Hiatal hernia classification: - Type I (sliding) — most common, GEJ displaced into chest - Type II (true paraesophageal) — gastric fundus beside esophagus, GEJ intra-abdominal - Type III (mixed sliding + paraesophageal) — most common PEH - Type IV — other organs herniated (colon, spleen) Asymptomatic PEH — observation generally (Stylopoulos approach — watchful waiting; risk of emergency low ~1%/yr but high mortality if emergent). Symptomatic PEH — elective laparoscopic repair. Cameron lesions — gastric erosions/ulcers in hernia sac at diaphragmatic hiatus — cause chronic GI bleeding + iron deficiency anemia. Surgical principles: sac dissection, complete reduction, crural closure, antireflux procedure (Nissen most common; Toupet if dysmotility / poor esophageal contractility). Mesh use controversial — meta-analyses show reduced short-term recurrence but erosion + esophageal stricture risk with synthetic; biologic acceptable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 70 ปี dysphagia + reflux 6 เดือน + iron deficiency anemia

EGD: large 8 cm paraesophageal hernia type III + organoaxial gastric volvulus + Cameron erosions in herniated stomach
CT: > 50% stomach in chest + obstruction signs at GEJ

Symptoms: dysphagia worsening + intermittent chest pain + early satiety + anemia

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bariatric not indicated at this BMI"},{"label":"B","text":"Bariatric surgery candidate (BMI > 40 OR BMI > 35 with obesity-related comorbidities — ASMBS 2022 update lowered threshold)"},{"label":"C","text":"Liposuction"},{"label":"D","text":"Gastric balloon as definitive"},{"label":"E","text":"Refer to psychiatry only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Bariatric surgery candidate (BMI > 40 OR BMI > 35 with obesity-related comorbidities — ASMBS 2022 update lowered threshold)**: (1) **Multidisciplinary evaluation**: dietitian, psychologist, endocrinology, gastroenterology — preoperative weight loss, nutritional assessment, medical optimization, psychiatric clearance, smoking cessation; (2) **Procedure options**: - **Roux-en-Y gastric bypass (RYGB)** — gold standard; greater + more durable weight loss, better DM resolution, more GERD improvement; complexity higher; risks: marginal ulcer, internal hernia, dumping, nutritional deficiency - **Sleeve gastrectomy (LSG)** — most common globally; simpler; less weight loss than RYGB but acceptable durability; risks: leak (staple line), GERD worsening (Barrett''s screening) - **Duodenal switch (BPD-DS) / SADI-S** — most weight loss but more nutritional issues; reserved superobese - **Adjustable gastric band (LAGB)** — historic, declining use; lowest efficacy + durability; (3) **Outcomes**: 60-70% excess weight loss at 1-2 yr; DM remission 50-80% (DiaRem score predicts); HT, OSA, dyslipidemia improvement; mortality reduction (Sjöström SOS study); (4) **Lifelong vitamin + mineral supplementation** + nutritional surveillance + medical follow-up; (5) **Psychological** — eating disorder screening + ongoing support; (6) **DM**: SO bariatric surgery (Metabolic Surgery)** — 2nd-line for T2DM BMI ≥ 30 not controlled (joint statements); (7) Pregnancy — wait 12-18 months post-op + folic acid + vitamin supplementation

---

**Bariatric / metabolic surgery indications** (ASMBS-IFSO 2022 update — lowered thresholds): - BMI ≥ 35 regardless of comorbidities - BMI 30-34.9 with metabolic disease (T2DM, NAFLD/MASH) - Asian populations: BMI 27.5-32.5 with comorbidities considered Historical NIH 1991 was BMI > 40 OR > 35 + comorbidity. **Mechanism of weight loss + metabolic improvement**: restriction (anatomical), malabsorption (RYGB, DS), neurohormonal (ghrelin, GLP-1, PYY changes). **Outcomes**: - %EWL: LSG ~ 50-60%, RYGB ~ 60-70%, DS ~ 70-80% - DM remission: highest with DS > RYGB > LSG (STAMPEDE trial 5-yr) - HT, OSA, MASH improvement substantial - Mortality 30-40% reduction long-term (Sjöström SOS) **Complications**: leak, bleeding, stenosis, internal hernia, marginal ulcer, dumping, nutritional deficiency (iron, B12, calcium, vit D, thiamine in rapid loss). **Pregnancy** — defer 12-18 mo for stable weight + nutrition. **Endoscopic options**: gastric balloons (temporary), endoscopic sleeve (under investigation) — bridging or non-surgical candidates. A ผิด — meets criteria. C ผิด — cosmetic, not metabolic. D ผิด — temporary. E ผิด — already cleared.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 35 ปี BMI 42 (severe obesity class III), DM type 2 controlled HbA1c 7.2, HT, OSA, depression — ลองอาหารควบคุมหลายปีไม่สำเร็จ ต้องการลดน้ำหนักถาวร

VS stable, lab acceptable, psychological evaluation cleared

คำถาม: ตัวเลือก bariatric surgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"NG decompression + observation 48 hr"},{"label":"B","text":"Internal hernia post-RYGB — surgical emergency"},{"label":"C","text":"Outpatient EGD"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Reverse RYGB"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Internal hernia post-RYGB — surgical emergency**: (1) **Resuscitation** + NG decompression + IV fluid + surgical consultation; (2) **Emergent diagnostic laparoscopy / laparotomy** — high suspicion + whirl sign on CT — do NOT delay; (3) **Operative findings**: 3 possible defect sites post-RYGB: - **Petersen''s defect** — between Roux limb mesentery + transverse mesocolon - **Jejunojejunostomy mesenteric defect** - **Transverse mesocolon defect** (if retrocolic Roux limb); (4) **Reduce** internally herniated bowel; **assess viability** — resect non-viable; (5) **Close all mesenteric defects with non-absorbable suture** to prevent recurrence; (6) **Postop**: bowel rest, gradual feeding, nutritional optimization; (7) **High mortality** if delayed (bowel ischemia in closed loop) — modern series mortality ~ 1-3% with timely intervention vs >20% delayed; (8) Counsel patient about lifelong risk + symptom recognition

---

Internal hernia post-bariatric (RYGB) — incidence 1-5%; cause of significant late morbidity. Mesenteric defects created during RYGB heal poorly + may not be closed routinely (controversy — current trend toward routine closure with non-absorbable suture). Three sites: 1. Petersen''s defect (between Roux limb mesentery + transverse mesocolon) 2. Jejunojejunostomy defect 3. Transverse mesocolon defect (retrocolic technique) Antecolic Roux limb construction → only Petersen''s + JJ defects (preferred technique). Diagnosis: high index of suspicion in any post-RYGB patient with abdominal symptoms. CT signs: mesenteric swirl/whirl sign (twisted vessels), SBO, mesenteric edema, hurricane sign. Plain CT may be falsely negative — symptoms + clinical alone may warrant diagnostic laparoscopy. Treatment: emergent reduction + defect closure. Bowel ischemia common — assess viability carefully. Post-op recurrence with simple closure 5-10%; non-absorbable suture preferred. Patient education + early ED visit for symptoms key.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 65 ปี post-Roux-en-Y gastric bypass 3 ปี มาด้วยอาการปวดท้องเรื้อรังเป็นพักๆ 6 เดือน + คลื่นไส้อาเจียน ครั้งล่าสุด acute severe + bilious vomiting 24 hr ก่อน

VS: BP 102/64, HR 116, RR 22, Temp 37.0°C
Abdomen: distended, tender diffuse, sluggish bowel sounds

Lab: WBC 14,800, lactate 3.4
CT abdomen: ''mesenteric whirl sign'' + small bowel obstruction + dilated alimentary limb';

update public.mcq_questions
set choices = '[{"label":"A","text":"Insulin therapy"},{"label":"B","text":"Dumping syndrome post-gastrectomy — early + late dumping symptoms"},{"label":"C","text":"PPI long-term"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"Antibiotic for SIBO"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Dumping syndrome post-gastrectomy — early + late dumping symptoms**: (1) **Early dumping** (within 30 min): rapid emptying of hyperosmolar food → fluid shift into bowel + vasoactive substance release → tachycardia, sweating, flushing, abdominal cramps; (2) **Late dumping** (1-3h): rapid carbohydrate absorption → insulin spike → reactive hypoglycemia; this patient has both; (3) **Dietary management first-line** (75% improve): - **Small frequent meals** 6-8/day - **Low simple carb / high complex carb + protein + fat** - **Avoid hyperosmolar liquids** with meals — separate fluid from solid 30-60 min - **Pectin/guar gum** soluble fiber to slow gastric emptying - **Lie down 30 min post-meal**; (4) **Acarbose** — α-glucosidase inhibitor — slows carb absorption → reduces late dumping (reactive hypoglycemia); (5) **Octreotide** — somatostatin analog — slows GI transit + inhibits insulin/vasoactive peptides; SC short-acting before meals OR LAR depot monthly — refractory cases; (6) **Surgical revision** for refractory severe (< 5%): - Reconstruction with Roux limb (if Billroth I/II) - Antireflux procedure - Pyloric reconstruction (Henley loop, jejunal interposition); (7) **Nutritional follow-up** + monitoring B12, iron, calcium, vit D

---

Dumping syndrome — common post-gastrectomy / pyloroplasty / RYGB. Pathophysiology: 1. Early (osmotic + vasomotor): hyperosmolar bolus into small bowel → fluid shift, release of vasoactive intestinal peptides (VIP, neurotensin, serotonin) → tachycardia, flushing, sweating, cramps 2. Late (hypoglycemic): rapid glucose absorption → hyperinsulinism → reactive hypoglycemia 30 min - 3h post-meal Diagnosis: clinical + Sigstad score (≥ 7 suggests dumping); oral glucose challenge with hypoglycemia + tachycardia. Treatment ladder: 1. Diet modification (75% effective) 2. Acarbose for late dumping 3. Octreotide SC pre-meal or LAR for refractory 4. Surgical revision rarely needed Post-RYGB hypoglycemia (''post-bariatric hypoglycemia'') — late dumping variant, increasingly recognized; lifestyle + acarbose + diazoxide considered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 45 ปี post-gastrectomy 2 ปีก่อนสำหรับ gastric ulcer มา outpatient ด้วย persistent watery diarrhea + flushing 15 นาทีหลังกิน + palpitation + sweating + drowsiness ก่อนกินอาหารบ่อย ๆ

Glucose during episodes 48 mg/dL
Upper GI series: small gastric remnant + rapid emptying

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative observation"},{"label":"B","text":"Blunt Thoracic Aortic Injury (BTAI) — modern preferred: thoracic endovascular aortic repair (TEVAR)"},{"label":"C","text":"Anticoagulation only"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Wait 1 week for elective repair"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Blunt Thoracic Aortic Injury (BTAI) — modern preferred: thoracic endovascular aortic repair (TEVAR)**: (1) **Acute resuscitation + permissive hypotension** SBP 100-120 (lower if no head injury) + heart rate control (esmolol or labetalol) to reduce shear stress on aorta — ''impulse control'' (dP/dt reduction); (2) **Grade-based management** (SVS BTAI classification): - Grade I (intimal tear): observation + medical (impulse control); - Grade II (intramural hematoma): selective intervention; - Grade III (pseudoaneurysm): **TEVAR within 24h** — improved survival vs open in modern era (NTDB data, AAST PROOVIT registry); - Grade IV (rupture): emergent TEVAR; (3) **TEVAR**: percutaneous femoral access, stent-graft deploy across injury; may require LSCA coverage (consider revascularization if dominant); (4) **Open repair** alternative — if TEVAR not feasible (anatomy, no graft) — left thoracotomy + clamp + interposition graft; higher morbidity; (5) **Address concurrent injuries** — TBI, abdominal, etc.; balance permissive hypotension vs head injury; (6) ICU + multidisciplinary trauma

---

**Blunt Thoracic Aortic Injury (BTAI)** — usually at aortic isthmus (just distal to L subclavian artery — relatively fixed ligamentum arteriosum). Result of rapid deceleration (MVC, fall, blast). 80-85% die at scene; remaining present with widened mediastinum, hypotension. Diagnosis: CXR signs (widened mediastinum > 8 cm, apical cap, indistinct knob, depressed L mainstem bronchus, tracheal deviation R, NG tube deviation R, L pleural effusion) → CT angiography gold standard. SVS BTAI Grading: - I: intimal tear - II: intramural hematoma - III: pseudoaneurysm (most common needing intervention) - IV: rupture / transection Management evolution: open repair → TEVAR (since 2010s). Modern era: TEVAR < 24h preferred — reduced mortality, paraplegia (vs open clamp/sew). Anatomical considerations: proximal landing zone, LSCA coverage (consider revascularization), femoral access. Impulse control medical therapy critical — beta-blocker (esmolol) to reduce dP/dt + shear; SBP target lower; concurrent TBI requires balanced BP target. A C D E ผิด — grade III ต้อง intervention urgent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 28 ปี ตกจากที่สูง โดน blunt chest trauma

VS: BP 110/72, HR 102, RR 20, SpO2 95% room air
Chest: tenderness left chest, no flail, mild crepitus
CXR: widened mediastinum > 8 cm + indistinct aortic knob + left apical cap + depressed left mainstem bronchus
CT chest angiography: blunt thoracic aortic injury at isthmus (just distal to L subclavian) — grade III (pseudoaneurysm) + mediastinal hematoma; no contrast extravasation

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral calcium carbonate alone"},{"label":"B","text":"Symptomatic post-thyroidectomy hypocalcemia (likely transient hypoparathyroidism from parathyroid trauma/devascularization)"},{"label":"C","text":"Furosemide"},{"label":"D","text":"Steroid IV"},{"label":"E","text":"Discharge with PO calcium"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Symptomatic post-thyroidectomy hypocalcemia (likely transient hypoparathyroidism from parathyroid trauma/devascularization)**: (1) **IV calcium gluconate 10% 10 mL slow IV bolus over 10 min** (3-4 mL contains 1 g — provides 90 mg elemental Ca per amp) — repeat as needed + continuous infusion if persistent (e.g., 1 g calcium gluconate in 100 mL D5W at 50 mL/h titrate); (2) **Repeat Ca q4-6h**; (3) **Activated vitamin D (calcitriol)** 0.25-0.5 mcg PO BID — bypasses PTH-dependent activation; (4) **Oral calcium carbonate** 1-2 g elemental Ca q6h between meals (better absorbed); (5) **Replete magnesium** — Mg essential for PTH function + Ca release; IV MgSO4 1-2 g if Mg < 1.8; (6) **ECG monitoring** — prolonged QT → torsade risk; (7) **Differentiate transient vs permanent hypoparathyroidism**: transient 6 mo follow-up; permanent if PTH not recovering — continue lifelong Ca + calcitriol; consider PTH replacement (recombinant PTH 1-84); (8) **Hungry bone syndrome** consideration in pre-op hyperparathyroid patients post-parathyroidectomy — rapid Ca uptake into bones; same management

---

**Post-thyroidectomy hypocalcemia** — common (10-30% transient, 1-3% permanent post-total thyroidectomy). Causes: 1. Parathyroid trauma / devascularization / inadvertent removal 2. Hungry bone syndrome — patients with severe pre-op hyperparathyroidism (rapid Ca deposition into bones post-correction) 3. Hypomagnesemia impairing PTH function/secretion **Symptoms**: perioral + acral paresthesias, muscle cramps, Chvostek sign (facial twitch on tapping facial nerve at zygomatic arch), Trousseau sign (carpal spasm with BP cuff inflation), tetany, laryngospasm, seizures, prolonged QT → torsades **Severity grading**: - Mild (Ca 8.0-8.4): oral Ca + calcitriol - Moderate (Ca 7.0-7.9): oral + close monitoring - Severe (Ca < 7.0 or symptomatic): IV calcium gluconate + infusion **IV Ca preparation**: - Calcium gluconate 10% 10 mL = 1 g = 90 mg elemental Ca (preferred — less tissue necrosis if extravasate) - Calcium chloride 10% 10 mL = 1 g = 270 mg elemental Ca (central line preferred — sclerosant) Always concurrently replete Mg + vitamin D. PTH check — distinguishes hypoparathyroid (low PTH) from other causes. Lifelong management of permanent hypoparathyroidism: calcium + calcitriol; recombinant PTH 1-84 for selected.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 32 ปี post-thyroidectomy total day 1 มาด้วยอาการ tetany, perioral numbness, tingling fingers, positive Chvostek + Trousseau signs

VS stable
Lab: Ca 6.4 (low), ionized Ca 0.8, Mg 1.6, PO4 5.2, PTH 8 (low normal), albumin 4.0
ECG: prolonged QTc

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + repeat Ca/PTH in 1 year"},{"label":"B","text":"Primary hyperparathyroidism with surgical indication → minimally invasive parathyroidectomy"},{"label":"C","text":"Calcimimetic (cinacalcet) lifelong only"},{"label":"D","text":"Total thyroidectomy"},{"label":"E","text":"Bisphosphonate alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Primary hyperparathyroidism with surgical indication → minimally invasive parathyroidectomy**: (1) **Surgical indications (4th International Workshop 2014)** for asymptomatic PHPT: - Age < 50 - Serum Ca > 1.0 mg/dL above upper limit normal (this patient 11.4 likely meets) - 24h urine Ca > 400 - eGFR < 60 - Nephrolithiasis or nephrocalcinosis - BMD T-score ≤ -2.5 OR vertebral fracture - Inability/refusal medical surveillance - This patient meets multiple → surgery indicated; (2) **Pre-op localization**: sestamibi scan + neck US (concordant → MIP feasible); 4D-CT if discordant; (3) **Minimally invasive parathyroidectomy (MIP)** — focused exploration of localized adenoma; intraoperative PTH monitoring (50% drop from baseline at 10 min post-excision predicts cure); (4) **Bilateral neck exploration** if non-localizing, multi-gland, family history MEN; (5) **Intraoperative PTH (IoPTH)** — drop ≥ 50% from highest pre-excision + into normal range = cure (Miami criterion); (6) **Address vitamin D deficiency** pre-op cautiously (may worsen hypercalcemia in PHPT — controversial — replete moderately); (7) **Post-op monitoring**: Ca, PTH; risk of hungry bone syndrome; (8) **Cure rate** > 95% in expert hands

---

**Primary hyperparathyroidism (PHPT)** — high Ca + high (or inappropriately normal) PTH. Most common cause of hypercalcemia in outpatients. Etiology: 85% single adenoma, 10-15% 4-gland hyperplasia (sporadic or MEN 1/2A), 1% parathyroid cancer. **Symptoms** (classic ''stones, bones, abdominal groans, psychic moans''): nephrolithiasis, osteoporosis/fractures, abdominal pain (PUD, pancreatitis), neuropsychiatric (depression, fatigue), polyuria. Many asymptomatic on screening. **4th International Workshop 2014 surgical indications** (asymptomatic): - Ca > 1.0 above ULN - 24h urine Ca > 400 + kidney stone risk - eGFR < 60 - Nephrolithiasis/nephrocalcinosis - T-score ≤ -2.5 or vertebral fracture - Age < 50 - Refusal/inability for surveillance - Symptomatic — always surgery **Localization**: sestamibi + US (concordant = MIP); 4D-CT if uncertain; MRI; PET-CT (parathyroid). **MIP**: focused approach to localized adenoma; IoPTH guides extent (Miami criterion: 50% drop into normal range = cure). **MEN consideration**: family history, young age — 4-gland exploration; subtotal vs total parathyroidectomy + autotransplant. **Cinacalcet**: calcimimetic — selected non-operative candidates; doesn''t address bone loss. A ผิด — meets surgical criteria. C ผิด — surgery curative. D ผิด — thyroidectomy ไม่ใช่ PHPT. E ผิด — surgery first-line.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 45 ปี ตรวจสุขภาพประจำปี พบ Ca 11.4 (high) + PTH 145 (high) + iPTH elevated + 24h urine Ca 380 (elevated) + Vit D 25-OH 22 (slightly low)

No bone disease, no nephrolithiasis on US, no DM
BMD: T-score -2.1 hip (osteopenia)
Sestamibi scan: positive single adenoma in right inferior parathyroid

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Beta-blocker first then surgery"},{"label":"B","text":"Pheochromocytoma — proper preoperative alpha-blockade BEFORE surgery (critical to prevent intraoperative hypertensive crisis)"},{"label":"C","text":"Surgery immediately without medical preparation"},{"label":"D","text":"Radiotherapy"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pheochromocytoma — proper preoperative alpha-blockade BEFORE surgery (critical to prevent intraoperative hypertensive crisis)**: (1) **Alpha-blockade FIRST** — phenoxybenzamine (non-selective irreversible) 10 mg BID, titrate q2-3 days to 0.5-1 mg/kg/day OR doxazosin (alpha-1 selective) 1-16 mg/day — for 10-14 days; goal: BP normotensive supine + mild orthostasis upon standing; (2) **Beta-blockade ONLY AFTER alpha-blockade established** (NEVER before — unopposed alpha → hypertensive crisis) — to control reflex tachycardia; propranolol or atenolol; (3) **High-sodium diet + IV fluid** preop — restore intravascular volume (chronic vasoconstriction has reduced); (4) **Calcium channel blocker** as adjunct (nicardipine, amlodipine); (5) **Adrenalectomy** — laparoscopic retroperitoneal OR transabdominal approach for benign-appearing < 6-8 cm; open for larger / malignant / invasive; minimize tumor manipulation (catecholamine release); ligate adrenal vein early; (6) **Intraop**: anesthesia team prepared with vasodilators (nitroprusside, phentolamine), beta-blockers (esmolol), vasopressors (norepi, phenylephrine) — wide swings of BP; (7) **Post-op**: monitor for hypotension (rebound — vasodilation), hypoglycemia (rebound insulin), and persistent disease; ICU 24h; (8) **Pathology + genetic testing** — 30-40% pheochromocytoma have germline mutation (RET, VHL, NF1, SDH genes) — refer genetics; (9) **Lifelong surveillance** for recurrence + metachronous + second primary; (10) **''Rule of 10s'' historic** (now outdated): 10% extra-adrenal (paraganglioma), 10% bilateral, 10% malignant, 10% familial — actual percentages higher

---

**Pheochromocytoma / paraganglioma** — catecholamine-secreting tumor of chromaffin cells. Adrenal medulla (pheochromocytoma) or extra-adrenal (paraganglioma — head/neck, organ of Zuckerkandl, bladder). **Symptoms triad**: paroxysmal headache + palpitations + diaphoresis (90% specificity if all 3). HT (sustained or paroxysmal). **Biochemical diagnosis**: plasma free metanephrines (most sensitive ~99%) OR 24h urine fractionated metanephrines. Chromogranin A supportive. **Imaging**: CT/MRI adrenal — ''lightbulb'' enhancement; 123-I MIBG for functional confirmation + extra-adrenal; PET-DOTA for paraganglioma/metastatic. **Preop pharmacologic preparation** (critical — historic mortality 50% → < 3% with proper prep): - Alpha-blockade 10-14 days: phenoxybenzamine (non-selective irreversible), doxazosin (selective alpha-1) - High-sodium diet + IV fluid - Beta-blockade AFTER alpha-blockade (only for tachycardia) - Calcium channel blocker adjunct - Goal: SBP < 130, mild orthostasis **Surgery**: laparoscopic adrenalectomy (transabdominal or retroperitoneal); open for large > 6-8 cm, invasive, malignant. Minimize tumor manipulation, ligate adrenal vein early. **Postop**: hypotension (rebound), hypoglycemia (catecholamine-induced insulin suppression then rebound). Long-term: lifelong biochemical surveillance, genetic testing (30-40% germline mutation — RET, VHL, NF1, SDHB/C/D, MAX, TMEM127), screen first-degree relatives if positive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 48 ปี ภาวะ persistent hypertension + episodic palpitations + headaches + diaphoresis + hyperhidrosis + paroxysmal panic-like attacks

VS: BP 178/108 baseline; during attack 230/130
Lab: plasma metanephrine 3,200 (elevated 10x normal), normetanephrine 4,800 (elevated 8x normal), 24h urine VMA elevated; chromogranin A elevated
CT abdomen: 3.5 cm well-circumscribed enhancing mass at right adrenal
123-I MIBG scan: positive uptake at right adrenal

คำถาม: pre-op preparation + management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient referral elective surgery"},{"label":"B","text":"Incarcerated inguinal hernia with bowel obstruction — emergent surgical reduction + repair"},{"label":"C","text":"Observation + IV fluids only"},{"label":"D","text":"Laxatives"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Incarcerated inguinal hernia with bowel obstruction — emergent surgical reduction + repair**: (1) **Attempt manual reduction** (taxis) — gentle, with sedation + Trendelenburg, after analgesia + muscle relaxation — if successful + no strangulation suspected → elective repair within days (caution: bowel ischemia could be missed → re-evaluate carefully post-reduction); (2) **Emergent surgical exploration** if: cannot reduce, signs of strangulation (peritonitis, sepsis, dark/bloody hernia sac contents, severe pain disproportionate), bowel obstruction not relieved; (3) **Operative**: - **Open approach** (Lichtenstein with mesh) — standard, can assess viability easily - **Laparoscopic** (TEP, TAPP) — increasingly utilized; allows intra-abdominal bowel assessment; mesh may be avoided if bowel viability questionable - **Bowel assessment**: viable → reduce + repair with mesh; non-viable → resect + primary anastomosis; (4) **Mesh decision**: clean contaminated (bowel resected) — primary repair without mesh OR delayed mesh OR biological mesh (controversial — recent evidence permits prosthetic in many cases per Society guidelines); (5) **Post-op**: monitor for infection, recurrence; (6) Discuss bilateral repair if other side detectable

---

**Inguinal hernia** — common surgical problem. Indirect (most common, lateral to inferior epigastric vessels, congenital patent processus vaginalis) vs direct (medial, Hesselbach triangle, acquired weakness). Most asymptomatic; watchful waiting acceptable for asymptomatic minimally symptomatic (Fitzgibbons JAMA 2006 trial). **Indications for surgery**: symptoms, enlarging, recurrent obstruction risk. **Complications**: - Incarceration: irreducible without strangulation - Strangulation: ischemic bowel — emergency - Bowel obstruction **Approach**: - Open (Lichtenstein with mesh) — gold standard - Laparoscopic (TEP — totally extraperitoneal, TAPP — transabdominal preperitoneal) — comparable outcomes, bilateral repair easier, lower chronic pain - Recent evidence: laparoscopic equal/better re: chronic pain, return to work; cost higher **Mesh**: standard in adults (lower recurrence vs primary suture per evidence). Polypropylene most common. In contaminated field (strangulated bowel resection): biological mesh OR delayed repair OR primary suture; recent literature supports prosthetic mesh selectively. **Pediatric**: high ligation alone, no mesh; very low recurrence. **Femoral hernia**: more common in women, high incarceration risk → repair always upon diagnosis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องเฉียบพลัน LLQ 6 ชั่วโมง คลื่นไส้ ไม่อาเจียน ไม่เคยมีอาการก่อน

VS: BP 124/76, HR 88, RR 16, Temp 36.8°C
Abdomen: tender LLQ but no rebound; reducible inguinal hernia left side detected on exam — bulge over inguinal ligament
CT abdomen: incarcerated left inguinal hernia + small bowel obstruction at hernia site; bowel inside hernia sac, no signs of strangulation yet

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical hemorrhoidectomy first-line"},{"label":"B","text":"Grade III internal hemorrhoid — staged management starting non-operative + procedural"},{"label":"C","text":"Long-term opioid use"},{"label":"D","text":"Total proctocolectomy"},{"label":"E","text":"Observation lifelong"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Grade III internal hemorrhoid — staged management starting non-operative + procedural**: (1) **Conservative first-line**: high-fiber diet + adequate hydration + avoid straining + warm sitz baths + topical agents (analgesic, anti-inflammatory steroid short-term); (2) **Office-based procedures** for failed conservative or persistent grade I-III: - **Rubber band ligation (RBL)** — most effective office procedure; grade I-III; ~80% success; ligate above dentate line; avoid in anticoagulated patients (post-ligation bleeding 5-10 days); - **Infrared coagulation, sclerotherapy** — lower-grade alternatives; (3) **Surgical hemorrhoidectomy** for: grade IV, mixed internal-external, refractory grade III after RBL, complications (thrombosis, gangrene), patient preference - **Open (Milligan-Morgan) or closed (Ferguson) hemorrhoidectomy** — gold standard; remove diseased tissue; more painful but lower recurrence - **Stapled hemorrhoidopexy (Longo)** — less pain, faster recovery, higher recurrence + risk of severe complications (rectal stricture, sepsis); (4) **THD (transanal hemorrhoidal dearterialization) / HAL-RAR** — dearterialization with Doppler + mucopexy; less pain, mid-range recurrence; (5) **Address constipation + risk factors** lifelong

---

**Hemorrhoid grading** (internal — above dentate line): - Grade I: bleeding without prolapse - Grade II: prolapse with spontaneous reduction - Grade III: prolapse requiring manual reduction - Grade IV: irreducible / chronically prolapsed External hemorrhoids — below dentate line, somatic innervation (painful); thrombosed external — excise within 72h. **Treatment ladder**: 1. Lifestyle: fiber 25-35 g/day, water, sitz bath, topical 2. Office procedures (grade I-III RBL most effective) 3. Surgical hemorrhoidectomy (Milligan-Morgan open, Ferguson closed, Longo stapled, THD/HAL-RAR) — for severe / refractory / complications 4. Newer: laser hemorrhoidoplasty Avoid: chronic constipation, prolonged straining, prolonged sitting on toilet, NSAIDs (bleeding). Pregnancy: conservative + topical; surgery rarely needed (postpartum resolution).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 60 ปี ปวดทวารหนัก + เลือดออกหลังถ่าย 6 เดือน + ก้อนยื่นออก reducible

Exam: prolapsed grade III internal hemorrhoid (reducible manually), no thrombosis, no skin tag
No perianal disease, no fistula
Colonoscopy normal proximal

คำถาม: management';

commit;
