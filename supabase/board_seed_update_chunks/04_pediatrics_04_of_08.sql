-- ===============================================================
-- UPDATE chunk 4/8: pediatrics (25 questions)
-- ===============================================================

begin;

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

commit;
