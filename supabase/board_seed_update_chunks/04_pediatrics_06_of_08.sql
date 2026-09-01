-- ===============================================================
-- UPDATE chunk 6/8: pediatrics (25 questions)
-- ===============================================================

begin;

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

commit;
