#!/usr/bin/env python3
"""
Extract NL (student) MCQ questions from text-based PDF exam papers into a CSV
that the web admin importer (/admin/mcq/import) accepts.

v2 — handles real-world "compiled exam" PDFs where one file holds the whole
paper, split into broad subject SECTIONS ("Internal medicine", "Surgery", ...)
with question numbers that reset per section, choices labelled A–E or Thai
ก–จ, and (often) NO answer key. Subject is detected from the section header and
applied per question; questions without a detected answer get a placeholder so
they still import as status=review for the admin to verify + write เฉลย.

Usage:
    python3 pdf-to-mcq-csv.py INPUT --exam-type NL2 --exam-source "NL2 2024" -o out.csv
        INPUT = a .pdf file or a folder of .pdf files
    Optional:
        --subject SLUG   fallback subject when no section header is detected
        --status         active|review|disabled (default review)

Requires: PyPDF2  (pip3 install PyPDF2)

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
    sys.exit("PyPDF2 is required. Install with: pip3 install PyPDF2")


CSV_HEADERS = [
    "subject", "exam_type", "exam_source", "question_number", "scenario",
    "choice_a", "choice_b", "choice_c", "choice_d", "choice_e",
    "correct", "difficulty", "status",
]

# Thai choice labels → A–E
THAI_LABEL = {"ก": "A", "ข": "B", "ค": "C", "ง": "D", "จ": "E"}

# Section header (broad subject) detection. Ordered: first match wins.
# slug must match a row in mcq_subjects (audience='student'). New broad subjects
# (internal_med, emergency, radiology, anesthesia, rehab, derm, family) may need
# creating in the DB — the run summary lists which slugs were used.
SECTION_PATTERNS = [
    (r"internal\s*medicine|\bmedicine\b(?!\s*certificate)", "internal_med"),
    (r"orthop(a)?edic", "ortho"),
    (r"p(a)?ediatric|\bpeds?\b", "ped"),
    (r"obstetric|gyn(a)?ecolog|\bob[\s\-/]*gyn\b|\bob\s*&\s*gyn\b", "ob_gyn"),
    (r"psychiatr", "psychi"),
    (r"ophthalmolog|\beye\b", "eye"),
    (r"otolaryngolog|\bent\b|ear[\s,]+nose", "ent"),
    (r"forensic|legal\s*medicine", "forensic"),
    (r"community|preventive|epidemiolog|public\s*health|family\s*medicine", "epidemio"),
    (r"emergency", "emergency"),
    (r"radiolog", "radiology"),
    (r"an(a)?esthe", "anesthesia"),
    (r"rehabilitat|physical\s*medicine", "rehab"),
    (r"dermatolog", "derm"),
    (r"\bsurgery\b|surgical", "surgery"),
]

# A line is treated as a section header only if it is short + (mostly) latin —
# this prevents subject words inside a question body from flipping the section.
HEADER_LINE = re.compile(r"^[A-Za-z][A-Za-z0-9 &/().,\-]{2,40}$")

NUM_RE = re.compile(r"^\s*(\d{1,3})\s*[.)]\s*(.*)")
CHOICE_RE = re.compile(r"^\s*([A-Ea-eก-จ])\s*[.)]\s*(.*)")
ANSWER_RE = re.compile(r"(?:ตอบข้อ|ตอบ|เฉลย|answer|ans)\s*[:.]?\s*([A-Ea-eก-จ])\b", re.IGNORECASE)


def extract_text(pdf_path):
    reader = PyPDF2.PdfReader(open(pdf_path, "rb"))
    out = []
    for p in reader.pages:
        t = p.extract_text()
        if t:
            out.append(t)
    return "\n".join(out)


def clean_text(text):
    """Fix common Thai PDF extraction artifacts (same map as parse-nl1-pdfs.py)."""
    repl = {
        "ÿ": "ส", "Ā": "ห", "š": "้", "ü": "ว", "Š": "่", "ś": "๊",
        "ŧ": "็", "Ť": "์", "ŗ": "", "Ũ": "็", "Ř": "์", "þ": "ษ", "Ŧ": "์",
    }
    for bad, good in repl.items():
        text = text.replace(bad, good)
    return text


def detect_section(line):
    """Return a subject slug if the line looks like a section header, else None."""
    s = line.strip()
    if not HEADER_LINE.match(s):
        return None
    low = s.lower()
    for pat, slug in SECTION_PATTERNS:
        if re.search(pat, low):
            return slug
    return None


def norm_label(raw):
    raw = raw.strip()
    return THAI_LABEL.get(raw, raw.upper())


def finalize(q):
    """Clean a question dict; return it only if it has a scenario + >=2 choices."""
    if not q:
        return None
    q["scenario"] = re.sub(r"\s+", " ", q["scenario"]).strip()
    if len(q["scenario"]) < 5 or len(q["choices"]) < 2:
        return None
    return q


def parse_text(text, default_subject):
    """Line-based parse that tracks the current section subject."""
    questions = []
    current = None
    subject = default_subject

    for raw_line in text.split("\n"):
        line = raw_line.rstrip()
        if not line.strip():
            continue

        sec = detect_section(line)
        if sec:
            subject = sec
            continue

        # Answer line (rare in compiled papers, common in answer keys)
        am = ANSWER_RE.search(line)
        if am and current and current["choices"]:
            current["correct"] = norm_label(am.group(1))
            continue

        cm = CHOICE_RE.match(line)
        if cm and current:
            label = norm_label(cm.group(1))
            txt = cm.group(2).strip()
            if label in "ABCDE" and txt:
                current["choices"][label] = txt
            continue

        nm = NUM_RE.match(line)
        if nm:
            done = finalize(current)
            if done:
                questions.append(done)
            current = {
                "subject": subject,
                "scenario": nm.group(2).strip(),
                "choices": {},
                "correct": "",
            }
            continue

        # Continuation of the scenario (only before choices start)
        if current and not current["choices"]:
            current["scenario"] += " " + line.strip()

    done = finalize(current)
    if done:
        questions.append(done)
    return questions


def collect_pdfs(input_path):
    if os.path.isdir(input_path):
        out = []
        for dirpath, _dirs, files in os.walk(input_path):
            for f in sorted(files):
                if f.lower().endswith(".pdf"):
                    out.append(os.path.join(dirpath, f))
        return out
    return [input_path]


def main():
    ap = argparse.ArgumentParser(description="Extract NL MCQ from PDF → import CSV")
    ap.add_argument("input", help="PDF file or folder of PDFs")
    ap.add_argument("--exam-type", required=True, choices=["NL1", "NL2"])
    ap.add_argument("--exam-source", default="",
                    help='e.g. "NL2 2024" — written to every row')
    ap.add_argument("--subject", default="",
                    help="fallback subject slug when no section header is detected")
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
    by_subject = {}
    for pdf in pdfs:
        text = clean_text(extract_text(pdf))
        parsed = parse_text(text, args.subject)
        print(f"📄 {os.path.basename(pdf)}: {len(parsed)} questions")
        for q in parsed:
            qnum += 1
            ch = q["choices"]
            subj = q["subject"] or args.subject
            by_subject[subj] = by_subject.get(subj, 0) + 1
            rows.append({
                "subject": subj,
                "exam_type": args.exam_type,
                "exam_source": args.exam_source,
                "question_number": qnum,
                "scenario": q["scenario"],
                "choice_a": ch.get("A", ""),
                "choice_b": ch.get("B", ""),
                "choice_c": ch.get("C", ""),
                "choice_d": ch.get("D", ""),
                "choice_e": ch.get("E", ""),
                # No answer in source → placeholder "A"; admin sets the real one
                # during review (status=review keeps these hidden meanwhile).
                "correct": q["correct"] or "A",
                "difficulty": args.difficulty,
                "status": args.status,
            })

    with open(args.output, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=CSV_HEADERS)
        writer.writeheader()
        writer.writerows(rows)

    incomplete = sum(1 for r in rows if not all(
        r[k] for k in ("choice_a", "choice_b", "choice_c", "choice_d", "choice_e")))
    no_answer = sum(1 for r in rows if not r["correct"] or r["correct"] == "A")
    no_subject = sum(1 for r in rows if not r["subject"])

    print(f"\n✅ wrote {len(rows)} rows → {args.output}")
    print("\n📊 questions per subject (slug):")
    for slug, n in sorted(by_subject.items(), key=lambda x: -x[1]):
        print(f"   {slug or '(no section detected)'}: {n}")
    if no_subject:
        print(f"\n   ⚠️  {no_subject} rows have NO subject — pass --subject as a "
              f"fallback, or these will be flagged in the import preview")
    if incomplete:
        print(f"   ⚠️  {incomplete} rows missing one or more of choices A–E "
              f"(import preview will flag these → fix by hand)")
    print(f"   ℹ️  answers were not in this source — every row defaults to 'A'; "
          f"set the real answer + write เฉลย in /admin/mcq during review")
    print("\nNext: /admin/mcq → Bulk import (NL) → upload CSV → preview → import")


if __name__ == "__main__":
    main()
