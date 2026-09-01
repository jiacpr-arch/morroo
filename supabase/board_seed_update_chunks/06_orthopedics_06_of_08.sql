-- ===============================================================
-- UPDATE chunk 6/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotic outpatient only without admission"},{"label":"B","text":"Acute Hematogenous Osteomyelitis Distal Femur Pediatric"},{"label":"C","text":"No antibiotic just observation"},{"label":"D","text":"6-month IV antibiotic mandatory"},{"label":"E","text":"Amputation femur"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hematogenous Osteomyelitis Distal Femur Pediatric: (1) **blood culture × 2 + tissue/bone aspirate culture** before starting antibiotic; identify organism (Kingella PCR for 6-36 months, MRSA screening); (2) **empirical IV antibiotic** within hours based on age + local epidemiology: (a) age > 3 months: cefazolin or clindamycin (cover MSSA/Streptococcus); consider vancomycin if MRSA prevalence high (> 10-15%); add ceftriaxone if Kingella suspected ("less ill" child 6-36 mo); (b) age < 3 months: vancomycin + cefotaxime (GBS, gram-negative, S. aureus); (c) sickle cell: add coverage for Salmonella (ceftriaxone); (3) **modern protocol — early transition to oral antibiotic** when clinical + lab improvement (afebrile, CRP downtrending) at 3-7 days IV → oral antibiotic to complete 3-4 weeks total (oral as effective as IV per recent RCTs — no need for prolonged IV/PICC) — major paradigm shift; (4) **surgical drainage + debridement** indicated: (a) **subperiosteal abscess** (as in this case), (b) intraosseous abscess, (c) failure of conservative response 48-72 hours, (d) adjacent septic arthritis, (e) sequestrum (chronic); (5) **antibiotic duration 3-4 weeks** acute (longer 4-6 weeks if complex/inadequate source control); monitor with CRP normalization; (6) **MRI** definitive imaging — early changes (vs X-ray which shows changes only after 10-14 days); (7) **multidisciplinary**: pediatric ortho + ID + pediatric medicine; (8) **complications**: chronic osteomyelitis, growth arrest (if physis involved), sequestrum, sepsis, septic arthritis; (9) long-term follow-up

---

Pediatric hematogenous osteomyelitis: metaphyseal long bones (slow-flow vessels). S. aureus most common. Kingella (6-36 mo, PCR), Salmonella (SCD). MRI early diagnosis. Empirical IV antibiotic by age + local MRSA prevalence + clinical (Kingella). Surgical drainage for abscess + adjacent septic arthritis + failed conservative. Modern: early IV-to-oral transition, 3-4 wk total. Complications: chronic OM, growth arrest.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 8 ปี ปวด distal femur ขวา 5 วัน + ไข้สูง 39.2°C + ไม่ยอม weight bear + ค่อย ๆ บวม

V/S: BP 105/65, HR 130, Temp 39.2°C
PE: tender + warm distal femur, refuse weight bear, knee effusion mild (sympathetic), no overlying skin lesion (rules out cellulitis)
Lab: WBC 18,500 (PMN 88%), CRP 220, ESR 95, blood culture × 2 pending
MRI femur + Gd: bone marrow edema + subperiosteal abscess distal femur metaphysis + surrounding soft tissue edema — acute hematogenous osteomyelitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Above-knee amputation always"},{"label":"B","text":"Diabetic Foot Osteomyelitis Chronic + Probe-to-Bone Positive"},{"label":"C","text":"Oral antibiotics 5 days only"},{"label":"D","text":"No antibiotics observation"},{"label":"E","text":"Long-term IV antibiotics > 1 year"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic Foot Osteomyelitis Chronic + Probe-to-Bone Positive: (1) **multidisciplinary diabetic foot care** — endocrine, vascular, infectious disease, podiatry/orthopedic, wound care, nutrition; (2) **probe-to-bone test** sensitive + specific for OM in diabetic foot; X-ray + MRI confirms; **bone biopsy + culture** preferred over wound swab (deep tissue/bone — gold standard for organism + sensitivities); (3) **vascular assessment** — ABI, toe-brachial index, TcPO2 — if vascular insufficiency → vascular surgery for revascularization before/with limb salvage; (4) **glycemic control** — HbA1c target individualized (< 8 reasonable balance); (5) **antibiotic therapy** organism-targeted: (a) **6 weeks** if surgical resection achieves clear margin or no surgery (medical only — selective); (b) **2-4 weeks** if surgical resection achieves complete removal of infected bone with clean margins; (c) empirical broad spectrum if culture pending — cover S. aureus (vancomycin if MRSA risk) + gram-negative + anaerobes for limb-threatening; (6) **surgical resection of infected bone** indicated: (a) failure of medical management, (b) extensive bony destruction, (c) sepsis, (d) gangrene/necrosis, (e) deep abscess; partial calcanectomy, metatarsal head/ray resection, transmetatarsal amputation, midfoot/below-knee amputation depending on extent; (7) **wound care + offloading** — total contact casting, removable boot, specialized footwear; (8) **negative pressure wound therapy (VAC)** + adjuncts; (9) **screen + treat comorbidities** (renal, retinopathy, autonomic); (10) **smoking cessation**, foot care education, regular podiatry follow-up; (11) prevention — most important

---

Diabetic foot osteomyelitis: probe-to-bone + MRI + bone biopsy. Multidisciplinary (endo + vascular + ID + podiatry + wound care). Vascular optimization first. Targeted antibiotic 6 wk (medical) or 2-4 wk (post-surgical clear margin) per bone biopsy + culture. Surgical resection for failed medical, extensive destruction, sepsis. Wound care + offloading + glycemic control. Prevention through foot care education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 60 ปี DM2 (HbA1c 9.5%) มี chronic foot ulcer plantar 1st MTP 6 เดือน + ขนาด 3 cm × probe to bone +, ขอบ undermined + slough
No cellulitis ascending; foot warmth normal, no systemic symptoms

V/S: stable, no fever
PE: 1st MTP ulcer probe-to-bone positive (highly suggestive osteomyelitis), peripheral pulses palpable (ABI 0.85), neuropathy + (insensate)
Lab: WBC 9,500, CRP 35, ESR 65, glucose 220

X-ray foot: cortical destruction + lucency 1st metatarsal head + periosteal reaction — chronic osteomyelitis
MRI foot: bone marrow edema + cortical destruction + subcutaneous abscess 1st MT — osteomyelitis confirmed
Bone biopsy + culture: MSSA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotics broad spectrum 2 weeks only"},{"label":"B","text":"Spinal Tuberculosis (Pott''s Disease) with Cord Compression"},{"label":"C","text":"Surgical fusion without ATT"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Single antitubercular drug rifampin alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Tuberculosis (Pott''s Disease) with Cord Compression: (1) **multidisciplinary care** — TB specialist (pulmonology/ID), orthopedic spine surgeon, neurosurgeon, public health; (2) **anti-TB therapy (ATT)** — backbone, started immediately after workup: HRZE (isoniazid + rifampin + pyrazinamide + ethambutol) × 2 months → HR × 7-10 months (total 9-12 months for spinal TB, longer than pulmonary); modify based on drug sensitivity (MDR/XDR); (3) monitor liver function, vision (ethambutol), pyridoxine supplementation; (4) **surgical decompression + stabilization** indicated for: (a) **neurologic deficit** (as in this case) — emergent decompression to preserve neurology, (b) significant kyphosis > 30° or progressive deformity, (c) instability, (d) large abscess + cold abscess > 5 cm, (e) failure of medical management, (f) doubt of diagnosis (need biopsy); (5) **surgical approach** typically anterior debridement + reconstruction (cage, strut graft) + posterior instrumentation (combined approach) — Hong Kong operation classic; (6) **CT-guided drainage** + biopsy for abscess + organism confirmation + AFB + GeneXpert (rapid PCR) + culture + drug sensitivity; (7) **non-operative**: medical only for early Pott''s without neurologic compromise + small abscess + no significant deformity — bracing (TLSO) + ATT + monitor with MRI; (8) **multidrug-resistant TB** (MDR/XDR) — longer treatment (18-24 months), 2nd-line drugs, modified surgery; (9) screen HIV + immunocompromised; (10) public health notification + contact tracing; (11) nutritional optimization

---

Pott''s disease: spinal TB. Disc-sparing + paraspinal abscess + adjacent vertebral involvement. ATT 9-12 months (HRZE → HR). Surgical decompression + stabilization for neurologic deficit, deformity, abscess, instability, dx confirmation. CT-guided biopsy + GeneXpert + culture. Multidrug-resistant requires modified. HIV screen. Notification. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 38 ปี HIV-negative อาการปวดหลัง T-spine ไข้ low-grade 39°C + เหงื่อกลางคืน + น้ำหนักลด 5 kg 3 เดือน + เริ่มอ่อนแรงขา 2 ข้าง 1 สัปดาห์

V/S: Temp 38.0°C
PE: thoracic kyphosis เพิ่ม + tender T8 + paraspinal mass palpable, motor LE 4/5 with hyperreflexia + +Babinski
Lab: WBC 9,000, CRP 80, ESR 90, HIV negative

MRI T-spine + Gd: T8-T9 vertebral body destruction + intervertebral disc relatively preserved ("disc-sparing" — characteristic of TB) + large bilateral paraspinal abscess (psoas extension) + epidural component with cord compression

CBC + ECG + cxr: miliary TB pattern in chest
AFB smear sputum + + bronchoscopy → MTB culture positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics outpatient"},{"label":"B","text":"Necrotizing Fasciitis with Septic Shock — Surgical Emergency"},{"label":"C","text":"Wait for cultures before antibiotics"},{"label":"D","text":"Conservative no surgery initial"},{"label":"E","text":"Long-term IV antibiotic only 6 months no surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Necrotizing Fasciitis with Septic Shock — Surgical Emergency: (1) **immediate aggressive resuscitation** in parallel with surgery: ABCs + airway, IV access × 2 large bore, crystalloid + vasopressor (norepinephrine) for MAP > 65, blood culture × 2, lactate; (2) **broad-spectrum empirical antibiotics within 1 hour**: triple coverage — **vancomycin + piperacillin-tazobactam (or meropenem) + clindamycin** (clindamycin essential — anti-toxin/Eagle effect against streptococcal/clostridial exotoxin + reduces super-antigen production); add IVIG for streptococcal toxic shock; (3) **EMERGENT surgical debridement within hours** — single most important determinant of survival; mortality increases each hour of delay; aggressive wide debridement to bleeding healthy tissue + remove ALL necrotic fascia/tissue + obtain tissue cultures + Gram stain; repeat debridement at 24-48 hours until clean ("second look"); (4) **multidisciplinary surgical team** — general/trauma surgery + orthopedic + plastic + ICU + ID; (5) **adjunct hyperbaric oxygen** controversial — should not delay surgery; (6) **fasciotomy** if compartment syndrome features; (7) **wound management** post-debridement: VAC + delayed reconstruction (flaps, skin grafts) after clean; (8) **amputation** if extensive necrosis + uncontrollable sepsis; (9) **fluid + electrolyte + glycemic management**; (10) **classify type**: I (polymicrobial — DM, abdomen), II (monomicrobial Group A Strep — limbs, healthy), III (Vibrio — seawater exposure, fish), IV (fungal — immunocompromised); (11) **LRINEC score** > 6 suspicion, > 8 high; (12) high mortality 20-40% even with prompt treatment

---

Necrotizing fasciitis: surgical emergency. Mortality increases each hour delay. Triad: pain out of proportion + woody induration extending past erythema + systemic toxicity. Resuscitation + IV abx (vanc + pip-tazo + CLINDAMYCIN — anti-toxin) within 1h + emergent aggressive debridement. Repeat debridement 24-48h. Multidisciplinary. Types I-IV. LRINEC score. Mortality 20-40%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 50 ปี DM ปวด + บวม ขาขวาตั้งแต่ ankle ขึ้นมา calf 2 วัน หลัง trauma เล็กน้อยกระแทกประตู เริ่มมี erythema → bullae → skin necrosis เปลี่ยนสีเทาดำ ปวดมากเกินกว่า skin findings (pain out of proportion)

V/S: BP 88/55, HR 130, RR 26, Temp 39.5°C, SpO2 92%, septic shock
PE: extensive erythema + hemorrhagic bullae + dishwater drainage + crepitus + tense edema + decreased sensation overlying skin ("woody" induration extending beyond visible erythema)
Lab: WBC 24,000 (PMN 92% + bands), Cr 2.5, lactate 4.5, BUN 45, Na 128, glucose 380, CRP 480, LRINEC score 9 (high risk)

X-ray + CT leg: subcutaneous gas + extensive soft tissue edema along fascial planes — necrotizing soft tissue infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics 5 days"},{"label":"B","text":"Chronic Osteomyelitis Post-Trauma — Cierny-Mader IIIB"},{"label":"C","text":"Cast immobilization no surgery"},{"label":"D","text":"Long-term IV antibiotic only no debridement"},{"label":"E","text":"Discharge home no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Osteomyelitis Post-Trauma — Cierny-Mader IIIB: (1) **multidisciplinary care** — orthopedic + plastic surgery + ID + wound care + medical optimization; (2) **principles**: (a) thorough debridement of all necrotic bone (sequestrectomy) + soft tissue, (b) hardware removal (typically — biofilm), (c) culture-targeted antibiotics, (d) dead space management, (e) soft tissue coverage, (f) skeletal stabilization, (g) restore function; (3) **staged surgical approach**: (a) **first stage** — wide debridement + sequestrectomy + remove hardware + obtain deep cultures + thorough irrigation + place **antibiotic-loaded cement beads or spacer** (PMMA with vancomycin/tobramycin/gentamicin) — Masquelet technique uses induced membrane for staged bone reconstruction, (b) **second stage** 6-8 weeks later — remove cement + bone graft (autograft iliac crest, allograft, distraction osteogenesis with external fixator/Ilizarov) + definitive fixation; (4) **antibiotic therapy** — culture-targeted IV 4-6 weeks (or oral with high bioavailability — modern transitioning to oral early), guided by sensitivities; chronic suppression possible for non-surgical candidates; (5) **soft tissue coverage** for IIIB defect — local rotational flap (gastrocnemius proximal, soleus middle, distally based sural artery), free flap (latissimus dorsi, ALT — anterolateral thigh) — plastic surgery; (6) **bone reconstruction options**: bone graft (cancellous, structural), bone transport (Ilizarov), vascularized fibula autograft; (7) **B-host optimization** — DM control, smoking cessation, nutrition, MRSA decolonization; (8) **amputation** for: extensive bone loss + soft tissue + functional limitation + recurrent failures + non-compliant host; (9) **long-term follow-up** — relapse high (10-30%)

---

Chronic osteomyelitis: Cierny-Mader staging (anatomic + host). Multidisciplinary. Aggressive debridement + sequestrectomy + hardware removal + antibiotic spacer (1st stage) → bone graft + definitive fixation (2nd stage). Culture-targeted antibiotics 4-6 wk. Soft tissue coverage (local/free flap). Host optimization (DM, smoking, nutrition). Bone reconstruction. Amputation for unreconstructable. Relapse 10-30%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 45 ปี s/p open tibia fracture + ORIF 2 ปีก่อน เริ่มมี draining sinus ขาส่วนล่าง 8 เดือน + ปวด intermittent + bone fragment ออกมาจาก sinus เป็นครั้งคราว

PE: chronic draining sinus tibia, surrounding skin atrophic + discolored, no acute cellulitis, soft tissue thin/fibrotic, palpable hardware deep, NV intact
Lab: WBC 8,500, CRP 25, ESR 50

X-ray tibia: sequestrum (necrotic bone fragment) within involucrum (new bone formation), cortical thickening, lucency around hardware suggesting hardware loosening
MRI tibia: marrow + soft tissue involvement, abscess pocket
Deep tissue + bone biopsy + culture: MRSA + Enterobacter (polymicrobial chronic OM)

Dx: chronic osteomyelitis (Cierny-Mader IIIB — localized + B host)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast immobilization 6 weeks rigid"},{"label":"B","text":"Acute Lateral Ankle Sprain Grade II — Functional Rehabilitation"},{"label":"C","text":"Surgical repair all acute Grade II sprains"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lateral Ankle Sprain Grade II — Functional Rehabilitation: (1) **Ottawa Ankle Rules** — clinical decision rule to avoid unnecessary X-ray (high sensitivity > 95%): X-ray if bone tenderness at distal 6 cm posterior edge of medial or lateral malleolus, navicular tenderness, 5th MT base tenderness, OR inability to weight bear 4 steps both in ED + immediately after injury; (2) **PRICE → POLICE protocol** (modern — Protection, Optimal Loading, Ice, Compression, Elevation) initial 48-72 hours; (3) **functional rehabilitation > prolonged immobilization** — better outcomes: brief functional support (compression brace, lace-up brace) 1-2 weeks + early weight-bearing as tolerated; (4) **early mobilization + PT** — most important: ROM exercises, proprioception (wobble board, single-leg balance), peroneal strengthening, sport-specific training, gradual return to play; (5) NSAIDs short course (limited concern about ligament healing in low-grade sprain); (6) **avoid prolonged cast immobilization** > 1 week (causes stiffness, deconditioning, prolongs recovery); (7) **avoid surgical repair** for acute ATFL — equivalent to functional rehab in most patients (recent RCTs); (8) **return to sport** when full ROM + strength + functional tests + no pain ~ 2-6 weeks Grade II; (9) **chronic ankle instability** (recurrent sprains, > 6 months) → consider operative reconstruction — **Brostrom-Gould** procedure (anatomic repair) or anatomic reconstruction with allograft/autograft for poor tissue; (10) **screen for high ankle sprain (syndesmotic)** — squeeze test, external rotation test, dorsiflexion compression test (DRL) — different rehab + may need surgical fixation if unstable

---

Lateral ankle sprain: Ottawa Ankle Rules to avoid X-ray. PRICE → POLICE. Functional rehab > immobilization. Brief brace + early WB + PT (proprioception + peroneal strengthening). Surgery for acute ATFL no better than functional rehab. Chronic instability — Brostrom-Gould. ALWAYS screen syndesmotic (high ankle) — different management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 24 ปี เล่นบาสล้มข้อเท้าซ้ายบิดเข้าใน (inversion) ปวด + บวมข้อเท้า lateral 2 วัน เดินกระเผลกแต่ weight bear ได้บางส่วน

PE: tender ATFL + CFL (anterior + below lateral malleolus), mild swelling, no tenderness medial malleolus, no proximal fibula tenderness, no syndesmotic tenderness, no inability to weight-bear in ED, no bone tenderness 6 cm distal posterior edge of fibula/tibia
Ottawa Ankle Rules: negative — no X-ray indicated

Anterior drawer + + talar tilt + (mild instability) → Grade II lateral ankle sprain (partial ATFL ± CFL tear)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always Keller resection arthroplasty"},{"label":"B","text":"Moderate Hallux Valgus Failed Conservative — Surgical Correction"},{"label":"C","text":"Steroid injection only long-term"},{"label":"D","text":"Above-ankle amputation"},{"label":"E","text":"Cast immobilization 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Hallux Valgus Failed Conservative — Surgical Correction: (1) **conservative first-line** for 6-12 months (already failed in this case): (a) **wide toe-box footwear** (most important — most pain from shoe pressure), (b) bunion pads + spacers, (c) orthotics for forefoot pain, (d) NSAIDs for symptoms, (e) night splints (limited evidence), (f) PT for foot intrinsic strengthening; (2) **surgical correction tailored to deformity severity** (HVA + IMA + joint congruency + 1st MTP arthritis): (a) **mild (HVA < 25°, IMA < 13°)**: distal metatarsal osteotomy — Chevron, Mitchell, Akin (proximal phalanx osteotomy as adjunct); (b) **moderate (HVA 25-40°, IMA 13-18°)**: **scarf osteotomy** OR proximal/diaphyseal metatarsal osteotomy + soft tissue procedure (lateral release + medial capsulorrhaphy); (c) **severe (HVA > 40°, IMA > 18°)**: proximal metatarsal osteotomy (Lapidus — 1st TMT arthrodesis — for hypermobile 1st ray) OR double osteotomy; (d) **1st MTP arthritis** present: arthrodesis 1st MTP (definitive, eliminates motion, durable); (3) **minimally invasive (MICA — percutaneous bunionectomy)** emerging — comparable outcomes, shorter recovery — but learning curve; (4) **avoid Keller resection arthroplasty** (transfer metatarsalgia, weakness — outdated except very low demand elderly); (5) **avoid surgery for cosmesis alone**; (6) post-op: post-op shoe 4-6 weeks, gradual return to regular shoe 6-12 weeks, full activity 3-6 months; (7) **rheumatoid foot** specific — different procedures; (8) recurrence 10-20% — counsel; (9) **Lapidus** for hypermobile 1st TMT joint

---

Hallux valgus: conservative first (wide shoes, padding, NSAIDs) — most pain from shoe pressure. Surgery for failed conservative + functional limitation. Procedure tailored to severity (HVA, IMA, congruency, arthritis): distal osteotomy mild, proximal/scarf moderate, Lapidus severe/hypermobile, arthrodesis with 1st MTP arthritis. Modern MICA emerging. Avoid Keller. NOT for cosmesis alone. Recurrence 10-20%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 50 ปี ปวดโคนนิ้วโป้งเท้าซ้าย 3 ปี + bunion โต ใส่รองเท้าลำบาก ค่อย ๆ แย่ลง FAILED 12 เดือน conservative (wide shoes, orthotics, NSAIDs, padding)

PE: hallux valgus angle (HVA) clinically 35°, painful 1st MTP, lateral deviation great toe, dorsiflexion painful, no significant 1st MTP arthritis, second toe overlap mild

Weight-bearing X-ray foot: HVA 35° (normal < 15), IMA (intermetatarsal angle) 14° (normal < 9), distal metatarsal articular angle (DMAA) 10°, congruent joint — moderate hallux valgus';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue normal weight-bearing"},{"label":"B","text":"Acute Charcot Neuroarthropathy (Eichenholtz Stage I — Active Fragmentation)"},{"label":"C","text":"Immediate amputation"},{"label":"D","text":"IV antibiotics presuming osteomyelitis without evidence"},{"label":"E","text":"Long-term oral steroid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Charcot Neuroarthropathy (Eichenholtz Stage I — Active Fragmentation): (1) **differentiate from osteomyelitis** crucial — clinical (no wound, no sinus tract), MRI (no abscess/ring enhancement), low-level inflammation, history (insensate diabetic without break in skin); biopsy if uncertainty + concurrent ulcer; (2) **immediate immobilization + offloading** — most important intervention: (a) **total contact cast (TCC)** — gold standard — full contact cast that immobilizes + redistributes pressure away from involved area + reduces edema, change weekly, (b) alternative — irremovable CROW boot (Charcot Restraint Orthotic Walker), (c) **strict non-weight bearing or protected WB** for 3-6 months until acute phase resolves; (3) **Eichenholtz staging**: I — fragmentation/destructive (acute, hot, swollen — months); II — coalescence (subacute — resolution of edema, callus formation); III — consolidation (chronic — stable deformity); (4) **monitor**: skin temperature comparison to contralateral (cool down 2°C difference = resolution), X-ray progression, edema reduction; (5) **bisphosphonate** controversial — no clear benefit; calcitonin sometimes used; (6) **glycemic control** + multidisciplinary diabetes care; (7) **surgical reconstruction** (after acute phase resolved into consolidation phase) for: severe deformity preventing braceability, ulceration over bony prominence, instability, recurrent ulcers, infection — options: exostectomy, arthrodesis (midfoot Lapidus, hindfoot triple), Ilizarov correction; (8) **prevent recurrence**: lifetime custom shoes/orthotics + regular podiatry follow-up + patient education; (9) **avoid weight-bearing during acute phase** at all costs — leads to progressive deformity

---

Charcot neuroarthropathy: diabetic neuropathy + autonomic. Differentiate from osteomyelitis (no wound, no abscess on MRI). Eichenholtz I (acute) → II → III. Acute: total contact cast + offloading + protected WB 3-6 mo (until temperature normalizes). Surgery later for severe deformity, ulcer over prominence. Lifetime custom shoes + podiatry. Glycemic control. WB during acute → catastrophic deformity progression.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 58 ปี DM2 x 20 ปี with diabetic neuropathy + foot deformity, ปวด + บวม + แดง + warm midfoot ขวา 3 สัปดาห์ ไม่มี trauma ชัดเจน, ไม่มี wound

V/S: stable, no fever
PE: warm + erythema + edema midfoot, no draining wound, palpable pedal pulses, severe sensory loss (insensate — neuropathic), rocker-bottom deformity beginning, no ascending cellulitis, no purulence
Lab: WBC 8,000, CRP 25, ESR 45 (mild inflammation but not septic-level), glucose 280

X-ray foot: fragmentation + subluxation + joint destruction Lisfranc (TMT) region, no obvious sequestrum, no soft tissue gas
MRI foot: bone marrow edema + multiple TMT fractures + subluxation without ring-enhancing collection (vs OM which would have abscess + sinus tract)

Dx: Acute Charcot Neuroarthropathy (Eichenholtz stage I — fragmentation) midfoot';

update public.mcq_questions
set choices = '[{"label":"A","text":"Steroid injection PTT first line"},{"label":"B","text":"Stage IIB Adult Acquired Flatfoot (Flexible Deformity) Failed Conservative — Surgical Reconstruction"},{"label":"C","text":"Always triple arthrodesis regardless of stage"},{"label":"D","text":"Above-knee amputation"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stage IIB Adult Acquired Flatfoot (Flexible Deformity) Failed Conservative — Surgical Reconstruction: (1) **conservative first-line 3-6 months** (already failed in this case): (a) custom-molded orthotic with medial arch + heel posting (UCBL, AFO), (b) **PT** — eccentric posterior tibial tendon strengthening (Alfredson protocol), Achilles stretching, intrinsic foot strengthening, (c) NSAIDs, (d) supportive footwear, (e) brief immobilization (cast/boot) for acute exacerbation, (f) **avoid corticosteroid injection** (risk of tendon rupture); (2) **Johnson-Strom (Myerson modification) staging**: I — tenosynovitis without deformity; II — flexible flatfoot (IIA — forefoot abduction < 30%; IIB — > 30%); III — rigid deformity; IV — talar tilt + ankle valgus; (3) **surgical treatment** stage-specific: (a) Stage I — tenosynovectomy ± tendon debridement; (b) **Stage II (flexible) — joint-sparing reconstruction**: medial slide calcaneal osteotomy + lateral column lengthening (Evans) + FDL (flexor digitorum longus) transfer to navicular + spring ligament repair + Achilles/gastrocnemius lengthening if equinus; (c) Stage III (rigid) — **triple arthrodesis** (subtalar + talonavicular + calcaneocuboid) for rigid hindfoot deformity; (d) Stage IV — modified triple + medial deltoid ligament reconstruction or ankle arthrodesis; (4) post-op: non-WB 6-8 weeks, gradual WB in boot, full WB 3-4 months; (5) modern minimally invasive osteotomies emerging; (6) patient counseling — return to full activity 6-12 months; (7) addressing all components: bony (osteotomy) + soft tissue (FDL transfer, spring ligament) + Achilles (lengthening) — "reconstruction" rather than single procedure

---

PTTD/Adult flatfoot: Johnson-Strom staging guides. Conservative first (orthotic, eccentric exercise — Alfredson). AVOID steroid injection (rupture risk). Surgery for failed conservative: Stage II flexible → joint-sparing (medial slide calc osteotomy + lateral column lengthening + FDL transfer + spring ligament repair); Stage III rigid → triple arthrodesis; Stage IV → modified triple + deltoid reconstruction or ankle fusion.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 55 ปี ปวด medial ankle + arch ขวา + ค่อย ๆ มี progressive flatfoot 2 ปี ไม่สามารถยืน single-leg heel raise ได้

PE: visible flatfoot deformity with valgus hindfoot + abducted forefoot + arch collapse, "too many toes sign" lateral (excessive abduction), tender posterior tibial tendon path, unable to perform single heel raise on affected side (cannot invert hindfoot), supple deformity (correctable with manipulation — stage IIA-B vs rigid in advanced)

MRI ankle: posterior tibial tendon tear + tenosynovitis + degeneration, no significant arthritis

Dx: Adult Acquired Flatfoot Deformity (AAFD) — Posterior Tibial Tendon Dysfunction (PTTD), Johnson-Strom stage IIB (flexible + valgus hindfoot + abducted forefoot)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Start allopurinol immediately during acute attack"},{"label":"B","text":"Acute Gouty Arthritis Attack (First MTP — Podagra) with CKD"},{"label":"C","text":"Continue thiazide diuretic"},{"label":"D","text":"IV antibiotics presumed septic without aspiration"},{"label":"E","text":"No treatment self-limited"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Gouty Arthritis Attack (First MTP — Podagra) with CKD: (1) **joint aspiration mandatory** to confirm dx + rule out septic arthritis (concurrent septic in gouty joint not rare); polarized light microscopy — negatively birefringent needle-shaped urate crystals diagnostic; (2) **acute attack treatment** (start within 24h for best response; continue until resolution + 1-2 days): (a) **NSAIDs** first-line in patients without contraindication (indomethacin, naproxen, etoricoxib) — avoid in this patient with CKD; (b) **colchicine** 1.2 mg → 0.6 mg 1h later → 0.6 mg BID — effective if started early (< 24h); reduce dose in CKD; many GI side effects; (c) **corticosteroid** — oral prednisolone 30-40 mg × 5-7 days OR intra-articular steroid (joint injection — excellent for monoarthritis, after septic ruled out) — **preferred in this patient with CKD**; (d) **IL-1 antagonist (anakinra, canakinumab)** for refractory or NSAID/steroid/colchicine intolerant — expensive; (3) **do NOT start urate-lowering therapy during acute attack** (worsens) — wait 2-4 weeks after resolution; (4) **urate-lowering therapy (ULT)** indications: ≥ 2 attacks/year, tophi, urate nephrolithiasis, CKD: (a) **first-line allopurinol** (titrate to target uric acid < 6, or < 5 if tophi); start 100 mg + slowly uptitrate (rapid escalation may trigger attack); check HLA-B*58:01 in high-risk populations (Asian — SJS/TEN); (b) febuxostat alternative (avoid in CV disease — CARES trial); (c) probenecid (uricosuric) — avoid in CKD; (d) pegloticase for refractory; (5) **flare prophylaxis** during ULT initiation — low-dose colchicine 0.6 mg daily OR low-dose NSAID × 6 months to prevent flares; (6) **lifestyle**: reduce alcohol (especially beer), purine-rich foods (red meat, organ meat, shellfish, high-fructose corn syrup), weight loss, hydration; switch thiazide (worsens hyperuricemia) to alternative (losartan — uricosuric); (7) screen comorbidities (HT, DM, MetS, CV, renal); (8) educate; (9) follow-up

---

Acute gout: joint aspiration confirms (negatively birefringent crystals) + rules out septic. Acute Rx: NSAID, colchicine (early), steroid (preferred in CKD). Do NOT start ULT in acute attack. Indications for ULT: ≥ 2/yr, tophi, nephrolithiasis, CKD. Allopurinol first (target < 6) — check HLA-B*58:01 in Asians (SJS). Flare prophylaxis × 6 mo. Lifestyle. Switch thiazide (worsens). Modify CV/renal/metabolic comorbidities.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี underlying HT + CKD stage 3 + กิน thiazide + alcohol heavy ตื่นมาเช้านี้ปวด + บวม + แดง + ร้อน 1st MTP ขวา (podagra) อย่างรุนแรง 12 ชั่วโมง pain 10/10

V/S: T 37.8°C
PE: erythema + warmth + extreme tenderness 1st MTP ขวา, no other joints, no fever significant, no skin source
Lab: WBC 12,000, CRP 80, uric acid 9.2 (elevated; but acute attack uric acid can be normal), Cr 1.8 (CKD)

Joint aspiration 1st MTP: WBC 28,000 (PMN 80%), polarized light — **negatively birefringent needle-shaped urate crystals** intracellular within neutrophils — gout confirmed
Gram stain negative + culture pending (rules out concurrent septic arthritis)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all RA medication before surgery"},{"label":"B","text":"Severe Rheumatoid Hand Deformity Despite Optimized DMARD — Reconstruction"},{"label":"C","text":"Total hand arthrodesis"},{"label":"D","text":"Discharge no surgery ever"},{"label":"E","text":"Above-elbow amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Rheumatoid Hand Deformity Despite Optimized DMARD — Reconstruction: (1) **medical management optimization first** with rheumatologist — modern bDMARD/tsDMARD has reduced surgical need: methotrexate, anti-TNF (adalimumab, etanercept), JAK inhibitors (tofacitinib, baricitinib), anti-IL-6 (tocilizumab), B-cell (rituximab) — ensure controlled disease activity DAS28 < 3.2 minimum, ideally remission; (2) **surgery** for functional impairment + pain despite medical optimization, deformity progression, tendon rupture imminent or actual; (3) **principles**: address proximal joints (wrist) before distal (MCP, PIP, DIP) — pyramid; address tendon rupture acutely (e.g., extensor tendon rupture at Lister tubercle — Mannerfelt syndrome — needs tendon transfer); (4) **specific procedures** (tailored): (a) **wrist** — synovectomy + Darrach (distal ulna excision) or Sauvé-Kapandji (DRUJ fusion) for caput ulnae syndrome; wrist arthrodesis (Mannerfelt nail) for end-stage; total wrist arthroplasty alternative; (b) **MCP joints** — silicone implant arthroplasty (Swanson) — pain relief + correction of ulnar drift + improved cosmesis (function modest improvement); modern pyrocarbon implants; tendon rebalancing; (c) **PIP** — silicone arthroplasty (index/middle for pinch — preserve motion) OR arthrodesis (ring/small for stability — preserve grip); (d) **DIP** — usually arthrodesis (stability over motion); (e) **swan neck deformity** — silicone arthroplasty PIP, central slip reattachment, or DIP arthrodesis; (f) **boutonnière** — Fowler central slip reconstruction or arthroplasty if PIP destroyed; (g) **extensor tendon ruptures** — end-to-side transfer (EIP, FDS-3, FDS-4); (5) post-op: hand therapy critical with custom splinting + ROM; (6) patient expectations — pain relief + cosmesis better than function gains; (7) staged procedures common

---

RA hand: medical first (DMARD optimization). Surgery for functional impairment despite optimization. Address proximal → distal. Wrist: synovectomy + Darrach/Sauvé-Kapandji, arthrodesis. MCP: silicone arthroplasty (Swanson). PIP: arthroplasty (index/middle) or arthrodesis (ring/small). DIP: arthrodesis. Extensor rupture: tendon transfer. Hand therapy essential. Pain + cosmesis > function gains. Modern bDMARD reduced surgical need.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 55 ปี RA seropositive (RF + anti-CCP +) 15 ปี ปวด + บวมข้อมือ + นิ้วมือ + ผิดรูปทั้ง 2 ข้าง อาการ stable on stable DMARD (MTX + adalimumab) แต่ลำบาก ADL — ติดกระดุม เปิดขวด พิมพ์ ใช้ช้อน

PE: bilateral wrist + MCP + PIP synovitis with classic deformities — ulnar drift MCP, swan neck + boutonnière deformities multiple fingers, wrist subluxation + radial deviation, intrinsic plus deformity, trigger fingers multiple
DAS28 well-controlled 2.8 (low activity)

X-ray hand + wrist: severe RA — joint destruction MCP + PIP + wrist, periarticular osteopenia, subluxation, erosion, no fusion yet';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cervical collar only no imaging"},{"label":"B","text":"Cervical Fracture in Ankylosing Spondylitis — \"3-Column Fracture Despite Minor Trauma\" — Highly Unstable"},{"label":"C","text":"Force neck into neutral position"},{"label":"D","text":"Aggressive traction immediately"},{"label":"E","text":"Discharge with cervical collar without imaging"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical Fracture in Ankylosing Spondylitis — "3-Column Fracture Despite Minor Trauma" — Highly Unstable: (1) **MRI mandatory** in any AS patient with new neck pain after even trivial trauma — fractures highly unstable + frequently missed initially (50%); (2) **immediate strict immobilization** — collar in pre-injury chin-on-chest position (DO NOT force into neutral — can cause neurologic injury — splint in deformed position with sandbags/towels); (3) **DO NOT use traction except in carefully controlled OR setting** — fractures in AS span all 3 columns + traction can lead to distraction + neurologic injury; (4) **emergent surgical stabilization** — long-segment posterior instrumentation 2-3 levels above + 2-3 levels below fracture (3+ levels each side for adequate purchase in osteoporotic AS bone) — long construct + good fixation; biomechanically — AS bone is osteoporotic + long lever arms above/below fracture; (5) MRI to assess cord edema + epidural hematoma (much higher risk in AS — bleeding into rigid spine) — surgical decompression if needed; (6) **screen for additional fractures** — full neuroaxis CT/MRI (multiple fractures common — particularly thoracolumbar); (7) **avoid extension force** during transport + intubation (awake fiberoptic intubation preferred); (8) AS patient — predispose to high mortality (30%) post-trauma — careful management; complications: epidural hematoma, neurologic deterioration, pseudarthrosis, fixation failure; (9) DVT prophylaxis; (10) long-term — TNF inhibitors for AS optimization; bone health (vitamin D, bisphosphonate); fall prevention; (11) **chin-on-chest deformity correction** considered separately later in elective settings (pedicle subtraction osteotomy — PSO)

---

AS cervical fracture: highly unstable 3-column injury from minor trauma. MRI mandatory (50% initially missed). Immobilize in PRE-INJURY position (don''t force neutral — can cause neuro injury). AVOID traction. Long-segment posterior instrumentation (3+ levels each side). MRI for epidural hematoma (common). Full neuroaxis imaging (multiple fractures). Awake fiberoptic intubation. High mortality (30%). Long-term: TNF, bone health, fall prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 65 ปี Ankylosing Spondylitis (HLA-B27 +) duration 30 ปี complete cervical fusion ankylosis + thoracic kyphosis 50° (chin-on-chest deformity) ตกหกล้มเตี้ย ๆ ในห้องน้ำ ปวดคอเล็กน้อย
ไม่มี neurologic deficit

PE: severe kyphotic deformity (cannot extend neck), neck pain new-onset, motor + sensory intact bilateral, normal reflexes, no spinal cord level findings

X-ray + CT C-spine: AS classic "bamboo spine", complete autofusion + ossification of anterior + posterior longitudinal ligaments + ligamentum flavum + facet joint fusion; **C5-C6 transverse fracture through ankylosed segment crossing all 3 columns** (highly unstable despite minor trauma)
MRI C-spine: subtle cord edema at fracture level, no cord compression yet';

update public.mcq_questions
set choices = '[{"label":"A","text":"Allopurinol urate-lowering therapy"},{"label":"B","text":"Acute CPPD (Pseudogout) Arthritis Elderly"},{"label":"C","text":"Antibiotic IV without aspiration"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute CPPD (Pseudogout) Arthritis Elderly: (1) **joint aspiration mandatory** to confirm CPPD (positively birefringent rhomboid crystals) + rule out septic; concurrent septic arthritis common in elderly; (2) **acute attack treatment**: (a) **NSAIDs** if no contraindication; (b) **colchicine** (acute + prophylaxis); (c) **intra-articular corticosteroid** — excellent for monoarthritis after septic ruled out — first-line in elderly with comorbidities; (d) oral steroid alternative for polyarticular; (e) IL-1 antagonist (anakinra) for refractory; (3) **no urate-lowering therapy** (CPPD not urate); (4) **prophylaxis for recurrent attacks**: low-dose colchicine 0.5-0.6 mg daily; (5) **screen secondary causes** — "H''s" — Hyperparathyroidism, Hemochromatosis, Hypomagnesemia, Hypophosphatasia, Hypothyroidism, Wilson disease (rare); workup: Ca, Mg, Phosphate, TSH, ferritin, parathyroid hormone, alkaline phosphatase; (6) **address comorbidity** — primary hyperparathyroidism in this patient → endocrinology workup + parathyroidectomy if indicated (improves CPPD); (7) **chronic CPPD arthropathy** (pseudo-OA, pseudo-RA pattern) — managed as OA + symptomatic + intra-articular treatment; (8) **X-ray chondrocalcinosis** characteristic finding (linear calcification cartilage); (9) **education** patient + family + multidisciplinary geriatric care

---

CPPD (pseudogout): positively birefringent rhomboid crystals. Aspiration confirms + rules out septic (concurrent common). Acute Rx: NSAID, colchicine, INTRA-ARTICULAR STEROID (preferred in elderly comorbidity), IL-1 antag for refractory. Screen secondary causes ("H''s" — HPT, hemochromatosis, hypoMg, hypothyroid). Parathyroidectomy may help. Chondrocalcinosis on X-ray. Multidisciplinary geriatric care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 75 ปี ปวด + บวม + warm ข้อเข่าซ้าย acute 1 วัน, ไม่มี trauma, no fever
PMHx: hyperparathyroidism, recent UTI

V/S: T 37.6°C
PE: knee effusion + tender + warm, no other joints, no skin source

Lab: WBC 11,000, CRP 60, uric acid 6.5 (within normal), Ca 11.0 (mildly elevated)

Knee aspiration: WBC 18,000 (PMN 75%), polarized light — **positively birefringent rhomboid-shaped crystals** (CPPD/calcium pyrophosphate dihydrate) — pseudogout confirmed
Gram stain + culture negative

X-ray knee: chondrocalcinosis (linear calcification meniscus + hyaline cartilage) bilateral';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive PT in painful phase"},{"label":"B","text":"Adhesive Capsulitis (Frozen Shoulder) in DM — Phase-Specific Management"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adhesive Capsulitis (Frozen Shoulder) in DM — Phase-Specific Management: (1) **natural history** — 3 phases: (a) painful/freezing (6 wk - 9 mo) — pain dominant, ROM declining; (b) frozen/adhesive (4-12 mo) — stiff with less pain; (c) thawing (5-26 mo) — gradual recovery of ROM; total course 1-3 years; (2) **patient education + reassurance** about natural history; (3) **conservative management** first-line: (a) **NSAIDs** for pain; (b) **physiotherapy** — gentle ROM + stretching within pain tolerance; aggressive PT during painful phase may worsen — counterintuitive; (c) **intra-articular corticosteroid injection** (glenohumeral, US-guided) — evidence supports moderate short-medium term benefit + may accelerate recovery especially in painful phase; (d) **hydrodilatation** (capsular distension with saline + steroid under fluoroscopy) — moderate evidence in frozen phase; (e) home exercise (Codman pendulum, wall walking, towel stretches); (4) **diabetes optimization** — DM is major risk factor + worse outcomes (HbA1c control); (5) **interventional treatment** for severe refractory: (a) **manipulation under anesthesia (MUA)** — useful but capsular rupture risk + complications; (b) **arthroscopic capsular release** — modern preferred, releases rotator interval + anterior capsule + axillary recess + posterior capsule selectively, immediate ROM gain — for refractory > 6-12 months; (6) **avoid prolonged immobilization** (worsens stiffness); (7) **screen comorbidities** — DM, thyroid (hypo + hyper), Dupuytren, CV disease; (8) **counseling** — long course, function generally returns over 1-3 years even without surgery

---

Adhesive capsulitis (frozen shoulder): self-limited natural history 1-3 years (3 phases — painful, frozen, thawing). DM major risk + worse outcomes. Conservative: NSAIDs + gentle PT + glenohumeral steroid injection + hydrodilatation. AVOID aggressive PT in painful phase. MUA + arthroscopic capsular release for severe refractory. Optimize DM + screen thyroid + Dupuytren. Educate on natural history.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 52 ปี DM2 (HbA1c 8.5%) ปวด + ขยับไหล่ขวาลำบาก 6 เดือน ปวดมากตอนกลางคืน + ค่อย ๆ stiff ขึ้นเรื่อย ๆ, ไม่มี trauma

PE: global limitation ROM both active + passive (active = passive — characteristic of capsular pattern frozen shoulder); external rotation < 30°, abduction < 90°, internal rotation to L1 only; mild tenderness; no clear weakness when isolated

MRI shoulder: thickened glenohumeral joint capsule + axillary recess obliteration + coracohumeral ligament thickening — adhesive capsulitis, no rotator cuff tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative observation always"},{"label":"B","text":"OPLL with Cervical Myelopathy — Surgical Decompression"},{"label":"C","text":"Cervical traction long term home"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Lumbar laminectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OPLL with Cervical Myelopathy — Surgical Decompression: (1) **OPLL** more common in East Asian populations (2-3% — Japanese, Korean, Thai, Chinese); types: continuous, segmental, mixed, localized; associated with DISH (diffuse idiopathic skeletal hyperostosis), ankylosing spondylitis, hypoparathyroidism; (2) **AOSpine CSM guidelines** — moderate-severe myelopathy → surgical decompression preferred to prevent progression; (3) **surgical approach** depends on: extent of OPLL, K-line (line from anterior C2 to anterior C7 — if OPLL crosses K-line → anterior decompression preferred), cervical alignment (lordosis vs kyphosis), number of levels: (a) **anterior cervical corpectomy + reconstruction (ACCF) + fusion** — for OPLL crossing K-line, kyphotic alignment, focal compression; technically demanding (dural tear risk — OPLL may be adherent to dura), CSF leak; (b) **posterior approach (laminectomy + fusion or laminoplasty)** — preferred for: multilevel (≥ 3), preserved lordosis, OPLL not crossing K-line, lower complication rate vs anterior; (c) **combined approach** for severe; (4) **laminoplasty** — motion-preserving open-door laminoplasty popular in Asia for multilevel OPLL with preserved lordosis — comparable outcomes vs fusion with less morbidity; (5) **complications**: C5 nerve palsy (post-op, 5-10%), CSF leak (anterior), dural tear, recurrence/progression of OPLL after posterior surgery; (6) **OPLL is progressive disease** — continues to ossify; follow long-term; (7) **screen DISH + endocrinopathy** if extensive; (8) post-op: rehab, gradual return; (9) outcomes — modest improvement (don''t promise return to normal)

---

OPLL: Asian-prevalent ossified PLL → cervical myelopathy. Surgical decompression for moderate-severe (AOSpine). K-line guides approach (OPLL crossing K-line → anterior corpectomy preferred). Posterior (laminoplasty or laminectomy + fusion) for multilevel + preserved lordosis. Anterior risk of dural tear (OPLL adherent). C5 palsy post-op risk. Progressive disease — long-term follow-up. Screen DISH, endocrinopathy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 62 ปี ปวดคอ + ค่อย ๆ มี gait imbalance + clumsy hands 1 ปี + numbness ปลายมือ
ไม่มี trauma

PE: hyperreflexia + Hoffmann''s + Babinski + wide-based gait + decreased fine motor — myelopathy signs

X-ray + CT C-spine: **ossification of posterior longitudinal ligament (OPLL)** — dense ossified band along posterior vertebral body C3 to C6, severe canal stenosis 50%, no instability; continuous type (vs segmental, mixed, localized)
MRI: cord compression + signal change C4-C5

Dx: OPLL — cervical myelopathy (more common in Asian — ~ 2-3% Japan/Korea/Thailand)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bone grows in length only via physis"},{"label":"B","text":"remodels in response to mechanical stress"},{"label":"C","text":"Bone never remodels after maturity"},{"label":"D","text":"All bone is dead tissue"},{"label":"E","text":"Bone density only genetic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wolff''s Law: "Bone in a healthy person or animal will adapt to the loads under which it is placed." Bone is dynamic tissue that **remodels in response to mechanical stress** — increased stress → increased bone density + cortical thickness (hypertrophy); decreased stress (immobilization, microgravity, paralysis) → decreased bone density + cortical thinning (atrophy/osteopenia); (1) **mechanotransduction** — osteocytes (terminally differentiated osteoblasts buried in lacunae + canalicular network) act as primary mechanosensors detecting fluid flow + strain → signaling via Wnt/β-catenin (sclerostin downregulation → bone formation), RANKL/OPG axis, nitric oxide, prostaglandins; (2) **clinical applications**: (a) disuse osteopenia post-immobilization (this patient), (b) astronauts in microgravity lose 1-2%/month BMD, (c) athletes — tennis player dominant arm has higher BMD, (d) **mechanical loading therapy** for osteoporosis (weight-bearing exercise, resistance training, vibration therapy), (e) implant design (stress shielding under rigid prosthesis → bone resorption — common around femoral stems), (f) bone remodeling around osteotomies + fractures (callus formation under stress), (g) **distraction osteogenesis** (Ilizarov — gradual distraction stimulates new bone formation along tension), (h) **bone tunnel widening** post-ACL reconstruction (mechanical stress), (i) Sigmund Frost''s law (related) — chronic damaging strain causes maladaptive change; (3) **Davis'' Law** parallel for soft tissue — "soft tissue remodels along lines of stress" (tendon, ligament, fascia)

---

Wolff''s Law: bone remodels per mechanical stress. Osteocytes are mechanosensors (Wnt/β-catenin, RANKL, NO, PGE). Clinical applications: disuse osteopenia, astronaut bone loss, athlete sport-side hypertrophy, stress shielding around implants, distraction osteogenesis (Ilizarov), exercise for osteoporosis. Davis'' law analogous for soft tissue. Foundation principle in orthopedics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

คำถามเกี่ยวกับ bone biology + Wolff''s Law:

**Wolff''s law (formulated by Julius Wolff 1892)** อธิบายปรากฏการณ์อะไรในกระดูก?

สภาพแวดล้อม: เด็กชายอายุ 14 ปี แขนซ้าย immobilized ใน cast 8 weeks หลัง forearm fracture
หลัง remove cast: forearm bone density ลดลง + cortical thickness ลดลง compared to contralateral';

update public.mcq_questions
set choices = '[{"label":"A","text":"All fractures heal the same way"},{"label":"B","text":"Fracture Healing Mechanisms — Primary vs Secondary Bone Healing"},{"label":"C","text":"Primary healing has more callus than secondary"},{"label":"D","text":"Secondary healing is faster than primary"},{"label":"E","text":"Cartilage callus does not exist"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fracture Healing Mechanisms — Primary vs Secondary Bone Healing: (1) **Primary (direct) bone healing** — occurs only with **anatomic reduction + rigid fixation + minimal gap (< 100-300 μm) + minimal interfragmentary motion**: (a) **contact healing** — direct cortical reconstruction via cutting cones (osteoclasts at front + osteoblasts behind laying down osteons in haversian remodeling); requires gap < 0.01 mm; (b) **gap healing** — gap 100-300 μm — fills with lamellar bone perpendicular to long axis → secondary remodeling into normal cortical bone; (c) **no visible callus** on X-ray; (d) **slow process** (months-years for complete remodeling); (e) examples: lag screw fixation, plate fixation with compression, ORIF; (2) **Secondary (indirect/endochondral) bone healing** — physiologic healing with some motion + larger gap: 4 stages: (a) **hematoma + inflammation** (days 1-7): fracture hematoma rich in growth factors (BMP, TGF-β, PDGF, FGF), inflammatory response; (b) **soft callus** (days 7-21): chondroblasts → cartilaginous callus (endochondral pathway recapitulating embryonic bone formation) + intramembranous formation peripherally; (c) **hard callus** (3-12 weeks): cartilaginous callus mineralizes + replaces with woven bone via endochondral ossification; (d) **remodeling** (months-years): woven bone → lamellar bone, Wolff''s law re-shapes; (e) **visible callus** on X-ray; (f) **examples**: cast, IM nail, external fixator, bridging plate; (3) **clinical correlation**: AO principles — absolute stability for primary healing (articular surfaces) vs relative stability for secondary healing (diaphyseal — bridging callus = strong stable construct); (4) **BMP-2, BMP-7** clinical use in non-unions; (5) **factors** affecting healing: blood supply, mechanical stability, gap size, age, nutrition, smoking, NSAIDs (controversial), diabetes, infection

---

Fracture healing: primary (direct) — anatomic reduction + rigid fixation + minimal gap/motion → cutting cones, no callus (lag screw, plate compression). Secondary (indirect, endochondral) — some motion + gap → 4 stages: hematoma → soft callus → hard callus → remodeling, with visible callus (cast, IM nail, ex-fix, bridging plate). AO principles: absolute stability for articular, relative stability for diaphysis. BMP-2/7 for non-unions.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

Fracture healing: รูปแบบ healing แตกต่างกันใน scenarios ต่อไปนี้:

A) Lag screw fixation of oblique tibial fracture with anatomic reduction + interfragmentary compression (gap < 100 μm)
B) Intramedullary nailing of midshaft femoral fracture with motion at fracture site (gap 1-3 mm)

จงอธิบายความแตกต่างของ fracture healing mechanism + biology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Articular cartilage heals well after injury"},{"label":"B","text":"Articular Cartilage Anatomy + Physiology + Healing Limitations"},{"label":"C","text":"Cartilage has rich vascular supply"},{"label":"D","text":"Fibrocartilage is superior to hyaline cartilage"},{"label":"E","text":"Chondrocytes have unlimited reproductive capacity"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Articular Cartilage Anatomy + Physiology + Healing Limitations: (1) **Hyaline articular cartilage** — covers synovial joint surfaces; aneural + alymphatic + avascular (nutrition from synovial fluid via diffusion + cyclic loading — "sponge effect"); (2) **composition**: ~ 70% water, 20% type II collagen (provides tensile strength), 5% proteoglycans (mainly aggrecan with GAG side chains — chondroitin + keratan sulfate — provide compressive strength via hydration), chondrocytes (~ 1-5% by volume, only cell type — produces + maintains ECM); (3) **zonal architecture**: (a) **superficial (tangential) zone** — flat chondrocytes parallel to surface, collagen parallel — wear resistance; (b) **middle (transitional) zone** — rounded chondrocytes, oblique collagen — compression resistance; (c) **deep (radial) zone** — perpendicular columns of chondrocytes + collagen — load transfer to bone; (d) **calcified cartilage** — between cartilage + subchondral bone, separated by **tidemark**; (e) **subchondral bone** — provides nutrition + mechanical support; (4) **healing limitations** — major problem in cartilage injury: (a) **avascular** — no blood supply → no inflammatory response → no influx of progenitor cells, (b) **chondrocyte limited reproductive capacity** + cannot migrate to defects, (c) **isolated lacunae** — cells cannot communicate or migrate; (5) **partial-thickness defects** (chondral only — superficial to tidemark) — DO NOT heal; (6) **full-thickness defects** (chondral + subchondral) — partial healing via marrow-derived mesenchymal stem cells but forms **fibrocartilage** (type I collagen, biomechanically inferior to hyaline) — degrades over time; (7) **clinical correlations + cartilage restoration techniques** (size + location + age dependent): (a) **microfracture/abrasion arthroplasty** — small defects < 2 cm² — bone marrow stimulation → fibrocartilage fill; (b) **OATS (osteochondral autograft transfer)** / mosaicplasty — moderate defects 2-4 cm² from less weight-bearing area; (c) **OCA (osteochondral allograft)** — large defects > 4 cm²; (d) **ACI/MACI (autologous chondrocyte implantation/matrix-assisted)** — moderate-large defects; (e) **PRP, BMAC** adjuncts; (f) **scaffolds** emerging; (g) **gene therapy** + cell therapy investigational; (8) cartilage damage often progresses to OA — early intervention key

---

Articular cartilage: avascular, aneural, alymphatic. Type II collagen + proteoglycans + chondrocytes + 70% water. Zonal architecture (superficial → middle → deep → calcified → subchondral). Partial-thickness defects DO NOT heal. Full-thickness — fibrocartilage (inferior). Restoration: microfracture (small), OATS (mod), OCA (large), ACI/MACI (mod-large). Cartilage damage → OA progression. Early intervention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

คำถามเกี่ยวกับ **articular cartilage** anatomy + function + healing:

Articular cartilage มีโครงสร้างพิเศษ + ทำไม cartilage damage ถึง heal ยากเป็นพิเศษ + อะไรคือ implications สำหรับ cartilage restoration?';

update public.mcq_questions
set choices = '[{"label":"A","text":"All meniscus tears heal equally"},{"label":"B","text":"Meniscus Anatomy + Vascular Zones + Healing"},{"label":"C","text":"Inner meniscus has best blood supply"},{"label":"D","text":"Meniscus is purely structural with no function"},{"label":"E","text":"Meniscectomy improves joint biomechanics"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Meniscus Anatomy + Vascular Zones + Healing: (1) **Meniscus structure**: semilunar fibrocartilaginous discs between femoral condyles + tibial plateau (medial — C-shape; lateral — O-shape with discoid variant), composed of type I collagen + small amount type II + proteoglycans + meniscal cells (fibrochondrocytes); (2) **Functions**: (a) load distribution (50-70% of axial load transmitted in extension, up to 85% in flexion through menisci), (b) shock absorption, (c) joint stability (secondary to ligaments, especially medial meniscus posterior horn for AP knee stability), (d) joint lubrication, (e) proprioception; (3) **Vascular supply** — peripheral 20-30% of meniscus only — via geniculate arteries (medial + lateral superior + inferior, middle geniculate posterior); divided into **Arnoczky zones**: (a) **red-red zone** (outer 1/3, peripheral) — vascularized — excellent healing potential; (b) **red-white zone** (middle 1/3) — limited vascularity — moderate healing; (c) **white-white zone** (inner 1/3, central — avascular) — no vascularity — minimal healing; (4) **Clinical implications**: (a) **repairable tears**: vertical/longitudinal, peripheral red-red or red-white zone, acute (< 4-8 weeks), < 4 cm length, with reasonable tissue quality → arthroscopic meniscal repair (inside-out, outside-in, all-inside) to preserve meniscus + prevent PTOA; (b) **partial meniscectomy** for irreparable tears: complex degenerative, white-white zone, severely macerated, > 8 weeks old; (c) **augmentation** for borderline zones: fibrin clot, PRP, marrow venting, synovial rasping → improves healing; (5) **meniscal allograft transplantation** for prior subtotal/total meniscectomy with painful knee + relatively preserved cartilage in younger patient; (6) **meniscectomy associated with early PTOA** (Fairbank changes, increased contact pressure) — preserve meniscus when possible; (7) **bucket-handle tears, root tears, ramp lesions** — specific subtypes with surgical implications (root tear repair restores meniscal function)

---

Meniscus: fibrocartilage shock absorber + load distributor. Vascular zones (Arnoczky): red-red (peripheral, healing OK), red-white (middle, moderate), white-white (central, avascular — no healing). Repairable: peripheral, vertical, acute, < 4 cm. Meniscectomy → early OA → preserve when possible. Meniscal allograft for prior meniscectomy + painful knee. Root tear repair restores function. Augmentation for borderline zones.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Meniscus** ของเข่า มี **blood supply zones** ต่างกัน which directly affects healing potential + surgical decision-making

จงอธิบาย meniscus blood supply zones + clinical implications สำหรับ tears + repair';

update public.mcq_questions
set choices = '[{"label":"A","text":"Rotator cuff has only 2 muscles"},{"label":"B","text":"Rotator Cuff Anatomy + Function"},{"label":"C","text":"Deltoid is part of rotator cuff"},{"label":"D","text":"Rotator cuff is not innervated"},{"label":"E","text":"All rotator cuff muscles attach to lesser tuberosity"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rotator Cuff Anatomy + Function: (1) **4 muscles forming dynamic stabilizers + active movers of glenohumeral joint** — mnemonic **"SITS"**: (2) **Supraspinatus**: origin — supraspinous fossa scapula; insertion — superior facet of greater tuberosity humerus; action — initiation of abduction (0-15°), assists overhead elevation; innervation — **suprascapular nerve** (C5, C6); clinical — most commonly injured (rotator cuff tear classic location), Jobe''s empty can test; (3) **Infraspinatus**: origin — infraspinous fossa; insertion — middle facet of greater tuberosity; action — external rotation (primary) + extension; innervation — **suprascapular nerve** (C5, C6); clinical — external rotation lag sign + Hornblower''s; spinoglenoid notch cyst → isolated infraspinatus weakness; (4) **Teres minor**: origin — lateral border scapula; insertion — inferior facet of greater tuberosity; action — external rotation + adduction; innervation — **axillary nerve** (C5, C6); clinical — Hornblower''s sign if isolated weakness; quadrilateral space syndrome; (5) **Subscapularis**: origin — subscapular fossa anterior scapula; insertion — lesser tuberosity humerus; action — internal rotation + adduction; innervation — **upper + lower subscapular nerves** (C5, C6, C7); clinical — belly press, lift-off test, bear hug test for subscapularis pathology; commonly torn in anterior shoulder dislocation; (6) **Function**: (a) **dynamic stabilization** — compresses humeral head into glenoid ("concavity-compression" — provides 60% of glenohumeral stability), (b) coordinate with deltoid for elevation (force couple), (c) initiate abduction (deltoid alone causes superior humeral migration without cuff), (d) rotational movements; (7) **Force couples**: anterior (subscapularis) + posterior (infraspinatus + teres minor) cuff balance; superior (cuff) + inferior (deltoid) balance; (8) **Clinical pearls**: (a) supraspinatus — most commonly injured, JOBE test; (b) **rotator cuff tear pattern progression** — typically begins at "crescent" of supraspinatus near insertion + progresses anteriorly + posteriorly; (c) **rotator interval** — between supraspinatus + subscapularis — contains coracohumeral + superior glenohumeral ligaments + biceps tendon; (d) blood supply tenuous in critical zone ("watershed" hypovascular zone 1 cm proximal to insertion) → degenerative tears origin

---

Rotator cuff: SITS (Supraspinatus, Infraspinatus, Teres minor, Subscapularis). Supra+Infra — suprascapular n; Teres minor — axillary; Subscap — upper/lower subscapular. Functions: dynamic stabilizer (concavity-compression — 60% stability), initiate abduction, rotation, force couples. Critical zone (watershed hypovascular) → degenerative tears. Specific tests for each (Jobe, ER lag, Hornblower, belly press, lift-off, bear hug).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Rotator cuff** anatomy + function — ส่วน core musculoskeletal

จงอธิบาย rotator cuff anatomy (4 muscles, origin/insertion, action, innervation) + functional importance + clinical correlations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Salter-Harris II has worst prognosis"},{"label":"B","text":"Physis (Growth Plate) Anatomy + Salter-Harris Classification"},{"label":"C","text":"Physis fractures all heal without growth disturbance"},{"label":"D","text":"Type V is the most common"},{"label":"E","text":"Reserve zone is the weakest zone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physis (Growth Plate) Anatomy + Salter-Harris Classification: (1) **Physis structure** — cartilaginous growth plate between epiphysis + metaphysis in growing bone; responsible for **endochondral ossification** + longitudinal growth; (2) **Zones** (epiphysis → metaphysis): (a) **reserve/resting zone** — stem-cell-like chondrocytes, low metabolic activity, contains BMP-rich matrix; (b) **proliferative zone** — chondrocytes divide + form columns parallel to longitudinal axis; (c) **hypertrophic zone** (3 subzones — maturation, degeneration, calcification) — chondrocytes enlarge + matrix calcifies + chondrocytes apoptose; **weakest zone — fractures typically occur here**; (d) **metaphyseal zone (zone of provisional calcification)** — vascular invasion + osteoblast deposition of woven bone; (3) **Blood supply** — perichondrial ring (Lacroix) + epiphyseal vessels (nourish proliferative + reserve zone — INJURY threatens growth); metaphyseal vessels nourish metaphyseal side; (4) **Salter-Harris Classification of physeal fractures (1963)** — based on fracture pattern + prognostic implications: (a) **Type I** — fracture through physis only (separation) — typically excellent prognosis, usually closed reduction + cast, may be radiologically subtle; (b) **Type II** — fracture through physis + metaphysis (Thurston-Holland fragment) — most common (75%), usually good prognosis with closed reduction; (c) **Type III** — fracture through physis + epiphysis (intra-articular) — requires anatomic reduction (open if needed) to restore articular congruity + prevent growth arrest at fracture site; (d) **Type IV** — fracture through metaphysis + physis + epiphysis (vertical, intra-articular) — anatomic reduction essential (often ORIF) to prevent partial growth arrest ("bone bar" formation); (e) **Type V** — crush injury to physis (rare, often diagnosed retrospectively after growth arrest); WORST prognosis — universal growth arrest; (f) **Type VI** (Rang) — perichondrial ring injury — peripheral growth arrest; (5) **Growth arrest mechanism** — bone bar formation between epiphysis + metaphysis blocking physis → angular deformity or limb-length discrepancy; (6) **Treatment of growth arrest** — physeal bar excision + interposition (fat, methyl methacrylate) for small bars in young children; epiphysiodesis (intentional growth plate closure) of unaffected side to balance length; corrective osteotomy; limb lengthening (Ilizarov); contralateral epiphysiodesis to equalize at maturity; (7) **clinical correlations**: SCFE (slip through hypertrophic zone), DDH late presentation, leg length discrepancy assessment (Multiplier method, Moseley straight-line graph, Paley methods), Greulich-Pyle bone age

---

Physis: cartilaginous growth plate. Zones: reserve → proliferative → hypertrophic (weakest, fractures here) → metaphyseal. Salter-Harris: I (through physis), II (+ metaphysis — most common, good prognosis), III (+ epiphysis, intra-articular — ORIF), IV (metaphysis + physis + epiphysis — ORIF, bar risk), V (crush — worst, growth arrest). Growth arrest → bone bar → angular deformity/LLD. Treatment: bar excision, epiphysiodesis, osteotomy, lengthening.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Physis (growth plate)** anatomy + injury classification (Salter-Harris) — สำคัญใน pediatric orthopedics

อธิบาย physis structure + Salter-Harris classification + prognostic implications + growth disturbance';

update public.mcq_questions
set choices = '[{"label":"A","text":"Osteoclasts form bone"},{"label":"B","text":"Bone Cellular Biology + RANKL/OPG Pathway"},{"label":"C","text":"Osteocytes do not communicate"},{"label":"D","text":"OPG promotes osteoclast formation"},{"label":"E","text":"Estrogen has no effect on bone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Cellular Biology + RANKL/OPG Pathway: (1) **3 main bone cell types**: (a) **osteoblasts** — bone-forming cells, derived from mesenchymal stem cells, produce type I collagen + non-collagenous matrix proteins (osteocalcin, osteopontin, BSP) → osteoid → mineralized; secrete alkaline phosphatase (clinical marker bone formation); regulated by Wnt/β-catenin pathway, BMP, PTH (intermittent — anabolic; continuous — catabolic), Vit D; (b) **osteoclasts** — bone-resorbing multinucleated giant cells, derived from monocyte/macrophage lineage; attach to bone via integrin αvβ3 (sealing zone) + secrete H+ (vacuolar ATPase → dissolves mineral) + cathepsin K (degrades collagen) → resorption pit (Howship''s lacuna); mark of activity — serum CTX, NTX (clinical markers bone resorption); (c) **osteocytes** — terminally differentiated osteoblasts buried in bone lacunae + canalicular network — most abundant bone cell (90-95%) — mechanosensors + secrete sclerostin (inhibitor of bone formation — Wnt/β-catenin antagonist) + FGF-23 (phosphate metabolism); (2) **RANKL/OPG/RANK pathway** — master regulator of osteoclast formation + activity: (a) **RANKL** (Receptor Activator of NF-κB Ligand) — produced by osteoblasts, osteocytes, T-cells; binds RANK receptor on osteoclast precursors → osteoclast differentiation + maturation + survival; (b) **OPG (osteoprotegerin)** — decoy receptor, also produced by osteoblasts, binds RANKL → prevents RANK activation → inhibits osteoclast formation; (c) **RANKL : OPG ratio** determines bone resorption (high ratio → more resorption); (d) **regulators of RANKL/OPG ratio**: PTH (continuous — increases RANKL → resorption); estrogen (increases OPG → protects bone — explains postmenopausal bone loss); glucocorticoid (increases RANKL → bone loss); (3) **Clinical applications — osteoporosis treatments**: (a) **bisphosphonates** (alendronate, zoledronate, risedronate, ibandronate) — inhibit osteoclast activity (interfere with farnesyl pyrophosphate synthase → apoptosis of osteoclasts); anti-resorptive; (b) **denosumab** — monoclonal antibody against RANKL — directly inhibits osteoclast formation; subQ q 6 months; (c) **teriparatide, abaloparatide** — PTH analogs given intermittent — anabolic (bone formation); (d) **romosozumab** — monoclonal antibody against sclerostin → activates Wnt/β-catenin → both anabolic + anti-resorptive; (e) **SERMs** (raloxifene) — estrogen receptor modulator; (f) **calcitonin** — limited use; (4) **adverse effects**: bisphosphonate — osteonecrosis of jaw (ONJ), atypical femur fracture (AFF); denosumab — same + rebound vertebral fractures if stopped without transition; romosozumab — CV concern

---

Bone biology: osteoblasts (form bone, Wnt/BMP), osteoclasts (resorb bone — H+ + cathepsin K), osteocytes (mechanosensors, sclerostin, FGF-23). RANKL/OPG/RANK axis = master regulator of osteoclasts. Osteoporosis Rx: anti-resorptive (bisphosphonate, denosumab — anti-RANKL), anabolic (teriparatide PTH analog, romosozumab — anti-sclerostin/Wnt activator), SERM. ONJ + AFF complications. Denosumab rebound fractures.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Bone biology** — cellular components + signaling — สำคัญต่อ osteoporosis treatment

อธิบาย osteoblast + osteoclast + osteocyte function + **RANKL/OPG pathway** + clinical applications (denosumab, bisphosphonates, romosozumab)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Complete immobilization always best for tendon healing"},{"label":"B","text":"Tendon Healing Biology + Phases"},{"label":"C","text":"Tendons heal within 1 week"},{"label":"D","text":"Type II collagen is dominant in tendons"},{"label":"E","text":"Corticosteroids enhance tendon healing"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tendon Healing Biology + Phases: (1) **Tendon structure**: highly organized type I collagen (90-95%) in parallel arrangement (tertiary structure — fibril → fibers → fascicles → tendon) + small amount type III + elastin + proteoglycans (decorin) + ground substance + tenocytes (sparse fibroblast-like cells) + endotenon + epitenon + paratenon (vascular layer); (2) **Vascular supply** — tendons are hypovascular relative to other tissues; blood supply from: (a) paratenon (most), (b) mesotendon, (c) bone-tendon junction, (d) musculotendinous junction; some tendons have "watershed" zones — Achilles (2-6 cm above insertion), supraspinatus (1 cm proximal to insertion) — prone to degeneration; (3) **Tendon healing phases** (3 phases, ~ 6+ months total): (a) **inflammatory phase** (days 1-7) — hemorrhage + clot, inflammatory cells (neutrophils → macrophages), growth factors (PDGF, TGF-β, IGF, VEGF); (b) **proliferative phase** (days 5 - 4 weeks) — fibroblast proliferation, type III collagen production (initially), high water content, disorganized; (c) **remodeling phase** (4 weeks - 1+ year) — type III → type I collagen, longitudinal alignment along stress, increased tensile strength, **continues for 6-12 months**; (4) **Intrinsic vs extrinsic healing**: (a) **intrinsic healing** — tenocytes within tendon proliferate + produce collagen → primary tendon healing; preferred mechanism, maintains tendon glide; (b) **extrinsic healing** — fibroblasts from peritendon migrate in → forms scar/adhesions → impairs tendon glide (e.g., flexor tendon zone II adhesions); both occur; balance important; (5) **Mechanical stimulation effects**: (a) **early controlled motion stimulates intrinsic healing** + promotes collagen alignment along stress + reduces adhesions; (b) **complete immobilization** → atrophy + extrinsic healing → adhesions + stiffness; (c) **excessive motion** → rupture + scarring; (6) **Clinical applications**: (a) **flexor tendon repair zone II** — early protected motion (Duran, Kleinert, early active) reduces adhesions; (b) **rotator cuff repair** — protected rehab — sling 4-6 weeks, then progressive ROM, full activity 4-6 months; (c) **Achilles repair** — progressive weight-bearing in boot, accelerated rehab; (d) **patellar tendon** repair — protected early ROM; (7) **factors affecting healing**: blood supply, nutrition (vitamin C, protein, zinc), age, smoking, NSAIDs (debated), corticosteroid (impairs healing — limit injections), DM, hypercholesterolemia (associated with tendinopathy)

---

Tendon healing: type I collagen + hypovascular (watershed zones). 3 phases: inflammatory (1-7 d) → proliferative (5 d - 4 wk) → remodeling (4 wk - 1+ yr). Intrinsic healing (tenocytes — maintains glide) vs extrinsic (peritendon — adhesions). Early controlled motion → intrinsic healing + collagen alignment → BETTER outcomes than complete immobilization. Steroid impairs. Continues 6-12 months. Clinical applications: flexor tendon, rotator cuff, Achilles rehab.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Tendon healing biology** — สำคัญสำหรับ rehabilitation protocols after tendon repair (e.g., Achilles, rotator cuff, flexor tendon)

อธิบาย tendon healing phases + intrinsic vs extrinsic healing + implications สำหรับ early motion vs immobilization';

update public.mcq_questions
set choices = '[{"label":"A","text":"Spinothalamic tract carries vibration sense"},{"label":"B","text":"Spinal Cord Tracts + Clinical Correlations"},{"label":"C","text":"Corticospinal tract crosses in lumbar cord"},{"label":"D","text":"Brown-Sequard has worst prognosis"},{"label":"E","text":"Posterior cord syndrome affects motor function"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal Cord Tracts + Clinical Correlations: (1) **Descending tracts** (motor): (a) **lateral corticospinal tract** — primary voluntary motor — UMN cell bodies in motor cortex → decussate at medullary pyramids → descend in lateral spinal cord → synapse on LMN in anterior horn ipsilateral; controls **ipsilateral** muscles below decussation; injury → ipsilateral UMN signs below level; (b) **anterior corticospinal tract** — minor, axial musculature; (c) extrapyramidal — rubrospinal, vestibulospinal, reticulospinal, tectospinal (modulate posture, tone); (2) **Ascending tracts** (sensory): (a) **dorsal column-medial lemniscus (DCML)** — fine touch + vibration + proprioception + 2-point discrimination; ascends ipsilaterally → decussates in medulla → sensation from **contralateral** side perceived; (b) **lateral spinothalamic tract** — pain + temperature; sensory neurons enter spinal cord → ascend 1-2 levels → cross immediately to opposite side via anterior commissure → ascend in lateral spinothalamic tract → sensation from **contralateral** side; (c) **anterior spinothalamic tract** — crude touch + pressure (less clinically important); (d) **spinocerebellar tracts** — unconscious proprioception to cerebellum; (3) **Incomplete spinal cord syndromes**: (a) **Central cord syndrome** — most common, hyperextension injury in older with cervical stenosis — central gray matter + medial corticospinal damage → **upper extremity weakness > lower extremity weakness** (cervical fibers central, lumbar fibers lateral in corticospinal) + variable sensory; usually good prognosis; (b) **Brown-Sequard syndrome** — cord hemisection (penetrating, lateral disc, tumor) → **ipsilateral motor** (corticospinal) + ipsilateral proprioception/vibration (DCML) + **contralateral pain/temperature** (spinothalamic crossed) — best prognosis of incomplete; (c) **Anterior cord syndrome** — anterior 2/3 cord (vascular — anterior spinal artery, hyperflexion) — bilateral motor + bilateral pain/temperature loss + preserved proprioception/vibration (DCML — posterior); poor prognosis; (d) **Posterior cord syndrome** — rare, dorsal column injury (vitamin B12, syphilis, MS) — loss of proprioception + vibration + fine touch, preserved motor + pain/temp; (e) **Conus medullaris syndrome** (T12-L1 level) — mixed UMN + LMN, perianal/saddle anesthesia, bladder/bowel dysfunction, variable LE weakness; (f) **Cauda equina syndrome** — below L2 — pure LMN (peripheral nerve), saddle anesthesia, bladder/bowel — surgical emergency; (4) **ASIA assessment** — standardized neurologic exam for SCI

---

Spinal cord tracts: lateral corticospinal (descending motor — ipsilateral below decussation), DCML (ascending — fine touch/vibration/proprio — ipsilateral until medulla, then contralateral perception), spinothalamic (pain/temperature — crosses immediately, contralateral perception). Incomplete SCI syndromes: central (UE > LE, elderly hyperextension), Brown-Sequard (hemisection — best prognosis), anterior (motor + pain — worst), posterior cord, conus medullaris, cauda equina (surgical). ASIA assessment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Spinal cord anatomy + tracts** — สำคัญสำหรับ neurologic exam + SCI assessment

อธิบาย spinal cord tracts (ascending + descending) + lateralization + clinical correlations (incomplete SCI syndromes)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Synovium lines articular cartilage"},{"label":"B","text":"Synovial Joint Anatomy + Synovial Fluid"},{"label":"C","text":"Cartilage has rich blood supply via synovium"},{"label":"D","text":"Synovial fluid does not participate in cartilage nutrition"},{"label":"E","text":"Septic arthritis has WBC < 200"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Synovial Joint Anatomy + Synovial Fluid: (1) **Synovial joint components**: (a) **articular cartilage** — hyaline cartilage covering bony ends (avascular, aneural, alymphatic; type II collagen + proteoglycans); (b) **subchondral bone** — provides nutrition + support; (c) **joint capsule** — fibrous outer + synovial inner; (d) **synovium (synovial membrane)** — lines joint capsule (NOT cartilage), composed of: (i) synoviocytes type A (macrophage-like — phagocytosis) + type B (fibroblast-like — produce hyaluronic acid + lubricin); (e) **synovial fluid** — viscous filtrate of plasma + locally produced HA + lubricin; (f) **ligaments** (extrinsic + intrinsic — intra-capsular vs extra-capsular); (g) **tendons** crossing joint; (h) **menisci/labra/discs** (in specific joints — knee, shoulder, hip, TMJ); (i) **bursae** — reduce friction; (j) **neurovascular supply** — vascular ring (capsule + synovium — NOT cartilage), sensory innervation (Hilton''s law — innervated by nerves crossing joint); (2) **Synovial fluid functions**: lubrication (boundary by lubricin + hydrodynamic by HA), nutrition (delivers nutrients to cartilage via diffusion + cyclic loading), shock absorption, clearance of waste products; (3) **Joint nutrition** — "sponge effect" — cyclic loading + unloading drives fluid in + out of cartilage matrix → delivers nutrients (glucose, O2) + removes waste; immobilization → impaired cartilage nutrition → degeneration; (4) **Synovial fluid analysis** — diagnostic for joint pathology: (a) **normal** — clear, viscous ("string sign"), WBC < 200/μL (< 25% PMN), normal glucose, no crystals, sterile; (b) **non-inflammatory (OA, trauma)** — straw-colored, viscous, WBC 200-2,000 (< 25% PMN), no crystals; (c) **inflammatory (RA, SLE, gout, pseudogout)** — yellow-cloudy, less viscous, WBC 2,000-50,000 (often > 50% PMN), crystals positive for gout/pseudogout, sterile; (d) **septic** — purulent, opaque, low viscosity, **WBC > 50,000 (often > 75% PMN)** (> 100,000 highly suggestive but not absolute), low glucose (consumed by bacteria), Gram stain + culture positive, may have crystals (concurrent); (e) **hemorrhagic (fracture, hemophilia, PVNS, anticoagulant, tumor)** — bloody; (f) **crystals**: monosodium urate (gout — negatively birefringent, needle-shaped), CPPD (pseudogout — positively birefringent, rhomboid), hydroxyapatite (Milwaukee shoulder), cholesterol; (5) **Aspiration technique** — sterile technique, identify landmarks, avoid neurovascular structures; (6) **clinical caveat** — synovial fluid analysis not perfect — concurrent infection + crystal disease possible; always Gram stain + culture if any suspicion of infection

---

Synovial joint: cartilage + subchondral bone + capsule + synovium (type A + B synoviocytes) + synovial fluid (HA + lubricin) + ligaments + tendons + menisci + bursae. Functions: lubrication, cartilage nutrition ("sponge effect" — cyclic loading), shock absorption. Synovial fluid analysis: normal (<200) → non-inflammatory OA (<2K) → inflammatory (2K-50K) → SEPTIC (>50K, often >75% PMN). Crystals (gout negative birefringent needles, CPPD positive rhomboid). Always Gram + culture if infection suspected.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = '**Basic Science**

**Synovial joint anatomy + physiology** + synovial fluid analysis (foundation for joint pathology including arthritis, infection, crystal disease)

อธิบาย synovial joint structure + synovial fluid normal vs pathologic analysis';

commit;
