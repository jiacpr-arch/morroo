"use client";

import { useState } from "react";
import { ChevronDown, ChevronUp, HelpCircle } from "lucide-react";

interface Props {
  items: { q: string; a: string }[];
}

export default function QuickCheckList({ items }: Props) {
  const [open, setOpen] = useState<Set<number>>(new Set());

  function toggle(i: number) {
    const next = new Set(open);
    if (next.has(i)) next.delete(i);
    else next.add(i);
    setOpen(next);
  }

  if (items.length === 0) return null;

  return (
    <div className="space-y-2">
      <p className="text-xs font-bold uppercase text-amber-700 flex items-center gap-1">
        <HelpCircle className="h-3 w-3" /> Quick Check ({items.length})
      </p>
      <ul className="space-y-2">
        {items.map((it, i) => {
          const isOpen = open.has(i);
          return (
            <li key={i} className="border rounded-lg bg-amber-50/40">
              <button
                type="button"
                onClick={() => toggle(i)}
                className="w-full text-left p-3 flex items-start gap-2"
              >
                <span className="font-bold text-amber-700 shrink-0">Q{i + 1}.</span>
                <span className="flex-1 text-sm">{it.q}</span>
                {isOpen ? (
                  <ChevronUp className="h-4 w-4 text-muted-foreground shrink-0" />
                ) : (
                  <ChevronDown className="h-4 w-4 text-muted-foreground shrink-0" />
                )}
              </button>
              {isOpen && (
                <div className="px-3 pb-3 pt-1 border-t border-amber-200">
                  <p className="text-sm whitespace-pre-wrap">
                    <span className="font-semibold text-amber-700">A: </span>
                    {it.a}
                  </p>
                </div>
              )}
            </li>
          );
        })}
      </ul>
    </div>
  );
}
