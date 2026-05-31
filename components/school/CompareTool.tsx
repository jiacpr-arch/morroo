"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { X, Plus, Loader2, Sparkles } from "lucide-react";

interface ComparisonRow {
  aspect: string;
  values: string[];
}
interface Comparison {
  rows: ComparisonRow[];
  summary: string;
}

const PRESETS = [
  ["MI", "PE", "Aortic dissection"],
  ["Asthma", "COPD"],
  ["Type 1 DM", "Type 2 DM", "MODY"],
  ["ACE inhibitor", "ARB", "Aldosterone antagonist"],
  ["Crohn's disease", "Ulcerative colitis"],
];

export default function CompareTool() {
  const [items, setItems] = useState<string[]>(["", ""]);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<Comparison | null>(null);
  const [error, setError] = useState<string | null>(null);

  function addItem() {
    if (items.length < 4) setItems([...items, ""]);
  }
  function removeItem(i: number) {
    if (items.length <= 2) return;
    setItems(items.filter((_, x) => x !== i));
  }
  function setItem(i: number, v: string) {
    const copy = [...items];
    copy[i] = v;
    setItems(copy);
  }

  async function run() {
    const filled = items.map((s) => s.trim()).filter(Boolean);
    if (filled.length < 2) {
      setError("กรุณาใส่อย่างน้อย 2 อย่าง");
      return;
    }
    setError(null);
    setLoading(true);
    setResult(null);
    try {
      const res = await fetch("/api/school/compare", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ items: filled }),
      });
      if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.error ?? "Failed");
      }
      const data = (await res.json()) as Comparison;
      setResult(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Error");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardContent className="p-4 space-y-3">
          <div className="space-y-2">
            {items.map((it, i) => (
              <div key={i} className="flex items-center gap-2">
                <span className="w-6 text-center font-semibold text-muted-foreground">
                  {i + 1}.
                </span>
                <input
                  value={it}
                  onChange={(e) => setItem(i, e.target.value)}
                  placeholder="เช่น Myocardial infarction"
                  className="flex-1 border rounded-md px-3 py-2 text-sm"
                />
                {items.length > 2 && (
                  <button
                    onClick={() => removeItem(i)}
                    className="text-muted-foreground hover:text-rose-600"
                  >
                    <X className="h-4 w-4" />
                  </button>
                )}
              </div>
            ))}
          </div>
          {items.length < 4 && (
            <Button onClick={addItem} variant="outline" size="sm" className="gap-1">
              <Plus className="h-3 w-3" /> เพิ่ม
            </Button>
          )}
          {error && <p className="text-sm text-rose-600">{error}</p>}
          <Button onClick={run} disabled={loading} className="w-full gap-2">
            {loading ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" /> AI กำลังสร้าง…
              </>
            ) : (
              <>
                <Sparkles className="h-4 w-4" /> เปรียบเทียบ
              </>
            )}
          </Button>
        </CardContent>
      </Card>

      {/* Presets */}
      {!result && (
        <Card>
          <CardContent className="p-4">
            <p className="text-xs font-semibold mb-2">ลองตัวอย่าง</p>
            <div className="flex flex-wrap gap-1">
              {PRESETS.map((preset, i) => (
                <button
                  key={i}
                  onClick={() => setItems(preset)}
                  className="text-xs px-3 py-1.5 rounded-full border bg-background hover:bg-muted/50"
                >
                  {preset.join(" vs ")}
                </button>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {result && (
        <Card>
          <CardContent className="p-4 space-y-3">
            <div className="overflow-x-auto">
              <table className="w-full text-sm border-collapse">
                <thead>
                  <tr>
                    <th className="border p-2 text-left bg-muted">Aspect</th>
                    {items
                      .filter(Boolean)
                      .map((it, i) => (
                        <th key={i} className="border p-2 text-left bg-muted">
                          {it}
                        </th>
                      ))}
                  </tr>
                </thead>
                <tbody>
                  {result.rows.map((row, i) => (
                    <tr key={i}>
                      <td className="border p-2 font-semibold bg-muted/30">
                        {row.aspect}
                      </td>
                      {row.values.map((v, j) => (
                        <td key={j} className="border p-2 align-top">
                          {v}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <div className="rounded-lg p-3 border bg-pink-50/40">
              <p className="text-xs font-bold uppercase text-pink-700 mb-1">
                Key distinguishing point
              </p>
              <p className="text-sm">{result.summary}</p>
            </div>
            <Button onClick={() => setResult(null)} variant="outline" size="sm">
              เริ่มใหม่
            </Button>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
