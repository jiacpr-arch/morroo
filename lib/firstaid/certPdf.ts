"use client";

import { certToPng, type CertExportArgs } from "@/lib/firstaid/certImage";

// Builds the certificate PDF from the SAME PNG capture used for the image download, so
// the PDF and PNG are pixel-identical. The certificate node (1123×794) matches A4-landscape
// proportions, so the bitmap fills the page with no stretching or letterboxing.
export async function makeCertPdf(args: CertExportArgs) {
  const png = await certToPng(args);
  // Dynamic import keeps jsPDF out of the shared client bundle — only loaded on download.
  const { jsPDF } = await import("jspdf");
  const doc = new jsPDF({ orientation: "landscape", unit: "mm", format: "a4" });
  const pageW = doc.internal.pageSize.getWidth();
  const pageH = doc.internal.pageSize.getHeight();
  doc.addImage(png, "PNG", 0, 0, pageW, pageH);
  return doc;
}

export async function downloadCertPdf(args: CertExportArgs) {
  const doc = await makeCertPdf(args);
  doc.save(`firstaid-${args.kind}-${args.code}.pdf`);
}
