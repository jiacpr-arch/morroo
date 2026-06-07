/**
 * Browser-side PDF text extraction using pdf.js.
 *
 * Used by the school import flow when the PDF is too big to multipart-upload
 * through Vercel's serverless body limit. Extracts text locally, lets the
 * caller send just the text (much smaller) to the import API.
 *
 * Trade-off vs. uploading the PDF: images, diagrams, and layout are lost.
 * For text-heavy materials (lecture summaries, study guides) this is fine.
 * Handwritten PDFs (and scans with no text layer) need renderPdfPagesToImages
 * instead — pdf.js can't OCR.
 */

interface PdfTextItem {
  str?: string;
}

export async function extractPdfTextInBrowser(
  file: File,
  onProgress?: (current: number, total: number) => void,
): Promise<{ text: string; pages: number }> {
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
  const text = parts
    .join("\n\n")
    .replace(/[ \t]+/g, " ")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
  return { text, pages: doc.numPages };
}

/**
 * Render PDF pages to JPEG data URLs for vision models.
 *
 * Use this when pdf.js extracts no text (handwritten notes, scans without OCR).
 * Each page becomes a JPEG image the AI can read directly. Aggressive
 * compression keeps the JSON payload under Vercel's body limit:
 *   - scale 1.5 → roughly 1.5x device pixels, enough for handwriting
 *   - JPEG quality 0.65 → small file, still readable
 *
 * Caller should limit maxPages to keep the total request size reasonable
 * (~25 pages fits comfortably under 4-5 MB).
 */
export async function renderPdfPagesToImages(
  file: File,
  options: {
    maxPages?: number;
    scale?: number;
    jpegQuality?: number;
    onProgress?: (current: number, total: number) => void;
  } = {},
): Promise<{ images: string[]; pages: number }> {
  const maxPages = options.maxPages ?? 25;
  const scale = options.scale ?? 1.5;
  const jpegQuality = options.jpegQuality ?? 0.65;

  const pdfjs = await import("pdfjs-dist");
  pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
  const buf = new Uint8Array(await file.arrayBuffer());
  const doc = await pdfjs.getDocument({
    data: buf,
    cMapUrl: "/pdfjs/cmaps/",
    cMapPacked: true,
    standardFontDataUrl: "/pdfjs/standard_fonts/",
  }).promise;

  const total = Math.min(doc.numPages, maxPages);
  const images: string[] = [];
  for (let p = 1; p <= total; p++) {
    options.onProgress?.(p, total);
    try {
      const page = await doc.getPage(p);
      const viewport = page.getViewport({ scale });
      const canvas = document.createElement("canvas");
      canvas.width = Math.floor(viewport.width);
      canvas.height = Math.floor(viewport.height);
      const ctx = canvas.getContext("2d");
      if (!ctx) continue;
      // Fill white background so JPEG doesn't show black for transparent areas.
      ctx.fillStyle = "#ffffff";
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      await page.render({ canvasContext: ctx, viewport, canvas }).promise;
      const dataUrl = canvas.toDataURL("image/jpeg", jpegQuality);
      // Strip the prefix "data:image/jpeg;base64," — server-side we send the
      // raw base64 directly to the model.
      const base64 = dataUrl.split(",")[1] ?? "";
      images.push(base64);
      // Help GC for big PDFs.
      canvas.width = 0;
      canvas.height = 0;
    } catch {
      // Skip pages that fail to render — better partial content than total fail.
    }
  }
  return { images, pages: doc.numPages };
}
