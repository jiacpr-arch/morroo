-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 8/10
-- Questions 141-160 of 200
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
  s.id, 'board', NULL, 'ทารกอายุ 8 mo BW 8.2 kg มีผื่นแห้งคัน เริ่มที่หน้า + แก้ม 4 mo + ลามไป arms + legs + flexure (popliteal + antecubital) + ดูเหลืองอ่อน scratch marks, ตื่นกลางคืนคันรบกวน sleep; ครอบครัว atopic — แม่ asthma + sister AR

PE: erythematous + scaly + lichenified plaques flexor surfaces, no infection (no honey-crusted, no fluctuance, no pustule)
No wheeze, growth normal; SCORAD moderate', '[{"label":"A","text":"Steroid systemic chronic"},{"label":"B","text":"Atopic Dermatitis (Eczema) moderate, classic atopic march: EDUCATION + family — chronic relapsing disease, manage rather than cure; SKIN HYDRATION — daily lukewarm bath 10-15 min + immediately apply moisturizer (fragrance-free emollient) within 3 min (soak + seal), thick ointment (petroleum-based) preferred over lotion; bath additive (mild non-soap cleanser like Cetaphil, mild oat); TOPICAL CORTICOSTEROID — first-line antiinflammatory — low-potency (hydrocortisone 1-2.5%) for face/groin, mid-potency (triamcinolone 0.1%) for body, intermittent use 1-2× daily × 7-14 d for flares; PROACTIVE therapy — twice weekly steroid (or tacrolimus) to high-risk areas during quiescent phase reduces flares; TOPICAL CALCINEURIN INHIBITOR — tacrolimus 0.03% (≥ 2 yr) or pimecrolimus 1% — steroid-sparing, safe for face + thin skin; identify + avoid triggers — heat, sweat, harsh detergent, fragrance, wool; treat super-infection — bacterial (Staph 80%) → mupirocin topical or oral cephalexin/clindamycin if widespread, viral eczema herpeticum → URGENT acyclovir + ophtho consult if periocular; ANTIHISTAMINE for pruritus mostly sedating for sleep (hydroxyzine, diphenhydramine HS); bleach bath 2-3×/wk for recurrent infection; new — TOPICAL crisaborole (PDE4 inhibitor), Ruxolitinib (JAK inhibitor topical) for older kids; BIOLOGIC — Dupilumab (anti-IL4Rα) ≥ 6 mo FDA-approved for moderate-severe; Tralokinumab, Lebrikizumab emerging; food allergy + asthma + rhinitis comorbid — allergist + atopic march counseling; psychosocial impact + sleep affected"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Avoid all bathing"},{"label":"E","text":"Discharge no education"}]'::jsonb,
  'B', 'AD = chronic relapsing, atopic march common. Skin hydration + emollient + topical steroid first-line. Tacrolimus alternative thin skin/face. Proactive maintenance for flares prevention. Bleach bath for recurrent infection. Dupilumab biologic moderate-severe ≥ 6 mo. Family-centered education.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAD Guidelines AD 2024; European Task Force on AD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกอายุ 8 mo BW 8.2 kg มีผื่นแห้งคัน เริ่มที่หน้า + แก้ม 4 mo + ลามไป arms + legs + flexure (popliteal + antecubital) + ดูเหลืองอ่อน scratch marks, ตื่นกลางคืนคันรบกวน sleep; ครอบครัว atopic — แม่ asthma + sister AR

PE: erythematous + scaly + lichenified plaques flexor surfaces, no infection (no honey-crusted, no fluctuance, no pustule)
No wheeze, growth normal; SCORAD moderate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 10 ปี ครอบครัว Hx swelling — แม่ + ลุง + พี่ มี attacks intermittent swelling face, hands, feet, abdomen WITHOUT urticaria — ลูกสาวมาตอนนี้ episode 3 — facial + lip swelling + abdominal pain colicky + อาเจียน + ปวดเริ่ม 6 ชม

V/S: HR 102, BP 102/68, no respiratory distress (no laryngeal edema currently), BW 32 kg
PE: significant lip + facial swelling, abdominal tender no peritonitis, no hives, no pruritus, no airway compromise yet

Lab: C4 LOW, C1-INH antigenic LOW, C1-INH functional LOW = HAE type 1
Tryptase normal (excludes mast cell)
Not responding to antihistamine + steroid (prior episodes)', '[{"label":"A","text":"Antihistamine + steroid alone"},{"label":"B","text":"Hereditary Angioedema (HAE) Acute Attack — C1-INH deficiency, NOT histamine-mediated (no urticaria, no response to standard anaphylaxis treatment): EMERGENCY targeted therapy — C1-INH concentrate (Berinert) IV 20 U/kg (most evidence + first-line acute), OR Ecallantide (kallikrein inhibitor) SC 30 mg in 3 sites, OR Icatibant (bradykinin B2 receptor antagonist) SC 30 mg single dose (self-administer at home) — all FDA-approved acute attacks pediatric; AVOID — antihistamine, steroid, epinephrine (less effective HAE, but EPI can still help if respiratory distress + uncertainty); fresh frozen plasma alternative if specific therapy unavailable (contains C1-INH, can paradoxically worsen by providing substrate); supportive — airway monitoring (LARYNGEAL EDEMA can be fatal — early intubation if signs progression), IV fluid for abdominal attacks (third-spacing), analgesia, antiemetic; admission for laryngeal attacks; PROPHYLAXIS — long-term (≥ 1-2 attacks/mo or severe) — Lanadelumab (anti-kallikrein mAb SC q2 wk, age ≥ 2), Berotralstat (oral kallikrein inhibitor, ≥ 12 yr), C1-INH SC (Haegarda) twice weekly, attenuated androgens (danazol — limited in children due growth/virilization side effects); short-term prophylaxis before procedures (dental, surgery, intubation) — C1-INH 20 U/kg or FFP; AVOID precipitants (estrogen, ACEI, trauma); on-demand therapy patients should have self-administered kit + emergency plan; allergist + immunologist follow-up; education family + medical alert + genetic counseling (autosomal dominant — screen relatives)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'HAE = bradykinin-mediated, NOT histamine. C1-INH deficiency (or function). Acute: C1-INH concentrate, icatibant, ecallantide. Standard anaphylaxis Rx ineffective. Laryngeal edema can be fatal. Long-term prophylaxis (lanadelumab, berotralstat). Genetic + family screen.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'WAO HAE Guidelines 2021; US HAEA Medical Advisory Board', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 10 ปี ครอบครัว Hx swelling — แม่ + ลุง + พี่ มี attacks intermittent swelling face, hands, feet, abdomen WITHOUT urticaria — ลูกสาวมาตอนนี้ episode 3 — facial + lip swelling + abdominal pain colicky + อาเจียน + ปวดเริ่ม 6 ชม

V/S: HR 102, BP 102/68, no respiratory distress (no laryngeal edema currently), BW 32 kg
PE: significant lip + facial swelling, abdominal tender no peritonitis, no hives, no pruritus, no airway compromise yet

Lab: C4 LOW, C1-INH antigenic LOW, C1-INH functional LOW = HAE type 1
Tryptase normal (excludes mast cell)
Not responding to antihistamine + steroid (prior episodes)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี เพิ่งกลับจาก camping ไป East Coast US 3 wk ก่อน บ้าน outdoor 4 wk ก่อนเจอ tick attached arm × หลายชั่วโมง — เพิ่งเห็น 2 wk ก่อนมี expanding circular target-like rash 12 cm diameter inner clearing ที่แขนเดิม + ไข้ต่ำ + ปวดข้อ + headache + arthralgia — ใจเต้น ไม่สม่ำเสมอ

V/S: HR irregular 65 (sinus brady) ECG → second-degree AV block Mobitz I, BW 26 kg
PE: erythema migrans target rash 12 cm right arm, mild knee effusion bilateral, no facial palsy currently

Lab: Lyme ELISA + Western blot — IgM + + IgG +; CBC normal', '[{"label":"A","text":"Antibiotic short course oral"},{"label":"B","text":"Early disseminated Lyme disease with cardiac involvement (AV block) + arthritis: hospital admission for cardiac monitoring (AV block — may need temporary pacing if symptomatic complete heart block); IV ceftriaxone 50-75 mg/kg/d (max 2 g/d) × 14-21 days for cardiac OR neuro involvement (vs oral for skin/arthritis only); alternative IV penicillin G or cefuroxime; FOR cutaneous + arthritis without cardiac/neuro — oral DOXYCYCLINE 4.4 mg/kg/d ÷ q12h × 10-14 d (now recommended ALL AGES per IDSA 2020 — historically reserved > 8 yr due tooth staining, recent evidence safe < 8 yr for short courses); amoxicillin 50 mg/kg/d alternative all ages; cefuroxime alt; treat ARTHRITIS (Lyme arthritis) — oral doxycycline × 28 d → if persistent → IV ceftriaxone OR oral course again; reassess + repeat ECG; cardiac complications usually resolve with antibiotic but may need temporary pacing; FACIAL PALSY common — oral antibiotic, resolves with time; education + tick prevention (DEET, permethrin, long sleeves, tick checks); vaccine in development (VLA15); reportable; counsel family — Post-Treatment Lyme Disease Syndrome (controversial — fatigue/cognitive symptoms persisting); not contagious person-person"},{"label":"C","text":"Wait — outgrow"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', 'Lyme disease = Borrelia burgdorferi via Ixodes tick (US Northeast/upper Midwest, parts of Europe). Stages: early local (EM), early disseminated (multiple EM, neurological — facial palsy, meningitis; cardiac — AV block), late (arthritis). Doxycycline all ages per IDSA 2020. IV ceftriaxone for cardiac/neuro. Tick prevention.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'IDSA Guideline Lyme Disease 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี เพิ่งกลับจาก camping ไป East Coast US 3 wk ก่อน บ้าน outdoor 4 wk ก่อนเจอ tick attached arm × หลายชั่วโมง — เพิ่งเห็น 2 wk ก่อนมี expanding circular target-like rash 12 cm diameter inner clearing ที่แขนเดิม + ไข้ต่ำ + ปวดข้อ + headache + arthralgia — ใจเต้น ไม่สม่ำเสมอ

V/S: HR irregular 65 (sinus brady) ECG → second-degree AV block Mobitz I, BW 26 kg
PE: erythema migrans target rash 12 cm right arm, mild knee effusion bilateral, no facial palsy currently

Lab: Lyme ELISA + Western blot — IgM + + IgG +; CBC normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี BW 28 kg อยู่ Bangkok ไข้สูง 4 วันก่อน + ปวดศีรษะ + ปวดเมื่อย + ปวดเบ้าตา + ผื่นแดง + เลือดออกตามไรฟัน + ตอนนี้วันที่ 5 ของไข้ ไข้ลดแล้วแต่กลับเหนื่อยมาก ปวดท้องรุนแรง + อาเจียน + extremities เย็น + capillary refill ช้า

V/S: HR 132, BP 96/82 (narrow PP 14 mmHg — SHOCK), RR 32, SpO2 96%, Temp 37.0°C (defervescence)
Gen: lethargic + restless, cold extremities, hepatomegaly 4 cm, petechiae multiple, no obvious bleeding

Lab: Hct 50 (rising from 38 — hemoconcentration), Plt 28,000, AST 320, ALT 280, albumin 2.8
NS1 antigen + + IgM +; tourniquet test positive
Dengue Severe (DSS — Dengue Shock Syndrome)', '[{"label":"A","text":"Steroid + antibiotic"},{"label":"B","text":"Severe Dengue with Dengue Shock Syndrome (critical phase, defervescence + plasma leak) — WHO 2009 criteria: ICU admission + cardiovascular monitoring; CRYSTALLOID resuscitation — Ringer''s lactate or NSS 10 mL/kg IV bolus over 10-15 min (more aggressive faster than usual peds shock — 20 mL/kg may worsen plasma leak); reassess after each bolus (HR, BP, PP, cap refill, Hct, UO); if not improved → repeat 10-20 mL/kg over 10-30 min × 1-2 more; if still not improving → consider COLLOID (5% albumin or dextran 6% — pediatric data limited but used in dengue) 10-20 mL/kg; minimize fluid duration (24-48 hr critical phase, then reabsorption pulmonary edema risk) — taper carefully when stable + Hct dropping; avoid over-resuscitation in recovery phase (fluid overload + pulmonary edema common cause death — RAPID withdrawal as stable!); monitor Hct (rise = leak, fall = bleed or recovery), platelet (transfuse only if active bleed not for prophylaxis); supportive — paracetamol (AVOID NSAID + aspirin → bleeding risk), antiemetic; AVOID corticosteroid, immunoglobulin (no evidence); transfuse PRBC for severe bleeding + Hct fall; if hemorrhage suspected → control source; monitor LFTs + AKI; ICU duration 24-48 hr critical phase then convalescent; PREVENTION — vector control (Aedes aegypti — water containers), repellent, long sleeves, screens, vaccine: Dengvaxia (only seropositive prior), Qdenga newer (≥ 4-16 yr, regardless serostatus pre-approved); secondary infection with different serotype = increased severity (ADE — antibody-dependent enhancement); reportable disease"},{"label":"C","text":"Diuretic in shock phase"},{"label":"D","text":"Restrict fluid in shock"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Severe dengue — critical phase at defervescence (48 hr plasma leak window). Cautious crystalloid resuscitation (less + faster), reassess Hct/HR/BP, taper rapidly during recovery (fluid overload kills). NO aspirin/NSAID/steroid. Vector control + vaccines (Qdenga newer). Reportable.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'WHO Dengue Guidelines 2009 + 2024 updates; Thai Ministry of Public Health Dengue Treatment Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 ปี BW 28 kg อยู่ Bangkok ไข้สูง 4 วันก่อน + ปวดศีรษะ + ปวดเมื่อย + ปวดเบ้าตา + ผื่นแดง + เลือดออกตามไรฟัน + ตอนนี้วันที่ 5 ของไข้ ไข้ลดแล้วแต่กลับเหนื่อยมาก ปวดท้องรุนแรง + อาเจียน + extremities เย็น + capillary refill ช้า

V/S: HR 132, BP 96/82 (narrow PP 14 mmHg — SHOCK), RR 32, SpO2 96%, Temp 37.0°C (defervescence)
Gen: lethargic + restless, cold extremities, hepatomegaly 4 cm, petechiae multiple, no obvious bleeding

Lab: Hct 50 (rising from 38 — hemoconcentration), Plt 28,000, AST 320, ALT 280, albumin 2.8
NS1 antigen + + IgM +; tourniquet test positive
Dengue Severe (DSS — Dengue Shock Syndrome)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 18 วัน BW 3,400 g มา ED ด้วย ไข้ 38.4°C + irritability + poor feeding + lethargy 12 ชม — vaccine ยังไม่ได้

V/S: HR 178, RR 62, Temp 38.4°C, SpO2 96%
Gen: lethargic, full bulging anterior fontanelle, neck supple (newborns may not), no rash, mottled

Lab: CBC WBC 26,000 (left shift), CRP 95, glucose 75; UA negative
LP: WBC 1,580 (PMN 92%), Protein 285, Glucose 18, Gram stain: gram-positive coccobacilli in chains = Listeria suspicious OR GBS
Blood culture pending; HSV PCR sent', '[{"label":"A","text":"Ceftriaxone alone"},{"label":"B","text":"Neonatal Bacterial Meningitis (< 1 mo — different empiric coverage than older children): empiric IV antibiotic IMMEDIATELY (within 1 hr) — Ampicillin 75-100 mg/kg/dose q6h IV (covers Listeria + Enterococcus + susceptible GBS) + Gentamicin 4 mg/kg/dose q24h IV (synergy + gram-negative GBS, E. coli, etc.) + Cefotaxime 50-75 mg/kg/dose q6-8h IV (NOT ceftriaxone in newborns < 28 d due to bilirubin displacement + biliary sludging) — triple therapy covers GBS, E. coli, Listeria, enterococci, gram-negatives; ADD ACYCLOVIR 20 mg/kg/dose q8h IV (60 mg/kg/d) if HSV not excluded — newborns at high risk for HSV encephalitis/disseminated (CSF mononuclear pleocytosis, vesicles, seizure, transaminitis — but classic features may be absent — treat empirically until HSV PCR negative + clinical improvement, usually < 21 d); DEXAMETHASONE NOT routinely recommended in neonates (limited evidence + concerns); duration — GBS meningitis 14-21 d, E. coli meningitis 21 d, Listeria meningitis 21 d (longer than older kids); SUPPORTIVE — fluid + electrolytes, glucose, seizure management (load levetiracetam or phenobarbital); ICU monitoring + airway; SEPSIS workup including blood + urine + LP — done; serial neuro exam + imaging (brain MRI eventually for parenchymal involvement, infarct, abscess, hydrocephalus); audiology + ophtho follow-up (hearing loss common); developmental follow-up; family education; isolation if HSV — contact + standard"},{"label":"C","text":"Antiviral alone"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Neonatal meningitis < 28 d = different empiric (ampicillin + cefotaxime/gentamicin) — covers Listeria + GBS + gram-negative. NO ceftriaxone < 28 d (bilirubin displacement). ADD acyclovir until HSV excluded. Longer duration. Long-term sequelae high (hearing, neurological). Sepsis workup mandatory.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; IDSA Bacterial Meningitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 18 วัน BW 3,400 g มา ED ด้วย ไข้ 38.4°C + irritability + poor feeding + lethargy 12 ชม — vaccine ยังไม่ได้

V/S: HR 178, RR 62, Temp 38.4°C, SpO2 96%
Gen: lethargic, full bulging anterior fontanelle, neck supple (newborns may not), no rash, mottled

Lab: CBC WBC 26,000 (left shift), CRP 95, glucose 75; UA negative
LP: WBC 1,580 (PMN 92%), Protein 285, Glucose 18, Gram stain: gram-positive coccobacilli in chains = Listeria suspicious OR GBS
Blood culture pending; HSV PCR sent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 8 mo ครอบครัว Ashkenazi Jewish, ก่อนหน้านี้ปกติ ตอนนี้ developmental regression — เคย smile + roll over + sit เริ่มสูญเสีย skills, abnormal startle + exaggerated to noise (hyperacusis), hypotonia developing

PE: cherry-red spot on macula bilateral (pathognomonic), hypotonia, decreased response to environment
Family: cousin similar condition died age 4

Enzyme: hexosaminidase A activity DEFICIENT in leukocytes — GM2 gangliosidosis (Tay-Sachs)
MRI: developing white matter changes', '[{"label":"A","text":"Curative gene therapy now standard"},{"label":"B","text":"Tay-Sachs Disease (infantile form, HEXA gene, autosomal recessive — Ashkenazi Jewish 1:27 carrier) — NO curative treatment available: SUPPORTIVE PALLIATIVE care multidisciplinary team — pediatric neurology + genetics + palliative care + family support; SEIZURE management (anticonvulsants — levetiracetam, valproate, often refractory); FEEDING support — G-tube as bulbar function deteriorates; RESPIRATORY support — aspiration precautions, suctioning, oxygen, ventilation per family wishes; PAIN + comfort care — opioids, benzodiazepines; PHYSICAL therapy + positioning; AGGRESSIVE management of infections (frequent pneumonia from aspiration); NUTRITIONAL support — high-calorie, gastrostomy; SLEEP support — clonazepam/melatonin; FAMILY counseling — fatal disease (typical death 2-5 yr), grief support, hospice consideration, sibling support, decision-making around invasive intervention + DNR; GENETIC counseling — autosomal recessive 25% risk each pregnancy, carrier screening Ashkenazi Jewish standard + other ethnicities at risk, preimplantation diagnosis available, prenatal diagnosis via CVS or amnio; CARRIER SCREENING — Ashkenazi Jewish, French Canadian, Cajun Louisiana, Pennsylvania Dutch — recommended pre-conception; INVESTIGATIONAL — substrate reduction therapy (miglustat), enzyme replacement (limited brain penetration), gene therapy clinical trials in progress (AAV-based); biomarker tracking; transition to adult/hospice if family decides; respite care; reproductive planning for parents"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic prophylaxis only"},{"label":"E","text":"Discharge home no follow-up"}]'::jsonb,
  'B', 'Tay-Sachs = HEXA deficiency → GM2 accumulation. Infantile fatal, no cure. Carrier screening (Ashkenazi Jewish 1:27) preconception standard. Supportive palliative + family + genetic counseling. Cherry-red spot pathognomonic. Gene therapy trials ongoing.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'ACMG Carrier Screening Guidelines; National Tay-Sachs Disease Association', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 8 mo ครอบครัว Ashkenazi Jewish, ก่อนหน้านี้ปกติ ตอนนี้ developmental regression — เคย smile + roll over + sit เริ่มสูญเสีย skills, abnormal startle + exaggerated to noise (hyperacusis), hypotonia developing

PE: cherry-red spot on macula bilateral (pathognomonic), hypotonia, decreased response to environment
Family: cousin similar condition died age 4

Enzyme: hexosaminidase A activity DEFICIENT in leukocytes — GM2 gangliosidosis (Tay-Sachs)
MRI: developing white matter changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 5 วัน term BW 3,200 g, ดูปกติแรกคลอด หลัง feeding nasogastric protein-rich formula 2 วันที่ผ่านมา เริ่ม poor feeding + lethargy + recurrent vomiting → unresponsive + opisthotonus + tonic clonic seizure

V/S: HR 178, BP 60/40, RR 62 (Kussmaul-like), Temp 36.4°C
Lab: glucose 65, NH3 850 (very high!), pH 7.30, AG 18 (normal-mildly high), Na 138, K 3.8, urine ketone +
No sepsis features, CRP normal, CBC normal
Urine organic acids — pending; plasma amino acids — pending; acylcarnitine profile — pending
Family: cousin died unexplained newborn', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Suspected Urea Cycle Defect / Hyperammonemic Crisis (newborn unexplained metabolic crisis post-protein loading + high NH3 + cousin Hx = pattern): EMERGENCY pediatric metabolic specialist + ICU; ammonia > 500 = severe → DIALYSIS/CRRT (more rapid than HD) — most effective immediate intervention to clear ammonia; STOP all protein intake immediately (NPO); IV dextrose 10% at high rate to reverse catabolism + provide non-protein calories — GIR 10-15 mg/kg/min (caution glucose > 200 may exacerbate); IV insulin if hyperglycemia + ongoing catabolism (suppresses catabolism); IV lipid 1-2 g/kg/d (non-protein calorie); NITROGEN-SCAVENGING DRUGS — Sodium benzoate + Sodium phenylacetate (Ammonul) IV loading 250 mg/kg over 90 min then 250-500 mg/kg/d infusion — converts ammonia/glycine to hippurate + phenylacetyl-glutamine → renal excretion; alternatively glycerol phenylbutyrate (Ravicti); CARBAGLU (carglumic acid) for NAGS deficiency or propionic acidemia; ARGININE IV 600 mg/kg load then 200-300 mg/kg/d infusion (for urea cycle defects providing intermediates, exception in argininase deficiency); NEUROPROTECTION — manage seizure (levetiracetam preferred not metabolized via affected pathway, AVOID valproate in mitochondrial/urea cycle), ICP management, avoid hyperthermia; gradual reintroduction of protein after ammonia normalized < 80-100 — special metabolic formula; investigations — urine organic acids, plasma amino acids, plasma acylcarnitine, lactate, blood gas, urine orotic acid (helps subtype urea cycle); long-term: protein-restricted diet, supplements, monitor growth + cognitive, liver transplant considered for severe urea cycle defects with recurrent crisis (curative); family genetic counseling + screening + carrier testing + prenatal/preimplantation"},{"label":"C","text":"Continue regular feeding"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Newborn metabolic crisis = differential urea cycle defect, organic acidemia, fatty acid oxidation, MSUD, others. High NH3 + post-protein onset + family Hx = urea cycle suspicion. EMERGENCY — STOP protein + dextrose + nitrogen scavengers + dialysis if severe. Hyperammonemia → permanent neurological damage if untreated. Specialist + genetic counseling.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'ems_mgmt', 'endocrine_metabolic', 'peds',
  'ESPN/ASPGHAN Urea Cycle Disorder Guidelines; Mitochondrial/Metabolic Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 5 วัน term BW 3,200 g, ดูปกติแรกคลอด หลัง feeding nasogastric protein-rich formula 2 วันที่ผ่านมา เริ่ม poor feeding + lethargy + recurrent vomiting → unresponsive + opisthotonus + tonic clonic seizure

V/S: HR 178, BP 60/40, RR 62 (Kussmaul-like), Temp 36.4°C
Lab: glucose 65, NH3 850 (very high!), pH 7.30, AG 18 (normal-mildly high), Na 138, K 3.8, urine ketone +
No sepsis features, CRP normal, CBC normal
Urine organic acids — pending; plasma amino acids — pending; acylcarnitine profile — pending
Family: cousin died unexplained newborn'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี known hereditary spherocytosis ตอนนี้มา ED ด้วย sudden weakness + pallor + ปวดหัว + tachycardia 2 วัน ก่อนได้รับ parvovirus B19 exposure ที่ school (fifth disease ระบาด)

V/S: HR 152, BP 90/56, RR 28, SpO2 98%, BW 24 kg
PE: severe pallor, mild scleral icterus, splenomegaly 4 cm (baseline), no jaundice severe

Lab: Hb 3.8 (baseline 9.2 — DROP!), MCV 80, retic 0.2% (very LOW — APLASTIC), Plt + WBC normal
Indirect bilirubin slightly elevated, LDH not elevated significantly
Parvovirus B19 PCR + ; smear: spherocytes present, no schistocytes, scarce reticulocytes', '[{"label":"A","text":"Folic acid only"},{"label":"B","text":"Aplastic Crisis (Parvovirus B19) in Hereditary Spherocytosis: PRBC TRANSFUSION urgently — 10-15 mL/kg leukoreduced PRBC over 3-4 hr (recheck Hb post-transfusion target Hb 8-10 g/dL minimum, then transfuse periodically until reticulocyte recovery typically 7-14 days as bone marrow recovers from parvovirus B19 transient suppression); cardiac monitoring during transfusion + diuretic if symptomatic CHF; consider IV folate + supportive; ISOLATION — contact precautions (parvovirus B19 transmissible) + protect immunocompromised + pregnant women + others with hemolytic anemia (cross-infection risk in family/school); investigate household for similar conditions at risk; monitor — daily CBC + reticulocyte until reticulocyte > 1% sign recovery; counsel family — aplastic crisis self-limited 1-2 wk in immunocompetent (B19 transient suppression of erythroid precursors); follow-up — chronic management of HS + family screen + future planning splenectomy after age 6+ if not already done; vaccinate pneumococcal/meningococcal/Hib before splenectomy; long-term: most full recovery, but rare progress to chronic infection in immunocompromised → IVIG treatment; education families with chronic hemolytic anemia about parvovirus risks + close monitoring during outbreak"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', 'Aplastic crisis from Parvovirus B19 in HS or other chronic hemolytic anemia = transient red cell aplasia 1-2 wk. Sudden severe drop + reticulocytopenia = key feature. Transfusion supports until marrow recovers. Isolation (transmissible). Family counsel + pregnant + immunocompromised contacts.', NULL,
  'hard', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Red Book 2024 Parvovirus; British Society Haematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี known hereditary spherocytosis ตอนนี้มา ED ด้วย sudden weakness + pallor + ปวดหัว + tachycardia 2 วัน ก่อนได้รับ parvovirus B19 exposure ที่ school (fifth disease ระบาด)

V/S: HR 152, BP 90/56, RR 28, SpO2 98%, BW 24 kg
PE: severe pallor, mild scleral icterus, splenomegaly 4 cm (baseline), no jaundice severe

Lab: Hb 3.8 (baseline 9.2 — DROP!), MCV 80, retic 0.2% (very LOW — APLASTIC), Plt + WBC normal
Indirect bilirubin slightly elevated, LDH not elevated significantly
Parvovirus B19 PCR + ; smear: spherocytes present, no schistocytes, scarce reticulocytes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี known chronic kidney disease (CKD stage 3 จาก reflux nephropathy) ตอนนี้มา ED ปวดศีรษะรุนแรง + ตามัว + อาเจียน + ชัก × 1 ครั้ง brief

V/S: BP 195/132 (severely elevated, > 99th percentile + symptoms = hypertensive EMERGENCY), HR 102, RR 24, SpO2 99%, BW 28 kg
Gen: post-ictal currently, recovering; papilledema bilateral OD/OS, no focal deficit; clinically euvolemic

Lab: Cr 2.4 (baseline 1.6), K 4.8, glucose 102, no acute MI/CHF; UA proteinuria 2+, normal RBC
CT brain: no hemorrhage; consistent with PRES (posterior reversible encephalopathy syndrome) — MRI later', '[{"label":"A","text":"Rapid normalization of BP to normal in 1 hr"},{"label":"B","text":"Pediatric Hypertensive Emergency with end-organ damage (encephalopathy, seizure, PRES): ICU admission + continuous BP monitoring (preferably arterial line for accurate q minute monitoring); SLOW + CONTROLLED reduction — reduce 25% of planned reduction over FIRST 8 HOURS (NOT < 25% in first 1 hr to avoid hypoperfusion stroke/ischemic injury), additional 25% over next 8 hr, normal range over 24-48 hr total; first-line IV — Labetalol IV bolus 0.2-1 mg/kg q5-10 min titrate (max 40 mg/dose) OR continuous infusion 0.25-3 mg/kg/hr (avoid in asthma, CHF); OR Nicardipine continuous infusion 0.5-3 mcg/kg/min titrate (avoid in liver dysfunction); OR Sodium nitroprusside infusion 0.3-8 mcg/kg/min (caution cyanide toxicity in renal failure, light-protected) — use if refractory; OR Esmolol short-acting beta-blocker; AVOID sublingual nifedipine + IV hydralazine (less predictable + cause hypotension); manage SEIZURE — benzodiazepines, levetiracetam load; identify + treat underlying cause — CKD, renal artery stenosis (consider MRA renal), pheochromocytoma + neuroblastoma (screen catecholamines + imaging adrenal/sympathetic chain), drug-induced (cocaine/amphetamine, sympathomimetic, OCP), coarctation re-check, glomerulonephritis, endocrine; once BP controlled IV → transition oral antihypertensives — ACEI/ARB (if CKD + proteinuria), CCB, diuretic, beta-blocker per patient comorbid; AVOID — fluid overload, abrupt BP changes; recheck end organ — ophtho + neurology + cardiology + nephrology; long-term — outpatient BP target, address comorbid risk, growth + development monitoring, schooling, transition adult; PRES typically reverses with BP control + supportive (DAYS-WEEKS)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'Pediatric HT emergency = BP severely elevated + end-organ damage (encephalopathy, retinopathy, AKI, HF, dissection). Lower BP gradually (25% planned in first 8 hr) — avoid hypoperfusion injury. IV labetalol/nicardipine/SNP first-line. PRES reversible with BP control. Investigate cause + long-term oral antihypertensive.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'ems_mgmt', 'cardiovascular', 'peds',
  'AAP HT Guideline 2017; PHTS Pediatric Hypertension Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 ปี known chronic kidney disease (CKD stage 3 จาก reflux nephropathy) ตอนนี้มา ED ปวดศีรษะรุนแรง + ตามัว + อาเจียน + ชัก × 1 ครั้ง brief

V/S: BP 195/132 (severely elevated, > 99th percentile + symptoms = hypertensive EMERGENCY), HR 102, RR 24, SpO2 99%, BW 28 kg
Gen: post-ictal currently, recovering; papilledema bilateral OD/OS, no focal deficit; clinically euvolemic

Lab: Cr 2.4 (baseline 1.6), K 4.8, glucose 102, no acute MI/CHF; UA proteinuria 2+, normal RBC
CT brain: no hemorrhage; consistent with PRES (posterior reversible encephalopathy syndrome) — MRI later'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี BW 78 kg, ส่วนสูง 145 cm, BMI 37.0 (severe obesity > 99th percentile, > 120% of 95th percentile per AAP definition); puberty Tanner 3; ไม่มี endocrine cause; เริ่มมี acanthosis nigricans + acral darkening; sleep ngonggn snoring + witnessed apnea

PE: severe obesity, hypertension borderline 130/82, abdominal striae, acanthosis nigricans; mild gynecomastia (likely lipomastia), no Cushingoid features, normal thyroid; normal genitalia for stage
Lab: HbA1c 5.9 (impaired), fasting glucose 108, fasting insulin elevated, lipid panel — TG 220, LDL 132, HDL 38 (low), ALT 78 (high — likely NAFLD), TSH normal
PSG: moderate OSA (AHI 12)', '[{"label":"A","text":"Discourage discussion of weight"},{"label":"B","text":"Severe Pediatric Obesity with comorbidities (T2DM-risk, OSA, NAFLD, HT) — AAP 2023 Clinical Practice Guideline: comprehensive evidence-based management at any age (no longer ''watchful waiting''); INTENSIVE HEALTH BEHAVIOR + LIFESTYLE TREATMENT (IHBLT) — ≥ 26 contact hours over 3-12 mo, multidisciplinary (clinician + dietitian + behavioral + exercise + social + family) — first-line for ALL ages ≥ 6 yr + offered ≥ 2 yr; address dietary patterns (reduce SSB + ultraprocessed + portion control + family meals + Mediterranean-style + caloric awareness rather than restriction); physical activity — 60 min/d moderate-vigorous; limit screen time < 2 hr/d; sleep hygiene (treat OSA — adenotonsillectomy if appropriate, CPAP); behavioral therapy + family involvement + parent management training; SCREEN for + MANAGE COMORBIDITIES — T2DM (HbA1c, fasting glucose, OGTT if indicated), dyslipidemia (lipid panel), NAFLD (ALT q yr), HT (regular BP), OSA (PSG), depression, body image, eating disorder; PHARMACOTHERAPY now AAP-recommended adjunct ≥ 12 yr with BMI > 95th + comorbidities — Liraglutide ≥ 12 yr OR Phentermine-Topiramate ≥ 12 yr OR Orlistat ≥ 12 yr OR Setmelanotide for specific genetic obesity ≥ 6 yr OR Semaglutide weekly SC ≥ 12 yr (recent FDA approval, dramatic results — STEP TEENS trial 16% BMI reduction over 68 wk); long-term medication + monitoring; METABOLIC + BARIATRIC SURGERY (MBS) — AAP-recommended adolescents ≥ 13 yr with BMI > 35 + significant comorbidities OR > 40 (sleeve gastrectomy or RYGB) at specialized centers — significant durable weight loss + reverse comorbidities; psychosocial support — depression + body image + bullying common; school nutrition + activity advocacy; cardiometabolic risk reduction"},{"label":"C","text":"Surgery age 6"},{"label":"D","text":"Restrict all calories severely"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', 'AAP 2023 Pediatric Obesity Guidelines: paradigm shift — treat early + intensively (no watchful waiting). IHBLT for all ≥ 6 yr. Pharmacotherapy ≥ 12 yr with BMI > 95th + comorbidity (liraglutide, semaglutide, phentermine-topiramate). Bariatric surgery ≥ 13 yr selected severe. Comorbidity screening + multidisciplinary.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'pediatrics', 'integrative', 'endocrine_metabolic', 'peds',
  'AAP Clinical Practice Guideline: Pediatric Obesity 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 11 ปี BW 78 kg, ส่วนสูง 145 cm, BMI 37.0 (severe obesity > 99th percentile, > 120% of 95th percentile per AAP definition); puberty Tanner 3; ไม่มี endocrine cause; เริ่มมี acanthosis nigricans + acral darkening; sleep ngonggn snoring + witnessed apnea

PE: severe obesity, hypertension borderline 130/82, abdominal striae, acanthosis nigricans; mild gynecomastia (likely lipomastia), no Cushingoid features, normal thyroid; normal genitalia for stage
Lab: HbA1c 5.9 (impaired), fasting glucose 108, fasting insulin elevated, lipid panel — TG 220, LDL 132, HDL 38 (low), ALT 78 (high — likely NAFLD), TSH normal
PSG: moderate OSA (AHI 12)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ตรวจ routine check up พบ murmur fixed split S2 + soft systolic ejection murmur LUSB grade 2-3/6

V/S ปกติ, BW 18 kg, asymptomatic, normal growth
Family Hx: aunt has ASD repaired

ECG: incomplete RBBB, right axis deviation
CXR: mild cardiomegaly, prominent pulmonary vasculature
Echo: ostium secundum ASD 12 mm, L→R shunt, Qp:Qs 2.4, mild RV dilatation, normal LV, normal pulmonary pressure', '[{"label":"A","text":"No intervention needed ever"},{"label":"B","text":"Hemodynamically significant Ostium Secundum ASD (Qp:Qs > 1.5-2 + RV dilation): elective closure indicated to prevent long-term complications (PHT, atrial arrhythmias, paradoxical embolism, RV failure); TIMING — ideally 2-5 years of age (most defects identified by age, surgery before school age + reduces lifetime risk); MODALITY — TRANSCATHETER closure (Amplatzer Septal Occluder, Gore Cardioform) is FIRST-LINE for secundum ASD with adequate rims + appropriate size (90%+ secundum amenable) — minimally invasive, no sternotomy, shorter recovery, similar long-term outcomes; SURGICAL closure for: primum ASD, sinus venosus, large defect with inadequate rims, very large secundum > 35 mm, associated anomalies, contraindication to device; cardiac MRI for detailed anatomy + RV function; antibiotic prophylaxis NOT routinely required for ASD per AHA 2007 unless prosthetic material in first 6 mo OR residual defect adjacent to device; aspirin 3-5 mg/kg/d × 6 mo post-device closure (anti-platelet for endothelialization); follow-up — echo at 24 hr post + 1 mo + 6 mo + annually; activity — no restriction unless symptomatic; education + screen first-degree relatives (small familial component); long-term: post-closure outcomes excellent if closed before adult atrial arrhythmias develop"},{"label":"C","text":"Heart transplant"},{"label":"D","text":"Watch + wait age 40"},{"label":"E","text":"Diuretic chronic only"}]'::jsonb,
  'B', 'Secundum ASD = most common ASD. Transcatheter device closure preferred for amenable defects. Close 2-5 yr to prevent adult complications (atrial arrhythmia, PHT, RV dysfunction). Surgery for primum/sinus venosus/inadequate rims. Excellent outcomes if treated.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC ACHD Guideline 2018; STS Pediatric Cardiac', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ตรวจ routine check up พบ murmur fixed split S2 + soft systolic ejection murmur LUSB grade 2-3/6

V/S ปกติ, BW 18 kg, asymptomatic, normal growth
Family Hx: aunt has ASD repaired

ECG: incomplete RBBB, right axis deviation
CXR: mild cardiomegaly, prominent pulmonary vasculature
Echo: ostium secundum ASD 12 mm, L→R shunt, Qp:Qs 2.4, mild RV dilatation, normal LV, normal pulmonary pressure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 10 ปี ใจสั่น + เจ็บอกขณะออกกำลังกาย + episodes syncope ขณะเล่นกีฬา 2 ครั้ง 3 mo

V/S: HR 78, BP 110/72, BW 30 kg
PE: harsh ejection systolic murmur 4/6 at RUSB radiating to neck + suprasternal thrill, soft S2, delayed carotid upstroke (parvus et tardus)

ECG: LVH + strain pattern
CXR: prominent aorta, normal heart size
Echo: bicuspid AV (congenital) + severe AS (mean gradient 60 mmHg, peak gradient 90), normal LV function, mild AR', '[{"label":"A","text":"Continue sports unrestricted"},{"label":"B","text":"Severe Congenital Aortic Stenosis (bicuspid) + symptoms = INTERVENTION: cardiology + cardiac surgery urgent; activity RESTRICTION — no competitive sports + no isometric high-intensity activity until intervention (sudden death risk severe AS); BETA-BLOCKER for symptom control before intervention; BALLOON AORTIC VALVULOPLASTY (BAV) — TYPICALLY FIRST-LINE intervention in pediatric AS — minimally invasive, can repeat, postpones valve replacement (durability 5-10 yr typically before need for further intervention); SURGICAL OPTIONS depending on anatomy + age: 1) AV repair if leaflet preservation possible, 2) Ross procedure (pulmonary autograft to aortic position + homograft to PV — preferred in growing children, autograft grows, no anticoagulation, durable) — gold standard pediatric AS surgical; 3) AV REPLACEMENT — mechanical (durable but requires lifelong anticoagulation, problematic growth), bioprosthetic (no anticoagulation but limited durability + redo); 4) APICOAORTIC conduit; antibiotic prophylaxis prior to dental/surgery for prosthetic/repaired with material × 6 mo (AHA); long-term follow-up annually — echo + ECG + symptom + activity; counsel on Marfan/connective tissue + aortopathy/dissection risk with bicuspid AV; family screening (BAV familial component); contraception planning + pregnancy considerations later; transition adult CHD"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Wait — outgrow"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
  'B', 'Pediatric AS + symptoms or severe gradient = intervention. BAV first-line typically. Ross procedure preferred surgical for growing children (autograft grows, no anticoagulation). Mechanical valve = lifelong anticoagulation. Bicuspid AV = aortopathy + family screen. Activity restriction critical pre-intervention.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC Pediatric Cardiology; STS Congenital Cardiac', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 10 ปี ใจสั่น + เจ็บอกขณะออกกำลังกาย + episodes syncope ขณะเล่นกีฬา 2 ครั้ง 3 mo

V/S: HR 78, BP 110/72, BW 30 kg
PE: harsh ejection systolic murmur 4/6 at RUSB radiating to neck + suprasternal thrill, soft S2, delayed carotid upstroke (parvus et tardus)

ECG: LVH + strain pattern
CXR: prominent aorta, normal heart size
Echo: bicuspid AV (congenital) + severe AS (mean gradient 60 mmHg, peak gradient 90), normal LV function, mild AR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 ปี 4 wk ก่อน Hx COVID-19 mild ตอนนี้ ไข้สูง 39.6°C × 6 วัน + conjunctivitis bilateral + ผื่นแดง + ปวดท้องรุนแรง + อาเจียน + diarrhea + ปาก/ลิ้นแดง + edema hands/feet + hypotension shock-like

V/S: HR 142, BP 86/52, RR 32, SpO2 96%, Temp 39.6°C, BW 26 kg
Gen: ill-appearing, mucocutaneous + cardiac + GI

Lab: CRP 285 (very high), ESR 92, fibrinogen 580, ferritin 1,840, D-dimer 3,200, troponin 1.2 (HIGH!), BNP 4,250, lymphopenia, mild AKI Cr 1.4, sodium 132, albumin 2.8, LFT mildly elevated
SARS-CoV-2 IgG positive + PCR negative
Echo: LV dysfunction EF 38%, mild dilation, no coronary aneurysm yet (but Z-score borderline)', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Multisystem Inflammatory Syndrome in Children (MIS-C, post-COVID hyperinflammation, CDC criteria — fever + multi-system + lab evidence + SARS-CoV-2 exposure/serology + no alt Dx): admit PICU; cardiac monitoring + frequent echo; supportive — IV fluid careful (cardiac dysfunction → measure preload + avoid overload), vasopressor/inotrope as needed (norepinephrine, epinephrine, milrinone for LV dysfunction), respiratory support; IMMUNOMODULATION — first-line IVIG 2 g/kg single infusion + Methylprednisolone 1-2 mg/kg/d IV (low-mod dose) — combination shows improved outcomes (especially with shock/cardiac involvement); for severe/refractory — high-dose pulse methylprednisolone 30 mg/kg/d × 3 d OR anakinra (IL-1 receptor antagonist) 4-10 mg/kg/d SC/IV OR infliximab (anti-TNF) OR tocilizumab — escalation; ASPIRIN 3-5 mg/kg/d (anti-platelet — concurrent treatment with thrombosis prophylaxis); ANTICOAGULATION — enoxaparin prophylactic ALL patients OR therapeutic if thrombosis/severe LV dysfunction/aneurysm; address coronary involvement (z-score) — escalation if dilatation/aneurysm progresses; multidisciplinary — peds cardiology, ID, rheumatology, ICU, hematology; SUPPORTIVE — electrolytes, AKI management; recheck inflammatory markers + echo trending down; vaccination once recovered (COVID + others on schedule); long-term — cardiac function follow-up 6-12 mo, exercise tolerance, NSAID/anticoagulation duration; report to local public health + national database; family education + return precautions if recurrent fever"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antiviral alone"}]'::jsonb,
  'B', 'MIS-C = hyperinflammatory syndrome 2-6 wk after SARS-CoV-2 (mimics KD + TSS). CDC criteria. IVIG + steroid combination first-line. Cardiac involvement common (LV dysfunction, coronaries). Aspirin + anticoagulation. Escalation (anakinra) for refractory. Multidisciplinary + long-term cardiac follow-up.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement MIS-C 2022; ACR Clinical Guidance for MIS-C', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 ปี 4 wk ก่อน Hx COVID-19 mild ตอนนี้ ไข้สูง 39.6°C × 6 วัน + conjunctivitis bilateral + ผื่นแดง + ปวดท้องรุนแรง + อาเจียน + diarrhea + ปาก/ลิ้นแดง + edema hands/feet + hypotension shock-like

V/S: HR 142, BP 86/52, RR 32, SpO2 96%, Temp 39.6°C, BW 26 kg
Gen: ill-appearing, mucocutaneous + cardiac + GI

Lab: CRP 285 (very high), ESR 92, fibrinogen 580, ferritin 1,840, D-dimer 3,200, troponin 1.2 (HIGH!), BNP 4,250, lymphopenia, mild AKI Cr 1.4, sodium 132, albumin 2.8, LFT mildly elevated
SARS-CoV-2 IgG positive + PCR negative
Echo: LV dysfunction EF 38%, mild dilation, no coronary aneurysm yet (but Z-score borderline)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี on chemotherapy for ALL (induction phase, severely immunocompromised) แม่บอกพี่น้องเป็นอีสุกอีใส 14 วันก่อน — ตอนนี้พบ vesicular rash บน trunk + face 2 lesions ใหม่ ๆ + ไข้ 38.4°C

V/S: HR 122, RR 28, Temp 38.4°C, BW 20 kg
PE: 5-6 vesicles trunk + face on erythematous base (early), no respiratory distress, no encephalopathy currently, no severe LFT change

WBC neutropenia 220 (severely low), Plt 38,000, mild LFT elevation', '[{"label":"A","text":"Outpatient oral acyclovir"},{"label":"B","text":"Varicella in severely immunocompromised child = EMERGENCY (high mortality if disseminated): admit + IV Acyclovir 500 mg/m² q8h (or 10 mg/kg/dose q8h) IV × 7-10 days minimum (longer if continued lesions/disseminated/visceral), adjusted for renal function; oral acyclovir/valacyclovir INADEQUATE in this population; supportive — hydration (acyclovir crystalluria, maintain UO good), antipyretic AVOID ASPIRIN (Reye risk + transmission concern), antipruritic, prevent secondary bacterial infection (Staph, GAS — superinfection can be severe); careful skin/wound care + bath; monitor for VISCERAL DISSEMINATION — pneumonitis (severe, high mortality), encephalitis, hepatitis, DIC, hemorrhagic varicella — manage in ICU; isolate airborne + contact precautions (until lesions crusted, no new × 24 hr); REMOVE/REDUCE chemotherapy temporarily (coordinate oncology — risk infection vs cancer); POST-EXPOSURE for immunocompromised + susceptible contacts: VZIG (VariZIG) 125 U/10 kg IM (max 625 U) within 96 hr (extended to 10 d post-exposure) — passive immunization; alternative IVIG if VZIG unavailable; antiviral prophylaxis acyclovir 800 mg PO QID × 7 d (days 7-22 post-exposure) for high-risk susceptible if VZIG unavailable; prevention — VARIVAX vaccine for healthy + select immunocompetent contacts; long-term: full immunity post-recovery; vaccination once chemo completed + immune recovery"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Withhold all treatment"}]'::jsonb,
  'B', 'Varicella + severe immunocompromise (ALL on chemo, post-transplant, congenital immunodeficiency) = high mortality if untreated. IV acyclovir mandatory (oral inadequate). Watch visceral dissemination + bacterial superinfection. Post-exposure prophylaxis VZIG or acyclovir for susceptible immunocompromised contacts within 10 d.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Varicella; CDC ACIP Varicella Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี on chemotherapy for ALL (induction phase, severely immunocompromised) แม่บอกพี่น้องเป็นอีสุกอีใส 14 วันก่อน — ตอนนี้พบ vesicular rash บน trunk + face 2 lesions ใหม่ ๆ + ไข้ 38.4°C

V/S: HR 122, RR 28, Temp 38.4°C, BW 20 kg
PE: 5-6 vesicles trunk + face on erythematous base (early), no respiratory distress, no encephalopathy currently, no severe LFT change

WBC neutropenia 220 (severely low), Plt 38,000, mild LFT elevation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี vaccine ไม่ครบ (no MMR), เพิ่งเดินทางกลับจาก outbreak area ในต่างประเทศ ตอนนี้ ไข้สูง 40°C × 5 วัน + cough + coryza + conjunctivitis + Koplik spots (white spots on red base buccal mucosa) → ผื่นแดงเริ่มหน้าก่อน แล้วลามลงตัว 2 วัน + คอเจ็บ + เริ่มหอบเหนื่อย + ไม่ได้กิน vit A

V/S: HR 142, RR 48, SpO2 92%, Temp 40°C, BW 16 kg
PE: morbilliform rash trunk + extremities, conjunctivitis, Koplik (resolving), bilateral crackles + decreased breath sounds RLL
CXR: bilateral interstitial + RLL consolidation
CBC: lymphopenia
Measles IgM positive + PCR positive', '[{"label":"A","text":"Antiviral alone curative"},{"label":"B","text":"Measles with secondary pneumonia (major complication, leading cause measles death) — vaccine-preventable disease: admit + isolation airborne (negative pressure room if available, mask) until 4 d after rash onset; SUPPORTIVE — adequate hydration, antipyretic acetaminophen (AVOID aspirin), oxygen as needed to maintain SpO2 ≥ 92%, nutritional support; ANTIBIOTIC for bacterial pneumonia superinfection — empiric Ceftriaxone (covers Spn, H flu) + add anti-Staph (vancomycin) if severe/MRSA risk × 7-10 d; VITAMIN A SUPPLEMENT — proven to reduce measles morbidity + mortality especially in malnourished/vit A deficient — 200,000 IU PO single dose for > 1 yr (100,000 < 1 yr, 50,000 < 6 mo) — repeat day 2 + 2-4 wk if signs of vit A deficiency + measles severe (WHO standard); ANTIVIRAL — ribavirin investigational + only for severe cases (no routine antiviral measles); no specific approved antiviral; bacterial complications include AOM, pneumonia, mastoiditis, croup; OTHER COMPLICATIONS to watch — encephalitis 0.1-0.2% (high mortality + morbidity), SSPE (subacute sclerosing panencephalitis) rare delayed years later (degenerative); blindness from corneal scarring (vit A deficiency); diarrhea + malnutrition; POST-EXPOSURE PROPHYLAXIS for susceptible contacts within 72 hr (MMR vaccine — but contraindicated < 6 mo + pregnant + severely immunocompromised) OR within 6 d (immune globulin 0.5 mL/kg max 15 mL — for immunocompromised, pregnant, < 12 mo); reportable urgent + public health response; quarantine contacts 21 d if susceptible; vaccination key prevention (MMR 2-dose); long-term — immune amnesia (immune system reset post-measles, increased susceptibility 1-3 yr)"},{"label":"C","text":"Discharge no follow"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', 'Measles = highly contagious, reportable, vaccine-preventable. Pneumonia leading complication. Vitamin A WHO/AAP recommendation. Bacterial superinfection antibiotic. Watch encephalitis + SSPE. PEP within 72 hr MMR or within 6 d immune globulin for susceptible. Vaccination 2-dose prevention.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Measles; CDC ACIP MMR; WHO Vit A in Measles', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี vaccine ไม่ครบ (no MMR), เพิ่งเดินทางกลับจาก outbreak area ในต่างประเทศ ตอนนี้ ไข้สูง 40°C × 5 วัน + cough + coryza + conjunctivitis + Koplik spots (white spots on red base buccal mucosa) → ผื่นแดงเริ่มหน้าก่อน แล้วลามลงตัว 2 วัน + คอเจ็บ + เริ่มหอบเหนื่อย + ไม่ได้กิน vit A

V/S: HR 142, RR 48, SpO2 92%, Temp 40°C, BW 16 kg
PE: morbilliform rash trunk + extremities, conjunctivitis, Koplik (resolving), bilateral crackles + decreased breath sounds RLL
CXR: bilateral interstitial + RLL consolidation
CBC: lymphopenia
Measles IgM positive + PCR positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี ค่อย ๆ มีไข้ + ไอ persistent dry x 2-3 wk + ปวดศีรษะ + sore throat + myalgia + ไม่ค่อยตอบสนองต่อ ampicillin ขั้น primary care

V/S: HR 102, RR 28, SpO2 95%, Temp 38.4°C, BW 36 kg
Gen: not toxic, persistent dry cough, scattered crackles bilateral, mild wheeze, no consolidation pattern

CXR: bilateral interstitial + perihilar infiltrate (looks worse than clinical exam — classic for atypical)
CBC: WBC 9,200 normal, mild lymphopenia
Cold agglutinins positive; Mycoplasma IgM positive + PCR positive (current preferred)
Family: sibling sick with similar 4 wk ago', '[{"label":"A","text":"Continue ampicillin"},{"label":"B","text":"Mycoplasma pneumoniae pneumonia (atypical pneumonia, school-age + adolescent peak): antibiotic effective against atypical pathogens — Macrolide first-line (Azithromycin 10 mg/kg day 1 then 5 mg/kg × 4 d OR Clarithromycin 7.5 mg/kg q12h × 7-10 d OR Erythromycin); MACROLIDE RESISTANCE rising globally (especially Asia) — if no clinical improvement 48-72 hr or known high-resistance area → consider DOXYCYCLINE 4 mg/kg/d ÷ q12h × 7-10 d (now recommended ALL ages per IDSA 2020 for short courses, formerly restricted > 8 yr) OR Fluoroquinolone (levofloxacin) selected (off-label peds, reserve); supportive — antipyretic, hydration, monitoring; usually outpatient unless severe (hypoxia, distress, dehydration, immunocompromised); EXTRAPULMONARY MANIFESTATIONS to watch — hemolytic anemia (cold agglutinin), encephalitis (rare but devastating), Mycoplasma-induced rash + mucositis (MIRM), Stevens-Johnson syndrome variant, arthritis, myocarditis; consider hospitalization if extrapulmonary; immunity not lifelong → can reinfect; outbreaks among schools/families; no vaccine; identify clinical context — Mycoplasma should be considered school-age + adolescent with atypical features (gradual onset, prolonged cough, normal-mild CBC, bilateral patchy CXR, extrapulmonary, exposure)"},{"label":"C","text":"Antifungal alone"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"No antibiotic"}]'::jsonb,
  'B', 'Mycoplasma = atypical pneumonia school-age + adolescent. CXR worse than clinical. Cold agglutinin + extrapulmonary manifestations (MIRM, SJS, hemolytic anemia, encephalitis). Macrolide first-line; doxycycline (all ages 2020) or fluoroquinolone for macrolide-resistance. No vaccine; reinfection possible.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'PIDS/IDSA Pediatric CAP Guideline 2011; IDSA Pediatric Antibiotic Guideline 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี ค่อย ๆ มีไข้ + ไอ persistent dry x 2-3 wk + ปวดศีรษะ + sore throat + myalgia + ไม่ค่อยตอบสนองต่อ ampicillin ขั้น primary care

V/S: HR 102, RR 28, SpO2 95%, Temp 38.4°C, BW 36 kg
Gen: not toxic, persistent dry cough, scattered crackles bilateral, mild wheeze, no consolidation pattern

CXR: bilateral interstitial + perihilar infiltrate (looks worse than clinical exam — classic for atypical)
CBC: WBC 9,200 normal, mild lymphopenia
Cold agglutinins positive; Mycoplasma IgM positive + PCR positive (current preferred)
Family: sibling sick with similar 4 wk ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี BW 24 kg ครอบครัวสังเกตว่าลูกนอนกรน + หยุดหายใจ episodes 5-10 sec ขณะนอน + restless sleep + ตื่นเช้าง่วงนอน + พฤติกรรมหลังตื่น hyperactive + ผลการเรียนตก + ปัสสาวะรดที่นอน + mouth breathing daytime

PE: tonsils 3+ enlarged + adenoid facies (long face, open mouth), BMI 19, nasal congestion mild, no obstruction other; growth ปกติ
Polysomnography: AHI 14 events/hr (moderate-severe OSA in peds — AHI > 5 in kids = OSA, > 10 = moderate, > 15 = severe), oxygen desaturation nadir 82%, no central apnea, snoring throughout', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Pediatric Moderate-Severe Obstructive Sleep Apnea — ENT referral + adenotonsillectomy FIRST-LINE: surgical adenotonsillectomy success rate 70-80% pediatric OSA cure, addresses adenoid + tonsillar hypertrophy (most common cause); pre-op evaluation — anesthesia consult (post-op respiratory complications — especially < 3 yr, severe OSA, obesity, syndromes — admit overnight monitoring); supportive — humidified air, nasal saline, treat allergic rhinitis (intranasal corticosteroid + montelukast may help mild OSA pre-surgery + persistent post-op residual OSA); WATCH for post-op complications — bleeding (primary 24 hr, secondary 5-10 d), respiratory compromise, dehydration; if residual OSA post-surgery → CPAP/BiPAP titrated (PSG repeat 6-8 wk post-op); ADDRESS COMORBIDITIES — obesity weight management, allergic rhinitis, GERD, craniofacial syndromes (Pierre Robin, Treacher Collins, Crouzon — different approach), neuromuscular weakness, Down syndrome (higher OSA prevalence + risk + post-op edema); long-term sequelae untreated — cardiovascular (pulmonary HT, RV dysfunction), neurocognitive + behavioral (ADHD-like), failure to thrive, enuresis; family education — observe post-op recovery, return precautions; PSG repeat 6-8 wk post-op if symptoms persist; transition adult OSA if persists adolescence + adulthood"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Sedative for sleep"}]'::jsonb,
  'B', 'Pediatric OSA different from adult — adenotonsillar hypertrophy primary cause. Adenotonsillectomy first-line (70-80% cure). PSG diagnostic + AHI > 5 in kids = OSA. Comorbidities (obesity, Down, craniofacial). CPAP for residual OSA. Long-term cardiovascular + neurobehavioral sequelae untreated.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Practice Guideline: Pediatric OSA 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี BW 24 kg ครอบครัวสังเกตว่าลูกนอนกรน + หยุดหายใจ episodes 5-10 sec ขณะนอน + restless sleep + ตื่นเช้าง่วงนอน + พฤติกรรมหลังตื่น hyperactive + ผลการเรียนตก + ปัสสาวะรดที่นอน + mouth breathing daytime

PE: tonsils 3+ enlarged + adenoid facies (long face, open mouth), BMI 19, nasal congestion mild, no obstruction other; growth ปกติ
Polysomnography: AHI 14 events/hr (moderate-severe OSA in peds — AHI > 5 in kids = OSA, > 10 = moderate, > 15 = severe), oxygen desaturation nadir 82%, no central apnea, snoring throughout'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 14 ปี BMI 30 (obesity) presented with headache + nosebleed × 3 วัน — no other neurologic symptoms

V/S: BP 168/108 (severely elevated > 95th + 12 mmHg) confirmed × 3 separate measurements, HR 92, BW 68 kg, no signs end-organ damage (no papilledema, no AKI, no encephalopathy, no LVH on ECG, no neuro deficit)
Lab: Cr 0.8, K 3.6, glucose 102, UA negative, plasma renin/aldosterone normal, TSH normal, urine catecholamines pending
US renal: normal anatomy', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Hypertensive Urgency (severe HT WITHOUT end-organ damage — vs emergency WITH damage): admit observation, GRADUAL oral antihypertensive treatment over 24-48 hr (not minutes-hours like emergency); first-line oral options — Captopril 0.3-0.5 mg/kg/dose q8h (ACEI, fast onset 15-30 min, monitor renal function) OR Hydralazine 0.1-0.2 mg/kg/dose q4-6h (vasodilator) OR Labetalol oral 1-3 mg/kg/dose q12h (beta + alpha block) OR Nifedipine immediate release (NOT sublingual — avoid sudden drops, but oral 0.25-0.5 mg/kg may be acceptable in some pediatric protocols, used cautiously); avoid abrupt + excessive lowering; goal — reduce BP gradually over 24-48 hr aim < 95th percentile; identify cause — workup secondary HT (renal — US + DMSA + MRA renal arteries if young; endocrine — pheochromocytoma + neuroblastoma catecholamines, Cushing, hyperaldosteronism, thyroid; coarctation re-eval; OSA screen; medication-induced; oral contraceptive; sympathomimetic, illicit drugs); LIFESTYLE — weight management (this patient overweight), DASH diet, sodium reduction, increase activity, address screen time + sleep; long-term oral antihypertensive — ACEI (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide first-line per AAP 2017; reassess + titrate q1-4 wk; ABPM for white coat HT; address comorbid CV risk; family + school education"},{"label":"C","text":"Sublingual nifedipine"},{"label":"D","text":"IV nitroprusside"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', 'Pediatric HT urgency = severely elevated BP WITHOUT end-organ damage. Treat gradually with oral antihypertensives over 24-48 hr (vs IV emergency). Workup secondary cause. Lifestyle + pharmacotherapy long-term. AAP 2017 Guideline. Goal < 95th percentile.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AAP Clinical Practice Guideline: HT in Children 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 14 ปี BMI 30 (obesity) presented with headache + nosebleed × 3 วัน — no other neurologic symptoms

V/S: BP 168/108 (severely elevated > 95th + 12 mmHg) confirmed × 3 separate measurements, HR 92, BW 68 kg, no signs end-organ damage (no papilledema, no AKI, no encephalopathy, no LVH on ECG, no neuro deficit)
Lab: Cr 0.8, K 3.6, glucose 102, UA negative, plasma renin/aldosterone normal, TSH normal, urine catecholamines pending
US renal: normal anatomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 11 ปี เริ่มเหนื่อยง่าย + ทนหนาวไม่ค่อยได้ + น้ำหนักเพิ่ม 4 kg ใน 6 mo despite same diet + ผลการเรียนลดลง + skin dry + hair coarse + constipation + delayed puberty Tanner 2

V/S: HR 58, BP 102/68, BW 42 kg, growth velocity slowed (4 cm/yr from baseline 6 cm/yr)
PE: diffuse goiter symmetric firm rubbery, dry skin, mild bradycardia, normal reflexes (no delayed relaxation severe yet), proportional growth

Lab: TSH 38 (high), Free T4 0.5 (low), Free T3 low-normal
Anti-thyroid peroxidase (anti-TPO) HIGH, Anti-thyroglobulin elevated = autoimmune (Hashimoto thyroiditis)
Family: mother Hashimoto + sister type 1 DM', '[{"label":"A","text":"Methimazole"},{"label":"B","text":"Acquired Primary Hypothyroidism (Hashimoto thyroiditis, most common cause peds acquired hypothyroidism): LEVOTHYROXINE replacement starting dose pediatric (~3-5 mcg/kg/d adolescent, lower for younger child age-specific) — start lower in long-standing severe hypothyroidism then titrate up (avoid cardiac arrhythmia / pseudotumor cerebri / accelerated growth/bone age); take EMPTY STOMACH 30-60 min before food + separated from calcium/iron/PPI/soy (interfere absorption); RECHECK TSH + Free T4 q4-6 wk while titrating, then q6-12 mo once stable (TSH lag 6 wk after dose change); target TSH normal range (0.5-4) + Free T4 mid-normal range; INVESTIGATE associated autoimmune conditions (DM1, celiac, Addison, vitiligo, Sjogren, alopecia) + screen family; monitor growth + puberty progression (resume after euthyroid); educate family + child — lifelong condition + medication adherence; long-term — most stable euthyroid on replacement, occasional fluctuation, repeat scan if structural concern (rare cancer in pediatric Hashimoto); psychosocial support — initial mood/cognition affects; consider growth specialist if growth severely impaired; adolescent transition; AVOID — methimazole/PTU (those for hyperthyroidism), surgery (no indication)"},{"label":"C","text":"Iodine high dose"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', 'Hashimoto thyroiditis = most common acquired hypothyroidism kids + adolescents. Levothyroxine replacement + monitoring TSH/Free T4. Screen associated autoimmune. Family history common. Lifelong treatment. Avoid antithyroid agents (those for Graves).', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'PES Pediatric Hypothyroidism Guidelines; AAP Endocrinology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 11 ปี เริ่มเหนื่อยง่าย + ทนหนาวไม่ค่อยได้ + น้ำหนักเพิ่ม 4 kg ใน 6 mo despite same diet + ผลการเรียนลดลง + skin dry + hair coarse + constipation + delayed puberty Tanner 2

V/S: HR 58, BP 102/68, BW 42 kg, growth velocity slowed (4 cm/yr from baseline 6 cm/yr)
PE: diffuse goiter symmetric firm rubbery, dry skin, mild bradycardia, normal reflexes (no delayed relaxation severe yet), proportional growth

Lab: TSH 38 (high), Free T4 0.5 (low), Free T3 low-normal
Anti-thyroid peroxidase (anti-TPO) HIGH, Anti-thyroglobulin elevated = autoimmune (Hashimoto thyroiditis)
Family: mother Hashimoto + sister type 1 DM'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี พ่อแม่สังเกตว่ามี cafe-au-lait macules หลายจุด (8 จุด > 5 mm) + freckling axillary + Lisch nodules iris bilateral (slit-lamp + ในตา) + first-degree relative (พ่อ) มี NF-1

PE: > 6 CAL spots > 5 mm prepubertal, axillary + inguinal freckling, Lisch nodules, no plexiform NF currently, no skeletal deformity, normal development, BW + height normal

Clinical NIH criteria met for NF-1 ( ≥ 2 features)
No malignancy currently, MRI brain + spine pending baseline', '[{"label":"A","text":"No follow-up needed"},{"label":"B","text":"Neurofibromatosis Type 1 (NF1 = autosomal dominant, NF1 gene chromosome 17, ~50% spontaneous mutation) — multispecialty surveillance + management: GENETIC confirmation (NF1 sequencing) + counseling (50% offspring risk + 50% sporadic); MULTIDISCIPLINARY annual evaluation — pediatric neurology + ophthalmology + dermatology + orthopedics + oncology + cardiology + psychology + special education; ANNUAL OPHTHALMOLOGY — Lisch nodules + screen optic pathway glioma (most common CNS tumor NF1, peak 4-6 yr, surveillance MRI annual age 1-7 then if symptoms); annual GROWTH/PUBERTY/BP — early puberty + HT (pheochromocytoma — rare but evaluate if symptoms, renal artery stenosis — important treatable cause HT in NF1); ANNUAL SKIN exam — neurofibromas + plexiform NF (risk MPNST malignant transformation 5-10% lifetime); ANNUAL SKELETAL exam — scoliosis (common, severe + dysplastic), pseudoarthrosis tibia/fibula (typically congenital), sphenoid wing dysplasia; LEARNING DISABILITY 50% — neuropsychology + IEP + school accommodations; MRI brain baseline (most centers) + selective spine; AVOID elective IR + radiation if possible (NF1 = increased second malignancy risk); WATCH/EARLY DETECT — MPNST (Malignant Peripheral Nerve Sheath Tumor) — most common cancer NF1 adolescent/adult — rapid growth, pain, neurological symptoms = workup PET/MRI/biopsy urgent; AML, brain tumors, GIST, leukemia + breast cancer adult women NF1 (earlier screening mammogram 30); selumetinib (MEK inhibitor) FDA-approved for inoperable plexiform NF1 ≥ 2 yr with morbidity — significant benefit; FAMILY support + education + transition adult; pregnancy planning — NF1 women high-risk pregnancy + complications + half offspring inherit"},{"label":"C","text":"Surgery only no follow-up"},{"label":"D","text":"Chemotherapy preventive"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', 'NF1 = AD genetic disorder, multisystem manifestations. NIH criteria. Comprehensive multispecialty annual surveillance for tumor (OPG, MPNST), HT (RAS, pheo), skeletal (scoliosis), cognitive (LD), psychosocial. Selumetinib for plexiform NF. Genetic counseling. Long-term cancer surveillance.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'Children''s Tumor Foundation NF1 Guidelines; AAP Health Supervision NF1', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี พ่อแม่สังเกตว่ามี cafe-au-lait macules หลายจุด (8 จุด > 5 mm) + freckling axillary + Lisch nodules iris bilateral (slit-lamp + ในตา) + first-degree relative (พ่อ) มี NF-1

PE: > 6 CAL spots > 5 mm prepubertal, axillary + inguinal freckling, Lisch nodules, no plexiform NF currently, no skeletal deformity, normal development, BW + height normal

Clinical NIH criteria met for NF-1 ( ≥ 2 features)
No malignancy currently, MRI brain + spine pending baseline'
  );

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
