#!/usr/bin/env python3
"""
Import MCQ questions using AI (Claude) to parse and enhance
- Parse raw text from .docx into structured MCQ
- Fix incomplete questions
- Add choices where missing (up to 5)
- Add explanations
- Identify correct answers
"""

import os
import re
import json
import time
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

# ============================================
# Config
# ============================================

EXAM_FOLDERS = [
    "/Users/apple/Desktop/📄 ข้อสอบ NL/drive-download-20260326T042724Z-1-001/แบบไฟล์ doc",
]

OUTPUT_DIR = "/Users/apple/Desktop/morroo/scripts/mcq-output-ai"

SUBJECT_MAP = {
    "Cardio med": ("cardio_med", "อายุรศาสตร์หัวใจ"),
    "Chest med": ("chest_med", "อายุรศาสตร์ทรวงอก"),
    "ENT": ("ent", "โสต ศอ นาสิก"),
    "Endocrine": ("endocrine", "ต่อมไร้ท่อ"),
    "Forensic": ("forensic", "นิติเวชศาสตร์"),
    "GYN": ("ob_gyn", "สูติศาสตร์-นรีเวชวิทยา"),
    "HEMATO": ("hemato_med", "โลหิตวิทยา"),
    "INFECTIOUS": ("infectious_med", "โรคติดเชื้อ"),
    "OB": ("ob_gyn", "สูติศาสตร์-นรีเวชวิทยา"),
    "ORTHO": ("ortho", "ออร์โธปิดิกส์"),
    "Ped": ("ped", "กุมารเวชศาสตร์"),
    "Psychi": ("psychi", "จิตเวชศาสตร์"),
    "Surgery": ("surgery", "ศัลยศาสตร์"),
    "epidemio": ("epidemio", "ระบาดวิทยา"),
    "gi med": ("gi_med", "อายุรศาสตร์ทางเดินอาหาร"),
    "nephro": ("nephro_med", "อายุรศาสตร์ไต"),
    "neuro med1": ("neuro_med", "ประสาทวิทยา"),
    "neuro med1_2": ("neuro_med", "ประสาทวิทยา"),
}

# Load API key from .env.local
def load_api_key():
    env_path = "/Users/apple/Desktop/morroo/.env.local"
    with open(env_path) as f:
        for line in f:
            if line.startswith("ANTHROPIC_API_KEY="):
                return line.split("=", 1)[1].strip()
    raise ValueError("ANTHROPIC_API_KEY not found in .env.local")

API_KEY = load_api_key()


def extract_text_from_docx(filepath):
    """Extract all text from .docx"""
    try:
        with zipfile.ZipFile(filepath) as z:
            tree = ET.parse(z.open('word/document.xml'))
        ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
        lines = []
        for p in tree.findall('.//w:p', ns):
            t = ''.join(r.text or '' for r in p.findall('.//w:t', ns))
            if t.strip():
                lines.append(t.strip())
        return '\n'.join(lines)
    except Exception as e:
        print(f"  ❌ Error reading {filepath}: {e}")
        return ""


def call_claude(prompt, max_tokens=8000):
    """Call Claude API"""
    import urllib.request
    import urllib.error

    data = json.dumps({
        "model": "claude-haiku-4-5-20251001",
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}]
    }).encode()

    req = urllib.request.Request(
        "https://api.anthropic.com/v1/messages",
        data=data,
        headers={
            "Content-Type": "application/json",
            "x-api-key": API_KEY,
            "anthropic-version": "2023-06-01",
        }
    )

    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            result = json.loads(resp.read())
            return result['content'][0]['text']
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"  ❌ API Error {e.code}: {body[:200]}")
        return None
    except Exception as e:
        print(f"  ❌ API Error: {e}")
        return None


def parse_with_ai(raw_text, subject_name, filename, chunk_idx=0):
    """Use Claude to parse raw exam text into structured MCQ"""

    prompt = f"""คุณเป็นผู้เชี่ยวชาญด้านข้อสอบแพทย์ไทย (National License Exam)
ข้อมูลด้านล่างเป็นข้อสอบ MCQ สาขา {subject_name} จากไฟล์ {filename}

กรุณา parse ข้อสอบให้เป็น JSON array โดยแต่ละข้อมี format:

{{
  "scenario": "โจทย์ (รวม stem + scenario ทั้งหมด)",
  "choices": [{{"label": "A", "text": "..."}}, {{"label": "B", "text": "..."}}, ...],
  "correct_answer": "A/B/C/D/E",
  "exam_source": "แหล่งที่มา เช่น ศรว 2010, NLE 2015",
  "status": "complete/incomplete/needs_review",
  "ai_notes": "หมายเหตุ (ถ้ามี)"
}}

กฎ:
1. ถ้าข้อไหนมีตัวเลือกน้อยกว่า 5 ข้อ ให้เพิ่มตัวเลือกที่สมเหตุสมผลทางการแพทย์ให้ครบ 5 ข้อ (ระบุใน ai_notes ว่าเพิ่มตัวเลือกไหน)
2. ถ้าไม่มีเฉลย ให้วิเคราะห์และระบุคำตอบที่ถูกต้องที่สุด พร้อมเหตุผลใน ai_notes
3. ถ้าโจทย์ไม่สมบูรณ์ (ตัดกลางประโยค) ให้เติมให้สมบูรณ์ตามบริบททางการแพทย์
4. ถ้าข้อไหนเสียหายมากจนแก้ไม่ได้ ให้ status = "incomplete"
5. ตัวเลือกที่เพิ่มต้องเป็น plausible distractor ไม่ใช่คำตอบมั่วๆ
6. ข้อที่เป็นภาษาอังกฤษให้คงเป็นภาษาอังกฤษ ข้อที่เป็นภาษาไทยให้คงเป็นภาษาไทย

ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown code block:

--- RAW TEXT ---
{raw_text}
--- END ---"""

    result = call_claude(prompt, max_tokens=8000)
    if not result:
        return []

    # Parse JSON from response
    try:
        # Try to extract JSON array
        result = result.strip()
        if result.startswith('```'):
            result = re.sub(r'^```\w*\n?', '', result)
            result = re.sub(r'\n?```$', '', result)
        questions = json.loads(result)
        if isinstance(questions, list):
            return questions
    except json.JSONDecodeError:
        # Try to find JSON array in response
        match = re.search(r'\[[\s\S]*\]', result)
        if match:
            try:
                return json.loads(match.group())
            except:
                pass
        print(f"  ⚠️ Could not parse AI response as JSON")
        # Save raw response for debugging
        debug_path = os.path.join(OUTPUT_DIR, f"_debug_{filename}_{chunk_idx}.txt")
        with open(debug_path, 'w') as f:
            f.write(result)
    return []


def chunk_text(text, max_chars=6000):
    """Split text into chunks at question boundaries"""
    lines = text.split('\n')
    chunks = []
    current = []
    current_len = 0

    for line in lines:
        if current_len + len(line) > max_chars and current:
            chunks.append('\n'.join(current))
            current = []
            current_len = 0
        current.append(line)
        current_len += len(line) + 1

    if current:
        chunks.append('\n'.join(current))

    return chunks


def process_file(filepath, filename, subject_id, subject_name):
    """Process a single .docx file"""
    print(f"\n📄 {filename} → {subject_name}")

    raw_text = extract_text_from_docx(filepath)
    if not raw_text:
        return []

    print(f"   Raw text: {len(raw_text)} chars")

    # Split into chunks for AI
    chunks = chunk_text(raw_text, max_chars=6000)
    print(f"   Chunks: {len(chunks)}")

    all_questions = []
    for i, chunk in enumerate(chunks):
        print(f"   Processing chunk {i+1}/{len(chunks)}...", end=" ", flush=True)
        questions = parse_with_ai(chunk, subject_name, filename, i)
        print(f"→ {len(questions)} questions")
        for q in questions:
            q['subject'] = subject_id
            q['exam_type'] = 'NL2'
        all_questions.extend(questions)
        if i < len(chunks) - 1:
            time.sleep(1)  # Rate limiting

    return all_questions


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    grand_total = 0
    grand_complete = 0
    grand_incomplete = 0

    for folder in EXAM_FOLDERS:
        docx_files = sorted(Path(folder).glob("*.docx"))
        print(f"\n{'='*60}")
        print(f"📁 Processing {len(docx_files)} files from:")
        print(f"   {folder}")
        print(f"{'='*60}")

        for filepath in docx_files:
            filename = filepath.stem
            if filename not in SUBJECT_MAP:
                print(f"\n⚠️ Skipping {filename} (not in SUBJECT_MAP)")
                continue

            subject_id, subject_name = SUBJECT_MAP[filename]

            questions = process_file(str(filepath), filename, subject_id, subject_name)

            # Stats
            complete = sum(1 for q in questions if q.get('status') != 'incomplete')
            incomplete = sum(1 for q in questions if q.get('status') == 'incomplete')

            print(f"   ✅ Complete: {complete} | ⚠️ Incomplete: {incomplete} | Total: {len(questions)}")

            grand_total += len(questions)
            grand_complete += complete
            grand_incomplete += incomplete

            # Save
            output_file = os.path.join(OUTPUT_DIR, f"{subject_id}.json")

            # If file exists (e.g. OB + GYN both map to ob_gyn), merge
            existing = []
            if os.path.exists(output_file):
                with open(output_file, 'r') as f:
                    existing = json.load(f)

            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(existing + questions, f, ensure_ascii=False, indent=2)

    # Summary
    summary = {
        'total_questions': grand_total,
        'complete': grand_complete,
        'incomplete': grand_incomplete,
    }

    with open(os.path.join(OUTPUT_DIR, '_summary.json'), 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)

    print(f"\n{'='*60}")
    print(f"📊 FINAL SUMMARY")
    print(f"{'='*60}")
    print(f"Total questions: {grand_total}")
    print(f"✅ Complete: {grand_complete}")
    print(f"⚠️ Incomplete: {grand_incomplete}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"\nNext step: Review JSON files, then run seed-mcq.js to insert into Supabase")


if __name__ == '__main__':
    main()
