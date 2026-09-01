"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { CheckCircle2, XCircle, Save, Loader2, AlertTriangle } from "lucide-react";
import type { McqQuestion, McqChoice } from "@/lib/types-mcq";
import {
  updateMcqQuestion,
  updateMcqQuestionStatus,
} from "@/lib/supabase/mutations-mcq-admin";

interface Props {
  question: McqQuestion;
  selected: boolean;
  onToggleSelect: () => void;
  onRemove: () => void;
}

function parseAiNotes(notes: string | null): {
  confidence: number | null;
  issues: string[];
} {
  if (!notes) return { confidence: null, issues: [] };
  const confMatch = notes.match(/confidence=([\d.]+)/);
  const confidence = confMatch ? parseFloat(confMatch[1]) : null;
  const issuesMatch = notes.match(/issues:\s*\[(.+?)\]/);
  const issues = issuesMatch
    ? issuesMatch[1].split(";").map((s) => s.trim()).filter(Boolean)
    : [];
  return { confidence, issues };
}

function confidenceColor(c: number | null): string {
  if (c == null) return "bg-gray-100 text-gray-600";
  if (c >= 0.85) return "bg-emerald-100 text-emerald-700";
  if (c >= 0.7) return "bg-amber-100 text-amber-700";
  return "bg-rose-100 text-rose-700";
}

export function ReviewQuestionCard({
  question,
  selected,
  onToggleSelect,
  onRemove,
}: Props) {
  const [scenario, setScenario] = useState(question.scenario);
  const [choices, setChoices] = useState<McqChoice[]>(question.choices);
  const [correct, setCorrect] = useState(question.correct_answer);
  const [explanation, setExplanation] = useState(question.explanation ?? "");
  const [reference, setReference] = useState(question.reference_source ?? "");
  const [dirty, setDirty] = useState(false);
  const [saving, setSaving] = useState<"save" | "approve" | "reject" | null>(null);
  const [err, setErr] = useState<string | null>(null);

  const { confidence, issues } = parseAiNotes(question.ai_notes);

  function updateChoice(i: number, text: string) {
    setChoices((prev) => prev.map((c, idx) => (idx === i ? { ...c, text } : c)));
    setDirty(true);
  }

  async function save(): Promise<boolean> {
    setSaving("save");
    setErr(null);
    const ok = await updateMcqQuestion(question.id, {
      scenario,
      choices,
      correct_answer: correct,
      explanation: explanation || null,
      reference_source: reference || null,
    });
    setSaving(null);
    if (!ok) {
      setErr("บันทึกไม่สำเร็จ");
      return false;
    }
    setDirty(false);
    return true;
  }

  async function approve() {
    if (dirty) {
      const ok = await save();
      if (!ok) return;
    }
    setSaving("approve");
    setErr(null);
    const ok = await updateMcqQuestionStatus(question.id, "active");
    setSaving(null);
    if (!ok) {
      setErr("Approve ไม่สำเร็จ");
      return;
    }
    onRemove();
  }

  async function reject() {
    if (!confirm("Reject ข้อนี้? (จะถูก mark เป็น disabled)")) return;
    setSaving("reject");
    setErr(null);
    const ok = await updateMcqQuestionStatus(question.id, "disabled");
    setSaving(null);
    if (!ok) {
      setErr("Reject ไม่สำเร็จ");
      return;
    }
    onRemove();
  }

  return (
    <Card>
      <CardContent className="pt-5 space-y-3">
        <div className="flex items-start gap-3 flex-wrap">
          <input
            type="checkbox"
            checked={selected}
            onChange={onToggleSelect}
            aria-label="Select for bulk action"
            className="mt-1 h-4 w-4"
          />
          <div className="flex-1 flex flex-wrap gap-1">
            {question.board_specialty && (
              <Badge variant="outline" className="font-mono text-[10px]">
                {question.board_specialty}
              </Badge>
            )}
            {question.board_section && (
              <Badge variant="outline" className="font-mono text-[10px]">
                {question.board_section}
              </Badge>
            )}
            {question.board_topic && (
              <Badge variant="outline" className="font-mono text-[10px]">
                {question.board_topic}
              </Badge>
            )}
            <Badge variant="secondary">{question.difficulty}</Badge>
            {question.board_age_group && (
              <Badge variant="secondary">{question.board_age_group}</Badge>
            )}
            {confidence != null && (
              <Badge className={confidenceColor(confidence)}>
                conf {confidence.toFixed(2)}
              </Badge>
            )}
          </div>
        </div>

        {issues.length > 0 && (
          <div className="flex items-start gap-2 rounded-md bg-amber-50 px-3 py-2 text-xs text-amber-900">
            <AlertTriangle className="h-4 w-4 mt-0.5 shrink-0" />
            <div>
              <div className="font-medium mb-0.5">Critique issues:</div>
              <ul className="list-disc list-inside space-y-0.5">
                {issues.map((iss, i) => (
                  <li key={i}>{iss}</li>
                ))}
              </ul>
            </div>
          </div>
        )}

        <div>
          <label className="text-xs font-medium text-muted-foreground">Scenario</label>
          <Textarea
            value={scenario}
            onChange={(e) => {
              setScenario(e.target.value);
              setDirty(true);
            }}
            rows={5}
            className="mt-1 font-sans"
          />
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">Choices</label>
          <div className="space-y-1.5 mt-1">
            {choices.map((c, i) => (
              <div key={c.label} className="flex items-center gap-2">
                <label className="flex items-center gap-1.5 cursor-pointer">
                  <input
                    type="radio"
                    name={`correct-${question.id}`}
                    checked={correct === c.label}
                    onChange={() => {
                      setCorrect(c.label);
                      setDirty(true);
                    }}
                    className="h-4 w-4"
                  />
                  <span className="font-mono text-sm w-5">{c.label}.</span>
                </label>
                <Input
                  value={c.text}
                  onChange={(e) => updateChoice(i, e.target.value)}
                  className="flex-1"
                />
              </div>
            ))}
          </div>
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">Explanation</label>
          <Textarea
            value={explanation}
            onChange={(e) => {
              setExplanation(e.target.value);
              setDirty(true);
            }}
            rows={3}
            className="mt-1"
          />
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">Reference</label>
          <Input
            value={reference}
            onChange={(e) => {
              setReference(e.target.value);
              setDirty(true);
            }}
            className="mt-1"
          />
        </div>

        {err && (
          <div className="text-sm text-rose-700 bg-rose-50 rounded px-3 py-2">
            {err}
          </div>
        )}

        <div className="flex flex-wrap gap-2 pt-1">
          <Button
            variant="outline"
            size="sm"
            onClick={save}
            disabled={!dirty || saving !== null}
          >
            {saving === "save" ? (
              <Loader2 className="h-3 w-3 animate-spin mr-1" />
            ) : (
              <Save className="h-3 w-3 mr-1" />
            )}
            Save edits
          </Button>
          <Button
            size="sm"
            onClick={approve}
            disabled={saving !== null}
            className="bg-emerald-600 hover:bg-emerald-700"
          >
            {saving === "approve" ? (
              <Loader2 className="h-3 w-3 animate-spin mr-1" />
            ) : (
              <CheckCircle2 className="h-3 w-3 mr-1" />
            )}
            {dirty ? "Save & approve" : "Approve"}
          </Button>
          <Button
            size="sm"
            variant="outline"
            onClick={reject}
            disabled={saving !== null}
            className="text-rose-700 hover:bg-rose-50"
          >
            {saving === "reject" ? (
              <Loader2 className="h-3 w-3 animate-spin mr-1" />
            ) : (
              <XCircle className="h-3 w-3 mr-1" />
            )}
            Reject
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
