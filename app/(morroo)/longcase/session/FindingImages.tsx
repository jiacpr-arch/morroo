"use client";

import { useState } from "react";
import { ImageIcon, Maximize2 } from "lucide-react";

export interface FindingImage {
  name: string;
  image_url: string;
  image_credit?: string;
  /** Written report / finding, hidden until the student asks for it */
  report: string;
  isAbnormal: boolean;
}

// Pictures that came back from the student's own orders — PE signs (jaundice,
// clubbing) or investigations (ECG strip, CXR film). The written report stays
// hidden until they tap for it, so they practise reading the image first —
// as in the real long case exam.
export function FindingImages({ heading, items }: { heading: string; items: FindingImage[] }) {
  const [shownReports, setShownReports] = useState<Record<string, boolean>>({});
  if (items.length === 0) return null;

  return (
    <div className="space-y-3">
      <p className="text-xs font-semibold text-gray-600 flex items-center gap-1">
        <ImageIcon className="h-4 w-4" /> {heading}
      </p>
      {items.map(item => {
        const showReport = shownReports[item.name];
        return (
          <figure key={item.name} className="rounded-lg border border-gray-200 bg-gray-50 overflow-hidden">
            <figcaption className="flex items-center justify-between px-3 py-2 text-sm font-medium text-gray-800 bg-white border-b">
              {item.name}
              <a
                href={item.image_url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-xs text-blue-600 hover:underline flex items-center gap-1"
              >
                <Maximize2 className="h-3.5 w-3.5" /> ดูภาพเต็ม
              </a>
            </figcaption>
            {/* eslint-disable-next-line @next/next/no-img-element -- URL dynamic จากข้อมูลเคส (Storage / public) */}
            <img
              src={item.image_url}
              alt={`ภาพ ${item.name}`}
              loading="lazy"
              className="w-full max-h-[70vh] object-contain bg-black"
            />
            <div className="px-3 py-2 space-y-1">
              {item.report && (showReport ? (
                <p className={`text-sm ${item.isAbnormal ? "text-red-600 font-medium" : "text-gray-700"}`}>
                  ผลอ่าน: {item.report}
                </p>
              ) : (
                <button
                  type="button"
                  onClick={() => setShownReports(prev => ({ ...prev, [item.name]: true }))}
                  className="text-xs text-amber-700 hover:underline"
                >
                  อ่านเองแล้ว → เปิดผลอ่าน
                </button>
              ))}
              {item.image_credit && <p className="text-[11px] text-gray-400">ที่มา: {item.image_credit}</p>}
            </div>
          </figure>
        );
      })}
    </div>
  );
}
