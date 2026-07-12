import { jsPDF } from "jspdf";
import { registerPDFFonts, PDF_FONT } from "./fonts/register-fonts";
import { sanitisePDFText as S } from "./pdf-text";
import type { CertConfig } from "./config";

registerPDFFonts();

const LOGO_URL = "/images/logo-morroo.png";

export interface CertData {
  studentName: string;
  studentPhone?: string | null;
  studentEmail?: string | null;
  completedAt: string;
  preTestScore?: number | null;
  postTestScore?: number | null;
  ekgPassed?: boolean | null;
  certId: string;
}

// Loads an image from a URL and returns its dataURL + natural dimensions.
// Returns null if the file is missing or fails to load, so callers can skip
// the logo gracefully without breaking certificate generation.
async function loadImage(
  url: string,
): Promise<{ dataUrl: string; w: number; h: number } | null> {
  try {
    const res = await fetch(url);
    if (!res.ok) return null;
    const blob = await res.blob();
    const dataUrl = await new Promise<string>((resolve, reject) => {
      const r = new FileReader();
      r.onload = () => resolve(r.result as string);
      r.onerror = reject;
      r.readAsDataURL(blob);
    });
    const dims = await new Promise<{ w: number; h: number } | null>((resolve) => {
      const img = new Image();
      img.onload = () => resolve({ w: img.naturalWidth, h: img.naturalHeight });
      img.onerror = () => resolve(null);
      img.src = dataUrl;
    });
    if (!dims || !dims.w || !dims.h) return null;
    return { dataUrl, ...dims };
  } catch {
    return null;
  }
}

// Renders a landscape A4 certificate using the embedded Sarabun font so Thai
// student names (and any Thai config text) render correctly.
export async function exportCertificatePDF({
  cert,
  certConfig,
}: {
  cert: CertData;
  certConfig: CertConfig;
}): Promise<string> {
  const doc = new jsPDF("l", "mm", "a4");
  doc.setFont(PDF_FONT, "normal");
  const pw = doc.internal.pageSize.getWidth(); // 297
  const ph = doc.internal.pageSize.getHeight(); // 210
  const brand = certConfig.brandColor;

  // Outer border
  doc.setDrawColor(...brand);
  doc.setLineWidth(2);
  doc.rect(10, 10, pw - 20, ph - 20);
  doc.setLineWidth(0.4);
  doc.rect(14, 14, pw - 28, ph - 28);

  // Seal at the very top
  const logo = await loadImage(certConfig.logoUrl || LOGO_URL);
  if (logo) {
    const boxW = 64,
      boxH = 38;
    let w = boxW,
      h = (logo.h / logo.w) * w;
    if (h > boxH) {
      h = boxH;
      w = (logo.w / logo.h) * h;
    }
    try {
      doc.addImage(logo.dataUrl, "PNG", (pw - w) / 2, 18, w, h);
    } catch {
      /* ignore malformed image, certificate still renders */
    }
  }

  // Title + subtitle below the seal
  doc.setTextColor(...brand);
  doc.setFont(PDF_FONT, "bold");
  doc.setFontSize(22);
  doc.text(certConfig.title, pw / 2, 66, { align: "center" });
  doc.setFont(PDF_FONT, "normal");
  doc.setFontSize(11);
  doc.setTextColor(110);
  doc.text(certConfig.subtitle, pw / 2, 73, { align: "center" });

  doc.setTextColor(80);
  doc.setFontSize(11);
  doc.text("This is to certify that", pw / 2, 89, { align: "center" });

  // Student name — large
  doc.setTextColor(20);
  doc.setFont(PDF_FONT, "bold");
  doc.setFontSize(28);
  doc.text(S(cert.studentName) || "-", pw / 2, 104, { align: "center" });

  // Underline
  doc.setDrawColor(...brand);
  doc.setLineWidth(0.6);
  const nameWidth = Math.min(180, pw - 60);
  doc.line((pw - nameWidth) / 2, 108, (pw + nameWidth) / 2, 108);

  // Body text
  doc.setFont(PDF_FONT, "normal");
  doc.setFontSize(11);
  doc.setTextColor(60);
  const body1 = certConfig.theoryOnly
    ? `has successfully completed the online theoretical portion of the ${certConfig.subtitle} course`
    : `has successfully completed the ${certConfig.subtitle} course`;
  const body2 = `in accordance with the ${certConfig.issuingBody} curriculum.`;
  doc.text(body1, pw / 2, 119, { align: "center" });
  doc.text(body2, pw / 2, 126, { align: "center" });

  if (certConfig.theoryOnly && certConfig.theoryStatement) {
    doc.setFont(PDF_FONT, "bold");
    doc.setFontSize(11);
    doc.setTextColor(...brand);
    doc.text(S(certConfig.theoryStatement), pw / 2, 134, { align: "center" });
    doc.setFont(PDF_FONT, "normal");
  }

  // Stats row
  const issued = cert.completedAt ? new Date(cert.completedAt) : new Date();
  const validity = certConfig.validityMonths || 24;
  const expires = new Date(issued);
  expires.setMonth(expires.getMonth() + validity);
  const fmt = (d: Date) =>
    d.toLocaleDateString("en-GB", { year: "numeric", month: "short", day: "2-digit" });

  doc.setFontSize(9);
  doc.setTextColor(100);
  doc.text(`Issued: ${fmt(issued)}`, pw * 0.3, 145, { align: "center" });
  doc.text(`Valid through: ${fmt(expires)}`, pw * 0.7, 145, { align: "center" });

  const scoreParts: string[] = [];
  if (cert.preTestScore != null) scoreParts.push(`Pre-test ${cert.preTestScore}%`);
  if (cert.postTestScore != null) scoreParts.push(`Post-test ${cert.postTestScore}%`);
  if (cert.ekgPassed) scoreParts.push("EKG test passed");
  if (scoreParts.length) {
    doc.setFontSize(10);
    doc.setTextColor(40);
    doc.text(scoreParts.join("     "), pw / 2, 152, { align: "center" });
  }

  if (certConfig.theoryOnly && certConfig.practicalRecommendation) {
    doc.setFontSize(9);
    doc.setTextColor(120);
    doc.text(S(certConfig.practicalRecommendation), pw / 2, 159, { align: "center" });
  }

  // Signature lines
  const sigY = ph - 40;
  doc.setDrawColor(120);
  doc.setLineWidth(0.3);
  doc.line(pw * 0.18, sigY, pw * 0.38, sigY);
  doc.line(pw * 0.62, sigY, pw * 0.82, sigY);
  doc.setFontSize(8);
  doc.setTextColor(100);
  doc.text("Instructor", pw * 0.28, sigY + 5, { align: "center" });
  doc.text(certConfig.centerName, pw * 0.72, sigY + 5, { align: "center" });

  // Cert ID + center
  doc.setFontSize(8);
  doc.setTextColor(120);
  doc.text(`Certificate ID: ${cert.certId}`, pw / 2, ph - 22, { align: "center" });
  doc.text(`${certConfig.centerName} - ${certConfig.centerUrl}`, pw / 2, ph - 17, {
    align: "center",
  });

  const safeName = (cert.studentName || "student").replace(/[^a-zA-Z0-9_-]/g, "_");
  const fname = `${certConfig.certIdPrefix.toLowerCase()}_${safeName}_${cert.certId}.pdf`;
  doc.save(fname);
  return fname;
}
