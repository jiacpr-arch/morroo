#!/usr/bin/env python3
"""
AI-powered NL (student) MCQ extractor: turn a text-based PDF exam paper into a
clean import CSV by letting Claude do the structuring (far more robust than
regex for compiled papers with mixed Thai/English, per-section numbering, and
missing answer keys).

Pipeline per PDF:
  1. extract text (PyPDF2) + fix Thai PDF artifacts
  2. split into overlapping chunks
  3. ask Claude to return structured MCQs per chunk, choosing a subject slug
     from the allowed list for the exam type
  4. dedupe across chunk overlaps, write the import CSV

Requires:
  pip3 install PyPDF2
  export ANTHROPIC_API_KEY=sk-ant-...    # your key, used locally

Usage:
  export ANTHROPIC_API_KEY=sk-ant-...
  python3 pdf-to-mcq-ai.py "NL2/2024/NL2 2024 Unofficial.pdf" \
      --exam-type NL2 --exam-source "NL2 2024" -o nl2_2024.csv

  # whole folder of years:
  python3 pdf-to-mcq-ai.py NL2 --exam-type NL2 -o nl2_all.csv

CSV columns match lib/mcq-import.ts MCQ_CSV_HEADERS.
"""

import argparse
import csv
import json
import os
import re
import sys
import time
import urllib.request
import urllib.error

try:
    import PyPDF2
except ImportError:
    sys.exit("PyPDF2 is required. Install with: pip3 install PyPDF2")

CSV_HEADERS = [
    "subject", "exam_type", "exam_source", "question_number", "scenario",
    "choice_a", "choice_b", "choice_c", "choice_d", "choice_e",
    "correct", "difficulty", "status",
]

# Allowed subject slugs per exam type (slug, Thai name). These are the BROAD
# subjects the compiled papers are organised by. Slugs must exist in
# mcq_subjects before import — run the companion SQL (nl_broad_subjects.sql) to
# create any that are missing. Claude is told to pick the best-fitting slug.
ALLOWED = {
    "NL2": [
        ("internal_med", "อายุรศาสตร์ (รวม)"),
        ("surgery", "ศัลยศาสตร์"),
        ("ped", "กุมารเวชศาสตร์"),
        ("ob_gyn", "สูติศาสตร์-นรีเวชวิทยา"),
        ("ortho", "ออร์โธปิดิกส์"),
        ("psychi", "จิตเวชศาสตร์"),
        ("ent", "โสต ศอ นาสิก (ENT)"),
        ("eye", "จักษุวิทยา"),
        ("forensic", "นิติเวชศาสตร์"),
        ("epidemio", "เวชศาสตร์ชุมชน/ระบาดวิทยา"),
        ("emergency", "เวชศาสตร์ฉุกเฉิน"),
        ("radiology", "รังสีวิทยา"),
        ("anesthesia", "วิสัญญีวิทยา"),
        ("rehab", "เวชศาสตร์ฟื้นฟู"),
        ("derm", "ตจวิทยา (ผิวหนัง)"),
        ("family_med", "เวชศาสตร์ครอบครัว"),
    ],
    "NL1": [
        ("biochemistry", "ชีวเคมี/อณูชีววิทยา"),
        ("cell_biology", "ชีววิทยาของเซลล์"),
        ("genetics", "พันธุศาสตร์/พัฒนาการ"),
        ("immunology", "วิทยาภูมิคุ้มกัน"),
        ("microbiology", "จุลชีววิทยา"),
        ("parasitology", "ปรสิตวิทยา"),
        ("pharmacology", "เภสัชวิทยาพื้นฐาน"),
        ("biostatistics", "ชีวสถิติ/ระเบียบวิธีวิจัย"),
        ("pathology", "พยาธิวิทยา"),
        ("lab_principles", "หลักการตรวจทางห้องปฏิบัติการ"),
        ("hemato_preclinic", "ระบบเลือด (preclinic)"),
        ("cardiovascular", "ระบบหัวใจและหลอดเลือด (preclinic)"),
        ("respiratory", "ระบบทางเดินหายใจ (preclinic)"),
        ("gi_preclinic", "ระบบทางเดินอาหาร (preclinic)"),
        ("renal_preclinic", "ระบบไต (preclinic)"),
        ("neuro_preclinic", "ระบบประสาท (preclinic)"),
        ("endocrine_preclinic", "ระบบต่อมไร้ท่อ (preclinic)"),
        ("reproductive", "ระบบสืบพันธุ์"),
        ("musculoskeletal", "ระบบกล้ามเนื้อและกระดูก"),
        ("skin", "ระบบผิวหนัง"),
        ("multisystem", "กระบวนการหลายระบบ"),
    ],
}

API_URL = "https://api.anthropic.com/v1/messages"


def extract_text(pdf_path):
    reader = PyPDF2.PdfReader(open(pdf_path, "rb"))
    return "\n".join((p.extract_text() or "") for p in reader.pages)


def clean_text(text):
    repl = {
        "ÿ": "ส", "Ā": "ห", "š": "้", "ü": "ว", "Š": "่", "ś": "๊",
        "ŧ": "็", "Ť": "์", "ŗ": "", "Ũ": "็", "Ř": "์", "þ": "ษ", "Ŧ": "์",
    }
    for bad, good in repl.items():
        text = text.replace(bad, good)
    return text


def chunk_text(text, size=9000, overlap=600):
    """Split into ~size-char chunks with overlap so boundary questions aren't lost."""
    chunks = []
    i = 0
    n = len(text)
    while i < n:
        chunks.append(text[i:i + size])
        if i + size >= n:
            break
        i += size - overlap
    return chunks


def build_prompt(chunk, exam_type):
    subjects = "\n".join(f'  - {slug}: {th}' for slug, th in ALLOWED[exam_type])
    return f"""คุณคือผู้ช่วยจัดรูปแบบข้อสอบแพทย์ (National License Exam {exam_type})
ด้านล่างเป็นข้อความดิบที่ดึงจาก PDF ข้อสอบ (อาจมีอักขระเพี้ยน ไทย/อังกฤษปนกัน
เลขข้อรีเซ็ตตามสาขา และอาจไม่มีเฉลย)

งานของคุณ: ดึง "ข้อสอบ MCQ" ออกมาเป็น JSON เท่านั้น
กฎ:
1. แต่ละข้อต้องมี scenario (โจทย์) และตัวเลือกอย่างน้อย 2 ตัว
2. เก็บข้อความตามต้นฉบับ (ไทย/อังกฤษ) ไม่ต้องแปล ไม่ต้องแก้เนื้อหา
3. ตัวเลือกใช้ label A,B,C,D,E (ถ้าต้นฉบับเป็น ก/ข/ค/ง/จ ให้แปลงเป็น A-E ตามลำดับ)
4. ถ้ามีเฉลย ใส่ "correct" เป็น label (A-E); ถ้าไม่มี ใส่ null
5. ระบุ "subject" โดยเลือก slug ที่เหมาะที่สุดจากรายการนี้:
{subjects}
   (อิงจากหัวข้อสาขาในข้อความ เช่น "Internal medicine"→internal_med, "Surgery"→surgery)
6. ข้อที่ถูกตัดครึ่ง/ไม่สมบูรณ์ที่ขอบ chunk ให้ "ข้าม" ไป อย่าเดาต่อ
7. อย่าใส่ข้อความอธิบายใดๆ นอก JSON

ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown:
[
  {{"subject":"internal_med","scenario":"...","choices":[{{"label":"A","text":"..."}},{{"label":"B","text":"..."}}],"correct":"A"}}
]

ข้อความดิบ:
\"\"\"
{chunk}
\"\"\""""


def call_claude(api_key, model, prompt, max_tokens=8000, retries=2):
    body = json.dumps({
        "model": model,
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}],
    }).encode("utf-8")
    req = urllib.request.Request(API_URL, data=body, method="POST", headers={
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
    })
    last_err = None
    for attempt in range(retries + 1):
        try:
            with urllib.request.urlopen(req, timeout=120) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            raw = (data.get("content") or [{}])[0].get("text", "")
            return parse_questions(raw)
        except urllib.error.HTTPError as e:
            last_err = f"HTTP {e.code}: {e.read().decode('utf-8', 'ignore')[:200]}"
            if e.code in (429, 500, 502, 503, 529) and attempt < retries:
                time.sleep(2 * (attempt + 1))
                continue
            break
        except Exception as e:  # noqa: BLE001
            last_err = str(e)
            if attempt < retries:
                time.sleep(2 * (attempt + 1))
                continue
            break
    print(f"   ⚠️  Claude call failed: {last_err}")
    return []


def parse_questions(raw):
    s = raw.strip()
    if s.startswith("```"):
        s = re.sub(r"^```\w*\n?", "", s).replace("\n```", "").rstrip("`").strip()
    try:
        v = json.loads(s)
        return v if isinstance(v, list) else []
    except json.JSONDecodeError:
        pass
    # lenient: salvage complete {...} objects
    out = []
    depth = 0
    start = None
    instr = False
    esc = False
    for i, c in enumerate(s):
        if instr:
            if esc:
                esc = False
            elif c == "\\":
                esc = True
            elif c == '"':
                instr = False
            continue
        if c == '"':
            instr = True
        elif c == "{":
            if depth == 0:
                start = i
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0 and start is not None:
                try:
                    out.append(json.loads(s[start:i + 1]))
                except json.JSONDecodeError:
                    pass
                start = None
    return out


def norm_key(scenario):
    return re.sub(r"\s+", " ", scenario or "").strip().lower()[:80]


def main():
    ap = argparse.ArgumentParser(description="AI PDF→MCQ extractor (Claude)")
    ap.add_argument("input", help="PDF file or folder of PDFs")
    ap.add_argument("--exam-type", required=True, choices=["NL1", "NL2"])
    ap.add_argument("--exam-source", default="", help='e.g. "NL2 2024"')
    ap.add_argument("--model", default="claude-haiku-4-5-20251001",
                    help="Claude model (default Haiku 4.5 — cheap+good for extraction)")
    ap.add_argument("--difficulty", default="medium", choices=["easy", "medium", "hard"])
    ap.add_argument("--status", default="review", choices=["active", "review", "disabled"])
    ap.add_argument("-o", "--output", default="mcq-ai-import.csv")
    args = ap.parse_args()

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        sys.exit("Set your key first:  export ANTHROPIC_API_KEY=sk-ant-...")

    if os.path.isdir(args.input):
        pdfs = []
        for dp, _d, fs in os.walk(args.input):
            pdfs += [os.path.join(dp, f) for f in sorted(fs) if f.lower().endswith(".pdf")]
    else:
        pdfs = [args.input]
    if not pdfs:
        sys.exit(f"No PDF files found at {args.input}")

    valid_slugs = {slug for slug, _ in ALLOWED[args.exam_type]}
    rows = []
    seen = set()
    by_subject = {}
    qnum = 0

    for pdf in pdfs:
        src = args.exam_source or os.path.splitext(os.path.basename(pdf))[0]
        text = clean_text(extract_text(pdf))
        chunks = chunk_text(text)
        print(f"📄 {os.path.basename(pdf)} — {len(text)} chars, {len(chunks)} chunks")
        file_count = 0
        for ci, chunk in enumerate(chunks, 1):
            qs = call_claude(api_key, args.model, build_prompt(chunk, args.exam_type))
            added = 0
            for q in qs:
                scenario = (q.get("scenario") or "").strip()
                choices = q.get("choices") or []
                if len(scenario) < 5 or len(choices) < 2:
                    continue
                key = norm_key(scenario)
                if key in seen:
                    continue
                seen.add(key)
                cmap = {}
                for c in choices:
                    lab = str(c.get("label", "")).strip().upper()
                    if lab in "ABCDE":
                        cmap[lab] = (c.get("text") or "").strip()
                if len(cmap) < 2:
                    continue
                subj = (q.get("subject") or "").strip()
                if subj not in valid_slugs:
                    subj = subj or ""  # keep; import preview will flag unknowns
                correct = (q.get("correct") or "").strip().upper()
                if correct not in "ABCDE":
                    correct = "A"  # placeholder; verify during review
                qnum += 1
                added += 1
                by_subject[subj or "(unknown)"] = by_subject.get(subj or "(unknown)", 0) + 1
                rows.append({
                    "subject": subj,
                    "exam_type": args.exam_type,
                    "exam_source": src,
                    "question_number": qnum,
                    "scenario": scenario,
                    "choice_a": cmap.get("A", ""),
                    "choice_b": cmap.get("B", ""),
                    "choice_c": cmap.get("C", ""),
                    "choice_d": cmap.get("D", ""),
                    "choice_e": cmap.get("E", ""),
                    "correct": correct,
                    "difficulty": args.difficulty,
                    "status": args.status,
                })
            file_count += added
            print(f"   chunk {ci}/{len(chunks)}: +{added} (file total {file_count})")
        print(f"   ✅ {file_count} questions from this file")

    with open(args.output, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=CSV_HEADERS)
        w.writeheader()
        w.writerows(rows)

    print(f"\n✅ wrote {len(rows)} rows → {args.output}")
    print("\n📊 questions per subject (slug):")
    for slug, n in sorted(by_subject.items(), key=lambda x: -x[1]):
        print(f"   {slug}: {n}")
    print("\nNext: create any missing subject slugs (see nl_broad_subjects.sql),")
    print("then /admin/mcq → Bulk import (NL) → upload CSV → preview → import")


if __name__ == "__main__":
    main()
