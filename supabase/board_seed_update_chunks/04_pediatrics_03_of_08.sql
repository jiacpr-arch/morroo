-- ===============================================================
-- UPDATE chunk 3/8: pediatrics (25 questions)
-- ===============================================================

begin;

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

commit;
