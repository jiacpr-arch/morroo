-- ===============================================================
-- UPDATE chunk 4/8: psychiatry (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Cold turkey without support"},{"label":"B","text":"First-line pharmacotherapy"},{"label":"C","text":"E-cigarettes as long-term replacement"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tobacco Use Disorder — Comprehensive Smoking Cessation: (1) Combination behavioral + pharmacotherapy = most effective; (2) **First-line pharmacotherapy** (FDA approved): - **Varenicline** (Chantix) — partial agonist α4β2 nicotinic; most effective single agent; start 1 wk before quit date, titrate to 1mg BID × 12 wk (extend if needed); side effects: nausea, vivid dreams, sleep disturbance, neuropsychiatric warning removed (EAGLES trial reassured); reduces craving + reduces reward; - **Nicotine Replacement Therapy (NRT)** — patch + short-acting (gum, lozenge, inhaler, nasal spray) combination superior to single; safe in most CV disease; can start before quit date; - **Bupropion SR** — dopaminergic + noradrenergic; effective; reduces craving + weight gain; AVOID seizure history, eating disorders; (3) Combination — varenicline + NRT OR varenicline + bupropion = superior to single (some studies); (4) **Behavioral first-line**: - Brief counseling at every healthcare visit (5As: Ask, Advise, Assess, Assist, Arrange); - Quitlines (1-800-QUIT-NOW), text messaging programs (SmokefreeTXT), apps, web programs; - Group counseling, individual; - Motivational interviewing; (5) Address triggers + replacements + coping; (6) Treatment duration ≥ 12 weeks; extended (6 mo) reduces relapse; (7) **Special populations**: - Pregnancy — NRT cautiously (preferred over smoking); behavioral primary; - Psychiatric — varenicline safe per EAGLES; address depression + anxiety; high smoking rates in mental illness (50-90%); - Adolescents — behavioral + cautious NRT; (8) Address e-cigarettes / vaping — not approved smoking cessation; harm reduction debate; nicotine-containing; respiratory effects; (9) Comorbidity: CV disease, COPD, cancer screening; (10) Multidisciplinary: primary care, pulmonology, psychiatry if comorbid

---

Tobacco Use Disorder: combination behavioral + pharmacotherapy most effective. Varenicline most effective single agent (EAGLES safety reassured). NRT combination (patch + short-acting). Bupropion. Counseling at every visit (5As). Special: pregnancy, psychiatric (high comorbid), adolescent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 45 ปี smokes 1.5 packs/day × 25 ปี — ต้องการเลิก, prior attempts failed (relapsed within weeks); morning craving + craving with coffee + after meals strong; HSI score high; comorbid HTN, beginning COPD; ไม่มี active psychiatric disorder

Motivated, family support, no contraindications';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Inhalant Use Disorder"},{"label":"C","text":"Catecholamines for cardiac arrest"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Inhalant Use Disorder — High Morbidity + Mortality (Sudden Sniffing Death — cardiac arrhythmia; multi-organ toxicity): (1) Acute: monitor cardiac (arrhythmia — sensitization to catecholamines), respiratory, neurological (encephalopathy), hepatic, renal; supportive; (2) AVOID catecholamines (epinephrine sensitization with inhalants → arrhythmia) — use beta-blocker for arrhythmia in this setting (atypical from cocaine context); (3) NO FDA-approved medication; (4) Behavioral first-line: family-based + CBT + school + community intervention; address access; (5) Comorbidity: conduct disorder, ADHD, depression, substance use, trauma, low SES; (6) Long-term toxicity: leukoencephalopathy (white matter — toluene), peripheral neuropathy, cerebellar dysfunction, hepatorenal, hearing loss, bone marrow (benzene); (7) Adolescent + pediatric population predominantly; access (household products); (8) Education + prevention essential — community-level intervention; (9) Family + social work involvement; (10) Multidisciplinary: pediatrics, psychiatry, neurology, social work, school personnel; (11) Mortality reduction through harm reduction + abstinence

---

Inhalant Use Disorder: ''huffing'' — Sudden Sniffing Death (arrhythmia). AVOID catecholamines (sensitization). Multi-organ toxicity (CNS leukoencephalopathy, hepatorenal). NO FDA medication. Adolescent — family + school + community. Address access.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'วัยรุ่นชายอายุ 14 ปี — มา ED ด้วย sudden cardiac arrest at gathering; resuscitated; admits inhaling toluene from spray cans ''huffing'' × past year; school problems, low SES, easy access to inhalants

Lab: hepatic enzymes elevated, mild renal dysfunction, anion gap metabolic acidosis
Mother concerned';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment alone"},{"label":"B","text":"Antisocial Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Cure with single intervention"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antisocial Personality Disorder (DSM-5: pervasive disregard for + violation of rights of others since age 15 + ≥ 3 of 7 criteria + conduct disorder before age 15 + age ≥ 18 + not solely during schizophrenia/BP): (1) Challenging to treat — limited evidence + low treatment engagement; (2) Approach realistic expectations + boundaries; (3) Treat comorbidity: substance use disorder (very high comorbid — focus often more productive), depression, anxiety; (4) Psychotherapy: - CBT for specific behaviors (anger management, impulse control); - Schema-focused therapy + MBT studied; - Therapeutic communities; - Avoid expectation of full personality change; - Focus on behavioral outcomes (reduced violence, substance use, employment); (5) Medication targets specific symptoms — no medication for ASPD itself: - SSRI for impulsivity, aggression (moderate); - Mood stabilizer for aggression; - Atypical antipsychotic for severe aggression; - AVOID benzodiazepine + stimulants (disinhibition + abuse); (6) Forensic considerations — legal involvement common; competency, sentencing, supervision; assess violence risk (HCR-20, VRAG); (7) Distinguish: - Conduct disorder (< 18); - Psychopathy (overlap, Hare PCL-R, more severe); - Narcissistic PD (lacks ASPD childhood conduct disorder); - Substance-induced (resolves with sobriety); (8) Long-term: chronic; some ''burnout'' with age — reduced criminality after 40s; (9) Multidisciplinary including criminal justice + family + employment; (10) Provider safety + self-care — engagement can be exhausting

---

Antisocial PD: pervasive violation of rights + childhood conduct disorder. Treat comorbid substance use (often more productive). CBT for specific behaviors. Medication targets symptoms (no medication for ASPD itself). AVOID BZD + stimulants. Forensic risk assessment. Realistic expectations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 28 ปี nyu admitted ระหว่าง legal proceedings for assault — history of multiple arrests since age 16, repeated lying, irresponsible (frequently fired), aggressive (multiple fights), reckless (DUI × 3), no remorse for harm caused — childhood: conduct disorder before 15 yo

No psychosis, no mood disorder; substance use comorbid (alcohol, cocaine)
DSM-5 ASPD criteria met';

update public.mcq_questions
set choices = '[{"label":"A","text":"Confront grandiosity directly"},{"label":"B","text":"Narcissistic Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Narcissistic Personality Disorder (DSM-5: pervasive grandiosity + need for admiration + lack of empathy + ≥ 5/9 criteria): (1) Treatment engagement often poor (denial, externalization); (2) Address presenting concern (depression here) — entry point + alliance; (3) Psychotherapy long-term: - Psychodynamic (Kohut Self-Psychology, Kernberg, TFP — Transference-Focused Psychotherapy); - Schema-focused; - CBT for specific symptoms; - Mentalization-Based Treatment (MBT); - Therapeutic alliance challenging — narcissistic injury common; (4) Address: relationship pattern, work issues, anger management, empathy development, vulnerability tolerance; (5) Subtypes: - **Grandiose** (overt, exhibitionist — classical); - **Vulnerable** (covert, hypersensitive, depression, shame-prone) — more common presentation in clinical setting; (6) Comorbidity: depression (especially with life setbacks, narcissistic injury), substance use, anxiety, other PDs; (7) Medication: target symptoms (SSRI for depression, anxiety); no medication for NPD itself; (8) Suicide risk — narcissistic injury + depression elevated; (9) Couples/family therapy often helpful — relationship dimension prominent; (10) Long-term — chronic, gradual change possible; some improvement with age + maturation; (11) Provider self-awareness — countertransference (idealization → devaluation cycle)

---

Narcissistic PD: grandiosity + need for admiration + lack of empathy. Engagement through presenting concern. Long-term psychotherapy (Kohut, Kernberg, TFP, schema). Grandiose vs vulnerable subtypes. Suicide risk with injury. No specific medication. Countertransference common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 45 ปี executive — มา OPD ตาม spouse''s insistence; pattern × decades — grandiosity, need for admiration, lack of empathy, sense of entitlement, exploits relationships for own gain, envy + believes others envy him, arrogant; recent failures + marriage in crisis triggered moderate depression (PHQ-9 14)

No psychosis, no manic episodes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Forced exposure without preparation"},{"label":"B","text":"Avoidant Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Avoidant Personality Disorder (DSM-5: pervasive social inhibition + feelings of inadequacy + hypersensitivity to negative evaluation + ≥ 4/7 criteria): (1) CBT first-line — graded exposure to feared situations (similar to social anxiety), cognitive restructuring of self-views + others'' judgments, behavioral activation, social skills training; (2) Group therapy provides natural exposure; (3) Schema-focused therapy + Dialectical Behavior Therapy adaptations; (4) Mentalization-Based Treatment; (5) SSRI for comorbid social anxiety + depression — common overlap with social anxiety disorder (high; conceptual debate whether separate or severe end of social anxiety spectrum); (6) Comorbidity: social anxiety (very high overlap), depression, other anxiety, substance use; (7) Long-term — chronic; CBT shows durable improvement; (8) Distinguish from: - Social anxiety disorder (overlapping, perhaps continuum); - Schizoid PD (no desire for relationships vs avoidant desires but avoids due to fear); - Dependent PD (clings to relationships); (9) Therapeutic alliance carefully — sensitivity to perceived criticism; (10) Multidisciplinary

---

Avoidant PD: social inhibition + inadequacy + hypersensitivity to evaluation. CBT (graded exposure + cognitive restructuring) first-line. SSRI for comorbid social anxiety. Overlap with social anxiety. Distinguish from schizoid (no desire) + dependent (clings).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 30 ปี × lifelong — avoids social/occupational activities requiring interpersonal contact, unwilling to engage unless certain of being liked, restraint in intimate relationships, preoccupied with criticism + rejection, views self as socially inept, reluctant to take risks; functional but limited socially + occupationally — entry-level job, no close friends, single

No MDD/psychosis acute
Longstanding pattern since teenage
Attended counseling reluctantly';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue current dependence"},{"label":"B","text":"Dependent Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dependent Personality Disorder (DSM-5: pervasive + excessive need to be taken care of → submissive + clinging + fears of separation; ≥ 5/8 criteria): (1) Psychotherapy — CBT, psychodynamic, schema-focused — focus on assertiveness training, independent decision-making, building self-efficacy, identifying own preferences/values, healthy relationships; (2) Address abusive relationship — safety planning (separate issue beyond PD), domestic violence resources, gradual empowerment (often complex — patient may resist leaving abuser she depends on); (3) Group therapy provides interpersonal feedback; (4) SSRI for comorbid depression, anxiety, panic (common); (5) Comorbidity: depression, anxiety, somatic, other PDs (especially borderline, avoidant, histrionic); (6) Long-term — chronic; gradual improvement with sustained treatment; (7) Distinguish from: avoidant PD (avoids relationships due to fear vs dependent seeks them desperately), borderline PD (unstable relationships vs dependent clings), histrionic PD (attention-seeking vs nurturance-seeking); (8) Therapeutic relationship — risk of patient becoming dependent on therapist — encourage autonomy; (9) Cultural sensitivity — some interdependence is cultural norm, distinguish pathology; (10) Multidisciplinary including DV resources if applicable

---

Dependent PD: excessive need to be cared for + submissive + clinging + fear of separation. Psychotherapy — assertiveness training, decision-making, self-efficacy. Address abusive relationship (DV resources). SSRI for comorbid depression. Cultural sensitivity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 35 ปี — pattern × adulthood — difficulty making everyday decisions without excessive advice, needs others to assume responsibility, difficulty expressing disagreement, difficulty initiating projects alone, goes to excessive lengths to obtain nurturance/support, feels helpless when alone, urgently seeks new relationship when one ends; in abusive relationship × 10 ปี, cannot leave

MSE: depressed mood, low self-esteem';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat as OCD with SSRI high dose + ERP"},{"label":"B","text":"Obsessive-Compulsive Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Obsessive-Compulsive Personality Disorder (DSM-5: pervasive preoccupation with orderliness, perfectionism, mental + interpersonal control at expense of flexibility, openness, efficiency; ≥ 4/8 criteria): (1) Distinct from OCD — OCPD is ego-syntonic (patient sees traits as desirable), no specific obsessions/compulsions; OCD ego-dystonic; ~ 20% comorbidity; (2) Psychotherapy: - CBT for specific issues (perfectionism, rigidity, procrastination from over-planning, work-life balance); - Psychodynamic; - Schema-focused; - Address rigidity in relationships, control issues, emotional expression; (3) Couples/family therapy — relational issues prominent; (4) Address comorbid depression (anhedonia, exhaustion from over-conscientiousness); (5) SSRI for comorbid depression/anxiety; (6) Long-term — relatively stable; high functioning often (especially in structured work — may be adaptive in some careers); (7) Distinguish: - OCD (egodystonic, obsessions/compulsions); - Narcissistic PD (entitlement vs OCPD duty-bound); - Autism (social communication deficits); (8) Approach therapeutically — patient often comes for relationship/depression rather than personality complaint; engage gradually with traits; (9) Modern view — perfectionism + control are functional in some contexts, dysfunctional when excessive; help develop flexibility

---

OCPD: pervasive perfectionism + rigidity + control. Ego-syntonic (distinct from OCD ego-dystonic). Psychotherapy + address comorbid depression. Couples therapy. Often high-functioning. SSRI for comorbid only. Distinguish from OCD, narcissistic, autism.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 50 ปี high-functioning accountant — มา OPD ด้วย work stress + marital issues; pattern × decades — preoccupied with details/rules/lists, perfectionism interferes with task completion, overly conscientious + scrupulous, unable to discard worn-out objects, reluctance to delegate, miserly, rigid + stubborn — distinct from OCD (no obsessions/compulsions, ego-syntonic)

No true obsessions/compulsions
No significant depression/anxiety currently';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose typical antipsychotic"},{"label":"B","text":"Schizotypal Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizotypal Personality Disorder (DSM-5: pervasive social + interpersonal deficits + cognitive/perceptual distortions + eccentricities; ≥ 5/9 criteria; Cluster A): (1) Considered schizophrenia-spectrum — genetically related; (2) Psychotherapy: - Supportive + social skills training; - CBT for specific symptoms (paranoid ideation, social anxiety); - Avoid intense psychodynamic exploration (may worsen psychotic-like sx); (3) Low-dose atypical antipsychotic (risperidone, aripiprazole) for cognitive-perceptual sx + helps anxiety + social functioning; modest evidence; (4) SSRI for comorbid anxiety + depression — common; (5) Address comorbidity: depression, anxiety, substance use, other PDs (paranoid, schizoid); (6) Distinguish: - Schizophrenia (full psychotic episodes); - Paranoid PD (pervasive distrust but less cognitive/perceptual); - Schizoid PD (lacks interest in relationships, no cognitive/perceptual distortions); - Autism spectrum (social communication deficits, restricted interests vs schizotypal odd beliefs); (7) Long-term — chronic; ~ 25% develop schizophrenia; longitudinal monitoring; (8) Family involvement (genetic counseling, education); (9) Multidisciplinary

---

Schizotypal PD: pervasive social deficit + cognitive-perceptual distortions + eccentricities (Cluster A, schizophrenia-spectrum). Low-dose atypical antipsychotic + SSRI + supportive therapy. ~ 25% develop schizophrenia. Distinguish from schizophrenia, paranoid, schizoid PD, autism.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 38 ปี — chronic — odd beliefs/magical thinking (interprets coincidences as personal signs), unusual perceptual experiences (sees aura around people occasionally), suspicious + mild paranoid ideation, odd speech (vague, circumstantial), constricted affect, no close friends, social anxiety not improving — but no full psychotic episodes

Family hx: brother with schizophrenia
Functional but isolated';

update public.mcq_questions
set choices = '[{"label":"A","text":"Confront paranoid interpretations"},{"label":"B","text":"Paranoid Personality Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paranoid Personality Disorder (DSM-5: pervasive distrust + suspiciousness + interpret others'' motives as malevolent; ≥ 4/7 criteria; Cluster A): (1) Treatment engagement challenging — distrust extends to providers; (2) Psychotherapy — supportive + collaborative; reliable + predictable + transparent approach; NEVER confront paranoid interpretations directly (alliance rupture); explore evidence gently with cognitive techniques; (3) Build alliance gradually; (4) Address presenting concerns (relationship issues, work conflict, depression); (5) Medication targets symptoms — SSRI for comorbid depression/anxiety; low-dose atypical antipsychotic for severe paranoid sx without psychosis (limited evidence); (6) AVOID benzodiazepine (disinhibition possible); (7) Comorbidity: depression, anxiety, substance use, other PDs (schizotypal, schizoid, narcissistic, avoidant); (8) Distinguish: - Schizophrenia paranoid type (psychosis, hallucinations, delusions); - Delusional disorder (specific delusion); - Schizotypal PD (cognitive/perceptual distortions); - Antisocial PD (different pattern); (9) Long-term — chronic + stable; gradual improvement with sustained therapy; (10) Provider self-awareness — distrust pattern may evoke defensiveness — maintain professional consistency

---

Paranoid PD: pervasive distrust + suspiciousness (Cluster A). Supportive + collaborative approach; NEVER confront directly. SSRI for comorbid. Build alliance gradually. AVOID BZD. Distinguish from psychosis (no hallucinations/delusions) + schizotypal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 50 ปี — lifelong pattern of distrust + suspiciousness of others — interprets benign motives as malicious, doubts loyalty of friends/family, reluctant to confide (fears used against him), holds grudges, perceives attacks on character + reacts angrily; no psychotic episodes, no formal delusions; intact reality testing

No substance use, no other psychiatric
MSE: guarded, suspicious of interviewer; otherwise oriented + logical';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force social engagement"},{"label":"B","text":"Schizoid Personality Disorder (DSM-5"},{"label":"C","text":"Long-term antipsychotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizoid Personality Disorder (DSM-5: pervasive detachment from social relationships + restricted range of emotional expression; ≥ 4/7 criteria; Cluster A): (1) Treatment often not sought — patient may not see problem (ego-syntonic); reason for referral usually work/family concern; (2) Respect patient''s preferred level of social engagement — pathologizing introversion is wrong; only intervene if functional impairment + patient distress; (3) Psychotherapy if engaged — supportive, gradual social skills exploration if patient wants; do not force social engagement against preference; (4) Address comorbidity if present (rare): depression, anxiety; (5) Medication targets specific symptoms; no medication for schizoid PD itself; (6) Distinguish: - Avoidant PD (DESIRES relationships but avoids due to fear vs schizoid lacks desire); - Schizotypal PD (cognitive/perceptual distortions); - Autism (social communication deficits, restricted interests vs schizoid emotional detachment without intent); - Normal introversion (preference vs pervasive impairment); (7) Long-term — chronic + stable pattern; (8) Modern: emphasize quality of life by patient''s own values; don''t pathologize introversion; (9) If work requires more interaction — career counseling; (10) Family education + support

---

Schizoid PD: pervasive detachment + restricted emotion (Cluster A). Often ego-syntonic, treatment limited. Respect preference; distinguish from introversion. Distinguish from avoidant (desires relationships), schizotypal (cognitive distortions), autism. No specific medication.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 40 ปี IT — มาเมื่อ employer ส่ง เนื่องจากกังวล social withdrawal — lifelong pattern of detachment from relationships, prefers solitary activities, little interest in close relationships (including family), no sexual experiences (no desire), takes pleasure in few activities, appears emotionally cold + indifferent to praise/criticism; high-functioning in independent work

No psychotic features, no cognitive/perceptual distortions
No depression/anxiety';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reinforce attention-seeking"},{"label":"B","text":"Histrionic Personality Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Histrionic Personality Disorder (DSM-5: pervasive + excessive emotionality + attention seeking; ≥ 5/8 criteria; Cluster B): (1) Psychotherapy — psychodynamic (insight into use of dramatic display, dependency), CBT (skills, more meaningful self-presentation), supportive; (2) Group therapy — interpersonal feedback; (3) Address comorbidity: depression (high — narcissistic injury, abandonment), substance use, somatic, conversion sx; (4) SSRI for comorbid depression/anxiety; (5) Therapeutic alliance — patient may seek therapist approval/attention — maintain professional boundaries; (6) Address dependency on others'' attention; develop more genuine connections + self-worth not contingent on attention; (7) Distinguish: - Borderline PD (abandonment fear, identity disturbance, self-harm — overlap exists); - Narcissistic PD (grandiosity + entitlement vs histrionic centrality + attention); - Dependent PD (clings for nurturance); - Antisocial PD (manipulative for gain vs histrionic for attention); (8) Long-term — chronic; some improvement with age; (9) Cultural + gender considerations — emotional expression varies; avoid gender bias in diagnosis; (10) Multidisciplinary; (11) Modern: DSM-5 emphasizes dimensional view — overlap with borderline frequently

---

Histrionic PD: excessive emotionality + attention-seeking (Cluster B). Psychotherapy (psychodynamic, CBT, supportive). Address comorbid depression. SSRI for comorbidity. Distinguish from borderline (overlap), narcissistic, dependent. Cultural + gender considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 32 ปี actress — มา OPD ด้วย depressed mood หลัง breakup; pattern × adulthood — uncomfortable when not center of attention, sexually provocative/seductive interactions, rapidly shifting + shallow emotions, uses physical appearance to draw attention, impressionistic speech style (vague), theatrical + exaggerated emotional expression, suggestible, considers relationships more intimate than they are

MSE: dramatic, flirtatious with interviewer, tearful then laughing quickly';

update public.mcq_questions
set choices = '[{"label":"A","text":"Beta-blocker monotherapy"},{"label":"B","text":"Thiamine 100mg IV BEFORE glucose"},{"label":"C","text":"Phenytoin for seizure prophylaxis"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol Withdrawal — Severe with Delirium Tremens (mortality 5-15% if untreated) — EMERGENCY: (1) ICU monitoring — autonomic instability, seizure, arrhythmia, electrolyte; (2) **Benzodiazepine** — backbone of treatment: - Symptom-triggered (CIWA-Ar based — better outcomes vs fixed schedule); - Diazepam or chlordiazepoxide (long-acting — auto-taper) preferred; - Lorazepam IV/IM if liver impairment (no active metabolites); - Loading dose for severe; phenobarbital if BZD-refractory; - Continuous infusion lorazepam/midazolam ICU if needed; (3) **Thiamine 100mg IV BEFORE glucose** — prevent Wernicke; followed by folate, multivitamin; (4) Correct electrolytes: K, Mg, phos (refeeding-like); (5) IV fluids — maintenance + replacement (cautious — cardiac); (6) Seizure: usually BZD prevents; if active — IV BZD; phenytoin NOT effective for alcohol withdrawal seizures (use BZD); (7) Hallucinations + agitation: BZD primary; low-dose haloperidol adjunct if severely agitated (lowers seizure threshold — caution); (8) Distinguish DTs: hyperactive autonomic, severe tremor, hallucinations (often visual), delirium — peaks 48-96 h post last drink; alcoholic hallucinosis — hallucinations without delirium/autonomic; (9) After acute: AUD treatment (MAT — naltrexone, acamprosate, disulfiram; behavioral; AA); (10) Multidisciplinary: ICU/medicine, psychiatry, addiction medicine

---

Delirium Tremens: mortality 5-15%. ICU + symptom-triggered benzodiazepine (long-acting; lorazepam in liver disease). Thiamine BEFORE glucose. Correct K/Mg/phos. Phenytoin NOT effective for alcohol withdrawal seizure. Peak 48-96h. AUD treatment after acute.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 55 ปี admitted for elective surgery; chronic heavy alcohol use × 30 ปี (5 drinks/day) — last drink 48 ชั่วโมงก่อนเข้า รพ; ขณะนี้ tremor severe, agitation, diaphoresis, HR 130, BP 175/100, fever 38.2°C, visual hallucinations (sees bugs), disorientation, brief generalized seizure × 1

CIWA-Ar 28 (severe)
Lab: K 3.0, Mg 1.3, low phos
No head trauma, no infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Glucose IV first"},{"label":"B","text":"Thiamine 500 mg IV TID × 2 days"},{"label":"C","text":"Low-dose oral thiamine only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wernicke Encephalopathy + Korsakoff Syndrome (Wernicke-Korsakoff Syndrome — thiamine deficiency; classic triad: ophthalmoplegia + ataxia + confusion — only ~ 30% have all three; Korsakoff = chronic anterograde amnesia + confabulation): (1) **Thiamine 500 mg IV TID × 2 days** — high-dose parenteral; then 250mg IV/IM daily × 5 days; then oral 100mg daily; (2) **BEFORE any IV glucose** — glucose can precipitate Wernicke in thiamine-deficient; even routine IVF dextrose dangerous; (3) Magnesium replacement (thiamine requires Mg as cofactor — coexists in AUD); (4) Multivitamin + folate; (5) Treat underlying AUD — abstinence, MAT, behavioral; (6) Recovery: Wernicke acute features often reversible with prompt thiamine; Korsakoff (chronic memory loss + confabulation) often permanent — only 20% full recovery; (7) Long-term: cognitive rehabilitation, supportive environment, social work, possible nursing home/supported living if severe; (8) Nutritional rehabilitation — broader malnutrition addressed; (9) Other AUD complications screen: liver, cardiac (alcoholic cardiomyopathy), pancreatitis, peripheral neuropathy, cerebellar atrophy, cancer; (10) Multidisciplinary: neurology, internal medicine, psychiatry, addiction medicine, PT/OT, social work, nutrition; (11) Prevention key in AUD population — high-dose thiamine in ED + admission protocols

---

Wernicke-Korsakoff: thiamine deficiency. Triad (ophthalmoplegia, ataxia, confusion) — only 30% all. HIGH-DOSE PARENTERAL thiamine BEFORE glucose (glucose precipitates Wernicke). Korsakoff (chronic memory + confabulation) often permanent. Prevention protocols in AUD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 60 ปี chronic AUD × 35 ปี — มา ED ด้วย ataxia (wide-based gait, falls), confusion + disorientation, ophthalmoplegia (lateral rectus weakness, nystagmus), peripheral neuropathy; over past months developed inability to form new memories + confabulation

Malnourished, BMI 18
Lab: low albumin, normal B12, MCV 105
MRI: bilateral mammillary body atrophy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge against medical advice immediately"},{"label":"B","text":"BPD Crisis with Recent Suicide Attempt — Acute Management"},{"label":"C","text":"Long-term hospitalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"Add benzodiazepine"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPD Crisis with Recent Suicide Attempt — Acute Management: (1) **Medical stabilization first** — acetaminophen overdose protocol (NAC, monitor LFT, INR, lactate; transfer to hepatology if hepatotoxicity); (2) **Capacity assessment** — current psychiatric status, impaired by recent attempt; (3) **Brief hospitalization indicated** for safety + acute crisis intervention, NOT for chronic suicidality treatment (extended hospitalization can regress BPD); (4) **DBT skills coaching crisis intervention** if DBT-trained therapist available — between-session coaching protocol; (5) **Coordinate with outpatient DBT therapist** + treatment team; do not undermine existing alliance; (6) Safety planning (Stanley-Brown) — warning signs, internal coping, social distractions, contacts, professional help, means restriction; (7) Identify precipitant (relationship conflict) + DBT skills (distress tolerance, interpersonal effectiveness); (8) Brief intervention rather than rehospitalization for chronic suicidality (long admission may worsen); (9) Outpatient follow-up within 24-48 hours; (10) Address means restriction — limit access to medications, large quantities; (11) Family/partner education + support; (12) AVOID adding new medications during crisis unless indicated; benzodiazepines avoid (disinhibition); SSRI continuation; (13) Document carefully; (14) Multidisciplinary; (15) Distinguish chronic from acute risk change — distinct intervention strategies

---

BPD crisis: brief hospitalization for safety, NOT extended (regression). DBT coaching + coordinate outpatient therapist. Safety planning + means restriction. AVOID BZD (disinhibition). Distinguish acute change from chronic suicidality. Follow-up 24-48h.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 26 ปี (known BPD, in DBT × 6 เดือน) มา ED ด้วย acute crisis หลังทะเลาะกับ partner — overdosed 20 acetaminophen 4 ชั่วโมงก่อน, brought by friend; ขณะนี้ stable medically (acetylcysteine started); ปฏิเสธ admission, wants to leave

Alert, oriented, fluctuating between anger + tearfulness
No psychosis, no SI currently after intervention
Distress over relationship';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialist treatment"},{"label":"B","text":"Complex BPD + Comorbidities — Integrated Multidisciplinary Approach"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex BPD + Comorbidities — Integrated Multidisciplinary Approach: (1) **DBT** as primary modality — addresses BPD core + SI + emotion regulation; comprehensive program (skills group + individual therapy + phone coaching + consultation team); (2) **Address trauma** — once stabilized (DBT Stage 2 — trauma-focused work after behavioral stabilization in Stage 1); PE, CPT, EMDR for PTSD; (3) **AUD** — integrated dual diagnosis treatment (separate treatment historically less effective); MAT (naltrexone particularly — affects reward + emotion regulation, FDA approved AUD); concurrent with mental health treatment; AA optional; (4) **Bulimia** — CBT-E (Enhanced) ideal; combined with DBT may be needed; SSRI fluoxetine (FDA approved); nutritional support; medical monitoring (electrolytes, dental, cardiac); (5) **Medication adjuncts**: SSRI (depression, anxiety, bulimia), low-dose mood stabilizer (lamotrigine — emotion regulation), low-dose atypical antipsychotic (severe affective + cognitive sx); AVOID benzodiazepines (disinhibition + AUD); AVOID stimulants; (6) **Social determinants**: housing (Housing First model), employment (supported employment), legal, financial; (7) **Family education + family DBT** if available; sister assessment + treatment; (8) **Trauma-informed care** throughout; (9) **Crisis planning**: ED, hotline, friends/family, therapist coaching; (10) **Long-term** — treatment is years; gradual improvement; 50% BPD remit at 10 yr; (11) Multidisciplinary: DBT therapist, psychiatrist, addiction medicine, eating disorder specialist, primary care, social work, peer support

---

Complex BPD: integrated treatment. DBT primary + trauma-focused (after stabilization) + integrated dual diagnosis (AUD + bulimia) + medication adjuncts + social determinants + trauma-informed. AVOID BZD + stimulants. Multidisciplinary, long-term. 50% remit at 10 yr.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 30 ปี BPD + comorbid AUD + bulimia nervosa + chronic SI + history of trauma (childhood sexual abuse) — มา OPD เพื่อ comprehensive treatment planning

Unstable housing, intermittent employment
Failed standard CBT × 2 prior
Mother supportive, sister has similar issues';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bupropion first-line"},{"label":"B","text":"Bulimia Nervosa (DSM-5: binge + inappropriate compensatory ≥ 1×/wk × 3 mo + self-evaluation overly influenced + not exclusively during AN)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bulimia Nervosa (DSM-5: binge + inappropriate compensatory ≥ 1×/wk × 3 mo + self-evaluation overly influenced + not exclusively during AN): (1) **CBT-E (Enhanced CBT) for eating disorders** = first-line — gold standard for BN; (2) **Fluoxetine 60 mg/day** — FDA-approved for BN; higher dose than depression; reduces binge + purge frequency; (3) **Combination CBT + fluoxetine** for severe/incomplete response; (4) IPT alternative — slower onset; DBT for emotion regulation; (5) Nutritional rehabilitation + regular eating pattern; reduce dietary restriction → reduces binge cycle; (6) Address medical complications: - Electrolytes (hypokalemia → cardiac arrhythmia); - Dental erosion + parotitis (acid exposure); - Esophagitis, Mallory-Weiss tears; - Ipecac toxicity (cardiomyopathy historical); - Laxative abuse → bowel dysfunction; (7) Comorbidity high: depression, anxiety, substance use, BPD, OCD, PTSD; (8) Family-based treatment (FBT) for adolescents — also effective; (9) AVOID: bupropion (seizure risk in eating disorders); benzodiazepine; (10) Long-term: 50-70% recovery; relapse common; maintenance + relapse prevention; (11) Multidisciplinary: psychiatry, eating disorder specialist therapist, dietitian, primary care, dental

---

Bulimia Nervosa: binge + compensatory + body image. CBT-E first-line. Fluoxetine 60mg FDA approved. Combination for severe. Address electrolytes + dental. AVOID bupropion (seizure). Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 22 ปี × 3 ปี — recurrent binge eating (large quantity + loss of control) + compensatory behaviors (self-induced vomiting, laxatives) ≥ 1×/wk × 6 เดือน; weight: BMI 22 (normal); shape + weight overly influence self-evaluation

Lab: K 3.0, mild metabolic alkalosis, dental erosion, parotid swelling, Russell''s sign (knuckle calluses)
No binge/purge during AN episode';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bariatric surgery without treatment"},{"label":"B","text":"Binge Eating Disorder (DSM-5: recurrent binge + ≥ 3 features + ≥ 1×/wk × 3 mo + marked distress + NO compensatory behaviors)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Long-term benzodiazepine"},{"label":"E","text":"Bupropion first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Binge Eating Disorder (DSM-5: recurrent binge + ≥ 3 features + ≥ 1×/wk × 3 mo + marked distress + NO compensatory behaviors): (1) **CBT-E** for BED = first-line; reduces binge frequency + improves comorbidity; (2) **Lisdexamfetamine (Vyvanse) 30-70 mg/day** — FDA approved for BED (only stimulant approved); reduces binge episodes; monitor CV, abuse potential; (3) **Topiramate** — reduces binges + weight; cognitive side effects + kidney stones; (4) **SSRI** — modest benefit; for comorbid depression/anxiety; (5) Behavioral weight loss programs combined with CBT-BED (vs alone); (6) IPT, DBT alternatives; (7) Address obesity comorbidity: T2DM, HTN, dyslipidemia, OSA, MASLD; weight loss medications considered (semaglutide, etc. — emerging evidence with BED); bariatric surgery requires careful BED screening (BED is NOT contraindication but requires treatment + ongoing monitoring); (8) Comorbidity: depression, anxiety, substance use, ADHD (common — addressed by lisdexamfetamine partially); (9) Group therapy + support; (10) Long-term: chronic with relapses; maintenance; (11) Distinguish from BN (no compensatory) + obesity without binge eating; (12) Multidisciplinary: psychiatry, dietitian, primary care, possibly bariatric, exercise specialist

---

Binge Eating Disorder: binge + distress + NO compensatory. CBT-E first-line. Lisdexamfetamine FDA approved. Topiramate. Treat obesity comorbidity. BED screening before bariatric surgery. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 38 ปี × 5 ปี — recurrent binge eating (large quantity + loss of control + eats rapidly, until uncomfortably full, when not hungry, alone due to embarrassment, disgust after) ≥ 1×/wk × 6 เดือน — NO compensatory behaviors

BMI 35 (obese), comorbid HTN, dyslipidemia, T2DM
Shame + distress about binges';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force feeding"},{"label":"B","text":"Avoidant/Restrictive Food Intake Disorder (ARFID"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Avoidant/Restrictive Food Intake Disorder (ARFID — DSM-5 2013 new dx; food avoidance/restriction → weight loss / nutritional deficiency / feeding tube dependence / psychosocial impairment + NOT due to body image or AN/BN): (1) Multidisciplinary treatment essential — pediatrics, child psychiatry, dietitian, feeding therapist, OT, family therapy; (2) Subtypes: - Sensory (texture, taste, smell aversion — common with autism); - Lack of interest (low appetite/drive); - Fear of aversive consequences (choking, vomiting fear after event); (3) Feeding therapy / behavioral: - Sensory-based exposure (graduated exposure to new textures/flavors); - Systematic desensitization; - Positive reinforcement; - Parent training + meal structure; - Family-based treatment adapted for ARFID; (4) CBT for ARFID (older children + adolescents); (5) Address comorbidity: anxiety (very common), autism spectrum (common), ADHD, OCD; (6) Medication: limited evidence; SSRI for comorbid anxiety/OCD; mirtazapine appetite stimulation off-label; cyproheptadine appetite stimulation; (7) Nutritional rehabilitation + supplementation; (8) Long-term: chronic course with sensory subtype + autism; gradual broadening of diet; (9) Distinguish from picky eating (normal developmental, no medical/psychosocial impairment); (10) Address feeding tube weaning if applicable

---

ARFID (DSM-5 2013): food restriction NOT due to body image → weight/nutrition/psychosocial impairment. Subtypes: sensory, lack of interest, fear of consequences. Multidisciplinary feeding therapy + behavioral. Address comorbid autism/anxiety. Distinguish from picky eating.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 11 ปี — significant weight loss + failure to gain expected weight × 18 เดือน + nutritional deficiency (iron, vitamin D) + dependence on supplements — restriction based on sensory characteristics (texture, smell — only eats white foods, soft textures) + lack of interest in eating, NOT due to body image concerns

No body image disturbance, no fear of weight gain
Autism spectrum traits present
No medical cause identified';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Lead poisoning workup + treatment"},{"label":"C","text":"Punishment"},{"label":"D","text":"Surgery"},{"label":"E","text":"SSRI alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pica (DSM-5: persistent eating non-nutritive non-food substances ≥ 1 mo + developmentally inappropriate + not culturally sanctioned): (1) Medical evaluation + treatment: - **Lead poisoning workup + treatment** (chelation if severe — succimer, EDTA per Pb level + age); environmental abatement; - Iron deficiency (often comorbid — may drive pica per ''iron deficiency hypothesis''); supplement; - Parasitic infection (geophagia → helminthiasis); - Dental injury, intestinal obstruction/perforation, electrolyte imbalance, infections; (2) Behavioral interventions: - Functional analysis (sensory, attention, escape, automatic); - Environment management (remove access to ingested substances); - Differential reinforcement (preferred items contingent on not eating non-food); - Response interruption + redirection; - Pediatric/developmental behavioral specialists; (3) Comorbidity: autism, intellectual disability, schizophrenia, OCD, trichophagia/trichobezoar; (4) Common in pregnancy (geophagia, ice — pagophagia) — usually transient + benign if not toxic substance; (5) Iron + zinc supplementation in some cases; (6) Family education + safety; (7) Long-term: often resolves in childhood; persistent with autism/ID; (8) Multidisciplinary: pediatrics, child psychiatry, behavioral therapist, developmental specialist, family

---

Pica: persistent non-food ingestion. Medical eval (lead, iron, parasites, GI). Behavioral functional analysis. Common with autism/ID. Iron deficiency may drive (hypothesis). Pregnancy variant. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กหญิงอายุ 6 ปี + autism spectrum + intellectual disability — eating non-nutritive substances (dirt, paint chips, fabric, hair) × 1 ปี — developmentally inappropriate; mother concerned; recent elevated blood lead level

Lab: Hgb 9 (low — iron deficient), Pb 22 μg/dL (elevated)
Dental damage
No evidence of malnutrition';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Rumination Disorder (DSM-5"},{"label":"C","text":"Fundoplication surgery first"},{"label":"D","text":"PPI alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rumination Disorder (DSM-5: repeated regurgitation ≥ 1 mo + not due to medical condition + not exclusively during ARFID/AN/BN/BED): (1) Medical workup first — rule out GERD, eosinophilic esophagitis, pyloric stenosis, neurologic, metabolic; (2) Infants — feeding interaction + caregiver assessment essential (maternal depression here): - Treat postpartum depression (SSRI — sertraline preferred; CBT/IPT; social support); - Improve mother-infant bonding (parent-infant psychotherapy, attachment-focused); - Feeding practices (positioning, post-feeding handling); - Sensory input + alternative stimulation; (3) Behavioral interventions for older children/adults: - Diaphragmatic breathing (most effective — competing response — first-line for adults/older children); - Habit reversal; - Functional analysis (sensory, self-stimulatory, attention); - Differential reinforcement; (4) Nutritional support — adequate caloric intake; (5) Comorbidity assessment: anxiety, depression, intellectual disability, autism; (6) Family + caregiver support + education; (7) Multidisciplinary: pediatrics, child psychiatry, GI, behavioral therapist, social work, lactation; (8) Distinguish from: GERD, cyclic vomiting, bulimia (deliberate self-induced), anorexia

---

Rumination Disorder: regurgitation + re-chewing/swallowing. Medical rule-out first. Infants: address caregiver + bonding (postpartum depression here). Older: diaphragmatic breathing first-line. Distinguish from GERD + bulimia. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ทารกอายุ 14 เดือน — repeated regurgitation of food (without nausea, retching) followed by re-chewing + re-swallowing × 4 เดือน, weight loss, failure to thrive

No GERD per workup
No gastrointestinal disorder identified
Mother + infant interaction: mother appears withdrawn, postpartum depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — adults don''t have ADHD"},{"label":"B","text":"Adult ADHD"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult ADHD — Combined Type (DSM-5 — onset before 12, ≥ 5 sx in adults inattention or hyperactive-impulsive, ≥ 2 settings, impairment): (1) Combination treatment most effective: medication + behavioral; (2) **Medication first-line**: - **Stimulants** (methylphenidate, amphetamine — long-acting preferred — Concerta, Vyvanse) — 70% response rate; controlled substance — diversion monitoring; - **Non-stimulants**: atomoxetine (Strattera — SNRI), guanfacine ER, clonidine ER — slower onset but useful with substance use hx, comorbid anxiety, contraindication to stimulant; (3) **Behavioral interventions**: - CBT for ADHD (Safren) — executive function strategies, organization, time management, distraction control; - Coaching; - Mindfulness; - Skills training; (4) Address comorbidity (75% adults have at least one): depression, anxiety, substance use, learning disorders, sleep, ASD; (5) Accommodations: workplace + academic (extended time, quiet environment, written instructions); (6) Lifestyle: structure + routine, exercise, sleep, limit distractions, time management tools; (7) Couples therapy if relational impact; (8) Medication monitoring: BP, HR (stimulants), height/weight (children less issue adults), cardiac if risk factors, mental health; (9) Misuse + diversion screening — abuse potential of stimulants; (10) Long-term: chronic; gradual learning of skills; medication often continued; (11) Multidisciplinary

---

Adult ADHD: onset < 12, ≥ 5 sx adults, ≥ 2 settings, impairment. Combination medication + behavioral. Stimulants 70% response. Non-stimulants for comorbidity/abuse risk. CBT for ADHD. High comorbidity. Workplace accommodations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 30 ปี — chronic difficulty with attention, organization, time management, procrastination, missed deadlines × adulthood, but more apparent since starting graduate school; reports similar issues since childhood (forgetful, lost things, restless) — confirmed by mother + school records

No medical cause, no other psychiatric, no substance use
ASRS-v1.1 elevated
DSM-5 ADHD criteria met (≥ 5 sx adult; onset < 12 yo)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment alone"},{"label":"B","text":"Multimodal evidence-based interventions"},{"label":"C","text":"Incarceration only"},{"label":"D","text":"No treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conduct Disorder, Adolescent-Onset (DSM-5: ≥ 3 of 15 criteria in 12 mo + ≥ 1 in past 6 mo; pattern violating rights or major norms; adolescent-onset = no criteria before 10 yo, better prognosis than childhood-onset): (1) **Multimodal evidence-based interventions**: - **Multisystemic Therapy (MST)** — intensive family + community-based; reduces recidivism + out-of-home placement; - **Functional Family Therapy (FFT)** — family-focused; - **Multidimensional Treatment Foster Care (MTFC)** — for severe; - Parent Management Training; - CBT — anger management, problem-solving; (2) Address comorbidity high: ADHD (50%), depression, anxiety, substance use, learning disorders, trauma (often); (3) ADHD treatment improves conduct sx — stimulants for comorbid; (4) Medication targets specific sx: - Atypical antipsychotic (risperidone) for severe aggression — last-line, side effects; - Mood stabilizer for aggression; - SSRI for comorbid depression/anxiety; - AVOID benzodiazepine + stimulants in misuse risk; (5) School + community involvement; address truancy; alternative educational programs; (6) Social services + child welfare — address abuse/neglect if present; family support; (7) Juvenile justice coordination; restorative justice approaches; (8) Long-term prognosis: - Adolescent-onset — often resolves into adulthood (better); - Childhood-onset — progress to ASPD (~ 40%); (9) Multidisciplinary: child + adolescent psychiatry, family therapy, school, juvenile justice, social work, primary care

---

Conduct Disorder: ≥ 3/15 criteria. Adolescent-onset (no criteria < 10) better prognosis. MST/FFT/MTFC evidence-based. CBT + parent training. Address ADHD + trauma + family. Medication targets sx. Adolescent-onset often resolves; childhood-onset → 40% ASPD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'วัยรุ่นชายอายุ 15 ปี — pattern × 18 เดือน — aggression to people + animals (bullies, fights, weapons), destruction of property (setting fires, vandalism), deceitfulness/theft (stolen items, lying), serious violation of rules (curfew, truancy, runaway) — onset 12 yo

Family: chaotic, parental DV, low SES
No substance use disorder
No psychotic disorder
No intellectual disability
DSM-5 conduct disorder criteria met — adolescent-onset';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment only"},{"label":"B","text":"Oppositional Defiant Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Oppositional Defiant Disorder (DSM-5: pattern of angry/irritable mood + argumentative/defiant behavior + vindictiveness ≥ 6 mo + ≥ 4 of 8 sx + functional impairment): (1) Behavioral parent training first-line — PCIT (Parent-Child Interaction Therapy, age 2-7), Triple P, Incredible Years, Defiant Children program; (2) CBT — problem-solving, anger management; (3) Family therapy + school-based interventions; (4) Address comorbidity (high): - ADHD (very common — treat to reduce ODD sx); - Depression, anxiety; - Learning disorders; - DMDD (chronic irritability); (5) Medication adjunctive for severe + comorbidity: - Stimulants for ADHD comorbidity → ODD improves; - SSRI for depression/anxiety; - Atypical antipsychotic for severe aggression (last-line — risperidone, aripiprazole); - AVOID benzodiazepine; (6) School-based: behavioral plan, 504/IEP if needed; (7) Distinguish: - Conduct disorder (more severe — aggression to people/animals, property destruction, theft); - DMDD (chronic irritability + severe outbursts); - Normal developmental defiance; (8) Long-term: 30% progress to conduct disorder; ODD predicts adult depression, anxiety, substance use; (9) Multidisciplinary: child psychiatry, behavioral therapist, school, family

---

ODD: angry/irritable + argumentative/defiant + vindictive ≥ 6 mo. Parent training first-line (PCIT, Triple P). Address ADHD comorbidity (very common). Distinguish from conduct disorder (more severe) + DMDD (chronic irritability). 30% progress to conduct disorder.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 8 ปี × 12 เดือน — frequent loss of temper, easily annoyed, angry/resentful, argues with adults, defies adult requests, deliberately annoys, blames others, spiteful/vindictive × 2-3 episodes/wk — pattern at home + school + with peers

No aggression to people/animals + no destruction of property + no theft (would suggest conduct disorder)
Not during depressive/psychotic episode
DSM-5 ODD criteria met';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention"},{"label":"B","text":"IEP/504 special education"},{"label":"C","text":"Institutionalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intellectual Disability (Intellectual Developmental Disorder), Mild (DSM-5: deficits in intellectual + adaptive functioning + onset during developmental period; severity based on adaptive functioning, not IQ alone): (1) Comprehensive evaluation: - **Etiologic workup**: chromosomal microarray (first-line), Fragile X testing (most common inherited cause), targeted gene panel if features, WES emerging, metabolic if features, neuroimaging if exam abnormal, lead if pica/risk; - Hearing/vision; - Medical comorbidities; (2) Educational supports: - **IEP/504 special education** — IDEA Part B; - Adaptive functioning focus + life skills; - Inclusion when possible with supports; - Vocational training (transition planning starting at 14-16 yo); (3) Behavioral interventions for behavioral issues; applied behavior analysis; positive behavioral supports; (4) Speech-language therapy + OT/PT as needed; (5) Address comorbid psychiatric disorders (high rates — 30-50%): ADHD, anxiety, depression, autism, psychotic disorders; treatment same as general population but lower medication doses + sensitive to side effects; (6) **Family support + education + genetic counseling**; reproductive recurrence risk; respite care; sibling support; (7) Transition planning to adulthood: guardianship (vs supported decision-making — modern approach), residential, vocational, healthcare, social security; (8) Sexuality + relationship education adapted; (9) Address discrimination + advocacy; (10) Multidisciplinary: developmental pediatrics, child psychiatry, neurology, genetics, school, OT/PT/SLP, social work, family

---

Intellectual Disability (DSM-5 IDD): intellectual + adaptive deficit + developmental onset. Etiologic workup (chromosomal microarray, Fragile X). Educational supports (IEP). Behavioral interventions. Address comorbid psychiatric (high). Family + genetic counseling. Multidisciplinary lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 7 ปี — developmental delay since infancy, IQ 55 (mild intellectual disability), adaptive functioning impaired (conceptual, social, practical), school behind grade level; parents seeking comprehensive plan; family hx: maternal cousin with similar issues; Fragile X testing pending

No seizures, normal hearing/vision
Behavioral issues: occasional tantrums, social difficulties';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment for poor reading"},{"label":"B","text":"Educational intervention first-line"},{"label":"C","text":"No intervention — wait"},{"label":"D","text":"Surgery"},{"label":"E","text":"Lower expectations"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Specific Learning Disorder, with impairment in reading (Dyslexia) — DSM-5: difficulties learning + using academic skills ≥ 6 mo despite intervention + below age-expected + not better explained by ID, sensory, neurologic, lack of instruction): (1) **Educational intervention first-line**: - Evidence-based reading instruction — **structured literacy** (Orton-Gillingham, Wilson, LiPS) — explicit, systematic phonics-based; - **IEP/504** with specific reading goals + accommodations (extended time, text-to-speech, audiobooks, modified assignments); - Intensity matters — 1:1 or small group, frequent; - Special education or reading specialist; (2) Comprehensive evaluation: - Psychoeducational testing (academic + cognitive); - Language assessment; - Hearing/vision; - Rule out other learning disorders + comorbidity; (3) Address comorbidity: ADHD (very common — 30-40%), anxiety, depression (especially school avoidance), other SLDs; (4) Treat comorbid ADHD with medication if present (improves attention + learning capacity); (5) Address anxiety + self-esteem — reading difficulty stigma; CBT if significant; (6) Family education + advocacy (parents'' rights under IDEA + ADA); (7) Long-term: persistent challenge; compensatory strategies improve; technology (text-to-speech, audiobooks) for lifelong support; many achieve academic + occupational success; (8) Multidisciplinary: psychology, special education, reading specialist, speech-language, primary care, child psychiatry if comorbid; (9) Subtypes (specifiers): reading, written expression, mathematics (dyscalculia)

---

Specific Learning Disorder (Dyslexia): persistent reading difficulty despite instruction + intact IQ. Structured literacy (Orton-Gillingham) evidence-based. IEP/504 + accommodations. Address ADHD comorbidity (30-40%). Long-term — compensatory + technology. Family advocacy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กหญิงอายุ 9 ปี grade 3 — persistent difficulty with reading (slow, inaccurate, effortful word reading; poor comprehension despite adequate instruction × 18 เดือน) — IQ normal (95), no sensory impairment, no neurologic disorder, attended school regularly

Family hx: father had reading difficulty
Frustrated, beginning school avoidance, mild anxiety';

commit;
