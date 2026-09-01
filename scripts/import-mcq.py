#!/usr/bin/env python3
"""
Import MCQ questions from .docx files
1. Parse all .docx files from NL exam folders
2. Use AI (Claude) to clean up, fix, and enhance questions
3. Export to JSON for review before inserting into Supabase
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

OUTPUT_DIR = "/Users/apple/Desktop/morroo/scripts/mcq-output"

# Map filename to subject
SUBJECT_MAP = {
    "Cardio med": "cardio_med",
    "Chest med": "chest_med",
    "ENT": "ent",
    "Endocrine": "endocrine",
    "Forensic": "forensic",
    "GYN": "ob_gyn",
    "HEMATO": "hemato_med",
    "INFECTIOUS": "infectious_med",
    "OB": "ob_gyn",
    "ORTHO": "ortho",
    "Ped": "ped",
    "Psychi": "psychi",
    "Surgery": "surgery",
    "epidemio": "epidemio",
    "gi med": "gi_med",
    "nephro": "nephro_med",
    "neuro med1": "neuro_med",
    "neuro med1_2": "neuro_med",
}


def extract_text_from_docx(filepath):
    """Extract all text paragraphs from a .docx file"""
    try:
        with zipfile.ZipFile(filepath) as z:
            tree = ET.parse(z.open('word/document.xml'))
        ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
        lines = []
        for p in tree.findall('.//w:p', ns):
            t = ''.join(r.text or '' for r in p.findall('.//w:t', ns))
            if t.strip():
                lines.append(t.strip())
        return lines
    except Exception as e:
        print(f"  ❌ Error reading {filepath}: {e}")
        return []


def parse_questions_from_lines(lines, filename):
    """Parse MCQ questions from text lines"""
    questions = []
    current_q = None
    current_source = filename

    # Detect source headers like "ศรว 2010", "NLE 2015"
    source_pattern = re.compile(r'^(ศรว|NLE|NL)\s*\d{4}', re.IGNORECASE)
    choice_pattern = re.compile(r'^([A-Ea-e])[.\)]\s*(.*)')
    number_pattern = re.compile(r'^(\d+)[.\)]\s*(.*)')

    for line in lines:
        # Check for source header
        source_match = source_pattern.match(line)
        if source_match:
            current_source = line.strip()
            continue

        # Check for choice line (A. xxx, B. xxx, etc.)
        choice_match = choice_pattern.match(line)
        if choice_match and current_q:
            label = choice_match.group(1).upper()
            text = choice_match.group(2).strip()
            if text:
                current_q['choices'].append({'label': label, 'text': text})
            continue

        # Check for numbered question
        number_match = number_pattern.match(line)
        if number_match:
            # Save previous question
            if current_q and (current_q.get('scenario') or current_q.get('choices')):
                questions.append(current_q)

            scenario = number_match.group(2).strip()
            current_q = {
                'question_number': int(number_match.group(1)),
                'scenario': scenario,
                'choices': [],
                'exam_source': current_source,
            }
            continue

        # If line looks like a standalone choice (short, no period at start)
        if current_q and len(line) < 100 and not line[0].isdigit():
            # Could be a choice without label, or continuation of scenario
            # Heuristic: if we already have choices, this might be another choice
            if current_q['choices']:
                next_label = chr(ord('A') + len(current_q['choices']))
                if next_label <= 'E':
                    current_q['choices'].append({'label': next_label, 'text': line})
                    continue

        # If no current question, this might be a question without a number
        if not current_q and len(line) > 30:
            current_q = {
                'question_number': len(questions) + 1,
                'scenario': line,
                'choices': [],
                'exam_source': current_source,
            }
            continue

        # Otherwise, append to current scenario
        if current_q and not current_q['choices']:
            current_q['scenario'] += '\n' + line

    # Don't forget last question
    if current_q and (current_q.get('scenario') or current_q.get('choices')):
        questions.append(current_q)

    return questions


def analyze_questions(questions):
    """Analyze quality of parsed questions"""
    stats = {
        'total': len(questions),
        'no_choices': 0,
        'few_choices': 0,  # < 4
        'good': 0,  # 4-5 choices
        'no_scenario': 0,
        'short_scenario': 0,  # < 20 chars
    }

    issues = []
    for i, q in enumerate(questions):
        q_issues = []
        n_choices = len(q.get('choices', []))

        if n_choices == 0:
            stats['no_choices'] += 1
            q_issues.append('no_choices')
        elif n_choices < 4:
            stats['few_choices'] += 1
            q_issues.append(f'only_{n_choices}_choices')
        else:
            stats['good'] += 1

        scenario = q.get('scenario', '')
        if not scenario:
            stats['no_scenario'] += 1
            q_issues.append('no_scenario')
        elif len(scenario) < 20:
            stats['short_scenario'] += 1
            q_issues.append('short_scenario')

        if q_issues:
            issues.append({
                'index': i,
                'question_number': q.get('question_number'),
                'issues': q_issues,
                'scenario_preview': scenario[:80] if scenario else '',
                'choices_count': n_choices,
            })

    return stats, issues


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    all_results = {}
    total_questions = 0
    total_issues = 0

    for folder in EXAM_FOLDERS:
        docx_files = sorted(Path(folder).glob("*.docx"))
        print(f"\n📁 Folder: {folder}")
        print(f"   Found {len(docx_files)} .docx files\n")

        for filepath in docx_files:
            filename = filepath.stem
            subject = SUBJECT_MAP.get(filename, filename.lower().replace(' ', '_'))

            print(f"📄 {filename} → subject: {subject}")

            # Extract text
            lines = extract_text_from_docx(str(filepath))
            print(f"   Lines extracted: {len(lines)}")

            # Parse questions
            questions = parse_questions_from_lines(lines, filename)
            print(f"   Questions parsed: {len(questions)}")

            # Analyze quality
            stats, issues = analyze_questions(questions)
            print(f"   ✅ Good: {stats['good']} | ⚠️ Few choices: {stats['few_choices']} | ❌ No choices: {stats['no_choices']}")

            if issues:
                total_issues += len(issues)
                print(f"   📋 Issues found: {len(issues)}")

            # Store result
            result = {
                'filename': filename,
                'subject': subject,
                'exam_type': 'NL2',
                'stats': stats,
                'issues': issues,
                'questions': questions,
            }
            all_results[filename] = result
            total_questions += len(questions)

            # Save individual file
            output_file = os.path.join(OUTPUT_DIR, f"{subject}.json")
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(result, f, ensure_ascii=False, indent=2)

    # Save summary
    summary = {
        'total_files': len(all_results),
        'total_questions': total_questions,
        'total_issues': total_issues,
        'per_file': {k: v['stats'] for k, v in all_results.items()},
    }

    with open(os.path.join(OUTPUT_DIR, '_summary.json'), 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)

    print(f"\n{'='*50}")
    print(f"📊 SUMMARY")
    print(f"{'='*50}")
    print(f"Files processed: {len(all_results)}")
    print(f"Total questions: {total_questions}")
    print(f"Total issues: {total_issues}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"\nNext step: Run import-mcq-ai.py to fix issues with AI")


if __name__ == '__main__':
    main()
