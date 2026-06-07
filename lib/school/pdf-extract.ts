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
 * compression keeps the JSON payload under Vercel's body limit AND keeps
 * browser memory under control on Safari (which has a much smaller per-tab
 * memory budget than Chrome — Safari tabs crash with "page couldn't load"
 * when canvas allocations spike).
 *
 * Defaults:
 *   - scale 1.0 → render at native PDF resolution; still readable for
 *     handwriting and ~4× less canvas memory than 2.0
 *   - JPEG quality 0.6 → small file, still readable
 *   - maxPages 12 → safer Safari budget; raise per-call for known
 *     Chrome users
 *
 * After each page we explicitly release page resources, shrink the canvas
 * to 0×0, and yield to the event loop so the browser can GC between pages.
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
  const maxPages = options.maxPages ?? 12;
  const scale = options.scale ?? 1.0;
  const jpegQuality = options.jpegQuality ?? 0.6;

  const pdfjs = await import("pdfjs-dist");
  pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
  const buf = new Uint8Array(await file.arrayBuffer());
  const doc = await pdfjs.getDocument({
    data: buf,
    cMapUrl: "/pdfjs/cmaps/",
    cMapPacked: true,
    standardFontDataUrl: "/pdfjs/standard_fonts/",
  }).promise;

  try {
    const total = Math.min(doc.numPages, maxPages);
    const images: string[] = [];
    for (let p = 1; p <= total; p++) {
      options.onProgress?.(p, total);
      // Yield to the event loop so the browser can paint progress and GC
      // before allocating the next canvas. Without this, Safari batches the
      // whole loop into one micro-task and OOMs.
      await new Promise<void>((r) => setTimeout(r, 0));
      let page: Awaited<ReturnType<typeof doc.getPage>> | null = null;
      let canvas: HTMLCanvasElement | null = null;
      try {
        page = await doc.getPage(p);
        const viewport = page.getViewport({ scale });
        canvas = document.createElement("canvas");
        canvas.width = Math.floor(viewport.width);
        canvas.height = Math.floor(viewport.height);
        const ctx = canvas.getContext("2d");
        if (!ctx) continue;
        // Fill white so JPEG doesn't show black for transparent areas.
        ctx.fillStyle = "#ffffff";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        await page.render({ canvasContext: ctx, viewport, canvas }).promise;
        const dataUrl = canvas.toDataURL("image/jpeg", jpegQuality);
        const base64 = dataUrl.split(",")[1] ?? "";
        if (base64) images.push(base64);
      } catch {
        // Skip pages that fail to render — partial content is fine.
      } finally {
        // Explicitly release everything before next iteration.
        if (canvas) {
          canvas.width = 0;
          canvas.height = 0;
        }
        try {
          page?.cleanup();
        } catch {
          /* ignore */
        }
      }
    }
    return { images, pages: doc.numPages };
  } finally {
    // PDFDocumentProxy.destroy exists at runtime but isn't on the public types
    // in this version — cast to unknown to release pdf.js resources anyway.
    try {
      const d = (doc as unknown as { destroy?: () => Promise<void> }).destroy;
      if (typeof d === "function") await d.call(doc);
    } catch {
      /* ignore */
    }
  }
}
