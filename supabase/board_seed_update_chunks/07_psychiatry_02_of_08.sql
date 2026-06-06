-- ===============================================================
-- UPDATE chunk 2/8: psychiatry (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"No prevention possible"},{"label":"B","text":"Comprehensive Suicide Prevention Program — Public Health Approach"},{"label":"C","text":"Ignore"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single intervention"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive Suicide Prevention Program — Public Health Approach: (1) **Universal prevention**: public education, stigma reduction, mental health literacy, school-based programs, media reporting guidelines (avoid copycat effect — WHO + Suicide Prevention Resource Center guidelines), safe firearm/medication storage; (2) **Selective prevention**: gatekeeper training (teachers, clergy, military, healthcare — recognize warning signs + refer); workplace programs; veteran programs; LGBTQ+ youth support; (3) **Indicated prevention**: screening high-risk (Columbia Suicide Severity Rating Scale), brief interventions, safety planning (Stanley-Brown), means restriction; (4) **Treatment access**: integrated primary care behavioral health, telepsychiatry, crisis services, hotlines (988 US, 1323 Thailand), text/chat services; (5) **Treatment of underlying**: mental health, substance use; lithium + clozapine unique anti-suicide effects; (6) **Crisis services**: 24/7 hotlines, mobile crisis teams, crisis stabilization units, peer-run respite, ED + hospital follow-up; (7) **Means restriction**: most evidence-based — counsel + restrict access (especially firearms, medications, jumping locations, pesticides — major in Asia); coalition with families, employers, communities; (8) **Postvention**: support for survivors of suicide loss (bereavement groups, individual therapy) + traumatic events (school suicide clusters); (9) **System changes**: Zero Suicide initiative (healthcare organization commitment); transitions of care critical (post-discharge highest risk); follow-up (caring contacts — postcards, calls reduce reattempts); (10) **Research + data**: surveillance, evaluation; (11) **Multidisciplinary + multisector**: healthcare, schools, workplaces, military, criminal justice, faith communities, government; (12) **Equity**: address disparities (LGBTQ+, indigenous, youth, military veterans, rural)

---

Suicide prevention: public health approach — universal + selective + indicated. Means restriction most evidence-based. Zero Suicide initiative. Crisis services + hotlines. Treatment access + transitions of care. Postvention. Multidisciplinary + multisector. Equity. Modern: data-driven + comprehensive. Many lives can be saved.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'Hospital implements suicide prevention program — public health approach';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid technology"},{"label":"B","text":"Telepsychiatry Implementation — Expands Access + Capacity"},{"label":"C","text":"In-person only"},{"label":"D","text":"Ignore technology"},{"label":"E","text":"Random approach"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telepsychiatry Implementation — Expands Access + Capacity: (1) **Modalities**: synchronous video (most common), telephone, asynchronous (consult, secure messaging), eConsult, hybrid models; (2) **Equipment + technology**: secure HIPAA-compliant platforms, basic hardware (camera, microphone, screen), bandwidth, backup options; (3) **Use cases**: routine outpatient visits, ED consultation (psychiatrists scarce), inpatient psychiatry consultation in non-psych hospitals, school-based, primary care integration, rural communities, correctional facilities, group therapy, family + couples therapy; (4) **Patient population**: most effective comparable to in-person care for most disorders (depression, anxiety, PTSD, ADHD, substance use disorder); some limitations — severe psychosis requiring physical exam, certain ages (very young), elderly with cognitive impairment, technology access; (5) **Special considerations**: emergency protocols (safety plan, local emergency contacts, hospital), documentation, prescription regulations (controlled substances rules — DEA Ryan Haight Act + COVID waivers); (6) **Licensing + credentialing**: state-by-state in US, interstate compacts emerging; Thailand — increasing regulation + acceptance; (7) **Reimbursement**: parity laws, payer coverage expanding post-COVID; (8) **Quality**: training in telehealth-specific skills, patient assessment + safety, technical + therapeutic competence; (9) **Equity**: digital divide concerns (rural, elderly, low-income, language barriers — provide alternatives); (10) **Modern**: collaborative care, eConsults, peer support, asynchronous apps for self-management (Headspace, Calm, BetterHelp); (11) **Multidisciplinary integration**: primary care, specialty, schools, employers; (12) **Outcomes research**: similar to in-person + improved access

---

Telepsychiatry: expands access + workforce capacity. Multiple modalities. Effective for most disorders comparable to in-person. Safety + emergency protocols essential. Licensing + reimbursement evolving. Equity — digital divide. Modern: integrated with collaborative care + asynchronous apps + peer support. COVID accelerated adoption.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'Hospital wants to expand telepsychiatry + reduce mental health workforce gap';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Chronic Pain + Depression + OUD + Insomnia — Integrative Multidisciplinary Care"},{"label":"C","text":"More opioids"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Single specialist"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pain + Depression + OUD + Insomnia — Integrative Multidisciplinary Care: (1) **Bidirectional relationship**: chronic pain + depression — each worsens other; chronic pain + opioid use → addiction risk + hyperalgesia + worsens depression + sleep; (2) **Multidisciplinary team**: pain medicine, addiction medicine, psychiatry, primary care, PT, OT, behavioral health, social work, possibly anesthesia/interventional; (3) **OUD treatment first** (often) — initiating buprenorphine treats addiction + provides analgesia + can replace opioid analgesics; methadone similar; addresses primary risk; (4) **Chronic pain non-pharmacologic + non-opioid pharmacologic**: - CBT for chronic pain (evidence-based); - PT + graded exercise; - Mindfulness-based stress reduction; - Acceptance + commitment therapy; - SNRIs (duloxetine — both pain + depression); - SSRIs (less for pain but treat depression); - Anticonvulsants (gabapentin, pregabalin — caution misuse potential); - Topical agents (capsaicin, lidocaine); - Procedures (steroid injection, RFA, spinal cord stimulator selected); - Avoid escalating opioids; (5) **Depression treatment**: SSRI/SNRI (duloxetine excellent — dual purpose), CBT, behavioral activation, exercise; (6) **Insomnia**: CBT-I gold standard; avoid benzodiazepines + nightly opioids; consider melatonin agonist, low-dose trazodone, DORA; sleep hygiene; (7) **Address comorbidity**: anxiety, substance use, trauma history; (8) **Functional goals**: return to meaningful activity > pain elimination; (9) **Patient education + self-management**; (10) **Family + social support**: care navigation, support groups; (11) **Avoid harm**: monitoring, PDMP (prescription drug monitoring program), urine drug screens, naloxone, safety planning; (12) **Whole-person care**: holistic + biopsychosocial model

---

Chronic pain + depression + OUD + insomnia = quintessential integrative + multidisciplinary case. Treat OUD first often (buprenorphine multipurpose). Chronic pain — non-pharm + non-opioid (CBT, PT, SNRI). Depression treatment overlaps. CBT-I for insomnia. Functional goals over pain elimination. Whole-person care. Modern pain medicine: biopsychosocial + non-opioid focus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ผู้ป่วยอายุ 55 ปี chronic pain (low back) + depression + opioid use disorder + chronic insomnia — multidisciplinary integrative management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Schizophrenia + Substance Use + Metabolic Syndrome — Integrative Multidisciplinary Care"},{"label":"C","text":"Single drug only"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizophrenia + Substance Use + Metabolic Syndrome — Integrative Multidisciplinary Care: (1) **Mental health treatment** continuation + optimization: antipsychotic adherence (LAI consideration — risperidone, paliperidone, aripiprazole, olanzapine LAIs); switch to less metabolic agent (aripiprazole, ziprasidone, lurasidone, cariprazine) given metabolic syndrome — but balance with effectiveness; (2) **Co-occurring substance use disorder**: integrated dual diagnosis treatment (separate treatment historically less effective); motivational interviewing + CBT; cannabis use disorder — no FDA-approved meds, supportive therapy + harm reduction; cannabis exacerbates psychosis + increases relapse — important to address; (3) **Metabolic syndrome management**: lifestyle (diet, exercise, weight), screen + treat (HbA1c, lipids, BP); switch antipsychotic if possible; metformin for weight gain (off-label use, modest benefit); statin if indicated; (4) **Psychosocial**: assertive community treatment (ACT) for severe persistent; supportive employment; supportive housing; CBT for psychosis (CBTp) — emerging evidence; (5) **Family education + support**: NAMI Family-to-Family, support groups, education about illness + reduce expressed emotion (high EE associated with relapse); (6) **Social determinants**: housing, employment, income, education, social network; (7) **Physical health**: people with schizophrenia 15-20 years reduced life expectancy — mostly cardiovascular + metabolic; aggressive prevention + treatment; (8) **Smoking** common (60-90%) — increases mortality + drug interactions; cessation programs; (9) **Multidisciplinary team**: psychiatry, addiction medicine, primary care, nursing, social work, vocational rehab, peer support, family; (10) **Treatment resistance** (~30%): clozapine after 2 failed antipsychotics — only antipsychotic with mortality reduction; (11) **Quality + outcomes**: SAMHSA + WHO + AIMS Center models

---

Schizophrenia + SUD + metabolic syndrome = complex chronic illness requiring integrative multidisciplinary care. Integrated dual diagnosis treatment. Metabolic syndrome major contributor to mortality — aggressive prevention + treatment + antipsychotic choice. Smoking cessation. Family education + support. Social determinants. Treatment-resistant — clozapine (unique mortality reduction). Multidisciplinary lifelong care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ผู้ป่วยอายุ 28 ปี — schizophrenia + cannabis use disorder + metabolic syndrome on olanzapine + family stress — multidisciplinary integrative care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Adolescent Eating Disorder + Depression + Self-Harm + Family Conflict — Integrative Multidisciplinary Care"},{"label":"C","text":"Single specialist"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Eating Disorder + Depression + Self-Harm + Family Conflict — Integrative Multidisciplinary Care: (1) **Safety assessment** + level of care: AN with medical instability → inpatient medical; otherwise residential, PHP, IOP, outpatient by severity; (2) **Family-Based Treatment (FBT/Maudsley) first-line for adolescent AN** — parents take active role in refeeding + recovery; (3) **Multidisciplinary**: adolescent medicine, child + adolescent psychiatry, dietitian, individual therapy, family therapy, school liaison; (4) **Concurrent depression**: treat with SSRI (caution — FDA boxed warning increased SI in adolescents but benefits outweigh; close monitoring); CBT or DBT; (5) **Self-harm (cutting)**: DBT-A (DBT for adolescents) — skills, family component; address function (emotion regulation usually); reduce access to means; safety plan; (6) **Family conflict**: family therapy + parental support; reduce blame + criticism; consistency; education about adolescent development; (7) **School refusal**: gradual exposure + return; school accommodations; address bullying, learning disorders, anxiety; school nurse + counselor coordination; (8) **Adolescent development considerations**: identity, peer relationships, autonomy + parental support balance, social media + body image; (9) **LGBTQ+ assessment** + support if applicable (high suicide + eating disorder risk if minority stress); (10) **Suicide risk** elevated — assess + safety plan; (11) **Long-term**: chronic illness for some; relapse common; ongoing care + transition to adult system; (12) **Outcomes**: with comprehensive care 50% full recovery, 25% partial, 25% chronic; (13) **Multidisciplinary team**: child + adolescent psychiatry, adolescent medicine, dietitian, individual therapist, family therapist, school personnel, primary care; family-centered

---

Adolescent multiple psychiatric comorbidities = integrative + multidisciplinary + family-centered. FBT for adolescent AN. SSRI + CBT/DBT for depression + self-harm. Family therapy + school re-integration. Adolescent development considerations. Suicide risk elevated. Long-term care + transition. Multidisciplinary essential. Outcomes improve with comprehensive care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'Adolescent อายุ 16 ปี — eating disorder (anorexia nervosa) + depression + cutting + family conflict + school refusal — multidisciplinary integrative management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation only — let it resolve"},{"label":"B","text":"Recurrent MDD, severe"},{"label":"C","text":"Stop all medications permanently"},{"label":"D","text":"Benzodiazepine monotherapy long-term"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Recurrent MDD, severe — DSM-5 ≥ 5 sx > 2 wk + functional impairment + ≥ 2 prior episodes: (1) Restart SSRI ที่เคย response (sertraline) — same agent ที่เคยใช้ได้ผล มีโอกาส response ซ้ำสูง; titrate to therapeutic dose; (2) Concurrent psychotherapy (CBT or IPT) — combination ดีกว่า monotherapy ใน recurrent/severe; (3) Maintenance phase: หลัง remission ต้อง continue ≥ 2 ปี (recurrent — 3 prior episodes = lifelong maintenance per APA); (4) Education: นี่คือ chronic recurrent illness, ห้ามหยุดยาเอง; relapse rate 50% off-medication; (5) Safety: assess SI ทุก visit; (6) Monitor side effects + adherence; measurement-based care (PHQ-9 ทุก 2-4 wk); (7) Lifestyle: exercise, sleep hygiene, social activation

---

Recurrent MDD: ≥ 2 episodes. Prior response to specific SSRI predicts re-response — restart same agent. Combination therapy (SSRI + CBT/IPT) most effective in recurrent. Maintenance phase critical — ≥ 3 episodes = often lifelong. Premature discontinuation = relapse. Measurement-based care (PHQ-9).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 42 ปี เคยมี depressive episode 2 ครั้งก่อนหน้านี้ (response ดีต่อ sertraline; หยุดยาเองหลัง 4 เดือน) — ขณะนี้กลับมามีอาการ depressed mood + anhedonia + insomnia + fatigue + guilt + decreased concentration + passive SI × 8 สัปดาห์

No psychotic features, no manic history
PHQ-9: 19 (severe)
TSH, B12, CBC normal
No substance use';

update public.mcq_questions
set choices = '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"MDD with melancholic features (DSM-5 specifier"},{"label":"C","text":"Bupropion monotherapy"},{"label":"D","text":"Benzodiazepine only"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with melancholic features (DSM-5 specifier — loss of pleasure in all/almost all activities + lack of reactivity + ≥ 3: distinct quality of mood, worse AM, early morning awakening, marked psychomotor change, significant weight loss, excessive guilt): (1) Pharmacotherapy first-line — melancholic responds well to TCA + SNRI; SSRI also effective แต่ severe melancholic อาจ response ต่ำกว่า; consider venlafaxine, duloxetine, nortriptyline; (2) ECT highly effective for severe melancholic/psychomotor retardation — consider early ถ้า severe, suicidal, food/fluid refusal, ก่อนหน้า ECT response; (3) Augmentation: lithium, T3, atypical antipsychotic; (4) Psychotherapy adjunctive (severe melancholic อาจ respond ต่อ medication ดีกว่า psychotherapy alone); (5) Safety: suicide risk high (severe + guilt + hopelessness); (6) Monitor weight, nutrition, hydration

---

Melancholic MDD specifier: severe biological depression — TCA/SNRI/ECT particularly effective. Suicide risk high. ECT consideration early for severe/refractory/suicidal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 58 ปี depressed × 6 สัปดาห์ — anhedonia ที่ pervasive (ไม่มีอะไรทำให้ดีขึ้นแม้แต่ชั่วคราว) + early morning awakening 3am + diurnal variation (แย่ตอนเช้า) + 8 kg weight loss + psychomotor retardation + excessive guilt

MSE: psychomotor slow, masked affect, latency of response
No psychotic sx, no prior bipolar';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"MDD with atypical features (DSM-5"},{"label":"C","text":"TCA only"},{"label":"D","text":"Antipsychotic monotherapy"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with atypical features (DSM-5: mood reactivity + ≥ 2 of: weight gain/↑appetite, hypersomnia, leaden paralysis, interpersonal rejection sensitivity): (1) SSRI first-line (modern data — historical MAOI preference largely superseded); sertraline, fluoxetine, escitalopram; (2) MAOI (phenelzine) classic effective สำหรับ atypical แต่ side effects + diet restrictions; reserve for refractory; (3) CBT, IPT — effective adjunct/alternative; (4) Bupropion อาจช่วย hypersomnia + weight (activating); (5) Lifestyle: structured sleep, exercise, light therapy ถ้า seasonal component; (6) Address interpersonal rejection sensitivity — overlap กับ borderline traits, evaluate; (7) Comorbidity: anxiety + somatic symptoms common

---

Atypical MDD: mood reactivity + reverse vegetative (hypersomnia, hyperphagia) + leaden paralysis + rejection sensitivity. Historically MAOI > TCA; modern SSRI first-line. Bupropion can help with sedation/weight.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 26 ปี depressed × 4 เดือน — mood improves with positive events (mood reactivity), hypersomnia (sleep 12h), hyperphagia (น้ำหนักขึ้น 6kg), leaden paralysis (heavy limbs), long-standing interpersonal rejection sensitivity

PHQ-9: 16';

update public.mcq_questions
set choices = '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"MDD with psychotic features (DSM-5 specifier; severe + mood-congruent delusions/hallucinations)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Watchful waiting"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with psychotic features (DSM-5 specifier; severe + mood-congruent delusions/hallucinations) — high acuity: (1) Admit — food refusal + dehydration + psychotic risk; (2) Treatment: antidepressant + antipsychotic combination (SSRI/SNRI + atypical antipsychotic เช่น olanzapine, quetiapine, aripiprazole) — combination superior to either monotherapy (STOP-PD trial); (3) ECT first-line consideration — highly effective for psychotic depression (response rate 80-90%), faster than medication, lifesaving in food refusal/severe SI/catatonic features; (4) IV hydration + nutrition support (NG ถ้าจำเป็น); (5) Safety: suicide risk very high (psychotic depression × 5 risk); 1:1 observation; (6) Avoid antidepressant monotherapy (less effective + may worsen); (7) Maintenance: continue both medications post-remission; relapse risk high; (8) Multidisciplinary: psychiatry, internal medicine, nursing

---

Psychotic MDD: severe depression + mood-congruent (or incongruent) psychotic features. ECT first-line (response 80-90%). Pharmacological: antidepressant + antipsychotic combination (STOP-PD). Avoid monotherapy. Suicide risk × 5. Admit for safety + medical stabilization.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 65 ปี severe depressed × 3 เดือน + recent onset — เชื่อว่าตัวเองทำบาปร้ายแรงที่ทำให้ทั้งครอบครัวจะถูกลงโทษ (mood-congruent guilt delusion), บางครั้งได้ยินเสียงด่าตัวเอง, ปฏิเสธอาหาร 5 วัน (กลัวเป็นบาปกิน), น้ำหนักลด 7kg, immobile/mute บางช่วง

No prior psychotic disorder, no substance use, MMSE 26/30
Lab: Na 138, BUN 28 (mild dehydration), Cr 1.0';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue same regimen"},{"label":"B","text":"Treatment-Resistant Depression (TRD"},{"label":"C","text":"Discharge home with outpatient follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Treatment-Resistant Depression (TRD — failure ≥ 2 adequate trials) — ECT indicated: (1) ECT first-line สำหรับ TRD + severe depression + active SI — most effective antidepressant (response 60-80% TRD; > 80% psychotic depression); (2) Indications: severe MDD, suicidal, catatonic, psychotic, food refusal, prior ECT response, pregnancy (safe); (3) Procedure: bilateral or right unilateral high-dose; brief-pulse; 6-12 treatments acute course (3×/wk); muscle relaxant (succinylcholine) + brief anesthesia (methohexital); seizure 25-60 sec induced; (4) Side effects: transient cognitive (anterograde + retrograde amnesia — right unilateral less); headache, myalgia; no significant long-term cognitive deficit in most; (5) Contraindications relative: increased ICP, recent MI/stroke (consult cardiology/neurology); (6) Continuation/maintenance ECT prevents relapse; concurrent maintenance medication; (7) Alternatives ถ้า ECT not feasible: ketamine/esketamine IV/IN (rapid onset, FDA approved esketamine), TMS (less invasive, less effective for severe), psilocybin (research); (8) Multidisciplinary: psychiatry, anesthesia, nursing, family education (reduce stigma)

---

Treatment-Resistant Depression (TRD): failure ≥ 2 adequate trials. ECT most effective antidepressant — response 60-80% TRD. Indications: severe, suicidal, psychotic, catatonic, food refusal. Cognitive side effects transient. Continuation/maintenance ECT + medication prevents relapse. Alternatives: ketamine/esketamine, TMS.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 52 ปี severe MDD × 18 เดือน — failed adequate trials (≥ 6 wk at therapeutic dose) ของ sertraline, venlafaxine, bupropion, mirtazapine; CBT × 16 sessions; lithium + T3 augmentation; ขณะนี้ severely depressed, weight loss 10kg, active SI with plan

No psychotic features, no substance use
Medical workup: stable, no contraindications
Family ขอ recommendations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue failed agents"},{"label":"B","text":"Esketamine (intranasal) + oral antidepressant"},{"label":"C","text":"Stop all treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Esketamine (intranasal) + oral antidepressant — FDA approved 2019 TRD + 2020 MDD with acute SI: (1) Mechanism: NMDA receptor antagonist → rapid synaptic plasticity, BDNF; effect within hours-days (vs weeks for SSRI); (2) Dosing: esketamine intranasal 56-84mg twice weekly × 4 wk induction, then weekly/biweekly maintenance; concurrent oral antidepressant required; (3) REMS program — administer in healthcare setting + observation 2h post (dissociation, BP elevation, sedation); cannot drive same day; (4) Side effects: dissociation (transient), BP increase (monitor), sedation, dizziness, nausea, urinary issues with chronic use; abuse potential — controlled substance; (5) Racemic ketamine IV (off-label) — similar mechanism, used in clinical practice + research; lower cost; less regulated; (6) Contraindications: aneurysm, AVM, intracerebral hemorrhage, hypertensive emergency, history of psychosis; (7) Combination with antidepressant + psychotherapy; (8) Long-term safety data evolving — limit duration when possible; (9) Multidisciplinary: psychiatry, nursing, ongoing antidepressant management

---

Esketamine (intranasal) — FDA approved 2019 TRD, 2020 acute SI. Rapid onset (hours-days). NMDA antagonist. Requires REMS program (in-clinic + 2h observation). Must combine with oral antidepressant. Side effects: dissociation, BP, abuse potential. Racemic IV ketamine off-label alternative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 45 ปี TRD — failed 4 antidepressants + augmentation + CBT; ECT ผู้ป่วยปฏิเสธ; ขณะนี้ severe SI ไม่มี plan, urgent need สำหรับ rapid intervention

No psychotic features, no substance use, no cardiovascular contraindications
BP 128/78';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue failed treatment"},{"label":"B","text":"Repetitive Transcranial Magnetic Stimulation (rTMS)"},{"label":"C","text":"ECT only"},{"label":"D","text":"No further treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Repetitive Transcranial Magnetic Stimulation (rTMS) — FDA approved 2008 TRD: (1) Mechanism: magnetic field induces electric current in left dorsolateral prefrontal cortex → modulate mood circuits; (2) Protocol: typically 5×/wk × 4-6 wk (20-30 sessions); each ~ 20-40 min; outpatient; no anesthesia; (3) Stimulation: high-frequency (10 Hz) left DLPFC excitatory; low-frequency right DLPFC inhibitory; iTBS (intermittent theta burst) accelerated protocol — 3 min sessions; (4) Response rate 30-40% TRD; remission 20-30%; less effective than ECT but better tolerated; (5) Side effects: scalp discomfort, headache (transient), rare seizure (0.1%); contraindications — seizure disorder, metallic head implants (cochlear, deep brain stimulator), recent MI; (6) Combine กับ antidepressant; (7) Maintenance protocols emerging; (8) Indications expanding: OCD (FDA approved 2018), smoking cessation, anxiety; (9) Advantages: no anesthesia, no cognitive side effects, continue daily activities; (10) Multidisciplinary: psychiatry, technician

---

rTMS: FDA approved 2008 TRD. Left DLPFC stimulation. Outpatient, no anesthesia, 4-6 wk. Response 30-40%, less than ECT but better tolerated. Side effects: scalp discomfort, rare seizure. Contraindications: seizure, metallic head implants. iTBS accelerated. Expanding indications (OCD).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 38 ปี moderate MDD × 1 ปี — failed 2 SSRI trials adequate dose/duration + CBT × 12 sessions; ผู้ป่วยกังวล side effects ของ medication เพิ่ม, ไม่ต้องการ ECT; ทำงานเต็มเวลา, ต้องการ outpatient option

No seizure history, no metallic implant in head, no recent MI';

update public.mcq_questions
set choices = '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"Bipolar II Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bipolar II Disorder (DSM-5: ≥ 1 hypomanic + ≥ 1 MDD episode; never met manic episode criteria): (1) Mood stabilizer first-line — lithium (effective + reduces suicide), lamotrigine (excellent for bipolar depression — first-line BP-II depression — slow titration to avoid SJS), quetiapine (FDA approved BP depression), lurasidone (FDA approved); (2) Avoid antidepressant monotherapy — risk of cycle acceleration + manic switch; ถ้าจำเป็น combine กับ mood stabilizer; (3) Acute hypomanic episode: usually no hospitalization; mood stabilizer + temporary sleep aid; (4) Depression dominates clinical picture ใน BP-II — focus on bipolar depression treatment; (5) Psychotherapy: CBT, IPSRT (sleep + social rhythm), family-focused; (6) Long-term maintenance essential; (7) Comorbidity: anxiety (40-50%), substance use, ADHD; (8) Suicide risk high (similar to BP-I); (9) Psychoeducation: recognize prodromes, sleep regulation, avoid triggers; (10) Pregnancy planning + medication management

---

Bipolar II: ≥ 1 hypomania (4 days, observable, non-impairing/hospitalizing) + ≥ 1 MDD. Mood stabilizer first-line — lamotrigine for BP depression, lithium, quetiapine, lurasidone. Avoid antidepressant monotherapy. Depression dominates. Long-term maintenance. Suicide risk high.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 29 ปี recurrent depressive episodes × 5 ปี — ก่อนหน้านี้รักษาด้วย SSRI หลายตัว; mother reports periods of '' more energy, productive, less sleep, sociable, talkative'' lasting 5-7 วัน × 3-4 ครั้งต่อปี — มี subjective feeling of being ''high'' but not impaired functionally

No hospitalization, no psychosis
No manic episodes met full criteria
DSM-5 hypomania criteria met (≥ 4 days, observable change)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue lithium"},{"label":"B","text":"Lithium Toxicity (Severe"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lithium Toxicity (Severe — level > 2.0, neurological signs) — EMERGENCY: (1) Discontinue lithium immediately + thiazide diuretic (HCTZ → reduced renal clearance → toxicity); (2) IV fluid resuscitation — normal saline aggressive (restore volume + renal perfusion + enhance excretion); avoid loop diuretics + further dehydration; (3) Hemodialysis indicated: - level > 4.0 regardless symptoms; - level > 2.5 + severe symptoms; - level > 2.5 + renal failure preventing clearance; - life-threatening symptoms; (4) Cardiac monitoring (arrhythmia, QT); neuro monitoring; (5) Avoid concomitant nephrotoxic + drugs that ↓ clearance (NSAIDs, ACE-I, ARB, thiazide); (6) Education: lithium narrow therapeutic index; dehydration, diet sodium, drug interactions, NSAID/ACE-I/thiazide; recognize early signs (tremor, GI, ataxia); (7) Once recovered, reassess maintenance — alternative mood stabilizer if recurrent toxicity; (8) Long-term effects: chronic toxicity → nephrogenic DI, CKD, hypothyroid, hyperparathyroid — monitor Cr, TSH, Ca; (9) Multidisciplinary: psychiatry, nephrology, ICU if severe

---

Lithium toxicity: narrow therapeutic index. Triggers: dehydration, diuretic (thiazide ↓ clearance), NSAID, ACE-I, low sodium. Manifest: GI + neuro (tremor → ataxia → confusion → seizure → coma). Treatment: stop lithium, IV saline, hemodialysis (level > 4.0 or severe). Monitor long-term renal, thyroid, parathyroid.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 35 ปี BP-I on lithium 900 mg/day × 5 ปี (stable) — เริ่มมี recent diarrhea + nausea × 3 วัน + tremor + ataxia + confusion + slurred speech

ก่อนหน้านี้ 2 สัปดาห์เริ่ม HCTZ for hypertension
V/S: BP 100/65, HR 100, mildly dehydrated
Lab: Na 135, K 3.4, Cr 1.5 (baseline 0.8), lithium level 2.4 mEq/L (therapeutic 0.6-1.2)
ECG: U waves, prolonged QT';

update public.mcq_questions
set choices = '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"MDD/BP Depression with Mixed Features (DSM-5"},{"label":"C","text":"Stimulant"},{"label":"D","text":"Discharge"},{"label":"E","text":"Observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD/BP Depression with Mixed Features (DSM-5: full episode of one pole + ≥ 3 sx opposite pole — high acuity): (1) Avoid antidepressant monotherapy — high risk of switching, cycle acceleration, suicide; (2) First-line: atypical antipsychotic with mixed features evidence — lurasidone (FDA approved BP depression including mixed), quetiapine, olanzapine; (3) Mood stabilizer — valproate, lithium (less data mixed than pure mania); lamotrigine may help; (4) Combination — mood stabilizer + atypical; (5) Safety: suicide risk very high (mixed features = highest suicide risk in mood disorders) — assess + hospitalize ถ้า needed; (6) Avoid stimulants; (7) Limit benzodiazepine to acute agitation; (8) Psychotherapy: CBT, IPSRT, family-focused; (9) ECT effective for severe mixed; (10) Comorbid substance use common; (11) Long-term: chronic course, frequent recurrences, maintenance essential

---

Mixed features specifier: full episode + ≥ 3 sx opposite pole. Highest suicide risk in mood disorders. AVOID antidepressant monotherapy. Atypical antipsychotic (lurasidone) + mood stabilizer. ECT for severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 30 ปี BP-I, ขณะนี้ depressed episode × 6 wk — but also มี racing thoughts, distractibility, decreased sleep need (but feel fatigued), agitation, irritability, suicidal ideation

MSE: dysphoric mood + psychomotor agitation + flight of ideas + irritability
Meets DSM-5 criteria for MDD episode + ≥ 3 manic sx — Mixed Features specifier';

update public.mcq_questions
set choices = '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"Cyclothymic Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cyclothymic Disorder (DSM-5: numerous hypomanic + depressive sx that don''t meet full criteria × ≥ 2 yr adults, ≥ 1 yr youth; no symptom-free period > 2 mo): (1) Mood stabilizer — lithium, valproate, lamotrigine; lower doses than BP-I อาจเพียงพอ; (2) Limited evidence base — extrapolated from BP-I/II; (3) Psychotherapy: CBT, IPSRT, psychoeducation — emphasize sleep + social rhythm regularity; (4) Avoid antidepressant monotherapy — switch risk + worsen cycling; (5) Long-term — 15-50% progress to full BP-I/II; monitor; (6) Comorbidity: substance use, anxiety, personality features; (7) Lifestyle: sleep regularity, avoid sleep deprivation/circadian disruption, limit substances, structured routine; (8) Education + family support

---

Cyclothymic Disorder: chronic mood instability × ≥ 2 yr (1 yr youth); subsyndromal hypomania + depression. Mood stabilizer (lithium, valproate, lamotrigine). Avoid antidepressant monotherapy. 15-50% progress to full BP. Psychoeducation + social rhythm.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 25 ปี × 3 ปี has had numerous periods of mild hypomanic-like symptoms (elevated mood, decreased sleep need, increased activity 3-4 วัน) สลับกับ mild depressive symptoms (low mood, fatigue, decreased interest 1-2 weeks) — no period of stability > 2 months

No episode meets full hypomania or MDD criteria
Functional impairment present
No substance use, normal TSH';

update public.mcq_questions
set choices = '[{"label":"A","text":"Brief course only"},{"label":"B","text":"Persistent Depressive Disorder (Dysthymia; DSM-5"},{"label":"C","text":"No treatment needed"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Depressive Disorder (Dysthymia; DSM-5: depressed mood most days × ≥ 2 yr + ≥ 2: appetite, sleep, energy, self-esteem, concentration, hopelessness): (1) Combination treatment best — psychotherapy + antidepressant > monotherapy (CBASP — Cognitive Behavioral Analysis System of Psychotherapy ออกแบบเฉพาะ chronic depression); (2) Antidepressant: SSRI first-line; SNRI, bupropion, mirtazapine alternatives; ตอบสนองช้ากว่า MDD episodic; (3) Psychotherapy: CBASP, CBT, IPT, psychodynamic; (4) Treatment duration extended — chronic course requires ongoing maintenance; (5) Address chronic interpersonal patterns + low self-esteem; (6) Comorbidity: MDD episodes superimposed (''double depression''), anxiety, personality disorders; (7) Lifestyle: exercise, sleep, social engagement; (8) Long-term outcomes: 50-70% improve with sustained treatment; without treatment chronic + impairing

---

Persistent Depressive Disorder (formerly dysthymia + chronic MDD): ≥ 2 yr depressed mood + 2 sx. Combination therapy best — CBASP designed for chronic depression. Long-term maintenance. Double depression common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 40 ปี — depressed mood '' most of the day, more days than not'' × 4 ปี — fatigue, low self-esteem, poor concentration, hopelessness, hyperphagia, low energy; functional but suboptimal

No discrete MDD episode meeting criteria
No hypomania/mania
PHQ-9: 12 (moderate)
No substance use';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Premenstrual Dysphoric Disorder (PMDD; DSM-5"},{"label":"C","text":"Lithium only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Premenstrual Dysphoric Disorder (PMDD; DSM-5: severe luteal phase mood + behavioral symptoms × most cycles past year, confirmed prospectively, functional impairment): (1) SSRI first-line — fluoxetine, sertraline, paroxetine, escitalopram; FDA approved; (2) Dosing options: - continuous daily; - luteal phase only (14 days before menses to onset of menses) — works for PMDD because rapid onset on serotonin system; - symptom-onset only (start when sx begin); (3) Oral contraceptive containing drospirenone (Yaz) — FDA approved PMDD; alternatives — continuous OCP suppress cycle; (4) GnRH agonist (severe refractory) with add-back hormonal therapy; (5) CBT + lifestyle (exercise, stress reduction, sleep, limit caffeine + alcohol, calcium supplementation moderate evidence); (6) Avoid: alprazolam (limited evidence + dependence risk); diuretics for bloating only; (7) Multidisciplinary: psychiatry, OB-GYN, primary care; (8) Distinguish from premenstrual syndrome (PMS — milder) + premenstrual exacerbation of underlying disorder

---

PMDD: severe luteal-phase mood + behavioral sx + impairment, confirmed prospectively. SSRI first-line (rapid onset luteal). Drospirenone OCP FDA approved. CBT + lifestyle. Distinguish from PMS + premenstrual exacerbation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 32 ปี × 12 เดือน — severe mood symptoms (irritability, anger, mood lability, depression, anxiety) เริ่ม 7-10 วันก่อนประจำเดือน + หาย 1-3 วันหลังเริ่มประจำเดือน — disrupts work + relationships

Prospective daily mood charting × 3 cycles confirms cyclic pattern
No other psychiatric disorder, no medical cause';

update public.mcq_questions
set choices = '[{"label":"A","text":"Mood stabilizer (lithium/valproate) first-line"},{"label":"B","text":"Disruptive Mood Dysregulation Disorder (DMDD; DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Punishment focus"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disruptive Mood Dysregulation Disorder (DMDD; DSM-5: severe recurrent temper outbursts ≥ 3×/wk + persistent irritable mood between outbursts × ≥ 12 mo, in ≥ 2 settings, onset 6-10 yo, dx 6-18 yo — to avoid overdiagnosis of pediatric bipolar): (1) Parent training in behavior management — first-line for irritability + outbursts; (2) CBT — emotion regulation, problem-solving, anger management; DBT for adolescents adapted; (3) Family therapy + family education; (4) School-based intervention + IEP/504; (5) Medication when severe + functional impairment + behavioral failed: - Stimulants for comorbid ADHD (very common); - SSRI for comorbid depression/anxiety; - Atypical antipsychotic (risperidone, aripiprazole) for severe aggression (last-line, side effects monitoring); - Avoid mood stabilizers without bipolar diagnosis; (6) Comorbidity common: ADHD, ODD, anxiety, depression; (7) Long-term: DMDD predicts adult depression + anxiety (NOT bipolar — important distinction from prior ''pediatric bipolar'' overdiagnosis); (8) Multidisciplinary: child psychiatry, behavioral therapist, school personnel, family

---

DMDD: chronic irritability + severe temper outbursts in children — DSM-5 added to prevent overdiagnosis pediatric bipolar. Behavioral parent training + CBT first-line. SSRI/stimulants for comorbidity. NOT bipolar — predicts adult depression/anxiety.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 9 ปี — severe recurrent temper outbursts (verbal + physical), out of proportion to provocation, ≥ 3×/wk × 18 เดือน + persistent irritable/angry mood between outbursts (''grumpy all the time'') — at home + school + with peers

Onset age 7 ปี
Developmental hx normal, no trauma history
No manic/hypomanic episodes — irritability is chronic, not episodic';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — wait for spring"},{"label":"B","text":"Seasonal Affective Disorder (MDD with seasonal pattern; DSM-5 specifier"},{"label":"C","text":"TCA only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Seasonal Affective Disorder (MDD with seasonal pattern; DSM-5 specifier — temporal relationship × ≥ 2 yr): (1) Bright Light Therapy — first-line: - 10,000 lux × 30 min, morning, daily; - 2,500 lux × 2 hr alternative; - start fall, continue through winter; effect within 1-2 wk; - side effects: eye strain, headache, agitation/hypomania risk in BP; (2) SSRI — fluoxetine FDA approved seasonal; sertraline, escitalopram alternatives; (3) Bupropion XL — FDA approved prevention SAD; start before season; (4) CBT-SAD — specifically adapted; effective + prevents recurrence; (5) Combination — light + medication for severe; (6) Lifestyle: morning outdoor light exposure, exercise, sleep hygiene, vitamin D supplementation moderate evidence; (7) Bipolar specifier — seasonal pattern in BP common — careful with light + antidepressant (switch risk); (8) Prevention: start treatment before symptom onset (autumn); (9) Atypical features common (hypersomnia, hyperphagia); (10) Subsyndromal ''winter blues'' more common than full SAD

---

Seasonal Affective Disorder: MDD with seasonal pattern × ≥ 2 yr. Bright light therapy (10,000 lux × 30 min AM) first-line. Bupropion XL FDA approved prevention. SSRI also. CBT-SAD effective. Start before season. Bipolar caution (switch).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 35 ปี ย้ายไป Sweden ทำงาน — recurrent depressive episodes ในฤดูหนาว (Oct-March) × 3 ปี ติดต่อกัน, full remission ฤดูร้อน; hypersomnia, hyperphagia (carbohydrate craving), weight gain, low energy

ก่อนย้ายไม่มี depression
ไม่มี non-seasonal episodes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term benzodiazepine monotherapy"},{"label":"B","text":"Generalized Anxiety Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Generalized Anxiety Disorder (DSM-5: excessive worry ≥ 6 mo + ≥ 3 sx + impairment): (1) CBT first-line — effective, durable, cognitive restructuring + exposure to uncertainty + relaxation + behavioral activation; (2) Medication first-line — SSRI (escitalopram, sertraline, paroxetine) or SNRI (venlafaxine XR, duloxetine); start low + titrate; full effect 4-6 wk; (3) Buspirone — alternative, no abuse potential, slower onset; (4) Pregabalin — effective + faster onset (Europe approved); (5) Avoid benzodiazepines long-term (tolerance, dependence, cognitive); short-term bridging acceptable; (6) Combination CBT + medication for moderate-severe; (7) Lifestyle: caffeine reduction, exercise, sleep hygiene, mindfulness, limit alcohol; (8) Comorbidity common: depression (60%), other anxiety, substance use; (9) Long-term — chronic illness; relapse common when treatment stopped; continue ≥ 12 mo after remission; (10) Multidisciplinary: primary care, psychiatry, therapist

---

GAD: excessive worry ≥ 6 mo + ≥ 3 sx. CBT + SSRI/SNRI first-line. Buspirone alternative. AVOID long-term benzodiazepine. Combination most effective. Chronic course — long-term treatment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 40 ปี — excessive worry about multiple domains (family, work, finances, health) × 8 เดือน — difficult to control + restlessness, fatigue, difficulty concentrating, irritability, muscle tension, sleep disturbance

GAD-7: 16 (severe)
No panic attacks, no specific phobia
Medical workup negative
No substance use, no caffeine excess';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid all social activity"},{"label":"B","text":"Social Anxiety Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine monotherapy"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Social Anxiety Disorder (DSM-5: marked fear of social situations + avoidance + > 6 mo + impairment): (1) CBT with exposure first-line — graded exposure to feared social situations + cognitive restructuring; group CBT particularly effective (provides exposure); (2) SSRI first-line medication (paroxetine, sertraline, escitalopram, fluvoxamine — FDA approved); SNRI alternative (venlafaxine); (3) Combination CBT + SSRI for severe + chronic; (4) Performance-only subtype: beta-blocker (propranolol 10-40mg) PRN before performance — blocks autonomic sx; or short-acting benzodiazepine PRN (limited use, abuse potential); (5) Address alcohol use — self-medication common, AUD comorbidity high — treat both; (6) Avoid benzodiazepine long-term; (7) Long-term: chronic without treatment, often onset adolescence; (8) Comorbidity: depression, other anxiety, AUD; (9) Subtypes: generalized (more impairing) vs performance-only; (10) Multidisciplinary

---

Social Anxiety: marked fear of scrutiny > 6 mo. CBT with exposure + SSRI first-line. Beta-blocker PRN for performance subtype. Address comorbid AUD (common self-medication). AVOID long-term benzodiazepine.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 24 ปี — intense fear of social situations + scrutiny × 6 ปี — avoidance of public speaking, meeting new people, eating in public; physical sx (blushing, sweating, trembling); impairs career advancement; ดื่ม alcohol ก่อน social events เพื่อช่วย

LSAS score 85 (severe)
No psychotic features, recognizes fear excessive
UDS negative drugs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid all procedures"},{"label":"B","text":"Specific Phobia, Blood-Injection-Injury Type (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Specific Phobia, Blood-Injection-Injury Type (DSM-5: marked fear of specific stimulus + avoidance + > 6 mo + impairment): (1) Exposure therapy first-line — gold standard, durable; graded exposure to feared stimulus (e.g., needles in this case) + virtual reality emerging; single-session exposure can be effective; (2) Blood-Injection-Injury subtype unique — biphasic vasovagal response (initial sympathetic then drop → syncope); (3) Applied Tension Technique — specific to BII phobia: tense muscles → maintain BP → prevent syncope during exposure/procedure; (4) Cognitive restructuring + relaxation adjunct; (5) Medication usually NOT first-line for specific phobia — limited evidence; benzodiazepine for procedure if exposure not feasible (one-time); SSRI for severe/comorbid; (6) Pregnancy considerations — needs prenatal care; coordinate with OB + exposure therapist; (7) Self-help + apps for mild; (8) Multidisciplinary if comorbidity

---

Specific Phobia: exposure therapy first-line. BII subtype: biphasic vasovagal — use Applied Tension Technique (tense muscles → maintain BP). Single-session exposure effective. Medication limited role. Pregnancy needs coordinated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 28 ปี กลัวการเจาะเลือด/เข็มฉีดยา ตั้งแต่เด็ก — บริจาคเลือดไม่ได้, หลีกเลี่ยง medical care, เคยเป็นลม (vasovagal) เมื่อเห็นเลือด; ตอนนี้ตั้งครรภ์ + ต้อง prenatal blood draws

MSE: alert, oriented, no other psychiatric symptoms
Functional in other areas';

update public.mcq_questions
set choices = '[{"label":"A","text":"Permanent home schooling"},{"label":"B","text":"Separation Anxiety Disorder (DSM-5"},{"label":"C","text":"Adult-style benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Separation Anxiety Disorder (DSM-5 — moved from peds-only to applies all ages; ≥ 4 wk children, ≥ 6 mo adults): (1) CBT for childhood anxiety first-line — Coping Cat program, parent involvement, exposure to graded separations; (2) Parent training — reduce accommodation behaviors (parents'' avoidance reinforces); reward brave behaviors; (3) School re-entry plan — gradual return, supportive school counselor, address school avoidance — earlier return better outcomes (school refusal becomes harder with time); (4) SSRI if severe + CBT inadequate — sertraline, fluoxetine, fluvoxamine (effective for childhood anxiety per CAMS trial); SSRI + CBT combination most effective; (5) Address comorbidity: other anxiety disorders, depression, learning issues; (6) Family therapy + parent psychoeducation; (7) Rule out: medical causes of somatic sx, bullying at school, learning disorder, trauma; (8) Long-term: SAD predicts adult anxiety; early intervention important; (9) Multidisciplinary: child psychiatry, therapist, pediatrician, school personnel

---

Separation Anxiety Disorder: CBT first-line (Coping Cat). Parent training to reduce accommodation. Gradual school re-entry. SSRI for severe (CAMS — combination best). Early return to school. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กหญิงอายุ 7 ปี เริ่มไม่ยอมไปโรงเรียน × 3 เดือน — กลัวว่า mother จะหายไปหรือมีอันตราย, ฝันร้าย, somatic complaints (stomach ache, headache) ทุกเช้าก่อนไป รร., refuses sleepover, ติดแม่ตลอด, attended school normally ก่อนหน้านี้

No trauma, no recent separation
Developmental hx normal, school performance was good';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force child to speak"},{"label":"B","text":"Selective Mutism (DSM-5"},{"label":"C","text":"Punishment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Selective Mutism (DSM-5 — anxiety disorder; failure to speak in specific social situations despite speaking in others, > 1 mo, not just first month of school, not language disorder): (1) Behavioral therapy first-line — exposure-based, stimulus fading (gradually introduce people child can speak in front of), shaping (reward approximations of speech), positive reinforcement; (2) Parent + school collaboration — consistent approach, reduce pressure, accept gestures initially then shape; (3) SSRI (fluoxetine, sertraline) for moderate-severe or treatment-resistant — significant evidence base; combines with behavioral; (4) Avoid: forcing child to speak, punishment, labeling as ''stubborn'', special attention to silence; (5) School interventions: small group integration, supportive teachers, gradual exposure to speaking situations; (6) Distinguish from: shyness (normal), language disorder, ASD, hearing impairment, trauma (mutism after trauma); (7) Multilingual children — higher prevalence + need to assess in both languages; (8) Multidisciplinary: child psychiatry, behavioral therapist, school personnel, speech-language pathologist; (9) Long-term: most improve with treatment; untreated predicts adult anxiety

---

Selective Mutism: anxiety disorder (DSM-5). Behavioral exposure-based + parent/school collaboration first-line. SSRI for moderate-severe (fluoxetine evidence). Multilingual children higher prevalence. Avoid forcing/punishment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กหญิงอายุ 5 ปี พูดได้ปกติที่บ้านกับ family แต่ไม่พูดเลยที่ รร. × 18 เดือน — ไม่พูดกับ teacher, peers, ในที่สาธารณะ; ใช้ gesture หรือ point; understanding ภาษาปกติ; bilingual (ไทย + Mandarin)

Developmental hx normal
No trauma
No hearing/speech disorder
Met criteria > 1 mo (not first month of school)';

commit;
