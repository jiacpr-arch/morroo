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
