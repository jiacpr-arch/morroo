import sharp from "sharp";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const FONTS_DIR = path.join(__dirname, "..", "assets", "fonts");

const INTER_B64 = fs
  .readFileSync(path.join(FONTS_DIR, "Inter-Black.ttf"))
  .toString("base64");
const SARABUN_B64 = fs
  .readFileSync(path.join(FONTS_DIR, "Sarabun-Bold.ttf"))
  .toString("base64");

const W = 1024;
const H = 1024;
const RIGHT_PAD = 60;
const HEADLINE_FONT_SIZE = 84;
const HEADLINE_FONT_SIZE_LONG = 64;
const SUBTITLE_FONT_SIZE = 44;
const CTA_FONT_SIZE = 26;

function escapeXml(s) {
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function pickHeadlineSize(headline) {
  return String(headline).length > 16
    ? HEADLINE_FONT_SIZE_LONG
    : HEADLINE_FONT_SIZE;
}

function buildOverlaySvg({ headline, subtitle }) {
  const upperHeadline = escapeXml(String(headline ?? "").toUpperCase());
  const safeSubtitle = escapeXml(String(subtitle ?? ""));
  const cta = escapeXml("หมอรู้ · morroo.com");
  const headlineSize = pickHeadlineSize(headline);
  const xRight = W - RIGHT_PAD;

  // Scrim darkens right ~65% so light text stays legible against any FLUX
  // background. Anchored within central 60% vertical band (y 205–820) so a
  // 16:9 center-crop on the blog card preserves headline + subtitle + CTA.
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}">
  <defs>
    <style>
      @font-face { font-family: 'Inter'; font-weight: 900; font-style: normal; src: url('data:font/ttf;base64,${INTER_B64}') format('truetype'); }
      @font-face { font-family: 'Sarabun'; font-weight: 700; font-style: normal; src: url('data:font/ttf;base64,${SARABUN_B64}') format('truetype'); }
    </style>
    <linearGradient id="scrim" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#0F172A" stop-opacity="0"/>
      <stop offset="0.35" stop-color="#0F172A" stop-opacity="0.55"/>
      <stop offset="1" stop-color="#0F172A" stop-opacity="0.92"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="${W}" height="${H}" fill="url(#scrim)"/>
  <text x="${xRight}" y="440" font-family="Inter" font-weight="900" font-size="${headlineSize}" fill="#FFFFFF" text-anchor="end" letter-spacing="-1">${upperHeadline}</text>
  <text x="${xRight}" y="${440 + headlineSize + 18}" font-family="Sarabun" font-weight="700" font-size="${SUBTITLE_FONT_SIZE}" fill="#E2E8F0" text-anchor="end">${safeSubtitle}</text>
  <text x="${xRight}" y="${H - 70}" font-family="Sarabun" font-weight="700" font-size="${CTA_FONT_SIZE}" fill="#CBD5E1" text-anchor="end">${cta}</text>
</svg>`;
}

export async function composeCoverWithText(imageBuffer, { headline, subtitle }) {
  const svg = buildOverlaySvg({ headline, subtitle });
  return sharp(imageBuffer)
    .composite([{ input: Buffer.from(svg), blend: "over" }])
    .png({ compressionLevel: 9 })
    .toBuffer();
}
