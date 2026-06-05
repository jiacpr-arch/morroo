-- ===============================================================
-- UPDATE chunk 5/8: pediatrics (25 questions)
-- ===============================================================

begin;

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

commit;
