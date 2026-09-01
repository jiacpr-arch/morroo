-- ===============================================================
-- UPDATE chunk 7/8: pediatrics (25 questions)
-- ===============================================================

begin;

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

commit;
