// Registers the Sarabun TTF font with jsPDF so Thai characters, Unicode
// symbols (≥, ≤, ₂, —, °, etc.) and accented Latin render correctly in
// exported certificates. Without this, jsPDF falls back to WinAnsi-only
// Helvetica and produces garbage glyphs for anything outside Latin-1.
//
// The base64 payloads in ./sarabun-regular.ts / ./sarabun-bold.ts are
// generated from the matching .ttf files:
//   base64 -w 0 Sarabun-Regular.ttf  > sarabun-regular.ts   (wrapped as ESM)
// Sarabun is licensed under the SIL Open Font License 1.1.
//
// Import this only from client code that actually renders a PDF (dynamic
// import) — the payloads are ~120KB each and shouldn't bloat every route.

import { jsPDF } from "jspdf";
import sarabunRegular from "./sarabun-regular";
import sarabunBold from "./sarabun-bold";

export const PDF_FONT = "Sarabun";

let registered = false;

export function registerPDFFonts() {
  if (registered) return;
  registered = true;

  jsPDF.API.events.push([
    "addFonts",
    function (this: jsPDF) {
      this.addFileToVFS("Sarabun-Regular.ttf", sarabunRegular);
      this.addFont("Sarabun-Regular.ttf", PDF_FONT, "normal");
      this.addFileToVFS("Sarabun-Bold.ttf", sarabunBold);
      this.addFont("Sarabun-Bold.ttf", PDF_FONT, "bold");
    },
  ]);
}
