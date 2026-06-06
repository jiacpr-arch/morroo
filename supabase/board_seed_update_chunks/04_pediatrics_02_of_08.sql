-- ===============================================================
-- UPDATE chunk 2/8: pediatrics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as adult bundle"},{"label":"B","text":"Pediatric CLABSI Prevention Bundle"},{"label":"C","text":"Avoid all central lines"},{"label":"D","text":"Use all femoral lines"},{"label":"E","text":"No prevention needed in children"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric CLABSI Prevention Bundle: similar adult core (hand hygiene, max barrier, chlorhexidine ≥ 0.5% in alcohol > 2 mo old, site selection — IJ or subclavian preferred over femoral in non-emergent, daily review) + pediatric-specific: (1) Use of central lines minimized — peripheral IV when possible, midline if longer duration; (2) Catheter selection by size + child size (different small catheters); (3) Site selection: in infants/children — IJ often easier than subclavian; femoral acceptable in PICU/post-op cardiac (less infection difference than adults); (4) Insertion checklist + observer; (5) Chlorhexidine bathing daily in PICU (less convincing evidence than adults); (6) Dressing change protocols (transparent q7d or per soil); (7) Hub disinfection ("scrub the hub"); (8) Daily review of necessity — early removal; (9) Antimicrobial-impregnated catheters in selected; (10) Education + ongoing competency assessment; (11) PICU-specific: TPN line designation, sepsis surveillance; (12) Family education + engagement; (13) Tracking + feedback: CLABSI rate per 1000 catheter-days; (14) Multidisciplinary: physicians, nurses, infection prevention, family

---

Pediatric CLABSI prevention — similar core to adult bundle (Pronovost Keystone applies) + pediatric considerations: smaller catheters, site preference varies, chlorhexidine after 2 mo old, family engagement. Pediatric ICU CLABSI lower with bundle implementation (Miller MR Pediatrics 2010 — 40% reduction). Modern: family-centered care, technology, electronic surveillance. Continuous improvement + audit + feedback critical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Exclude families from care decisions"},{"label":"B","text":"Family-Centered Care (FCC) in pediatric/PICU"},{"label":"C","text":"Visit only 2 hours/day"},{"label":"D","text":"Decisions by physicians alone"},{"label":"E","text":"No family communication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Family-Centered Care (FCC) in pediatric/PICU — partnership with families improves outcomes: (1) Core principles (Institute for Patient + Family-Centered Care): respect + dignity, information sharing, participation, collaboration; (2) Open visitation 24/7 + family at bedside; (3) Family rounds — daily bedside multidisciplinary rounds including family + child (age-appropriate); (4) Shared decision-making — values, goals, options discussed; (5) Family presence during procedures + resuscitation (AHA + AAP endorse); (6) Parental + caregiver role: comfort, education, advocacy, observation; (7) Sibling support + visitation; (8) Cultural + linguistic competence — interpreters, cultural understanding; (9) Discharge planning involves family early; (10) Family advisory councils — family input on hospital policies + design; (11) Education programs + support groups; (12) Bereavement care for family if child dies; (13) Outcome measures: family satisfaction, length of stay, readmission, error rates (reduced when family engaged), staff satisfaction; (14) Evidence: family presence at resuscitation reduces PTSD in family + does not impair care (Compassionate Connected Care, Doyle Crit Care Med); FCC reduces LOS, complications, costs (Cooper RL Crit Care Med)

---

FCC = evidence-based partnership with families. Core: respect, information, participation, collaboration. Reduces LOS, complications, PTSD, increases satisfaction. Family-centered rounds, presence during resuscitation, shared decision-making, cultural competence. IPFCC framework. AAP, AHA endorse. Modern pediatric care unimaginable without family partnership.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Chemotherapy only by oncologist"},{"label":"B","text":"Pediatric Cancer Integrative Multidisciplinary Care"},{"label":"C","text":"Refuse all support"},{"label":"D","text":"Single specialist"},{"label":"E","text":"Ignore long-term effects"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cancer Integrative Multidisciplinary Care: (1) Oncology team: pediatric hematology-oncology, treatment protocol per COG/UKALL/equivalent; (2) Treatment: induction → consolidation → maintenance for ALL; risk-stratified (cytogenetics, MRD); intrathecal therapy + cranial RT (selected) for CNS prophylaxis; (3) Supportive: tumor lysis syndrome prevention (hydration, allopurinol, rasburicase for high risk), febrile neutropenia management (empirical broad antibiotic within 1h), antifungal prophylaxis selected, antiviral if needed, transfusion support, growth factors (G-CSF); (4) Multidisciplinary team: oncology, infectious disease, nutritionist, PT/OT, psychology, child life, social work, chaplain, school liaison, primary pediatrician coordination; (5) Family support: shared decision-making, anticipatory guidance, sibling support, financial counseling (treatment expensive), respite care; (6) Child life specialist: developmentally appropriate education, coping, distraction, procedural support; (7) School re-integration: maintain education, home/hospital schooling, school nurse coordination, transition back; (8) Long-term survivorship: 90% 5-year survival ALL — surveillance for late effects (secondary malignancy, cardiotoxicity, growth, fertility, cognitive, psychosocial); transition to adult survivor clinic; (9) Palliative care concurrent — improves QOL even in curative intent; (10) End-of-life care if treatment fails — pediatric palliative + hospice integration

---

Pediatric cancer = integrative + multidisciplinary + family-centered. ALL 90% 5-year survival modern. Treatment phases. Risk-stratified (MRD, cytogenetics). Supportive care critical (febrile neutropenia, tumor lysis, transfusions). Multidisciplinary team. Family support essential. Long-term survivorship: late effects screening, transition to adult care. Palliative care concurrent (improves QOL + may extend life). Modern pediatric oncology highly integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Abrupt transfer at 18"},{"label":"B","text":"Adolescent Transition to Adult Care (integrative + planned process)"},{"label":"C","text":"Pediatric care for life"},{"label":"D","text":"Ignore transition needs"},{"label":"E","text":"Discharge from all care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Transition to Adult Care (integrative + planned process): (1) Begin transition planning in early adolescence (age 12-14) — not abrupt at 18; (2) Joint pediatric + adult provider coordination — written transition plan, shared records; (3) Self-management skills development: medication knowledge + administration, appointment scheduling, insurance navigation, recognizing warning signs, communication with providers; (4) Address adolescent-specific issues: sexuality + reproductive health, mental health (depression, anxiety, substance use higher in chronic illness), school/career planning, peer relationships, identity + autonomy; (5) Family role evolution — from primary decision-maker to support; (6) Confidentiality + assent/consent transition; (7) Specific concerns by condition (DM, CF, cancer survivor, congenital heart, sickle cell, IBD, transplant); (8) Insurance + legal: medical decision-making, conservatorship if cognitive impairment, transition of insurance; (9) Multidisciplinary support: adolescent medicine, social work, mental health, primary care; (10) Outcome metrics: continuity of care, no gap, adherence, satisfaction; (11) Got Transition + Six Core Elements framework (national approach); (12) Special populations: developmental disabilities, autism (specialized adult providers limited), cognitive impairment, complex care

---

Adolescent transition to adult care = critical integrative process. Begin early, planned, not abrupt. Six Core Elements (Got Transition): transition policy, tracking, readiness, planning, transfer, completion. Self-management skill building. Adolescent-specific issues. Family + autonomy balance. Multidisciplinary. Specific to condition (CF, DM, sickle cell, transplant, complex care). Outcomes: continuity, adherence. Gap in transition = poor outcomes. Modern: ''Got Transition'' national framework + AAP/AAFP/ACP joint clinical report.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge from all follow-up"},{"label":"B","text":"Premature Infant Follow-up (NICU Graduate)"},{"label":"C","text":"Single specialty manages all"},{"label":"D","text":"Refuse early intervention"},{"label":"E","text":"Use chronological age only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Premature Infant Follow-up (NICU Graduate) — Integrative Multidisciplinary: (1) High-risk infant follow-up clinic (HRIF): developmental assessment, growth, neurological at scheduled intervals up to 2-3 years (corrected age); (2) Subspecialty care: pulmonology (BPD/CLD — chronic lung disease, RSV prophylaxis with palivizumab, weaning O2 home), ophthalmology (ROP — retinopathy of prematurity, follow-up), cardiology (PDA, congenital concerns), neurology (IVH, PVL, hydrocephalus), GI (NEC, feeding difficulties); (3) Developmental: PT, OT, speech therapy, early intervention services (IDEA Part C), assessments (Bayley, AIMS); (4) Nutrition: high-calorie formulas, fortification, weight gain monitoring, feeding therapy; (5) Vaccination: catch-up schedule + RSV prophylaxis (palivizumab) for high-risk; (6) Hearing + vision screening + monitoring; (7) Family support: parental mental health (high postpartum depression + PTSD risk), sibling support, financial counseling (NICU costs, ongoing care), respite care; (8) Coordinate care: medical home with primary pediatrician + specialty consults; (9) Long-term: school readiness assessment, IEP if developmental delays, transition planning; (10) Outcomes: many achieve typical development; some have lasting disabilities — early intervention improves outcomes; family-centered support throughout; corrected age use until 2 yr for milestones

---

NICU graduate follow-up = quintessentially integrative. High-Risk Infant Follow-up clinic standard model. Subspecialty care (pulm, ophtho, cardio, neuro, GI, dev). Early intervention essential — improves outcomes. Family-centered + corrected age use until 2 yr. Long-term outcomes variable — modern care + interventions improve trajectory. Family support critical (parental MH, finances, social). AAP + March of Dimes guidelines. Outcomes registry data informs care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with home O2"},{"label":"B","text":"Neonatal RDS (surfactant deficiency)"},{"label":"C","text":"Diuretic only"},{"label":"D","text":"Restrict oxygen completely"},{"label":"E","text":"Oral antibiotic outpatient"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal RDS (surfactant deficiency): warm + dry + INSURE หรือ early CPAP+selective surfactant; ให้ surfactant (poractant alfa 200 mg/kg หรือ beractant 100 mg/kg) intratracheal ภายใน 2 ชม; nCPAP 5-6 cmH2O เป็น first-line; intubate ถ้า FiO2 > 0.4 + persistent distress; antenatal steroid ถ้ารู้ก่อนคลอด; antibiotic ครอบคลุม sepsis (ampicillin+gentamicin) เพราะ chorioamnionitis; thermoregulation + nutrition + monitor PDA/IVH/ROP/BPD

---

RDS = ภาวะที่พบบ่อยที่สุดในทารกเกิดก่อนกำหนด เกิดจาก surfactant deficiency. ESPR 2023 guideline เน้น less invasive surfactant administration (LISA/MIST) + nCPAP. Antenatal steroid ลด RDS, IVH, death อย่างมีนัยสำคัญ. Caffeine สำหรับ AOP. Antibiotic ครอบคลุม early-onset sepsis ในเด็กที่แม่มี chorioamnionitis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกเกิดก่อนกำหนด GA 30 wk BW 1,400 g คลอด emergency C/S จากแม่ chorioamnionitis ทารกหายใจหอบเหนื่อยตั้งแต่ 30 นาทีหลังคลอด grunting + retraction

V/S: HR 168, RR 78, SpO2 84% room air, Temp 36.4°C
Gen: cyanosis central, severe subcostal + intercostal retraction, nasal flaring, expiratory grunting
CXR: bilateral diffuse ground-glass + air bronchogram + low lung volume';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue feed + observation"},{"label":"B","text":"Necrotizing Enterocolitis Bell stage IIB-III"},{"label":"C","text":"Increase feed volume"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Necrotizing Enterocolitis Bell stage IIB-III: NPO ทันที + NG decompression + IV fluid resuscitation + broad-spectrum antibiotic (ampicillin + gentamicin + metronidazole or piperacillin-tazobactam) × 7-14 วัน; bowel rest 7-14 วัน; serial AXR q6h หา pneumoperitoneum; surgical consultation; indications surgery: perforation, fixed loop, clinical deterioration; TPN; correct coagulopathy; platelet transfusion ถ้า < 50,000 + bleeding; long-term watch for strictures + short bowel syndrome

---

NEC = leading cause GI emergency + mortality ใน preterm. Bell staging guides management. Pneumatosis intestinalis = pathognomonic. Portal venous gas = severe. Surgery for perforation/clinical deterioration. Prevention: breast milk feeding, slow advancement, probiotics (selected populations), antenatal steroid.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก preterm GA 28 wk BW 950 g อายุ 14 วัน เริ่ม feed breast milk + fortifier ได้ดี วันนี้มี abdominal distension + bilious vomiting + bloody stool + lethargy + temperature instability

V/S: HR 188, RR 72, SpO2 92%, BP 52/30, Temp 35.8°C
Abd: distended, erythema abdominal wall, absent bowel sounds, tenderness

CBC: WBC 4,200 (left shift), Plt 68,000, Hb 9.2
Lactate 5.8, metabolic acidosis pH 7.21
AXR: pneumatosis intestinalis + portal venous gas';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation only"},{"label":"B","text":"Early-onset neonatal sepsis (likely GBS"},{"label":"C","text":"Antibiotic oral outpatient"},{"label":"D","text":"Discharge with follow-up"},{"label":"E","text":"IVIG only without antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-onset neonatal sepsis (likely GBS — inadequate IAP): blood culture + LP + UA + CBC ก่อนให้ antibiotic; empiric Ampicillin 150 mg/kg/dose q12h IV + Gentamicin 4 mg/kg/dose q24h IV; resuscitation fluid 10-20 mL/kg NSS bolus careful; correct glucose + electrolytes; meningitis dose ถ้า LP +; duration: 10 d bacteremia, 14-21 d meningitis (GBS); supportive: thermoregulation, ventilation, vasopressor ถ้า shock

---

Early-onset sepsis (EOS) < 72 ชม. GBS = most common pathogen. Inadequate IAP = risk factor. Kaiser EOS calculator + CDC 2010/2019 guidance. Always rule out meningitis. Antibiotic timing critical. Long-term: developmental follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกแรกเกิด term GA 39 wk BW 3,200 g คลอด NL แม่ GBS positive ไม่ได้ intrapartum antibiotic prophylaxis อายุ 18 ชม มี temperature instability + poor feeding + tachypnea + grunting

V/S: HR 178, RR 72, Temp 38.4°C, SpO2 94%
Gen: lethargic, mottled skin, capillary refill 4 sec, mild jaundice

CBC: WBC 28,500 (immature/total 0.3), Plt 110,000, CRP 65
Glucose 45, ABG mild metabolic acidosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe only"},{"label":"B","text":"Hyperbilirubinemia + ABO incompatibility (Coombs+)"},{"label":"C","text":"Exchange transfusion immediately"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"Discharge home without phototherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperbilirubinemia + ABO incompatibility (Coombs+): plot on AAP 2022 nomogram by gestational age + risk factors → bilirubin 18.2 at 96h + neuroToxicity risk factors = phototherapy threshold; intensive phototherapy (450-500 nm blue-green LED, body surface > 80%); continue breastfeeding, supplement formula ถ้า dehydration; recheck TSB q6-12h; exchange transfusion ถ้า > exchange threshold หรือ ABE signs; investigate G6PD ในเด็กเอเชีย; IVIG ถ้า isoimmune + rising despite phototherapy; follow-up 24-48h post-discharge

---

AAP 2022 updated nomogram: integrates GA, age in hours, neurotoxicity risk factors (isoimmune disease, G6PD, sepsis, albumin < 3, asphyxia). ABO incompatibility = mild hemolysis. Intensive phototherapy = mainstay. Bilirubin encephalopathy = preventable cause of kernicterus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term DOL 4 BW 3,400 g (BW birth 3,500 g, weight loss 2.8%) breastfeeding มา check up พบตัวเหลือง

V/S ปกติ Temp 36.8°C
Gen: jaundice ถึง knees, alert, feed ดี

Total bilirubin 18.2 mg/dL (direct 0.8), Hb 14.5, Hct 44, blood group: mother O+, baby A+
Coombs test: weakly positive
Reticulocyte 4.2%';

update public.mcq_questions
set choices = '[{"label":"A","text":"Decrease FiO2 to 21%"},{"label":"B","text":"Persistent Pulmonary Hypertension Newborn (PPHN, MAS-related)"},{"label":"C","text":"Discharge home with oxygen"},{"label":"D","text":"Stop oxygen entirely"},{"label":"E","text":"Beta blocker"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Pulmonary Hypertension Newborn (PPHN, MAS-related): optimize ventilation + oxygenation (SpO2 95-99%, target PaO2 60-80, gentle ventilation, avoid hypocapnia); correct acidosis + hypoglycemia + hypocalcemia; surfactant ถ้า MAS/parenchymal disease; inhaled Nitric Oxide (iNO) 20 ppm first-line pulmonary vasodilator; sedation (fentanyl) เพื่อลด stress + pulmonary vasoconstriction; vasopressor (milrinone, sildenafil) ถ้า iNO ไม่พอ; ECMO ถ้า refractory (OI > 25-40); avoid hyperoxia; transfer to ECMO center

---

PPHN = failure of normal postnatal fall in PVR → R→L shunt → hypoxemia. Differential SpO2 (pre > post) = key clinical sign. iNO + gentle ventilation + supportive care. ECMO for refractory cases. Common causes: MAS, sepsis, RDS, congenital diaphragmatic hernia, idiopathic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term GA 40 wk meconium-stained fluid + low Apgar (3, 5) อายุ 4 ชม หอบเหนื่อยมาก + cyanosis + เริ่มต้องการ FiO2 100%

V/S: HR 178, RR 75, SpO2 right hand 92% / right foot 78% (pre/post-ductal differential 14%)

ABG (FiO2 1.0): pH 7.22, PaO2 42, PaCO2 58
CXR: clear lung field, normal heart size
Echo: tricuspid regurgitation jet velocity high, RV pressure 65 mmHg + R→L shunting at PFO + PDA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"D-TGA emergency"},{"label":"C","text":"Beta blocker only"},{"label":"D","text":"100% oxygen alone resolves"},{"label":"E","text":"Heart transplant immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** D-TGA emergency: Prostaglandin E1 infusion 0.05-0.1 mcg/kg/min IV ทันที (เปิด PDA เพื่อ allow mixing) + balloon atrial septostomy (Rashkind) ภายใต้ echo ในห้อง cath เพื่อขยาย atrial communication; cardiology + cardiac surgery consultation; transfer to cardiac center; correct metabolic acidosis + glucose; avoid hyperoxia (สามารถปิด PDA); ventilation as needed; arterial switch operation (Jatene) ภายใน 2 weeks of life (เพราะ LV regression); long-term cardiology follow-up

---

D-TGA = most common cyanotic CHD presenting in newborn. Cyanosis refractory to O2 = key sign. PGE1 keeps PDA open for mixing. BAS expands intra-atrial mixing. Definitive: arterial switch within 2 weeks. Hyperoxia test (PaO2 < 100 on 100% O2) suggests cyanotic CHD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term GA 38 wk BW 3,400 g คลอด NL Apgar 8/9 อายุ 6 ชม cyanosis ทั่วตัวไม่ดีขึ้นด้วย O2

V/S: HR 158, RR 62, SpO2 right hand 75% / right foot 78%
Gen: marked central cyanosis ที่ไม่ตอบสนองต่อ O2, mild distress, no murmur
Hyperoxia test: PaO2 < 100 บน FiO2 100%

CXR: ''egg on string'', cardiomegaly, increased pulmonary vascularity
Echo: D-Transposition of Great Arteries (D-TGA) + small PFO + small PDA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + recheck pulses tomorrow"},{"label":"B","text":"Critical/Ductal-dependent Coarctation of Aorta"},{"label":"C","text":"Antihypertensive medication only"},{"label":"D","text":"Discharge with diuretic"},{"label":"E","text":"Heart transplant"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical/Ductal-dependent Coarctation of Aorta: Prostaglandin E1 0.05-0.1 mcg/kg/min IV infusion ทันที (เปิด PDA ฟื้น systemic perfusion); resuscitation + inotropic support (milrinone, dopamine) ถ้า shock; correct metabolic acidosis + hypoglycemia + hypocalcemia; broad-spectrum antibiotic หา sepsis; intubation + ventilation ถ้า respiratory failure; urgent cardiology + cardiac surgery referral; surgical repair (end-to-end, subclavian flap, balloon angioplasty); long-term BP monitoring (residual HT common)

---

Critical coarctation = ductal-dependent. Presents shock as PDA closes (DOL 3-7). BP gradient + weak femoral pulses = classic. PGE1 = lifesaving. Associated bicuspid AV, VSD. Long-term sequelae: residual HT, re-coarctation, aortic dissection.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term DOL 5 lethargic, ดูดนมไม่ดี, ขาเย็น, มา ED

V/S: BP right arm 95/62, BP right leg 60/38 (gradient 35 mmHg), HR 168, RR 68, SpO2 96% right hand / 90% right foot
PE: weak femoral pulses bilateral, brachial-femoral delay, mild hepatomegaly, no murmur

CXR: cardiomegaly + pulmonary edema
Echo: severe juxtaductal coarctation of aorta + bicuspid aortic valve + LV dysfunction, closing PDA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient azithromycin"},{"label":"B","text":"Pediatric Community-Acquired Pneumonia (likely Strep pneumoniae)"},{"label":"C","text":"Discharge home no antibiotic"},{"label":"D","text":"Antifungal first-line"},{"label":"E","text":"Steroid alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Community-Acquired Pneumonia (likely Strep pneumoniae): IV Ampicillin 50 mg/kg/dose q6h (200 mg/kg/d) เป็น first-line ใน fully immunized child + hospitalized + moderate severity; O2 ให้ SpO2 ≥ 92%; IV fluid maintenance + antipyretic; ถ้า effusion มาก + clinical worse → US chest + drainage + culture; switch oral amoxicillin เมื่อ stable + afebrile 24-48h; duration total 7-10 d; วัคซีน PCV13 + influenza; macrolide ถ้า atypical (Mycoplasma, Chlamydia)

---

PIDS/IDSA 2011 guideline: ampicillin first-line for hospitalized peds CAP (Spn). PCV13 reduced Spn rates. Add macrolide if atypical suspected. Severity: hypoxia, RR, retractions, oral intake guide hospitalization. Effusion → drainage if large/empyema.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 3 ปี ไข้ + ไอ + หอบเหนื่อย 3 วัน ไม่มี wheeze, vaccine ครบ

V/S: HR 152, RR 58, SpO2 91% room air, Temp 39.4°C, BW 14 kg
Gen: alert, mild distress, decreased breath sound + crackles + bronchial breath right lower lobe

CBC: WBC 18,200 (PMN 78%), CRP 158
CXR: right lower lobe consolidation + small parapneumonic effusion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic + discharge"},{"label":"B","text":"Severe asthma exacerbation (GINA 2024)"},{"label":"C","text":"Sedative only"},{"label":"D","text":"Restrict fluid"},{"label":"E","text":"IV diuretic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe asthma exacerbation (GINA 2024): O2 to SpO2 94-98% (kids); albuterol nebulized 2.5-5 mg q20 min × 3 หรือ continuous + ipratropium 250-500 mcg ผสมใน first 3 doses; systemic corticosteroid early — oral prednisolone 1-2 mg/kg (max 60 mg) ภายใน 1 ชม; magnesium sulfate IV 25-50 mg/kg (max 2 g) over 20 min ถ้า refractory; reassess PEFR, work of breathing, SpO2 q15-30 min; IV terbutaline หรือ ICU + ventilation ถ้า impending failure; admit ถ้า incomplete response; discharge plan: action plan, ICS, follow-up 1-2 wk, trigger avoidance

---

GINA 2024 + AAP: ABC ไปก่อน. Early systemic steroid critical (delay = worse outcome). Mg sulfate for severe/refractory. Avoid sedatives (mask deterioration). ICU/intubation for impending respiratory failure (silent chest, exhaustion, CO2 normalizing/rising = late). Long-term: ICS + action plan + trigger control.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 7 ปี known asthma มา ED ด้วยอาการหอบเหนื่อย ไอ wheeze หลังเจอแมว 2 ชม ก่อน ใช้ albuterol MDI ที่บ้าน 4 puff ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 89% room air, BW 25 kg
Gen: speaking single words, marked accessory muscle use, audible wheeze, prolonged expiration
PEFR 35% predicted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Tracheostomy immediately"},{"label":"B","text":"Croup (laryngotracheobronchitis, parainfluenza)"},{"label":"C","text":"Antibiotic + admit"},{"label":"D","text":"Albuterol nebulizer"},{"label":"E","text":"Intubate routinely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Croup (laryngotracheobronchitis, parainfluenza): Dexamethasone 0.6 mg/kg PO/IM (max 16 mg) single dose ให้ทุกระดับความรุนแรง (ลด admission + return); humidified air/cool mist ความช่วยเหลือไม่เด่น แต่ comfort; minimize agitation; ถ้า moderate-severe (stridor at rest, retractions) → nebulized racemic epinephrine 0.5 mL of 2.25% (or L-epi) → monitor 3-4 hr (rebound); admit ถ้า persistent stridor, repeated epi, distress; avoid antibiotic (viral); reassurance + return precautions

---

Croup = viral (parainfluenza most common), age 6 mo-3 yr. Single-dose dexamethasone for all severity grades (level 1 evidence). Nebulized epinephrine for moderate-severe with rebound monitoring 3-4 hr. Avoid agitation. Bacterial tracheitis = serious differential (toxic appearance, high fever, no response to epi).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี เสียงแหบ + ไอเสียงเหมือนเห่า + stridor ขณะร้อง 1 วัน ก่อนหน้าเป็นหวัดเล็กน้อย ไม่มีไข้สูง

V/S: HR 132, RR 36, SpO2 96%, Temp 38.0°C
Gen: alert, comfortable at rest, no drooling, mild stridor only with crying, mild suprasternal retraction
Westley croup score 3 (mild-moderate)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lay flat for direct laryngoscopy"},{"label":"B","text":"Suspected Epiglottitis (incomplete Hib vaccine)"},{"label":"C","text":"Oral antibiotic + discharge"},{"label":"D","text":"Force IV before airway"},{"label":"E","text":"CT neck first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Epiglottitis (incomplete Hib vaccine): KEEP CHILD CALM with parent (no IV, no exam, no X-ray ใน ED ที่อาจทำให้ตื่นกลัว); call anesthesia + ENT + ICU ทันที; transfer to OR for controlled intubation by experienced team (have tracheostomy backup); blood culture + epiglottis swab AFTER airway secured; IV Ceftriaxone 100 mg/kg/d × 7-10 วัน (Hib first then Spn, GAS, Staph); ICU monitoring; rifampin chemoprophylaxis household contacts (unvaccinated < 4 yr); extubate 48-72 hr; vaccinate Hib

---

Epiglottitis (Hib mainly, now also Spn, GAS, Staph in vaccinated era) = airway emergency. Don''t disturb child (no agitation = no sudden obstruction). Controlled intubation by expert. Differentiate from croup (toxic, drooling, tripod, no cough). Hib vaccine dramatically reduced incidence.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี vaccine incomplete (no Hib) มา ED ด้วยไข้สูง 40°C 6 ชม น้ำลายไหล นั่งโน้มตัวไปข้างหน้า (tripod) เสียงแหบ ดูป่วยมาก ไม่ยอมนอน

V/S: HR 162, RR 32, SpO2 91%, Temp 40°C, BW 18 kg
Gen: toxic appearance, drooling, muffled voice, no cough, anxious
Avoid lateral neck X-ray in ED';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + albuterol + discharge"},{"label":"B","text":"Foreign body aspiration (likely right main bronchus"},{"label":"C","text":"Wait 2 weeks observation"},{"label":"D","text":"Heimlich blindly"},{"label":"E","text":"Empiric tuberculosis treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Foreign body aspiration (likely right main bronchus — peanut): NPO; pediatric ENT/pulm consultation; urgent rigid bronchoscopy ในห้องผ่าตัดภายใต้ GA — diagnostic + therapeutic (extract FB); avoid blind sweep + back blows ใน conscious child > 1 yr (เสี่ยง ดัน FB ลึก); ถ้า complete obstruction + unconscious → BLS algorithm (5 back blows + 5 chest thrusts < 1 yr, abdominal thrusts > 1 yr); O2 + monitor; antibiotic + steroid post-retrieval ถ้า มี mucosal injury; education on choking hazard

---

FBA = leading cause unintentional death < 4 yr. Peanut, nuts, grapes, hot dog common. Sudden choking + asymmetric findings = classic. Expiratory CXR (or lateral decubitus) reveals air trapping (ball-valve). Rigid bronchoscopy = diagnostic + therapeutic. Don''t delay.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน ขณะเล่นกินถั่ว สำลักทันที ไอ เริ่ม wheeze ข้างขวา หอบเหนื่อย

V/S: HR 162, RR 48, SpO2 90% room air, Temp 37.0°C
Gen: alert, mild distress, asymmetric breath sound (decreased right) + unilateral expiratory wheeze right, no stridor

CXR inspiratory: normal; CXR expiratory: hyperinflation right lung + mediastinal shift left';

update public.mcq_questions
set choices = '[{"label":"A","text":"Defibrillation immediately"},{"label":"B","text":"Symptomatic bradycardia post-arrest (PALS 2020)"},{"label":"C","text":"Adenosine"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic bradycardia post-arrest (PALS 2020): ensure adequate oxygenation + ventilation FIRST (most peds bradycardia hypoxia-driven); if HR < 60 + poor perfusion despite ventilation → start chest compressions; Epinephrine 0.01 mg/kg (0.1 mL/kg of 1:10,000) IV/IO q3-5 min; Atropine 0.02 mg/kg (min 0.1 mg, max 0.5 mg) IF vagal-mediated or AV block; identify + treat reversible causes (Hs and Ts — hypoxia in drowning); pacing only if drug-refractory + likely complete AV block; post-arrest care: targeted temperature, glucose control, family centered

---

PALS 2020: peds bradycardia mostly hypoxic — fix airway/breathing first. CPR if HR < 60 with poor perfusion despite ventilation. Epi first-line drug. Atropine for vagal/AV block. Post-arrest neuroprotection + targeted temperature management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 2 ปี BW 12 kg post-drowning rescue หลัง CPR 5 นาที ROSC แต่ HR 48/min พบ poor perfusion + capillary refill 5 sec + altered mental status + weak central pulses

V/S: HR 48, BP 70/40, SpO2 88% on 100% O2
Monitor: sinus bradycardia, no ectopy

ABG: pH 7.18, PaO2 110, PaCO2 32, HCO3 14';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antihistamine oral + observe"},{"label":"B","text":"Anaphylaxis"},{"label":"C","text":"Steroid IV alone"},{"label":"D","text":"Diphenhydramine alone"},{"label":"E","text":"Watch + wait"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anaphylaxis: IM Epinephrine 1:1000 = 0.01 mg/kg (max 0.3 mg = 0.3 mL) ต้น lateral thigh ทันที — first-line lifesaving; repeat q5-15 min ถ้าไม่ดีขึ้น; supine + legs up; high-flow O2 + airway support + albuterol ถ้า wheeze; IV fluid bolus 20 mL/kg crystalloid ถ้า hypotension; secondary: H1 antihistamine (diphenhydramine), H2 antihistamine, corticosteroid (ไม่ใช่ first-line, ไม่กัน biphasic); observe 4-6 ชม (biphasic 5%); discharge with EpiPen × 2 + allergist referral + action plan + avoidance

---

Anaphylaxis = clinical diagnosis. Epinephrine IM = first-line, no contraindication. Delay = mortality. Observation post-treatment 4-6 hr for biphasic reaction (5-20%). Always provide EpiPen × 2 + action plan + allergist referral. Common triggers: foods, insects, drugs, latex.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี BW 22 kg กินกุ้ง 15 นาที ก่อน เริ่มมีลมพิษทั่วตัว + ปากบวม + เสียงแหบ + หอบเหนื่อย + wheeze + อาเจียน 2 ครั้ง

V/S: HR 158, BP 78/42, RR 38, SpO2 92%
Gen: anxious, generalized urticaria + angioedema, biphasic wheeze, weak pulses';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic oral outpatient"},{"label":"B","text":"Pediatric septic shock (likely meningococcemia)"},{"label":"C","text":"Wait for culture results"},{"label":"D","text":"Diuretic first"},{"label":"E","text":"Discharge with oral antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric septic shock (likely meningococcemia): IV/IO access × 2 ภายใน 5 นาที; aggressive fluid resuscitation 10-20 mL/kg NSS/LR bolus × repeat up to 60 mL/kg ใน first hour (reassess after each bolus — risk fluid overload, hepatomegaly, rales); empiric Ceftriaxone 100 mg/kg/dose IV ภายใน 1 ชม (after culture if no delay); start epinephrine peripheral 0.05-0.3 mcg/kg/min ถ้า fluid-refractory (cold shock); norepi for warm shock; correct hypoglycemia, hypocalcemia, acidosis; intubate ถ้า impending failure; ICU + central + arterial line; stress dose hydrocortisone ถ้า catecholamine-resistant; transfer pediatric ICU

---

Surviving Sepsis Campaign Pediatric 2020: hour-1 bundle. Recognize early. Fluid resuscitation with reassessment for overload. Empiric antibiotic within 1 hr. Vasoactive support — epi for cold shock (low CO), norepi for warm (low SVR). Goals: normalize MAP, perfusion, lactate. Pediatric ICU.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 3 ปี BW 14 kg ไข้สูง 40°C 24 ชม petechiae purpura ทั่วตัว ซึม ขาเย็น

V/S: HR 178, BP 68/30, RR 42, SpO2 92%, Temp 40°C, capillary refill 6 sec
Gen: lethargic, cold extremities, mottled, weak pulses, oliguria

Lactate 6.8, glucose 52, WBC 2,800, Plt 78,000, CRP 220, INR 1.8, fibrinogen 95';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Febrile UTI ใน infant"},{"label":"C","text":"Bag urine + oral antibiotic"},{"label":"D","text":"Discharge no antibiotic"},{"label":"E","text":"Antifungal first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Febrile UTI ใน infant: ส่ง urine culture จาก catheterization (suprapubic also acceptable) ก่อนเริ่ม antibiotic; empiric IV Ceftriaxone 50-75 mg/kg/d (admit ถ้า < 2 mo, toxic, vomiting, dehydration); switch oral once afebrile + clinical improvement (total 7-14 วัน); renal/bladder ultrasound ทุกราย first febrile UTI; VCUG ถ้า abnormal US + recurrence + atypical course; ตรวจหา renal scarring (DMSA) selected; counsel hygiene + voiding habits; continuous prophylaxis only selected high-grade VUR/recurrence

---

AAP 2011/2016 UTI guideline: febrile infant 2-24 mo. Catheter or SPA sample (bag = high false +). E. coli most common. Imaging: US for all, VCUG selective. Long-term scarring risk → prompt treatment + follow-up. Circumcision reduces UTI in male infants.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกหญิงอายุ 8 เดือน ไข้สูง 39.4°C 2 วันโดยไม่มี source อาเจียน + irritable

V/S: HR 162, RR 32, Temp 39.4°C, BW 8 kg
Gen: alert, no focal source

UA cath: WBC 80/HPF, leukocyte esterase +++, nitrite +, bacteria ++
Cultures: pending; CBC: WBC 16,500';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose immunosuppression immediately"},{"label":"B","text":"Post-streptococcal Glomerulonephritis (PSGN)"},{"label":"C","text":"Steroid pulse therapy routinely"},{"label":"D","text":"Plasmapheresis"},{"label":"E","text":"Discharge with no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-streptococcal Glomerulonephritis (PSGN): supportive care mainstay (self-limited 4-6 wk); salt + water restriction; loop diuretic (furosemide) สำหรับ edema + HT; antihypertensive (CCB, ACEI ระวัง AKI) ถ้า HT severe; treat residual strep infection (penicillin หรือ amoxicillin × 10 d); monitor BP + UA + renal function; admit ถ้า severe HT, encephalopathy, oliguria, electrolyte imbalance; recheck C3 ที่ 8 wk (ควรกลับมาปกติ — ถ้าไม่กลับ → คิด C3 glomerulopathy/MPGN); long-term BP + proteinuria follow-up

---

PSGN = classic acute nephritic syndrome เด็ก. ASO + low C3 (transient < 8 wk) + recent strep + hematuria + HT + edema. Most self-limit. Treatment supportive. Persistent low C3 > 8 wk → reconsider Dx (MPGN, C3GN, lupus).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี Cola-colored urine + ขาบวม + ปวดศีรษะ 3 วัน 2 สัปดาห์ก่อนเป็น strep throat (untreated)

V/S: BP 142/96, HR 92, BW 28 kg
PE: periorbital edema, mild pretibial edema

UA: RBC 80+, RBC cast +, protein 2+, dysmorphic RBC
BUN 42, Cr 1.2, Albumin 3.6, C3 LOW, C4 normal, ASO HIGH';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Idiopathic Nephrotic Syndrome (likely Minimal Change Disease)"},{"label":"C","text":"Cyclophosphamide first-line"},{"label":"D","text":"ACEI alone"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Idiopathic Nephrotic Syndrome (likely Minimal Change Disease): prednisolone 60 mg/m²/d (max 60 mg) PO × 4-6 wk → 40 mg/m² alternate day × 4-6 wk → taper (total 12 wk standard course); salt restriction + cautious diuretic ถ้า severe edema; albumin 25% + furosemide ถ้า severe edema + low IV volume; penicillin prophylaxis (pneumococcal peritonitis risk); pneumococcal + influenza vaccine; thromboprophylaxis selected (severe albumin < 2); biopsy ถ้า atypical (age < 1 or > 12, hematuria, HT, AKI, low C3, steroid-resistant, frequent relapse + steroid toxic); monitor BP + growth + bone density

---

Pediatric NS = MCD ในเด็กส่วนใหญ่ (> 90%, ages 2-10). Triad: proteinuria, hypoalbuminemia, edema (+ hyperlipidemia). Steroid response = MCD typical. Complications: infection (encapsulated organisms), VTE, AKI. Steroid-resistant → biopsy + alternative immunosuppression.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี ตื่นเช้ามาตาบวม 1 สัปดาห์ น้ำหนักเพิ่ม 3 kg ใน 2 สัปดาห์ ขาบวมตอนเย็น ปัสสาวะเป็นฟอง

V/S: BP 100/64, HR 102, BW 18 kg (จาก 15 kg)
PE: periorbital + pretibial pitting edema, mild ascites

UA: protein 4+, no hematuria
Urine spot P/Cr 5.6
Albumin 1.8, Cholesterol 380, normal Cr, complement normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Acute Lymphoblastic Leukemia (likely B-ALL, most common peds cancer)"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Watch + wait"},{"label":"E","text":"Splenectomy first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lymphoblastic Leukemia (likely B-ALL, most common peds cancer): admit oncology; flow cytometry + cytogenetics + molecular (BCR-ABL, MLL, hyperdiploidy); LP + bone marrow biopsy ใน first week; risk stratification (NCI age 1-10 + WBC < 50K = standard risk); induction chemo (vincristine + dexa/pred + asparaginase + ± anthracycline); tumor lysis prophylaxis — hydration 2× maintenance + allopurinol or rasburicase + monitor K, P, Ca, urate, Cr; transfusion: PRBC for Hb < 7 หรือ symptomatic, platelet for < 10K หรือ bleeding; central line; G-CSF selected; long-term: 2-3 yr therapy + late effects monitoring

---

ALL = most common pediatric cancer (peak 2-5 yr). 5-yr survival > 90% with modern protocols. Tumor lysis = major early complication. CNS prophylaxis intrathecal. Down syndrome + ALL = unique biology. Long-term: cardio, neuro, second malignancy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี เหนื่อยง่าย + ซีด 3 สัปดาห์ + ปวดขา + petechiae + bruise + ต่อมน้ำเหลืองโต ทั่วตัว + hepatosplenomegaly

V/S: HR 138, Temp 38.4°C, BW 18 kg
PE: pallor, generalized lymphadenopathy, liver 4 cm, spleen 6 cm BCM

CBC: WBC 68,500 (blasts 78%), Hb 6.2, Plt 28,000
Peripheral smear: lymphoblasts
LDH 1,840, Uric acid 8.6';

update public.mcq_questions
set choices = '[{"label":"A","text":"Splenectomy"},{"label":"B","text":"Acute Immune Thrombocytopenia (ITP, post-viral, typical)"},{"label":"C","text":"Bone marrow biopsy mandatory all"},{"label":"D","text":"Chemotherapy"},{"label":"E","text":"Antibiotic prophylaxis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Immune Thrombocytopenia (ITP, post-viral, typical): ในเด็กที่ no/mild bleeding (skin only) → observation alone ตามแนวทาง ASH 2019 (most spontaneous resolution 4-8 wk); หลีกเลี่ยง contact sports + NSAID/aspirin; education สัญญาณเลือดออกหนัก; first-line ถ้ามี bleeding significant: IVIG 0.8-1 g/kg single dose หรือ anti-D (Rh+ non-splenectomized) หรือ corticosteroid (prednisolone 2-4 mg/kg/d × 5-7 d then taper); platelet transfusion เฉพาะ life-threatening bleed; ถ้า chronic > 12 mo → rituximab, TPO agonists; rule out other causes (smear + family Hx)

---

ITP = isolated thrombocytopenia, typical post-viral. Most peds = acute, self-limit. ASH 2019: observation for skin-only bleeding regardless of platelet count. Treat if significant mucosal bleed. Bone marrow not required if typical features (no atypical labs/exam).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 4 ปี petechiae + bruising เกิดขึ้นเอง 1 สัปดาห์ ก่อนหน้า 2 สัปดาห์เป็น URI well-appearing

V/S ปกติ, BW 16 kg
PE: scattered petechiae arms + legs + trunk, no hepatosplenomegaly, no lymphadenopathy

CBC: WBC 7,200 (normal diff), Hb 12.4, Plt 8,000
Peripheral smear: large platelets, no blasts, no schistocytes';

commit;
