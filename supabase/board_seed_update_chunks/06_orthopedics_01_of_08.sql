-- ===============================================================
-- UPDATE chunk 1/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Non-operative + bedrest 6 weeks"},{"label":"B","text":"Displaced Intracapsular Femoral Neck Fracture (Garden III-IV) in elderly"},{"label":"C","text":"Bracing only"},{"label":"D","text":"Amputation"},{"label":"E","text":"Discharge home with NSAIDs"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Displaced Intracapsular Femoral Neck Fracture (Garden III-IV) in elderly: high risk avascular necrosis (AVN) + nonunion (intracapsular blood supply tenuous) — surgical management within 24-48 hours (Cochrane evidence — earlier surgery lower mortality): hemiarthroplasty (if low demand, > 80, comorbidity) or total hip arthroplasty (THA — if active independent ambulator, < 75-80, better functional outcome long-term — HEALTH trial NEJM 2019); avoid internal fixation in elderly with displaced fracture (high AVN/nonunion); pre-op: optimize comorbidities, manage delirium (CAM), DVT prophylaxis, pain control (multimodal — avoid opioid-only, regional block — fascia iliaca compartment block), nutrition, geriatric consult; multidisciplinary care (ortho-geriatric co-management — Cochrane evidence reduces mortality + LOS); post-op: early mobilization, rehabilitation, fall prevention, osteoporosis screening + treatment (DEXA, bisphosphonate, vit D)

---

Hip fracture in elderly: mortality 20-30% first year. Intracapsular displaced (Garden III-IV) — arthroplasty preferred over fixation due to high AVN risk. THA vs hemi: THA for active independent < 75-80; hemi for low-demand elderly. Early surgery < 48h reduces mortality (NICE, AAOS). Ortho-geriatric co-management improves outcomes. Multidisciplinary care + secondary prevention (osteoporosis Rx, fall prevention) essential.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 78 ปี underlying HT, mild dementia ตกจากบันได 3 ขั้น มาห้องฉุกเฉินด้วยปวด left hip + ไม่สามารถ weight bear ได้

V/S: BP 138/82, HR 96, RR 18, Temp 36.8°C
PE: shortening + external rotation ของ left leg, tender at left hip, no neurovascular deficit

X-ray hip: displaced intracapsular femoral neck fracture left + Garden III';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast immobilization"},{"label":"B","text":"antegrade reamed intramedullary nailing (IMN)"},{"label":"C","text":"Conservative + bedrest"},{"label":"D","text":"Amputation"},{"label":"E","text":"Manipulation in ED"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Closed Femoral Shaft Fracture in young adult: (1) Initial: ATLS protocol, IV access × 2, fluid resuscitation (femoral fracture loses 1-1.5 L blood), pain control, traction splint (Hare/Sager) for transport + pain; (2) Definitive: **antegrade reamed intramedullary nailing (IMN)** within 24-48 hours — standard of care for closed femoral shaft (early stabilization reduces ARDS, fat embolism, length of stay); (3) Damage control orthopedics — external fixation if polytrauma + hemodynamic instability + delayed definitive within days; (4) Antibiotic prophylaxis (cefazolin pre-op); (5) Compartment syndrome screening (rare in thigh but possible); (6) Tetanus update if needed; (7) VTE prophylaxis (mechanical immediate + chemical when bleeding controlled); (8) Post-op: early mobilization with weight bearing as tolerated typically with locked IMN, PT, follow-up X-rays for healing; (9) Complications: malunion, nonunion, infection, knee stiffness, AVN (rare); (10) Return to function 4-6 months for athletic activity

---

Femoral shaft fracture in young adult: IMN is gold standard (closed, locked, reamed). Early stabilization < 24-48h reduces pulmonary complications (ARDS, fat embolism). Damage control orthopedics for polytrauma. Blood loss substantial. Multidisciplinary trauma care. Modern IMN: > 95% union, early weight-bearing, return to function 4-6 months.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 25 ปี ขับมอเตอร์ไซค์ชน ถูกรถยนต์ชนเข้ามาห้องฉุกเฉิน ปวดต้นขาขวาอย่างรุนแรง

V/S: BP 96/64, HR 122, RR 22, SpO2 96%
PE: right thigh swollen, tender, deformed, shortened
Palpable distal pulses, no open wound, no neurological deficit
Length discrepancy 4 cm

X-ray: closed midshaft femoral fracture, displaced, comminuted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast + observation"},{"label":"B","text":"Acute Compartment Syndrome (ACS)"},{"label":"C","text":"Diuretic + observation"},{"label":"D","text":"Amputation immediately"},{"label":"E","text":"Discharge with NSAIDs"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Compartment Syndrome (ACS) — clinical diagnosis + supportive measurement (5 P''s: Pain out of proportion + Pallor + Paresthesia + Paralysis + Pulselessness; pulselessness late finding): emergent fasciotomy (within 6 hours from onset of symptoms — irreversible muscle necrosis after 6-8 hours): (1) Remove constrictive bandage/cast immediately; (2) Limb at heart level (not elevated — reduces perfusion pressure); (3) IV fluid + maintain MAP; (4) Pain control; (5) **Emergent fasciotomy** — 4-compartment fasciotomy leg (anterior, lateral, deep posterior, superficial posterior) through 2 incisions (medial + lateral) — should not delay for confirmatory measurements if clinical signs; (6) Leave wounds open with VAC dressing — secondary closure or skin grafting 5-7 days later; (7) Treat underlying fracture (IMN tibial); (8) Monitor for rhabdomyolysis (CK, myoglobinuria) — IV fluid + bicarbonate + mannitol if needed, AKI risk; (9) Tetanus prophylaxis; (10) Long-term: contracture (Volkmann''s), nerve injury, chronic pain follow-up; (11) Multidisciplinary: ortho, vascular, plastic, ICU

---

Acute Compartment Syndrome (ACS): elevated pressure within osseofascial compartment → ischemia + necrosis. Most commonly leg (tibia fracture #1 cause). Clinical diagnosis. Pain out of proportion + passive stretch pain = early classic signs. Pulses preserved in many — pulselessness late. Compartment pressure > 30 mmHg or ΔP < 30 mmHg (DBP - compartment) = surgical. Emergent fasciotomy within 6h — irreversible after 6-8h. Don''t delay for confirmation if clinical. Complications: Volkmann''s contracture, nerve injury, rhabdo + AKI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 35 ปี construction worker ตกบันได 3 เมตร ลงพื้นขาขวาก่อน มาห้องฉุกเฉินปวดมาก ขาขวาบวม + เริ่มชาปลายเท้า

V/S: BP 138/82, HR 102, RR 20
PE: right calf tense + extremely painful especially passive stretch + paresthesia distal + pulses distal palpable but diminished
No open wound

X-ray: closed tibial shaft fracture displaced midshaft
Intramuscular pressure right anterior compartment: 48 mmHg (normal < 30, perfusion pressure = DBP - compartment pressure = 82-48 = 34 — borderline)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bilateral total knee replacement immediately"},{"label":"B","text":"Bilateral Knee Osteoarthritis (KL Grade III) — stepwise conservative first then surgical"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Stem cell therapy first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral Knee Osteoarthritis (KL Grade III) — stepwise conservative first then surgical: (1) **Non-pharmacologic (foundation)**: weight loss 5-10% (significantly reduces pain — every 1 lb lost = 4 lb less force on knee per step); exercise (low-impact aerobic + strengthening — quadriceps emphasis); physiotherapy; assistive devices (cane on contralateral side); knee bracing for selected; (2) **Pharmacologic stepwise**: topical NSAIDs first-line for knee; oral acetaminophen limited efficacy (recent evidence); oral NSAIDs (caution GI, renal, CV, elderly); duloxetine for chronic pain (FDA approved); avoid opioids long-term (OARSI/ACR strong against); intra-articular corticosteroid injection (short-term — 6-12 wk relief, no more than 3-4/year per joint); intra-articular hyaluronic acid (controversial benefit); platelet-rich plasma (PRP) — emerging evidence; (3) **Glucosamine + chondroitin**: mixed evidence; (4) **Avoid**: tramadol routinely (recent evidence — Solomon JAMA 2019 increased mortality vs NSAIDs); oral corticosteroid long-term; (5) **Surgical**: total knee arthroplasty (TKA) when conservative measures fail + significant functional limitation + appropriate BMI (some centers BMI > 40 require weight loss first); high tibial osteotomy for selected unicompartmental varus + young; unicompartmental knee arthroplasty (UKA) selected; arthroscopy NOT effective for OA without mechanical symptoms (USPSTF + OARSI strong against); (6) Multidisciplinary care; (7) Long-term: 90% TKA survival 15-20 years modern

---

Knee OA management: stepwise conservative → surgical. Weight loss + exercise foundation. Pharmacologic: topical NSAIDs first; oral NSAIDs with caution; duloxetine; intra-articular steroid short-term; avoid long-term opioids + tramadol. Arthroscopy NOT effective for pure OA (without mechanical symptoms — meniscal flap). TKA when conservative fail + significant impairment + appropriate BMI. UKA selective. Modern TKA 90% 15-20 yr survival. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 65 ปี ปวดเข่าทั้งสองข้าง 5 ปี ค่อย ๆ แย่ลง ปวดมากขึ้นเมื่อเดิน ขึ้นบันได พักดีขึ้น ตื่นเช้าฝืดน้อยกว่า 30 นาที

BMI 32 (obese)
V/S: ปกติ
PE: bilateral varus deformity, crepitation, decreased ROM, no warmth + no effusion

Lab: ESR + CRP ปกติ, RF negative, Anti-CCP negative
X-ray bilateral knees: joint space narrowing medial > lateral, osteophytes, subchondral sclerosis, no erosion — Kellgren-Lawrence grade III';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAIDs + observation"},{"label":"B","text":"Septic Arthritis (synovial WBC > 50,000 + PMN + gram-positive cocci"},{"label":"C","text":"Steroid injection"},{"label":"D","text":"Discharge with oral antibiotic"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic Arthritis (synovial WBC > 50,000 + PMN + gram-positive cocci — likely S. aureus including possible MRSA): (1) Joint aspiration (already done — diagnostic + therapeutic decompression); (2) IV broad-spectrum antibiotic empirical within hour — vancomycin (MRSA coverage) + cefazolin (or ceftriaxone — MSSA/streptococci/gram-negative coverage); modify per culture + sensitivities; (3) **Joint drainage** — emergent: arthroscopic vs open arthrotomy + irrigation + debridement; serial aspiration alternative in some (less effective for thick + organized pus); (4) Repeat drainage as needed; (5) Antibiotic duration: 2-6 weeks IV typically (2-4 weeks for native joint S. aureus, longer for resistant or complications); (6) Treat predisposing factors (DM control); (7) Differential workup: tuberculous, gonococcal (sexually active), Lyme, atypical; (8) Other infection screening (endocarditis with S. aureus — echocardiogram); (9) Rehabilitation post-treatment: PT, return to ROM + strength; (10) Long-term: joint damage common — secondary OA; (11) Multidisciplinary: orthopedics + infectious disease + rheumatology

---

Septic arthritis: medical + surgical emergency. Risk factors: DM, immunocompromise, RA, IV drugs, prosthetic joint, recent procedure. S. aureus most common. Joint WBC > 50,000 + > 75% PMN suggestive; > 100,000 likely. Diagnosis: aspiration before antibiotic. Empirical: vancomycin + ceftriaxone/cefazolin. Drainage: arthroscopic vs open — emergent. Antibiotic 2-6 weeks. Rule out endocarditis (S. aureus — echo). Joint damage common — secondary OA. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี underlying DM type 2 มาด้วยอาการปวด + บวม + แดง + ร้อนข้อเข่าซ้าย × 3 วัน ไม่เคยมีอาการเช่นนี้มาก่อน + ไข้ต่ำ 38.2°C

V/S: BP 132/84, HR 102, RR 18, Temp 38.2°C
PE: left knee — erythema, warmth, effusion + tense + extreme tenderness ROM limited

Lab: WBC 14,500 (PMN 86%), CRP 156, ESR 88, glucose 184
Joint aspiration:
- WBC 65,000 (PMN 92%) — very high
- No crystals on polarized light
- Gram stain: gram-positive cocci in clusters
- Culture pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + weight loss"},{"label":"B","text":"non-weight-bearing immediately"},{"label":"C","text":"Cast traction"},{"label":"D","text":"Total hip arthroplasty in child"},{"label":"E","text":"NSAIDs + observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Slipped Capital Femoral Epiphysis (SCFE) — pediatric ortho emergency: (1) Made child **non-weight-bearing immediately** (any weight bearing may worsen slip + AVN risk); (2) Admit; (3) Emergent **operative stabilization within 24-48 hours** — percutaneous in situ fixation with single cannulated screw across physis (stops further slip + promotes physeal closure); (4) Severity classification: stable (can ambulate, low AVN risk 0-10%) vs unstable (cannot ambulate, high AVN risk 20-50%); (5) Bilateral risk — contralateral hip 20-40% within 18 months — prophylactic fixation considered in young + endocrinopathy + obese; (6) **Screen for endocrinopathy** in atypical age + bilateral + severe: hypothyroid, GH excess/deficiency, renal osteodystrophy, hypogonadism; (7) Avoid forceful reduction (increases AVN risk); (8) Post-op: progressive weight-bearing as tolerated; (9) Long-term follow-up: AVN, chondrolysis, FAI (femoroacetabular impingement), OA in adulthood; (10) Counseling — limit activities until physeal closure; weight management; (11) Multidisciplinary: pediatric ortho, endocrinology if indicated, PT

---

SCFE: slip of capital femoral epiphysis through physis. Adolescent (10-16), obese, more in boys + Black. Knee or groin pain + limp. Atypical presentation (knee pain) common. Diagnosis: X-ray AP + frog-leg. Treatment: non-weight-bearing + in situ percutaneous fixation. Avoid forceful reduction (AVN risk). Unstable SCFE high AVN risk (20-50%). Endocrine screening. Bilateral common. Long-term FAI + early OA.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 13 ปี อ้วน BMI 28 มาด้วยอาการปวด left hip + ขาเดิน limp 2 สัปดาห์ — มีอาการ groin pain + radiates to medial thigh + knee (referred pain)

ไม่มีบาดเจ็บที่ชัดเจน
V/S: ปกติ
PE: left limb shortening 1cm, externally rotated, decreased internal rotation + obligatory external rotation when flexed (Drehmann sign), pain on hip motion

X-ray hip frog-leg + AP: posterior + medial displacement of femoral epiphysis on left + widening of physis ("ice cream slipping off cone")';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast without reduction"},{"label":"B","text":"Colles'' Fracture (distal radius dorsal angulation — classic fragility fracture in elderly)"},{"label":"C","text":"Amputation"},{"label":"D","text":"ORIF in all elderly"},{"label":"E","text":"Discharge without follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Colles'' Fracture (distal radius dorsal angulation — classic fragility fracture in elderly): (1) **Closed reduction + cast immobilization** under hematoma block or conscious sedation — reduce + cast in slight flexion + ulnar deviation × 6 weeks; (2) Post-reduction X-ray confirm acceptable alignment (radial inclination, height, volar tilt); (3) **Operative fixation** indications: intra-articular displaced, comminuted, unstable, loss of reduction in cast, polytrauma, open fracture — ORIF with volar locking plate (most common modern), external fixation, K-wires; (4) **Fragility fracture = osteoporosis** — comprehensive workup + treatment: bone density (DXA — done), labs (Ca, vitamin D, PTH, TSH, others if indicated), fall risk assessment + prevention, **start anti-osteoporosis Rx** — bisphosphonate (alendronate, zoledronate IV — preferred in non-compliance or GI issues), denosumab, anabolic (teriparatide, romosozumab) for very high risk, calcium + vitamin D, weight-bearing exercise; (5) Pain management: multimodal, acetaminophen first; (6) Hand therapy + early ROM; (7) Follow-up X-rays weekly initially; (8) Long-term: stiffness common, CRPS rare; (9) **Fall prevention** essential — CDC STEADI; secondary fracture prevention crucial (1 fragility fracture → high risk subsequent)

---

Colles'' fracture: distal radius dorsal displacement — classic fragility fracture (FOOSH — fall on outstretched hand). Closed reduction + cast for most; ORIF for unstable/intra-articular/comminuted (volar locking plate modern). Critical: identify as fragility fracture → osteoporosis workup + treatment + fall prevention (50% reduction in subsequent fractures with treatment). Secondary fracture prevention essential. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 70 ปี ตกเก้าอี้ปวดข้อมือซ้าย + บวม + ทำงานบ้านไม่ได้ มา ED 2 ชั่วโมงก่อน

V/S: ปกติ
PE: left wrist swelling + deformity "dinner fork" appearance + tender, decreased ROM, distal pulse palpable, no neurovascular deficit

X-ray: distal radius fracture with dorsal angulation + dorsal displacement + minimally comminuted — Colles'' fracture
DXA score: T-score -2.8 (osteoporosis)';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAIDs + outpatient follow-up"},{"label":"B","text":"Cauda Equina Syndrome (CES) — surgical emergency (delayed surgery → permanent neurologic deficit)"},{"label":"C","text":"Acupuncture only"},{"label":"D","text":"Bed rest 6 weeks"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cauda Equina Syndrome (CES) — surgical emergency (delayed surgery → permanent neurologic deficit): (1) **Emergent surgical decompression** within 24-48 hours from onset of symptoms (some advocate within 48-72h for chance of recovery — controversial but earlier better); (2) Pre-op: urgent neurosurgery consult, Foley catheter, IV steroid (controversial — dexamethasone often given), pain control; (3) Surgery: laminectomy + discectomy (open or microdiscectomy) + decompress neural elements; (4) Post-op: monitor neurologic recovery + bladder/bowel function; (5) Recovery: varies — bladder/bowel may not fully recover even with timely surgery; sexual dysfunction common; (6) Multidisciplinary: spine surgery, urology, neurology, rehabilitation, mental health; (7) **Red flags** for CES + back pain (must screen all patients): - new urinary retention/incontinence; - bowel incontinence; - saddle anesthesia; - bilateral leg weakness/sensory loss; - decreased anal sphincter tone; (8) Counseling family: rehab + recovery realistic expectations; (9) Long-term: assistive devices, support, mental health, sexual + bladder/bowel rehabilitation; (10) Prevent: avoid heavy lifting, proper biomechanics, core strengthening

---

Cauda Equina Syndrome: surgical emergency. Red flags = saddle anesthesia, urinary retention/incontinence, bowel incontinence, decreased anal sphincter tone, bilateral leg weakness. Emergent MRI + surgical decompression within 24-48h. Delayed surgery = permanent deficit. Bladder/bowel may not fully recover. Multidisciplinary recovery. Red flags must be screened in any back pain.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 32 ปี + back pain + bilateral leg numbness + urinary retention 24 ชั่วโมง + bowel incontinence × 12 ชม recently

ไม่มี trauma
History: chronic back pain × 5 years on NSAIDs intermittently, gym + lifting weight 3 วันก่อน

V/S: BP 132/82, HR 88
PE: tender lumbar + diminished sensation perianal area (saddle anesthesia) + decreased anal sphincter tone
+ bilateral leg weakness 4/5 + reduced ankle reflex bilateral
Bladder palpable suprapubic (urinary retention)

MRI lumbar: large central disc herniation L4-L5 + L5-S1 + compression cauda equina + mass effect';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until 1 year for evaluation"},{"label":"B","text":"< 6 months + reducible"},{"label":"C","text":"Tight swaddling + no intervention"},{"label":"D","text":"Total hip replacement"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Developmental Dysplasia of the Hip (DDH) — risk factors present (female + breech + family history + first-born): (1) Newborn screening: Ortolani (reducible dislocation — clunk on abduction) + Barlow (provocative — dislocates on adduction) + Galeazzi (knee height asymmetry); (2) Imaging: ultrasound for < 4 mo (femoral head ossifies after — alpha + beta angles); X-ray after 4-6 mo (ossification adequate); (3) Treatment by age + severity: - **< 6 months + reducible**: Pavlik harness (abduction + flexion brace) × 6-12 weeks; success > 90% if started early; - **6 months - 18 months + Pavlik failure or older child**: closed reduction under anesthesia + spica cast (with arthrogram + adductor tenotomy if needed); - **> 18 months or failed closed**: open reduction + capsular tightening + femoral or pelvic osteotomy; (4) Follow-up with US until adequate, then X-ray surveillance until skeletally mature; (5) Pavlik complications: AVN, femoral nerve palsy, brachial plexus injury — proper monitoring; (6) Long-term: untreated DDH → early OA + need THA in young adult; (7) Multidisciplinary: pediatric ortho, peds primary care; (8) Family education + counseling regarding ongoing care + activity precautions; (9) Genetic counseling — family screening (siblings 5% risk)

---

DDH: spectrum from dysplasia to dislocation. Risk factors: female (4-6:1), breech, first-born, family history, oligohydramnios. Screen at birth + 2 wk + 2-4 mo + 6-9 mo + walking. US first-line < 4 mo; X-ray after. Treatment age-dependent: Pavlik harness < 6 mo (success > 90%); closed reduction + spica 6-18 mo; open reduction + osteotomy > 18 mo. Untreated → early OA + THA in young adult. Tight swaddling discouraged — promotes DDH.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ทารกแรกเกิดเพศหญิง GA 39 wk normal delivery หลังคลอด pediatrician ตรวจพบ asymmetric thigh creases + Galeazzi sign positive + Ortolani positive (clunk on abduction)

Family history: aunt มี DDH ตอนเด็ก
First-born child, breech presentation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bed rest 6 months"},{"label":"B","text":"Arthroscopic rotator cuff repair (RCR)"},{"label":"C","text":"Shoulder fusion"},{"label":"D","text":"Amputation"},{"label":"E","text":"Stem cell injection alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Large Rotator Cuff Tear with Fatty Infiltration: (1) Pain management initially: NSAIDs, ice, activity modification; (2) Physical therapy 6-12 weeks emphasis on scapular stabilization + remaining cuff strengthening + ROM — even prior to surgery; (3) Imaging confirms diagnosis + extent of tear, fatty infiltration (Goutallier classification — higher grade = worse repair outcome); (4) **Operative management** options depending on tear, age, function, demands: - **Arthroscopic rotator cuff repair (RCR)** — preferred in younger active with reparable tears, low fatty infiltration; - **Open or mini-open repair** — large tears, revision surgery; - **Reverse total shoulder arthroplasty (RTSA)** — irreparable massive tear + cuff arthropathy + elderly with limited function, especially > 70 yo; - **Superior capsular reconstruction or tendon transfer** — selected massive irreparable tears in younger patients (e.g., latissimus transfer); (5) Pre-op: optimize comorbidities, smoking cessation (poor healing), DM control; (6) Post-op: sling 4-6 weeks, then gradual PT — passive ROM → active assisted → active → strengthening; full return to activity 6-9 months; (7) Outcomes: tear size + chronicity + fatty infiltration affect prognosis; (8) Non-operative management acceptable for selected (low demand, comorbidity, willing to accept functional limitation, prefer non-surgical); (9) Multidisciplinary: ortho/sports medicine, PT, pain management

---

Rotator cuff tears common with age. Classification: partial vs full-thickness; size (small < 1 cm, medium 1-3, large 3-5, massive > 5). Fatty infiltration (Goutallier 0-4) prognostic. Treatment: conservative trial (PT, NSAIDs, injection) for many; surgical repair for active failed conservative or large tears in young; RTSA for massive irreparable + arthropathy in elderly. Smoking cessation, DM control improve healing. Long rehab.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 60 ปี ปวด + อ่อนแรง shoulder ขวา + ไม่สามารถยกแขนได้ × 3 เดือน ก่อนหน้านี้เป็น nat้ในการเล่นกอล์ฟ ไม่มีบาดเจ็บที่ชัดเจน

V/S: ปกติ
PE: limited active abduction + forward flexion right shoulder, near normal passive ROM, painful arc 60-120°, positive Hawkins-Kennedy + Neer impingement signs, positive empty can test (supraspinatus weakness), positive drop arm sign

MRI shoulder: full-thickness rotator cuff tear (supraspinatus + infraspinatus + partial subscapularis) — large tear 4 cm + fatty infiltration moderate (Goutallier 2)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery + plate fixation"},{"label":"B","text":"Pediatric Both-Bone Forearm Fracture"},{"label":"C","text":"Long arm cast without reduction"},{"label":"D","text":"Amputation"},{"label":"E","text":"External fixation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Both-Bone Forearm Fracture: closed reduction + cast (long arm cast above elbow × 6 weeks) under conscious sedation or general anesthesia in ED/OR; pediatric bones remodel well — accept up to 10-15° angulation depending on age; > 8 years old accept less angulation (10°); operative fixation indications: failed closed reduction, open fracture, multiple trauma, irreducible, vascular injury, Monteggia or Galeazzi variants, age > 12; flexible intramedullary nailing (TENs) for older children; serial follow-up X-rays weekly initially for displacement; safety + child protection considerations; Salter-Harris classification for growth plate injuries (I-V) and growth disturbance follow-up if involved; remove cast + return to activity gradually 8-10 weeks

---

Pediatric forearm fractures common. Closed reduction + cast for most (remodeling potential). Older children accept less angulation. Surgical fixation for failed closed, open, polytrauma, irreducible. Flexible IM nailing (TENs) for older children. Monteggia (radial head dislocation + ulna fracture) + Galeazzi (DRUJ disruption + radius fracture) — surgical. Follow-up for displacement, malunion, growth disturbance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 6 ปี ตกจาก monkey bar ปวด left forearm + บวม + ไม่ใช้แขน 1 ชั่วโมงก่อน

V/S: ปกติ
PE: left forearm midshaft swelling + tenderness + deformity, no neurovascular deficit, no open wound

X-ray: both bone forearm fracture (radius + ulna) midshaft, displaced + angulated 25°';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative immobilization in equinus only"},{"label":"B","text":"Achilles Tendon Rupture (athletic male 30-50 yo)"},{"label":"C","text":"Bedrest only"},{"label":"D","text":"Amputation"},{"label":"E","text":"Continue activities"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Achilles Tendon Rupture (athletic male 30-50 yo): (1) **Initial**: ice, elevation, splint in equinus (plantar flexion), non-weight-bearing; (2) **Treatment options**: Surgical repair (open or percutaneous) vs functional rehabilitation with cast/boot — both acceptable, individualized choice; (3) **Operative**: end-to-end repair, augmentation if needed, percutaneous less invasive — slightly lower re-rupture risk, faster return to sports, but surgical complications (infection, nerve injury, scar); (4) **Non-operative functional rehabilitation**: equinus cast/boot × 2-4 weeks → progressive weight-bearing + ROM with heel lifts → PT × 12 weeks — modern functional rehab nearly equivalent re-rupture rate to surgery (Soroceanu CORR 2012 meta-analysis); (5) **Decision factors**: age, activity level, comorbidities (DM, smoking — surgical complications), preference; (6) Post-treatment: PT progressive strengthening, gradual return to running 4-6 mo, sports 6-9 mo; (7) Outcomes: 90%+ functional recovery either approach; (8) Counsel: chronic rupture (> 6 wk) more complex; tendinopathy prevention; eccentric loading; (9) Multidisciplinary: ortho/sports medicine, PT

---

Achilles rupture: athletic 30-50 yo ("weekend warrior"), often "feel kick" sensation. Diagnosis clinical (Thompson + palpable defect + unable plantarflex). Treatment: operative vs functional rehabilitation — modern evidence similar outcomes, re-rupture rates close. Decision individualized (activity, age, comorbidity, preference). Long rehabilitation. Return to sport 6-9 mo.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 38 ปี เล่นบาสเกตบอลกระโดดลงพื้น รู้สึกถูกเตะที่น่อง ปวดร้อน + ไม่สามารถยกเท้าได้ (toe walking impossible) + เดินกะเผลก

V/S: ปกติ
PE: palpable defect 3-5 cm above heel, Thompson test positive (squeeze calf — no plantar flexion of foot), unable to plantarflex against resistance

US: complete Achilles tendon rupture';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term opioid"},{"label":"B","text":"Carpal Tunnel Syndrome (CTS) — median nerve compression at wrist"},{"label":"C","text":"Cast 6 months"},{"label":"D","text":"Amputation"},{"label":"E","text":"Discharge without treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Carpal Tunnel Syndrome (CTS) — median nerve compression at wrist: (1) **Conservative first-line**: nocturnal wrist splint (neutral position — most effective single intervention), ergonomic modifications, activity modification, NSAIDs for pain, glucocorticoid injection (short-term improvement, lasts 1-3 mo); (2) Lifestyle: weight management, glycemic control if DM (predisposing); (3) Workplace ergonomics; (4) **Conservative usually trial 6-12 weeks**; (5) **Surgical decompression** indications: severe symptoms, thenar atrophy, motor deficit, failed conservative, severe EMG findings, persistent symptoms despite treatment; open vs endoscopic carpal tunnel release — equivalent outcomes, endoscopic faster return to work but slightly higher nerve injury risk; (6) Post-op: ROM exercises, gradual return to activity 4-6 weeks, full recovery 3-6 months; (7) Outcomes: 90% improvement with surgery; (8) Differential: cervical radiculopathy (C6-C7), thoracic outlet syndrome, pronator teres syndrome; (9) Bilateral common — assess both hands; (10) Pregnancy CTS often resolves postpartum

---

CTS = most common upper extremity entrapment neuropathy. Median nerve compression at wrist (transverse carpal ligament). Risk: female, age, pregnancy, DM, hypothyroid, RA, obesity, repetitive use. Diagnosis: clinical + EMG/NCV. Conservative trial (splint, injection, NSAIDs) 6-12 wk. Surgical decompression for severe + failed conservative. Open vs endoscopic similar outcomes. > 90% improvement post-op.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 48 ปี office worker (typing) มาด้วยอาการ ชา + เจ็บ + อ่อนแรงนิ้วโป้ง + ชี้ + กลาง + ครึ่งนิ้วนาง × 6 เดือน อาการแย่ตอนกลางคืน ทำให้ตื่นนอน

V/S: ปกติ
PE: thenar atrophy mild, decreased sensation median nerve distribution, positive Tinel sign + Phalen test + Durkan test

EMG/NCV: median nerve conduction velocity slowed at wrist, no other neuropathy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency surgery immediately"},{"label":"B","text":"Lumbar Radiculopathy (S1) from disc herniation — most resolve with conservative care 6-12 weeks"},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Spinal fusion immediately"},{"label":"E","text":"Bed rest 6 months"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lumbar Radiculopathy (S1) from disc herniation — most resolve with conservative care 6-12 weeks: (1) **Conservative first-line** (90% improve without surgery within 3 mo): pain control (NSAIDs first-line; acetaminophen; muscle relaxant short-term; avoid opioids long-term — recent evidence + addiction risk; neuropathic pain agents — gabapentin/pregabalin if needed); short-term rest then activity as tolerated; physical therapy (core strengthening, neural mobilization, exercises); back school; CBT for chronic pain; (2) **Epidural steroid injection**: short-term symptom relief (8-12 weeks); useful if surgery is being considered or for severe pain not improving; (3) **Surgical indications**: cauda equina syndrome (emergent), progressive neuro deficit, intractable pain failing 6-12 weeks conservative, significant motor deficit; **microdiscectomy** standard procedure; (4) **Surgery outcomes**: rapid pain relief but long-term similar to conservative at 1-2 yr (SPORT trial Weinstein NEJM 2008); patient selection important; (5) Multidisciplinary: spine surgery, PM&R, PT, pain management; (6) Lifestyle: weight, smoking cessation, ergonomics, exercise; (7) Mental health screening — chronic back pain + depression high overlap; (8) Avoid prolonged bed rest

---

Lumbar radiculopathy: 90% resolve with conservative care. SPORT trial: surgery vs conservative — surgery faster relief, similar long-term outcomes. Conservative: NSAIDs, PT, epidural steroid, education. Surgery for cauda equina (emergent), progressive deficit, intractable pain > 6-12 wk conservative. Avoid bed rest. Multidisciplinary. Long-term opioids harmful. Address psychosocial factors.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 42 ปี delivery driver ปวดหลัง + ปวดร้าวลงขาขวาตามแนวด้าน lateral ของขาถึงข้อเท้า + ปลายเท้า — เป็นมา 4 สัปดาห์ ปวดมากเวลานั่งนาน + ไอ + จาม + ก้มตัว

ไม่มี bowel/bladder dysfunction, no saddle anesthesia
V/S: ปกติ
PE: positive straight leg raise right at 40° (sciatic stretch sign), decreased sensation lateral foot + decreased ankle dorsiflexion + decreased ankle reflex

MRI lumbar: L5-S1 paracentral disc herniation right + impinging on right S1 nerve root, no canal stenosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Acute Hematogenous Osteomyelitis (pediatric — common metaphysis of long bones, S. aureus most common)"},{"label":"C","text":"Aspirin only"},{"label":"D","text":"Amputation"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hematogenous Osteomyelitis (pediatric — common metaphysis of long bones, S. aureus most common): (1) **Admit + IV broad-spectrum antibiotic empirical** within hour — vancomycin (MRSA coverage especially community-acquired) + cefazolin (MSSA + streptococci); modify per culture sensitivity; (2) **Source control**: surgical drainage + debridement if subperiosteal abscess, joint involvement, or no response to antibiotic 48-72h; image-guided drainage in some; (3) **Duration**: 4-6 weeks total — modern practice: 2 wk IV then transition to oral if responding well + acceptable bioavailability + reliable family (NICHE consensus); avoid PICC line outpatient for full 6 wk anymore — switch to oral; (4) Monitor response: CRP (best — rapidly responsive), fever, clinical, repeat imaging if not improving; (5) Surgical consultation: orthopedic + ID; (6) Pain management; (7) Complications: chronic osteomyelitis, growth disturbance (if physis involved), abscess, septic arthritis spread, pathologic fracture; (8) Differential: Brodie abscess (subacute), tumor (osteosarcoma — similar to osteo but X-ray, biopsy); (9) Multidisciplinary: ped ID, orthopedics, family support, PT; (10) Long-term follow-up for growth + function

---

Acute hematogenous osteomyelitis pediatric: S. aureus most common (MRSA increasing — community-acquired, can have invasive features). Metaphysis of long bones (femur, tibia). MRI most sensitive for early diagnosis. Treatment: IV antibiotics, surgical drainage if abscess. Duration 4-6 weeks (modern: IV 2 wk then oral). Complications: growth disturbance, chronic osteo. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กชายอายุ 8 ปี ตัวเหลือง + ปวดขา + ไข้สูง 39.4°C × 5 วัน + ไม่อยากเดิน + บวม + ปวดมากที่ข้อเข่าซ้าย

V/S: HR 132, BP 96/64, Temp 39.4°C
PE: left knee — focally tender lower femur metaphysis, warm, swelling, joint ROM preserved (joint not yet involved)

Lab: WBC 18,500 (PMN 88%), CRP 245, ESR 95, Blood culture: Staphylococcus aureus growing
MRI knee: marrow edema + cortical bone destruction + periosteal elevation at distal femur metaphysis — acute osteomyelitis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest"},{"label":"B","text":"ACL reconstruction"},{"label":"C","text":"Cast 6 months"},{"label":"D","text":"Total knee replacement"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ACL Tear + Multi-ligament Injury (young active athlete): (1) Initial: RICE (rest, ice, compression, elevation), pain control, knee immobilizer or hinged brace; PT pre-operatively ("prehab") improves outcomes; (2) **ACL reconstruction** indications: young, active, return to sports + cutting/pivoting activities + instability; technique: arthroscopic ACL reconstruction with autograft (bone-patellar tendon-bone, hamstring tendon, quadriceps tendon) or allograft; concurrent meniscal repair (preserve when possible) or partial meniscectomy; MCL grade I-II often heal with bracing (delayed ACL); grade III MCL with concurrent ACL — may consider acute repair vs staged; (3) **Non-operative** acceptable for sedentary, low demand, partial tears, willing to modify activity ("copers"); (4) **Timing**: delay 2-4 weeks until swelling resolved, ROM regained — reduces arthrofibrosis risk (Shelbourne accelerated rehab); some advocate earlier; (5) **Post-op**: prolonged rehab 6-9 months for return to sport; ACL-RSI score for psychological readiness; (6) **Outcomes**: 85-90% return to sport, 65% to pre-injury level; (7) Long-term: increased OA risk (50% at 10-15 yr), prevention strategies (neuromuscular training programs — FIFA 11+); (8) Multidisciplinary: sports medicine, PT, athletic trainer, psychologist; (9) Female athletes higher ACL injury risk (anatomy, hormonal, biomechanics) — prevention programs especially important

---

ACL tear: common sports injury (pivoting, cutting). MOI: non-contact deceleration with rotation. Diagnosis: clinical (Lachman, pivot shift) + MRI. Treatment: surgical reconstruction for young active; non-operative for selected. Concurrent injuries common ("unhappy triad" — ACL + MCL + medial meniscus). Long rehab (6-9 mo) to return to sport. Long-term OA risk despite surgery. Female athletes higher risk. Prevention programs (neuromuscular training).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 22 ปี soccer player เปลี่ยนทิศทางขณะวิ่ง รู้สึก pop ในเข่า ขวา + ปวด + บวมทันที + ไม่สามารถเดินได้

MRI knee: complete tear of ACL + partial tear MCL + medial meniscus tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Traumatic Spinal Cord Injury (SCI)"},{"label":"C","text":"Conservative only"},{"label":"D","text":"Amputation"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Traumatic Spinal Cord Injury (SCI): (1) **ATLS protocol**: airway + breathing (intubation if high cervical), circulation (neurogenic shock — bradycardia + hypotension — IV fluid + atropine for symptomatic bradycardia + vasopressor — norepinephrine preferred); (2) **Immobilization**: spine board + cervical collar + log roll; (3) **MAP > 85** for 7 days improves outcomes (controversial — increasing evidence); (4) **Methylprednisolone (NASCIS protocol)** — controversial, no longer routine due to mixed evidence + risks (infection, GI bleed, mortality) — some still use within 8h for selected cases; (5) **Surgical decompression** + stabilization within 24 hours (some advocate < 12-24 — STASCIS study showed neurologic improvement); pedicle screws + rods, anterior decompression + corpectomy + cage + plate, combined; (6) **Multidisciplinary acute care**: spine surgery, ICU/trauma, anesthesia, physiatry, ortho, neurosurgery; (7) **Acute complications**: respiratory failure (high SCI), autonomic dysreflexia, neurogenic shock, DVT/PE (high risk — prophylactic anticoagulation when bleeding controlled), pressure injuries, urinary retention/dysfunction, bowel dysfunction, ileus; (8) **Inpatient rehab** transfer when stable — comprehensive rehabilitation; (9) **Long-term**: lifelong issues — pressure injuries, UTIs, autonomic dysfunction, sexual dysfunction, psychological adjustment, mental health, vocational, social; (10) **Multidisciplinary lifelong care**: PM&R, urology, GI, psychology, social work, vocational; (11) Family support + grief counseling; (12) Modern: emerging therapies — stem cells, exoskeletons, functional electrical stimulation, neuromodulation — still experimental for cure but improve function

---

Acute SCI: trauma emergency + lifelong condition. Neurogenic shock (bradycardia + hypotension) vs spinal shock (transient flaccidity + areflexia). MAP > 85 × 7 days. High-dose steroid controversial — no longer routine. Surgical decompression + stabilization < 24h. Complications: respiratory, DVT/PE, autonomic dysreflexia, UTI. Lifelong multidisciplinary care. Modern: technology + emerging therapies. Family-centered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี post-MVC (motorcycle) — high-energy trauma, complete loss of motor + sensory below T6 level immediately

V/S: BP 88/52, HR 56 (bradycardia), Temp 36.4°C
Gen: alert, oriented, paralyzed below mid-thoracic level
Neuro: complete loss motor + sensory below T6, areflexic, priapism (suggests SCI)

CT spine: T6 burst fracture + retropulsion of fragment into canal + spinal cord compression
MRI: cord edema + transection at T6 likely

ASIA grade A complete spinal cord injury';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient + oral antibiotic"},{"label":"B","text":"Open Fracture Gustilo Type IIIA"},{"label":"C","text":"Bedrest only"},{"label":"D","text":"Discharge with cast"},{"label":"E","text":"Aspirin"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Open Fracture Gustilo Type IIIA: (1) **Initial**: ATLS, control hemorrhage, immobilize, hemodynamic resuscitation; (2) **Early IV broad-spectrum antibiotic within 1 hour** (BAPRAS evidence — earlier = less infection): cefazolin (gram-positive coverage) + gentamicin (gram-negative for III) or vancomycin + ceftazidime/piperacillin-tazobactam; add metronidazole/penicillin for farmyard contamination (clostridia); duration 24-72h post-closure typically; (3) **Tetanus prophylaxis** — vaccine if > 5 yr since booster, immunoglobulin if not vaccinated; (4) **Irrigation + debridement** in OR within 6 hours (the "6-hour rule" debated but principle of early debridement valid); (5) **Bone stabilization**: temporary external fixation if extensive soft tissue, then definitive IMN once soft tissue stabilized; some immediate IMN for selected; (6) **Soft tissue coverage**: assess + plan with plastic surgery — primary closure if possible, delayed primary, skin graft, local or free flap (rotational, free) — within 7 days reduces infection; (7) **Multidisciplinary**: orthopedic trauma + plastic surgery + ID; (8) Complications: infection (osteomyelitis), nonunion, malunion, amputation, compartment syndrome; (9) Long-term rehab + function follow-up; (10) Gustilo grading guides management: I (clean < 1cm wound), II (1-10 cm moderate damage), IIIA (> 10 cm but coverable), IIIB (extensive + needs flap), IIIC (vascular injury — limb-threatening, often amputation)

---

Open fractures: emergency. Gustilo classification (I, II, IIIA-C). Critical interventions: hemorrhage control, IMMEDIATE IV antibiotic (within 1h — most important factor), tetanus prophylaxis, urgent I&D in OR ("6-hour rule" — earlier the better), bone stabilization, soft tissue coverage. Multidisciplinary trauma + plastic + ID. Complications high — infection, osteomyelitis, nonunion. Type IIIC limb-threatening.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 42 ปี ตกจากบันได 3 เมตร — open tibial fracture + bone protrusion + bleeding + contamination

Gustilo classification: Type IIIA (extensive soft tissue + > 10cm wound + adequate coverage)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore — likely growing pain"},{"label":"B","text":"Osteosarcoma (most common primary malignant bone tumor in young — peak 15-25 yo, around knee — distal femur, proximal tibia)"},{"label":"C","text":"Aspirin alone"},{"label":"D","text":"Total joint replacement only"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteosarcoma (most common primary malignant bone tumor in young — peak 15-25 yo, around knee — distal femur, proximal tibia): (1) **Multidisciplinary**: orthopedic oncology + medical oncology + radiation oncology + pediatric/adolescent if applicable + pathology + radiology + plastic surgery + rehab + psychology + social work; (2) **Staging workup**: CT chest (lung metastases most common), bone scan, MRI of primary, biopsy (open or core through planned surgical approach); (3) **Neoadjuvant chemotherapy** 8-12 weeks: MAP regimen (methotrexate + doxorubicin + cisplatin) — standard for high-grade osteo; (4) **Limb-sparing surgery** (vs amputation) — wide local excision with negative margins; reconstruction (mega-prosthesis, allograft, rotationplasty in selected, expandable prosthesis in growing children); (5) **Adjuvant chemotherapy** post-op for 6-12 months total; (6) **Histologic response** assessed post-neoadjuvant — > 90% necrosis = good response prognosticator; (7) **Surveillance**: CT chest q3 mo × 2 yr, q6 mo × 2 yr, annual after — pulmonary metastases most common site relapse; (8) **Long-term**: secondary malignancy from chemo, cardiotoxicity, fertility, growth, function, psychological, return to school/society; (9) **Survivorship care plan**; (10) **Outcomes**: localized 60-70% 5-yr survival; metastatic at presentation 20-30%; modern improving with neoadjuvant + adjuvant chemo + limb-sparing — major advance over historical amputation alone; (11) **Genetic counseling**: rare familial syndromes (Li-Fraumeni — TP53, hereditary retinoblastoma, Rothmund-Thomson)

---

Osteosarcoma: most common primary malignant bone tumor in young (15-25 yo peak), around knee (distal femur, proximal tibia). Pain + mass + X-ray (sunburst, Codman triangle). MRI + biopsy + staging (CT chest for mets). Neoadjuvant chemo (MAP) + limb-sparing surgery + adjuvant chemo. 5-yr survival 60-70% localized, 20-30% metastatic. Genetic counseling for syndromes. Modern multidisciplinary care + chemo enables limb salvage in most.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'วัยรุ่นชายอายุ 16 ปี ปวด distal femur ขวา 6 สัปดาห์ + บวมเริ่ม + ก้อนคลำได้ + ไม่ตอบสนองต่อ NSAIDs + น้ำหนักลดเล็กน้อย

Family: no cancer history known
V/S: ปกติ
PE: tender + warm + firm mass distal femur lateral side

X-ray: lytic + sclerotic lesion distal femur metaphysis with Codman triangle + sunburst periosteal reaction
MRI: 8 cm soft tissue mass + cortical destruction + extends into surrounding tissue
CT chest: no metastases visible
Biopsy (open): osteosarcoma, high grade, malignant osteoid produced by tumor cells';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bed rest"},{"label":"B","text":"Ankylosing Spondylitis / Axial Spondyloarthritis (axSpA) — chronic inflammatory disease of axial skeleton, HLA-B27 strongly associated"},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Amputation"},{"label":"E","text":"Refuse treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ankylosing Spondylitis / Axial Spondyloarthritis (axSpA) — chronic inflammatory disease of axial skeleton, HLA-B27 strongly associated: (1) **Lifestyle**: regular exercise (cornerstone — improves stiffness, mobility, pain), postural exercises, swimming, no smoking, weight management; (2) Physical therapy + spine flexibility/strengthening; (3) **Pharmacologic stepwise**: - NSAIDs first-line (continuous use — disease-modifying effect potential per some evidence) — slow disease progression, reduce inflammation; long-term + GI/renal/CV monitoring; - **TNF-alpha inhibitors** (etanercept, adalimumab, infliximab, golimumab, certolizumab) for NSAID failures or severe — major advance — improve symptoms + slow radiographic progression (uncertain); - **IL-17 inhibitors** (secukinumab, ixekizumab) alternative biologic — effective even after TNFi failure; - **JAK inhibitors** (tofacitinib, upadacitinib) newer; - Sulfasalazine/methotrexate — only for peripheral arthritis (not axial); - Glucocorticoid — local injection only (no systemic); (4) **Extra-articular**: uveitis (30% — most common, urgent ophthalmology), IBD (overlap), psoriasis, aortic regurgitation, restrictive lung disease; (5) Surveillance: cardiovascular risk (increased), osteoporosis (DEXA, treat), depression; (6) Surgical: joint replacement for hip involvement; spinal correction surgery rare for severe deformity; (7) Counseling: family screening if symptoms (HLA-B27 60-90% in axSpA but only 5% of B27 develop disease); pregnancy + lactation considerations (most biologics compatible); (8) Multidisciplinary: rheumatology, PT, ophthalmology, dermatology, GI, cardiology, mental health

---

Ankylosing Spondylitis / axSpA: chronic inflammatory axial skeleton, HLA-B27 association. Inflammatory back pain (insidious, > 3 mo, morning stiffness, improves with exercise, worsens with rest). Sacroiliitis on imaging (X-ray or MRI). Treatment: lifestyle + exercise foundation + NSAIDs + biologic (TNFi, IL-17i, JAKi) for severe. Extra-articular: uveitis (most common), IBD, psoriasis. CV + osteoporosis surveillance. Multidisciplinary lifelong care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 30 ปี HLA-B27 ตรวจสุขภาพประจำปี — ปวดหลังเรื้อรัง > 6 เดือน, ปวดมากตอนเช้า + improvement กับการเคลื่อนไหว, ปวดน้อยลงกับ exercise, ปวดมากตอนค่ำ

Family: father มี chronic back issues
V/S: ปกติ
PE: limited spine flexion + Schober test reduced, no joint inflammation, normal hip + knee ROM

Lab: ESR 45, CRP 22 (elevated), HLA-B27 positive
X-ray pelvis: bilateral sacroiliitis grade 2 (sclerosis + erosions both sides)
MRI SI joints: bone marrow edema both sides — active inflammation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bone is static tissue"},{"label":"B","text":"Bone remodeling cycle"},{"label":"C","text":"Only one cell type involved"},{"label":"D","text":"No regulation"},{"label":"E","text":"No hormonal effects"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Biology + Remodeling: (1) Two cell types: **osteoblasts** (bone formation — secrete osteoid + matrix) and **osteoclasts** (bone resorption — derived from monocyte lineage, multinucleated); (2) **Bone remodeling cycle**: activation → resorption (osteoclasts dig pit) → reversal → formation (osteoblasts fill with new bone) → mineralization; continuous balance maintains bone mass; takes 4-6 months per cycle; (3) **Regulation**: parathyroid hormone (intermittent — anabolic; sustained — catabolic), vitamin D (Ca absorption + bone), calcitonin (inhibit osteoclast — minor), estrogen (inhibit osteoclast — explains postmenopausal bone loss), glucocorticoids (catabolic), thyroid (high turnover), mechanical loading (Wolff''s law — bone adapts to load); (4) **Bone composition**: cortical (dense, peripheral, 80% of skeleton) + trabecular/cancellous (sponge-like, internal, higher turnover, sensitive to estrogen — vertebrae); (5) **Pathophysiology of osteoporosis**: imbalance — resorption > formation; postmenopausal — estrogen deficiency → ↑ RANK-L → ↑ osteoclast; senile — both decrease but resorption > formation; secondary — glucocorticoids, hyperparathyroidism, hyperthyroidism, malabsorption, hypogonadism; (6) **Diagnosis**: DEXA T-score (-2.5 or lower = osteoporosis; -1.0 to -2.5 osteopenia; > -1.0 normal); fragility fracture defines clinical osteoporosis regardless of DXA; (7) **Treatment**: bisphosphonates (anti-resorptive — alendronate, risedronate, zoledronate IV), denosumab (anti-RANK-L mAb), teriparatide (recombinant PTH 1-34 anabolic), abaloparatide, romosozumab (anti-sclerostin — anabolic), SERMs (raloxifene), Ca + vitamin D, exercise; (8) **Calcium + vitamin D** foundation: Ca 1000-1200 mg, vit D 800-2000 IU daily

---

Bone is dynamic — continuous remodeling. Osteoblasts + osteoclasts balance determines bone mass. Hormonal + mechanical regulation. Postmenopausal + senile + secondary osteoporosis mechanisms. Diagnosis: DEXA T-score + fragility fracture. Treatment: anti-resorptive + anabolic agents + Ca/vit D + exercise. Modern: biologics (denosumab, romosozumab) + sequential therapy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Resident ถามอาจารย์เรื่อง bone biology — bone remodeling + osteoporosis pathophysiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"No engineering principles needed"},{"label":"B","text":"Orthopedic Biomechanics + Implant Design"},{"label":"C","text":"All materials same"},{"label":"D","text":"No mechanical principles"},{"label":"E","text":"Random design"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Orthopedic Biomechanics + Implant Design: (1) **Joint forces**: hip + knee experience 3-5× body weight during walking, up to 8× during running; this drives loosening, wear of implants; (2) **Wolff''s Law**: bone remodels in response to load — relevant for stress shielding around implants; (3) **Implant materials**: titanium (Ti6Al4V — strong, biocompatible, lower modulus to reduce stress shielding), cobalt-chrome (wear surface), zirconia ceramic (low wear, brittle), UHMWPE polyethylene (bearing surface), highly crosslinked polyethylene (reduced wear); (4) **Failure modes**: aseptic loosening (most common reason for revision — particle disease, polyethylene wear → osteolysis), infection (1-2% — devastating), instability, fracture, wear; (5) **Total Hip Arthroplasty (THA) design**: femoral stem (cemented vs cementless — initial fixation by interference fit then bone ingrowth), femoral head (28-36 mm — larger reduces dislocation but increases wear with metal-on-metal), acetabular cup (titanium shell + polyethylene liner — standard), fixation (cemented for elderly, cementless for younger); (6) **Bearing surfaces**: metal-on-polyethylene (standard), ceramic-on-polyethylene (lower wear), ceramic-on-ceramic (lowest wear but squeak + fracture risk), metal-on-metal (mostly abandoned — pseudotumor + ion levels); (7) **Surgical principles**: anatomic positioning, soft tissue balance, ROM, stability, leg length; (8) **Recovery**: early mobilization, PT, weight bearing as tolerated typically; (9) **Survivorship**: > 90% 15-20 years modern THA/TKA

---

Biomechanics + implant design = critical for orthopedic outcomes. Joint forces drive wear. Material selection + design + fixation choices. Failure modes: aseptic loosening (most), infection, instability. Bearing surfaces evolved over decades. Modern implants > 90% 15-20 yr survival. Stress shielding around implants. Wolff''s law relevant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Resident ถามเรื่อง biomechanics — joint forces + implant design considerations';

update public.mcq_questions
set choices = '[{"label":"A","text":"No biology relevant"},{"label":"B","text":"Muscle + Tendon Biology"},{"label":"C","text":"All muscle same"},{"label":"D","text":"No healing process"},{"label":"E","text":"Cardiac and skeletal same"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Muscle + Tendon Biology: (1) **Muscle types**: skeletal (voluntary, striated), cardiac, smooth; **fiber types** (skeletal): Type I slow-twitch oxidative (endurance, fatigue-resistant, mitochondria-rich, red), Type IIa fast-twitch oxidative-glycolytic (mixed), Type IIb fast-twitch glycolytic (power, fatigue-easily); training-dependent shift; (2) **Muscle contraction**: actin-myosin sliding filament theory — ATP-dependent — neural input → ACh release → Ca release from SR → cross-bridge cycling; (3) **Muscle injury**: strain (overstretch — pain, bleeding) → hematoma → inflammatory phase → satellite cell activation → regeneration with new myofibers; scar tissue if extensive; (4) **Healing phases**: hemostasis + inflammation → cell proliferation → matrix remodeling; (5) **Tendon biology**: type I collagen primarily; lower vascularity → slower healing; tendon healing phases similar — inflammation, proliferation, remodeling; (6) **Risk factors** for tendinopathy: overuse, age, diabetes, fluoroquinolones (CI), genetics; (7) **Treatment principles**: relative rest (not absolute — controlled loading promotes healing), eccentric loading (Alfredson protocol for Achilles), NSAIDs short-term, modalities, PT; surgical repair for complete rupture; (8) **Sports medicine principles**: prehabilitation, biomechanics, return to sport criteria, prevention programs (FIFA 11+, ACL injury prevention); (9) **PRP (platelet-rich plasma)**: emerging therapy for tendinopathy + selected injuries — mixed evidence; (10) **Eccentric exercise**: gold standard for chronic tendinopathy (Alfredson protocol)

---

Muscle + tendon biology critical for sports medicine + orthopedic care. Fiber types + training. Injury + healing phases. Tendinopathy chronic — eccentric loading evidence-based (Alfredson). Fluoroquinolones cause tendon rupture (avoid). Modern treatments: controlled loading, PT, biologics (PRP). Prevention programs reduce injury (FIFA 11+).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'อาจารย์อธิบาย physiology — muscle + tendon biology + healing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid only"},{"label":"B","text":"Multimodal Pain Management — opioid-sparing approach"},{"label":"C","text":"No pain management"},{"label":"D","text":"Long-term opioid for all"},{"label":"E","text":"Bedrest only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimodal Pain Management — opioid-sparing approach: (1) **Multimodal**: target multiple pain pathways with lower doses of each agent — better analgesia + fewer side effects; (2) **Pre-op**: acetaminophen 1000 mg PO + gabapentin 300-600 mg PO + celecoxib 400 mg PO (selective COX-2 inhibitor — less GI/bleeding than non-selective); (3) **Intra-op**: regional anesthesia preferred (spinal, epidural, peripheral nerve block — femoral, adductor canal, popliteal); local infiltration analgesia (LIA — surgeon-administered bupivacaine/liposomal bupivacaine + adjuncts); (4) **Post-op**: scheduled acetaminophen + NSAID (caution renal, GI, bleeding) + low-dose opioid PRN; gabapentin/pregabalin if neuropathic component; ice + elevation; (5) **Avoid**: routine long-term opioids (epidemic + addiction), opioid only as primary analgesic, ketorolac > 5 days; (6) **Special populations**: elderly (reduce doses, avoid certain — Beers Criteria), CKD (NSAIDs avoid, acetaminophen OK), opioid-tolerant (multimodal + higher doses), addiction (consult addiction medicine); (7) **PCA (Patient-Controlled Analgesia)**: useful for major surgery; (8) **Continuous regional catheter**: extended block, less opioid, faster recovery; (9) **Discharge counseling**: limited opioid prescriptions, monitor for misuse, dispose unused, non-opioid alternatives; (10) **Pain assessment**: regular, multimodal scales (NRS, FLACC for pediatric, behavioral); (11) **Acute pain transition to chronic**: identify + intervene early, multidisciplinary pain management

---

Multimodal pain management = standard. Opioid-sparing approach reduces side effects + addiction risk. Pre-op + intra-op + post-op planning. Regional anesthesia + LIA + scheduled non-opioids + minimal opioid PRN. Outcomes: better pain control + faster recovery + less opioid use. Special populations require adjustment. Address opioid epidemic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Resident ถามเรื่อง pharmacology — pain management in orthopedic surgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"Traditional restrictive recovery"},{"label":"B","text":"ERAS for Total Joint Arthroplasty (THA/TKA)"},{"label":"C","text":"Bed rest 1 week"},{"label":"D","text":"Opioid-only analgesia"},{"label":"E","text":"No PT"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS for Total Joint Arthroplasty (THA/TKA): (1) Pre-op: patient education + expectation setting ("joint class"), home environment prep; medical optimization (HbA1c < 7%, smoking cessation, weight loss if BMI > 40, dental clearance, anemia treated, MRSA screening + decolonization); (2) Pre-admission carb loading 2h pre-op, no prolonged fasting; (3) Antibiotic prophylaxis within 60 min (cefazolin); (4) Spinal anesthesia preferred + IV sedation; (5) Multimodal analgesia (acetaminophen + NSAID + gabapentinoid + regional block + LIA + minimal opioid); (6) Tranexamic acid (TXA) IV or topical reduces transfusion; (7) Normothermia + restrictive fluids + no Foley routine; (8) Same-day mobilization + early discharge; many centers now outpatient TJA (TKA/THA discharge same day or next morning for selected); (9) Post-op: oral diet + PT immediately; multimodal pain; VTE prophylaxis (aspirin for low-risk, DOAC or LMWH for higher-risk per modern evidence Anderson AAOS); (10) Discharge: home > rehab facility (cost + outcomes), home PT, multidisciplinary follow-up; (11) Outcomes: shorter LOS, lower complications, higher satisfaction, similar safety; (12) Quality metrics: LOS, readmission, complications, PROMs (KOOS, HOOS, EQ-5D); (13) Multidisciplinary: surgeon, anesthesia, nursing, PT/OT, social work, case management

---

ERAS for TJA — major paradigm shift. Pre-op optimization + same-day mobilization + multimodal analgesia + TXA + outpatient TJA programs. Reduces LOS, complications, opioid use. Patient education key. Multidisciplinary. Outcomes equivalent or better than traditional. PROMs (patient-reported outcome measures) track success. Modern: many TJA outpatient.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'Hospital wants to reduce surgical complications + improve total joint arthroplasty outcomes — implement ERAS protocol';

commit;
