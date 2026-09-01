-- ===============================================================
-- UPDATE chunk 4/8: orthopedics (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast extension 12 weeks no surgery"},{"label":"B","text":"ACL reconstruction"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Knee arthrodesis"},{"label":"E","text":"Total knee arthroplasty"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete ACL Tear + Medial Meniscus Tear in Young Active Athlete: (1) initial management: RICE + brace + crutches WBAT + early ROM + quadriceps activation; (2) prehabilitation ("prehab") — restore ROM + reduce effusion + quadriceps strength before surgery (better outcomes); (3) **ACL reconstruction** indicated: young active patient + functional instability + desires return to pivoting sports; (4) graft choice: **bone-patellar tendon-bone (BPTB) autograft** — classic, robust, faster return to sport in some studies; **hamstring autograft** (semitendinosus + gracilis) — less anterior knee pain, donor site morbidity; **quadriceps tendon autograft** — increasingly popular, less morbidity; allograft — less ideal in young due to higher re-rupture rate; (5) **timing**: typically delay until effusion resolves + ROM restored + quadriceps activation (often 3-6 weeks post-injury) — STABILITY trial supports lateral extra-articular tenodesis (LET) augmentation in young athletes to reduce re-rupture; (6) concomitant meniscal repair preferred over meniscectomy when possible (peripheral 1/3, vertical, longitudinal, < 4 weeks old); (7) postop rehab 6-9 months progressive — RTS criteria (LSI > 90%, hop tests, psychological readiness — ACL-RSI scale); (8) ACL prevention programs (FIFA 11+) for return; (9) **non-operative** acceptable for: low-demand sedentary, copers (~ 30% functional without ACL), older patients without instability symptoms

---

Acute ACL tear: hemarthrosis within hours. Lachman most sensitive. MRI + bone bruise + meniscus assessment. ACL reconstruction for young active. Graft choice (BPTB, hamstring, quadriceps autograft). Concomitant meniscal repair preferred. LET augmentation reduces re-rupture (STABILITY trial). 6-9 month rehab. Non-op for low-demand copers.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 25 ปี เล่นฟุตบอลถูกบิดเข่าซ้าย ได้ยิน pop + เข่าบวม immediate (within 4 hours) ขยับเข่าได้แต่รู้สึก unstable

PE: large effusion + decreased ROM, positive Lachman test (most sensitive ACL), positive anterior drawer + pivot shift (under anesthesia), no varus/valgus instability, intact PCL, distal NV intact

MRI knee: complete ACL tear midsubstance + bone bruise lateral femoral condyle + posterolateral tibial plateau (kissing contusion pattern of ACL), medial meniscus tear posterior horn flap — Type IIIA, lateral meniscus intact, PCL intact';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home no surgery"},{"label":"B","text":"Bucket-Handle Meniscal Tear with Mechanical Locking (Young Athlete) — Reparable Tear"},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Total knee arthroplasty"},{"label":"E","text":"Cast in flexion 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bucket-Handle Meniscal Tear with Mechanical Locking (Young Athlete) — Reparable Tear: (1) **urgent arthroscopic meniscal repair** indicated เพราะ: young patient + reparable tear (peripheral red-red or red-white zone, vertical longitudinal, < 4 weeks old, > 1 cm length) + meniscus preservation prevents PTOA; (2) **meniscal repair technique** (inside-out, outside-in, all-inside devices — modern FasT-Fix, Smith & Nephew TRUE-SPAN) — depending on tear location; (3) protected weight-bearing 4-6 weeks + ROM restriction (0-90° initially); (4) avoid deep flexion + pivoting × 4-6 months; (5) return to sport 4-6 months; (6) **meniscectomy** (partial or subtotal) only for unsalvageable tears (white-white zone, complex/degenerative, irreparable) — recognized as risk for early OA; minimize bone resection; (7) augmentation: fibrin clot, PRP, marrow venting to enhance healing for poorly vascularized; (8) MRI follow up if symptoms recur; (9) **always check ACL** — frequently associated (40-50%) — bucket handle medial often with ACL tear, may need concomitant ACL reconstruction (concomitant repair + ACLR superior outcomes); (10) chronic locked knee — irreducible, requires surgery

---

Bucket-handle meniscal tear: classic mechanical locking. "Double PCL sign" on MRI. Urgent arthroscopic repair (young, reparable). Meniscectomy = early OA → preserve when possible. Augment vascular zone tears. Always assess ACL (often concomitant). Modern all-inside devices. RTS 4-6 months.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 22 ปี นักฟุตบอล บิดเข่าขวา 3 วันก่อน ปวด + เข่าล็อค เหยียดเข่าไม่ได้ (-10° extension block) + เดินกระเผลก

PE: positive McMurray + Thessaly + Apley grind, joint line tenderness medial, fixed flexion deformity 10° (mechanical block), no significant ligamentous instability

MRI knee: bucket-handle tear medial meniscus posterior horn extending into mid-segment with displaced fragment in intercondylar notch ("double PCL sign" — bucket handle fragment appearing as second PCL), normal ACL/PCL/collaterals';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Isolated Complete PCL Tear (Grade III)"},{"label":"C","text":"Cast in flexion 12 weeks"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Total knee arthroplasty"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Complete PCL Tear (Grade III): (1) **non-operative management first-line** for isolated PCL tears เพราะ: better natural history vs ACL, PCL has better intrinsic healing, most patients functional without surgery; (2) **PCL-specific bracing** in extension (jack brace) × 4-6 weeks (resists posterior tibial sag); (3) PT — emphasize **quadriceps strengthening** (quad acts as PCL agonist by preventing posterior tibial translation); avoid open-chain hamstring exercises (antagonist to PCL); (4) progressive return to activity 3-6 months; (5) **PCL reconstruction** indicated for: combined ligamentous injury (most PCL injuries with combined are surgical), persistent symptomatic instability after 6 months conservative, displaced bony avulsion (fix the avulsion fragment); (6) **important to evaluate posterolateral corner (PLC)** in all PCL tears — combined PCL + PLC injury — PLC undertreated leads to PCL graft failure; (7) chronic isolated PCL may develop medial + patellofemoral compartment OA (altered biomechanics) → counsel; (8) reconstruction techniques: tibial inlay vs transtibial ("killer turn"), single vs double bundle, autograft/allograft

---

Isolated PCL tear: non-operative first-line (better natural history than ACL). Brace in extension + quadriceps strengthening. Surgery for combined injuries, displaced bony avulsion, failed conservative. ALWAYS evaluate PLC (PLC injury → PCL graft failure if untreated). Chronic PCL — medial + patellofemoral OA risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 32 ปี รถมอเตอร์ไซค์ชน dashboard กระแทกหน้าแข้ง ปวดเข่าซ้าย + บวมเล็กน้อย

PE: positive posterior drawer (most sensitive PCL), positive posterior sag sign, normal Lachman, no varus/valgus instability, mild effusion, NV intact

MRI knee: complete isolated PCL tear (substance), no ACL or collateral injury, no posterolateral corner injury, no meniscal tear, no posterior tibial bone bruise (suggestive)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent surgery same day"},{"label":"B","text":"Isolated Grade III MCL Tear"},{"label":"C","text":"Cast extension 12 weeks"},{"label":"D","text":"Total knee arthroplasty"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Grade III MCL Tear: (1) **non-operative management gold standard** for isolated MCL — excellent healing potential (extra-articular ligament with good blood supply); (2) hinged knee brace (ROM brace) for 4-6 weeks — allows ROM but protects from valgus stress; full ROM permitted; (3) WBAT immediately; (4) PT — early ROM, progressive quadriceps + hamstring strengthening; (5) RTS 6-12 weeks (Grade III) when full ROM + no pain + valgus stability + strength symmetric; (6) **surgical repair/reconstruction** rarely indicated for isolated MCL — reserved for: (a) chronic symptomatic instability after 3-6 months conservative, (b) tibial-side avulsion (Stener-like lesion — pes anserinus interposition prevents healing), (c) combined ligament injury (ACL + MCL with persistent instability after ACL recon + conservative MCL), (d) bony avulsion; (7) always check **distal MCL tibial-side tear** — may not heal due to pes anserinus interposition + need repair; (8) chronic insufficiency may rarely require reconstruction (semitendinosus autograft, etc.); (9) early activity NOT detrimental

---

Isolated MCL tear: non-operative gold standard (excellent healing). Hinged brace 4-6 weeks + early ROM + WBAT. Surgery rare — reserved for tibial-side avulsion (pes interposition), combined ligament injury, chronic instability. Stener-like lesion (distal MCL) may not heal. Grade III complete tear — still heals well with conservative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 26 ปี เล่นรักบี้ ถูกชนด้านนอกเข่าซ้าย ปวดด้านในเข่า

PE: tender medial joint line + over MCL origin femur, positive valgus stress at 30° flexion with 8 mm opening (vs intact 4 mm contralateral) + endpoint firm, no opening at full extension, normal Lachman, normal posterior drawer, no effusion

MRI knee: complete MCL tear (proximal/femoral attachment) — Grade III, no ACL/PCL/lateral injury, no meniscal tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative bracing only"},{"label":"B","text":"Isolated Posterolateral Corner (PLC) Injury Grade III + Peroneal Nerve Injury — Surgical"},{"label":"C","text":"Total knee arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast in extension 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Posterolateral Corner (PLC) Injury Grade III + Peroneal Nerve Injury — Surgical: (1) **acute primary repair OR reconstruction within 2-3 weeks** preferred over delayed repair (LaPrade) — better outcomes with early intervention while tissue planes identifiable; chronic > 3 weeks → reconstruction; (2) **PLC reconstruction** using anatomic technique — LaPrade anatomic reconstruction (fibular collateral + popliteofibular + popliteus tendon) with semitendinosus/allograft (Achilles, anterior/posterior tibialis); (3) **peroneal nerve** — observe (most neuropraxia recover); neurolysis intraoperatively; if no recovery by 3-6 months, EMG, consider tendon transfer (posterior tibial to dorsiflex) or AFO; (4) **always assess for PCL injury** — combined PCL + PLC very common — undertreated PLC → PCL graft failure; (5) post-op rehab: brace 6 weeks, progressive WB, no isolated hamstring 4 months, RTS 9-12 months; (6) **non-operative** only for grade I-II isolated, no functional instability; (7) chronic untreated PLC → varus thrust gait, medial compartment OA, ACL graft failure; (8) physical exam — dial test + varus stress at 30° + reverse pivot shift sensitive

---

PLC injury: often missed → late instability + ACL graft failure. Acute repair/reconstruction (< 2-3 wk) > delayed. LaPrade anatomic reconstruction standard. Peroneal nerve injury common — observe most. Combined with PCL frequent — undertreated PLC = PCL graft failure. Dial test + varus + reverse pivot shift exam.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 30 ปี รถมอเตอร์ไซค์ชน knee twisting injury 3 สัปดาห์ ปวดด้านนอกเข่าขวา + รู้สึก unstable เมื่อเดิน + foot drop เริ่มมี

PE: positive dial test at 30° (10° increased external rotation tibia vs contralateral but symmetric at 90°), positive reverse pivot shift, varus thrust gait, foot drop right (peroneal nerve injury), positive posterolateral drawer

MRI knee: posterolateral corner (PLC) injury — popliteus + popliteofibular ligament + fibular collateral ligament (LCL) all torn, peroneal nerve edema, isolated PLC, intact ACL/PCL';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lateral release alone first surgery"},{"label":"B","text":"First-Time Lateral Patellar Dislocation in Adolescent + Osteochondral Fracture"},{"label":"C","text":"Total knee arthroplasty"},{"label":"D","text":"Cast extension 12 weeks"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First-Time Lateral Patellar Dislocation in Adolescent + Osteochondral Fracture: (1) **arthroscopy/arthrotomy + osteochondral fragment fixation or removal** if significant loose body (> 5 mm articular surface) — fragment fixation preferred when feasible (bioabsorbable nail, headless screw); (2) **MPFL reconstruction** considered first-time in young patient with: significant anatomic risk factors (trochlear dysplasia, patella alta, increased TT-TG distance > 20 mm, hyperlaxity, genu valgum, increased femoral anteversion); recurrent dislocator (≥ 2 episodes) — definitely; (3) **non-operative** for first-time without osteochondral fracture, without major risk factors: brace + PT (vastus medialis obliquus strengthening, hip abductor strengthening, taping) — recurrence 15-50%; (4) for recurrent dislocators + significant TT-TG > 20 mm → MPFL reconstruction + **tibial tubercle osteotomy** (medialization Fulkerson) ± **trochleoplasty** for severe dysplasia; (5) MPFL reconstruction graft (semitendinosus, gracilis, allograft); (6) avoid lateral release alone (proven ineffective without addressing pathology); (7) pediatric — preserve physis with reconstruction technique modification; (8) early ROM + PT post-op; (9) RTS 6-9 months

---

Patellar dislocation: lateral. MPFL primary restraint medially. First-time: conservative if no osteochondral fracture + few risk factors. MPFL reconstruction for recurrent or significant risk factors. Add TTO (medialization) if TT-TG > 20 mm. Trochleoplasty for severe dysplasia. Lateral release alone — ineffective.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'เด็กหญิงอายุ 15 ปี นักเต้น บิดเข่าซ้าย รู้สึก patella หลุดออก side แล้วเข้าเอง เข่าบวม + ปวด

PE: large effusion, tender medial patella + medial retinaculum (MPFL), positive apprehension test, J-sign on extension, generalized hyperlaxity (Beighton 7/9)

MRI knee: lateral patellar dislocation episode — MPFL tear (femoral attachment), bone bruise medial patella + lateral femoral condyle (kissing contusion), small osteochondral fragment from patella ("flake" sign), trochlear dysplasia (shallow trochlea), patella alta (Insall-Salvati 1.4)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate rTSA for any tear"},{"label":"B","text":"Symptomatic Full-Thickness Rotator Cuff Tear in Active Middle-Aged Laborer"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Steroid injection monthly long-term"},{"label":"E","text":"Total shoulder arthroplasty"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Full-Thickness Rotator Cuff Tear in Active Middle-Aged Laborer: (1) **PT + structured conservative first 3 months** — most patients improve symptoms even without anatomic healing: rotator cuff + scapular stabilizer exercises, posture, NSAIDs, subacromial corticosteroid injection (limited use — > 1 injection may damage cuff); (2) **arthroscopic rotator cuff repair** indicated: failure of conservative + symptomatic + young/active/laborer with reparable tear (< 4 cm, no advanced fatty infiltration Goutallier ≥ 3, no significant arthritis) + tear progression; (3) **acute traumatic tear** — earlier repair (within 3-4 months) better outcomes vs chronic; (4) **double-row vs single-row** — double-row more anatomic + biomechanical, may reduce re-tear especially for larger tears; (5) augmentation: biceps tenodesis if associated biceps pathology; PRP/scaffold limited evidence; (6) **massive irreparable tears** (> 5 cm, retraction to glenoid, Goutallier 3-4, > 65 ปี) options: arthroscopic debridement + biceps tenotomy/tenodesis, **superior capsular reconstruction (SCR)**, tendon transfers (latissimus dorsi, lower trapezius), **reverse total shoulder arthroplasty (rTSA)** for cuff tear arthropathy; (7) post-op: sling 4-6 weeks, no active ROM initially, progressive PT, return to laborer activity 6 months; (8) re-tear rate 20-40%; cuff repair improves pain even with re-tear

---

RC tear: conservative trial first (PT improves many without healing). Surgical repair for failed conservative + reparable + active patient. Acute traumatic — earlier repair better. Massive irreparable: SCR, tendon transfer, rTSA (cuff arthropathy). Goutallier fatty infiltration grade key prognosticator. Re-tear 20-40% but outcomes still improved.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 58 ปี laborer ปวดไหล่ขวา 6 เดือน ปวดมากตอนกลางคืน ยกแขนเหนือศีรษะลำบาก + อ่อนแรง 3 เดือนหลัง trauma เล็กน้อย

PE: positive Neer + Hawkins (impingement), positive empty can test + drop arm test (supraspinatus weakness 3/5), positive external rotation lag sign (infraspinatus), normal subscapularis (negative belly press)

MRI shoulder: full-thickness rotator cuff tear involving supraspinatus + anterior infraspinatus, retraction 3 cm to glenoid (Patte II), mild fatty infiltration Goutallier 2, no significant arthritis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always SLAP repair regardless of age"},{"label":"B","text":"SLAP Tear Type II in Overhead Throwing Athlete"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Cast in adduction 6 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SLAP Tear Type II in Overhead Throwing Athlete: (1) **conservative trial first 3-6 months** — PT essential: posterior capsular stretching (sleeper stretch, cross-body) for GIRD, scapular stabilization, dynamic stability, gradual return-to-throwing program; (2) NSAIDs, activity modification; (3) **surgical indications**: failure of comprehensive conservative + persistent symptoms + desire to return to overhead sport; (4) **surgical options controversial**: (a) **SLAP repair** (suture anchors to labrum) — traditional for type II in young athlete < 35-40 ปี — historic gold standard but high rate of stiffness, persistent pain, failure to return to elite throwing (especially baseball pitchers); (b) **biceps tenodesis** — increasingly preferred in older athletes (> 35-40 ปี) + lower demand patients + revision setting + concurrent biceps pathology — superior outcomes vs SLAP repair in many studies; (c) **biceps tenotomy** — older low-demand; (5) **return to elite pitching after SLAP repair only 50-60%** — counsel realistic expectations; (6) preventive — pitch count, mechanics, kinetic chain; (7) avoid SLAP repair > 40 ปี (better outcomes with tenodesis)

---

SLAP tear: overhead athletes. Conservative first (PT, GIRD correction). Surgery — SLAP repair vs biceps tenodesis. Repair traditional for young athlete; tenodesis increasingly preferred (better outcomes, especially > 35-40 ปี). RTS to elite pitching only 50-60% after repair — counsel. Tenotomy for elderly. O''Brien test sensitive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 28 ปี นักเบสบอลพิทเชอร์ ปวดไหล่ลึก ๆ + ปวดเวลาขว้าง — pain in late cocking + early acceleration

PE: positive O''Brien (active compression test — pain with internal rotation + resisted forward flexion at 90°, relieved with external rotation), positive Speed test, decreased internal rotation (GIRD — glenohumeral internal rotation deficit 25°)

MR arthrogram: type II SLAP lesion (superior labrum from anterior to posterior — biceps anchor detachment), no rotator cuff tear, no Bankart, mild posterior labral fraying';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate arthroscopic decompression"},{"label":"B","text":"Subacromial Impingement Syndrome (Rotator Cuff Tendinopathy + Bursitis) Without Full-Thickness Tear"},{"label":"C","text":"Total shoulder arthroplasty"},{"label":"D","text":"Long-term opioid"},{"label":"E","text":"Bedrest in sling 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Subacromial Impingement Syndrome (Rotator Cuff Tendinopathy + Bursitis) Without Full-Thickness Tear: (1) **conservative management first-line 3-6 months** — overwhelming evidence: (a) **structured PT** — emphasis on **scapular stabilization** (lower trapezius, serratus anterior), **rotator cuff strengthening** (especially posterior cuff — infraspinatus/teres minor), posterior capsule stretching, postural correction; (b) activity modification; (c) NSAIDs short course; (d) **subacromial corticosteroid injection** — short-term pain relief (4-12 weeks), limit to 1-3 injections (cuff damage with repeated); (2) **CSAW + ARC trials (Lancet 2018, BMJ 2019) — subacromial decompression NOT superior to placebo/sham + PT** — major shift away from surgery for impingement without structural pathology; (3) **surgery (arthroscopic subacromial decompression + bursectomy ± acromioplasty)** reserved for: failure of comprehensive 6-12 months conservative + significant structural pathology (large bursal spur, calcific tendinitis); (4) calcific tendinitis specific treatment: lavage + needling, ESWT, surgical excision; (5) cuff tear progression workup if symptoms persist; (6) PT alone effective in 70-80%; (7) reassurance + education on natural history

---

Subacromial impingement: PT + NSAIDs + selective steroid injection first-line. CSAW + ARC trials → arthroscopic decompression NOT superior to placebo/PT alone — major paradigm shift. Surgery reserved for failed extensive conservative + structural pathology. Address scapular stabilization key. Conservative effective 70-80%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 45 ปี ปวดไหล่ขวา 4 เดือน ปวดมากตอนยกแขนเหนือศีรษะ + นอนทับ

PE: positive Neer + Hawkins + Jobe (empty can — weakness due to pain 4/5, no true weakness), painful arc 60-120°, no significant atrophy, no obvious lag signs

X-ray shoulder: mild subacromial spur, no significant glenohumeral arthritis, Bigliani type II acromion
MRI: rotator cuff tendinopathy + subacromial-subdeltoid bursitis, NO full-thickness tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency repair all proximal LHB"},{"label":"B","text":"Proximal Long Head of Biceps (LHB) Tendon Rupture (Most Common)"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Total shoulder arthroplasty"},{"label":"E","text":"Cast in flexion 6 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Proximal Long Head of Biceps (LHB) Tendon Rupture (Most Common): (1) **conservative management** for most patients — proximal LHB rupture has minimal functional consequence: minor loss of forearm supination (10-20%) + elbow flexion (10-15%) strength compensated by short head + brachialis + supinator; cosmetic Popeye deformity may bother some; (2) ice, NSAIDs, gradual return to activity 2-3 weeks; (3) **surgical biceps tenodesis** (suprapectoral or subpectoral, with anchor or interference screw) indicated: (a) young active patients + cosmetic concern + want full strength, (b) athletes/laborers especially with high supination demand (e.g., carpenter, mechanic), (c) concomitant SLAP/labral or rotator cuff pathology requiring surgery; (4) **biceps tenotomy** acceptable simpler alternative — accepts Popeye + minimal strength loss — older low-demand patients; (5) **distal biceps rupture** (at radial tuberosity) — different — typically operative repair in active adults due to 30-50% supination + 30% elbow flexion strength loss + endurance loss — surgical repair indicated for young active patients (Endobutton, suture anchors, bone tunnels); (6) screen rotator cuff pathology (often concomitant in LHB rupture)

---

Proximal LHB biceps rupture: conservative for most (minimal functional loss). Popeye deformity cosmetic. Tenodesis for young/active/cosmetic concerns or concurrent surgery. Tenotomy older alternative. DISTAL biceps rupture (radial tuberosity) — surgical for active patients (significant supination + elbow flexion strength loss). Screen rotator cuff pathology.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี laborer รู้สึก pop ที่ไหล่หน้าซ้ายเวลายกของหนัก + รู้สึกอ่อนแรง forearm flexion เล็กน้อย
ไม่ปวดมาก

PE: Popeye deformity (distal bulge upper arm with elbow flexion — proximal LHB rupture), mild ecchymosis, decreased forearm supination strength + elbow flexion 4+/5 (preserved largely due to brachialis + short head), no weakness elsewhere

US / MRI shoulder: complete long head of biceps (LHB) tendon rupture at proximal level, mild rotator cuff tendinopathy, no full-thickness cuff tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency surgery same week"},{"label":"B","text":"Lateral Epicondylitis (Lateral Epicondylosis / Tennis Elbow) — ECRB Tendinosis"},{"label":"C","text":"Long-term opioid daily"},{"label":"D","text":"Cast forearm 12 weeks"},{"label":"E","text":"Repeated steroid injections monthly long-term"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lateral Epicondylitis (Lateral Epicondylosis / Tennis Elbow) — ECRB Tendinosis: (1) **conservative management first-line 6-12 months** — high spontaneous improvement rate (80-90% at 1-2 years even untreated): (a) activity modification, ergonomic adjustments, counterforce brace (Cho-Pat strap), (b) **PT — eccentric strengthening of wrist extensors** (Tyler twist with FlexBar) — strong evidence, (c) NSAIDs short course, (d) ice; (2) **corticosteroid injection** — short-term relief (< 6 weeks) but **WORSE long-term outcomes** vs wait-and-see (Coombes JAMA 2013 — increased recurrence + chronicity) — minimize use, reserve for severe acute pain; (3) **PRP (platelet-rich plasma) injection** — mixed evidence, may improve long-term outcomes vs steroid; (4) extracorporeal shockwave therapy (ESWT) — moderate evidence; (5) **percutaneous tenotomy** (needle, ultrasonic — TENEX) emerging; (6) **surgical (open or arthroscopic ECRB debridement)** reserved for: failure of 6-12 months comprehensive conservative + significant impact on function (10-15% require surgery); (7) education on natural history — chronic condition with high spontaneous improvement; (8) avoid prolonged steroid + repeated injections

---

Lateral epicondylitis: tendinosis of ECRB (not inflammation). Conservative 6-12 months — high spontaneous resolution. Eccentric exercises (FlexBar) strongest evidence. Steroid injection — short-term relief but worse long-term (Coombes JAMA). PRP mixed. Surgery only for failed comprehensive conservative. Natural history favorable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 45 ปี เล่นเทนนิส + พิมพ์งานเยอะ ปวดด้านนอกข้อศอกขวา 3 เดือน ปวดมากเวลาบีบ + ยกของ

PE: tenderness lateral epicondyle + just distal at ECRB origin, positive Cozen test (resisted wrist extension reproduces pain), positive Mill test, no neurologic deficit

US lateral elbow: thickening + hypoechogenicity ECRB origin + neovascularization — tendinosis, no significant tear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate surgery all partial tears"},{"label":"B","text":"Partial UCL Tear in Overhead Throwing Athlete (Pitcher) — \"T-sign\""},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Cast forearm 12 weeks"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Partial UCL Tear in Overhead Throwing Athlete (Pitcher) — "T-sign": (1) **conservative first** — 3-6 months of comprehensive non-operative trial: rest from throwing 6-12 weeks, NSAIDs, PT — flexor-pronator strengthening + scapular + core, dynamic stabilization, gradual return-to-throwing program; (2) **PRP injection** for partial tears emerging — some evidence supports faster RTS in partial tears especially in non-elite throwers; (3) **surgical reconstruction** — Tommy John surgery / UCL reconstruction — indicated: failure of conservative + elite throwers + wish to return to high-level pitching + full-thickness tear; (4) **UCL reconstruction techniques**: original Jobe technique, **docking technique** (modified, less morbidity, comparable outcomes), figure-of-8, internal brace augmentation (Dugas — UCL repair with internal brace for proximal/distal avulsion-type tears in young athletes — faster RTS 6-9 months vs 12-15 months reconstruction); (5) graft: palmaris longus, gracilis, semitendinosus; (6) **return to pitching 12-18 months** post-reconstruction; (7) ulnar nerve transposition — selective (controversial routine); (8) pre-disposing — workload, pitch count, mechanics — prevention key; (9) RTS rate ~ 80% pitchers

---

UCL tear: pitcher''s elbow. Conservative trial first (rest + PT + PRP). UCL reconstruction (Tommy John) for failed conservative + elite + full-thickness. Docking technique modified Jobe. UCL repair + internal brace (Dugas) — proximal/distal avulsion young — faster RTS. RTS 12-18 months reconstruction. Prevention: pitch count, mechanics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 22 ปี นักเบสบอลพิทเชอร์ ปวด medial elbow + decreased throwing velocity + worse late cocking phase 3 เดือน

PE: tender medial epicondyle + UCL, positive moving valgus stress test, positive milking maneuver, no ulnar nerve symptoms, valgus instability at 30° flexion 4 mm opening vs 2 mm contralateral

MRI elbow: partial-thickness undersurface tear medial UCL (anterior bundle) — "T-sign" on MR arthrogram (contrast extension along undersurface), no full thickness tear, no loose bodies';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgical fixation all metatarsal stress fractures"},{"label":"B","text":"March Fracture (Stress Fracture 2nd Metatarsal) in Military Recruit — Low-Risk Stress Fracture"},{"label":"C","text":"Cast non-weight bearing 12 weeks long-leg"},{"label":"D","text":"Discharge no treatment continue training"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** March Fracture (Stress Fracture 2nd Metatarsal) in Military Recruit — Low-Risk Stress Fracture: (1) **non-operative management** for low-risk metatarsal stress fracture (2nd, 3rd, 4th MT shaft) — heals reliably: rest from impact activity + relative rest (cross-train — swimming, cycling); WBAT in stiff-soled shoe or post-op shoe or short walking boot 4-8 weeks; gradual return to weight-bearing impact 6-8 weeks; gradual return to running 8-12 weeks with progressive program; (2) NSAIDs limited (theoretical concern about bone healing — controversial); (3) ice, edema control; (4) **address underlying risk factors**: training error (rapid increase in volume/intensity > 10% rule), biomechanics (cavus foot, hindfoot varus, leg length discrepancy, gait), nutrition (calorie intake, vitamin D, calcium), Female Athlete Triad/RED-S in females, BMD if recurrent or red flags; (5) gradual return to running program; (6) **high-risk stress fractures** (5th MT base — Jones fracture zone 2, proximal 2nd MT base, navicular, medial femoral neck, anterior tibial diaphysis, talus, patella, sesamoid) — require surgical fixation or strict non-WB casting due to nonunion risk; (7) prevention — graduated training, footwear, biomechanics

---

March fracture: stress fracture metatarsal shaft (2nd-4th) — low risk. Heals with relative rest + protected WB 6-8 weeks + gradual return. Address training error, biomechanics, nutrition, Female Athlete Triad. High-risk stress fractures (5th MT Jones, navicular, femoral neck tension side, anterior tibia) — surgical or strict non-WB casting (nonunion risk).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ทหารใหม่อายุ 20 ปี เริ่มฝึก military training ปวดกลางเท้าซ้าย 3 สัปดาห์ ปวดมากขึ้นขณะวิ่ง พักดีขึ้น ไม่มี trauma

PE: tenderness + mild swelling dorsum foot over 2nd metatarsal shaft, no obvious deformity, no skin lesion, normal NV

X-ray foot: initial — no obvious fracture; repeat 3 weeks later — periosteal new bone + callus formation 2nd metatarsal mid-shaft
MRI foot: bone marrow edema + linear hypointense line 2nd metatarsal shaft — stress fracture';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency surgery same week"},{"label":"B","text":"Chronic Plantar Fasciitis (Plantar Fasciosis)"},{"label":"C","text":"Long-term oral steroid"},{"label":"D","text":"Calcaneal spur excision routinely"},{"label":"E","text":"Cast non-weight bearing 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Plantar Fasciitis (Plantar Fasciosis): (1) **conservative management first-line 6-12 months** — most resolve spontaneously: (a) **stretching** — plantar fascia-specific stretch (Rompe + DiGiovanni — better evidence than gastroc/Achilles alone) + Achilles/calf stretching; (b) **orthoses** — over-the-counter pre-fabricated insoles (no evidence custom superior — UK guidelines); heel cushion; arch support; (c) **night splints** (passive dorsiflexion) — moderate evidence for chronic; (d) NSAIDs short course; (e) activity modification, footwear (supportive); (f) ice massage; (g) PT — eccentric loading, manual therapy; (2) **corticosteroid injection** — short-term relief (4-12 wk) แต่ risks: plantar fascia rupture, fat pad atrophy, increased recurrence — limit to 1-2 injections; (3) **PRP injection** — moderate evidence, fewer complications vs steroid; (4) **ESWT (extracorporeal shockwave therapy)** — moderate evidence, FDA-approved for chronic > 6 months; (5) **percutaneous needle fasciotomy/TENEX** — emerging; (6) **surgical (partial plantar fasciotomy ± gastrocnemius recession)** reserved for: failure of 12 months comprehensive conservative — < 5% require surgery; (7) calcaneal spur is incidental finding (poor correlation with symptoms — do NOT routinely excise); (8) screen for inflammatory arthropathy if bilateral/young/atypical (SpA)

---

Plantar fasciitis: 80-90% resolve conservatively within 12 months. Plantar fascia-specific stretching strongest evidence. Insoles, night splints, NSAIDs adjuncts. Steroid injection short-term — limit (rupture, fat pad atrophy). PRP, ESWT emerging. Surgery rare (failed comprehensive). Calcaneal spur incidental — do NOT excise. Screen SpA if atypical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 48 ปี ครู ปวดส้นเท้าซ้าย 6 เดือน ปวดมากที่สุดเมื่อก้าวแรกตอนเช้า + หลังนั่งนาน ดีขึ้นเมื่อเดินสักพัก

PE: tenderness medial calcaneal tuberosity (plantar fascia origin), positive Windlass test (great toe dorsiflexion reproduces pain), tight Achilles, no swelling, no skin changes

US plantar fascia: thickened plantar fascia 6 mm (normal < 4 mm) + hypoechogenic — plantar fasciitis
X-ray foot: calcaneal spur (incidental — does not correlate with pain)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative bedrest 12 weeks regardless"},{"label":"B","text":"Proximal Hamstring Tendon Avulsion with Significant Retraction in Active Athlete"},{"label":"C","text":"Above-knee amputation"},{"label":"D","text":"Total hip arthroplasty"},{"label":"E","text":"Cast in flexion 12 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Proximal Hamstring Tendon Avulsion with Significant Retraction in Active Athlete: (1) **operative repair indicated** for: (a) complete 3-tendon avulsion (especially with > 2 cm retraction), (b) active patient (athlete) with functional demand, (c) acute injury (< 4-6 weeks ideal — easier dissection + better outcomes); (2) **surgical repair** — open repair via posterior gluteal crease approach, suture anchors to ischial tuberosity, identify + protect sciatic nerve (immediately deep to hamstring origin), restore tendon excursion; (3) post-op: brace in hip extension + knee flexion 6 weeks, gradual ROM, no active hamstring 6-8 weeks, PT, RTS 6-9 months; (4) **non-operative** for: low-grade partial tears (≤ 2 tendons + < 2 cm retraction), elderly/sedentary, late presentation (delayed surgery has worse outcomes — > 4-6 wk retracted): RICE + crutches WBAT + PT — progressive eccentric strengthening + flexibility + neuromuscular control; (5) **chronic proximal hamstring avulsion** (> 4-6 wk) — more difficult surgery: tendon-graft augmentation (allograft, ipsilateral semitendinosus advancement), Achilles allograft reconstruction; outcomes inferior to acute repair; (6) sciatic nerve symptoms — neurolysis at surgery; (7) **acute hamstring strain (grade I-II, no avulsion)** — non-operative — POLICE protocol + progressive Nordic eccentric (best evidence reduces recurrence) + PT + gradual return-to-running

---

Proximal hamstring tendon avulsion: surgery for complete avulsion + > 2 cm retraction + active patient (acute < 4-6 wk ideal). Identify + protect sciatic nerve. Chronic avulsion → graft reconstruction (inferior outcomes). Grade I-II strain → non-operative + Nordic eccentric (best evidence). RTS 6-9 months surgery, 2-12 wk strain.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 26 ปี นักฟุตบอล sprint แล้วรู้สึก pop ที่หลังต้นขาขวา ปวดมาก เดินกระเผลก

PE: ecchymosis posterior thigh distal, tender + palpable defect biceps femoris long head + semitendinosus origin, weakness knee flexion 3/5, weakness hip extension 4/5, positive prone slumped knee-bend test, no neurologic deficit

MRI thigh: high-grade partial tear hamstring origin (ischial tuberosity) — biceps femoris long head + semitendinosus + semimembranosus, > 2 cm retraction tendinous origin (proximal hamstring tendon avulsion)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue NSAIDs indefinitely"},{"label":"B","text":"Advanced Primary Hip OA Failed Conservative — Total Hip Arthroplasty (THA)"},{"label":"C","text":"Hip arthrodesis first"},{"label":"D","text":"Hemiarthroplasty preferred over THA in healthy 64"},{"label":"E","text":"Bedrest"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced Primary Hip OA Failed Conservative — Total Hip Arthroplasty (THA): (1) **primary THA gold standard** — "operation of the century" — excellent pain relief + function + > 95% 10-year survival; (2) preoperative optimization: medical comorbidities (HbA1c < 7.5-8, smoking cessation 4 weeks, BMI < 40 ideal), dental evaluation, MRSA screening, anemia optimization; (3) **surgical approach** — posterior (most common, higher dislocation), direct anterior (faster early recovery, learning curve, LFCN injury), direct lateral (low dislocation, abductor weakness limp); no clear superiority long-term; (4) **bearing surfaces**: ceramic-on-cross-linked polyethylene most common modern; metal-on-metal largely abandoned (ALVAL, ARMD); ceramic-on-ceramic (squeaking 1-3%, fracture rare); (5) cementless femoral + acetabular fixation (modern standard for most), cemented for severely osteoporotic elderly; (6) post-op rehab: WBAT same day, PT, ambulation; (7) hip precautions for posterior approach 6-12 weeks (avoid flexion > 90°, adduction, internal rotation); (8) DVT prophylaxis (aspirin, LMWH, DOAC); (9) infection prevention (antibiotic prophylaxis cefazolin within 1 hour, TXA reduces transfusion); (10) long-term: dislocation 1-3%, infection 1%, aseptic loosening, periprosthetic fracture, ALTR — counsel; (11) FDA implant tracking; (12) follow-up X-ray to monitor wear/loosening

---

Primary THA: gold standard advanced hip OA failed conservative. > 95% 10-yr survival. Optimize medical comorbidities preop (HbA1c, BMI, smoking, MRSA, dental). Modern bearing: ceramic-on-XLPE. Cementless fixation standard. Posterior most common (dislocation risk). TXA + DVT prophylaxis. Long-term complications counseled. "Operation of the century".'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 64 ปี ปวด hip ขวา 5 ปี ค่อย ๆ แย่ลง ปวดมาก + ขัด + ขยับยาก, FAILED 12 เดือน conservative (PT, NSAIDs, weight loss, intra-articular steroid)

BMI 28, no major comorbidity
PE: groin pain, internal rotation severely limited, Trendelenburg gait

X-ray hip: severe hip OA — joint space obliterated, subchondral cyst, osteophyte, sclerosis, no AVN, no acetabular dysplasia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue NSAIDs no surgery"},{"label":"B","text":"Aseptic Femoral Loosening Post-THA (15 ปี — late) — Revision Femoral Component"},{"label":"C","text":"Bedrest indefinitely"},{"label":"D","text":"Cast immobilization"},{"label":"E","text":"Antibiotics empirically without workup"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aseptic Femoral Loosening Post-THA (15 ปี — late) — Revision Femoral Component: (1) **rule out infection first** — ALL painful THA must have CRP + ESR + hip aspiration before assuming aseptic (MSIS criteria) — done: negative; (2) workup: bilateral hip X-ray with comparison to immediate post-op, CT to assess bone stock + cup version; metal-ion levels if MoM; (3) **revision THA — femoral component** with options based on remaining bone stock: (a) **proximally porous-coated stem** (if bone stock adequate), (b) **distally fixed extended stem (Wagner SL, Restoration Modular, fluted tapered stem)** for proximal bone deficiency, (c) impaction grafting + cemented stem (rarely used), (d) custom stem for severe deficiency; (4) Paprosky femoral defect classification guides; (5) extended trochanteric osteotomy (ETO) often needed to remove well-fixed stem; (6) cup assessment intra-op — revise if loose, malpositioned, or worn; (7) cells with abductor mechanism + soft tissue evaluation; (8) higher risk of complications vs primary (infection 3-5%, dislocation 5-10%, fracture, instability); (9) post-op restrictions + protected WB; (10) physical therapy

---

Painful THA: ALWAYS rule out infection first (CRP + ESR + aspiration — MSIS). Aseptic femoral loosening → revision. Paprosky classification guides. Distally fixed stem for proximal bone loss. ETO often needed. Higher complication rate vs primary. Cup assessed concurrently. Modern revision good outcomes but inferior to primary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 72 ปี s/p left THA 15 ปีก่อน เริ่มปวดต้นขา + groin 1 ปี ปวดมากขึ้นเมื่อ weight bear + standing up, ไม่ตอบสนอง NSAIDs

PE: groin + thigh pain, antalgic gait, no warmth, no draining sinus

X-ray hip: cementless femoral stem with radiolucency Gruen zones 1, 2, 7, 5, calcar resorption, distal stem subsidence 4 mm vs prior X-ray — aseptic loosening femoral component, acetabular cup intact
Lab: CRP 5 (normal), ESR 18 (normal), aspiration negative for infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotics outpatient discharge"},{"label":"B","text":"Acute Postoperative Periprosthetic Joint Infection (PJI < 3 months from surgery) — Confirmed MSIS"},{"label":"C","text":"Long-term opioid no surgery"},{"label":"D","text":"Discharge no antibiotics"},{"label":"E","text":"Single-stage replacement always in chronic PJI"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Postoperative Periprosthetic Joint Infection (PJI < 3 months from surgery) — Confirmed MSIS: (1) **debridement, antibiotics, and implant retention (DAIR)** — appropriate for acute postoperative (< 4-6 weeks from index surgery, or acute hematogenous with < 3 weeks symptoms) — well-fixed implants + susceptible organism + viable soft tissue: open thorough debridement + irrigation + **polyethylene liner exchange** + retention of metal components + 6-week IV organism-specific antibiotic (after intra-op cultures) → followed by oral suppression; success 50-70%; (2) **2-stage revision** — gold standard for chronic PJI (> 4-6 wk from surgery or chronic symptoms > 3 wk) or failed DAIR: (a) remove all components + thorough debridement + antibiotic-loaded cement spacer (articulating preferred for knee), (b) IV antibiotic 6 weeks, (c) antibiotic-free interval + verify eradication (normalized CRP/ESR, negative aspiration), (d) reimplantation; success 85-95%; (3) 1-stage revision — gaining favor in selected cases with low-virulence organism + healthy host; (4) hold antibiotic until intra-op cultures (unless septic); empiric vancomycin + cefepime/ceftriaxone; (5) chronic suppression for non-revisable patient; (6) infectious disease consult; (7) optimize host (DM, nutrition, smoking)

---

PJI: orthopedic emergency. MSIS criteria diagnosis. ACUTE postoperative (< 4-6 wk) or acute hematogenous (< 3 wk symptoms) + well-fixed implant → DAIR (irrigation + poly exchange + retention + 6 wk IV abx). CHRONIC or failed DAIR → 2-stage revision (gold standard). Hold antibiotics until cultures. ID consult. Host optimization.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 68 ปี s/p right TKA 8 weeks ago เริ่มปวด + บวม + แดง ข้อเข่าขวา 5 วัน + ไข้ต่ำ 37.8°C + drainage from incision

PE: warmth + erythema knee, mild effusion, tender, draining sinus, no neurologic deficit
Lab: WBC 13,000, CRP 145, ESR 88
Knee aspiration: WBC 28,000 (PMN 92%), gram stain negative, culture pending

MSIS criteria: 1 major (sinus tract communicating with prosthesis) + minor criteria meet — periprosthetic joint infection (PJI), acute postoperative (< 3 months)';

update public.mcq_questions
set choices = '[{"label":"A","text":"TKA always preferred"},{"label":"B","text":"advantages vs TKA"},{"label":"C","text":"Knee arthrodesis"},{"label":"D","text":"Bedrest 6 weeks"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Medial Compartment OA + Active Patient + Specific Criteria — Unicompartmental Knee Arthroplasty (UKA): (1) UKA candidate criteria (Kozinn + Scott + modern criteria): (a) isolated medial (or lateral) compartment OA confirmed clinically + radiographically + intra-operatively, (b) intact ACL (anterior stability essential), (c) correctable varus deformity (< 10-15°), (d) ROM > 90° flexion, (e) flexion contracture < 10°, (f) no significant patellofemoral OA (mild patellofemoral OK), (g) BMI no longer absolute contraindication; activity level no longer contraindication (modern evidence allows active patients); age — modern UKA performed across age spectrum; (2) **advantages vs TKA**: more bone preservation, preserves cruciates → more native kinematics + proprioception, smaller incision, less blood loss, faster recovery, more "natural" feel, lower transfusion, lower cardiopulmonary risk; (3) **disadvantages**: higher revision rate at 10-15 years (5-10% vs 3-5% TKA), revision to TKA easier than failed TKA revision; (4) **TKA alternative** for multicompartmental, deformity, instability, advanced patellofemoral; (5) high tibial osteotomy (HTO) alternative for younger patients (< 50-55) with isolated medial + correctable malalignment + want to preserve native joint; (6) outcome optimization: high-volume surgeon, modern implant design, robotic-assisted (controversial benefit)

---

UKA: isolated single-compartment OA with intact cruciates + correctable deformity + ROM preserved. Better functional outcome + faster recovery vs TKA but higher revision rate at 10-15 yr. HTO alternative for young (< 55) + isolated medial + correctable. TKA for multicompartmental, instability, severe deformity. Patient selection key. Modern criteria more inclusive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 58 ปี active เล่นกอล์ฟ ปวดเข่าด้านในขวา 2 ปี ดีขึ้นน้อยกับ conservative

BMI 27, ROM 0-130°, no significant instability
PE: tender medial joint line, varus 5°, intact ACL, full ROM, no flexion contracture, no lateral compartment pain, no patellofemoral symptoms

X-ray standing knee + Rosenberg + Skyline: isolated medial compartment OA — joint space obliterated medial, preserved lateral + patellofemoral, mild osteophytes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Anatomic TSA without cuff"},{"label":"B","text":"Cuff Tear Arthropathy with Pseudoparalysis — Reverse Total Shoulder Arthroplasty (rTSA)"},{"label":"C","text":"Hemiarthroplasty preferred for cuff arthropathy"},{"label":"D","text":"Conservative no surgery indefinite"},{"label":"E","text":"Arthrodesis shoulder"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cuff Tear Arthropathy with Pseudoparalysis — Reverse Total Shoulder Arthroplasty (rTSA): (1) **reverse TSA indicated** — revolutionized treatment of cuff tear arthropathy: (a) reverses normal shoulder anatomy — semi-constrained ball-on-socket at glenoid + cup on humerus, (b) shifts center of rotation medially + distally + tensions deltoid, (c) deltoid replaces cuff function for elevation, (d) does NOT require functional cuff (unlike anatomic TSA which requires intact cuff); (2) **indications**: cuff tear arthropathy, irreparable massive cuff tear with pseudoparalysis, failed rotator cuff repair with cuff arthropathy, complex proximal humerus fracture in elderly (no tuberosity healing concern), revision arthroplasty, **chronic locked dislocation**, rheumatoid arthritis with cuff deficiency; (3) prerequisites: functional deltoid, intact axillary nerve, adequate bone stock glenoid (or augmented baseplate), acceptable infection workup; (4) **outcomes**: predictable pain relief + improved elevation (typically 120-150° from baseline pseudoparalysis), external rotation less predictable (consider latissimus dorsi transfer for ER deficiency), better than hemiarthroplasty for cuff arthropathy; (5) **complications**: instability (1-5%), infection (Cutibacterium acnes — "propi"), scapular notching (less with newer designs), acromial stress fracture (5-10%), neurologic, periprosthetic fracture; (6) post-op: sling, gradual deltoid activation + ROM; (7) age previously > 70 ปี, modern indications expanding to younger active patients selectively; (8) prosthesis survival > 90% at 10 years

---

Reverse TSA: revolutionary for cuff tear arthropathy + pseudoparalysis. Doesn''t need cuff — uses deltoid. Indications expanded: massive irreparable cuff tear, proximal humerus fracture in elderly, revision, locked dislocation, RA. Predictable elevation. Complications: notching, instability, fracture, infection (P. acnes). > 90% 10-yr survival. Age limits relaxing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 75 ปี ปวด + อ่อนแรงไหล่ขวา ยกแขนเหนือศีรษะไม่ได้ 5 ปี (chronic massive rotator cuff tear → cuff tear arthropathy)

PE: pseudoparalysis (active elevation < 90° but full passive ROM), positive impingement, drop arm, weakness external rotation, no infection signs

X-ray shoulder: superior migration of humeral head (acromiohumeral distance 4 mm — normal > 7 mm), Hamada IV (acetabularization acromion), glenohumeral OA — cuff tear arthropathy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cast immobilization 12 weeks"},{"label":"B","text":"Vancouver B2 Periprosthetic Femoral Fracture (around stem, loose stem, adequate bone stock) — Revision Surgery"},{"label":"C","text":"Discharge home with crutches"},{"label":"D","text":"ORIF without revising loose stem"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vancouver B2 Periprosthetic Femoral Fracture (around stem, loose stem, adequate bone stock) — Revision Surgery: (1) **operative revision** — Vancouver B2 mandates revision of loose stem + fracture fixation: (a) **revision to long-stemmed femoral implant** (modular tapered fluted stem — Wagner SL, Restoration Modular) that bypasses fracture by ≥ 2 cortical diameters + obtains distal fixation in intact bone; (b) cerclage cables/wires for fracture reduction; (c) consider strut allograft augmentation for cortical defects; (2) Vancouver classification: **A**(trochanteric — non-op for AG; ORIF for AL with avulsion of vastus origin), **B1** (around stem, stable stem, good bone — ORIF with locked plate ± cerclage, retain stem), **B2** (around stem, loose stem, good bone — revise long stem), **B3** (around stem, loose stem, poor bone — revise long stem + augmentation/allograft/proximal femoral replacement); **C** (distal to stem — ORIF locked plate, retain stem); (3) pre-op assessment: stem fixation (subsidence, radiolucency, calcar resorption), bone stock, soft tissue, host comorbidities; (4) DVT prophylaxis; (5) post-op WB depends on fixation; (6) PT + multidisciplinary geriatric care; (7) osteoporosis treatment; (8) fall prevention; (9) mortality + complications high in elderly (similar to hip fracture)

---

Periprosthetic femur fracture post-THA: Vancouver classification (B is most common — at stem). B1 stable stem = ORIF + retain. B2 loose stem + good bone = revise to long stem. B3 loose + poor bone = revise + augmentation/proximal femur replacement. C distal to stem = ORIF. Bypass fracture 2 cortical diameters. High complication + mortality similar to hip fracture.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 78 ปี s/p left THA 10 ปีก่อน หกล้มในห้องน้ำ ปวด thigh + hip ซ้าย เดินไม่ได้

PE: shortening + external rotation left leg, palpable crepitation thigh, NV intact

X-ray femur: spiral periprosthetic femur fracture around tip of cementless femoral stem, stem appears loose (subsidence, radiolucency), no acetabular fracture — **Vancouver B2** (fracture around stem with loose stem, adequate bone stock)';

update public.mcq_questions
set choices = '[{"label":"A","text":"THA only option for any patient"},{"label":"B","text":"Young Active Male with Advanced Hip OA + Adequate Bone Stock — Hip Resurfacing as Option"},{"label":"C","text":"Hip arthrodesis"},{"label":"D","text":"Conservative indefinitely"},{"label":"E","text":"Steroid injection only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Young Active Male with Advanced Hip OA + Adequate Bone Stock — Hip Resurfacing as Option: (1) **discuss THA vs hip resurfacing arthroplasty (HRA)** with patient — shared decision; (2) **hip resurfacing advantages**: (a) preserves femoral head + neck bone stock (revision-friendly), (b) larger head + lower dislocation rate vs THA, (c) more natural hip biomechanics + restoration of hip offset, (d) potentially better function for high-demand activity (some studies — equivalent return to sport), (e) easier revision to THA if needed; (3) **hip resurfacing disadvantages/risks**: (a) **metal-on-metal bearing** — adverse local tissue reaction (ALTR), pseudotumor, metal ion elevation (cobalt, chromium), ALVAL, raised concern in females + small components → most series report better outcomes in **males with larger femoral head** (> 50 mm); (b) femoral neck fracture (1-2% within first year); (c) limited implants on market (recalls — DePuy ASR, Birmingham hip exception remains); (d) require pre-op bone density adequate; (4) **patient selection criteria (Birmingham hip)**: male > female, age < 65 ปี typically, large femoral head (> 50 mm component), good bone density (no severe osteoporosis), no severe femoral head deformity/cysts, no metal allergy, no renal impairment; (5) **modern trend** — declining HRA use globally + favoring THA with cross-linked polyethylene + ceramic-on-ceramic in young active patients (less concern with metal ions, similar functional outcomes); (6) discuss with patient + informed consent + metal ion monitoring

---

Hip resurfacing arthroplasty: bone-preserving option for young active males with large femoral head. Birmingham hip remaining major implant. Risks: ALTR, pseudotumor, metal ion elevation, femoral neck fracture. Modern trend → declining use, favoring THA with XLPE/ceramic-on-ceramic. Strict patient selection (male, large head, no osteoporosis). Shared decision-making.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 42 ปี อดีตนักรักบี้ ปวด hip ซ้าย 3 ปี (advanced OA secondary to old acetabular fracture) ต้องการกลับมาเล่นกีฬา active, ผู้ป่วยตัวสูง 180 cm bone stock ดี

Discussion of options THA vs hip resurfacing

X-ray hip: end-stage OA, adequate femoral head + neck bone stock, no significant cysts, no severe deformity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate aggressive excision without delay"},{"label":"B","text":"Heterotopic Ossification (HO) Post-THA Brooker Grade III + Functional ROM Restriction"},{"label":"C","text":"No further treatment ever"},{"label":"D","text":"Total joint revision"},{"label":"E","text":"Above-knee amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Heterotopic Ossification (HO) Post-THA Brooker Grade III + Functional ROM Restriction: (1) **observation initially** — HO progression usually slows by 6-12 months; bone scan to assess metabolic activity ("hot" bone scan = active formation, not ready for excision); (2) **prophylaxis at index surgery** to prevent — high risk patients (male, prior HO, ankylosing spondylitis, DISH, post-traumatic, posterior approach): (a) **indomethacin 25 mg TID × 6 weeks** post-op (NSAID — inhibits osteoblast differentiation), or selective COX-2; (b) **single-fraction radiation therapy** 6-8 Gy within 72 hours post-op (alternative — equivalent efficacy, avoids GI/renal effects of NSAIDs); (3) **surgical excision** considered for symptomatic HO causing functional limitation: (a) wait until HO mature (12-18 months) — bone scan shows decreased activity + serum alkaline phosphatase normalized → reduces recurrence; (b) wide excision + capsulotomy + restore ROM; (c) **prophylaxis post-excision** essential (otherwise recurrence near 100%) — indomethacin or single-dose radiation 6-8 Gy within 24-72 hours; (4) physical therapy for ROM restoration; (5) screen for ankylosing spondylitis, DISH, neurogenic causes (SCI, TBI) when severe/recurrent; (6) **acute traumatic HO** (post-burn, brain injury, SCI) — etidronate historic, indomethacin, radiation; modern bisphosphonate + radiation

---

Heterotopic ossification post-THA: more common in male, posterior approach, prior HO, AS, DISH. Prophylaxis: indomethacin 6 weeks OR single-dose radiation 6-8 Gy < 72h — for high-risk patients. Excision delayed 12-18 months until mature (bone scan, alk phos). MUST give prophylaxis post-excision (otherwise recurs near 100%). PT for ROM.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 55 ปี s/p right THA 6 เดือนก่อน ปวด + ยับยั้ง ROM ของ hip ขวา (loss of flexion to 80° from prior 110°) — ankylosing trend

PE: marked decreased ROM, palpable mass around hip

X-ray hip: extensive heterotopic ossification around hip (Brooker grade III — bone islands with < 1 cm between bone surfaces), implants well-fixed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue conservative indefinitely"},{"label":"B","text":"Bilateral End-Stage Tricompartmental Knee OA Failed Conservative — Total Knee Arthroplasty (TKA)"},{"label":"C","text":"Bilateral simultaneous TKA always preferred"},{"label":"D","text":"Knee arthrodesis first"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral End-Stage Tricompartmental Knee OA Failed Conservative — Total Knee Arthroplasty (TKA): (1) **TKA indicated** — proven excellent pain relief + function + > 90% 15-year survival; (2) preoperative optimization: HbA1c < 7.5-8 (some centers strict < 7), BMI consideration (some centers BMI > 40 require weight loss but evidence evolving — Obesity Society + AAHKS — BMI not absolute contraindication but increased complication risk), MRSA screening, smoking cessation, dental clearance, medical clearance; (3) **staged vs simultaneous bilateral TKA**: staged (8-12 weeks apart) safer profile (lower mortality + complications); simultaneous in selected healthy patient with adequate support; (4) **surgical technique**: standard PCL-substituting (posterior-stabilized) vs cruciate-retaining design (similar outcomes), patellar resurfacing (controversial), tourniquet + TXA (reduces transfusion 30%), antibiotic prophylaxis cefazolin within 1 hour, periarticular injection (multimodal — reduces opioid); (5) post-op rehabilitation: early WBAT + PT same day (rapid recovery protocols / enhanced recovery after surgery — ERAS), CPM controversial; (6) DVT prophylaxis (aspirin, LMWH, DOAC); (7) multimodal pain management (avoid opioid-only); (8) **outcomes** — excellent pain relief + function in 85-90% (10-15% with persistent unexplained pain — counsel); (9) complications: PJI (1%), DVT/PE, periprosthetic fracture, aseptic loosening, instability, polyethylene wear; (10) **patient education + expectation management** key

---

Primary TKA: gold standard end-stage knee OA failed conservative. > 90% 15-yr survival. Optimize preop (HbA1c, BMI, smoking, MRSA, dental). Staged > simultaneous bilateral generally. PCL-substituting vs cruciate-retaining similar. TXA + tourniquet + multimodal pain + ERAS. 10-15% with persistent unexplained pain — manage expectations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'หญิงไทยอายุ 70 ปี ปวดเข่าทั้ง 2 ข้าง 8 ปี ค่อย ๆ แย่ลง ปวดตอนเดิน + ขึ้นบันได, BMI 35, FAILED conservative > 2 ปี (PT, NSAIDs, weight loss, steroid injection)

PE: bilateral varus deformity 12°, flexion contracture 10°, ROM 10-100°, crepitation, no instability
HbA1c 7.2%, no significant cardiac/renal disease

X-ray standing: severe bilateral tricompartmental OA (medial > lateral > patellofemoral) — Kellgren-Lawrence IV';

update public.mcq_questions
set choices = '[{"label":"A","text":"Total patellectomy always best"},{"label":"B","text":"patellofemoral arthroplasty (PFA)"},{"label":"C","text":"Arthroscopic debridement first for isolated OA"},{"label":"D","text":"Conservative indefinitely regardless of symptoms"},{"label":"E","text":"Bedrest 6 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated Patellofemoral Arthritis Failed Conservative — Treatment Options: (1) continued conservative (PT — VMO + hip strengthening + flexibility, NSAIDs, brace, taping, weight loss, activity modification, steroid injection); (2) **arthroscopic debridement** — NOT effective for isolated OA without mechanical symptoms (USPSTF + OARSI against); (3) **patellofemoral arthroplasty (PFA)** — modern indication: isolated patellofemoral OA without tibiofemoral or significant trochlear dysplasia in younger patient; preserves tibiofemoral compartments + cruciate ligaments + meniscus; modern onlay designs (vs older inlay) have better outcomes; (4) **tibial tubercle osteotomy (TTO) — anteromedialization (Fulkerson)** — improves patellofemoral kinematics if maltracking + cartilage damage lateral facet; (5) **TKA** — definitive if isolated PF OA progresses or for older patients (PF OA component of OA); better long-term predictability; (6) **avoid total patellectomy** — historic procedure with poor outcomes (loss of extensor mechanism leverage, persistent pain + weakness); (7) cartilage restoration (microfracture, OATS, ACI/MACI) — selective for focal defects in young; (8) shared decision-making + counsel; (9) patient age + activity level + tibiofemoral status + obesity all factor

---

Isolated patellofemoral OA: options vary. PFA — modern indication for isolated PF OA in younger active patient (preserves rest of joint). TTO anteromedialization for maltracking. TKA definitive for older or progressing OA. AVOID total patellectomy (poor outcomes). Arthroscopic debridement ineffective for pure OA. Cartilage restoration for focal defects.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'orthopedics'
  and scenario = 'ชายไทยอายุ 52 ปี ปวดเข่าด้านหน้าซ้าย 4 ปี (isolated patellofemoral OA — post-traumatic from prior patellar fracture) ปวดตอนขึ้นบันได + เดินลงทางลาด + นั่งนาน, FAILED conservative 2 ปี

PE: tender patellofemoral joint + retropatellar crepitation, mild Q-angle, no tibiofemoral pain, no instability

X-ray + skyline + MRI: isolated patellofemoral OA, preserved tibiofemoral compartments, severe patellofemoral cartilage loss + osteophyte';

commit;
