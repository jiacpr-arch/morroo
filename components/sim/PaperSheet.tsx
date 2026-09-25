"use client";

// ใบกระดาษจำลองของจริงที่โผล่ทับเวที — ใบรายงานผลแลป / ใบสั่งการรักษา
// (แนวเดียวกับฉลากยาในเกมร้านยาของ pharmroo) แตะที่ไหนก็ได้เพื่อไปต่อ

import type { LabSheetNode, OrderSheetNode } from "@/lib/sim/types";

export type Paper =
  | { kind: "lab"; sheet: LabSheetNode["labSheet"] }
  | { kind: "order"; sheet: OrderSheetNode["orderSheet"] };

export default function PaperSheet({ paper, onDone }: { paper: Paper; onDone: () => void }) {
  const isLab = paper.kind === "lab";
  return (
    <div
      className="cbs-lab-overlay"
      onClick={onDone}
      role="button"
      tabIndex={0}
      aria-label={isLab ? "ปิดใบรายงานผล แล้วไปต่อ" : "ปิดใบสั่งการรักษา แล้วไปต่อ"}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") { e.preventDefault(); onDone(); }
      }}
    >
      <div className={`cbs-lab-sheet${isLab ? "" : " cbs-order-sheet"}`} onClick={(e) => e.stopPropagation()}>
        <div className="cbs-lab-head">
          <span className="cbs-lab-hosp">{isLab ? "ห้องปฏิบัติการ รพ.หมอรู้" : "รพ.หมอรู้"}</span>
          <span className="cbs-lab-tag">{isLab ? "LAB REPORT" : "DOCTOR'S ORDER"}</span>
        </div>
        <div className="cbs-lab-title">{isLab ? paper.sheet.title : "ใบสั่งการรักษา"}</div>
        {paper.sheet.patient && <div className="cbs-lab-patient">{paper.sheet.patient}</div>}
        {paper.kind === "lab" ? (
          <div className="cbs-lab-rows">
            {paper.sheet.rows.map((r, i) => (
              <div
                key={i}
                className={`cbs-lab-row${r.abnormal ? " cbs-lab-abn" : ""}${r.isNew ? " cbs-lab-new" : ""}`}
              >
                <span className="cbs-lab-name">{r.name}</span>
                <span className="cbs-lab-flag">{r.abnormal ? "ผิดปกติ" : "ปกติ"}</span>
                <span className="cbs-lab-value">{r.value}</span>
              </div>
            ))}
          </div>
        ) : (
          <ol className="cbs-order-rows">
            {paper.sheet.orders.map((o, i) => (
              <li key={i} className={`cbs-order-row${o.isNew ? " cbs-lab-new" : ""}`}>
                <span className="cbs-order-no">{i + 1}.</span>
                <span className="cbs-order-text">{o.text}</span>
              </li>
            ))}
          </ol>
        )}
        <button type="button" className="cbs-lab-close" onClick={onDone}>
          {isLab ? "อ่านผลแล้ว ไปต่อ" : "เซ็นออร์เดอร์ แล้วไปต่อ"}
        </button>
      </div>
    </div>
  );
}
