// Single source of truth for the BROAD NL subjects that compiled past-exam
// papers are organised by (Internal medicine, Surgery, Pediatrics, ...). Used
// by the in-web PDF importer to (a) auto-create the subjects, (b) tell Claude
// which subject slugs are allowed, and (c) the Python helper scripts mirror this
// list. Coarser than the AI-generated subspecialty subjects on purpose.

export interface NlSubjectSeed {
  name: string; // slug — unique in mcq_subjects.name
  name_th: string;
  icon: string;
  exam_type: "NL1" | "NL2";
}

export const NL_BROAD_SUBJECTS: NlSubjectSeed[] = [
  // NL2 (clinical)
  { name: "internal_med", name_th: "อายุรศาสตร์ (รวม)", icon: "🩺", exam_type: "NL2" },
  { name: "surgery", name_th: "ศัลยศาสตร์", icon: "🔪", exam_type: "NL2" },
  { name: "ped", name_th: "กุมารเวชศาสตร์", icon: "👶", exam_type: "NL2" },
  { name: "ob_gyn", name_th: "สูติศาสตร์-นรีเวชวิทยา", icon: "🤰", exam_type: "NL2" },
  { name: "ortho", name_th: "ออร์โธปิดิกส์", icon: "🦴", exam_type: "NL2" },
  { name: "psychi", name_th: "จิตเวชศาสตร์", icon: "🧘", exam_type: "NL2" },
  { name: "ent", name_th: "โสต ศอ นาสิก (ENT)", icon: "👂", exam_type: "NL2" },
  { name: "eye", name_th: "จักษุวิทยา", icon: "👁️", exam_type: "NL2" },
  { name: "forensic", name_th: "นิติเวชศาสตร์", icon: "🔍", exam_type: "NL2" },
  { name: "epidemio", name_th: "เวชศาสตร์ชุมชน/ระบาดวิทยา", icon: "📊", exam_type: "NL2" },
  { name: "emergency", name_th: "เวชศาสตร์ฉุกเฉิน", icon: "🚑", exam_type: "NL2" },
  { name: "radiology", name_th: "รังสีวิทยา", icon: "🩻", exam_type: "NL2" },
  { name: "anesthesia", name_th: "วิสัญญีวิทยา", icon: "💉", exam_type: "NL2" },
  { name: "rehab", name_th: "เวชศาสตร์ฟื้นฟู", icon: "🦽", exam_type: "NL2" },
  { name: "derm", name_th: "ตจวิทยา (ผิวหนัง)", icon: "🩹", exam_type: "NL2" },
  { name: "family_med", name_th: "เวชศาสตร์ครอบครัว", icon: "👨‍👩‍👧", exam_type: "NL2" },
  // NL1 (preclinical)
  { name: "biochemistry", name_th: "ชีวเคมี/อณูชีววิทยา", icon: "🧪", exam_type: "NL1" },
  { name: "cell_biology", name_th: "ชีววิทยาของเซลล์", icon: "🔬", exam_type: "NL1" },
  { name: "genetics", name_th: "พันธุศาสตร์/พัฒนาการ", icon: "🧬", exam_type: "NL1" },
  { name: "immunology", name_th: "วิทยาภูมิคุ้มกัน", icon: "🛡️", exam_type: "NL1" },
  { name: "microbiology", name_th: "จุลชีววิทยา", icon: "🦠", exam_type: "NL1" },
  { name: "parasitology", name_th: "ปรสิตวิทยา", icon: "🪱", exam_type: "NL1" },
  { name: "pharmacology", name_th: "เภสัชวิทยาพื้นฐาน", icon: "💊", exam_type: "NL1" },
  { name: "biostatistics", name_th: "ชีวสถิติ/ระเบียบวิธีวิจัย", icon: "📈", exam_type: "NL1" },
  { name: "pathology", name_th: "พยาธิวิทยา", icon: "🧫", exam_type: "NL1" },
  { name: "lab_principles", name_th: "หลักการตรวจทางห้องปฏิบัติการ", icon: "⚗️", exam_type: "NL1" },
  { name: "hemato_preclinic", name_th: "ระบบเลือด (preclinic)", icon: "🩸", exam_type: "NL1" },
  { name: "cardiovascular", name_th: "ระบบหัวใจและหลอดเลือด (preclinic)", icon: "❤️", exam_type: "NL1" },
  { name: "respiratory", name_th: "ระบบทางเดินหายใจ (preclinic)", icon: "🫁", exam_type: "NL1" },
  { name: "gi_preclinic", name_th: "ระบบทางเดินอาหาร (preclinic)", icon: "🫄", exam_type: "NL1" },
  { name: "renal_preclinic", name_th: "ระบบไต (preclinic)", icon: "🫘", exam_type: "NL1" },
  { name: "neuro_preclinic", name_th: "ระบบประสาท (preclinic)", icon: "🧠", exam_type: "NL1" },
  { name: "endocrine_preclinic", name_th: "ระบบต่อมไร้ท่อ (preclinic)", icon: "🦋", exam_type: "NL1" },
  { name: "reproductive", name_th: "ระบบสืบพันธุ์", icon: "🍼", exam_type: "NL1" },
  { name: "musculoskeletal", name_th: "ระบบกล้ามเนื้อและกระดูก", icon: "💪", exam_type: "NL1" },
  { name: "skin", name_th: "ระบบผิวหนัง", icon: "🧴", exam_type: "NL1" },
  { name: "multisystem", name_th: "กระบวนการหลายระบบ", icon: "🔗", exam_type: "NL1" },
];

export function broadSubjectsFor(examType: "NL1" | "NL2"): NlSubjectSeed[] {
  return NL_BROAD_SUBJECTS.filter((s) => s.exam_type === examType);
}

// Fix common Thai PDF text-extraction artifacts (mirrors the Python helpers).
export function cleanPdfText(text: string): string {
  const repl: Record<string, string> = {
    "ÿ": "ส", "Ā": "ห", "š": "้", "ü": "ว", "Š": "่", "ś": "๊",
    "ŧ": "็", "Ť": "์", "ŗ": "", "Ũ": "็", "Ř": "์", "þ": "ษ", "Ŧ": "์",
  };
  return text.replace(/[ÿĀšüŠśŧŤŗŨŘþŦ]/g, (c) => repl[c] ?? c);
}

// Split text into overlapping chunks so questions on a boundary aren't lost
// (the importer dedupes by scenario, so a little overlap is safe).
export function chunkText(text: string, size = 9000, overlap = 600): string[] {
  const chunks: string[] = [];
  const n = text.length;
  let i = 0;
  while (i < n) {
    chunks.push(text.slice(i, i + size));
    if (i + size >= n) break;
    i += size - overlap;
  }
  return chunks;
}
