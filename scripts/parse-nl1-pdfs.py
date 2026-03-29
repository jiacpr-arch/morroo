#!/usr/bin/env python3
"""
Parse NL1 MCQ questions from PDF files
Extracts questions, choices, answers, and explanations
Outputs JSON files ready for Supabase import
"""

import PyPDF2
import re
import json
import os
import sys

OUTPUT_DIR = "/Users/apple/Desktop/NL1_parsed"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def extract_text(pdf_path):
    reader = PyPDF2.PdfReader(open(pdf_path, 'rb'))
    text = ""
    for p in reader.pages:
        t = p.extract_text()
        if t:
            text += t + "\n"
    return text

def clean_text(text):
    """Fix common PDF extraction artifacts"""
    # Fix broken Thai characters from PDF extraction
    text = text.replace('ÿ', 'ส')
    text = text.replace('Ā', 'ห')
    text = text.replace('š', '้')
    text = text.replace('ü', 'ว')
    text = text.replace('Š', '่')
    text = text.replace('ś', '๊')
    text = text.replace('ŧ', '็')
    text = text.replace('Ť', '์')
    text = text.replace('ŗ', '')
    text = text.replace('Ũ', '็')
    text = text.replace('Ř', '์')
    text = text.replace('þ', 'ษ')
    text = text.replace('Ŧ', '์')
    return text

def parse_classified_pdf(text, subject_name):
    """Parse classified PDF format: question + choices + คำตอบ + explanation"""
    questions = []

    # Split by question number pattern
    # Pattern: number. followed by text (at start of line or after whitespace)
    parts = re.split(r'(?:^|\n)\s*(\d+)\.\s', text)

    # parts[0] is preamble, then alternating: [number, content, number, content, ...]
    i = 1
    while i < len(parts) - 1:
        q_num = int(parts[i])
        q_content = parts[i + 1]
        i += 2

        # Parse question content: scenario + choices + answer + explanation
        q = parse_question_block(q_content, q_num, subject_name)
        if q:
            questions.append(q)

    return questions

def parse_question_block(content, q_num, subject_name):
    """Parse a single question block"""

    # Find choices - pattern: A.) text or A. text or a) text
    choice_pattern = r'([A-E])\s*[\.\)]+\s*(.+?)(?=\n\s*[A-E]\s*[\.\)]+|\nค[ํา]าตอบ|\n\s*$)'

    # Split at คำตอบ/คําตอบ
    answer_split = re.split(r'ค[ํา]าตอบ', content, maxsplit=1)

    if len(answer_split) < 2:
        # No answer section found - try alternate patterns
        answer_split = re.split(r'เฉลย', content, maxsplit=1)

    question_part = answer_split[0] if answer_split else content
    answer_part = answer_split[1] if len(answer_split) > 1 else ""

    # Extract choices from question part
    choices = {}
    choice_matches = re.findall(r'([A-E])\s*[\.\)]+\s*(.+?)(?=\s*[A-E]\s*[\.\)]+|$)',
                                 question_part, re.DOTALL)

    if not choice_matches:
        # Try single-line pattern
        for line in question_part.split('\n'):
            m = re.match(r'\s*([A-E])\s*[\.\)]+\s*(.+)', line.strip())
            if m:
                choices[m.group(1)] = m.group(2).strip()
    else:
        for label, text in choice_matches:
            choices[label] = text.strip().split('\n')[0].strip()

    if len(choices) < 2:
        return None

    # Extract scenario (everything before first choice)
    scenario = question_part
    first_choice_match = re.search(r'\n\s*A\s*[\.\)]', question_part)
    if first_choice_match:
        scenario = question_part[:first_choice_match.start()].strip()

    # Clean up scenario
    scenario = re.sub(r'\s+', ' ', scenario).strip()
    if not scenario or len(scenario) < 5:
        return None

    # Extract correct answer
    correct_answer = "A"
    ans_match = re.search(r'ตอบข[้š]อ\s*([A-E])', answer_part)
    if not ans_match:
        ans_match = re.search(r'([A-E])\s*[\.\)]+', answer_part[:50])
    if ans_match:
        correct_answer = ans_match.group(1)

    # Extract explanation (bullet points after answer)
    explanation_lines = []
    for line in answer_part.split('\n'):
        line = line.strip()
        if line.startswith('•') or line.startswith('-'):
            explanation_lines.append(line)
        elif explanation_lines and line and not re.match(r'ตอบข', line):
            # Continuation of previous bullet
            explanation_lines[-1] += ' ' + line

    explanation = '\n'.join(explanation_lines) if explanation_lines else ""

    # Build choice array format for DB
    choices_arr = []
    for label in sorted(choices.keys()):
        choices_arr.append({
            "label": label,
            "text": choices[label]
        })

    # Build detailed explanation
    detailed = None
    if explanation:
        choice_explanations = []
        for c in choices_arr:
            # Try to find per-choice explanation
            per_choice = ""
            for line in explanation_lines:
                if c["label"] + ")" in line or c["label"] + "." in line or c["text"][:10] in line:
                    per_choice = line
                    break
            choice_explanations.append({
                "label": c["label"],
                "text": c["text"],
                "is_correct": c["label"] == correct_answer,
                "explanation": per_choice
            })

        detailed = {
            "summary": explanation_lines[0] if explanation_lines else "",
            "reason": explanation,
            "choices": choice_explanations,
            "key_takeaway": explanation_lines[-1] if explanation_lines else ""
        }

    return {
        "subject": subject_name,
        "exam_type": "NL1",
        "question_number": q_num,
        "scenario": scenario,
        "choices": choices_arr,
        "correct_answer": correct_answer,
        "explanation": explanation[:500] if explanation else None,
        "detailed_explanation": detailed,
        "difficulty": "medium",
        "is_ai_enhanced": False,
        "status": "active"
    }


def parse_full_exam(text):
    """Parse full exam paper with B-code subject headers"""
    # Find subject sections
    subject_pattern = r'B\d+\.?\d*\s+(.+?)(?=\n)'

    sections = []
    matches = list(re.finditer(r'(B\d+\.?\d*)\s+(.+?)(?=\n)', text))

    for i, m in enumerate(matches):
        bcode = m.group(1)
        subject_name = m.group(2).strip()
        start = m.end()
        end = matches[i+1].start() if i+1 < len(matches) else len(text)
        section_text = text[start:end]
        sections.append((bcode, subject_name, section_text))

    return sections


# Map B-codes to subject DB names
# NOTE: B3=Nervous, B7=Cardiovascular (NL1 standard)
BCODE_TO_SUBJECT = {
    "B1.1": "biochemistry",
    "B1.2": "cell_biology",
    "B1.3": "genetics",
    "B2": "hemato_preclinic",
    "B3": "neuro_preclinic",
    "B4": "skin",
    "B5": "musculoskeletal",
    "B6": "respiratory",
    "B7": "cardiovascular",
    "B8": "gi_preclinic",
    "B9": "renal_preclinic",
    "B10": "reproductive",
    "B11": "endocrine_preclinic",
}

BCODE_NAME_TH = {
    "biochemistry": "ชีวเคมีและอณูชีววิทยา",
    "cell_biology": "ชีววิทยาของเซลล์",
    "genetics": "พัฒนาการมนุษย์และพันธุศาสตร์",
    "immunology": "วิทยาภูมิคุ้มกัน",
    "microbiology": "จุลชีววิทยา",
    "parasitology": "ปรสิตวิทยา",
    "pharmacology": "เภสัชวิทยาพื้นฐาน",
    "biostatistics": "ชีวสถิติและระเบียบวิธีวิจัย",
    "pathology": "พยาธิวิทยา",
    "multisystem": "กระบวนการหลายระบบ",
    "lab_principles": "หลักการตรวจทางห้องปฏิบัติการ",
    "hemato_preclinic": "ระบบเลือด (preclinic)",
    "cardiovascular": "ระบบหัวใจและหลอดเลือด (preclinic)",
    "skin": "ระบบผิวหนัง",
    "musculoskeletal": "ระบบกล้ามเนื้อและกระดูก",
    "respiratory": "ระบบทางเดินหายใจ (preclinic)",
    "neuro_preclinic": "ระบบประสาท (preclinic)",
    "gi_preclinic": "ระบบทางเดินอาหาร (preclinic)",
    "renal_preclinic": "ระบบไต (preclinic)",
    "reproductive": "ระบบสืบพันธุ์",
    "endocrine_preclinic": "ระบบต่อมไร้ท่อ (preclinic)",
}


def infer_subject_from_name(bcode, subject_name):
    """Infer subject from B-code + name text (handles year-to-year variations)"""
    name_lower = subject_name.lower()

    # Name-based matching (priority over B-code for B1.x since they vary)
    # Normalize spaces (PDF artifacts like "M ultisystem")
    name_lower = re.sub(r'\s+', ' ', name_lower).strip()

    name_map = [
        (['biochem', 'molecular bio'], 'biochemistry'),
        (['biology of cell', 'cell bio'], 'cell_biology'),
        (['genetic', 'development', 'human develop'], 'genetics'),
        (['immune', 'immuno'], 'immunology'),
        (['microbial', 'microbi', 'infection'], 'microbiology'),
        (['parasit'], 'parasitology'),
        (['pharmacodyn', 'pharmacokin', 'pharmacol', 'general pharm'], 'pharmacology'),
        (['quantitative', 'biostatist'], 'biostatistics'),
        (['specimen', 'laboratory', 'lab collect', 'princip'], 'lab_principles'),
        (['tissue response', 'patholog', 'pathogenesis', 'pathophysiol'], 'pathology'),
        (['gender', 'ethnic', 'behavioral', 'multisystem'], 'multisystem'),
        (['hema', 'lymph'], 'hemato_preclinic'),
        (['nervous', 'cns', 'neuro'], 'neuro_preclinic'),
        (['skin', 'derm', 'connective'], 'skin'),
        (['musculo', 'skeletal'], 'musculoskeletal'),
        (['respir', 'pulm'], 'respiratory'),
        (['cardio', 'heart', 'vascular'], 'cardiovascular'),
        (['gastrointestinal', 'gastro'], 'gi_preclinic'),
        (['renal', 'urinary', 'nephro'], 'renal_preclinic'),
        (['repro', 'reproductive'], 'reproductive'),
        (['endocrin'], 'endocrine_preclinic'),
    ]

    for keywords, subject in name_map:
        for kw in keywords:
            if kw in name_lower:
                return subject

    return None


def process_classified_files():
    """Process the 6 classified NL1 PDFs"""
    classified_dir = "/Users/apple/Desktop/📄 ข้อสอบ NL/NL 1/classificate"

    file_subject_map = {
        "NLE-Step1-B1.7-PrinciplesOfLabColl-Inter.pdf": "lab_principles",
        "NLE-Step1-B2-Hematology-SI124.pdf": "hemato_preclinic",
        "NLE-Step1-B4-Skin-RelatedCNT.pdf": "skin",
        "NLE-Step1-B6-RS-SI124.pdf": "respiratory",
        "NLE-Step1-B8-GI-SI124.pdf": "gi_preclinic",
        "NLE-Step1-B11-Endocrine-SI124.pdf": "endocrine_preclinic",
    }

    all_questions = {}

    for filename, subject in file_subject_map.items():
        filepath = os.path.join(classified_dir, filename)
        print(f"\n📄 Processing {filename}...")

        text = extract_text(filepath)
        text = clean_text(text)

        questions = parse_classified_pdf(text, subject)

        all_questions[subject] = questions
        print(f"   ✅ Parsed {len(questions)} questions for {subject}")

        # Save individual file
        outpath = os.path.join(OUTPUT_DIR, f"NL1_{subject}.json")
        with open(outpath, 'w', encoding='utf-8') as f:
            json.dump(questions, f, ensure_ascii=False, indent=2)

    return all_questions


def process_full_exam(pdf_path, year_label):
    """Process a full exam paper"""
    print(f"\n📄 Processing {year_label}...")

    text = extract_text(pdf_path)
    text = clean_text(text)

    # Find B-code sections
    sections = parse_full_exam(text)

    all_questions = {}

    for bcode, subject_name, section_text in sections:
        # Map to our subject names
        subject = None
        for code, subj in BCODE_TO_SUBJECT.items():
            if bcode.startswith(code):
                subject = subj
                break

        if not subject or (bcode.startswith('B1.') and len(bcode) > 4):
            # B1.10, B1.11 etc. wrongly match B1.1 - use name-based matching
            inferred = infer_subject_from_name(bcode, subject_name)
            if inferred:
                subject = inferred
            if not subject:
                print(f"   ⚠️  Skipping unknown: {bcode} {subject_name}")
                continue

        questions = parse_classified_pdf(section_text, subject)

        if subject not in all_questions:
            all_questions[subject] = []
        all_questions[subject].extend(questions)

        if questions:
            print(f"   {bcode} {subject_name}: {len(questions)} questions -> {subject}")

    return all_questions


def main():
    print("🚀 Parsing NL1 PDFs...\n")

    # 1. Process classified files (with detailed answers)
    print("=" * 60)
    print("📚 CLASSIFIED FILES (with explanations)")
    print("=" * 60)
    classified_qs = process_classified_files()

    # 2. Process full exam papers
    print("\n" + "=" * 60)
    print("📚 FULL EXAM PAPERS")
    print("=" * 60)

    exam_papers = [
        ("/Users/apple/Desktop/📄 ข้อสอบ NL/NL 1/NLE1 2018 complete v2.pdf", "NL1_2018"),
        ("/Users/apple/Desktop/📄 ข้อสอบ NL/NL 1/NL1 2017 SMST.pdf", "NL1_2017"),
        ("/Users/apple/Desktop/📄 ข้อสอบ NL/NL 1/2016.pdf", "NL1_2016"),
        ("/Users/apple/Desktop/📄 ข้อสอบ NL/NL 1/2014.pdf", "NL1_2014"),
    ]

    exam_qs = {}
    for pdf_path, label in exam_papers:
        if os.path.exists(pdf_path):
            qs = process_full_exam(pdf_path, label)
            for subj, questions in qs.items():
                if subj not in exam_qs:
                    exam_qs[subj] = []
                exam_qs[subj].extend(questions)

    # 3. Merge all questions
    print("\n" + "=" * 60)
    print("📊 SUMMARY")
    print("=" * 60)

    all_subjects = {}

    # Add classified questions first (they have better explanations)
    for subj, qs in classified_qs.items():
        if subj not in all_subjects:
            all_subjects[subj] = []
        all_subjects[subj].extend(qs)

    # Add exam questions
    for subj, qs in exam_qs.items():
        if subj not in all_subjects:
            all_subjects[subj] = []
        all_subjects[subj].extend(qs)

    total = 0
    for subj in sorted(all_subjects.keys()):
        qs = all_subjects[subj]
        # Re-number
        for i, q in enumerate(qs):
            q['question_number'] = i + 1

        count = len(qs)
        total += count
        name_th = BCODE_NAME_TH.get(subj, subj)
        print(f"   {subj}: {count} questions ({name_th})")

        # Save merged file
        outpath = os.path.join(OUTPUT_DIR, f"NL1_{subj}.json")
        with open(outpath, 'w', encoding='utf-8') as f:
            json.dump(qs, f, ensure_ascii=False, indent=2)

    print(f"\n   📊 Total: {total} questions across {len(all_subjects)} subjects")
    print(f"   💾 Saved to {OUTPUT_DIR}/")


if __name__ == "__main__":
    main()
