/* ──────────────────────────────────────────────
   ACLS EMR — Type definitions
   ────────────────────────────────────────────── */

export type AclsRhythm =
  | "VF"
  | "pVT"
  | "PEA"
  | "Asystole"
  | "Sinus Bradycardia"
  | "SVT"
  | "AF with RVR"
  | "VT with pulse"
  | "ROSC"
  | "Other";

export type AclsOutcome =
  | "ROSC"
  | "Death"
  | "Ongoing CPR"
  | "Transfer";

export type AclsDrugRoute = "IV" | "IO" | "ET";

export interface AclsDrugEntry {
  id: string;
  time: string; // HH:mm
  drug: string;
  dose: string;
  route: AclsDrugRoute;
  note?: string;
}

export interface AclsDefibrillation {
  id: string;
  time: string;
  energy: number; // joules
  type: "Monophasic" | "Biphasic";
  rhythm_before: AclsRhythm;
  rhythm_after: AclsRhythm;
}

export interface AclsTimelineEvent {
  id: string;
  time: string;
  event: string;
  detail?: string;
}

export interface AclsRecord {
  id: string;
  // Patient
  patient_name: string;
  patient_age: number;
  patient_gender: "M" | "F";
  patient_hn?: string;
  patient_weight?: number;

  // Arrest info
  arrest_date: string; // ISO date
  arrest_time: string; // HH:mm
  arrest_location: string;
  witnessed: boolean;
  bystander_cpr: boolean;
  initial_rhythm: AclsRhythm;

  // Team
  team_leader: string;
  recorder: string;
  team_members?: string;

  // Interventions
  cpr_start_time: string;
  drugs: AclsDrugEntry[];
  defibrillations: AclsDefibrillation[];
  timeline: AclsTimelineEvent[];

  // Airway
  airway_management: string;
  iv_access: string;

  // Reversible causes (5H5T)
  reversible_causes: string[];

  // Outcome
  outcome: AclsOutcome;
  rosc_time?: string;
  end_time: string;
  total_duration_min?: number;
  post_rosc_care?: string;
  notes?: string;

  // Meta
  created_at: string;
  updated_at: string;
}

// For the form — partial record being built step by step
export type AclsFormData = Omit<AclsRecord, "id" | "created_at" | "updated_at">;

export const INITIAL_FORM_DATA: AclsFormData = {
  patient_name: "",
  patient_age: 0,
  patient_gender: "M",
  patient_hn: "",
  patient_weight: undefined,
  arrest_date: new Date().toISOString().slice(0, 10),
  arrest_time: "",
  arrest_location: "",
  witnessed: false,
  bystander_cpr: false,
  initial_rhythm: "VF",
  team_leader: "",
  recorder: "",
  team_members: "",
  cpr_start_time: "",
  drugs: [],
  defibrillations: [],
  timeline: [],
  airway_management: "",
  iv_access: "",
  reversible_causes: [],
  outcome: "ROSC",
  rosc_time: "",
  end_time: "",
  total_duration_min: undefined,
  post_rosc_care: "",
  notes: "",
};

export const RHYTHMS: AclsRhythm[] = [
  "VF",
  "pVT",
  "PEA",
  "Asystole",
  "Sinus Bradycardia",
  "SVT",
  "AF with RVR",
  "VT with pulse",
  "ROSC",
  "Other",
];

export const REVERSIBLE_CAUSES_5H = [
  "Hypovolemia",
  "Hypoxia",
  "Hydrogen ion (Acidosis)",
  "Hypo/Hyperkalemia",
  "Hypothermia",
];

export const REVERSIBLE_CAUSES_5T = [
  "Tension pneumothorax",
  "Tamponade (cardiac)",
  "Toxins",
  "Thrombosis (pulmonary)",
  "Thrombosis (coronary)",
];

export const COMMON_ACLS_DRUGS = [
  "Epinephrine 1 mg",
  "Amiodarone 300 mg",
  "Amiodarone 150 mg",
  "Lidocaine 1-1.5 mg/kg",
  "Atropine 1 mg",
  "Adenosine 6 mg",
  "Adenosine 12 mg",
  "Vasopressin 40 U",
  "Calcium Chloride 1 g",
  "Sodium Bicarbonate 50 mEq",
  "Magnesium Sulfate 2 g",
];
