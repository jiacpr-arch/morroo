/**
 * Resolve a fixed UI order-button label (e.g. "Heart", "ECG", "UA") to the
 * key a Long Case actually stored its result under (e.g. "Cardiovascular",
 * "12-lead ECG", "Urinalysis").
 *
 * Cases are generated with inconsistent, bespoke key names, while the order
 * UI (PE_SYSTEMS / COMMON_LABS) uses a fixed list. A plain `results[label]`
 * lookup therefore misses and the student/examiner wrongly sees
 * "ไม่มีผลในระบบ" / "ปกติ". This matcher bridges the two with, in order:
 *   1. exact match
 *   2. normalized match (case-, space- and punctuation-insensitive)
 *   3. synonym-group match (curated equivalents below)
 *   4. containment fallback (e.g. "ECG" ⊂ "12-lead ECG")
 */

export const normalizeKey = (s: string): string =>
  s.toLowerCase().replace(/[^a-z0-9]/g, "");

// Each inner array is a group of equivalent names. The first entry is the
// canonical UI label; the rest are key variants seen in generated cases.
const SYNONYM_GROUPS: string[][] = [
  // --- Physical exam systems ---
  ["GA", "General Appearance", "General", "General Exam"],
  ["HEENT", "Head and Neck", "Head & Neck", "Neck", "ENT", "Eyes"],
  ["Heart", "CVS", "CV", "Cardiac", "Cardiovascular", "Cardiovascular System"],
  ["Lung", "Lungs", "Chest", "Respiratory", "Pulmonary", "Respiratory System", "Chest/Lungs"],
  ["Abdomen", "Abdominal", "GI", "Gastrointestinal", "Abdominal Exam"],
  ["GU", "Genitourinary", "Genital", "Pelvic", "Pelvic Exam"],
  ["Extremities", "Extremity", "Musculoskeletal", "MSK", "Limbs"],
  ["Neuro", "Neurological", "Neurologic", "Nervous System", "CNS", "Neuro Exam"],
  ["Skin", "Integumentary", "Dermatologic", "Dermatological"],

  // --- Labs ---
  ["CBC", "Complete Blood Count"],
  ["BMP", "Basic Metabolic Panel", "Chem 7"],
  ["LFT", "LFTs", "Liver Function Test", "Liver Function Tests", "Liver Panel"],
  ["Coagulation", "Coags", "Coagulogram", "PT/PTT", "PT / PTT", "PT/INR", "PT / INR", "Coagulation Profile"],
  ["UA", "Urinalysis", "Urine Analysis", "Urine Exam", "U/A"],
  ["UPT", "Urine Pregnancy Test", "Pregnancy Test", "Beta-hCG", "B-hCG", "hCG"],
  ["Troponin I", "Troponin", "Troponin T", "Trop", "hs-Troponin", "Cardiac Troponin", "Troponin-I", "Troponin-T"],
  ["CK-MB", "CKMB", "CK MB"],
  ["BNP", "NT-proBNP", "proBNP", "NT proBNP"],
  ["Lactate", "Serum Lactate", "Lactic Acid"],
  ["Blood culture", "Blood Culture", "Blood Cultures", "Hemoculture", "H/C"],
  ["Sputum AFB", "AFB", "AFB Smear", "Sputum AFB Stain", "Sputum for AFB"],

  // --- Imaging ---
  ["CXR", "Chest X-Ray", "Chest X-ray", "Chest Xray", "Chest X-Ray (PA)", "CXR (PA)", "Chest Radiograph"],
  ["ECG", "EKG", "12-lead ECG", "12 lead ECG", "12-Lead ECG", "Electrocardiogram"],
  ["Scrotal US", "Scrotal Ultrasound", "Testicular US", "Testicular Ultrasound"],
  ["Transvaginal US", "TVS", "TVUS", "Transvaginal Ultrasound"],
  ["CT Abdomen", "CT Abdomen/Pelvis", "Abdominal CT", "CT Abd", "CTA Abdomen", "CT Whole Abdomen"],
  ["CT Head", "CT Brain", "Brain CT", "NCCT Head", "CT Head Non-contrast"],
  ["MRI Brain", "MRI Head", "Brain MRI", "MRI Brain with contrast"],
  ["Echo", "Echocardiography", "Echocardiogram", "Echocardiography (2D + Doppler)", "2D Echo", "TTE"],
];

const GROUP_OF = new Map<string, number>();
SYNONYM_GROUPS.forEach((group, i) =>
  group.forEach(name => GROUP_OF.set(normalizeKey(name), i))
);

/** Return the actual key in `available` that matches `query`, or undefined. */
export function matchKey(query: string, available: string[]): string | undefined {
  if (available.includes(query)) return query;

  const nq = normalizeKey(query);
  if (!nq) return undefined;

  const normExact = available.find(k => normalizeKey(k) === nq);
  if (normExact) return normExact;

  const group = GROUP_OF.get(nq);
  if (group !== undefined) {
    const bySynonym = available.find(k => GROUP_OF.get(normalizeKey(k)) === group);
    if (bySynonym) return bySynonym;
  }

  if (nq.length >= 3) {
    const contained = available.find(k => {
      const nk = normalizeKey(k);
      return nk.length >= 3 && (nk.includes(nq) || nq.includes(nk));
    });
    if (contained) return contained;
  }

  return undefined;
}

/** Look up a value from `results` by `query`, tolerating key-name variants. */
export function matchResult<T>(query: string, results: Record<string, T>): T | undefined {
  const key = matchKey(query, Object.keys(results));
  return key === undefined ? undefined : results[key];
}

// ---------------------------------------------------------------------------
// history_script reconciliation
//
// Two case authors write history_script with two different key vocabularies:
//   - hand-authored / admin cases use short keys (cc, pi, onset, pmh, ...)
//   - the weekly auto-generator writes long keys (chief_complaint, hpi, ...)
// The AI-patient route only ever read the short keys, so every auto-generated
// case fed the model a BLANK history and it improvised a patient that
// contradicted the (correctly stored) PE / labs / diagnosis. Resolve both
// vocabularies to one canonical shape so either author works.
// ---------------------------------------------------------------------------

/** Canonical fields the AI-patient prompt needs from a case's history_script. */
export interface HistoryScript {
  cc: string;        // chief complaint
  pi: string;        // present illness / HPI
  onset: string;     // onset, duration, character
  pmh: string;       // past medical history
  meds: string;      // current medications
  allergies: string; // drug/food allergies
  fh: string;        // family history
  sh: string;        // social history
  ros: string;       // review of systems
}

const HISTORY_ALIASES: Record<keyof HistoryScript, string[]> = {
  cc: ["cc", "chief_complaint", "chiefComplaint", "chief complaint"],
  pi: ["pi", "hpi", "present_illness", "history_present_illness", "presentIllness"],
  onset: ["onset", "onset_duration", "duration", "character"],
  pmh: ["pmh", "past_medical", "past_medical_history", "pastMedical", "underlying"],
  meds: ["meds", "medications", "medication", "current_medications", "drugs"],
  allergies: ["allergies", "allergy", "drug_allergy", "drugAllergy"],
  fh: ["fh", "family_history", "familyHistory"],
  sh: ["sh", "social_history", "socialHistory", "social"],
  ros: ["ros", "review_of_systems", "reviewOfSystems", "review_of_system"],
};

/**
 * Resolve a raw history_script (either key vocabulary) into the canonical
 * {@link HistoryScript} shape. Missing fields come back as "" so the caller
 * can treat them uniformly.
 */
export function readHistoryScript(
  raw: Record<string, unknown> | null | undefined,
): HistoryScript {
  const byNorm = new Map<string, string>();
  for (const [k, v] of Object.entries(raw ?? {})) {
    const str = typeof v === "string" ? v : v == null ? "" : JSON.stringify(v);
    if (str) byNorm.set(normalizeKey(k), str);
  }

  const out = {} as HistoryScript;
  for (const field of Object.keys(HISTORY_ALIASES) as (keyof HistoryScript)[]) {
    out[field] =
      HISTORY_ALIASES[field]
        .map((alias) => byNorm.get(normalizeKey(alias)))
        .find((v) => v) ?? "";
  }
  return out;
}
