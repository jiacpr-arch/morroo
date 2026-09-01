-- ===============================================================
-- UPDATE chunk 8/8: pediatrics (25 questions)
-- ===============================================================

begin;

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
