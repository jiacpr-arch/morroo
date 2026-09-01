-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 2/10
-- Questions 21-40 of 200
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
  s.id, 'board', NULL, 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences', '[{"label":"A","text":"Same dose as adult per body weight"},{"label":"B","text":"Pediatric dosing requires consideration of developmental pharmacokinetics: (1) Absorption — gastric pH higher in neonates (favors penicillin, disfavors weak acids); slower gastric emptying; (2) Distribution — higher % water (neonates 75% water vs adult 60% — increased Vd of water-soluble drugs like aminoglycosides); lower albumin (higher free fraction of bound drugs — bilirubin displacement risk in neonates with ceftriaxone, sulfa); BBB permeable in neonate; (3) Metabolism — CYP450 immature at birth → mature by age 1 (varies); UGT (glucuronidation) immature → ''gray baby syndrome'' with chloramphenicol; (4) Excretion — GFR low at birth, matures by 1 yr → renal drug dose adjustment; (5) Dosing methods: weight-based (mg/kg) for most; body surface area (m²) for chemotherapy; age-band approximations; (6) Special considerations: ceftriaxone CI in neonates < 4 wk (bilirubin displacement + Ca precipitation); chloramphenicol gray baby syndrome; tetracycline tooth/bone deposition < 8 yr; fluoroquinolone cartilage concern; aspirin Reye syndrome with viral illness; codeine/tramadol CI < 12 yr; benzyl alcohol toxicity in preservatives; (7) Always verify dose + use pediatric-specific resources"},{"label":"C","text":"Halve adult dose for all children"},{"label":"D","text":"Pediatric-specific dosing not necessary"},{"label":"E","text":"Use weight only"}]'::jsonb,
  'B', 'Pediatric pharmacology = different from adult due to developmental changes in ADME. Weight-based dosing standard. Special CI: ceftriaxone < 4 wk (bilirubin, Ca), chloramphenicol (gray baby), tetracycline < 8 yr (tooth, bone), fluoroquinolone (cartilage), aspirin + viral illness (Reye), codeine < 12 yr (variable metabolism, respiratory depression). Verify dose meticulously.', NULL,
  'medium', 'procedures', 'review',
  'pediatrics', 'basic_science', 'procedures', 'peds',
  'AAP Pediatric Clinical Pharmacology; Lexicomp Pediatric Drug Information', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถาม physiology — neonatal transitional circulation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Neonatal Transitional Circulation: fetal — high pulmonary vascular resistance (PVR), low systemic vascular resistance (SVR), R→L shunting through ductus arteriosus + foramen ovale + ductus venosus; oxygenation from placenta. AT BIRTH: (1) First breath expands lungs → ↓PVR + ↑oxygenation → pulmonary blood flow increases; (2) Cord clamping → loss of placental low-resistance circuit → ↑SVR; (3) Increased pulmonary venous return → ↑LA pressure → functional closure of foramen ovale (anatomic 3 mo-1 yr); (4) Higher PaO2 + ↓ prostaglandins → functional closure of ductus arteriosus (anatomic by 2-3 weeks); (5) Ductus venosus closes when umbilical flow stops; (6) Persistent fetal circulation (PPHN — persistent pulmonary HT of newborn) if PVR fails to drop — causes: meconium aspiration, sepsis, RDS, congenital diaphragmatic hernia — Rx: 100% O2, sedation, mechanical vent, iNO (selective pulmonary vasodilator), milrinone, ECMO; ductal-dependent CHD (HLHS, critical AS/PS, TGA, Tricuspid atresia) — PGE1 maintains PDA until surgery"},{"label":"C","text":"No transition occurs"},{"label":"D","text":"PDA never closes"},{"label":"E","text":"Foramen ovale always patent"}]'::jsonb,
  'B', 'Neonatal transition: fetal R→L shunts + high PVR → newborn L→R adult circulation. Trigger: first breath + cord clamping. PVR drops, SVR rises, shunts close. PPHN if PVR fails to drop (iNO, ECMO). Ductal-dependent CHD: PGE1 maintains PDA (HLHS, critical AS/PS, TGA, Tricuspid atresia). PPS (peripheral pulmonary stenosis) common in newborns from incomplete transition — benign murmur usually.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'basic_science', 'cardiovascular', 'peds',
  'Nelson Textbook of Pediatrics 22nd ed Ch. 461; Avery''s Diseases of the Newborn 11th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Resident ถาม physiology — neonatal transitional circulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย immunology — infant immune system + vaccine response', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Infant immune system maturation: (1) Innate: present at birth but qualitatively + quantitatively immature; (2) Adaptive: passive (maternal IgG transplacentally — protects 6 mo, wanes), active maturing; (3) Maternal IgG falls 6-9 mo while infant own immune building → ''physiologic hypogammaglobulinemia'' (6-9 mo nadir) → susceptibility window; (4) IgA in breast milk — mucosal protection; (5) IgM appears first to new antigen; IgG class switching; (6) T-cell response immature — Th2-biased — atopy susceptibility; (7) Vaccine response: live attenuated (MMR, varicella, rotavirus, BCG) need cellular immunity — given after 6 mo; inactivated/subunit/conjugate (DTaP, Hib, PCV13, Hepatitis B, polio IPV) — given starting birth/2 mo; conjugate vaccines (PCV, Hib, MenACWY) — conjugate protein to polysaccharide for T-cell-dependent response in infants; (8) Polysaccharide unconjugated vaccines (pneumovax 23) poorly immunogenic < 2 yr — give after 2 yr; (9) Live vaccines CI in pregnant, severe immunodeficiency, recent IVIG (delay 11 mo for MMR/varicella)"},{"label":"C","text":"Adults respond same as infants"},{"label":"D","text":"No need for vaccination"},{"label":"E","text":"Single dose universal"}]'::jsonb,
  'B', 'Infant immune system immature + Th2-biased. Maternal IgG protects ~ 6 mo then wanes. Live vaccines after 6-12 mo (cellular immunity needed). Conjugate vaccines key — convert T-independent polysaccharide to T-dependent (PCV, Hib, MenACWY) — effective in infants. Unconjugated polysaccharide (PPSV23) ineffective < 2 yr. Maternal vaccination (Tdap pregnancy, RSV, COVID, influenza) → passive transfer protects infant. Live vaccines CI in pregnancy + immunocompromised.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'CDC Recommended Immunization Schedule; AAP Red Book 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย immunology — infant immune system + vaccine response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Pediatric Fluid Management: (1) Maintenance fluid ''4-2-1 rule'' (Holliday-Segar): 4 mL/kg/hr first 10 kg + 2 mL/kg/hr next 10 kg + 1 mL/kg/hr each additional kg (e.g., 25 kg child = 40 + 20 + 5 = 65 mL/hr); (2) Maintenance fluid composition: isotonic — D5 NS preferred over D5 0.45 NS (Cochrane evidence — hypotonic causes iatrogenic hyponatremia, especially in ill children) — AAP 2018 endorse isotonic; (3) Resuscitation: NSS or LR 20 mL/kg bolus over 15-30 min for shock, may repeat × 2-3 then assess + consider blood/colloid; (4) Dehydration assessment: mild (3-5%), moderate (6-9% — sunken eyes, dry MM, decreased turgor, prolonged capillary refill, tachycardia), severe (≥ 10% — lethargic, sunken fontanelle, very poor perfusion, hypotension late sign in peds); (5) Replacement: 50% deficit + maintenance over first 8h, remaining 50% over next 16h; oral rehydration solution (ORS) preferred for mild-moderate (cheaper, safer, effective); (6) Electrolyte considerations: K based on serum + UO; correct Na slowly (max 10-12 mEq/L/d to avoid central pontine myelinolysis); (7) Special situations: DKA (cautious slow fluid as discussed), burns (Parkland formula for kids), neonatal (different calculations)"},{"label":"C","text":"8-4-2 rule"},{"label":"D","text":"Always restrict fluid"},{"label":"E","text":"Adult formula"}]'::jsonb,
  'B', 'Pediatric fluid management essential skill. 4-2-1 rule (Holliday-Segar 1957) for maintenance. AAP 2018 + NEJM 2018 (Friedman): isotonic preferred over hypotonic (less iatrogenic hyponatremia, esp ill children). 20 mL/kg bolus for shock (can repeat). Replace deficit over 24h (DKA 48h slower). ORS for mild-moderate dehydration. Cautions: rapid Na correction (CPM), DKA cerebral edema, neonatal special, burns Parkland. Frequent re-assessment + adjustment.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'basic_science', 'renal_gu', 'peds',
  'AAP Clinical Practice Guideline: Maintenance IV Fluids in Children 2018 (Feld LG et al.); Holliday MA, Segar WE. Pediatrics 1957', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics', '[{"label":"A","text":"Single intervention solves all"},{"label":"B","text":"Comprehensive Child Health Program — multi-level intervention: (1) Antenatal: maternal nutrition + iron + folate, vaccination (Tdap, flu, COVID, RSV maternal), screening (gestational diabetes, group B Strep), education; (2) Intrapartum: skilled birth attendant, group B Strep prophylaxis if indicated, immediate skin-to-skin contact, delayed cord clamping (1-3 min — improves iron stores), early breastfeeding initiation; (3) Newborn: routine care (vitamin K, eye prophylaxis, hepatitis B vaccine), newborn screening (heel prick — congenital hypothyroidism, PKU, sickle cell, CF, etc.), pulse oximetry screening (critical CHD), hearing screening; (4) Well-child visits at scheduled intervals: growth + development monitoring, anticipatory guidance, vaccinations per CDC/local schedule, screening (lead, anemia, vision, hearing, autism, depression in adolescents); (5) Vaccination: universal + catch-up programs, education, address vaccine hesitancy, school requirements; (6) Nutrition: breastfeeding promotion (6 mo exclusive), complementary feeding 6 mo, micronutrient programs (iron, vitamin D, vitamin A), school meal programs; (7) Safety: car seats, helmets, water safety, firearm storage, lead paint; (8) Mental health: screening, school-based programs, family support; (9) Equity: address social determinants (food security, housing, education access); (10) Quality metrics: infant mortality, vaccination coverage, well-child visit completion, screening uptake, hospitalization rates"},{"label":"C","text":"Adult medicine principles only"},{"label":"D","text":"Ignore prevention"},{"label":"E","text":"Single specialty manages"}]'::jsonb,
  'B', 'Comprehensive child health — life-course approach + multi-level intervention. WHO + AAP + CDC frameworks. Key components: antenatal, intrapartum, newborn screening + immunization, well-child visits, anticipatory guidance, safety, mental health, equity. Quality metrics: infant mortality (key indicator), vaccination coverage, screening uptake. Social determinants of health critical. Multidisciplinary + multi-level. Thailand: maternal + child health policy improved outcomes significantly past decades.', NULL,
  'easy', 'signs_symptoms', 'review',
  'pediatrics', 'ems_mgmt', 'signs_symptoms', 'peds',
  'WHO Reproductive Maternal Newborn Child + Adolescent Health Strategy; AAP Bright Futures Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations', '[{"label":"A","text":"Same as adult bundle"},{"label":"B","text":"Pediatric CLABSI Prevention Bundle: similar adult core (hand hygiene, max barrier, chlorhexidine ≥ 0.5% in alcohol > 2 mo old, site selection — IJ or subclavian preferred over femoral in non-emergent, daily review) + pediatric-specific: (1) Use of central lines minimized — peripheral IV when possible, midline if longer duration; (2) Catheter selection by size + child size (different small catheters); (3) Site selection: in infants/children — IJ often easier than subclavian; femoral acceptable in PICU/post-op cardiac (less infection difference than adults); (4) Insertion checklist + observer; (5) Chlorhexidine bathing daily in PICU (less convincing evidence than adults); (6) Dressing change protocols (transparent q7d or per soil); (7) Hub disinfection (\"scrub the hub\"); (8) Daily review of necessity — early removal; (9) Antimicrobial-impregnated catheters in selected; (10) Education + ongoing competency assessment; (11) PICU-specific: TPN line designation, sepsis surveillance; (12) Family education + engagement; (13) Tracking + feedback: CLABSI rate per 1000 catheter-days; (14) Multidisciplinary: physicians, nurses, infection prevention, family"},{"label":"C","text":"Avoid all central lines"},{"label":"D","text":"Use all femoral lines"},{"label":"E","text":"No prevention needed in children"}]'::jsonb,
  'B', 'Pediatric CLABSI prevention — similar core to adult bundle (Pronovost Keystone applies) + pediatric considerations: smaller catheters, site preference varies, chlorhexidine after 2 mo old, family engagement. Pediatric ICU CLABSI lower with bundle implementation (Miller MR Pediatrics 2010 — 40% reduction). Modern: family-centered care, technology, electronic surveillance. Continuous improvement + audit + feedback critical.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'Miller MR et al. Pediatrics 2010 (PICU CLABSI Bundle); CDC HICPAC + PIDS Guidelines for Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes', '[{"label":"A","text":"Exclude families from care decisions"},{"label":"B","text":"Family-Centered Care (FCC) in pediatric/PICU — partnership with families improves outcomes: (1) Core principles (Institute for Patient + Family-Centered Care): respect + dignity, information sharing, participation, collaboration; (2) Open visitation 24/7 + family at bedside; (3) Family rounds — daily bedside multidisciplinary rounds including family + child (age-appropriate); (4) Shared decision-making — values, goals, options discussed; (5) Family presence during procedures + resuscitation (AHA + AAP endorse); (6) Parental + caregiver role: comfort, education, advocacy, observation; (7) Sibling support + visitation; (8) Cultural + linguistic competence — interpreters, cultural understanding; (9) Discharge planning involves family early; (10) Family advisory councils — family input on hospital policies + design; (11) Education programs + support groups; (12) Bereavement care for family if child dies; (13) Outcome measures: family satisfaction, length of stay, readmission, error rates (reduced when family engaged), staff satisfaction; (14) Evidence: family presence at resuscitation reduces PTSD in family + does not impair care (Compassionate Connected Care, Doyle Crit Care Med); FCC reduces LOS, complications, costs (Cooper RL Crit Care Med)"},{"label":"C","text":"Visit only 2 hours/day"},{"label":"D","text":"Decisions by physicians alone"},{"label":"E","text":"No family communication"}]'::jsonb,
  'B', 'FCC = evidence-based partnership with families. Core: respect, information, participation, collaboration. Reduces LOS, complications, PTSD, increases satisfaction. Family-centered rounds, presence during resuscitation, shared decision-making, cultural competence. IPFCC framework. AAP, AHA endorse. Modern pediatric care unimaginable without family partnership.', NULL,
  'easy', 'psych_behavior', 'review',
  'pediatrics', 'ems_mgmt', 'psych_behavior', 'peds',
  'Institute for Patient + Family-Centered Care; Committee on Hospital Care + IPFCC. Patient + Family-Centered Care + the Pediatrician''s Role 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management', '[{"label":"A","text":"Chemotherapy only by oncologist"},{"label":"B","text":"Pediatric Cancer Integrative Multidisciplinary Care: (1) Oncology team: pediatric hematology-oncology, treatment protocol per COG/UKALL/equivalent; (2) Treatment: induction → consolidation → maintenance for ALL; risk-stratified (cytogenetics, MRD); intrathecal therapy + cranial RT (selected) for CNS prophylaxis; (3) Supportive: tumor lysis syndrome prevention (hydration, allopurinol, rasburicase for high risk), febrile neutropenia management (empirical broad antibiotic within 1h), antifungal prophylaxis selected, antiviral if needed, transfusion support, growth factors (G-CSF); (4) Multidisciplinary team: oncology, infectious disease, nutritionist, PT/OT, psychology, child life, social work, chaplain, school liaison, primary pediatrician coordination; (5) Family support: shared decision-making, anticipatory guidance, sibling support, financial counseling (treatment expensive), respite care; (6) Child life specialist: developmentally appropriate education, coping, distraction, procedural support; (7) School re-integration: maintain education, home/hospital schooling, school nurse coordination, transition back; (8) Long-term survivorship: 90% 5-year survival ALL — surveillance for late effects (secondary malignancy, cardiotoxicity, growth, fertility, cognitive, psychosocial); transition to adult survivor clinic; (9) Palliative care concurrent — improves QOL even in curative intent; (10) End-of-life care if treatment fails — pediatric palliative + hospice integration"},{"label":"C","text":"Refuse all support"},{"label":"D","text":"Single specialist"},{"label":"E","text":"Ignore long-term effects"}]'::jsonb,
  'B', 'Pediatric cancer = integrative + multidisciplinary + family-centered. ALL 90% 5-year survival modern. Treatment phases. Risk-stratified (MRD, cytogenetics). Supportive care critical (febrile neutropenia, tumor lysis, transfusions). Multidisciplinary team. Family support essential. Long-term survivorship: late effects screening, transition to adult care. Palliative care concurrent (improves QOL + may extend life). Modern pediatric oncology highly integrated.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'integrative', 'hemato_onco', 'peds',
  'Children''s Oncology Group Protocols; AAP + ASCO Pediatric Cancer Survivorship; ChIPS — Children''s International Project on Palliative + Hospice Services', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity', '[{"label":"A","text":"Abrupt transfer at 18"},{"label":"B","text":"Adolescent Transition to Adult Care (integrative + planned process): (1) Begin transition planning in early adolescence (age 12-14) — not abrupt at 18; (2) Joint pediatric + adult provider coordination — written transition plan, shared records; (3) Self-management skills development: medication knowledge + administration, appointment scheduling, insurance navigation, recognizing warning signs, communication with providers; (4) Address adolescent-specific issues: sexuality + reproductive health, mental health (depression, anxiety, substance use higher in chronic illness), school/career planning, peer relationships, identity + autonomy; (5) Family role evolution — from primary decision-maker to support; (6) Confidentiality + assent/consent transition; (7) Specific concerns by condition (DM, CF, cancer survivor, congenital heart, sickle cell, IBD, transplant); (8) Insurance + legal: medical decision-making, conservatorship if cognitive impairment, transition of insurance; (9) Multidisciplinary support: adolescent medicine, social work, mental health, primary care; (10) Outcome metrics: continuity of care, no gap, adherence, satisfaction; (11) Got Transition + Six Core Elements framework (national approach); (12) Special populations: developmental disabilities, autism (specialized adult providers limited), cognitive impairment, complex care"},{"label":"C","text":"Pediatric care for life"},{"label":"D","text":"Ignore transition needs"},{"label":"E","text":"Discharge from all care"}]'::jsonb,
  'B', 'Adolescent transition to adult care = critical integrative process. Begin early, planned, not abrupt. Six Core Elements (Got Transition): transition policy, tracking, readiness, planning, transfer, completion. Self-management skill building. Adolescent-specific issues. Family + autonomy balance. Multidisciplinary. Specific to condition (CF, DM, sickle cell, transplant, complex care). Outcomes: continuity, adherence. Gap in transition = poor outcomes. Modern: ''Got Transition'' national framework + AAP/AAFP/ACP joint clinical report.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP/AAFP/ACP Clinical Report: Transitions Clinical Report 2018; Got Transition / National Alliance to Advance Adolescent Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care', '[{"label":"A","text":"Discharge from all follow-up"},{"label":"B","text":"Premature Infant Follow-up (NICU Graduate) — Integrative Multidisciplinary: (1) High-risk infant follow-up clinic (HRIF): developmental assessment, growth, neurological at scheduled intervals up to 2-3 years (corrected age); (2) Subspecialty care: pulmonology (BPD/CLD — chronic lung disease, RSV prophylaxis with palivizumab, weaning O2 home), ophthalmology (ROP — retinopathy of prematurity, follow-up), cardiology (PDA, congenital concerns), neurology (IVH, PVL, hydrocephalus), GI (NEC, feeding difficulties); (3) Developmental: PT, OT, speech therapy, early intervention services (IDEA Part C), assessments (Bayley, AIMS); (4) Nutrition: high-calorie formulas, fortification, weight gain monitoring, feeding therapy; (5) Vaccination: catch-up schedule + RSV prophylaxis (palivizumab) for high-risk; (6) Hearing + vision screening + monitoring; (7) Family support: parental mental health (high postpartum depression + PTSD risk), sibling support, financial counseling (NICU costs, ongoing care), respite care; (8) Coordinate care: medical home with primary pediatrician + specialty consults; (9) Long-term: school readiness assessment, IEP if developmental delays, transition planning; (10) Outcomes: many achieve typical development; some have lasting disabilities — early intervention improves outcomes; family-centered support throughout; corrected age use until 2 yr for milestones"},{"label":"C","text":"Single specialty manages all"},{"label":"D","text":"Refuse early intervention"},{"label":"E","text":"Use chronological age only"}]'::jsonb,
  'B', 'NICU graduate follow-up = quintessentially integrative. High-Risk Infant Follow-up clinic standard model. Subspecialty care (pulm, ophtho, cardio, neuro, GI, dev). Early intervention essential — improves outcomes. Family-centered + corrected age use until 2 yr. Long-term outcomes variable — modern care + interventions improve trajectory. Family support critical (parental MH, finances, social). AAP + March of Dimes guidelines. Outcomes registry data informs care.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'integrative', 'respiratory', 'peds',
  'AAP Section on Perinatal Pediatrics; Follow-up Care of High-Risk Infants 2008 + updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกเกิดก่อนกำหนด GA 30 wk BW 1,400 g คลอด emergency C/S จากแม่ chorioamnionitis ทารกหายใจหอบเหนื่อยตั้งแต่ 30 นาทีหลังคลอด grunting + retraction

V/S: HR 168, RR 78, SpO2 84% room air, Temp 36.4°C
Gen: cyanosis central, severe subcostal + intercostal retraction, nasal flaring, expiratory grunting
CXR: bilateral diffuse ground-glass + air bronchogram + low lung volume', '[{"label":"A","text":"Discharge with home O2"},{"label":"B","text":"Neonatal RDS (surfactant deficiency): warm + dry + INSURE หรือ early CPAP+selective surfactant; ให้ surfactant (poractant alfa 200 mg/kg หรือ beractant 100 mg/kg) intratracheal ภายใน 2 ชม; nCPAP 5-6 cmH2O เป็น first-line; intubate ถ้า FiO2 > 0.4 + persistent distress; antenatal steroid ถ้ารู้ก่อนคลอด; antibiotic ครอบคลุม sepsis (ampicillin+gentamicin) เพราะ chorioamnionitis; thermoregulation + nutrition + monitor PDA/IVH/ROP/BPD"},{"label":"C","text":"Diuretic only"},{"label":"D","text":"Restrict oxygen completely"},{"label":"E","text":"Oral antibiotic outpatient"}]'::jsonb,
  'B', 'RDS = ภาวะที่พบบ่อยที่สุดในทารกเกิดก่อนกำหนด เกิดจาก surfactant deficiency. ESPR 2023 guideline เน้น less invasive surfactant administration (LISA/MIST) + nCPAP. Antenatal steroid ลด RDS, IVH, death อย่างมีนัยสำคัญ. Caffeine สำหรับ AOP. Antibiotic ครอบคลุม early-onset sepsis ในเด็กที่แม่มี chorioamnionitis.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'European Consensus Guidelines on the Management of RDS 2023 (Sweet DG et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกเกิดก่อนกำหนด GA 30 wk BW 1,400 g คลอด emergency C/S จากแม่ chorioamnionitis ทารกหายใจหอบเหนื่อยตั้งแต่ 30 นาทีหลังคลอด grunting + retraction

V/S: HR 168, RR 78, SpO2 84% room air, Temp 36.4°C
Gen: cyanosis central, severe subcostal + intercostal retraction, nasal flaring, expiratory grunting
CXR: bilateral diffuse ground-glass + air bronchogram + low lung volume'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก preterm GA 28 wk BW 950 g อายุ 14 วัน เริ่ม feed breast milk + fortifier ได้ดี วันนี้มี abdominal distension + bilious vomiting + bloody stool + lethargy + temperature instability

V/S: HR 188, RR 72, SpO2 92%, BP 52/30, Temp 35.8°C
Abd: distended, erythema abdominal wall, absent bowel sounds, tenderness

CBC: WBC 4,200 (left shift), Plt 68,000, Hb 9.2
Lactate 5.8, metabolic acidosis pH 7.21
AXR: pneumatosis intestinalis + portal venous gas', '[{"label":"A","text":"Continue feed + observation"},{"label":"B","text":"Necrotizing Enterocolitis Bell stage IIB-III: NPO ทันที + NG decompression + IV fluid resuscitation + broad-spectrum antibiotic (ampicillin + gentamicin + metronidazole or piperacillin-tazobactam) × 7-14 วัน; bowel rest 7-14 วัน; serial AXR q6h หา pneumoperitoneum; surgical consultation; indications surgery: perforation, fixed loop, clinical deterioration; TPN; correct coagulopathy; platelet transfusion ถ้า < 50,000 + bleeding; long-term watch for strictures + short bowel syndrome"},{"label":"C","text":"Increase feed volume"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral antibiotic only"}]'::jsonb,
  'B', 'NEC = leading cause GI emergency + mortality ใน preterm. Bell staging guides management. Pneumatosis intestinalis = pathognomonic. Portal venous gas = severe. Surgery for perforation/clinical deterioration. Prevention: breast milk feeding, slow advancement, probiotics (selected populations), antenatal steroid.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Clinical Report on NEC 2022; Neu J. NEJM 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก preterm GA 28 wk BW 950 g อายุ 14 วัน เริ่ม feed breast milk + fortifier ได้ดี วันนี้มี abdominal distension + bilious vomiting + bloody stool + lethargy + temperature instability

V/S: HR 188, RR 72, SpO2 92%, BP 52/30, Temp 35.8°C
Abd: distended, erythema abdominal wall, absent bowel sounds, tenderness

CBC: WBC 4,200 (left shift), Plt 68,000, Hb 9.2
Lactate 5.8, metabolic acidosis pH 7.21
AXR: pneumatosis intestinalis + portal venous gas'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด term GA 39 wk BW 3,200 g คลอด NL แม่ GBS positive ไม่ได้ intrapartum antibiotic prophylaxis อายุ 18 ชม มี temperature instability + poor feeding + tachypnea + grunting

V/S: HR 178, RR 72, Temp 38.4°C, SpO2 94%
Gen: lethargic, mottled skin, capillary refill 4 sec, mild jaundice

CBC: WBC 28,500 (immature/total 0.3), Plt 110,000, CRP 65
Glucose 45, ABG mild metabolic acidosis', '[{"label":"A","text":"Observation only"},{"label":"B","text":"Early-onset neonatal sepsis (likely GBS — inadequate IAP): blood culture + LP + UA + CBC ก่อนให้ antibiotic; empiric Ampicillin 150 mg/kg/dose q12h IV + Gentamicin 4 mg/kg/dose q24h IV; resuscitation fluid 10-20 mL/kg NSS bolus careful; correct glucose + electrolytes; meningitis dose ถ้า LP +; duration: 10 d bacteremia, 14-21 d meningitis (GBS); supportive: thermoregulation, ventilation, vasopressor ถ้า shock"},{"label":"C","text":"Antibiotic oral outpatient"},{"label":"D","text":"Discharge with follow-up"},{"label":"E","text":"IVIG only without antibiotic"}]'::jsonb,
  'B', 'Early-onset sepsis (EOS) < 72 ชม. GBS = most common pathogen. Inadequate IAP = risk factor. Kaiser EOS calculator + CDC 2010/2019 guidance. Always rule out meningitis. Antibiotic timing critical. Long-term: developmental follow-up.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP COFN/COID Clinical Report: Management of Neonates at Risk for Early-Onset Sepsis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด term GA 39 wk BW 3,200 g คลอด NL แม่ GBS positive ไม่ได้ intrapartum antibiotic prophylaxis อายุ 18 ชม มี temperature instability + poor feeding + tachypnea + grunting

V/S: HR 178, RR 72, Temp 38.4°C, SpO2 94%
Gen: lethargic, mottled skin, capillary refill 4 sec, mild jaundice

CBC: WBC 28,500 (immature/total 0.3), Plt 110,000, CRP 65
Glucose 45, ABG mild metabolic acidosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 4 BW 3,400 g (BW birth 3,500 g, weight loss 2.8%) breastfeeding มา check up พบตัวเหลือง

V/S ปกติ Temp 36.8°C
Gen: jaundice ถึง knees, alert, feed ดี

Total bilirubin 18.2 mg/dL (direct 0.8), Hb 14.5, Hct 44, blood group: mother O+, baby A+
Coombs test: weakly positive
Reticulocyte 4.2%', '[{"label":"A","text":"Observe only"},{"label":"B","text":"Hyperbilirubinemia + ABO incompatibility (Coombs+): plot on AAP 2022 nomogram by gestational age + risk factors → bilirubin 18.2 at 96h + neuroToxicity risk factors = phototherapy threshold; intensive phototherapy (450-500 nm blue-green LED, body surface > 80%); continue breastfeeding, supplement formula ถ้า dehydration; recheck TSB q6-12h; exchange transfusion ถ้า > exchange threshold หรือ ABE signs; investigate G6PD ในเด็กเอเชีย; IVIG ถ้า isoimmune + rising despite phototherapy; follow-up 24-48h post-discharge"},{"label":"C","text":"Exchange transfusion immediately"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"Discharge home without phototherapy"}]'::jsonb,
  'B', 'AAP 2022 updated nomogram: integrates GA, age in hours, neurotoxicity risk factors (isoimmune disease, G6PD, sepsis, albumin < 3, asphyxia). ABO incompatibility = mild hemolysis. Intensive phototherapy = mainstay. Bilirubin encephalopathy = preventable cause of kernicterus.', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Practice Guideline Revision: Hyperbilirubinemia 2022 (Kemper AR et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 4 BW 3,400 g (BW birth 3,500 g, weight loss 2.8%) breastfeeding มา check up พบตัวเหลือง

V/S ปกติ Temp 36.8°C
Gen: jaundice ถึง knees, alert, feed ดี

Total bilirubin 18.2 mg/dL (direct 0.8), Hb 14.5, Hct 44, blood group: mother O+, baby A+
Coombs test: weakly positive
Reticulocyte 4.2%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 40 wk meconium-stained fluid + low Apgar (3, 5) อายุ 4 ชม หอบเหนื่อยมาก + cyanosis + เริ่มต้องการ FiO2 100%

V/S: HR 178, RR 75, SpO2 right hand 92% / right foot 78% (pre/post-ductal differential 14%)

ABG (FiO2 1.0): pH 7.22, PaO2 42, PaCO2 58
CXR: clear lung field, normal heart size
Echo: tricuspid regurgitation jet velocity high, RV pressure 65 mmHg + R→L shunting at PFO + PDA', '[{"label":"A","text":"Decrease FiO2 to 21%"},{"label":"B","text":"Persistent Pulmonary Hypertension Newborn (PPHN, MAS-related): optimize ventilation + oxygenation (SpO2 95-99%, target PaO2 60-80, gentle ventilation, avoid hypocapnia); correct acidosis + hypoglycemia + hypocalcemia; surfactant ถ้า MAS/parenchymal disease; inhaled Nitric Oxide (iNO) 20 ppm first-line pulmonary vasodilator; sedation (fentanyl) เพื่อลด stress + pulmonary vasoconstriction; vasopressor (milrinone, sildenafil) ถ้า iNO ไม่พอ; ECMO ถ้า refractory (OI > 25-40); avoid hyperoxia; transfer to ECMO center"},{"label":"C","text":"Discharge home with oxygen"},{"label":"D","text":"Stop oxygen entirely"},{"label":"E","text":"Beta blocker"}]'::jsonb,
  'B', 'PPHN = failure of normal postnatal fall in PVR → R→L shunt → hypoxemia. Differential SpO2 (pre > post) = key clinical sign. iNO + gentle ventilation + supportive care. ECMO for refractory cases. Common causes: MAS, sepsis, RDS, congenital diaphragmatic hernia, idiopathic.', NULL,
  'hard', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Report: Use of Inhaled Nitric Oxide 2014; PPHN Network Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 40 wk meconium-stained fluid + low Apgar (3, 5) อายุ 4 ชม หอบเหนื่อยมาก + cyanosis + เริ่มต้องการ FiO2 100%

V/S: HR 178, RR 75, SpO2 right hand 92% / right foot 78% (pre/post-ductal differential 14%)

ABG (FiO2 1.0): pH 7.22, PaO2 42, PaCO2 58
CXR: clear lung field, normal heart size
Echo: tricuspid regurgitation jet velocity high, RV pressure 65 mmHg + R→L shunting at PFO + PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 38 wk BW 3,400 g คลอด NL Apgar 8/9 อายุ 6 ชม cyanosis ทั่วตัวไม่ดีขึ้นด้วย O2

V/S: HR 158, RR 62, SpO2 right hand 75% / right foot 78%
Gen: marked central cyanosis ที่ไม่ตอบสนองต่อ O2, mild distress, no murmur
Hyperoxia test: PaO2 < 100 บน FiO2 100%

CXR: ''egg on string'', cardiomegaly, increased pulmonary vascularity
Echo: D-Transposition of Great Arteries (D-TGA) + small PFO + small PDA', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"D-TGA emergency: Prostaglandin E1 infusion 0.05-0.1 mcg/kg/min IV ทันที (เปิด PDA เพื่อ allow mixing) + balloon atrial septostomy (Rashkind) ภายใต้ echo ในห้อง cath เพื่อขยาย atrial communication; cardiology + cardiac surgery consultation; transfer to cardiac center; correct metabolic acidosis + glucose; avoid hyperoxia (สามารถปิด PDA); ventilation as needed; arterial switch operation (Jatene) ภายใน 2 weeks of life (เพราะ LV regression); long-term cardiology follow-up"},{"label":"C","text":"Beta blocker only"},{"label":"D","text":"100% oxygen alone resolves"},{"label":"E","text":"Heart transplant immediately"}]'::jsonb,
  'B', 'D-TGA = most common cyanotic CHD presenting in newborn. Cyanosis refractory to O2 = key sign. PGE1 keeps PDA open for mixing. BAS expands intra-atrial mixing. Definitive: arterial switch within 2 weeks. Hyperoxia test (PaO2 < 100 on 100% O2) suggests cyanotic CHD.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC Guideline for Management of Adults With Congenital Heart Disease 2018; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 38 wk BW 3,400 g คลอด NL Apgar 8/9 อายุ 6 ชม cyanosis ทั่วตัวไม่ดีขึ้นด้วย O2

V/S: HR 158, RR 62, SpO2 right hand 75% / right foot 78%
Gen: marked central cyanosis ที่ไม่ตอบสนองต่อ O2, mild distress, no murmur
Hyperoxia test: PaO2 < 100 บน FiO2 100%

CXR: ''egg on string'', cardiomegaly, increased pulmonary vascularity
Echo: D-Transposition of Great Arteries (D-TGA) + small PFO + small PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 5 lethargic, ดูดนมไม่ดี, ขาเย็น, มา ED

V/S: BP right arm 95/62, BP right leg 60/38 (gradient 35 mmHg), HR 168, RR 68, SpO2 96% right hand / 90% right foot
PE: weak femoral pulses bilateral, brachial-femoral delay, mild hepatomegaly, no murmur

CXR: cardiomegaly + pulmonary edema
Echo: severe juxtaductal coarctation of aorta + bicuspid aortic valve + LV dysfunction, closing PDA', '[{"label":"A","text":"Observe + recheck pulses tomorrow"},{"label":"B","text":"Critical/Ductal-dependent Coarctation of Aorta: Prostaglandin E1 0.05-0.1 mcg/kg/min IV infusion ทันที (เปิด PDA ฟื้น systemic perfusion); resuscitation + inotropic support (milrinone, dopamine) ถ้า shock; correct metabolic acidosis + hypoglycemia + hypocalcemia; broad-spectrum antibiotic หา sepsis; intubation + ventilation ถ้า respiratory failure; urgent cardiology + cardiac surgery referral; surgical repair (end-to-end, subclavian flap, balloon angioplasty); long-term BP monitoring (residual HT common)"},{"label":"C","text":"Antihypertensive medication only"},{"label":"D","text":"Discharge with diuretic"},{"label":"E","text":"Heart transplant"}]'::jsonb,
  'B', 'Critical coarctation = ductal-dependent. Presents shock as PDA closes (DOL 3-7). BP gradient + weak femoral pulses = classic. PGE1 = lifesaving. Associated bicuspid AV, VSD. Long-term sequelae: residual HT, re-coarctation, aortic dissection.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA 2018 Guideline Adult CHD; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 5 lethargic, ดูดนมไม่ดี, ขาเย็น, มา ED

V/S: BP right arm 95/62, BP right leg 60/38 (gradient 35 mmHg), HR 168, RR 68, SpO2 96% right hand / 90% right foot
PE: weak femoral pulses bilateral, brachial-femoral delay, mild hepatomegaly, no murmur

CXR: cardiomegaly + pulmonary edema
Echo: severe juxtaductal coarctation of aorta + bicuspid aortic valve + LV dysfunction, closing PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี ไข้ + ไอ + หอบเหนื่อย 3 วัน ไม่มี wheeze, vaccine ครบ

V/S: HR 152, RR 58, SpO2 91% room air, Temp 39.4°C, BW 14 kg
Gen: alert, mild distress, decreased breath sound + crackles + bronchial breath right lower lobe

CBC: WBC 18,200 (PMN 78%), CRP 158
CXR: right lower lobe consolidation + small parapneumonic effusion', '[{"label":"A","text":"Outpatient azithromycin"},{"label":"B","text":"Pediatric Community-Acquired Pneumonia (likely Strep pneumoniae): IV Ampicillin 50 mg/kg/dose q6h (200 mg/kg/d) เป็น first-line ใน fully immunized child + hospitalized + moderate severity; O2 ให้ SpO2 ≥ 92%; IV fluid maintenance + antipyretic; ถ้า effusion มาก + clinical worse → US chest + drainage + culture; switch oral amoxicillin เมื่อ stable + afebrile 24-48h; duration total 7-10 d; วัคซีน PCV13 + influenza; macrolide ถ้า atypical (Mycoplasma, Chlamydia)"},{"label":"C","text":"Discharge home no antibiotic"},{"label":"D","text":"Antifungal first-line"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', 'PIDS/IDSA 2011 guideline: ampicillin first-line for hospitalized peds CAP (Spn). PCV13 reduced Spn rates. Add macrolide if atypical suspected. Severity: hypoxia, RR, retractions, oral intake guide hospitalization. Effusion → drainage if large/empyema.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'PIDS/IDSA Guidelines: Management of CAP in Children 2011 (Bradley JS et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี ไข้ + ไอ + หอบเหนื่อย 3 วัน ไม่มี wheeze, vaccine ครบ

V/S: HR 152, RR 58, SpO2 91% room air, Temp 39.4°C, BW 14 kg
Gen: alert, mild distress, decreased breath sound + crackles + bronchial breath right lower lobe

CBC: WBC 18,200 (PMN 78%), CRP 158
CXR: right lower lobe consolidation + small parapneumonic effusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 7 ปี known asthma มา ED ด้วยอาการหอบเหนื่อย ไอ wheeze หลังเจอแมว 2 ชม ก่อน ใช้ albuterol MDI ที่บ้าน 4 puff ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 89% room air, BW 25 kg
Gen: speaking single words, marked accessory muscle use, audible wheeze, prolonged expiration
PEFR 35% predicted', '[{"label":"A","text":"Antibiotic + discharge"},{"label":"B","text":"Severe asthma exacerbation (GINA 2024): O2 to SpO2 94-98% (kids); albuterol nebulized 2.5-5 mg q20 min × 3 หรือ continuous + ipratropium 250-500 mcg ผสมใน first 3 doses; systemic corticosteroid early — oral prednisolone 1-2 mg/kg (max 60 mg) ภายใน 1 ชม; magnesium sulfate IV 25-50 mg/kg (max 2 g) over 20 min ถ้า refractory; reassess PEFR, work of breathing, SpO2 q15-30 min; IV terbutaline หรือ ICU + ventilation ถ้า impending failure; admit ถ้า incomplete response; discharge plan: action plan, ICS, follow-up 1-2 wk, trigger avoidance"},{"label":"C","text":"Sedative only"},{"label":"D","text":"Restrict fluid"},{"label":"E","text":"IV diuretic"}]'::jsonb,
  'B', 'GINA 2024 + AAP: ABC ไปก่อน. Early systemic steroid critical (delay = worse outcome). Mg sulfate for severe/refractory. Avoid sedatives (mask deterioration). ICU/intubation for impending respiratory failure (silent chest, exhaustion, CO2 normalizing/rising = late). Long-term: ICS + action plan + trigger control.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'GINA Global Strategy 2024; AAP Section on Allergy/Asthma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 7 ปี known asthma มา ED ด้วยอาการหอบเหนื่อย ไอ wheeze หลังเจอแมว 2 ชม ก่อน ใช้ albuterol MDI ที่บ้าน 4 puff ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 89% room air, BW 25 kg
Gen: speaking single words, marked accessory muscle use, audible wheeze, prolonged expiration
PEFR 35% predicted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี เสียงแหบ + ไอเสียงเหมือนเห่า + stridor ขณะร้อง 1 วัน ก่อนหน้าเป็นหวัดเล็กน้อย ไม่มีไข้สูง

V/S: HR 132, RR 36, SpO2 96%, Temp 38.0°C
Gen: alert, comfortable at rest, no drooling, mild stridor only with crying, mild suprasternal retraction
Westley croup score 3 (mild-moderate)', '[{"label":"A","text":"Tracheostomy immediately"},{"label":"B","text":"Croup (laryngotracheobronchitis, parainfluenza): Dexamethasone 0.6 mg/kg PO/IM (max 16 mg) single dose ให้ทุกระดับความรุนแรง (ลด admission + return); humidified air/cool mist ความช่วยเหลือไม่เด่น แต่ comfort; minimize agitation; ถ้า moderate-severe (stridor at rest, retractions) → nebulized racemic epinephrine 0.5 mL of 2.25% (or L-epi) → monitor 3-4 hr (rebound); admit ถ้า persistent stridor, repeated epi, distress; avoid antibiotic (viral); reassurance + return precautions"},{"label":"C","text":"Antibiotic + admit"},{"label":"D","text":"Albuterol nebulizer"},{"label":"E","text":"Intubate routinely"}]'::jsonb,
  'B', 'Croup = viral (parainfluenza most common), age 6 mo-3 yr. Single-dose dexamethasone for all severity grades (level 1 evidence). Nebulized epinephrine for moderate-severe with rebound monitoring 3-4 hr. Avoid agitation. Bacterial tracheitis = serious differential (toxic appearance, high fever, no response to epi).', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'Cochrane: Glucocorticoids for Croup 2018; AAP Section on Emergency Medicine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี เสียงแหบ + ไอเสียงเหมือนเห่า + stridor ขณะร้อง 1 วัน ก่อนหน้าเป็นหวัดเล็กน้อย ไม่มีไข้สูง

V/S: HR 132, RR 36, SpO2 96%, Temp 38.0°C
Gen: alert, comfortable at rest, no drooling, mild stridor only with crying, mild suprasternal retraction
Westley croup score 3 (mild-moderate)'
  );

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
