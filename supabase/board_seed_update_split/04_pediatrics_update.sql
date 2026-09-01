-- ===============================================================
-- UPDATE: pediatrics (200 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"IV antibiotics + bronchodilator + steroid"},{"label":"B","text":"Acute Bronchiolitis (RSV) moderate-severe"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Intubation immediately"},{"label":"E","text":"Restrict fluid completely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Bronchiolitis (RSV) moderate-severe: supportive care mainstay — O2 to SpO2 ≥ 90%, nasal suctioning, hydration; routine bronchodilators NOT recommended (AAP 2014 — no proven benefit); NO routine steroids or antibiotics (viral); HFNC for moderate distress; hospitalization for severe distress/hypoxia/dehydration/apnea < 3 mo; palivizumab prophylaxis for high-risk (premature, BPD, CHD)

---

Bronchiolitis = viral lower respiratory infection (RSV most common). Peak age 2-6 mo. AAP 2014 + NICE emphasize supportive care. Key: O2, hydration, monitoring. No routine antibiotics, bronchodilators, steroids, chest PT. HFNC may help. Prevention: hand hygiene + palivizumab for high-risk. A wrong — abx + steroid not indicated. C wrong — moderate distress can''t discharge. D wrong — try less invasive. E wrong — fluid needed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 เดือน คลอดครบกำหนด มาห้องฉุกเฉินด้วยอาการหอบเหนื่อย ไอ มีเสียง wheeze เป็นมา 3 วัน ก่อนหน้าเป็นหวัด 1 สัปดาห์ พ่อแม่บอกว่าลูกกินนมน้อยลง

V/S: HR 165, RR 65, SpO2 89% room air, Temp 37.8°C, น้ำหนัก 7 kg
Gen: alert but tired, mild cyanosis perioral, nasal flaring, subcostal + intercostal retraction
Lungs: bilateral fine crackles + expiratory wheeze, prolonged expiratory phase

CBC: WBC 12,500, normal differential
CXR: hyperinflation + bilateral perihilar streaking + scattered atelectasis
RSV antigen: positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with paracetamol for viral exanthem"},{"label":"B","text":"Complete Kawasaki Disease (5/6 criteria) with coronary involvement"},{"label":"C","text":"Antibiotic for streptococcal scarlet fever"},{"label":"D","text":"Observation × 24 hours"},{"label":"E","text":"Hospice care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete Kawasaki Disease (5/6 criteria) with coronary involvement: IVIG 2 g/kg IV over 10-12h within first 10 days (reduces coronary aneurysm 25→5%); high-dose aspirin 80-100 mg/kg/d until afebrile 48-72h then low-dose 3-5 mg/kg/d antiplatelet × 6-8 wk; echo at dx, 2 wk, 6-8 wk; high-risk Kobayashi → adjunctive steroid; IVIG-resistant → 2nd IVIG, infliximab; live vaccines delayed 11 mo post-IVIG

---

Kawasaki = acute vasculitis of medium vessels, leading cause acquired heart disease children. Criteria: fever ≥ 5 d + ≥ 4 of 5: conjunctivitis, oral changes, rash, extremity changes, cervical LN. IVIG + aspirin within first 10 days reduces coronary aneurysm 5×. Echo at dx, 2 wk, 6-8 wk. AHA 2017 guideline. Long-term cardiac surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 4 ปี ไข้สูง 39.8°C × 6 วัน + ผื่นแดง + ตาแดง 2 ข้าง + ปากแดงสด + แขนขาบวมแดง + ต่อมน้ำเหลืองที่คอข้างเดียว 1.8 cm + irritable

V/S: HR 142, BP 96/64, Temp 39.8°C
PE: cracked lips + strawberry tongue + cervical lymphadenopathy unilateral + bilateral non-purulent conjunctival injection + polymorphous rash + extremity edema + perineal desquamation

Lab: WBC 18,500, CRP 145, Plt 580,000 (rising), Albumin 2.8
Echo: dilated left main coronary (Z-score +3.5)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + serial exams"},{"label":"B","text":"Ileocolic Intussusception (most common bowel obstruction 6 mo-3 yr)"},{"label":"C","text":"Antibiotic + outpatient"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"MRI abdomen first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ileocolic Intussusception (most common bowel obstruction 6 mo-3 yr): IV fluid bolus 20 mL/kg + NG decompression + NPO; pneumatic or hydrostatic enema reduction under fluoroscopy/US guidance (80-90% success, first-line); contraindications: peritonitis, perforation, instability; surgery if enema fails, perforation, identifiable lead point (older children); post-reduction observation 12-24h (recurrence 5-10%)

---

Intussusception (telescoping bowel) — most common obstruction infants 6 mo-3 yr. Classic triad: intermittent crampy pain + currant jelly stool + sausage mass (25-50%). Most ileocolic (95%). Lead point: lymphoid hyperplasia (post-viral, Peyer''s patches). US diagnostic (target sign). Enema reduction first-line. Surgery if fails or contraindicated. Older children: investigate pathological lead point.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 เดือน acute onset ปวดท้อง crying + กระสับกระส่าย 15-20 นาทีแล้วหยุด สลับเป็นรอบ ๆ × 6 ชั่วโมง อาเจียน 3 ครั้ง วันนี้ถ่าย currant jelly stool

V/S: HR 168, lethargic
Abdomen: distended, palpable sausage-shaped mass RUQ

US: target/donut sign + pseudokidney — ileocolic intussusception';

update public.mcq_questions
set choices = '[{"label":"A","text":"Insulin bolus IV high dose + glucose 50% IV"},{"label":"B","text":"Pediatric DKA moderate-severe (ISPAD 2022)"},{"label":"C","text":"Same protocol as adult DKA"},{"label":"D","text":"Restrict all fluid"},{"label":"E","text":"Discharge home with oral hypoglycemic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric DKA moderate-severe (ISPAD 2022): CAUTIOUS fluid resuscitation (high cerebral edema risk!) — 10-20 mL/kg NSS bolus if shock then deficit over 48h (not 24h); insulin drip 0.05-0.1 U/kg/hr start 1-2h AFTER fluid (NO bolus); K replacement in fluid once K < 5.5 + UO established; bicarbonate ONLY if pH < 6.9 + CV compromise; MONITOR for cerebral edema (HA, AMS, bradycardia, HT, sudden change) — mannitol or 3% HTS if suspected; transition to SC insulin when bicarbonate > 18, pH > 7.3, AG closed, eating; diabetes team consultation + family education

---

Pediatric DKA: high risk cerebral edema (mortality 20-25%, most common DKA death in peds). Key differences from adult: cautious fluid over 48h; NO insulin bolus; delayed insulin start; aggressive K replacement; avoid bicarbonate; high suspicion for cerebral edema. Glaser PECARN 2018: fast vs slow fluid + 0.45% vs 0.9% — both safe. Modern: gentle resuscitation + close monitoring + multidisciplinary team.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 12 ปี polyuria + polydipsia + น้ำหนักลด 6 kg × 2 เดือน + เหนื่อย + คลื่นไส้ + อาเจียน 6 ชม

V/S: BP 102/64, HR 124, RR 32 (Kussmaul), Temp 36.8°C, DTX HI
Gen: dehydrated, GCS 13, capillary refill 4 sec

ABG: pH 7.10, PaCO2 18, HCO3 6
Lab: Glucose 685, Na 132, K 5.4, BUN 28, Cr 1.0, Ketone urine 3+, AG 30
New DM type 1';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for culture before any antibiotic"},{"label":"B","text":"Bacterial Meningitis likely Meningococcus (gram-neg diplococci + petechiae)"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Acyclovir only"},{"label":"E","text":"Steroid only without antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bacterial Meningitis likely Meningococcus (gram-neg diplococci + petechiae): IMMEDIATE IV antibiotic within 1h — Ceftriaxone 100 mg/kg/d + Vancomycin 60 mg/kg/d (until Spn sens known); Dexamethasone 0.15 mg/kg q6h × 2-4d (give before/with first antibiotic); resuscitation; ICU monitoring; droplet isolation 24h; public health reporting; chemoprophylaxis close contacts (rifampin, cipro, ceftriaxone single dose); audiology follow-up (hearing loss risk)

---

Bacterial meningitis = peds emergency. Gram-neg diplococci → N. meningitidis. Time to antibiotic = key prognostic factor — give within 1h. Empiric ceftriaxone + vancomycin. Dexamethasone before/with antibiotic. Isolation + chemoprophylaxis for meningococcal contacts. Long-term: hearing + developmental follow-up. MenACWY + MenB vaccines.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี ไข้สูง + คอแข็ง + ปวดศีรษะ + ซึม + กระสับกระส่าย × 24 ชม Vaccine complete

V/S: BP 98/62, HR 142, RR 32, Temp 39.6°C
GCS 12, neck stiffness +, Kernig + Brudzinski +
Mild petechial rash chest

CBC: WBC 22,500, CRP 285, Lactate 4.2
CT brain: normal
LP: WBC 1,850 (PMN 95%), Protein 220, Glucose 18, Gram stain: gram-neg diplococci';

update public.mcq_questions
set choices = '[{"label":"A","text":"Admit for EEG + MRI + LP mandatory"},{"label":"B","text":"Simple Febrile Seizure (6 mo-5 yr, generalized, < 15 min, single in 24h, normal exam)"},{"label":"C","text":"Long-term phenytoin prophylaxis"},{"label":"D","text":"Discharge without counseling"},{"label":"E","text":"Continuous IV anticonvulsant infusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Simple Febrile Seizure (6 mo-5 yr, generalized, < 15 min, single in 24h, normal exam): Reassurance (cornerstone — usually benign, recurrence 30%, epilepsy 2-5%); treat fever source (URI viral here); antipyretics for comfort (NOT to prevent recurrence — proven no benefit); NO routine EEG/MRI/LP for simple FS with normal exam in non-toxic well-vaccinated child > 12 mo; NO anticonvulsant prophylaxis; counsel parents: recurrence, safety, when to call EMS (> 5 min, breathing trouble); complex FS (focal, > 15 min, recurrent in 24h, abnormal exam) → fuller workup

---

Simple Febrile Seizure: 6 mo-5 yr, fever > 38°C, generalized, < 15 min, single in 24h, normal exam, no CNS infection/metabolic cause. Most common peds seizure (3-5%). Strong familial. Recurrence 30%, epilepsy 2-3% (vs 1% baseline). AAP 2011/2018: minimal workup if classic + well-appearing + > 12 mo + vaccines complete. No prophylactic anticonvulsant. Education + reassurance + safety.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน development normal มา ED ชักทั้งตัว tonic-clonic 5 นาที ขณะไข้ 39.8°C จาก URI เริ่ม 2 ชม ก่อน หลังชักซึม 10-15 นาทีแล้วฟื้นปกติ ครอบครัวพ่อมีประวัติ febrile seizure

ไม่มี neuro deficit, neck supple, fontanelle ปกติ, no rash
WBC 9,200, glucose 96';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — likely viral croup"},{"label":"B","text":"Suspected Foreign Body Aspiration (peds emergency)"},{"label":"C","text":"Heimlich maneuver in office"},{"label":"D","text":"Antibiotic + bronchodilator + outpatient"},{"label":"E","text":"Steroid alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Foreign Body Aspiration (peds emergency): clinical history + asymmetric breath sounds + CXR signs = high suspicion; don''t disturb child (avoid converting partial to complete obstruction); allow comfortable position + O2; avoid blind finger sweep, back blows/abdominal thrust (per AHA peds BLS — only for complete obstruction with no air movement); urgent RIGID bronchoscopy in OR under GA by experienced peds ENT + anesthesia (diagnosis + removal); CT chest if equivocal but don''t delay; post-extraction monitor edema (steroid), pneumonia; prevention counseling — high-risk foods < 4 yr

---

FBA — most common accidental death in toddlers. Peak 1-3 yr. Peanuts, popcorn, grapes, hot dogs, beads. Triad: choking + cough + wheeze (50%). CXR normal in 25% (radiolucent). Asymmetric breath sounds, air trapping, atelectasis, mediastinal shift on expiratory film. Rigid bronchoscopy by experienced team. Don''t agitate child + avoid blind interventions. AHA BLS: back blows/thrusts only for complete obstruction without air movement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 3 ปี healthy มา ED ไอเสียงดังบ่อย ๆ + เหมือนสำลัก + stridor inspiratory × 30 นาที ลดลงเล็กน้อย ยังมีอยู่ ไม่มีไข้ ประวัติเล่นกับถั่วลิสง 30 นาทีก่อน

V/S: HR 132, RR 28, SpO2 94%
Gen: anxious, mild distress
Stridor inspiratory mild, air entry decreased RLL, no wheeze

CXR (expiratory): RLL hyperinflation + slight mediastinal shift';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid pulse therapy high dose"},{"label":"B","text":"Post-streptococcal AGN (PSGN)"},{"label":"C","text":"Renal transplant evaluation"},{"label":"D","text":"Aggressive immunosuppression"},{"label":"E","text":"Discharge with high-protein diet"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-streptococcal AGN (PSGN) — classic features: nephritic syndrome, low C3 + normal C4, ASO elevated, RBC casts, recent strep: Supportive care (mainstay — usually self-limiting in children > 95% recover): salt + fluid restriction, diuretic (furosemide) for edema + HT, antihypertensive if severe; NO routine steroid; Penicillin × 10 days (eradicate strep + prevent transmission, not change PSGN course); Monitor BP, UO, weight, electrolytes, Cr; C3 normalize within 8 wk — if persistent → biopsy + DDx (MPGN, lupus, dense deposit); long-term follow-up 1-2 yr

---

PSGN — classic peds nephritic syndrome 1-3 wk after GAS infection. Immune complex deposition. Features: hematuria + RBC casts + proteinuria + HT + edema + AKI + LOW C3 + normal C4 + elevated ASO. Self-limiting > 95% children. Supportive care. NO routine steroid. C3 normalize 6-8 wk — if persistent → biopsy. DDx: IgA (C3 normal), MPGN (C3 persistent low), Lupus (C3 + C4 low + ANA), HSP (purpura + GI + joints).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี บวมรอบตา + ขา + ท้อง 1 สัปดาห์ ปัสสาวะออกน้อย สีคล้ายเบียร์เข้ม

V/S: BP 138/88 (high for age), HR 92
PE: periorbital + lower extremity pitting edema + mild ascites

Urinalysis: protein 4+, blood 3+, RBC casts + dysmorphic RBCs
Lab: Albumin 1.8, Cr 0.8, Chol 380, C3 ต่ำ, C4 ปกติ, ASO 480 (high)

ก่อน 3 สัปดาห์ pharyngitis ไม่รักษา';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Early-Onset Neonatal Sepsis (< 72h"},{"label":"C","text":"Discharge home with parental observation"},{"label":"D","text":"Oral antibiotic"},{"label":"E","text":"Hold antibiotic until culture grows"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-Onset Neonatal Sepsis (< 72h — likely GBS, E. coli, Listeria from maternal source): Immediate IV antibiotic within 1h — Ampicillin (GBS, Listeria, susceptible E. coli) + Gentamicin (gram-neg + synergy); cefotaxime if meningitis (NOT ceftriaxone in neonates — kernicterus + Ca precipitation); Septic workup: blood culture × 2, CBC, CRP serial, urine culture (if > 6 days), LP if possible, CXR; Resuscitation: warming, fluid bolus 10-20 mL/kg, vasopressor for hypotension, intubation if needed; NICU; Duration: 10-14d bacteremia, 14-21d meningitis; modify per culture; family support; long-term developmental follow-up

---

Neonatal sepsis: early-onset < 72h (vertical from mother — GBS, E. coli, Listeria) vs late-onset > 72h (hospital/community). Risk factors: prematurity, prolonged ROM > 18h, maternal intrapartum fever, GBS unknown. Signs subtle: temperature instability (hypo > hyper), apnea, poor feeding, lethargy. Sepsis screen: CBC + I/T ratio + CRP + culture. Empirical antibiotic ASAP: ampicillin + gentamicin (NOT ceftriaxone). LP if possible. NICU resuscitation. Duration based on organism + culture + clinical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก 36h GA 34 wk preterm BW 1,800g มาด้วย apnea + cyanosis + lethargy 2 ชม ก่อน ก่อนหน้านี้กินนมได้ดี

V/S: HR 168, BP 56/32 (hypotensive), RR irregular + apnea, Temp 35.8°C (hypothermia), SpO2 88%
Gen: lethargic, poor perfusion
Mother: GBS unknown, ROM 18h, intrapartum fever 38.4°C

Lab: WBC 4,200 (band 24%, I/T 0.4), Plt 102K
ABG: pH 7.20, HCO3 14, Lactate 4.8
CRP 28 (high for neonate)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Normal variation, observe"},{"label":"B","text":"Global Developmental Delay + Regression + Microcephaly progression"},{"label":"C","text":"Refer adult psychiatry"},{"label":"D","text":"Lifestyle change only"},{"label":"E","text":"MRI without other workup"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global Developmental Delay + Regression + Microcephaly progression — neurodegenerative concern (Rett syndrome in girls, mitochondrial, leukodystrophy, neurometabolic): multidisciplinary referral — dev peds, neuro, genetics; Tier 1: chromosomal microarray + Fragile X + MECP2 (Rett — regression 6-18 mo + microcephaly + hand stereotypies + lost purposeful hand use + breathing irregularities); brain MRI; metabolic screen (ammonia, lactate, AA, OA, acylcarnitine, VLCFA, MPS, lysosomal); TSH, CK; Tier 2: whole exome sequencing, mtDNA; Early intervention (don''t wait for dx): PT/OT/speech; Family support + genetic counseling; symptomatic + specific treatments for some metabolic disorders

---

Developmental regression + microcephaly progression = red flag for neurodegenerative disease. Rett syndrome: girls, 6-18 mo regression + lost hand use + stereotypies + microcephaly progression + breathing irregularities + seizures — MECP2 gene (X-linked). Other: neurometabolic, leukodystrophies, neurogenetic syndromes. Tiered workup. Early intervention essential. Multidisciplinary: dev peds, neuro, genetics, therapies, family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิง 14 เดือน normal development จน 9 เดือน หลังจากนั้นช้าลง: ไม่นั่งจน 14 เดือน, ไม่พูดคำ, ไม่ตอบสนองชื่อ, eye contact ลดลง, head circumference จาก 75th → 25th percentile

ไม่มี dysmorphic features
Family: น้องคนพี่ healthy, ไม่มีประวัติพันธุกรรม';

update public.mcq_questions
set choices = '[{"label":"A","text":"Salbutamol nebulization × 1 dose then reassess in 20 min"},{"label":"B","text":"Severe asthma exacerbation (PRAM/PASS high score)"},{"label":"C","text":"ICS increased dose + observe 1 hour"},{"label":"D","text":"Subcutaneous epinephrine + heliox"},{"label":"E","text":"Intubate immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe asthma exacerbation (PRAM/PASS high score): continuous nebulized SABA (salbutamol) + ipratropium nebulization (synergistic) × 3 stacked doses; systemic corticosteroid (oral pred 1-2 mg/kg or IV methylprednisolone 1 mg/kg); IV magnesium sulfate 25-50 mg/kg over 20 min (severe not responding); supplemental O2 to SpO2 ≥ 94%; prepare PICU; consider IV terbutaline, ketamine, or NIV/intubation for impending failure; chest X-ray if focal finding or atypical; admit; follow-up: action plan, ICS optimization, allergy + trigger review

---

Severe peds asthma exacerbation: failed home SABA + signs of severe distress (RR ↑, SpO2 < 92%, accessory muscle use, unable to speak in sentences). GINA + AAP: continuous nebulized SABA + ipratropium; systemic steroid (oral if tolerating, IV if not); IV MgSO4 for severe not responding to SABA dose 1; O2 to ≥ 94%; PICU for not improving. Intubation last resort (high barotrauma risk in status asthmaticus).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี น้ำหนัก 24 kg underlying asthma ICS regular มา ED ด้วยอาการเหนื่อย + wheeze ต่อเนื่อง 6 ชม ก่อนหน้านี้พ่นยา salbutamol ที่บ้านทุก 2 ชม ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 88% room air, Temp 36.8°C
Gen: tired, unable to complete sentences
Use accessory muscles, suprasternal + intercostal retraction marked
Wheezing both lungs, expiratory phase prolonged';

update public.mcq_questions
set choices = '[{"label":"A","text":"Intubation immediately"},{"label":"B","text":"Moderate Croup (viral laryngotracheobronchitis, often parainfluenza)"},{"label":"C","text":"IV antibiotic + admit"},{"label":"D","text":"Albuterol + ipratropium"},{"label":"E","text":"Discharge with cough syrup only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Croup (viral laryngotracheobronchitis, often parainfluenza): Dexamethasone 0.6 mg/kg PO/IV/IM single dose (or budesonide nebulization 2 mg as alternative) — Cochrane evidence reduces revisits, hospitalizations, intubation; Nebulized racemic epinephrine 2.25% 0.5 mL or L-epinephrine 5 mL of 1:1000 for moderate-severe distress at rest (immediate relief but observe 3-4h for rebound); humidified air NOT proven; supportive care, hydration, antipyretic; admit if persistent stridor at rest after Rx, hypoxia, dehydration, comorbidity; discharge home with parental education + return precautions

---

Croup (viral) common 6 mo-6 yr, parainfluenza most. Westley score grades severity: 0-2 mild, 3-5 moderate, 6-11 severe, 12+ impending failure. Mild: dexamethasone + discharge. Moderate-severe: + nebulized epinephrine, observe 3-4h. DDx: epiglottitis (toxic, drooling, tripod — Hib vaccine reduced), bacterial tracheitis, FBA, retropharyngeal abscess. Humidified air debunked. Single-dose dex effective.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี ก่อนหน้านี้ healthy มาด้วยอาการไอเสียงเห่า (barking) + stridor inspiratory + hoarseness + ไข้ต่ำ 38.2°C เริ่ม 24 ชม ก่อน ก่อนหน้านี้มี URI 2 วัน

V/S: HR 132, RR 32, SpO2 95% room air
Gen: alert, mild distress at rest, no drooling, no toxic appearance
Stridor inspiratory at rest, mild retraction, no cyanosis
Voice hoarse, barking cough

Westley croup score = 4 (moderate)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for culture, no treatment"},{"label":"B","text":"Febrile UTI / Pyelonephritis (toddler with positive UA + flank tenderness)"},{"label":"C","text":"Symptomatic only"},{"label":"D","text":"Surgery immediately"},{"label":"E","text":"Long-term prophylactic antibiotic for all"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Febrile UTI / Pyelonephritis (toddler with positive UA + flank tenderness): Empirical antibiotic — oral if tolerating + non-toxic (cefixime, cefpodoxime, amoxicillin-clavulanate) × 7-10 days OR IV if toxic/dehydrated/refusing PO (ceftriaxone 50 mg/kg/d then switch to PO); urine culture to guide; renal/bladder US within 2 weeks (AAP 2011 — first febrile UTI all children 2-24 mo); VCUG only if abnormal US or recurrence (AAP 2011 change from prior recommendation); follow-up: clinical resolution, repeat UA + culture only if persistent symptoms; counsel: hygiene, hydration, recognize recurrence symptoms; long-term: minority develop renal scarring (5-15%) — risk factor VUR

---

Pediatric UTI: 2-24 mo with fever, esp female + uncircumcised male, requires evaluation. Catheterized or suprapubic specimen (bag culture unreliable). E. coli most common. AAP 2011 (revised 2016): empirical antibiotic (oral OK if non-toxic) 7-10 d; US within 2 wk first febrile UTI; VCUG only if abnormal US or recurrence (departed from prior). Long-term: renal scarring risk in minority; VUR association. Counsel hygiene + hydration + recurrence signs.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 18 เดือน มาด้วยไข้สูง 39.4°C × 48 ชม ไม่มีอาการระบุชัดเจน irritable + ดื่มน้ำน้อยลง ปัสสาวะออกน้อย

Vaccine complete
V/S: HR 132, BP 92/58, RR 24, Temp 39.4°C
Gen: irritable, well-hydrated mostly
Kidney area: percussion tenderness left

Urinalysis (catheter sample): WBC > 100, nitrite +, leukocyte esterase +, bacteria +
Urine culture: pending
CBC: WBC 16,500, CRP 88';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent surgery without correction"},{"label":"B","text":"Hypertrophic Pyloric Stenosis"},{"label":"C","text":"Antibiotic + observation"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypertrophic Pyloric Stenosis: correct electrolyte + dehydration FIRST before surgery (NOT a surgical emergency — metabolic correction critical): IV NSS 20 mL/kg bolus if shock, then D5 1/2 NS + KCl 20-40 mEq/L at 1.5-2× maintenance; goal: Cl > 100, HCO3 < 26-30, K > 3.5, urine Cl > 20; NPO + NG decompression if vomiting; then Ramstedt pyloromyotomy (open or laparoscopic) — definitive, excellent outcomes; post-op: feeds advance within 4-8h; rarely persistent vomiting; counsel parents: not preventable, very good prognosis

---

Hypertrophic Pyloric Stenosis: presents 2-12 wk (peak 3-5 wk), males 4:1, firstborn. Projectile non-bilious vomiting + hungry after + visible peristalsis + olive mass (60%). US diagnostic (muscle > 4 mm, channel > 15 mm). Classic: hypochloremic hypokalemic metabolic alkalosis from loss of HCl. CORRECT METABOLIC DERANGEMENT FIRST (not surgical emergency). Anesthesia risk if not corrected (paradoxic aciduria, post-op apnea). Ramstedt pyloromyotomy curative. Excellent prognosis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 5 สัปดาห์ มาด้วยอาการอาเจียนพุ่ง (projectile) ทุกมื้อนม 2 สัปดาห์ น้ำหนักลด 200 g ก่อนหน้านี้กินดี

V/S: HR 142, dehydration moderate
Gen: hungry after vomiting ("hungry vomiter")
Abdomen: visible peristalsis epigastrium + palpable "olive-like" mass RUQ

Lab: Na 134, K 3.2 (low), Cl 92 (low), HCO3 32 (high) — hypochloremic, hypokalemic metabolic alkalosis
US abdomen: pyloric muscle thickness 5 mm, pyloric channel length 18 mm — consistent with hypertrophic pyloric stenosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation only"},{"label":"B","text":"Neonatal Hyperbilirubinemia from ABO incompatibility hemolysis (high risk per AAP Bhutani nomogram > 95th percentile + risk factors)"},{"label":"C","text":"Discharge with sunlight exposure"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"IV antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Hyperbilirubinemia from ABO incompatibility hemolysis (high risk per AAP Bhutani nomogram > 95th percentile + risk factors): immediate intensive phototherapy (target > 12 cm² body surface); hydration support (continue breastfeeding + supplementation if needed — NOT routine IVF unless dehydrated); exchange transfusion threshold based on age + risk + bilirubin trend (per AAP 2022 guideline curves) — typically TSB > 25 mg/dL in term healthy or > 20 + risk factors; monitor TSB q4-6h; check for ABO/Rh, G6PD, sepsis, sepsis, infection; phototherapy continued until TSB safely below threshold; long-term hearing screen (kernicterus = irreversible brain damage); counsel parents

---

Neonatal hyperbilirubinemia: physiologic (peak day 3-5, < 12 mg/dL term) vs pathologic (early < 24h, rapid rise, prolonged, direct > 20%). Causes: hemolytic (ABO, Rh, G6PD, hereditary spherocytosis), polycythemia, breastfeeding (suboptimal feeding) vs breast milk (later, > 7d), sepsis, hypothyroidism, biliary atresia (direct). AAP 2022 guidelines: TSB-age-based curves. Phototherapy first-line. Exchange for very high TSB. Kernicterus = bilirubin encephalopathy (lethargy, hypertonia, opisthotonos, sensorineural hearing loss).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกแรกเกิด GA 38 wk BW 3.2 kg วันที่ 4 หลังเกิด มีอาการตัวเหลือง พ่อแม่กังวล

V/S: stable, breastfeeding ปานกลาง (น้ำหนักลด 9% ของน้ำหนักแรกเกิด), urine output ปานกลาง
Gen: alert, jaundice ลามถึงท้องและขา

Blood group: mother O+, baby A+, DAT positive
Total bilirubin: 22 mg/dL (high), Direct 0.8
Hb 14.2, retic 4% (high), peripheral smear: spherocytes, microspherocytes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Critical cyanotic congenital heart disease (D-TGA)"},{"label":"C","text":"Discharge with oxygen at home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical cyanotic congenital heart disease (D-TGA) — neonatal emergency: Maintain ductal patency — PROSTAGLANDIN E1 (alprostadil) IV infusion 0.05-0.1 mcg/kg/min (start immediately; allows mixing through PDA between parallel circulations); monitor for side effects (apnea, hypotension, fever); NICU/cardiac ICU admission; pediatric cardiology consult — cardiac catheterization + balloon atrial septostomy (Rashkind) within hours (improves mixing at atrial level); definitive surgery — arterial switch operation (ASO/Jatene) within first 2-3 weeks of life; pre-op stabilization: avoid hyperoxia + acidosis + temperature derangement; family counseling + multidisciplinary cardiac team

---

Critical cyanotic CHD presenting early: D-TGA most common (egg-on-string CXR); also TAPVR, Tricuspid atresia, Truncus, Tetralogy + critical PS. Ductal-dependent — PGE1 maintains PDA for circulation mixing/blood flow. Hyperoxia test failed PaO2 < 150 = likely cardiac. Echo confirms. Rashkind balloon atrial septostomy = bridge. Arterial switch (Jatene) within 2-3 weeks. Pulse oximetry screening newborn (post-ductal > 95% + < 3% difference pre/post-ductal) — universal in many countries.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกแรกเกิด GA 39 wk BW 3.4 kg อายุ 2 วัน มีอาการ central cyanosis ต่อเนื่อง SpO2 78% pre-ductal และ 76% post-ductal, ไม่ดีขึ้นด้วย O2 100%

V/S: HR 152, RR 58, BP 64/40, Temp 36.8°C
PE: no respiratory distress, well-perfused, no murmur clearly heard

Hyperoxia test: PaO2 from 38 → 62 (failed to rise > 150 — suggests cardiac cause)
CXR: "egg on a string" appearance + decreased pulmonary vasculature
Echo: D-Transposition of Great Arteries (D-TGA), intact ventricular septum, small PDA, small PFO';

update public.mcq_questions
set choices = '[{"label":"A","text":"Transfusion immediately"},{"label":"B","text":"Severe Iron Deficiency Anemia (cow milk excess + low intake of iron-rich food)"},{"label":"C","text":"IV iron infusion immediately"},{"label":"D","text":"Bone marrow biopsy"},{"label":"E","text":"Erythropoietin"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Iron Deficiency Anemia (cow milk excess + low intake of iron-rich food): correctable nutritional cause: Oral iron supplementation 3-6 mg/kg/day elemental iron in divided doses (or single daily — equivalent efficacy with better adherence per recent evidence); vitamin C to enhance absorption (give with citrus juice not milk); limit cow milk to < 500 mL/day (cow milk inhibits iron absorption + GI microbleeding); introduce iron-rich complementary foods (meat, fortified cereal, beans, dark green vegetables); reassess Hb 4 weeks (expect rise 1-2 g/dL); continue iron 3 months after Hb normal to replete stores; severe symptomatic anemia (HR > 180, CHF, severe pallor): consider transfusion (small aliquots over time to avoid CHF — transfusion-related); investigate other causes if no response (occult blood loss, malabsorption, parasites); developmental follow-up (iron deficiency linked to cognitive deficits)

---

Pediatric IDA: peak 9-24 mo. Causes: cow milk excess > 500 mL/d (low Fe + induces GI microbleeding + low solid food intake); preemie/LBW (low stores); rapid growth. Diagnosis: microcytic hypochromic + low ferritin + low transferrin sat. DDx: thalassemia (high ferritin), anemia of chronic disease (high ferritin). Treatment: oral iron 3-6 mg/kg/d + vitamin C + dietary modification. Reassess 4 wk. Continue 3 mo post-Hb normal. Long-term: cognitive impact — early treatment important. Iron-fortified cereal + meat in complementary feeding (start 6 mo).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 8 เดือน มาด้วยผิวซีดมา 2 เดือน อ่อนเพลีย กินอาหารน้อย ส่วนใหญ่ดื่มนมวัวมาก (1.5 L/day) ตั้งแต่ 6 เดือน ไม่กินอาหารแข็ง

V/S: HR 132 (tachycardia), BP 88/52, Temp 36.8°C
Gen: pale, irritable, developmental milestones at age level
Mild systolic murmur grade 2/6 (flow murmur)

Lab: Hb 6.4 (severe anemia), MCV 58 (microcytic), MCH 18 (hypochromic), RDW 22% (high), Reticulocyte 1.0%, Ferritin 4 ng/mL (very low), Iron 18, TIBC 520, Transferrin sat 4%
Thalassemia screening: negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with multivitamins"},{"label":"B","text":"Failure to Thrive"},{"label":"C","text":"Operate for suspected obstruction"},{"label":"D","text":"Antibiotic empirical"},{"label":"E","text":"Ignore — will catch up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Failure to Thrive — multifactorial workup + multidisciplinary management: (1) Comprehensive history: diet (24h recall, food diary), feeding patterns, family + social, medical, GI symptoms; (2) Examination: anthropometrics (weight, height, head circumference, BMI plotted), signs of malnutrition + micronutrient deficiency, developmental assessment; (3) Workup: CBC, electrolytes, BUN, Cr, glucose, LFT, TSH, urinalysis, celiac serology, stool studies (O&P, occult blood); sweat chloride if suspicion CF; HIV; specific tests based on history; (4) Multidisciplinary: pediatrician, dietitian, social worker (food security, family support), developmental specialist, possibly psychiatry (eating disorder, depression), speech therapy (feeding/swallowing); (5) Nutritional rehabilitation: increase calorie density, supplemental feeds, NG/G-tube if severe; (6) Social interventions: food assistance, WIC, family support, evaluate for neglect (rare but consider); (7) Hospitalization criteria: severe malnutrition, refractory weight loss, suspected abuse/neglect, family inability to manage; (8) Re-feeding precaution if severe; (9) Long-term: developmental follow-up, school readiness, prevention of recurrence

---

Failure to Thrive (FTT) = inadequate growth (weight < 3rd or 5th percentile, weight loss, or crossing 2 major percentile lines downward). Causes: organic (5-10% — CF, CHD, GI malabsorption, metabolic, endocrine, neurologic), non-organic (psychosocial — most common — feeding interactions, neglect, food insecurity, depression, postpartum). Workup: history + exam first then targeted labs. Multidisciplinary essential. Treat cause. Nutritional rehab. Social intervention often key. Don''t miss neglect/abuse but don''t assume. Long-term: developmental, cognitive impacts.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี น้ำหนัก 9 kg (< 3rd percentile) ส่งจาก outpatient clinic ด้วยอาการน้ำหนักไม่เพิ่ม 6 เดือน + อาเจียนเป็นๆ หายๆ + กินอาหารน้อย + พัฒนาการช้า (ไม่พูดคำ ไม่เดินมั่นคง)

Family: parents working long hours, ทารกอยู่กับยายอายุ 75 ปี ภาวะเศรษฐกิจไม่ดี

Gen: pale, thin, lethargic, signs of micronutrient deficiency (cheilosis, koilonychia)
Mild abdominal distension
No organomegaly
No dysmorphic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with vitamin K"},{"label":"B","text":"Non-Accidental Injury (NAI) / Child Abuse"},{"label":"C","text":"Counsel parents and discharge"},{"label":"D","text":"Ignore — accidental"},{"label":"E","text":"Surgical correction of bruises"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Accidental Injury (NAI) / Child Abuse — multiple red flags: history inconsistent with injuries, multiple bruises different ages on non-bony sites, retinal hemorrhages (shaken baby), developmental delay, parental risk factors. Mandatory action: (1) Admit hospital for safety + workup; (2) Comprehensive evaluation: skeletal survey (occult fractures — rib, metaphyseal), head CT (subdural hematoma, edema, axonal injury), abdominal CT if concern, ophthalmology (retinal hemorrhages — specific for abusive head trauma), bone scan if concerning, coagulation studies (rule out bleeding disorder); (3) MANDATORY REPORT to child protective services / police (legally required, do not delay or ask parents'' permission); (4) Multidisciplinary child protection team consultation; (5) Social work + psychiatric assessment of family; (6) Safety plan before discharge — may require foster care, kinship placement, or supervised visits; (7) Court testimony documentation; (8) Long-term: developmental, behavioral, psychological follow-up (high risk PTSD, attachment, future problems); (9) Sibling assessment (others at risk); (10) Treatment + support for non-offending parent if applicable

---

Child abuse / Non-Accidental Injury — high mortality (death in infants common): red flags = history inconsistent with injuries; injuries at different ages; non-bony sites (back, buttocks, ears, neck); patterns (handprint, bite, ligature); retinal hemorrhages bilateral multi-layer (abusive head trauma / shaken baby); rib fractures (esp posterior, in infants); developmental delay + neglect signs. Mandatory reporting (legally required, immediately, do not need parental permission). Skeletal survey + head imaging + ophthalmology. Multidisciplinary: pediatrics, child abuse specialist, social work, CPS, law enforcement, possibly forensics. Safety FIRST. Document carefully. Long-term outcomes worse if unrecognized + return to abusive environment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 9 เดือน นำส่งโดยพ่อแม่ด้วยอาการ multiple bruises ที่ขา + แขน + หลัง + ก้น 3 สัปดาห์ ไม่มีประวัติบาดเจ็บที่ชัดเจน หรือเล่ามีแต่ "ตกจากเก้าอี้"

Vaccine partial (delayed)
Development delayed (no sitting at 9 months, no babbling)

V/S: HR 132, BP 88/56, Temp 36.8°C, น้ำหนัก < 5th percentile
PE: multiple bruises ในระยะต่างๆ (different colors — yellow, blue, purple) ที่ป้องและ non-bony sites; subconjunctival hemorrhage; circular bruise คล้ายรอยมือ
Fundoscopy: bilateral retinal hemorrhages multiple layers

Family: father unemployed, mother depressed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Symptomatic only"},{"label":"B","text":"Cystic Fibrosis"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Probiotic only"},{"label":"E","text":"Discharge with cough syrup"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cystic Fibrosis — multisystem disease requiring multidisciplinary care: (1) Respiratory: airway clearance (chest physiotherapy, oscillating PEP, hypertonic saline neb, dornase alfa, exercise), CFTR modulator therapy (elexacaftor/tezacaftor/ivacaftor for F508del — "Trikafta" — major outcome improvement), antibiotic (acute exacerbations + chronic suppressive for Pseudomonas), inhaled antibiotics (tobramycin, aztreonam); (2) Pancreatic insufficiency: pancreatic enzyme replacement therapy (PERT — Creon) with meals, fat-soluble vitamin supplements (ADEK), high-calorie diet (120-150% RDA), salt supplementation; (3) Sweat chloride loss prevention: extra salt, hydration; (4) Endocrine: monitor for CF-related diabetes (annual OGTT from age 10), osteoporosis (DEXA); (5) GI: monitor for distal intestinal obstruction syndrome, biliary cirrhosis, GERD; (6) Reproductive: counseling (males infertile due CBAVD, females reduced fertility); (7) Vaccinations: all routine + annual influenza + pneumococcal + COVID; (8) Multidisciplinary CF center care: pediatric pulmonology, gastroenterology, nutritionist, social work, psychology, respiratory therapy; (9) Family genetic counseling (autosomal recessive); (10) Newborn screening confirmation in younger siblings; (11) Long-term: lung transplant evaluation when FEV1 < 30% predicted; survival ~ 50 years modern with Trikafta

---

Cystic Fibrosis: autosomal recessive, CFTR gene (most common F508del), affects exocrine glands. Multisystem: respiratory (chronic infection, bronchiectasis), pancreatic insufficiency (steatorrhea, FTT), CF-related diabetes, sweat chloride loss, infertility (CBAVD males), biliary, sinopulmonary, intestinal obstruction. Diagnosis: newborn screening (immunoreactive trypsinogen), sweat chloride > 60, CFTR genetic testing. Multidisciplinary CF center care. Trikafta (elexacaftor/tezacaftor/ivacaftor) revolutionized care for F508del. Survival ~ 50 yr modern. Lung transplant for end-stage.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี น้ำหนัก 18 kg มาด้วยอาการ chronic ไอเรื้อรัง + เหนื่อย + น้ำหนักไม่เพิ่ม 6 เดือน + ถ่ายอุจจาระมีน้ำมันมัน + อาเจียน

Vaccine complete
Family: ลูกพี่ลูกน้องสมาชิกครอบครัวมี cystic fibrosis

V/S: HR 102, RR 22, SpO2 96%, ไม่มีไข้
Gen: pale, thin, mild clubbing
Lungs: occasional crackles bilateral, mild expiratory wheeze
Abdomen: distended, mild tenderness, no hepatosplenomegaly
Pilonidal area: bulky stool noted on undergarment

Sweat chloride test: 78 mEq/L (high — > 60 = positive)
CFTR genetic testing: F508del homozygous
Fecal elastase: < 100 (pancreatic insufficiency)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same dose as adult per body weight"},{"label":"B","text":"Pediatric dosing requires consideration of developmental pharmacokinetics"},{"label":"C","text":"Halve adult dose for all children"},{"label":"D","text":"Pediatric-specific dosing not necessary"},{"label":"E","text":"Use weight only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric dosing requires consideration of developmental pharmacokinetics: (1) Absorption — gastric pH higher in neonates (favors penicillin, disfavors weak acids); slower gastric emptying; (2) Distribution — higher % water (neonates 75% water vs adult 60% — increased Vd of water-soluble drugs like aminoglycosides); lower albumin (higher free fraction of bound drugs — bilirubin displacement risk in neonates with ceftriaxone, sulfa); BBB permeable in neonate; (3) Metabolism — CYP450 immature at birth → mature by age 1 (varies); UGT (glucuronidation) immature → ''gray baby syndrome'' with chloramphenicol; (4) Excretion — GFR low at birth, matures by 1 yr → renal drug dose adjustment; (5) Dosing methods: weight-based (mg/kg) for most; body surface area (m²) for chemotherapy; age-band approximations; (6) Special considerations: ceftriaxone CI in neonates < 4 wk (bilirubin displacement + Ca precipitation); chloramphenicol gray baby syndrome; tetracycline tooth/bone deposition < 8 yr; fluoroquinolone cartilage concern; aspirin Reye syndrome with viral illness; codeine/tramadol CI < 12 yr; benzyl alcohol toxicity in preservatives; (7) Always verify dose + use pediatric-specific resources

---

Pediatric pharmacology = different from adult due to developmental changes in ADME. Weight-based dosing standard. Special CI: ceftriaxone < 4 wk (bilirubin, Ca), chloramphenicol (gray baby), tetracycline < 8 yr (tooth, bone), fluoroquinolone (cartilage), aspirin + viral illness (Reye), codeine < 12 yr (variable metabolism, respiratory depression). Verify dose meticulously.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Neonatal Transitional Circulation"},{"label":"C","text":"No transition occurs"},{"label":"D","text":"PDA never closes"},{"label":"E","text":"Foramen ovale always patent"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Transitional Circulation: fetal — high pulmonary vascular resistance (PVR), low systemic vascular resistance (SVR), R→L shunting through ductus arteriosus + foramen ovale + ductus venosus; oxygenation from placenta. AT BIRTH: (1) First breath expands lungs → ↓PVR + ↑oxygenation → pulmonary blood flow increases; (2) Cord clamping → loss of placental low-resistance circuit → ↑SVR; (3) Increased pulmonary venous return → ↑LA pressure → functional closure of foramen ovale (anatomic 3 mo-1 yr); (4) Higher PaO2 + ↓ prostaglandins → functional closure of ductus arteriosus (anatomic by 2-3 weeks); (5) Ductus venosus closes when umbilical flow stops; (6) Persistent fetal circulation (PPHN — persistent pulmonary HT of newborn) if PVR fails to drop — causes: meconium aspiration, sepsis, RDS, congenital diaphragmatic hernia — Rx: 100% O2, sedation, mechanical vent, iNO (selective pulmonary vasodilator), milrinone, ECMO; ductal-dependent CHD (HLHS, critical AS/PS, TGA, Tricuspid atresia) — PGE1 maintains PDA until surgery

---

Neonatal transition: fetal R→L shunts + high PVR → newborn L→R adult circulation. Trigger: first breath + cord clamping. PVR drops, SVR rises, shunts close. PPHN if PVR fails to drop (iNO, ECMO). Ductal-dependent CHD: PGE1 maintains PDA (HLHS, critical AS/PS, TGA, Tricuspid atresia). PPS (peripheral pulmonary stenosis) common in newborns from incomplete transition — benign murmur usually.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Resident ถาม physiology — neonatal transitional circulation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Infant immune system maturation"},{"label":"C","text":"Adults respond same as infants"},{"label":"D","text":"No need for vaccination"},{"label":"E","text":"Single dose universal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infant immune system maturation: (1) Innate: present at birth but qualitatively + quantitatively immature; (2) Adaptive: passive (maternal IgG transplacentally — protects 6 mo, wanes), active maturing; (3) Maternal IgG falls 6-9 mo while infant own immune building → ''physiologic hypogammaglobulinemia'' (6-9 mo nadir) → susceptibility window; (4) IgA in breast milk — mucosal protection; (5) IgM appears first to new antigen; IgG class switching; (6) T-cell response immature — Th2-biased — atopy susceptibility; (7) Vaccine response: live attenuated (MMR, varicella, rotavirus, BCG) need cellular immunity — given after 6 mo; inactivated/subunit/conjugate (DTaP, Hib, PCV13, Hepatitis B, polio IPV) — given starting birth/2 mo; conjugate vaccines (PCV, Hib, MenACWY) — conjugate protein to polysaccharide for T-cell-dependent response in infants; (8) Polysaccharide unconjugated vaccines (pneumovax 23) poorly immunogenic < 2 yr — give after 2 yr; (9) Live vaccines CI in pregnant, severe immunodeficiency, recent IVIG (delay 11 mo for MMR/varicella)

---

Infant immune system immature + Th2-biased. Maternal IgG protects ~ 6 mo then wanes. Live vaccines after 6-12 mo (cellular immunity needed). Conjugate vaccines key — convert T-independent polysaccharide to T-dependent (PCV, Hib, MenACWY) — effective in infants. Unconjugated polysaccharide (PPSV23) ineffective < 2 yr. Maternal vaccination (Tdap pregnancy, RSV, COVID, influenza) → passive transfer protects infant. Live vaccines CI in pregnancy + immunocompromised.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'อาจารย์อธิบาย immunology — infant immune system + vaccine response';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Pediatric Fluid Management"},{"label":"C","text":"8-4-2 rule"},{"label":"D","text":"Always restrict fluid"},{"label":"E","text":"Adult formula"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Fluid Management: (1) Maintenance fluid ''4-2-1 rule'' (Holliday-Segar): 4 mL/kg/hr first 10 kg + 2 mL/kg/hr next 10 kg + 1 mL/kg/hr each additional kg (e.g., 25 kg child = 40 + 20 + 5 = 65 mL/hr); (2) Maintenance fluid composition: isotonic — D5 NS preferred over D5 0.45 NS (Cochrane evidence — hypotonic causes iatrogenic hyponatremia, especially in ill children) — AAP 2018 endorse isotonic; (3) Resuscitation: NSS or LR 20 mL/kg bolus over 15-30 min for shock, may repeat × 2-3 then assess + consider blood/colloid; (4) Dehydration assessment: mild (3-5%), moderate (6-9% — sunken eyes, dry MM, decreased turgor, prolonged capillary refill, tachycardia), severe (≥ 10% — lethargic, sunken fontanelle, very poor perfusion, hypotension late sign in peds); (5) Replacement: 50% deficit + maintenance over first 8h, remaining 50% over next 16h; oral rehydration solution (ORS) preferred for mild-moderate (cheaper, safer, effective); (6) Electrolyte considerations: K based on serum + UO; correct Na slowly (max 10-12 mEq/L/d to avoid central pontine myelinolysis); (7) Special situations: DKA (cautious slow fluid as discussed), burns (Parkland formula for kids), neonatal (different calculations)

---

Pediatric fluid management essential skill. 4-2-1 rule (Holliday-Segar 1957) for maintenance. AAP 2018 + NEJM 2018 (Friedman): isotonic preferred over hypotonic (less iatrogenic hyponatremia, esp ill children). 20 mL/kg bolus for shock (can repeat). Replace deficit over 24h (DKA 48h slower). ORS for mild-moderate dehydration. Cautions: rapid Na correction (CPM), DKA cerebral edema, neonatal special, burns Parkland. Frequent re-assessment + adjustment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single intervention solves all"},{"label":"B","text":"Comprehensive Child Health Program"},{"label":"C","text":"Adult medicine principles only"},{"label":"D","text":"Ignore prevention"},{"label":"E","text":"Single specialty manages"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive Child Health Program — multi-level intervention: (1) Antenatal: maternal nutrition + iron + folate, vaccination (Tdap, flu, COVID, RSV maternal), screening (gestational diabetes, group B Strep), education; (2) Intrapartum: skilled birth attendant, group B Strep prophylaxis if indicated, immediate skin-to-skin contact, delayed cord clamping (1-3 min — improves iron stores), early breastfeeding initiation; (3) Newborn: routine care (vitamin K, eye prophylaxis, hepatitis B vaccine), newborn screening (heel prick — congenital hypothyroidism, PKU, sickle cell, CF, etc.), pulse oximetry screening (critical CHD), hearing screening; (4) Well-child visits at scheduled intervals: growth + development monitoring, anticipatory guidance, vaccinations per CDC/local schedule, screening (lead, anemia, vision, hearing, autism, depression in adolescents); (5) Vaccination: universal + catch-up programs, education, address vaccine hesitancy, school requirements; (6) Nutrition: breastfeeding promotion (6 mo exclusive), complementary feeding 6 mo, micronutrient programs (iron, vitamin D, vitamin A), school meal programs; (7) Safety: car seats, helmets, water safety, firearm storage, lead paint; (8) Mental health: screening, school-based programs, family support; (9) Equity: address social determinants (food security, housing, education access); (10) Quality metrics: infant mortality, vaccination coverage, well-child visit completion, screening uptake, hospitalization rates

---

Comprehensive child health — life-course approach + multi-level intervention. WHO + AAP + CDC frameworks. Key components: antenatal, intrapartum, newborn screening + immunization, well-child visits, anticipatory guidance, safety, mental health, equity. Quality metrics: infant mortality (key indicator), vaccination coverage, screening uptake. Social determinants of health critical. Multidisciplinary + multi-level. Thailand: maternal + child health policy improved outcomes significantly past decades.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics';

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

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAID only at home"},{"label":"B","text":"Sickle cell vaso-occlusive crisis (VOC)"},{"label":"C","text":"Discharge home no analgesia"},{"label":"D","text":"Steroid IV high dose"},{"label":"E","text":"Iron supplement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sickle cell vaso-occlusive crisis (VOC): IV access + IV fluid 1-1.5× maintenance (avoid over-hydration → ATS/pulmonary edema); rapid pain assessment + analgesia ภายใน 30 นาที — IV morphine 0.1-0.15 mg/kg q3-4h หรือ PCA + ketorolac (avoid if dehydration/renal); warmth + reassurance + diversion; O2 ถ้า SpO2 < 95%; blood culture + empiric ceftriaxone ถ้าไข้ > 38.5°C (functional asplenia → encapsulated organism); monitor for acute chest syndrome (new infiltrate + symptom); incentive spirometry; transfusion ถ้า severe anemia หรือ ACS; hydroxyurea long-term ถ้ายังไม่ได้; vaccinations + penicillin prophylaxis

---

VOC = most common acute presentation SCD. Prompt analgesia + hydration. Watch for ACS (life-threatening). Functional asplenia → high infection risk → fever requires evaluation. Long-term: hydroxyurea, transcranial Doppler (stroke screen), HSCT/gene therapy considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี known HbSS มาด้วยปวดขา + หลัง 2 ข้าง รุนแรง 8 ชม pain score 9/10 ไข้ 38.2°C

V/S: HR 122, BP 108/72, RR 24, SpO2 96%, BW 22 kg
PE: tender extremities, no swelling, no chest signs

CBC: Hb 7.8 (baseline 8.5), retic 12%, WBC 15,200, Plt 384,000
CXR clear, BCx pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Folate supplementation"},{"label":"B","text":"Iron deficiency anemia (excess cow milk + dietary insufficient)"},{"label":"C","text":"Blood transfusion routine"},{"label":"D","text":"B12 injection"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iron deficiency anemia (excess cow milk + dietary insufficient): oral elemental iron 3-6 mg/kg/d (sulfate, fumarate, or gluconate) ÷ 1-3 doses ระหว่างมื้อ + vitamin C (ส้ม) เพื่อช่วยดูดซึม; limit cow milk < 500 mL/d; ส่งเสริม iron-rich food (red meat, beans, fortified cereal); recheck retic 1 wk (เพิ่ม), Hb 4 wk (ขึ้น 1-2 g/dL); ต่อ 3 เดือนหลัง Hb ปกติเติม store; investigate ถ้าไม่ตอบสนอง (compliance, ongoing loss, malabsorption); IV iron sucrose ถ้า oral intolerance/malabsorption; screen Hb at 12 mo (AAP); rule out lead exposure

---

IDA = most common pediatric anemia. Cow milk > 500-700 mL/d = major risk factor (low iron, GI bleeding, displaces iron-rich foods). AAP universal screen at 12 mo. Microcytic + low ferritin + high RDW. Replenish stores 3 mo post-normalization. Address dietary cause.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 14 เดือน ดูดนมวัวเต็มกระป๋อง 1.2 L/วัน ตั้งแต่ 9 เดือน ไม่ค่อยกินอาหารแข็ง ซีด เหนื่อยง่าย

V/S ปกติ, BW 10 kg
PE: pale, koilonychia, no organomegaly, no jaundice

CBC: Hb 7.2, MCV 58, MCH 18, MCHC 27, RDW 19, retic LOW
Ferritin 4, TSAT 4%, TIBC HIGH, serum iron LOW';

update public.mcq_questions
set choices = '[{"label":"A","text":"Calcium alone"},{"label":"B","text":"Nutritional Rickets (Vitamin D deficiency)"},{"label":"C","text":"High-dose calcitriol routinely"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery for bowing first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nutritional Rickets (Vitamin D deficiency): Vitamin D3 (cholecalciferol) — Stoss therapy 600,000 IU PO single dose หรือ daily 2,000-6,000 IU × 8-12 wk depending on age + severity; calcium supplement 500-1000 mg/d elemental เมื่อ intake ต่ำ; expose sunlight (15-30 นาที/วัน arms+face); breastfed infant ต้อง vitamin D 400 IU/d ตั้งแต่ first weeks (AAP); recheck Ca, P, ALP, 25(OH)D, PTH ที่ 1 + 3 เดือน; maintenance 400-1,000 IU/d after; XR healing ใน 4-6 wk; investigate other causes (hypophosphatemic, VDDR) ถ้าไม่ตอบสนอง

---

Nutritional rickets = preventable. AAP recommends vitamin D 400 IU/d all breastfed infants from first weeks. Risk factors: exclusively breastfed without supplement, dark skin, limited sun, maternal deficiency. ALP elevated. Healing on X-ray 4-6 wk after treatment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน breastfed exclusively โดยไม่ได้ supplement vitamin D อยู่ใน apartment ไม่ได้ออกแสงแดด มา clinic ด้วย delay walking + bowing legs + frontal bossing

V/S ปกติ, BW 9.5 kg
PE: rachitic rosary, widened wrists, genu varum, frontal bossing

Lab: Ca 8.0, P 2.4 (low), ALP 980 (high), 25(OH)D 8 (low), PTH 142 (high)
XR wrist: cupping + fraying + widened growth plate';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force feed via NG immediately"},{"label":"B","text":"Failure to Thrive (likely psychosocial + caloric insufficiency)"},{"label":"C","text":"Discharge without follow-up"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Failure to Thrive (likely psychosocial + caloric insufficiency): multidisciplinary approach (pediatrician + nutritionist + social worker + lactation/feeding specialist + mental health for mom); detailed dietary + feeding history + 3-day food diary; quantify caloric intake vs need (cal-up to 150 kcal/kg/d catch-up); fortify breast milk + add complementary food calorie-dense (avocado, oil, butter); maternal depression screen + treatment + WIC/government nutrition support; safe environment + nurturing; close growth follow-up q1-2 wk; investigate organic causes selected (celiac, CF, anemia, endocrine, renal); rule out abuse/neglect; hospitalize ถ้า severe (< 80% ideal weight, dehydration, social concern)

---

FTT = inadequate growth velocity. Causes: inadequate intake (most), inadequate absorption, increased need, defective utilization. Most psychosocial + dietary. Multidisciplinary key. Catch-up needs 150 kcal/kg/d. Rule out organic. Address psychosocial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 10 เดือน BW 6.2 kg (< 3rd percentile) length 65 cm (< 3rd) HC 41 cm (5th) — น้ำหนักลด across 2 percentile lines since 4 mo (was 50th)

Feed: breast milk + porridge mostly water, mother depressed, family low income
PE: thin, decreased subcutaneous fat, alert, no dysmorphism, no organomegaly

No medical illness history; CBC normal, CMP normal, TSH normal, sweat chloride pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until 6 months for first vaccines"},{"label":"B","text":"month routine vaccines (Thai EPI + recommended)"},{"label":"C","text":"Only Hepatitis B"},{"label":"D","text":"Defer if mild URI"},{"label":"E","text":"MMR + varicella"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** 2-month routine vaccines (Thai EPI + recommended): DTwP/DTaP, IPV, HepB (2nd dose), Hib, PCV13 (PCV10 also acceptable), Rotavirus (RV1 PO หรือ RV5 first dose, ต้องเริ่มก่อน 15 wk, ครบก่อน 8 mo); สามารถให้ multiple sites ใน same visit; observe 15 นาทีหลังฉีด; ผลข้างเคียงปกติ (low-grade fever, redness/swelling, fussy) ใช้ paracetamol PRN; contraindications absolute น้อย (anaphylaxis ต่อ vaccine; severe immune compromise สำหรับ live vaccines); BCG ให้แรกเกิด (Thai EPI); ครั้งถัดไป 4 mo + 6 mo

---

Thai EPI 2 mo: DTP-HB-Hib (5-in-1) + OPV/IPV + PCV + Rotavirus. AAP/CDC similar. Multiple simultaneous safe. Mild illness not contraindication. Live vaccines (MMR, varicella) start 9-12 mo. Catch-up schedule for delays.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 2 เดือน term, healthy, exclusively breastfed มา well-child visit ครั้งแรกหลังคลอด (Birth visit ได้ Hep B แล้ว) เพื่อ vaccination';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Hypoxic-Ischemic Encephalopathy (moderate, Sarnat II)"},{"label":"C","text":"Warming actively"},{"label":"D","text":"Steroid only"},{"label":"E","text":"Avoid all medication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypoxic-Ischemic Encephalopathy (moderate, Sarnat II): therapeutic hypothermia (selective head หรือ whole-body) start ภายใน 6 ชม of birth, target temp 33.5°C × 72 ชม → rewarm slowly 0.5°C/hr; eligibility: ≥ 36 wk GA, < 6 hr of life, evidence of perinatal acidosis (cord pH ≤ 7 or BE ≤ -16) + Apgar ≤ 5 ที่ 10 นาที หรือ ongoing resuscitation, moderate-severe encephalopathy; supportive care (ventilation, BP, glucose, electrolytes); EEG/aEEG monitor; treat seizures (phenobarbital 20 mg/kg load); avoid hyperthermia + hyperoxia + hypocapnia; MRI day 4-5; long-term developmental + neurology follow-up; counsel family about prognosis

---

HIE = leading cause neonatal neuro-disability term infants. Therapeutic hypothermia within 6 hr = standard of care, reduces death + disability NNT ~7. Sarnat staging guides treatment. EEG/MRI for prognosis. Multidisciplinary follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term GA 39 wk BW 3,500 g คลอด emergency C/S for prolonged labor + cord prolapse Apgar 1/3/5 ที่ 1/5/10 นาที ตอนนี้อายุ 30 นาที seizures + hypotonia + poor feeding

V/S: HR 138, RR via vent, SpO2 96%, Temp 36.8°C
Gen: ventilated, depressed level of consciousness, abnormal tone (hypotonia), abnormal reflexes, frequent seizures

Umbilical artery pH 6.95, BE -16, lactate 12
Sarnat stage II';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until 6 months to treat"},{"label":"B","text":"Congenital Hypothyroidism (athyreosis)"},{"label":"C","text":"Soy formula only"},{"label":"D","text":"PTU"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital Hypothyroidism (athyreosis): start L-thyroxine 10-15 mcg/kg/d PO ทันที (crushed tablet ใน small breastmilk หรือ water — NOT soy formula, iron, calcium ที่ลด absorption); recheck TSH + free T4 ที่ 2 wk + 4 wk + q1-2 mo first year ปรับ dose; target TSH normal range + free T4 upper half of normal; goal: prevent permanent neurological damage (start ภายใน 2 wk of life critical); imaging (US, scintigraphy) for etiology — athyreosis = permanent; counsel family about lifelong treatment + monitoring; developmental follow-up + audiology + ophthalmology baseline

---

CH = most common preventable cause intellectual disability. Newborn screening universal. Start L-thyroxine ASAP (< 2 wk) at high dose 10-15 mcg/kg/d. Avoid soy formula, iron, calcium with dose. Monitor q1-2 mo first year. Athyreosis = permanent; ectopia or dyshormonogenesis variable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Newborn screening positive for elevated TSH at DOL 5 (heel-stick filter paper TSH 80, normal < 20) ทารก term BW 3,400 g ดูปกติ คลำคอไม่พบ goiter

Confirmatory venous: TSH 95, Free T4 0.4 (low)
No dysmorphic features; mother no thyroid disease
US thyroid: athyreosis (no thyroid tissue)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard formula"},{"label":"B","text":"Classic Phenylketonuria"},{"label":"C","text":"High-protein diet"},{"label":"D","text":"BCAA supplementation"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Classic Phenylketonuria: start Phe-restricted special medical formula (Lofenalac, Phenex) ทันที + provide essential amino acids except Phe; lifelong dietary management; goal Phe 2-6 mg/dL ตลอดชีวิต; metabolic geneticist + dietitian team; monitor Phe levels weekly first year + q monthly; allow limited natural protein for Tyr; supplement tyrosine, BH4 cofactor responsive trial (sapropterin); avoid aspartame; pregnancy planning critical (maternal PKU syndrome — fetal effects); growth + developmental monitoring; ใหม่: Phenylalanine ammonia lyase (pegvaliase) adults

---

PKU = autosomal recessive PAH deficiency. Untreated → severe intellectual disability, seizures, eczema, musty odor. Newborn screening + lifelong Phe-restricted diet prevents disability. Maternal PKU = teratogenic without strict control pre-conception. Sapropterin for responsive; pegvaliase enzyme replacement adults.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Newborn screening DOL 5 positive elevated phenylalanine 28 mg/dL (normal < 2) confirmed serum Phe 32 mg/dL with Tyr low normal

ทารก term well-appearing, mother health normal, no family Hx
Confirmatory: BH4 cofactor testing negative (classic PKU not BH4-deficient)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassure no further evaluation"},{"label":"B","text":"Trisomy 21 (Down syndrome)"},{"label":"C","text":"Surgery only addresses the issue"},{"label":"D","text":"No intervention needed"},{"label":"E","text":"Aggressive chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trisomy 21 (Down syndrome) — coordinated multispecialty care per AAP 2022 health supervision: confirm karyotype + counsel family; echocardiogram ใน first month (40-50% CHD — AVSD common); CBC at birth (transient abnormal myelopoiesis, polycythemia) + repeat first year; TSH at birth + 6 mo + annually (CH risk); ophthalmology + audiology birth + ongoing; cervical spine atlantoaxial instability evaluation before sports; growth chart Down-specific; feeding/swallow eval; developmental + early intervention; screen leukemia, celiac, sleep apnea (PSG at 4 yr), Alzheimer adult; immunizations standard; family education + support resources; long-term primary care coordination

---

DS = most common chromosomal disorder. Multisystem: CHD 50%, GI atresias, leukemia, hypothyroidism, sleep apnea, atlantoaxial instability, AD risk adult. AAP 2022 health supervision guideline. Coordinated team. Family-centered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'Newborn term GA 38 wk BW 2,800 g มี features: upslanting palpebral fissures, epicanthal folds, flat nasal bridge, single transverse palmar crease, hypotonia, mild macroglossia, sandal gap toes

Low-set ears, brachycephaly; mother age 38 (no prenatal screening)
PE: heart murmur (II/VI systolic LSB)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until puberty starts spontaneously"},{"label":"B","text":"Turner Syndrome (45,XO) management"},{"label":"C","text":"Testosterone replacement"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Turner Syndrome (45,XO) management: rhGH 0.35 mg/kg/wk SC start when growth falls below normal (ideally 4-6 yr) to maximize adult height; estrogen replacement start 11-12 yr low-dose transdermal then increase over 2-3 yr to mimic puberty + induce secondary sex characteristics + bone mineralization; later add progesterone for menstrual cycle; cardiac MRI baseline + echo q3-5 yr (BAV, coarctation, dissection risk); renal US baseline; thyroid + glucose + lipids annually; hearing + ophtho baseline + recurrent; bone density before estrogen + adulthood; ear infections + otitis; psychosocial support; fertility counseling (most infertile, oocyte donation); transition to adult endo; AHA cardiac care plan

---

Turner = monosomy X. Short stature + gonadal dysgenesis. Multisystem: cardiac (BAV, coarctation, dissection), renal, hearing, autoimmune. Multidisciplinary lifelong care. GH + estrogen + cardiac surveillance + psychosocial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 7 ปี short stature (height 110 cm, < 3rd percentile, dropping percentile since age 2) + low posterior hairline + webbed neck + widely spaced nipples + cubitus valgus

Family mid-parental height 160 cm; bone age delayed 1 yr; karyotype 45,XO; renal US: horseshoe kidney; echo: bicuspid aortic valve';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + repeat echo 1 yr"},{"label":"B","text":"Large VSD with congestive heart failure + failure to thrive"},{"label":"C","text":"Diuretic alone forever"},{"label":"D","text":"Cardiac transplant"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Large VSD with congestive heart failure + failure to thrive: anti-HF therapy — furosemide 1-2 mg/kg/dose q8-12h PO + spironolactone 1-2 mg/kg/d + captopril 0.1-0.3 mg/kg/dose q8h (increase as tolerated, monitor BP + renal); high-calorie nutrition (24-27 kcal/oz formula) + may need NG feeds; treat anemia (keep Hb ≥ 10); RSV prophylaxis ในฤดู; immunizations on time; surgical/catheter closure 3-6 mo ของวัย ถ้า: persistent HF/FTT despite therapy, pulmonary HT, large shunt + Qp:Qs > 2; small restrictive VSD ส่วนใหญ่ปิดเอง (35-40%); cardiology follow-up; endocarditis prophylaxis routine NOT recommended unless prior IE/repair < 6 mo

---

VSD = most common CHD. Large VSD = HF + FTT. Manage HF medically + nutritional + timed surgical closure. Small VSD often closes spontaneously. AHA 2018 endocarditis prophylaxis only for highest-risk lesions (cyanotic, prosthetic, prior IE, < 6 mo post-repair).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกอายุ 3 เดือน BW 4.2 kg (จาก BW เกิด 3.4 kg — เพิ่ม < 30 g/d) feed นมไม่ดี sweating ขณะ feed หอบขณะ feed

V/S: HR 158, RR 62, SpO2 96%, BW 4.2 kg
PE: tachypnea, mild retraction, hepatomegaly 3 cm, harsh holosystolic murmur grade 4/6 LLSB + diastolic rumble apex, hyperdynamic precordium
CXR: cardiomegaly + increased pulmonary vascularity
Echo: large perimembranous VSD 8 mm + L→R shunt + LV/LA enlargement';

update public.mcq_questions
set choices = '[{"label":"A","text":"Beta agonist nebulizer"},{"label":"B","text":"Tetralogy of Fallot ''tet spell'' (hypercyanotic spell)"},{"label":"C","text":"Diuretic IV"},{"label":"D","text":"Inotropic agent"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tetralogy of Fallot ''tet spell'' (hypercyanotic spell): calm + knee-chest position (เพิ่ม SVR); 100% O2 mask; IV access + Morphine 0.1 mg/kg IM/IV หรือ SC (sedate + decrease respiratory effort + decrease infundibular spasm); IV fluid bolus 10-20 mL/kg NSS (increase preload + RV filling); Phenylephrine 0.02 mg/kg IV หรือ IV infusion ถ้า refractory (increase SVR); sodium bicarbonate ถ้า severe acidosis; Esmolol/Propranolol IV ถ้า spell continues (decrease infundibular contractility); AVOID inotropic agents (worsen RVOT obstruction); urgent cardiology + cardiac surgery — definitive surgical repair recommended now (delayed repair = more spells); admit ICU

---

Tet spell = acute increase in RVOT obstruction + decrease SVR → severe R→L shunt → hypoxia. Treatment increases SVR + reduces infundibular spasm. Knee-chest position increases SVR + venous return. Phenylephrine for refractory. Avoid inotropes (worsen obstruction). Definitive surgical repair after spell.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 6 เดือน known Tetralogy of Fallot (still pre-repair) ตื่นเช้ามาร้องไห้แล้ว cyanotic วูบลง SpO2 ลดเหลือ 60% หายใจหอบเหนื่อย irritable

V/S: HR 178, BP 78/42, RR 58, SpO2 60% room air, BW 6 kg
Gen: marked cyanosis, irritable, decreased intensity of pulmonic ejection murmur (vs baseline harsh)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate unsynchronized defibrillation"},{"label":"B","text":"Pediatric SVT (stable, narrow complex regular tachycardia)"},{"label":"C","text":"Lidocaine bolus"},{"label":"D","text":"Magnesium IV"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric SVT (stable, narrow complex regular tachycardia): vagal maneuvers FIRST — apply ice pack/bag to face × 15-30 sec (diving reflex, most effective ใน infants); ถ้าไม่กลับ → Adenosine 0.1 mg/kg IV rapid push + flush via proximal IV (max 6 mg first dose, repeat 0.2 mg/kg max 12 mg); ถ้า unstable (poor perfusion, AMS, HF) → synchronized cardioversion 0.5-1 J/kg → 2 J/kg; identify + treat reversible causes; cardiology consult; long-term: digoxin หรือ propranolol prophylaxis; ablation for recurrent/refractory; counsel family about recurrence + vagal maneuvers at home

---

SVT = most common dysrhythmia infants. Vagal maneuvers (ice to face) first if stable. Adenosine = drug of choice. Synchronized cardioversion if unstable. WPW common substrate in infants. Long-term: medication or ablation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกอายุ 2 เดือน BW 5 kg มาด้วย irritability + poor feeding 6 ชม ก่อน HR fast monitor

V/S: HR 240, BP 75/45, RR 52, SpO2 98%, capillary refill 3 sec
Gen: irritable but alert, no distress
ECG: narrow complex tachycardia rate 240, no P wave, regular rhythm = SVT (likely AVRT)';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAID alone"},{"label":"B","text":"Acute Rheumatic Fever (Jones criteria revised 2015"},{"label":"C","text":"Antibiotic only 7 days"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Anticoagulation high dose"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Rheumatic Fever (Jones criteria revised 2015 — 2 major + evidence GAS): admit + bed rest until afebrile + ESR normalize; eradication GAS — benzathine penicillin G IM 600,000-1,200,000 U single dose (or PO penicillin V × 10 d); arthritis + carditis — high-dose aspirin 80-100 mg/kg/d ÷ 4 doses (monitor salicylate level, hepatotoxicity); severe carditis (CHF, severe valve insufficiency) — corticosteroid (prednisolone 1-2 mg/kg/d × 2-3 wk taper); Sydenham chorea — supportive ± haloperidol/valproic acid; HF management; ECHO + serial; SECONDARY PROPHYLAXIS critical — benzathine penicillin IM q3-4 wk ต่อ minimum 10 ปี หรือถึง 21 ปี (without carditis) หรือ 40 ปี/lifelong (with carditis); dental prophylaxis only for severe valve disease per AHA

---

ARF = post-strep autoimmune. Jones criteria revised 2015 (low + high-risk populations). Major: carditis, arthritis, chorea, erythema marginatum, subcutaneous nodules. Long-term secondary prophylaxis critical — duration depends on carditis severity. Pen V or benzathine IM standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 11 ปี ปวดข้อหลายข้อย้ายที่ × 2 สัปดาห์ ไข้ 38.5°C ใจสั่น 3 สัปดาห์ก่อนเคย sore throat untreated

V/S: HR 122, BP 105/68, Temp 38.5°C
PE: migratory polyarthritis (knees, elbows), erythema marginatum, subcutaneous nodules, soft systolic murmur apex new

Lab: ESR 78, CRP 95, ASO HIGH, anti-DNase B HIGH
ECG: PR interval 240 ms (prolonged)
Echo: mild MR + mild AR, no vegetation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic only as needed"},{"label":"B","text":"Cystic Fibrosis (classic F508del homozygous)"},{"label":"C","text":"Steroid daily"},{"label":"D","text":"Restrict salt"},{"label":"E","text":"Diuretic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cystic Fibrosis (classic F508del homozygous) — multidisciplinary CF center care: airway clearance — chest physiotherapy + nebulized hypertonic saline 7% + dornase alfa daily; bronchodilator pre-airway clearance; pancreatic enzyme replacement (PERT) 1500-2500 lipase units/kg/meal — monitor + titrate; high-calorie diet (110-200% of normal need) + fat-soluble vitamin (ADEK) supplement + salt supplement; treat infection — sputum culture q3 mo, treat Staph (anti-staph penicillin), Pseudomonas (inhaled tobramycin or colistin) chronically suppressive; CFTR modulator — elexacaftor/tezacaftor/ivacaftor (Trikafta) ≥ 2 yr F508del = transformative; vaccinations (RSV, flu, COVID); CF-related diabetes screen annually > 10 yr; liver, bone, sinus, fertility monitoring; mental health; psychosocial support

---

CF = autosomal recessive, F508del most common mutation. Multisystem: lung, pancreas, sweat, sinuses, liver, fertility. Newborn screening (IRT + DNA). CFTR modulators revolutionized care. Median survival now 50+ yr. Center-based multidisciplinary care essential.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 6 เดือน เกิด meconium ileus DOL 2 + chronic loose foul-smelling stool + poor weight gain + recurrent pneumonia + chronic cough

BW 5.8 kg (< 3rd percentile), length 60 cm (< 3rd)
PE: clubbing early, wheeze, hyperinflation, decreased subcutaneous fat

Sweat chloride 78 mmol/L (> 60 = positive), CFTR genotype: F508del/F508del (homozygous classic)
Stool elastase: very low (pancreatic insufficient)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pertussis < 6 mo = high risk severe"},{"label":"C","text":"Bronchodilator only"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antiviral"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pertussis < 6 mo = high risk severe: admit (apnea, pulmonary HT, death risk); macrolide (azithromycin 10 mg/kg/d × 5 d preferred ในเด็ก < 1 mo เพื่อหลีกเลี่ยง erythromycin/IHPS); supportive — O2, monitor for apnea/cyanosis (continuous cardiopulmonary), suction, IV fluid, small frequent feeds; consider exchange transfusion ถ้า extreme leukocytosis + pulmonary HT (lifesaving in severe cases); droplet isolation 5 d after start macrolide; ICU + intubation ถ้า respiratory failure; reportable disease; post-exposure prophylaxis household contacts macrolide; Tdap booster mother + cocooning + maternal Tdap during pregnancy (27-36 wk) สำคัญ; complete DTaP catch-up

---

Pertussis < 6 mo = high mortality. Macrolide reduces shedding (azithromycin first-line). Maternal Tdap during pregnancy + cocooning protects infants until immunized. Extreme leukocytosis (> 50K) + pulmonary HT = exchange transfusion considered. Reportable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 2 เดือน vaccine ยังไม่ครบ (DTaP เพิ่งได้ครั้งแรก) ไอ paroxysmal 2 สัปดาห์ + whooping inspiration หลังไอ + cyanosis ขณะไอ + post-tussive emesis แม่เพิ่งเป็นหวัด chronic cough

V/S: HR 168, RR 52, SpO2 92%, Temp 37.6°C, BW 5 kg
Gen: well between coughing fits, lethargic during, post-tussive cyanosis

CBC: WBC 38,500, lymphocytosis 78% (absolute lymphocyte > 20,000)
Nasopharyngeal PCR for Bordetella pertussis: positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment indicated"},{"label":"B","text":"Latent TB Infection (LTBI, child < 5 yr or close contact = high priority)"},{"label":"C","text":"Active TB regimen 6 months"},{"label":"D","text":"Wait for symptoms"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Latent TB Infection (LTBI, child < 5 yr or close contact = high priority): start LTBI treatment — INH 10 mg/kg/d × 6-9 mo (standard) หรือ rifampin 15-20 mg/kg/d × 4 mo (shorter, fewer hepatotoxicity) หรือ INH + rifapentine once weekly × 12 wk (3HP, ≥ 2 yr); pyridoxine 1-2 mg/kg/d supplement (prevent INH neuropathy in malnourished, breastfed, vegetarian); monthly clinical evaluation (compliance, hepatotoxicity); LFT baseline + as needed; address index case + screen household; CXR + symptoms re-evaluate ถ้า new symptoms; education + DOTS if compliance concern; report public health; vaccinate BCG not protective against pulmonary TB but reduces meningitis/miliary

---

Pediatric LTBI = critical to treat (high progression to active TB). 6-9 mo INH classic; 4 mo rifampin or 3HP equally effective with fewer side effects + better adherence. Pyridoxine supplement. CDC/WHO recommend LTBI treatment for child close contacts.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี พ่ออยู่บ้านเดียวกันเพิ่ง diagnosis active pulmonary TB smear+ TB clinic ส่งมาประเมิน

เด็ก asymptomatic, no cough, no fever, no weight loss; BW 20 kg, normal exam
CXR: clear (no infiltrate, no LN)
Tuberculin skin test (TST) 12 mm induration, IGRA positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diuretic alone forever"},{"label":"B","text":"Viral Myocarditis with acute decompensated HF"},{"label":"C","text":"High-dose steroid mandatory"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Viral Myocarditis with acute decompensated HF: ICU admission with continuous monitoring; ABC + supplemental O2 + non-invasive ventilation/intubation ถ้า severe; gentle fluid resuscitation (watch for worsening HF); inotropic support — milrinone (preferred — inodilator, less arrhythmogenic) 0.25-0.75 mcg/kg/min หรือ low-dose epinephrine; diuretic furosemide IV; afterload reduction (carvedilol, ACEI) เมื่อ stable; mechanical circulatory support (VAD, ECMO) ถ้า refractory cardiogenic shock; arrhythmia management (avoid digoxin acutely); IVIG controversial — selected cases; routine immunosuppression NOT recommended; treat underlying infection; HF + arrhythmia team + cardiac transplant evaluation ถ้า persistent; long-term: gradual recovery 50-70%, residual cardiomyopathy 20-30%, death/transplant 10%; restrict activity 3-6 mo

---

Viral myocarditis = leading cause acute DCM kids. Enterovirus, parvo, adeno, SARS-CoV-2 common. ICU + inotropic + mechanical support. ECMO bridge to recovery/transplant. Steroid/IVIG limited evidence — selected cases. 3 outcomes: recovery, chronic DCM, death.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี ก่อนหน้านี้ healthy 1 สัปดาห์ ก่อนมี viral URI + diarrhea ตอนนี้ดูเหนื่อยง่าย หอบเหนื่อยเวลาเดิน ดูดนมไม่ดี dependent edema

V/S: HR 168 sinus, BP 82/52, RR 48, SpO2 94%, BW 16 kg
PE: gallop S3, jugular distention, hepatomegaly 4 cm, rales, decreased pulses, cap refill 4 sec

CBC normal, troponin HIGH (12 ng/mL), BNP 1,820, CK-MB elevated
CXR: cardiomegaly + pulmonary edema
Echo: dilated LV + EF 22% + global hypokinesis
Viral PCR: enterovirus +';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic for EHEC"},{"label":"B","text":"Typical HUS (post-EHEC Shiga toxin)"},{"label":"C","text":"Loperamide"},{"label":"D","text":"Heparin"},{"label":"E","text":"Aspirin"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Typical HUS (post-EHEC Shiga toxin): supportive care mainstay (no specific treatment cures); fluid management — careful IV fluid early in disease may prevent oliguric phase, but ONCE oliguric → restrict to insensible + UO; correct electrolytes (K, P, Ca); transfuse PRBC for Hb < 6 หรือ symptomatic; AVOID platelet transfusion (worsens microangiopathy) unless major bleeding/surgery; renal replacement therapy (HD, CRRT, PD) ถ้า severe AKI/uremia/hyperK/volume overload — needed ~50%; treat HT; AVOID antibiotic for EHEC (increases Shiga toxin release + HUS risk in some studies); AVOID antimotility (loperamide, opioid); plasma exchange not indicated typical HUS; eculizumab for atypical HUS (complement dysregulation, recurrent, family Hx); long-term renal + BP follow-up; reportable disease + public health

---

Typical HUS = MAHA + thrombocytopenia + AKI post-EHEC Shiga toxin. Supportive only. Avoid antibiotic + antimotility (worsen). Atypical HUS (complement) = eculizumab. Long-term CKD risk 25%. Public health reporting (foodborne).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 5 ปี diarrhea bloody × 5 วัน หลังกินเนื้อ undercooked วันนี้ปัสสาวะน้อย ซีด เหนื่อยง่าย

V/S: BP 132/86, HR 122, BW 20 kg
PE: pallor, mild edema, petechiae, mild hepatosplenomegaly

CBC: Hb 7.2, Plt 38,000, WBC 14,500
Peripheral smear: schistocytes ++, helmet cells
BUN 68, Cr 2.4, K 5.8, Albumin 3.0
UA: protein 2+, RBC, granular cast
Stool culture: E. coli O157:H7 positive (Shiga toxin)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Metformin alone"},{"label":"B","text":"New-onset Type 1 Diabetes without DKA"},{"label":"C","text":"Sulfonylurea"},{"label":"D","text":"Lifestyle alone"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** New-onset Type 1 Diabetes without DKA: start subcutaneous insulin — basal-bolus regimen (preferred): glargine/detemir/degludec long-acting once daily (~0.4-0.5 U/kg/d total = 50% basal, 50% bolus) + rapid-acting (lispro, aspart, glulisine) pre-meal based on carb counting + correction; alternative: NPH + regular insulin ทวีติด; start total daily insulin 0.5-1 U/kg/d (peripubertal more); diabetes team education (carb counting, glucose monitoring 4-6×/d or CGM, sick day rules, hypoglycemia recognition + glucagon, exercise, ketone monitoring); HbA1c target < 7.5% (ADA recent: individualize, < 7% if achievable safely); annual screen — TSH, celiac, retinopathy (≥ 11 yr or 2-5 yr post-Dx), microalbuminuria (≥ 11 yr or 2-5 yr), lipid; immunizations (flu, pneumococcal); psychosocial support; transition to adult care; technology — CGM, insulin pump, AID systems greatly improve outcomes

---

T1DM = autoimmune β-cell destruction. Insulin mandatory. ISPAD/ADA: basal-bolus or pump = standard. Carb counting + flexible insulin + CGM = modern. Address comorbidities + transition. AID closed-loop systems improve TIR + reduce burden.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 10 ปี polyuria + polydipsia + weight loss 4 kg × 6 wk ไม่มีอาเจียน ไม่ซึม

V/S: BP 110/70, HR 92, BW 30 kg
Gen: alert, mild dehydration

Glucose random 320, HbA1c 11.2%, no ketones serum/urine, pH 7.36, HCO3 22
Anti-GAD65 + IA-2 antibodies positive (T1DM autoimmune)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until 6 hr"},{"label":"B","text":"Neonatal Hypoglycemia (symptomatic, IDM)"},{"label":"C","text":"Glucose oral gel only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Insulin"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Hypoglycemia (symptomatic, IDM): IV access + start IV dextrose — give bolus D10W 2 mL/kg (200 mg/kg) slow IV push then continuous D10W infusion GIR 6-8 mg/kg/min, titrate up to achieve glucose > 50 mg/dL (< 48h) and > 60 mg/dL (> 48h); recheck glucose 15-30 min after intervention then q1-2h until stable; continue regular feeds (breast or formula) once stable + tolerating; gradually wean IV as PO intake increases (rebound common); if persistent hypoglycemia despite GIR 12-15 mg/kg/min → think hyperinsulinism (diazoxide, octreotide, glucagon), inborn error, hormone deficiency; check critical sample (insulin, cortisol, GH, lactate, ketones, FFA, ammonia, AC profile) ขณะ hypo; long-term: neurodevelopmental follow-up severe/prolonged

---

Neonatal hypoglycemia = preventable cause neurodisability. Symptomatic + glucose < 47 (PES 2015) or < 50 (AAP) = treat. IDM = transient hyperinsulinism, screen + feed early. Persistent severe → workup for hyperinsulinism/inborn error. Avoid prolonged hypoglycemia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก LGA term BW 4,400 g (IDM — mother GDM A2 on insulin) อายุ 2 ชม jittery + lethargic + poor feeding

V/S: HR 152, RR 48, SpO2 96%, Temp 36.8°C
Gen: alert at moments, jittery, mild distress

Bedside glucose 28 mg/dL (< 47 = abnormal; cutoff < 50 symptomatic according to recent AAP)
No seizure';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment if asymptomatic"},{"label":"B","text":"Pediatric Lead Poisoning BLL ≥ 45 mcg/dL = chelation therapy indicated"},{"label":"C","text":"Wait until 100 mcg/dL"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Lead Poisoning BLL ≥ 45 mcg/dL = chelation therapy indicated: หา + remove lead source FIRST (critical — re-exposure futile chelation); BLL 45-69 + asymptomatic → outpatient succimer (DMSA) 10 mg/kg/dose q8h × 5 d then q12h × 14 d (oral chelator); BLL ≥ 70 หรือ symptomatic encephalopathy → inpatient + dual IV CaNa2EDTA + IM dimercaprol (BAL) (BAL ก่อน EDTA หลีกเลี่ยง redistribution to brain); whole bowel irrigation/cathartic for chip in GI; iron + calcium + zinc supplement (compete absorption); environmental abatement (Department of Public Health, certified abatement); recheck BLL post-chelation + 2-4 wk; family screen siblings + lead source; public health reporting; developmental + neurology follow-up (irreversible cognitive deficit); CDC 2021 reference value 3.5 mcg/dL — any BLL = action

---

Lead = potent neurotoxin, no safe level. CDC blood lead reference 3.5 mcg/dL (2021). Chelation ≥ 45 + remove source. Encephalopathy = emergency (BAL + EDTA). Source: old paint, water pipes, soil, imported items. Sources of exposure must be eliminated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 3 ปี อยู่บ้านเก่าทาสีก่อน 1978 มี pica eating paint chips มา clinic ด้วย irritability + decreased appetite + abdominal pain intermittent + developmental delay (speech)

BW 13 kg, no organomegaly
CBC: Hb 9.8, MCV 70, basophilic stippling +
Blood lead level (BLL) 52 mcg/dL
AXR: paint chip in colon';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + wait"},{"label":"B","text":"Pediatric Status Epilepticus (> 5 min established)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Diuretic"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Status Epilepticus (> 5 min established): ABC — position, suction, jaw thrust, O2 + bag-mask ถ้า inadequate ventilation, monitor; rapid glucose check (give D10W 5 mL/kg ถ้า < 60); IV/IO access; FIRST line = Lorazepam 0.1 mg/kg IV (max 4 mg) หรือ Midazolam 0.2 mg/kg IM/IN/buccal (no IV) — may repeat × 1 ที่ 5 นาที; SECOND line ถ้า persists: fosphenytoin 20 mg PE/kg IV (over 7-10 min, monitor BP/arrhythmia) หรือ Levetiracetam 60 mg/kg IV (max 4.5 g, equally effective per ESETT 2019) หรือ valproate 40 mg/kg IV (avoid age < 2, hepatic dysfunction, metabolic concern); THIRD line ถ้า refractory > 30-60 min: midazolam infusion หรือ pentobarbital coma → intubate + EEG monitor in ICU; treat underlying cause (FS workup, infection, electrolytes, toxic, structural); antipyretic for fever; do NOT delay treatment for diagnostics

---

SE = neurologic emergency. > 5 min = treat. Time = brain. Benzo first (lorazepam IV preferred, midaz IM/buccal/IN if no IV). Second-line: fosphenytoin, leva, valproate equivalent (ESETT 2019). Refractory > 30-60 min = anesthetic infusion + ICU. Treat underlying cause.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี ชักทั้งตัว tonic-clonic ต่อเนื่อง > 5 นาที EMS ส่งมา ED ขณะที่ชักยังคงอยู่ at ED chair seizure ต่อ + ไข้ 39°C ครอบครัวบอก seizure เริ่ม 25 นาทีก่อน

V/S: HR 168, BP 102/68, RR irregular, SpO2 92%, Temp 39°C, BW 20 kg
Glucose bedside 96, no obvious trauma';

update public.mcq_questions
set choices = '[{"label":"A","text":"Brain MRI mandatory all kids"},{"label":"B","text":"Pediatric Migraine without aura (ICHD-3 criteria)"},{"label":"C","text":"Opioid as needed"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Migraine without aura (ICHD-3 criteria): no neuroimaging needed (no red flags + normal exam); acute treatment — ibuprofen 10 mg/kg PO at onset (most effective NSAID) หรือ acetaminophen 15 mg/kg; triptans (sumatriptan nasal/PO, rizatriptan, almotriptan, zolmitriptan) ≥ 12 yr FDA-approved; antiemetic (ondansetron, metoclopramide) ถ้าคลื่นไส้; rest in dark quiet room; treat early ในตอน aura/onset; prevention ถ้า > 4-6 attacks/mo + functional impact — topiramate, amitriptyline (low dose, off-label), propranolol; CGRP antagonist (rimegepant > 12, atogepant > 12) emerging; behavioral: cognitive behavioral therapy + biofeedback proven effective in peds (CHAMP trial); lifestyle — regular sleep, hydration, meals, exercise, limit screens, trigger diary; education; school accommodation

---

Pediatric migraine common. Ibuprofen + triptan acute. CHAMP trial: behavioral therapy + low-dose preventive equivalent. Imaging only with red flags. Lifestyle + trigger management critical. CGRP class emerging in older adolescents.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 12 ปี ปวดหัวข้างเดียว throbbing × 6 ชม + คลื่นไส้ + กลัวแสง กลัวเสียง ทำให้นอน 3-4 ครั้ง/เดือน × 6 เดือน ครอบครัวแม่มี migraine; เรียนยังปกติ

PE neurologic ปกติ; BMI ปกติ
ไม่มี red flags (no head trauma, no fever, no fixed deficit, no AM headache + vomit, normal exam)';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"Spastic diplegic Cerebral Palsy (likely from PVL)"},{"label":"C","text":"Spinal surgery infant"},{"label":"D","text":"Discharge no therapy"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spastic diplegic Cerebral Palsy (likely from PVL) — early intervention multidisciplinary: PT/OT/speech therapy intensive — focus motor + functional skills (GMFM, Bayley); orthotics (AFO) prevent contracture + improve gait; spasticity management — oral baclofen, dantrolene, diazepam (titrate); focal — botulinum toxin injection (effective for focal spasticity, repeat q3-6 mo); intrathecal baclofen pump (severe generalized); selective dorsal rhizotomy (GMFCS II-III, ambulatory, age 4-8); orthopedic surgery (tendon lengthening, osteotomy) selected; assistive devices (walker, wheelchair); GMFCS staging; co-morbidities — epilepsy 30-50%, intellectual 50%, hearing/vision, GI/feeding, GERD, sleep, hip surveillance + scoliosis; family-centered + IEP school; address pain + drooling + bone health; nutrition + growth; transition planning

---

CP = non-progressive motor disorder, perinatal injury (PVL, HIE common). GMFCS staging guides function. Early intervention + multidisciplinary essential. Spasticity tools: oral, botox, ITB, SDR, surgery. Address comorbidities. Family-centered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน ประวัติ preterm 28 wk BPD HIE มา clinic ด้วย delay motor — ยังไม่นั่งเองได้ ขาเกร็ง spastic both legs scissoring + toe-walking ปกติ cognition ดูใกล้ปกติ

PE: increased tone lower extremities, scissoring, brisk DTRs, Babinski +, persistent ATNR, no head control issue
MRI brain: periventricular leukomalacia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassure ''late talker''"},{"label":"B","text":"Suspected ASD"},{"label":"C","text":"Discharge — wait 1 yr"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected ASD — refer for comprehensive evaluation (developmental pediatrician, psychologist with ADOS-2, speech-language) — diagnosis < 24 mo possible reliable; AAP universal ASD screen 18 + 24 mo with M-CHAT-R; while awaiting eval start early intervention (federal Part C, ages 0-3) — applied behavioral analysis (ABA) intensive 20-40 hr/wk, speech, OT, sensory integration; parent training (Pivotal Response Treatment, ESDM); audiology if not done; genetic evaluation (chromosomal microarray + Fragile X DNA + targeted gene panel if features); medical comorbidities — seizure, sleep, GI, ADHD; immunizations standard (no MMR-autism link, debunked); family support + IEP school transition; medication only for specific symptoms (risperidone/aripiprazole for severe irritability/aggression, melatonin sleep) not core ASD; school IEP/IDEA

---

ASD prevalence 1 in 36 (CDC 2023). Early identification + intervention critical for outcomes. AAP screen 18 + 24 mo. M-CHAT-R/F. Comprehensive eval (ADOS-2 + ADI-R). Multidisciplinary intervention. Medication for comorbid symptoms only. Genetic + medical workup. No vaccine link.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 24 เดือน พ่อแม่กังวล — พูด < 5 คำเดี่ยว, ไม่ตอบเรียก, ไม่พ้นมือ, no joint attention, ตื่นเล่นล้อรถซ้ำ ๆ + hand-flapping, sensory issues (covers ears, food selectivity), tantrums เมื่อ routine change

Developmental: motor normal, fine motor ok, social/language severely delayed
Hearing test: normal; M-CHAT-R high risk
No dysmorphism, normal exam';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until age 12"},{"label":"B","text":"ADHD combined presentation (DSM-5)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment-based"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ADHD combined presentation (DSM-5): multimodal treatment — first-line FDA-approved stimulant medications (methylphenidate, amphetamine derivatives) effective 70-80%, start low + titrate up clinical effect + side effect (appetite, sleep, growth, BP); long-acting preparations preferred adherence; alternative — atomoxetine (NRI), guanfacine ER, clonidine ER (non-stimulant, slower onset); behavioral therapy + parent training (mandatory < 6 yr); IEP/504 school accommodations (extended time, preferred seating, breaks, organizational support); monitor growth, BP, HR; sleep hygiene; address comorbid (anxiety, depression, ODD, learning disability); avoid screen + structured routine; reassess q3-6 mo; long-term: persists 50-65% adult; AAP 2019 + AACAP guideline

---

ADHD = neurodevelopmental, persists adulthood half. DSM-5 criteria: ≥ 6 symptoms either inattention or hyperactivity/impulsivity, ≥ 6 mo, ≥ 2 settings, before 12 yr, impairment. Vanderbilt screening tool. Stimulant first-line 6+ yr; behavioral primary < 6. Multimodal. Address comorbidities + school.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี ป.2 ครู report ไม่มีสมาธิ ลุกในห้องบ่อย คุยไม่หยุด ขัดจังหวะ ทำการบ้านไม่เสร็จ ลืม supplies เป็นมา > 6 เดือน ที่บ้านก็เป็นเช่นเดียวกัน ไม่เคยมี mood disorder, ทำร้ายตัวเอง

Vanderbilt teacher + parent score: both > cutoff inattention + hyperactivity
DDx normal exam, hearing+vision ok, no learning specifically
Family Hx: father has ADHD';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient SSRI alone discharge"},{"label":"B","text":"Adolescent Severe Major Depression with active suicidal ideation + means access"},{"label":"C","text":"Reassure no follow-up"},{"label":"D","text":"Bupropion as first-line"},{"label":"E","text":"Sleeping pills"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Severe Major Depression with active suicidal ideation + means access: immediate safety assessment — ensure ในที่ปลอดภัย ใน clinic จนกว่า safe disposition; เก็บยาทั้งหมด lock + remove firearms/sharps จากบ้าน (lethal means restriction); psychiatric evaluation urgent + likely admission to inpatient psychiatry (active SI + means + persistent symptoms = high risk); safety plan + crisis hotline (988); start SSRI fluoxetine 10-20 mg/d (only FDA-approved peds depression > 8 yr) — monitor closely first 4 wk for activation/SI (black box warning); evidence-based psychotherapy — CBT or IPT-A; family involvement + psychoeducation; school support; treat comorbidities; ภายใน 1 wk follow-up; sertraline alternative; ความคาดหวัง: response 50-60%, remission 30-40%; persistent → SSRI + CBT (TADS); refractory → augmentation, ECT, ketamine (selected); transition to adult care; suicide risk persists — ongoing monitoring

---

Adolescent depression + active SI with means = high acute risk → admission. Lethal means restriction = #1 evidence-based prevention. SSRI fluoxetine peds depression only FDA-approved < 18 (sertraline > 6 only OCD). Combination CBT + SSRI > monotherapy (TADS). Black box warning monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 15 ปี มาคลินิกพ่อแม่กังวล — หลีกเลี่ยงคบเพื่อน 6 เดือน, ผลการเรียนตก, sleep > 12h, นน. ลด 5 kg, ร้องไห้บ่อย, กล่าวว่า ''ไม่อยากตื่นอีก'' ฟังเพลง dark พ่อพบว่ามียาเก็บไว้ใน drawer

PHQ-9 score 22 (severe); SI active ideation ไม่มีแผนเฉพาะแต่เก็บยา; previous self-harm episodes 1; no psychotic Sx
No substance use; no family Hx attempt';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient calorie diary only"},{"label":"B","text":"Anorexia Nervosa, restricting type, severe with medical instability"},{"label":"C","text":"Force feed without medical eval"},{"label":"D","text":"Punitive approach"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anorexia Nervosa, restricting type, severe with medical instability — admit for medical stabilization (criteria: HR < 50 day or < 45 night, BP < 90/45, orthostatic, < 75% IBW, electrolyte imbalance, refeeding risk): cardiac monitor; SLOW refeeding to avoid refeeding syndrome — start 1,200-1,400 kcal/d (or 30-40 kcal/kg/d) ค่อยเพิ่ม 200 kcal q1-3 d (newer guidelines: more aggressive start ใน less severe cases); check + correct electrolytes (P, K, Mg) daily + thiamine supplement BEFORE feeding; weight gain target 0.5-1 kg/wk inpatient; calorie progression supervised; multidisciplinary team — pediatrician, dietitian, mental health (Family-Based Treatment Maudsley = first-line ที่อายุ < 18, evidence-based for AN); olanzapine adjunct ของบางอย่าง; SSRI helpful comorbid anxiety/depression (after weight restoration); bone density monitoring + treat with weight restoration not BP/HRT; medical follow-up + long-term: mortality 5%, recovery 50-70%

---

AN = high mortality eating disorder (highest of all mental illnesses). Hospitalize for medical instability. Refeeding syndrome = fatal — slow refeed + phosphate/electrolyte/thiamine. FBT (Maudsley) = first-line < 18. Multidisciplinary. Bone, growth, fertility long-term.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 14 ปี BMI 14.5 น้ำหนักลด 12 kg ใน 6 เดือน amenorrhea 4 mo distorted body image (กลัวอ้วน) restricting calorie + excessive exercise no purging

V/S: HR 42, BP 88/56 standing → 78/50 (orthostatic), Temp 35.6°C, BMI 14.5
PE: lanugo, cachectic, dry skin, bradycardia

ECG: prolonged QTc, sinus brady; K 3.0, Phosphate 2.2, ALT/AST elevated; bone density Z-score -2.1';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue same regimen"},{"label":"B","text":"Severe nodulocystic acne refractory to standard therapy"},{"label":"C","text":"Wait + outgrow"},{"label":"D","text":"Steroid systemic chronic"},{"label":"E","text":"Antibiotic 5 years"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe nodulocystic acne refractory to standard therapy → consider Isotretinoin (oral) — cumulative dose 120-150 mg/kg over 5-6 mo; pregnancy prevention iPLEDGE program mandatory in females (teratogenic — Category X, 2 effective contraception methods + monthly pregnancy test); baseline + monthly LFT + lipid + CBC; counsel side effects (dry skin/lips/eyes, photosensitivity, depression/suicidal ideation monitor, IBD link not proven, night vision, headache from pseudotumor cerebri, hyperostosis); avoid tetracycline concurrent (pseudotumor); avoid waxing/laser × 6 mo; mental health screen + support; results: clear 70-90%, relapse 30%; alternative oral spironolactone (anti-androgen, females), oral hormonal therapy (COC, anti-androgen), light/laser therapy; multidisciplinary — dermatology + adolescent medicine + mental health

---

Severe nodulocystic acne → isotretinoin = most effective. iPLEDGE registry mandatory (teratogenicity). Monitor LFT/lipid/mental health. Acne scarring + psychosocial impact justifies aggressive treatment. Alternative oral anti-androgens (spironolactone, COC) effective females.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 16 ปี มี nodulocystic acne รุนแรงทั่วใบหน้า + หลัง + อก หลายปี ใช้ benzoyl peroxide + topical retinoid + tetracycline 6 mo แล้วไม่ดีขึ้น มี scarring + ส่งผลต่อ self-esteem มาก';

update public.mcq_questions
set choices = '[{"label":"A","text":"Elective surgery 1 year"},{"label":"B","text":"Incarcerated right inguinal hernia (surgical emergency) + asymptomatic left reducible hernia"},{"label":"C","text":"Wait + observe"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incarcerated right inguinal hernia (surgical emergency) + asymptomatic left reducible hernia: attempt manual reduction with sedation (morphine + midazolam) + Trendelenburg + gentle steady pressure — successful 80% if reduction within 12 hr of incarceration; ถ้า reduce ได้ → schedule semi-elective surgical repair ภายใน 24-48 ชม (allow edema to subside, reduce recurrent incarceration); ถ้า reduction ไม่สำเร็จ หรือ strangulation/perforation signs (peritonitis, sepsis, bilious vomiting, bloody stool) → emergency surgery; NPO + IV fluid + pediatric surgery consultation; left side — repair simultaneously contralateral exploration controversial ในเด็กเอเชีย exploration recommended (35% contralateral PPV); preterm/high-risk hernia higher complication = repair before discharge from NICU; post-op: testicular check + recurrence monitoring

---

Pediatric inguinal hernia = indirect (patent processus vaginalis). Incarceration risk highest first year. Manual reduction first if no strangulation. Surgery semi-elective post-reduction. Contralateral exploration in young infants debated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 4 เดือน term, BW 7 kg พบ groin bulge ทั้งสองข้างเมื่อร้องไห้ + ขณะ feeding 2 สัปดาห์ ตอนนี้ฝั่งขวาบวมเริ่มแข็ง 4 ชม ทารกร้องไห้รุนแรง อาเจียน 1 ครั้ง groin red

PE: right groin: tender + non-reducible mass, mild erythema
Left groin: easily reducible bulge
No testicular pain/swelling, abdomen soft non-distended';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency surgery before correcting electrolytes"},{"label":"B","text":"Hypertrophic Pyloric Stenosis"},{"label":"C","text":"Discharge with formula change"},{"label":"D","text":"Reglan oral"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypertrophic Pyloric Stenosis: surgery is NEVER emergency — correct fluid + electrolyte FIRST (anesthesia safety): NPO + NG decompression; IV fluid resuscitation D5 1/2 NSS + KCl 20 mEq/L at 1.5-2× maintenance; goal — correct dehydration, normalize Cl > 100, HCO3 < 30, K > 3.5, urine output good; usually 24-48 ชม; THEN surgical pyloromyotomy (Ramstedt) — laparoscopic preferred; feed advancement 6-8 ชม post-op (small volume → full); home POD 1-2; long-term: excellent outcome, no growth issues; education + reassurance

---

HPS = classic first-born male, 3-6 wk, projectile non-bilious vomit, hungry baby. Hypochloremic hypokalemic metabolic alkalosis (paradoxical aciduria). Correct electrolytes FIRST — anesthesia/respiratory safety critical. Pyloromyotomy curative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 5 สัปดาห์ first-born อาเจียน projectile non-bilious เพิ่มขึ้น × 1 สัปดาห์ หลังกินนม น้ำหนักลด 200 g ดูดนมเก่ง (hungry vomiter)

V/S: HR 162, RR 38, BW 3.8 kg (BW เกิด 3.6 kg)
PE: dehydrated, sunken fontanelle, peristaltic wave visible LUQ → RLQ, palpable olive RUQ, no abdominal distension

Lab: Na 132, K 3.0, Cl 88, HCO3 32 (hypochloremic hypokalemic metabolic alkalosis), BUN 28
US pylorus: muscle thickness 5 mm, length 18 mm = pyloric stenosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge antibiotic only"},{"label":"B","text":"Acute Appendicitis (likely non-perforated)"},{"label":"C","text":"MRI before surgery"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Wait 1 week"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Appendicitis (likely non-perforated): NPO + IV fluid resuscitation + analgesia + IV antibiotic ceftriaxone + metronidazole หรือ piperacillin-tazobactam pre-op; surgical consultation; laparoscopic appendectomy ภายใน 12-24 ชม preferred (less SSI, shorter LOS); short-course antibiotic 24 ชม post-op ถ้า non-perforated; ถ้า perforated/abscess → 5-7 d IV → switch oral; non-operative management (NOM) ด้วย antibiotic + observation = option for selected non-complicated cases (recent evidence shows acceptable in selected); appendectomy still standard ใน complicated cases; post-op: advance diet POD 1, discharge POD 1-2; long-term: rare recurrence in NOM (~30%); educate signs return

---

Appendicitis = most common acute surgical abdomen kids. PAS or Alvarado helpful. US first-line imaging (avoid CT radiation). Laparoscopic appendectomy standard. NOM antibiotic-alone emerging option for non-complicated. Recurrence ~30% after NOM.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 12 ปี ปวดท้องเริ่มรอบสะดือ 18 ชม ก่อน ย้ายมา RLQ + ไข้ + คลื่นไส้อาเจียน + เบื่ออาหาร เดินสะเทือนเจ็บ

V/S: HR 122, BP 110/72, Temp 38.4°C, BW 36 kg
PE: RLQ tenderness at McBurney, Rovsing +, psoas +, obturator +, rebound +

CBC: WBC 16,500 (left shift), CRP 78
Pediatric Appendicitis Score 9 (likely)
US abdomen: non-compressible appendix > 7 mm + appendicolith + peri-appendiceal fluid';

update public.mcq_questions
set choices = '[{"label":"A","text":"Start PPI immediately"},{"label":"B","text":"Physiologic Gastroesophageal Reflux (GER, not GERD"},{"label":"C","text":"Surgery fundoplication"},{"label":"D","text":"Stop breastfeeding"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physiologic Gastroesophageal Reflux (GER, not GERD — ''happy spitter''): reassurance to parents — ~50% infants at 4 mo, peaks 4 mo, resolves > 90% by 12 mo (lower esophageal sphincter immature); positioning — UPRIGHT 20-30 min after feed; AVOID prone or side-lying for sleep (SIDS risk); smaller more frequent feeds; thickened feed (rice cereal, infant rice starch) ถ้า ของเหลวมาก; trial of hypoallergenic formula (extensively hydrolyzed) × 2-4 wk ถ้าสงสัย milk protein allergy; AVOID acid suppression in uncomplicated GER (no benefit, increased infection + fracture risk); review red flag — FTT, projectile, bilious, blood, persistent crying, hematemesis, dysphagia, lethargy → workup; education + follow-up if persists past 12-18 mo or develops GERD complications (esophagitis, FTT, respiratory)

---

Physiologic GER common, resolves spontaneously. No need for acid suppression in uncomplicated ''happy spitter.'' GERD = pathologic when complications (FTT, esophagitis, respiratory). NASPGHAN/ESPGHAN 2018 advise against acid suppression first-line.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกอายุ 3 เดือน term BW 6 kg (50th percentile, growing normally) gulp + spit up after most feeds ตั้งแต่อายุ 2 wk ปริมาณน้อย ไม่หลังจาก projectile happy baby, gain weight ดี, feed ดี, ไม่ irritable, no respiratory issue

PE ปกติ, no dehydration, no abdominal mass, no FTT';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery"},{"label":"B","text":"Functional constipation with overflow encopresis (Rome IV criteria)"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Daily enema chronic"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Functional constipation with overflow encopresis (Rome IV criteria): disimpaction — polyethylene glycol (PEG 3350/Miralax) 1-1.5 g/kg/d × 3-6 d (oral preferred over enema, equally effective in studies, less traumatic); maintenance — PEG 0.4-0.8 g/kg/d titrate to soft daily stool × minimum 6 months; behavior modification — scheduled toilet sits 5-10 min after meals (gastrocolic reflex) × 2-3 ครั้ง/วัน, positive reinforcement (sticker chart), foot stool, calm + non-punitive; dietary — increase fiber gradually (age + 5 = grams/d) + adequate water + limit cow milk < 500 mL/d; physical activity; education that this is medical condition + retraining takes months — relapse common; alarm features for further evaluation (FTT, blood, FH Hirschsprung, abnormal anus/neuro) → workup; mental health support if needed

---

Functional constipation = most common kids constipation. Encopresis from retentive behavior + overflow. Rome IV diagnosis. PEG = first-line (oral disimpaction + maintenance). Behavior modification + dietary essential. Long-term commitment, relapse common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี ถ่ายอุจจาระแข็งทุก 5-7 วัน × 6 เดือน เจ็บขณะถ่าย retentive posturing soiling underwear 3 ครั้ง/wk หลังจาก toilet trained 3 yr ปกติ

Diet: low fiber, picky eating, ดูดนมวัว 1 L/d, น้ำน้อย, no exercise; emotion อาย
PE: palpable stool LLQ + suprapubic, anal exam normal (no fissure, no tag), no neuro deficit, growth normal

No red flags (no delayed meconium, no FTT, no bloody stool)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bone marrow biopsy"},{"label":"B","text":"IgA Vasculitis (HSP, EULAR/PRINTO/PReS criteria)"},{"label":"C","text":"Aggressive cytotoxic all"},{"label":"D","text":"Discharge no follow"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Vasculitis (HSP, EULAR/PRINTO/PReS criteria): supportive care most cases (self-limited 4-6 wk, monitor 6 mo); rest + elevate legs + analgesia (NSAID for arthralgia, avoid ถ้า renal involvement); hydration; AVOID activity that could exacerbate purpura; monitor for complications — abdominal pain (intussusception risk 3-4%, usually ileo-ileal — US monitoring), GI bleeding, renal (any presentation — hematuria/proteinuria 30-50% within 4 wk); BP + UA + Cr q1-2 wk × 6 mo (nephritis can be delayed up to 6 mo); corticosteroid (prednisolone 1-2 mg/kg/d) NOT for cutaneous/arthritis (no prevention of nephritis) but consider for severe abdominal pain or rapidly progressive nephritis; ถ้า severe nephritis (nephrotic, RPGN) → MMF, cyclophosphamide, ACEI; recurrence 30%

---

HSP/IgAV = most common pediatric vasculitis. Tetrad: palpable purpura (always), arthritis, abdominal pain, nephritis. Most self-limit. Steroid for severe abdominal pain not skin/joint. Long-term renal follow-up 6 mo (nephritis predictor outcome). Intussusception ileo-ileal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี 2 สัปดาห์ก่อนเป็น URI ตอนนี้ palpable purpura ที่ขา + ก้น + ปวดท้องตื้น ๆ + ปวดข้อเข่า + ข้อเท้า + ปัสสาวะสีเข้ม

V/S: BP 110/72, HR 102, Temp 37.4°C, BW 24 kg
PE: palpable purpura lower extremities + buttocks, no thrombocytopenia, mild knee + ankle effusion

CBC: Plt 384,000 normal, WBC 12,200
UA: RBC 30/HPF, Protein 1+
BUN 14, Cr 0.5, complement normal
ABD US: bowel wall thickening, no intussusception';

update public.mcq_questions
set choices = '[{"label":"A","text":"Methotrexate IV without ophthalmology evaluation"},{"label":"B","text":"Oligoarticular JIA (≤ 4 joints first 6 mo) + ANA + ที่มี asymptomatic uveitis (high risk especially ANA+ young female)"},{"label":"C","text":"Wait — outgrow"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Oligoarticular JIA (≤ 4 joints first 6 mo) + ANA + ที่มี asymptomatic uveitis (high risk especially ANA+ young female): NSAID (naproxen 10 mg/kg/dose q12h) first-line for joint inflammation; intra-articular corticosteroid injection (triamcinolone hexacetonide) — effective + can sustain remission joint; methotrexate 10-15 mg/m²/wk PO or SC (preferred SC) ถ้า persistent/polyarticular evolution or uveitis not controlled — both joint + uveitis; for uveitis topical corticosteroid (prednisolone acetate) + mydriatic ophtho-managed; biologic — adalimumab (anti-TNF, best for uveitis) ถ้า uveitis refractory; SCHEDULED slit lamp screen q3 mo × first 4 yr (ANA+ < 7 yr highest risk → high screening frequency); PT + OT; education + activity; long-term: remission 50-75%, uveitis blindness preventable with screening + treatment

---

JIA oligoarticular = most common subtype. Young ANA+ girl = highest uveitis risk → scheduled screen (asymptomatic chronic anterior uveitis = blindness risk). MTX disease-modifying. Adalimumab gold standard for uveitis. PT/OT functional. Screening prevents irreversible vision loss.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 3 ปี ขาขวาเข่าบวม 6 wk + ตื่นมาขาเกร็ง morning stiffness 30 นาที + เดินขาเขลงเล็กน้อย ไม่มีไข้ ไม่มีรอย rash

V/S ปกติ, BW 14 kg
PE: right knee effusion + warm, slight flexion contracture 10°, no other joint, no rash, no organomegaly

CBC normal, CRP mild elevated, ANA + 1:160 (speckled), RF negative, HLA-B27 negative, anti-CCP negative
XR: soft tissue swelling, no erosion
Ophtho slit lamp: ASYMPTOMATIC anterior uveitis +';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discontinue O2 immediately"},{"label":"B","text":"Bronchopulmonary Dysplasia (Moderate-Severe per NIH 2018 criteria"},{"label":"C","text":"High-dose steroid week 1"},{"label":"D","text":"Restrict calories"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bronchopulmonary Dysplasia (Moderate-Severe per NIH 2018 criteria — O2 + GA 36 wk PMA): optimize ventilation + O2 (target SpO2 90-95%, avoid hyperoxia); high-calorie nutrition (target 130-150 kcal/kg/d) + protein-fortified human milk + multivitamin; cautious fluid (avoid overload); diuretic (furosemide intermittent or thiazide + spironolactone) selected ถ้า worsening pulmonary edema or HT; bronchodilator (inhaled albuterol) selected ถ้า reversible airway obstruction; systemic corticosteroid (DART low-dose dexamethasone) controversial — only for ventilator-dependent BPD (consider risk neurodevelopmental); inhaled corticosteroid mixed evidence; immunizations + RSV palivizumab prophylaxis (high risk); home O2 wean by oximetry; early intervention developmental services; treat pulmonary HT (sildenafil); ophtho + audio + neurodevelopmental follow-up; long-term: improve pulmonary function over years but increased asthma + reduced exercise tolerance

---

BPD = chronic lung disease premature infants. NIH 2018 criteria. Multifactorial — surfactant deficient, oxygen toxicity, volutrauma, infection, inflammation. Nutritional + O2 + judicious diuretics + RSV prophylaxis. Long-term respiratory + neurodevelopmental follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกเดิม preterm GA 26 wk BW 700 g ตอนนี้อายุ corrected gestational 36 wk (postnatal age 10 wk) ยังต้องการ O2 supplemental 28% via nasal cannula (FiO2 ≥ 0.21 + > 28 d cumulative oxygen need); CXR: hyperinflation + cystic changes

Feed full enteral, growing slowly, no acute illness
Echo: mild pulmonary HT';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with mother"},{"label":"B","text":"Neonatal Abstinence Syndrome (NAS, opioid exposure)"},{"label":"C","text":"Naloxone routinely"},{"label":"D","text":"Restrict breastfeeding"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Abstinence Syndrome (NAS, opioid exposure) — utilize Eat, Sleep, Console (ESC) function-based approach (newer, reduces pharmacotherapy + LOS) OR Finnegan score; non-pharmacologic FIRST — swaddling, low stimulation environment, dim lighting, calm room, breastfeeding promotion (allowed in methadone/buprenorphine), skin-to-skin, on-demand feeds, small frequent, hypercaloric formula ถ้า not breastfeeding; pharmacotherapy ถ้า non-pharm fails — morphine 0.04 mg/kg q3-4h titrate (or methadone or buprenorphine sublingual, recent buprenorphine sublingual showing shorter treatment); clonidine adjunct/monotherapy non-opioid; phenobarbital ถ้า polysubstance; observe minimum 4-7 d for opioid (longer for methadone 5-7 d); discharge — child welfare/social work involvement, follow-up 1-2 wk, ophtho + auditory + developmental, breastfeeding support, naloxone training, address maternal substance use disorder + mental health

---

NAS rising incidence (opioid epidemic). Non-pharm first (ESC model = function-based, less pharm + LOS, AAP endorsed). Morphine or methadone first-line pharm. Breastfeeding allowed in methadone/buprenorphine — recommended. Address maternal SUD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term DOL 2 BW 2,800 g แม่ใช้ methadone 80 mg/d ตลอด pregnancy ทารกตื่นกลางคืน irritable + high-pitched cry + tremor + sweating + sneezing + feeding difficulty + loose stool

Finnegan score 12 (moderate-severe, > 8 = treatment threshold ที่ 3 consecutive scores)
Vitals stable
No signs sepsis, no jaundice severe';

update public.mcq_questions
set choices = '[{"label":"A","text":"Implant pacemaker"},{"label":"B","text":"Vasovagal (neurocardiogenic) Syncope (clinical Dx + reassuring features)"},{"label":"C","text":"Cardiac catheterization"},{"label":"D","text":"Antiarrhythmic"},{"label":"E","text":"Discharge no instruction"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vasovagal (neurocardiogenic) Syncope (clinical Dx + reassuring features): reassurance — common benign in adolescents (15% age 15); identify + avoid triggers (prolonged standing, hot environment, dehydration, fasting, fear/pain, blood/needles, micturition); preventive — increase fluid 2-3 L/d + salt liberalization 6-10 g/d (low sodium common adolescents); counterpressure maneuvers (leg crossing, fist clenching, squat) when prodromal; AVOID prolonged standing/hot/skip meals; postural changes slowly; education about prodrome — sit/lie immediately; ECG normal sufficient most cases (no need echo/MRI/tilt table routinely if classic features + normal ECG + no red flags); RED FLAGS for cardiac syncope warranting workup: exertional, no prodrome, supine, family Hx SCD, chest pain, palpitation, prolonged QT, structural heart disease — refer cardiology; refractory → midodrine, fludrocortisone, beta blocker controversial

---

Vasovagal = most common syncope adolescents. Diagnosis clinical with classic prodrome + triggers + reassuring exam/ECG. Red flags = cardiac eval. Lifestyle (fluid/salt/avoid trigger) effective most. Pharmacology rarely needed. AAP/AHA: ECG initial; further testing only if red flags.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 14 ปี ขณะยืน assembly เช้า > 30 นาที + ร้อน + อดอาหาร feeling lightheaded + nausea + visual gray-out → faints to ground 5 sec then rapid recovery, อาเจียนเล็กน้อย

V/S after: HR 78, BP 110/72 (no orthostatic later), Temp normal
PE: normal, no neuro deficit, no murmur

ECG: sinus, QTc 410 ms normal, normal axis + intervals
Hx: family no sudden death, no syncope with exercise, no chest pain';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + recheck 12 hr"},{"label":"B","text":"Acetaminophen toxicity (above treatment line at 4 hr)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Flumazenil"},{"label":"E","text":"Naloxone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acetaminophen toxicity (above treatment line at 4 hr): N-Acetylcysteine (NAC) — IV protocol (preferred for hepatic concern): 150 mg/kg in 200 mL D5W over 60 min, then 50 mg/kg in 500 mL D5W over 4 hr, then 100 mg/kg in 1 L D5W over 16 hr (total 21 hr, 300 mg/kg cumulative); may extend if persistent injury at end of standard course (LFT or APAP still detectable); monitor for anaphylactoid reaction during infusion (slow rate, antihistamine) — true allergy rare; alternative oral PO NAC 140 mg/kg loading then 70 mg/kg q4h × 17 doses (less preferred when vomiting); transfer to liver transplant center if King''s College criteria positive (pH < 7.3, INR > 6.5, Cr > 3.4, Stage III encephalopathy); supportive — fluids, electrolytes, antiemetic ondansetron; psychiatric eval after stabilization (this is suicide attempt); social work + safety plan + lethal means restriction

---

Acetaminophen = leading cause acute liver failure US/UK. Rumack-Matthew nomogram (4-24 hr) guides NAC need. NAC effective if < 8-10 hr. IV NAC standard 21-hr regimen. King''s College criteria for transplant. Psychiatric eval mandatory after intentional ingestion (lethal means + safety).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 15 ปี (BW 50 kg) กิน Tylenol 50 เม็ด (500 mg/tablet = 25 g, 500 mg/kg) 4 ชม ก่อน หลังทะเลาะ ตอนนี้คลื่นไส้อาเจียน หลังกิน 90 นาทีให้ activated charcoal ไม่ได้ (ไม่ใช่ ED)

V/S: HR 102, BP 116/78, RR 18, SpO2 99%, Temp 37.0°C
Gen: alert, no jaundice yet

4-hr acetaminophen level: 240 mcg/mL (Rumack-Matthew nomogram = above ''probable hepatotoxicity'' line)
LFT: AST 32, ALT 38 (still normal), INR 1.0, Cr 0.7
Glucose 92, no other co-ingestion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Activated charcoal"},{"label":"B","text":"Severe Iron Toxicity (ingestion > 60 mg/kg elemental, peak 4-6 hr, serum > 500 mcg/dL or symptoms)"},{"label":"C","text":"Outpatient observation"},{"label":"D","text":"Naloxone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Iron Toxicity (ingestion > 60 mg/kg elemental, peak 4-6 hr, serum > 500 mcg/dL or symptoms): activated charcoal NOT effective (doesn''t bind iron); GI decontamination — whole bowel irrigation with PEG-electrolyte solution (25-40 mL/kg/hr via NG) if tablets visible on KUB + significant ingestion; gastric lavage controversial selective; aggressive IV crystalloid resuscitation (large losses GI + 3rd space + capillary leak); IV Deferoxamine chelation — 15 mg/kg/hr IV continuous infusion (max 6 g/24 hr) when serum iron > 500, severe symptoms, metabolic acidosis, or shock; classic ''vin rose'' urine indicates chelation; continue until clinical improvement, serum iron < 350, urine returns clear, acidosis resolved (typically 24 hr); side effects deferoxamine — hypotension (slow rate), pulmonary toxicity, anaphylactoid; correct acidosis, glucose, coagulopathy; LFT monitoring; ICU admission; child safety — accidental childproof packaging counseling

---

Iron = leading cause peds poisoning death (historically). Stages: GI (0-6 hr), latent (6-24), shock/metabolic (12-48), hepatotoxicity (2-5 d), late scarring (4-6 wk). > 60 mg/kg = toxic, > 500 mcg/dL serum = severe. Deferoxamine for severe. Charcoal ineffective. WBI for radiopaque pills. Childproof packaging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี BW 12 kg พบเปิดขวด adult prenatal vitamin iron 80 mg/tablet กิน 30 เม็ด (2,400 mg = 200 mg/kg elemental iron — ในขวด FeSO4 elemental ≈ 65 mg/tablet = ~108 mg/kg) 2 ชม ก่อน อาเจียนหลายครั้ง bloody, lethargic

V/S: HR 168, BP 78/40, RR 38, SpO2 96%, BW 12 kg
Gen: lethargic, abdominal tenderness, vomiting, melena

ABG: pH 7.20, HCO3 12 (high AGMA), lactate 8
Serum iron 1,200 mcg/dL (4 hr level — toxic > 500), AST 240, ALT 180
AXR: radiopaque tablets in stomach + small bowel';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe before factor replacement"},{"label":"B","text":"Severe Hemophilia A with intracranial bleed (life-threatening = highest priority)"},{"label":"C","text":"Aspirin"},{"label":"D","text":"Surgery without factor first"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Hemophilia A with intracranial bleed (life-threatening = highest priority): IMMEDIATE Factor VIII replacement BEFORE any imaging if strongly suspected ICH (history alone enough — clinical context > confirmatory imaging delay); dose for major/CNS bleed — Factor VIII 50 IU/kg IV bolus (target factor level 100%, formula: 1 IU/kg raises factor by 2%), then continuous infusion 3-4 IU/kg/hr OR q8-12h dosing to maintain trough 50-100% × 14 days for CNS bleed; admit pediatric ICU + neurosurgery consultation; serial neuro exams + repeat CT; AVOID NSAIDs, antiplatelets, IM injection; if inhibitor present → bypassing agents — rFVIIa 90-120 mcg/kg q2-3h OR FEIBA 50-100 IU/kg q6-12h; emicizumab not for acute bleed treatment (prophylaxis only); long-term prophylaxis emicizumab subQ q1-2 wk if not already; comprehensive hemophilia center; PT/OT post-recovery; education + medical alert; counsel about activity

---

Hemophilia + suspected ICH = factor replacement BEFORE imaging (don''t delay). Target 100% for CNS bleed, maintain 50-100% × 14 d. WFH 2020 guideline. Inhibitor → bypassing agents (rFVIIa, FEIBA). Emicizumab = prophylaxis only. Comprehensive care center coordination.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี known severe Hemophilia A (factor VIII < 1%) สะดุดตกบันได 4 ชม ก่อน อาเจียน 2 ครั้ง ปวดศีรษะ + ง่วงซึม + walk unsteady

V/S: HR 92, BP 110/72, GCS 14 (E4V4M6), pupil R 4 mm sluggish, L 3 mm reactive

CT brain: small (1.5 cm) subdural hematoma right frontoparietal, no midline shift, no mass effect
No previous inhibitor';

update public.mcq_questions
set choices = '[{"label":"A","text":"No transfusion needed"},{"label":"B","text":"Beta-Thalassemia Major (Cooley anemia)"},{"label":"C","text":"Splenectomy mandatory all"},{"label":"D","text":"Iron supplement"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Beta-Thalassemia Major (Cooley anemia) — comprehensive care: hypertransfusion regimen — PRBC q3-4 wk maintain pre-transfusion Hb 9-10.5 g/dL (suppresses endogenous erythropoiesis → reduces extramedullary hematopoiesis + skeletal deformity + improves growth/quality of life); iron chelation MANDATORY once cumulative transfusion ≥ 20 units OR ferritin > 1,000 — deferasirox PO 14-28 mg/kg/d OR deferoxamine SC 8-12 hr × 5 nights/wk OR deferiprone PO TID; baseline + annual cardiac MRI T2* (iron-induced cardiomyopathy = leading death), liver MRI; endocrine — growth, puberty, thyroid, parathyroid, gonadal, glucose monitor + treat; bone density + osteoporosis prophylaxis; folate supplement; immunizations including pneumococcal/meningococcal/Hib (functional asplenia if splenectomy); HCV screening (transfusion); HSCT = potentially curative (HLA-matched sibling preferred, age < 14); gene therapy (lentiviral lovo-cel, CRISPR exa-cel) FDA-approved emerging curative; counseling family for siblings; psychosocial support; transition adult care

---

Beta-thal major = severe transfusion-dependent. Hypertransfusion + iron chelation cornerstones. Iron overload = cardiac/endocrine/liver toxicity. Cardiac MRI T2* monitors. HSCT curative. Gene therapy emerging (exa-cel, lovo-cel). Comprehensive care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 4 ปี ซีดเรื้อรัง ตั้งแต่อายุ 6 mo, ต้องได้ blood transfusion ทุก 3-4 wk ตับโต ม้ามโต face thalassemic ''chipmunk'' frontal bossing maxillary prominence

Family: parents both beta-thalassemia trait
Hb electrophoresis: HbF 92%, HbA2 elevated, no HbA = beta-thalassemia major

Current Hb 6.8 (pre-transfusion), ferritin 1,200 (rising 1 yr post-transfusion), Hb 9.2 post-transfusion baseline
Growth chart < 3rd percentile';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for PCR before treatment"},{"label":"B","text":"HSV Encephalitis (classic features"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HSV Encephalitis (classic features — temporal lobe, hemorrhagic, focal seizure, PLEDs) = empirically treat IMMEDIATELY (don''t wait PCR — delay = worse outcome): IV Acyclovir 60 mg/kg/d ÷ q8h (20 mg/kg/dose) × 14-21 days (peds higher dose than adult); ensure adequate hydration to prevent crystalline nephrotoxicity (renal monitoring + good UO); seizure management — load levetiracetam or fosphenytoin + ongoing maintenance; ICU monitoring + airway protection; treat increased ICP (head-up, mannitol, hypertonic saline) if signs; repeat LP at end of treatment with HSV PCR (negative before stop); EEG monitoring; AVOID delay — HSE has 70% mortality untreated, < 30% with treatment; counsel family — neurological sequelae common (memory, seizure, behavioral, cognitive); long-term neuro + neuropsych + epilepsy follow-up; family education home seizure plan

---

HSV encephalitis = most common sporadic encephalitis, treatable. Temporal lobe involvement + focal seizure + PLEDs + hemorrhagic = classic. Empiric acyclovir EARLY = standard (mortality 70 → 20% with treatment). 14-21 d treatment + repeat LP. Long-term neuro sequelae common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี ไข้ + ปวดศีรษะ + สับสน 3 วัน + ชัก focal right side × 5 นาที × 2 ครั้ง วันนี้

V/S: HR 132, BP 108/70, RR 24, SpO2 96%, Temp 39.4°C, BW 16 kg
Gen: lethargic, GCS 12, no neck stiffness obvious, occasional focal twitches right face

CT brain: temporal lobe hypodensity bilateral (R > L) + edema
MRI brain: temporal lobe T2/FLAIR hyperintensity bilateral asymmetric + cingulate involvement
LP: WBC 250 (lymphocyte 80%), Protein 95, Glucose 56 (normal), RBC 850 (! suggests hemorrhagic temporal lobe)
CSF HSV PCR: pending
EEG: PLEDs (periodic lateralized epileptiform discharges) right temporal';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"Bilateral high-grade VUR with breakthrough UTIs + scarring"},{"label":"C","text":"Immediate kidney transplant"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Chronic high-dose ibuprofen"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral high-grade VUR with breakthrough UTIs + scarring: continuous antibiotic prophylaxis (CAP) — trimethoprim-sulfamethoxazole 2-3 mg/kg/d trimethoprim OR nitrofurantoin 1-2 mg/kg/d at bedtime (reduces febrile UTI; RIVUR trial 50% reduction); manage voiding dysfunction + constipation aggressively (treat any bowel-bladder dysfunction); monitor — annual US + selective DMSA, BP, growth; recheck VCUG 12-24 mo (resolution rate decreases with higher grade — Grade IV ~30-40% resolve); surgical or endoscopic correction (subureteral injection Deflux, ureteral reimplantation) considered if: breakthrough infection on CAP, progressive scarring, parental preference, persistent high-grade after age 5-6, non-compliance; long-term: BP, proteinuria, renal function monitoring (risk CKD, HT, pregnancy complication); patient + family education + voiding hygiene

---

VUR + recurrent febrile UTI + scarring = treat. AAP/AUA: CAP for selected high-grade VUR + recurrent UTI (RIVUR trial). Address bowel-bladder dysfunction. Surgical/endoscopic for breakthrough/persistent. Long-term renal/BP follow-up. Voiding habits matter.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน 3rd febrile UTI ใน 6 mo (E. coli ทั้งหมด) ระหว่าง episodes ดีปกติ

VCUG: bilateral Grade IV VUR (gross dilation ureter + pelvis + calyces with blunting of fornices)
DMSA: small focal scarring left kidney
Renal US: hydronephrosis bilateral mild-moderate
BP normal, growth normal, no neurogenic bladder';

update public.mcq_questions
set choices = '[{"label":"A","text":"Circumcise routinely at 1 wk"},{"label":"B","text":"Mid-shaft Hypospadias with chordee"},{"label":"C","text":"Surgery at age 10"},{"label":"D","text":"Hormone alone"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mid-shaft Hypospadias with chordee — DO NOT circumcise (foreskin needed for surgical repair); pediatric urology referral; surgical repair typically 6-18 months of age (single or staged tubularized incised plate, urethroplasty); pre-op assessment — rule out DSD if also undescended testes or ambiguous genitalia (karyotype + endo workup); post-op care: stent/catheter management, antibiotic prophylaxis, follow-up complications (fistula 5-15%, meatal stenosis, dehiscence); counsel family — cosmetic + functional good results, ongoing follow-up to puberty; psychosocial support; school + adolescent transition counseling

---

Hypospadias = ~1 in 200-300 male births. Severity by meatal position. AVOID circumcision (foreskin for repair). Repair 6-18 mo. Pediatric urology. Rule out DSD if bilateral cryptorchidism or ambiguous. Excellent outcomes most.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายแรกเกิด term BW 3,200 g พบ urethral meatus opening ที่ ventral surface penis (mid-shaft) + ventral curvature (chordee) + hooded foreskin (dorsal incomplete)

ไม่มี ambiguous genitalia, scrotum normal, testes palpable bilateral descended
No other dysmorphism, normal fontanelle, normal exam อื่น';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until puberty"},{"label":"B","text":"Cryptorchidism (undescended testis)"},{"label":"C","text":"hCG injection only"},{"label":"D","text":"Discharge — outgrow"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cryptorchidism (undescended testis): natural descent rare after 6 mo of age — refer pediatric urology for surgical management; orchiopexy recommended ที่อายุ 6-18 months (optimal window before age 1 yr per AUA 2014 + EAU); surgery — open inguinal vs laparoscopic (impalpable testes); benefits early orchiopexy — better fertility (preserve germ cells), easier examination for malignancy (testicular cancer 4-10× elevated risk vs general — surveillance lifelong), normal growth; hormonal therapy hCG/GnRH analogues NOT recommended first-line (low success + side effects); if impalpable bilateral testes + < 3 mo old + signs of virilization → URGENT endocrine + DSD workup (CAH karyotype 46,XX masculinized); counsel — lifelong testicular self-exam; semen analysis later in life if needed; address comorbid inguinal hernia (often coexistent)

---

Cryptorchidism ~3% term, ~30% preterm. Natural descent first 6 mo. Orchiopexy 6-18 mo optimal — reduces infertility + cancer risk. Hormonal therapy not first-line. Bilateral impalpable = endo + DSD workup. Lifelong cancer surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 9 เดือน term, BW 4 kg (เกิด 3.5 kg) มา check up พบ right testis อยู่ใน inguinal canal palpable but undescended ไม่สามารถดึงลง scrotum left testis ปกติใน scrotum

ไม่มี hypospadias, ไม่มี ambiguous genitalia, normal phallus length
No previous descent attempted
US confirms right testis in inguinal canal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bronchodilator only"},{"label":"B","text":"Severe Influenza pneumonia (high-risk + hospitalization criteria)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Influenza pneumonia (high-risk + hospitalization criteria): IV Oseltamivir 3 mg/kg/dose q12h × 5 days (start as soon as suspect, best within 48 hr but still benefit later in severe disease); admit + O2 support to SpO2 ≥ 92%; supportive — fluid management, antipyretic; consider concurrent bacterial superinfection (Strep pneumo, Staph aureus including MRSA, GAS) — empiric ceftriaxone + vancomycin if persistent fever, worsening, lobar consolidation, leukocytosis; ICU + HFNC/CPAP/intubation if severe respiratory failure; ECMO selected; isolation droplet + standard precautions; chemoprophylaxis household + close contacts at high risk (immunocompromised, < 5 yr, pregnant, chronic illness) — oseltamivir 1× daily × 7-10 d; influenza vaccine annually (best prevention); avoid aspirin (Reye syndrome); long-term: counsel post-influenza pneumonia surveillance

---

Severe influenza = hospitalize. Oseltamivir within 48 hr ideal but benefit even later in severe. Watch bacterial superinfection (Staph especially). Annual vaccination prevention. Reye syndrome — no aspirin. Chemoprophylaxis household high-risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี ไข้สูง 40°C + ปวดเมื่อยกล้ามเนื้อ + ไอ + หอบเหนื่อย 2 วัน + อาเจียน เริ่มหอบเหนื่อยมากขึ้น 6 ชม ก่อนมา ED

V/S: HR 152, BP 92/58, RR 48, SpO2 88% room air, Temp 39.6°C, BW 22 kg
Gen: alert but distress, accessory muscle use, bilateral crackles

Rapid Influenza A positive (H1N1); CXR: bilateral interstitial infiltrate + RLL consolidation
CBC: WBC 4,200 (lymphopenia)
Community outbreak Influenza A current';

update public.mcq_questions
set choices = '[{"label":"A","text":"Don''t discuss"},{"label":"B","text":"Adolescent contraception counseling (confidential, evidence-based per AAP/ACOG)"},{"label":"C","text":"Refuse counseling"},{"label":"D","text":"Only abstinence"},{"label":"E","text":"Force parental consent"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent contraception counseling (confidential, evidence-based per AAP/ACOG): assess preferences + medical eligibility (CDC US-MEC 2024); ALL options + LARC = first-line offer per AAP — most effective, top-tier (IUD copper or LNG, etonogestrel implant); etonogestrel implant Nexplanon — most effective adolescent option (failure < 1%, 3 yr), reversible, no estrogen, can use breastfeeding; LNG-IUD or copper IUD — also top-tier, > 99% effective, 3-12 yr depending on type, can place in adolescents per ACOG; tier 2: DMPA injection q3 mo (bone density caution, weight gain), combined oral contraceptive pill, patch, ring (need adherence); always counsel about STI prevention — condoms PLUS LARC (dual protection); emergency contraception availability (ulipristal, LNG, copper IUD); screen + offer STI testing (chlamydia/gonorrhea, HIV, syphilis, hepatitis B); Pap smear start 21 yr; HPV vaccination; preventive counseling — alcohol/drug, mental health, safety; confidentiality unless harm to self/others

---

AAP/ACOG: confidential adolescent contraception counseling. LARC (implant, IUD) = first-line (most effective). Dual protection (LARC + condom) for STI. CDC US-MEC for safety. STI screening + HPV vaccine + mental health screen. Confidentiality (varies by state).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 16 ปี มาคลินิก ขอคุมกำเนิด มี sexual activity 6 mo unprotected ครั้ง bf ใช้ withdrawal เคยขาดประจำเดือน 2 mo (UPT neg, MIA normal cycles since)

BP 116/72, BMI 22, no contraindication migraine with aura, no smoking, no DVT Hx, no breast/cervical cancer family
No current STI symptoms; agrees to STI screen';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — wait + see"},{"label":"B","text":"Suspected Acute Pediatric Sexual Abuse (recent < 72 hr"},{"label":"C","text":"Don''t report"},{"label":"D","text":"Discharge no eval"},{"label":"E","text":"Confront alleged perpetrator"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Acute Pediatric Sexual Abuse (recent < 72 hr — forensic evidence window) — multidisciplinary urgent response: ENSURE child safety FIRST (do not leave with potential abuser, may need protective custody temporary), keep child with trusted caregiver; mandated reporter — IMMEDIATE report to child protective services (CPS) + law enforcement (legally required, even suspicion = report, no delay); refer to Child Advocacy Center / SANE-Pediatric trained provider for forensic medical evaluation (limit history-taking + exam to one trained interviewer/examiner to reduce trauma + preserve evidence); forensic evidence collection (rape kit) if within window (72-96 hr varies); STI testing (chlamydia, gonorrhea, trichomonas, syphilis, HIV, HBV, HCV) + pregnancy test if menarche; HIV PEP within 72 hr if indicated (28-d antiretroviral); STI prophylaxis (ceftriaxone + azithromycin + metronidazole for older); emergency contraception if post-menarche; hepatitis B vaccination if not immune; counseling — mental health referral immediate + ongoing trauma-focused CBT; medical follow-up 2-6 wk for STI + counseling; document carefully (verbatim quotes, body diagram, photo if SANE) — chain of custody; AAP Section on Child Maltreatment guideline; multidisciplinary team (medical, mental health, legal, social work)

---

Child sexual abuse = mandatory report (all healthcare providers). Child Advocacy Center coordinated multidisciplinary. Limit re-interviewing (trauma + investigation integrity). Forensic eval + evidence within 72-96 hr. STI/HIV PEP + EC. Trauma-informed care. Long-term mental health. Document carefully.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 5 ปี แม่พามาเพราะเด็กเล่าว่า ''ลุงเอาของแข็งเข้าไป'' 2 วันก่อน + dysuria + ปัสสาวะมีเลือด เคยปกติมาก่อน

V/S ปกติ, BW 18 kg
PE: anogenital exam — vaginal redness + small laceration introitus + bleeding scant + perianal bruise (yellow-green = > 24h) — no other PE injury

Affect: child anxious, avoids eye contact, hesitant to speak; mother appropriate concern, brought immediately';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with reassurance"},{"label":"B","text":"Highly suspicious Non-Accidental Trauma (Abusive Head Trauma / Shaken Baby Syndrome)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Don''t report"},{"label":"E","text":"Send home with abuser"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Highly suspicious Non-Accidental Trauma (Abusive Head Trauma / Shaken Baby Syndrome): triad — retinal hemorrhages + subdural hematomas + cerebral edema/injury — pathognomonic when no other explanation; injuries inconsistent with history (8-mo-old not yet rolling cannot generate force of 1-ft fall to cause SDH/retinal hem/long bone Fx); ENSURE child safety FIRST — admit hospital, do not discharge with caregivers under suspicion, may need emergency protective custody; MANDATORY REPORT immediate to CPS + law enforcement (mandatory reporter — no need certainty, suspicion sufficient); medical evaluation — full skeletal survey (XR of every bone — repeat in 2 wk to detect healing fractures), bilateral ophtho exam dilated by ophthalmologist (document retinal hem), brain MRI for parenchymal/axonal injury, abdominal CT or LFT/amylase/lipase to evaluate occult abdominal trauma, coagulation studies + Cl to rule out bleeding disorder (preserve evidence), Cu/Vit C/Cu deficiency rule out bone disease; consult Child Abuse Pediatrician (board-certified subspecialty) for assessment; multidisciplinary team — social work, mental health, law enforcement, hospital legal; siblings — screen + protect (high risk also); detailed documentation + photo + verbatim quotes (chain of custody); long-term: neurological sequelae 80% (developmental delay, seizure, vision, cognitive); legal proceedings; long-term mental health + developmental services

---

AHT/SBS = leading cause death from child abuse. Triad: SDH + retinal hem + brain injury. History inconsistent with injury = key. Mandatory report. Comprehensive workup (skeletal survey, ophtho, MRI). Sibling protection. Long-term sequelae high. Child abuse pediatrician consultation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 8 เดือน BW 7.2 kg แม่เล่ากลิ้งจากโซฟา 1 ฟุต ทารกร้องไห้ไม่หยุด 1 ชม alert ตอนนี้

PE: bulging fontanelle, ecchymosis right forehead + retinal hemorrhages bilateral (multiple, dot/blot/flame) + grip mark bruise bilateral upper arms + femoral fracture left + multiple healed rib fractures different ages on incidental CXR

CT: bilateral subdural hematoma + different ages
Development normal; SES low; previous CPS reports for sibling
Mother story changes during interview';

update public.mcq_questions
set choices = '[{"label":"A","text":"Levothyroxine"},{"label":"B","text":"Graves Disease pediatric"},{"label":"C","text":"Surgery first-line all"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Graves Disease pediatric: anti-thyroid drug FIRST-LINE (block + replace or titration) — Methimazole 0.2-0.5 mg/kg/d ÷ 1-2 doses (only PTU during pregnancy 1st trimester due to teratogenicity, methimazole preferred otherwise per AAP/ATA 2016) — duration 1-2 yr trial (remission ~25-30% pediatric — lower than adult); beta-blocker (propranolol 1-2 mg/kg/d ÷ 3-4 doses, max 60 mg/d) for symptomatic relief tachycardia/tremor first 2-4 wk; baseline + monthly LFT + CBC (rare agranulocytosis, hepatotoxicity — discontinue + alternative if occur); periodic TSH + Free T4 + Free T3 (TSH lags 6-8 wk); if treatment fails or recurs after 2-yr course → definitive therapy — RAI ablation (preferred in adolescents > 10 yr, post-puberty for fertility) OR total thyroidectomy (skilled surgeon); ophthalmopathy — most mild self-limit, severe → ophtho + steroid + selenium + RAI typically not recommended worsens; reproductive counseling adolescent female (methimazole teratogenic 1st trimester); psychosocial + school accommodation; monitor growth + puberty + bone density

---

Pediatric Graves rare, treatment more conservative than adult initially. Methimazole 1-2 yr trial (remission lower than adult). Beta-blocker symptoms. Monitor LFT/CBC. RAI or surgery if fails. AAP/ATA 2016 guideline.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 13 ปี น้ำหนักลด 5 kg ใน 3 mo + ใจสั่น + ทนร้อนไม่ได้ + เหงื่อออก + tremor + irritable + insomnia + ผลการเรียนลด

V/S: HR 122 sinus, BP 138/72, BW 38 kg
PE: diffuse goiter symmetric non-tender, ophthalmopathy mild (mild proptosis + lid retraction), warm moist skin, fine tremor, hyperreflexia

TSH < 0.01, Free T4 4.2 (high), Free T3 12 (high), TSI/TRAb HIGH, anti-TPO + thyroid US: diffuse heterogeneous + increased vascularity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase insulin drip rate"},{"label":"B","text":"Cerebral Edema in pediatric DKA (most feared complication"},{"label":"C","text":"Stop all fluid"},{"label":"D","text":"Give D50W"},{"label":"E","text":"Increase rate of glucose drop"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cerebral Edema in pediatric DKA (most feared complication — 20-25% mortality if untreated, 25% morbidity in survivors): RECOGNIZE EARLY — clinical signs: headache, vomiting (after initial), altered mental status, bradycardia + HT (Cushing triad), papilledema, sluggish pupil, rapid corrected Na rise (warning sign); STOP IV fluid resuscitation rate (often over-aggressive contributes); reduce IV fluid 1/2 to 2/3 maintenance; head of bed 30°; immediate osmotherapy — 3% Hypertonic Saline 2.5-5 mL/kg over 10-15 min OR Mannitol 0.5-1 g/kg over 20 min (may need re-dose); intubate + mild hyperventilation transient bridge (avoid prolonged hypocapnia → reduce cerebral blood flow worsen ischemia); maintain euvolemia + adequate cerebral perfusion pressure; emergent CT head (rules out hemorrhage but treat clinically — don''t delay osmotherapy for CT); ICU + continuous neuro monitoring + neurosurgery consultation; identify other reversible factors (electrolyte derangement, sepsis); continue cautious diabetic management — extend correction over 48 hr (not 24); risk factors for cerebral edema: severe acidosis at presentation, high BUN, treatment with bicarbonate, rapid sodium drop, young age (< 5), new-onset diabetes; family counsel + long-term neuropsychological evaluation

---

Cerebral edema in DKA = most feared, fatal if missed. Recognize warning signs (HA, vomit, Cushing, falling GCS, papilledema, paradoxical Na rise). Hypertonic saline OR mannitol IMMEDIATELY. Don''t wait for CT. Reduce fluid. Avoid prolonged hyperventilation. Risk factors guide caution.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 9 ปี DKA แรกเดิม pH 7.05 glucose 720 ตอนนี้ resuscitation 6 ชม IV fluid + insulin drip ดี glucose ลดมา 280 ตอนนี้

แต่จู่ ๆ ก็มี headache + ซึม + อาเจียน vomiting + GCS ลด 14 → 11 + papilledema + HR 62 + BP 132/88 (Cushing reflex)

ABG: pH 7.28 (ดีขึ้น), Glucose 280, Na corrected 142 (rise from 134 — sign of edema)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery for genital correction immediately"},{"label":"B","text":"Salt-wasting CAH (21-hydroxylase deficiency) with adrenal crisis = endocrine emergency"},{"label":"C","text":"Insulin alone"},{"label":"D","text":"Discharge with oral medication"},{"label":"E","text":"No steroid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Salt-wasting CAH (21-hydroxylase deficiency) with adrenal crisis = endocrine emergency: IMMEDIATE Hydrocortisone IV — 25 mg IV bolus (or 25-50 mg/m² depending source) STAT — STRESS dose for crisis, then 25-50 mg/m²/d ÷ q6h or continuous infusion; aggressive fluid resuscitation 20 mL/kg NSS bolus repeat as needed (severe dehydration) then maintenance + correction over 24-48 hr; correct hypoglycemia — D10W 2-5 mL/kg bolus; treat hyperkalemia — IV insulin + glucose, calcium gluconate (cardiac protection), albuterol nebulizer, kayexalate, dialysis if severe; treat acidosis (usually corrects with volume + glucose + Cortisol); once stable: maintenance regimen — Hydrocortisone 10-15 mg/m²/d PO ÷ TID + Fludrocortisone 50-150 mcg/d PO (mineralocorticoid) + salt supplement 1-2 g/d (NaCl) in infants until intake from food; STRESS dosing education — 3× dose for illness/fever/surgery, IM hydrocortisone for vomiting (kit + training); medical alert bracelet; pediatric endocrinology + multidisciplinary DSD team; gender assignment + psychosocial — discussed with multidisciplinary team + family (not just surgical decision; postpone elective genital surgery — controversial); monitor growth, bone age, virilization, fertility, puberty

---

CAH salt-wasting = leading cause neonatal female virilization + crisis. 21-hydroxylase = 90%. NBS includes 17-OHP. Crisis: emergency hydrocortisone + fluid + glucose + correct K. Lifelong replacement + stress dosing + salt. DSD team for gender + psychosocial. Genital surgery controversial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกเพศหญิงอายุ 2 wk virilized genitalia (Prader stage III — fused labia, clitoromegaly) อาเจียน + diarrhea + weight loss 200 g + lethargy + tachycardia + hyperpigmentation + dehydration

V/S: HR 178, BP 56/30, RR 48, SpO2 96%, Temp 36.4°C, BW 3.0 kg (เกิด 3.4 kg)

Lab: Na 122, K 7.2, Glucose 38, HCO3 12 (metabolic acidosis), 17-OH-progesterone HIGH, cortisol LOW, ACTH HIGH
Karyotype 46,XX';

update public.mcq_questions
set choices = '[{"label":"A","text":"Biopsy first then chemo"},{"label":"B","text":"Wilms Tumor (Nephroblastoma)"},{"label":"C","text":"Watchful waiting"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Steroid alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wilms Tumor (Nephroblastoma) — most common pediatric renal malignancy peak 2-4 yr (clinical/imaging diagnosis sufficient — biopsy not done in COG/SIOP protocols, upstages tumor): pediatric oncology + pediatric surgery + radiation oncology coordinated; COG approach (North America) — NEPHRECTOMY FIRST (radical nephrectomy with retroperitoneal lymph node sampling) → staging → adjuvant chemotherapy based on stage + histology; SIOP approach (Europe) — neoadjuvant chemotherapy first → nephrectomy → adjuvant; staging — chest CT (lung mets), abdominal CT/MRI (IVC tumor thrombus important), bone scan + brain MRI for rhabdoid/clear cell selected; favorable histology + early stage — excellent prognosis (cure 90%+); chemotherapy regimens — vincristine + actinomycin-D ± doxorubicin ± etoposide depending stage; radiation for higher stage; screening — Beckwith-Wiedemann, hemihypertrophy, WAGR (aniridia + GU + retardation), Denys-Drash — abdominal US q3 mo until age 8; surveillance post-treatment chest + abdomen imaging; long-term: renal function, cardiac (anthracycline), pulmonary (if XRT), secondary malignancy

---

Wilms = most common renal malignancy peds (2-4 yr peak). Biopsy NOT done (upstages). COG: nephrectomy first; SIOP: neoadjuvant. Favorable hist + early stage = > 90% cure. Screen at-risk syndromes. Long-term toxicity monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 3 ปี แม่คลำพบก้อนใน abdomen ลูก, ไม่เจ็บ, น้ำหนักไม่ลด, ปัสสาวะเป็นเลือดบ้าง 2 wk, BP สูง

V/S: BP 132/86, HR 102, BW 14 kg
PE: large left flank smooth firm mass, ปกติเด็ก well-appearing, no other abnormality, no aniridia, no hemihypertrophy

US: 8 cm renal mass left kidney + intact capsule, no IVC thrombus
CT chest + abdomen: large renal mass left + no metastasis, contralateral kidney normal
Biopsy NOT performed (would upstage)
Family: no syndrome';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery alone curative"},{"label":"B","text":"High-risk Neuroblastoma (age > 18 mo, stage 4, N-MYC amplified, unfavorable histology)"},{"label":"C","text":"Chemo only no immunotherapy"},{"label":"D","text":"Wait + observe"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High-risk Neuroblastoma (age > 18 mo, stage 4, N-MYC amplified, unfavorable histology) — multidisciplinary intensive multimodal therapy: pediatric oncology + surgery + radiation oncology + BMT center; intensive induction chemotherapy (cyclophosphamide + topotecan/etoposide + cisplatin + doxorubicin/vincristine) × 5-6 cycles; surgical resection of primary; consolidation with myeloablative chemotherapy + tandem autologous stem cell transplant (recent studies improve EFS); radiation therapy primary site + selected mets; differentiation therapy 13-cis-retinoic acid maintenance; anti-GD2 immunotherapy (dinutuximab + GM-CSF + IL-2) — major advance (COG ANBL0032 trial significantly improved survival); newer: anti-GD2 + chemo upfront; supportive — pain management, nutrition, central line, transfusion support, infection prophylaxis; opsoclonus-myoclonus — IVIG + steroid + rituximab (paraneoplastic); long-term: hearing (cisplatin), cardiac (anthracycline), fertility, secondary malignancy, growth/endocrine, neurocognitive; prognosis high-risk historically 30-50% 5-yr survival, improving with newer therapy; family counseling + comprehensive late effects clinic

---

Neuroblastoma = most common solid tumor < 1 yr. Range: spontaneous regression in infants (stage 4S, MYCN-) to highly aggressive (high-risk MYCN+). Multimodal: chemo + surgery + RT + ASCT + anti-GD2 immunotherapy + retinoic acid. Opsoclonus-myoclonus paraneoplastic. Long-term toxicity monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี ปวดท้อง + คลำได้ก้อน abdominal + อ่อนเพลีย + เหนื่อยง่าย + bony pain + periorbital ecchymosis (''raccoon eyes'') + small subcutaneous nodule pulsatile + diarrhea (VIP from tumor)

V/S: HR 132, BP 102/68, BW 12 kg
PE: large irregular firm abdominal mass crossing midline, hepatomegaly, opsoclonus-myoclonus (eye + body), no aniridia

Lab: catecholamines (urine VMA + HVA) HIGH, NSE HIGH, LDH HIGH, ferritin HIGH
CT/MIBG scan: large adrenal mass with calcification + para-aortic LN + bony mets vertebra + femur + bone marrow aspirate POSITIVE for neuroblasts
N-MYC amplification: positive (high-risk)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive surgery + chemo"},{"label":"B","text":"Cat Scratch Disease (Bartonella henselae)"},{"label":"C","text":"Discharge no diagnosis"},{"label":"D","text":"Surgical excision routine"},{"label":"E","text":"Chemo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cat Scratch Disease (Bartonella henselae): most cases self-limited (3-4 mo) — supportive care; for typical immunocompetent + mild disease, antibiotic limited benefit (no proven shortening of natural course); however, AAP recommends azithromycin 10 mg/kg PO day 1, then 5 mg/kg × 4 d (PO) for hastens resolution + accepted; warm compresses to LN; analgesia; do NOT incise + drain typically (sinus tract); needle aspiration if suppurative + symptomatic; reassurance; for severe disease (visceral, encephalopathy, neuroretinitis, hepatosplenic, endocarditis, immunocompromised) — antibiotic combination (azithromycin + rifampin/doxycycline) extended duration; cat avoidance not necessary (most resolution), flea control on pet; HIV/immunocompromised need investigation Bartonella bacillary angiomatosis (different organism); follow-up 2-4 wk; rule out other LN causes (mycobacteria atypical, tularemia, lymphoma) if persists > 2 mo, > 3 cm, hard, systemic symptoms → biopsy

---

Cat scratch = Bartonella henselae from cat (especially kittens). Inoculation papule → regional LN 1-3 wk. Most self-limit. Azithromycin may hasten resolution. Severe/immunocompromised → combination antibiotic. Differential lymphadenopathy includes atypical mycobacteria, lymphoma — biopsy if atypical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี ก้อนต่อมน้ำเหลืองที่คอข้างขวา 2 cm 3 wk + ไข้ต่ำ ๆ + tender 2 wk ก่อนคุยกับแมวบ้านโดน scratch ที่แขนข้างขวา ตรงนี้มี healed papule 1 cm ที่ข้อมือขวา; ไม่มี night sweat, no weight loss, no other LN

BW 24 kg, no organomegaly
CBC normal, ESR mildly elevated
Bartonella henselae IgG titer +';

update public.mcq_questions
set choices = '[{"label":"A","text":"No prophylaxis, breastfeed normally"},{"label":"B","text":"Perinatal HIV exposure HIGH-risk (maternal VL > 50, unsuppressed)"},{"label":"C","text":"Single-drug ZDV only"},{"label":"D","text":"No follow-up"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal HIV exposure HIGH-risk (maternal VL > 50, unsuppressed) — combination antiretroviral prophylaxis: start within 6-12 hr of birth (CRITICAL TIMING) — 3-drug ARV regimen — zidovudine + lamivudine + nevirapine (preferred) OR raltegravir-based per HIV pediatric specialist guidance, duration 6 wk; immediate consultation pediatric HIV specialist; HIV PCR DNA (NAT) at birth, 14-21 d, 1-2 mo, 4-6 mo (definitive exclusion 2 negative tests ≥ 1 mo + ≥ 4 mo); antibody at 18-24 mo confirm; AVOID breastfeeding — replacement feeding (formula) in resource-rich settings; if breastfeeding inevitable (resource-limited) → maternal ART + infant prophylaxis throughout; vaccinations standard except avoid live vaccines (BCG until HIV status known); PCP prophylaxis (TMP-SMX) start age 4-6 wk regardless of CD4 until HIV ruled out; comprehensive primary care + adherence support; partner notification + testing; mental health + social work; if infant infected — start cART immediately, comprehensive HIV care; counsel family + privacy

---

Perinatal HIV exposure: high-risk = 3-drug prophylaxis (vs ZDV monotherapy for low-risk). Start within 6-12 hr. Duration 6 wk. Series of HIV PCR for diagnosis (Ab unreliable < 18 mo). Avoid breastfeeding in resource-rich. PCP prophylaxis. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกเกิดจากแม่ HIV+ on ART unsuppressed viral load 18,000 copies/mL ที่ delivery (NOT undetectable, NOT ideal) คลอด NL term BW 3,000 g

No prenatal care until trimester 3; baby asymptomatic, no obvious dysmorphism, well-appearing
Birth: HIV PCR sent, awaiting result; CBC normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Streptococcal Pharyngitis + Scarlet fever (GAS confirmed)"},{"label":"C","text":"Antiviral"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Discharge no antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Streptococcal Pharyngitis + Scarlet fever (GAS confirmed): antibiotic Penicillin V PO 250 mg BID-TID (< 27 kg) or 500 mg BID (≥ 27 kg) × 10 days OR Amoxicillin 50 mg/kg/d (max 1,000 mg) once daily × 10 days (similar efficacy + better adherence) OR Benzathine penicillin G 600,000 U IM single dose (< 27 kg) or 1,200,000 U (≥ 27 kg) — single shot ensures compliance; for true penicillin allergy: cephalexin (non-anaphylactic), clindamycin, azithromycin (resistance rising — verify), clarithromycin; treatment goals — prevent acute rheumatic fever (best evidence within 9 d of symptom onset), reduce suppurative complication (peritonsillar abscess, OM, sinusitis), reduce contagion (24 hr after antibiotic = not contagious — return school); supportive — analgesia/antipyretic, fluids, salt water gargle; treat household contacts ONLY if symptomatic (not routine); recurrence within months — repeat treatment same; chronic carriers (asymptomatic + Rapid+) generally NOT treated; complications — RhF, PSGN, scarlet fever, peritonsillar abscess; follow-up if persistent symptoms; tonsillectomy criteria — recurrent (Paradise criteria) — not first-line

---

GAS pharyngitis = treat to prevent RhF + complications. Centor score helps clinical Dx; confirm with RADT (high specificity). Penicillin or amoxicillin first-line × 10 d. Scarlet fever = GAS + erythrogenic toxin. 24 hr post-abx → return school. Penicillin allergy → cephalexin most safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 7 ปี ไข้ 39.0°C + เจ็บคอ + กลืนเจ็บ × 2 วัน, ไม่ไอ, ไม่คัดจมูก

V/S: HR 102, Temp 39.0°C, BW 22 kg
PE: tonsils enlarged + exudate, tender anterior cervical LN, no cough, no congestion, palate petechiae, strawberry tongue, sandpaper rash trunk (scarlatiniform)

Rapid Strep A: positive
Center score 4-5';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop resuscitation immediately"},{"label":"B","text":"Pediatric Drowning Cardiac Arrest with hypothermia"},{"label":"C","text":"Cease CPR before rewarm"},{"label":"D","text":"Discharge"},{"label":"E","text":"Defibrillation asystole"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Drowning Cardiac Arrest with hypothermia: continue aggressive ALS resuscitation — high-quality CPR with minimal interruption, depth 1/3 chest diameter, rate 100-120/min, allow full recoil; airway secured + ventilation 10/min asynchronous with chest compression; IV/IO Epinephrine 0.01 mg/kg (0.1 mL/kg 1:10,000) q3-5 min; manage rhythm per PALS — asystole/PEA = CPR + epi; identify + treat reversible causes (Hs and Ts) — Hypoxia (most important in drowning), Hypothermia (continue resuscitation until rewarm > 32°C — ''not dead until warm and dead''), Hypovolemia, H+ (acidosis), Hyperkalemia, Hypoglycemia, Tension PTX, Tamponade, Toxin, Thrombosis (PE/MI uncommon peds); ACTIVE rewarming — warm IV fluid 38-40°C, warmed humidified O2, bladder + gastric + thoracic lavage warm fluid, ECMO if available (Class I in hypothermia arrest); avoid hyperventilation; correct electrolytes; once ROSC — post-arrest care (targeted temperature management — recent THAPCA trials suggest 32-34°C × 2 days vs strict normothermia debated, AHA peds 2020: maintain 32-34°C OR 36-37.5°C without fever); neuro exam delayed prognostication; long-term — most survivors require comprehensive neuro rehab; consider organ donation if irreversibly nonresponsive; family support; prevention — pool fence, supervision, swim lessons, CPR education

---

Drowning = hypoxia primary mechanism. Hypothermia prolongs viability — continue resuscitation until rewarmed > 32-35°C (''not dead until warm and dead''). Reversible causes (Hs and Ts). Post-arrest TTM. Don''t defibrillate asystole. Prevention = supervision + barriers + CPR education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี BW 18 kg พบจมในสระว่ายน้ำ 5-7 นาที EMS เริ่ม CPR pulseless rhythm asystole มา ED ต่อเนื่อง CPR

ณ ED: continued CPR + intubated + IV/IO access; pupils dilated mid-position, no spontaneous breath, no pulse
Monitor: asystole, then PEA
Glucose 80, K 5.2, Temp 32.0°C (mild hypothermia from cold water)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Moderate-Severe Burn 26% TBSA"},{"label":"C","text":"Tubinated outpatient"},{"label":"D","text":"Antibiotic prophylactic"},{"label":"E","text":"Restrict all fluid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Moderate-Severe Burn 26% TBSA — admit burn unit: airway evaluation (no signs above so observation) — early intubation if any signs inhalation; fluid resuscitation — Parkland formula 4 mL × kg × %TBSA (full + partial thickness, NOT superficial) over 24 hr = 4 × 18 × 26 = 1,872 mL Ringer''s lactate, give 1/2 in first 8 hr from time of burn (not arrival), 1/2 over next 16 hr; pediatric variation — additional MAINTENANCE fluid (often D5LR or D5W after) for children — Galveston (5,000 mL × m²/TBSA + 2,000 mL × m² maintenance) or modified Parkland with maintenance; titrate to urine output 1 mL/kg/hr; analgesia adequate — IV morphine 0.05-0.1 mg/kg q2-4h; wound care — cool tap water cooling 20 min if within 3 hr but AVOID hypothermia; gentle wound cleaning; silver sulfadiazine or bacitracin or biological/synthetic dressings; tetanus prophylaxis (per status); circumferential burn → escharotomy assess; nutrition — high calorie + protein (2-3 g/kg/d); infection prevention; physical therapy early to prevent contracture; multidisciplinary burn center; long-term scarring + functional rehab; psychosocial; report if non-accidental suspected (pattern, history inconsistent)

---

Pediatric burn fluid resus = Parkland or Galveston, NOT just Parkland (kids need MAINTENANCE fluid added). UO target 1 mL/kg/hr. Burn center for major burns. Early analgesia + wound care + nutrition. NAI screen if pattern inconsistent. Multidisciplinary including PT/OT/psych.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี BW 18 kg เกิดเหตุน้ำร้อนจากกาแฟราดลงไหล่ + แขน + อก หน้า L (เด็กล้ม) เผาผิวไหม้ตื้น scattered: full thickness 8% + partial thickness 18% (รวม TBSA burn ~26%)

V/S: HR 138, BP 96/60, RR 32, SpO2 99%, Temp 36.4°C
Gen: alert, pain crying, no airway involvement (no soot, no singed hair, no stridor, no hoarseness)
Weight = 18 kg';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Esophageal Button Battery = EMERGENCY (alkaline injury caustic necrosis within 2 hr"},{"label":"C","text":"Wait until passes"},{"label":"D","text":"Charcoal"},{"label":"E","text":"Ipecac"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Esophageal Button Battery = EMERGENCY (alkaline injury caustic necrosis within 2 hr — can cause perforation, fistula, vascular injury, death even after hours): IMMEDIATE endoscopic removal in OR ภายใน 2 hours of ingestion regardless symptom (don''t wait or observe) — gastroenterology/ENT urgent; pre-removal mitigation NEW 2023 NASPGHAN/NACER recommendation — administer HONEY 10 mL PO q10 min × up to 6 doses (if > 12 mo + < 12 hr from ingestion + no perforation) OR sucralfate suspension 10 mL q10 min (in hospital) — both shown to neutralize alkaline injury + reduce mucosal damage in delayed presentation; do NOT induce vomiting (corrosive); NPO; airway monitoring; post-removal — assess injury extent + monitor for delayed complications (esophageal stricture, perforation, aortoesophageal fistula → catastrophic hemorrhage, tracheoesophageal fistula); imaging — repeat imaging confirm removal; if perforation/mediastinitis → surgery + ICU; if battery gastric in asymptomatic + no esophageal injury + > 12 mo + > 15 mm → can sometimes observe with follow-up imaging; education prevention (childproof, lock electronics); reportable to National Capital Poison Center battery hotline (US 1-800-498-8666)

---

Esophageal button battery = TIME-CRITICAL emergency (alkaline burn within 2 hr). Immediate endoscopic removal. HONEY (or sucralfate) mitigation 2023 NASPGHAN: 10 mL q10 min × 6 doses for > 12 mo + < 12 hr. Delayed complications (stricture, fistula) up to weeks later. Childproof prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี กลืนแบตเตอรี่กระดุม (button battery, 20 mm CR2032) 4 ชม ก่อน asymptomatic — เห็นในหลอดอาหารส่วนล่าง 1/3 บน CXR PA + lateral (double halo sign + step-off)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid alone forever"},{"label":"B","text":"Celiac Disease (TTG > 10× + biopsy-confirmed villous atrophy)"},{"label":"C","text":"Eliminate dairy only"},{"label":"D","text":"Reduce gluten"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Celiac Disease (TTG > 10× + biopsy-confirmed villous atrophy): STRICT LIFELONG gluten-free diet (avoid wheat, rye, barley + cross-contamination) — only effective treatment; refer pediatric gastroenterologist + dietitian (gluten-free education essential — labels, eating out, hidden gluten); replace nutritional deficiencies — iron, folate, vitamin D, calcium, B12, zinc selectively; monitor symptom resolution (weeks) + serology normalization (TTG falls 6-12 mo); resolution growth catch-up + symptoms; bone density assessment (osteopenia common); screen first-degree relatives (10% prevalence); associated conditions screen — Type 1 DM (5%), autoimmune thyroid (5-10%), Addison, Sjogren, IgA deficiency, dermatitis herpetiformis; pneumococcal vaccine (functional asplenia); psychosocial — adherence challenges adolescence; ESPGHAN 2020 recent: in some children with TTG > 10× ULN + EMA + + HLA-DQ2/DQ8 → can avoid biopsy (Dx without endoscopy) — biopsy still standard most; long-term complications poorly controlled — refractory celiac, EATL lymphoma, infertility, osteoporosis; school + family + restaurant + travel planning

---

Celiac disease = lifelong gluten avoidance only effective treatment. ESPGHAN 2020: no-biopsy diagnosis if TTG > 10× ULN + EMA + + symptoms (select children). Screen relatives + associated autoimmune conditions. Nutritional repletion. Dietitian + family education. Long-term cancer/osteoporosis surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 5 ปี chronic diarrhea + abdominal distension + ปวดท้องเรื้อรัง + irritable + ผลโรงเรียนตก + growth failure (น้ำหนัก + ส่วนสูง < 3rd percentile) × 1 yr ปกติ unrelated to vaccines or new food

Diet: regular Western diet inc wheat
PE: thin, pot belly, mild pallor, no rash
Family: aunt with type 1 DM, mother autoimmune thyroiditis

CBC: mild iron-deficiency anemia
TTG-IgA HIGH (10× ULN), total IgA normal, anti-EMA + 
Intestinal biopsy: villous atrophy Marsh 3b';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — surgery only"},{"label":"B","text":"Pediatric Crohn Disease with growth failure + perianal + extraintestinal"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Steroid forever"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Crohn Disease with growth failure + perianal + extraintestinal — moderate-severe: multidisciplinary pediatric gastroenterology team + dietitian + IBD nurse + psychology + adolescent medicine + ophthalmology; INDUCTION — exclusive enteral nutrition (EEN) 8 weeks (formula only, equally effective as steroid in pediatric CD, improves growth, no steroid side effects — first-line per ESPGHAN/NASPGHAN); OR systemic corticosteroid prednisolone if EEN not tolerated; biologic — Infliximab (anti-TNF) early in moderate-severe pediatric CD with growth failure or fistulizing/perianal (top-down approach evidence improving outcomes vs step-up) + concurrent immunomodulator (azathioprine 1-2.5 mg/kg or methotrexate 15 mg/m²/wk SC) selected to reduce immunogenicity; ALTERNATIVES — adalimumab, ustekinumab, vedolizumab, risankizumab (newer); perianal fistula — combined medical + EUA + seton drainage + antibiotic (cipro + metronidazole) + biologic; treat anemia (iron replacement IV often), nutritional repletion, vitamin D + calcium; growth monitoring + puberty staging; ophthalmology for uveitis (topical steroid + treat IBD); surveillance colonoscopy + cancer screening; immunization including live (varicella/MMR) BEFORE biologic; mental health + transition adult care; surgery — symptomatic fistula not responding, stricture, perforation, abscess, refractory disease, dysplasia

---

Pediatric Crohn = growth + nutrition focus. EEN first-line induction (vs steroid). Early biologic (top-down) for moderate-severe + complicating features improves long-term outcomes + growth. Perianal disease = combined medical + surgical. Multidisciplinary team. Vaccinate before biologic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 13 ปี chronic intermittent abdominal pain RLQ + diarrhea 4-6 ครั้ง/วัน (intermittent bloody) + weight loss 7 kg ใน 6 mo + delayed puberty Tanner 2 + ครั้งล่าสุดมี perianal fistula + ตา anterior uveitis flare

V/S: HR 92, BW 38 kg (had been 45 kg)
PE: cachectic, RLQ tenderness, perianal tag + small fistula, clubbing early, no organomegaly

CBC: Hb 9.8 (microcytic), albumin 2.6, ESR 78, CRP 95, ferritin low
Fecal calprotectin > 1,000 (very high)
Colonoscopy + ileoscopy: skip lesions ileum + terminal colon + perianal disease + cobblestoning + granulomas histology = Crohn disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Acute Otitis Media (AAP 2013 + 2022 update)"},{"label":"C","text":"Surgery first"},{"label":"D","text":"Antiviral"},{"label":"E","text":"Steroid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Otitis Media (AAP 2013 + 2022 update): antibiotic indicated < 6 mo all, 6-23 mo with unilateral severe, ≥ 2 yr severe or bilateral ≥ 2 yr if non-severe; this patient (18 mo, unilateral + severe) → antibiotic; Amoxicillin 80-90 mg/kg/d ÷ q12h × 10 days (< 2 yr) — first-line if no recent antibiotic use; Amoxicillin-clavulanate 90 mg/kg/d if: recent antibiotic < 30 d, concurrent conjunctivitis (likely H. flu), prior treatment failure, recurrent AOM, severe disease, child > 2 yr can use 7-day course; alternatives for penicillin allergy (non-anaphylactic) — cefdinir, cefuroxime, cefpodoxime; anaphylaxis — azithromycin (resistance rising); analgesia + antipyretic (ibuprofen + acetaminophen); shared decision-making ''watchful waiting'' (Watch + Wait, with prescription back-up) for non-severe, unilateral, ≥ 2 yr; follow-up if no improvement 48-72 hr → reassess + escalate (amox-clav, ceftriaxone IM × 1-3 d); tympanostomy tubes for recurrent (≥ 3 in 6 mo or ≥ 4 in 12 mo) or chronic effusion + hearing/speech impact; PCV13/15/20 + influenza vaccine reduce AOM; breastfeeding + smoke avoidance preventive

---

AOM = most common kid bacterial infection (Spn, H flu, M cat). AAP 2013/2022: antibiotic for severe or < 2 yr bilateral; amoxicillin first-line. Pain management critical. Watchful waiting in select. Recurrent → tubes. Pneumococcal vaccine prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน ไข้ 39°C + irritable + ดึงหู ซ้าย × 2 วัน + URI 4 วันก่อน

V/S: HR 122, RR 28, Temp 39.0°C, BW 11 kg
PE: TM left bulging + erythematous + decreased mobility on pneumatic otoscopy = AOM moderate-severe, no perforation, no posterior auricular swelling
Right TM normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Acute Mastoiditis (complication AOM)"},{"label":"C","text":"Antiviral alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Wait for spontaneous resolution"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Mastoiditis (complication AOM): admit + IV antibiotic urgent — Ceftriaxone 50-100 mg/kg/d (covers Spn, H flu, Strep, GAS) + Vancomycin 60 mg/kg/d if concern MRSA, or Pip-tazo if severe; ENT consultation urgent; if subperiosteal abscess → surgical drainage (myringotomy + tympanostomy tube + cortical mastoidectomy if coalescent or abscess or refractory); imaging — CT temporal bone + intracranial complication screen (epidural abscess, sigmoid sinus thrombosis, meningitis, brain abscess); intracranial complications → emergent neurosurgery + extended antibiotic + anticoagulation for sinus thrombosis (controversial); blood culture + ear discharge culture pre-antibiotic; analgesia + supportive; total antibiotic 2-4 wk IV → oral; hearing test + ENT follow-up; recurrent risk; counsel + education AOM treatment importance

---

Mastoiditis = AOM complication. Protruding pinna + post-auricular swelling = classic. CT for severity + intracranial complication screen. IV antibiotic + ENT + surgery if abscess/coalescent. Sigmoid sinus thrombosis + brain abscess = serious neurological complications.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี untreated AOM 10 วันก่อน ตอนนี้ ไข้สูง 39.5°C + ปวดหลังหู + บวมแดงด้านหลังใบหู ดันใบหูออกข้างหน้า + irritable + drowsy

V/S: HR 132, RR 28, Temp 39.5°C, BW 18 kg
PE: protruding right pinna outward + downward, post-auricular swelling + erythema + tenderness + fluctuance, TM right perforated purulent discharge, ตรวจ neuro ปกติ

CBC: WBC 22,400 (left shift), CRP 168
CT mastoid: opacification mastoid air cells + coalescent destruction bony septae + small subperiosteal abscess + intact intracranial';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive antibiotic"},{"label":"B","text":"Erythema Infectiosum (Fifth Disease, Parvovirus B19)"},{"label":"C","text":"Isolation indefinitely"},{"label":"D","text":"Antiviral 6 weeks"},{"label":"E","text":"Steroid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Erythema Infectiosum (Fifth Disease, Parvovirus B19): supportive care — no specific antiviral, rash phase = not contagious (contagious during pre-rash febrile illness only); reassurance — self-limited 7-10 days, rash can wax/wane with heat/sun/exercise × wk-mo; antipyretic + comfort; safe return to school (rash phase non-contagious); aplastic crisis precautions — counsel family/contacts with chronic hemolytic anemia (sickle cell father — temporary red cell aplasia, ~2 wk transfusion-dependent crisis) — they may need transfusion + isolation if exposed; pregnant women contacts — counsel about risk fetal hydrops + miscarriage (1st trimester especially) — referral for serology + obstetric monitoring; immunocompromised — chronic infection risk → IVIG treatment; arthritis (especially adults more) self-limit weeks; rare complications — myocarditis, encephalitis; no vaccine available; long-term immunity following infection

---

Parvovirus B19 = fifth disease. Slapped cheek + lacy rash. Self-limit. Concerns: aplastic crisis in chronic hemolytic anemia (sickle cell), fetal hydrops in pregnancy, chronic anemia in immunocompromised. Rash phase NOT contagious — only pre-rash febrile. Supportive care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี ไข้ + เหนื่อย 3 วัน 1 wk ago — well-appearing ตอนนี้ มี slapped cheek แดงสด ทั้ง 2 ข้าง + lacy reticular erythematous rash trunk + arms + legs ปรากฏ 2 วัน, ไม่คัน, ไม่มีไข้ ตอนนี้

PE: bilateral malar erythema + lacy rash limbs, no oral lesions, no other findings
Family: father chronic anemia (sickle cell), grandmother elderly
No joint complaint';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic only"},{"label":"B","text":"Reye Syndrome (acute encephalopathy + fatty liver, association salicylate + viral illness"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reye Syndrome (acute encephalopathy + fatty liver, association salicylate + viral illness — varicella/influenza): admit PICU; aggressive management cerebral edema — head of bed 30°, intubation + mild hyperventilation transient, osmotherapy (mannitol 0.25-1 g/kg or 3% hypertonic saline 2.5-5 mL/kg), maintain CPP, monitor ICP (consider invasive ICP monitor), avoid hypotonic fluids; correct hypoglycemia — D10W (often need ongoing infusion + hyperglycemic state target); correct coagulopathy — vitamin K, FFP if bleeding/procedure; correct electrolyte derangements + avoid hyponatremia (worsens edema); manage hyperammonemia — lactulose, neomycin/rifaximin (limited evidence in Reye but tradition); avoid sedatives/hepatotoxic; supportive — temperature regulation, GI prophylaxis, DVT prophylaxis if able, infection surveillance; rule out other causes (inborn errors of metabolism — urine organic acids, acylcarnitine, ammonia, lactate — especially recurrent Reye-like → MCAD/OTC etc); liver transplant evaluation for refractory liver failure; prevention — AVOID aspirin in children with viral illness/varicella/influenza (FDA black box) — use acetaminophen/ibuprofen; reportable to CDC; long-term: high mortality 20-40%, neurologic sequelae in survivors

---

Reye syndrome = aspirin + viral illness (varicella, influenza) classic. Hepatic + brain dysfunction without jaundice + hyperammonemia + hypoglycemia + coagulopathy. Management ICU + cerebral edema + supportive. RULE OUT inborn errors metabolism. PREVENT — no aspirin in kids with viral illness (use acetaminophen).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี 4 วัน ก่อนเป็น chickenpox + influenza, แม่ให้ aspirin ลดไข้ ตอนนี้ vomiting persistent 24 ชม + ซึม + irritable → lethargic + confused → in coma, no fever now

V/S: HR 122, BP 132/88, RR 24, Temp 37.0°C
Gen: lethargic, GCS 11, hepatomegaly 3 cm, no jaundice, decerebrate posturing

ALT 850, AST 920, NH3 280 (high), INR 2.4, hypoglycemia 48, glucose, no bilirubin elevation
Brain CT: cerebral edema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Heel-stick tests only PKU"},{"label":"B","text":"Universal Newborn Screening (NBS) per state mandates"},{"label":"C","text":"Optional only"},{"label":"D","text":"Wait until 6 weeks"},{"label":"E","text":"Single disease test"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Universal Newborn Screening (NBS) per state mandates — typically tests > 30 conditions ในแผง expanded screening (US RUSP / Thai NBS): metabolic — phenylketonuria, MSUD, homocystinuria, tyrosinemia, galactosemia, fatty acid oxidation (MCAD, VLCAD, LCHAD), organic acidemias (MMA, PA, IVA, GA1); endocrine — congenital hypothyroidism (CH), congenital adrenal hyperplasia (CAH); hemoglobinopathies — sickle cell, beta-thalassemia; cystic fibrosis (IRT ± DNA), severe combined immunodeficiency (SCID — TREC assay), spinal muscular atrophy (SMA), lysosomal storage disease (Pompe, MPS-I, others — newer additions), critical congenital heart disease (CCHD — pulse oximetry), hearing screen (OAE/AABR); rationale — early detection of treatable disorders to prevent disability + death (success stories — PKU, CH, CAH, MCAD, SCD); collection 24-48 hr to allow milk feeding (avoid false negatives); positive screen = NOT diagnosis (confirmatory testing needed urgent), counsel families carefully; primary care + subspecialty referral for positives; education + family-centered approach; recheck — if early discharge before 24 hr or NICU/transfusion → repeat; coordinated with genetic counseling

---

NBS = public health success — early detection treatable diseases. US RUSP > 30 conditions, varies by state. Heel-stick 24-48 hr + pulse oximetry + hearing screen. Positive screen needs confirmatory testing + urgent subspecialty. Improves outcomes for many treatable conditions.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 24 hr ก่อน discharge แม่ถามว่าทำไมต้องเจาะส้นเท้า ผ่านมาสองวันได้รับ heel-stick "PKU test"';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic IV broad-spectrum"},{"label":"B","text":"Acute viral gastroenteritis with moderate dehydration"},{"label":"C","text":"Bowel rest NPO 24 hr"},{"label":"D","text":"Antimotility agent"},{"label":"E","text":"Discharge no rehydration"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute viral gastroenteritis with moderate dehydration: ORS (Oral Rehydration Solution) per WHO/AAP — first-line for mild-moderate even with vomiting; calculate deficit ~50-100 mL/kg = 600-1,100 mL replace over 4 hr in small frequent volumes (5 mL q1-2 min, gradually increase); ondansetron oral 0.15 mg/kg single dose (1 dose) reduces vomiting + admission (evidence-based); IV fluid bolus 20 mL/kg NSS only if severe dehydration/shock/failed ORS; reassess hydration q1-2 hr; resume regular age-appropriate diet (BRAT diet not necessary — continued breastfeeding, formula, regular food OK as tolerated, NO dilution); rotavirus vaccine prevention (RV1 or RV5); zinc supplement 10-20 mg/d × 10-14 d (developing world WHO — modest benefit); probiotics (Lactobacillus GG, S. boulardii) shorten duration mild benefit; AVOID — antimotility (loperamide) ในเด็กเล็ก; antiemetic limited to ondansetron; antidiarrheal limited; counsel — return if dehydration worsens, blood, high fever, persistent vomit; admit if cannot tolerate ORS, severe dehydration, electrolyte imbalance, < 6 mo with severe vomiting

---

Viral gastroenteritis = leading cause peds diarrhea. Rotavirus most common (declining with vaccine). ORS first-line — even with vomiting (give small frequent). Ondansetron evidence-based reduces vomit + admission. Resume normal diet ASAP. Avoid antimotility. Hand hygiene + vaccine prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 เดือน BW 11 kg ถ่ายเหลว 8 ครั้ง/วัน + อาเจียน 6 ครั้ง × 2 วัน หลังจากเพื่อน daycare เป็นเหมือนกัน, no blood in stool, ไม่ไข้สูง

V/S: HR 168, BP 88/52, RR 32, Temp 37.6°C, capillary refill 3-4 sec
Gen: lethargic แต่ rousable, sunken eyes, dry mucous membranes, decreased skin turgor, น้ำหนักลด 800 g (~7% loss) — moderate dehydration

Lab: Na 138, K 3.5, HCO3 18, glucose 88, BUN 28
Stool: rotavirus antigen positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Slow oral rehydration only"},{"label":"B","text":"Severe Hypovolemic Shock + Severe Hypernatremic Dehydration (cholera)"},{"label":"C","text":"Subcutaneous fluid"},{"label":"D","text":"Antiemetic alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Hypovolemic Shock + Severe Hypernatremic Dehydration (cholera): URGENT IV/IO access ภายใน 5 นาที (alternative 3-mortar drill); RAPID IV bolus Ringer''s Lactate 20 mL/kg over 5-15 min repeat as needed (typical 60 mL/kg first hour); reassess after EACH bolus (mental status, perfusion, HR, BP, UO); IV antibiotic — Doxycycline 4.4 mg/kg single dose PO/IV OR Azithromycin 20 mg/kg single dose OR Erythromycin (alternative cholera-specific to reduce stool output + duration); for severe HYPERNATREMIA correct slowly to AVOID cerebral edema — once shock resolved, replace remaining deficit + ongoing losses over 48-72 hours, reduce serum Na ≤ 10-12 mEq/L per 24 hr (calculate free water deficit, give D5 ¼-½ NSS depending); correct hypokalemia (caution if renal failure) + acidosis (often self-corrects with perfusion); strict ins/outs; monitor for AKI; transfer to ICU; once tolerating PO, transition ORS + continue antibiotic; isolation + infection control (notifiable disease); public health reporting; family contact prophylaxis if outbreak; long-term: cholera vaccine for outbreak/endemic

---

Severe dehydration + shock = IV/IO emergency. 20 mL/kg LR bolus repeat × reassess. Cholera = rapid massive losses, dyhydration may progress hours. Hypernatremic correction slow (≤ 12 mEq/L per 24 hr) — too fast = cerebral edema. Antibiotic reduces stool output + duration. Notifiable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 12 mo BW 9 kg ถ่ายเหลว 15 ครั้ง + อาเจียน 8 ครั้ง × 36 ชม นาน 4 วันก่อน (cholera outbreak ในชุมชน) ปัสสาวะไม่ออก 12 ชม, lethargic

V/S: HR 198 (thready), BP 60/30 (palpable), RR 48, SpO2 96%, Temp 36.2°C, capillary refill 6 sec, BW 8 kg (loss 1 kg = ~11% severe)
Gen: lethargic-obtunded, deep sunken eyes, no tears, dry mucous, very poor turgor, cold extremities

Lab: Na 152 (hypernatremic), K 2.8, HCO3 8, BUN 48, Cr 1.4, glucose 60, pH 7.10
Stool RDT: V. cholerae O1 positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + recheck 3 mo"},{"label":"B","text":"Biliary Atresia (progressive obliterative cholangiopathy)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery age 1"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biliary Atresia (progressive obliterative cholangiopathy) — TIME-CRITICAL Dx: Kasai portoenterostomy (hepatic portoenterostomy connecting Roux limb of jejunum to porta hepatis) — outcomes depend strongly on age at surgery — best if < 60 days of age (success bile flow > 70%, vs < 30% if > 90 d); refer urgent hepatobiliary surgical center; pre-op: vitamin K + correct coagulopathy, optimize nutrition; post-op care — fat-soluble vitamin supplementation (ADEK), MCT formula, prophylactic antibiotic (TMP-SMX or neomycin) to prevent cholangitis (common complication post-Kasai); ursodeoxycholic acid 10-20 mg/kg/d may improve bile flow; growth + nutrition monitoring; treat cholangitis with broad-spectrum IV antibiotic + admit; long-term — even successful Kasai 50% require liver transplant by age 20 (chronic liver disease progresses); refer pediatric liver transplant center early; family support + education + transition adult; counsel family — without treatment, biliary cirrhosis + death by 2-3 yr; key teaching: ANY infant with jaundice > 2 wk needs fractionated bilirubin, direct > 2 or > 20% total = pathologic

---

Biliary atresia = #1 indication peds liver transplant. ANY infant jaundice > 2 wk = check direct bilirubin (don''t dismiss). Kasai < 60 days = best outcome. Even with Kasai, 50% need transplant. Multidisciplinary HCC center. Cholangitis prophylaxis. ADEK + nutrition.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกหญิงอายุ 6 wk term BW 4 kg jaundice ต่อเนื่อง ตั้งแต่ 2 wk + acholic stools (pale/clay-colored) + dark urine + hepatomegaly + คาดว่าเป็น ''physiologic jaundice'' ก่อนหน้านี้

Growth ปกติ, no spleen palpable, alert, no rash
Lab: Total bilirubin 9.2 (DIRECT 5.8 — conjugated/direct > 2 abnormal!), ALT 220, AST 280, GGT 380, ALP 540, albumin 3.6
Abdominal US: gallbladder small/absent, triangular cord sign, no obvious bile duct
HIDA scan: no excretion into bowel after 24 hr (even with phenobarbital priming)
Liver biopsy: bile duct proliferation + ductopenia + portal fibrosis = consistent with biliary atresia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid for hepatitis"},{"label":"B","text":"Acute Hepatitis A (self-limited typically in children)"},{"label":"C","text":"Liver transplant immediately"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hepatitis A (self-limited typically in children): supportive care — usually completely self-resolving, especially in younger kids; rest as tolerated; adequate nutrition (low-fat diet only as tolerance with nausea, no restriction need); maintain hydration; AVOID hepatotoxic drugs (acetaminophen — restrict to therapeutic doses if needed, NSAIDs, alcohol in adolescents); ANTIVIRAL NOT INDICATED (HAV self-limit); monitor for fulminant hepatitis (rare 0.4%) — daily clinical assessment + LFT + INR + glucose; admit if vomiting can''t maintain hydration, severe pain, signs of coagulopathy or encephalopathy (INR > 1.5 + AMS = pediatric acute liver failure → transplant center referral); isolation — fecal-oral spread; school exclusion 1 wk post-jaundice onset; hand hygiene critical; CONTACTS — post-exposure prophylaxis with HAV vaccine within 14 days (preferred immunocompetent + age 1-40) OR IG for selected (< 12 mo, > 40 yr, immunocompromised, chronic liver dz, pregnant); HAV vaccine routine 12-23 mo (Thai EPI + ACIP); reportable to public health; counsel hygiene + safe food/water + vaccine education

---

HAV = fecal-oral, self-limited in kids (more severe adults). Supportive care. Monitor for fulminant (rare). Post-exposure prophylaxis = HAV vaccine within 14 d most. HAV vaccine routine 12-23 mo + travelers. Hygiene + food/water safety. Reportable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี ไข้ + คลื่นไส้ + อ่อนเพลีย + ปวดท้อง + เบื่ออาหาร × 1 wk เพิ่งกลับจากเที่ยว rural area กิน street food, น้ำดื่มต่างถิ่น ตอนนี้ตัวเหลือง + ปัสสาวะสีเข้ม + อุจจาระสีอ่อนลง

V/S: BW 22 kg, mild jaundice, hepatomegaly + tender, no encephalopathy, alert

Lab: Total bilirubin 8.5 (mixed elevation, direct 4.5), ALT 1,820, AST 1,640 (very high), ALP 240, INR 1.1, no coagulopathy yet
Anti-HAV IgM POSITIVE, anti-HEV negative, anti-HBV negative, anti-HCV negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — PDA closes naturally"},{"label":"B","text":"Hemodynamically significant Patent Ductus Arteriosus (hsPDA) premature"},{"label":"C","text":"Surgery routinely all preemies"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemodynamically significant Patent Ductus Arteriosus (hsPDA) premature: fluid restriction (110-130 mL/kg/d); ventilation optimization (high PEEP); pharmacological closure — Indomethacin 0.2 mg/kg q12h × 3 doses (classical) OR Ibuprofen 10 mg/kg then 5 mg/kg q24h × 2 doses (similar efficacy + fewer renal/GI side effects) OR oral acetaminophen 15 mg/kg q6h × 3-7 days (newer alternative — equally effective in some studies + safer for renal/platelet) — monitor renal function, platelets, NEC, IVH; consider transcatheter PDA closure (Amplatzer Piccolo) increasingly used preterm — particularly if pharm contraindicated/failed; SURGICAL ligation reserved for failed pharm + transcatheter not feasible (now used less due to long-term morbidity); CONSERVATIVE management — many small PDA close spontaneously even in preemies, recent trials (PDA-TOLERATE, BeNeDuctus) question aggressive treatment — selective treatment with hsPDA only; if not hemodynamically significant → observe; monitor RFFD (recurrent BPD, IVH, NEC, mortality); coordinate neonatology + cardiology

---

PDA premature = common, may close spontaneously. Treatment debated — recent trials (BeNeDuctus, PDA-TOLERATE) favor selective for hsPDA. Pharm: indomethacin or ibuprofen (renal/GI risk) or acetaminophen (safer profile). Transcatheter Piccolo emerging. Surgery rarely.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก preterm GA 27 wk BW 850 g อายุ 8 วัน on ventilator + surfactant ตอนแรกดีขึ้น แต่จู่ ๆ ต้อง FiO2 เพิ่มจาก 0.25 → 0.45, RR เพิ่ม, persistent murmur new + bounding pulses + wide pulse pressure (50/25, mean 33) + active precordium

Echo: large PDA 3 mm + L-R shunt + LA/LV enlargement + reverse diastolic flow descending aorta (steal phenomenon)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Infective Endocarditis confirmed (modified Duke criteria"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery without antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infective Endocarditis confirmed (modified Duke criteria — major: typical organism + echo evidence): admit + IV antibiotic — Penicillin G 200,000-300,000 U/kg/d ÷ q4-6h OR Ceftriaxone 100 mg/kg/d once daily (for penicillin-susceptible Strep viridans) + Gentamicin 3 mg/kg/d ÷ q8h × first 2 weeks (synergy short-course); total duration 4 weeks IV (uncomplicated native valve) or 6 weeks (prosthetic, complications); blood culture follow-up 48-72 hr q week × duration; daily TTE/weekly serial monitoring vegetation + complications; pediatric infectious disease + cardiology + cardiac surgery consultation; SURGICAL INDICATIONS (~50% need surgery): heart failure, abscess, persistent bacteremia despite appropriate antibiotic, large vegetation > 10 mm with embolism, fungal IE, prosthetic dehiscence; complications surveillance — embolic events (stroke, kidney, spleen, mycotic aneurysm), heart failure, abscess; supportive — anti-HF if HF, anticoagulation NOT routine; oral health + dental followup; secondary prevention — AHA 2007/2021: antibiotic prophylaxis for selected dental/respiratory procedures in high-risk lesions only (prosthetic, prior IE, cyanotic unrepaired, < 6 mo post-repair with material, repair with residual defect adjacent to material, transplant valvulopathy); long-term: cardiology follow-up + heart failure monitoring

---

IE in kids with CHD = important consideration. Modified Duke criteria. TEE > TTE for vegetations/abscess. Long-course IV antibiotic + surgical evaluation for indications. AHA 2007/2021: prophylaxis only highest-risk lesions, not all murmurs. Oral hygiene + dental.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 12 ปี s/p TOF repair 8 ปีที่แล้ว มี residual VSD + AR ไข้ต่ำ ๆ persistent × 3 wk + เหนื่อย + เบื่ออาหาร + weight loss 2 kg ก่อนหน้าทำฟันโดยไม่ได้ antibiotic

V/S: HR 102, BP 102/40 (wide PP from AR), Temp 38.4°C, BW 32 kg
PE: pale, splinter hemorrhages, Roth spots fundus, new murmur AR worse, splenomegaly mild

CBC: WBC 14,200, Hb 9.8 (chronic), CRP 78, ESR 92
Blood culture × 3 separate sites POSITIVE Strep viridans
TTE then TEE: vegetation 8 mm aortic valve + small abscess root';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Pediatric Decompensated Heart Failure (cardiogenic shock approaching)"},{"label":"C","text":"ACEI alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Vasodilator only without inotrope"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Decompensated Heart Failure (cardiogenic shock approaching): admit ICU; ABC + supplemental O2 (BiPAP/HFNC, intubation if respiratory failure); hold/pause carvedilol acutely (negative inotrope, restart when compensated); continue ACEI if BP tolerates (otherwise hold); IV diuretic — furosemide 1-2 mg/kg IV bolus then continuous infusion 0.1-0.5 mg/kg/hr titrate UO; correct electrolytes (K, Mg); INOTROPIC SUPPORT — Milrinone 0.25-0.75 mcg/kg/min (preferred — inodilator, reduces afterload + improves cardiac output, less arrhythmogenic, avoid if hypotension or renal failure) OR Dobutamine 5-15 mcg/kg/min OR low-dose epinephrine if hypotension; mechanical circulatory support — ECMO or VAD (Berlin Heart EXCOR pediatric LVAD widely used) if refractory to medical management = bridge to transplant; advanced HF + transplant team referral early (urgent listing); strict ins/outs + daily weight; volume optimization; address arrhythmia (ICD for primary/secondary prevention SCD); long-term once stable — beta-blocker + ACEI/ARB + spironolactone + sometimes ivabradine; sacubitril/valsartan emerging peds (PANORAMA trial); device therapy (ICD, CRT) selected; nutrition + cardiac rehab; psychosocial; transition adult; transplant outcomes peds excellent (1-yr 90%+, 5-yr 80%)

---

Pediatric decompensated HF = ICU + careful balance. Milrinone preferred inotrope. Mechanical support (ECMO, Berlin Heart) bridge to transplant. Hold beta-blocker acutely. Continue ACEI if tolerates. Transplant evaluation early. Long-term: optimize medical + device + transplant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี idiopathic dilated cardiomyopathy ที่ Dx 6 mo ago บน carvedilol + enalapril มา ED ด้วยอาการเหนื่อยมาก ขณะพักไม่หาย + ขาบวม + น้ำหนักเพิ่ม 3 kg ใน 1 wk + ปัสสาวะน้อย

V/S: HR 132, BP 88/58, RR 32, SpO2 92%, BW 28 kg
Gen: cachectic, JVD, S3 gallop, hepatomegaly 5 cm, bilateral pretibial pitting edema, cool extremities, prolonged cap refill 4 sec

Lab: BNP 4,200, Cr 1.2 (baseline 0.6), Na 132, K 4.2
Echo: EF 18% (down from 28%), severe LV dilation, severe MR
INTERMACS profile 3-4';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — outgrow"},{"label":"B","text":"Hirschsprung Disease (congenital aganglionic megacolon, classic)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Laxative"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hirschsprung Disease (congenital aganglionic megacolon, classic): pediatric surgery referral urgent; initial management — saline rectal irrigations (decompression, prevent enterocolitis) BID-TID until surgery; broad-spectrum antibiotic prophylaxis (Hirschsprung-associated enterocolitis HAEC is life-threatening — fever + distension + bloody/explosive stool, mortality 30%, treat early with IV antibiotic + irrigation + NPO + IV fluids + surgical assessment for perforation/toxic megacolon); definitive surgery — pull-through procedure (Soave, Swenson, Duhamel) — typically performed 3-6 mo of age (single-stage primary pull-through if stable, or staged with colostomy if extensive disease/severe enterocolitis); post-op — irrigation continued first months, monitor for HAEC, soiling/constipation common (manage with bowel program, biofeedback, sphincter assessment); long-term: most achieve near-normal continence (60-80%), but HAEC risk persists; total colonic Hirschsprung worse prognosis; family genetic counseling (RET mutation, 5-10% familial); associated conditions screen — Down syndrome (CRSI), other syndromes; long-term follow-up bowel function + growth; education families about HAEC signs + emergency contact

---

Hirschsprung = delayed passage meconium (> 48 hr term) + bowel obstruction + transition zone. Confirm rectal biopsy (aganglionosis). HAEC = life-threatening complication. Pull-through 3-6 mo. Saline irrigations bridge. Long-term continence usually good. Genetic screening selected.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term DOL 3 ยังไม่ถ่ายขี้เทา + วันที่ 2 อาเจียน bilious + abdominal distension + เมื่อใส่ rectal tube → explosive passage gas + meconium then re-distends

Family: cousin with similar history
V/S: HR 152, RR 48, mild distress, distended abdomen, hyperactive bowel sounds, empty rectal vault on DRE, no fistula no anal stenosis

AXR: dilated loops + paucity rectal air
Contrast enema: transition zone sigmoid + delayed emptying
Rectal suction biopsy: AGANGLIONIC + hypertrophied nerve fibers + acetylcholinesterase + = Hirschsprung disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose diuretic alone"},{"label":"B","text":"AKI Stage 3 (Cr > 3× baseline)"},{"label":"C","text":"Restrict all fluid + protein severely"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AKI Stage 3 (Cr > 3× baseline) — likely intrinsic ATN from prolonged hypovolemic-prerenal then ATN (also consider HUS but no MAHA/thrombocytopenia here, post-infectious GN, drug-induced, NSAID-related): assess + treat reversible factors — adequate volume status (carefully — if hypovolemic give IV fluid challenge 10-20 mL/kg, otherwise restrict to insensible + UO if euvolemic/overloaded); STOP nephrotoxic drugs (NSAID, aminoglycoside, IV contrast, ACEI); manage HYPERKALEMIA — calcium gluconate (cardiac protection if ECG changes), insulin + glucose, albuterol nebulizer, sodium bicarbonate if acidotic, kayexalate (selected pediatric — caution), dialysis if refractory or > 6.5; correct acidosis (sodium bicarb if pH < 7.2 or HCO3 < 12); manage hyperphosphatemia + hypocalcemia — phosphate binder; nutritional support — adequate calorie, restrict K + P + Na, modest protein (1-1.5 g/kg/d, NOT severe protein restriction); RENAL REPLACEMENT THERAPY indications (peds AEIOU): A — Acidosis severe, E — Electrolyte (K refractory), I — Intoxication, O — Overload severe with respiratory compromise, U — Uremia symptomatic; modalities — hemodialysis (typical for child), CRRT (hemodynamically unstable, ICU), peritoneal dialysis (younger, available, hemodynamically tolerant); pediatric nephrology consultation; monitor recovery (typical ATN recovers 1-3 wk); long-term follow-up — CKD risk 30-50% even after recovery, BP monitoring, growth, schooling

---

Pediatric AKI = KDIGO criteria. Common causes: prerenal (dehydration), ATN, HUS, GN, obstruction, drug-induced. Stop nephrotoxin. Manage hyperK + acidosis + fluid carefully. RRT for refractory AEIOU. Long-term CKD risk → follow-up. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี ติดเชื้อ Salmonella gastroenteritis 5 วันแล้ว ตอนนี้ปัสสาวะลด < 0.5 mL/kg/hr × 12 hr + edema mild + lethargic

V/S: BP 132/86, HR 102, BW 22 kg
PE: mild dehydration improved but edema developing, no rash, no joint, no purpura

Lab: BUN 64, Cr 2.4 (baseline 0.5), K 5.8, P 6.2, Ca 8.0, HCO3 16, Albumin 3.4
UA: granular casts, mild proteinuria 1+, no RBC, eosinophils negative, Na urine 60 mmol/L, FeNa 3% (intrinsic)
US: kidneys normal size + echogenicity, no obstruction';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antihypertensive only without lifestyle"},{"label":"B","text":"Pediatric Hypertension Stage 1 (likely primary/essential associated with obesity)"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single BP check sufficient"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertension Stage 1 (likely primary/essential associated with obesity) — AAP 2017 Clinical Practice Guideline: confirm BP > 95th percentile on 3 separate occasions OR ABPM; obesity treatment cornerstone — MULTICOMPONENT lifestyle modification (DASH diet, reduce sodium < 1500-2300 mg/d, increase fruits/vegetables/whole grains, limit sugar-sweetened beverages); physical activity ≥ 60 min/d moderate-vigorous, limit screen time < 2 hr/d; weight management + family-based behavioral therapy; address sleep — screen + treat OSA (polysomnography given snoring + apnea, likely contributes); secondary cause workup — UA + Cr + electrolytes + lipids + glucose + insulin + TSH + plasma renin + aldosterone if young/severe, renal US + ECHO for end-organ damage (LVH suggests need treatment); INDICATIONS pharmacological therapy — secondary HT, symptomatic HT, target organ damage (LVH, CKD, retinopathy), Stage 2 HT, lifestyle modification failure for Stage 1, persistent risk; FIRST-LINE drugs — ACE inhibitor (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide; AVOID — abrupt withdrawal beta-blocker, ACEI in pregnancy potential; target < 90th percentile (or < 130/80 adolescents); monitor q3-6 mo + adjust; address comorbid CV risk factors (lipid, glucose); transition to adult care; PARENT/family lifestyle support critical

---

Pediatric HT rising prevalence (obesity epidemic). AAP 2017: new lower BP thresholds. Confirm with multiple measurements + ABPM. Lifestyle modification mainstay. Pharm for secondary, symptomatic, end-organ damage, Stage 2, refractory. ACEI/ARB/CCB/thiazide first-line. Address comorbid CV risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 11 ปี BMI 28 (severe obesity, > 99th percentile) ไม่มีอาการ มา clinic เพื่อ check-up ครู school พบ BP สูงในห้อง infirmary 3 ครั้ง

Clinic BP 3 ครั้ง q1 min: 142/92, 138/90, 140/88 (all > 95th percentile for age/height — confirmed stage 1 HT > 95th + > 1 yr); 24-hr ABPM mean SBP > 95th + > 1 yr — confirmed sustained HT

Hx: father HT, no medication, no symptoms; sleep snoring witnessed apnea by mother
Lab: lipid mildly elevated, glucose 102 (impaired), HbA1c 5.9 (pre-diabetes), Cr normal, no proteinuria, TSH normal
US renal: normal
Echo: mild LVH (LV mass index increased)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Splenectomy immediately for all"},{"label":"B","text":"Hereditary Spherocytosis (autosomal dominant most, spectrin/ankyrin defect)"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid lifelong"},{"label":"E","text":"Antibiotic prophylaxis only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Spherocytosis (autosomal dominant most, spectrin/ankyrin defect): folic acid 1 mg/day lifelong (high RBC turnover); blood transfusion only for aplastic crisis (Parvo B19) or severe symptomatic anemia; recheck CBC + reticulocyte q3-6 mo; ultrasound for gallstones (high prevalence — pigmented stone, prophylactic cholecystectomy at time of splenectomy if stones present); growth monitoring; INDICATIONS for SPLENECTOMY (typically delayed until > 6 yr to allow immune maturation, reduce sepsis risk): severe HS (Hb < 8, severe hyperbilirubinemia, growth failure, gallstones, frequent hospitalizations); subtotal/partial splenectomy emerging — preserves some immune function; PRE-SPLENECTOMY immunizations 2 wk before — pneumococcal (PCV13 + PPSV23), meningococcal (MenACWY + MenB), Hib + influenza annual; POST-SPLENECTOMY — penicillin prophylaxis (Pen V 125 mg BID < 5 yr, 250 mg BID > 5 yr) × minimum 5 years OR lifelong (varies), aspirin for thrombocytosis selected; education sepsis emergency response (fever > 38.5 → urgent evaluation, IV antibiotic — septic risk encapsulated organism lifelong); medical alert; family screening + genetic counseling (autosomal dominant 75%); transition adult

---

HS = most common hereditary hemolytic anemia. EMA flow cytometry standard test (+ osmotic fragility classical). Folate + monitoring + splenectomy for severe. Pre-splenectomy immunization critical. Post-splenectomy infection risk lifelong — counsel + prophylaxis + medical alert. Family screen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี chronic anemia + episodic jaundice + splenomegaly + gallstones (US) + family Hx (father had splenectomy, sister has spherocytosis)

V/S: BW 18 kg, mild scleral icterus, spleen palpable 4 cm BCM, no hepatomegaly

CBC: Hb 9.0, MCV 78, MCHC 38 (HIGH — diagnostic), retic 8%, increased RDW
Smear: spherocytes ++++ no central pallor, polychromasia
Coombs: NEGATIVE (excludes immune hemolysis)
Osmotic fragility increased; Eosin-5''-maleimide (EMA) flow cytometry: decreased fluorescence = HS
Indirect bilirubin elevated 4.5, LDH elevated, haptoglobin low';

update public.mcq_questions
set choices = '[{"label":"A","text":"Free water bolus"},{"label":"B","text":"Severe Symptomatic Hyponatremia from SIADH (post-craniopharyngioma surgery"},{"label":"C","text":"Diuretic alone"},{"label":"D","text":"Salt restriction"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Symptomatic Hyponatremia from SIADH (post-craniopharyngioma surgery — common in neurosurgical pediatrics from posterior pituitary disruption — can be SIADH or CSW or DI): SEIZURE/severe symptoms → administer 3% Hypertonic Saline 4-6 mL/kg IV over 10-20 min (raise Na ~5-6 mEq/L acutely to abort seizure); reassess + may repeat if seizure recurs; AVOID rapid correction (> 8-10 mEq/L per 24 hr → osmotic demyelination, central pontine myelinolysis) — TARGET correction 6-12 mEq/L first 24 hr then 6-8 mEq/L subsequent; FLUID RESTRICTION 50-75% of maintenance once stable (mainstay SIADH); identify cause — post-op CNS, pain, opiates, medications; treat underlying; differentiate SIADH vs CSW (cerebral salt wasting): SIADH = euvolemic + concentrated urine + low Na; CSW = hypovolemic + concentrated urine + low Na — treatment opposite (CSW needs salt + volume!); helpful — orthostatic BP, weight, FENa, JVP, hematocrit; if CSW → hypertonic saline + 3% saline maintenance + fludrocortisone if persistent; consider DDAVP-induced if recent DI episode + DDAVP given (triphasic response common post-surgery); monitor Na q1-2 hr during acute correction, q4-6 hr subsequent; neuro exam frequent; if too rapid correction occurs — REVERSE with D5W + DDAVP (if needed); endocrine + neurosurgery + nephrology coordinated

---

Post-neurosurgical pediatric hyponatremia = differential SIADH vs CSW vs DDAVP-induced — treatment opposite for SIADH (restrict) vs CSW (replenish salt + volume). Severe symptomatic → 3% saline carefully. Avoid overcorrection → ODS/CPM. Triphasic response possible. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี post-op craniopharyngioma resection 3 วันก่อน, ตอนนี้ confused + lethargic + headache + nausea + ชัก × 1 ครั้ง brief

V/S: BP 110/72, HR 92, BW 26 kg, no signs dehydration, weight gain 1.5 kg post-op

Lab: Na 116 (severe!), K 3.8, Cl 80, HCO3 24, BUN 6, Cr 0.5, glucose 92, osmolality serum 245 (LOW)
Urine: osmolality 380 (HIGHER than serum — inappropriately concentrated), urine Na 60 (HIGH for hyponatremia)
UO normal 1.2 mL/kg/hr; clinically euvolemic
TSH normal, cortisol normal (post-op on stress steroid)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Restrict fluid only"},{"label":"B","text":"Central Diabetes Insipidus (post-surgical, classic triphasic response"},{"label":"C","text":"Diuretic"},{"label":"D","text":"Limit fluid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Central Diabetes Insipidus (post-surgical, classic triphasic response — DI immediate then SIADH days 3-7 from cell death then permanent DI): Desmopressin (DDAVP) — synthetic vasopressin analogue — multiple routes; oral starting dose 50-100 mcg BID-TID titrate to effect (children typically PO or intranasal); intranasal 5-10 mcg q12h titrate; subcutaneous 0.05-0.1 mcg q12h-q24h in NPO/perioperative — most precise; ASSESS for triphasic response — initial DI may transition to SIADH (don''t continue DDAVP rigidly — risk hyponatremia + seizure!); MONITOR carefully — Na, fluid balance, weight, UO daily/q12h initially; allow patient access to fluid + free thirst response (most reliable indicator of need); AVOID — set DDAVP doses without monitoring; gradual increase; risk overcorrection → hyponatremia + seizure (worse if also restricted access to fluid); INSTRUCT — drink to thirst, avoid fixed water intake; family education + emergency plan; medical alert; combine with thyroid + cortisol + GH replacement if panhypopit; ophtho + neuro follow-up; transition adult endocrinology; consider partial deficit (no DI permanent, only transient — recheck 1-3 mo); psychosocial support school

---

Central DI = ADH deficiency. Post-pituitary surgery: triphasic response (DI → SIADH → permanent DI). DDAVP replacement + drink to thirst + careful monitoring. Combination panhypopituitarism replacements (cortisol, thyroid, GH, ADH). Education + medical alert.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 10 ปี craniopharyngioma s/p resection 3 wk now มาตรวจกับ endo polyuria 5-7 L/d + polydipsia preferring ice cold water + เริ่มขาดน้ำ

V/S: BW 28 kg, mild dehydration
Lab: Na 152 (high), Urine osm 100 (very dilute despite high serum osm), Serum osm 310 (HIGH)
Water deprivation test (cautious): no concentration with deprivation + Urine osm rises markedly (> 50% increase) after DDAVP = Central DI
MRI: post-op changes, no bright spot posterior pituitary';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Central Precocious Puberty idiopathic (CPP < 8 yr girls, < 9 yr boys, GnRH-dependent)"},{"label":"C","text":"Surgery"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Central Precocious Puberty idiopathic (CPP < 8 yr girls, < 9 yr boys, GnRH-dependent): treatment INDICATED in this child because of young age (< 7 yr girls), rapid progression, advanced bone age threatening adult height; GnRH agonist therapy — Leuprolide acetate IM 7.5 mg q1 mo OR Leuprolide depot 11.25-22.5 mg q3 mo OR Histrelin implant SC annual (60-mg implant) — suppress HPG axis + prevent further pubertal progression + preserve adult height; alternatives Triptorelin q1 mo or q3 mo; continue until 11-12 yr girls (after which pubertal progression appropriate); monitor — LH suppressed < 0.3 IU/L 60 min post-injection (or DHEAS for adrenal contribution), estradiol low, growth velocity slows, bone age progression slows; SIDE effects — local injection site, sterile abscess, headache, hot flushes minimal, possible psychological transient mood changes; AVOID — discontinuation without endocrine guidance; PSYCHOSOCIAL support — child + family (advanced physical development + social-emotional issues, body image, social interaction with older-looking peers); investigate for cause if signs concerning (cafe-au-lait → McCune-Albright, neuro findings → CNS lesion, virilization → adrenal/ovarian tumor); peripheral precocious puberty (PPP, GnRH-independent) = different mgmt (treat cause + sometimes letrozole/spironolactone — but this case CPP); long-term: adult height preserved, fertility preserved post-discontinuation, ongoing endocrine follow-up; communication with school

---

Central precocious puberty (CPP) < 8 girls, < 9 boys = GnRH-dependent. Treat with GnRH agonist (leuprolide, histrelin implant, triptorelin) to preserve adult height + delay social/emotional impact. Workup CNS (MRI mandatory), exclude PPP causes (McCune-Albright, tumors). Psychosocial support.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี 6 mo คุณแม่สังเกตว่าเริ่มมีเต้าโผล่ทั้ง 2 ข้าง + pubic hair sparse + อายุ 6 ปี advanced growth velocity (8 cm/yr last year)

V/S: BW 26 kg, height 130 cm (90th percentile, accelerating)
PE: Tanner stage breast 3 + pubic hair 2 + axillary 1, no virilization, no cafe-au-lait spots

Lab: LH basal 2.5 (pubertal range — pubertal LH > 0.3 IU/L), FSH 4, estradiol 35, GnRH stimulation test — LH peak 18 (pubertal); bone age 9 yr (advanced 2-3 yr); brain MRI: normal (no CNS lesion = idiopathic central precocious puberty)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Suspected Posterior Fossa Brain Tumor (likely medulloblastoma) + symptomatic obstructive hydrocephalus + increased ICP"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"LP first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Posterior Fossa Brain Tumor (likely medulloblastoma) + symptomatic obstructive hydrocephalus + increased ICP: admit + ICU; manage increased ICP — head of bed 30°, avoid hyponatremia, mannitol/3% saline if severe symptoms, dexamethasone 0.15-0.25 mg/kg/dose q6h IV (peritumoral edema reduction); neurosurgery URGENT — external ventricular drain (EVD) for hydrocephalus management OR endoscopic third ventriculostomy (ETV) as definitive surgery; staging — total spine MRI before resection (drop metastases CSF) + cytology lumbar CSF post-operative (with intracranial pressure normalized); SURGICAL RESECTION — maximal safe resection by experienced pediatric neurosurgeon; histology + molecular characterization — medulloblastoma WHO 4 subgroups (WNT, SHH, group 3, group 4) with different prognosis + therapy intensity; ADJUVANT THERAPY — craniospinal irradiation 23.4-36 Gy + posterior fossa boost (limited or omitted in young children < 3 yr to reduce neurocognitive sequelae) + chemotherapy (cisplatin, vincristine, cyclophosphamide, lomustine, etoposide per COG); MOLECULAR-guided treatment intensity — WNT subgroup excellent prognosis, can de-intensify; SHH variable; group 3/4 standard-intensive; LONG-TERM — neurocognitive deficits (XRT cerebellum + hippocampus), endocrinopathy (pan-hypopit), hearing loss (cisplatin), secondary malignancy, vasculopathy, growth, posterior fossa syndrome (mutism transient); MULTIDISCIPLINARY late effects clinic

---

Pediatric brain tumor = leading cause cancer death kids. Posterior fossa (medulloblastoma, ependymoma, JPA, brainstem glioma) most common. LP CONTRAINDICATED with mass effect. Steroid + neurosurg + complete staging spine + molecular characterization guide therapy. Long-term sequelae substantial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี ปวดศีรษะตอนเช้า 6 wk + อาเจียน projectile morning + diplopia + ataxia เดินไม่ตรง + papilledema OD/OS + 6th nerve palsy bilateral + neck stiffness mild

V/S: BP 132/82, HR 62, BW 24 kg
Gen: alert, no focal weakness, dysmetria + truncal ataxia, wide-based gait

MRI brain: posterior fossa midline mass 4 cm enhancing + obstructive hydrocephalus (4th ventricle compressed)
LP CONTRAINDICATED (mass effect)
Likely medulloblastoma (most common malignant peds brain tumor, posterior fossa, 5-9 yr)';

update public.mcq_questions
set choices = '[{"label":"A","text":"MRI brain first"},{"label":"B","text":"Multi-trauma pediatric polytrauma"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wait for MRI"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-trauma pediatric polytrauma — ATLS/PALS approach: AIRWAY priority (GCS ≤ 8 = intubate, c-spine immobilization throughout); rapid sequence intubation with c-spine inline stabilization, etomidate 0.3 mg/kg + rocuronium 1 mg/kg (avoid succinylcholine in significant head injury, hyperkalemia); BREATHING — bilateral chest sounds, end-tidal CO2, CXR (rule out PTX/HTX/PE), maintain SpO2 ≥ 94%; CIRCULATION — IV/IO × 2 large-bore, type + cross 10 mL/kg PRBC + crystalloid 20 mL/kg max (avoid over-resuscitation), MTP if exsanguinating (1:1:1 PRBC:FFP:platelet), TXA 15 mg/kg over 10 min then 2 mg/kg/hr (CRASH-3, pediatric extrapolation); control external bleeding + pelvic binder; DISABILITY — pupils + GCS, manage increased ICP (head of bed 30°, gentle hyperventilation transient bridge PaCO2 30-35, hypertonic saline 3% 3-5 mL/kg, mannitol option, target CPP > 40); EXPOSURE + environment — prevent hypothermia, log roll spine exam; FAST + bedside US; pan-CT (head + c-spine + chest + abdomen + pelvis) once stable enough; pediatric trauma center transfer if not already at; neurosurgery + general surgery + orthopedic surgery + pediatric ICU multidisciplinary; abdominal injury — splenic/liver lacerations → most managed non-operative if stable; pelvic fracture significant — bleed risk, may need IR/angiography; head injury — CT head, may need neurosurgery if mass lesion; transfusion goal Hb > 7 (10 if active bleed), Plt > 100 if neuro injury, INR < 1.5; tetanus prophylaxis; family liaison + chaplain; secondary survey systematic; reportable to trauma registry

---

Pediatric polytrauma = ABC primary survey + secondary survey + multidisciplinary trauma center. Pediatric differences: relatively larger head, smaller airway, kids compensate then crash, c-spine, occult internal bleeding. TXA for major hemorrhage. Non-operative for stable splenic/liver. Avoid over-fluid (worsens coagulopathy).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี BW 22 kg มี motor vehicle accident — passenger seat unbelted, ejected, found unresponsive at scene 30 นาทีก่อน EMS GCS 6 ขณะนำส่ง; arrival ED ตอนนี้ continued unresponsive

V/S arrival: HR 132, BP 76/40, RR irregular shallow, SpO2 84% room air
Gen: GCS 6 (E1V1M4), unequal pupils R 5 mm sluggish/L 3 mm reactive, no obvious external bleeding, scalp hematoma left occipital, abdomen tender RUQ + LUQ, deformity left thigh + pelvis tender

FAST exam: free fluid RUQ + LUQ; pelvic XR: pelvic fracture; CXR: pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"CT brain mandatory all head injury"},{"label":"B","text":"Minor head trauma in young child"},{"label":"C","text":"Discharge no instruction"},{"label":"D","text":"MRI immediately"},{"label":"E","text":"Skull XR"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Minor head trauma in young child — apply PECARN Pediatric Head Injury Rule (< 2 yr separate criteria, 2-18 yr criteria): age 3 yr (criteria for 2-18 yr) — assess PECARN risk factors: 1) altered mental status (GCS < 15, agitation, somnolence, repetitive questioning, slow response) — NO here, 2) loss of consciousness — NO, 3) vomiting — NO, 4) severe mechanism (MVC ejected, death, rollover; pedestrian/cyclist without helmet struck; fall > 5 ft/1.5 m for > 2 yr; head struck by high-impact object) — fall 1.2 m is below threshold = NO, 5) signs basilar skull fracture — NO, 6) severe headache — NO; ALL PECARN criteria NEGATIVE = very low risk (< 0.05% ciTBI) → recommend observation only, NO CT indicated; explain to family — observe at home × 24-48 hr with return precautions (worsening headache, repeated vomiting, AMS, focal deficit, seizure, irritability not improved, fluid from nose/ear, gait abnormality); injury prevention counseling — safety practices feeding chair, supervision, helmets/seatbelts, fall prevention; consider age + parental concern + injury mechanism + clinician experience in shared decision-making; if observation in ED 4-6 hr selected scenarios; head injury results in concussion → return to learn + play progression

---

PECARN HIR (Kuppermann Lancet 2009) reduces CT use in low-risk pediatric head injury (radiation exposure concern). Risk stratification: very low (no factors) = observe; intermediate (1+ factors) = observe/clinician judgment; high-risk = CT. Family education + return precautions. Shared decision-making.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 3 ปี ตกจากที่นั่งกินข้าว 1.2 เมตร ลงพื้น 30 นาทีก่อน — ไม่ตักหรือสลบ ร้องไห้ทันที พ่อแม่บอก ตอนนี้ alert + ตื่นปกติ + ไม่อาเจียน + ไม่ปวดศีรษะ + ไม่ชัก

V/S: HR 102, BP 96/62, Temp ปกติ, BW 14 kg
Gen: alert + playful + no distress, GCS 15
PE: scalp hematoma small frontal (parietal), no obvious skull deformity, no Battle/raccoon sign, no hemotympanum, no CSF leak, no neuro deficit, normal exam อื่น

No Hx coagulopathy, no medication, no bleeding disorder';

update public.mcq_questions
set choices = '[{"label":"A","text":"Return to play 24 hr after injury"},{"label":"B","text":"Sport-Related Concussion"},{"label":"C","text":"Wait 1 year"},{"label":"D","text":"MRI all concussions"},{"label":"E","text":"Discharge no education"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sport-Related Concussion — physical + cognitive rest first 24-48 hr then gradual return (CISG/Berlin 2017 + Amsterdam 2022 Consensus): SYMPTOMATIC initially — relative rest 24-48 hr (no school, no athletics, limit screens) then GRADUATED return as symptoms improve, NOT complete rest beyond 48 hr (recent evidence: prolonged rest = worse outcomes); RETURN-TO-LEARN progression — light cognitive activity at home → return school with accommodations (extended time, reduced workload, breaks, no exams, quieter environment) → full school no accommodation → required before return to play; RETURN-TO-PLAY 6-step graduated progression — each step ≥ 24 hr, advance only if symptom-free: 1) symptom-limited activity, 2) light aerobic exercise (walking, stationary bike), 3) sport-specific exercise (running, drills no contact), 4) non-contact training drills (passing, more complex), 5) full contact practice (medical clearance required), 6) return to play; if symptoms recur at any step → drop back one step ≥ 24 hr; medical clearance by trained provider before contact; AVOID — opioids, NSAIDs early (recent concern); manage symptoms — acetaminophen, sleep hygiene, vestibular therapy for dizziness, cervical therapy for neck, neuropsychology assessment for prolonged; SECOND IMPACT SYNDROME — return to contact play before recovery = catastrophic risk, especially adolescent; persistent symptoms > 4 wk = post-concussion syndrome, multidisciplinary team referral; education prevention — helmet, rule changes, safer technique; school + sport responsibility; long-term: most resolve within 1-4 wk pediatric; CTE concern for repetitive head impact long-term

---

Concussion = brain trauma symptom-based diagnosis. Berlin/Amsterdam consensus: brief rest 24-48 hr then gradual return-to-learn + return-to-play 6-step protocol. Second impact syndrome = preventable catastrophic complication especially adolescent. Pediatric recovery typically 1-4 wk. Education + helmet + rule changes.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 14 ปี football เล่นบอลตี + กระทบศีรษะ 5 วันก่อน — short LOC 30 sec + headache, photophobia, dizziness, sleep disturbance, irritability, concentration ลดลง 5 วันแล้ว; ตอนนี้ symptoms มี mild headache + ความเข้มข้นยังไม่ปกติเต็มที่ + tolerating school accommodation

No seizure, no focal deficit, no skull fracture, no LOC > 30 sec, normal exam current; CT brain ที่ ED วันแรก: normal
No h/o multiple concussion
Family wants to know about return to play';

update public.mcq_questions
set choices = '[{"label":"A","text":"Remove collar immediately without further evaluation"},{"label":"B","text":"Pediatric Cervical Spine clearance (different rules than adult"},{"label":"C","text":"Wait 1 week"},{"label":"D","text":"MRI without XR"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cervical Spine clearance (different rules than adult — NEXUS less validated, PECARN cervical spine recently): pediatric c-spine clearance criteria + approach: 1) high-risk mechanism + clinical factors (altered mental status, focal neuro deficit, midline cervical tenderness, distracting injury, intoxication, age < 3 + difficult to examine) = imaging; 2) without high-risk → clinical clearance — patient awake + alert + no neuro deficit + no tenderness + ROM intact without pain + able to communicate; THIS PATIENT — has midline tenderness → IMAGING indicated; FIRST imaging — lateral cervical XR (lateral, AP, odontoid if cooperative ≥ 5 yr) — assess prevertebral space, alignment (anterior + posterior longitudinal, spinolaminar, posterior spinous), pseudosubluxation C2-3 normal up to age 8 (50% have); if XR equivocal/abnormal OR high-risk mechanism → CT cervical spine (better bony detail than XR but radiation); if neuro deficit OR persistent symptoms with normal CT → MRI (ligamentous, cord, dynamic); MAINTAIN c-collar until cleared (immobilization continues); KIDS — relatively larger head + ligamentous laxity → SCIWORA (spinal cord injury without radiographic abnormality) possible especially < 8 yr — high index suspicion; if neuro symptoms despite normal imaging → MRI; pediatric trauma center + neurosurgery if instability or neuro injury; family + child education; long-term — outcome depends on injury severity

---

Pediatric c-spine clearance differs from adult (relatively larger head, ligamentous laxity, SCIWORA risk). Tenderness or high-risk = image. Lateral XR first; CT if equivocal; MRI for cord/ligamentous/SCIWORA. Pseudosubluxation C2-3 normal up to age 8. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี BW 26 kg crash bicycle into pole ขณะวันก่อน — no LOC, complains neck pain mild + headache; in c-collar in ED

V/S: GCS 15, normal neurologic exam, no extremity weakness, no sensory deficit, normal reflexes
PE: alert + conversant + cooperative; midline cervical tenderness mild at C5 area, no distracting injuries elsewhere, no obvious deformity, no signs intoxication
No paresthesia, no torticollis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Severe restriction + isolation"},{"label":"B","text":"Peanut Allergy long-term management + emerging therapies"},{"label":"C","text":"No further intervention"},{"label":"D","text":"Skin test only"},{"label":"E","text":"Steroid daily"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peanut Allergy long-term management + emerging therapies: EMERGENCY ACTION PLAN (written, share school + caregivers + family) — recognize anaphylaxis (mucous membranes/skin + respiratory or GI or hypotension), immediate EpiPen Jr 0.15 mg IM thigh (< 25 kg) → repeat in 5-15 min if no improvement → call EMS → transport to ED; education — antigens, reading labels (FALCPA US, EU mandatory labeling), cross-contamination prevention, restaurant communication, travel; STRICT AVOIDANCE remains cornerstone but allergen avoidance alone — high accidental exposure rate; pediatric ALLERGIST referral — confirm with skin prick test + serum IgE + supervised oral food challenge (gold standard); EARLY ORAL IMMUNOTHERAPY (OIT) — landmark LEAP study (Du Toit NEJM 2015): early introduction of peanut at 4-11 mo in high-risk infants (severe eczema, egg allergy) REDUCES peanut allergy by 80% at age 5 — current AAP/NIAID guideline endorses early introduction; FDA-APPROVED peanut OIT — Palforzia (peanut allergen powder), age 4-17 yr — gradual escalation reduces severity of accidental ingestion (not cure, daily maintenance dose lifelong, anaphylaxis can still occur during therapy — requires trained allergist); Omalizumab (anti-IgE) — recent FDA approval 2024 for food allergy adjunct; SUBLINGUAL IMMUNOTHERAPY + epicutaneous (Viaskin patch) — less robust, alternatives; medical alert bracelet; school 504 plan; mental health — anxiety common families; cross-reactivity (other tree nuts, legumes) — assess individually; revaccinate yearly anaphylaxis EpiPen training; future: monoclonal antibodies, gene therapy emerging

---

Food allergy = chronic disease. EpiPen + emergency plan + strict avoidance + education foundational. LEAP study revolutionized — EARLY introduction peanut in high-risk infants reduces allergy 80%. OIT (Palforzia FDA-approved) + omalizumab adjunctive for desensitization. Long-term allergist follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี Hx anaphylaxis ต่อ ถั่วลิสง 6 mo ก่อน (Epi pen ใช้ — fine) ตอนนี้ asymptomatic เพื่อ counseling + management plan; family asks about prevention + management + new therapy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid systemic chronic"},{"label":"B","text":"Atopic Dermatitis (Eczema) moderate, classic atopic march"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Avoid all bathing"},{"label":"E","text":"Discharge no education"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Atopic Dermatitis (Eczema) moderate, classic atopic march: EDUCATION + family — chronic relapsing disease, manage rather than cure; SKIN HYDRATION — daily lukewarm bath 10-15 min + immediately apply moisturizer (fragrance-free emollient) within 3 min (soak + seal), thick ointment (petroleum-based) preferred over lotion; bath additive (mild non-soap cleanser like Cetaphil, mild oat); TOPICAL CORTICOSTEROID — first-line antiinflammatory — low-potency (hydrocortisone 1-2.5%) for face/groin, mid-potency (triamcinolone 0.1%) for body, intermittent use 1-2× daily × 7-14 d for flares; PROACTIVE therapy — twice weekly steroid (or tacrolimus) to high-risk areas during quiescent phase reduces flares; TOPICAL CALCINEURIN INHIBITOR — tacrolimus 0.03% (≥ 2 yr) or pimecrolimus 1% — steroid-sparing, safe for face + thin skin; identify + avoid triggers — heat, sweat, harsh detergent, fragrance, wool; treat super-infection — bacterial (Staph 80%) → mupirocin topical or oral cephalexin/clindamycin if widespread, viral eczema herpeticum → URGENT acyclovir + ophtho consult if periocular; ANTIHISTAMINE for pruritus mostly sedating for sleep (hydroxyzine, diphenhydramine HS); bleach bath 2-3×/wk for recurrent infection; new — TOPICAL crisaborole (PDE4 inhibitor), Ruxolitinib (JAK inhibitor topical) for older kids; BIOLOGIC — Dupilumab (anti-IL4Rα) ≥ 6 mo FDA-approved for moderate-severe; Tralokinumab, Lebrikizumab emerging; food allergy + asthma + rhinitis comorbid — allergist + atopic march counseling; psychosocial impact + sleep affected

---

AD = chronic relapsing, atopic march common. Skin hydration + emollient + topical steroid first-line. Tacrolimus alternative thin skin/face. Proactive maintenance for flares prevention. Bleach bath for recurrent infection. Dupilumab biologic moderate-severe ≥ 6 mo. Family-centered education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกอายุ 8 mo BW 8.2 kg มีผื่นแห้งคัน เริ่มที่หน้า + แก้ม 4 mo + ลามไป arms + legs + flexure (popliteal + antecubital) + ดูเหลืองอ่อน scratch marks, ตื่นกลางคืนคันรบกวน sleep; ครอบครัว atopic — แม่ asthma + sister AR

PE: erythematous + scaly + lichenified plaques flexor surfaces, no infection (no honey-crusted, no fluctuance, no pustule)
No wheeze, growth normal; SCORAD moderate';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antihistamine + steroid alone"},{"label":"B","text":"Hereditary Angioedema (HAE) Acute Attack"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Angioedema (HAE) Acute Attack — C1-INH deficiency, NOT histamine-mediated (no urticaria, no response to standard anaphylaxis treatment): EMERGENCY targeted therapy — C1-INH concentrate (Berinert) IV 20 U/kg (most evidence + first-line acute), OR Ecallantide (kallikrein inhibitor) SC 30 mg in 3 sites, OR Icatibant (bradykinin B2 receptor antagonist) SC 30 mg single dose (self-administer at home) — all FDA-approved acute attacks pediatric; AVOID — antihistamine, steroid, epinephrine (less effective HAE, but EPI can still help if respiratory distress + uncertainty); fresh frozen plasma alternative if specific therapy unavailable (contains C1-INH, can paradoxically worsen by providing substrate); supportive — airway monitoring (LARYNGEAL EDEMA can be fatal — early intubation if signs progression), IV fluid for abdominal attacks (third-spacing), analgesia, antiemetic; admission for laryngeal attacks; PROPHYLAXIS — long-term (≥ 1-2 attacks/mo or severe) — Lanadelumab (anti-kallikrein mAb SC q2 wk, age ≥ 2), Berotralstat (oral kallikrein inhibitor, ≥ 12 yr), C1-INH SC (Haegarda) twice weekly, attenuated androgens (danazol — limited in children due growth/virilization side effects); short-term prophylaxis before procedures (dental, surgery, intubation) — C1-INH 20 U/kg or FFP; AVOID precipitants (estrogen, ACEI, trauma); on-demand therapy patients should have self-administered kit + emergency plan; allergist + immunologist follow-up; education family + medical alert + genetic counseling (autosomal dominant — screen relatives)

---

HAE = bradykinin-mediated, NOT histamine. C1-INH deficiency (or function). Acute: C1-INH concentrate, icatibant, ecallantide. Standard anaphylaxis Rx ineffective. Laryngeal edema can be fatal. Long-term prophylaxis (lanadelumab, berotralstat). Genetic + family screen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 10 ปี ครอบครัว Hx swelling — แม่ + ลุง + พี่ มี attacks intermittent swelling face, hands, feet, abdomen WITHOUT urticaria — ลูกสาวมาตอนนี้ episode 3 — facial + lip swelling + abdominal pain colicky + อาเจียน + ปวดเริ่ม 6 ชม

V/S: HR 102, BP 102/68, no respiratory distress (no laryngeal edema currently), BW 32 kg
PE: significant lip + facial swelling, abdominal tender no peritonitis, no hives, no pruritus, no airway compromise yet

Lab: C4 LOW, C1-INH antigenic LOW, C1-INH functional LOW = HAE type 1
Tryptase normal (excludes mast cell)
Not responding to antihistamine + steroid (prior episodes)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic short course oral"},{"label":"B","text":"Early disseminated Lyme disease with cardiac involvement (AV block) + arthritis"},{"label":"C","text":"Wait — outgrow"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Steroid alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early disseminated Lyme disease with cardiac involvement (AV block) + arthritis: hospital admission for cardiac monitoring (AV block — may need temporary pacing if symptomatic complete heart block); IV ceftriaxone 50-75 mg/kg/d (max 2 g/d) × 14-21 days for cardiac OR neuro involvement (vs oral for skin/arthritis only); alternative IV penicillin G or cefuroxime; FOR cutaneous + arthritis without cardiac/neuro — oral DOXYCYCLINE 4.4 mg/kg/d ÷ q12h × 10-14 d (now recommended ALL AGES per IDSA 2020 — historically reserved > 8 yr due tooth staining, recent evidence safe < 8 yr for short courses); amoxicillin 50 mg/kg/d alternative all ages; cefuroxime alt; treat ARTHRITIS (Lyme arthritis) — oral doxycycline × 28 d → if persistent → IV ceftriaxone OR oral course again; reassess + repeat ECG; cardiac complications usually resolve with antibiotic but may need temporary pacing; FACIAL PALSY common — oral antibiotic, resolves with time; education + tick prevention (DEET, permethrin, long sleeves, tick checks); vaccine in development (VLA15); reportable; counsel family — Post-Treatment Lyme Disease Syndrome (controversial — fatigue/cognitive symptoms persisting); not contagious person-person

---

Lyme disease = Borrelia burgdorferi via Ixodes tick (US Northeast/upper Midwest, parts of Europe). Stages: early local (EM), early disseminated (multiple EM, neurological — facial palsy, meningitis; cardiac — AV block), late (arthritis). Doxycycline all ages per IDSA 2020. IV ceftriaxone for cardiac/neuro. Tick prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี เพิ่งกลับจาก camping ไป East Coast US 3 wk ก่อน บ้าน outdoor 4 wk ก่อนเจอ tick attached arm × หลายชั่วโมง — เพิ่งเห็น 2 wk ก่อนมี expanding circular target-like rash 12 cm diameter inner clearing ที่แขนเดิม + ไข้ต่ำ + ปวดข้อ + headache + arthralgia — ใจเต้น ไม่สม่ำเสมอ

V/S: HR irregular 65 (sinus brady) ECG → second-degree AV block Mobitz I, BW 26 kg
PE: erythema migrans target rash 12 cm right arm, mild knee effusion bilateral, no facial palsy currently

Lab: Lyme ELISA + Western blot — IgM + + IgG +; CBC normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid + antibiotic"},{"label":"B","text":"Severe Dengue with Dengue Shock Syndrome (critical phase, defervescence + plasma leak)"},{"label":"C","text":"Diuretic in shock phase"},{"label":"D","text":"Restrict fluid in shock"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Dengue with Dengue Shock Syndrome (critical phase, defervescence + plasma leak) — WHO 2009 criteria: ICU admission + cardiovascular monitoring; CRYSTALLOID resuscitation — Ringer''s lactate or NSS 10 mL/kg IV bolus over 10-15 min (more aggressive faster than usual peds shock — 20 mL/kg may worsen plasma leak); reassess after each bolus (HR, BP, PP, cap refill, Hct, UO); if not improved → repeat 10-20 mL/kg over 10-30 min × 1-2 more; if still not improving → consider COLLOID (5% albumin or dextran 6% — pediatric data limited but used in dengue) 10-20 mL/kg; minimize fluid duration (24-48 hr critical phase, then reabsorption pulmonary edema risk) — taper carefully when stable + Hct dropping; avoid over-resuscitation in recovery phase (fluid overload + pulmonary edema common cause death — RAPID withdrawal as stable!); monitor Hct (rise = leak, fall = bleed or recovery), platelet (transfuse only if active bleed not for prophylaxis); supportive — paracetamol (AVOID NSAID + aspirin → bleeding risk), antiemetic; AVOID corticosteroid, immunoglobulin (no evidence); transfuse PRBC for severe bleeding + Hct fall; if hemorrhage suspected → control source; monitor LFTs + AKI; ICU duration 24-48 hr critical phase then convalescent; PREVENTION — vector control (Aedes aegypti — water containers), repellent, long sleeves, screens, vaccine: Dengvaxia (only seropositive prior), Qdenga newer (≥ 4-16 yr, regardless serostatus pre-approved); secondary infection with different serotype = increased severity (ADE — antibody-dependent enhancement); reportable disease

---

Severe dengue — critical phase at defervescence (48 hr plasma leak window). Cautious crystalloid resuscitation (less + faster), reassess Hct/HR/BP, taper rapidly during recovery (fluid overload kills). NO aspirin/NSAID/steroid. Vector control + vaccines (Qdenga newer). Reportable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 9 ปี BW 28 kg อยู่ Bangkok ไข้สูง 4 วันก่อน + ปวดศีรษะ + ปวดเมื่อย + ปวดเบ้าตา + ผื่นแดง + เลือดออกตามไรฟัน + ตอนนี้วันที่ 5 ของไข้ ไข้ลดแล้วแต่กลับเหนื่อยมาก ปวดท้องรุนแรง + อาเจียน + extremities เย็น + capillary refill ช้า

V/S: HR 132, BP 96/82 (narrow PP 14 mmHg — SHOCK), RR 32, SpO2 96%, Temp 37.0°C (defervescence)
Gen: lethargic + restless, cold extremities, hepatomegaly 4 cm, petechiae multiple, no obvious bleeding

Lab: Hct 50 (rising from 38 — hemoconcentration), Plt 28,000, AST 320, ALT 280, albumin 2.8
NS1 antigen + + IgM +; tourniquet test positive
Dengue Severe (DSS — Dengue Shock Syndrome)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ceftriaxone alone"},{"label":"B","text":"Neonatal Bacterial Meningitis (< 1 mo"},{"label":"C","text":"Antiviral alone"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Bacterial Meningitis (< 1 mo — different empiric coverage than older children): empiric IV antibiotic IMMEDIATELY (within 1 hr) — Ampicillin 75-100 mg/kg/dose q6h IV (covers Listeria + Enterococcus + susceptible GBS) + Gentamicin 4 mg/kg/dose q24h IV (synergy + gram-negative GBS, E. coli, etc.) + Cefotaxime 50-75 mg/kg/dose q6-8h IV (NOT ceftriaxone in newborns < 28 d due to bilirubin displacement + biliary sludging) — triple therapy covers GBS, E. coli, Listeria, enterococci, gram-negatives; ADD ACYCLOVIR 20 mg/kg/dose q8h IV (60 mg/kg/d) if HSV not excluded — newborns at high risk for HSV encephalitis/disseminated (CSF mononuclear pleocytosis, vesicles, seizure, transaminitis — but classic features may be absent — treat empirically until HSV PCR negative + clinical improvement, usually < 21 d); DEXAMETHASONE NOT routinely recommended in neonates (limited evidence + concerns); duration — GBS meningitis 14-21 d, E. coli meningitis 21 d, Listeria meningitis 21 d (longer than older kids); SUPPORTIVE — fluid + electrolytes, glucose, seizure management (load levetiracetam or phenobarbital); ICU monitoring + airway; SEPSIS workup including blood + urine + LP — done; serial neuro exam + imaging (brain MRI eventually for parenchymal involvement, infarct, abscess, hydrocephalus); audiology + ophtho follow-up (hearing loss common); developmental follow-up; family education; isolation if HSV — contact + standard

---

Neonatal meningitis < 28 d = different empiric (ampicillin + cefotaxime/gentamicin) — covers Listeria + GBS + gram-negative. NO ceftriaxone < 28 d (bilirubin displacement). ADD acyclovir until HSV excluded. Longer duration. Long-term sequelae high (hearing, neurological). Sepsis workup mandatory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 18 วัน BW 3,400 g มา ED ด้วย ไข้ 38.4°C + irritability + poor feeding + lethargy 12 ชม — vaccine ยังไม่ได้

V/S: HR 178, RR 62, Temp 38.4°C, SpO2 96%
Gen: lethargic, full bulging anterior fontanelle, neck supple (newborns may not), no rash, mottled

Lab: CBC WBC 26,000 (left shift), CRP 95, glucose 75; UA negative
LP: WBC 1,580 (PMN 92%), Protein 285, Glucose 18, Gram stain: gram-positive coccobacilli in chains = Listeria suspicious OR GBS
Blood culture pending; HSV PCR sent';

update public.mcq_questions
set choices = '[{"label":"A","text":"Curative gene therapy now standard"},{"label":"B","text":"Tay-Sachs Disease (infantile form, HEXA gene, autosomal recessive"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic prophylaxis only"},{"label":"E","text":"Discharge home no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tay-Sachs Disease (infantile form, HEXA gene, autosomal recessive — Ashkenazi Jewish 1:27 carrier) — NO curative treatment available: SUPPORTIVE PALLIATIVE care multidisciplinary team — pediatric neurology + genetics + palliative care + family support; SEIZURE management (anticonvulsants — levetiracetam, valproate, often refractory); FEEDING support — G-tube as bulbar function deteriorates; RESPIRATORY support — aspiration precautions, suctioning, oxygen, ventilation per family wishes; PAIN + comfort care — opioids, benzodiazepines; PHYSICAL therapy + positioning; AGGRESSIVE management of infections (frequent pneumonia from aspiration); NUTRITIONAL support — high-calorie, gastrostomy; SLEEP support — clonazepam/melatonin; FAMILY counseling — fatal disease (typical death 2-5 yr), grief support, hospice consideration, sibling support, decision-making around invasive intervention + DNR; GENETIC counseling — autosomal recessive 25% risk each pregnancy, carrier screening Ashkenazi Jewish standard + other ethnicities at risk, preimplantation diagnosis available, prenatal diagnosis via CVS or amnio; CARRIER SCREENING — Ashkenazi Jewish, French Canadian, Cajun Louisiana, Pennsylvania Dutch — recommended pre-conception; INVESTIGATIONAL — substrate reduction therapy (miglustat), enzyme replacement (limited brain penetration), gene therapy clinical trials in progress (AAV-based); biomarker tracking; transition to adult/hospice if family decides; respite care; reproductive planning for parents

---

Tay-Sachs = HEXA deficiency → GM2 accumulation. Infantile fatal, no cure. Carrier screening (Ashkenazi Jewish 1:27) preconception standard. Supportive palliative + family + genetic counseling. Cherry-red spot pathognomonic. Gene therapy trials ongoing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 8 mo ครอบครัว Ashkenazi Jewish, ก่อนหน้านี้ปกติ ตอนนี้ developmental regression — เคย smile + roll over + sit เริ่มสูญเสีย skills, abnormal startle + exaggerated to noise (hyperacusis), hypotonia developing

PE: cherry-red spot on macula bilateral (pathognomonic), hypotonia, decreased response to environment
Family: cousin similar condition died age 4

Enzyme: hexosaminidase A activity DEFICIENT in leukocytes — GM2 gangliosidosis (Tay-Sachs)
MRI: developing white matter changes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Suspected Urea Cycle Defect / Hyperammonemic Crisis (newborn unexplained metabolic crisis post-protein loading + high NH3 + cousin Hx = pattern)"},{"label":"C","text":"Continue regular feeding"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Urea Cycle Defect / Hyperammonemic Crisis (newborn unexplained metabolic crisis post-protein loading + high NH3 + cousin Hx = pattern): EMERGENCY pediatric metabolic specialist + ICU; ammonia > 500 = severe → DIALYSIS/CRRT (more rapid than HD) — most effective immediate intervention to clear ammonia; STOP all protein intake immediately (NPO); IV dextrose 10% at high rate to reverse catabolism + provide non-protein calories — GIR 10-15 mg/kg/min (caution glucose > 200 may exacerbate); IV insulin if hyperglycemia + ongoing catabolism (suppresses catabolism); IV lipid 1-2 g/kg/d (non-protein calorie); NITROGEN-SCAVENGING DRUGS — Sodium benzoate + Sodium phenylacetate (Ammonul) IV loading 250 mg/kg over 90 min then 250-500 mg/kg/d infusion — converts ammonia/glycine to hippurate + phenylacetyl-glutamine → renal excretion; alternatively glycerol phenylbutyrate (Ravicti); CARBAGLU (carglumic acid) for NAGS deficiency or propionic acidemia; ARGININE IV 600 mg/kg load then 200-300 mg/kg/d infusion (for urea cycle defects providing intermediates, exception in argininase deficiency); NEUROPROTECTION — manage seizure (levetiracetam preferred not metabolized via affected pathway, AVOID valproate in mitochondrial/urea cycle), ICP management, avoid hyperthermia; gradual reintroduction of protein after ammonia normalized < 80-100 — special metabolic formula; investigations — urine organic acids, plasma amino acids, plasma acylcarnitine, lactate, blood gas, urine orotic acid (helps subtype urea cycle); long-term: protein-restricted diet, supplements, monitor growth + cognitive, liver transplant considered for severe urea cycle defects with recurrent crisis (curative); family genetic counseling + screening + carrier testing + prenatal/preimplantation

---

Newborn metabolic crisis = differential urea cycle defect, organic acidemia, fatty acid oxidation, MSUD, others. High NH3 + post-protein onset + family Hx = urea cycle suspicion. EMERGENCY — STOP protein + dextrose + nitrogen scavengers + dialysis if severe. Hyperammonemia → permanent neurological damage if untreated. Specialist + genetic counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 5 วัน term BW 3,200 g, ดูปกติแรกคลอด หลัง feeding nasogastric protein-rich formula 2 วันที่ผ่านมา เริ่ม poor feeding + lethargy + recurrent vomiting → unresponsive + opisthotonus + tonic clonic seizure

V/S: HR 178, BP 60/40, RR 62 (Kussmaul-like), Temp 36.4°C
Lab: glucose 65, NH3 850 (very high!), pH 7.30, AG 18 (normal-mildly high), Na 138, K 3.8, urine ketone +
No sepsis features, CRP normal, CBC normal
Urine organic acids — pending; plasma amino acids — pending; acylcarnitine profile — pending
Family: cousin died unexplained newborn';

update public.mcq_questions
set choices = '[{"label":"A","text":"Folic acid only"},{"label":"B","text":"Aplastic Crisis (Parvovirus B19) in Hereditary Spherocytosis"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aplastic Crisis (Parvovirus B19) in Hereditary Spherocytosis: PRBC TRANSFUSION urgently — 10-15 mL/kg leukoreduced PRBC over 3-4 hr (recheck Hb post-transfusion target Hb 8-10 g/dL minimum, then transfuse periodically until reticulocyte recovery typically 7-14 days as bone marrow recovers from parvovirus B19 transient suppression); cardiac monitoring during transfusion + diuretic if symptomatic CHF; consider IV folate + supportive; ISOLATION — contact precautions (parvovirus B19 transmissible) + protect immunocompromised + pregnant women + others with hemolytic anemia (cross-infection risk in family/school); investigate household for similar conditions at risk; monitor — daily CBC + reticulocyte until reticulocyte > 1% sign recovery; counsel family — aplastic crisis self-limited 1-2 wk in immunocompetent (B19 transient suppression of erythroid precursors); follow-up — chronic management of HS + family screen + future planning splenectomy after age 6+ if not already done; vaccinate pneumococcal/meningococcal/Hib before splenectomy; long-term: most full recovery, but rare progress to chronic infection in immunocompromised → IVIG treatment; education families with chronic hemolytic anemia about parvovirus risks + close monitoring during outbreak

---

Aplastic crisis from Parvovirus B19 in HS or other chronic hemolytic anemia = transient red cell aplasia 1-2 wk. Sudden severe drop + reticulocytopenia = key feature. Transfusion supports until marrow recovers. Isolation (transmissible). Family counsel + pregnant + immunocompromised contacts.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี known hereditary spherocytosis ตอนนี้มา ED ด้วย sudden weakness + pallor + ปวดหัว + tachycardia 2 วัน ก่อนได้รับ parvovirus B19 exposure ที่ school (fifth disease ระบาด)

V/S: HR 152, BP 90/56, RR 28, SpO2 98%, BW 24 kg
PE: severe pallor, mild scleral icterus, splenomegaly 4 cm (baseline), no jaundice severe

Lab: Hb 3.8 (baseline 9.2 — DROP!), MCV 80, retic 0.2% (very LOW — APLASTIC), Plt + WBC normal
Indirect bilirubin slightly elevated, LDH not elevated significantly
Parvovirus B19 PCR + ; smear: spherocytes present, no schistocytes, scarce reticulocytes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Rapid normalization of BP to normal in 1 hr"},{"label":"B","text":"Pediatric Hypertensive Emergency with end-organ damage (encephalopathy, seizure, PRES)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertensive Emergency with end-organ damage (encephalopathy, seizure, PRES): ICU admission + continuous BP monitoring (preferably arterial line for accurate q minute monitoring); SLOW + CONTROLLED reduction — reduce 25% of planned reduction over FIRST 8 HOURS (NOT < 25% in first 1 hr to avoid hypoperfusion stroke/ischemic injury), additional 25% over next 8 hr, normal range over 24-48 hr total; first-line IV — Labetalol IV bolus 0.2-1 mg/kg q5-10 min titrate (max 40 mg/dose) OR continuous infusion 0.25-3 mg/kg/hr (avoid in asthma, CHF); OR Nicardipine continuous infusion 0.5-3 mcg/kg/min titrate (avoid in liver dysfunction); OR Sodium nitroprusside infusion 0.3-8 mcg/kg/min (caution cyanide toxicity in renal failure, light-protected) — use if refractory; OR Esmolol short-acting beta-blocker; AVOID sublingual nifedipine + IV hydralazine (less predictable + cause hypotension); manage SEIZURE — benzodiazepines, levetiracetam load; identify + treat underlying cause — CKD, renal artery stenosis (consider MRA renal), pheochromocytoma + neuroblastoma (screen catecholamines + imaging adrenal/sympathetic chain), drug-induced (cocaine/amphetamine, sympathomimetic, OCP), coarctation re-check, glomerulonephritis, endocrine; once BP controlled IV → transition oral antihypertensives — ACEI/ARB (if CKD + proteinuria), CCB, diuretic, beta-blocker per patient comorbid; AVOID — fluid overload, abrupt BP changes; recheck end organ — ophtho + neurology + cardiology + nephrology; long-term — outpatient BP target, address comorbid risk, growth + development monitoring, schooling, transition adult; PRES typically reverses with BP control + supportive (DAYS-WEEKS)

---

Pediatric HT emergency = BP severely elevated + end-organ damage (encephalopathy, retinopathy, AKI, HF, dissection). Lower BP gradually (25% planned in first 8 hr) — avoid hypoperfusion injury. IV labetalol/nicardipine/SNP first-line. PRES reversible with BP control. Investigate cause + long-term oral antihypertensive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 9 ปี known chronic kidney disease (CKD stage 3 จาก reflux nephropathy) ตอนนี้มา ED ปวดศีรษะรุนแรง + ตามัว + อาเจียน + ชัก × 1 ครั้ง brief

V/S: BP 195/132 (severely elevated, > 99th percentile + symptoms = hypertensive EMERGENCY), HR 102, RR 24, SpO2 99%, BW 28 kg
Gen: post-ictal currently, recovering; papilledema bilateral OD/OS, no focal deficit; clinically euvolemic

Lab: Cr 2.4 (baseline 1.6), K 4.8, glucose 102, no acute MI/CHF; UA proteinuria 2+, normal RBC
CT brain: no hemorrhage; consistent with PRES (posterior reversible encephalopathy syndrome) — MRI later';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discourage discussion of weight"},{"label":"B","text":"Severe Pediatric Obesity with comorbidities (T2DM-risk, OSA, NAFLD, HT)"},{"label":"C","text":"Surgery age 6"},{"label":"D","text":"Restrict all calories severely"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Pediatric Obesity with comorbidities (T2DM-risk, OSA, NAFLD, HT) — AAP 2023 Clinical Practice Guideline: comprehensive evidence-based management at any age (no longer ''watchful waiting''); INTENSIVE HEALTH BEHAVIOR + LIFESTYLE TREATMENT (IHBLT) — ≥ 26 contact hours over 3-12 mo, multidisciplinary (clinician + dietitian + behavioral + exercise + social + family) — first-line for ALL ages ≥ 6 yr + offered ≥ 2 yr; address dietary patterns (reduce SSB + ultraprocessed + portion control + family meals + Mediterranean-style + caloric awareness rather than restriction); physical activity — 60 min/d moderate-vigorous; limit screen time < 2 hr/d; sleep hygiene (treat OSA — adenotonsillectomy if appropriate, CPAP); behavioral therapy + family involvement + parent management training; SCREEN for + MANAGE COMORBIDITIES — T2DM (HbA1c, fasting glucose, OGTT if indicated), dyslipidemia (lipid panel), NAFLD (ALT q yr), HT (regular BP), OSA (PSG), depression, body image, eating disorder; PHARMACOTHERAPY now AAP-recommended adjunct ≥ 12 yr with BMI > 95th + comorbidities — Liraglutide ≥ 12 yr OR Phentermine-Topiramate ≥ 12 yr OR Orlistat ≥ 12 yr OR Setmelanotide for specific genetic obesity ≥ 6 yr OR Semaglutide weekly SC ≥ 12 yr (recent FDA approval, dramatic results — STEP TEENS trial 16% BMI reduction over 68 wk); long-term medication + monitoring; METABOLIC + BARIATRIC SURGERY (MBS) — AAP-recommended adolescents ≥ 13 yr with BMI > 35 + significant comorbidities OR > 40 (sleeve gastrectomy or RYGB) at specialized centers — significant durable weight loss + reverse comorbidities; psychosocial support — depression + body image + bullying common; school nutrition + activity advocacy; cardiometabolic risk reduction

---

AAP 2023 Pediatric Obesity Guidelines: paradigm shift — treat early + intensively (no watchful waiting). IHBLT for all ≥ 6 yr. Pharmacotherapy ≥ 12 yr with BMI > 95th + comorbidity (liraglutide, semaglutide, phentermine-topiramate). Bariatric surgery ≥ 13 yr selected severe. Comorbidity screening + multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 11 ปี BW 78 kg, ส่วนสูง 145 cm, BMI 37.0 (severe obesity > 99th percentile, > 120% of 95th percentile per AAP definition); puberty Tanner 3; ไม่มี endocrine cause; เริ่มมี acanthosis nigricans + acral darkening; sleep ngonggn snoring + witnessed apnea

PE: severe obesity, hypertension borderline 130/82, abdominal striae, acanthosis nigricans; mild gynecomastia (likely lipomastia), no Cushingoid features, normal thyroid; normal genitalia for stage
Lab: HbA1c 5.9 (impaired), fasting glucose 108, fasting insulin elevated, lipid panel — TG 220, LDL 132, HDL 38 (low), ALT 78 (high — likely NAFLD), TSH normal
PSG: moderate OSA (AHI 12)';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention needed ever"},{"label":"B","text":"Hemodynamically significant Ostium Secundum ASD (Qp:Qs > 1.5-2 + RV dilation)"},{"label":"C","text":"Heart transplant"},{"label":"D","text":"Watch + wait age 40"},{"label":"E","text":"Diuretic chronic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemodynamically significant Ostium Secundum ASD (Qp:Qs > 1.5-2 + RV dilation): elective closure indicated to prevent long-term complications (PHT, atrial arrhythmias, paradoxical embolism, RV failure); TIMING — ideally 2-5 years of age (most defects identified by age, surgery before school age + reduces lifetime risk); MODALITY — TRANSCATHETER closure (Amplatzer Septal Occluder, Gore Cardioform) is FIRST-LINE for secundum ASD with adequate rims + appropriate size (90%+ secundum amenable) — minimally invasive, no sternotomy, shorter recovery, similar long-term outcomes; SURGICAL closure for: primum ASD, sinus venosus, large defect with inadequate rims, very large secundum > 35 mm, associated anomalies, contraindication to device; cardiac MRI for detailed anatomy + RV function; antibiotic prophylaxis NOT routinely required for ASD per AHA 2007 unless prosthetic material in first 6 mo OR residual defect adjacent to device; aspirin 3-5 mg/kg/d × 6 mo post-device closure (anti-platelet for endothelialization); follow-up — echo at 24 hr post + 1 mo + 6 mo + annually; activity — no restriction unless symptomatic; education + screen first-degree relatives (small familial component); long-term: post-closure outcomes excellent if closed before adult atrial arrhythmias develop

---

Secundum ASD = most common ASD. Transcatheter device closure preferred for amenable defects. Close 2-5 yr to prevent adult complications (atrial arrhythmia, PHT, RV dysfunction). Surgery for primum/sinus venosus/inadequate rims. Excellent outcomes if treated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี ตรวจ routine check up พบ murmur fixed split S2 + soft systolic ejection murmur LUSB grade 2-3/6

V/S ปกติ, BW 18 kg, asymptomatic, normal growth
Family Hx: aunt has ASD repaired

ECG: incomplete RBBB, right axis deviation
CXR: mild cardiomegaly, prominent pulmonary vasculature
Echo: ostium secundum ASD 12 mm, L→R shunt, Qp:Qs 2.4, mild RV dilatation, normal LV, normal pulmonary pressure';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue sports unrestricted"},{"label":"B","text":"Severe Congenital Aortic Stenosis (bicuspid) + symptoms = INTERVENTION"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Wait — outgrow"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Congenital Aortic Stenosis (bicuspid) + symptoms = INTERVENTION: cardiology + cardiac surgery urgent; activity RESTRICTION — no competitive sports + no isometric high-intensity activity until intervention (sudden death risk severe AS); BETA-BLOCKER for symptom control before intervention; BALLOON AORTIC VALVULOPLASTY (BAV) — TYPICALLY FIRST-LINE intervention in pediatric AS — minimally invasive, can repeat, postpones valve replacement (durability 5-10 yr typically before need for further intervention); SURGICAL OPTIONS depending on anatomy + age: 1) AV repair if leaflet preservation possible, 2) Ross procedure (pulmonary autograft to aortic position + homograft to PV — preferred in growing children, autograft grows, no anticoagulation, durable) — gold standard pediatric AS surgical; 3) AV REPLACEMENT — mechanical (durable but requires lifelong anticoagulation, problematic growth), bioprosthetic (no anticoagulation but limited durability + redo); 4) APICOAORTIC conduit; antibiotic prophylaxis prior to dental/surgery for prosthetic/repaired with material × 6 mo (AHA); long-term follow-up annually — echo + ECG + symptom + activity; counsel on Marfan/connective tissue + aortopathy/dissection risk with bicuspid AV; family screening (BAV familial component); contraception planning + pregnancy considerations later; transition adult CHD

---

Pediatric AS + symptoms or severe gradient = intervention. BAV first-line typically. Ross procedure preferred surgical for growing children (autograft grows, no anticoagulation). Mechanical valve = lifelong anticoagulation. Bicuspid AV = aortopathy + family screen. Activity restriction critical pre-intervention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 10 ปี ใจสั่น + เจ็บอกขณะออกกำลังกาย + episodes syncope ขณะเล่นกีฬา 2 ครั้ง 3 mo

V/S: HR 78, BP 110/72, BW 30 kg
PE: harsh ejection systolic murmur 4/6 at RUSB radiating to neck + suprasternal thrill, soft S2, delayed carotid upstroke (parvus et tardus)

ECG: LVH + strain pattern
CXR: prominent aorta, normal heart size
Echo: bicuspid AV (congenital) + severe AS (mean gradient 60 mmHg, peak gradient 90), normal LV function, mild AR';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Multisystem Inflammatory Syndrome in Children (MIS-C, post-COVID hyperinflammation, CDC criteria"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antiviral alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multisystem Inflammatory Syndrome in Children (MIS-C, post-COVID hyperinflammation, CDC criteria — fever + multi-system + lab evidence + SARS-CoV-2 exposure/serology + no alt Dx): admit PICU; cardiac monitoring + frequent echo; supportive — IV fluid careful (cardiac dysfunction → measure preload + avoid overload), vasopressor/inotrope as needed (norepinephrine, epinephrine, milrinone for LV dysfunction), respiratory support; IMMUNOMODULATION — first-line IVIG 2 g/kg single infusion + Methylprednisolone 1-2 mg/kg/d IV (low-mod dose) — combination shows improved outcomes (especially with shock/cardiac involvement); for severe/refractory — high-dose pulse methylprednisolone 30 mg/kg/d × 3 d OR anakinra (IL-1 receptor antagonist) 4-10 mg/kg/d SC/IV OR infliximab (anti-TNF) OR tocilizumab — escalation; ASPIRIN 3-5 mg/kg/d (anti-platelet — concurrent treatment with thrombosis prophylaxis); ANTICOAGULATION — enoxaparin prophylactic ALL patients OR therapeutic if thrombosis/severe LV dysfunction/aneurysm; address coronary involvement (z-score) — escalation if dilatation/aneurysm progresses; multidisciplinary — peds cardiology, ID, rheumatology, ICU, hematology; SUPPORTIVE — electrolytes, AKI management; recheck inflammatory markers + echo trending down; vaccination once recovered (COVID + others on schedule); long-term — cardiac function follow-up 6-12 mo, exercise tolerance, NSAID/anticoagulation duration; report to local public health + national database; family education + return precautions if recurrent fever

---

MIS-C = hyperinflammatory syndrome 2-6 wk after SARS-CoV-2 (mimics KD + TSS). CDC criteria. IVIG + steroid combination first-line. Cardiac involvement common (LV dysfunction, coronaries). Aspirin + anticoagulation. Escalation (anakinra) for refractory. Multidisciplinary + long-term cardiac follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 8 ปี 4 wk ก่อน Hx COVID-19 mild ตอนนี้ ไข้สูง 39.6°C × 6 วัน + conjunctivitis bilateral + ผื่นแดง + ปวดท้องรุนแรง + อาเจียน + diarrhea + ปาก/ลิ้นแดง + edema hands/feet + hypotension shock-like

V/S: HR 142, BP 86/52, RR 32, SpO2 96%, Temp 39.6°C, BW 26 kg
Gen: ill-appearing, mucocutaneous + cardiac + GI

Lab: CRP 285 (very high), ESR 92, fibrinogen 580, ferritin 1,840, D-dimer 3,200, troponin 1.2 (HIGH!), BNP 4,250, lymphopenia, mild AKI Cr 1.4, sodium 132, albumin 2.8, LFT mildly elevated
SARS-CoV-2 IgG positive + PCR negative
Echo: LV dysfunction EF 38%, mild dilation, no coronary aneurysm yet (but Z-score borderline)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient oral acyclovir"},{"label":"B","text":"Varicella in severely immunocompromised child = EMERGENCY (high mortality if disseminated)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Withhold all treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Varicella in severely immunocompromised child = EMERGENCY (high mortality if disseminated): admit + IV Acyclovir 500 mg/m² q8h (or 10 mg/kg/dose q8h) IV × 7-10 days minimum (longer if continued lesions/disseminated/visceral), adjusted for renal function; oral acyclovir/valacyclovir INADEQUATE in this population; supportive — hydration (acyclovir crystalluria, maintain UO good), antipyretic AVOID ASPIRIN (Reye risk + transmission concern), antipruritic, prevent secondary bacterial infection (Staph, GAS — superinfection can be severe); careful skin/wound care + bath; monitor for VISCERAL DISSEMINATION — pneumonitis (severe, high mortality), encephalitis, hepatitis, DIC, hemorrhagic varicella — manage in ICU; isolate airborne + contact precautions (until lesions crusted, no new × 24 hr); REMOVE/REDUCE chemotherapy temporarily (coordinate oncology — risk infection vs cancer); POST-EXPOSURE for immunocompromised + susceptible contacts: VZIG (VariZIG) 125 U/10 kg IM (max 625 U) within 96 hr (extended to 10 d post-exposure) — passive immunization; alternative IVIG if VZIG unavailable; antiviral prophylaxis acyclovir 800 mg PO QID × 7 d (days 7-22 post-exposure) for high-risk susceptible if VZIG unavailable; prevention — VARIVAX vaccine for healthy + select immunocompetent contacts; long-term: full immunity post-recovery; vaccination once chemo completed + immune recovery

---

Varicella + severe immunocompromise (ALL on chemo, post-transplant, congenital immunodeficiency) = high mortality if untreated. IV acyclovir mandatory (oral inadequate). Watch visceral dissemination + bacterial superinfection. Post-exposure prophylaxis VZIG or acyclovir for susceptible immunocompromised contacts within 10 d.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี on chemotherapy for ALL (induction phase, severely immunocompromised) แม่บอกพี่น้องเป็นอีสุกอีใส 14 วันก่อน — ตอนนี้พบ vesicular rash บน trunk + face 2 lesions ใหม่ ๆ + ไข้ 38.4°C

V/S: HR 122, RR 28, Temp 38.4°C, BW 20 kg
PE: 5-6 vesicles trunk + face on erythematous base (early), no respiratory distress, no encephalopathy currently, no severe LFT change

WBC neutropenia 220 (severely low), Plt 38,000, mild LFT elevation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antiviral alone curative"},{"label":"B","text":"Measles with secondary pneumonia (major complication, leading cause measles death)"},{"label":"C","text":"Discharge no follow"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Measles with secondary pneumonia (major complication, leading cause measles death) — vaccine-preventable disease: admit + isolation airborne (negative pressure room if available, mask) until 4 d after rash onset; SUPPORTIVE — adequate hydration, antipyretic acetaminophen (AVOID aspirin), oxygen as needed to maintain SpO2 ≥ 92%, nutritional support; ANTIBIOTIC for bacterial pneumonia superinfection — empiric Ceftriaxone (covers Spn, H flu) + add anti-Staph (vancomycin) if severe/MRSA risk × 7-10 d; VITAMIN A SUPPLEMENT — proven to reduce measles morbidity + mortality especially in malnourished/vit A deficient — 200,000 IU PO single dose for > 1 yr (100,000 < 1 yr, 50,000 < 6 mo) — repeat day 2 + 2-4 wk if signs of vit A deficiency + measles severe (WHO standard); ANTIVIRAL — ribavirin investigational + only for severe cases (no routine antiviral measles); no specific approved antiviral; bacterial complications include AOM, pneumonia, mastoiditis, croup; OTHER COMPLICATIONS to watch — encephalitis 0.1-0.2% (high mortality + morbidity), SSPE (subacute sclerosing panencephalitis) rare delayed years later (degenerative); blindness from corneal scarring (vit A deficiency); diarrhea + malnutrition; POST-EXPOSURE PROPHYLAXIS for susceptible contacts within 72 hr (MMR vaccine — but contraindicated < 6 mo + pregnant + severely immunocompromised) OR within 6 d (immune globulin 0.5 mL/kg max 15 mL — for immunocompromised, pregnant, < 12 mo); reportable urgent + public health response; quarantine contacts 21 d if susceptible; vaccination key prevention (MMR 2-dose); long-term — immune amnesia (immune system reset post-measles, increased susceptibility 1-3 yr)

---

Measles = highly contagious, reportable, vaccine-preventable. Pneumonia leading complication. Vitamin A WHO/AAP recommendation. Bacterial superinfection antibiotic. Watch encephalitis + SSPE. PEP within 72 hr MMR or within 6 d immune globulin for susceptible. Vaccination 2-dose prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี vaccine ไม่ครบ (no MMR), เพิ่งเดินทางกลับจาก outbreak area ในต่างประเทศ ตอนนี้ ไข้สูง 40°C × 5 วัน + cough + coryza + conjunctivitis + Koplik spots (white spots on red base buccal mucosa) → ผื่นแดงเริ่มหน้าก่อน แล้วลามลงตัว 2 วัน + คอเจ็บ + เริ่มหอบเหนื่อย + ไม่ได้กิน vit A

V/S: HR 142, RR 48, SpO2 92%, Temp 40°C, BW 16 kg
PE: morbilliform rash trunk + extremities, conjunctivitis, Koplik (resolving), bilateral crackles + decreased breath sounds RLL
CXR: bilateral interstitial + RLL consolidation
CBC: lymphopenia
Measles IgM positive + PCR positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue ampicillin"},{"label":"B","text":"Mycoplasma pneumoniae pneumonia (atypical pneumonia, school-age + adolescent peak)"},{"label":"C","text":"Antifungal alone"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"No antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mycoplasma pneumoniae pneumonia (atypical pneumonia, school-age + adolescent peak): antibiotic effective against atypical pathogens — Macrolide first-line (Azithromycin 10 mg/kg day 1 then 5 mg/kg × 4 d OR Clarithromycin 7.5 mg/kg q12h × 7-10 d OR Erythromycin); MACROLIDE RESISTANCE rising globally (especially Asia) — if no clinical improvement 48-72 hr or known high-resistance area → consider DOXYCYCLINE 4 mg/kg/d ÷ q12h × 7-10 d (now recommended ALL ages per IDSA 2020 for short courses, formerly restricted > 8 yr) OR Fluoroquinolone (levofloxacin) selected (off-label peds, reserve); supportive — antipyretic, hydration, monitoring; usually outpatient unless severe (hypoxia, distress, dehydration, immunocompromised); EXTRAPULMONARY MANIFESTATIONS to watch — hemolytic anemia (cold agglutinin), encephalitis (rare but devastating), Mycoplasma-induced rash + mucositis (MIRM), Stevens-Johnson syndrome variant, arthritis, myocarditis; consider hospitalization if extrapulmonary; immunity not lifelong → can reinfect; outbreaks among schools/families; no vaccine; identify clinical context — Mycoplasma should be considered school-age + adolescent with atypical features (gradual onset, prolonged cough, normal-mild CBC, bilateral patchy CXR, extrapulmonary, exposure)

---

Mycoplasma = atypical pneumonia school-age + adolescent. CXR worse than clinical. Cold agglutinin + extrapulmonary manifestations (MIRM, SJS, hemolytic anemia, encephalitis). Macrolide first-line; doxycycline (all ages 2020) or fluoroquinolone for macrolide-resistance. No vaccine; reinfection possible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 12 ปี ค่อย ๆ มีไข้ + ไอ persistent dry x 2-3 wk + ปวดศีรษะ + sore throat + myalgia + ไม่ค่อยตอบสนองต่อ ampicillin ขั้น primary care

V/S: HR 102, RR 28, SpO2 95%, Temp 38.4°C, BW 36 kg
Gen: not toxic, persistent dry cough, scattered crackles bilateral, mild wheeze, no consolidation pattern

CXR: bilateral interstitial + perihilar infiltrate (looks worse than clinical exam — classic for atypical)
CBC: WBC 9,200 normal, mild lymphopenia
Cold agglutinins positive; Mycoplasma IgM positive + PCR positive (current preferred)
Family: sibling sick with similar 4 wk ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Pediatric Moderate-Severe Obstructive Sleep Apnea"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Sedative for sleep"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Moderate-Severe Obstructive Sleep Apnea — ENT referral + adenotonsillectomy FIRST-LINE: surgical adenotonsillectomy success rate 70-80% pediatric OSA cure, addresses adenoid + tonsillar hypertrophy (most common cause); pre-op evaluation — anesthesia consult (post-op respiratory complications — especially < 3 yr, severe OSA, obesity, syndromes — admit overnight monitoring); supportive — humidified air, nasal saline, treat allergic rhinitis (intranasal corticosteroid + montelukast may help mild OSA pre-surgery + persistent post-op residual OSA); WATCH for post-op complications — bleeding (primary 24 hr, secondary 5-10 d), respiratory compromise, dehydration; if residual OSA post-surgery → CPAP/BiPAP titrated (PSG repeat 6-8 wk post-op); ADDRESS COMORBIDITIES — obesity weight management, allergic rhinitis, GERD, craniofacial syndromes (Pierre Robin, Treacher Collins, Crouzon — different approach), neuromuscular weakness, Down syndrome (higher OSA prevalence + risk + post-op edema); long-term sequelae untreated — cardiovascular (pulmonary HT, RV dysfunction), neurocognitive + behavioral (ADHD-like), failure to thrive, enuresis; family education — observe post-op recovery, return precautions; PSG repeat 6-8 wk post-op if symptoms persist; transition adult OSA if persists adolescence + adulthood

---

Pediatric OSA different from adult — adenotonsillar hypertrophy primary cause. Adenotonsillectomy first-line (70-80% cure). PSG diagnostic + AHI > 5 in kids = OSA. Comorbidities (obesity, Down, craniofacial). CPAP for residual OSA. Long-term cardiovascular + neurobehavioral sequelae untreated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี BW 24 kg ครอบครัวสังเกตว่าลูกนอนกรน + หยุดหายใจ episodes 5-10 sec ขณะนอน + restless sleep + ตื่นเช้าง่วงนอน + พฤติกรรมหลังตื่น hyperactive + ผลการเรียนตก + ปัสสาวะรดที่นอน + mouth breathing daytime

PE: tonsils 3+ enlarged + adenoid facies (long face, open mouth), BMI 19, nasal congestion mild, no obstruction other; growth ปกติ
Polysomnography: AHI 14 events/hr (moderate-severe OSA in peds — AHI > 5 in kids = OSA, > 10 = moderate, > 15 = severe), oxygen desaturation nadir 82%, no central apnea, snoring throughout';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Hypertensive Urgency (severe HT WITHOUT end-organ damage"},{"label":"C","text":"Sublingual nifedipine"},{"label":"D","text":"IV nitroprusside"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertensive Urgency (severe HT WITHOUT end-organ damage — vs emergency WITH damage): admit observation, GRADUAL oral antihypertensive treatment over 24-48 hr (not minutes-hours like emergency); first-line oral options — Captopril 0.3-0.5 mg/kg/dose q8h (ACEI, fast onset 15-30 min, monitor renal function) OR Hydralazine 0.1-0.2 mg/kg/dose q4-6h (vasodilator) OR Labetalol oral 1-3 mg/kg/dose q12h (beta + alpha block) OR Nifedipine immediate release (NOT sublingual — avoid sudden drops, but oral 0.25-0.5 mg/kg may be acceptable in some pediatric protocols, used cautiously); avoid abrupt + excessive lowering; goal — reduce BP gradually over 24-48 hr aim < 95th percentile; identify cause — workup secondary HT (renal — US + DMSA + MRA renal arteries if young; endocrine — pheochromocytoma + neuroblastoma catecholamines, Cushing, hyperaldosteronism, thyroid; coarctation re-eval; OSA screen; medication-induced; oral contraceptive; sympathomimetic, illicit drugs); LIFESTYLE — weight management (this patient overweight), DASH diet, sodium reduction, increase activity, address screen time + sleep; long-term oral antihypertensive — ACEI (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide first-line per AAP 2017; reassess + titrate q1-4 wk; ABPM for white coat HT; address comorbid CV risk; family + school education

---

Pediatric HT urgency = severely elevated BP WITHOUT end-organ damage. Treat gradually with oral antihypertensives over 24-48 hr (vs IV emergency). Workup secondary cause. Lifestyle + pharmacotherapy long-term. AAP 2017 Guideline. Goal < 95th percentile.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 14 ปี BMI 30 (obesity) presented with headache + nosebleed × 3 วัน — no other neurologic symptoms

V/S: BP 168/108 (severely elevated > 95th + 12 mmHg) confirmed × 3 separate measurements, HR 92, BW 68 kg, no signs end-organ damage (no papilledema, no AKI, no encephalopathy, no LVH on ECG, no neuro deficit)
Lab: Cr 0.8, K 3.6, glucose 102, UA negative, plasma renin/aldosterone normal, TSH normal, urine catecholamines pending
US renal: normal anatomy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Methimazole"},{"label":"B","text":"Acquired Primary Hypothyroidism (Hashimoto thyroiditis, most common cause peds acquired hypothyroidism)"},{"label":"C","text":"Iodine high dose"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acquired Primary Hypothyroidism (Hashimoto thyroiditis, most common cause peds acquired hypothyroidism): LEVOTHYROXINE replacement starting dose pediatric (~3-5 mcg/kg/d adolescent, lower for younger child age-specific) — start lower in long-standing severe hypothyroidism then titrate up (avoid cardiac arrhythmia / pseudotumor cerebri / accelerated growth/bone age); take EMPTY STOMACH 30-60 min before food + separated from calcium/iron/PPI/soy (interfere absorption); RECHECK TSH + Free T4 q4-6 wk while titrating, then q6-12 mo once stable (TSH lag 6 wk after dose change); target TSH normal range (0.5-4) + Free T4 mid-normal range; INVESTIGATE associated autoimmune conditions (DM1, celiac, Addison, vitiligo, Sjogren, alopecia) + screen family; monitor growth + puberty progression (resume after euthyroid); educate family + child — lifelong condition + medication adherence; long-term — most stable euthyroid on replacement, occasional fluctuation, repeat scan if structural concern (rare cancer in pediatric Hashimoto); psychosocial support — initial mood/cognition affects; consider growth specialist if growth severely impaired; adolescent transition; AVOID — methimazole/PTU (those for hyperthyroidism), surgery (no indication)

---

Hashimoto thyroiditis = most common acquired hypothyroidism kids + adolescents. Levothyroxine replacement + monitoring TSH/Free T4. Screen associated autoimmune. Family history common. Lifelong treatment. Avoid antithyroid agents (those for Graves).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 11 ปี เริ่มเหนื่อยง่าย + ทนหนาวไม่ค่อยได้ + น้ำหนักเพิ่ม 4 kg ใน 6 mo despite same diet + ผลการเรียนลดลง + skin dry + hair coarse + constipation + delayed puberty Tanner 2

V/S: HR 58, BP 102/68, BW 42 kg, growth velocity slowed (4 cm/yr from baseline 6 cm/yr)
PE: diffuse goiter symmetric firm rubbery, dry skin, mild bradycardia, normal reflexes (no delayed relaxation severe yet), proportional growth

Lab: TSH 38 (high), Free T4 0.5 (low), Free T3 low-normal
Anti-thyroid peroxidase (anti-TPO) HIGH, Anti-thyroglobulin elevated = autoimmune (Hashimoto thyroiditis)
Family: mother Hashimoto + sister type 1 DM';

update public.mcq_questions
set choices = '[{"label":"A","text":"No follow-up needed"},{"label":"B","text":"Neurofibromatosis Type 1 (NF1 = autosomal dominant, NF1 gene chromosome 17, ~50% spontaneous mutation)"},{"label":"C","text":"Surgery only no follow-up"},{"label":"D","text":"Chemotherapy preventive"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neurofibromatosis Type 1 (NF1 = autosomal dominant, NF1 gene chromosome 17, ~50% spontaneous mutation) — multispecialty surveillance + management: GENETIC confirmation (NF1 sequencing) + counseling (50% offspring risk + 50% sporadic); MULTIDISCIPLINARY annual evaluation — pediatric neurology + ophthalmology + dermatology + orthopedics + oncology + cardiology + psychology + special education; ANNUAL OPHTHALMOLOGY — Lisch nodules + screen optic pathway glioma (most common CNS tumor NF1, peak 4-6 yr, surveillance MRI annual age 1-7 then if symptoms); annual GROWTH/PUBERTY/BP — early puberty + HT (pheochromocytoma — rare but evaluate if symptoms, renal artery stenosis — important treatable cause HT in NF1); ANNUAL SKIN exam — neurofibromas + plexiform NF (risk MPNST malignant transformation 5-10% lifetime); ANNUAL SKELETAL exam — scoliosis (common, severe + dysplastic), pseudoarthrosis tibia/fibula (typically congenital), sphenoid wing dysplasia; LEARNING DISABILITY 50% — neuropsychology + IEP + school accommodations; MRI brain baseline (most centers) + selective spine; AVOID elective IR + radiation if possible (NF1 = increased second malignancy risk); WATCH/EARLY DETECT — MPNST (Malignant Peripheral Nerve Sheath Tumor) — most common cancer NF1 adolescent/adult — rapid growth, pain, neurological symptoms = workup PET/MRI/biopsy urgent; AML, brain tumors, GIST, leukemia + breast cancer adult women NF1 (earlier screening mammogram 30); selumetinib (MEK inhibitor) FDA-approved for inoperable plexiform NF1 ≥ 2 yr with morbidity — significant benefit; FAMILY support + education + transition adult; pregnancy planning — NF1 women high-risk pregnancy + complications + half offspring inherit

---

NF1 = AD genetic disorder, multisystem manifestations. NIH criteria. Comprehensive multispecialty annual surveillance for tumor (OPG, MPNST), HT (RAS, pheo), skeletal (scoliosis), cognitive (LD), psychosocial. Selumetinib for plexiform NF. Genetic counseling. Long-term cancer surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี พ่อแม่สังเกตว่ามี cafe-au-lait macules หลายจุด (8 จุด > 5 mm) + freckling axillary + Lisch nodules iris bilateral (slit-lamp + ในตา) + first-degree relative (พ่อ) มี NF-1

PE: > 6 CAL spots > 5 mm prepubertal, axillary + inguinal freckling, Lisch nodules, no plexiform NF currently, no skeletal deformity, normal development, BW + height normal

Clinical NIH criteria met for NF-1 ( ≥ 2 features)
No malignancy currently, MRI brain + spine pending baseline';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Tuberous Sclerosis Complex (TSC, autosomal dominant TSC1/TSC2 gene"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Single antiepileptic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tuberous Sclerosis Complex (TSC, autosomal dominant TSC1/TSC2 gene → hyperactive mTOR pathway): multidisciplinary lifelong care — neurology + cardiology + nephrology + dermatology + ophthalmology + neuropsychology + special education + genetics; INFANTILE SPASMS treatment — first-line VIGABATRIN (preferred in TSC, evidence superior to ACTH in TSC), monitor retinal toxicity (vigabatrin retinal field defect); alternative ACTH; ketogenic diet adjunct; epilepsy surgery if focal resistant; CONTROL EPILEPSY critical for cognitive outcome; mTOR INHIBITORS — Everolimus (FDA-approved for SEGA, renal angiomyolipoma, refractory epilepsy in TSC ≥ 1 yr) revolutionized treatment + can shrink tumors; SEGA surveillance — MRI annual + watch growth, hydrocephalus, neuro symptoms — surgical resection vs everolimus (decision per anatomy + symptoms); RENAL angiomyolipomas — surveillance + bleeding risk (large > 3 cm), everolimus or embolization or partial nephrectomy; CARDIAC rhabdomyoma — most regress spontaneously childhood, surgery rarely needed unless obstruction/arrhythmia; SKIN — facial angiofibromas topical sirolimus, surgical/laser for cosmesis; DENTAL — pitting/enamel; PULMONARY — lymphangioleiomyomatosis (LAM) women adolescence/adult; INTELLECTUAL DISABILITY 50% — early intervention + IEP; AUTISM spectrum 30-60% — early intervention; PSYCHIATRIC + ADHD common; CANCER surveillance — renal cell carcinoma + others; FAMILY genetic counseling (AD, 25-67% sporadic vs inherited); transition adult care; updated TSC consensus 2021 + 2024

---

TSC = autosomal dominant, mTOR pathway. Multisystem: brain (tubers, SEGA, infantile spasms, autism, LD), cardiac (rhabdomyoma — regress), renal (AML, cysts), skin, eye, lung (LAM adults). Vigabatrin first-line for infantile spasms in TSC. mTOR inhibitor everolimus revolutionized. Multidisciplinary lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกหญิงอายุ 6 mo ตอนคลอดพ่อแม่สังเกตว่ามี hypomelanotic macules (ash-leaf spots) หลายจุด — สังเกตได้ด้วย Wood''s lamp; ตอนนี้ infantile spasms (hypsarrhythmia EEG +) เริ่ม 4 mo + developmental regression + cardiac murmur ที่เคยตรวจ pre-natal มี rhabdomyoma

PE: > 3 hypomelanotic macules trunk + extremities, shagreen patch lumbar back, no facial angiofibroma yet (too young)
Echo: multiple cardiac rhabdomyomas (non-obstructive)
Brain MRI: multiple cortical tubers + subependymal nodules + subependymal giant cell astrocytoma (SEGA) borderline size
US renal: small angiomyolipomas + cysts bilateral
Genetics: TSC2 mutation positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for culture results"},{"label":"B","text":"Early-Onset Neonatal Sepsis (likely GBS despite IAP"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Single antibiotic narrow spectrum"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-Onset Neonatal Sepsis (likely GBS despite IAP — IAP reduces but doesn''t eliminate): IMMEDIATE recognition + treat as septic shock; ABC — airway + breathing (consider intubation given respiratory distress + impending failure); CIRCULATION — IV/IO access × 2 within minutes; aggressive fluid resuscitation 10-20 mL/kg NSS BOLUS over 5-10 min repeat as needed reassessing after each (target normal perfusion); empiric BROAD-SPECTRUM IV antibiotic within FIRST HOUR — Ampicillin 100-150 mg/kg/dose q6h + Gentamicin 4 mg/kg/dose q24h IV (covers GBS, E. coli, Listeria, gram-negatives); if meningitis confirmed (LP after stabilization, NOT delaying antibiotic) → add Cefotaxime 50 mg/kg/dose q6-8h + extend duration; correct hypoglycemia D10W 2 mL/kg bolus + ongoing infusion; correct acidosis (volume + antibiotic), electrolytes; VASOPRESSOR if fluid-refractory shock — DOPAMINE 5-15 mcg/kg/min OR EPINEPHRINE 0.05-0.3 mcg/kg/min (preferred cold shock — neonates often cold); HYDROCORTISONE if catecholamine-resistant; NEONATAL ICU; monitor for DIC (FFP + platelet if active bleed/severe consumption); intubation + surfactant if respiratory failure; ECMO selected refractory; serial lactate + perfusion; antibiotic duration 10 d uncomplicated bacteremia, 14-21 d meningitis (GBS), longer for complications; supportive — temp regulation, glucose, electrolytes, nutrition, family support; vaccine on schedule once recovered; audiology + neuroimaging + developmental follow-up; counsel family — outcome variable, prevention via IAP + new maternal GBS vaccine in development

---

Early-onset sepsis = leading cause neonatal mortality. GBS most common despite IAP (reduces but doesn''t eliminate). Recognize signs (temp instability, respiratory, poor feeding, lethargy, mottling). Empiric ampicillin + gentamicin within 1 hr. Aggressive fluid + vasopressor + ICU. Antibiotic duration per Dx. Long-term sequelae.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term DOL 1 (age 14 ชม), แม่ GBS+ ได้ IAP intrapartum penicillin > 4 hr ก่อนคลอด ตอนนี้ทารกอาการแย่ลง — temperature instability + respiratory distress + cyanosis + poor feeding + lethargy

V/S: HR 184, RR 78, Temp 35.8°C (hypothermia), SpO2 88%, capillary refill 5 sec
Gen: lethargic, mottled, weak pulses, mild grunting, retractions, jaundice mild

CBC: WBC 28,000 + immature/total ratio 0.4 (HIGH), Plt 78,000, glucose 38, lactate 5.2
ABG: pH 7.18, BE -12
CXR: bilateral patchy infiltrate
Blood culture × 2 pending; LP pending; CRP 95';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue carbamazepine"},{"label":"B","text":"DRESS (Drug Reaction with Eosinophilia + Systemic Symptoms"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DRESS (Drug Reaction with Eosinophilia + Systemic Symptoms — severe SCAR — Severe Cutaneous Adverse Reaction): IMMEDIATE DISCONTINUE OFFENDING DRUG (carbamazepine + cross-reactive aromatic antiepileptics — phenytoin, phenobarbital, lamotrigine — switch to non-aromatic levetiracetam, valproate); admit + multidisciplinary (dermatology + ID + nephrology + hepatology + cardiology + pulmonology — multi-organ involvement); SUPPORTIVE — fluid balance, electrolytes, nutrition; SYSTEMIC CORTICOSTEROIDS — prednisolone 1-2 mg/kg/d IV/PO (start higher in severe/visceral involvement) + slow taper over weeks-months (rapid taper → relapse); TOPICAL corticosteroid + emollient for skin; refractory + life-threatening → consider IVIG OR cyclosporine OR rituximab; monitor — VISCERAL INVOLVEMENT (liver, kidney, heart, lung, brain, pancreas, thyroid) recurrent flares + organ-specific (LFT q daily, Cr, ECG, echo, lipase) + autoimmune sequelae long-term (autoimmune thyroiditis, T1DM, lupus, AIHA developing months-years post — long-term follow-up); supportive other organ management; AVOID future re-exposure offending drug + cross-reactive drugs (lifelong, medical alert bracelet, document allergy); HLA TESTING — HLA-B*15:02 (carbamazepine SJS/DRESS in Asians especially Han Chinese, Thai, Indonesian — FDA + Thai Ministry of Health recommend screening before carbamazepine), HLA-B*58:01 (allopurinol), HLA-B*57:01 (abacavir); family + sibling considered for testing depending; report to drug safety authority; mortality ~10% DRESS

---

DRESS = severe adverse drug reaction. Carbamazepine, phenytoin, allopurinol, sulfa, vancomycin common triggers. Latency 2-6 wk. Fever + rash + facial edema + LN + eosinophilia + multi-organ. STOP drug + systemic steroid + long taper. HLA-B*15:02 screening before carbamazepine in Asians (Thai). Late autoimmune sequelae.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 11 ปี เริ่มกิน carbamazepine สำหรับ seizure 4 wk ก่อน ตอนนี้ ไข้สูง + ผื่นแดงทั่วตัว morbilliform → expanding + facial edema + lymphadenopathy generalized + เหนื่อย + คลื่นไส้ + เริ่ม dark urine

V/S: HR 122, BP 102/68, RR 24, Temp 39.4°C, BW 36 kg
PE: erythroderma-like rash > 50% BSA, facial edema, generalized lymphadenopathy, hepatomegaly tender, no mucous involvement to suggest SJS

CBC: WBC 18,000 with eosinophils 4,200 (15% — HIGH), atypical lymphocytes
LFT: ALT 480, AST 520 (high — hepatitis), bilirubin elevated
Cr 1.4 (mild AKI), proteinuria + LE +
Viral HHV-6 reactivation common — PCR pending
DRESS RegiSCAR score: definite';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue TMP-SMX"},{"label":"B","text":"Stevens-Johnson Syndrome (SJS, severe cutaneous adverse reaction, < 10% BSA detachment; SJS-TEN overlap 10-30%; TEN > 30%)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic IV broad-spectrum prophylactic"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stevens-Johnson Syndrome (SJS, severe cutaneous adverse reaction, < 10% BSA detachment; SJS-TEN overlap 10-30%; TEN > 30%) — DERMATOLOGIC EMERGENCY: IMMEDIATE DISCONTINUE OFFENDING DRUG (TMP-SMX + cross-reactive sulfa) + ANY other non-essential medications; TRANSFER to burn unit / specialized SJS center (mortality 5% SJS, 30% TEN, treatment effectiveness depends on early specialty care); SUPPORTIVE care = priority (Burn-unit style) — temperature regulation (lose thermoregulation), fluid resuscitation (Parkland-like formula but typically less aggressive than burn — adjust by ins/outs, mucosal losses), electrolytes + nutrition (consider TPN, mucositis severe), pain management (IV opioid), prevent infection — sterile environment, gentle wound care (non-adherent dressings, biosynthetic skin substitutes), avoid empiric antibiotic (mask infection — culture-directed only); MUCOSAL CARE multidisciplinary — ophthalmology DAILY (prevent corneal scarring/blindness — lubrication + topical steroid + amniotic membrane transplant for severe), oral hygiene, GU care, GI/respiratory mucosa involvement; SPECIFIC therapy CONTROVERSIAL evidence — options: cyclosporine 3-5 mg/kg/d (most evidence + best outcome data in TEN/SJS, immunomodulator), IVIG (controversial, some studies + some no benefit), corticosteroid (controversial — high-dose pulse early may help, prolonged use ↑ infection risk, recent meta-analyses suggest benefit early steroid); etanercept (anti-TNF) emerging promising; AVOID NSAID, prophylactic systemic antibiotic; long-term — skin (pigmentation), ocular sequelae (visual impairment 35%, dry eye, scarring, blindness — LIFELONG ophtho follow-up), pulmonary (bronchiolitis obliterans), genitourinary stricture, psychological PTSD, oral/dental long-term; AVOID OFFENDING + CROSS-REACTIVE DRUG lifelong + medical alert + document; HLA testing for genetic susceptibility identification; family + reproductive counseling; reportable adverse event

---

SJS/TEN = severe drug reaction, skin emergency. STOP drug + transfer burn/specialized unit. Supportive Burn-like + mucosal care + ophtho daily. Cyclosporine best evidence specific therapy. Steroid controversial. Long-term ocular + pulmonary + skin sequelae. HLA testing. Lifelong drug avoidance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 14 ปี เริ่ม TMP-SMX 8 วันก่อนสำหรับ UTI ตอนนี้ ไข้ + ผื่นแดง dusky พอง + slipped skin sheets + ปาก + ตา + อวัยวะเพศ involvement + เจ็บปาก + กลืนไม่ได้ + ตาเปิดไม่ได้ + dysuria — sloughing < 10% BSA

V/S: HR 122, BP 102/68, RR 24, Temp 39.2°C, BW 40 kg
Gen: ill-looking, dehydrated, skin: dusky red macules + blisters + epidermal detachment + Nikolsky sign positive, severe mucositis oral + ocular + genital; involvement < 10% BSA = SJS

Lab: ALT 240, leukopenia 2,800, electrolyte abnormalities
HLA-B testing pending; biopsy: full-thickness epidermal necrosis + few lymphocytic infiltrate = consistent';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aspirin"},{"label":"B","text":"Type 1 von Willebrand Disease (most common inherited bleeding disorder, AD, partial quantitative deficiency) + heavy menstrual bleeding + IDA"},{"label":"C","text":"NSAID"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Surgery alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Type 1 von Willebrand Disease (most common inherited bleeding disorder, AD, partial quantitative deficiency) + heavy menstrual bleeding + IDA: hematology consultation; ACUTE bleeding (heavy menses now) — antifibrinolytic Tranexamic acid (TXA) 25 mg/kg/dose q8h PO during menses (effective for heavy bleeding); DESMOPRESSIN (DDAVP) — releases stored vWF + FVIII from endothelium — INTRANASAL Stimate 150 mcg/spray 1 spray each nostril q12-24h OR IV 0.3 mcg/kg infusion q12h — FOR Type 1 vWD with documented response (test response with stimation first); monitor for hyponatremia + seizure (fluid restriction during DDAVP); avoid > 3 doses (tachyphylaxis); ESTROGEN-PROGESTIN combined oral contraceptive — effective for menstrual control (also pregnancy prevention) ± LNG-IUD; vWF/FVIII CONCENTRATE (Humate-P, Wilate, recombinant) for severe bleeding, surgery, refractory bleeding; LONG-TERM management — vary intervention by need + lifestyle; AVOID — aspirin, NSAID, antiplatelet (worsen bleeding); MEDICAL ALERT bracelet + dental procedure pre-op planning (DDAVP, TXA, factor concentrate as needed); IRON replacement for IDA (oral or IV depending severity); FAMILY screening (AD, screen first-degree relatives, prenatal/PGD selected); long-term follow-up hematology + gyn + dental; education + transition adult; pregnancy planning — vWF normalizes 2nd-3rd trimester in many but post-partum hemorrhage risk → hematology coordination; emicizumab not vWD indicated

---

vWD = most common inherited bleeding disorder. Type 1 mild quantitative most common. Menorrhagia common presenting in adolescents. DDAVP + TXA + COC + factor concentrate per scenario. Avoid antiplatelet/NSAID. Iron supplement + family screen. Medical alert + dental planning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 13 ปี (post-menarche 1 yr) เลือดประจำเดือนมาก 8 วัน + เปลี่ยน pad q1-2 hr + Hb ลด + เลือดกำเดาหลายครั้ง + bruise ง่าย + เลือดออกหลังถอนฟัน นานกว่าปกติ 3 เดือน ก่อน

Family: mother มี heavy menses + brother บางครั้ง easy bruise
V/S: HR 102, BP 102/68, BW 50 kg

Lab: Hb 9.2, MCV 76 (microcytic — IDA), Ferritin LOW, Plt 280,000, PT normal, aPTT mildly prolonged 38 sec (normal 25-35), bleeding time prolonged
vWF antigen LOW (40%, normal 50-150), vWF activity (RCo) LOW, FVIII modestly LOW (subset of vWD), multimer analysis normal pattern = Type 1 vWD';

update public.mcq_questions
set choices = '[{"label":"A","text":"Insulin bolus + sodium bicarb"},{"label":"B","text":"Pediatric DKA moderate (ISPAD 2022)"},{"label":"C","text":"Restrict all fluid"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral hypoglycemic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric DKA moderate (ISPAD 2022): IV access; fluid resuscitation CAUTIOUS — 10-20 mL/kg NSS bolus over 30-60 min (avoid > 50 mL/kg first 4 hr — cerebral edema risk in peds, prefer SLOWER vs adult), then maintenance + deficit over 24-48 hr (NOT 24 hr alone); insulin AT LEAST 1 hr after starting fluid (not immediately, allows initial fluid resuscitation), then continuous IV regular insulin 0.05-0.1 U/kg/hr (NO BOLUS in peds DKA — bolus = no benefit, increased cerebral edema risk); POTASSIUM REPLACEMENT — add K to fluid (KCl 20-40 mEq/L) once K < 5.5 + UO established, even if serum K initially normal/high (total body deficit); monitor K q1-2h initially; BICARBONATE only if pH < 6.9 + CV compromise (controversial otherwise + cerebral edema risk); GLUCOSE monitor hourly — DEXTROSE add to fluid once glucose drops to ~250-300 (D5 then D10 if needed, continue insulin to clear ketones not just glucose); transition SC insulin when bicarbonate > 18, pH > 7.3, AG normal, glucose < 200, eating; OVERLAP IV + SC insulin (give SC dose 15-30 min before STOP IV insulin); GLUCOSE + electrolytes q1-2 hr; serum osmolality corrected sodium trend (paradoxical Na rise as glucose falls = appropriate; FALL = cerebral edema warning); MONITOR for CEREBRAL EDEMA — most feared, > 80% pediatric DKA deaths — signs: headache, vomiting (after initial improvement), AMS, papilledema, Cushing reflex, paradoxical Na rise; manage if detected — IMMEDIATE hypertonic saline OR mannitol, reduce fluid rate; identify TRIGGER — missed insulin most common adolescents, intercurrent illness (viral, UTI, GE), insulin pump failure; PSYCHOSOCIAL — adherence issues common adolescent (mental health, family conflict, eating disorder); patient education + family + transition adult; CGM + insulin pump consideration

---

Pediatric DKA = ISPAD 2022 cautious approach (cerebral edema risk). NO insulin bolus, delayed insulin (after fluid), gradual fluid over 48 hr, K replacement, monitor for cerebral edema warning signs (HA, AMS, paradoxical Na rise). Address trigger + psychosocial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 12 ปี known T1DM (Dx 2 yr ago) มา ED ด้วย vomiting + abdominal pain + polyuria after missed insulin 24 ชม

V/S: HR 122, BP 102/68, RR 28 (Kussmaul), SpO2 98%, BW 36 kg
Gen: alert, ill-appearing, mild dehydration

Lab: pH 7.20, HCO3 12 (moderate DKA), AG 24, Glucose 480, K 4.8 (corrected), Na 132, BUN 22, Cr 0.8, ketone urine 3+, lactate 2.5 (mild), Cl 100
No neuro deficit, no headache, no signs cerebral edema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait 24 hr observation"},{"label":"B","text":"Acute Ischemic Stroke in Sickle Cell Disease (peds stroke incidence 11% in SCD by 20 yr)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Aspirin alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Ischemic Stroke in Sickle Cell Disease (peds stroke incidence 11% in SCD by 20 yr) — peds stroke emergency: ABC + neurologic exam + emergent CT/MRI confirmed; EXCHANGE TRANSFUSION urgent — reduce HbS to < 30% — most effective acute intervention to halt ongoing stroke + reduce extension (manual or automated exchange, preferred over simple transfusion); pediatric neurology + hematology + interventional radiology + ICU; IV ALTEPLASE (tPA) — generally NOT recommended in SCD (different pathophysiology — vasculopathy + sludge rather than thromboembolic, no good evidence) + selected major centers offer in SCD adult, adult/peds general criteria <4.5 hr; pediatric tPA non-SCD: limited data, selected centers for older adolescents extrapolated adult criteria; thrombectomy — emerging in pediatric LVO stroke (limited data, selected centers); SUPPORTIVE — maintain euvolemia + normal glucose + normal Na + normal temp + adequate oxygenation + treat seizure if present + manage ICP if increased; OPTIMIZE OXYGEN delivery (transfuse Hb > 10), avoid hypoxia + hyperthermia; antiplatelet (aspirin 1-5 mg/kg/d) considered after acute phase + once exchange completed (delayed); EARLY rehab; INVESTIGATIONS — TCD historical, baseline + post-stroke MRA/cervical vessels (vasculopathy moyamoya in SCD), echo (cardioembolic), prothrombotic workup (anti-phospholipid, factor V Leiden, protein C/S — selective); secondary stroke prevention — CHRONIC TRANSFUSION program (target HbS < 30% lifelong) OR Hydroxyurea (alternative — STOP study + TWiTCH trial); long-term — hematopoietic stem cell transplant (HLA-matched sibling), GENE THERAPY (newer FDA-approved SCD), rehab, neuropsych, school IEP, family

---

Pediatric stroke in SCD = urgent exchange transfusion (reduce HbS < 30%). tPA generally NOT used in SCD (different pathophysiology). Secondary prevention: chronic transfusion or hydroxyurea + monitor TCD. HSCT or gene therapy curative options. Rehab + neuropsych long-term.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 8 ปี known sickle cell disease (HbSS) อาการเริ่ม 2 ชม ก่อน — สูญเสีย speech + right hemiparesis + facial droop + altered mental status

V/S: HR 112, BP 132/78, Temp 37.0°C, BW 22 kg
Gen: alert but dysarthric, expressive aphasia, right facial droop, right arm + leg weakness 2/5 strength, sensory loss right side, no seizure

CT head non-contrast: subtle hypodensity left MCA territory + dense MCA sign
MRI + DWI: large left MCA stroke + ADC restriction = acute ischemic stroke
TCD: previously high velocities suggesting stenosis; CBC: Hb 7.8, retic 8%; recent transfusion 1 month ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — start chemo slowly"},{"label":"B","text":"Hyperleukocytosis (WBC > 100K) + Leukostasis + Tumor Lysis Syndrome (TLS) imminent"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Transfuse aggressively"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperleukocytosis (WBC > 100K) + Leukostasis + Tumor Lysis Syndrome (TLS) imminent — pediatric oncology emergency: admit ICU + ped-onc team; AGGRESSIVE TLS prophylaxis + treatment — IV HYDRATION 2-3× maintenance (3 L/m²/d crystalloid, no K addition initially); RASBURICASE 0.15-0.2 mg/kg IV daily × 1-5 days (recombinant urate oxidase — preferred over allopurinol for high uric acid > 8 mg/dL OR rapidly rising OR organ dysfunction — converts uric acid to allantoin, rapid + effective; CAUTION G6PD deficient — methemoglobinemia + hemolysis, screen if Asian/African/Mediterranean); alternative ALLOPURINOL 10 mg/kg/d for less severe TLS risk; ALKALINIZATION controversial (urate easier excretion but increases calcium phosphate precipitation — most centers now avoid with rasburicase); CORRECT ELECTROLYTES — K (Ca gluconate IV cardiac protection + insulin/glucose + albuterol + sodium polystyrene + dialysis), P (binders + dialysis), Ca (treat hypocalcemia only if symptomatic — concern Ca-P precipitation); LEUKAPHERESIS — selected case (HOLD if asymptomatic), benefit unclear in ALL hyperleukocytosis (vs AML where established) — generally not first-line in peds ALL because rapid response to cytoreduction with steroid alone; STEROID — start prednisolone 60 mg/m²/d (initial cytoreduction prior to full chemo, gentle dose increase to avoid TLS); RAPID PROGRESSION TO CHEMOTHERAPY — induction (vincristine + steroid + asparaginase ± anthracycline) once initial stabilization; PRBC transfusion only if severe symptomatic anemia (avoid increasing viscosity → worsen leukostasis); platelet transfusion for active bleed or < 20 (NOT prophylactic transfusion may aggravate); RRT/dialysis indication — severe TLS refractory hyperK/AKI/hyperP; coagulopathy management (cryo if fibrinogen low, FFP); central line + supportive; intrathecal chemo + CNS prophylaxis later; counsel family — newer molecular subtyping + risk stratification + immunotherapy (blinatumomab, CAR-T for relapse) revolutionized outcomes (cure > 90% pre-B ALL pediatric); long-term: late effects monitoring + comprehensive cancer survivorship

---

Hyperleukocytosis + TLS = oncologic emergency. Aggressive hydration + rasburicase (or allopurinol) + correct electrolytes (K, P, Ca, uric acid). Avoid alkalinization with rasburicase. Steroid cytoreduction + rapid chemo. Leukapheresis selective. Avoid excessive PRBC (increases viscosity). Multidisciplinary ICU.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี newly diagnosed ALL ตรวจ initial WBC 380,000 (hyperleukocytosis > 100K) + clinical symptoms — confusion, dyspnea, retinal hemorrhages, headache + petechiae

V/S: HR 132, BP 102/72, RR 32, SpO2 92%, Temp 37.6°C, BW 24 kg
Gen: confused, mild distress, retinal hemorrhages, splenomegaly 5 cm

Lab: WBC 380,000 (blasts 85% — pre-B ALL), Hb 6.5, Plt 24,000, K 6.2, P 9.0, Ca 7.2, uric acid 18 (HIGH), LDH 4,820, Cr 1.4, AGMA mild, INR 1.4, fibrinogen 180 (DIC borderline)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Hepatoblastoma (most common pediatric primary liver cancer, peak 1-3 yr, very high AFP, virilization rare from beta-hCG)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Surgery without chemo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hepatoblastoma (most common pediatric primary liver cancer, peak 1-3 yr, very high AFP, virilization rare from beta-hCG) — multimodal: pediatric oncology + hepatobiliary surgery + transplant team coordinated; ALL hepatoblastoma treated per international protocols (COG/SIOPEL); NEOADJUVANT CHEMOTHERAPY — cisplatin-based (PLADO: cisplatin + doxorubicin or C5VD or as per protocol) × 4-6 cycles — shrinks tumor to allow resection; reassess RESECTABILITY POST-CHEMO with imaging; SURGICAL RESECTION — partial hepatectomy if confined to resectable anatomy (PRETEXT I, II, post-chemo III); LIVER TRANSPLANTATION (orthotopic) — for unresectable PRETEXT III/IV without extrahepatic disease — pediatric transplant center, requires donor evaluation, immunosuppression lifelong, EXCELLENT outcomes with appropriate selection (5-yr survival ~70-90%); ADJUVANT CHEMOTHERAPY post-surgery; monitor AFP — drops with effective treatment, rises with recurrence; LONG-TERM follow-up — recurrence (most within 2 yr), hearing (cisplatin ototoxicity audiology long-term), renal + cardiac (doxorubicin), secondary malignancy, growth + developmental; transition adult; PROGNOSIS — overall 5-yr survival 80%, depends on PRETEXT stage + histology + alpha-fetoprotein response + complete resection; family education + comprehensive cancer survivorship clinic; investigate associated conditions — Beckwith-Wiedemann, FAP (APC mutation), prematurity + low birth weight + parenteral nutrition risk factors

---

Hepatoblastoma = most common pediatric primary liver cancer. PRETEXT staging. Cisplatin-based neoadjuvant chemo + surgery (or transplant for unresectable) excellent outcomes. AFP marker. Cisplatin ototoxicity monitor. Associated: BWS, FAP, prematurity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี ครอบครัวคลำพบก้อน RUQ ขนาดใหญ่ + abdominal distension + เริ่มเบื่ออาหาร + น้ำหนักลด 1 kg ใน 2 mo + early puberty (signs virilization)

V/S: BW 11 kg, abdominal distension + large RUQ mass firm, no jaundice, splenomegaly absent

Lab: AFP 480,000 (extremely high — characteristic), bilirubin normal, ALT mildly elevated, hCG mildly elevated (paraneoplastic), no jaundice
US: large 12 cm hepatic mass right lobe
CT chest/abdomen: well-defined heterogeneous hepatic mass, no metastasis lung, no portal vein invasion
Biopsy: hepatoblastoma fetal/embryonal type
PRETEXT staging: III (limited resection feasibility)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Pediatric Pancreatitis (trauma-related"},{"label":"C","text":"Restrict all food + fluid weeks"},{"label":"D","text":"Prophylactic antibiotic IV"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Pediatric Pancreatitis (trauma-related — handlebar injury common cause peds): admit + ICU consideration if severe (organ dysfunction); SUPPORTIVE — primary treatment, NO specific therapy curative; FLUID resuscitation — IV crystalloid LR 1.5-2× maintenance first 24-48 hr (most important — prevents pancreatic ischemia + necrosis) — guide by clinical perfusion + UO + Hct trend, AVOID over-resuscitation; ANALGESIA — IV opioid (morphine 0.05-0.1 mg/kg q3-4h, contrary to old myth about Oddi spasm — modern evidence supports morphine + ketorolac); ANTIEMETIC; NUTRITION — EARLY ENTERAL feeding within 24-72 hr (oral or NG/NJ if cannot tolerate) — improves outcomes vs prolonged NPO (older paradigm) — start clear liquid → soft → regular; if cannot enteral → TPN; AVOID PROPHYLACTIC ANTIBIOTIC (no benefit, increased resistance); ANTIBIOTIC only for: documented infection, infected necrosis (FNA-guided), cholangitis; INVESTIGATIONS — exclude causes — trauma here, but consider gallstones (US), hypertriglyceridemia (lipid), hypercalcemia, drugs (asparaginase, valproate, steroid, thiazide), genetic (PRSS1, CFTR, SPINK1, CTRC — selected); MRCP if structural concern; ERCP for sphincterotomy/stone removal if obstructive; monitor for complications — pseudocyst (drain if symptomatic or > 6 cm + > 6 wk), necrosis (FNA + debridement step-up approach), abscess (drainage), AKI, ARDS, abdominal compartment syndrome; CHRONIC PANCREATITIS pediatric (recurrent acute → chronic) — multidisciplinary genetic + nutritional + endocrine evaluation; long-term — exocrine + endocrine insufficiency (DM, malabsorption) monitor; family education + dietary; PEDIATRIC pancreatitis usually resolves with supportive care + treat cause

---

Pediatric pancreatitis = supportive care primary. Aggressive IV fluid first 24-48 hr (prevent ischemia). EARLY enteral feeding (improves outcomes). Adequate analgesia (morphine OK). Avoid prophylactic antibiotic. Investigate cause. Trauma + biliary + drug + genetic. Complications surveillance. Long-term: chronic pancreatitis if recurrent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 10 ปี Trauma ขณะเล่นจักรยานชน handlebar เข้าท้อง 2 วันก่อน ตอนนี้ ปวดท้องรุนแรง upper abdomen + radiating to back + คลื่นไส้อาเจียน + ไข้ต่ำ

V/S: HR 122, BP 102/68, RR 22, Temp 38.0°C, BW 30 kg
Gen: distress, abdominal tenderness epigastric + RUQ, mild rebound, hypoactive bowel sounds, no peritonitis severe

Lab: lipase 3,200 (high, > 3× normal), amylase 1,840, CBC WBC 14,500, glucose 110, Cr normal, LFT mildly elevated, calcium 8.4
US abdomen + contrast CT: pancreatic edema + peripancreatic fluid + no necrosis on early CT (may evolve)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"IgA Vasculitis (HSP) with multiple severe complications"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery first immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Vasculitis (HSP) with multiple severe complications — intussusception, severe abdominal pain, nephritis nephrotic-range, scrotal involvement: admit ICU monitoring; abdominal management — surgical consultation for intussusception ileo-ileal (usually doesn''t reduce with enema; surgery if persistent + symptomatic, often resolves spontaneously in HSP); IV fluid resuscitation + bowel rest if severe abdominal pain + analgesia; SYSTEMIC CORTICOSTEROID — prednisolone 1-2 mg/kg/d IV or PO (max 60 mg/d) — INDICATIONS in HSP: severe abdominal pain, GI bleeding, intussusception, scrotal involvement, severe arthritis, evidence of severe nephritis — given for these severe complications (no clear evidence for routine cutaneous/mild disease); SEVERE NEPHRITIS (this patient — RPGN-like, nephrotic-range, AKI) — escalate immunosuppression: corticosteroid pulse methylprednisolone 30 mg/kg/d × 3 d then prednisolone; ADD cyclophosphamide IV monthly × 6 mo OR mycophenolate mofetil OR rituximab for severe progressive; ACEI/ARB for proteinuria once stable; renal biopsy CONSIDERED for severe nephritis to guide therapy + prognosis (ISKDC classification); MANAGE HT carefully (CCB or labetalol acute, ACEI/ARB long-term once stable); ORCHITIS/SCROTAL — supportive care, scrotal support, NSAID (caution renal), corticosteroid; MONITOR — BP, UA, Cr, intussusception clinical + serial US (q12-24h), GI bleeding; long-term followup — UA + BP + Cr q monthly × 6 mo (nephritis up to 6 mo post), then less frequent; chronic kidney disease 1-5% even with treatment; PROGNOSIS depend on renal involvement severity; family education recurrence 30%

---

HSP/IgAV with severe complications (intussusception, nephritis, scrotal) = treat aggressively with steroid + escalated immunosuppression if severe nephritis. Intussusception in HSP often ileo-ileal + doesn''t reduce with enema, may resolve spontaneously. Long-term renal monitoring 6 mo. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 11 ปี ก่อนหน้านี้ healthy เริ่มมีปวดท้อง severe colicky 3 วันก่อน + อาเจียน + bloody stool + palpable purpura ทั้ง 2 ขา + ปวดข้อหลายข้อย้ายที่ + ปัสสาวะปริมาณน้อย dark urine

V/S: BP 132/86 (HT in child), HR 102, BW 32 kg, mild edema
PE: extensive palpable purpura buttocks + lower legs, scrotal swelling + tenderness (HSP-orchitis), abdominal tender diffuse no peritonitis, knee + ankle effusion mild bilateral

Lab: Plt 380,000 normal, CBC mild leukocytosis, BUN 32, Cr 1.4 (high), UA — RBC casts + protein 3+, urine P:Cr 5.0 (nephrotic-range proteinuria!), albumin 2.4, complement normal
ABD US: intussusception ileo-ileal R sided + bowel wall edema; testicular US: orchitis only no torsion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge no further treatment"},{"label":"B","text":"Isolated CNS Relapse Pediatric ALL"},{"label":"C","text":"Single intrathecal dose"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Antifungal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated CNS Relapse Pediatric ALL — pediatric oncology emergency + new treatment paradigm: pediatric oncology + radiation oncology + neurology + neurosurgery + BMT team; INTRATHECAL CHEMOTHERAPY (triple therapy: methotrexate + cytarabine + hydrocortisone) intensified frequency (twice weekly × 4-6 wk then weekly × 4-8 wk to clear blasts); SYSTEMIC reinduction — high-intensity chemotherapy (high-dose methotrexate to cross BBB + dexamethasone + asparaginase + vincristine ± additional agents per protocol); CNS RADIATION THERAPY — craniospinal RT (typical 18 Gy cranial + spinal lower) AFTER chemo control + once approach end of treatment plan — irradiation reduces CNS recurrence but neurocognitive cost especially young children — modern trials reduce/omit RT if molecular/MRD control achievable + extensive chemo CNS-directed; HEMATOPOIETIC STEM CELL TRANSPLANT (allogeneic) — strongly considered for early CNS relapse < 18 mo from initial Dx + selected high-risk; CAR-T cell therapy (tisagenlecleucel — FDA approved relapsed/refractory pediatric ALL) — emerging for relapse + can penetrate CNS; blinatumomab (BiTE — anti-CD19/CD3) emerging; SUPPORTIVE — manage increased ICP with steroid (dexamethasone) + hyperosmolar therapy if symptomatic; monitor MRD (minimal residual disease) — quantitative response to therapy guides intensity; INVESTIGATIONS — exclude marrow relapse (BMA), molecular characterization (BCR-ABL, MLL, others); long-term — neurocognitive deficits from CNS RT + IT therapy (especially young), endocrinopathy from CNS RT, growth + puberty delay, secondary malignancy, cardiac (anthracycline cumulative); psychosocial + family + transition adult; treatment intensity + prognosis depend on timing relapse, MRD, immunophenotype, age; comprehensive cancer survivorship

---

Isolated CNS relapse ALL = aggressive multimodal treatment with high CR rate but worse than initial. Intensified IT + high-dose systemic + CNS-directed RT + HSCT or CAR-T for selected. Early relapse worse prognosis. Multidisciplinary cancer survivorship long-term.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 7 ปี ในช่วง maintenance phase ALL (treatment 2 yr) เริ่มปวดศีรษะ + อาเจียน morning + diplopia + papilledema bilateral 1 wk

V/S: BP 112/68, HR 92, BW 26 kg
PE: papilledema bilateral, 6th nerve palsy bilateral (false localizing), no other focal deficit, alert

Lab: CBC stable (no marrow relapse currently — Plt 220, WBC 4,200 no blasts), LFT normal, Cr normal
MRI brain + spine: leptomeningeal enhancement + multiple lesions in brain parenchyma + spinal cord
LP: WBC 35 (all blasts on cytospin), Protein elevated, Glucose normal, BLASTS confirmed = isolated CNS relapse';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue steroid forever"},{"label":"B","text":"Chronic Pediatric ITP (> 12 mo duration, intermittent bleeding, impacts quality of life)"},{"label":"C","text":"Splenectomy immediately"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pediatric ITP (> 12 mo duration, intermittent bleeding, impacts quality of life) — beyond first-line: pediatric hematology specialist + ASH 2019 + 2024 updates; INDICATIONS to treat (vs observe) — significant bleeding, lifestyle impact, contact sports involvement, surgery planning; FIRST-LINE for chronic ITP — TPO RECEPTOR AGONISTS (revolutionized — non-immunosuppressive, oral, well-tolerated): ELTROMBOPAG ≥ 1 yr FDA-approved (25-75 mg/d oral, take fasting + 4 hr after polyvalent cations, monitor LFT cataract eye exam) OR ROMIPLOSTIM ≥ 1 yr (SC weekly injection, dose-adjusted by platelet response); ~70-80% response rate; PREDNISOLONE pulses (rather than chronic) — short courses for bleeds or surgeries; IVIG — short-term boost for severe bleed or pre-surgery (rapid effect); RITUXIMAB (anti-CD20) — second-line, durable response 30-40%, side effects + immunosuppression; FOSTAMATINIB (SYK inhibitor) — oral newer alternative; SPLENECTOMY — historically curative ~70%, but now reserved for refractory after TPO-RA fail + > 6 yr age (immune maturity) + counseling about lifelong infection risk + vaccinations pre + post (pneumococcal, meningococcal, Hib, influenza) + penicillin prophylaxis 5+ yr; HEAVY MENSES — TXA + COC (combined OCP) for menstrual control; ACTIVITY — generally allow normal activity with awareness, avoid contact sports if Plt < 30K; MEDICAL ALERT bracelet; FAMILY education emergency response + when to seek care; long-term watch for chronic disease, autoimmune comorbidity, secondary malignancy considerations; psychosocial support adolescent + transition adult

---

Chronic pediatric ITP (> 12 mo) — TPO receptor agonists (eltrombopag, romiplostim) revolutionized (oral, non-immunosuppressive, ~70-80% response). Rituximab + fostamatinib alternatives. Splenectomy reserved + delayed > 6 yr. Treat based on bleeding/lifestyle, not just count. ASH 2019/2024.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 9 ปี diagnosis ITP 14 mo ago + ได้รับ IVIG + steroid + รักษาแล้ว ตอนนี้ Plt count vary 8,000-30,000 chronic ITP > 12 mo + petechiae + minor bleeding + บางครั้ง heavy menses (post-menarche 1 yr) + ผลกระทบ activity

V/S: BW 32 kg, intermittent petechiae + bruising, no severe bleeding currently

CBC: Hb 11.0, WBC normal, Plt 12,000
Bone marrow biopsy (done 1 yr ago): normal megakaryocytes, no abnormality = ITP
No connective tissue disease evidence (ANA negative, normal complement)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Alport Syndrome (X-linked, COL4A5 type IV collagen"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alport Syndrome (X-linked, COL4A5 type IV collagen — affects glomerular basement membrane, cochlea, lens) — long-term progressive renal disease management: nephrology + ophthalmology + audiology + genetics + multidisciplinary; RENIN-ANGIOTENSIN-ALDOSTERONE SYSTEM (RAAS) blockade EARLY — ACEI (lisinopril, enalapril, ramipril) titrated to maximum tolerated dose (proteinuria reduction primary) — STARTING when proteinuria detected, slows progression; ARB if ACEI not tolerated; spironolactone aldosterone receptor antagonist add-on; SGLT2 inhibitor (dapagliflozin, empagliflozin) emerging — recent evidence reduces progression in CKD including Alport; bardoxolone (Nrf2 activator) — recent FDA approval emerging; counsel about lifelong progression to ESRD (males X-linked 90% by age 30); ANNUAL — BP monitoring + UA + Cr + GFR + audiology + ophtho (cataract + anterior lenticonus); HYPERTENSION management — RAAS blockade + diuretics + add as needed; AVOID nephrotoxin (NSAID, aminoglycoside, contrast); HEARING aids when indicated; ophthalmology for lenticonus + cataract; PREPARE FOR ESRD — late teens to adult — dialysis + KIDNEY TRANSPLANT (preferred — successful long-term, but risk of post-transplant anti-GBM antibodies in some — rare complication needing monitoring + immunosuppression coordination); GENETIC COUNSELING + family screen — X-linked (males severe, females carrier — variable severity), AR + AD forms exist (COL4A3/COL4A4 — Alport variant); prenatal/preimplantation diagnosis available; education adolescence + transition adult nephrology; psychosocial support; gene therapy in development

---

Alport syndrome = inherited basement membrane disease (X-linked most). Progressive nephritis + sensorineural hearing loss + ocular changes. Early ACEI/ARB slow progression. SGLT2i emerging. Most males progress to ESRD → transplant. Genetic counseling. Family screen. Multispecialty.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 8 ปี persistent microscopic hematuria > 1 yr + intermittent gross hematuria after URI + mild proteinuria new + family Hx — มี uncle (mother''s brother) ESRD age 25 with bilateral sensorineural hearing loss + cousin had similar

V/S: BP 110/72 normal, BW 26 kg
PE: anterior lenticonus on slit-lamp + retinal flecks, normal exam otherwise
Audiometry: bilateral high-frequency sensorineural hearing loss

Lab: Cr 0.7 normal, UA — RBC 50+, dysmorphic, mild protein 1+, UP/UCr 0.4, complement normal
Family Hx + clinical features = X-linked Alport syndrome
Kidney biopsy + EM: basement membrane splitting + lamellation + thinning = Alport
Genetic testing: COL4A5 mutation positive (X-linked)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Mucopolysaccharidosis Type I Hurler (severe form, IDUA deficiency"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Surgery alone"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mucopolysaccharidosis Type I Hurler (severe form, IDUA deficiency — autosomal recessive) — multidisciplinary lifelong care: HEMATOPOIETIC STEM CELL TRANSPLANTATION (HSCT, allogeneic) — best treatment if performed EARLY (< 2 yr ideally, before significant CNS damage) — donor cells produce enzyme + provide enzyme delivery to CNS via crossing BBB (limited but partial), improves longevity + cognition + organomegaly — DECISION POINT NOW given age + severe form; ENZYME REPLACEMENT THERAPY (ERT) — Laronidase (Aldurazyme) IV weekly — does NOT cross BBB so does NOT prevent CNS deterioration in severe form (Hurler), but improves visceral disease + reduces airway/hepatosplenomegaly — typically GIVEN PERIOPERATIVELY when planning HSCT and continued long-term as adjunct; SUPPORTIVE — multispecialty annual evaluation: cardiology (valve disease — surgery may be needed), ENT (airway, AOM, hearing loss, OSA — adenotonsillectomy), ophtho (corneal clouding, glaucoma, retinopathy), neurology (cervical cord compression — RISK ANESTHESIA), orthopedic (carpal tunnel, hip dysplasia, kyphosis), neurosurgery (hydrocephalus → VP shunt), pulmonology (restrictive lung), gastroenterology, audiology, dental; PHYSICAL + OCCUPATIONAL therapy; ANESTHESIA CARE — extremely high risk (airway difficult, cervical instability, restrictive lung, valve disease) — anesthesia consult before procedures; ATTAINTIVES — gene therapy clinical trials emerging (autologous transduced HSC); substrate reduction therapy + intrathecal ERT investigational; FAMILY genetic counseling + carrier testing siblings; prenatal/preimplantation testing for future pregnancy; psychosocial support; transition adult metabolic — though severe Hurler historically died by age 5-10 without treatment, modern HSCT + ERT improves longevity

---

MPS Hurler = severe form, IDUA deficiency. Multisystem (face, viscera, joints, eye, brain, cardiac, airway). HSCT early (< 2 yr) for severe + ERT (laronidase) for visceral but limited CNS. High anesthesia risk. Gene therapy emerging. Multidisciplinary lifelong + family genetic counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 18 mo คุณแม่กังวล — coarse facial features + recurrent URI + macrocephaly + corneal clouding + hepatosplenomegaly + cardiac murmur + delayed development + stiff joints + claw hand + กระดูกอ่อนผิดรูป (dysostosis multiplex)

PE: characteristic coarse face, large tongue, depressed nasal bridge, hepatosplenomegaly, lumbar gibbus, corneal clouding bilateral mild, joint contractures hands, BW + height < 3rd percentile

Lab: urine glycosaminoglycans (GAGs) markedly elevated; alpha-L-iduronidase enzyme: severely deficient → Hurler syndrome (MPS-I, severe form, IDUA gene autosomal recessive)
Echo: thickened mitral + aortic valves + mild LVH';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single drug cure"},{"label":"B","text":"Mitochondrial Disease (multisystemic"},{"label":"C","text":"Valproic acid"},{"label":"D","text":"Surgery curative"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitochondrial Disease (multisystemic — features overlap Kearns-Sayre/Leigh syndrome/MELAS): NO CURATIVE TREATMENT — symptomatic + supportive multidisciplinary lifelong; AVOID precipitants — STARVATION (frequent meals, avoid fasting > 4-6 hr, complex carbs at bedtime), DEHYDRATION (adequate hydration always), METABOLIC STRESS (illness/fever — early aggressive treatment with IV fluid + glucose); AVOID drugs that impair mitochondrial function — VALPROIC ACID (HEPATOTOXICITY in mitochondrial), aminoglycosides (deafness), high-dose steroid, anesthetic ketamine + thiopental + nitrous (use propofol total IV anesthesia with caution, avoid prolonged propofol — PRIS); SUPPLEMENT ''MITO COCKTAIL'' (evidence variable but commonly used): COENZYME Q10 (ubiquinone) 5-10 mg/kg/d, CARNITINE 50-100 mg/kg/d (if low), VITAMIN C + E (antioxidants), B vitamins (riboflavin 100 mg/d, thiamine, B12, folate), ARGININE (especially MELAS for stroke-like episodes — 0.5 g/kg orally daily prophylactic, 0.5 g/kg IV acute episode); CREATINE supplementation; address ACUTE LACTIC ACIDOSIS — IV fluid + dextrose, BICARBONATE only severe symptomatic (controversial); DIETARY — frequent small meals, complex carb at bedtime, may benefit from ketogenic diet (selected complex I deficiency); EXERCISE — moderate aerobic exercise improves mitochondrial biogenesis (paradoxically); MULTISYSTEM management — cardiology (cardiomyopathy, conduction defects — Kearns-Sayre block — PACEMAKER may be needed), ophthalmology (PEO, retinopathy), audiology (hearing aids), endocrine (diabetes, hypothyroid, growth issues), neurology (stroke-like episodes, epilepsy, dystonia), GI (dysmotility), nephrology (Fanconi); PT/OT; nutritional support — G-tube selected; genetic counseling — mitochondrial inheritance (mtDNA = maternal, heteroplasmy variable transmission; nDNA = autosomal); EMERGING — gene therapy + mitochondrial replacement therapy (legal in some countries); family support + transition adult

---

Mitochondrial disease = heterogeneous multisystem disorders. No cure. Supportive + ''mito cocktail'' (CoQ10, carnitine, vit B/C/E, arginine for MELAS). AVOID valproate (hepatotoxic), aminoglycosides, prolonged anesthetics. Avoid metabolic stress. Multidisciplinary. Mitochondrial inheritance counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 5 ปี multiple system involvement — developmental regression starting 2 yr + episodic vomiting + lactic acidosis episodes + ptosis bilateral + exercise intolerance + hearing loss bilateral + retinopathy + short stature + lactic acidemia

V/S: BW 14 kg (< 3rd %), HR mildly tachycardic, no acute distress
PE: ptosis bilateral, ophthalmoplegia, retinopathy on fundoscopy, sensorineural hearing loss bilateral, no rash

Lab: lactate 6.2 (HIGH chronic), pyruvate elevated, lactate/pyruvate ratio elevated, plasma amino acids — alanine high (chronic acidosis), urine organic acids — Krebs cycle intermediates abnormal; CK mildly elevated; CSF lactate elevated
Muscle biopsy: ragged red fibers + decreased COX staining + abnormal mitochondria EM; mtDNA testing: large deletion confirmed (Kearns-Sayre vs other)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Iron supplementation indefinite"},{"label":"B","text":"Alpha Thalassemia Trait (alpha-thal carrier, --SEA common Thai/Southeast Asian)"},{"label":"C","text":"Blood transfusion"},{"label":"D","text":"Splenectomy"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alpha Thalassemia Trait (alpha-thal carrier, --SEA common Thai/Southeast Asian): NO TREATMENT NEEDED for trait/carrier; reassurance — life expectancy normal, mild microcytosis lifelong, no clinical consequence to individual; DIFFERENTIATE from iron deficiency anemia (similar microcytic but iron studies + normal RDW + family hx + DNA help distinguish — KEY: IDA = high RDW + low ferritin + low TSAT; alpha-thal trait = normal/low normal RDW + normal iron studies + family history); AVOID UNNECESSARY iron supplementation — does not help thalassemia trait + can cause iron overload long-term; counsel family about INHERITANCE — autosomal recessive, both parents trait → 25% offspring may have Hb H disease (3 gene deletion — moderate disease, lifelong) OR Hb Bart hydrops fetalis (4 gene deletion --/-- = lethal in utero — severe consequence!); PREMARITAL / PRECONCEPTION COUNSELING crucial for couple with both alpha-thal trait — option of prenatal diagnosis (CVS, amnio) + preimplantation genetic diagnosis (PGD); national screening program Thai for thalassemia common (high prevalence Thailand 30-40% trait); reproductive education for the patient when older; OTHER ASIAN COUNTRY screening similar; recognize the family genetic implications + offer testing siblings + family; routine pediatric care otherwise; CBC follow-up; routine vaccinations; document allergy + thalassemia trait medical record; consider HPLC + DNA confirmation if uncertain

---

Alpha-thal trait = common in Southeast Asia, Mediterranean. Asymptomatic carrier. NO TREATMENT needed. Important: DIFFERENTIATE from IDA (RDW + iron studies). Avoid unnecessary iron. CRITICAL: GENETIC COUNSELING for couples — both trait → 25% Hb H disease or HYDROPS FETALIS (lethal). Premarital screening + prenatal diagnosis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 4 ปี ตรวจ routine CBC พบ Hb 10.2 (mild anemia) + MCV 65 (microcytic), MCH 21, MCHC normal, RDW 12.5 (NORMAL, not elevated), Plt + WBC normal, Retic 1.8% (normal)

Dietary: balanced, adequate iron-rich foods, breastfed first year + appropriate formula transition, no excessive milk, no recent illness
Family: parents both alpha-thalassemia trait, paternal grandfather Mediterranean origin

Iron studies normal — ferritin 65, TSAT 24%, iron + TIBC normal
Hb electrophoresis: HbA 95%, HbA2 normal, HbF normal (alpha-thalassemia electrophoresis often normal — DNA testing needed)
DNA testing α-globin: alpha-thalassemia trait (heterozygous α/-- or --SEA confirmed)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Mumps with Orchitis (post-pubertal complication 15-30% males)"},{"label":"C","text":"Discharge home no precautions"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Steroid only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mumps with Orchitis (post-pubertal complication 15-30% males): supportive care — no specific antiviral (viral self-limited); pain control — acetaminophen, ibuprofen, scrotal support + ice; bed rest, hydration; antiviral — interferon-alpha investigational, not standard; ISOLATION — droplet precautions until 5 days after parotitis onset (highly contagious); steroid use for orchitis controversial — some recommend short course prednisolone 1 mg/kg/d × 3-5 d for severe orchitis to reduce pain + possible fertility impact (evidence limited); WATCH for OTHER COMPLICATIONS — meningitis/encephalitis (1-10%, CSF mononuclear pleocytosis), oophoritis (post-pubertal females), pancreatitis (5%), deafness (sensorineural, sudden 5/10,000), arthritis, myocarditis, thyroiditis; LP if meningoencephalitis suspected (severe HA + AMS + nuchal rigidity); audiogram follow-up at recovery + 3 mo (hearing loss); FERTILITY counsel — orchitis MAY cause testicular atrophy + reduced fertility in 15-30% of orchitis cases, BILATERAL infrequent but more concerning, true sterility rare (~13% unilateral, < 30% bilateral); REPORT — public health (reportable disease); CONTACTS — vaccinate susceptible contacts within 72 hr (MMR), counsel pregnancy contact (vaccine contraindicated pregnancy + immunocompromised); PREVENTION — MMR vaccine 2 dose (Thai EPI + CDC) — outbreaks in undervaccinated communities (booster recommended outbreak settings, third MMR can boost waning immunity per CDC outbreak guidance); long-term — most fully recover, document immunity status for family + patient + reproductive counseling

---

Mumps + orchitis = post-pubertal complication (testicular atrophy + reduced fertility, rare bilateral sterility). Supportive treatment, scrotal support + analgesia, droplet isolation 5 d post-parotitis. Watch other complications (meningitis, deafness, pancreatitis). MMR 2-dose prevention + outbreak boost. Reportable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 13 ปี vaccine ไม่ครบ (missed MMR booster) ปวด + บวม parotid gland bilateral + ไข้ + ปวดศีรษะ + ตึงคอ × 4 d, ตอนนี้ ปวด testicle ข้างขวา + บวมแดง 24 ชม + ไข้สูง ใหม่

V/S: HR 102, RR 22, Temp 38.8°C, BW 38 kg
PE: bilateral parotid swelling + tender, right scrotal swelling + erythema + tender testicle (epididymo-orchitis), no peritoneal sign, no meningeal stiffness severe

Lab: amylase elevated (parotitis), lipase normal (pancreas not), CBC mild lymphocytosis
Mumps IgM positive + RT-PCR positive; HSV negative; bacterial culture negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Iron supplementation alone"},{"label":"B","text":"Acute Autoimmune Hemolytic Anemia warm-IgG (post-viral/Mycoplasma + EBV-associated)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Autoimmune Hemolytic Anemia warm-IgG (post-viral/Mycoplasma + EBV-associated): admit; ABC + monitor; supportive — adequate hydration (alkalinize urine to prevent renal damage from hemolysis), monitor renal function + electrolytes; PRBC TRANSFUSION carefully if symptomatic severe anemia (Hb < 5 or symptomatic) — challenge: ALL units may be incompatible due to autoantibody panreactive — emergency ''least incompatible'' units selected by blood bank in consultation; slow transfusion with vigilant monitoring; FIRST-LINE — CORTICOSTEROID — prednisolone 1-2 mg/kg/d (max 60 mg) PO OR methylprednisolone IV equivalent — typically 70-80% response, slow taper over months once Hb stabilizes; AVOID PREMATURE STEROID TAPER (relapse common); IVIG 1-2 g/kg in selected cases — short-term boost or if hemolysis severe; FOLIC ACID 1 mg/d (increased demand); REFRACTORY OR RELAPSED — second-line — rituximab (anti-CD20) increasingly first-line or early second in AIHA (especially pediatric — fewer side effects than long-term steroid, durable response); other options: cyclosporine, MMF, azathioprine, danazol; SPLENECTOMY rarely needed kids (long-term infection risk + many spontaneous remission); investigate UNDERLYING — viral (EBV, CMV, Mycoplasma — supportive), drug-induced (review meds), autoimmune (ANA, lupus serology), lymphoproliferative (rare child but consider if persistent), Evans syndrome (AIHA + ITP); thromboprophylaxis selected (AIHA + LE/APS + immobile); patient + family education + monitor recovery; isolation if Mycoplasma or other infectious cause; long-term most children RECOVER with treatment (vs adult AIHA which can be chronic)

---

AIHA pediatric usually warm-IgG, often post-viral. Coombs+, hemolysis labs, splenomegaly. Treat with steroid first-line + RBC transfusion carefully (least incompatible). Rituximab second-line increasingly first-line in pediatrics. Long-term recovery typical in kids. Investigate underlying viral/autoimmune.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี เริ่มซีดอย่างรวดเร็ว + เหนื่อย + ปัสสาวะสีโคล่า dark + ตาเหลือง 3 วัน ก่อนหน้านี้เป็น viral URI 1 สัปดาห์

V/S: HR 132, BP 102/68, RR 24, Temp 37.6°C, BW 20 kg, jaundice
PE: pallor, jaundice, splenomegaly 2 cm BCM, no lymphadenopathy, no organomegaly other

Lab: Hb 5.2 (acute drop from baseline 12), MCV 105 (macrocytic — reticulocytosis), retic 18% (HIGH), LDH 980, haptoglobin LOW, indirect bilirubin 6.2 elevated, direct Coombs POSITIVE (warm IgG), no schistocytes, Plt + WBC normal
Negative ANA, normal complement, no recent drug, viral panel positive Mycoplasma + EBV recent';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — child usually self-resolves"},{"label":"B","text":"Conscious child with foreign body airway obstruction (FBAO) complete"},{"label":"C","text":"Wait — observe at home"},{"label":"D","text":"Mouth-to-mouth without addressing"},{"label":"E","text":"Discharge home no assessment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conscious child with foreign body airway obstruction (FBAO) complete — AHA BLS algorithm: assess universal sign of choking + inability to speak/cough/breathe = COMPLETE OBSTRUCTION; for CONSCIOUS child > 1 yr → ABDOMINAL THRUSTS (Heimlich maneuver) — stand or kneel behind child, place fist (thumb-side) above navel + below ribcage, grasp with other hand, quick upward thrusts × 5 + reassess + repeat until expelled OR unconscious; for INFANT < 1 yr (different) → 5 back blows (between scapulae) + 5 chest thrusts (sternum compression), alternating until expelled or unconscious; if UNCONSCIOUS → start CPR, lower onto firm surface, BEGIN compressions first (per current AHA — compressions may expel FB), 30 compressions then look in mouth for visible FB before breaths (DO NOT blind finger sweep), if FB visible — remove with finger, then 2 breaths if possible, continue CPR; call EMS 1669 (Thailand) immediately; transport once secured (FB removed or in ALS hands); after expulsion → assess + observe (may have lower airway/post-obstruction issues), seek medical care for airway trauma, residual aspiration, swallowing/respiratory function evaluation; AVOID — back blows in standing conscious > 1 yr (per current AHA peds — abdominal thrusts preferred), blind finger sweep (may push FB deeper); PREVENTION — choking-hazard foods (round/hard/smooth — grapes, nuts, hot dogs, hard candy, popcorn, marshmallow), supervise during meals, no eating + running, age-appropriate food, food cut into small pieces, parent CPR training, choking awareness; for severe cases beyond BLS → ALS, emergency cricothyroidotomy (last resort), rigid bronchoscopy if at hospital

---

FBAO = AHA BLS algorithm. Conscious > 1 yr — abdominal thrusts (Heimlich). Infant < 1 yr — back blows + chest thrusts. Unconscious — CPR (compressions first), check mouth between cycles (no blind sweep). Call EMS. Prevention — supervised meals, no choking hazard foods.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 4 ปี กำลังกินขนมเชอรี่ + พูด + จู่ ๆ ก็เริ่มไอ + grasps throat + ไม่สามารถพูดได้ + cyanosis เริ่ม + ไม่สามารถหายใจ

Conscious + standing + alert + signs choking universal sign (clutching throat)
ไม่สามารถ cry, no air movement, สีฟ้า

สถานการณ์ critical airway obstruction full';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic immediately"},{"label":"B","text":"Viral Upper Respiratory Infection (common cold, rhinovirus most common)"},{"label":"C","text":"Strict bed rest"},{"label":"D","text":"Steroid"},{"label":"E","text":"Discharge with no education"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Viral Upper Respiratory Infection (common cold, rhinovirus most common): supportive care — adequate hydration, rest, humidification; saline nasal drops/sprays + gentle suction for nasal congestion (especially infants who are obligate nose breathers); honey for cough ≥ 1 yr (NOT < 1 yr — botulism risk) — better than dextromethorphan in trials; ACETAMINOPHEN or IBUPROFEN for fever > 38.5 + discomfort (alternate not recommended routinely); AVOID — over-the-counter cough/cold medicine < 6 yr (FDA + AAP warn, no efficacy + side effects), antibiotic (no benefit for viral, increases resistance), antihistamine for cold (no benefit + sedation), decongestant nasal spray (rebound + side effects); EDUCATION family — typical course 7-10 days, peak day 3-5, cough may persist 2-3 wk; return precautions — high fever > 3-4 d, difficulty breathing, dehydration, ear pain, persistent symptoms > 10 d (suggests bacterial sinusitis), worsening; PREVENTION — handwashing, avoid sharing utensils, cover cough/sneeze, stay home when sick, annual influenza vaccination, breastfeeding; address — daycare/school exclusion until fever-free 24 hr (without antipyretic) + well-appearing; education on hand hygiene + when to seek medical care

---

URI = common cold, viral self-limited. Supportive care only. AVOID antibiotic + OTC cough/cold meds < 6 yr + decongestant spray. Honey for cough > 1 yr. Education family on course + return precautions + prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 2 ปี ไข้ต่ำ 38.0°C + น้ำมูก clear + ไอเล็กน้อย + เจ็บคอ × 3 วัน ไม่มีหอบเหนื่อย ไม่มี ear pain, well-appearing, กินดี, เล่นได้, ดูแข็งแรง

V/S: HR 102, RR 28, SpO2 99%, Temp 38.0°C, BW 12 kg
PE: clear rhinorrhea, mild pharyngeal erythema, tympanic membranes normal, lungs clear, no LN, normal exam

No medical Hx, vaccines up-to-date';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antiviral alone"},{"label":"B","text":"Acute Bacterial Sinusitis (criteria AAP"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Wait 4 weeks"},{"label":"E","text":"Surgery first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Bacterial Sinusitis (criteria AAP — persistent > 10 d without improvement, OR worsening, OR severe onset with fever > 39°C + purulent discharge ≥ 3 d): antibiotic indicated; AMOXICILLIN 45 mg/kg/d ÷ q12h × 10 d (standard dose first-line) OR HIGH-DOSE AMOXICILLIN-CLAVULANATE 90 mg/kg/d ÷ q12h × 10 d (for: recent antibiotic < 30 d, daycare attendance, < 2 yr, severe disease, persistent症; better coverage of resistant Strep pneumo + H flu + M cat); duration 10 d for uncomplicated; alternatives for true penicillin allergy — cefdinir, cefuroxime, cefpodoxime, levofloxacin (anaphylaxis); supportive — saline nasal irrigation, decongestant short-term (< 5 d, no rebound), analgesia; AVOID antihistamine (thickens secretions), oral decongestant routine; reassess 48-72 hr — if not improving → switch to amox-clav or add 3rd-gen cephalosporin (ceftriaxone IM 50 mg/kg × 1-3 d); RED FLAGS for complications — eye involvement (preseptal vs orbital cellulitis, abscess, vision change, ophthalmoplegia, proptosis = ORBITAL COMPLICATIONS, EMERGENCY imaging + IV antibiotic + ENT/ophthalmology), intracranial complications (severe HA, AMS, focal deficit, fever, seizure = MENINGITIS, ABSCESS, CAVERNOUS SINUS THROMBOSIS); osteomyelitis frontal bone (Pott puffy tumor); admit + IV antibiotic for complications; recurrent sinusitis — workup immunodeficiency, allergy, anatomic abnormality, CF, primary ciliary dyskinesia

---

Acute bacterial sinusitis criteria AAP. Amoxicillin standard OR amox-clav for risk factors. Duration 10 d. Watch for orbital + intracranial complications (eye signs, neuro signs = emergency). Recurrent = workup underlying.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 6 ปี URI symptoms × 12 วันโดยไม่ดีขึ้น + ปวดที่หน้าผาก + คัดจมูก purulent yellow-green discharge + ไอเรื้อรัง + ไข้ + halitosis + กรอบตาบวมเล็กน้อย morning

V/S: HR 92, RR 22, Temp 38.0°C, BW 22 kg
PE: tender to palpation maxillary + frontal sinuses, purulent nasal discharge, mild periorbital edema (no proptosis or visual disturbance), no other findings

Diagnosis acute bacterial sinusitis based on AAP criteria: persistent symptoms > 10 d without improvement + worsening + severe onset';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic"},{"label":"B","text":"Hand-Foot-Mouth Disease (HFMD, enterovirus most commonly Coxsackie A16, also A6 atypical severe, EV-71 with neurological complications)"},{"label":"C","text":"Steroid"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Discharge no education"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hand-Foot-Mouth Disease (HFMD, enterovirus most commonly Coxsackie A16, also A6 atypical severe, EV-71 with neurological complications): supportive care — viral self-limited 7-10 d; hydration KEY (oral aversion from painful oral ulcers — offer cold liquids, popsicles, smooth food, avoid acidic/spicy); PAIN — acetaminophen + ibuprofen; topical analgesic — viscous lidocaine (CAUTION young child — local application only, not ''magic mouthwash'' with diphenhydramine due to systemic toxicity in young kids — recently FDA warned); cool foods (ice cream, smoothies, popsicles, yogurt); soft bland diet; SCHOOL/DAYCARE — exclude until fever resolved + lesions crusted (drooling/lesion contagious, fecal-oral persists weeks); CONTACT precautions + hand hygiene + sanitize toys/surfaces; usually no specific antiviral (investigational pleconaril); MONITOR for COMPLICATIONS (mostly EV-71) — neurological (aseptic meningitis, encephalitis, brainstem encephalitis, polio-like paralysis, AFM acute flaccid myelitis), cardiorespiratory (pulmonary edema, myocarditis can be fatal), dehydration from poor oral intake; admit if: severe dehydration, neurological symptoms, persistent high fever, age < 6 mo, immunocompromised, refusal of liquids; ATYPICAL HFMD (Coxsackie A6) — more severe vesicles widespread + onychomadesis (nail shedding) weeks later; EV-71 outbreaks Asia + Australia 2010s significant; EV-71 vaccine in development + available China; reportable in some regions; PRIMARY PREVENTION — handwashing + hygiene + disinfection; secondary attack rate in households high

---

HFMD = enterovirus (Coxsackie A16 common; EV-71 severe with neurological + cardiopulmonary complications). Supportive + hydration + pain. Daycare/school exclusion fever-free + lesions. Watch EV-71 complications (encephalitis, AFM, pulmonary edema). Hygiene prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 3 ปี วันที่ 2 ของไข้ต่ำ + เจ็บปาก + ปฏิเสธอาหาร + พบ vesicles ในปาก + บริเวณฝ่ามือ ฝ่าเท้า + ก้น well-appearing แต่กินไม่ค่อย

V/S: HR 102, Temp 38.2°C, BW 14 kg, no dehydration
PE: ulcerative vesicular lesions oral mucosa (palate, tongue, buccal), papulovesicular rash hands + feet + buttocks, no rash on trunk, no respiratory distress, no neuro deficit

Daycare outbreak; suspected Coxsackie A16 or Enterovirus 71 (EV-71 higher complications)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Routine bronchodilator + steroid"},{"label":"B","text":"Mild Bronchiolitis (alert + feeding > 50% + no severe distress + SpO2 ≥ 92% + age > 3 mo with no apnea)"},{"label":"C","text":"Antibiotic IV"},{"label":"D","text":"Chest physiotherapy"},{"label":"E","text":"Hospitalization always"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mild Bronchiolitis (alert + feeding > 50% + no severe distress + SpO2 ≥ 92% + age > 3 mo with no apnea): outpatient management appropriate — supportive care mainstay per AAP 2014 guideline; reassure family — typical course 5-7 days symptoms peak day 3-5, total 14-21 days cough lingers, self-limited; nasal saline drops/spray + gentle bulb suction before feeds + sleep — opens nasal airway (infant obligate nasal breather), improves feeding + sleep; humidified air; CONTINUE breastfeeding/formula — small frequent feeds; tylenol/ibuprofen for fever > 6 mo (only acetaminophen < 6 mo); AVOID per AAP 2014 — routine bronchodilator (no benefit shown), routine steroid (no benefit + concerns), antibiotic (viral + no benefit), chest physiotherapy (no benefit + may distress), epinephrine nebulizer (limited benefit), hypertonic saline (mixed evidence outpatient); RETURN PRECAUTIONS — increased work of breathing/retractions, RR > 60-70, decreased feeding < 50%, dehydration, apnea, cyanosis, lethargy, fever > 38.5 persistent, age < 3 mo, immunocompromised, chronic medical condition; OFFICE FOLLOW-UP 24-48 hr if concern; PREVENTION — RSV palivizumab prophylaxis for high-risk (preterm, BPD, CHD, immunocompromised) during RSV season; NIRSEVIMAB (new RSV monoclonal antibody) FDA-approved for ALL infants in first RSV season — single SC dose, broader use than palivizumab; maternal RSV vaccination during pregnancy 32-36 wk protects infant; handwashing + smoke avoidance; admit if: severe distress, hypoxia < 92%, dehydration, apnea, < 3 mo high-risk, poor caregiver capacity

---

Mild bronchiolitis = outpatient + supportive. AAP 2014: NO routine bronchodilator/steroid/antibiotic/chest PT. Saline nasal + suction + small frequent feeds. Education + return precautions. NEW prevention: nirsevimab (broader than palivizumab) all infants + maternal RSV vaccine.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 3 mo BW 5.5 kg ไข้ต่ำ + ไอ + ดูดนมน้อยลง 24 ชม ก่อนหน้า 4 วัน เป็นหวัด พี่ที่บ้านเพิ่งเป็น URI

V/S: HR 162, RR 56, SpO2 95% room air, Temp 37.6°C
Gen: alert, มี wheeze เบา + few crackles bilateral, mild retraction subcostal, no nasal flaring severe, no cyanosis, no apnea, taking 70% normal feed orally

CBC routine not necessary; CXR not routine indicated; RSV antigen + (not required for diagnosis)
Severity: MILD bronchiolitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — observe + no education"},{"label":"B","text":"Conjunctivitis pediatric"},{"label":"C","text":"Topical steroid alone"},{"label":"D","text":"Surgical eye procedure"},{"label":"E","text":"Antifungal drops first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conjunctivitis pediatric — bacterial vs viral approach: most pediatric conjunctivitis bacterial (Strep pneumo, H. influenzae most, especially with concurrent AOM = ''conjunctivitis-otitis syndrome'') vs adult viral predominance; bacterial features — mucopurulent discharge prominent + matted lids especially morning, can be bilateral; viral features — clear/watery discharge + preauricular adenopathy + concurrent URI; in pediatric, EMPIRIC TOPICAL ANTIBIOTIC commonly used (although meta-analyses suggest most bacterial self-resolve, antibiotic shortens duration + return to school + treats concurrent OM if missed) — ERYTHROMYCIN ophthalmic ointment 0.5% ¼ inch ribbon to lower lid 4-6× daily × 5-7 d OR Polymyxin B/trimethoprim ophthalmic drops 1 drop q4-6h × 5-7 d OR Sulfacetamide drops × 5-7 d; AZITHROMYCIN 1% drops 1 drop BID × 2 d then daily × 5 d; fluoroquinolone drops for severe/contact lens; AVOID — Neomycin (allergy frequency), steroid drops (NO STEROID in conjunctivitis EVER without ophthalmology — masks HSV/bacterial worsening); EYE HYGIENE — warm compress + gentle wipe with sterile saline cotton; remove + DISCARD contact lenses; HANDWASHING + no eye rubbing + own towel/pillowcase; RETURN TO SCHOOL — 24 hr after antibiotic start typically (varies by school) + crusting clears; OPHTHALMOLOGY REFERRAL — moderate-severe pain, photophobia, visual changes, contact lens wear, foreign body, copious discharge (gonorrhea — STAT), unilateral, allergic refractory, neonatal conjunctivitis (different — silver nitrate or erythromycin prophylaxis newborn standard, gonorrhea/chlamydia in newborn), HSV (vesicles + corneal involvement); ALLERGIC conjunctivitis — bilateral + intense itching + clear watery + tearing + concurrent rhinitis — treat with antihistamine drops

---

Pediatric conjunctivitis = often bacterial (vs adult viral). Bacterial — purulent + matted lids. Empiric topical antibiotic (erythromycin, polymyxin/trimethoprim, azithromycin) shortens course. AVOID topical steroid (masks HSV). Refer if severe/contact lens/visual change/atypical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 5 ปี ตื่นเช้ามาตาแฉะ + ขี้ตาเป็น crust + ตาแดง 2 ข้าง 2 d ก่อน + URI ตอนนี้ asymptomatic อื่น ๆ ดี ไม่มีไข้ ไม่มีปวด ไม่เห็นไม่ดีลง daycare + เพื่อนคนหนึ่งเป็นเหมือนกัน

V/S: ปกติ, BW 20 kg
PE: bilateral conjunctival injection + mucopurulent discharge mild + crust eyelid (worst morning) + preauricular LN absent, no proptosis, no photophobia, visual acuity normal, no foreign body sensation, no contact lens use
No signs systemic — measles, KD, herpes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Severe Bronchiolitis + apnea + impending failure (high-risk profile"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral oseltamivir"},{"label":"E","text":"Steroid IV high dose"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Bronchiolitis + apnea + impending failure (high-risk profile: < 12 wk, apnea, severe distress, hypoxia, dehydration, rising PaCO2): admit ICU; close monitoring continuous SpO2 + cardiac + respiratory; HFNC HIGH-FLOW NASAL CANNULA 1-2 L/kg/min FiO2 titrated (first-line respiratory support, reduces intubation 30-50% per recent peds trials, especially severe bronchiolitis) — better than standard low-flow O2 or face mask; nasal CPAP if HFNC insufficient (5-7 cmH2O); INTUBATION + MECHANICAL VENTILATION if HFNC/CPAP fails — gentle ventilation strategy (permissive hypercapnia OK, avoid volutrauma), low TV 5-6 mL/kg + PEEP titrated + low Pplat < 30 + heat-moisture exchanger; FLUID — IV maintenance + cautious correction of dehydration (avoid SIADH-related hyponatremia → use isotonic ASPEN 2023, avoid hypotonic, monitor Na q6-12 h, target 1-1.25× maintenance until tolerating PO); SUCTION nasal/oral; supplemental O2 to SpO2 ≥ 90% AAP (some target ≥ 92% for younger/severe); AVOID per AAP 2014 — routine bronchodilator/steroid/antibiotic; HYPERTONIC SALINE 3% nebulizer — selected (mixed evidence for inpatient bronchiolitis — modest benefit), 4-6 mL q4h; consider EPI nebulizer trial selected; ANTIBIOTIC empiric if signs concurrent bacterial pneumonia/sepsis (rare); palivizumab/nirsevimab for prevention not treatment; ECMO selected — refractory hypoxemia/CO2 retention/cardiac failure (PPHN can develop); contact + droplet isolation (RSV); reassessment regular; transfer pediatric ICU if not at one already; FAMILY support + counsel; AAP RSV prophylaxis update — nirsevimab single dose for infants first RSV season highly effective preventing severe bronchiolitis 80% reduction

---

Severe bronchiolitis = ICU + respiratory support escalation (HFNC → CPAP → mechanical ventilation). Watch for apnea (young infants, premature), respiratory failure. NO routine bronchodilator/steroid/antibiotic (AAP 2014). Hypertonic saline selective. Nirsevimab prevention. ECMO for refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 8 wk BW 4 kg ก่อนคลอดครบกำหนด แต่มาด้วย apnea + severe respiratory distress + cyanosis + dehydration + ไอ 5 วันแล้ว วันแรก RSV positive

V/S: HR 188, RR 78 (then apneic pauses 20 sec), SpO2 84% RA → 92% on 2 L NC, Temp 36.5°C
Gen: lethargic, severe retraction, nasal flaring, grunting, mild cyanosis perioral, decreased UO past 12 hr

CBC: WBC normal, CRP slightly elevated
CXR: hyperinflation + scattered atelectasis bilateral + perihilar infiltrate (RSV pattern)
ABG: pH 7.30, PaCO2 50 (rising), PaO2 62 on FiO2 0.40';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antiviral alone"},{"label":"B","text":"Staphylococcal Toxic Shock Syndrome (TSST-1 superantigen-mediated, classic tampon-associated menstrual TSS"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Diuretic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Staphylococcal Toxic Shock Syndrome (TSST-1 superantigen-mediated, classic tampon-associated menstrual TSS — CDC criteria: fever ≥ 38.9, diffuse macular rash, hypotension, multisystem involvement ≥ 3 organs, desquamation 1-2 wk later): ICU admission + multidisciplinary; ABC + aggressive RESUSCITATION — IV crystalloid 20 mL/kg bolus repeat to restore perfusion (often need MASSIVE volume — capillary leak), vasopressor norepinephrine + epinephrine for cold/warm shock; SOURCE CONTROL — REMOVE TAMPON (retained foreign body source) IMMEDIATELY, irrigate vagina, examine for retained pieces; EMPIRIC ANTIBIOTIC — combination: 1) Clindamycin 40 mg/kg/d ÷ q6-8h IV (PROTEIN SYNTHESIS INHIBITOR — turns OFF toxin production, critical addition) + 2) Vancomycin 60 mg/kg/d ÷ q6h IV (cover MRSA + Staph aureus, until MRSA excluded) OR Oxacillin/Nafcillin if MSSA + non-MRSA region; alternative — linezolid (also turns off protein synthesis); duration 10-14 d IV → oral; if GAS-associated streptococcal TSS = penicillin G + clindamycin (similar combo); IVIG 1-2 g/kg single dose — recommended (binds + neutralizes superantigen toxins, evidence supportive); supportive — manage AKI (consider CRRT), liver dysfunction, DIC (replace fibrinogen + platelet if bleed), respiratory failure (intubation + ARDS strategy), aggressive supportive (electrolytes, glucose, nutrition); monitor for COMPLICATIONS — MOFS, AKI, DIC, ARDS, mortality 5-15%; DESQUAMATION on palms + soles 1-2 wk later (pathognomonic); recurrence risk if persists tampon use + persistent colonization — counsel avoidance of high-absorbency tampons + frequent change + alternate methods; EDUCATION + reportable disease (cluster surveillance, although now uncommon); pediatric infectious disease + gynecology consultation; psychiatric/social — adolescent + understanding precautions

---

TSS = superantigen-mediated (TSST-1 staph, scarlet fever toxin GAS). Menstrual + non-menstrual forms. CDC criteria. Multisystem failure. ABC + source control + clinda (protein synthesis = toxin OFF) + anti-staph (vanc/oxacillin) + IVIG. ICU. Education prevention. Desquamation pathognomonic 1-2 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 14 ปี (post-menarche 2 yr, tampon use last menses 5 d ago, removed 24 hr ago) ตอนนี้ ไข้สูง 40°C ฉับพลัน + ผื่นแดง diffuse macular + คลื่นไส้ + อาเจียน + ปวดเมื่อย muscle + ความดันต่ำ confused 6 hr

V/S: HR 142, BP 78/42, RR 28, SpO2 96%, Temp 40°C, BW 45 kg
Gen: ill-appearing, generalized erythroderma + diffuse macular rash (sunburn-like), mucous membrane hyperemia (strawberry tongue + conjunctival injection), no signs meningitis, capillary refill 4 sec

Lab: WBC 22,500 (left shift), Plt 65,000, Cr 1.8 (AKI), AST/ALT elevated, CK 1,800 (myositis), CPR 285, lactate 4.2, INR 1.4
Cultures pending; pelvic exam — find retained tampon piece! source identified';

update public.mcq_questions
set choices = '[{"label":"A","text":"Routine vaccinations"},{"label":"B","text":"Severe Combined Immunodeficiency (SCID, multiple genetic forms"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Steroid alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Combined Immunodeficiency (SCID, multiple genetic forms — X-linked common gamma chain, ADA deficiency, others) — pediatric emergency, no immune system, fatal first year if untreated: admit + ISOLATION strict protective (HEPA filtered room, no live exposures); HCT transplantation (HEMATOPOIETIC STEM CELL TRANSPLANT) — DEFINITIVE treatment, BEST outcomes if performed EARLY (< 3.5 mo of age, no prior infection — > 90% survival; older + infected — declining survival); urgent referral to pediatric immunology + transplant center; HLA-matched sibling donor preferred (best outcomes); haploidentical parent or matched unrelated donor alternative; GENE THERAPY — approved/clinical trial for specific genotype — ADA deficiency (Strimvelis EU approved, US compassionate use), X-linked SCID gene therapy emerging; ENZYME REPLACEMENT — for ADA-SCID — PEG-ADA (Adagen, polyethylene glycol-conjugated bovine adenosine deaminase) IM weekly until HSCT or gene therapy possible; SUPPORTIVE pre-HSCT — PCP PROPHYLAXIS TMP-SMX 5 mg/kg/d trimethoprim 3×/wk (CRITICAL — Pneumocystis jirovecii pneumonia common in SCID and lethal); IVIG REPLACEMENT 400-600 mg/kg q3-4 wk IV (replace humoral immunity); FUNGAL prophylaxis fluconazole; AVOID ALL LIVE VACCINES — BCG, rotavirus, MMR, varicella (can cause disease in SCID); use INACTIVATED only; treat infections aggressively + early; AVOID NON-IRRADIATED BLOOD PRODUCTS (GVHD risk) — use IRRADIATED + CMV-negative + leukoreduced + filtered; nutritional support — TPN if FTT; family genetic counseling + screening relatives + prenatal/PGD; document allergy + immune status; transition to long-term immunology follow-up post-HSCT (chronic GVHD, immune reconstitution, fertility, secondary malignancy); important for newborn screening to identify before infection — improves outcome dramatically

---

SCID = pediatric immunology emergency. Recurrent severe infections + FTT + lymphopenia + absent thymus = work-up urgent. HSCT < 3.5 mo + uninfected = best outcome > 90%. ADA gene therapy. PCP prophylaxis + IVIG + isolation + IRRADIATED blood + NO live vaccines. NBS screening identifies early.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารกชายอายุ 4 mo recurrent oral candidiasis (thrush) + chronic diarrhea + failure to thrive (BW 4 kg < 3rd %ile) + persistent pneumonia × 2 episodes + chronic cough; ครอบครัว uncle (mother''s brother) died age 6 mo from infection

PE: cachectic, oral thrush, mild rales, hepatomegaly mild, NO PALPABLE THYMUS/LN/TONSILS
CXR: no thymic shadow + bilateral patchy infiltrate (consider PCP)

CBC: lymphocyte count 280 (severe lymphopenia — < 2,800 abnormal infant, < 500 critical), Hb normal, neutrophils normal
Flow cytometry: very low T cells, low B cells (variable), normal NK cells — suggests T-B-NK+ SCID = ADA deficiency OR XL-SCID T-B+NK-
SCID TREC newborn screening positive on review (low TREC)
NB: NBS for SCID standard in many states/Thailand emerging';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Acute Liver Failure (PALF"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Wait — observe"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Acute Liver Failure (PALF — INR > 1.5 with encephalopathy OR > 2 without encephalopathy + no chronic liver disease): ICU + pediatric hepatology + transplant center referral IMMEDIATE; SUPPORTIVE — multiorgan management; HYPOGLYCEMIA — continuous D10W or D15W IV infusion + serial glucose q1-2 hr (severe risk + brain damage); CORRECT COAGULOPATHY — VITAMIN K IV 5-10 mg single dose (rule out vitamin K deficiency component); FFP/cryoprecipitate/PCC only for active bleeding or invasive procedures (treating INR alone obscures prognostication); manage CEREBRAL EDEMA + ICP — most feared complication encephalopathy grade 3-4 (head of bed 30°, normothermia, sedation propofol + fentanyl, intubation if grade 3+ encephalopathy + mannitol/hypertonic saline for ICP, target Na 145-155, consider ICP monitor selective, AVOID hyperventilation prolonged); NUTRITION — IV dextrose with limited amino acids ammonia management; rifaximin + lactulose ammonia (efficacy lower in pediatric ALF); manage AKI (CRRT) + sepsis (broad-spectrum antibiotic — ceftriaxone with cultures); FLUID — careful, avoid hyponatremia (cerebral edema); IDENTIFY CAUSE — acetaminophen (use NAC EMPIRICALLY in PALF of UNKNOWN cause — proven benefit even non-APAP), drug-induced (review all meds), viral hepatitis (HAV/HBV/HCV/HEV serology + EBV/CMV/HSV/parvovirus PCR), autoimmune (ANA, SMA, LKM1), Wilson disease (ceruloplasmin, urine copper, slit-lamp KF rings, ATP7B testing — adolescent), metabolic (galactosemia, tyrosinemia, mitochondrial — especially infants), Reye (aspirin Hx), HLH (ferritin extreme); CONSIDER PALF Registry; LIVER TRANSPLANT EVALUATION URGENT — KING''S COLLEGE CRITERIA in peds for transplant listing (etiology-specific or combination of pH < 7.3 / INR > 6.5 / Cr > 3.4 + grade III/IV encephalopathy); PALF prognosis 60% spontaneous recovery, 25-30% transplant, 10-15% death — depends on cause + severity + age; family education + intense psychosocial support

---

Pediatric Acute Liver Failure = ICU + transplant center. Manage hypoglycemia + coagulopathy + cerebral edema (#1 fatal). Empiric NAC for unknown cause (proven benefit non-APAP too). Identify cause (extensive workup). King''s College criteria + PALF Registry guide transplant. Mortality high without transplant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 4 ปี ก่อนหน้านี้ healthy เพิ่งเป็น viral gastroenteritis 1 wk ก่อน หลังจากนั้น lethargic + ตัวเหลือง + คลื่นไส้อาเจียน + ปวดท้อง 3 วัน + สับสน + asterixis + petechiae + เลือดออกตามไรฟัน ตอนนี้

V/S: HR 122, BP 98/62, RR 22, Temp 37.4°C, BW 16 kg
Gen: jaundice severe, drowsy, confused, asterixis, petechiae, mild hepatomegaly (small actually — shrinking liver = ominous), no ascites yet

Lab: ALT 4,820, AST 5,640 (very high), Bilirubin total 22 (direct 14), INR 4.8 (severe coagulopathy), glucose 38 (hypoglycemia), NH3 220, albumin 2.4, lactate 5.8, Cr 1.6
UA + urine drug screen + acetaminophen level pending; viral hepatitis serology pending; ceruloplasmin + urine copper pending (Wilson); autoimmune workup pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric STEMI (rare, mostly secondary to Kawasaki coronary aneurysm thrombosis, also congenital anomalies, drug-induced, hypercoagulable, vasculitis)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Antiviral"},{"label":"E","text":"Wait — observe"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric STEMI (rare, mostly secondary to Kawasaki coronary aneurysm thrombosis, also congenital anomalies, drug-induced, hypercoagulable, vasculitis): immediate cardiology + interventional cardiology + ICU; SUPPORTIVE — oxygen titrated to SpO2 ≥ 94%, IV access + monitoring, MONA-B adapted (Morphine, Oxygen, Nitrate, Aspirin, Beta-blocker but cautious in peds): ASPIRIN 81-162 mg PO chewed STAT (anti-platelet) + clopidogrel/ticagrelor loading; ANTICOAGULATION — heparin (UFH or LMWH) + maintain therapeutic; nitrate if BP allows; beta-blocker (metoprolol) if stable; pain management (morphine — caution in non-evidence pediatric); STATIN early; ESC/AHA: PRIMARY PCI (preferred reperfusion if available within 90-120 min) — pediatric coronary PCI by experienced interventional pediatric cardiologist (adult-trained, specialized centers); ALTERNATIVE thrombolysis (alteplase IV) if PCI not available within 120 min, no contraindication — pediatric data limited, extrapolated from adult; KD-related thrombosis — combined antiplatelet + anticoagulation often used long-term; CABG considered if multivessel or complex anatomy; ICU monitoring + arrhythmia management (ventricular arrhythmia post-MI), congestive heart failure management (inotrope, diuretic, fluid balance); SECONDARY PREVENTION — long-term aspirin + clopidogrel/warfarin (DAPT or triple if anticoagulation, balance bleeding) + beta-blocker + ACEI + statin + cardiac rehabilitation; LIFESTYLE — avoid contact sports (per AHA Kawasaki long-term), regular cardiology follow-up, serial echo + cardiac MRI/stress test; psychosocial support; transition adult; KD-with-giant aneurysm = highest cardiac risk subset — IVIG + ASA acute KD reduce aneurysm 25→5% but giant aneurysms persist + carry lifelong risk (MI, sudden death); coronary CTA/MRI angiogram serial monitoring; gene therapy + organ transplant for end-stage HF; long-term mortality elevated

---

Pediatric STEMI = rare. KD-coronary aneurysm thrombosis = leading cause adolescent MI. Primary PCI preferred reperfusion (within 90-120 min) by experienced peds interventional cardiologist. DAPT + anticoagulation + supportive. Lifelong KD coronary surveillance. Avoid contact sports. Transition adult cardiology.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 12 ปี known Kawasaki disease 5 ปีก่อนมี giant coronary aneurysms (LAD + RCA) ตอนนี้กำลังเล่นกีฬาเริ่มเจ็บอกรุนแรง + คลื่นไส้ + sweating + เริ่ม dyspnea 1 ชม. ก่อน — ECG ED ที่มา

V/S: HR 102, BP 92/58, RR 28, SpO2 96%, BW 36 kg
Gen: distress, diaphoretic, mild distress

ECG: anterior ST elevation V1-V4 + Q waves emerging; cardiac enzymes — troponin 5.6 (high), CK-MB elevated
Echo: anterior wall hypokinesis (new) + visible giant LAD aneurysm + thrombus seen + EF 38%
Diagnosis: STEMI in adolescent with Kawasaki coronary aneurysm thrombosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Biphasic Anaphylaxis recurrence (5-20% incidence, typically 4-12 hr after initial reaction, occurs even with adequate initial treatment)"},{"label":"C","text":"Discharge home immediately"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Antiviral"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biphasic Anaphylaxis recurrence (5-20% incidence, typically 4-12 hr after initial reaction, occurs even with adequate initial treatment): IMMEDIATE IM Epinephrine 0.01 mg/kg (0.3 mg in 30 kg child) lateral thigh REPEAT q5-15 min as needed (3-4 doses possible); IV access established + crystalloid bolus 20 mL/kg if hypotension; supplemental O2; supine position (Trendelenburg if hypotension); BRONCHODILATOR albuterol nebulizer for wheeze; ANTIHISTAMINE H1 (diphenhydramine 1 mg/kg IV) + H2 (ranitidine/famotidine) — secondary, NOT replacing epi; CORTICOSTEROID (methylprednisolone 1-2 mg/kg IV) — once thought to prevent biphasic but RECENT EVIDENCE shows steroid does NOT reliably prevent biphasic — still given but not ''lifesaving''; admit + monitor minimum 6-24 hr post-resolution (longer observation for high-risk: severe initial, multiple doses epinephrine, asthmatic, history of biphasic); ICU if respiratory compromise/multidose epi needed/hypotension; KNOW RISK FACTORS FOR BIPHASIC — multiple doses initial epinephrine, delayed initial epinephrine administration, asthma, severe initial reaction, broad-area cutaneous, GI/respiratory predominate symptoms, oral allergen (vs IV/sting); discharge planning — written EMERGENCY ACTION PLAN, prescribe TWO EpiPen Jr 0.15 mg (< 25 kg) OR EpiPen 0.3 mg (≥ 25 kg) — carry both at all times (school + activities), instruct USE FOR ANY anaphylaxis suspicion (don''t wait), thigh IM, after EpiPen use → call EMS regardless of improvement (biphasic risk); ALLERGIST referral within 1-4 wk; identify trigger + avoidance education; consider oral immunotherapy long-term (Palforzia FDA-approved); school 504 plan; medical alert bracelet; family + child education + practice + emotional support; food allergy registries; emerging — omalizumab adjunct (recent FDA approval 2024 food allergy); long-term: persistent allergy 80% peanut (vs 50% egg/milk)

---

Biphasic anaphylaxis = recurrent reaction without re-exposure (5-20%, typically 4-12 hr). Risk factors include severe initial, multi-dose epi, delayed treatment, asthma. Same management as initial. Observation 6-24 hr (longer high-risk). Steroid doesn''t reliably prevent. Two EpiPen + allergist + action plan.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 9 ปี BW 30 kg ก่อนหน้านี้ 2 ชม. มี anaphylaxis severe จากการกิน peanut — IM Epi 0.15 mg ที่ ED → resolved fully within 30 min + observed 2 ชม. asymptomatic ขณะ ED ไม่มี wheeze, BP normal

ณ moment ที่ family กำลังจะกลับบ้าน — เด็กกลับมา wheeze severe + facial swelling + urticaria generalized + BP 88/52 + เหนื่อย anaphylactic shock again';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Testicular Torsion (urological emergency, time-critical for testicle salvage"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Testicular Torsion (urological emergency, time-critical for testicle salvage — 90% salvage if < 6 hr, 50% < 12 hr, < 10% > 24 hr): pediatric urology IMMEDIATE consultation + OR booking; do not delay surgery for imaging if clinical Dx strong (US helpful but not mandatory in clear cases — saves time); PREPARE FOR OR — NPO, IV fluid, analgesia (IV morphine 0.05-0.1 mg/kg), antiemetic; SCROTAL EXPLORATION + DETORSION + BILATERAL ORCHIOPEXY — emergent surgical exploration via scrotal/inguinal incision; detort affected testicle (typically rotated medially — ''open book'' technique) + assess viability (color, perfusion, ICG/Doppler intra-op) — if viable → orchiopexy fixation (3 points, non-absorbable suture or scrotal sac fixation); if non-viable necrotic → ORCHIECTOMY; CONTRALATERAL orchiopexy MANDATORY (bell-clapper deformity often bilateral congenital anatomy — 70-80% — fix contralateral to prevent future torsion); MANUAL DETORSION attempted in ED — bridge if surgery delay (rotate testicle laterally ''open book'' from medial to lateral 540-720°, success unpredictable, MUST still go to OR for fixation); follow-up — testicular self-exam + counsel future torsion contralateral 1-2%; long-term — fertility may be affected even after successful detorsion (controversial — antibody mechanism), counsel adolescent + future reproductive plans; psychosocial support — orchiectomy + prosthesis option for cosmetic + psychological; education — testicular pain = urology emergency, prompt evaluation; DIFFERENTIAL DDx of acute scrotum — torsion of appendix testis (less urgent, conservative), epididymitis (older boys, STI in adolescent), hernia, hydrocele, trauma, hemorrhage, tumor, Henoch-Schonlein scrotum — but DO NOT delay if torsion suspected!

---

Testicular torsion = time-critical urological emergency. < 6 hr = 90% salvage. Clinical Dx + urgent surgical exploration (do not delay for imaging). Bilateral orchiopexy mandatory (anatomical predisposition). Manual detorsion bridge. Long-term fertility concern + contralateral risk monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 13 ปี BW 38 kg ตื่นเช้ามาด้วย ปวดอัณฑะข้างขวารุนแรง + คลื่นไส้อาเจียน 2 ชม ก่อน — ก่อนหน้านี้ไม่มี trauma, no STI Hx, sexually inactive

V/S: HR 102, BP 110/72, BW 38 kg
PE: right scrotal swelling + tender + high-riding testis + horizontal lie + absent cremasteric reflex + diffuse tenderness; left testis normal; no signs UTI/STI; abdomen non-tender, no inguinal hernia

US scrotum + Doppler: decreased blood flow right testicle + ''whirlpool sign'' spermatic cord = testicular torsion (right side)
CBC + UA normal
Duration 2 hr from symptom onset (early)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient PO hydration"},{"label":"B","text":"Severe Rhabdomyolysis (CK > 5× normal, often > 5,000) with AKI + Hyperkalemia + Electrolyte derangement"},{"label":"C","text":"Diuretic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Rhabdomyolysis (CK > 5× normal, often > 5,000) with AKI + Hyperkalemia + Electrolyte derangement: admit + ICU monitoring; AGGRESSIVE IV FLUID RESUSCITATION — primary intervention — isotonic crystalloid 1-2 L bolus then continuous infusion 200-500 mL/hr (high rate to target UO ≥ 1-2 mL/kg/hr to flush myoglobin + maintain perfusion) — most important intervention; ALKALINIZATION of urine — sodium bicarbonate IV continuous infusion target urine pH > 6.5 (controversial mixed evidence, may help reduce myoglobin precipitation in tubules but caution metabolic alkalosis + hypocalcemia worsening tetany) — recent guidelines selective use; MANNITOL (osmotic diuresis) — controversial, no clear benefit, AVOID in oliguric AKI (can worsen); MANAGE HYPERKALEMIA — calcium gluconate cardiac protection if ECG changes, insulin + glucose, albuterol, sodium bicarb (with caution Ca), sodium polystyrene resin selective, DIALYSIS if refractory; manage hyperphosphatemia (binders selectively, but Ca worsening); manage hypocalcemia (only if symptomatic — treating before resolution can worsen Ca-P precipitation); HEMODIALYSIS / CRRT — indications: AKI with severe hyperkalemia refractory, severe acidosis, uremia, fluid overload, severe hyperphosphatemia + symptomatic hypocalcemia — myoglobin clearance by dialysis controversial (large molecule, removal limited); IDENTIFY + REMOVE TRIGGER — exertional (most common adolescent — heat, exercise), trauma/crush, drug-induced (statin, fibrate, cocaine, MDMA, alcohol), infection, electrolyte derangement, genetic (McArdle, CPT II, malignant hyperthermia susceptibility — workup if recurrent), neuroleptic malignant syndrome, viral myositis; SYMPTOM management — analgesia, antiemetic, monitor compartment syndrome (limb pain + tense + neurovascular changes = surgical fasciotomy); REST + activity restriction × 2-4 wk; education — heat acclimatization, hydration, avoid hard exercise without conditioning, sports clearance gradual; nephrology + cardiology + neurology follow-up; chronic kidney disease risk monitoring; recurrent → workup metabolic muscle disease

---

Rhabdomyolysis = muscle injury → myoglobin → AKI + hyperK + hyperP + hypoCa + acidosis. Adolescent exertional heat-related common. Aggressive IV fluid + electrolyte management + dialysis selective. Alkalinization controversial. Compartment syndrome watch. Workup recurrent genetic. Long-term CKD risk monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 16 ปี BW 65 kg ออกกำลังกายหนักในที่ร้อน (football practice in heat, dehydrated) 6 ชม + เริ่มปวดกล้ามเนื้อรุนแรง + ปัสสาวะสีโคล่า dark + ปริมาณน้อย + คลื่นไส้ + อ่อนเพลีย

V/S: HR 122, BP 132/82, Temp 38.0°C, BW 65 kg (มี dehydration)
Gen: alert, generalized muscle tenderness + cramping, dark cola-colored urine, oliguric

Lab: CK 84,500 (very high — > 5× normal), myoglobinuria + (urine dipstick blood + but no RBC microscopy), K 6.2 (high), P 8.2 (high), Ca 7.4 (low), uric acid 14, lactate 4.8, AGMA pH 7.28
Cr 2.8 (baseline 0.9 → AKI Stage 3), BUN 42; UA: ''blood'' +++ but no RBC + myoglobin positive on dipstick + granular casts';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"IgA Nephropathy (Berger disease, most common primary glomerular disease worldwide, autosomal dominant with variable expression"},{"label":"C","text":"Steroid pulse routine all"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Antibiotic chronic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Nephropathy (Berger disease, most common primary glomerular disease worldwide, autosomal dominant with variable expression — long-term progression to ESRD 20-40% within 20 yr without treatment): pediatric nephrology follow-up; RISK STRATIFICATION (Oxford-MEST-C classification + clinical factors) for progression risk — proteinuria > 0.5-1 g/d, HT, reduced GFR, severe pathology features (cellular crescents); STANDARD CARE for ALL — BP control (target < 90th percentile/130/80), low salt diet, RAAS BLOCKADE with ACEI (lisinopril, enalapril) or ARB (losartan) titrated to maximum tolerated dose to reduce proteinuria + slow progression (first-line for all with proteinuria); FOR HIGH-RISK PROGRESSION (persistent proteinuria > 1 g/d despite RAAS, reduced GFR, severe biopsy) — additional immunosuppression: corticosteroid 6 mo regimen (Pozzi protocol or STOP-IgAN — controversial mixed evidence in modern era, KDIGO 2021 recommends only if persistent proteinuria + supportive care optimized); MMF or cyclophosphamide for severe; SGLT2 INHIBITORS (dapagliflozin) — newer evidence reduces progression in IgA nephropathy + other CKD per DAPA-CKD/EMPA-KIDNEY (pediatric data emerging); TARGETED RELEASE BUDESONIDE (Nefecon — newer FDA-approved 2023 for IgA nephropathy targeting gut Peyer''s patches where pathogenic IgA originates) — adult, pediatric trials emerging; AVOID nephrotoxin (NSAID); manage CV risk (BP + lipid + lifestyle); MONITORING — BP + UA + Cr + UP/UCr q3-6 mo; long-term — many progress, some stable, individual variation; family history + screen relatives (familial component); ADULT — kidney transplant possible (IgA recurrence post-transplant 30-50% but slow + manageable); GENETIC counseling familial cases; emerging therapy — IgA-specific therapies in trial (sparsentan endothelin antagonist)

---

IgA nephropathy = most common primary GN worldwide. Episodic gross hematuria post-URI + persistent microscopic. Biopsy mesangial IgA. Long-term progression risk. Supportive care + ACEI/ARB BP/proteinuria control + risk-stratified immunosuppression. SGLT2i + targeted budesonide emerging. Family screen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 12 ปี recurrent gross hematuria episodes — เป็น 1-3 d ระหว่าง URI episodes, ระหว่าง episodes UA — persistent microscopic hematuria + mild proteinuria; ตอนนี้ URI ครั้งที่ 4 ใน 1 ปี + gross hematuria again + BP rising 138/86

Family: father had similar in childhood — eventually ESRD age 40
PE: BP 138/86, BW 36 kg, no edema currently, mild flank tenderness

Lab: Hb normal, Plt normal, complement NORMAL (excludes lupus, PSGN, MPGN), anti-streptolysin normal
UP/UCr 0.8, Cr 0.8 (baseline), no other autoimmune workup positive
Renal biopsy: mesangial IgA + C3 deposits + mesangial proliferation = IgA Nephropathy (Berger disease) — most common primary GN worldwide';

update public.mcq_questions
set choices = '[{"label":"A","text":"Active rapid rewarming with very hot bottle"},{"label":"B","text":"Severe Neonatal Hypothermia + Cold Stress Syndrome with multiple complications (sclerema, hypoglycemia, polycythemia, metabolic acidosis, possible DIC + sepsis)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone without rewarming"},{"label":"E","text":"Antiviral"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Neonatal Hypothermia + Cold Stress Syndrome with multiple complications (sclerema, hypoglycemia, polycythemia, metabolic acidosis, possible DIC + sepsis): admit NICU + multidisciplinary; ACTIVE EXTERNAL REWARMING gentle — 0.5-1°C/hr (NOT > 1°C/hr — avoid rebound hypotension/arrhythmia) — radiant warmer/incubator + skin-to-skin care with mother + warm dry blanket + warm humidified O2 + warmed IV fluid 37°C + plastic wrap reduce evaporation + cover head (large surface area newborn head); INVASIVE rewarming for very severe — warm peritoneal lavage, hemodialysis warmed circuit selected — rarely needed neonates if not arrested; CORRECT HYPOGLYCEMIA — D10W 2 mL/kg IV bolus + continuous infusion at GIR 6-8 mg/kg/min (cold stress depletes glucose); FLUID RESUSCITATION — careful — cold-stressed infants may have shock + acidosis; antibiotic empiric (ampicillin + gentamicin) cover sepsis — cold stress + sepsis often coexist (hypothermia common sepsis sign); correct ACIDOSIS — usually self-correct with rewarming + perfusion (avoid bicarb routine); correct COAGULOPATHY — vitamin K + monitor for DIC (cold + sepsis); manage POLYCYTHEMIA — partial exchange transfusion if Hct > 65 + symptomatic; cardiovascular support — vasopressor if shock persists despite rewarming + fluid + correction; SCLEREMA = ominous sign (severe disease + high mortality); MONITOR continuously — temp q5-15 min during rewarming + glucose q hourly + electrolytes + cardiac/respiratory; identify CAUSE — home birth without warmth, sepsis, hypothyroidism (delayed cord clamping or delivery in cold environment most common), hypothalamic injury, narcotic exposure; long-term — neurodevelopmental follow-up + cold-stress sequelae; FAMILY/system education + improve home delivery practices (cocoon + skin-to-skin + delayed bath + heated room) + Thai PHC programs to support home delivery with warmth chain (WHO/UNICEF Warm Chain 10 steps); psychosocial support family + counseling

---

Severe neonatal hypothermia = emergency, multiple complications (hypoglycemia, acidosis, sepsis, DIC, polycythemia, sclerema). Gradual rewarming 0.5-1°C/hr + correct hypoglycemia + sepsis coverage + supportive. Sclerema ominous. WHO Warm Chain prevention. Address home delivery practices.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'ทารก term GA 38 wk BW 2,400 g (small) คลอดที่บ้าน ผู้ทำคลอดไม่ได้ขยายส่งโรงพยาบาลทันที 4 ชม. มาถึง ED มา ED ตอนนี้ลำตัวเย็น + ซึม + breathing shallow + bradycardia + ไม่ดูดนม

V/S: HR 88 (bradycardia for newborn), RR 32, SpO2 88% room air, Temp axillary 32.4°C (severe hypothermia, normal 36.5-37.5°C, mild 32-36, moderate < 32, severe < 28)
Gen: lethargic, cold to touch, mottled, weak pulses, sclerema (waxy stiff skin from fat)

Lab: glucose 28 (hypoglycemia), Hb 17 (polycythemia common cold-stressed), Plt low 80,000, lactate elevated, mild metabolic acidosis pH 7.25';

update public.mcq_questions
set choices = '[{"label":"A","text":"High tidal volume + low PEEP"},{"label":"B","text":"Pediatric ARDS (PARDS, PALICC criteria"},{"label":"C","text":"High tidal volume aggressive"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Stop all support"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric ARDS (PARDS, PALICC criteria — non-cardiogenic bilateral infiltrate + hypoxemia + acute onset) severe (P/F < 100 or OI > 16) — lung-protective ventilation + supportive: VENTILATION strategy — LOW TIDAL VOLUME 5-6 mL/kg predicted body weight (lung-protective, prevent volutrauma + barotrauma); PERMISSIVE HYPERCAPNIA — accept PaCO2 60-80 to allow lower TV/PEEP unless brain injury/PHT; PEEP TITRATION + recruitment (lower PEEP for less severe, higher PEEP for severe to recruit + maintain) per PEEP/FiO2 table or esophageal pressure-guided; PLATEAU PRESSURE < 28-32 cmH2O target (limit transpulmonary pressure); FiO2 minimum to maintain SpO2 88-92% acceptable (avoid hyperoxia); MONITOR oxygenation — P/F ratio, OI (oxygenation index for peds), SpO2; CONSERVATIVE FLUID balance (avoid net positive) — diuretic if hemodynamically stable + ARDS — FACTT-Lung guides; prone positioning — improves oxygenation in moderate-severe PARDS (extrapolated adult, peds emerging evidence positive, 12-16 hr prone session if tolerated); NEUROMUSCULAR BLOCKADE (rocuronium, cisatracurium) — controversial routine, may improve oxygenation in severe ARDS (ACURASYS adult); recruitment maneuvers selective; SEDATION protocol — interruption + daily SAT/SBT; oxygen alternatives — HFOV (high-frequency oscillatory ventilation) — older protocol, recent OSCILLATE/OSCAR negative in adults, peds uncertain — selective use refractory severe; iNO inhaled nitric oxide — PARDS with pulmonary HT, transient improvement, not survival benefit; ECMO — refractory severe PARDS (P/F < 80 on max settings, OI > 35-40) — transfer ECMO center; SUPPORTIVE — sepsis source control (ID + antibiotic + antiviral as identified — ongoing here), hemodynamic support (vasopressor, fluid balance), nutrition early enteral, glucose control, stress ulcer prophylaxis, DVT prophylaxis (per peds CHEST guidelines age-appropriate), prevent VAP (HOB 30, oral care, daily SBT, weaning); FAMILY-CENTERED communication + psychosocial; outcome — pediatric ARDS mortality 20-30% (better than adult); long-term — pulmonary function recovery + neurocognitive long-term follow-up, post-ICU PTSD + depression families + child

---

Pediatric ARDS = PALICC criteria. Lung-protective ventilation (low TV 5-6 mL/kg, PEEP titrated, permissive hypercapnia, plateau < 28-32). Prone positioning moderate-severe. Conservative fluid. ECMO refractory. Treat underlying. Long-term pulmonary + neurocognitive follow-up. Family-centered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี BW 22 kg admitted ICU with severe community-acquired pneumonia (Spn + Influenza A coinfection) + sepsis 48 ชม + progressive respiratory failure → intubated + ventilated → ARDS developing

V/S: HR 142, BP 92/58 on epinephrine, intubated FiO2 0.8 PEEP 8 + ventilated
Gen: sedated + intubated, ARDS picture

Lab: pH 7.28, PaO2 62 → P/F 78 (severe ARDS PARDS, < 100), CXR: bilateral diffuse opacities, normal cardiac silhouette, no atelectasis explanation alone
Lactate 4.8, on antibiotic + antiviral + supportive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Orbital Cellulitis with Subperiosteal Abscess (POST-septal infection"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Orbital Cellulitis with Subperiosteal Abscess (POST-septal infection — emergency, vision-threatening, life-threatening intracranial spread): immediate admit + IV antibiotic + ophthalmology + ENT + (neurosurgery if intracranial concern); SUPPORTIVE — bed rest + head elevation + warm compress + analgesia + antipyretic; EMPIRIC IV ANTIBIOTIC broad-spectrum cover (Strep pneumo, Strep + GAS, Staph aureus including MRSA, H flu, anaerobes from sinus, gram-negative) — Vancomycin (60 mg/kg/d ÷ q6h) + Ceftriaxone (50-75 mg/kg/d) + Metronidazole (30 mg/kg/d ÷ q6h) for anaerobic coverage; alternative pip-tazo + vanc; duration IV 1-2 wk → oral × 2-4 wk total; SURGICAL DRAINAGE — INDICATIONS for subperiosteal abscess: > 1 cm size, optic neuropathy, complete ophthalmoplegia, large abscess, frontal involvement, no improvement after 24-48 hr IV antibiotic, intracranial extension, immunocompromised, age > 9 yr (less likely respond to medical alone) — ENT/oculoplastic surgery for endoscopic sinus surgery + drainage of orbital abscess + culture; medical management trial for small abscess + no optic compromise + < 9 yr — observe 24-48 hr + escalate if no improvement; OPHTHALMOLOGY SERIAL exams — visual acuity, color vision (early optic nerve compromise), pupil reactivity (RAPD = optic nerve), proptosis measure, ROM; CT/MRI sinus + orbit + brain (rule out cavernous sinus thrombosis, intracranial extension — meningitis, brain abscess, cavernous sinus thrombosis — CRITICAL detection); MEDICAL emergency for vision (optic nerve compression irreversible) + LIFE-threatening intracranial complications; SUPPORTIVE — anticoagulation considered if cavernous sinus thrombosis (controversial), corticosteroid AVOID routine (may worsen infection unless adjunct in late phase); culture + sensitivity guided; topical antibiotic eye drop if conjunctival; long-term — recurrence if persistent sinusitis, optic nerve dysfunction, scarring; pediatric ID + ophtho + ENT follow-up + image; CHANDLER classification of orbital infection — preseptal (I) < subperiosteal abscess (III) < orbital abscess (IV) < cavernous sinus thrombosis (V); preseptal cellulitis (anterior to orbital septum) = milder, often outpatient oral antibiotic

---

Orbital cellulitis = post-septal, vision + life-threatening, sinus source. Distinguish from preseptal (anterior to septum, mild). Chandler classification I-V. IV broad-spectrum (vanc + ceftriaxone + metronidazole) + surgical drainage selected. Watch optic nerve + intracranial complications. ENT + ophtho + ID coordinated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี เริ่ม URI + sinusitis 4 d ก่อน + ตอนนี้ปวดตา + บวมแดงรอบตา left + ตามองเห็นเริ่มจะลด + ตาเคลื่อนไหวเจ็บ + diplopia + ตาโปนเล็กน้อย + ไข้ 39.0°C

V/S: HR 122, BP 102/68, Temp 39.0°C, BW 22 kg
PE: marked periorbital erythema + edema + warm + tender, mild proptosis left, restricted EOM all directions painful, decreased visual acuity 20/40 → 20/100, mild RAPD, conjunctival injection; no Roth spots, no obvious sinusitis discharge externally but CT might show

CBC: WBC 22,000 (left shift), CRP 285
CT orbits + sinuses: opacification ethmoid sinus + subperiosteal abscess medial orbit + lateralization globe = orbital cellulitis with abscess + ethmoid sinusitis source';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Pediatric Deep Vein Thrombosis + Pulmonary Embolism (rising incidence, multifactorial risk factors here"},{"label":"C","text":"Aspirin alone"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Deep Vein Thrombosis + Pulmonary Embolism (rising incidence, multifactorial risk factors here — central line, immobility, IBD, OCP from family — none actually, but adolescent IBD acute inflammation high VTE risk): admit ICU + cardiology/pulmonology + hematology + IR consultation; RISK STRATIFICATION — hemodynamically stable vs unstable (this patient is stable but with RV strain — submassive); SUPPORTIVE — oxygen titrated to SpO2 ≥ 92%, fluid resuscitation if hypotension (caution — RV preload-dependent in PE, avoid over-resuscitation, vasopressor preferred), analgesia; ANTICOAGULATION — start immediately if no contraindication: LMW HEPARIN (enoxaparin) 1 mg/kg SC q12h (preferred in stable pediatric — outpatient convertible) titrated to anti-Xa level 0.5-1.0 IU/mL (peds dosing per nomogram); OR UNFRACTIONATED HEPARIN IV bolus 75 U/kg + infusion 20 U/kg/hr titrated to PTT 60-85 sec (preferred if unstable, renal failure, or procedure planned); transition to DOAC (rivaroxaban approved peds, dabigatran emerging) OR warfarin (INR 2-3) for longer-term oral therapy; SYSTEMIC THROMBOLYSIS (tPA) — INDICATED for hemodynamically UNSTABLE PE (massive — shock, sustained hypotension, cardiac arrest) — dose alteplase 0.5-1 mg/kg over 2 hr (extrapolated adult); high bleeding risk weigh; CATHETER-DIRECTED THROMBOLYSIS / mechanical thrombectomy — for selected submassive (this patient could be candidate) — direct catheter to clot + lower dose tPA + mechanical fragmentation — emerging in pediatric IR; SURGICAL EMBOLECTOMY — refractory + experienced center; IVC FILTER selected (recurrent PE despite anticoagulation, contraindication anticoagulation — but problematic kids — long-term thrombosis around filter); REMOVE OFFENDING — REMOVE central venous catheter (if no longer needed) — major risk factor; immobility — early mobilization once anticoagulated; IDENTIFY UNDERLYING — thrombophilia workup (after acute, may be falsely positive during) — protein C/S, antithrombin, factor V Leiden, prothrombin gene, APS, MTHFR; treat underlying disease (IBD optimization); DURATION anticoagulation — 3-6 mo for provoked PE; longer for unprovoked or thrombophilia/recurrent; long-term monitoring — recurrence + post-thrombotic syndrome (chronic limb swelling/discomfort 25-50%) + pulmonary HT (rare CTEPH); compression stockings post-DVT for PTS prevention; psychosocial + transition adult; PEDIATRIC PE/DVT rising — central lines + obesity + IBD + sickle + cancer + adolescent OCP all common risk factors

---

Pediatric DVT/PE rising — central line + IBD + immobility + OCP + cancer + obesity risk factors. Anticoagulation (LMWH first-line stable, UFH if unstable). Submassive PE with RV strain = consider catheter-directed thrombolysis. Massive = systemic tPA. Long-term: thrombophilia workup, duration 3-6 mo, post-thrombotic syndrome, transition adult.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 14 ปี BW 60 kg admit hospital สำหรับ Crohn disease flare 7 d + central line femoral + on TPN + immobilized + ใช้ COC mother + bed-bound largely. วันนี้เริ่มหอบเหนื่อยฉับพลัน + เจ็บอกที่เพิ่ม inspiration + ใจสั่น + bilateral leg swelling left worse + tender

V/S: HR 132, BP 102/68, RR 32, SpO2 88% room air → 95% on 4 L NC, Temp 37.4°C
Gen: distress, anxious, mild cyanosis, pleuritic chest pain, left leg swelling thigh circumference 6 cm > right + tender + warm + skin discoloration

Lab: D-dimer extremely elevated > 5,000, CBC mild leukocytosis, BNP elevated, troponin slightly elevated; ECG sinus tachycardia + S1Q3T3 pattern
US lower extremity Doppler: large DVT left common femoral + iliac extension
CT PE protocol: bilateral pulmonary emboli with right > left + mild right heart strain (RV dilatation)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid only"},{"label":"B","text":"Anti-NMDA Receptor Encephalitis (autoimmune encephalitis, often paraneoplastic in females with ovarian teratoma, mostly idiopathic in younger kids)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anti-NMDA Receptor Encephalitis (autoimmune encephalitis, often paraneoplastic in females with ovarian teratoma, mostly idiopathic in younger kids): pediatric neurology + neuro-immunology + oncology + ICU coordinated; FIRST-LINE IMMUNOTHERAPY combination: 1) HIGH-DOSE METHYLPREDNISOLONE 30 mg/kg/d IV × 5 d (pulse) followed by oral prednisone taper, 2) IVIG 2 g/kg total over 2-5 days, 3) PLASMAPHERESIS / plasma exchange alternative or adjunct (especially severe/refractory); REMOVE TUMOR — surgical resection of ovarian teratoma (if present — paraneoplastic in 50% females, removal frequently rapid response improvement); SECOND-LINE (refractory to first-line after 2 wk OR severe disease) — RITUXIMAB 375 mg/m² weekly × 4 doses (deplete B cells, mainstay) AND/OR CYCLOPHOSPHAMIDE IV monthly × 6 cycles; emerging options: bortezomib, tocilizumab, daratumumab for refractory; SUPPORTIVE — ICU monitoring (dysautonomia + seizures), antiepileptic for seizures (levetiracetam preferred), symptomatic management for movements (clonazepam, benzo) + behavior (low-dose atypical antipsychotic + caution; or none — symptoms often paradoxical worsen with neuroleptics), dysautonomia management (avoid wild HR/BP swings — beta-blocker + alpha-2 agonist + careful), nutrition (NG/G-tube during severe phase, may need 6-12 mo); REHABILITATION — long, intensive multidisciplinary (PT, OT, speech, neuropsych) — recovery slow over months-years; LONG-TERM — relapse 20% (especially without tumor removal/no rituximab), monitor antibody titers + clinical, continued immunosuppression depending; OUTCOMES — 75% substantial recovery (slow + incomplete), 10% death/severe disability — early diagnosis + early treatment = best outcomes; PSYCHOSOCIAL — family + child + transition return to school + academic accommodation; OTHER autoimmune encephalitides (anti-LGI1, anti-CASPR2, anti-GABA-B, anti-AMPA) treatable similar approach; differential important — HSV encephalitis (treat empirically with acyclovir until ruled out!), neuroleptic malignant syndrome, primary psychiatric (PEDS!)

---

Anti-NMDA encephalitis = treatable autoimmune encephalitis. Female + ovarian teratoma association (~50%). Multi-modal first-line (steroid + IVIG + plasmapheresis) + tumor removal + escalation rituximab/cyclophosphamide for refractory. Prolonged rehab. Differential includes HSV encephalitis (empiric acyclovir). Long-term 75% recovery if treated early.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กหญิงอายุ 13 ปี ก่อนหน้านี้ healthy 4 wk ก่อน มี viral-like illness + flu symptoms ตอนนี้ ผิดปกติ behavioral + psychiatric (paranoia, hallucinations, mood lability) + abnormal movements (orofacial dyskinesia, choreoathetosis) + dysautonomia (HR fluctuation 60-180, BP swings) + seizures + sleep disturbance + decreased consciousness progressive

V/S: HR variable 60-160, BP variable 90/50 to 160/100, RR variable, Temp 37.0°C, BW 42 kg
Gen: alert with severe disorganization, agitation, orofacial movements, intermittent posturing

Lab: CBC + CMP normal; CSF — lymphocytic pleocytosis 25 + protein 80 + glucose normal + oligoclonal bands present
Viral PCR negative HSV/VZV/EV; brain MRI: subtle FLAIR changes hippocampi bilateral mild
EEG: extreme delta brush pattern (highly suggestive)
Anti-NMDA receptor antibodies POSITIVE serum + CSF (high titer)
Pelvic US + MRI: ovarian teratoma left (paraneoplastic in ~50% of females anti-NMDA — must search)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue aggressive chemo"},{"label":"B","text":"Pediatric End-of-life Palliative Care for DIPG (universally fatal pediatric tumor"},{"label":"C","text":"Refuse pain medication"},{"label":"D","text":"Continue intensive ICU care"},{"label":"E","text":"No family communication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric End-of-life Palliative Care for DIPG (universally fatal pediatric tumor — median survival 9-11 mo) — comprehensive family-centered approach: multidisciplinary palliative team — pediatric palliative + oncology + neurology + chaplain + child life + psychology + social work + nursing; ESTABLISH GOALS OF CARE — confirm family understanding + wishes + child if developmentally able (assent vs consent considerations) + advance directives + DNR/DNI orders + location of care preference (home, hospice, hospital); SYMPTOM MANAGEMENT comprehensive: PAIN — opioid (morphine 0.1-0.2 mg/kg PO/IV/SC q4h titrated + breakthrough q1-2 hr 10% of total daily) + adjuvants (acetaminophen, NSAID, gabapentin for neuropathic, methadone or hydromorphone if morphine inadequate), AVOID undertreatment (peds often undertreated); NAUSEA/VOMITING — ondansetron, dexamethasone, prochlorperazine, scopolamine patch; DYSPNEA — opioid (low-dose morphine helps subjective dyspnea + reduces work of breathing in dying), oxygen for comfort (not necessarily SpO2 target), fan, repositioning; SECRETIONS — glycopyrrolate, scopolamine (less sedating), suctioning gentle; SEIZURES — benzo PRN, may need continuous if frequent; AGITATION — benzo (midazolam, lorazepam, diazepam), antipsychotic if delirium, AVOID restraints; CONSTIPATION — laxative ALWAYS with opioid (osmotic + stimulant); NUTRITION — small frequent comfort feeds as tolerated, NG/G-tube usually NOT initiated late, may stop existing feeds if not desired/causing discomfort; FAMILY-CENTERED — frequent communication + emotional support + sibling support + bereavement counseling; child life specialist + chaplain + memory making + legacy projects (handprints, letters, photo books); HOME hospice if family prefers + supported (preferred most families when feasible — peds home hospice programs); pediatric hospice services (community Children''s Hospice International); BEREAVEMENT — anticipatory grief support before death, ongoing after, support groups; spirituality + cultural considerations + rituals; SCHOOL — communication with school + classmates appropriate developmental level; DONATION discussed if family wishes (organ — usually not possible DIPG); legal documentation; long-term — family grief counseling extends years; siblings — high risk for complicated grief + behavioral issues, support school + mental health; staff support — burnout + moral distress; education + advocacy + pediatric palliative care expanding; clinical research participation + tissue donation for research (PCBT — Pacific Coast Brain Tumor); GENERAL PRINCIPLES from AAP statement on pediatric palliative + WHO end-of-life: dignity + comfort + family + presence + adequate symptom management + concurrent care (palliative + disease-directed not exclusive) early integrated

---

Pediatric palliative care = comprehensive comfort + family-centered + symptom management + spiritual/emotional support. For DIPG (universally fatal), focus on quality of remaining time. Opioids + adjuvants for pain (avoid undertreatment). Address ALL symptoms. Multidisciplinary team. Home/hospice if preferred. Bereavement support extends post-death. Concurrent palliative + disease-directed care model.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'pediatrics'
  and scenario = 'เด็กชายอายุ 6 ปี known glioblastoma multiforme brainstem (DIPG — diffuse intrinsic pontine glioma) ได้ chemo + radiation 1 yr ago + progression ปัจจุบัน. ตอนนี้ 18 mo since diagnosis (median survival DIPG 9-11 mo) + multiple symptoms — ปวดศีรษะ + อาเจียน + dysphagia + drooling + dyspnea + agitation + bed-bound + cannot speak

V/S: HR 102, RR 22 irregular, SpO2 92% RA, BP 102/68, BW 18 kg (decreased from 22 kg)
Family wishes — discussed extensively — comfort care, no further oncologic treatment
Goals — minimize suffering, allow death with dignity, maintain quality of remaining time

MRI: progression of tumor — no further oncologic treatment options';

commit;
