-- ===============================================================
-- UPDATE chunk 3/8: internal_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue ART + observe; no specific renal treatment needed"},{"label":"B","text":"HIV-associated nephropathy / collapsing FSGS"},{"label":"C","text":"IV cyclophosphamide pulse alone"},{"label":"D","text":"Stop ART + IV methylprednisolone pulse"},{"label":"E","text":"Plasmapheresis as first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV-associated nephropathy / collapsing FSGS — Treat nephrotic syndrome + glomerular disease: (1) Continue ART and ensure adherence (VL suppression slows progression); (2) ACEi or ARB for proteinuria reduction (target < 1 g/d; here lisinopril titrate, monitor K, Cr) + BP target < 130/80; (3) Statin for hyperlipidemia from nephrotic syndrome; (4) Glucocorticoid (prednisolone 1 mg/kg/d up to 80 mg) considered in adult HIV-associated FSGS though evidence less robust than primary FSGS; (5) Manage edema (loop diuretic, sodium restriction); (6) Anticoagulation if albumin < 2.0-2.5 + high-risk features (membranous more); (7) Vaccinate pneumococcal + influenza + COVID; (8) Nephrologist follow-up + monitor for ESRD progression — APOL1 high-risk increases ESRD risk; eventually consider transplant

---

HIV-associated nephropathy (HIVAN) / collapsing FSGS in West African/Black ancestry strongly linked to APOL1 G1/G2 risk variants (2 risk alleles → high risk). KDIGO 2021 + AASLD/IDSA + HIV nephropathy guidelines: (1) Definitive — ART maintained, ensure VL suppression (HIVAN incidence dramatically reduced in ART era). (2) Renin-angiotensin blockade: ACEi or ARB → proteinuria, slows progression; monitor K, Cr (allow up to 30% Cr ↑ if stable). (3) BP target < 130/80 (SPRINT-applicable). (4) Steroid: data mixed; prednisolone 60-80 mg/d × 2-6 mo considered in some collapsing FSGS, especially if no contraindication. SONAR-style: not for routine HIVAN. (5) Lipids: statin for nephrotic dyslipidemia. (6) Anticoagulation: less common in FSGS vs membranous (membranous + albumin < 2.0-2.5 = highest VTE risk). (7) Vaccinations + opportunistic infection prophylaxis per CD4. (8) APOL1: 2 risk alleles → counsel re renal disease risk, transplant donor screening, possible APOL1-targeted therapy in trials (inaxaplin). (9) ESRD: dialysis, transplant (allograft outcomes good post-ART era). A ผิด — RAS blockade essential. C ผิด — cyclophosphamide for refractory rare. D ผิด — never stop ART. E ผิด — for TTP/anti-GBM not FSGS.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 45 ปี HIV positive on ART × 8 ปี, CD4 ปัจจุบัน 580, VL undetectable มา OPD ด้วย proteinuria 4+ จาก routine UA + edema ใน 6 สัปดาห์

V/S: BP 158/96, HR 76, RR 16, SpO2 98%
PE: periorbital + lower limb 3+ pitting edema, no rash, no ascites

Lab: Cr 1.8 (baseline 1.0), Albumin 2.4, Cholesterol 348, LDL 198, Triglyceride 412
UA: protein 4+, no RBC casts, oval fat bodies
24-hr urine protein: 8.2 g/d, Urine protein/Cr 7.8 g/g
C3 normal, C4 normal, ANA negative, HCV negative, HBV: anti-HBs +, ANCA negative
Kidney biopsy: focal segmental glomerulosclerosis (FSGS) — collapsing variant, severe podocyte effacement, no immune complex deposit
APOL1 genotype: 2 risk alleles (high-risk genotype)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase VT to 10 mL/kg PBW + decrease PEEP"},{"label":"B","text":"Moderate ARDS (P/F 100-200)"},{"label":"C","text":"Maximize FiO2 100% + remove PEEP"},{"label":"D","text":"Routine corticosteroids high-dose for all ARDS"},{"label":"E","text":"Liberal fluid bolus 30 mL/kg q6h"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate ARDS (P/F 100-200) — Continue lung-protective ventilation: VT 4-6 mL/kg predicted body weight (already optimal), plateau pressure ≤ 30, driving pressure < 15, PEEP titrated per ARDSnet table or transpulmonary pressure; permissive hypercapnia pH > 7.20; conservative fluid strategy (FACTT trial — avoid positive balance); prone positioning ≥ 16 hr/d if P/F < 150 (PROSEVA — mortality benefit); neuromuscular blockade only if severe and dyssynchrony; consider VV-ECMO if refractory (EOLIA, P/F < 80 despite optimization); no routine steroid but consider dexamethasone in moderate-severe per DEXA-ARDS; sedation light; daily SBT + SAT

---

Moderate ARDS by Berlin definition (acute < 7 d, bilateral opacities, not solely cardiac, P/F 100-200 with PEEP ≥ 5). ARDSnet/SCCM/ESICM 2023 ARDS guideline: (1) Lung-protective ventilation (ARMA trial NEJM 2000): VT 4-8 mL/kg PBW (target 6), plateau ≤ 30, driving pressure (Pplat − PEEP) < 15; permissive hypercapnia pH > 7.20. (2) PEEP titration: ARDSnet high-PEEP/FiO2 table or transpulmonary pressure / esophageal balloon. (3) Prone positioning ≥ 16 hr/d for moderate-severe (PROSEVA P/F < 150 — mortality reduction). (4) Conservative fluid strategy (FACTT) — less positive balance shortens vent days. (5) Neuromuscular blockade (cisatracurium) early if severe + dyssynchrony (ACURASYS positive; ROSE neutral in light sedation era — selective use). (6) Inhaled vasodilators (NO, epoprostenol): improve oxygenation, no mortality benefit. (7) VV-ECMO: severe refractory (P/F < 80, pH < 7.25 + PaCO2 ≥ 60); EOLIA / CESAR. (8) Steroids: dexamethasone 20 mg × 5 d then 10 mg × 5 d in moderate-severe COVID and ARDS (DEXA-ARDS by Villar — controversial but used). (9) Daily SAT + SBT; light sedation (RASS 0 to −2); early mobilization. A ผิด — high VT injurious. C ผิด — high FiO2 toxic, PEEP critical. D ผิด — routine high-dose not standard. E ผิด — fluid overload harmful.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 70 ปี admit ด้วย septic shock จาก urinary source ขณะนี้ on norepinephrine + IV meropenem ใน ICU วันที่ 4 มี acute pulmonary edema + ARDS

V/S: BP 102/64 on norepi 0.15 mcg/kg/min, HR 102, RR 26 on mechanical ventilation, P/F ratio 142, Temp 37.8°C
Lab: Hb 9.4, WBC 16,800, Plt 88,000, Cr 2.6 (baseline 1.0), Lactate 2.4 (down from 6.2)
CXR: bilateral patchy infiltrates, no clear pulmonary edema cardiogenic
Echo: LVEF 55%, no significant valve, no pericardial effusion
ABG: pH 7.34, PaO2 78 on FiO2 60% PEEP 12, PaCO2 42
VT 6 mL/kg PBW, plateau pressure 28';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral cephalexin × 10 d outpatient"},{"label":"B","text":"Right-sided infective endocarditis (MSSA) in IV drug user (Modified Duke criteria"},{"label":"C","text":"Vancomycin monotherapy × 2 weeks"},{"label":"D","text":"Watchful waiting until culture sensitivity"},{"label":"E","text":"Anticoagulation IV heparin for vegetation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Right-sided infective endocarditis (MSSA) in IV drug user (Modified Duke criteria: 2 major — positive blood cultures with typical organism + echo evidence of endocardial involvement) — IV antistaphylococcal therapy 4-6 weeks: cloxacillin/oxacillin/nafcillin 2 g q4h (MSSA-specific; cefazolin alternative); vancomycin if MRSA. Consider addition of gentamicin only for short period (no longer routine due to nephrotoxicity per ESC 2023). Daily clinical + repeat BCx q48h to document clearance. Surgical indications (Class I): heart failure from valve dysfunction, persistent bacteremia/vegetation despite > 5-7 d appropriate Rx, perivalvular abscess, large vegetation > 10 mm with embolic event, certain fungal/resistant organisms, recurrent septic PE from RV vegetation. Multidisciplinary endocarditis team consult. Substance use disorder treatment (MAT). HIV/HBV/HCV screen. Source control (any IV access)

---

Right-sided infective endocarditis in IVDU. Modified Duke criteria 2023: 2 major (positive BCx with typical organism + echo evidence) = definite IE. AHA 2015/2023 + ESC 2023 IE guideline: (1) Antimicrobial therapy by organism: - MSSA right-sided: cloxacillin/oxacillin/nafcillin 12 g/d × 4-6 wk; some uncomplicated right-sided IVDU MSSA: 2-week regimen of nafcillin + gentamicin per AHA (now controversial, mostly 4 wk). - MRSA: vancomycin or daptomycin 6 mg/kg/d (some prefer daptomycin for right-sided IE). - Streptococci viridans: penicillin G or ceftriaxone ± gentamicin. - Enterococcus: ampicillin + gentamicin or ampicillin + ceftriaxone. - HACEK: ceftriaxone. - Routine gentamicin combo for staph IE no longer recommended due to nephrotoxicity (ESC 2023). (2) Surgery indications (Class I): heart failure, uncontrolled infection (persistent BCx + > 5-7 d Rx, abscess, fistula), prevent embolism (large vegetation > 10 mm with embolic event, large mobile vegetation > 10 mm). (3) Echo: TEE > TTE for sensitivity (especially prosthetic valve); repeat if change in clinical status. (4) Repeat blood cultures q48-72 hr until clearance. (5) Daily monitoring for complications. (6) Addiction treatment: link to MAT, harm reduction. (7) Vaccines: HBV (if susceptible), pneumococcal. (8) Watch for septic emboli (lung in right-sided), AKI from drug + immune complex (Bartter Type GN). A ผิด — IE = IV abx weeks. C ผิด — MSSA: beta-lactam superior to vanco. D ผิด — sensitivity already (MSSA). E ผิด — anticoagulation increases hemorrhagic risk in IE.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 42 ปี IV drug user, no fixed home มา ED ด้วยไข้สูง 38.8°C × 2 สัปดาห์, อ่อนเพลีย, น้ำหนักลด 5 kg, เพิ่งสังเกตเห็นจุดดำๆ ใต้เล็บ + จุดแดงๆบนฝ่ามือ

V/S: BP 110/68, HR 102, RR 18, SpO2 96%, Temp 38.8°C
PE: harsh holosystolic murmur ที่ LLSB เพิ่มขึ้นด้วย inspiration (Carvallo sign — tricuspid), splinter hemorrhages, Janeway lesions ฝ่ามือ, Osler nodes finger pads, Roth spots in fundoscopy

Blood culture × 3 separated by ≥ 1 hr from different sites: all 3 + Staphylococcus aureus, MSSA
Transthoracic echo: tricuspid valve vegetation 1.5 cm, no LV vegetation
Transesophageal echo: confirms 1.5 cm mobile vegetation on TV, no perivalvular abscess, no perforation, normal LV function
CXR: multiple bilateral cavitary nodules consistent with septic emboli
HIV: negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for blood culture result before antibiotics"},{"label":"B","text":"Septic shock (sepsis-3 + vasopressor + lactate > 2 despite resuscitation)"},{"label":"C","text":"Aggressive 6 L crystalloid bolus regardless of response"},{"label":"D","text":"Norepinephrine before any fluid resuscitation"},{"label":"E","text":"Activated protein C (drotrecogin alfa)"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock (sepsis-3 + vasopressor + lactate > 2 despite resuscitation) — Hour 1 bundle (SSC 2021): (1) Measure lactate + remeasure if elevated; (2) Obtain blood cultures BEFORE antibiotics if no delay; (3) Broad-spectrum antibiotics WITHIN 1 hr (e.g., for CAP severe: beta-lactam + macrolide or respiratory FQ; broaden to ceftriaxone + azithromycin OR pip-tazo + macrolide if HAP risk); (4) Crystalloid 30 mL/kg within 3 hr (use balanced solution — RL preferred over NS per SMART/SALT-ED); (5) Vasopressor (norepinephrine first-line) for MAP ≥ 65 if hypotensive despite fluid; add vasopressin 0.03 U/min if norepi > 0.25-0.5 mcg/kg/min; epinephrine 3rd line; corticosteroid (hydrocortisone 200 mg/d) if refractory shock; source control; lung-protective ventilation; conservative transfusion (Hb > 7); glucose 140-180; VTE + stress ulcer prophylaxis; daily assessment de-escalation

---

Septic shock — Surviving Sepsis Campaign 2021 + 2024 update: (1) Hour-1 Bundle: lactate, blood cultures, broad-spectrum antibiotics, 30 mL/kg crystalloid in hypotension/lactate ≥ 4, vasopressor for refractory hypotension. (2) Fluid: balanced crystalloid (lactated Ringer, Plasma-Lyte) preferred over normal saline (SMART trial — less AKI); albumin if requiring large volumes. Dynamic measures (passive leg raise, stroke volume variation, IVC variability) to guide further fluid — avoid fluid overload (CLASSIC, CLOVERS data — restrictive may be non-inferior; ongoing debate). (3) Vasopressor: norepinephrine first; add vasopressin 0.03 U/min as norepi-sparing or for AVP-deficient; epinephrine for refractory; phenylephrine and dopamine not first-line. MAP target ≥ 65; higher in chronic HTN (SEPSISPAM hint). (4) Corticosteroid: hydrocortisone 50 mg q6h or 200 mg infusion for vasopressor-requiring septic shock (ADRENAL, APROCCHSS). (5) Empiric antibiotics within 1 hr: cover suspected source; for CAP severe — beta-lactam + macrolide (Cochrane); broaden for resistant organism risk. (6) Source control within 6-12 hr. (7) Mechanical ventilation: lung-protective. (8) Glycemic control 140-180. (9) VTE prophylaxis (LMWH unless contraindicated). (10) Stress ulcer prophylaxis high-risk only. (11) Nutrition: early enteral. (12) Drotrecogin alfa withdrawn (PROWESS-SHOCK negative). A ผิด — antibiotic delay = mortality. C ผิด — fluid not endless; reassess. D ผิด — fluid first then vaso (or concurrent). E ผิด — withdrawn drug.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 32 ปี admit ICU ด้วย septic shock จาก community-acquired pneumonia

V/S เริ่มต้น: BP 78/44 (MAP 56), HR 124, RR 32, SpO2 88% on 6L NC, Temp 39.2°C
Lactate 4.8 mmol/L, qSOFA 3, SOFA 8
Lab: WBC 22,000 (N 88%, bands 12%), Plt 88,000, Cr 1.8, Bili 1.6
CXR: RLL consolidation
Blood + sputum cultures sent

คำถาม: management ใน hour 1 + ongoing per Surviving Sepsis Campaign';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic lock therapy alone + retain catheter"},{"label":"B","text":"Catheter-related bloodstream infection (CRBSI) MRSA in HD patient"},{"label":"C","text":"Retain catheter + oral linezolid 600 mg BID × 10 d"},{"label":"D","text":"Remove catheter + cefazolin 1 g IV post-HD only"},{"label":"E","text":"Echinocandin coverage assumed fungal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Catheter-related bloodstream infection (CRBSI) MRSA in HD patient — Definitive management: Remove catheter (S. aureus = absolute indication for removal per IDSA) + IV vancomycin (target trough 15-20 mg/L หรือ AUC 400-600) or daptomycin 6-8 mg/kg/dose post-HD × at least 4-6 weeks (S. aureus longer 4-6 wk due to metastatic infection risk; check TEE to rule out IE which would extend to 6 wk and consider surgical) + temporary vascath/femoral for HD while waiting + replace tunneled catheter at new site after blood cultures clear ≥ 48-72 hr + monitor for complications (endocarditis, septic arthritis, osteomyelitis, septic emboli); long-term vascular access planning (AVF) ideal

---

Catheter-related bloodstream infection in HD patient. IDSA 2009 CRBSI + 2016 vascular catheter + KDOQI vascular access guidelines: (1) Diagnosis CRBSI: same organism from catheter + peripheral blood (paired cultures with differential time to positivity > 2 hr suggests catheter source); 2 catheter cultures with same organism; quantitative blood culture catheter:peripheral ratio ≥ 3:1. (2) Catheter removal MANDATORY for: S. aureus, P. aeruginosa, Candida, complications (endocarditis, septic thrombophlebitis, persistent bacteremia > 72 hr despite Rx). (3) Antibiotic selection: empiric vancomycin (HD setting MRSA common) + Gram-negative coverage (cefepime, ceftazidime). De-escalate per culture. (4) Duration: - Uncomplicated CoNS: 5-7 days. - MSSA: 4 weeks (rule out IE with TEE — if positive 6 wk + surgical assessment). - MRSA: 4-6 weeks. - Gram-negative: 7-14 days. - Candida: 14 days from first negative culture + ophth exam. (5) Lock therapy + retain catheter: salvage option for coagulase-negative staph or Gram-neg in selected patients without complications, NOT for S. aureus / Candida. (6) Repeat blood cultures 2-4 d after starting therapy to ensure clearance. (7) TEE: S. aureus bacteremia routinely (high IE rate); MSSA bacteremia 28-day rule (TEE within 5-7 d). (8) Vascular access plan: transition to AVF (preferred) or AVG. A ผิด — S. aureus needs removal. C ผิด — retain not allowed for S. aureus. D ผิด — cefazolin OK for MSSA not MRSA. E ผิด — bacterial not fungal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 58 ปี underlying T2DM, ESRD on hemodialysis × 3 ปี via tunneled CVC right IJ มา ED ด้วยไข้ 38.6°C + rigors ทันทีหลังจาก HD เมื่อเช้า + แดงร้อน + เจ็บบริเวณ exit site catheter

V/S: BP 102/64, HR 108, RR 20, SpO2 96%, Temp 38.6°C
PE: catheter exit site erythematous + purulent discharge, no tunnel tenderness, no septic emboli signs

Lab: WBC 14,200 (N 86%), Hb 10.2, Plt 198,000, Cr 6.8 (baseline 7.0), CRP 92
Blood culture × 2 from peripheral + catheter (paired): both positive Gram-positive cocci in clusters
Final ID: MRSA (vancomycin MIC 1.0, daptomycin susceptible)
TEE: no vegetation
CT chest: no septic emboli';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard 7+3 cytarabine + daunorubicin chemotherapy"},{"label":"B","text":"Acute promyelocytic leukemia (APL) with coagulopathy/DIC"},{"label":"C","text":"Imatinib (BCR-ABL targeted)"},{"label":"D","text":"Watchful waiting until risk stratification complete"},{"label":"E","text":"Plasmapheresis for coagulopathy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute promyelocytic leukemia (APL) with coagulopathy/DIC — Hematologic emergency: Start ATRA (all-trans retinoic acid) 45 mg/m² IMMEDIATELY on clinical suspicion (don''t wait for cytogenetic confirmation) + Arsenic trioxide (ATO) 0.15 mg/kg/d for low-intermediate risk per Lo-Coco APL0406 (ATRA + ATO without chemo); for high-risk (WBC > 10,000) add anthracycline (idarubicin) or gemtuzumab ozogamicin; aggressive coagulopathy support — transfuse cryoprecipitate to fibrinogen > 150, FFP, platelets > 30-50K (DIC + bleeding); monitor for differentiation syndrome (ATRA syndrome: fever, dyspnea, weight gain, infiltrates, hypoxia, hypotension) → dexamethasone 10 mg BID; tumor lysis prophylaxis (allopurinol/rasburicase, IV fluid); CNS prophylaxis high-risk; PCR monitoring of PML-RARA for MRD; aim cure rate > 90%

---

Acute promyelocytic leukemia (APL) = AML-M3 with t(15;17) PML-RARA fusion. Distinct hematologic emergency due to early hemorrhagic death from DIC. NCCN + Sanz/PETHEMA APL guideline: (1) Start ATRA IMMEDIATELY on clinical suspicion — bilobed promyelocytes + Auer rods + DIC is the trigger; delay = death. (2) Frontline regimen: - Low/intermediate risk (WBC < 10,000): ATRA + ATO (APL0406 Lo-Coco NEJM 2013 — no chemotherapy, > 90% cure, lower toxicity). - High risk (WBC ≥ 10,000): ATRA + ATO + idarubicin or gemtuzumab ozogamicin (cytoreduction). (3) Coagulopathy support: aggressive blood products — fibrinogen > 150 mg/dL (cryoprecipitate), platelets > 30-50K, FFP for INR; daily monitoring DIC panel; avoid heparin/antifibrinolytics (no clear benefit; increase thrombosis with antifibrinolytics paradoxically). (4) Differentiation syndrome (formerly ATRA syndrome): fever, weight gain, infiltrates, effusions, hypotension, AKI; 25% incidence; dexamethasone 10 mg BID at first sign; continue ATRA unless severe. (5) Tumor lysis prophylaxis: hydration, allopurinol or rasburicase. (6) CNS prophylaxis: intrathecal MTX × 4-6 doses for high-risk. (7) Maintenance: ATRA ± 6MP + MTX × 2 yr in some protocols. (8) MRD monitoring: PCR PML-RARA q3 mo for 2 yr. APL cure rate now > 90% — was 0% pre-ATRA era. A ผิด — APL needs differentiation therapy, not 7+3. C ผิด — imatinib for CML/BCR-ABL. D ผิด — wait = bleed death. E ผิด — plasmapheresis no role.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอ่อนเพลีย เลือดออกตามไรฟัน + จุดเลือดออกใต้ผิวหนัง (petechiae) ไข้ต่ำ 1 สัปดาห์ น้ำหนักลด 3 kg ใน 1 เดือน

V/S: BP 118/72, HR 96, RR 18, SpO2 98%, Temp 37.6°C
PE: pallor, petechiae lower extremities, gingival bleeding, no hepatosplenomegaly significant, no lymphadenopathy

Lab: Hb 7.4 (low), MCV 92, WBC 38,000 with 78% myeloblasts on peripheral smear (large cells with Auer rods + cytoplasm fine azurophilic granules), Plt 28,000
LDH 1,820, Uric acid 9.8, K 5.2, Phosphate 5.8, Ca 7.8, Cr 1.6
Fibrinogen 80, PT 18, aPTT 42, D-dimer 8,400 (DIC)
Bone marrow aspirate: > 90% promyelocytic blasts with abundant Auer rods + bilobed nuclei
Cytogenetics: t(15;17) PML-RARA fusion confirmed
FLT3 negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV vitamin K 10 mg + observe"},{"label":"B","text":"Warfarin-associated intracerebral hemorrhage"},{"label":"C","text":"Fresh frozen plasma 4 units alone over 8 hr"},{"label":"D","text":"Activated factor VII alone"},{"label":"E","text":"Restart warfarin within 24 hr to prevent stroke"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Warfarin-associated intracerebral hemorrhage — IMMEDIATE reversal: 4-factor Prothrombin Complex Concentrate (4F-PCC, e.g., Kcentra) 25-50 IU/kg IV based on INR (preferred over FFP per Cochrane + INCH trial — faster INR correction + less volume + less mortality) + IV vitamin K 10 mg slow IV (sustains reversal as PCC short-acting); recheck INR 30 min + 6 hr (target < 1.4); BP control target SBP 130-150 (ATACH-II/INTERACT data — aggressive < 140 safe but not superior); neurosurgery consult (no surgery typically for deep ganglia ICH unless deteriorating large lobar > 30 mL near surface); avoid prophylactic anticonvulsant; ICU monitoring; once stable + 4-8 weeks → discuss restarting anticoagulation (RESTART trial favors restart for AF stroke prevention; weigh against rebleed)

---

Warfarin-associated ICH — life-threatening, requires urgent reversal. AHA/ASA 2022 ICH + Neurocritical Care 2016 anticoagulant reversal + ISTH guidelines: (1) Vitamin K antagonist (warfarin) reversal: - 4F-PCC (Kcentra) 25-50 IU/kg IV based on INR — INCH trial NEJM 2016 showed faster INR correction vs FFP, but did not improve mortality; preferred per Cochrane due to speed + small volume. - IV vitamin K 10 mg slow infusion (anaphylactoid risk; provides sustained reversal beyond PCC''s short half-life of factors). - Recheck INR 30 min + 6 hr; goal < 1.4. - FFP alternative if PCC unavailable but slower + larger volume. (2) DOAC reversal: - Dabigatran: idarucizumab (Praxbind). - Factor Xa inhibitor (apixaban, rivaroxaban): andexanet alfa (ANNEXA-4, ANNEXA-I) — class IIa; or 4F-PCC if andexanet unavailable. (3) BP target ICH: SBP 130-150; aggressive < 140 in ATACH-II safe but mortality benefit unclear (INTERACT2). (4) Surgical: minimally invasive surgery (ENRICH trial 2024 — benefit in lobar ICH 30-80 mL). DC for cerebellar > 3 cm or hydrocephalus. (5) Restart anticoagulation: balance stroke risk vs rebleed; typically 4-8 weeks for lobar (higher CAA rebleed) or earlier for deep (hypertensive); RESTART, SoSTART trials. (6) Seizure prophylaxis only if seizure, not routine. A ผิด — vit K alone too slow. C ผิด — FFP slower, large volume, less effective. D ผิด — rFVIIa increased thrombosis without benefit. E ผิด — too early restart = rebleed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 68 ปี underlying COPD + AF on warfarin (INR target 2-3, last INR 2.4) มา ED ด้วยเลือดออกในสมอง (acute ICH) จาก fall

V/S: BP 184/102, HR 88, RR 22, SpO2 95%, GCS 13
Neuro: right hemiparesis 2/5, NIHSS 16
CT brain: left putaminal hemorrhage 35 mL, no IVH, mild midline shift
INR 2.6, Hb 11.2, Plt 218,000, Cr 1.0
Fibrinogen 320';

update public.mcq_questions
set choices = '[{"label":"A","text":"Start allopurinol 300 mg/d ทันทีระหว่าง acute attack"},{"label":"B","text":"Acute gout (3rd attack with monosodium urate crystals confirmed)"},{"label":"C","text":"Antibiotic for septic arthritis empirically"},{"label":"D","text":"Urate-lowering therapy alone without addressing acute pain"},{"label":"E","text":"Continuous opioid analgesia only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute gout (3rd attack with monosodium urate crystals confirmed) — Acute attack treatment options (similarly effective): (1) NSAIDs (naproxen 500 mg BID, indomethacin 50 mg TID) × 5-7 d — first-line if no CKD/PUD/CV contraindication; (2) Colchicine 1.2 mg then 0.6 mg 1 hr later then 0.6 mg BID until resolved (low-dose AGREE trial preferred over old high-dose); (3) Glucocorticoid PO/IA — prednisolone 30-40 mg/d taper 7-14 d or intra-articular if single joint; (4) IL-1 inhibitor (anakinra, canakinumab) refractory; THEN urate-lowering therapy (ULT) AFTER attack settles OR start during acute with adequate flare prophylaxis (ACR 2020 — can start ULT during flare): allopurinol initial 100 mg/d (50 mg in CKD 4-5) titrate q2-5 wk to target serum urate < 6 (< 5 with tophi); HLA-B*5801 screening in Han Chinese, Thai, Korean (SJS/TEN risk); febuxostat alternative; flare prophylaxis with colchicine 0.6 mg/d × 3-6 mo when starting ULT; lifestyle modification

---

Acute gout — classic podagra + needle-shaped negatively birefringent MSU crystals (gold standard). ACR 2020 + EULAR 2016 gout guideline: (1) Acute attack treatment (first-line — pick one): - NSAIDs (any FDA-approved): naproxen, indomethacin, etoricoxib; caution CKD, PUD, CV. - Colchicine: 1.2 mg → 0.6 mg 1 hr later → 0.6 mg BID until resolved (AGREE trial — low-dose non-inferior, less toxicity). Avoid CYP3A4/PgP interactions (clarithromycin, statin) → toxicity. - Glucocorticoid: oral prednisolone 30-40 mg × 5-10 d taper; IM/IA injection if single joint, can''t take oral. - IL-1 inhibitor for refractory: anakinra (daily), canakinumab. (2) Urate-lowering therapy (ULT) indications (ACR 2020): ≥ 2 attacks/yr, tophi, CKD stage ≥ 3, urate stones; conditionally even after 1st attack if young/comorbid/high urate. (3) ULT options: - Allopurinol (xanthine oxidase inhibitor): start 100 mg/d (50 mg in CKD 4-5), titrate q2-5 wk; target serum urate < 6 (< 5 with tophi); SJS/TEN risk in HLA-B*5801 (high in Han Chinese, Thai, Korean) — screen before starting per ACR. - Febuxostat: 2nd line; CV mortality concern (CARES trial). - Uricosuric (probenecid): if underexcretor + normal renal. - Pegloticase: refractory tophaceous. (4) Flare prophylaxis when starting ULT: colchicine 0.6 mg/d × 3-6 mo (avoids paradoxical flares from urate mobilization). (5) Can start ULT during attack (ACR 2020 changed from waiting). (6) Lifestyle: limit purine-rich (organ meats, seafood), fructose, alcohol (esp beer); weight loss; consider losartan, fenofibrate (mild uricosuric effect). A ผิด — start ULT during attack OK but not at 300 mg without titration. C ผิด — Gram stain neg, crystals + = gout. D ผิด — need analgesia. E ผิด — opioid alone misses anti-inflammatory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวที่ทราบ มาด้วยปวดข้อนิ้วเท้ามาก รุนแรง onset 6 ชม. หลังกินอาหารทะเล + เบียร์เยอะ ตื่นมาเจ็บมากจนเดินไม่ได้

V/S: BP 138/82, HR 96, RR 16, Temp 38.0°C
PE: 1st MTP right swollen, erythematous, warm, exquisitely tender (typical podagra), no other joint involved, no tophi

Lab: Uric acid 9.2 mg/dL, CRP 48, WBC 12,400, Cr 1.1, no leukocytosis other
Joint aspiration: negatively birefringent needle-shaped crystals on polarized microscopy, WBC 28,000 (predominant neutrophil), Gram stain negative, culture pending
Previous: 2 similar episodes in past year self-limited';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for temporal artery biopsy before treatment"},{"label":"B","text":"Giant cell arteritis with cranial ischemic symptoms (jaw claudication + amaurosis fugax = imminent permanent vision loss risk)"},{"label":"C","text":"Methotrexate alone first-line"},{"label":"D","text":"NSAIDs only"},{"label":"E","text":"Oral prednisolone 20 mg/d to avoid side effects"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant cell arteritis with cranial ischemic symptoms (jaw claudication + amaurosis fugax = imminent permanent vision loss risk) — Start high-dose glucocorticoid IMMEDIATELY without waiting for biopsy: IV methylprednisolone pulse 500-1000 mg × 3 d (for visual symptoms) followed by oral prednisolone 1 mg/kg/d (max 60-80 mg); without visual symptoms: oral prednisolone 40-60 mg/d; obtain temporal artery biopsy within 2 weeks (steroid does not change pathology that quickly) — bilateral or 2 cm segment; treat PMR component overlap; add tocilizumab (anti-IL-6) as steroid-sparing per GiACTA trial (especially in refractory or steroid-toxicity risk); aspirin 81 mg may reduce ischemic events (some controversy); bone health (calcium, vit D, bisphosphonate); PCP prophylaxis if prolonged steroid; very slow taper over 1-2 yr; relapse common — monitor ESR/CRP + clinical

---

Giant cell arteritis (GCA) with cranial/ischemic symptoms — emergency. Classic features: > 50 yr (most > 70), new headache, scalp tenderness, jaw claudication, visual disturbance (amaurosis fugax → AION → blindness), PMR overlap (40-50%), constitutional, ESR/CRP↑, anemia, thrombocytosis. ACR/Vasculitis Foundation 2021 + EULAR GCA guideline: (1) START STEROID FIRST — do not wait for biopsy (steroid does not eliminate vasculitis on histology within 2 weeks). - Visual symptoms: IV methylprednisolone 500-1000 mg × 3 d → oral prednisolone 1 mg/kg/d. - No visual symptoms: oral prednisolone 40-60 mg/d. (2) Diagnostic confirmation: - Temporal artery biopsy (TAB) within 2 weeks: 2 cm segment, bilateral consider (skip lesions). - US TA: halo sign, compression sign — high specificity. - MR or PET-CT for large vessel involvement (50% LV GCA). (3) Tocilizumab (anti-IL-6R) — GiACTA trial NEJM 2017 — steroid-sparing, faster remission; option in initial or relapsed/steroid-toxicity. (4) Aspirin 81 mg: may reduce stroke/vision loss (mixed evidence). (5) Steroid taper: very slow over 1-2 yr; relapse 40-50%. (6) Adjuncts: bone health (DXA, Ca/vit D, bisphosphonate if prolonged), glucose monitoring, PCP prophylaxis (if pred ≥ 20 mg × ≥ 1 mo), cataract/glaucoma monitoring. (7) Large vessel involvement: surveillance for aortic aneurysm (CXR or aortic imaging annually). A ผิด — vision loss imminent. C ผิด — MTX adjunct not first-line. D ผิด — NSAID inadequate. E ผิด — 20 mg insufficient for GCA + vision.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 72 ปี มาด้วยปวดศีรษะข้างขวา + scalp tenderness + jaw claudication (เคี้ยวแล้วล้าจนต้องหยุด) มา 3 สัปดาห์ + transient vision loss (amaurosis fugax) ตา ขวา 1 ครั้ง 1 วันก่อน + อาการอ่อนเพลีย น้ำหนักลด ปวดไหล่ + สะโพกตอนเช้า (PMR symptoms)

V/S: BP 138/82, HR 78, Temp 37.4°C
PE: tender thickened cordlike right superficial temporal artery, decreased pulse, no visual field defect on exam, fundus normal at moment

Lab: ESR 92, CRP 64, Hb 10.4 (anemia of chronic disease), Plt 484,000, normal LFT, normal CK
US temporal artery: "halo sign" + non-compressible right TA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical resection of involved lymph nodes"},{"label":"B","text":"Classical Hodgkin lymphoma, stage IIB bulky (unfavorable)"},{"label":"C","text":"Watchful waiting until B symptoms severe"},{"label":"D","text":"Rituximab monotherapy"},{"label":"E","text":"Bone marrow transplant first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Classical Hodgkin lymphoma, stage IIB bulky (unfavorable) — Treatment: ABVD chemotherapy (doxorubicin, bleomycin, vinblastine, dacarbazine) × 4 cycles + Involved-Site Radiation Therapy (ISRT) to bulky/initial sites; alternative escalated BEACOPP for higher-risk; PET-adapted therapy per RATHL/AHL2011 — interim PET after 2 cycles → if Deauville 1-3 (negative) consider omit bleomycin; if PET-positive escalate; pneumocystis prophylaxis with prolonged therapy; bleomycin lung toxicity monitoring (PFT, avoid high FiO2); cardiac monitoring doxorubicin; fertility preservation (sperm bank, oocyte cryopreservation) before therapy; vaccinations live attenuated complete pre-Rx; brentuximab vedotin + nivolumab/pembrolizumab for relapsed/refractory; long-term: secondary malignancy, cardiac, lung, thyroid surveillance

---

Classical Hodgkin lymphoma. Ann Arbor staging modified Cotswolds/Lugano 2014: stage I-IV + A/B (constitutional symptoms) + E (extranodal) + X (bulky > 10 cm). Risk stratification (EORTC/GHSG): - Early favorable: I/II without risk factors. - Early unfavorable: I/II with B symptoms, bulky, > 3 sites, ESR > 50 or extranodal. - Advanced: III/IV. NCCN + ESMO HL guideline: (1) Early favorable: ABVD × 2 + ISRT 20 Gy (RAPID, EORTC H10); or ABVD × 3-4 if RT avoidance. (2) Early unfavorable: ABVD × 4 + ISRT 30 Gy. (3) Advanced: ABVD × 6 or escBEACOPP × 4-6 (better PFS but more toxic); brentuximab vedotin + AVD (ECHELON-1) — superior PFS, neuropathy concern. (4) PET-adapted: interim PET-2 negative (Deauville 1-3) → de-escalate (drop bleomycin per RATHL); positive → escalate. (5) Toxicity: bleomycin (pneumonitis — PFT, age > 40 risk), doxorubicin (cardiac), pregnancy concerns. (6) Survivorship: secondary cancers (breast in young women receiving thoracic RT, lung, sarcoma), cardiac, hypothyroidism (40-50% post-thoracic RT), infertility, psychosocial. (7) Relapsed/refractory: salvage chemo + autologous SCT; brentuximab, PD-1 inhibitor (nivolumab, pembrolizumab); allogeneic SCT for refractory. (8) Fertility preservation: sperm bank, oocyte/embryo, ovarian tissue cryopreservation. A ผิด — surgery only for biopsy. C ผิด — curable cancer, treat. D ผิด — rituximab for CD20+ (NHL), HL is CD20-. E ผิด — BMT for relapsed/refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยน้ำหนักลด 8 kg ใน 3 เดือน + เหงื่อกลางคืน + ไข้ + ต่อมน้ำเหลืองโตคอด้านขวา ขนาด 3 cm × 4 cm หลายต่อม ไม่เจ็บ

V/S: BP 122/74, HR 86, RR 16, SpO2 99%, Temp 37.8°C
PE: cervical + supraclavicular + axillary lymphadenopathy non-tender rubbery; spleen tip palpable 2 cm BCM; no pruritus, no alcohol-induced pain

Lab: Hb 11.8, WBC 8,400, Plt 268,000, LDH 480, Cr 0.9, LFT normal, Uric 6.2, ESR 58
HIV: negative, HBsAg neg, anti-HCV neg, EBV positive (latent)
CT chest/abdomen/pelvis: bulky mediastinal mass 8 cm + cervical, axillary lymphadenopathy + spleen 14 cm
Lymph node excisional biopsy: Reed-Sternberg cells (multinucleated owl-eye nuclei) CD15+ CD30+ CD20− with mixed inflammatory background
→ Classical Hodgkin lymphoma, nodular sclerosis subtype
PET-CT: stage IIB (above diaphragm + B symptoms + bulky)
BM biopsy: no involvement
Echo LVEF 60%, PFT normal, fertility counseling done';

update public.mcq_questions
set choices = '[{"label":"A","text":"CT brain ก่อน LP ในทุกรายของ suspected meningitis"},{"label":"B","text":"Suspected acute bacterial meningitis"},{"label":"C","text":"LP first then antibiotics"},{"label":"D","text":"Acyclovir IV monotherapy"},{"label":"E","text":"Delay antibiotics until culture confirms organism"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected acute bacterial meningitis — Sequence: (1) Blood cultures × 2 immediately; (2) Empirical antibiotics WITHIN 1 hr (do NOT delay for CT/LP): ceftriaxone 2 g IV q12h + vancomycin 15-20 mg/kg q8-12h (cover S. pneumoniae, N. meningitidis, drug-resistant pneumococcus); add ampicillin 2 g q4h ถ้า > 50 yr or immunocompromised (Listeria coverage); (3) Adjunctive dexamethasone 10 mg IV q6h × 4 d started BEFORE or with first antibiotic dose (improves outcomes in pneumococcal — DeGans NEJM 2002); (4) CT brain BEFORE LP only if: immunocompromised, history of CNS disease, new seizure, papilledema, focal neuro deficit, altered consciousness (this patient GCS 13 may qualify — but don''t delay antibiotics); (5) LP after CT if no contraindication: opening pressure, cell count, glucose, protein, Gram stain, culture, PCR (meningococcal, pneumococcal, HSV, enterovirus); (6) Isolate (droplet precaution for meningococcus); contact prophylaxis (ciprofloxacin or rifampin) for close contacts of N. meningitidis; notify public health

---

Acute bacterial meningitis — neurological emergency. IDSA 2004 (updated) + ESCMID 2016 + Thai ID Society guideline: (1) Antibiotics within 1 hr of presentation reduces mortality — every hour delay = ↑ mortality 13%. (2) Empirical regimen: ceftriaxone + vancomycin (Asia: vancomycin covers drug-resistant pneumococcus; ceftriaxone for meningococcus + susceptible pneumococcus + GNB). (3) Ampicillin if > 50 yr, immunocompromised, alcoholic, pregnant — covers Listeria (4-cephalosporin resistant). (4) Acyclovir 10 mg/kg IV q8h if HSV encephalitis suspected (focal neuro, temporal lobe, seizure). (5) Dexamethasone 10 mg IV q6h × 4 d before/with first antibiotic — Cochrane: reduces hearing loss + mortality in pneumococcal; stop if not pneumococcal/H. influenzae. (6) CT before LP indications (IDSA): immunocompromised, CNS lesion history, new seizure, papilledema, GCS reduced, focal deficit. If CT not immediately available — empirical antibiotic + CT + LP. (7) Public health: meningococcal = mandatory notification + droplet isolation until 24 hr antibiotic + chemoprophylaxis (ciprofloxacin 500 mg × 1, rifampin 600 mg BID × 2 d) for household + close contacts. A ผิด — CT for selected, not all. C ผิด — Antibiotics first, never delay. D ผิด — acyclovir for HSV not initial bacterial. E ผิด — culture takes days, can''t wait.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มา ED ด้วยไข้สูง 39.4°C + ปวดศีรษะรุนแรง + คอแข็ง + สับสน onset 18 ชม. ก่อนหน้านี้มี URI 3 วัน

V/S: BP 102/68, HR 112, RR 22, SpO2 97%, GCS 13 (E3V4M6)
PE: neck stiffness +, Kernig +, Brudzinski +, photophobia, no focal neuro, no papilledema, no rash

Lab: WBC 18,400 (N 92% bands 10%), Plt 168,000, Cr 1.0, Glucose 96, CRP 220

คำถาม: management ลำดับขั้นตอนใน suspected acute bacterial meningitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antipyretic + supportive care only"},{"label":"B","text":"Severe leptospirosis / Weil disease (icterohemorrhagic form)"},{"label":"C","text":"Empirical anti-malarial therapy first"},{"label":"D","text":"Steroid IV high-dose monotherapy"},{"label":"E","text":"Tetracycline + chloramphenicol combo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe leptospirosis / Weil disease (icterohemorrhagic form) — IV penicillin G 1.5 MU q6h OR IV ceftriaxone 1 g IV q24h × 7 days (ceftriaxone preferred, simpler, covers other tropical co-infections like scrub typhus pending diagnosis; doxycycline 100 mg PO/IV BID alternative in mild cases — preferred for outpatient prevention/treatment). Supportive: aggressive fluid for AKI (avoid overload — capillary leak), pressors if shock, possibly hemodialysis if oliguric/severe metabolic derangement; monitor for: pulmonary hemorrhage syndrome (severe form — high mortality), DIC, jaundice, myocarditis; Jarisch-Herxheimer reaction watch (first 24 hr of antibiotics); notify public health (notifiable disease in Thailand); occupational + environmental exposure history; rodent contact, paddy field water — high prevalence in Thai farmers

---

Severe leptospirosis (Weil disease) — tropical zoonotic disease common in Thai paddy farmers, fishermen, post-flooding. Clinical triad: jaundice + AKI + hemorrhage. Other clues: calf tenderness, conjunctival suffusion (non-purulent), exposure history. WHO + Thai Leptospirosis guideline + Faine criteria: (1) Antibiotics — start ASAP (effectiveness ↓ after 5-7 d but still beneficial): - Severe/hospitalized: IV penicillin G 1.5 MU q6h OR IV ceftriaxone 1 g/d × 7 d (LeptIM trial — ceftriaxone non-inferior to penicillin, easier dosing, broader cover). - Mild outpatient: doxycycline 100 mg BID × 7 d. - Doxycycline 200 mg/week — chemoprophylaxis in high-exposure flood. (2) Jarisch-Herxheimer reaction: 24 hr after antibiotics — fever + shock; supportive. (3) Supportive: - AKI: cautious fluid, RRT for severe oliguric AKI or refractory acidosis. - Pulmonary hemorrhage (severe — high mortality): ARDS lung-protective ventilation; some advocate corticosteroid for SPHS (mixed evidence). - DIC: blood products. - Plasma exchange controversial. (4) Differential in tropical fever: scrub typhus (eschar, similar regions), dengue (positive NS1), malaria (P. falciparum), rickettsia, melioidosis (Burkholderia in NE Thailand — different exposure). (5) Public health notification + environmental investigation + community education. A ผิด — needs antibiotic. C ผิด — pattern fits Weil not malaria primarily. D ผิด — steroid not standard. E ผิด — old regimen, not first-line.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 28 ปี เกษตรกร อาชีพปลูกข้าว เพิ่งเข้าทุ่งนาน้ำท่วม 2 สัปดาห์ก่อน ขาเท้ามีแผลถลอกขณะลุยน้ำ มาด้วยไข้สูง 39.5°C × 6 วัน + ปวดศีรษะรุนแรง + ปวดน่อง + ตาแดง (conjunctival suffusion) + คลื่นไส้ + ปัสสาวะสีเข้ม

V/S: BP 92/56, HR 124, RR 22, SpO2 95%, Temp 39.5°C
PE: jaundice +, conjunctival suffusion (no purulent discharge), calf tenderness + (hallmark), no rash, lung mild crackles bilateral, abdomen mild tender, no meningismus

Lab: Hb 12.0, WBC 15,200 (N 86% — neutrophilic), Plt 78,000, Cr 3.2 (AKI), Bilirubin 8.4 (direct 5.2), AST 88, ALT 68, ALP 280, CK 6,200 (rhabdomyolysis), Lactate 2.4, INR 1.6
UA: protein 2+, granular casts, no RBC casts
CXR: bilateral patchy infiltrates (pulmonary hemorrhage)
Microscopic agglutination test (MAT) pending; leptospira IgM rapid test positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home + paracetamol + NSAID + observe outpatient"},{"label":"B","text":"Dengue with warning signs cusp (rising Hct + dropping platelets at critical phase day 4-5 = transitioning to critical/leak phase)"},{"label":"C","text":"Aggressive IV fluid 30 mL/kg bolus regardless of phase"},{"label":"D","text":"Prophylactic platelet transfusion if Plt < 50,000"},{"label":"E","text":"Empirical antibiotics for febrile illness"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dengue with warning signs cusp (rising Hct + dropping platelets at critical phase day 4-5 = transitioning to critical/leak phase) — admit + monitor q4-6h V/S + Hct + UO + warning signs; isotonic IV fluid (Ringer lactate or NS) titrate to maintain UO 0.5-1 mL/kg/hr + Hct stability; serial Hct (every 4-6 hr in critical phase); paracetamol ONLY (avoid NSAIDs, aspirin — bleeding risk); platelet transfusion only if active bleeding (not prophylactic by count alone unless < 10K in some); avoid IM injection, central lines if possible; recognize compensated/decompensated dengue shock (narrow pulse pressure < 20 mmHg → IV crystalloid bolus 10-20 mL/kg; refractory → colloid + look for occult bleeding); convalescent phase (day 6-7 onwards): reabsorption — STOP/reduce IV fluid to prevent overload (most common iatrogenic harm)

---

Dengue fever transitioning into critical phase (day 4-6 — plasma leakage). WHO + Thai Dengue 2009 + 2022 guideline: (1) Phases: - Febrile (day 1-3): high fever, malaise, headache, retro-orbital pain. - Critical (day 4-6, around defervescence): plasma leakage — rising Hct, falling platelets; risk of shock, bleeding, organ impairment. - Recovery (day 7-10): reabsorption of leaked fluid; risk of fluid overload, pulmonary edema, hyponatremia. (2) Warning signs (WHO 2009): abdominal pain, persistent vomiting, mucosal bleeding, lethargy/restlessness, hepatomegaly > 2 cm, ↑ Hct + ↓ platelet. (3) Severe dengue: severe plasma leakage (shock, fluid accumulation with respiratory distress), severe bleeding, severe organ impairment (AST/ALT ≥ 1000, CNS, cardiac, AKI). (4) Fluid management cornerstone: - Maintenance crystalloid (RL/NS) titrate by UO + Hct + clinical. - Shock (DSS): 10-20 mL/kg bolus crystalloid; refractory → colloid (dextran-70, gelofusine); blood transfusion if Hct ↓ rapidly (occult bleed). - Recovery phase: ↓ IV rapidly; furosemide if overload. (5) Antipyretic: paracetamol only; NO NSAIDs/aspirin (bleeding, Reye). (6) Platelet transfusion: NOT prophylactic by number alone in dengue; only with active significant bleeding or < 10K with risk factors. Cochrane: no benefit prophylactic. (7) IM injection avoid; line placement minimal; safe NG if bleeding. (8) Surveillance: notifiable disease; vector control. (9) Discharge: afebrile > 48 hr, clinical improvement, rising platelets, stable Hct, good UO. A ผิด — critical phase needs monitoring. C ผิด — aggressive fluid → overload. D ผิด — no prophylactic transfusion. E ผิด — viral.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 24 ปี ไม่มีโรคประจำตัว มาด้วยไข้สูง 39°C × 4 วัน + ปวดเมื่อยกล้ามเนื้อ + ปวดข้อ + ปวดหลังตา + ผื่น maculopapular วันที่ 3-4 ก่อน defervescence

V/S: BP 102/64, HR 104, RR 18, SpO2 99%, Temp 38.6°C
PE: tourniquet test positive (> 20 petechiae/inch²), no jaundice, abdomen soft no ascites, no organomegaly

Lab: Hb 13.8 (baseline 12.0 — rising hemoconcentration), Hct 41% (rising), WBC 3,200 (low), Plt 88,000 (falling from 165,000 at day 1), AST 142, ALT 98, Cr 0.7, glucose 92, K 3.6, Albumin 3.4
Dengue NS1 antigen positive; IgM positive; IgG negative (primary)
ไม่มี warning signs ของ severe dengue ขณะนี้: no severe abdominal pain, no persistent vomiting, no mucosal bleeding, no lethargy, no fluid accumulation, no hepatomegaly > 2 cm
Does not yet meet criteria for severe dengue';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ampicillin-sulbactam IV"},{"label":"B","text":"Scrub typhus (Orientia tsutsugamushi)"},{"label":"C","text":"Praziquantel for parasitic infection"},{"label":"D","text":"Antiviral oseltamivir empirical"},{"label":"E","text":"IV cefepime + metronidazole"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Scrub typhus (Orientia tsutsugamushi) — characteristic eschar + tropical fever + regional exposure (North/Northeast Thailand) — First-line: doxycycline 100 mg PO/IV BID × 7 d (very rapid defervescence, often < 48 hr — clinical ''doxycycline response'' supports diagnosis); azithromycin 500 mg/d × 3-5 d alternative (preferred in pregnancy, children < 8 yr, doxy intolerance); chloramphenicol older alternative; ceftriaxone NOT effective (rickettsia is intracellular); severe disease (MOF, ARDS, meningoencephalitis) — IV doxycycline + supportive ICU; consider co-infection workup (leptospira, dengue, melioidosis common co-endemic in Thailand); notify public health (vector mite chiggers); occupation/exposure counseling + DEET; family/cluster investigation

---

Scrub typhus — Orientia tsutsugamushi via chigger mite bite; endemic in Asia-Pacific including Thailand (North/Northeast). Clinical: eschar (60-90% — pathognomonic black necrotic skin with rim of erythema, often inguinal/axillary/groin/genital — search carefully), fever, headache, myalgia, lymphadenopathy, maculopapular rash, hepatosplenomegaly. Complications: pneumonia, ARDS, meningoencephalitis, AKI, hepatitis, myocarditis, DIC, MOF. WHO + Thai ID + ICMR guideline: (1) First-line: doxycycline 100 mg BID × 7 d — rapid defervescence within 24-48 hr (response is diagnostic clue); IV in severe. (2) Azithromycin 500 mg/d × 3-5 d — preferred in pregnancy, children < 8 yr, doxy allergy/intolerance; effective in doxy-resistant strains (some Thai isolates). (3) Chloramphenicol 50-75 mg/kg/d — older alternative, blood dyscrasia risk. (4) Rifampin 600-900 mg/d × 7 d — used in some Asian doxy-resistant studies. (5) Beta-lactam NOT effective — intracellular pathogen. (6) Severe (MOF, ARDS, meningoencephalitis): IV doxycycline, supportive ICU care; mortality up to 30% if untreated. (7) Co-infection (Thailand co-endemic): always rule out leptospirosis, dengue, malaria, melioidosis. (8) Prevention: DEET, protective clothing, avoiding chigger-infested grass/shrub, doxycycline prophylaxis for short-term exposure. A ผิด — beta-lactam ineffective. C ผิด — not parasitic. D ผิด — not influenza. E ผิด — gram-positive/anaerobe regimens ไม่ครอบ rickettsia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 38 ปี ทำงานในป่าเขาภาคเหนือ มา 1 สัปดาห์ มาด้วยไข้สูง 39.2°C × 7 วัน + ปวดศีรษะ + ปวดเมื่อย + ไอแห้ง + cervical lymphadenopathy generalized

PE: small black eschar 5 mm ที่ inguinal region (eschar = patognomonic), generalized lymphadenopathy painless, maculopapular rash trunk, hepatosplenomegaly mild

Lab: Hb 13.0, WBC 9,800, Plt 96,000, AST 138, ALT 92, Cr 1.0, ESR 88
Weil-Felix: OX-K positive (suggestive)
Indirect immunofluorescence Orientia tsutsugamushi IgM positive → confirms scrub typhus
Malarial film negative, Dengue NS1 negative, leptospira IgM negative
ไม่มี severe complications (no MOF, no ARDS, no meningoencephalitis)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral doxycycline + observation"},{"label":"B","text":"Severe disseminated melioidosis (Burkholderia pseudomallei) — Two-phase therapy"},{"label":"C","text":"Ciprofloxacin alone × 14 d"},{"label":"D","text":"Vancomycin IV for gram-positive coverage"},{"label":"E","text":"Stop antibiotic once blood culture clears"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe disseminated melioidosis (Burkholderia pseudomallei) — Two-phase therapy: (1) **Intensive phase** (≥ 10-14 d, longer in severe disseminated): IV ceftazidime 50 mg/kg q6-8h OR meropenem 1 g q8h (meropenem preferred in severe sepsis, neuro, septic shock — MERTH trial); add IV TMP-SMX if deep-seated focus (CNS, bone, prostate, joint); (2) **Eradication phase** (3-6 months — usually 3 mo for skin, 6 mo for visceral abscess/bone/prostate): oral TMP-SMX 8/40 mg/kg/dose BID + folic acid; alternative doxycycline 100 mg BID + amoxicillin-clavulanate in TMP-SMX intolerance (less effective — higher relapse). Source control: drain large abscesses. Diabetes/alcohol management — major host risk factors. Lifelong relapse risk → adherence critical; report to public health (Northeast Thailand endemic); occupational exposure counseling (paddy field, mud, contaminated water/soil)

---

Melioidosis — Burkholderia pseudomallei, endemic in Northeast Thailand (Khon Kaen, Ubon — highest incidence globally), Southeast Asia, northern Australia. Bacterium of soil + surface water; risk factors = diabetes (most important — 50% of cases), alcoholism, CKD, thalassemia, chronic lung disease, occupational exposure (rice farmers). Disseminated form = highest mortality (40-60%). Limmathurotsakul/Wuthiekanun + Currie + IDSA Tropical guideline: (1) Intensive phase ≥ 10-14 d (longer 4-8 wk in severe/disseminated/deep): - IV ceftazidime 50 mg/kg q6-8h (max 8 g/d) — standard. - IV meropenem 1 g q8h — for severe sepsis, septic shock, ICU, neurological involvement (MERTH trial showed reduced mortality in severe cases). - Add IV TMP-SMX (8/40 mg/kg q12h) for: CNS, bone, joint, prostate, deep-seated focus. (2) Eradication phase 3-6 months (oral): - TMP-SMX 8/40 mg/kg per dose BID × 3 mo (skin, simple) or 6 mo (visceral abscess, bone, prostate) + folic acid 5 mg/d. - Alternative: doxycycline 100 mg BID + amoxicillin-clavulanate — higher relapse rate (~10%). (3) Source control: drainage of large abscesses; orchiectomy/prostatectomy for refractory prostate; cardiac surgery for endocarditis. (4) Host optimization: glycemic control (essential), alcohol cessation, treat comorbid. (5) Relapse: 5-15% — usually due to inadequate eradication; serial follow-up. (6) Public health: notifiable in Thailand; environmental investigation; education farmers re foot protection, avoiding mud, post-flood. A ผิด — disseminated severe needs IV intensive. C ผิด — cipro inadequate. D ผิด — gram-negative not positive. E ผิด — eradication phase 3-6 mo essential.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 56 ปี underlying T2DM long-standing, alcoholic, นาข้าวอีสาน มาด้วยไข้สูง + ฝีหนองที่ปอด + ตับ + ม้าม + ข้อ + ผิวหนัง 3 สัปดาห์ ก่อนหน้านี้ลุยน้ำขณะฝนตก

V/S: BP 96/58, HR 116, RR 24, SpO2 90% RA, Temp 39.0°C
PE: multiple skin abscess, hepatosplenomegaly, lung crackles + consolidation RLL

Lab: Hb 9.8, WBC 21,000 (N 88%), Plt 188,000, Cr 1.6, ALT 92, ALP 320, Bilirubin 2.4, Glucose 380
CXR: multilobar consolidation + cavitation + nodules
US abdomen: multiple liver + spleen abscesses
Blood + abscess pus culture × 4: Burkholderia pseudomallei (oxidase positive, gram-negative bipolar safety-pin stain) — sensitive ceftazidime, meropenem, TMP-SMX';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral artemether-lumefantrine × 3 d"},{"label":"B","text":"Severe Plasmodium falciparum malaria (parasitemia > 10%, severe anemia, AKI, jaundice, hypoglycemia, acidosis, hyperlactatemia, altered consciousness"},{"label":"C","text":"IV chloroquine (still effective in Africa)"},{"label":"D","text":"Primaquine alone first-line for radical cure"},{"label":"E","text":"Mefloquine PO empirical"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Plasmodium falciparum malaria (parasitemia > 10%, severe anemia, AKI, jaundice, hypoglycemia, acidosis, hyperlactatemia, altered consciousness — WHO severe malaria criteria multiple) — IV artesunate 2.4 mg/kg at 0, 12, 24 hr then daily (artesunate superior to quinine — SEAQUAMAT, AQUAMAT — ↓ mortality 35% adult, 22% pediatric); continue at least 24 hr IV regardless of clinical response, then complete with full oral artemisinin combination therapy (ACT) e.g., artemether-lumefantrine × 3 d (anti-relapse); supportive: cautious IV fluid (avoid overload — ARDS), correct hypoglycemia (D10), blood transfusion if Hb < 7 + symptomatic, dialysis for severe AKI, broad-spectrum antibiotics if concomitant sepsis (bacteremia common); exchange transfusion no longer routine recommended; monitor for delayed hemolysis 7-14 d post-artesunate; admit ICU

---

Severe Plasmodium falciparum malaria — high mortality if delayed. WHO severe malaria criteria: any 1 of impaired consciousness, prostration, multiple seizures, acidosis (HCO3 < 15, lactate > 5), hypoglycemia (< 40), severe anemia (Hb < 7 adult), AKI, hyperbilirubinemia (jaundice), pulmonary edema/ARDS, abnormal bleeding, shock, hyperparasitemia (> 10% in non-immune, > 5% in falciparum). WHO Malaria Treatment Guideline 2023 + Thai Vector-borne Disease guideline: (1) IV artesunate FIRST-LINE for severe malaria — 2.4 mg/kg at 0, 12, 24 hr then daily; minimum 24 hr IV; landmark trials SEAQUAMAT (Lancet 2005, Asia) and AQUAMAT (Lancet 2010, Africa pediatric) showed substantial mortality reduction over quinine. (2) Continue with full oral ACT regimen × 3 d for radical cure after IV done. (3) Quinine + doxycycline/clindamycin: second-line if artesunate unavailable; hypoglycemia + cardiotoxicity. (4) Supportive: - Fluids: cautious — over-resuscitation worsens ARDS/cerebral edema (FEAST principle). - Hypoglycemia: D10/D50; quinine-induced hyperinsulinism in pregnant. - Anemia: transfusion if Hb < 7 + symptomatic. - AKI: dialysis if oliguric, severe acidosis, fluid overload. - Sepsis: bacteremia common in severe malaria (especially African children) — empirical broad-spectrum antibiotics. - Avoid: routine steroid, exchange transfusion (no benefit). (5) Delayed hemolytic anemia post-artesunate (PADH) 7-14 d — monitor Hb. (6) Cerebral malaria: ICU, mannitol selectively for raised ICP. (7) Primaquine after acute Rx — only if confirmed P. vivax/ovale + G6PD-normal; not falciparum routine (gametocidal single dose 0.25 mg/kg for transmission control). (8) Chloroquine: NOT for P. falciparum (universal resistance); only in chloroquine-sensitive vivax. A ผิด — severe malaria = IV not oral. C ผิด — chloroquine resistance universal P. falciparum. D ผิด — primaquine for radical cure of vivax/ovale, not severe falciparum. E ผิด — mefloquine adjunctive prophylaxis/uncomplicated, not severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 35 ปี เพิ่งกลับจากซาฟารีในกานา 2 สัปดาห์ที่แล้ว ไม่ได้กินยา chemoprophylaxis มา ED ด้วยไข้สูง 40°C + chills + ปวดศีรษะ + คลื่นไส้ + ปัสสาวะสีดำ + ซีด

V/S: BP 88/52, HR 132, RR 28, SpO2 94%, Temp 40.2°C, GCS 13
PE: jaundice, pallor, hepatosplenomegaly +, no rash, no meningismus

Lab: Hb 6.4 (severe anemia), Plt 28,000, WBC 8,400, Cr 2.6, BUN 64, AST 142, ALT 88, Bilirubin 4.8 (mostly indirect — hemolysis), LDH 1,840, glucose 48 (hypoglycemia), Lactate 7.2 (severe), HCO3 14 (acidosis)
Thick blood film: high parasitemia 12% Plasmodium falciparum ring forms + few schizonts (ominous)
UA: hemoglobinuria + (blackwater fever)
No G6PD deficiency known';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral azithromycin + discharge home"},{"label":"B","text":"Severe healthcare-associated/nursing home pneumonia (NHAP) with sepsis"},{"label":"C","text":"Oral amoxicillin × 7 d outpatient"},{"label":"D","text":"Single antibiotic IV ceftriaxone only"},{"label":"E","text":"Antiviral oseltamivir alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe healthcare-associated/nursing home pneumonia (NHAP) with sepsis — admit (consider ICU given respiratory distress + sepsis + age + comorbid) + empirical IV broad-spectrum within 1 hr (sepsis bundle): cover MRSA + Pseudomonas (recent hospitalization, NH residence, prior antibiotics) — vancomycin (or linezolid for MRSA pneumonia advantage in lung penetration + thrombocytopenia consideration) + piperacillin-tazobactam OR cefepime OR meropenem (Pseudomonas + GNB); add azithromycin or respiratory FQ (atypical coverage); blood cultures + sputum Gram/culture before antibiotics if no delay; respiratory virus panel; urinary antigens (Legionella, pneumococcal); influenza/COVID test; oxygen + NIV if hypercapnic; conservative fluid for sepsis; de-escalate based on culture in 48-72 hr; duration 7-8 d for uncomplicated bacterial; 14 d if Pseudomonas/MRSA/cavitation; vaccinate after recovery (pneumococcal, influenza); goals-of-care discussion in dementia given prognosis

---

Severe pneumonia with sepsis in patient with healthcare-associated risk factors (nursing home, recent hospitalization, prior antibiotics). IDSA/ATS 2019 CAP + 2016 HAP/VAP guideline: (1) Risk stratification: CURB-65, PSI/PORT; ICU criteria (IDSA major/minor — invasive vent or septic shock = major; ≥ 3 minor). (2) HCAP concept officially removed from 2016 IDSA HAP/VAP — but for nursing home residents with severe pneumonia + recent hospital + comorbidities, MDR coverage warranted: - Standard severe CAP: beta-lactam (ceftriaxone/cefotaxime) + macrolide (azithromycin) OR respiratory FQ. - + Pseudomonas risk (structural lung dz, recent abx, recent hosp, NH): pip-tazo OR cefepime OR meropenem. - + MRSA risk (recent hospitalization, prior MRSA, dialysis, IVDU, post-influenza, cavitary): vancomycin or linezolid (linezolid: superior in MRSA pneumonia per ZEPHyR though debated; safer in renal). (3) Diagnostics: blood + sputum cultures (high-quality sputum), urinary antigens (Strep pneumo, Legionella), respiratory viral panel + influenza/COVID test. (4) Duration: 5-7 d uncomplicated, 7-8 d HAP, 14 d Pseudomonas/MRSA/abscess/empyema. (5) Adjuncts: oxygen, NIV for hypercapnia (avoid if altered mental status), conservative fluid, glycemic control, VTE prophylaxis, early enteral nutrition. (6) Vaccinate after recovery: PCV20 or PPSV23, annual influenza, COVID booster. (7) Steroid: dexamethasone 6 mg in severe CAP showed benefit in CAPE-COD NEJM 2023 — option but not yet universal. (8) De-escalate based on culture/clinical response 48-72 hr. (9) Failure to improve: complications (empyema, abscess), resistant organism, unusual pathogen (TB, fungal). (10) Dementia + severe pneumonia — palliative care discussion. A ผิด — severe = admit. C ผิด — severity needs IV broad. D ผิด — single agent doesn''t cover MRSA/Pseudo/atypical. E ผิด — bacterial likely primary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 78 ปี underlying COPD + dementia + nursing home resident มา ED ด้วยไข้ + ไอ + เสมหะ + เหนื่อย 3 วัน ก่อนหน้านี้ admit รพ. 1 เดือนก่อนสำหรับ pneumonia

V/S: BP 102/64, HR 108, RR 26, SpO2 88% RA → 93% on 4L NC, Temp 38.6°C
PE: confusion (worse than baseline), crackles LLL + dullness, accessory muscle use

Lab: WBC 22,000, Cr 1.6 (baseline 1.0), Lactate 2.6, Procalcitonin 8.4, BUN 38, Glucose 192, Hb 11.4
CXR: LLL consolidation
CURB-65 = 4, qSOFA = 2, PSI class V (high risk)
No penicillin allergy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat as DKA: NSS + insulin infusion + bicarbonate"},{"label":"B","text":"Hyperosmolar Hyperglycemic State (HHS)"},{"label":"C","text":"IV regular insulin bolus 0.1 U/kg before fluid resuscitation"},{"label":"D","text":"Discharge with adjustment of oral antidiabetic medication"},{"label":"E","text":"Rapid correction of glucose to normal in 2 hours"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperosmolar Hyperglycemic State (HHS) — older T2DM, severe hyperglycemia > 600, effective serum osmolality > 320 (here calc shows > 320), minimal ketosis, normal pH/AG: (1) Aggressive fluid replacement first (volume deficit 8-10 L typical) — NSS 1-1.5 L over 1 hr then 250-500 mL/hr; switch to ½NS when corrected serum Na ≥ 135; add D5/D10 once glucose 250-300 (continue insulin); (2) Insulin infusion 0.05-0.1 U/kg/hr started AFTER initial fluid bolus + K replete (no bolus needed); lower insulin rate than DKA; (3) Slow glucose correction — 50-75 mg/dL/hr to avoid cerebral edema (greater risk than DKA); (4) Slow Na correction — change < 10 mEq/L per 24 hr to prevent osmotic demyelination; (5) Replace K (target 4-5); (6) Identify precipitant: infection (most common — URI here, UTI, pneumonia), missed/inadequate insulin, new T2DM presentation, MI, stroke, drugs (steroid, diuretic, atypical antipsychotic); (7) VTE prophylaxis (HHS = hypercoagulable); (8) Mortality HHS > DKA (5-20%) — slower, sicker, older, comorbid; ICU admission

---

Hyperosmolar Hyperglycemic State (HHS, formerly HHNK) — diabetic emergency distinct from DKA. ADA 2024 + ADA Hyperglycemic Crises Consensus 2024: (1) Diagnostic criteria HHS: glucose > 600 mg/dL, effective serum osmolality > 320 mOsm/kg (calc: 2×Na + glucose/18 + BUN/2.8), pH > 7.3, HCO3 > 18, minimal/no ketosis, AG ≤ 12, altered mental status. (2) Pathophysiology: T2DM elderly; residual insulin secretion prevents lipolysis/ketosis but insufficient for glucose uptake; profound dehydration from osmotic diuresis (deficit 8-12 L). (3) Treatment differs from DKA — FLUID is primary, insulin secondary: - Fluid: NSS 1-1.5 L over 1 hr → 250-500 mL/hr; switch to ½NS when corrected serum Na ≥ 135. - K: replete if K < 5.3 (give 20-30 mEq/L of fluid); hold insulin if K < 3.3 until K replete. - Insulin: 0.05-0.1 U/kg/hr (lower than DKA) AFTER fluid initiated; NO bolus. - Glucose drop target 50-75 mg/dL/hr (slower than DKA); add D5W when glucose 250-300 + continue insulin. - Na: slow correction < 10 mEq/L per 24 hr; risk osmotic demyelination if too fast. (4) Precipitants: infection (most common — UTI, pneumonia, URI), missed meds, MI, stroke, new T2DM, steroids, atypical antipsychotics. (5) Complications: cerebral edema (esp pediatric, faster fluid → higher risk), thromboembolism (hypercoagulable — VTE prophylaxis), AKI, ARDS. (6) Mortality 5-20% (higher than DKA''s 1-5%) — older, sicker, more comorbidity. (7) ICU monitoring. (8) Resolution: osmolality normalized, glucose < 250, mental status improved → transition to SC insulin. A ผิด — not DKA (no ketosis, normal AG, normal pH). C ผิด — insulin before fluid → cardiovascular collapse + worsened cellular dehydration. D ผิด — emergency. E ผิด — rapid correction → cerebral edema.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 68 ปี underlying T2DM, HT มา ED ด้วยอาการสับสน + อ่อนเพลีย + ปัสสาวะเยอะ + กระหายน้ำมาก 4 วัน หลังจากเริ่มมี viral URI 1 สัปดาห์ก่อน ไม่กินอาหารและน้ำตามปกติ

V/S: BP 96/58, HR 124, RR 20, SpO2 97%, Temp 37.4°C, น้ำหนัก 68 kg
PE: dry mucous membrane, sunken eyes, lethargic, GCS 13, no Kussmaul breathing

Lab: Glucose 968 mg/dL, Na 138 (corrected 156 — Adj +1.6 per 100 above 100), K 4.8, Cl 110, HCO3 22, BUN 76, Cr 2.8, Anion gap 12 (NORMAL), Ketones beta-hydroxybutyrate 0.4 (minimal), Osm 392 mOsm/kg, Lactate 1.4, Albumin 3.4
Urinalysis: ketones trace (mild), glucose 4+
ABG: pH 7.34, PaCO2 38, HCO3 22';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral levothyroxine 100 mcg/d outpatient"},{"label":"B","text":"Myxedema coma (decompensated severe hypothyroidism)"},{"label":"C","text":"Active rewarming with hot blankets + warmed IV fluid only"},{"label":"D","text":"Withhold steroid until cortisol confirmed"},{"label":"E","text":"T3 alone without T4"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myxedema coma (decompensated severe hypothyroidism) — Endocrinology emergency: (1) IV T4 (levothyroxine) 200-500 mcg loading dose then 50-100 mcg/d (slow conversion to T3); IV T3 (liothyronine) 5-20 mcg loading then 2.5-10 mcg q8h CONCURRENTLY (faster onset; cardiac caution in elderly/CAD); (2) IV hydrocortisone 100 mg q8h (concurrent adrenal insufficiency common — give before T4 to prevent precipitating adrenal crisis from increased cortisol clearance); (3) Passive rewarming (active aggressive rewarming causes vasodilation + hypotension); (4) Supportive ventilation (CO2 retention from hypothyroid respiratory depression — mechanical ventilation often needed); (5) Hypotonic saline (D5W or D5½NS) cautious for hyponatremia + glucose support; (6) Identify precipitant (infection, cold, MI, sedative/opioid use, surgery, non-adherence); empirical antibiotics if infection suspected; (7) Avoid sedatives (cleared slowly); (8) ICU admission; mortality 20-40% despite treatment

---

Myxedema coma — decompensated severe hypothyroidism. Mortality 20-40%. Classic features: AMS/coma, hypothermia, hypoventilation, hyponatremia, hypoglycemia, bradycardia, hypotension. Often elderly female with chronic hypothyroidism precipitated by cold, infection, drugs (sedative, opioid, amiodarone), MI, surgery, non-adherence. ATA + Endocrine Society guideline: (1) Thyroid hormone replacement (regimens vary; controversial T4 alone vs T4+T3): - IV T4 (levothyroxine): 200-500 mcg loading bolus then 50-100 mcg/d; slow onset (1-3 d). - IV T3 (liothyronine): 5-20 mcg loading then 2.5-10 mcg q8h; faster onset (hours); cardiac risk (arrhythmia, MI in elderly/CAD); some advocate combination for severe coma. - Oral inadequate due to absorption issues. (2) Hydrocortisone 100 mg IV q8h BEFORE or with thyroid hormone — concurrent adrenal insufficiency common (primary or secondary); thyroid replacement can precipitate adrenal crisis by ↑ cortisol clearance. (3) Passive rewarming (warm blankets, room temp); avoid active aggressive rewarming (vasodilation → shock). (4) Supportive: - Ventilation: often need intubation for hypercapnic respiratory failure (decreased respiratory drive + edema + obesity hypoventilation). - Hyponatremia: hypertonic saline only if severe symptomatic; usually fluid restriction + slow correction; SIADH-like picture. - Hypoglycemia: D10 IV. - Hypotension: cautious fluid; pressor if persistent. (5) Identify precipitant: infection, MI, cold, drugs (amiodarone, lithium), trauma. (6) Empirical antibiotics if infection suspected. (7) Avoid sedatives (decreased clearance). (8) ICU monitoring. (9) Watch for atrial fibrillation, MI during T4 replacement. A ผิด — too slow, can''t absorb. C ผิด — aggressive rewarming = shock. D ผิด — give steroid empirically. E ผิด — T4 backbone with T3 supplement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 65 ปี underlying hypothyroidism (สรุปไม่ได้กิน levothyroxine 6 เดือน), found unresponsive ที่บ้านในเช้าที่อากาศหนาว (ฤดูหนาวภาคเหนือ)

V/S: BP 84/52, HR 42, RR 8 shallow, SpO2 92% RA, Temp 32.2°C (hypothermia), Glucose 58
PE: lethargic GCS 8, pale puffy face, dry coarse skin, hyporeflexia, periorbital edema, no goiter, no neck scar (no prior thyroidectomy)

Lab: Na 124, K 4.8, Glucose 58, Cr 1.4, CK 1,820 (mild), TSH > 100 (very high), Free T4 0.2 (very low), Cortisol AM 6 (suboptimal), ACTH 28
ABG: pH 7.30, PaCO2 60, PaO2 64, HCO3 28
CXR: small heart, pleural effusion bilateral mild
EKG: sinus bradycardia 42, low voltage, prolonged QT';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until CD4 > 200 to start ART"},{"label":"B","text":"Newly diagnosed HIV with severe immunosuppression CD4 < 50"},{"label":"C","text":"Two-drug ART only"},{"label":"D","text":"Defer ART until baseline opportunistic infections fully treated"},{"label":"E","text":"Start ART + initiate isoniazid preventive therapy without TB screening"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Newly diagnosed HIV with severe immunosuppression CD4 < 50 — Start ART promptly (rapid initiation within days per WHO + DHHS), preferred regimen: Bictegravir/tenofovir alafenamide/emtricitabine (B/F/TAF — single tablet, high barrier, well-tolerated, no boost) OR Dolutegravir + TDF/FTC (TLD) or TAF/FTC — Thailand National AIDS Program TLD frontline; concomitantly: opportunistic infection prophylaxis — TMP-SMX 1 DS daily (PCP + toxoplasmosis prevention since toxo IgG+ + CD4 < 100); azithromycin 1200 mg weekly for MAC prevention (consider — most providers focus on ART-driven immune recovery); fluconazole 200 mg/d in regions with high cryptococcal burden when CrAg negative is sometimes used though not standard; vaccinate (pneumococcal PCV20, hepatitis B series booster, influenza, COVID, HPV, Tdap); counsel re ART adherence + safer sex + disclosure + partner testing/treatment + PrEP for partner; monitor for IRIS (immune reconstitution inflammatory syndrome — particularly TB and cryptococcal); ART adherence (target VL undetectable < 50 in 6 mo); social work + mental health

---

Newly diagnosed HIV — rapid ART initiation. WHO 2023 + DHHS 2024 + Thai National AIDS Program: (1) Start ART regardless of CD4 — earlier is better (START, TEMPRANO trials). Rapid initiation (same-day or within 7 d) reduces mortality, improves retention. (2) Preferred 1st-line regimens (DHHS): - Bictegravir/TAF/FTC (B/F/TAF, Biktarvy) — single-tablet INSTI, high barrier. - Dolutegravir (DTG) + TAF/FTC or TDF/FTC (TLD in Thai NAP). - DTG/3TC dual: in select stable patients (no HBV, baseline VL < 500K). (3) Avoid efavirenz first-line now (CNS side effects, lower barrier) — but still in resource-limited settings. (4) Opportunistic infection prophylaxis: - CD4 < 200: TMP-SMX (PCP). - CD4 < 100 + toxo IgG+: TMP-SMX (also covers toxo). - CD4 < 50: MAC prophylaxis with azithromycin 1200 mg weekly — though some recent guidelines suggest dropping if rapid ART initiation. - Fluconazole prophylaxis for cryptococcus in high-burden regions (CrAg screening then preemptive). - Routine TB symptom screen + IGRA/TST + CXR; IPT (isoniazid preventive therapy) 6 mo or 3HP if TB ruled out. (5) Vaccinations (avoid live until CD4 > 200): pneumococcal PCV20, HepB, influenza, COVID, HPV up to 45 yr, Tdap. (6) IRIS — paradoxical worsening of underlying infection within weeks of ART; commonly TB (5-25%), cryptococcal, CMV, MAC; manage continuing ART + treating underlying + steroid in severe (TB IRIS). (7) Counseling: adherence, U=U (undetectable=untransmittable), partner notification, PrEP for partners. (8) Monitor: VL at 4-8 wk, 3, 6 mo then q6-12 mo; CD4 q6 mo until > 350 then less; routine labs. A ผิด — START/TEMPRANO showed early ART benefit at all CD4. C ผิด — dual regimens select cases only. D ผิด — concurrent ART + OI treatment (with timing per OI). E ผิด — must screen TB before IPT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 45 ปี HIV-positive baseline (recently diagnosed, CD4 12 cells/μL, VL 480,000), ไม่เคย ART มา OPD เพื่อ start ART พบ:

No current opportunistic infection clinically (no cough, no fever, no headache)
CBC: Hb 11.4, WBC 4,800, Plt 188,000
CD4 12, VL 480,000
HIV genotype: no resistance mutations
HBsAg negative, Anti-HBs positive (vaccinated), Anti-HCV negative
Cryptococcal antigen serum: negative
TB symptom screen: negative, CXR clear, IGRA negative
Toxoplasma serology IgG positive
Urinalysis normal, eGFR 105, glucose 92, HbA1c 5.4%, lipid panel normal
No significant other comorbid';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV vitamin K + observation only"},{"label":"B","text":"Drug-induced liver injury (DILI)"},{"label":"C","text":"Empirical corticosteroid pulse therapy"},{"label":"D","text":"Continue herbal medicine + tincture"},{"label":"E","text":"Antiviral therapy empirical"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Drug-induced liver injury (DILI) — likely from herbal supplement (Chinese herbs common cause in Asia — Polygonum, Bai Xian Pi, Ji Gu Cao, Sho-saiko-to, Atractylodes, etc.) ± analgesic: (1) Immediate withdrawal of all suspected hepatotoxic drugs/herbs (rechallenge contraindicated); (2) Supportive: maintain hydration, monitor LFT + INR daily initially; (3) Assess severity using Hy''s law (jaundice + 3× ULN ALT + bilirubin > 2× ULN without alternative cause = mortality risk 10-50%); (4) NAC (N-acetylcysteine) IV considered for early non-acetaminophen DILI with coagulopathy (Lee NEJM 2009 — modest mortality benefit pre-encephalopathy); (5) Glucocorticoid for hypersensitivity DILI with eosinophilia or autoimmune-like features (controversial); (6) Monitor for acute liver failure (ALF) — King''s College criteria for transplant referral (non-acetaminophen: pH < 7.3, OR INR > 6.5 + Cr > 3.4 + grade III/IV encephalopathy, OR 3 of 5 criteria); urgent referral to transplant center if INR > 1.5 + any encephalopathy; (7) RUCAM scoring + comprehensive ddx (viral hepatitis, autoimmune, Wilson, ischemic, biliary); (8) DILI registry reporting; patient counseling herbal/OTC labeling

---

Drug-induced liver injury (DILI) — hepatocellular pattern (R-ratio = (ALT/ULN)/(ALP/ULN) > 5). Asia: herbal/dietary supplements major cause (Korean DILIN: 27%; Chinese: many; US DILIN: 16%). AASLD 2014 + EASL 2019 + ACG 2021 DILI guideline: (1) Diagnosis = exclusion + temporal relationship; RUCAM score (5-8 probable, ≥ 9 highly probable). (2) Causes: APAP (predictable, dose-dependent), antibiotics (amox-clav, isoniazid, nitrofurantoin), antiepileptic (phenytoin, carbamazepine, valproate), statin (rare), methotrexate, herbal/supplement (Hydroxycut, Herbalife, Chinese herbs, kava), checkpoint inhibitor (ipi/nivo). (3) Management — discontinuation cornerstone: - Stop offending agent immediately; do not rechallenge (mortality on rechallenge much higher). - Supportive monitoring. - NAC IV 150 mg/kg over 1 hr, then 12.5 mg/kg/hr × 4 hr, then 6.25 mg/kg/hr × 16 hr — Lee NEJM 2009 showed transplant-free survival benefit in non-APAP early ALF (coma grade I-II); not routinely for early DILI without ALF. - Corticosteroid: only if hypersensitivity (DRESS), autoimmune-like features (SMA, ANA, eos, IgG ↑), some immune checkpoint inhibitor hepatitis. - L-ornithine-L-aspartate, lactulose if hepatic encephalopathy. (4) Hy''s law: jaundice + ALT > 3× + Bili > 2× (no obstruction/hemolysis/Gilbert) → ~10-50% mortality without transplant. (5) Acute liver failure (ALF) — coagulopathy (INR > 1.5) + encephalopathy in previously healthy liver < 26 wk: - Transfer to transplant center URGENT. - King''s College Criteria for transplantation. - MARS (artificial liver support) — bridge. (6) Reporting: LiverTox database, DILIN, national pharmacovigilance. (7) Patient education: avoid hepatotoxic OTC/herbals; rechallenge contraindicated. A ผิด — VitK alone inadequate. C ผิด — steroid not routine. D ผิด — perpetuates injury. E ผิด — viral panel negative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเหนื่อยเพลีย ผิวเหลือง 2 สัปดาห์ หลังกินยาแก้ปวดประจำเดือน + Chinese herbal medicine มา 3 สัปดาห์

V/S: BP 118/72, HR 88, RR 16, Temp 37.0°C
PE: jaundice + scleral icterus, hepatomegaly mild tender, no asterixis, no encephalopathy

Lab: AST 1,580, ALT 2,420 (very high — hepatocellular pattern, R-ratio > 5), ALP 142, GGT 95, Bilirubin total 6.8 (direct 4.2), Albumin 3.4, INR 1.4 (mild prolongation), Cr 0.8
Anti-HAV IgM negative, HBsAg negative, anti-HBc IgM negative, anti-HCV negative, HCV RNA negative, anti-HEV IgM negative
ANA negative, anti-SMA negative, IgG normal, ceruloplasmin 32 (normal), iron studies normal
US abdomen: hepatomegaly, normal echotexture, no biliary obstruction, no mass
RUCAM score (Roussel Uclaf Causality Assessment): 7 (probable DILI)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral ciprofloxacin outpatient × 7 d"},{"label":"B","text":"Spontaneous Bacterial Peritonitis (SBP)"},{"label":"C","text":"Vancomycin IV monotherapy"},{"label":"D","text":"Surgical laparotomy for source control"},{"label":"E","text":"Symptomatic management only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spontaneous Bacterial Peritonitis (SBP) — ascitic fluid PMN > 250/μL = diagnostic; (1) Empirical IV ceftriaxone 2 g/d × 5 d (first-line; covers usual gut translocation organisms — E. coli, K. pneumoniae, S. pneumoniae); avoid aminoglycoside (renal toxicity in cirrhosis); piperacillin-tazobactam if recent abx exposure, nosocomial, severe sepsis (resistance concern); (2) IV albumin 1.5 g/kg on day 1 + 1 g/kg on day 3 — reduces hepatorenal syndrome + mortality (Sort NEJM 1999 — particularly if Bili > 4 or Cr > 1); (3) HOLD non-selective beta-blocker temporarily if hypotensive or AKI (NSBB safe in stable cirrhosis with SBP but stop if shock); (4) Hold diuretic temporarily during AKI; (5) After resolution: secondary prophylaxis lifelong with norfloxacin 400 mg/d (or TMP-SMX, ciprofloxacin) — reduces recurrence + improves survival; (6) Primary prophylaxis indications: variceal hemorrhage (norfloxacin × 7 d) or low ascitic protein (< 1.5) + advanced cirrhosis (Bili > 3, Cr > 1.2, Na < 130) + Child-Pugh ≥ 9; (7) Liver transplant evaluation (SBP marker of decompensation, 1-yr survival 30-50%)

---

Spontaneous bacterial peritonitis (SBP). AASLD 2021 + EASL 2018 + Thai Hep Soc guideline: (1) Diagnostic paracentesis MANDATORY in any cirrhotic ascitic patient with fever, abdominal pain, encephalopathy, sepsis, AKI, GI bleed. (2) Diagnosis: ascitic fluid PMN > 250/μL (regardless of culture). - Culture-negative neutrocytic ascites = SBP variant — treat. - Monomicrobial non-neutrocytic bacterascites (positive culture, PMN < 250) — repeat tap; treat if symptomatic or persistent. - Secondary bacterial peritonitis (perforation): polymicrobial, protein > 1, glucose < 50, LDH > serum, Runyon criteria, ascitic CEA > 5 — surgical. (3) Empirical antibiotics: - Community-acquired: IV ceftriaxone 2 g/d × 5 d (covers E. coli, Klebsiella, pneumococcus). - Nosocomial / recent broad-spectrum exposure: pip-tazo, carbapenem (rising MDR). (4) Albumin 1.5 g/kg day 1 + 1 g/kg day 3 — Sort NEJM 1999: reduces HRS-AKI + mortality, especially if Cr > 1 or Bili > 4. (5) Repeat paracentesis at 48 hr to confirm > 25% PMN decrease — if not, broaden antibiotics, consider secondary peritonitis. (6) Hold/reduce NSBB if hypotension/AKI; restart when stable. (7) Hold diuretic during AKI; assess HRS criteria (cirrhotic + AKI + no improvement after 48 hr withdrawal + albumin challenge + no shock/nephrotoxin/structural). (8) HRS treatment: terlipressin + albumin (CONFIRM), norepi alternative. (9) Secondary prophylaxis after SBP: norfloxacin 400 mg/d lifelong (or other FQ, TMP-SMX); reduces recurrence + mortality. (10) Primary prophylaxis: GI bleeding + cirrhosis; low ascitic protein + high MELD. (11) Liver transplant evaluation (SBP = significant decompensation). A ผิด — IV broad first. C ผิด — vanco gram-negative inadequate. D ผิด — SBP not surgical. E ผิด — untreated mortality high.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 58 ปี underlying alcoholic cirrhosis Child-Pugh B, ascites known with chronic diuretics, MELD 16 มา ED ด้วยไข้ + ปวดท้องทั่วไป + abdominal tenderness + worsening ascites 3 วัน

V/S: BP 102/64, HR 104, RR 20, SpO2 96%, Temp 38.4°C
PE: jaundice, distended abdomen + shifting dullness, diffuse mild tender, no rebound, no rigidity, normal bowel sounds, no asterixis, GCS 15, no encephalopathy

Lab: WBC 12,400, Hb 10.2, Plt 88,000, Cr 1.4 (baseline 1.0), Bili 4.2, INR 1.6, Albumin 2.4, Na 130, K 4.0
Diagnostic paracentesis: WBC 580 cells/μL with PMN 420 cells/μL (> 250 = SBP), ascitic albumin 0.8 (SAAG = 1.6 = portal hypertension), Gram stain negative, culture pending, glucose 88 (similar to serum), LDH 180, total protein 1.2
No recent antibiotics, no surgery, no abdominal pain pattern peritonitis-like';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical bowel resection ทันทีเป็น first-line"},{"label":"B","text":"Crohn disease, moderate-severe ileocolonic + perianal fistula"},{"label":"C","text":"5-ASA monotherapy"},{"label":"D","text":"Antibiotic alone (metronidazole) long-term"},{"label":"E","text":"Watchful waiting until obstruction develops"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Crohn disease, moderate-severe ileocolonic + perianal fistula — Multidisciplinary approach: (1) Acute symptom control: prednisolone 40-60 mg/d taper or budesonide 9 mg/d (ileal release for ileal-Right colon — less systemic SE); (2) Address perianal abscess first: surgical drainage + seton placement (before immunosuppression to prevent worsening sepsis); (3) Induction + maintenance with biologic — anti-TNF (infliximab 5 mg/kg IV at 0, 2, 6 wk then q8wk OR adalimumab) — especially effective for fistulizing Crohn (ACCENT II); top-down strategy preferred over step-up in high-risk (young, deep ulcer, extensive, perianal, fistulizing) — REACT, RISK; (4) Combine with immunomodulator (azathioprine, methotrexate) — SONIC superior outcome combo > monotherapy; (5) Alternative biologics: ustekinumab (UNITI), vedolizumab (gut-selective, less efficacious in fistula), risankizumab; (6) Antibiotic ciprofloxacin + metronidazole for perianal disease adjunct; (7) Nutritional optimization (enteral nutrition in select cases); (8) Smoking cessation (worsens CD); (9) Vaccines (live attenuated avoid post-biologic); (10) CRC + small bowel surveillance; (11) Bone health, mood support

---

Crohn disease, moderate-severe, ileocolonic, fistulizing/perianal. Key features distinguishing from UC: skip lesions, transmural, granuloma, terminal ileum, perianal disease, fistula, oral aphthae, extraintestinal manifestations more common. ACG 2018 + AGA 2021 + ECCO 2020 Crohn guideline: (1) Severity assessment: CDAI, Harvey-Bradshaw, biomarkers, imaging extent. (2) Goals: clinical remission, mucosal healing (deep remission), prevent complications + surgery. (3) Initial: - Mild ileal: budesonide 9 mg/d × 8 wk. - Moderate-severe: systemic glucocorticoid (prednisolone 40 mg/d) taper. - Risk-stratify: young age, deep ulcer, extensive, perianal, fistula = high-risk → top-down biologic. (4) Biologic therapy: - Anti-TNF (infliximab, adalimumab) — most studied; ACCENT II for fistula. - Ustekinumab (anti-IL-12/23). - Vedolizumab (anti-α4β7 integrin, gut-selective). - Risankizumab, upadacitinib (newer). (5) Combination therapy: anti-TNF + immunomodulator (AZA, MTX) — SONIC trial: combo > monotherapy in steroid-free remission. (6) Perianal disease: - Examination under anesthesia (EUA) + MRI pelvis. - Abscess drainage + seton (essential before/concurrent with biologic). - Antibiotic (ciprofloxacin + metronidazole) adjunct. - Anti-TNF for fistula. (7) Surgery: for stricture (resection or strictureplasty), abscess, perforation, refractory disease; recurrence common at anastomosis. (8) Smoking cessation — major modifiable factor in CD. (9) Vaccines pre-immunosuppression (live attenuated); routine annual flu, pneumococcal, HBV. (10) Surveillance colonoscopy 8 yr from diagnosis. (11) Nutrition, bone, pregnancy, vaccination, malignancy surveillance. A ผิด — surgery not first-line. C ผิด — 5-ASA limited efficacy in CD. D ผิด — antibiotic alone inadequate moderate-severe. E ผิด — wait → complications.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องล่างขวา + เลือดออกทางทวารหนัก 6 เดือน + น้ำหนักลด 6 kg + ไข้ต่ำ + ปวดข้อ + แผลในปาก aphthous + perianal fistula

Lab: Hb 10.4, MCV 80, WBC 9,200, Plt 412,000, ESR 56, CRP 28, Albumin 3.0, fecal calprotectin 720 (high)
Colonoscopy: skip lesion pattern, deep linear ulcers + cobblestone in terminal ileum + ascending colon, normal rectum (rectal sparing), perianal fistula confirmed; biopsy = non-caseating granuloma, transmural inflammation
MRI enterography: terminal ileum 12 cm involvement + complex perianal fistula + small abscess perianal
No intra-abdominal abscess, no obstruction
Stool culture: negative
TB workup: IGRA negative, CXR clear
HBV/HCV/HIV: negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Platelet transfusion to raise Plt > 50,000"},{"label":"B","text":"Acquired Thrombotic Thrombocytopenic Purpura (acquired TTP"},{"label":"C","text":"Platelet + plasma transfusion + supportive only"},{"label":"D","text":"Heparin anticoagulation for microthrombi"},{"label":"E","text":"Defer TPE until next morning per hematology consult"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acquired Thrombotic Thrombocytopenic Purpura (acquired TTP — autoimmune ADAMTS13 inhibitor) — Emergent treatment: (1) Therapeutic plasma exchange (TPE) DAILY starting within hours of diagnosis — replace ADAMTS13 + remove inhibitor + remove vWF multimers; continue until Plt > 150K × 2 d + LDH normalized; (2) Corticosteroid (methylprednisolone 1 g/d × 3 d or prednisolone 1 mg/kg/d) — immunosuppression of antibody; (3) Caplacizumab (anti-vWF nanobody) — accelerates platelet recovery, reduces exacerbation/refractory disease (HERCULES NEJM 2019); standard now in many centers; (4) Rituximab — anti-CD20 (frontline option per ISTH 2020; reduces refractoriness + relapse, lower TPE sessions); (5) AVOID prophylactic platelet transfusion (worsens thrombosis — fatal!) — only if life-threatening bleed or pre-procedure; (6) AVOID antiplatelet/anticoagulant unless specific indication; (7) Treat precipitant (infection, drugs, pregnancy, malignancy, HIV) if identified; (8) Monitor for relapse — Q4-12 wk ADAMTS13 level; relapse rate 30-50%; rituximab can prevent

---

Thrombotic thrombocytopenic purpura (TTP) — classic pentad (now diagnostic = first 2): microangiopathic hemolytic anemia (MAHA) + thrombocytopenia + fever + neuro + renal; ADAMTS13 < 10% confirms TTP. ISTH 2020 + ASH 2020 + ITP/TTP guideline: (1) Diagnosis: PLASMIC score ≥ 5 (creatinine < 2, INR < 1.5, MCV < 90, Plt < 30, no transplant, no cancer, hemolysis) — high probability TTP. ADAMTS13 < 10% confirms (most labs report). Anti-ADAMTS13 IgG distinguishes acquired (autoimmune) from congenital (cTTP/Upshaw-Schulman). (2) TREAT EMPIRICALLY before ADAMTS13 result — emergency, untreated mortality > 90%: - **Therapeutic plasma exchange (TPE)** daily within hours of diagnosis — replaces ADAMTS13 + removes inhibitor + vWF multimers; FFP if TPE delayed. - **Glucocorticoid**: methylprednisolone 1 g/d × 3 d, or prednisolone 1 mg/kg/d. - **Caplacizumab** (anti-vWF nanobody, Cablivi): HERCULES NEJM 2019 — accelerates platelet recovery, reduces refractoriness/exacerbation, prevents thrombotic events; ISTH 2020 recommends caplacizumab + TPE + steroid. - **Rituximab** 375 mg/m² × 4 weekly: frontline in some protocols; reduces refractoriness + relapse. (3) NO prophylactic platelet transfusion — controversial historical contraindication (fuel on fire) in TTP — case reports of catastrophic worsening; only for life-threatening bleed or pre-LP/central line. (4) AVOID anticoagulation/antiplatelet routinely. (5) Investigate precipitants: drugs (clopidogrel, ticlopidine, quinine, cyclosporine, gemcitabine, VEGF inhibitor), infection (HIV — test all TTP), pregnancy, malignancy, autoimmune. (6) Monitor: daily CBC, LDH, fibrinogen, ADAMTS13 (relapse prevention); platelet > 150K × 2 d + LDH normalized = remission, TPE can be tapered. (7) Long-term: ADAMTS13 monitoring Q3-12 mo; relapse 30-50% — preemptive rituximab in those with persistent ADAMTS13 < 10%. (8) Congenital TTP: regular plasma infusion or recombinant ADAMTS13 (recently approved adamzistron alfa). A ผิด — platelet transfusion harmful. C ผิด — TPE essential, not transfusion alone. D ผิด — anticoag worsens. E ผิด — TPE within hours, do NOT delay.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัวเดิม มาด้วย microangiopathic hemolytic anemia + thrombocytopenia + AKI + fluctuating neuro symptoms (confusion → headache → mild aphasia ↔ recovery) + ไข้ low-grade × 5 วัน

V/S: BP 142/88, HR 102, RR 18, SpO2 97%, Temp 37.8°C, GCS variable 13-15
PE: petechiae diffuse, scleral icterus, no rash, no lymphadenopathy, no organomegaly

Lab: Hb 7.2 (rapid drop, baseline 12), MCV 88, Schistocytes 8% on peripheral smear, Plt 18,000, WBC 9,200
LDH 2,440, indirect bilirubin 4.6, haptoglobin < 10 (consumed)
Reticulocyte 8%, DAT/Coombs negative (non-immune hemolysis)
Cr 2.4 (baseline 0.8), UA: protein 2+, blood 2+, no RBC casts
PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer mildly elevated
ADAMTS13 activity < 5% (severely decreased) + ADAMTS13 inhibitor positive → confirms TTP
E. coli O157:H7 negative, no diarrhea (rules out HUS)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Splenectomy ทันที"},{"label":"B","text":"Pregnancy-associated severe Immune Thrombocytopenia (ITP)"},{"label":"C","text":"Platelet transfusion alone × 6 units to suppress"},{"label":"D","text":"Defer treatment until delivery"},{"label":"E","text":"Heparin anticoagulation for hypercoagulable"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy-associated severe Immune Thrombocytopenia (ITP) — must exclude pregnancy-specific causes (gestational thrombocytopenia: mild Plt > 70K third tri; preeclampsia/HELLP: HTN + AKI + LFT abnormal; TTP: MAHA + neuro + low ADAMTS13). Plt 8K with bleeding = severe ITP; treat: (1) First-line corticosteroid: prednisolone 1 mg/kg/d × 1-2 wk taper, or short pulse dexamethasone (40 mg × 4 d × 1-4 cycles per ASH 2019); IV methylprednisolone 1 g × 3 d if life-threatening; (2) IVIG 1 g/kg × 1-2 d — rapid (24-48 hr) platelet rise; preferred in pregnancy + emergency; (3) Pre-delivery target Plt > 30K (vaginal), > 50K (C-section), > 80K (neuraxial anesthesia); (4) Second-line in pregnancy: anti-D (Rh+ only), splenectomy 2nd trimester if refractory (delayed if possible); thrombopoietin receptor agonists (eltrombopag, romiplostim) — limited pregnancy safety data, case-by-case; (5) AVOID rituximab in 1st trimester (B-cell depletion neonate); cyclophosphamide teratogenic; (6) Coordination with OB + anesthesia for delivery planning; neonatal thrombocytopenia (10-25% via passive antibody) — neonatal CBC daily × 1 wk post-delivery; (7) Postpartum follow-up — relapse common as immune homeostasis shifts

---

Immune Thrombocytopenia (ITP) — isolated thrombocytopenia, diagnosis of exclusion (no clue to alternative cause + no other lineage involvement). ASH 2019 ITP guideline + Provan Blood Adv 2019: (1) Diagnosis: history, exam, CBC + smear (rule out pseudothrombocytopenia, MAHA), exclude drug-induced (heparin = HIT), infection (HIV, HCV, HBV, H. pylori, CMV), autoimmune (SLE → APS), lymphoma, splenic sequestration. Bone marrow only if atypical (older > 60 yr unclear etiology, refractory). (2) Treatment thresholds: - No bleed + Plt > 30K: observation (in adult, asymptomatic). - Bleed or Plt < 30K (some < 20K): treat. - Severe bleed: emergent treatment. (3) First-line corticosteroid options: - Prednisolone 1 mg/kg/d × 1-2 wk, taper. - Dexamethasone 40 mg × 4 d × 1-4 cycles per ASH (faster, less SE). - IV methylprednisolone 1 g × 3 d (life-threatening bleed). (4) IVIG 1 g/kg × 1-2 d — rapid (24-48 hr) platelet rise; preferred in pregnancy + emergency + need for rapid response. (5) Anti-D Ig 50-75 mcg/kg — Rh+ only, splenic-intact; risk of intravascular hemolysis. (6) Second-line: rituximab, TPO receptor agonists (eltrombopag, romiplostim, avatrombopag — durable response 60-80%), splenectomy (after 1 yr — accommodation), fostamatinib (SYK inhibitor). (7) Pregnancy-specific: - Differentiate gestational thrombocytopenia (mild, Plt > 70, late gestation, no Hx) vs ITP (severe < 100, any time, prior Hx). - Target Plt > 30K (vaginal delivery), > 50K (C-section), > 80K (neuraxial). - Steroid + IVIG safe in pregnancy. - Avoid rituximab early, cyclophosphamide. - TPO-RA limited data — case-by-case. - Neonatal: monitor CBC daily × 1 wk (Plt nadir day 2-5 from passive antibody); rarely severe but ICH risk. (8) Platelet transfusion: severe bleed only, not routine (consumed rapidly). A ผิด — splenectomy delay. C ผิด — transfusion not first; immune-mediated destruction. D ผิด — symptomatic + Plt < 10K + delivery soon = treat. E ผิด — heparin worsens bleeding, not indicated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัวเดิม ตั้งครรภ์ GA 32 weeks มาด้วย petechiae + epistaxis + เลือดออกตามเหงือก 2 สัปดาห์ ก่อนหน้านี้ healthy

V/S: BP 122/76, HR 88, RR 16, Temp 37.0°C
PE: extensive petechiae lower extremities + trunk, no purpura, no organomegaly, no lymphadenopathy, gravid uterus appropriate GA

Lab: Hb 11.2 (normal), MCV 88, WBC 7,400 (normal differential), Plt 8,000 (severe isolated thrombocytopenia), Reticulocyte 1.5%, smear: large platelets only (no schistocytes — rules out TTP/HUS/HELLP)
Coag: PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer normal
LFT normal (rules out HELLP), Cr 0.6, UA normal
HIV negative, HCV negative, HBV negative
DAT (Coombs) negative
ANA negative
Bone marrow (deferred for now): would show normal/increased megakaryocytes if ITP
No bleeding currently active beyond petechiae + minor mucocutaneous';

commit;
