-- ===============================================================
-- หมอรู้ — Board seed: พยาธิวิทยา (pathology) — part 3/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('path_clinical_decision', 'พยาธิวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pathology', NULL, 0),
  ('path_basic_science', 'พยาธิวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pathology', NULL, 0),
  ('path_ems_mgmt', 'พยาธิวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pathology', NULL, 0),
  ('path_integrative', 'พยาธิวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'pathology', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ME case — found man with gunshot wound to head; postmortem exam — distinguishing entrance vs exit wounds, range determination, trajectory, and forensic ballistics workflow', '[{"label":"A","text":"Random"},{"label":"B","text":"Gunshot Wound Forensic Examination"},{"label":"C","text":"Skip"},{"label":"D","text":"Refuse"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gunshot Wound Forensic Examination: (1) **Entrance vs exit features**: - **Entrance**: usually round/oval; abrasion collar (skin scraped by spinning bullet); marginal abrasion irregular if angled; bullet wipe (dirt/lubricant); inverted edges; - **Exit**: usually larger, irregular/stellate; no abrasion collar (unless shored = pressed against surface); everted edges; (2) **Range of fire (entrance characteristics)**: - **Contact**: muzzle imprint, soot in wound track, seared edges, stellate tearing (gas under skin — head especially); - **Close-range (intermediate)**: < ~ 1 m — **stippling/tattooing** = embedded burnt+unburnt powder grains (in skin, not wipeable); soot if very close; - **Distant**: no stippling; (3) **Documentation**: - Photographs (with scale, ruler); - Diagrams; - Trajectory: external + internal — entrance to exit or terminal location; can suggest assailant position; - Wound dimensions, location anatomically + clothing + body landmarks; (4) **Bullet recovery + chain of custody**: - Recovered carefully without metal forceps (preserve striae for ballistics); - Labeled + sealed bag with documentation; - Chain of custody maintained for forensic ballistics + court; (5) **Tox + alcohol**: standard; (6) **Manner determination — homicide, suicide, accident, undetermined**: - Suicide indicators: contact wound, anatomically accessible site (temple ipsilateral to handedness, mouth, sub-mandibular), single shot, weapon present, no defensive wounds, fingerprints/DNA; - Multiple shots, atypical site, defensive wounds, weapon away → homicide more likely; - Scene investigation essential; (7) **Special — shotgun**: pellet pattern (close range tight, distance spreads); choke effect; wadding identified; (8) **Other forensic ballistics**: rifling pattern (lands + grooves), caliber estimation, NIBIN database; (9) **Communication**: testimony in court, evidence-based, neutral; quality + peer review for testimony; (10) **NAME standards + Wood + DiMaio textbook + RCFL coordination**

---

GSW: entrance (abrasion collar, contact may have soot/imprint/stellate; close range has stippling) vs exit (larger, no collar). Range: contact/close/distant. Manner determination needs scene + wounds + tox + history. Bullet recovery + chain of custody. Photograph + diagram + measurements.', NULL,
  'medium', 'forensic', 'review',
  'pathology', 'clinical_decision', 'forensic', 'adult',
  'DiMaio Gunshot Wounds; NAME', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ME case — found man with gunshot wound to head; postmortem exam — distinguishing entrance vs exit wounds, range determination, trajectory, and forensic ballistics workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pregnant woman Rh-negative with Rh-positive fetus — postpartum maternal serology + antibody screen + cord blood + Kleihauer-Betke + RhoGAM administration + management of subsequent pregnancy', '[{"label":"A","text":"ไม่ทำอะไร"},{"label":"B","text":"Rh Alloimmunization Prevention"},{"label":"C","text":"Refuse"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rh Alloimmunization Prevention: (1) **Pathophysiology**: Rh-negative mother exposed to Rh-positive fetal blood (delivery, miscarriage, trauma, procedures, transfusion) → anti-D Ab → next Rh-positive pregnancy → fetal hemolysis (HDFN — hemolytic disease of fetus + newborn); severe → hydrops fetalis, in utero death; (2) **Prevention with RhoIG (RhoGAM, anti-D immunoglobulin)**: - **Antenatal**: 300 μg IM at 28 wk gestation (covers usual fetomaternal hemorrhage to delivery); - **Postpartum**: 300 μg IM within 72 hr of delivery if baby Rh+ (cord blood typing); - **Sensitizing events**: 300 μg after miscarriage > 12 wk, ectopic, amniocentesis, CVS, abdominal trauma, ECV, antepartum hemorrhage; smaller doses (50-120 μg) for early pregnancy events per protocol; (3) **Workup**: - **Antibody screen** maternal at first prenatal + 28 wk (and after sensitizing event); - **Cord blood typing** (ABO, Rh, DAT) on baby of Rh-negative mother; - **Kleihauer-Betke test** if large fetomaternal hemorrhage suspected (placental abruption, trauma, abdominal injury) — quantifies fetal RBCs in maternal circulation → dose RhoIG (1 vial 300 μg covers ~ 30 mL fetal whole blood); alternative flow cytometry; (4) **Mechanism RhoIG**: passive Ab coats fetal RBCs → cleared by maternal RES before maternal immune sensitization; (5) **Mother already sensitized (anti-D present)**: RhoIG doesn''t help — monitor anti-D titers + middle cerebral artery Doppler peak systolic velocity (MCA-PSV) in fetus → predicts fetal anemia; intrauterine transfusion if severe; deliver early; (6) **Other relevant alloantibodies**: Kell (transfuse Kell-negative blood to Rh-D negative women of childbearing age — Kell can cause severe HDFN with low titers + suppress erythropoiesis), Duffy, Kidd, c, E, S; routine antibody screen covers; (7) **ABO incompatibility HDFN**: mostly mild — group O mother + A/B baby; jaundice manageable with phototherapy; (8) **Postpartum management**: newborn DAT + bilirubin monitoring; phototherapy + exchange transfusion if severe; (9) **Counseling for future pregnancy**

---

Rh prevention: RhoIG antenatal (28 wk) + postpartum (if baby Rh+) within 72 h + after sensitizing events. Kleihauer-Betke quantifies FMH for dosing. Already sensitized → MCA-PSV + IUT. Kell-negative blood for Rh-D-neg women childbearing. Other alloantibodies relevant.', NULL,
  'medium', 'transfusion', 'review',
  'pathology', 'clinical_decision', 'transfusion', 'mixed',
  'ACOG; AABB', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Pregnant woman Rh-negative with Rh-positive fetus — postpartum maternal serology + antibody screen + cord blood + Kleihauer-Betke + RhoGAM administration + management of subsequent pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี ผู้หญิงตั้งครรภ์ — chest pain + dyspnea + troponin elevated; cardiac biomarkers + interpretation + reference intervals + DDx', '[{"label":"A","text":"Random"},{"label":"B","text":"Cardiac Biomarkers — Troponin (hs-cTn) + Use"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Biomarkers — Troponin (hs-cTn) + Use: (1) **High-sensitivity troponin (hs-cTnI or hs-cTnT)** — replaces conventional troponin; detects much lower levels reliably + rapid rule-in/rule-out protocols (0/1-h or 0/2-h); (2) **Pathophysiology**: cTnI + cTnT — cardiac-specific structural proteins released from injured cardiomyocytes; rise within 1-3 hr injury, peak 24-48 hr, persist 7-14 d; (3) **Interpretation**: - **Sex-specific 99th percentile URL (upper reference limit)** — male/female different — apply correct; - **Delta change** essential — rule-in for MI requires both elevated AND dynamic change (rise/fall); - 0/1-h algorithm ESC: hs-cTn very low + no chest pain ≥ 3 hr → rule-out; high + delta → rule-in; - Type 1 MI (atherothrombotic) vs **Type 2 MI** (supply-demand mismatch — anemia, hypotension, tachyarrhythmia); cardiac troponin elevation also in many non-MI conditions; (4) **Differential of elevated troponin (NOT all MI)**: - Demand ischemia (anemia, sepsis, tachyarrhythmia, HF, hypotension, hypoxia); - Myocarditis (incl post-COVID, immune checkpoint inhibitor); - Cardiomyopathy (HCM, takotsubo, peripartum, infiltrative); - Aortic dissection, PE (RV strain), severe HTN, stroke (neurogenic stunning); - Renal disease (chronic elevation — interpret with delta + clinical), tachyarrhythmia, blunt trauma, cardioversion, ablation, cardiac surgery; - Sepsis, critical illness; (5) **Universal definition of MI (4th)**: troponin rise/fall + ≥ 1 of (symptoms ischemia, ECG changes, imaging evidence wall motion/loss, coronary thrombus identified); (6) **In pregnancy**: differential includes peripartum cardiomyopathy, preeclampsia-related, dissection (SCAD — spontaneous coronary artery dissection — increased pregnancy), PE, amniotic fluid embolism, takotsubo; pregnancy slightly alters reference; (7) **Other biomarkers**: BNP/NT-proBNP (HF — pregnancy slightly elevated baseline), D-dimer (PE — pregnancy elevated baseline — adjust by trimester or use age/preg-adjusted cutoff or YEARS), CK-MB (obsolete except specific scenarios); (8) **Pre-analytics**: hemolysis affects assays; tube types; same assay for serial; (9) **Critical value reporting** + ED-cardiology coordination + standardized protocols

---

hs-cTn: sex-specific 99th URL + delta change rule-in MI. 0/1-h algorithm ESC. DDx many non-MI causes (demand, myocarditis, PE, dissection, sepsis, renal, infiltrative). Universal MI definition (4th). Pregnancy: SCAD, peripartum CM, preeclampsia, PE.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'ESC 0/1-h hs-cTn; Universal MI Definition 4th', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี ผู้หญิงตั้งครรภ์ — chest pain + dyspnea + troponin elevated; cardiac biomarkers + interpretation + reference intervals + DDx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — fatigue + bradycardia + cold intolerance; labs TSH 25, free T4 0.4 (low), anti-TPO + anti-thyroglobulin antibodies elevated; การวินิจฉัยและการรักษา + interpretation', '[{"label":"A","text":"Hyperthyroidism"},{"label":"B","text":"Hypothyroidism — Diagnosis + Lab Interpretation"},{"label":"C","text":"Refuse"},{"label":"D","text":"Random"},{"label":"E","text":"Adrenal crisis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypothyroidism — Diagnosis + Lab Interpretation: (1) **Primary hypothyroidism**: TSH ↑ + free T4 ↓ (overt) or normal (subclinical); most common etiology — **Hashimoto thyroiditis** (autoimmune — anti-TPO + anti-Tg positive); other — post-radioactive iodine, post-thyroidectomy, iodine deficiency, drugs (lithium, amiodarone, IFN, IO checkpoint inhibitors, ATG, TKI); (2) **Secondary (central) hypothyroidism**: TSH low/inappropriately normal + free T4 ↓ — pituitary or hypothalamic disease (mass, surgery, RT, infiltrative — sarcoid, hemochromatosis, lymphocytic hypophysitis); (3) **Sick euthyroid (NTIS — non-thyroidal illness syndrome)**: TSH normal/low, T3 low, reverse T3 high, T4 variable — defer routine hypothyroid screening in critically ill unless strong clinical suspicion; (4) **TSH assays — interpretation pitfalls**: - Reference range narrows ages + adjusted for pregnancy (trimester-specific cutoffs — lower upper limit early pregnancy); - **Biotin interference** (high-dose biotin supplements interfere with streptavidin-biotin immunoassays → falsely low TSH + falsely high free T4 mimicking hyperthyroidism — pause biotin 48 h before draw); - **Macro-TSH** (autoantibody-bound TSH cleared slowly — falsely high TSH); - **Heterophile antibodies, HAMA** — false elevations; (5) **Treatment**: - **Levothyroxine (T4)** — once-daily oral, empty stomach, 30-60 min before food/coffee/other meds; weight-based starting dose ~ 1.6 μg/kg/d in healthy; lower starting dose (12.5-25 μg) in elderly, CAD; - Recheck TSH 6-8 wk after dose change; - Target TSH normal range (mid-low for young, slightly higher for elderly); - **Subclinical hypothyroidism**: treat if TSH > 10, symptomatic, infertility/pregnancy planning, goiter, dyslipidemia; pregnant — treat to TSH < 2.5; - **Pregnancy**: increase levothyroxine ~ 30% empirically + monitor q4 wk first half; (6) **T3 add-on**: largely unsupported routinely; some persistent symptoms patient subgroups discussed; (7) **Drug interactions**: PPI, calcium, iron, soy reduce absorption — separate timing; (8) **Multidisciplinary**: endocrinology + primary care + pregnancy + cardiology if older with CAD

---

Hypothyroidism: primary (TSH↑, T4↓) — Hashimoto most common. Central (low/inappropriate TSH). Sick euthyroid distinct. Biotin/macro-TSH/heterophile interfere. Levothyroxine 1.6 μg/kg empty stomach; recheck q6-8 wk; pregnancy ↑30%. Subclinical Tx criteria.', NULL,
  'easy', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'ATA Hypothyroidism 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — fatigue + bradycardia + cold intolerance; labs TSH 25, free T4 0.4 (low), anti-TPO + anti-thyroglobulin antibodies elevated; การวินิจฉัยและการรักษา + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — confusion + dilute urine; serum Na 118; clinical euvolemic; urine osm 450, serum osm 250; การวินิจฉัยและการ workup + management', '[{"label":"A","text":"Diuretic"},{"label":"B","text":"Hyponatremia — Workup + Treatment"},{"label":"C","text":"Skip"},{"label":"D","text":"Refuse"},{"label":"E","text":"Furosemide alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyponatremia — Workup + Treatment: (1) **First step — confirm true hyponatremia + identify acute vs chronic**: rule out pseudohyponatremia (hyperlipidemia/hyperproteinemia — older methods; hyperglycemia — corrected Na = measured + 1.6 mEq/L per 100 mg/dL glucose above 100); (2) **Classification by tonicity + volume**: - **Hypotonic** (true): - **Hypovolemic**: GI loss, renal loss (diuretics — thiazide), adrenal insufficiency, third-spacing, cerebral salt wasting; - **Euvolemic**: SIADH (this case profile — urine osm > 100 + serum osm < 275 + euvolemic + normal renal/adrenal/thyroid + urine Na > 20); hypothyroidism; adrenal insufficiency; reset osmostat; primary polydipsia (low urine osm < 100); - **Hypervolemic**: HF, cirrhosis, nephrotic syndrome, AKI/CKD; (3) **SIADH causes**: - **CNS**: stroke, hemorrhage, infection (meningitis, encephalitis), trauma, mass, surgery, pain, nausea; - **Pulmonary**: SCLC ectopic ADH, pneumonia, TB, ARDS; - **Drugs**: SSRIs, carbamazepine + oxcarbazepine, MDMA, antipsychotics, NSAIDs, vincristine, cyclophosphamide; - **Postoperative** (especially neuro); - **HIV, idiopathic in elderly** (~ 10% of community-dwelling elderly); (4) **Workup essentials**: - **Serum + urine osmolality + urine Na simultaneously**; - **Volume status assessment**; - **TSH, cortisol** rule out endocrine; - **History + medication review**; - **Imaging** for SIADH cause if cancer/CNS suspected; (5) **Treatment**: - **Acute severe symptomatic (seizure, severe altered LOC, brainstem herniation)**: **3% hypertonic saline 100 mL bolus q10 min × 1-3** until symptoms improve; target rise ~ 4-6 mEq/L initial; - **Chronic asymptomatic/mild**: cause-directed — restrict fluid, treat underlying; - **SIADH chronic**: fluid restriction (< 800-1000 mL/d), salt + protein intake, **tolvaptan (V2 receptor antagonist)** carefully (limit 30 days liver concern); urea oral; loop diuretic + salt tablets adjunct; - **CRITICAL — rate of correction**: ≤ 10-12 mEq/L in 24 hr (some say 8); too rapid → **osmotic demyelination syndrome (ODS — central pontine + extrapontine myelinolysis)** — devastating, irreversible; - **Risk factors ODS**: chronic hyponatremia, alcoholism, malnutrition, liver disease, hypokalemia; - **Re-lower** with hypotonic fluid + DDAVP if overcorrected to slow back; (6) **Recheck Na q2-4 hr during correction**

---

Hyponatremia: confirm hypotonic + classify by volume → cause. SIADH if euvolemic + urine osm>100 + urine Na>20 + normal endocrine. Acute symptomatic: 3% saline bolus. Chronic: fluid restriction, tolvaptan, urea. Rate ≤10-12 mEq/L/24h (ODS risk). Re-lower if overcorrected.', NULL,
  'hard', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'European Hyponatremia Guidelines; ASN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — confusion + dilute urine; serum Na 118; clinical euvolemic; urine osm 450, serum osm 250; การวินิจฉัยและการ workup + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี HIV positive — high fever + lymphadenopathy; biopsy: necrotizing granulomas with acid-fast bacilli; AFB+, GeneXpert MTB/RIF positive — rifampin susceptible; การ pathology workflow + integration', '[{"label":"A","text":"Random"},{"label":"B","text":"Mycobacterial Infection Pathology + Workflow"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mycobacterial Infection Pathology + Workflow: (1) **Histology features**: - **Granulomatous inflammation** — collections of epithelioid macrophages + Langhans giant cells + lymphocytes; - **Caseating necrosis** classic of TB (vs sarcoid non-necrotizing); - Acid-fast bacilli (slender, beaded rods) — usually scant in tuberculoid form, abundant in immunocompromised; - **Spectrum**: tuberculoid (well-organized granuloma, paucibacillary) → lepromatous-like in HIV severe (poorly formed, multibacillary, foamy macrophages); (2) **Stains for AFB**: - **Ziehl-Neelsen** (carbol-fuchsin) — gold standard; - **Kinyoni** (cold modification); - **Auramine-rhodamine fluorescence** — more sensitive than Z-N for screening; - **Fite stain** for M. leprae + Nocardia (less acid-fast); (3) **Differential of granulomatous infection**: - Mycobacteria — TB, NTM (MAC, kansasii), leprosy; - **Fungal** — histoplasmosis (small yeast in macrophages), coccidioidomycosis (large spherules with endospores), blastomycosis (broad-based budding), cryptococcosis (capsule with India ink/mucicarmine, narrow-based budding), aspergillosis (septate hyphae 45° branching), mucormycosis (broad ribbon-like aseptate hyphae 90° branching); - **Bacterial** — brucellosis, listeriosis, syphilis, cat-scratch (Bartonella); - **Parasitic** — schistosomiasis, leishmaniasis; - **Sarcoidosis** (non-caseating); - **GPA + Crohn''s** non-infectious; (4) **Special stains adjunct**: GMS, PAS (fungi); Warthin-Starry (spirochetes, Bartonella); Giemsa (Leishmania, Histoplasma); (5) **Molecular diagnostics (rapid + sensitive)**: - **GeneXpert MTB/RIF** (now MTB/RIF Ultra) — 2-hr PCR direct from specimen — detects MTB + rifampin resistance — revolutionary; - **Line probe assays** (LPA) — first-line + second-line drug resistance; - **NAAT** for other organisms; (6) **Culture + susceptibility** still gold standard for definitive ID + full susceptibility — Mycobacteria growth slow weeks (MGIT broth, LJ solid); MALDI-TOF mass spec for species ID; (7) **HIV + TB co-infection**: common SE Asia + sub-Saharan; impacts presentation + Tx; IRIS risk on ART; (8) **Reporting + public health**: TB reportable; isolate; contact tracing; (9) **Multidisciplinary**: pathology + microbiology + ID + pulmonology + public health

---

Granuloma: caseating (TB), non-caseating (sarcoid); Z-N/auramine for AFB; Fite for leprosy. Differential: fungi (GMS/PAS), bacterial, parasitic, autoimmune. GeneXpert MTB/RIF rapid + RIF resistance. Culture gold-standard + slow. HIV + TB common, IRIS risk.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'clinical_decision', 'microbiology', 'adult',
  'WHO TB Diagnostic; CAP Surgical Pathology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี HIV positive — high fever + lymphadenopathy; biopsy: necrotizing granulomas with acid-fast bacilli; AFB+, GeneXpert MTB/RIF positive — rifampin susceptible; การ pathology workflow + integration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย HIV/AIDS — sputum + BAL: large yeast cells with broad-based budding + capsule; cryptococcal antigen positive in serum + CSF; การวินิจฉัยและการรักษา', '[{"label":"A","text":"TB"},{"label":"B","text":"Cryptococcosis — Pathology + Treatment"},{"label":"C","text":"Bacterial"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cryptococcosis — Pathology + Treatment: (1) **Organism**: Cryptococcus neoformans (immunocompromised — HIV/AIDS, organ transplant, steroid use) + C. gattii (immunocompetent + Pacific Northwest); encapsulated yeast — polysaccharide capsule (GXM antigen detected); (2) **Histology**: round to oval yeast 4-10 μm with thick polysaccharide capsule appearing as clear halo (mucicarmine + Alcian blue + Fontana-Masson + positive for capsule/melanin); narrow-based budding; (3) **Stains**: - **India ink** (CSF — wet mount) — capsule excludes dye; - **Mucicarmine** + **Alcian blue** — stain capsule pink/blue; - **Fontana-Masson** — stains melanin in cell wall (helpful capsule-deficient variant); - GMS + PAS — fungal wall; (4) **Cryptococcal antigen (CrAg) detection**: - Lateral flow assay (LFA) — fast, accurate, low cost — in serum + CSF; - Latex agglutination historical; - **Sensitive + specific** for screening — used for HIV+ patients with CD4 < 100 in high-burden settings (preempt with fluconazole); (5) **Clinical syndromes**: cryptococcal meningitis (most common AIDS, classic), pulmonary cryptococcosis (variable from asymptomatic to severe), cutaneous, prostate, disseminated; (6) **CSF in cryptococcal meningitis**: lymphocytic, elevated protein, low glucose, **markedly elevated opening pressure** (often > 25 cm H2O — critical to manage with repeated LPs to reduce → reduces blindness + mortality); (7) **Treatment** (cryptococcal meningitis HIV — WHO + IDSA): - **Induction (2 wk)**: amphotericin B (liposomal preferred — toxicity less) + flucytosine; - **AMBITION-cm trial** — **single-dose liposomal amphotericin B 10 mg/kg + 14 days flucytosine + fluconazole** non-inferior to standard, less toxic — emerging standard especially LMIC settings; - **Consolidation (8 wk)**: fluconazole 400-800 mg; - **Maintenance**: fluconazole 200 mg until CD4 > 100-200 sustained on ART; - **Opening pressure management**: serial LPs reducing 50% to < 20 cm; lumbar drain or shunt selected cases; - **IRIS risk** when ART started — delay ART 4-6 wk after antifungal initiation; (8) **Other organ transplant + non-HIV**: tailored; (9) **Pulmonary cryptococcosis** mild — fluconazole; severe — amphotericin + flucytosine then fluconazole; (10) **Multidisciplinary**: ID + neurology + ICU + pharmacy

---

Cryptococcus: encapsulated yeast (India ink, mucicarmine+); CrAg LFA sensitive. Meningitis AIDS classic. CSF: lymphocytic + ↑OP critical to manage. Tx: ampho + flucytosine induction → fluconazole consolidation + maintenance; AMBITION-cm single-dose lipo ampho emerging. IRIS risk.', NULL,
  'hard', 'microbiology', 'review',
  'pathology', 'clinical_decision', 'microbiology', 'adult',
  'IDSA Cryptococcus; WHO HIV OI; AMBITION-cm', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย HIV/AIDS — sputum + BAL: large yeast cells with broad-based budding + capsule; cryptococcal antigen positive in serum + CSF; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of routine H&E stain — chemistry of hematoxylin and eosin staining + common artifacts + interpretation', '[{"label":"A","text":"Random"},{"label":"B","text":"Hematoxylin + Eosin (H&E) Stain Chemistry + Interpretation"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hematoxylin + Eosin (H&E) Stain Chemistry + Interpretation: (1) **Hematoxylin**: natural dye from logwood tree; oxidized to **hematein** (active form); requires **mordant** (aluminum, iron — Harris uses aluminum potassium sulfate) to bind tissue; basic — stains **acidic structures (nucleic acids, ribosomes, calcium-rich, mucin)** blue/purple → **''basophilic''**; (2) **Eosin**: acidic synthetic dye; stains **basic structures (proteins, cytoplasm, collagen, red blood cells, keratin)** pink/red → **''eosinophilic''**; (3) **Typical workflow**: deparaffinize (xylene) → rehydrate (graded ethanol) → hematoxylin → blueing (Scott''s tap water or lithium carbonate) — turns red precipitate blue + sharpens → differentiate (acid alcohol — remove excess) → dehydrate → eosin → dehydrate → clear → coverslip with mounting medium; (4) **Variations**: progressive (no differentiation, e.g., Mayer''s) vs regressive (over-stain then differentiate, e.g., Harris); H&E variations (gill''s, mayer''s, harris''s) — pathologists/labs prefer different; (5) **Common H&E artifacts + their causes**: - **''Cornflake'' (air bubbles)** — incomplete coverslip wetting → ghosts of cells; - **Knife scratches** — dull microtome; - **Tissue folding** — section too thick + cold block; - **''Chatter'' / lines** — microtome vibration or blocked block; - **Pale staining** — over-differentiation, weak dye, old; - **Over-purple/blue** — over-stain, inadequate differentiation; - **Floaters** — tissue contamination between cases; serious QC issue → CAP requirement to address; - **Pen/charcoal artifacts** from ink margins; - **Lipid washout artifact** — clear vacuoles from fat dissolved by xylene/ethanol; - **Freezing artifact** — ice crystal vacuolation (frozen sections); - **Mercury pigment** (B5 fixed) — small brown granules; - **Formalin pigment** (acid hematin — pH issue) — brown/black extracellular granules in bloody tissue; - **Heat artifact** (electrocautery) — nuclei elongated + smudged at edges; (6) **Other key routine stains**: PAS (carbohydrates, BM, fungi), GMS (fungi, PCP), Gram (bacteria), Z-N/auramine (AFB), Congo red (amyloid — apple-green birefringence under polarized), Prussian blue (iron), reticulin, trichrome (collagen), oil red O (frozen for lipid), Alcian blue (mucin); (7) **QA standards**: CAP histology checklist — stain quality monitoring + control slides + tissue handling

---

H&E: hematoxylin (basic, stains acidic structures blue — nucleic acids) + eosin (acidic, stains basic structures pink — cytoplasm/collagen). Progressive vs regressive. Artifacts: cornflake, scratches, chatter, floaters, lipid wash, formalin pigment. Special stains complement.', NULL,
  'easy', 'quality_safety', 'review',
  'pathology', 'basic_science', 'quality_safety', 'mixed',
  'CAP Histology Checklist; Bancroft Theory and Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of routine H&E stain — chemistry of hematoxylin and eosin staining + common artifacts + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หลักการของ flow cytometry ใน hematopathology — workflow + gating + immunophenotyping + interpretation + applications + limitations', '[{"label":"A","text":"Random"},{"label":"B","text":"Flow Cytometry Principles"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Flow Cytometry Principles: (1) **Concept**: cells in suspension pass through laser → detect forward scatter (FSC — size), side scatter (SSC — granularity/complexity), + fluorescence at multiple wavelengths from labeled antibodies binding cellular antigens (surface, intracellular); (2) **Workflow**: - Cell suspension preparation (blood, BM, lymph node, body fluid, FNA); - Lysis of RBCs (cell-specific protocols); - **Cocktail** of fluorochrome-conjugated antibodies (different fluorochromes — FITC, PE, APC, PerCP, BV421, etc. — many channels); - Acquire (typically 100,000+ events/tube); - **Compensation** for spectral overlap between fluorochromes; - **Gating** strategy (sequential gates): FSC/SSC → exclude debris + doublets → identify lymphocytes, monocytes, granulocytes, blasts → subset analysis; (3) **Modern instruments**: 8-12 colors routine; spectral flow cytometry + mass cytometry (CyTOF) > 30 parameters; (4) **Applications hemato**: - **Leukemia/lymphoma diagnosis + classification** — phenotype B/T/NK + lineage (CD19, CD20, CD3, CD56, CD13/33 myeloid, CD41/61 megakaryocyte, CD235a erythroid); abnormal antigen expression patterns vs normal; - **MRD (minimal residual disease)** — high-sensitivity (10⁻⁴ to 10⁻⁶) in ALL, CLL, AML, MM (8-color + next-generation flow per EuroFlow); - **PNH** — CD55 + CD59 absence on granulocytes/RBCs, FLAER (more sensitive); - **Lymphocyte subsets** — CD4/CD8 in HIV monitoring; - **CD34 stem cell enumeration** for HCT; - **DNA content/ploidy** (less common now); - **Platelet disorders** — GPIb (Bernard-Soulier), GPIIb/IIIa (Glanzmann); - **Reticulocyte enumeration** automated; (5) **Light chain restriction**: monoclonal B-cell — kappa or lambda only; vs polyclonal reactive — mixed; (6) **CD45 vs SSC plot**: standard gating — blasts CD45 dim/low SSC, lymphocytes CD45 bright/low SSC, granulocytes CD45 dim/high SSC; (7) **Limitations**: - Loss of architecture (cell context lost — biopsy still essential); - Cell viability sensitive (older samples); - Sample heterogeneity + subsampling; - Operator + interpretation expertise required; - Cost + technology investment; (8) **QC**: instrument standardization (CS&T beads), control samples, compensation, panel validation; (9) **Reporting**: standardized terminology; integrate with cytology/histology + cytogenetics + molecular

---

Flow cytometry: laser detection of size/granularity/fluorochrome-labeled antibodies. Multi-color cocktail + gating (CD45 vs SSC + lineage). Applications: heme malignancy classification, MRD (EuroFlow), PNH (CD55/59/FLAER), CD34, light chain restriction. Compensation + QC.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'basic_science', 'hematopathology', 'mixed',
  'ICCS Flow Cytometry; EuroFlow', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'หลักการของ flow cytometry ใน hematopathology — workflow + gating + immunophenotyping + interpretation + applications + limitations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab director — implementing laboratory biosafety program + risk assessment + BSL levels + PPE + safety culture + reporting', '[{"label":"A","text":"Random"},{"label":"B","text":"Laboratory Biosafety Program"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Laboratory Biosafety Program: (1) **Biosafety Levels (BSL — WHO/CDC)**: - **BSL-1**: agents not known to cause disease in healthy adults (e.g., E. coli K-12, B. subtilis); basic lab practices; - **BSL-2**: moderate-risk agents (most clinical specimens, HIV, HBV, HCV, S. aureus, Salmonella); BSC class II + PPE + sharps + autoclave; - **BSL-3**: serious/lethal disease + airborne route (M. tuberculosis, SARS-CoV-2 — initial phases, certain influenzas); sealed lab + directional airflow + respirator + autoclave; - **BSL-4**: high-risk + no treatment (Ebola, Marburg, smallpox); positive-pressure suit + dedicated facility; (2) **Animal BSL (ABSL)** parallel framework; (3) **Risk assessment** essential: - Agent characteristics (route, infectious dose, stability, treatment, vaccine); - Procedures (aerosol-generating — sonication, centrifuge open, vortex, pipetting, autopsy); - Personnel (training, immunocompromised, pregnant); - Equipment + facility; - Likelihood + consequence; (4) **Engineering controls** (most effective): biosafety cabinet (BSC class I/II/III — II most common clinical), HEPA filtration, autoclave, sealed centrifuges, biosafety hood; (5) **Administrative controls**: training, competency, SOPs, occupational health, vaccination (HBV, MMR, varicella, influenza, COVID, others per role); (6) **PPE**: gloves, lab coat, eye protection, face shield, respiratory (N95, PAPR); appropriate to task; donning/doffing trained; (7) **Sharps + waste**: sharps containers, no recapping, dedicated biohazard waste, segregation, disposal per regulations; chemical + radiation waste separate; (8) **Specimen handling**: tube tops carefully, prevent spills, contained transport, decontamination protocols (bleach 1:10, 70% EtOH, glutaraldehyde, etc. — agent-specific); (9) **Exposure response**: - Bloodborne — wash + report + occupational health + serology + PEP per algorithm (HIV PEP within hours, HBV vaccine/HBIG, HCV monitoring); - Aerosol — leave room + report; - Documentation + RCA; (10) **Reporting + surveillance**: needlestick injuries, near-misses; trend analysis; quality improvement; (11) **Regulations**: OSHA bloodborne pathogen standard, CDC/NIH BMBL 6th ed, CAP, ISO 15189, country-specific (e.g., Thailand DMSc); (12) **Culture of safety**: leadership commitment, non-punitive reporting, continuous improvement, training, drills

---

Biosafety: BSL 1-4 by agent risk; engineering (BSC, HEPA) > admin (training, vaccines) > PPE. Risk assessment + agent-specific. Exposure response — bloodborne PEP. Reporting non-punitive. OSHA BBP, BMBL 6th ed, ISO 15189. Culture of safety.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CDC/NIH BMBL 6th ed; WHO LBM 4th ed; ISO 15189', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab director — implementing laboratory biosafety program + risk assessment + BSL levels + PPE + safety culture + reporting'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab management — implementing comprehensive quality management system (QMS) with accreditation + continuous improvement + ISO 15189 + CAP + Six Sigma + lean', '[{"label":"A","text":"Random"},{"label":"B","text":"Lab Quality Management System (QMS)"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab Quality Management System (QMS): (1) **Standards/accreditation frameworks**: - **ISO 15189**: international standard for medical labs — quality + competence; - **CAP (College of American Pathologists)** accreditation — checklists by discipline + on-site inspection; - **CLIA (US — Clinical Laboratory Improvement Amendments)** regulatory; - **The Joint Commission (TJC)** lab accreditation; - **WHO LQSI / Stepwise Lab Quality Improvement Process** for resource-limited; - **Country-specific**: Thailand LA (Laboratory Accreditation), BLQS; (2) **QMS pillars (12 ''Quality System Essentials'' per CLSI HS01)**: organization, personnel, equipment, purchasing/inventory, process control, information management, documents/records, occurrence management, assessments, process improvement, customer service, facilities/safety; (3) **Total testing process — 3 phases**: - **Pre-analytical** (60-70% of errors): order entry, patient ID, collection, transport, accessioning — STAT recognition, mislabels, tube errors, hemolysis; - **Analytical**: test performance, calibration, QC, validation, proficiency testing — failure modes traceable; - **Post-analytical**: result reporting, critical value, interpretation, distribution — wrong report linked to wrong patient; (4) **Quality control + proficiency testing**: - Daily internal QC (Westgard rules for SPC), CUSUM; - **External PT** required (CAP surveys, CDC, etc.) regular — proficiency testing failure → corrective action; - **Interlaboratory comparison**; (5) **Continuous improvement frameworks**: - **PDCA (Plan-Do-Check-Act)** Deming; - **Six Sigma DMAIC** (define-measure-analyze-improve-control) — DPMO < 3.4/million; - **Lean** — eliminate waste (TIM WOODS — transport, inventory, motion, waiting, overprocessing, overproduction, defects, skills); 5S; value stream mapping; - **A3 problem solving**, **kaizen**; (6) **Patient safety events**: - Sentinel events + close calls reported; - **Root cause analysis (RCA)** systematic; - **Failure modes + effects analysis (FMEA)** proactive; - **TJC NPSGs** patient safety goals (correct patient + sample, critical value, medication safety); (7) **KPIs/dashboards**: TAT (turnaround time), critical value compliance, rejection rate, customer satisfaction, mislabeling rate, error rates by phase; (8) **Personnel competency**: hire + train + assess (CLIA 6 elements); continuing ed; (9) **Document control**: SOPs, versions, training records, traceability; (10) **Risk-based quality (CLSI QMS, IVD-R)** modernizing — designed for individual lab + tests

---

Lab QMS: ISO 15189 / CAP / CLIA / TJC standards; CLSI HS01 12 essentials. Phases: pre-analytical (60-70% errors) + analytical + post-analytical. QC + PT mandatory. Improvement: PDCA/Six Sigma/Lean. RCA + FMEA. KPIs (TAT, critical values, rejections).', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'ISO 15189; CAP All Common Checklist; CLSI HS01', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab management — implementing comprehensive quality management system (QMS) with accreditation + continuous improvement + ISO 15189 + CAP + Six Sigma + lean'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 5 ปี — abdominal mass + LDH high + catecholamine metabolites (HVA + VMA) elevated; biopsy: small round blue cells with Homer-Wright rosettes + neuropil-like background; IHC: synaptophysin+, chromogranin+, PHOX2B+; molecular: MYCN amplification', '[{"label":"A","text":"Wilms"},{"label":"B","text":"Neuroblastoma — Pediatric"},{"label":"C","text":"Refuse"},{"label":"D","text":"Hodgkin"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroblastoma — Pediatric: (1) **Origin**: neural crest cells (sympathoadrenal) — adrenal medulla, paraspinal sympathetic ganglia; (2) **Most common extracranial solid tumor in children**; median age ~ 17 mo; (3) **Histology**: small round blue cell tumor; Homer-Wright rosettes (neuroblasts around fibrillary core); neuropil (fine eosinophilic matrix); spectrum — neuroblastoma (undifferentiated, poorly differentiated, differentiating), ganglioneuroblastoma (intermixed, nodular), ganglioneuroma (mature, benign); (4) **IHC**: synaptophysin+, chromogranin+, neuron-specific enolase+, CD56+, **PHOX2B+** (specific transcription factor), GD2 (target for therapy); CK negative (vs small cell carcinoma), CD99 negative (vs Ewing), TdT negative (vs lymphoblastic); (5) **Urinary catecholamines (HVA + VMA)** elevated in > 90% — diagnostic + monitoring; (6) **Imaging**: **MIBG (I-123 metaiodobenzylguanidine)** — concentrated in neuroblastoma — staging + response assessment; PET/CT alternative; (7) **Staging**: INRGSS (image-defined risk factors) — international consensus; INSS (older surgical staging); (8) **Risk stratification (Children''s Oncology Group)**: - Age (< 18 mo better), stage, MYCN amplification (poor), ploidy (hyperdiploid better in infant), histology (Shimada/INPC favorable vs unfavorable), 1p/11q LOH; - **MYCN amplification — strongest adverse molecular marker**; - **ALK mutations** (germline + somatic — actionable with crizotinib/lorlatinib); - **ATRX, ARID1A, TERT** alterations; (9) **Treatment by risk**: - **Low-risk**: surgery alone often curative; observation for stage MS infants; - **Intermediate-risk**: surgery + moderate chemo (carbo + etop + cyclo + dox); - **High-risk** (~ 50%, with worse outcomes): - **Induction**: 5-6 cycles intensive chemo (BuMel-based); - **Consolidation**: high-dose chemo + auto-HCT (often tandem) + radiation to primary; - **Maintenance**: **anti-GD2 immunotherapy (dinutuximab)** + IL-2 + GM-CSF + cis-RA (isotretinoin) — major survival improvement; - **Refractory/relapsed**: MIBG therapy (I-131), ALK inhibitors (if mutated), naxitamab, eflornithine new addition; (10) **Multidisciplinary**: pediatric onc + surgery + RT + nuclear medicine + pathology + genetics + supportive + survivorship

---

Neuroblastoma: neural crest; Homer-Wright + neuropil; synaptophysin/chromogranin/PHOX2B+; HVA/VMA + MIBG. INRGSS staging + COG risk (age, MYCN amp, ploidy, histology, 1p/11q). High-risk: induction + auto-HCT + anti-GD2 (dinutuximab) maintenance. ALK actionable.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'WHO Soft Tissue + Bone 5th ed; COG Neuroblastoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 5 ปี — abdominal mass + LDH high + catecholamine metabolites (HVA + VMA) elevated; biopsy: small round blue cells with Homer-Wright rosettes + neuropil-like background; IHC: synaptophysin+, chromogranin+, PHOX2B+; molecular: MYCN amplification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 4 ปี — abdominal mass kidney → resection: triphasic tumor with blastemal + epithelial (tubules) + stromal components; favorable histology; WT1 mutation', '[{"label":"A","text":"Neuroblastoma"},{"label":"B","text":"Wilms Tumor (Nephroblastoma)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Lymphoma"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wilms Tumor (Nephroblastoma): (1) **Most common renal tumor pediatric**; peak 2-5 yr; ~ 5% bilateral; (2) **Histology**: classic **triphasic** — **blastemal** (small round blue cells), **epithelial** (primitive tubules, glomeruloid structures), **stromal** (loose mesenchymal); proportions variable; (3) **Favorable vs unfavorable histology**: - **Favorable** ~ 90%; - **Unfavorable** — diffuse anaplasia (extreme nuclear enlargement + hyperchromasia + atypical mitoses); focal anaplasia better than diffuse; - **Other renal tumors pediatric** distinct entities (per WHO): **clear cell sarcoma of kidney (CCSK)**, **rhabdoid tumor of kidney (SMARCB1/INI1 loss — extremely aggressive)**, **congenital mesoblastic nephroma** (infant, ETV6-NTRK3 in cellular type); (4) **IHC**: WT1+ in blastemal/epithelial; PAX2/PAX8 epithelial; vimentin stromal; (5) **Molecular**: WT1, WT2 (11p15), CTNNB1, FBXW7, TP53 (anaplasia association); (6) **Hereditary predisposition syndromes (~ 10-15% Wilms)**: - **WAGR** (Wilms, Aniridia, GU anomaly, Range of intellectual disability — 11p13 deletion); - **Denys-Drash** (WT1 mutation — early onset nephropathy + pseudohermaphroditism + Wilms); - **Beckwith-Wiedemann** (11p15 — overgrowth, omphalocele, macroglossia, hemihypertrophy — Wilms + other tumors); - **Perlman, Sotos, Bloom, Li-Fraumeni**; — surveillance with renal US for at-risk children; (7) **Staging (COG NWTS)**: I (limited to kidney, resected) → V (bilateral); (8) **Treatment (combined approaches — COG North American + SIOP European)**: - **COG**: surgery first → adjuvant chemo based on stage + histology + biology; - **SIOP**: pre-operative chemo → surgery → adjuvant; - **Chemo agents**: vincristine + actinomycin D (low-stage), + doxorubicin (higher-stage); - **RT** for unfavorable + advanced; - **High-risk relapsed**: high-dose chemo + auto-HCT, etoposide-based, novel agents; (9) **Outcomes**: > 90% cure favorable; (10) **Multidisciplinary**: peds onc + urology + RT + pathology + genetics; (11) **Long-term survivorship** — cardiotoxicity, renal function, secondary malignancy, reproductive

---

Wilms tumor: triphasic (blastemal + epithelial + stromal); favorable vs unfavorable (anaplasia). WT1+/PAX8. Hereditary syndromes: WAGR, Denys-Drash, BWS — surveillance. COG vs SIOP approach (surgery first vs neoadjuvant). Cure > 90% favorable.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'WHO Urinary + Male Genital 5th ed; COG Wilms', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 4 ปี — abdominal mass kidney → resection: triphasic tumor with blastemal + epithelial (tubules) + stromal components; favorable histology; WT1 mutation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Multidisciplinary integrative pathology — patient with breast cancer + pregnancy + complex management; multidisciplinary tumor board including OB-GYN + medical onc + breast + pathology + maternal-fetal medicine', '[{"label":"A","text":"Random"},{"label":"B","text":"Pregnancy-Associated Breast Cancer (PABC) Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy-Associated Breast Cancer (PABC) Integrative Care: (1) **Definition**: diagnosed during pregnancy, lactation, or 1 year postpartum; ~ 1 in 3000 pregnancies; often delayed diagnosis (changes in breast); (2) **Pathology + workup**: - Core biopsy safe during pregnancy; pathology unchanged — IHC (ER/PR/HER2/Ki-67) standard; - More often ER-, HER2+, TNBC, higher grade in young; - Genetic counseling — BRCA testing recommended (young + family history); (3) **Staging**: US, MRI breast (no gadolinium contrast in pregnancy), CXR (with abdominal shielding), liver US; avoid CT + PET if avoidable; bone scan post-delivery; (4) **Multidisciplinary team**: medical oncology + breast surgery + radiation oncology + maternal-fetal medicine + OB-GYN + pathology + radiology + neonatology + psychology + lactation; (5) **Treatment by trimester**: - **1st trimester**: - **Surgery** safe (mastectomy or BCS — adapt anesthesia, avoid SLN with isosulfan blue, radiotracer alone OK); - **Chemotherapy CONTRAINDICATED** in 1st trimester (organogenesis); - **Endocrine therapy + tamoxifen CONTRAINDICATED** entire pregnancy (teratogenic); - **HER2 targeted (trastuzumab) CONTRAINDICATED** entire pregnancy (oligohydramnios); - **Radiation deferred to post-delivery**; - **2nd + 3rd trimester**: - Anthracycline + cyclophosphamide (AC) chemotherapy can be given (data show safe for fetus); - Taxanes (paclitaxel) OK 2nd-3rd; - **Avoid chemo within 3-4 wk of delivery** (neonatal cytopenia); - **6) Termination consideration**: rarely needed unless very early Ist trimester + need for immediate teratogenic Tx, no longer routinely recommended given good outcomes with adapted Tx; (7) **Delivery**: full-term preferred; (8) **Post-delivery**: complete standard treatment — endocrine, HER2 targeted, RT; (9) **Lactation**: usually safe to feed from unaffected side; avoid lactation during chemo; (10) **Fetal monitoring**: growth scans, NST, anomaly scan timing; (11) **Mental health**, support; (12) **Genetic counseling + future planning**; (13) **Fertility consult**: many young patients want options preserved; (14) **Survivorship including ongoing breast surveillance + late effects + psychosocial**; (15) **Outcomes**: comparable to non-PABC stage-for-stage when treated appropriately

---

PABC integrative care: multidisciplinary inc. MFM. Trimester-based Tx — surgery anytime; chemo 2nd/3rd OK (anthracycline + taxane), CONTRA in 1st; tamoxifen + trastuzumab CONTRA entire pregnancy; RT post-delivery. Delivery full-term preferred. Outcomes comparable.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'ESMO PABC; NCCN Breast', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Multidisciplinary integrative pathology — patient with breast cancer + pregnancy + complex management; multidisciplinary tumor board including OB-GYN + medical onc + breast + pathology + maternal-fetal medicine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative palliative care + pathology — patient with advanced metastatic cancer of unknown primary (CUP) — workflow + multidisciplinary + targeted therapy + supportive care + goals of care', '[{"label":"A","text":"Random"},{"label":"B","text":"Cancer of Unknown Primary (CUP) Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cancer of Unknown Primary (CUP) Integrative Care: (1) **Definition**: histologically confirmed metastatic cancer without identifiable primary site after appropriate workup; ~ 2-5% of cancers; (2) **Pathology workup** (most important step — increasingly identifies primary or actionable target): - **Histology**: well-differentiated adenocarcinoma, poorly differentiated, squamous, neuroendocrine, undifferentiated → broad categories; - **IHC** algorithm (extensive, site-tailored): - CK7 + CK20 + (lung, breast, pancreas, biliary, urothelial, gastric); - CK7 + CK20 - (lung, breast, biliary, thyroid, salivary); - CK7 - CK20 + (colorectal); - CK7 - CK20 - (HCC, RCC, prostate, squamous, neuroendocrine); - Site-specific: TTF-1 (lung, thyroid), GATA3 (breast, urothelial), PAX8 (Müllerian, thyroid, RCC), CDX2 (GI), p40 (squamous), synapto/chromo (neuroendocrine), SALL4 (germ cell), HepPar1 (HCC), arginase (HCC), RCC marker, NKX3.1 (prostate), MUC1, MUC2, others; - **Molecular**: comprehensive NGS for actionable mutations + tissue-of-origin classifier (CancerType ID, CUP-AI-Dx); MSI/dMMR + TMB + PD-L1; (3) **Imaging**: CT chest/abdomen/pelvis; mammogram (women); upper + lower endoscopy if GI suspicion; specific imaging by histology + IHC; PET-CT useful selected; (4) **Favorable CUP subsets (treat like primary)**: - Women with adenocarcinoma in axillary nodes → treat as breast; - Women with peritoneal carcinomatosis (papillary serous + psammoma + PAX8+/WT1+) → ovarian/Müllerian; - Men with squamous in cervical nodes → treat as head/neck; - Inguinal nodes squamous → genital/anal; - Single site → consider primary; - Neuroendocrine — well-diff treat like NET, poorly diff like SCLC; - Germ cell features (midline mass young male) — test/treat like germ cell; (5) **Treatment**: - **Site-specific** when subset identifies; - **Empiric chemo** (platinum + taxane historical) — limited benefit; - **Targeted therapy if actionable mutations** — increasingly important — agnostic FDA approvals: **larotrectinib/entrectinib (NTRK fusions), pembrolizumab (MSI-H/dMMR or TMB ≥ 10), dabrafenib + trametinib (BRAF V600E), selpercatinib (RET), etc.**; - **Immunotherapy + chemo** — CUPISCO trial — molecular-guided improved outcomes; (6) **Multidisciplinary**: medical onc + pathology + radiology + molecular tumor board + palliative + supportive; (7) **Palliative integration early** — symptom management + goals of care + advance care planning; (8) **Patient + family**: communication of uncertainty, emotional support, second opinions, clinical trial discussion; (9) **Equity**: access to comprehensive molecular workup + targeted therapy + trials

---

CUP integrative care: pathology IHC algorithm + molecular (NGS + tissue-of-origin classifier) → identify favorable subset or actionable target. Treat per primary when identified. Tissue-agnostic targeted therapy (NTRK/MSI-H/BRAF/RET). CUPISCO molecular-guided. Palliative early.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'ESMO CUP; CUPISCO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative palliative care + pathology — patient with advanced metastatic cancer of unknown primary (CUP) — workflow + multidisciplinary + targeted therapy + supportive care + goals of care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative pathology — public health surveillance: lab data role in identifying outbreaks + emerging pathogens + antimicrobial resistance + population health + epidemic preparedness', '[{"label":"A","text":"Random"},{"label":"B","text":"Clinical Lab Role in Public Health Surveillance"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clinical Lab Role in Public Health Surveillance: (1) **Outbreak detection + response**: - **Real-time reporting** of reportable diseases (TB, measles, meningococcal disease, HIV, hepatitis, foodborne, STDs, novel emergencies) — automated electronic laboratory reporting (ELR) to public health; - **Cluster detection** algorithms (CDC + state systems) on lab data; - **Whole-genome sequencing** (WGS) for foodborne outbreaks (PulseNet) — supplements/replaces PFGE; (2) **Antimicrobial resistance (AMR) surveillance** (One Health priority): - **WHO GLASS** global; - National systems track key resistance (MRSA, VRE, CRE/carbapenem-resistant Enterobacterales, MDR/XDR-TB, MDR Gonorrhea, candida auris, drug-resistant malaria); - **Clinical microbiology labs essential** — submit isolates, AST data; (3) **Emerging + re-emerging pathogen detection**: - **COVID-19 pandemic** demonstrated critical lab role — high-throughput PCR, variant tracking (WGS — GISAID), serology, antigen testing; - **Mpox, Marburg, Ebola** preparedness; - **Avian influenza H5N1** — One Health (animal + human + environment); - **Antimicrobial-resistant Candida auris** monitoring; (4) **Public health labs** (state + reference) — confirmatory + outbreak + characterization + capacity-building; (5) **Population health** initiatives: - Cancer registries (population incidence + outcomes); - Newborn screening (PKU, sickle cell, etc.); - HIV testing (universal); - Cervical cancer (HPV + cytology); - Hepatitis C screening universal adult; - LDL/A1C/BP population-level chronic disease; (6) **Equity considerations**: - Disparities in screening access, diagnosis, treatment — health equity goals; - Reduce disparities through accessible testing + culturally competent outreach; (7) **Epidemic preparedness**: - **Laboratory Response Network (LRN)** US — tiered lab capability for biosafety + bioterror; - Stockpile reagents; - Surge capacity testing; - Workforce training; - Specimen submission protocols + transport (Cat A/B); (8) **Data integration**: - **Electronic lab reporting (ELR)** + HL7/FHIR standards; - **Public health informatics** infrastructure; - Privacy + ethics + data sharing; (9) **International collaboration**: WHO, ECDC, CDC, IHR (International Health Regulations) — outbreak coordination; (10) **Lessons from COVID + Ebola + Zika**: investment in lab capacity + workforce + surveillance + equity essential

---

Clinical labs public health: ELR + outbreak detection + WGS (PulseNet); AMR surveillance (WHO GLASS); emerging pathogens (COVID/mpox/H5N1); newborn screening + cancer registries; equity. LRN preparedness. International collaboration (WHO, IHR). Workforce + capacity investment.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'integrative', 'microbiology', 'mixed',
  'WHO GLASS; CDC PHL; LRN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative pathology — public health surveillance: lab data role in identifying outbreaks + emerging pathogens + antimicrobial resistance + population health + epidemic preparedness'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — nephrotic syndrome (proteinuria 6 g/d + edema + hypoalbuminemia + hyperlipidemia) → kidney biopsy: segmental sclerosis affecting < 50% glomeruli with podocyte foot process effacement on EM; IF: nonspecific IgM/C3 entrapment; APOL1 high-risk variants', '[{"label":"A","text":"Minimal change"},{"label":"B","text":"Focal Segmental Glomerulosclerosis (FSGS)"},{"label":"C","text":"Membranous"},{"label":"D","text":"IgA"},{"label":"E","text":"Lupus"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Focal Segmental Glomerulosclerosis (FSGS): (1) **Histology**: segmental (affecting only portion of glomerulus) + focal (involves only some glomeruli) sclerosis; podocyte injury; (2) **Subtypes (Columbia classification)**: - **Tip lesion** (best prognosis); - **Perihilar** (often secondary, hyperfiltration); - **Cellular**; - **Collapsing** (worst — HIVAN, APOL1, SARS-CoV-2, drug); - **NOS** (not otherwise specified); (3) **Primary vs secondary** (critical distinction): - **Primary (idiopathic)**: circulating permeability factor (suPAR? others under research); diffuse foot process effacement on EM; nephrotic syndrome; often steroid-responsive; - **Secondary**: maladaptive (obesity, reduced nephron number, reflux, HTN), drug (heroin, lithium, anabolic steroids, bisphosphonate, IFN), infection (HIV, parvovirus, SARS-CoV-2), genetic; subnephrotic proteinuria; focal foot process effacement; (4) **Genetic FSGS**: NPHS1 (nephrin), NPHS2 (podocin), WT1 (Denys-Drash), TRPC6, INF2, ACTN4 (autosomal dominant), COL4A3/4/5 (Alport — overlap), MYO1E; **APOL1** high-risk variants — African ancestry — increased FSGS, HIVAN, lupus nephritis collapsing, CKD progression risk; (5) **IF**: nonspecific IgM + C3 entrapment in sclerotic segments; full house argues for lupus; (6) **EM**: diffuse foot process effacement in primary; less in secondary; (7) **Treatment**: - **Primary FSGS**: corticosteroids first-line (high-dose prednisone ≥ 4 mo); steroid-resistant — calcineurin inhibitors (cyclosporine, tacrolimus); rituximab considered; **MMF, ACTH, abatacept** in refractory; **plasmapheresis** for recurrent FSGS post-transplant; - **Secondary FSGS**: address underlying (weight loss, RAS blockade, treat HIV — TAF/PrEP, drugs); - **SGLT2 inhibitors** added for proteinuric CKD (DAPA-CKD); - **Sparsentan** (dual endothelin + AT1R antagonist — DUPLEX trial) approved 2023 FSGS; (8) **Genetic testing** in pediatric + adult selected — guides treatment (genetic forms don''t respond to immunosuppression typically); (9) **Recurrence** in transplant ~ 30% primary — plasmapheresis ± rituximab; (10) **Multidisciplinary**

---

FSGS: segmental sclerosis + podocyte injury. Columbia subtypes (tip, perihilar, cellular, collapsing, NOS). Primary (steroid-responsive, diffuse FPE) vs secondary (maladaptive, focal FPE) vs genetic. APOL1 high-risk variants. Sparsentan + SGLT2 added. Genetic testing selected.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'KDIGO Glomerular 2021/2024; DUPLEX', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — nephrotic syndrome (proteinuria 6 g/d + edema + hypoalbuminemia + hyperlipidemia) → kidney biopsy: segmental sclerosis affecting < 50% glomeruli with podocyte foot process effacement on EM; IF: nonspecific IgM/C3 entrapment; APOL1 high-risk variants'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — nephrotic syndrome → biopsy: thickened GBM with subepithelial deposits ''spike'' on silver stain; IF: granular IgG + C3 along GBM; IHC: PLA2R+ on glomeruli; serum anti-PLA2R antibody positive', '[{"label":"A","text":"Minimal change"},{"label":"B","text":"Membranous Nephropathy (MN)"},{"label":"C","text":"FSGS"},{"label":"D","text":"IgA"},{"label":"E","text":"ATN"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Membranous Nephropathy (MN): (1) **Histology**: thickened GBM, ''spikes'' on Jones methenamine silver (basement membrane reaction around subepithelial deposits — represents new BM forming around immune deposits); (2) **IF**: diffuse granular IgG + C3 along GBM (IgG4 subclass dominant in primary); (3) **EM (staging — Ehrenreich-Churg)**: stage I — subepithelial deposits; II — spikes; III — incorporation; IV — resorption + irregular GBM; (4) **Primary (idiopathic) MN — ~ 80%**: autoimmune to podocyte antigens: - **PLA2R (M-type phospholipase A2 receptor) — ~ 70-80%** — serum + tissue IHC; biomarker for diagnosis + monitoring response; - **THSD7A** ~ 3% — second target; - **Newer antigens**: NELL1 (~ 5-10% — malignancy-associated MN), exostosin 1/2 (autoimmune), semaphorin 3B (pediatric), neural EGFL-like 1, protocadherin 7, HTRA1, others — actively discovered; (5) **Secondary MN — ~ 20%** — workup essential: - **Infection**: hepatitis B (children especially), syphilis, hepatitis C, schistosomiasis, malaria; - **Malignancy** (10% adult > 60 — especially NELL1+ — lung, colorectal, prostate); - **Drugs**: NSAIDs, gold, mercury, penicillamine, captopril, anti-TNF; - **Autoimmune**: lupus (Class V), RA, Sjögren — IgG1+2+3 mixed (not pure IgG4), C1q present (vs primary); - **Allograft**: de novo or recurrent; (6) **Workup**: - Serum anti-PLA2R + anti-THSD7A; - Hepatitis B + C, HIV, syphilis, ANA, complement; - Age-appropriate cancer screening; - Renal biopsy with IF + EM (immunoperoxidase for antigens); (7) **Treatment**: - **Conservative**: RAS blockade + statin + sodium restriction + DVT prophylaxis (high VTE risk — nephrotic + albumin < 2.5; nephrotic-range proteinuria); SGLT2 inhibitors; - **Immunosuppression** if high-risk (persistent nephrotic, declining eGFR): - **Rituximab** — first-line per KDIGO 2021 (MENTOR trial — superior to cyclosporine); - **Cyclophosphamide + steroids** (Ponticelli regimen) alternative; - **Calcineurin inhibitors** option but more relapse; - **Combination** for high-risk; - **Anti-PLA2R titer-guided** response monitoring; - **B-cell depletion antigen-specific therapies** emerging; (8) **Remission**: 30% spontaneous remission in primary — observation high-risk patients

---

MN: subepithelial deposits + spikes on silver; granular IgG/C3 IF. Primary ~80% — PLA2R, THSD7A, NELL1 (cancer-assoc), exostosins (autoimmune). Secondary: HBV/syphilis/malignancy/drugs/lupus class V. Rituximab first-line (MENTOR); anti-PLA2R titer-guided.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'KDIGO Glomerular 2021/2024; MENTOR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — nephrotic syndrome → biopsy: thickened GBM with subepithelial deposits ''spike'' on silver stain; IF: granular IgG + C3 along GBM; IHC: PLA2R+ on glomeruli; serum anti-PLA2R antibody positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย ICU + AKI; urine: muddy brown granular casts; FENa > 2%; biopsy if obtained: tubular epithelial sloughing + flattened cells + apoptosis + regenerative changes; การวินิจฉัยและการรักษา', '[{"label":"A","text":"GN"},{"label":"B","text":"Acute Tubular Necrosis (ATN) — Pathology + Management"},{"label":"C","text":"Vasculitis"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Tubular Necrosis (ATN) — Pathology + Management: (1) **Causes**: - **Ischemic**: sepsis, hypovolemia, hypotension, cardiac arrest, cardiogenic shock; - **Nephrotoxic**: aminoglycosides, vancomycin, contrast (less common now with iso-osmolar), chemo (cisplatin), pigment (rhabdomyolysis — myoglobin; hemolysis — hemoglobin), light chains (myeloma cast nephropathy distinct), heavy metals, ethylene glycol; (2) **Histology**: tubular epithelial cell injury, flattening, loss of brush border, sloughing into lumen, apoptosis/necrosis, denuded basement membrane, regenerative epithelium (mitoses), intratubular debris, no significant inflammation; preservation of glomeruli (early); (3) **Urinary findings**: muddy brown (epithelial cell) granular casts, isosthenuria (urine osm ~ serum osm — concentrating defect), FENa > 2% (lost concentrating ability vs pre-renal < 1%); FEUrea > 50%; (4) **AKI staging (KDIGO)** by Cr rise + urine output; (5) **Differential**: pre-renal (FENa < 1%, hyaline casts, responds to fluid), post-renal (obstruction — hydro on US), other intrinsic (GN, AIN, vascular); (6) **Acute Interstitial Nephritis (AIN) — distinct entity**: - Drug (PPIs, NSAIDs, antibiotics — beta-lactams, sulfa, vancomycin, fluoroquinolones, **immune checkpoint inhibitors major emerging cause**), infection, autoimmune; - Histology — interstitial inflammation + edema + eosinophils + tubulitis; - Urinalysis WBC + WBC casts + eosinophiluria (insensitive); rash + fever (less common now); - Treatment: stop offending drug + steroids if persistent + checkpoint AIN; (7) **Treatment ATN**: - **Address cause**: optimize hemodynamics, withdraw nephrotoxins, treat infection; - **Supportive**: AKI complications — volume management, hyperkalemia, acidosis, uremic complications; - **No specific therapy** to reverse ATN; recovery via tubular regeneration; - **Renal replacement therapy (RRT)** indications: refractory hyperK, acidosis, volume, uremic complications, certain intoxications (AEIOU); modalities CRRT vs IHD in unstable ICU; - **Pharmacology adjustment** for renal clearance; (8) **Recovery**: oliguria → diuresis phase → recovery — most regain function; some progress to CKD; AKI is independent risk for future CKD; (9) **Prevention**: hydration, avoiding nephrotoxins, sepsis bundles, smart-pump CT contrast protocols, drug monitoring (vancomycin AUC, aminoglycoside)

---

ATN: ischemic or nephrotoxic; muddy brown casts + FENa>2% + isosthenuria. Histology: tubular sloughing + regen. KDIGO AKI staging. AIN distinct (eos, ICI emerging cause). Tx: address cause + supportive + RRT for AEIOU; no specific reversal. Prevention key.', NULL,
  'medium', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'KDIGO AKI 2012; ASN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย ICU + AKI; urine: muddy brown granular casts; FENa > 2%; biopsy if obtained: tubular epithelial sloughing + flattened cells + apoptosis + regenerative changes; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — pancreatic cyst → EUS-FNA + cyst fluid analysis: CEA 600 ng/mL + amylase low + cytology: mucinous epithelial cells with mild atypia; imaging: branch-duct dilatation + mural nodule; molecular cyst fluid: KRAS + GNAS mutations; การวินิจฉัย', '[{"label":"A","text":"Pseudocyst"},{"label":"B","text":"Intraductal Papillary Mucinous Neoplasm (IPMN) — Pancreatic Cyst Workup"},{"label":"C","text":"Cancer"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intraductal Papillary Mucinous Neoplasm (IPMN) — Pancreatic Cyst Workup: (1) **Pancreatic cystic lesions (PCLs) — major categories**: - **Pseudocyst** (post-pancreatitis, no epithelium); - **Serous cystadenoma (SCA)** — benign, microcystic + central scar; - **Mucinous Cystic Neoplasm (MCN)** — pre-malignant, women, ovarian-type stroma; - **IPMN** (this case) — pre-malignant, main-duct + branch-duct + mixed; - **Solid pseudopapillary neoplasm** (young women); - **PNET cystic**; (2) **IPMN subtypes**: - **Main-duct IPMN (MD-IPMN)**: high malignant potential — usually surgical; - **Branch-duct IPMN (BD-IPMN)**: lower risk; - **Mixed**; - Pathology subtypes: gastric (most common BD-IPMN, low risk), intestinal (main duct, MUC2+, colloid carcinoma association), pancreatobiliary (high-grade, MUC1+), oncocytic (separate entity now); (3) **Workup (revised Kyoto 2024 + Fukuoka guidelines)**: - **High-risk stigmata** → resect: enhancing mural nodule ≥ 5 mm, MPD ≥ 10 mm, jaundice; - **Worrisome features** → consider EUS + biopsy: cyst ≥ 3 cm, thickened wall, MPD 5-9 mm, mural nodule < 5 mm, abrupt MPD change, lymphadenopathy, CA19-9 elevated, growth ≥ 5 mm/2 yr, new diabetes; - Surveillance per size + features; (4) **Cyst fluid analysis (EUS-FNA)**: - **CEA**: > 192 ng/mL suggests mucinous; very high (> 500) more likely mucinous neoplasm but not pre-malignant grading; - **Amylase**: high in pseudocyst + IPMN (connect to duct); low in MCN/SCA (don''t communicate); - **Glucose**: low (< 50 mg/dL) in mucinous; normal in non-mucinous (better than CEA in some studies); - **Cytology**: mucinous epithelium, atypia (limited sensitivity); - **Molecular**: KRAS + GNAS mutations highly suggestive IPMN (GNAS specific); KRAS + mucinous in MCN; VHL in SCA; CTNNB1 + solid pseudopapillary; - **String sign** of mucin; (5) **Management**: surgical resection for high-risk features; surveillance for low-risk (MRI/EUS); (6) **Resected pathology**: assess grade — low-grade dysplasia → high-grade → invasive carcinoma; invasive component changes prognosis substantially — surgical staging; (7) **Multidisciplinary**: GI + pancreatic surgery + radiology + pathology + medical onc; (8) **Hereditary**: PJS (STK11), familial pancreatic cancer — surveillance protocols

---

IPMN: cyst fluid CEA + amylase + glucose + cytology + KRAS/GNAS molecular. MD vs BD subtypes + histologic types. Fukuoka/Kyoto: high-risk stigmata → resect; worrisome → EUS+biopsy. Grade matters (LGD → HGD → invasive). Multidisciplinary; hereditary considerations.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'Revised Kyoto 2024; Fukuoka; WHO Digestive Tumors 5th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — pancreatic cyst → EUS-FNA + cyst fluid analysis: CEA 600 ng/mL + amylase low + cytology: mucinous epithelial cells with mild atypia; imaging: branch-duct dilatation + mural nodule; molecular cyst fluid: KRAS + GNAS mutations; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — fatigue + pruritus + jaundice; labs: ALP markedly elevated + GGT high + AMA positive (titer 1:160) + IgM elevated; biopsy: chronic non-suppurative cholangitis + bile duct destruction + lymphoplasmacytic + granulomas; การวินิจฉัย', '[{"label":"A","text":"Hepatitis"},{"label":"B","text":"Primary Biliary Cholangitis (PBC, formerly PBC = primary biliary cirrhosis)"},{"label":"C","text":"PSC"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Biliary Cholangitis (PBC, formerly PBC = primary biliary cirrhosis): (1) **Pathophysiology**: autoimmune destruction of small + medium intrahepatic bile ducts → chronic cholestasis → fibrosis → cirrhosis; women > men 10:1; middle-aged; (2) **Clinical**: fatigue + pruritus (mainstay symptoms — significant impact QoL); jaundice late; sicca symptoms (Sjögren overlap); osteoporosis; metabolic bone disease; hyperlipidemia (cholesterol) without increased CV; (3) **Diagnostic criteria** (2 of 3): - **ALP elevated ≥ 1.5× ULN ≥ 24 wk**; - **AMA (anti-mitochondrial Ab) positive** (M2 specific — anti-PDC-E2) ≥ 1:40 (95% PBC); - **Histologic features** typical of PBC (florid duct lesion); (4) **AMA-negative PBC** ~ 5% — anti-sp100 + anti-gp210 antinuclear Abs may help; (5) **Histology (Ludwig staging I-IV)**: - **Stage 1**: portal inflammation + florid duct lesion (CNSC + granulomas); - **Stage 2**: periportal + ductular proliferation; - **Stage 3**: bridging fibrosis; - **Stage 4**: cirrhosis; (6) **Differential**: - **Primary Sclerosing Cholangitis (PSC)**: men > women, IBD association, p-ANCA, large duct strictures (MRCP — beaded), ''onion-skin'' fibrosis; **no specific treatment** (UDCA not endorsed); cholangiocarcinoma + colorectal cancer surveillance; - **Autoimmune hepatitis** overlap (PBC-AIH overlap) — interface hepatitis + ALT high; - **IgG4-related disease** cholangiopathy — high IgG4 + storiform fibrosis; - **Drug-induced + others**; (7) **Treatment**: - **UDCA (ursodeoxycholic acid)** 13-15 mg/kg/d — first-line, improves biochemistry + survival + delays transplant — RESPONSE is critical (POISE/Toronto criteria); - **Obeticholic acid (OCA, Ocaliva)** — FXR agonist, second-line for UDCA-incomplete responders; - **Bezafibrate, fenofibrate** — fibrates — add-on UDCA-incomplete responders (BEZURSO trial); - **Seladelpar, elafibranor** — PPAR delta agonists — approved 2024-2025 for UDCA-inadequate response; - **Pruritus management**: cholestyramine, rifampin, naltrexone, sertraline, **ileal bile acid transporter (IBAT) inhibitor (linerixibat)** for chronic pruritus; - **Symptomatic**: fatigue (modafinil sometimes); osteoporosis (Ca, vit D, bisphosphonate); fat-soluble vitamins; (8) **Liver transplant** — end-stage cirrhosis or refractory pruritus; can recur post-transplant; (9) **Multidisciplinary**: hepatology + transplant + rheum + dietitian

---

PBC: autoimmune small bile duct destruction; women, AMA+ (PDC-E2), ↑ALP. Florid duct lesion + granulomas; Ludwig stages. UDCA 1st; OCA, bezafibrate, seladelpar/elafibranor (new) for incomplete responders. Pruritus management (rifampin, naltrexone, IBAT). Distinct from PSC.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'AASLD PBC 2018/2022; EASL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — fatigue + pruritus + jaundice; labs: ALP markedly elevated + GGT high + AMA positive (titer 1:160) + IgM elevated; biopsy: chronic non-suppurative cholangitis + bile duct destruction + lymphoplasmacytic + granulomas; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี post-cholecystectomy — biopsy bile duct mass: glandular structures with abundant desmoplastic stroma + perineural invasion; IHC: CK7+ CK19+ CK20- TTF1- CDX2- HepPar1- glypican3-; molecular: IDH1 + FGFR2 fusion analyzed', '[{"label":"A","text":"HCC"},{"label":"B","text":"Cholangiocarcinoma — Pathology + Molecular"},{"label":"C","text":"Pancreatic ca"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cholangiocarcinoma — Pathology + Molecular: (1) **Anatomic classification**: - **Intrahepatic cholangiocarcinoma (iCCA)** — small + large duct; - **Perihilar (Klatskin)** — most common, Bismuth-Corlette types I-IV; - **Distal extrahepatic** (distal bile duct); - **Gallbladder carcinoma** — separate entity but related; (2) **Histology**: glandular structures + abundant desmoplastic stroma + perineural + lymphovascular invasion; (3) **IHC**: CK7+, CK19+, CK20 variable (less in iCCA), CDX2 +/-, MUC1+; HepPar1-, glypican3- (distinguishes from HCC); CK20+/CDX2+ may suggest GI mets (differential); (4) **Molecular (key for targeted therapy)** — depends on subtype: - **iCCA**: - **IDH1/2 mutations** ~ 20% — **ivosidenib** (ClarIDHy IDH1 inhibitor) approved; enasidenib (IDH2) under study; - **FGFR2 fusions/rearrangements** ~ 10-15% — **pemigatinib (FIGHT-202), futibatinib (FOENIX-CCA2), infigratinib** approved; resistance via FGFR2 kinase mutations; - **BRAF V600E** ~ 5% — dab+tram; - **HER2 (ERBB2) amplification** — trastuzumab + pertuzumab, T-DXd; - **NTRK fusions** rare — larotrectinib/entrectinib; - **MSI-H/dMMR** — pembrolizumab; - **Perihilar/distal**: KRAS, TP53, SMAD4, ARID1A; less actionable; - **Gallbladder**: TP53, KRAS, HER2; (5) **Risk factors**: PSC, choledochal cysts, hepatolithiasis, **liver flukes Opisthorchis viverrini + Clonorchis sinensis** (endemic SE Asia — Thailand high incidence), chronic hepatitis B/C, NAFLD, biliary intraepithelial neoplasia; (6) **Workup**: CT/MRI MRCP/ERCP; tumor markers CA 19-9, CEA; tissue biopsy + brushings + molecular profiling; staging laparoscopy for advanced iCCA; (7) **Treatment**: - **Resectable**: surgical resection with R0 margin; adjuvant capecitabine (BILCAP); - **Locally advanced**: chemoRT or systemic; transplant for selected unresectable iCCA (UNOS criteria); - **Advanced/metastatic**: - **Frontline**: **durvalumab + gemcitabine + cisplatin** (TOPAZ-1) or **pembrolizumab + gem-cis** (KEYNOTE-966); - **Second-line**: matched targeted therapy if mutations + FOLFOX (ABC-06); - **Later lines**: targeted-specific (pemi, futi, ivosid, dab-tram, T-DXd, pembro MSI-H); (8) **Multidisciplinary**: GI/HPB surgery + hepatology + medical onc + RT + IR + pathology; (9) **Thailand context** — Opisthorchis-related cholangiocarcinoma — northeast region — public health programs

---

Cholangiocarcinoma: iCCA vs perihilar vs distal vs GB. CK7+/CK19+; HepPar-. iCCA molecular: IDH1 (ivosidenib), FGFR2 fusions (pemigatinib/futibatinib), BRAF, HER2, NTRK, MSI-H. Risk: PSC, choledochal cysts, liver flukes (Thailand). Frontline durva+gem-cis (TOPAZ-1).', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'NCCN Hepatobiliary; TOPAZ-1; ClarIDHy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี post-cholecystectomy — biopsy bile duct mass: glandular structures with abundant desmoplastic stroma + perineural invasion; IHC: CK7+ CK19+ CK20- TTF1- CDX2- HepPar1- glypican3-; molecular: IDH1 + FGFR2 fusion analyzed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี smoker + asbestos exposure 40 yr ago — pleural thickening + effusion; biopsy: epithelioid + spindle cells; IHC: calretinin+, WT1+, D2-40+, CK5/6+, BAP1 LOSS, MTAP loss; CEA- BerEP4- TTF1-; FISH: CDKN2A homozygous deletion; การวินิจฉัย', '[{"label":"A","text":"Lung ca"},{"label":"B","text":"Malignant Pleural Mesothelioma (MPM)"},{"label":"C","text":"TB"},{"label":"D","text":"Hospice only"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Pleural Mesothelioma (MPM): (1) **Etiology**: **asbestos exposure** primary (long latency 20-50 yr); other — erionite (Turkey), radiation, SV40 (debated), BAP1 germline mutation (familial mesothelioma); pleural >> peritoneal > pericardial > tunica vaginalis; (2) **Histology subtypes** (matter prognostically + treatment): - **Epithelioid** ~ 70% (best prognosis); - **Sarcomatoid** ~ 15% (worst); - **Biphasic** (both); - **Desmoplastic** variant of sarcomatoid; - WHO 2021 includes **mesothelioma in situ** (early lesion concept); (3) **Histology**: tubulopapillary, solid, trabecular, deciduoid, lymphohistiocytoid, transitional; spindle sarcomatoid; (4) **IHC (panel essential — distinguish from adenocarcinoma metastatic to pleura — most important DDx)**: - **Mesothelial markers (positive in meso)**: calretinin (high sens + spec), WT1, **D2-40 (podoplanin)**, CK5/6, cytokeratin (CK7+/CK20- typical), mesothelin, HEG1, **claudin 15+**; - **Adenocarcinoma markers (negative in meso)**: CEA, BerEP4, MOC31, claudin-4, TTF-1 (lung), GATA3 (breast/urothelial), PAX8 (Müllerian/RCC); - Need ≥ 2 mesothelial + ≥ 2 negative adenoca to support meso (per IMIG); (5) **Distinguishing benign mesothelial reactive vs malignant (challenging on cytology + small biopsies)**: - **BAP1 IHC loss** + **MTAP loss** (CDKN2A/p16 surrogate) + **p16/CDKN2A homozygous deletion by FISH** — support malignancy; - **MTAP/BAP1 dual IHC reliable**; - **5-hmC loss**; - Definitive often requires invasion seen on biopsy; (6) **Molecular**: BAP1 loss/mutation ~ 60% (germline + somatic — Family BAP1 syndrome — meso + uveal melanoma + RCC + others); NF2, TP53, SETD2; (7) **Staging**: TNM 8th ed; CT + PET + diffusion MRI; surgical staging laparoscopy in select; (8) **Treatment**: - **Systemic frontline**: **nivolumab + ipilimumab** (CheckMate 743) — superior to chemo for non-epithelioid + comparable epithelioid; chemo (cisplatin + pemetrexed ± bevacizumab) historical; chemo + nivolumab combo; - **Surgical resection**: extended pleurectomy/decortication or extra-pleural pneumonectomy (less favored) — multimodal trimodal therapy (chemo + surgery + RT) for early-stage; - **Symptomatic**: pleurodesis, indwelling pleural catheter for recurrent effusion; (9) **Multidisciplinary**: thoracic surg + medical onc + RT + path; (10) **Compensation + occupational** — many countries support patients

---

MPM: asbestos; epithelioid/sarcomatoid/biphasic. IHC: calretinin/WT1/D2-40/CK5/6+; CEA/BerEP4/TTF1-. BAP1 loss + MTAP loss + p16/CDKN2A homozygous deletion distinguish from reactive. Nivo+ipi frontline (CheckMate 743). BAP1 germline syndrome.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Thoracic Tumors 5th ed; CheckMate 743', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี smoker + asbestos exposure 40 yr ago — pleural thickening + effusion; biopsy: epithelioid + spindle cells; IHC: calretinin+, WT1+, D2-40+, CK5/6+, BAP1 LOSS, MTAP loss; CEA- BerEP4- TTF1-; FISH: CDKN2A homozygous deletion; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — episodic hypertension + headaches + sweating + palpitations; plasma metanephrines elevated; CT: adrenal mass; biopsy (rarely needed): nests of chromaffin cells ''Zellballen'' pattern; IHC: chromogranin+, synaptophysin+, S100+ (sustentacular); molecular: SDHB testing', '[{"label":"A","text":"Cortisol-secreting"},{"label":"B","text":"Pheochromocytoma + Paraganglioma (PPGL)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Skip"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pheochromocytoma + Paraganglioma (PPGL): (1) **Origin**: chromaffin cells of adrenal medulla (pheochromocytoma) or extra-adrenal sympathetic/parasympathetic paraganglia (paraganglioma); (2) **Clinical**: classic triad — episodic headache + palpitations + sweating; sustained or paroxysmal hypertension; pallor; orthostatic; metabolic; some asymptomatic incidentaloma; (3) **Histology**: ''Zellballen'' (cell balls) — nests of polygonal chromaffin cells surrounded by capillary network; cytoplasm fine granular (catecholamines); pleomorphism doesn''t predict malignancy; (4) **IHC**: chromogranin A+, synaptophysin+, GATA3+, tyrosine hydroxylase+; **sustentacular cells S100+ (surround the nests)**; (5) **Biochemistry (most important for diagnosis)**: - **Plasma free metanephrines + normetanephrines** OR **24-h urine fractionated metanephrines** — sensitivity > 95%; - Pre-analytics critical (supine, avoid stress, no medications interfering); - **Chromogranin A** elevated; - **Methoxytyramine** (dopamine metabolite) — head/neck paragangliomas + SDH-related; (6) **Localization**: CT/MRI for primary; **123I-MIBG scintigraphy + 68Ga-DOTATATE PET** for staging; (7) **All PPGL — consider malignant potential** (no benign — replaced by ''metastatic risk''): - **PASS** (Pheochromocytoma of Adrenal Scaled Score) + **GAPP** + **COPPS**; - Definition of malignancy = metastasis (lymph node, bone, lung, liver, brain); ~ 10-15% metastatic; (8) **Genetic — 40% PPGL have germline mutation — universal genetic testing recommended**: - **Cluster 1 (pseudohypoxia)**: SDHx (SDHA, SDHB — adverse, malignant risk, methoxytyramine; SDHC, SDHD, SDHAF2), VHL, EPAS1 (HIF2A), FH, PHD2; - **Cluster 2 (kinase signaling)**: RET (MEN2), NF1, TMEM127, MAX, HRAS; - **Cluster 3 (Wnt)**: CSDE1, MAML3 fusions; (9) **Pre-operative management critical** (avoid hypertensive crisis): - **Alpha-blockade FIRST** (phenoxybenzamine or doxazosin) 7-14 d; - **Volume expansion** + high salt diet; - Beta-blockade **only after** alpha-blockade (avoid unopposed alpha → hypertensive crisis); - Calcium channel blocker adjunct; (10) **Treatment**: - **Surgical resection** (laparoscopic for most adrenal); - **Metastatic**: **lutetium-177 DOTATATE (PRRT)** approved; sunitinib, mTOR inhibitors, CVD chemo (cyclophos-vincristine-DTIC), 131I-MIBG (Azedra) for MIBG-avid; HIF-2α inhibitor **belzutifan** approved for VHL-related; - **Surveillance**: lifelong — metanephrines, imaging; (11) **Family screening** for germline carriers

---

Pheo/PGL: Zellballen + chromog/synapto/GATA3+; sustentacular S100+. Plasma/urine metanephrines diagnostic. MIBG + DOTATATE imaging. 40% germline — universal genetic testing (SDHx/VHL/RET/NF1/MAX). Alpha-blockade FIRST pre-op. PRRT (177Lu-DOTATATE) metastatic. Belzutifan VHL.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'Endocrine Society PPGL 2014/updates; WHO Endocrine Tumors 5th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — episodic hypertension + headaches + sweating + palpitations; plasma metanephrines elevated; CT: adrenal mass; biopsy (rarely needed): nests of chromaffin cells ''Zellballen'' pattern; IHC: chromogranin+, synaptophysin+, S100+ (sustentacular); molecular: SDHB testing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — incidental thrombocytopenia 25 + petechiae; CBC otherwise normal; smear: scant large platelets; BM normal megakaryocytes; การวินิจฉัยและการรักษา', '[{"label":"A","text":"TTP"},{"label":"B","text":"Immune Thrombocytopenic Purpura (ITP) — Adult"},{"label":"C","text":"DIC"},{"label":"D","text":"MDS"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Immune Thrombocytopenic Purpura (ITP) — Adult: (1) **Diagnosis** — **diagnosis of exclusion**: isolated thrombocytopenia + no other cause + appropriate clinical (no hepatosplenomegaly, no LAD, no systemic illness); peripheral smear shows large platelets without schistocytes, normal RBCs/WBCs; (2) **Pathophysiology**: anti-platelet autoantibodies (often GPIIb/IIIa, Ib/IX) + T-cell dysregulation → enhanced platelet destruction + impaired production; (3) **Workup**: - CBC + smear + retic; - DAT (rule out Evans syndrome — AIHA + ITP); - HIV + HCV + H. pylori (treat if positive — can resolve ITP); - HBV before rituximab; - ANA (rule out lupus); - Quantitative immunoglobulins (CVID); - Thyroid (autoimmune common); - Anti-platelet Ab testing not routine (insensitive); - BM biopsy not required if classic presentation + atypical features (older, abnormal blood counts, persistent — selectively); (4) **Classification**: newly diagnosed (< 3 mo), persistent (3-12 mo), chronic (> 12 mo), refractory (failed splenectomy + others); (5) **Treatment** (ASH 2019, IWG 2020+): - **Asymptomatic with platelet ≥ 30K**: observation typically (no treatment threshold absolute); - **Platelet < 30K or bleeding**: - **First-line**: corticosteroids — dexamethasone 40 mg × 4 d (preferred — faster, less cumulative SE) vs prednisone 1 mg/kg taper; - **IVIG** (1-2 g/kg) — rapid rise, surgery, severe bleeding; - **Anti-D** (Rh-positive non-splenectomized — RhD+ adults — rare use now); - **Second-line**: - **TPO receptor agonists** (eltrombopag, romiplostim, **avatrombopag**) — increase production, durable, well-tolerated, growing first-line role in chronic; - **Rituximab** — anti-CD20; ~ 50-60% response; - **Splenectomy** — historically definitive, less common now due to thrombosis + infection risk; pre-op vaccines + lifelong consideration of vaccine adherence; - **Fostamatinib** (SYK inhibitor) — option chronic; - **Refractory**: combinations, rituximab, alemtuzumab; (6) **Bleeding management**: platelet transfusion (limited efficacy — antibodies still active), IVIG + steroids, antifibrinolytics, recombinant factor VIIa selected; (7) **Pregnancy ITP**: corticosteroids + IVIG (avoid splenectomy + rituximab + TPO unless essential — limited data); planning delivery; **neonatal alloimmune thrombocytopenia (NAIT)** distinct; (8) **Evans syndrome** (concurrent AIHA + ITP) consider; (9) **Hereditary thrombocytopenias** masquerade — MYH9, Bernard-Soulier — consider if unusual features; (10) **Multidisciplinary**: hematology + primary care + specialist for refractory

---

ITP: isolated low platelets, exclusion diagnosis; rule out HIV/HCV/H. pylori/lupus/Evans. Tx: observe if ≥30K + no bleed; otherwise dex 40 mg×4 d or pred + IVIG. 2nd line: TPO-R agonists (eltrombopag/avatrombopag), rituximab, splenectomy, fostamatinib. Pregnancy + Evans considerations.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'ASH ITP 2019; IWG 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — incidental thrombocytopenia 25 + petechiae; CBC otherwise normal; smear: scant large platelets; BM normal megakaryocytes; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — fever + neurologic + thrombocytopenia (15) + MAHA (schistocytes on smear) + AKI (Cr 1.5) + LDH 1500; ADAMTS13 activity < 10%; การวินิจฉัยและการรักษา', '[{"label":"A","text":"ITP"},{"label":"B","text":"Thrombotic Thrombocytopenic Purpura (TTP)"},{"label":"C","text":"DIC"},{"label":"D","text":"Refuse"},{"label":"E","text":"AIHA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thrombotic Thrombocytopenic Purpura (TTP): (1) **Classic pentad** (not all present): fever + neurologic + thrombocytopenia + microangiopathic hemolytic anemia (MAHA) + renal — only ~ 5% have all; thrombocytopenia + MAHA mandatory; (2) **Pathophysiology**: severe **ADAMTS13 deficiency** (< 10%) — ADAMTS13 normally cleaves ultralarge vWF multimers → uncleared multimers cause platelet aggregation → microthrombi in microcirculation; - **Acquired (iTTP)**: anti-ADAMTS13 autoantibody (most adults); - **Congenital (Upshaw-Schulman)**: rare, ADAMTS13 mutation; (3) **MAHA — schistocytes** on smear (mechanical fragmentation by microthrombi) + indirect bili + LDH up + haptoglobin low + reticulocytosis; (4) **PLASMIC score (or French) score** — predicts severe ADAMTS13 deficiency before assay back (helps decide on PLEX before result): platelets, hemolysis variables, cancer hx, prior transplant, MCV, INR, Cr; high score → start treatment empirically; (5) **Differential** thrombotic microangiopathy (TMA): - **Hemolytic uremic syndrome (HUS)**: - **Shiga toxin-producing E. coli (STEC) HUS** — diarrhea, children, supportive only; - **Atypical HUS (aHUS)** — complement-mediated (factor H, I, CD46/MCP, C3, factor B mutations; anti-factor H antibodies); **eculizumab/ravulizumab (anti-C5)** transformed treatment; - **Drug-induced TMA** (calcineurin inhibitors, gemcitabine, mitomycin, quinine, ticagrelor); - **Transplant-associated TMA**; - **Pregnancy-associated**: preeclampsia/HELLP/eclampsia, pregnancy-onset TTP/aHUS; - **DIC** distinguished (PT/PTT abnormal, fibrinogen low); - **Malignant hypertension TMA, scleroderma renal crisis, APS catastrophic**; (6) **Workup**: - ADAMTS13 activity + inhibitor (essential, but treat empirically while waiting if PLASMIC high); - Complement assays (C3, C4, factor H, B, anti-factor H if aHUS suspected); - STEC stool culture/PCR; - HIV + autoimmune; (7) **Treatment iTTP** (medical emergency — mortality 90% untreated): - **TPE (therapeutic plasma exchange) DAILY** — replaces ADAMTS13 + removes antibody — start ASAP (within hours); - **High-dose corticosteroids**; - **Caplacizumab** (anti-vWF nanobody — inhibits platelet-vWF interaction — HERCULES trial) — rapid platelet recovery + reduced events; - **Rituximab** added for iTTP (refractory or upfront in many centers — reduces relapse, durable); - **Monitor**: platelet count + LDH + ADAMTS13 trajectory; (8) **Congenital TTP**: prophylactic plasma infusions or recombinant ADAMTS13 (recently approved); (9) **Long-term**: relapse possible; surveillance ADAMTS13; (10) **Multidisciplinary**: hematology + nephrology + neurology + apheresis + ICU

---

TTP: thrombocytopenia + MAHA + ADAMTS13 < 10%. PLASMIC score guides empiric Tx. Differential: HUS (STEC/atypical), drug-induced TMA, pregnancy, DIC. iTTP Tx emergency: TPE daily + steroids + caplacizumab + rituximab. Congenital TTP — recomb ADAMTS13. Multidisciplinary.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'ISTH TTP 2020; HERCULES; ASH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — fever + neurologic + thrombocytopenia (15) + MAHA (schistocytes on smear) + AKI (Cr 1.5) + LDH 1500; ADAMTS13 activity < 10%; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย sepsis + multiorgan failure + bleeding from multiple sites + low platelets; labs: PT + PTT prolonged, fibrinogen 80, D-dimer markedly elevated, schistocytes mild on smear; การวินิจฉัยและการรักษา', '[{"label":"A","text":"TTP"},{"label":"B","text":"Disseminated Intravascular Coagulation (DIC)"},{"label":"C","text":"Hemophilia"},{"label":"D","text":"ITP"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disseminated Intravascular Coagulation (DIC): (1) **Pathophysiology**: systemic activation of coagulation (tissue factor release) → widespread microvascular thrombosis (organ ischemia) + consumption of clotting factors + platelets → bleeding + thrombosis paradoxically; secondary fibrinolysis → elevated D-dimer/FDP; (2) **Triggers**: - **Sepsis** (most common — gram-negative + gram-positive); - **Malignancy**: solid tumors (mucin-producing — pancreas, prostate, GI), **acute promyelocytic leukemia (APL) — emergency** (Auer rods, t(15;17) PML-RARA — DIC prominent + needs ATRA STAT to prevent bleeding death); - **Obstetric**: amniotic fluid embolism, placental abruption, retained dead fetus, severe preeclampsia/HELLP; - **Trauma**, burns, head injury; - **Hemolytic transfusion reaction**; - **Snake bite**; - **Heat stroke**; (3) **Lab findings**: - **PT + aPTT prolonged**; - **Fibrinogen low** (< 100 — late, severe; can be normal early because acute-phase reactant); - **D-dimer/FDP elevated**; - **Platelet count low** (consumption); - **Schistocytes** on smear (mild — vs TTP/HUS); - **Antithrombin + protein C low**; (4) **Scoring systems**: - **ISTH DIC score** (platelets, D-dimer, PT prolongation, fibrinogen) — ≥ 5 = overt DIC; - **JAAM** (Japan), pre-DIC criteria; (5) **Acute (consumptive) vs chronic (compensated) DIC**: chronic — slower (e.g., malignancy) — labs may be subtler; (6) **Treatment**: - **TREAT UNDERLYING CAUSE** (sepsis source, deliver placenta, ATRA for APL, etc.) — most important; - **Supportive** based on bleeding vs thrombotic phenotype + lab values: - **Bleeding**: FFP, cryoprecipitate (fibrinogen < 1.5), platelets (< 50 with bleeding, < 20 prophylaxis); - **Thrombotic phenotype** (DVT/PE in DIC): therapeutic LMWH/UFH carefully if platelets > 30-50 + no major bleed; - **APL DIC**: ATRA + arsenic + supportive; (7) **Antithrombin concentrates, recombinant thrombomodulin, activated protein C (drotrecogin alfa — withdrawn) — NOT recommended now**; (8) **DIC differential**: liver disease (low factors, can mimic; factor VIII normal/high in liver vs low in DIC), vitamin K deficiency, severe trauma; (9) **Multidisciplinary**: ICU + heme + obstetric/onc per cause + transfusion medicine + ID; (10) **Monitor**: serial labs (PT/PTT/fib/platelets/D-dimer) trends

---

DIC: systemic activation coag → consumption + bleeding + thrombosis. PT/PTT↑ + fibrinogen↓ + D-dimer↑↑ + plt↓ + schistocytes. ISTH score. Triggers: sepsis, APL, OB, trauma. Tx: treat cause + supportive (FFP/cryo/platelets for bleeding; LMWH for thrombotic). APL — ATRA immediate.', NULL,
  'medium', 'coagulation', 'review',
  'pathology', 'clinical_decision', 'coagulation', 'adult',
  'ISTH DIC; ASH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย sepsis + multiorgan failure + bleeding from multiple sites + low platelets; labs: PT + PTT prolonged, fibrinogen 80, D-dimer markedly elevated, schistocytes mild on smear; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 3 ปี — eye exam: leukocoria + retinoblastoma; pathology: small round blue cells + Flexner-Wintersteiner rosettes; RB1 gene mutation hereditary; การ workup และการ multidisciplinary integrative care', '[{"label":"A","text":"Refuse"},{"label":"B","text":"Retinoblastoma — Pathology + Integrative Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Random"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Retinoblastoma — Pathology + Integrative Care: (1) **Epidemiology**: most common pediatric intraocular malignancy; ~ 95% diagnosed < 5 yr; unilateral (~ 75%, sporadic) + bilateral (~ 25%, hereditary, younger); (2) **Pathology**: - Small round blue cells; - **Flexner-Wintersteiner rosettes** (pseudorosettes — circle around clear lumen with photoreceptor differentiation); - **Homer-Wright rosettes** (around fibrillary material); - Fleurettes (more differentiated); - **Necrosis** + **calcifications** common; - Vitreous seeding; - **Risk factors for metastasis** on pathology: optic nerve invasion beyond lamina cribrosa, choroid massive invasion, scleral, anterior segment; (3) **IHC**: NSE+, synaptophysin+, retinal markers (CRX+, NRL+); (4) **Genetics**: - **RB1 (chromosome 13q14)** — first tumor suppressor described — Knudson two-hit hypothesis; - **Hereditary (germline RB1 mutation — ~ 40%)**: autosomal dominant, bilateral + multifocal + earlier onset; second tumor risk (osteosarcoma, soft tissue sarcoma, melanoma); trilateral retinoblastoma (PNET); - **Sporadic (somatic — ~ 60%)**: usually unilateral + later onset; - **MYCN amplification**: rare subset RB1-WT — aggressive; - **Genetic counseling + germline testing** for all + family screening; (5) **Diagnosis**: examination under anesthesia (clinical diagnosis usually — biopsy avoided to prevent seeding), B-scan US, MRI orbit + brain (avoid CT — radiation + RB1 second tumor risk); biopsy avoided (can seed); (6) **Staging**: International Classification of Retinoblastoma (ICRB) for intraocular A-E; staging extraocular; (7) **Treatment** (multidisciplinary — ocular oncology + pediatric oncology): - **Goals**: save life > save eye > save vision; - **Intraocular therapy**: - Focal: cryotherapy, laser, brachytherapy plaque; - **Intravenous chemo (CEV — carboplatin/etoposide/vincristine)** — bilateral, advanced unilateral with hope of salvaging eye; - **Intra-arterial chemotherapy (IAC)** — ophthalmic artery — local control with less systemic; - **Intravitreal chemotherapy** — vitreous seeds — methotrexate or melphalan; - **Enucleation**: for advanced when vision not salvageable or systemic risk; - **EBRT**: avoided when possible (second tumor + facial deformity); - **Adjuvant chemo + RT** post-enucleation if high-risk features; (8) **Long-term surveillance**: second tumor (especially germline), prosthesis care, growth + facial; (9) **Multidisciplinary**: ophthalmology + ocular onc + pediatric onc + genetics + radiology + RT + pathology + prosthetics + psychology + ophthalmology + family support

---

Retinoblastoma: pediatric intraocular; Flexner-Wintersteiner rosettes; CRX/synapto+. RB1 germline (40% — hereditary, bilateral, 2nd tumor risk) vs sporadic. Diagnosis clinical (avoid biopsy seeding). Treatment: save life>eye>vision; IV/IAC chemo, focal, enucleation when needed. Germline test + family screening.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'ICRB; AAO Retinoblastoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 3 ปี — eye exam: leukocoria + retinoblastoma; pathology: small round blue cells + Flexner-Wintersteiner rosettes; RB1 gene mutation hereditary; การ workup และการ multidisciplinary integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — Hodgkin lymphoma 30 ปีก่อน รักษาด้วย radiation + chemo; ตอนนี้ progressive shortness of breath + cardiomyopathy + breast mass; integrative survivorship care + late effects + multidisciplinary', '[{"label":"A","text":"Random"},{"label":"B","text":"Cancer Survivorship + Late Effects — Hodgkin Lymphoma Example"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Random"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cancer Survivorship + Late Effects — Hodgkin Lymphoma Example: (1) **Cancer survivorship growing population**: > 18M in US, similar growth globally; long-term post-treatment management essential; (2) **Late effects of treatment**: - **Cardiovascular** (chemo + RT — anthracycline cardiomyopathy, mantle RT — pericardial + valvular + coronary; cardio-onc screening); - **Pulmonary** (bleomycin pulmonary fibrosis; mantle RT — pulmonary fibrosis); - **Second primary malignancies**: solid tumors (breast — esp women with mantle RT, lung — esp smokers, thyroid, GI, sarcoma) + secondary leukemia (MDS/AML after alkylating + topoisomerase II inhibitors); - **Endocrine**: hypothyroidism (neck RT — TSH annual), gonadal failure (chemo + pelvic RT — fertility + bone density); growth hormone (children); diabetes risk increased; - **Fertility + reproductive**: pre-treatment counseling + sperm/oocyte/ovarian tissue cryopreservation; - **Bone health**: osteoporosis (steroid, hypogonadism, aromatase inhibitor); DEXA; bisphosphonate/denosumab; - **Cognitive** (''chemo brain'' — multifactorial); - **Psychosocial**: depression, anxiety, PTSD, fear of recurrence, work/relationships, financial toxicity; - **Sexual + body image**: importance; - **Lymphedema** (axillary surgery + RT); - **Fatigue** persistent; (3) **Hodgkin-specific late effects (NCCN/ASCO survivorship)**: - **Annual breast MRI + mammogram** from 8 yr post-RT or age 25 (whichever later) — high breast ca risk women with mantle RT; - **Cardio-onc evaluation** baseline + serial echo/CMR for selected; - **Pulmonary** evaluation; - **Thyroid US + TSH** annually with neck RT; (4) **Survivorship care plan**: - **Treatment summary** (regimens, doses, dates, complications); - **Surveillance schedule** by risk; - **Healthy behaviors** (smoking cessation paramount, exercise, nutrition, alcohol moderation, sun protection, vaccinations); - **Mental health support**; - **Family genetic counseling** when relevant; - **Communication** between oncologist + primary care + specialists; (5) **Integrative + complementary**: nutrition, exercise (oncology), mindfulness, acupuncture, yoga, massage — evidence-based use; (6) **Equity**: access disparities + financial toxicity; - **Care coordination + navigation**; (7) **De-escalation in modern Hodgkin treatment** (ABVD reduced, A+AVD, IO-based) aims to reduce these late effects

---

Cancer survivorship: late effects include CV (anthracycline + RT), 2nd malignancy (breast post-mantle RT, MDS/AML, lung), endocrine (thyroid, gonadal), bone, cognitive, psychosocial, fertility, lymphedema. Hodgkin: annual breast MRI + mammo from 8 yr/age 25 w/ mantle RT. Survivorship care plan + multidisciplinary.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'integrative', 'hematopathology', 'adult',
  'ASCO/NCCN Survivorship; LIVESTRONG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — Hodgkin lymphoma 30 ปีก่อน รักษาด้วย radiation + chemo; ตอนนี้ progressive shortness of breath + cardiomyopathy + breast mass; integrative survivorship care + late effects + multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab director — TAT (turnaround time) improvement project; data shows STAT troponin TAT > 60 min target 45 min; implementing lean methodology + value stream mapping + interventions', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Lab TAT Improvement Project (Lean Six Sigma)"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab TAT Improvement Project (Lean Six Sigma): (1) **Define TAT components — vein-to-result**: - Order entry → collection → transport → accessioning → analysis → verification → reporting; - Each step contributes; total + each phase measured; (2) **Lean methodology approach**: - **Value Stream Mapping (VSM)** — visualize current state with times + delays + handoffs + queues; identify ''waste'' (non-value-added activities); - **Gemba walk** — leaders observe actual workflow; - **8 wastes (DOWNTIME / TIMWOODS)** — defects, overproduction, waiting, non-utilized talent, transportation, inventory, motion, excess processing; - **Future state map** with eliminated waste + improvements; (3) **Six Sigma DMAIC**: - **Define**: problem statement + goal + scope + voice of customer; - **Measure**: baseline data + process capability + Pareto analysis; - **Analyze**: root causes (fishbone, 5 whys, FMEA); - **Improve**: pilot interventions; - **Control**: standardize + monitor (SPC charts); (4) **Common interventions for STAT TAT**: - **Pneumatic tube** transport vs courier (reduces transport time); - **Automated accessioning + receiving**; - **Pre-analytical automation** (track systems); - **Reflex testing** algorithms; - **Critical sample prioritization** in analyzer queues; - **Middleware** auto-verification (90-95% normal results bypass tech review); - **POCT** (point-of-care testing) — at the bedside (troponin 0/1-h algorithm with POCT cTn for ED); - **Workflow redesign**: dedicated STAT lane, staffing patterns matching demand (volume by time of day); - **Communication systems**: alerts for STAT samples, real-time dashboards; - **Pre-analytic improvements**: better order sets, mislabel reduction (right patient ID, two identifiers, barcoding), draw + transport SOPs; (5) **Stakeholder engagement**: ED + cardiology + ICU + lab — input + accountability; (6) **Metrics**: median + 90th percentile TAT, % within target (e.g., 90% < 60 min); not just average; (7) **Sustainability**: standardized work, daily huddles, monthly reviews, training; (8) **Patient outcomes connection**: faster TAT → faster MI rule-out, reduced ED LOS, better patient experience; (9) **Continuous improvement culture**: Kaizen events, employee suggestions, leadership support; (10) **Data-driven**: dashboards + real-time monitoring + accountability + transparency

---

TAT improvement Lean Six Sigma: VSM + Gemba walk + 8 wastes (TIMWOODS) + DMAIC. Interventions: pneumatic tube, automation, middleware auto-verify, POCT, dedicated STAT lane, staffing match. Measure median + 90th percentile + %target. Stakeholder engagement + sustainability + continuous improvement.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CAP Lean Lab; ASCP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab director — TAT (turnaround time) improvement project; data shows STAT troponin TAT > 60 min target 45 min; implementing lean methodology + value stream mapping + interventions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab — major mislabeling event led to wrong-patient transfusion → root cause analysis (RCA) + corrective action plan + sentinel event reporting + system change', '[{"label":"A","text":"Punish"},{"label":"B","text":"Sentinel Event + Root Cause Analysis (RCA)"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sentinel Event + Root Cause Analysis (RCA): (1) **Definitions**: - **Sentinel event** (TJC): patient safety event that reaches the patient + results in death, permanent harm, or severe temporary harm + requires immediate investigation + response; wrong-blood-in-tube → transfusion reaction = sentinel event; - **Adverse event**: any untoward outcome; - **Near miss**: error that didn''t reach patient (still tracked + analyzed); - **No-harm event**: reached patient but no harm; (2) **Response framework**: - **Immediate action**: stabilize patient + prevent further harm + secure equipment/specimens for analysis; - **Mandatory disclosure** to patient/family per institution + ethical standards; - **Report internally** (event reporting system); externally per regulation (state, TJC); (3) **Root Cause Analysis (RCA)** (TJC requirement for sentinel events, completed within 45 d): - **Multidisciplinary team** assembled — frontline staff + leadership + risk + content experts; - **Just culture approach** — fair, blame-free where appropriate (vs reckless behavior accountability); - **Tools**: fishbone (Ishikawa) diagram, 5 Whys, process flow mapping, FMEA; - **Categories**: communication, leadership, training, equipment, environment, information management, policies; - **System causes vs proximal**: most events have multiple system contributors (Swiss cheese model — accumulated holes align); (4) **Action plan**: - **Strong actions** (most effective): forcing functions (e.g., positive patient identification at scan — incompatible barcode → can''t proceed), automation, simplification, standardization, redundancy; - **Intermediate**: training, education, checklists, double-check; - **Weak**: warnings, signage, reminders alone (failure-prone); (5) **Wrong-blood-in-tube specifically**: - **Pre-collection**: two patient identifiers active confirmation (name + DOB or MRN; patient state name back); ID band check; - **Specimen labeling at bedside** (not later); - **Type & screen second sample** for confirmation prior to transfusion of non-O blood in patient with no prior type; - **Electronic patient identification system** (barcode wristband + handheld scanner + blood bank issue station); - **Audit + monitor**; (6) **Communication of findings**: transparent — to patient/family, staff (lessons learned), institutional leadership + board, regulatory; (7) **Follow-up + monitoring**: outcomes of changes, ongoing surveillance, sustainability; (8) **Just culture** — distinguish human error (console), at-risk behavior (coach), reckless (accountable); (9) **Culture of safety**: leadership + non-punitive + learning + improvement; (10) **TJC NPSGs** patient safety goals updated + monitored

---

Sentinel event + RCA: immediate stabilize + disclose + report. RCA multidisciplinary, just-culture, system-focused (Swiss cheese). Action hierarchy: forcing functions > training > warnings. Wrong-blood-in-tube: 2-ID, bedside labeling, T&S confirm, electronic barcoding. Transparent + sustainable.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'TJC Sentinel Event; AHRQ; Just Culture', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab — major mislabeling event led to wrong-patient transfusion → root cause analysis (RCA) + corrective action plan + sentinel event reporting + system change'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of cytology specimen preparation — direct smear vs cytospin vs liquid-based vs cell block + cells in each + clinical application', '[{"label":"A","text":"Skip"},{"label":"B","text":"Cytology Specimen Preparation Comparison"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Same"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cytology Specimen Preparation Comparison: (1) **Direct smear**: - Spread cells directly onto slide; - Fast + simple; - Best for FNA + ROSE (rapid on-site evaluation); - Air-dried (Diff-Quik) for rapid bedside or wet-fixed (95% ethanol for Pap stain); - Limitations: requires expertise to smear without crushing; uneven distribution; air-drying causes nuclear changes (good for cytoplasm visualization in Diff-Quik); (2) **Cytospin (cytocentrifuge)**: - Centrifuges cell suspension onto small area; - Best for low-cellularity specimens (CSF, BAL); - Even cell distribution + small monolayer area; - Multiple slides from single specimen for stains/IHC; (3) **Liquid-based cytology** (ThinPrep, SurePath): - Cells collected in preservative liquid → automated processing → thin monolayer on slide; - Reduces obscuring blood + mucus; - Allows ancillary testing (HPV co-test from same vial — primary cervical cancer screening); - Standardized + reproducible; - Better for high-volume screening (cervical); cost higher; (4) **Cell block**: - Centrifuge concentrate of cell suspension → fixed in formalin → embedded in paraffin → cut sections like tissue → H&E + IHC + molecular; - Essential for ancillary studies (IHC, FISH, molecular) — provides histologic-quality sections; - Used for body fluids, FNA needle rinse, fluid sediment; - Multiple sections from one block for serial stains; (5) **Specialized preparations**: - Cytological imprint (touch prep) — gross specimen touched on slide; - Crush prep — for soft tissues; - Smear for brain (intraoperative neuropath frozen + smear); (6) **Stains used**: - **Papanicolaou** — transparent, nuclear detail (gold standard for gyn cyto); wet-fixed; - **Diff-Quik / May-Grünwald-Giemsa** — rapid, cytoplasm + extracellular material + organisms; air-dried; - **H&E** on cell block; - **Special stains** + **IHC on cell block** essential for ancillaries; (7) **Quality factors**: adequacy (cell number + appropriate cell type), preservation (cells intact + morphology preserved), staining quality; (8) **Reporting systems**: cyto-specific (Bethesda cervical/thyroid, Paris urine, Milan salivary, IPC pancreatic); (9) **Indications + selection**: choose method based on specimen + clinical question + ancillaries needed; often combination (e.g., FNA = ROSE direct smear + needle rinse for cell block)

---

Cytology preps: direct smear (fast, FNA/ROSE), cytospin (low cellularity CSF/BAL), liquid-based (cervical screening + HPV cotest), cell block (essential IHC + molecular). Pap (wet, nucl detail) vs Diff-Quik (air-dried, cytoplasm/organisms). Reporting systems specific. Combination often best.', NULL,
  'easy', 'cytopathology', 'review',
  'pathology', 'basic_science', 'cytopathology', 'mixed',
  'Papanicolaou Society; ASC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of cytology specimen preparation — direct smear vs cytospin vs liquid-based vs cell block + cells in each + clinical application'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of in situ hybridization (ISH) — DNA vs RNA + chromogenic vs fluorescent + applications in surgical pathology', '[{"label":"A","text":"Same as IHC"},{"label":"B","text":"In Situ Hybridization (ISH) Principles + Applications"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** In Situ Hybridization (ISH) Principles + Applications: (1) **Concept**: nucleic acid probes (labeled DNA or RNA) hybridize to complementary sequences in fixed tissue/cells → preserve spatial context; (2) **Probe types**: - **DNA ISH** — detects DNA targets (gene, chromosome region); - **RNA ISH (mRNA ISH)** — detects RNA (gene expression); - Probe length: short oligonucleotides vs longer (sensitive); - Labels: enzyme (chromogenic) vs fluorescent (FISH); (3) **Chromogenic ISH (CISH)**: - Enzyme-substrate (HRP/AP) generates colored precipitate; - Permanent slides; - Visualized on light microscope; - Often combined with IHC (dual stain); - HER2 ISH options (dual color CISH); (4) **Fluorescent ISH (FISH)**: - Direct fluorescent labels; - Multiple targets in same cell (multicolor); - Better single-cell resolution + co-localization; - Requires fluorescent microscope; signal fades; (5) **Major clinical applications**: - **HPV ISH** — high-risk HPV DNA or E6/E7 mRNA — diagnostic for HPV-associated cancers (cervical, OPSCC); - **EBV-encoded RNA (EBER) ISH** — gold standard for EBV-associated disease (Burkitt endemic, NPC, lymphoproliferative); - **Kappa + lambda light chain ISH** — assesses clonality in plasma cell + B-cell neoplasms (vs polyclonal reactive); - **HER2 FISH/CISH** — ratio + copies for breast/gastric/other cancers; - **ALK, ROS1, RET, NTRK FISH** — gene rearrangements in lung + other cancers (break-apart probes); - **MYC, BCL2, BCL6 FISH** — lymphoma (HGBL classification); - **MDM2 FISH** — liposarcoma vs lipoma; - **EWSR1, SS18, FUS-DDIT3, EWSR1-WT1, others** — sarcoma classification; - **1p/19q codeletion FISH** — oligodendroglioma; - **MET amplification, FGFR fusions, NRG1 fusions**; - **CDKN2A homozygous deletion** — mesothelioma diagnosis (vs reactive); (6) **RNA ISH applications**: - **RNAscope** technology — sensitive RNA ISH visualizing individual transcripts as dots; gene expression spatially; - PD-L1 mRNA, neuroendocrine markers, lineage markers; (7) **Advantages**: spatial context preserved (vs PCR), works on FFPE, can be multiplexed; (8) **Limitations**: requires known target (not discovery), sensitivity may be lower than PCR, technical complexity, controls essential; (9) **Quality**: validated probes, positive + negative controls, internal controls, signal interpretation guidelines; (10) **Increasing role with multiplex imaging + spatial transcriptomics emerging** — co-detection of many targets

---

ISH: DNA/RNA probes hybridize to complementary sequences preserving tissue context. CISH (chromogen, perm) vs FISH (fluorescent, multicolor). Applications: HPV ISH, EBER, kappa/lambda clonality, HER2/ALK/MYC/MDM2 FISH, CDKN2A meso, RNAscope. Multiplex/spatial emerging.', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'CAP Molecular Pathology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of in situ hybridization (ISH) — DNA vs RNA + chromogenic vs fluorescent + applications in surgical pathology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — submandibular mass FNA: malignant cells with biphasic ducts + myoepithelial component; resection: salivary tumor — adenoid cystic carcinoma vs mucoepidermoid; pathology characterization', '[{"label":"A","text":"Cyst"},{"label":"B","text":"Salivary Gland Tumors — Pathology + Classification"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Salivary Gland Tumors — Pathology + Classification: (1) **Common benign**: pleomorphic adenoma (most common, mixed tumor, PLAG1/HMGA2 fusions, recurrence + malignant transformation risk), Warthin (lymphoid stroma + oncocytic epithelium, smokers), basal cell adenoma, oncocytoma; (2) **Common malignant**: - **Mucoepidermoid carcinoma (MEC)** — most common malignant; mucous + intermediate + epidermoid cells; **MAML2 rearrangements (CRTC1-MAML2 or CRTC3-MAML2)** — characteristic; histologic grading (low/intermediate/high) + AFIP/Brandwein systems; - **Adenoid cystic carcinoma (AdCC)** — second most common; cribriform + tubular + solid patterns; biphasic ductal + myoepithelial; **MYB-NFIB fusion** (t(6;9)) ~ 80%; characteristic **perineural invasion** + indolent + late recurrences; solid pattern (≥ 30%) worse; - **Acinic cell carcinoma** — serous acinar differentiation; **NR4A3 rearrangement (HTN3-NR4A3 in subset; PER1-NR4A3 others)** in 80%; **secretory carcinoma (MAML)** previously called mammary analogue — **ETV6-NTRK3 fusion** — actionable with larotrectinib/entrectinib; - **Salivary duct carcinoma (SDC)** — aggressive; resembles breast ductal carcinoma; HER2+, AR+, **androgen receptor**+ — actionable (trastuzumab, AR-targeted bicalutamide/enzalutamide); - **Polymorphous adenocarcinoma (PAC)** — minor glands palate; PRKD1 hotspot in classical, PRKD1/2/3 fusions in cribriform; - **Carcinoma ex pleomorphic adenoma** — malignant transformation of pleomorphic adenoma; PLAG1/HMGA2 + PI3K/TP53; - Others; (3) **Reporting (Milan System for Salivary FNA)**: I non-diagnostic; II non-neoplastic; III AUS; IVa benign neoplasm; IVb SUMP (salivary uncertain malignant potential); V suspicious; VI malignant — with ROM stratification; (4) **IHC + molecular increasingly drive classification**: - p63/p40 (myoepithelial + squamous); - SOX10 (myoepithelial); - DOG1 (acinic cell); - S100 (myoepithelial subtypes, secretory); - **Pan-Trk IHC** (secretory carcinoma — NTRK fusions); - **Androgen receptor** (SDC); - **HER2** (SDC); - **Site-specific** algorithms; (5) **Imaging**: MRI, US, CT; (6) **Treatment** based on type + stage + grade + extent: - Surgical resection (preserve facial nerve when possible); - Adjuvant RT for high-grade/positive margins/perineural; - Systemic for advanced/metastatic — site-specific (NTRK inhibitors for secretory, AR-targeted for SDC, HER2 for SDC, immunotherapy emerging); (7) **Multidisciplinary**: H&N surgery + RT + medical onc + path + dental + speech + rehab

---

Salivary tumors: MEC (MAML2 fusion), AdCC (MYB-NFIB, PNI), acinic (NR4A3), secretory (ETV6-NTRK3 — larotrectinib!), salivary duct (HER2+/AR+ — trastuzumab/AR-targeted), polymorphous (PRKD1). Milan System FNA reporting. Molecular increasingly drives classification + targeted Tx.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO H&N 5th ed; Milan System Salivary', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — submandibular mass FNA: malignant cells with biphasic ducts + myoepithelial component; resection: salivary tumor — adenoid cystic carcinoma vs mucoepidermoid; pathology characterization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with end-stage cancer + comprehensive palliative care + multidisciplinary integration — pathology role in goals of care decisions + symptom management + decision-making + end-of-life', '[{"label":"A","text":"Random"},{"label":"B","text":"Palliative + End-of-Life Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Palliative + End-of-Life Integrative Care: (1) **Palliative care definition** (WHO): improves QoL of patients + families facing life-threatening illness through prevention + relief of suffering by early identification + assessment + treatment of pain + other physical/psychosocial/spiritual problems; **NOT limited to end-of-life**; **integrated early improves outcomes** (Temel JCO 2010 NEJM lung cancer); (2) **Pathology role in palliative**: - **Diagnosis confirmation** for goals of care + treatment selection; - **Biomarkers** identifying actionable disease vs futile chemo; - **Re-biopsy** at progression to assess for new actionable findings + transformation; - **Limited workup** when appropriate — match to goals; - **Communication** with palliative team + family about biology + prognosis; (3) **Multidisciplinary team**: physicians (palliative + primary + specialties) + nursing + social work + chaplaincy + counseling + child life (peds) + pharmacist + nutritionist + complementary care + grief support; (4) **Symptom management** (essential): - **Pain**: WHO ladder + opioid-based + adjuvants (neuropathic — gabapentinoid, antidepressant); fentanyl patch + breakthrough; methadone selected (complex); regional/intervention (celiac block, intrathecal pump); - **Dyspnea**: opioids + anxiolytic + thoracentesis/pleurodesis + indwelling pleural catheter + oxygen (selective benefit); - **Nausea/vomiting**: cause-directed + antiemetic; - **Constipation** (opioid-induced): scheduled stimulant + osmotic; methylnaltrexone, naloxegol for refractory; - **Delirium**: identify cause + nonpharm + antipsychotic; - **Fatigue, anorexia/cachexia**, dry mouth, dyspnea, depression, anxiety, existential distress; (5) **Goals of care + advance care planning**: - **Conversations early** (not just when imminently dying) — values, preferences, prognosis discussions, surrogate decision-maker, code status, AD/POLST; - **Family meetings** structured; - **Cultural + religious** considerations; (6) **Models of care delivery**: - Outpatient palliative; - Inpatient palliative consult; - Inpatient palliative units; - **Hospice** (typically prognosis < 6 mo, comfort-focused); home + inpatient; - Pediatric palliative + bereavement; (7) **End-of-life care**: comfort measures, family support, anticipatory guidance, bereavement; (8) **Ethical considerations**: shared decision-making, autonomy + futility, surrogate decision-making, physician-aid-in-dying jurisdictional, withholding/withdrawing; (9) **Equity**: disparities in palliative access — geography, race/ethnicity, language, insurance; advocacy + policy; (10) **Education**: all clinicians need primary palliative skills; specialists for complex

---

Palliative care: integrated early improves QoL + survival (Temel). Pathology contributes via diagnosis + biomarkers + re-biopsy guiding decisions. Multidisciplinary team. Symptom mgmt (pain WHO ladder, dyspnea, nausea, delirium). Goals of care + ACP early. Outpatient/inpatient/hospice models. Equity + education.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'mixed',
  'WHO Palliative; ASCO Palliative; Temel NEJM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with end-stage cancer + comprehensive palliative care + multidisciplinary integration — pathology role in goals of care decisions + symptom management + decision-making + end-of-life'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี ตั้งครรภ์ฝาแฝด → preterm delivery; placental examination: pathology workflow + chorioamnionitis + funisitis + maternal vascular underperfusion (MVU) + multidisciplinary integration', '[{"label":"A","text":"Discard"},{"label":"B","text":"Placental Pathology — Workup + Integration"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental Pathology — Workup + Integration: (1) **Indications for placental exam (NIH/CAP/Society for Pediatric Pathology guidelines)**: - **Maternal**: preeclampsia, eclampsia, gestational diabetes, infection, chorioamnionitis suspicion, severe HTN, abruption, abnormal placentation (accreta/percreta), preterm labor, multiple gestation, antepartum hemorrhage; - **Fetal/neonatal**: stillbirth/IUFD, IUGR/SGA, malformation, hydrops, anomalies, NICU admission, neonatal sepsis, perinatal death, preterm < 36 wk; - **Placental**: gross abnormality, weight outside expected; (2) **Examination workflow**: - **Gross**: weight (compared to gestational age tables), dimensions, cord (length, insertion type, knots, vessels — 2 arteries + 1 vein normal — single artery associated with anomalies + IUGR), membranes (insertion, color, opacity), parenchyma (infarcts %, retroplacental hematoma — abruption, thrombi, calcifications, masses); - **Sections**: routine + targeted abnormalities; (3) **Common pathologic patterns + significance**: - **Acute chorioamnionitis** (Amsterdam consensus): - Maternal inflammatory response stages (1-3) — neutrophils in chorion → membrane → chorionic plate; - Fetal inflammatory response — funisitis (umbilical vessels + Wharton''s jelly), chorionic vasculitis; - Suggests ascending infection; correlates with neonatal sepsis + preterm; - **Maternal Vascular Malperfusion (MVM)**: - Infarcts, retroplacental hematoma, distal villous hypoplasia, accelerated villous maturation, decidual arteriopathy (atherosis); - Associated with preeclampsia + IUGR + abruption; - **Fetal Vascular Malperfusion (FVM)**: - Thrombi in fetal vessels, avascular villi, villous stromal-vascular karyorrhexis; - Associated with cord abnormalities, thrombophilia, stillbirth, perinatal stroke + neurodevelopmental; - **Villitis of Unknown Etiology (VUE)**: - Maternal T-cell infiltration of villi; - Associated with IUGR, recurrent pregnancy loss, neonatal encephalopathy; - **Infectious villitis**: CMV (with characteristic inclusions), syphilis, malaria, Listeria; - **Massive perivillous fibrin deposition (MPFD), maternal floor infarction**: severe — associated with recurrent pregnancy loss; - **Choriohemangioma** (vascular tumor) — polyhydramnios + fetal hydrops; - **Mesenchymal dysplasia** vs partial mole; (4) **Twin gestations**: - **Determine chorionicity** (dichorionic-diamniotic, monochorionic-diamniotic, monochorionic-monoamniotic) — confirms US findings — clinical implications; - **Twin-twin transfusion (TTTS)** features; - Vascular anastomoses in MC; - Discordant growth + complications; (5) **Multidisciplinary**: pathology + OB + maternal-fetal medicine + neonatology + ID + genetics + clinical for case discussion + correlation; (6) **Communication**: standardized reporting (Amsterdam Workshop consensus) — placental findings linked to clinical syndromes; (7) **Counseling + recurrence risk**: e.g., MVM recurrence preeclampsia higher; thrombophilia screen + low-dose aspirin in selected; (8) **Stillbirth workup**: placenta + autopsy + cultures + genetics + history

---

Placental path: indications (maternal/fetal/placental). Amsterdam consensus terminology: acute chorioamnionitis (maternal + fetal stages), MVM (preeclampsia/IUGR), FVM (cord/thrombophilia), VUE, infectious. Twin chorionicity. Multidisciplinary correlation. Counseling for recurrence (preeclampsia, ASA).', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'mixed',
  'Amsterdam Placental Workshop Consensus; SPP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี ตั้งครรภ์ฝาแฝด → preterm delivery; placental examination: pathology workflow + chorioamnionitis + funisitis + maternal vascular underperfusion (MVU) + multidisciplinary integration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยทารกอายุ 3 เดือน — sudden unexpected death infant (SUDI) → postmortem exam + scene investigation + multidisciplinary integrative — SUID + SIDS + diagnostic workflow', '[{"label":"A","text":"Random"},{"label":"B","text":"Sudden Unexpected Infant Death (SUID) Workflow"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sudden Unexpected Infant Death (SUID) Workflow: (1) **Definitions**: - **SUID** — umbrella term for any sudden + unexpected death of infant < 1 yr; - **SIDS (Sudden Infant Death Syndrome)** — diagnosis of exclusion after complete investigation including autopsy + scene + history; - Other SUID causes: accidental suffocation/strangulation in bed (ASSB), infection, cardiac (channelopathy, cardiomyopathy), inborn errors of metabolism, trauma (including abusive head trauma), congenital anomalies undetected; (2) **Investigation components (CDC/NAME standards)**: - **Scene investigation** (using CDC SUID Reporting Form): sleep environment, bedding, position, co-sleeping, smoke exposure, recent illness, household; ME investigator visit scene; - **Doll reenactment** with caregiver; - Photography; - Medical + family + social history; (3) **Autopsy + ancillary** (full pediatric ME autopsy): - Complete external + internal; - Histology — heart, lungs, brain (esp. medulla — arcuate nucleus development), kidneys, liver, others; - Toxicology comprehensive; - Microbiology + viral; - **Metabolic screen** (acylcarnitine, organic acids, amino acids — newborn screen filter card retained); - **Genetics — molecular autopsy** for cardiac channelopathies (LQTS, CPVT, Brugada) + cardiomyopathies + metabolic — blood saved for DNA; - Vitreous fluid (chemistry, electrolytes for evaluation of dehydration); - Skeletal survey (rule out non-accidental trauma); (4) **SIDS triple-risk model**: vulnerable infant (e.g., immature brainstem serotonin function, prematurity, male) + critical developmental period (2-4 mo peak) + exogenous stressor (prone sleep, soft bedding, overheating, smoke, viral); (5) **Modifiable risk factors / safe sleep (AAP)**: - **Back to sleep**; - Firm sleep surface, no soft objects or loose bedding; - Room-sharing without bed-sharing first 6 mo; - Pacifier; - Breastfeeding; - Avoid overheating + smoke exposure + alcohol/drug exposure; - Routine immunizations; - Antenatal care + avoid smoking; - SUID rates fell after Back to Sleep campaign; (6) **Family support**: bereavement, counseling, autopsy results meeting (typically weeks-months); investigative process explained empathetically; (7) **Multidisciplinary review**: ME + pediatrician + cardiologist + geneticist + ID + social services + public health + child protection if abuse considered; (8) **Death scene investigation specific training** for investigators; (9) **Public health surveillance + research**: SUID registry, monitor trends, evaluate interventions, equity (Black + American Indian/Alaska Native + Native Hawaiian higher rates — disparities); (10) **Mandatory reporting** + cooperation with law enforcement; (11) **Differentiating accident vs natural vs homicide** essential — final manner determination

---

SUID workflow: scene investigation + doll reenactment + full autopsy + tox + micro + metabolic + molecular autopsy (channelopathy/CM). SIDS = exclusion diagnosis. Triple-risk model. Safe sleep AAP (Back to Sleep). Multidisciplinary review + bereavement. Public health surveillance + equity.', NULL,
  'medium', 'forensic', 'review',
  'pathology', 'clinical_decision', 'forensic', 'peds',
  'NAME SUID; AAP Safe Sleep', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยทารกอายุ 3 เดือน — sudden unexpected death infant (SUDI) → postmortem exam + scene investigation + multidisciplinary integrative — SUID + SIDS + diagnostic workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — digital pathology — whole-slide imaging (WSI) + AI/machine learning + validation + clinical implementation + regulatory considerations', '[{"label":"A","text":"Skip"},{"label":"B","text":"Digital Pathology + AI"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Same as IHC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Digital Pathology + AI: (1) **Whole-slide imaging (WSI)**: - Glass slides scanned to high-resolution digital images (gigapixel) at 20×, 40× or higher; - Stored, viewed, shared digitally; - Enables remote review, second opinions, education, archiving, image analysis; (2) **Components**: - **Scanner** (Aperio, Hamamatsu, Philips, 3DHistech, Leica, others); - **Image management system (IMS)** for storage + organization + LIS integration; - **Viewer software** for pathologist review; - **Annotation tools**; - **AI/ML platforms**; (3) **Clinical applications**: - **Primary diagnosis** (validated, FDA-approved devices) — replacing glass + microscope; - **Subspecialty consultation** via telepathology; - **Quantitative image analysis** — Ki-67, ER/PR, HER2, PD-L1, mitotic count; - **AI-assisted diagnosis**: e.g., Paige Prostate (FDA-approved 2021 — flags suspicious prostate biopsies; Galen Mantle / Galen Breast); BRACAnalysis CDx, image-based MSI prediction, Ihq quantification; - **Education** + training; - **Research** + drug development; (4) **AI/ML algorithms**: - **Convolutional neural networks (CNNs)** for image classification + segmentation; - **Trained on labeled datasets** (large + diverse); - **Validation** on independent datasets — performance metrics (sensitivity, specificity, AUC); - **Clinical validation** + regulatory clearance (FDA, EMA, NMPA, MFDS); (5) **CAP guidelines for WSI**: - **Validation** required before clinical use — at least 60 cases, intra-observer agreement glass vs WSI; - **Document** validation; - **Continuous QA**; (6) **Implementation considerations**: - **Infrastructure**: storage (huge data — petabytes), network bandwidth, computational power; - **Workflow integration**: LIS, accessioning, slide labeling, barcode tracking; - **Pathologist training + ergonomics**: monitor quality, workflow software, reading speed; - **Cost-benefit**: scanner + storage vs reduced shipping + remote work + AI productivity; - **Regulatory**: FDA-cleared devices for primary diagnosis; off-label use research-only otherwise; (7) **AI considerations**: - **Bias**: training data representation (race, ethnicity, geography, institutional); - **Generalizability**: validation on diverse populations; - **Explainability**: black-box concerns — interpretable AI; - **Continuous learning**: regulatory framework challenges with model updates; - **Workflow**: AI assists pathologist not replaces — augmented intelligence; - **Liability**: who is responsible — pathologist, manufacturer, institution; - **Ethics + consent**: data use, privacy, equity; (8) **Future**: - **Spatial transcriptomics + multiplex imaging** integration; - **Foundation models** (CHIEF, Virchow, GIGA) — general-purpose pathology AI; - **Workflow optimization**, prognosis prediction, treatment response, biomarker discovery; - **Real-time AI** assistance during sign-out; (9) **Telepathology** in low-resource settings — equity; (10) **Workforce + training**: digital pathology curricula in residency + fellowship

---

Digital pathology: WSI + scanner + viewer + AI. Applications: primary dx (FDA-approved devices), teleconsult, quantitative IHC, AI-assisted (Paige Prostate). CAP validation required (≥60 cases). AI considerations: bias, validation, explainability, regulatory, ethics. Foundation models emerging. Augmented intelligence not replacement.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'basic_science', 'quality_safety', 'mixed',
  'CAP WSI Validation; FDA Digital Pathology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — digital pathology — whole-slide imaging (WSI) + AI/machine learning + validation + clinical implementation + regulatory considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab — informatics + laboratory information system (LIS) + HL7/FHIR + connectivity + reporting + EHR integration + cybersecurity', '[{"label":"A","text":"Random"},{"label":"B","text":"Lab Informatics Framework"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab Informatics Framework: (1) **Laboratory Information System (LIS)** — central system managing all lab data (orders, specimens, analytics, results, reports, QC); subsystems for AP (anatomic path), CP (clinical path), molecular, blood bank, microbiology often distinct modules; (2) **Workflow + integration**: - **Order entry** in EHR/CPOE → LIS via interface; - **Specimen tracking** with barcodes (accessioning to disposal); - **Analyzer interfaces** auto-result entry; - **Auto-verification** rules (90-95% of normal results); - **Result reporting** back to EHR; - **Critical value workflow** with documentation; - **Reflex testing** automated (e.g., HER2 IHC 2+ → FISH); (3) **Standards for interoperability**: - **HL7 v2** — legacy messaging — most common LIS-EHR; - **HL7 FHIR** — modern RESTful API — emerging standard, granular resources, mobile-friendly; - **LOINC** — universal codes for lab tests; - **SNOMED CT** — clinical terminology; - **CPT** — billing; - **ICD-10/11** — diagnosis; (4) **Specialty considerations**: - **Anatomic pathology**: synoptic reporting (CAP cancer protocols) — structured data + standardized reporting; integration with WSI + AI; voice recognition dictation; - **Molecular pathology**: variant nomenclature (HGVS), variant interpretation (OncoKB, ClinVar), structured reporting; complex specimen routing; - **Blood bank**: ISBT 128 barcodes, special reagents tracking, antibody database; - **Microbiology**: organism + AST data, infection control alerts; (5) **EHR integration challenges**: - Multi-system environments; - Test ordering + interpretation by clinicians; - Display of comprehensive reports including images + PDF; - Discrete data extraction for downstream use; (6) **Data analytics**: - **Quality dashboards** (TAT, rejection rates, critical value compliance); - **Patient-level insights** (delta checks, trends, alerts); - **Population health**: laboratory data + EHR integration for cohort identification, surveillance, research; - **Clinical decision support** integration; (7) **Cybersecurity + privacy**: - **HIPAA** (US) / **GDPR** (EU) / Thailand PDPA; - **Risk assessments**, security controls, access management, audit logs; - **Ransomware** increasing threat — backup, segmentation, incident response plans (multiple high-profile healthcare ransomware attacks 2020s); - **Phishing + employee training**; - **Vendor management** + supply chain risk; (8) **Disaster recovery + business continuity**: backups, downtime procedures (paper backup, manual processes), recovery testing; (9) **Cloud + AI integration**: increasing — careful with PHI; (10) **Workforce**: laboratory informaticists, pathology informatics fellowship — growing specialty; (11) **Quality + governance**: change management, validation, version control, downtime documentation

---

Lab informatics: LIS + interfaces + auto-verify + reflex testing. Standards: HL7 v2/FHIR, LOINC, SNOMED CT, ICD. Specialty: AP synoptic, molecular variant nomenclature, blood bank ISBT 128. EHR integration. Analytics + CDS. Cybersecurity (HIPAA/PDPA, ransomware). Disaster recovery + workforce.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'API Pathology Informatics; HIMSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab — informatics + laboratory information system (LIS) + HL7/FHIR + connectivity + reporting + EHR integration + cybersecurity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 20 ปี — pancytopenia + recurrent infections; BM biopsy hypocellular; flow cytometry: PNH (paroxysmal nocturnal hemoglobinuria) clone via CD55/CD59/FLAER analysis; การวินิจฉัยและการรักษา', '[{"label":"A","text":"AIHA"},{"label":"B","text":"Paroxysmal Nocturnal Hemoglobinuria (PNH)"},{"label":"C","text":"ITP"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paroxysmal Nocturnal Hemoglobinuria (PNH): (1) **Pathophysiology**: somatic **PIGA gene mutation** in hematopoietic stem cell → deficiency of glycosylphosphatidylinositol (GPI) anchor → loss of GPI-anchored proteins (CD55 + CD59 critical) on cell surface → susceptibility to complement-mediated intravascular hemolysis + thrombosis + bone marrow failure; (2) **Clinical**: chronic intravascular hemolysis (hemoglobinuria classically morning urine — accumulation overnight), abdominal pain crises, dysphagia, erectile dysfunction (NO scavenged by free Hb), fatigue, **thrombosis (atypical sites — hepatic = Budd-Chiari, splenic, mesenteric, cerebral)** — leading cause of mortality untreated, bone marrow failure (overlap with aplastic anemia + MDS); (3) **Diagnosis (flow cytometry — gold standard)**: - **FLAER** (fluorescent aerolysin — binds GPI anchor directly) — most sensitive; - **CD55 + CD59** on granulocytes + monocytes + erythrocytes; - **PNH clone size** quantified; - PNH RBCs categorized type I (normal CD55/CD59), II (partial deficiency), III (complete deficiency) — proportions matter for hemolysis severity; (4) **Types** (clinical phenotypes per ICCS): - **Classic** (hemolytic, large clone, normal marrow); - **PNH in setting of bone marrow failure** (aplastic anemia, MDS); - **Subclinical** (small clone, no hemolysis); (5) **Workup**: monitoring panel + LDH + retic + DAT (negative — distinguishes from AIHA — Coombs-negative hemolysis); abdominal Doppler for Budd-Chiari; (6) **Treatment**: - **Pre-eculizumab era**: supportive (transfusion + iron + folate), anticoagulation, allo-HCT for advanced; - **Eculizumab (anti-C5 monoclonal — terminal complement inhibitor)** — landmark — markedly reduced thrombosis + improved survival to near-normal; needs meningococcal + Hib + pneumococcal vaccinations + sometimes antibiotic prophylaxis (Neisseria); - **Ravulizumab** (long-acting anti-C5, q8wk); - **Pegcetacoplan (anti-C3)** — addresses extravascular hemolysis residual on C5 inhibition (PEGASUS); - **Iptacopan (anti-factor B, oral)** — APPLY-PNH (2023) — oral monotherapy alternative; **danicopan (anti-factor D, oral)** add-on to C5 inhibitor — addresses extravascular hemolysis (ALPHA); - **Allo-HCT** considered for severe bone marrow failure or specific resistant patients; (7) **Monitoring**: LDH + clone size + hemoglobin + symptoms; (8) **Multidisciplinary**: hematology + heme-onc + transplant + obstetrics for pregnancy (high VTE) + ID + pharmacy; (9) **Pregnancy** high-risk + needs careful management with complement inhibition

---

PNH: PIGA mutation → GPI anchor loss → CD55/CD59 deficiency → complement-mediated hemolysis + thrombosis. Flow with FLAER + CD55/CD59 diagnostic. Complement inhibitors: eculizumab, ravulizumab (anti-C5), pegcetacoplan (anti-C3), iptacopan (anti-fB oral), danicopan (anti-fD). Meningococcal vaccine req. Multidisciplinary; pregnancy high-risk.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'Brodsky NEJM PNH; ICCS PNH; APPLY-PNH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 20 ปี — pancytopenia + recurrent infections; BM biopsy hypocellular; flow cytometry: PNH (paroxysmal nocturnal hemoglobinuria) clone via CD55/CD59/FLAER analysis; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — recurrent miscarriages + DVT; coagulation workup: prolonged aPTT not corrected on mixing study → lupus anticoagulant positive; anti-cardiolipin IgG/IgM high titer; anti-β2 glycoprotein I positive; criteria + management', '[{"label":"A","text":"Hemophilia"},{"label":"B","text":"Antiphospholipid Syndrome (APS)"},{"label":"C","text":"vWD"},{"label":"D","text":"Refuse"},{"label":"E","text":"DIC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antiphospholipid Syndrome (APS): (1) **Definition (Sapporo + Sydney + 2023 ACR/EULAR criteria revised)**: clinical + lab criteria: - **Clinical**: vascular thrombosis (arterial, venous, microvascular) OR pregnancy morbidity (≥ 3 unexplained consecutive miscarriages < 10 wk, ≥ 1 unexplained fetal death ≥ 10 wk, ≥ 1 preterm < 34 wk due to severe preeclampsia/eclampsia/placental insufficiency); - **Lab** (≥ 1 positive on ≥ 2 occasions ≥ 12 wk apart): - **Lupus anticoagulant (LA)** — paradoxical name, prolongs phospholipid-dependent clotting tests in vitro but causes thrombosis in vivo; - **Anti-cardiolipin antibodies (aCL)** IgG and/or IgM medium-high titer; - **Anti-β2 glycoprotein I (aβ2GPI)** IgG and/or IgM > 99th percentile; (2) **Triple positivity** (LA + aCL + aβ2GPI) = highest risk; (3) **Primary APS** (idiopathic) vs **Secondary** (lupus, other autoimmune); (4) **Lupus anticoagulant testing — 3 steps**: prolonged screening test (aPTT-LA, dilute Russell viper venom time DRVVT) → mixing study (doesn''t correct — inhibitor) → confirm phospholipid dependence (adding excess phospholipid normalizes — confirms LA); (5) **Treatment**: - **Anticoagulation indefinite** for arterial or venous thrombosis: **warfarin INR 2-3** (target); high-risk (triple positive, arterial) — INR 3-4 considered; - **DOACs CONTRAINDICATED in triple-positive APS** (TRAPS, RAPS trials — increased recurrent thrombotic events with rivaroxaban vs warfarin); - **DOACs may be acceptable** in selected venous-only single positivity; - **Aspirin** for primary prevention in high-risk asymptomatic carriers (low evidence); - **Pregnancy management**: **low-dose aspirin + LMWH** prophylactic dose throughout pregnancy + 6 wk postpartum (full anticoagulant dose if prior VTE/arterial); reduces miscarriage substantially; warfarin teratogenic — avoid 1st trimester; (6) **Catastrophic APS (CAPS)** — rare, severe: multiorgan thrombosis < 1 week + lab criteria + histology of small-vessel thrombosis; high mortality; treatment — anticoagulation + corticosteroids + plasma exchange + IVIG ± rituximab/eculizumab; (7) **Other manifestations**: thrombocytopenia, hemolytic anemia, livedo reticularis, valvular disease (Libman-Sacks), CNS (cognitive, headache, stroke), renal (small-vessel nephropathy); (8) **Hydroxychloroquine** in lupus-associated APS — reduces thrombotic risk + pregnancy outcomes; (9) **Multidisciplinary**: hematology + rheumatology + maternal-fetal medicine + neurology + cardiology + obstetrics

---

APS: clinical (thrombosis/preg morbidity) + lab (LA, aCL, aβ2GPI on 2 occasions ≥12 wk apart). Triple positivity highest risk. LA 3-step testing (screen → mix → confirm). Warfarin INR 2-3 (not DOACs for triple+ — TRAPS). Pregnancy: ASA + LMWH. CAPS multiorgan severe. HCQ in lupus.', NULL,
  'hard', 'coagulation', 'review',
  'pathology', 'clinical_decision', 'coagulation', 'adult',
  '2023 ACR/EULAR APS; TRAPS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — recurrent miscarriages + DVT; coagulation workup: prolonged aPTT not corrected on mixing study → lupus anticoagulant positive; anti-cardiolipin IgG/IgM high titer; anti-β2 glycoprotein I positive; criteria + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of MSI (microsatellite instability) + MMR IHC testing for solid tumors — methodology + interpretation + clinical applications + Lynch syndrome', '[{"label":"A","text":"Skip"},{"label":"B","text":"MSI/MMR Testing"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Same as PD-L1"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MSI/MMR Testing: (1) **Mismatch repair (MMR) system**: corrects DNA replication errors (mismatched bases, small insertion-deletion loops); 4 proteins: **MLH1, MSH2, MSH6, PMS2**; function as heterodimers (MLH1-PMS2 + MSH2-MSH6); (2) **Deficient MMR (dMMR)** → accumulation of mutations especially at microsatellites (short tandem repeats) → microsatellite instability (MSI-H) → hypermutated tumors → high neoantigen load → immunotherapy responsive; (3) **Two testing approaches** (complementary, high concordance): - **MMR IHC** — 4 antibodies (MLH1, MSH2, MSH6, PMS2) on FFPE tumor; loss of nuclear staining = deficient; uses internal controls (normal cells); - **MSI PCR** — Bethesda or pentaplex panel (BAT-25, BAT-26, NR-21, NR-24, MONO-27) — compare tumor + normal; MSI-H if ≥ 30% (2/5 or more) unstable; MSI-L (intermediate) + MSS (stable); - **NGS-based MSI** — increasingly used (e.g., MSIsensor algorithm); (4) **IHC interpretation**: - **Loss patterns** (paired heterodimers): - **MLH1 + PMS2 loss** — either sporadic (MLH1 hypermethylation + often BRAF V600E in CRC) or Lynch (MLH1 germline mutation); reflex testing — **BRAF V600E + MLH1 hypermethylation** in CRC; if BRAF V600E or methylation positive → sporadic; if negative → germline testing (Lynch); endometrial — methylation only (BRAF not validated for EC); - **MSH2 + MSH6 loss** — Lynch syndrome (MSH2 or EPCAM mutation) — germline testing; - **MSH6 isolated loss** — Lynch (MSH6 mutation) — germline testing; - **PMS2 isolated loss** — PMS2 mutation (Lynch) or MLH1 hypomorph — germline testing; - **All proteins retained** = MMR proficient (likely MSS); (5) **Clinical applications**: - **Universal screening for Lynch syndrome** — CRC + EC (and increasingly gastric, urothelial, others by site or panel); - **Predictive biomarker for immunotherapy** — **pembrolizumab + dostarlimab** FDA-approved tumor-agnostic for dMMR/MSI-H; nivolumab + ipilimumab for CRC dMMR; pembro + dostarlimab adjuvant in some settings; **NEOADJUVANT pembro in CRC dMMR can achieve clinical complete response avoiding surgery (NICHE study)**; - **Prognostic** in CRC stage II — better prognosis, less benefit from 5-FU monotherapy; - **Pathology in Lynch**: tumor-infiltrating lymphocytes prominent, Crohn-like reaction, mucinous/medullary patterns; (6) **Lynch syndrome**: autosomal dominant; CRC + EC + ovarian + gastric + urothelial + biliary + small bowel + skin (Muir-Torre) + brain (Turcot); surveillance protocols + risk-reducing surgery + chemoprevention (aspirin CAPP2); cascade family testing; (7) **TMB-high** related — broader hypermutated phenotype — pembro tumor-agnostic at ≥ 10 mut/Mb (KEYNOTE-158)

---

MSI/MMR: MMR IHC (4 proteins, paired loss patterns) + MSI PCR (Bethesda/pentaplex). MLH1 loss → reflex BRAF/methylation (CRC). Other losses → germline testing. dMMR/MSI-H predicts IO response (pembro tumor-agnostic, NICHE neoadjuvant CRC). Lynch screening universal CRC+EC. TMB-high related.', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'CAP/ASCO/NCCN MMR/MSI; KEYNOTE-177; NICHE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of MSI (microsatellite instability) + MMR IHC testing for solid tumors — methodology + interpretation + clinical applications + Lynch syndrome'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pathologist — Q1: PD-L1 testing in cancers — companion diagnostic assays + tumor proportion score (TPS) + combined positive score (CPS) + immune cell (IC) score + interpretation pitfalls', '[{"label":"A","text":"Skip"},{"label":"B","text":"PD-L1 Testing"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Same as HER2"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PD-L1 Testing: (1) **Background**: PD-L1 (programmed death-ligand 1) on tumor + immune cells binds PD-1 on T-cells → immune evasion; checkpoint inhibitors (anti-PD-1/L1) restore anti-tumor immunity; (2) **PD-L1 IHC**: surface expression on viable tumor cells + tumor-associated immune cells (lymphocytes + macrophages); fixation + tissue handling impact; (3) **Scoring systems** (vary by indication + drug + assay — complex landscape): - **Tumor Proportion Score (TPS)** — % of viable tumor cells with PD-L1 membrane staining (any intensity); used for NSCLC pembrolizumab (TPS ≥ 1% or ≥ 50%); - **Combined Positive Score (CPS)** — (# PD-L1+ cells [tumor + lymphocytes + macrophages]) / total viable tumor cells × 100, capped at 100; used for gastric, esophageal, cervical, head/neck, urothelial, TNBC; e.g., gastric pembro CPS ≥ 1, cervical ≥ 1, H&N ≥ 1; - **Immune Cell (IC) score** — % of tumor area occupied by PD-L1+ immune cells; used for urothelial atezolizumab (IC ≥ 5%), TNBC atezolizumab historically (now superseded); - **Tumor Cell (TC) score** — % tumor cells; - **TIIC** (tumor-infiltrating immune cell) variants; (4) **Companion vs complementary diagnostics — multiple assays + clones**: - **22C3 pharmDx (Agilent)** — pembrolizumab — NSCLC TPS, gastric CPS, cervical, esophageal, TNBC, urothelial, H&N; - **28-8 pharmDx** — nivolumab — NSCLC, melanoma; - **SP142 (Ventana)** — atezolizumab — TNBC, urothelial; - **SP263 (Ventana)** — durvalumab — NSCLC; - **Inter-assay variability significant — SP142 stains less tumor cells than 22C3/28-8/SP263**; harmonization studies (Blueprint) — partial concordance; some interchangeability defined; (5) **Pre-analytical**: fixation 10% NBF 6-72 h; decalcification with EDTA preferred; tissue age (older paraffin blocks > 5 yr may lose signal); specific assay validation required; (6) **Interpretation pitfalls**: - Necrosis + crush artifact excluded from scoring; - Background macrophages may obscure; - Heterogeneity within tumor (multiple sections may help); - Cytoplasmic vs membranous staining (only membranous counts); - Internal positive controls (placenta, tonsil) for assay validation; - Inter-observer variability (training + standardization); (7) **Limitations**: - Predictive accuracy modest in some indications; - Some PD-L1-low tumors respond, PD-L1-high don''t; - Other biomarkers — TMB, MSI, gene signatures, T-cell infiltration, HRD — supplementary; (8) **Quality**: CAP guidelines for PD-L1 testing — validate each indication + assay + scoring; participate in proficiency testing

---

PD-L1 IHC: TPS (tumor membrane %; NSCLC pembro), CPS (tumor+immune/tumor cells; gastric/H&N/cervical/urothelial/TNBC pembro), IC (immune area %; urothelial atezo). Assay-drug pairs (22C3/28-8/SP142/SP263). SP142 stains less. Pre-analytics + heterogeneity + interpretation pitfalls. CAP PD-L1 guidelines.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'CAP PD-L1; Blueprint Harmonization', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Pathologist — Q1: PD-L1 testing in cancers — companion diagnostic assays + tumor proportion score (TPS) + combined positive score (CPS) + immune cell (IC) score + interpretation pitfalls'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pathology + LMIC integrative — pathology services in resource-limited setting — WHO Essential List + capacity building + telepathology + sustainability + workforce', '[{"label":"A","text":"Random"},{"label":"B","text":"Pathology in LMIC + Resource-Limited Settings"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pathology in LMIC + Resource-Limited Settings: (1) **Critical gap**: 80% of cancer mortality in LMIC but pathology + lab infrastructure underdeveloped — many countries < 1 pathologist per million population (vs > 50/million in HIC); accurate diagnosis essential for cancer + ID + maternal-child health; (2) **WHO Essential Diagnostics List (EDL)** (first published 2018, updated): - Lists priority tests for tier of facility (primary care, district, referral); - Includes pathology basics — H&E, basic IHC panels, blood smear, microbiology; - Goal: universal access to essential diagnostics like Essential Medicines List; (3) **Common challenges**: - **Workforce shortage** — pathologists, technologists, cytotechnologists; - **Infrastructure** — reliable electricity, water, reagents, equipment; - **Supply chain** — reagent + consumable disruptions, customs delays; - **Cold chain** + quality preservation; - **Training pipelines** — fewer training programs locally; - **Quality assurance** — limited PT availability + accreditation; - **Information systems** — paper-based common, limited LIS; - **Sustainable financing**; (4) **Sustainable approaches**: - **Tiered laboratory network**: primary (basic), district (intermediate), national/referral (specialized) — coordinated; - **Specimen referral systems**: efficient transport to higher-tier with results returned; - **Telepathology** — WSI for remote consultation — high-income partner institutions providing subspecialty interpretation; smartphone-based microscopy emerging; - **Capacity building**: in-country pathology training programs, fellowship exchanges, mentorship (e.g., ASCP Partnership, COG, Lancet Pathology Commission, IAP, USCAP); - **South-South collaboration**: regional referral centers, mentorship; - **Task-shifting**: appropriately trained technicians for screening (cervical cancer pathology, basic microbiology); - **Mobile labs** + point-of-care testing for outreach + emergencies (Ebola, COVID demonstrated portable + decentralized capacity); (5) **Specific examples**: - **Cervical cancer screening + HPV testing** — WHO 90/70/90 elimination strategy — pathology + cytology + HPV testing scale-up; - **TB Xpert MTB/RIF** — rapid + actionable; - **HIV viral load** — universal access; - **Sickle cell newborn screening** in Africa; (6) **Equity considerations**: - Affordability + sustainable supply; - Avoiding reverse dumping (obsolete equipment); - Local capacity building > vertical donor-driven projects; - Open-source + frugal innovation; (7) **Digital + AI potential**: - Lower-cost smartphone-based scanners; - AI for preliminary review where pathologists scarce (validation in local populations essential); - Cloud-based LIS; (8) **International partnerships + research**: - Lancet Commission on Pathology + Laboratory Medicine 2018 — landmark; - WHO Resolution on Lab Strengthening; - Global Fund + GAVI + PEPFAR lab investments; (9) **Sustainability principles**: local ownership, system-strengthening, training-of-trainers, monitoring + evaluation; (10) **Health equity** central — diagnostic access is precondition for treatment access

---

LMIC pathology: WHO EDL + tiered network + telepathology + capacity building + task-shifting + mobile labs. Challenges: workforce/infrastructure/supplies/QA/financing. Examples: cervical screening, TB Xpert, HIV VL, sickle cell screening. Lancet Commission. Sustainability + local ownership + equity.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'integrative', 'quality_safety', 'mixed',
  'WHO EDL; Lancet Pathology Commission 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Pathology + LMIC integrative — pathology services in resource-limited setting — WHO Essential List + capacity building + telepathology + sustainability + workforce'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 7 ปี — orbital mass + biopsy: small round blue cells + cytoplasmic cross-striations on PTAH; IHC: desmin+, myogenin+ (diffuse nuclear strong), MyoD1+; molecular: PAX3-FOXO1 fusion positive', '[{"label":"A","text":"Neuroblastoma"},{"label":"B","text":"Rhabdomyosarcoma (Alveolar — ARMS)"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rhabdomyosarcoma (Alveolar — ARMS): (1) **Most common pediatric soft tissue sarcoma**; (2) **Subtypes** (WHO 2020): - **Embryonal (ERMS) ~ 60-70%** — most common; head/neck (orbit, parameningeal), GU (botryoid in vagina/bladder); spindle/round cells in myxoid stroma; spindle cell + sclerosing subtypes (intermediate prognosis); + favorable in children; molecularly: loss of heterozygosity 11p15, frequent TP53 + RAS pathway; - **Alveolar (ARMS) ~ 20-30%** — aggressive; extremities; alveolar architecture with discohesive cells in spaces; - **Pleomorphic** — adults, rare; - **Spindle cell/sclerosing**; - **MYOD1-mutant spindle cell/sclerosing** — recently recognized — aggressive (LR — like adult); (3) **Histology + IHC**: - Small round blue cells (ERMS may have rhabdomyoblasts with strap cells); - **Desmin+, myogenin (MYF4)+, MyoD1+** — myogenic markers (myogenin nuclear strong+diffuse in ARMS vs focal/patchy in ERMS); - Cytokeratin negative; - PAX3+ + MYC+; (4) **Molecular** (essential — defines + treats): - **ARMS — translocations**: - **PAX3-FOXO1 t(2;13)** (~ 70% ARMS) — aggressive; - **PAX7-FOXO1 t(1;13)** (~ 20% ARMS) — slightly better prognosis; - **Fusion-positive ARMS prognosis worse than fusion-negative**; - **ERMS — fusion-negative**; loss of heterozygosity 11p15, TP53, RAS, MYCN; - **Fusion-negative behaves like ERMS regardless of histology — risk stratification by fusion**; (5) **Staging (TNM + IRS clinical grouping)**: site, size, nodal, metastatic; (6) **Risk stratification (COG)**: low-, intermediate-, high-risk by fusion status, site, stage, IRS group, age; (7) **Treatment**: - **Multimodal — chemo + surgery + RT**; - **VAC (vincristine + actinomycin D + cyclophosphamide)** backbone; ifosfamide + etoposide added higher risk; - **Local control**: surgery if not mutilating; RT for residual + parameningeal + alveolar; - **Targeted therapy emerging**: trials with PAX3-FOXO1-related (HDAC inhibitors, MYC inhibitors); IGF-1R inhibitors limited; (8) **Outcomes**: > 70% cure pediatric low-/intermediate-risk; metastatic ARMS PAX3-FOXO1+ < 30%; (9) **Multidisciplinary**: pediatric onc + surgery + RT + pathology + radiology + survivorship

---

Rhabdomyosarcoma: small round blue cells + myogenic (desmin/myogenin/MyoD1+). Subtypes — ARMS (PAX3/7-FOXO1 fusion — aggressive), ERMS (fusion-negative — better), pleomorphic, spindle/sclerosing/MYOD1. Risk strat: fusion status critical. Multimodal VAC + surg + RT.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'WHO Soft Tissue + Bone 5th ed; COG Rhabdomyosarcoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 7 ปี — orbital mass + biopsy: small round blue cells + cytoplasmic cross-striations on PTAH; IHC: desmin+, myogenin+ (diffuse nuclear strong), MyoD1+; molecular: PAX3-FOXO1 fusion positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี HIV+ — multiple skin lesions purple-red + lymphadenopathy + visceral involvement; biopsy: spindle cell proliferation + slit-like vascular spaces + hemosiderin; IHC: CD31+, CD34+, ERG+, HHV-8 (LANA)+', '[{"label":"A","text":"Angiosarcoma"},{"label":"B","text":"Kaposi Sarcoma (KS)"},{"label":"C","text":"Melanoma"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Kaposi Sarcoma (KS): (1) **Etiology**: **Human Herpesvirus 8 (HHV-8) / Kaposi Sarcoma-associated Herpesvirus (KSHV)** — gamma-herpesvirus — infection essential; lytic + latent gene programs drive proliferation; (2) **Epidemiology + variants (different presentations + behavior)**: - **Classic** — older Mediterranean/Eastern European men, indolent skin disease; - **African endemic** — pre-AIDS, sub-Saharan Africa; - **AIDS-associated** — HIV+, aggressive, mucocutaneous + visceral (GI, lung — high mortality); pre-ART common opportunistic; - **Iatrogenic** — transplant + immunosuppressed; (3) **Histology** stages: - **Patch stage**: subtle proliferation of vascular slit-like spaces between collagen, sparse spindle cells, RBC extravasation, hemosiderin; - **Plaque stage**: more extensive vascular proliferation, prominent spindle cells; - **Nodular**: dense spindle cells in fascicles, slit-like vascular spaces, hemosiderin, hyaline globules; (4) **IHC**: - Endothelial: **CD31+, CD34+, D2-40+, ERG+, FLI1+** (vascular/lymphatic origin); - **HHV-8 (LANA) IHC** — diagnostic — nuclear punctate; - Vimentin+, factor VIII+; (5) **HHV-8 also causes** (relevant differential): - **Primary effusion lymphoma (PEL)**; - **Multicentric Castleman Disease (MCD)** + KSHV-MCD; - **KSHV inflammatory cytokine syndrome (KICS)**; (6) **Treatment**: - **AIDS-KS**: - **ART (antiretroviral therapy)** — backbone — immune reconstitution often regresses; - **Local lesions**: cryotherapy, radiation, intralesional chemo (vinblastine), topical alitretinoin; - **Systemic disease**: liposomal doxorubicin (PLD) + ART; paclitaxel second-line; - **Pomalidomide** approved 2020 — both HIV+ + HIV-negative; lenalidomide; - **IRIS** (immune reconstitution inflammatory syndrome) — KS flare with ART start — manage with continuation of ART + chemo; - **Classic KS**: observation indolent; local treatment + chemo if progressive; - **Endemic**: chemo + supportive; (7) **Concurrent HHV-8 diseases** look for if any one diagnosed (PEL, MCD); (8) **Prevention**: ART + HIV prevention; awareness — sexual transmission of HHV-8 documented MSM; (9) **Multidisciplinary**: ID + dermatology + oncology + radiation onc + path; (10) **Public health implications** — ART access in resource-limited settings

---

Kaposi sarcoma: HHV-8/KSHV-driven; spindle cells + slit-like vessels + hemosiderin. CD31/34/ERG+/D2-40+ vascular + LANA (HHV-8)+ diagnostic. Variants: classic/endemic/AIDS/iatrogenic. ART backbone AIDS-KS; PLD systemic; pomalidomide new. IRIS flare possible. Other HHV-8 diseases (PEL, MCD) considered.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Skin + Hematolymphoid Tumors; NCI KS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี HIV+ — multiple skin lesions purple-red + lymphadenopathy + visceral involvement; biopsy: spindle cell proliferation + slit-like vascular spaces + hemosiderin; IHC: CD31+, CD34+, ERG+, HHV-8 (LANA)+'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-kidney transplant 8 มา + EBV+ — diffuse adenopathy + B symptoms; biopsy: polymorphous lymphoid proliferation + scattered Reed-Sternberg-like cells + EBV-encoded RNA ISH positive; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Lymphoma de novo"},{"label":"B","text":"Post-Transplant Lymphoproliferative Disorders (PTLD)"},{"label":"C","text":"TB"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Transplant Lymphoproliferative Disorders (PTLD): (1) **Spectrum (WHO HAEM5)**: - **Non-destructive PTLD**: plasmacytic hyperplasia, infectious mononucleosis-like, florid follicular hyperplasia; - **Polymorphic PTLD**: heterogeneous polymorphous lymphoid; - **Monomorphic PTLD**: most common — usually DLBCL-like (~ 80% B-cell origin), T-cell (rarer), Burkitt-like, plasmablastic, plasma cell myeloma; - **Classical Hodgkin-like PTLD**; (2) **EBV association**: - **Early PTLD (< 1 yr post-transplant)** ~ 70-90% EBV-positive — driven by immunosuppression + EBV reactivation/primary infection; - **Late PTLD (> 1 yr)** — variable EBV — closer to sporadic lymphoma biology; (3) **Risk factors**: heavy/specific immunosuppression (ATG, alemtuzumab, calcineurin inhibitors), EBV-mismatched donor/recipient (D+/R- highest), pediatric (more often EBV-naive at transplant), allograft type (intestinal + cardiothoracic higher risk vs renal); (4) **Workup**: - **EBV viral load** (whole blood or plasma PCR) — surveillance + diagnostic; - **Tissue biopsy** essential — morphology + IHC + EBER ISH; - **Imaging staging** PET-CT; - **CSF + BM** as indicated; - HHV-8 (PEL variant); (5) **Histology**: spectrum from polyclonal hyperplasia → monoclonal lymphoma; clonality (Ig gene rearrangement); EBER (EBV-encoded RNA) ISH positive most; (6) **Treatment** (stepwise): - **Reduce immunosuppression (RIS)** — first step — works in many early polyclonal/EBV-driven PTLD; risk of allograft rejection — balance; - **Rituximab monotherapy** for CD20+ B-cell PTLD — often combined with RIS; - **Rituximab + chemotherapy** (R-CHOP) for high-risk or chemo-required PTLD (PTLD-1 risk-stratified trial); - **EBV-specific cytotoxic T-lymphocytes (EBV-CTL — Tabelecleucel)** — for EBV+ PTLD refractory; - **Surgery + RT** for localized; - **Allograft tolerance** issues — coordination with transplant team essential; (7) **Monitoring + surveillance**: EBV PCR in high-risk patients; pre-emptive reduction of immunosuppression if rising VL; (8) **Prevention**: - EBV-naive recipients — surveillance; - Pre-emptive antiviral (gancicovir/valganciclovir) — limited evidence; - Vaccines under development; (9) **Multidisciplinary**: transplant + ID + hematology + pathology + radiology; (10) **Outcomes**: 5-yr OS 50-80% modern era; better with risk-adapted Tx

---

PTLD: post-transplant, often EBV+ early. Spectrum: non-destructive → polymorphic → monomorphic (DLBCL-like) → Hodgkin-like. EBER ISH + EBV viral load. Stepwise: RIS → rituximab → R-CHOP → EBV-CTL (tabelecleucel). PTLD-1 risk-stratified. Multidisciplinary; balance rejection.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'mixed',
  'WHO HAEM5 2022; PTLD-1; AST', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย post-kidney transplant 8 มา + EBV+ — diffuse adenopathy + B symptoms; biopsy: polymorphous lymphoid proliferation + scattered Reed-Sternberg-like cells + EBV-encoded RNA ISH positive; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — patchy erythematous skin lesions + plaques; biopsy: atypical lymphoid infiltrate in epidermis (epidermotropism) + Pautrier microabscesses + cerebriform nuclei; IHC: CD3+, CD4+, CD8-, CD7 loss, CD30 scattered+; การวินิจฉัย', '[{"label":"A","text":"Eczema"},{"label":"B","text":"Mycosis Fungoides (MF) — Cutaneous T-Cell Lymphoma"},{"label":"C","text":"Psoriasis"},{"label":"D","text":"Refuse"},{"label":"E","text":"DLBCL"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mycosis Fungoides (MF) — Cutaneous T-Cell Lymphoma: (1) **Most common cutaneous T-cell lymphoma (CTCL)**; chronic indolent progressive; (2) **Clinical stages**: - **Patch** — pink, scaly, can mimic eczema/psoriasis for years; - **Plaque** — thicker, infiltrated; - **Tumor** — nodular; - **Erythroderma** + **Sézary syndrome** (leukemic phase — > 1000 Sézary cells/μL with characteristic phenotype); (3) **Histology**: - Atypical lymphoid infiltrate in upper dermis + epidermotropism (single cells + small clusters in epidermis); - **Pautrier microabscesses** (collections of atypical lymphocytes in epidermis) — characteristic; - **Cerebriform (Sézary) nuclei** — convoluted; - Variable disruption of basement membrane; - Tumor stage — dense dermal infiltrate, less epidermotropism; (4) **IHC**: - **CD3+, CD4+, CD8-, CD45RO+** (memory T-helper); - **Aberrant loss of pan-T markers** — CD2, CD3, CD5, **CD7 (most common loss)** — supports neoplastic; - CD30+ subset (predicts brentuximab response); - CD25 in Sézary; - **TCR clonality** by PCR essential for diagnosis (detect monoclonal rearrangement); (5) **Variants** (WHO HAEM5): - Folliculotropic MF (worse prognosis); - Pagetoid reticulosis (localized indolent); - Granulomatous slack skin; - **Sézary syndrome** — leukemic CTCL; - **Primary cutaneous CD30+ LPDs** — lymphomatoid papulosis (LyP — clinically benign waxing/waning, CD30+ ALCL-like cells), primary cutaneous anaplastic large cell lymphoma (pcALCL); - **Subcutaneous panniculitis-like T-cell lymphoma (SPTCL)** — αβ-type; - Aggressive variants: primary cutaneous γδ TCL, primary cutaneous CD8+ aggressive epidermotropic; (6) **Staging (TNMB)**: skin (T1-4) + nodes (N) + visceral (M) + blood (B0-B2); (7) **Treatment by stage** (NCCN/EORTC): - **Early stage (IA-IIA)**: skin-directed — topical steroids, mechlorethamine, retinoids, **PUVA, narrowband UVB**, electron beam radiation (TSEBT); - **Advanced (IIB-IV) / Sézary**: systemic — bexarotene, IFN-α, methotrexate, romidepsin/vorinostat (HDAC inhibitors), **brentuximab vedotin** (CD30+ ALCANZA), **mogamulizumab** (anti-CCR4 — MAVORIC trial — Sézary), denileukin diftitox (E7777), pralatrexate, gemcitabine, single-agent chemo; - **Refractory**: allo-HCT for Sézary/advanced — only potentially curative; - **Lymphomatoid papulosis**: observation or methotrexate; (8) **Multidisciplinary**: dermatology + dermatopathology + hematology/oncology + RT; quality of life focus (chronic disease)

---

Mycosis fungoides: CTCL; epidermotropism + Pautrier microabscesses + cerebriform nuclei. CD3/4+/CD7 loss; TCR clonality. Stages: patch/plaque/tumor/erythroderma/Sézary. Skin-directed (topical, PUVA, TSEBT) early; systemic (bex, IFN, HDAC, brentuximab CD30+, mogamulizumab) advanced. Allo-HCT curative.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; NCCN PCTCL; MAVORIC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — patchy erythematous skin lesions + plaques; biopsy: atypical lymphoid infiltrate in epidermis (epidermotropism) + Pautrier microabscesses + cerebriform nuclei; IHC: CD3+, CD4+, CD8-, CD7 loss, CD30 scattered+; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — proximal limb pain + giant tumor near knee; X-ray: lytic + ''soap bubble'' lesion + epiphyseal; biopsy: multinucleated osteoclast-like giant cells + mononuclear stromal cells; IHC: **H3.3 G34W (G34 mutation specific)**+', '[{"label":"A","text":"Osteosarcoma"},{"label":"B","text":"Giant Cell Tumor of Bone (GCT)"},{"label":"C","text":"Ewing"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant Cell Tumor of Bone (GCT): (1) **Epidemiology**: skeletally mature young adults (20-40 yr); epiphyseal-metaphyseal location (distal femur > proximal tibia > distal radius > sacrum > spine); locally aggressive but rarely metastatic; (2) **Histology**: - **Sheets of evenly distributed osteoclast-like multinucleated giant cells** with similar nuclei to background mononuclear cells (key diagnostic feature); - **Mononuclear stromal cells** — the neoplastic cells (oval-spindled); - Lacks atypia, necrosis, atypical mitoses (concerning for malignant); - **Vascular fibrous stroma**, ABC (aneurysmal bone cyst)-like changes can occur; (3) **Molecular** (revolutionary 2013): - **H3F3A (H3.3) G34W mutation** in stromal cells — pathognomonic for conventional GCT of bone (~ 95%) — distinguishes from mimics; - **IHC with H3.3 G34W antibody** highly specific + diagnostic; - Distinct from H3 K27M (diffuse midline glioma), H3 K36M (chondroblastoma); (4) **Differential** of giant-cell-rich lesions: - **Brown tumor of hyperparathyroidism** (PTH ↑, multiple lesions); - **Aneurysmal bone cyst (ABC)** — blood-filled cavities; USP6 rearrangement; - **Giant cell granuloma of jaw** (peripheral + central); - **Non-ossifying fibroma**; - **Chondroblastoma** (epiphyseal in skeletally immature, chicken-wire calcifications, H3 K36M+); - **Giant cell-rich osteosarcoma** (atypia, more mitoses, neoplastic osteoid); - **Malignant GCT** (rare — undifferentiated sarcoma in GCT background, secondary to RT); (5) **Imaging**: lytic, eccentric, expansile, geographic margin, no matrix; (6) **Treatment**: - **Surgery**: extended curettage + adjuvant (phenol, polymethyl methacrylate, cryotherapy) + bone grafting/cement — preferred; - **En bloc resection** for advanced — sacrum/spine; - **Denosumab (anti-RANKL)** — landmark medical therapy — for unresectable/recurrent/metastatic; reduces tumor; **caution — risk of malignant transformation reported** with prolonged use + risk of recurrence at discontinuation; - **Bisphosphonates** considered; - **RT** for unresectable — but risk of malignant transformation in GCT; (7) **Recurrence**: ~ 15-50% post-curettage; surveillance; (8) **Metastatic GCT** (rare ~ 1-9%) — lung — usually responds to denosumab + resection; (9) **Multidisciplinary**: ortho onc + medical onc + RT + pathology + radiology; (10) **Surveillance** for recurrence + transformation

---

GCT of bone: epiphyseal, young adults; osteoclast-like giant cells + similar mononuclear stromal cells. H3.3 G34W mutation pathognomonic — IHC diagnostic. DDx giant-cell rich lesions distinct. Treatment: extended curettage + adjuvants; denosumab for unresectable (caution: malignant transformation reported).', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Soft Tissue + Bone 5th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — proximal limb pain + giant tumor near knee; X-ray: lytic + ''soap bubble'' lesion + epiphyseal; biopsy: multinucleated osteoclast-like giant cells + mononuclear stromal cells; IHC: **H3.3 G34W (G34 mutation specific)**+'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — multiple lymphadenopathy + B symptoms + multicentric Castleman disease + HHV-8+; biopsy: hyaline-vascular features + plasmablasts; การวินิจฉัยและการรักษา + spectrum', '[{"label":"A","text":"DLBCL"},{"label":"B","text":"Castleman Disease — Pathology + Spectrum"},{"label":"C","text":"TB"},{"label":"D","text":"Sarcoid"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Castleman Disease — Pathology + Spectrum: (1) **Classification**: - **Unicentric Castleman Disease (UCD)** — single lymph node region: - **Hyaline-vascular variant** (most common UCD) — abnormal follicles with onion-skin layers of mantle cells + atretic germinal centers traversed by penetrating sclerotic vessels (''lollipop''); commonly asymptomatic; - **Plasma cell variant** — sheets of plasma cells between hyperplastic follicles; often systemic; - **Mixed**; - **Multicentric Castleman Disease (MCD)** — multiple lymph node regions: - **HHV-8-positive MCD** — HIV-associated + non-HIV; plasmablastic features; LANA+ IHC; - **Idiopathic MCD (iMCD)** — HHV-8-negative; subtypes incl. **TAFRO syndrome** (Thrombocytopenia, Anasarca, Fever, Reticulin fibrosis, Organomegaly); (2) **Pathogenesis**: - HHV-8 produces viral IL-6 + lytic + latent gene products → cytokine storm — IL-6, IL-10, vIL-6 in HHV-8+ MCD; - iMCD — endogenous IL-6 + others — incomplete understanding; (3) **Clinical**: - UCD — often asymptomatic; sometimes systemic from cytokines; - MCD — B symptoms, hepatosplenomegaly, lymphadenopathy, edema/anasarca, ascites, organ dysfunction, vascular permeability; often severe + life-threatening; (4) **Workup**: - **Excisional biopsy** essential; - **HHV-8 (LANA) IHC**; - **HIV testing**; - **Inflammatory markers** (CRP, ESR, ferritin, IL-6); - **Imaging** (CT/PET); - **Rule out lymphoma, autoimmune, infection mimicking**; (5) **Diagnostic criteria iMCD (CDCN — Castleman Disease Collaborative Network)**: histopathology consistent + multicentric LAD + 2+ minor criteria (clinical/lab); exclude infectious, autoimmune, neoplastic; (6) **Treatment**: - **UCD**: surgical resection — curative; RT for unresectable; - **HHV-8+ MCD**: - **Rituximab** (CD20+ plasmablasts) — first-line; - **Antiviral** (ganciclovir/valganciclovir) — adjunct; - **HIV ART** if HIV+; - Chemotherapy (CHOP, EPOCH, liposomal doxorubicin) for severe; - **iMCD**: - **Siltuximab (anti-IL-6) — first-line approved** (NCCN, FDA — only drug specifically for iMCD); long-term benefit; - **Tocilizumab (anti-IL-6R)**; - Rituximab if siltuximab unavailable + selected; - **TAFRO**: aggressive — siltuximab + steroids + cyclosporine + others; (7) **Related entities**: POEMS syndrome (plasma cell disorder with neuropathy), KSHV inflammatory cytokine syndrome (KICS); (8) **Multidisciplinary**: hematology + ID + pathology + nephrology + supportive; (9) **Monitor**: clinical, biomarkers, imaging — long-term

---

Castleman: UCD (hyaline-vascular, plasma cell) vs MCD (HHV-8+ or iMCD incl TAFRO). HHV-8+ MCD — rituximab + antiviral + ART; iMCD — siltuximab (anti-IL-6) first-line. UCD — surgical resection curative. Cytokine storm pathogenesis. POEMS distinct. CDCN criteria.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; CDCN iMCD; NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — multiple lymphadenopathy + B symptoms + multicentric Castleman disease + HHV-8+; biopsy: hyaline-vascular features + plasmablasts; การวินิจฉัยและการรักษา + spectrum'
  );

commit;

