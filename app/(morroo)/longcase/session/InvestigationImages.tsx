"use client";

import { useState } from "react";
import { ImageIcon, Maximize2 } from "lucide-react";
import type { LongCaseResult } from "@/lib/longcase-media";

// Ordered investigations that came back with a picture (ECG strip, CXR film).
// The written report stays hidden until the student asks for it, so they
// practise reading the image first — as in the real long case exam.
export function InvestigationImages({ ordered, revealed }: {
  ordered: string[];
  revealed: Record<string, LongCaseResult>;
}) {
  const [shownReports, setShownReports] = useState<Record<string, boolean>>({});
  const items = ordered.filter(name => revealed[name]?.image_url);
  if (items.length === 0) return null;

  return (
    <div className="space-y-3">
      <p className="text-xs font-semibold text-gray-600 flex items-center gap-1">
        <ImageIcon className="h-4 w-4" /> ภาพผลตรวจ — ลองอ่านเองก่อนเปิดผลอ่าน
      </p>
      {items.map(name => {
        const res = revealed[name];
        const showReport = shownReports[name];
        return (
          <figure key={name} className="rounded-lg border border-gray-200 bg-gray-50 overflow-hidden">
            <figcaption className="flex items-center justify-between px-3 py-2 text-sm font-medium text-gray-800 bg-white border-b">
              {name}
              <a
                href={res.image_url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-xs text-blue-600 hover:underline flex items-center gap-1"
              >
                <Maximize2 className="h-3.5 w-3.5" /> ดูภาพเต็ม
              </a>
            </figcaption>
            {/* eslint-disable-next-line @next/next/no-img-element -- URL dynamic จากข้อมูลเคส (Storage / public) */}
            <img
              src={res.image_url}
              alt={`ภาพผล ${name}`}
              loading="lazy"
              className="w-full max-h-[70vh] object-contain bg-black"
            />
            <div className="px-3 py-2 space-y-1">
              {res.value && (showReport ? (
                <p className={`text-sm ${res.isAbnormal ? "text-red-600 font-medium" : "text-gray-700"}`}>
                  ผลอ่าน: {res.value}
                </p>
              ) : (
                <button
                  type="button"
                  onClick={() => setShownReports(prev => ({ ...prev, [name]: true }))}
                  className="text-xs text-amber-700 hover:underline"
                >
                  อ่านเองแล้ว → เปิดผลอ่าน
                </button>
              ))}
              {res.image_credit && <p className="text-[11px] text-gray-400">ที่มา: {res.image_credit}</p>}
            </div>
          </figure>
        );
      })}
    </div>
  );
}
