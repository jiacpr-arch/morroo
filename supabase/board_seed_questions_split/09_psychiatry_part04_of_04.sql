-- ===============================================================
-- หมอรู้ — Board seed: จิตเวชศาสตร์ (psychiatry) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('psych_clinical_decision', 'จิตเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'psychiatry', NULL, 0),
  ('psych_basic_science', 'จิตเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'psychiatry', NULL, 0),
  ('psych_ems_mgmt', 'จิตเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'psychiatry', NULL, 0),
  ('psych_integrative', 'จิตเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'psychiatry', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง limbic system + emotional regulation in psychiatric disorders', '[{"label":"A","text":"Random"},{"label":"B","text":"Limbic System + Emotional Regulation"},{"label":"C","text":"No relevance"},{"label":"D","text":"Single mechanism"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Limbic System + Emotional Regulation: (1) **Amygdala** — fear, threat detection, emotional salience; hyperactive in anxiety + PTSD + depression; CBT + exposure reduce reactivity; amygdala-prefrontal connectivity key; (2) **Hippocampus** — declarative memory, contextual conditioning; reduced volume in PTSD + chronic depression + AD; chronic stress + cortisol damage; antidepressants + ECT + exercise increase BDNF + may restore; (3) **Anterior cingulate cortex (ACC)** — emotion regulation, error monitoring, attention; dorsal ACC cognitive; ventral ACC affective; subgenual ACC (SCC, Brodmann 25) — depression hyperactive; deep brain stimulation target for TRD (Mayberg); (4) **Prefrontal cortex (PFC)** — top-down regulation of amygdala; impaired in depression + PTSD + ADHD + schizophrenia; medial PFC default mode + self-referential rumination in depression; dorsolateral PFC — executive + TMS target for depression; (5) **Insula** — interoception, emotional awareness, body sensations; alexithymia + somatic disorders involve insula; (6) **Nucleus accumbens** — reward, motivation; addiction, anhedonia in depression; ketamine + psychedelics modulate; (7) **Default mode network (DMN)** — medial PFC + posterior cingulate + precuneus — self-referential, rumination, hyperactive in depression; psilocybin reduces DMN activity (mechanism); (8) **Salience network** — anterior insula + dorsal ACC — switching between DMN + executive control; dysfunction in psychosis; (9) **Executive control network** — dorsolateral PFC + posterior parietal; ADHD impaired; (10) **Clinical implications**: dimensional understanding — circuits cross diagnostic categories (RDoC framework); treatments target circuits not just diagnosis

---

Limbic + circuits: amygdala (fear), hippocampus (memory, PTSD/depression atrophy), ACC (SCC TRD target), PFC (top-down regulation), insula (interoception), NAc (reward), DMN (rumination depression). RDoC dimensional framework. Treatments target circuits.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Mayberg; RDoC NIMH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง limbic system + emotional regulation in psychiatric disorders'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง GABA + glutamate balance + psychiatric implications', '[{"label":"A","text":"Random"},{"label":"B","text":"GABA + Glutamate Balance + Psychiatric"},{"label":"C","text":"No relevance"},{"label":"D","text":"Single mechanism"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** GABA + Glutamate Balance + Psychiatric: (1) **GABA** — primary inhibitory neurotransmitter (40% of CNS): - GABA-A — ligand-gated Cl-; benzodiazepine + barbiturate + alcohol + zolpidem + propofol + neurosteroid binding sites; subunit composition determines effects (α1 = sedation, α2/3 = anxiolysis, α5 = memory); - GABA-B — metabotropic (baclofen for spasticity, GHB/sodium oxybate for narcolepsy); - Reduced GABA in depression + anxiety; (2) **Glutamate** — primary excitatory neurotransmitter; — NMDA, AMPA, kainate, metabotropic receptors; - Excitotoxicity in stroke, neurodegeneration; - **Ketamine/esketamine** = NMDA antagonist → rapid antidepressant (synaptic plasticity, BDNF); - **Memantine** = NMDA antagonist (AD); - **Riluzole** = glutamate modulator (research depression); - **D-cycloserine** = NMDA partial agonist (research augmentation of exposure therapy); (3) **Anxiety**: GABA-glutamate imbalance; benzodiazepines enhance GABA-A; pregabalin + gabapentin reduce glutamate; (4) **Depression**: glutamate excess in some circuits; reduced GABA; ketamine + glutamate modulators; (5) **Schizophrenia**: NMDA hypofunction hypothesis — PCP/ketamine produce schizophrenia-like sx; agents enhancing NMDA function research (glycine, D-serine); (6) **Bipolar**: glutamate dysregulation; lithium + valproate + lamotrigine modulate; (7) **PTSD**: glutamate excess in fear circuits; (8) **Substance use**: alcohol enhances GABA + blocks NMDA → withdrawal = GABA withdrawal + NMDA hyperactivity (seizure, hyperexcitability); (9) **Modern**: rapid antidepressants targeting glutamate (ketamine + analogs) major therapeutic advance

---

GABA-glutamate: GABA inhibitory (BZD, EtOH, barbiturate target); glutamate excitatory (NMDA — ketamine antidepressant). Anxiety/depression — imbalance. Schizophrenia NMDA hypofunction. Rapid antidepressants target glutamate.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Krystal NMDA; Zarate Ketamine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง GABA + glutamate balance + psychiatric implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง norepinephrine + adrenergic system in psychiatric disorders', '[{"label":"A","text":"Random"},{"label":"B","text":"Norepinephrine + Adrenergic System"},{"label":"C","text":"No relevance"},{"label":"D","text":"Single mechanism"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Norepinephrine + Adrenergic System: (1) **Locus coeruleus** — major NE source; project widely; arousal, attention, stress response; hyperactive in PTSD + panic; (2) **Receptors**: - **Alpha-1**: postsynaptic — prazosin antagonism reduces PTSD nightmares (sympathetic to dreams); orthostatic SE (most antidepressants, antipsychotics); - **Alpha-2**: presynaptic autoreceptor (negative feedback) + postsynaptic; clonidine + guanfacine agonist for ADHD, anxiety, opioid withdrawal; mirtazapine alpha-2 antagonist (increases NE + 5-HT); - **Beta**: cardiac + bronchial primarily; propranolol non-selective antagonist for performance anxiety + somatic anxiety (tremor, tachycardia); essential tremor + akathisia; (3) **Disorders**: - **PTSD**: NE excess in fear circuits; prazosin nightmares; propranolol for somatic; - **Panic**: NE hyperactivity; SSRI/SNRI reduce; - **ADHD**: NE deficit attention; SNRI (atomoxetine), alpha-2 agonists (guanfacine, clonidine); stimulants increase NE + DA; - **Depression**: NE deficit hypothesis (one of monoamine theories); SNRI dual mechanism; bupropion NE + DA reuptake; - **Withdrawal syndromes**: opioid + alcohol → autonomic NE hyperactivity; clonidine + lofexidine for opioid withdrawal autonomic sx; - **Anxiety performance**: propranolol PRN; (4) **Cardiovascular consideration**: stimulants + SNRI raise BP/HR — monitor; (5) **Adrenergic medications side effects**: hypotension (alpha-1 antagonism — most antipsychotics, antidepressants), orthostatic, sedation

---

NE adrenergic: alpha-1 (prazosin PTSD nightmares), alpha-2 (clonidine ADHD/anxiety, mirtazapine antagonist), beta (propranolol performance anxiety, akathisia). PTSD/panic/ADHD/depression/withdrawal all involve NE. CV monitoring stimulants/SNRI.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Stahl; Raskind Prazosin PTSD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง norepinephrine + adrenergic system in psychiatric disorders'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง acetylcholine + cognitive function + psychiatric medications', '[{"label":"A","text":"Random"},{"label":"B","text":"Acetylcholine + Cognition + Psychiatric"},{"label":"C","text":"No relevance"},{"label":"D","text":"Single mechanism"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acetylcholine + Cognition + Psychiatric: (1) **Cholinergic pathways**: nucleus basalis of Meynert → cortex (cognition, memory); brainstem cholinergic → REM sleep, autonomic; (2) **Receptors**: - **Muscarinic (M1-M5)**: postganglionic parasympathetic + CNS; - **Nicotinic**: neuromuscular junction + CNS; (3) **Alzheimer''s disease**: cholinergic deficit (cortical + hippocampal); cholinesterase inhibitors (donepezil, rivastigmine, galantamine) — modest cognitive benefit; (4) **Anticholinergic burden**: - Major iatrogenic harm in elderly — falls, cognition, delirium, urinary retention, constipation, dry mouth, blurred vision, mydriasis, tachycardia; - **Drugs**: TCA (especially amitriptyline, doxepin), low-potency typical antipsychotics, anticholinergics (benztropine, trihexyphenidyl), diphenhydramine + 1st-gen antihistamines, oxybutynin + bladder antimuscarinics, scopolamine; - Cumulative anticholinergic burden scoring (ACB scale); avoid in elderly; (5) **Anticholinergic toxicity**: mad/hot/dry/red/blind/full; physostigmine antidote; (6) **Smoking + nicotine**: - Nicotine activates nicotinic receptors → DA release → reward; - Smoking cessation: varenicline (partial agonist α4β2), NRT, bupropion; - Schizophrenia high smoking (50-90%) — partial self-medication of cognitive sx, smoking induces CYP1A2 (lowers clozapine, olanzapine levels); (7) **REM sleep + cholinergic**: cholinergic activation during REM; anticholinergics reduce REM; (8) **Delirium**: anticholinergic + cholinergic deficit contribute; cholinesterase inhibitors in some studies modest delirium prevention/treatment; (9) **Beers Criteria**: avoid anticholinergic in elderly; (10) **Schizophrenia + cholinergic**: emerging — xanomeline (KarXT muscarinic agonist M1/M4) FDA approved 2024 schizophrenia — novel mechanism without D2 blockade; (11) **Psychogenic + autonomic**: vagal nerve stimulation for TRD (FDA approved)

---

Acetylcholine + cognition: AD cholinergic deficit (cholinesterase inhibitors). Anticholinergic burden major iatrogenic harm elderly (Beers). Toxicity → physostigmine. Smoking + nicotine + schizophrenia. Xanomeline (KarXT) novel muscarinic schizophrenia (FDA 2024).', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'AGS Beers 2023; KarXT FDA 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง acetylcholine + cognitive function + psychiatric medications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง inflammation + immune system + psychiatric disorders', '[{"label":"A","text":"Random"},{"label":"B","text":"Inflammation + Immune System + Psychiatry — Growing Field"},{"label":"C","text":"No relevance"},{"label":"D","text":"Single mechanism"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Inflammation + Immune System + Psychiatry — Growing Field: (1) **Sickness behavior** — cytokines (IL-1, IL-6, TNF-α) induce depression-like behavior (anorexia, anhedonia, fatigue, social withdrawal, sleep) — overlap with depression; (2) **Cytokine inducible depression**: interferon-α treatment (HCV, melanoma) — high rate depression — historical demonstration of inflammation-depression link; (3) **Depression inflammation hypothesis**: - Subgroup of MDD with elevated CRP, IL-6; - Chronic inflammation (autoimmune, obesity, infection) → depression risk; - **Anti-inflammatory adjuvant therapy** for depression — research: NSAIDs (mixed), omega-3, minocycline, anti-TNF (infliximab in elevated CRP subgroup); (4) **Schizophrenia immune**: - Maternal infection → offspring schizophrenia risk (epidemiology); - HLA region in GWAS; - Inflammation hypothesis; - Anti-NMDA encephalitis (autoimmune) mimics schizophrenia; (5) **Bipolar inflammation**: elevated inflammatory markers in mood episodes; (6) **PANS/PANDAS** — Pediatric Acute-onset Neuropsychiatric Syndrome / following streptococcal — abrupt onset OCD + tics + behavioral changes; treatment includes antibiotic + immunomodulation; controversial diagnosis; (7) **Autoimmune encephalitis**: anti-NMDA, LGI1, GABA-B, CASPR2 — present with psychiatric sx + neurological; treatable; tumor association; (8) **Multiple sclerosis psychiatric sx**: depression (50%), anxiety, cognitive, pseudobulbar affect; treatments — same + address MS disease; (9) **HIV**: cognitive (HAND), depression, mania; (10) **Microbiome-gut-brain axis** — emerging — gut bacteria influence mood + behavior; psychobiotics research; (11) **Modern**: precision psychiatry stratifying by inflammatory biomarkers — emerging trials; immunomodulatory therapy adjunct selected patients

---

Inflammation + psychiatry: sickness behavior, depression-inflammation link (subgroup with elevated CRP/IL-6), interferon-induced depression, schizophrenia (maternal infection), PANS/PANDAS, autoimmune encephalitis (anti-NMDA), MS psychiatric. Microbiome-gut-brain axis emerging.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Miller Cytokine Depression; Dalmau Autoimmune Encephalitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง inflammation + immune system + psychiatric disorders'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง CBT theoretical foundations + mechanisms', '[{"label":"A","text":"No theoretical basis"},{"label":"B","text":"CBT Theoretical Foundations + Mechanisms"},{"label":"C","text":"Single technique"},{"label":"D","text":"Surgery"},{"label":"E","text":"No evidence"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CBT Theoretical Foundations + Mechanisms: (1) **Beck''s cognitive model**: thoughts → feelings → behaviors (cognitive triad of depression — self, world, future); cognitive distortions (catastrophizing, all-or-nothing, mind reading, etc.); identify + modify; (2) **Behavioral**: - Conditioning (Pavlov, Skinner); - Exposure + response prevention (extinction of conditioned fear, OCD, phobias); - Behavioral activation (depression — increase reinforcing activities); - Habit reversal (BFRBs); (3) **Cognitive techniques**: - Identifying automatic thoughts; - Examining evidence; - Cognitive restructuring; - Behavioral experiments; - Decatastrophizing; (4) **Mechanism of change**: - Neural — fMRI shows changes in amygdala-PFC connectivity, reduced amygdala reactivity, increased PFC regulation; - Behavioral — learning new responses + reducing avoidance; - Cognitive — schema modification; (5) **Evidence base**: most studied psychotherapy; effective for depression, anxiety, OCD, PTSD, eating disorders, insomnia, psychosis (CBTp), pain, somatic; (6) **Specific protocols**: - **MDD**: Beck CBT, behavioral activation; - **GAD**: cognitive restructuring + worry exposure; - **Panic**: interoceptive + in vivo exposure; - **OCD**: ERP; - **PTSD**: PE, CPT; - **Insomnia**: CBT-I; - **Social anxiety**: cognitive + exposure (group effective); - **Eating disorders**: CBT-E (Fairburn); - **Substance use**: CBT, MET, relapse prevention; - **Psychosis**: CBTp; - **BPD**: DBT (modified CBT); - **Pain**: CBT for chronic pain; (7) **Format**: individual, group, online, app-based (effectiveness comparable for many disorders); (8) **Combination with medication**: synergistic for many disorders; (9) **Therapist factors**: training + adherence + alliance important; (10) **Limitations**: not all respond; some require psychodynamic, family, or other approaches

---

CBT: Beck cognitive triad + behavioral conditioning. Identifying automatic thoughts + cognitive restructuring + behavioral experiments + exposure. Mechanism: amygdala-PFC connectivity changes. Most studied. Disorder-specific protocols. Available online/app.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Beck CBT; Hofmann Meta-analyses', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง CBT theoretical foundations + mechanisms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง psychodynamic therapy + theoretical foundations', '[{"label":"A","text":"No evidence base"},{"label":"B","text":"Psychodynamic Therapy — Theoretical Foundations + Modern Practice"},{"label":"C","text":"Single school of thought"},{"label":"D","text":"Surgery"},{"label":"E","text":"Only short-term"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Psychodynamic Therapy — Theoretical Foundations + Modern Practice: (1) **Origins**: Freud psychoanalysis (unconscious, defense mechanisms, drive theory, transference); evolved through object relations (Klein, Winnicott, Mahler), self-psychology (Kohut), relational + interpersonal (Sullivan, Mitchell), attachment-informed (Bowlby + modern); (2) **Core concepts**: - **Unconscious mental processes** influence behavior; - **Defense mechanisms** (denial, projection, displacement, sublimation, intellectualization, splitting, etc.); - **Transference + countertransference** — patient''s feelings toward therapist + vice versa as therapeutic material; - **Insight** — understanding patterns; - **Working through** — repeated processing for change; - **Resistance** — barriers to insight + change; (3) **Modern psychodynamic**: - Brief dynamic therapy (Strupp, Davanloo, Sifneos) — 16-30 sessions, focused; - Mentalization-Based Treatment (MBT — Bateman + Fonagy) — BPD, understand mental states; - Transference-Focused Psychotherapy (TFP — Kernberg) — BPD, narcissistic; - Supportive psychodynamic; (4) **Evidence base** (Shedler): - Effective for depression, anxiety, personality disorders, complex trauma; - Effects sustained + grow after treatment ends (unlike some other modalities); - Equivalent to CBT for many disorders; (5) **Indications**: - Personality disorders; - Complex trauma; - Chronic interpersonal patterns; - Depression with personality features; - Patients seeking insight + meaning; - Treatment-resistant after symptom-focused therapies; (6) **Distinguish from psychoanalysis**: psychoanalysis (3-5×/wk, couch, intensive — limited modern use clinical) vs psychodynamic psychotherapy (1-2×/wk, face-to-face); (7) **Therapeutic alliance** central — Norcross + Wampold common factors research; (8) **Cultural adaptation** important; (9) **Combination with medication** acceptable; (10) **Modern psychodynamic** integrates neuroscience, attachment, emotion regulation

---

Psychodynamic: unconscious + defense mechanisms + transference + insight + working through. Modern: brief dynamic, MBT, TFP. Evidence base (Shedler) — effects sustained + grow. BPD, complex trauma, depression with personality, insight-seeking patients. Alliance central.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Shedler psychodynamic; Bateman MBT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง psychodynamic therapy + theoretical foundations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง psychiatric medication in pregnancy + lactation safety', '[{"label":"A","text":"Stop all medications in pregnancy"},{"label":"B","text":"Pregnancy + Lactation Psychiatric Pharmacology"},{"label":"C","text":"Continue valproate"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid SSRI absolutely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy + Lactation Psychiatric Pharmacology: (1) **Foundational**: untreated psychiatric illness has risks (untreated depression — preterm, LBW, postpartum depression risk, infanticide/suicide, impaired bonding, child development); medication risks; balance with shared decision-making; (2) **SSRIs**: - **Sertraline** generally preferred (extensive data, low milk transfer); - **Escitalopram, fluoxetine** acceptable; - **Paroxetine** — Ebstein cardiac anomaly (small absolute risk, controversial; avoid initiating in pregnancy); - Late pregnancy SSRI — 30% neonatal adaptation (transient); PPHN slight risk; do NOT routinely discontinue (relapse risk > NAS); (3) **SNRIs**: venlafaxine, duloxetine — acceptable; similar profile; (4) **Bupropion**: limited data but no clear teratogenicity; consider; (5) **Mirtazapine**: acceptable; appetite + sleep benefit hyperemesis; (6) **Mood stabilizers**: - **Lithium** — Ebstein anomaly small absolute risk; monitor levels closely (renal changes pregnancy); preferred over valproate; - **Valproate** — AVOID — NTD 1-2% + cognitive deficits + Major Congenital Malformations; FDA black box; - **Carbamazepine** — NTD + facial anomalies + folate supplement; avoid if possible; - **Lamotrigine** — acceptable; levels may decrease in pregnancy (monitor); breastfeeding compatible; (7) **Antipsychotics**: - Typical + atypical generally acceptable; - Gestational diabetes monitoring (olanzapine, quetiapine, clozapine); - Discontinuation late pregnancy not recommended; (8) **Benzodiazepines**: - 1st trimester — cleft palate small risk; - Late pregnancy — floppy infant syndrome + withdrawal; - If essential, short-term lowest dose; - AVOID alprazolam if possible; (9) **ECT**: safe in pregnancy + lactation; consider for severe depression/psychosis; (10) **Lactation**: most SSRI low transfer (sertraline preferred); benefits of breastfeeding generally outweigh medication exposure; LactMed resource; (11) **Resources**: MotherToBaby, LactMed, REPROTOX, OB-psychiatry consultation; (12) **Shared decision-making + informed consent**; (13) **Postpartum highest risk for relapse** — close monitoring + medication continuation often important; (14) **Multidisciplinary**: psychiatry, OB, primary care, pediatrics, lactation

---

Pregnancy/lactation psychiatry: balance untreated illness vs medication. Sertraline preferred. Valproate AVOID (NTD). Lithium monitor closely. Lamotrigine acceptable. ECT safe. BZD cautious. Postpartum relapse high — continue often. MotherToBaby, LactMed. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'psychiatry', 'basic_science', 'obgyn', 'adult',
  'ACOG; APA Perinatal; LactMed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง psychiatric medication in pregnancy + lactation safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง psychotropic side effect monitoring + labs', '[{"label":"A","text":"No monitoring needed"},{"label":"B","text":"Psychotropic Medication Monitoring"},{"label":"C","text":"Single test only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Psychotropic Medication Monitoring: (1) **Antipsychotics — atypical metabolic monitoring** (APA/ADA consensus): - **Baseline**: weight + BMI + waist circumference, BP, HbA1c or fasting glucose, fasting lipid panel, personal + family hx CV/DM; - **Follow-up**: weight + BP at 4, 8, 12 wk, then quarterly; HbA1c + lipids at 12 wk, then annually; - More frequent for high-risk agents (olanzapine, clozapine); (2) **Clozapine specific**: - **ANC**: weekly × 6 mo → biweekly × 6 mo → monthly thereafter; discontinue ANC < 1000 (severe < 500); - **Cardiac**: troponin + CRP + ECG at baseline + as indicated; monitor first 4-8 wk for myocarditis (chest pain, fever, dyspnea); - **Bowel**: monitor constipation/ileus; - **Drug levels**: target 350-600 ng/mL; check after dose change, smoking change; (3) **Lithium**: - **Baseline**: CMP (renal — Cr, BUN, eGFR), TSH, Ca + PTH (parathyroid), pregnancy, EKG > 50 yo or CV; - **Levels**: 12h post dose; therapeutic 0.6-1.2 mEq/L (lower for elderly, maintenance); after dose change in 5-7d; with medication changes (NSAID, ACE-I, diuretic); - **Routine**: levels q6-12 mo stable patients; TSH + Ca + Cr q6-12 mo; (4) **Valproate**: - **Baseline + monitoring**: LFT, CBC (thrombocytopenia), levels (50-125 mg/L); ammonia if encephalopathic features; pregnancy testing; (5) **Carbamazepine**: - CBC (aplastic anemia, agranulocytosis), LFT, Na (hyponatremia), levels (4-12 mg/L); HLA-B*1502 testing (Asian) before initiation (SJS risk); (6) **Lamotrigine**: - No routine labs; — SJS/TEN rash monitoring (slow titration); (7) **Stimulants**: - BP + HR baseline + monitoring; pre-existing CV considerations; - Height + weight (peds); - Misuse + diversion assessment; (8) **TCA, MAOI**: less used currently; EKG if cardiac risk; (9) **Antidepressant general**: - Na (SSRI/SNRI elderly — SIADH); - Sexual SE, GI, sleep, suicidality (especially adolescents — FDA boxed warning); (10) **Patient education** about monitoring + adherence essential

---

Psychotropic monitoring: atypical metabolic (weight, glucose, lipids, BP); clozapine (ANC, troponin/CRP/ECG); lithium (level, renal, thyroid, Ca); valproate (LFT, CBC, level); carbamazepine (CBC, LFT, Na, level, HLA-B*1502); lamotrigine (SJS rash); stimulants (BP, HR).', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'ADA/APA metabolic; Clozapine REMS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง psychotropic side effect monitoring + labs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง risk + protective factors for psychiatric disorders', '[{"label":"A","text":"No predictability"},{"label":"B","text":"Risk + Protective Factors for Psychiatric Disorders"},{"label":"C","text":"Single factor"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Risk + Protective Factors for Psychiatric Disorders: (1) **Biological risk**: - Genetics (heritability varies by disorder); - Family history; - Perinatal: maternal infection, malnutrition, obstetric complications, prematurity, maternal substance use; - Childhood TBI; - Medical illness (chronic, neurologic, endocrine); - Hormonal (perinatal, perimenopausal); - Sleep disorders; - Substance use; (2) **Psychological risk**: - Childhood trauma + adverse childhood experiences (ACEs — Felitti) — dose-response with adult mental + physical illness; - Insecure attachment; - Negative cognitive style; - Personality factors (neuroticism); - Prior psychiatric episodes (recurrence predictor); (3) **Social risk**: - Poverty + low SES; - Social isolation; - Discrimination (minority stress); - Migration + acculturation stress; - Adverse environment (community violence); - Family dysfunction; - Bullying; - Unemployment; - Housing instability + homelessness; (4) **Protective factors**: - Stable + supportive relationships; - Social connection + community; - Sense of purpose + meaning (religion, vocation); - Self-efficacy + coping skills; - Emotional regulation; - Healthy lifestyle (exercise, sleep, diet); - Treatment engagement when needed; - Cognitive flexibility; - Optimism (within reason); - Resilience traits; (5) **Specific examples**: - **Depression**: female sex, family hx, ACEs, chronic illness, isolation, loss, perimenopause, postpartum, low SES; - **PTSD**: trauma exposure + low cortisol pre-trauma + lack of social support; - **Schizophrenia**: family hx, prenatal/perinatal complications, cannabis (high-potency, adolescent), urban birth, migration, paternal age; - **Substance use**: family hx, ACEs, peer use, mental health comorbidity, early initiation, low SES; - **Suicide**: prior attempt (biggest), mental illness, substance use, isolation, recent loss, access to means; (6) **Life course perspective**: developmental periods + cumulative risk; (7) **Modifiable** vs **non-modifiable** distinction useful clinically; (8) **Intersectionality**: multiple identities + adversities compound; (9) **Universal + selective + indicated prevention** based on risk level; (10) **Multidisciplinary + multilevel** intervention

---

Risk + protective factors: biological (genetics, perinatal), psychological (ACEs, attachment, cognitive style), social (poverty, isolation, discrimination). Protective: relationships, purpose, coping. Disorder-specific patterns. Life course + intersectional + cumulative.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Felitti ACEs; WHO Mental Health Promotion', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง risk + protective factors for psychiatric disorders'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง childhood + adolescent brain development + psychiatric implications', '[{"label":"A","text":"Adolescent brain same as adult"},{"label":"B","text":"Childhood + Adolescent Brain Development + Psychiatric Implications"},{"label":"C","text":"No critical periods"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Childhood + Adolescent Brain Development + Psychiatric Implications: (1) **Brain development**: - Prefrontal cortex matures last (~ age 25); - Limbic system + reward circuits mature earlier (adolescence); - Synaptic pruning + myelination through adolescence; - Plasticity high in childhood + adolescence — critical periods; (2) **Adolescent risk-taking**: imbalance reward circuits (mature) vs prefrontal regulation (immature) → impulsivity, risk-taking, sensation-seeking — normative; substance use + accidents peak; psychiatric disorder onset peak (50% by age 14, 75% by age 24); (3) **Vulnerability**: - **Substance use**: adolescent brain especially vulnerable; cannabis affects executive function + may increase psychosis risk especially with family hx + high potency + early initiation; alcohol impacts hippocampus + frontal; - **Stress + trauma**: ACEs more impactful in critical periods; epigenetic effects; - **Depression + anxiety**: adolescent onset common — different risk factors + treatment considerations than adult; - **Eating disorders**: adolescent peak; - **First episode psychosis** in young adulthood; - **Suicide risk** adolescent — peer + media + bullying + LGBTQ+ minority stress; (4) **Medication considerations in youth**: - **SSRI** — FDA boxed warning increased SI in adolescents (CAMS trial — combination SSRI + CBT optimal for adolescent anxiety); benefit > risk for most; close monitoring; - **Stimulants** — growth + appetite + sleep + CV monitoring; - **Antipsychotic** — greater metabolic vulnerability in youth; weight gain; - **Lithium + valproate + AED**: monitoring; valproate avoided in adolescent girls (NTD if pregnancy); (5) **Psychotherapy modifications**: - Family involvement essential; - Developmentally appropriate techniques; - School coordination; - Trauma-informed; (6) **Confidentiality + consent**: assent + parental consent for minors; confidentiality between adolescent + provider (with limits for safety) — important for engagement; (7) **Transitions to adult care**: gap in services; transition planning; (8) **Modern**: prevention + early intervention — return on investment in adolescent mental health; (9) **Adolescent-specific clinics + programs**; (10) **Digital interventions** appeal to youth (apps, online)

---

Adolescent brain: PFC matures last (~25), limbic earlier. Imbalance → risk-taking. Critical periods + plasticity. Substance vulnerability. CAMS — SSRI + CBT for adolescent anxiety. Family + school coordination. Confidentiality with safety limits. Prevention + early intervention.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'peds',
  'Casey Adolescent Brain; CAMS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง childhood + adolescent brain development + psychiatric implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง trauma-informed care + practical application', '[{"label":"A","text":"No relevance"},{"label":"B","text":"Trauma-Informed Care (TIC) — SAMHSA Framework"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all patients with trauma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma-Informed Care (TIC) — SAMHSA Framework: (1) **Four R''s**: - **Realize** widespread impact of trauma; - **Recognize** signs + symptoms; - **Respond** with knowledge + integration; - **Resist re-traumatization**; (2) **Six key principles**: - Safety (physical + psychological); - Trustworthiness + transparency; - Peer support; - Collaboration + mutuality; - Empowerment, voice, choice; - Cultural, historical, gender issues; (3) **Trauma prevalence**: 70%+ adults experience trauma; psychiatric populations even higher; (4) **Universal approach**: assume potential trauma in all patients — don''t require disclosure; (5) **Practical applications**: - Avoid retraumatization triggers (restraint, seclusion, forced disrobing, sudden touching, loud noises); - Trauma screening — ACE, PTSD; - Patient choice + collaboration; - Explanation + consent; - Address physical + emotional safety; - Predictability + transparency; - Strengths-based vs deficit-based; (6) **Clinical contexts**: - Mental health treatment; - Substance use treatment; - Primary care; - Emergency departments (restraint debriefing); - Inpatient (open units when possible, choice in care, education for staff); - Pediatric — adverse childhood experiences screening; - Refugees + immigrants (cultural trauma); - Indigenous communities (historical trauma); - Domestic violence + sexual assault; - LGBTQ+ (minority stress trauma); (7) **Provider self-care**: - Vicarious traumatization; - Burnout prevention; - Supervision + peer support; (8) **System-level**: - Policy changes; - Training all staff (not just clinical); - Trauma champion roles; - Continuous improvement; (9) **Distinguish from trauma treatment**: TIC is approach to all care; trauma treatment is specific (PE, CPT, EMDR for PTSD); (10) **Modern integration**: TIC standard in healthcare systems + criminal justice + education + child welfare

---

Trauma-Informed Care: SAMHSA 4 R''s (Realize, Recognize, Respond, Resist retraumatization) + 6 principles (safety, trust, peer, collaboration, empowerment, cultural). Universal — assume trauma. Practical: avoid retraumatization, choice + collaboration, screening. TIC = approach; trauma treatment = specific.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'SAMHSA TIC; ACE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง trauma-informed care + practical application'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง assessment tools + rating scales in psychiatry', '[{"label":"A","text":"No scales useful"},{"label":"B","text":"Psychiatric Assessment Tools + Rating Scales"},{"label":"C","text":"Single scale all"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Psychiatric Assessment Tools + Rating Scales: (1) **Depression**: - **PHQ-9** (most widely used screening + monitoring; 9 items; cut-offs); - **Beck Depression Inventory (BDI-II)**; - **Hamilton Depression Rating Scale (HAM-D)** — clinician-rated; - **MADRS** — clinician; - **GDS** — geriatric (less somatic); - **EPDS** — perinatal; (2) **Anxiety**: - **GAD-7** (most widely used); - **HAM-A**; - **Beck Anxiety Inventory**; - **Penn State Worry Questionnaire (PSWQ)** — GAD specific; - **Liebowitz Social Anxiety (LSAS)**; - **Panic Disorder Severity Scale (PDSS)**; (3) **OCD**: - **Y-BOCS** — Yale-Brown — gold standard; (4) **PTSD**: - **PCL-5** — self-report screen; - **CAPS-5** — gold standard clinician-rated; (5) **Mania**: - **Young Mania Rating Scale (YMRS)**; - **MDQ** — Mood Disorder Questionnaire — bipolar screening; (6) **Psychosis**: - **PANSS** (Positive + Negative Syndrome Scale) — schizophrenia, research; - **SAPS, SANS**; - **BPRS**; (7) **Suicide**: - **Columbia Suicide Severity Rating Scale (C-SSRS)**; - **Beck Scale for Suicide Ideation**; (8) **Substance use**: - **AUDIT** (alcohol); - **DAST** (drug); - **CIWA-Ar** (alcohol withdrawal); - **COWS** (opioid withdrawal); - **ASSIST** (WHO); (9) **Cognitive**: - **MMSE** (most known but copyright); - **MoCA** (Montreal — sensitive MCI); - **SLUMS**; - **Mini-Cog**; - **AD8** (informant); (10) **ADHD**: - **ADHD Rating Scale** (parent + teacher); - **Conners**; - **Vanderbilt**; - **ASRS-v1.1** (adult screening); (11) **Eating disorders**: - **EDE-Q**; - **SCOFF** (screening); (12) **Quality of life + functioning**: - **GAF** (historical); - **WHODAS** — WHO Disability Assessment Schedule; (13) **Personality**: - **PID-5** (DSM-5 dimensional); - **NEO PI-R**; (14) **Modern**: - Measurement-based care — routine outcomes; - Patient-Reported Outcomes Measurement Information System (PROMIS); - Digital + computerized adaptive testing emerging; (15) **Cultural + linguistic adaptation** important

---

Rating scales: PHQ-9 (depression), GAD-7 (anxiety), Y-BOCS (OCD), PCL-5/CAPS-5 (PTSD), YMRS (mania), C-SSRS (suicide), AUDIT/DAST (substance), MoCA (cognitive), ASRS (adult ADHD), EDE-Q (eating), WHODAS (function). Measurement-based care.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'APA Measurement-Based Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง assessment tools + rating scales in psychiatry'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง cultural psychiatry + considerations', '[{"label":"A","text":"Culture irrelevant"},{"label":"B","text":"Culture affects all aspects"},{"label":"C","text":"Single approach"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cultural Psychiatry: (1) **Culture affects all aspects**: - Symptom expression + interpretation; - Help-seeking patterns; - Treatment preferences; - Family + community role; - Stigma; - Spirituality + religion; - Causation beliefs; - Trust in healthcare; (2) **DSM-5 Cultural Formulation Interview (CFI)**: - Cultural definition of problem; - Cultural perceptions of cause + context + support; - Cultural factors affecting self-coping + past help-seeking; - Cultural factors affecting current help-seeking; (3) **Culture-bound (now ''cultural concepts of distress'' DSM-5)**: - **Susto** (Latin — fright illness); - **Ataque de nervios** (Latin — uncontrolled grief/anger); - **Dhat syndrome** (South Asia — semen loss anxiety); - **Koro** (Asia — genital retraction); - **Khyâl cap** (''wind attacks'' Cambodia); - **Taijin kyofusho** (Japan — fear of offending others); - **Ghost sickness** (Native American); - **Maladi moun** (Caribbean); (4) **Thai cultural context**: - Buddhist concepts of suffering, karma, mindfulness; - Family-centered decision-making; - Stigma for severe mental illness; - Spirit + ancestor beliefs influence; - Somatization more accepted than psychological complaints; - Respect for hierarchy + face-saving; (5) **Immigrant/refugee mental health**: - Pre-migration trauma, migration trauma, post-migration adversity; - Acculturation stress; - Discrimination; - Family separation; - Language barriers; - Healthcare access; (6) **LGBTQ+ minority stress** (Meyer): - Distal stressors (discrimination); - Proximal stressors (concealment, internalized stigma); - Increased mental health disorders + suicide risk; - Affirming care reduces; (7) **Indigenous mental health**: - Historical trauma; - Colonization effects; - Cultural healing practices; - Community-based approaches; (8) **Language services**: - Professional interpreter (not family) for clinical interactions; - Translated materials; - Culturally adapted instruments; (9) **Provider cultural humility** vs cultural competence — ongoing learning + self-reflection; (10) **Multidisciplinary**: cultural consultants, traditional healers integration where appropriate, peer support; (11) **Avoid stereotyping** — individual variation within cultures; (12) **Modern**: cultural psychiatry integrated into all training; global mental health priority

---

Cultural psychiatry: culture affects symptom expression + help-seeking + treatment. DSM-5 CFI tool. Cultural concepts of distress (susto, ataque, dhat, koro). Thai Buddhist context. Immigrant/refugee considerations. LGBTQ+ minority stress. Language services. Cultural humility.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'DSM-5 CFI; Kleinman', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง cultural psychiatry + considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง measurement-based care + quality improvement in psychiatric practice', '[{"label":"A","text":"No measurement needed"},{"label":"B","text":"Measurement-Based Care (MBC) + Quality Improvement"},{"label":"C","text":"Single visit assessment"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Measurement-Based Care (MBC) + Quality Improvement: (1) **MBC definition**: routine use of standardized rating scales + symptom measures to guide clinical decisions; (2) **Components**: - Baseline assessment with validated scale; - Repeat measurements at regular intervals (typically each visit); - Use results to guide treatment decisions (continue, augment, switch); - Patient + clinician collaborative review; (3) **Common scales for MBC**: PHQ-9 (depression), GAD-7 (anxiety), AUDIT (alcohol), C-SSRS (suicide); standardized + brief + free + sensitive to change; (4) **Evidence**: - **STAR*D** + replication — MBC improves outcomes vs usual care; - Earlier identification of non-response; - Reduces treatment-as-usual variability; - Patient engagement + activation; (5) **Quality measures**: - Screening rates; - Treatment initiation; - Response + remission rates; - Suicide screening + follow-up; - Adherence; - Patient satisfaction; (6) **Implementation challenges**: - Time constraints; - Workflow integration; - EHR design; - Training; - Reimbursement; (7) **Solutions**: - Digital + patient portal pre-visit assessment; - Brief scales; - Integration into EHR + dashboards; - Care team workflow; - Reimbursement incentives (HEDIS, MIPS); (8) **Collaborative Care Model integration** — MBC core component (IMPACT trial); (9) **Population health**: - Registry-based; - Stepped care; - Outreach for non-improvers; (10) **Outcomes-based reimbursement**: pay-for-performance, value-based; (11) **Patient-Reported Outcome Measures (PROMs)**: increasing use; PROMIS measures; (12) **Equity considerations**: validity across populations; language; literacy; (13) **AIMS Center, APA, NIMH** advocacy + resources; (14) **Modern psychiatric quality** indicators: depression screening, follow-up after psych discharge, antipsychotic monitoring, adherence, suicide risk follow-up; (15) **Cochrane** + APA endorse MBC

---

Measurement-Based Care: routine rating scales (PHQ-9, GAD-7) guiding treatment decisions. Evidence STAR*D shows improved outcomes. Quality measures + implementation via EHR + collaborative care. Stepped care + outreach. Reimbursement incentives. Modern psychiatric quality.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'STAR*D; APA MBC; AIMS Center', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง measurement-based care + quality improvement in psychiatric practice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง therapeutic alliance + common factors in psychotherapy', '[{"label":"A","text":"No alliance needed"},{"label":"B","text":"Therapeutic Alliance + Common Factors"},{"label":"C","text":"Technique only"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Therapeutic Alliance + Common Factors: (1) **Common factors theory** (Frank, Wampold): - Effectiveness of psychotherapy partially due to specific techniques but largely due to shared ''common factors'' across orientations; - Therapeutic alliance, expectancy, empathy, positive regard, congruence, goal consensus, collaboration; (2) **Therapeutic alliance** (Bordin): - Bond (emotional connection); - Agreement on goals; - Agreement on tasks; - Most robust predictor of outcomes across modalities (effect size 0.5-0.6); - Patient + clinician perspectives — patient perception more predictive than clinician; - Early alliance (sessions 3-5) predictive of outcome; - Alliance ruptures inevitable — repair process therapeutic; (3) **Therapist factors**: - Empathy (Rogers — accurate empathy + unconditional positive regard + congruence); - Microskills + warmth + non-judgmental; - Training + experience matter but less than expected; - Therapist effects exceed treatment effects; (4) **Patient factors**: - Engagement + motivation; - Severity of illness; - Comorbidity; - Previous treatment experience; (5) **Cultural alliance**: - Cultural humility; - Adaptation; - Match (sometimes patient preference); - Language; (6) **Communication skills** essential: - Open-ended questions; - Reflection; - Summary; - Motivational interviewing; - Non-verbal awareness; (7) **Boundaries** + professional behavior; (8) **Ruptures**: identify, address, repair — often growth opportunity; (9) **Telepsychiatry alliance** — comparable to in-person for most; some challenges (technology, non-verbal); (10) **Group + family therapy alliance** — multiple alliances simultaneously; (11) **Provider self-care + supervision** — important for sustaining ability to form alliance; burnout impairs; (12) **Outcomes**: alliance contributes 5-15% of outcome variance (significant despite small percentage); (13) **Modern**: precision matching of therapist + patient — research limited but emerging

---

Therapeutic alliance + common factors: alliance (Bordin — bond + goals + tasks) most robust outcome predictor across modalities. Common factors theory (Wampold). Empathy + warmth + congruence (Rogers). Ruptures + repair therapeutic. Patient perspective key. Telepsychiatry comparable.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Wampold; Bordin; Norcross', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง therapeutic alliance + common factors in psychotherapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implementing assertive community treatment (ACT) program for severe mental illness', '[{"label":"A","text":"Office-based weekly visits only"},{"label":"B","text":"Assertive Community Treatment (ACT) — Evidence-Based Community Care Model"},{"label":"C","text":"No multidisciplinary team"},{"label":"D","text":"Surgery"},{"label":"E","text":"Standard outpatient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Assertive Community Treatment (ACT) — Evidence-Based Community Care Model: (1) **Population**: severe + persistent mental illness (schizophrenia, severe BP, severe MDD) with high service utilization (frequent hospitalizations, ED visits), housing instability, treatment non-adherence, dual diagnosis; (2) **Core principles**: - **Team-based**: multidisciplinary team (psychiatry, nursing, social work, peer support, substance use specialist, vocational specialist, housing specialist); - **In vivo** services — community + home + workplace, not office-based; - **24/7 availability**; - **Low caseload** — 10:1 patient:staff ratio; - **Time-unlimited** services; - **Frequent contact** (multiple visits/week); - **Comprehensive** services (medication, psychotherapy, case management, employment, housing, social, family); (3) **Outcomes** (Stein + Test Wisconsin original): - Reduces hospitalizations + ED visits; - Improves housing stability; - Improves community functioning; - Improves quality of life; - Cost-effective despite intensive services; (4) **Fidelity matters**: DACTS scale (Dartmouth Assertive Community Treatment Scale); programs varying in fidelity have varying outcomes; (5) **Variations**: - **Forensic ACT (FACT)** — criminal justice involved; - **CTI** (Critical Time Intervention) — time-limited transition support; (6) **Integration**: - Substance use treatment integrated (dual diagnosis); - Vocational rehabilitation (supported employment); - Housing (Housing First model); - Primary care coordination; - Family involvement; (7) **Modern adaptations**: - Telepsychiatry component; - Recovery-oriented (peer support, choice, strengths-based); - Trauma-informed; (8) **Limitations**: cost, workforce, urban vs rural feasibility; (9) **Compared to alternatives**: ACT > standard case management for severe illness; ACT not necessary for moderate illness; (10) **Long-term**: chronic illness model; not ''cure'' but sustained support

---

Assertive Community Treatment (ACT): severe mental illness, multidisciplinary team, in vivo, 24/7, low caseload, time-unlimited, comprehensive. Reduces hospitalization, improves housing + function. Fidelity matters (DACTS). Variations FACT, CTI. Modern: recovery + trauma-informed + telepsych.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'Stein + Test ACT; Dartmouth', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital implementing assertive community treatment (ACT) program for severe mental illness'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare system planning to reduce psychiatric ED boarding + improve crisis services', '[{"label":"A","text":"ED-only response"},{"label":"B","text":"Crisis Services Continuum — Comprehensive Approach"},{"label":"C","text":"No crisis services"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Crisis Services Continuum — Comprehensive Approach: (1) **988 Suicide + Crisis Lifeline** (US 2022 — equivalent in Thailand 1323): national hotline + text + chat; (2) **Mobile crisis teams**: - Community-based response to mental health crisis; - Police diversion (CIT model); - In-person assessment + de-escalation in person''s environment; - Bridge to services; - Reduce involuntary holds + arrests + ED visits; (3) **Crisis stabilization units / short-term observation**: - 23-72h stays; - Alternative to ED + hospitalization; - Comfortable, less restrictive setting; - Trauma-informed; - Bridge to outpatient; (4) **Crisis residential**: 7-14 days, peer-supported, less restrictive than hospital, voluntary; (5) **Peer-run respite**: alternative model, peer-led; (6) **CIT (Crisis Intervention Team) for police**: - 40-hour mental health training; - Diversion vs arrest for mental health crises; - Co-response models (police + clinician); (7) **Psychiatric ED**: dedicated psychiatric emergency services; (8) **Reduce ED boarding** (psychiatric patients in medical ED awaiting psych bed): - Real-time bed registries; - Telepsychiatry consultation; - Expedited transfer protocols; - Alternatives to hospitalization (crisis services); - Address upstream — outpatient access, social determinants; (9) **Post-crisis follow-up**: caring contacts (postcards, calls — reduce re-attempts), warm handoffs to outpatient, safety planning (Stanley-Brown); (10) **Continuum integration**: hotline → mobile crisis → stabilization → residential → outpatient — varying intensity; person-centered; (11) **System level**: data + tracking, outcomes monitoring, equity (disparities in access + outcomes), payment reform; (12) **Modern**: ''Crisis Now'' framework (SAMHSA + NASMHPD) — 3 components: regional crisis call center + mobile crisis + crisis receiving + stabilization facilities; (13) **Multidisciplinary**: psychiatry, nursing, social work, peer support, police partnership, hospital

---

Crisis services continuum: 988/1323 hotline, mobile crisis, crisis stabilization (23-72h), residential, peer respite, CIT police. Reduces ED boarding + involuntary holds. Post-crisis follow-up (caring contacts, warm handoff). ''Crisis Now'' framework. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'SAMHSA Crisis Now; CIT International', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Healthcare system planning to reduce psychiatric ED boarding + improve crisis services'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mental health system addressing workforce shortage + access disparities', '[{"label":"A","text":"No solutions available"},{"label":"B","text":"Mental Health Workforce + Access — Multi-pronged Approach"},{"label":"C","text":"Specialty referral only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mental Health Workforce + Access — Multi-pronged Approach: (1) **Workforce shortage** (global + national): - Psychiatrist shortage particularly rural + child + addiction + geriatric; - WHO global mental health workforce gap; - Loan forgiveness programs (NHSC US, HRSA); - Pipeline programs (URM, rural-track residencies); (2) **Task-sharing** + workforce expansion: - Mental health nursing, social work, psychology, peer support, community health workers; - WHO mhGAP (Mental Health Gap Action Programme) for low-resource settings; - **Friendship Bench** (Zimbabwe — lay health workers, evidence-based); - Primary care integration; (3) **Collaborative Care Model** (Wagner Chronic Care + Unützer IMPACT): - Integration mental health + primary care; - Care manager + psychiatric consultant + measurement-based care; - 2× improvement vs usual care; - Cost-effective; - Workforce multiplication — one psychiatrist serves many primary care patients; (4) **Telepsychiatry** + digital expansion: - Specialist reach extension; - Rural + underserved; - Reimbursement parity post-COVID; - Asynchronous (eConsult); - Mobile apps + digital therapeutics; (5) **Cultural + linguistic workforce**: - Diversity of providers improves access for diverse populations; - Trained interpreters; - Cultural adaptation training; (6) **Equity considerations**: - Insurance coverage parity (Mental Health Parity Act US); - Geographic distribution; - Out-of-network barriers; - Stigma; - Transportation; - Child care; - Work schedules; (7) **Prevention + early intervention** reduce downstream needs: - School-based mental health; - Pediatric primary care; - Workplace mental health; (8) **Self-management + lower-intensity options**: - Digital CBT (Sleepio, Woebot); - Bibliotherapy; - Peer-led groups; - Apps + online resources; - Self-help (NAMI, etc.); (9) **Stepped care**: matching intensity to severity; (10) **Modern**: precision matching + flexible delivery + integration

---

Mental health workforce shortage: task-sharing (WHO mhGAP, Friendship Bench), Collaborative Care (IMPACT), telepsychiatry, primary care integration, peer support, digital therapeutics, equity initiatives. Prevention + early intervention reduce need. Stepped care. Modern: flexible + precision delivery.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'WHO mhGAP; Unützer IMPACT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Mental health system addressing workforce shortage + access disparities'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implementing inpatient psychiatric quality + safety program', '[{"label":"A","text":"No safety planning needed"},{"label":"B","text":"Inpatient Psychiatric Quality + Safety"},{"label":"C","text":"Restraints first-line"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Inpatient Psychiatric Quality + Safety: (1) **Safety measures**: - **Suicide prevention** on inpatient units: - Environmental risk assessment (ligature points, accessible hazards); - Reduce ligature risk (psychiatric-safe rooms, fittings, doors); - Sharp + chemical access control; - Monitoring + 1:1 observation policies; - Patient property search; - Visitor screening; - Suicide assessment + safety planning; - Post-discharge transition (highest risk period); - **Caring contacts** post-discharge reduce re-attempts; - **Zero Suicide initiative**; (2) **Violence prevention**: - Risk assessment (BVC — Brøset Violence Checklist); - De-escalation training (Project BETA); - Environment (safety, no weapons access); - Adequate staffing; - Trauma-informed; (3) **Restraint + seclusion reduction**: - Last resort principle; - 6 Core Strategies (NASMHPD); - Comfort rooms, sensory modulation; - Debrief after events; - Staff training; - Trauma-informed; (4) **Medical safety**: - Falls; - VTE prophylaxis; - Medication errors (especially psychotropic); - Metabolic monitoring; - Medical comorbidity attention (acute issues not missed in psychiatric setting); - Pneumonia, sepsis screening; (5) **Quality measures**: - HBIPS (Hospital-Based Inpatient Psychiatric Services) — Joint Commission measures: - Hours of physical restraint use; - Hours of seclusion; - Patients discharged on multiple antipsychotics with justification; - Continuing care plan; - Multiple antipsychotic with appropriate justification; - Follow-up after psychiatric hospitalization; (6) **Patient experience + recovery-orientation**: - Patient + family voice; - Choice in treatment; - Education; - Discharge planning early + collaborative; (7) **Transitions of care**: - Discharge summary; - Outpatient appointment within 7 days (HBIPS quality measure); - Warm handoffs; - Medication reconciliation; - Communication with PCP + family; (8) **Staff well-being**: - Training; - Supervision; - Critical incident debrief; - Burnout prevention; (9) **Continuous quality improvement**: - Adverse event review; - Patient feedback; - Outcomes tracking; (10) **Multidisciplinary**: nursing, psychiatry, social work, OT, peer support, administration

---

Inpatient psychiatric safety: suicide prevention (Zero Suicide, environmental, caring contacts), violence prevention (BVC, BETA), restraint reduction (6 Core Strategies), medical safety, HBIPS quality measures, transitions of care, staff well-being. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'Zero Suicide; HBIPS; NASMHPD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital implementing inpatient psychiatric quality + safety program'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare system developing recovery-oriented mental health services', '[{"label":"A","text":"Symptom focus only"},{"label":"B","text":"Recovery-Oriented Mental Health Services"},{"label":"C","text":"Provider-directed"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Recovery-Oriented Mental Health Services: (1) **Recovery definition** (SAMHSA): - Process of change through which individuals improve health + wellness, live self-directed life, strive to reach full potential; - Distinct from symptom remission; - Person-centered, hopeful, sustained; (2) **Recovery dimensions**: - Health (physical + mental); - Home (stable housing); - Purpose (meaningful activities, work, education); - Community (relationships, social networks); (3) **CHIME framework** (Connectedness, Hope, Identity, Meaning, Empowerment — Leamy); (4) **Components of recovery-oriented services**: - **Person-centered planning** — individual goals + strengths + preferences; - **Peer support specialists** — lived experience, hope, recovery role models — emerging evidence-based workforce; - **Shared decision-making** — collaborative treatment decisions; - **Strengths-based** vs deficit-based approach; - **Self-management + self-advocacy** education; - **Wellness Recovery Action Plan (WRAP)**; - **Trauma-informed care**; - **Cultural responsiveness**; - **Family + community integration**; - **Reduce coercion** — voluntary engagement, alternatives to involuntary; - **Housing First** (immediate housing + supports); - **Supported employment** (IPS — Individual Placement + Support — evidence-based); - **Supported education**; (5) **Distinct from + complementary to medical model**: - Both clinical treatment + recovery support; - Both ''recovery in'' (symptom reduction) + ''recovery of'' (meaningful life despite illness); (6) **System changes**: - Peer workforce integration; - Recovery-oriented training for all staff; - Outcome measures including QoL, function, not just symptoms; - Anti-stigma initiatives; (7) **Modern**: - Recovery-oriented systems of care (ROSC) for substance use; - Mental Health Recovery Network; - International evidence base growing (UK, Australia, New Zealand leadership); (8) **Critiques + integration**: balance recovery with severity of illness, persistent disability needs, family advocacy; (9) **Outcomes**: improved engagement, satisfaction, function, reduced re-hospitalization

---

Recovery-oriented services (SAMHSA): person-centered, CHIME framework (Connectedness, Hope, Identity, Meaning, Empowerment). Peer support, shared decision-making, strengths-based, WRAP, Housing First, IPS supported employment. Both ''recovery in'' + ''recovery of''.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'SAMHSA; Leamy CHIME', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Healthcare system developing recovery-oriented mental health services'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital integrating addiction medicine + harm reduction approaches', '[{"label":"A","text":"Abstinence only requirement"},{"label":"B","text":"Addiction Medicine + Harm Reduction Integration"},{"label":"C","text":"No harm reduction"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Addiction Medicine + Harm Reduction Integration: (1) **Addiction as chronic disease**: - Brain disease model; - Treat with evidence-based interventions like other chronic diseases; - Reduce moralizing + stigma; - ASAM clinical model; (2) **Harm reduction principles**: - Meet people where they are; - Reduce harms of substance use while not requiring abstinence; - Pragmatic + compassionate; - Reduce stigma; - Save lives first; - Continuum: harm reduction → MAT → abstinence (individual journey); (3) **Specific interventions**: - **Naloxone distribution** + training (community + family + first responders) — reduces opioid overdose deaths; OTC in many places; - **Syringe service programs (SSP)** — clean needles, prevent HIV/HCV transmission; - **Drug checking** — fentanyl test strips, drug analysis; - **Safe consumption sites** (controversial in US, established in Europe, Canada, Australia) — supervised injection, prevent overdose, link to services; - **Medication-assisted treatment (MAT)** — buprenorphine, methadone, naltrexone — evidence-based, reduces mortality 50%; ASAM model; - **Low-threshold treatment** (no abstinence required for entry); - **Mobile + low-barrier services**; (4) **Integration into healthcare**: - **SBIRT** (Screening, Brief Intervention, Referral to Treatment) primary care; - **ED-initiated buprenorphine** (D''Onofrio JAMA 2015 — increases engagement); - **Hospitalization as opportunity** for treatment initiation; - **Addiction medicine consultation** — improves outcomes; - **Outpatient buprenorphine** — primary care + specialty; (5) **Address structural barriers**: - X-waiver removed 2023 (US — easier to prescribe buprenorphine); - Methadone access (clinics — restrictive); - Insurance coverage; - Stigma in healthcare; (6) **Co-occurring disorders** (dual diagnosis): - Integrated treatment essential; - Address mental health + substance use simultaneously; (7) **Hepatitis C treatment** regardless of active use — curative DAAs; (8) **HIV PrEP + treatment**; (9) **Modern**: - Stimulant use disorder no MAT yet — contingency management evidence-based; - Cannabis use disorder no FDA medication; - Opioid epidemic + fentanyl crisis = urgent harm reduction expansion; (10) **Multidisciplinary**: addiction medicine, primary care, psychiatry, infectious disease, social work, peer recovery support

---

Addiction + harm reduction: chronic disease model. Harm reduction (naloxone, SSP, drug checking, safe consumption, MAT) saves lives. SBIRT + ED-initiated buprenorphine + addiction consult. Integrated co-occurring treatment. HCV/HIV treatment. Stimulant — contingency management. Stigma reduction.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'ASAM; SAMHSA Harm Reduction', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital integrating addiction medicine + harm reduction approaches'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare system improving mental health for healthcare workers + burnout', '[{"label":"A","text":"Individual responsibility only"},{"label":"B","text":"Healthcare Worker Mental Health + Burnout"},{"label":"C","text":"No support needed"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Healthcare Worker Mental Health + Burnout: (1) **Burnout** (Maslach): emotional exhaustion + depersonalization + reduced personal accomplishment; (2) **Prevalence high**: 40-60% physicians + nurses; worsened by COVID-19 pandemic; (3) **Consequences**: - Personal — depression, anxiety, substance use, suicide (physicians at elevated risk), divorce; - Patient care — medical errors, lower quality, reduced empathy; - System — turnover, absenteeism, workforce shortage; (4) **Drivers** (system-level not individual): - Workload + EHR documentation burden; - Lack of autonomy; - Inefficient processes; - Moral injury (constraints prevent providing care believed needed); - Toxic culture; - Insufficient support; - Inadequate staffing; (5) **System-level interventions** (essential — individual interventions alone insufficient): - **Reduce administrative burden** (EHR optimization, scribes); - **Leadership development**; - **Workload management**; - **Schedule flexibility**; - **Team-based care**; - **Stanford WellMD model**; (6) **Individual-level support**: - **Confidential mental health services** (separate from credentialing); - **Peer support programs** (Code Lavender, second victim); - **Employee assistance programs**; - **Wellness initiatives**; - **Mindfulness, exercise, sleep**; (7) **Stigma reduction**: - Mental health licensing questions — many states reformed to focus on impairment not history; - Confidential treatment; - Modeling — leadership disclosing own mental health; (8) **Substance use** in healthcare: - Higher rates in some specialties (anesthesiology, EM); - Physician Health Programs (PHP) — confidential treatment + monitoring; - Recovery support; (9) **Physician suicide**: - Higher rate especially female physicians; - Means restriction (medication access); - Address contributors; - Resources (988, NAMI, AMA, AFSP); (10) **Trainee mental health**: - Residents particularly vulnerable; - ACGME requirements + duty hour limits; - Resident wellness programs; - Mentorship; (11) **Pandemic-specific**: PTSD, moral injury, exhaustion — ongoing recovery; (12) **Multidisciplinary leadership + culture change** essential; (13) **Modern**: AMA + Joint Commission emphasis on system-level + Quintuple Aim including workforce well-being

---

Healthcare worker burnout: 40-60%; system-level drivers (workload, EHR, moral injury, culture). System interventions (reduce admin burden, leadership, workload), individual support (confidential care, peer support, EAP), stigma reduction (licensing), PHP for substance use, physician suicide prevention. Modern: Quintuple Aim.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'Maslach; Stanford WellMD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Healthcare system improving mental health for healthcare workers + burnout'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี HIV+ + cocaine use disorder + depression + medication non-adherence + unstable housing — multidisciplinary integrative management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"HIV + Stimulant Use Disorder + Depression + Social Instability — Integrated Multidisciplinary"},{"label":"C","text":"Refuse care due to non-adherence"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV + Stimulant Use Disorder + Depression + Social Instability — Integrated Multidisciplinary: (1) **HIV care**: ART adherence + viral suppression — link to HIV care; ART medication interactions check (avoid ritonavir + many antidepressants); HCV/STI testing; CD4 + VL monitoring; PrEP for partners; (2) **Cocaine use disorder**: - NO FDA medication; - Contingency management most evidence-based; - CBT, motivational interviewing; - 12-step (CA, NA); - Address triggers + cravings; - Harm reduction (fentanyl test strips, naloxone availability — fentanyl contamination of cocaine); (3) **Depression**: - SSRI (sertraline, escitalopram — check ART interactions); - CBT, IPT; - Address comorbid; - Suicide assessment; (4) **Social determinants** (foundational — without addressing, treatment won''t stick): - **Housing First** — immediate stable housing reduces substance use, mental health symptoms, healthcare costs; - Income support, benefits, SSDI; - Employment (when ready) — Individual Placement + Support; - Health insurance enrollment; - Transportation; - Food security; - Legal assistance (civil + criminal); (5) **Adherence support**: - Pill organizers + reminders; - Directly observed therapy (DOT) for HIV in some models; - Address mental health + substance — major adherence drivers; - Patient-centered care; - Peer navigators; (6) **Integrated care site** ideal — co-located HIV, mental health, substance use, primary care, social work, case management; (7) **Trauma-informed care** — many at intersection have trauma history; (8) **Cultural + LGBTQ+ + minority affirmation** if applicable; (9) **Multidisciplinary**: infectious disease, psychiatry, addiction medicine, primary care, social work, peer support, housing specialist; (10) **Long-term**: chronic illnesses + chronic social complexity; sustained care + flexibility

---

Complex HIV + stimulant use + depression + unstable housing: integrated multidisciplinary essential. HIV care + ART (check interactions). Cocaine — contingency management. Depression SSRI + CBT. SOCIAL DETERMINANTS foundational (Housing First). Integrated site + peer support. Trauma-informed.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'HIVMA; HUD Housing First', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี HIV+ + cocaine use disorder + depression + medication non-adherence + unstable housing — multidisciplinary integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี chronic pain (LBP) + opioid use disorder + PTSD + insomnia + comorbid CV disease — integrative care plan', '[{"label":"A","text":"Escalating opioids"},{"label":"B","text":"Chronic Pain + OUD + PTSD + Insomnia + CVD — Integrative Multidisciplinary"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pain + OUD + PTSD + Insomnia + CVD — Integrative Multidisciplinary: (1) **Bidirectional relationships**: pain ↔ depression ↔ PTSD ↔ sleep ↔ substance use; CVD added complexity; (2) **OUD treatment foundational**: - **Buprenorphine** — treats addiction + provides analgesia (partial mu agonist); ideal in this profile; less CV stress than methadone; lower diversion than oral opioids; - Methadone alternative; - Naltrexone after detox; - Reduces mortality 50%; (3) **Chronic pain non-opioid + non-pharmacologic**: - **CBT for chronic pain** (evidence-based); - **PT + graded exercise**; - **Mindfulness-based stress reduction**; - **Acceptance + commitment therapy**; - **SNRI** (duloxetine — pain + depression + reasonable CV profile); - **Topical** (lidocaine, capsaicin); - **Anticonvulsant** (gabapentin, pregabalin — caution misuse + falls + sedation); - **Procedure** (selective steroid injection, RFA); - AVOID escalating opioids beyond MAT; (4) **PTSD treatment**: - **Trauma-focused therapy** — PE, CPT, EMDR; - **SSRI** (sertraline, paroxetine FDA-approved); - **Prazosin** for nightmares; - AVOID benzodiazepines (worsen PTSD); - May address pain via stress reduction; (5) **Insomnia**: - **CBT-I** gold standard; - AVOID benzodiazepines + nightly opioids; - Melatonin agonist, DORA, low-dose trazodone, doxepin alternatives; - Sleep hygiene; (6) **CV considerations**: - SNRI duloxetine generally OK; - AVOID TCAs (cardiac toxicity); - AVOID stimulants if used; - Buprenorphine relatively cardiac-safer than methadone; - Methadone QTc — monitor ECG; - SSRI generally CV-safe; - Address modifiable CV risk (BP, lipids, glucose, smoking); (7) **Address comorbidity**: depression (very common), anxiety, sleep apnea (high CV risk + comorbid); (8) **Functional goals** > pain elimination; (9) **Multidisciplinary**: pain medicine, addiction medicine, psychiatry, cardiology, PT, behavioral health, primary care, social work, peer support; (10) **Trauma-informed** throughout; (11) **Patient education + self-management + safety planning** (naloxone available, suicide risk)

---

Chronic pain + OUD + PTSD + insomnia + CVD: integrative. Buprenorphine MAT foundation (treats OUD + pain). Non-opioid chronic pain (CBT, PT, duloxetine). PTSD trauma-focused + SSRI (AVOID BZD). CBT-I for sleep. CV-safe medications (avoid TCA). Multidisciplinary + trauma-informed.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'ASAM OUD; APA PTSD; CDC Pain', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี chronic pain (LBP) + opioid use disorder + PTSD + insomnia + comorbid CV disease — integrative care plan'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี Alzheimer''s + late-life depression + chronic pain + polypharmacy + caregiver burnout + advance care planning — integrative geriatric care', '[{"label":"A","text":"Polypharmacy expansion"},{"label":"B","text":"Geriatric Integrative Care — AD + Depression + Pain + Polypharmacy + Caregiver — Comprehensive"},{"label":"C","text":"No caregiver support"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Integrative Care — AD + Depression + Pain + Polypharmacy + Caregiver — Comprehensive: (1) **Cognitive impairment**: - Cholinesterase inhibitor (donepezil, rivastigmine, galantamine); - Memantine moderate-severe; - Consider anti-amyloid mAb if early + amyloid+ (selected); - Non-pharmacologic (cognitive stimulation, structure, music); (2) **Late-life depression**: - SSRI (sertraline, escitalopram, mirtazapine) — start LOW go SLOW; - Avoid paroxetine (anticholinergic), high-dose citalopram (QT); - Psychotherapy (IPT, PST, CBT) effective + safer; - ECT for severe + safe in elderly; - Address pseudodementia overlap (depression worsens cognition); (3) **Chronic pain**: - Acetaminophen scheduled — first-line; - Topical (lidocaine, capsaicin, diclofenac); - SNRI (duloxetine — depression + pain); - PT + exercise (graded); - Mindfulness, CBT for chronic pain; - AVOID NSAIDs long-term (renal, GI, CV elderly); - AVOID opioids except when essential (delirium, falls, dependence — Beers); - AVOID gabapentin/pregabalin without indication (falls, cognitive — Beers); (4) **Polypharmacy + deprescribing**: - **Beers Criteria 2023** + STOPP/START — guides; - Anticholinergic burden (TCA, oxybutynin, diphenhydramine, antipsychotic — avoid); - Benzodiazepines AVOID; - Z-drugs AVOID; - Sliding scale insulin (use long-acting basal); - PPI long-term (deprescribe if no indication); - Medication reconciliation each visit; - ''Brown bag review''; (5) **Behavioral + Psychological Sx Dementia (BPSD)**: - Non-pharmacologic FIRST (identify triggers, environment, music, routine, caregiver training); - If essential: SSRI, trazodone, brexpiprazole (FDA approved 2023 AD agitation); - Atypical antipsychotic last-line (black box mortality elderly dementia); - AVOID benzodiazepines (worsen + falls); (6) **Caregiver support** (caregiver burnout high — affects patient + caregiver health): - Education; - Support groups (Alzheimer''s Association); - **Respite care**; - **Counseling** for caregiver; - REACH II intervention evidence-based; - Address depression in caregiver; (7) **Advance care planning** while patient has capacity: - POA + healthcare proxy; - Advance directive; - Goals of care (curative vs comfort + quality of life); - POLST; - Hospice eligibility discussion; - Driving cessation; - Financial protection; (8) **Safety**: - Falls (PT, home modification, medication review, vision/hearing); - Driving assessment (eventually cessation); - Wandering (ID, GPS); - Cooking/fire safety; - Medication mismanagement; (9) **Multidisciplinary**: geriatric psychiatry, geriatric medicine, neurology, nursing, PT/OT, social work, palliative care, family, primary care; (10) **Long-term**: progressive — adjust care; eventually palliative + hospice

---

Geriatric integrative AD + depression + pain + polypharmacy + caregiver: cholinesterase inhibitor + memantine, late-life depression SSRI low/slow + ECT, chronic pain non-opioid, deprescribing (Beers/STOPP), BPSD non-pharm first, caregiver support (respite, REACH II), advance care planning, safety. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'Beers 2023; APA Geriatric; REACH II', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี Alzheimer''s + late-life depression + chronic pain + polypharmacy + caregiver burnout + advance care planning — integrative geriatric care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 22 ปี first episode psychosis + cannabis use + family conflict + school disruption — integrative first-episode care', '[{"label":"A","text":"High-dose typical antipsychotic + discharge"},{"label":"B","text":"First Episode Psychosis — Coordinated Specialty Care (CSC) Integrative Model"},{"label":"C","text":"No family involvement"},{"label":"D","text":"Cannabis maintenance"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First Episode Psychosis — Coordinated Specialty Care (CSC) Integrative Model: (1) **Evidence base**: RAISE-ETP, OnTrackNY, EASA, Headspace — superior outcomes vs treatment as usual (engagement, function, hospitalization); (2) **Components of CSC**: - **Low-dose atypical antipsychotic** (aripiprazole, risperidone, paliperidone, olanzapine); start low + titrate; LAI option for adherence; minimize side effects; - **CBT for psychosis (CBTp)** — first-line psychotherapy; - **Family education + support (NEAP, MFG — multifamily group)** — reduces relapse; reduce expressed emotion; - **Supported employment + education (IPS-modified)** — return to school/work with support; - **Case management + care coordination**; - **Peer support specialists**; - **Substance use treatment integrated** — cannabis especially harmful in psychosis + relapse + outcome predictor; integrated motivational interviewing + CBT; - **Crisis planning**; - **Medical care** (metabolic monitoring, dental, primary care); (3) **Cannabis cessation critical**: - High-potency cannabis + early use + family history = strong risk for psychosis development + relapse; - Education + motivational interviewing + behavioral; - No FDA medication; (4) **Family work**: - Education about illness, course, treatment; - Reduce expressed emotion (critical comments, hostility, emotional overinvolvement linked to relapse); - Communication skills; - Problem-solving; - Family group; (5) **Functional restoration**: - Return to school with accommodations; - Reasonable accommodations Letter; - 504/IEP if disability; - Vocational rehabilitation; - Supported employment IPS; - Reasonable expectations + gradual; (6) **Address social determinants**: housing, income, transportation; (7) **Suicide assessment** — elevated risk first 2 years post-psychosis; (8) **Outcomes**: - 60-70% achieve symptomatic remission; - Functional recovery harder + variable; - DUP (duration untreated psychosis) shorter = better outcome — emphasizes early intervention; (9) **Long-term**: - Maintenance medication ≥ 1-2 yr post-stabilization; - Family + community support; - Possible recovery + return to function; (10) **Multidisciplinary CSC team**: psychiatrist, therapist, family specialist, vocational specialist, peer support, case manager

---

First Episode Psychosis — Coordinated Specialty Care (RAISE-ETP, OnTrackNY): low-dose atypical, CBTp, family education + multifamily group, IPS supported education/employment, integrated substance use (cannabis cessation critical), peer support, case management. Shorter DUP = better outcomes.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'RAISE-ETP; OnTrackNY; EASA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 22 ปี first episode psychosis + cannabis use + family conflict + school disruption — integrative first-episode care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 13 ปี depression + bullying + family conflict + decline in school + self-harm — adolescent integrative care', '[{"label":"A","text":"No family involvement"},{"label":"B","text":"Adolescent Depression with Self-Harm + Bullying + Family Conflict + School Issues — Integrative"},{"label":"C","text":"Watchful waiting with self-harm"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Depression with Self-Harm + Bullying + Family Conflict + School Issues — Integrative: (1) **Safety assessment first** — self-harm + suicide risk; safety planning + means restriction (medications, sharps); hospitalization if severe SI/plan/intent; (2) **Treatment first-line**: - **Combination CBT + SSRI** = optimal per TADS trial (Treatment for Adolescents with Depression Study); - **CBT** + behavioral activation + cognitive restructuring + problem-solving; - **SSRI** — fluoxetine + escitalopram FDA approved adolescents; sertraline + others used; - **FDA boxed warning** increased SI in adolescents — close monitoring, frequent visits initially, family education; benefit > risk; - **DBT-A** (DBT for adolescents) for self-harm + emotion regulation; (3) **Family therapy + family-based approaches**: - Adolescent-specific (ABFT — Attachment-Based Family Therapy); - Address family conflict (often bidirectional with depression); - Parent education + skills; - Communication; (4) **School-based intervention**: - Address bullying (anti-bullying policies, intervention); - Communicate with school; - 504/IEP if applicable; - School counselor involvement; - Gradual school re-engagement; - Address declining performance; (5) **Suicide prevention + safety**: - Safety planning (Stanley-Brown); - Means restriction (medications, firearms — household); - Crisis resources (988, 1323, school counselor); - Coping skills + distress tolerance; - Family education on warning signs; (6) **Address bullying specifically**: - Bullying victimization increases suicide × 2-3; - Anti-bullying programs (Olweus); - Cyberbullying — social media management, parental monitoring + autonomy balance; - School-based intervention; - Peer support; (7) **Adolescent development considerations**: - Identity formation; - Peer relationships; - Autonomy + parental support balance; - Confidentiality with safety limits; - Social media + body image; - Sexual + gender identity exploration; (8) **LGBTQ+ assessment** + affirmation if applicable (high risk depression + suicide if minority stress); (9) **Address comorbidity**: anxiety (very common), ADHD, learning, eating, substance; (10) **Suicide risk especially elevated** in adolescents with multiple stressors; (11) **Multidisciplinary**: adolescent psychiatry, therapist, family therapist, school personnel, primary care, social work, peer support

---

Adolescent depression + self-harm + bullying + family + school: TADS — combination CBT + SSRI optimal. DBT-A for self-harm. Family-based therapy (ABFT). School intervention + anti-bullying. Suicide prevention + safety planning + means restriction. Adolescent development. LGBTQ+ affirmation. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'peds',
  'TADS; ABFT; DBT-A', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 13 ปี depression + bullying + family conflict + decline in school + self-harm — adolescent integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี postpartum (4 wk) — severe MDD + breastfeeding + anxiety + sleep deprivation + partner stress — perinatal integrative care', '[{"label":"A","text":"Stop breastfeeding immediately + stop antidepressant"},{"label":"B","text":"Postpartum Depression — Perinatal Integrative Care"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Depression — Perinatal Integrative Care: (1) **Safety assessment first**: suicide risk + infanticide ideation (rare but evaluated); food/fluid intake; ability to care for self + baby; hospitalization if dangerous; (2) **Treatment**: - **SSRI** — sertraline preferred (low milk transfer, evidence-based); paroxetine alternative; escitalopram; - **Brexanolone** (IV neurosteroid — GABA modulator) — FDA approved postpartum depression — IV continuous infusion in inpatient × 60h; effective but limited availability + expense; - **Zuranolone** (oral neurosteroid — GABA modulator) — FDA approved 2023 postpartum depression — 14-day oral course; novel rapid-acting; - **CBT + IPT** — IPT specifically designed for postpartum + role transition + interpersonal; - **Combination therapy** for moderate-severe; (3) **Breastfeeding considerations**: - Most SSRIs compatible (low transfer, monitor infant); - Sertraline preferred; - Zuranolone breastfeeding contraindicated; - LactMed resource; - Shared decision-making; (4) **Sleep deprivation** (major contributor + bidirectional with depression): - Partner assistance for night feeding; - Pumping + bottle for partner to feed; - Brief evening sleep block (4-5 hours continuous); - Family help; - CBT-I adapted (limited options when breastfeeding); - Sleep hygiene; (5) **Anxiety/OCD postpartum**: - Common — intrusive thoughts about baby harm (egodystonic — distinguish from postpartum psychosis which is delusional); - SSRI + CBT; - Education to reduce shame; (6) **Partner involvement**: - Partner education about PPD; - Partner can also have depression (paternal PPD); - Communication; - Couples therapy if relational issues; - Support from partner; (7) **Social support**: - Family + friends + peer support (Postpartum Support International); - Mother-baby groups; - Public health nurse home visits; - Respite (someone watch baby); (8) **Identify + treat comorbidity**: anxiety (very common), prior trauma; (9) **Mother-infant bonding**: - Severe depression impairs; - Address with treatment + support; - Infant-parent psychotherapy if persistent issues; - Early intervention for infant if developmental concerns; (10) **Long-term**: - PPD predicts depression in subsequent pregnancies — prophylactic considerations; - Maintenance treatment; - Subsequent pregnancy planning; (11) **Multidisciplinary**: psychiatry (perinatal if available), OB-GYN, primary care, pediatrics, lactation, social work, family, peer support

---

Postpartum depression integrative: sertraline + brexanolone (IV) + zuranolone (oral) + IPT/CBT. Sleep deprivation address (partner, family help). Partner involvement (also paternal PPD). Social support (PSI). Address mother-infant bonding. Breastfeeding-compatible options. Multidisciplinary perinatal.', NULL,
  'medium', 'obgyn', 'review',
  'psychiatry', 'integrative', 'obgyn', 'adult',
  'ACOG Perinatal Depression; FDA Brexanolone + Zuranolone', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี postpartum (4 wk) — severe MDD + breastfeeding + anxiety + sleep deprivation + partner stress — perinatal integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี Parkinson''s disease + depression + anxiety + insomnia + RBD + impulse control disorder from dopamine agonist — integrative neuropsychiatric care', '[{"label":"A","text":"Continue dopamine agonist despite ICD"},{"label":"B","text":"Parkinson''s Disease + Multiple Neuropsychiatric Comorbidities — Integrative"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Random"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson''s Disease + Multiple Neuropsychiatric Comorbidities — Integrative: (1) **Depression in PD** (40-50%): - SSRI (sertraline, escitalopram) — first-line; - SNRI (venlafaxine — dual benefit pain + mood); - Bupropion (dopaminergic — may help motor + mood, but psychosis risk); - TCA (nortriptyline) — historical but anticholinergic + CV; - ECT effective + safe; - CBT, exercise (also motor benefit); - Distinguish from PD apathy + cognitive sx; (2) **Anxiety in PD** (very common; often ''wearing off'' anxiety with medication cycles): - SSRI/SNRI; - Address motor fluctuations contributing; - CBT, mindfulness; - AVOID benzodiazepines (falls, cognition); buspirone alternative; (3) **Insomnia in PD**: - Multifactorial (motor sx at night, RBD, depression, medication); - Melatonin for RBD (and sleep); - Address motor + medication timing; - CBT-I; - Cautious with sleep medications (falls, cognition); (4) **REM sleep behavior disorder (RBD)**: - Safety measures (bedroom safety, separate beds if injuries); - Melatonin 3-12mg HS first-line; - Clonazepam 0.25-2mg HS; - PD prodrome — already manifest in this patient; (5) **Impulse control disorder (ICD) from dopamine agonist**: - **Pramipexole, ropinirole, rotigotine** — pathological gambling, hypersexuality, binge eating, compulsive shopping; - Risk × 17 with dopamine agonist; - **Decrease/discontinue dopamine agonist** — usually resolves; replace with carbidopa-levodopa; - Patient + family education + screen (Questionnaire for Impulsive-Compulsive Disorders in PD — QUIP); - CBT + addiction approach if severe; (6) **PD psychosis**: - As disease progresses; - See separate; - Pimavanserin or quetiapine; (7) **PD cognitive decline (PDD)**: - Rivastigmine FDA approved; - Address dementia care; (8) **Address motor optimally** — quality of life + indirectly affects psychiatric; (9) **Multidisciplinary**: movement disorders neurology, psychiatry, sleep medicine, primary care, PT/OT, speech (for dysarthria, swallowing), social work, caregiver support; (10) **Caregiver burnout** — provide support; (11) **Modern**: deep brain stimulation considerations for motor — psychiatric assessment + outcomes (mood + cognition effects)

---

PD multiple neuropsychiatric: depression SSRI/SNRI/ECT, anxiety SSRI (AVOID BZD), insomnia + RBD melatonin/clonazepam, ICD from dopamine agonist (DECREASE/DISCONTINUE agonist), PD psychosis pimavanserin, PDD rivastigmine. Optimize motor. Multidisciplinary + caregiver support.', NULL,
  'medium', 'neurology', 'review',
  'psychiatry', 'integrative', 'neurology', 'adult',
  'MDS PD; Weintraub ICD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี Parkinson''s disease + depression + anxiety + insomnia + RBD + impulse control disorder from dopamine agonist — integrative neuropsychiatric care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare system implementing school-based mental health programs for adolescents', '[{"label":"A","text":"No intervention"},{"label":"B","text":"School-Based Mental Health (SBMH) — Evidence-Based Public Health Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** School-Based Mental Health (SBMH) — Evidence-Based Public Health Approach: (1) **Rationale**: - 50% lifetime mental health onset by age 14; 75% by 24; - Schools = natural location reaching youth; - Reduces stigma + access barriers; - 80% of children receive mental health care through school when available; (2) **Multi-Tiered Systems of Support (MTSS)**: - **Tier 1 universal**: school-wide mental health promotion, SEL (social-emotional learning), positive behavior supports, anti-bullying, mental health literacy curriculum, suicide prevention education, screening (limited evidence); - **Tier 2 selective**: small group interventions for at-risk students (anxiety, depression skills groups, grief, divorce, conduct issues); - **Tier 3 indicated**: individual therapy, crisis services, referral to community mental health; (3) **Programs evidence-based**: - **CBT-based**: Coping Cat (anxiety), CBITS (trauma), SPARK (depression), CWD-A (depression); - **DBT skills training in schools**; - **Mindfulness programs** (MindUP, Calm Schools); - **PBIS** (Positive Behavioral Interventions + Supports); - **SEL** (CASEL framework); - **Suicide prevention**: SOS, Sources of Strength (peer-led); (4) **Workforce models**: - **School counselors, psychologists, social workers** — backbone; - **Community partnerships** — external mental health providers in schools; - **Telepsychiatry consultation**; - **Stigma reduction** through teachers + peers; (5) **Specific issues**: - Bullying prevention (Olweus, KiVa); - Suicide prevention; - Substance use prevention (Life Skills Training); - LGBTQ+ supports (GSAs reduce suicide); - Identification + intervention for struggling youth; (6) **Crisis response**: - Suicide assessment + safety planning; - Post-suicide postvention (school cluster prevention); - Trauma response after events; (7) **Equity considerations**: - Disparities in access + identification + outcomes by race + SES; - Cultural adaptation; - Multilingual; - Address adverse childhood experiences (ACEs); (8) **Integration with primary care + community**; (9) **Outcomes** evidence: - Reduces ED visits, hospitalization, suicide attempts; - Improves academic outcomes (mental health + learning intertwined); - Cost-effective; (10) **Funding**: federal grants, state mental health, education department, private foundations; (11) **Modern**: - **Trauma-informed schools**; - **Restorative practices** (vs zero tolerance); - **Whole child approach**; - **Family + community engagement**

---

School-Based Mental Health: MTSS (universal/selective/indicated). Evidence-based programs (Coping Cat, CBITS, PBIS, SEL). School counselors + community partnerships + telepsych. Crisis response. Equity. Reduces ED + hospitalizations + improves academic. Trauma-informed + whole child.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'peds',
  'SAMHSA SBMH; MTSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Healthcare system implementing school-based mental health programs for adolescents'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Public health system addressing opioid epidemic + overdose prevention', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Opioid Epidemic + Overdose Prevention — Comprehensive Public Health"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid Epidemic + Overdose Prevention — Comprehensive Public Health: (1) **Scope** (US perspective applicable globally): - 100K+ overdose deaths/year; - Driven by fentanyl + analogs in illicit supply; - Synthetic opioid + stimulant + polysubstance; (2) **Prevention**: - **Prescribing guidelines** (CDC 2022 — updated, less rigid than 2016): - Non-opioid first-line for chronic pain; - When opioid: lowest effective dose + shortest duration + monitoring; - Avoid > 50 MME without careful consideration; - **PDMP** (Prescription Drug Monitoring Programs) — mandatory in many; - **Prescriber education**; - **Patient education**; - **Safe disposal** programs; (3) **Treatment access**: - **Medication for Addiction Treatment (MAT)**: buprenorphine, methadone, naltrexone — reduce mortality 50%; - **X-waiver removed 2023** — easier buprenorphine prescribing; - **Low-threshold care**, mobile units, ED-initiated; - **Methadone clinic access** (more restrictive — advocacy for liberalization); - **Insurance coverage**; - **Workforce expansion**; (4) **Harm reduction**: - **Naloxone distribution** — community + family + first responders + OTC (2023); reverses overdose; - **Syringe service programs** — prevent HIV/HCV; - **Fentanyl test strips**; - **Drug checking services**; - **Safe consumption sites** (controversial US, established elsewhere — supervised injection, no overdose deaths in established sites); - **Good Samaritan laws** (911 protection from prosecution); (5) **Comorbidity**: - Address mental health; - HCV treatment (highly effective DAAs — treat regardless active use); - HIV testing + PrEP; - Wound care for IV use; (6) **Specific populations**: - **Pregnancy**: methadone/buprenorphine; AVOID detox alone (high relapse + harm); - **Adolescents**: prevention + early intervention; - **Pain patients** transitioning off opioids — taper carefully + MAT if OUD; - **Justice-involved** — high overdose post-release; MAT continuation; (7) **System changes**: - Insurance parity; - Workforce; - Reduce stigma in healthcare; - Address pain management without opioid escalation; (8) **Social determinants**: - Housing instability — Housing First; - Employment; - Income; - Address despair contributing; - Address root causes — economic + social; (9) **Data + surveillance**: - Real-time overdose tracking; - Treatment outcomes; (10) **International cooperation**: - Fentanyl precursor regulation; - Naloxone access; - WHO guidelines; (11) **Modern**: - Stimulant + polysubstance increasing; - Need contingency management for stimulants; - Long-acting injectable buprenorphine + naltrexone improving adherence

---

Opioid epidemic: prescribing guidelines (CDC) + PDMP + safe disposal. MAT (buprenorphine, methadone, naltrexone) reduces mortality 50%; X-waiver removed 2023. Harm reduction (naloxone OTC, SSP, test strips, safe consumption). Comorbidity (HCV cure). Pregnancy MAT. Social determinants.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'CDC 2022 Pain; ASAM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Public health system addressing opioid epidemic + overdose prevention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital system improving care for justice-involved individuals with mental illness', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Justice-Involved + Mental Illness — Sequential Intercept Model"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Justice-Involved + Mental Illness — Sequential Intercept Model: (1) **Scope**: - Disproportionate representation in justice system; - 20%+ jail population; - ''Three largest mental hospitals are jails''; - Deinstitutionalization + inadequate community services contributed; (2) **Sequential Intercept Model** (Munetz + Griffin) — opportunities to divert at each stage: - **Intercept 0**: Crisis services (mobile crisis, 988, hotlines, stabilization — prevent police involvement); - **Intercept 1**: Law enforcement (CIT — Crisis Intervention Team training, co-response with clinicians, diversion at scene); - **Intercept 2**: Initial detention + court hearings (mental health screening, court liaison); - **Intercept 3**: Jails + courts (mental health treatment in jail, mental health courts — diversion to community treatment with court supervision); - **Intercept 4**: Reentry from jail/prison (Transition Coordinators, Forensic ACT, medication continuation, Medicaid/insurance re-enrollment, housing); - **Intercept 5**: Community corrections (probation, parole — mental health caseloads, treatment-mandated supervision); (3) **Specific evidence-based programs**: - **CIT** (Memphis model — 40-hr training officers, diversion, reduced shootings + arrests); - **Mental Health Courts** — voluntary diversion, treatment + supervision vs incarceration, reduced recidivism; - **Forensic ACT (FACT)** — assertive community treatment with criminal justice involvement; - **Drug Courts** — substance use; - **Veterans Treatment Courts**; (4) **Treatment in correctional settings**: - Medication continuation (psychiatric + MAT — crucial; jail withdrawal mortality + overdose post-release); - Therapy when available; - Crisis services + suicide prevention (highest risk first 24-48h jail admission); - **Reentry planning** essential — high mortality post-release; (5) **Medicaid Inmate Exclusion** (US barrier — being addressed) — eligibility paused during incarceration; (6) **Restoration of competency** for justice-involved with mental illness; (7) **Capital case + insanity defense** — forensic psychiatry expertise; (8) **Address mass incarceration policy**: - Sentencing reform; - Drug policy reform; - Diversion at multiple points; - Investment in community treatment vs incarceration; (9) **Equity**: - Racial disparities in arrest, sentencing, treatment; - Address bias; - Cultural responsiveness; (10) **Multidisciplinary**: forensic + community psychiatry, judges, attorneys, police, corrections, social work, peer support, family; (11) **Modern**: - **Stepping Up Initiative** (NACo + APA + Council of State Governments — county-level reform); - **Justice + Mental Health Collaboration Program (JMHCP)** federal funding

---

Justice + Mental Illness: Sequential Intercept Model (5 intercepts). CIT, mental health courts, FACT, drug courts, reentry planning. MAT + medication continuation crucial. Reduce mass incarceration. Address racial disparities. Stepping Up Initiative. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'Munetz + Griffin Sequential Intercept; CIT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital system improving care for justice-involved individuals with mental illness'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Health system addressing perinatal mental health screening + treatment access', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Perinatal Mental Health — Public Health Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Mental Health — Public Health Approach: (1) **Scope**: - Depression 10-20% pregnancy + postpartum; - Anxiety similar or higher; - Suicide leading cause maternal mortality in some series; - Untreated affects mother + infant + family; (2) **Screening recommendations**: - **ACOG** + **AAP** + **USPSTF** recommend universal screening pregnancy + postpartum (with adequate systems for follow-up); - **EPDS** (Edinburgh Postnatal Depression Scale) — most common; - **PHQ-9** + **GAD-7** alternatives; - Screen multiple times — early pregnancy, 3rd trimester, 6 wk postpartum, well-child visits up to 12 mo; - Screen at well-child visits — pediatrician + parents both benefit; (3) **Treatment access**: - **Massachusetts Child Psychiatry Access Project (MCPAP) for Moms** — telephone consultation + referrals for OB/family medicine — model replicating; - **Perinatal psychiatry programs** + specialty clinics; - **Mother-Baby Units** (inpatient — UK model spreading); - **Brexanolone** + **Zuranolone** FDA approved (limited access due to cost + REMS for brexanolone); - **Telepsychiatry**; - **Group therapy + peer support** (Postpartum Support International — PSI); (4) **Workforce gaps**: - Perinatal psychiatry specialty limited; - Education for OB + family medicine + pediatrics in prescribing + management; - Doulas + community health workers; (5) **Equity considerations**: - Racial disparities in screening + treatment + outcomes; - Black women — 3-4× maternal mortality (US); - Cultural adaptation; - Multilingual services; - Address structural racism in maternity care; (6) **Beyond depression**: - Anxiety; - PTSD (birth trauma, infant in NICU, prior pregnancy loss); - Bipolar; - Postpartum psychosis (EMERGENCY); - OCD intrusive thoughts; - Substance use; - Eating disorders; (7) **Father/partner mental health**: paternal PPD ~ 10%, affects family; screen + support; (8) **Loss + grief**: miscarriage, stillbirth, infant loss — specific support; (9) **Integrated care**: - OB + psychiatry; - Pediatrician engagement; - Lactation; - Social work; - Family; (10) **Policy advocacy**: - Insurance coverage; - Paid family leave; - Maternal mortality review committees; - **MOMS Act** (US); (11) **Modern**: - Maternal mental health = global priority; - WHO recommendations; - Perinatal mental health policy initiatives

---

Perinatal Mental Health: universal screening (EPDS), MCPAP for Moms consultation model, perinatal specialty + Mother-Baby Units, brexanolone/zuranolone, equity (racial disparities), beyond depression (anxiety, PTSD, OCD, bipolar, psychosis emergency), paternal PPD, integrated care, policy advocacy.', NULL,
  'medium', 'obgyn', 'review',
  'psychiatry', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG; AAP; MCPAP for Moms', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Health system addressing perinatal mental health screening + treatment access'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mental health system implementing prevention + early intervention strategies', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Mental Health Prevention + Early Intervention — Population Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mental Health Prevention + Early Intervention — Population Approach: (1) **Public health prevention framework**: - **Universal**: whole population; - **Selective**: high-risk groups; - **Indicated**: subsyndromal symptoms; (2) **Universal prevention**: - **Maternal + child health**: prenatal care, nutrition, parenting education, ACEs prevention; - **Early childhood**: high-quality preschool (Head Start), parenting programs (Triple P, Incredible Years); - **Schools**: SEL, mental health literacy, anti-bullying, suicide prevention education; - **Workplace**: mental health programs, EAP, leadership development; - **Community**: connectedness, civic engagement, anti-stigma campaigns; - **Population health**: address social determinants (poverty, housing, racism); (3) **Selective prevention**: - **At-risk youth**: trauma exposure, family mental illness, foster care, juvenile justice involvement; - **Postpartum**: prevention of PPD in high-risk women; - **Bereavement**: complicated grief prevention; - **Disaster mental health**; - **Refugees + immigrants**; - **Veterans + military**; - **LGBTQ+ youth**; (4) **Indicated prevention**: - **Subsyndromal depression** → prevent MDD: CBT for prevention; - **CHR for psychosis** → reduce conversion; - **Subsyndromal substance use** → SBIRT, MET; - **Eating disorder risk**; (5) **Suicide prevention** (across levels): - Universal (means restriction, mental health literacy); - Selective (high-risk groups); - Indicated (treatment of mental illness + safety planning + caring contacts); - Zero Suicide health system initiative; (6) **Investment return**: - Prevention has high ROI (return on investment) over lifetime; - Underfunded historically; (7) **Risk factor modification**: - Modifiable risks for dementia (Lancet Commission — hearing, education, exercise, sleep, smoking, alcohol, BP, obesity, depression, social isolation, traumatic brain injury, air pollution); - Mental health prevention overlap (exercise, sleep, substance use, isolation); (8) **Stigma reduction** + mental health literacy (MHFA — Mental Health First Aid); (9) **Integration with primary care + schools + community**; (10) **Evidence challenges**: - Long latency; - Causality complex; - Resources required; - But growing evidence base — many cost-effective interventions; (11) **Modern**: precision prevention + digital + population data; (12) **Global mental health**: UN Sustainable Development Goals — mental health priority; WHO mhGAP

---

Mental health prevention: universal (maternal/child, schools, workplace, community) + selective (at-risk groups) + indicated (subsyndromal sx). Suicide prevention across levels. ROI high. Risk factor modification (Lancet Commission dementia). Stigma reduction + mental health literacy. WHO global priority.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'WHO mhGAP; Lancet Commission Dementia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Mental health system implementing prevention + early intervention strategies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital system addressing mental health disparities + equity', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Mental Health Disparities + Equity — Comprehensive Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mental Health Disparities + Equity — Comprehensive Approach: (1) **Documented disparities**: - **Racial/ethnic**: African Americans + Latino/Hispanic — lower access, lower quality care, more coercive (involuntary, police, jail), under-diagnosis of mood + over-diagnosis of psychosis; - **LGBTQ+**: higher mental health burden (minority stress) + barriers to affirming care; - **SES**: poverty associated with mental illness bidirectionally; access barriers; - **Geographic**: rural lower access; - **Gender**: women — depression, anxiety, eating, sexual violence; men — substance use, suicide death (higher), under-treatment due to stigma; - **Age**: elderly — under-recognized; youth — under-resourced; - **Immigration status**: undocumented — barriers; - **Disability**: mental health needs; - **Justice-involved**: massive overrepresentation; (2) **Drivers of disparities**: - **Structural racism** + historical injustice; - **Insurance + cost barriers**; - **Workforce diversity gaps**; - **Cultural + linguistic mismatch**; - **Stigma** (especially in some communities); - **Bias in diagnosis + treatment**; - **Trauma + ACEs disproportionate**; - **Social determinants**; (3) **Interventions**: - **Workforce diversity**: pipeline, recruitment, retention of URM providers; - **Cultural humility training**; - **Implicit bias training**; - **Community-engaged research + program design**; - **Trauma-informed + healing-centered**; - **Language services**; - **Insurance coverage parity + expansion**; - **Telepsychiatry** to address geographic + access; - **Integrated care** (primary care, schools, faith communities); - **Peer support + community health workers**; - **Address social determinants**; - **Anti-stigma campaigns**; (4) **Specific examples**: - **Friendship Bench (Zimbabwe)** — lay health workers, evidence-based; - **mhGAP** (WHO) — task-sharing; - **Strong African American Families** — culturally adapted prevention; - **Asian Counseling + Referral Service (ACRS)** — cultural specific; - **LGBTQ+ affirming care centers**; - **Indigenous healing programs** — integration traditional + modern; (5) **Data + accountability**: - Track outcomes by demographics; - Equity metrics; - Community Advisory Boards; - Accountability for disparities; (6) **Policy advocacy**: - Mental Health Parity (US Mental Health Parity + Addiction Equity Act); - Mental Health Block Grant; - Medicaid expansion + behavioral health coverage; - International — universal mental health coverage; (7) **Multidisciplinary leadership** + community partnership essential; (8) **Modern**: health equity as core mission, not afterthought

---

Mental health disparities: racial/ethnic, LGBTQ+, SES, geographic, gender, age, immigration, justice. Drivers: structural racism, insurance, workforce gaps, cultural mismatch, stigma, bias, ACEs. Interventions: workforce diversity, cultural humility, telepsych, integration, peer support, social determinants, advocacy. Equity = core.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'WHO Health Equity; SAMHSA Equity', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital system addressing mental health disparities + equity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Health system implementing digital mental health interventions', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Digital Mental Health Interventions — Expanding Access + Workforce Capacity"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Digital Mental Health Interventions — Expanding Access + Workforce Capacity: (1) **Modalities**: - **Telepsychiatry** (synchronous video) — most common; - **Mobile apps** (self-guided + therapist-assisted): - **Digital therapeutics** — FDA-approved or registered (Reset, Reset-O for substance use disorder; Endeavor for ADHD; Somryst for insomnia); - **Self-help/wellness** (Headspace, Calm — meditation; Woebot, Wysa — conversational); - **CBT-based**: Sleepio (CBT-I — strong evidence), SHUTi, Beating the Blues; - **PTSD**: PTSD Coach (VA — free); - **Anxiety**: Mindshift; - **Smoking cessation**: SmokefreeTXT; - **Online therapy platforms**: BetterHelp, Talkspace (caveats — quality variable); - **Peer support online**: 7 Cups, NAMI online; (2) **Evidence base**: - CBT-based digital — comparable to in-person for mild-moderate; - Especially effective with some guidance/support (therapist coaching); - More variable for unguided self-help; (3) **Use cases**: - **Stepped care low intensity** (mild-moderate); - **Augmentation** of in-person treatment; - **Workforce extension**; - **Geographic access**; - **Stigma reduction** (privacy); - **Wait times** for higher intensity; - **Maintenance** post-active treatment; (4) **Challenges**: - Quality + evidence varies widely (most apps not evidence-based); - Privacy + data concerns; - Engagement + dropout high in self-guided; - Digital divide (access, literacy); - Crisis safety management; - Reimbursement evolving; (5) **Regulatory**: - **FDA digital therapeutics** — Prescription Digital Therapeutic (PDT) — clinical trials, indication, prescription; - **mHealth apps** — most unregulated; quality variable; - **APA + One Mind** app evaluation framework; (6) **Equity considerations**: - Digital divide — provide alternatives; - Tailored content; - Language; - Cost; (7) **Privacy + ethics**: - Data security; - Confidentiality; - Informed consent; - Algorithm transparency; (8) **AI + machine learning emerging**: - Symptom monitoring (passive sensing, voice analysis); - Personalized interventions; - Clinical decision support; - **AI chatbots for mental health** — ethical concerns, supplementary not replacement; (9) **Workflow integration**: - Apps prescribed + monitored by clinician; - Asynchronous data review; - Patient portal; (10) **Cost-effectiveness** + scalability — major advantage; (11) **Modern**: rapid evolution; clinician selection + guidance essential; balance promise with appropriate skepticism + evidence

---

Digital mental health: telepsychiatry, FDA digital therapeutics (Reset, Endeavor, Somryst), evidence-based apps (Sleepio CBT-I), self-help (Headspace, Woebot), online platforms (caveats). Stepped care low intensity. Workforce extension. Privacy + equity + AI emerging. Clinician guidance.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'FDA Digital Therapeutics; APA Apps', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Health system implementing digital mental health interventions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implementing global mental health approach + low-resource setting strategies', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Global Mental Health — Low-Resource Setting Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global Mental Health — Low-Resource Setting Approach: (1) **Scope**: - 1 in 4 people experience mental illness; - 70% in low + middle-income countries (LMIC); - Treatment gap 70-90% LMIC; - Mental health < 2% of health budgets globally; (2) **WHO mhGAP** (Mental Health Gap Action Programme): - **Priority conditions**: depression, psychosis, bipolar, epilepsy, dementia, alcohol + drug use disorders, intellectual disability, child + adolescent disorders, suicide; - **Intervention Guide (mhGAP-IG)** — task-sharing tool for primary care providers in LMIC; - Brief assessment + intervention algorithms; (3) **Task-sharing** = central strategy: - Train non-specialists (primary care, nurses, community health workers, lay health workers) in mental health; - Supervision by specialists; - Examples: **Friendship Bench (Zimbabwe)** — grandmothers on park benches deliver problem-solving therapy; evidence-based; **Healthy Activity Program (India)** — lay counselors deliver behavioral activation; **THP (Thinking Healthy Programme — Pakistan)** — CBT-based perinatal; (4) **Community-based + integrated care**: - Integrate mental health into primary care; - Schools; - Maternal-child health programs; - HIV + TB programs; - Disaster response; (5) **Address social determinants**: - Poverty alleviation; - Education; - Housing; - Gender equity; - Reduce violence; (6) **Cultural adaptation**: - Local idioms of distress; - Traditional healers integration (where appropriate + evidence-based); - Family + community-centered approaches; - Religion + spirituality; (7) **Emergency + humanitarian settings**: - **IASC Guidelines on Mental Health + Psychosocial Support (MHPSS) in Emergencies**; - Psychological First Aid; - Phased + tiered approach; - Refugees, conflict, disaster; (8) **Suicide prevention**: - Means restriction (pesticide regulation — major in Asia rural agriculture; firearm in some contexts); - Mental health treatment access; - Media reporting guidelines; - Crisis services; (9) **Building specialist capacity** + leadership: - **PRIME** (Programme for Improving Mental Health Care); - **Emerald**; - Country mental health strategies + plans; (10) **Sustainable Development Goals (SDG)** — mental health as priority (SDG 3.4 — reduce mortality from NCDs including mental health); (11) **Funding**: - Movement for mental health investment; - Global Mental Health Action Network; - World Bank involvement; (12) **Stigma + human rights**: - Address discrimination + institutional abuse; - Movement away from chains + restraint + custodial care; - Rights-based + recovery-oriented

---

Global Mental Health LMIC: WHO mhGAP, task-sharing (Friendship Bench Zimbabwe, HAP India, THP Pakistan), community-integrated, cultural adaptation, IASC humanitarian guidelines, suicide prevention (pesticide regulation), SDG priority, stigma + human rights.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'WHO mhGAP; Lancet Global Mental Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital implementing global mental health approach + low-resource setting strategies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implementing intellectual + developmental disability behavioral health services', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Intellectual + Developmental Disability (IDD) + Mental Health — Specialized Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intellectual + Developmental Disability (IDD) + Mental Health — Specialized Approach: (1) **Scope**: - 30-50% of IDD have psychiatric comorbidity; - Underdiagnosed + undertreated; - ''Diagnostic overshadowing'' — attribute symptoms to IDD; - Communication barriers; - Limited workforce; (2) **Common psychiatric in IDD**: - Anxiety (very common); - Depression (often atypical — irritability, behavior changes); - ADHD; - Autism overlap; - Psychosis; - Bipolar; - Behavioral issues (aggression, self-injury, stereotypies); - Trauma (high prevalence — abuse); - Adjustment disorders; (3) **Assessment**: - **Informant-based** scales (caregivers report); - **Modified instruments** (Glasgow Depression Scale for People with Learning Disability — GDS-LD; PAS-ADD); - Behavioral analysis + functional assessment; - Rule out medical (pain, constipation, sensory, sleep) — common drivers of behavioral changes in IDD; - Communication adaptation — pictures, simplified, AAC (augmentative + alternative communication); (4) **Treatment**: - **Behavioral interventions** first-line: - Applied Behavior Analysis (ABA); - Positive behavior support; - Functional analysis-based; - Environmental modification + sensory; - **Psychotherapy adapted**: - CBT with adaptation for cognitive level; - Behavioral therapy; - Trauma-focused (if applicable); - Family + caregiver involvement; - **Medication** — same as general but lower doses + slower titration + close monitoring: - SSRI for anxiety/depression; - Stimulant for ADHD; - Atypical antipsychotic for severe aggression/SIB (risperidone, aripiprazole FDA approved for severe irritability in autism); - AVOID polypharmacy; - AVOID benzodiazepines (paradoxical activation common); (5) **Address comorbidity + accommodations**: - Sensory issues (hearing, vision); - Communication; - Medical comorbidity (seizure, GI, cardiac); - Sleep; (6) **Caregiver support + family**: - Education; - Respite; - Caregiver mental health; - Sibling support; (7) **Transitions**: - Pediatric to adult care; - School to vocational; - Family home to supported living; (8) **Address abuse + trauma**: - Higher prevalence; - Trauma-informed; - Reporting; (9) **Specialized services**: - IDD-trained psychiatrists; - START programs (Systemic Therapeutic Assessment Resources + Treatment); - Behavioral specialists; - OT, speech, PT; - Case management; (10) **Avoid restrictive practices** (restraint, seclusion, chemical restraint) — use only as last resort; (11) **Long-term**: lifelong condition; chronic care model; (12) **Multidisciplinary**: psychiatry, developmental medicine, neurology, behavioral specialist, OT, speech, social work, family, vocational

---

IDD + Mental Health: 30-50% comorbidity, underdiagnosed (diagnostic overshadowing). Informant-based + behavioral assessment. Behavioral interventions first. Adapted psychotherapy. Medication lower dose + close monitor. Address abuse/trauma higher. Specialized services (START). Caregiver support. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'START; AAIDD; NADD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital implementing intellectual + developmental disability behavioral health services'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Healthcare system implementing forensic psychiatry consultation + risk assessment', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Forensic Psychiatry — Scope + Practice"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Forensic Psychiatry — Scope + Practice: (1) **Forensic psychiatry** = intersection of psychiatry + legal: criminal + civil; (2) **Criminal forensic**: - **Competency to stand trial** (Dusky standard); - **Insanity defense / NGRI** (varies by jurisdiction — M''Naghten test most common: not knowing right from wrong due to mental disease at time of offense; some use ALI Model Penal Code — substantial capacity test); - **Diminished capacity** (mens rea); - **Capital case** mitigation; - **Sentencing recommendations**; - **Sex offender evaluation + treatment**; - **Risk assessment** for violence; (3) **Civil forensic**: - **Capacity assessments** (medical decision-making, financial, testamentary, guardianship); - **Civil commitment**; - **Disability evaluations**; - **Personal injury / emotional distress claims**; - **Child custody** (specialized); - **Worker''s compensation**; - **Malpractice defense + plaintiff**; - **Independent Medical Exams (IME)**; (4) **Violence risk assessment**: - **Static factors**: prior violence (strongest predictor), age, gender, history; - **Dynamic factors**: psychiatric sx, substance use, treatment adherence, social support, life stressors, access to means; - **Standardized tools**: - **HCR-20** (Historical-Clinical-Risk Management — most commonly used); - **VRAG** (Violence Risk Appraisal Guide); - **COVR** (Classification of Violence Risk); - **Sex offender**: STATIC-99R, SVR-20, STABLE-2007; - **Structured Professional Judgment** > unstructured clinical judgment; - Probabilistic, not deterministic; (5) **Suicide risk** = different framework (C-SSRS, Beck SSI); (6) **Approach to forensic evaluation**: - Neutral (not therapeutic role — distinct from clinical); - Inform examinee of purpose + limits of confidentiality + role; - Collateral information essential; - Standardized assessment; - Document carefully; - Opinion clearly stated for legal purpose; (7) **Ethics**: - Avoid dual roles (treating + forensic same case); - Honesty + objectivity; - Avoid prejudice; - **APA Ethics Code + AAPL Guidelines**; (8) **Cultural + linguistic considerations**; (9) **Expert witness testimony**: - Specialized training; - Court testimony; - Daubert standard (scientific evidence admissibility); (10) **Modern**: - Risk assessment + management (not just prediction — also intervention); - Recovery-oriented even in forensic settings; - Address mental illness in justice system; - Reduce stigma + improve diversion + treatment access

---

Forensic psychiatry: criminal (competency, insanity, sentencing, violence risk) + civil (capacity, commitment, disability, custody). Risk assessment tools (HCR-20, VRAG, STATIC-99R). Structured professional judgment > unstructured. Avoid dual roles. AAPL ethics. Cultural considerations.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'AAPL; HCR-20; Dusky', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Healthcare system implementing forensic psychiatry consultation + risk assessment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี diabetes + depression + chronic kidney disease + sleep apnea + obesity + anxiety — metabolic-psychiatric integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Metabolic-Psychiatric Complex Case — Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Metabolic-Psychiatric Complex Case — Integrative: (1) **Bidirectional relationships**: depression worsens diabetes outcomes + medication adherence + lifestyle; diabetes increases depression risk × 2; obesity, sleep apnea, anxiety all interact; (2) **Depression treatment** considering CKD + DM + sleep apnea + obesity: - **SSRI** (sertraline, escitalopram — relatively safe in CKD; dose adjust escitalopram); - **SNRI** (duloxetine — caution CKD; venlafaxine alternative); - **AVOID**: paroxetine (anticholinergic + weight + sexual SE); high-dose citalopram (QT esp DM patients); TCA (anticholinergic + CV); - **Bupropion** — no sexual SE + may help weight; lower seizure threshold (caution if uncontrolled DM); - **CBT** (especially CBT for depression in chronic illness); - Avoid mirtazapine + olanzapine (weight gain) for this patient if possible — but mirtazapine helps insomnia + weight loss in malnourished; (3) **Anxiety treatment**: - SSRI/SNRI dual purpose; - CBT; - Buspirone alternative; - AVOID benzodiazepines (sleep apnea — respiratory depression; falls; cognitive); (4) **Sleep apnea treatment**: - CPAP — adherence challenging; - Weight loss; - Address with mental health (depression bidirectional); (5) **Diabetes management**: - Glycemic control improves depression + cognition; - SGLT2 inhibitors, GLP-1 (semaglutide, tirzepatide) — also weight loss + CV + renal benefit + may have mood benefit; - Monitor for medication interactions; - Reduce hypoglycemia (worsens anxiety + cognition); - Education + self-management; (6) **Obesity intervention**: - **Multimodal**: lifestyle (diet, exercise — also antidepressant), behavioral, pharmacologic (semaglutide), bariatric surgery (effective + careful psychiatric assessment including binge eating, depression); - GLP-1 agonists effective + may help binge eating + depression (research); (7) **Address other lifestyle**: - Smoking cessation; - Alcohol reduction; - Sleep hygiene; - Stress management (mindfulness); - Social engagement; (8) **CKD considerations**: - Medication renal adjustments; - Hyperkalemia risk (some antidepressants + ACE-I + spironolactone); - Anemia + cognitive; - Dialysis psychiatric implications (depression high prevalence); (9) **Comorbid screening**: - Cardiovascular; - Cognitive (DM + depression + sleep apnea → dementia risk); - Bone health; - Cancer screening; (10) **Multidisciplinary**: endocrinology, psychiatry, primary care, nephrology, sleep medicine, dietitian, behavioral health, possibly bariatric, exercise specialist, social work; (11) **Patient-centered care + shared decision-making** with multiple chronic illnesses; (12) **Health behavior change** — motivational interviewing, gradual + sustainable

---

Metabolic + psychiatric: bidirectional. SSRI/SNRI (sertraline, escitalopram, bupropion; AVOID paroxetine, TCA, high citalopram). CPAP. Diabetes mgmt (SGLT2, GLP-1 — also mood + weight benefit). Multimodal obesity. CKD med adjustments. Multidisciplinary + shared decision-making.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'APA Depression Diabetes; Endocrine Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี diabetes + depression + chronic kidney disease + sleep apnea + obesity + anxiety — metabolic-psychiatric integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี post-stroke + aphasia + depression + anxiety + caregiver burnout + medication management — integrative neuropsychiatric rehabilitation', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Post-Stroke Neuropsychiatric Comprehensive Care"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Stroke Neuropsychiatric Comprehensive Care: (1) **Post-stroke depression** (PSD ~ 30%): - SSRI (sertraline, escitalopram, citalopram cautious) — first-line; reduces depression + may improve recovery; - Some evidence prophylactic SSRI reduces incident PSD; - CBT adapted for cognitive + communication; - Exercise + rehab participation; - ECT if severe + safe post-stroke; - AVOID anticholinergics (TCA, paroxetine — cognitive); (2) **Post-stroke anxiety** (~ 25%): - SSRI; - CBT adapted; - Address stroke-related fears; - AVOID benzodiazepines (cognitive, sedation, aspiration risk, falls); (3) **Aphasia communication**: - Speech-language pathology; - Augmentative + alternative communication (AAC); - Communication-friendly assessment (yes/no, gestures, pictures, written); - Adapt psychotherapy + assessment tools; (4) **Cognitive assessment + management**: - Vascular cognitive impairment; - Vascular dementia if significant; - Cholinesterase inhibitor modest; - Cognitive rehabilitation; - Vascular risk factor modification (essential for prevention further events); (5) **Pseudobulbar affect (PBA)** if present: - Dextromethorphan + quinidine (Nuedexta); - SSRI alternative; (6) **Apathy** common (distinct from depression): - Address with activity engagement; - Limited medication evidence; - Dopaminergic experimental; (7) **Functional rehabilitation**: - PT/OT; - Speech therapy; - Vocational; - Adaptive equipment; - Home modifications; (8) **Caregiver burden**: - Education; - Respite; - Support groups; - Counseling; - Address depression in caregiver (high); (9) **Medication management**: - Pill organizers; - Caregiver involvement; - Simplification regimen; - Address polypharmacy; - **Anticholinergic burden minimize** (cognition); (10) **Vascular risk factor management**: - BP, lipids, glucose; - Antiplatelet/anticoagulation; - Smoking cessation; - Diet + exercise; (11) **Sexual + relationship issues**: - Address; - Adapt physically; - Couples counseling; (12) **Driving assessment**; (13) **Insurance + financial**: - Disability; - Family + Medical Leave Act; - Long-term care planning; (14) **Multidisciplinary stroke team**: neurology, psychiatry, PT/OT/SLP, rehabilitation medicine, social work, primary care, nursing, family, peer support (stroke survivor groups); (15) **Long-term**: chronic illness model + adaptation + sustained support

---

Post-stroke neuropsychiatric: PSD SSRI + CBT adapted, PSA SSRI (AVOID BZD), aphasia communication adaptation, vascular cognitive impairment + risk factor modification, PBA (dextromethorphan/quinidine), apathy, functional rehab, caregiver burden support, medication mgmt + minimize anticholinergic. Multidisciplinary stroke team.', NULL,
  'medium', 'neurology', 'review',
  'psychiatry', 'integrative', 'neurology', 'adult',
  'AHA/ASA Post-Stroke; Robinson PSD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี post-stroke + aphasia + depression + anxiety + caregiver burnout + medication management — integrative neuropsychiatric rehabilitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี cancer (breast) + depression + chronic pain + fatigue + sleep disturbance + chemotherapy effects — psycho-oncology integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Psycho-Oncology Comprehensive Care"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Psycho-Oncology Comprehensive Care: (1) **Distress screening** routine (NCCN Distress Thermometer); identifies psychological + practical + family + spiritual + physical needs; (2) **Depression**: - Distinguish from cancer-related fatigue + treatment side effects; - **Antidepressant choice — drug interactions critical**: - **Sertraline, escitalopram, mirtazapine** — preferred; - **AVOID**: fluoxetine, paroxetine, bupropion in tamoxifen patients (CYP2D6 inhibitors → reduce endoxifen active metabolite); - Mirtazapine — appetite + sleep + nausea benefit; - QTc considerations with chemotherapy (avoid high citalopram); - **CBT, mindfulness-based, meaning-centered (Breitbart)** psychotherapy; - **Exercise** — antidepressant + cancer benefits; - **ECT** if severe + safe; (3) **Anxiety**: - SSRI/SNRI; - CBT; - Mindfulness-based stress reduction (MBSR); - Anxiolytic for acute (e.g., procedure-related) — short-term BZD reasonable; - Hypnosis (anticipatory nausea); (4) **Cancer-related fatigue** (most common, multifactorial): - Exercise (paradoxically improves fatigue — evidence-based); - Address anemia, hypothyroidism, sleep, depression; - **Methylphenidate** (off-label) — moderate evidence palliative + advanced cancer; - **Modafinil** alternative; - **CBT for fatigue**; - **Mindfulness**; (5) **Pain management**: - WHO analgesic ladder; - Multi-modal (acetaminophen, NSAIDs, opioids titrated, adjuvants — gabapentin, antidepressants for neuropathic; SNRI duloxetine for chemo neuropathy); - Procedures (nerve blocks, neuraxial); - CBT for pain; - Mindfulness; - Spiritual + meaning support; (6) **Sleep**: - CBT-I; - Treat contributors (pain, hot flashes from chemo-induced menopause, anxiety, restless legs, OSA); - Melatonin agonist; - Trazodone, mirtazapine (also antidepressant); - AVOID benzodiazepines long-term; (7) **Chemotherapy-induced**: - Nausea (5-HT3 antagonists, mirtazapine); - Cognitive impairment (''chemo brain'' — cognitive rehab, address contributors, exercise); - Neuropathy (duloxetine evidence; pregabalin/gabapentin caution); - Hot flashes + sexual + reproductive concerns; (8) **Existential + spiritual**: - Meaning-centered therapy; - Chaplaincy; - Dignity therapy (Chochinov — advanced cancer); - Address fear of death + recurrence; - End-of-life planning if appropriate; (9) **Family + caregiver support**: - Education; - Couples + family therapy; - Caregiver burden + their mental health; - Children of cancer patients; (10) **Survivorship**: - Long-term follow-up; - Late effects monitoring; - Recurrence anxiety (common); - Reintegration to life; (11) **Multidisciplinary**: oncology, psycho-oncology, palliative care, pain medicine, primary care, social work, chaplaincy, nutritionist, PT/OT, navigator, peer support, family

---

Psycho-oncology comprehensive: distress screening (NCCN); depression — sertraline/escitalopram/mirtazapine (AVOID fluoxetine/paroxetine/bupropion + tamoxifen); cancer fatigue (exercise, methylphenidate palliative); pain (WHO ladder + adjuvants); sleep CBT-I; chemo SE; existential meaning-centered therapy; family + survivorship. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'NCCN Distress; Breitbart MCP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี cancer (breast) + depression + chronic pain + fatigue + sleep disturbance + chemotherapy effects — psycho-oncology integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 16 ปี autism spectrum + ADHD + anxiety + sleep + family stress + school challenges — adolescent ASD integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Adolescent ASD with Comorbidities — Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent ASD with Comorbidities — Integrative: (1) **ASD core**: - Continued behavioral + skills support; - Social skills training adapted; - OT for sensory + motor; - Speech-language; - Educational supports (IEP); (2) **ADHD comorbidity** (30-50% in ASD): - **Stimulants** can be effective but more side effects in ASD (irritability, decreased appetite); start low + slow; - **Non-stimulants** (atomoxetine, guanfacine, clonidine) — sometimes better tolerated; - Address executive function + organization; - Educational accommodations; (3) **Anxiety** (40% in ASD): - **SSRI** — first-line but watch for activation/behavioral disinhibition; sertraline, fluoxetine, escitalopram; - **CBT adapted for ASD** (e.g., ''Facing Your Fears'' — Reaven) — concrete + visual + skills-focused; - Address specific (separation, social, GAD, OCD); - Avoid benzodiazepines (paradoxical activation); (4) **Sleep** (very common in ASD — 50-80%): - **Sleep hygiene** + structured routine; - **Melatonin** (well-tolerated, evidence base in ASD); - Address contributors (anxiety, GI, sensory); - Behavioral sleep interventions; (5) **Severe irritability/aggression/self-injury** (not core ASD but common comorbid): - **Risperidone, aripiprazole** FDA-approved for irritability in ASD; - Behavioral interventions first; - Address triggers (sensory, communication, medical, environmental); (6) **Adolescent-specific issues**: - **Sexual + relationship education** adapted (often inadequate); - **Identity + self-acceptance** (neurodiversity perspective); - **Friendship + social challenges**; - **Bullying victimization** — assess + address; - **Gender + sexual minority** consideration (higher rates); - **Mental health stigma**; (7) **Transition planning** (starting age 14-16): - **Vocational** (supported employment, IPS adapted); - **Education** (post-secondary supports — many programs); - **Independent living skills**; - **Healthcare transition** to adult system; - **Driving assessment + skills**; - **Financial + legal**: ABLE accounts, special needs trust, supported decision-making vs guardianship; (8) **Family support**: - Education; - Sibling support; - Caregiver burnout; - Respite; (9) **Address medical comorbidity**: - Epilepsy (20-30% in ASD); - GI; - Hearing/vision; - Genetic — counseling + testing if syndromic; (10) **Multidisciplinary**: developmental + adolescent pediatrics, child + adolescent psychiatry, behavioral therapist, OT, speech, special education, social work, vocational, family; (11) **Modern**: neurodiversity perspective + acceptance + accommodation alongside skill-building

---

Adolescent ASD comorbidities integrative: ADHD (stimulant low/slow or non-stim), anxiety (SSRI + adapted CBT, AVOID BZD), sleep (melatonin), irritability (risperidone/aripiprazole FDA), adolescent issues (identity, sex ed, bullying, gender), transition planning, family support, address medical (epilepsy 20-30%). Neurodiversity.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'peds',
  'AAP ASD; AACAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 16 ปี autism spectrum + ADHD + anxiety + sleep + family stress + school challenges — adolescent ASD integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 38 ปี complex PTSD + depression + dissociation + chronic pain + substance use — trauma-integrative care', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Complex PTSD with Multiple Comorbidities — Integrative Phased Treatment"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex PTSD with Multiple Comorbidities — Integrative Phased Treatment: (1) **Phased treatment model** (Herman, ISTSS Complex PTSD): - **Phase 1 — Safety + Stabilization**: address self-harm, suicide risk, substance use, basic safety, skills (grounding, distress tolerance, emotion regulation), build alliance, psychoeducation — may take months-years before trauma processing; - **Phase 2 — Trauma processing**: gradual + integrated processing of trauma memories; - **Phase 3 — Integration + Re-engagement**: meaningful life, relationships, work, identity reconstruction; (2) **Trauma-focused therapies** (Phase 2): - **PE** (Prolonged Exposure); - **CPT** (Cognitive Processing Therapy); - **EMDR**; - **Trauma-focused CBT**; - For complex PTSD — adapted versions (STAIR + Narrative — Cloitre); - **Internal Family Systems (IFS)** + parts work for dissociation; (3) **Pharmacotherapy adjuncts**: - **SSRI** (sertraline + paroxetine FDA-approved PTSD); - **SNRI** (venlafaxine alternative); - **Prazosin** for nightmares; - **AVOID benzodiazepines** (worsen PTSD); - **Adjuncts**: atypical antipsychotic for severe + dissociation/psychotic-like (limited evidence); - **MDMA-assisted therapy** (FDA pending — research promising); - **Ketamine** + **psilocybin** (research); (4) **Comorbid depression**: - SSRI/SNRI overlap; - CBT; - Behavioral activation; - ECT for severe; (5) **Dissociation**: - Specialized assessment + treatment (ISSTD); - Grounding skills; - Address dissociative parts/states; - Avoid medications worsening dissociation (BZD, cannabis); (6) **Chronic pain — trauma overlap**: - Bidirectional; - CBT for chronic pain; - PT + mindfulness; - SNRI (duloxetine) overlap with PTSD + pain; - AVOID escalating opioids; (7) **Substance use** (very common — self-medication): - Integrated dual diagnosis treatment; - Address trauma + substance simultaneously (vs sequential — old model); - Seeking Safety (Najavits) — integrated PTSD + SUD curriculum; - MAT if opioid/alcohol; - Address harm reduction; (8) **Address social context**: - Safety from ongoing trauma (DV if applicable — safety planning, resources); - Stable housing; - Income; - Healthy relationships; - Address re-traumatization; (9) **Self-care + provider support**: - Vicarious traumatization risk; - Supervision essential; (10) **Trauma-informed care** throughout system; (11) **Multidisciplinary**: trauma-specialized therapist, psychiatry, primary care, pain medicine, addiction medicine, social work, peer support; (12) **Long-term**: gradual recovery; sustained engagement; complex PTSD takes years

---

Complex PTSD integrative: phased treatment (safety/stabilization → trauma processing → integration). PE/CPT/EMDR/STAIR for trauma. SSRI + prazosin (AVOID BZD). Integrated dual diagnosis (Seeking Safety). Chronic pain — CBT + non-opioid. Dissociation — ISSTD. Address ongoing trauma + social. Trauma-informed.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'ISTSS Complex PTSD; STAIR Cloitre', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 38 ปี complex PTSD + depression + dissociation + chronic pain + substance use — trauma-integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี severe BPD + AUD + bulimia + chronic SI + childhood trauma + custody issues — multi-disorder integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Multi-Disorder Severe Complex Case — Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-Disorder Severe Complex Case — Integrative: (1) **DBT** as foundational: - Comprehensive program (skills group + individual therapy + phone coaching + consultation team); - **Stage 1 — Behavioral stabilization**: address self-harm + suicidality + substance use + treatment-interfering behaviors + quality-of-life-interfering behaviors; - **Stage 2 — Trauma processing**: after stabilization; - **Stage 3 — Self-respect + ordinary problems**; - **Stage 4 — Capacity for joy**; (2) **AUD**: - **Naltrexone** (oral or LAI Vivitrol) — well-suited (affects reward + emotion regulation, FDA approved AUD); - Acamprosate alternative; - Disulfiram if highly motivated; - Behavioral (MET + CBT + 12-step); - Integrated with mental health; (3) **Bulimia**: - **CBT-E** (Enhanced — Fairburn) — gold standard; - **Fluoxetine 60mg** FDA approved BN; - Combined DBT + CBT-E may be needed; - Nutritional support + dietitian; - Medical monitoring (electrolytes, cardiac, dental); - **AVOID bupropion** (seizure risk); (4) **Trauma + childhood abuse**: - Address after Phase 1 stabilization; - Trauma-focused therapy (DBT-PE — Harned — integrates DBT + PE; or other trauma-focused after stabilization); - Trauma-informed care throughout; (5) **Chronic SI management**: - DBT skills (distress tolerance especially); - Distinguish chronic from acute change; - Crisis services + safety planning; - Brief hospitalization for acute danger (NOT extended — regression); - Address means restriction; (6) **Medication adjuncts** (no medication for BPD itself): - SSRI (depression, anxiety, bulimia); - Lamotrigine (emotion regulation); - Low-dose atypical (severe sx); - **AVOID benzodiazepines** (disinhibition + dependence + AUD); - **AVOID stimulants**; - Minimize polypharmacy; (7) **Custody issues**: - Mental health stigma in family court — advocacy; - Mental health does NOT automatically preclude custody; - Address actual parenting capacity; - Address children''s safety + needs; - Family therapy + supervised visitation if needed; - Social work + child welfare engagement; - Legal counsel; (8) **Children''s mental health** if involved — parent''s mental illness affects; address; (9) **Social determinants**: - Stable housing; - Income; - Healthy relationships; - Address ongoing stress + trauma sources; (10) **Address relapse + relapse prevention**: - Triggers + skills + support; - Long-term recovery model; (11) **Multidisciplinary**: DBT-trained therapist, psychiatrist, addiction medicine, eating disorder specialist, primary care, social work, legal, peer support, family therapy; (12) **Long-term**: treatment over years; 50% BPD remit at 10 yr; AUD + bulimia chronic with recovery possible; (13) **Provider self-care** — challenging cases; supervision essential

---

Severe multi-disorder BPD + AUD + bulimia + SI + trauma + custody: DBT foundational (Stage 1 safety → trauma processing). Naltrexone AUD. CBT-E + fluoxetine bulimia. Trauma after stabilization (DBT-PE). Address chronic SI. AVOID BZD + stimulants. Custody — actual capacity. Multidisciplinary. Provider self-care.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'Linehan DBT; Harned DBT-PE; CBT-E', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี severe BPD + AUD + bulimia + chronic SI + childhood trauma + custody issues — multi-disorder integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Refugee อายุ 35 ปี post-trauma + depression + cultural adjustment + family separation + somatic symptoms — refugee mental health integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Refugee Mental Health — Trauma + Culture + Resettlement Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Refugee Mental Health — Trauma + Culture + Resettlement Integrative: (1) **Trauma exposure layers**: - Pre-migration (war, violence, persecution, torture, sexual violence, witnessing); - Migration journey (smugglers, exploitation, deprivation, separation); - Post-migration (refugee camp conditions, asylum process stress, discrimination, language barriers, employment, separation from family, identity); (2) **Common presentations**: - **PTSD** (high prevalence — 30%+); - **Depression** (40%+); - **Anxiety**; - **Somatic symptoms** — somatic expression more accepted in many cultures than psychological complaints — body pain, GI, headache, weakness; (3) **Trauma-informed assessment**: - Build trust gradually; - Confidentiality + safety; - Cultural humility; - Avoid forced disclosure; - Multiple sessions; - Trauma-specific assessment (after stabilization + alliance); (4) **Treatment**: - **Phased approach** — safety + stabilization, then trauma-focused; - **Trauma-focused therapies adapted**: NET (Narrative Exposure Therapy) — designed for refugees + multiple trauma; CETA (Common Elements Treatment Approach) — transdiagnostic + low-resource; PE, CPT, EMDR; - **CBT for depression + anxiety**; - **SSRI** for PTSD + depression; - **Somatic complaints**: validate, treat medically, integrate gradually with psychological framing; - **Psychoeducation** culturally adapted; (5) **Cultural considerations**: - Cultural concepts of distress; - Family + community-centered (vs individual); - Spirituality + religion; - Gender + sexuality (sometimes additional persecution + trauma); - Traditional healing — collaborate when appropriate; - **Interpreters** essential (professional, not family); - Avoid translation of psychiatric terms — use cultural idioms when possible; (6) **Address current stressors**: - Asylum process — legal counsel; - Housing; - Employment + English/Thai language classes; - Healthcare access; - Education for children; - Social services navigation; - Community connections — connect with same-culture community where possible; (7) **Family separation**: - Sponsorship + reunification advocacy; - Communication with separated family if possible; - Address grief + uncertainty; (8) **Children of refugees**: - Acculturation gaps with parents; - School challenges; - Specific PTSD + depression; - Family therapy; (9) **Specific populations**: - **Survivors of torture** — specialized centers (HealTorture in US, Centre for Torture Trauma); - **Sexual + gender violence survivors**; - **LGBTQ+ refugees** (intersecting persecution); - **Unaccompanied minors**; (10) **System level**: - Trauma-informed services; - Linguistically + culturally competent providers; - Refugee resettlement agencies; - Community partnerships; - Advocacy for refugee mental health; (11) **Modern**: - **WHO + UNHCR** guidelines for refugee mental health; - **mhGAP** in refugee settings; - **Sphere standards**; (12) **Multidisciplinary**: psychiatry, primary care, social work, legal, education, refugee resettlement, community organizations

---

Refugee mental health: layered trauma (pre/migration/post). PTSD/depression/anxiety/somatic high. Phased treatment + NET/CETA adapted + SSRI. Cultural humility + interpreters + community + spirituality. Address current stressors (asylum, housing, employment). Specialized for torture, sexual violence, LGBTQ+, minors. WHO/UNHCR guidelines.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'WHO Refugee MH; NET Schauer', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Refugee อายุ 35 ปี post-trauma + depression + cultural adjustment + family separation + somatic symptoms — refugee mental health integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี chronic schizophrenia + smoking + clozapine + medical comorbidity (obesity, diabetes, sleep apnea) + family burden — chronic SMI integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Chronic Severe Mental Illness + Multiple Comorbidities — Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Severe Mental Illness + Multiple Comorbidities — Integrative: (1) **SMI medical comorbidity** = major mortality contributor: - 15-20 years reduced life expectancy in schizophrenia; - Cardiovascular leading cause; - Underdiagnosed + undertreated medical illness; (2) **Clozapine management**: - **Mandatory monitoring** — ANC, troponin/CRP/ECG, metabolic; - Specialist clozapine clinics improve outcomes; - Address side effects (sialorrhea, constipation, sedation, weight, metabolic); - Bowel monitoring — ileus mortality risk; - **Smoking + clozapine**: smoking induces CYP1A2 → lowers clozapine level; if quit smoking, level rises (toxicity risk — monitor); - **Therapeutic level** 350-600 ng/mL; (3) **Smoking cessation in schizophrenia**: - 50-90% smoke; - Lower quit rates but feasible; - Varenicline FDA approved + safety reassured (EAGLES); - NRT combinations; - Bupropion; - Behavioral support; - Monitor clozapine level if level was relying on smoking induction; (4) **Metabolic syndrome**: - **Aggressive prevention + treatment**; - Lifestyle (diet, exercise, weight); - Switch to lower-metabolic agent if possible (but clozapine often essential for TRS); - **Metformin** for weight gain prevention (off-label) modest evidence; - **GLP-1 agonists (semaglutide, tirzepatide)** — significant weight loss + DM benefit + acceptable in schizophrenia (emerging); - **Statin** for lipids; - **Glycemic control** for DM; - **BP** management; (5) **Sleep apnea**: - High prevalence with obesity; - CPAP therapy; - Weight loss synergy; - Improves cognition, mood, daytime function, CV risk; (6) **Other medical**: - Dental (often neglected); - Vision; - Cancer screening; - Vaccinations; - Hepatitis screening; - Drug interactions; (7) **Psychiatric optimization**: - **Long-acting injectable (LAI)** consideration if adherence issue + non-clozapine agent (clozapine no LAI); - **Psychosocial**: ACT for severe persistent; supported employment; supported housing; CBTp; - **Substance use** screening + treatment; - **Suicide risk** assessment ongoing (lifetime 5-10%); (8) **Family + caregiver support**: - **NAMI Family-to-Family**; - Family education reduces relapse + expressed emotion; - Caregiver burden + mental health; - Sibling + children of patient; - Multifamily group therapy; (9) **Social determinants**: - Housing; - Income (often SSDI); - Healthcare access; - Stigma; - Social engagement; (10) **Modern**: - **Health home model** integrating mental + physical health; - **Behavioral health-primary care integration**; - **Wellness coaching**; - **Peer support specialists**; (11) **Multidisciplinary lifelong team**: psychiatry, primary care, endocrinology, cardiology, sleep medicine, dental, social work, peer support, family, employment, housing support

---

Chronic SMI + medical comorbidity: 15-20 yr reduced life expectancy. Clozapine monitoring + smoking interaction (CYP1A2). Smoking cessation (varenicline EAGLES). Metabolic — lifestyle + metformin + GLP-1 emerging + statin + DM control. CPAP. Family support (NAMI). Integrated health home. Multidisciplinary lifelong.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'EAGLES; APA Schizophrenia; NAMI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี chronic schizophrenia + smoking + clozapine + medical comorbidity (obesity, diabetes, sleep apnea) + family burden — chronic SMI integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี end-of-life + advanced cancer + depression + existential distress + family conflict + pain — palliative psychiatric integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Palliative Psychiatric Care — End-of-Life Integrative"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Palliative Psychiatric Care — End-of-Life Integrative: (1) **Distinguish in advanced illness**: - **Adjustment** to diagnosis (normal); - **Demoralization** (loss of meaning, helplessness, hopelessness, NOT same as depression — distinct construct, responds to meaning-focused interventions); - **Depression** (anhedonia, guilt, worthlessness, persistent — distinct from sadness); - **Delirium** (very common end-of-life — under-recognized; rule out organic); - **Existential distress** (death anxiety, meaning); - **Anticipatory grief**; (2) **Depression in advanced illness**: - **Antidepressants — fast-acting options preferred** given prognosis: - **Methylphenidate** — onset within days, palliative care use, also helps fatigue; - **Ketamine** — rapid antidepressant, end-of-life setting research; - **Standard SSRI** — onset 2-6 wk (may not have time); - Sertraline, escitalopram, mirtazapine (multiple symptom benefit — appetite, sleep, antiemetic); - **CBT, IPT** adapted for limited time; - **Psychotherapy** specifically for advanced illness: - **Meaning-Centered Psychotherapy** (Breitbart) — addresses meaning + purpose; - **Dignity Therapy** (Chochinov) — life review, legacy; - **CALM** (Managing Cancer + Living Meaningfully — Rodin) — short-term, multiple themes; (3) **Existential distress**: - **Meaning-centered + dignity therapies**; - **Spiritual care** + chaplaincy; - **Psychedelic-assisted therapy** for end-of-life existential distress (psilocybin — FDA breakthrough, research base — Griffiths Hopkins) — emerging; - **Acceptance + commitment therapy**; - **Mindfulness**; (4) **Pain + symptom management**: - Adequate analgesia (often opioid scheduled + breakthrough); - Pain → mood interaction; - Adjuvants (gabapentin, antidepressants); - Address other sx (nausea, constipation, dyspnea, fatigue); (5) **Delirium at end-of-life**: - Extremely common (terminal delirium); - Identify reversible causes (medications, infection, electrolytes, dehydration); - Non-pharmacologic; - Low-dose antipsychotic if needed (haloperidol historically; atypicals); - Family education (often distressing for family); (6) **Family**: - Communication + family meetings; - Anticipatory grief; - Family conflict mediation; - Children of patient; - Bereavement support post-death; (7) **Goals of care + advance care planning**: - Patient''s values + wishes; - Hospice eligibility; - POLST; - Surrogate decision-making; - Code status; (8) **Hospice integration** — psychiatric + symptom management + family + spiritual + bereavement; (9) **Provider self-care** — emotional toll of palliative work; (10) **Ethical issues**: - Medical aid in dying (where legal — assessment + capacity); - Withdrawal of treatment; - Withholding food/fluid; - Palliative sedation; - Suicide vs aid in dying distinction; (11) **Multidisciplinary**: palliative care, psychiatry, oncology, primary care, nursing, chaplaincy, social work, hospice, family

---

Palliative psychiatric: distinguish demoralization vs depression vs delirium. Fast-acting antidepressants (methylphenidate, ketamine). Meaning-centered + dignity + CALM therapy. Existential distress + psychedelic-assisted research. Symptom management (pain, delirium). Family + advance care + hospice. Ethical issues. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'Breitbart MCP; Chochinov Dignity', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี end-of-life + advanced cancer + depression + existential distress + family conflict + pain — palliative psychiatric integrative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี first-episode depression + suicidality + medical resident with high-stress job + relationship issues + sleep deprivation — physician mental health integrative', '[{"label":"A","text":"No intervention"},{"label":"B","text":"Resident Physician Depression + Suicidality — Integrative Approach"},{"label":"C","text":"Single approach"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Resident Physician Depression + Suicidality — Integrative Approach: (1) **Safety assessment** primary: - Suicide risk assessment (C-SSRS); - Means restriction (access to medications, knowledge of lethal means); - Brief hospitalization if needed; safety planning; - Family + close contacts involved appropriately; (2) **Treatment**: - **SSRI** first-line (sertraline, escitalopram) — safe, well-tolerated, low overdose risk vs TCA; - **CBT or IPT** psychotherapy — combine for severity; - **ECT** if severe + refractory + suicidal — safe + effective; - **Address sleep deprivation** — bidirectional with depression; reduce on-call burden if possible; CBT-I once shift work allows; melatonin agonist; - **Address relationship + life issues** — couples or individual therapy; (3) **Physician-specific considerations**: - **Stigma + reluctance** to seek care — self-treatment + denial common + dangerous; - **Confidentiality concerns** — fear of credentialing/licensing impact; - **Separate clinical care** from work setting if possible; - **Confidential PHP (Physician Health Program)** if needed — protective + non-disciplinary in most states (vs Board of Medicine); - **Treatment compatible with continued practice** — most depression + anxiety treatment does not impair practice; appropriate accommodations; (4) **Address work environment** (system-level — not just individual): - **Reduce duty hours** within ACGME limits; - **Adequate supervision**; - **Workload management**; - **Wellness initiatives**; - **Peer support programs** (resident peer support); - **Reduce administrative burden**; - **Address culture** (mental health acceptable to discuss, leadership modeling); (5) **Physician suicide** elevated risk: - Especially female physicians; - Means access (medications, lethal knowledge); - Address contributors; - Means restriction essential; - Crisis resources (988, Physician Support Line, Lawyers Concerned for Lawyers analogous, AFSP); - **Loss of physician colleague** affects entire program — postvention; (6) **Substance use** screening (high rates physicians, especially EM + anesthesiology) — address if present; (7) **Trainee-specific stressors**: - High debt; - Long hours; - Sleep deprivation; - Trauma exposure (patient deaths, suffering, errors); - Pandemic effects (moral injury, exhaustion); - Imposter syndrome; - Disclosure dilemmas; (8) **Mentorship + community**: - Faculty mentorship; - Peer support; - Resident wellness committee; - Address isolation; (9) **Address relationship**: - Couples therapy; - Address partner''s burden; - Healthy relationship maintenance important; (10) **Long-term**: - Sustainable career + life integration; - Boundary setting; - Continued mental health awareness lifelong; (11) **Multidisciplinary + system change**: - Treatment provider + PHP + program leadership + wellness office + occupational health if needed; - System-level change essential — individual interventions alone insufficient; (12) **Hope + recovery messaging** — depression treatable; physicians can recover + continue careers; story of survival

---

Resident physician depression + suicidality: safety + means restriction + SSRI/ECT + CBT/IPT + sleep address. Physician-specific: stigma, confidentiality (PHP), licensing concerns, separate clinical care. System change essential (duty hours, workload, culture). Physician suicide elevated — means restriction. Mentorship + peer support. Hope + recovery.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'AMA Wellness; AFSP Physician Suicide', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี first-episode depression + suicidality + medical resident with high-stress job + relationship issues + sleep deprivation — physician mental health integrative'
  );

commit;

