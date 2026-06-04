#!/usr/bin/env python3
"""Append questions to radiology.json preserving existing formatting.
Usage: python _add_batch.py <batch_module.py>
"""
import json
import sys
import importlib.util
from pathlib import Path

BASE = Path(__file__).parent
TARGET = BASE / "radiology.json"


def load_batch(module_path: str):
    spec = importlib.util.spec_from_file_location("batch_mod", module_path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.QUESTIONS


def format_question(q: dict) -> str:
    """Format one question to match existing hybrid style:
    - outer object indented 2 spaces
    - keys indented 4 spaces
    - choices array entries on single lines (6-space indent)
    """
    lines = ["  {"]
    lines.append(f'    "scenario": {json.dumps(q["scenario"], ensure_ascii=False)},')
    lines.append('    "choices": [')
    for i, c in enumerate(q["choices"]):
        comma = "," if i < len(q["choices"]) - 1 else ""
        lines.append(
            "      { "
            + f'"label": {json.dumps(c["label"], ensure_ascii=False)}, '
            + f'"text": {json.dumps(c["text"], ensure_ascii=False)}'
            + " }" + comma
        )
    lines.append("    ],")
    lines.append(f'    "correct_answer": {json.dumps(q["correct_answer"], ensure_ascii=False)},')
    lines.append(f'    "explanation": {json.dumps(q["explanation"], ensure_ascii=False)},')
    lines.append(f'    "difficulty": {json.dumps(q["difficulty"], ensure_ascii=False)},')
    lines.append(f'    "board_section": {json.dumps(q["board_section"], ensure_ascii=False)},')
    lines.append(f'    "board_topic": {json.dumps(q["board_topic"], ensure_ascii=False)},')
    lines.append(f'    "board_age_group": {json.dumps(q["board_age_group"], ensure_ascii=False)},')
    lines.append(f'    "reference_source": {json.dumps(q["reference_source"], ensure_ascii=False)}')
    lines.append("  }")
    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print("usage: _add_batch.py <batch.py>")
        sys.exit(1)
    new_qs = load_batch(sys.argv[1])
    text = TARGET.read_text(encoding="utf-8")
    # validate existing
    existing = json.loads(text)
    # find last "  }" before final "]"
    # strip trailing whitespace + final ]
    stripped = text.rstrip()
    assert stripped.endswith("]"), "file must end with ]"
    body = stripped[:-1].rstrip()  # remove the ]
    # body should end with "  }"
    assert body.endswith("}"), "expected closing } before ]"
    new_block = ",\n" + ",\n".join(format_question(q) for q in new_qs) + "\n]\n"
    out = body + new_block
    # round-trip validate
    parsed = json.loads(out)
    assert len(parsed) == len(existing) + len(new_qs)
    TARGET.write_text(out, encoding="utf-8")
    print(f"appended {len(new_qs)} -> total {len(parsed)}")


if __name__ == "__main__":
    main()
