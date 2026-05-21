// Primary reference textbook per board specialty. Used by:
// - app/api/ai/longcase-examiner: grounds the "อ.บอร์ด" persona in the
//   right source for the candidate's specialty
// - (mirror of the map in scripts/generate-board-daily.mjs — keep in sync)

export const BOARD_SPECIALTY_REFERENCE: Record<string, string> = {
  emergency_medicine:
    "Tintinalli's Emergency Medicine 9e + AHA/ACEP guidelines ปัจจุบัน",
  internal_medicine:
    "Harrison's Principles of Internal Medicine 21e + guideline ของสมาคมที่เกี่ยวข้อง (AHA, ADA, KDIGO ฯลฯ)",
  surgery:
    "Schwartz's Principles of Surgery 11e / Sabiston Textbook of Surgery 21e + NCCN guidelines",
  pediatrics:
    "Nelson Textbook of Pediatrics 22e + AAP guidelines + แนวทางราชวิทยาลัยกุมารแพทย์ฯ",
  ob_gyn:
    "Williams Obstetrics 26e / Williams Gynecology 4e + ACOG / RCOG guidelines",
  orthopedics:
    "Campbell's Operative Orthopedics 14e / Rockwood and Green's Fractures 9e + AAOS guidelines",
  psychiatry:
    "Kaplan & Sadock's Synopsis of Psychiatry 12e + DSM-5-TR + APA practice guidelines",
  anesthesiology:
    "Miller's Anesthesia 9e + Stoelting's Anesthesia and Co-Existing Disease 8e + ASA guidelines",
  radiology:
    "Brant and Helms' Fundamentals of Diagnostic Radiology 5e / Radiology Review Manual 9e + ACR appropriateness criteria",
  family_medicine:
    "Williams Manual of Family Medicine + USPSTF recommendations + AAFP guidelines",
  pathology:
    "Robbins and Cotran Pathologic Basis of Disease 10e + Rosai and Ackerman's Surgical Pathology 11e + WHO classifications",
  rehab_medicine:
    "DeLisa's Physical Medicine and Rehabilitation 6e + Braddom's Physical Medicine and Rehabilitation 6e",
};

export function getBoardReference(specialty: string | null): string {
  if (!specialty) return "ตำรามาตรฐานของราชวิทยาลัยฯ";
  return BOARD_SPECIALTY_REFERENCE[specialty] ?? "ตำรามาตรฐานของราชวิทยาลัยฯ";
}
