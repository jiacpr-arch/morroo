#!/usr/bin/env python3
"""
Extract NL (student) MCQ questions from text-based PDF files into a CSV that
the web admin importer (/admin/mcq/import) accepts.

This generalizes scripts/parse-nl1-pdfs.py (which had hardcoded Mac paths and
wrote JSON). The parsing heuristics — Thai PDF character fix-ups, question-block
splitting, choice extraction — are kept; only the I/O is parameterized.

The answer found in the PDF is written to the `correct` column as a DRAFT only.
Every row is emitted with status=review so the questions stay hidden from
learners until an admin verifies the key and writes the เฉลย in the admin UI.

Usage:
    python scripts/pdf-to-mcq-csv.py INPUT --subject surgery --exam-type NL2 \
        --exam-source "ศรว 2562" -o out.csv

    INPUT can be a single .pdf or a folder of .pdf files.

Requires: PyPDF2  (pip install PyPDF2)

CSV columns (must match lib/mcq-import.ts MCQ_CSV_HEADERS):
    subject, exam_type, exam_source, question_number, scenario,
    choice_a, choice_b, choice_c, choice_d, choice_e, correct, difficulty, status
"""

import argparse
import csv
import os
import re
import sys

try:
    import PyPDF2
except ImportError:
    sys.exit("PyPDF2 is required. Install with: pip install PyPDF2")


CSV_HEADERS = [
    "subject", "exam_type", "exam_source", "question_number", "scenario",
    "choice_a", "choice_b", "choice_c", "choice_d", "choice_e",
    "correct", "difficulty", "status",
]


def extract_text(pdf_path):
    reader = PyPDF2.PdfReader(open(pdf_path, "rb"))
    text = ""
    for p in reader.pages:
        t = p.extract_text()
        if t:
            text += t + "\n"
    return text


def clean_text(text):
    """Fix common Thai PDF extraction artifacts (same map as parse-nl1-pdfs.py)."""
    replacements = {
        "ÿ": "ส", "Ā": "ห", "š": "้", "ü": "ว", "Š": "่", "ś": "๊",
        "ŧ": "็", "Ť": "์", "ŗ": "", "Ũ": "็", "Ř": "์", "þ": "ษ", "Ŧ": "์",
    }
    for bad, good in replacements.items():
        text = text.replace(bad, good)
    return text


def parse_question_block(content, q_num):
    """Parse a single question block: scenario + choices + answer."""
    # Split at คำตอบ / คําตอบ / เฉลย
    answer_split = re.split(r"ค[ํา]าตอบ", content, maxsplit=1)
    if len(answer_split) < 2:
        answer_split = re.split(r"เฉลย", content, maxsplit=1)

    question_part = answer_split[0] if answer_split else content
    answer_part = answer_split[1] if len(answer_split) > 1 else ""

    # Extract choices (A-E)
    choices = {}
    choice_matches = re.findall(
        r"([A-E])\s*[\.\)]+\s*(.+?)(?=\s*[A-E]\s*[\.\)]+|$)",
        question_part, re.DOTALL,
    )
    if not choice_matches:
        for line in question_part.split("\n"):
            m = re.match(r"\s*([A-E])\s*[\.\)]+\s*(.+)", line.strip())
            if m:
                choices[m.group(1)] = m.group(2).strip()
    else:
        for label, text in choice_matches:
            choices[label] = text.strip().split("\n")[0].strip()

    if len(choices) < 2:
        return None

    # Scenario = everything before first choice
    scenario = question_part
    first_choice = re.search(r"\n\s*A\s*[\.\)]", question_part)
    if first_choice:
        scenario = question_part[: first_choice.start()]
    scenario = re.sub(r"\s+", " ", scenario).strip()
    if not scenario or len(scenario) < 5:
        return None

    # Draft correct answer from the PDF (NOT trusted — verified later in admin)
    correct = ""
    ans_match = re.search(r"ตอบข[้š]อ\s*([A-E])", answer_part)
    if not ans_match:
        ans_match = re.search(r"([A-E])\s*[\.\)]+", answer_part[:50])
    if ans_match:
        correct = ans_match.group(1)

    return {
        "question_number": q_num,
        "scenario": scenario,
        "choices": choices,
        "correct": correct,
    }


def parse_pdf(text):
    """Split text into question blocks by leading 'N.' numbering."""
    questions = []
    parts = re.split(r"(?:^|\n)\s*(\d+)\.\s", text)
    i = 1
    while i < len(parts) - 1:
        q_num = int(parts[i])
        q = parse_question_block(parts[i + 1], q_num)
        i += 2
        if q:
            questions.append(q)
    return questions


def collect_pdfs(input_path):
    if os.path.isdir(input_path):
        return sorted(
            os.path.join(input_path, f)
            for f in os.listdir(input_path)
            if f.lower().endswith(".pdf")
        )
    return [input_path]


def main():
    ap = argparse.ArgumentParser(description="Extract NL MCQ from PDF → import CSV")
    ap.add_argument("input", help="PDF file or folder of PDFs")
    ap.add_argument("--subject", required=True,
                    help="mcq_subjects.name slug, e.g. surgery, ob_gyn")
    ap.add_argument("--exam-type", required=True, choices=["NL1", "NL2"])
    ap.add_argument("--exam-source", default="",
                    help='e.g. "ศรว 2562" (used when the PDF has no inline source)')
    ap.add_argument("--difficulty", default="medium",
                    choices=["easy", "medium", "hard"])
    ap.add_argument("--status", default="review",
                    choices=["active", "review", "disabled"],
                    help="default review — keeps questions hidden until verified")
    ap.add_argument("-o", "--output", default="mcq-import.csv")
    args = ap.parse_args()

    pdfs = collect_pdfs(args.input)
    if not pdfs:
        sys.exit(f"No PDF files found at {args.input}")

    rows = []
    qnum = 0
    for pdf in pdfs:
        print(f"📄 {os.path.basename(pdf)}")
        text = clean_text(extract_text(pdf))
        parsed = parse_pdf(text)
        print(f"   parsed {len(parsed)} questions")
        for q in parsed:
            qnum += 1
            ch = q["choices"]
            rows.append({
                "subject": args.subject,
                "exam_type": args.exam_type,
                "exam_source": args.exam_source,
                "question_number": qnum,
                "scenario": q["scenario"],
                "choice_a": ch.get("A", ""),
                "choice_b": ch.get("B", ""),
                "choice_c": ch.get("C", ""),
                "choice_d": ch.get("D", ""),
                "choice_e": ch.get("E", ""),
                "correct": q["correct"],
                "difficulty": args.difficulty,
                "status": args.status,
            })

    with open(args.output, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=CSV_HEADERS)
        writer.writeheader()
        writer.writerows(rows)

    incomplete = sum(1 for r in rows if not all(
        r[k] for k in ("choice_a", "choice_b", "choice_c", "choice_d", "choice_e")))
    no_answer = sum(1 for r in rows if not r["correct"])
    print(f"\n✅ wrote {len(rows)} rows → {args.output}")
    if incomplete:
        print(f"   ⚠️  {incomplete} rows missing one or more of choices A–E "
              f"(importer will flag these — fix by hand or in the CSV)")
    if no_answer:
        print(f"   ⚠️  {no_answer} rows had no detectable answer — fill `correct` "
              f"(A–E) before importing, or set it during review")
    print("\nNext: open /admin/mcq/import, upload the CSV, preview, then import "
          "(rows land as status=review → เฉลยในหน้า admin → กด Active)")


if __name__ == "__main__":
    main()
