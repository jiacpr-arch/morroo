/**
 * Browser-side PDF text extraction using pdf.js.
 *
 * Used by the school import flow when the PDF is too big to multipart-upload
 * through Vercel's serverless body limit. Extracts text locally, lets the
 * caller send just the text (much smaller) to the import API.
 *
 * Trade-off vs. uploading the PDF: images, diagrams, and layout are lost.
 * For text-heavy materials (lecture summaries, study guides) this is fine.
 * For image-heavy materials, compress the PDF and upload directly instead.
 */

interface PdfTextItem {
  str?: string;
}

export async function extractPdfTextInBrowser(
  file: File,
  onProgress?: (current: number, total: number) => void,
): Promise<string> {
  const pdfjs = await import("pdfjs-dist");
  pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
  const buf = new Uint8Array(await file.arrayBuffer());
  const doc = await pdfjs.getDocument({
    data: buf,
    cMapUrl: "/pdfjs/cmaps/",
    cMapPacked: true,
    standardFontDataUrl: "/pdfjs/standard_fonts/",
  }).promise;

  const parts: string[] = [];
  for (let p = 1; p <= doc.numPages; p++) {
    onProgress?.(p, doc.numPages);
    try {
      const page = await doc.getPage(p);
      const content = await page.getTextContent();
      const items = (content?.items as PdfTextItem[]) ?? [];
      parts.push(items.map((it) => it.str ?? "").join(" "));
    } catch {
      // Skip pages pdf.js can't parse — better some content than none.
    }
  }
  return parts
    .join("\n\n")
    .replace(/[ \t]+/g, " ")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}
