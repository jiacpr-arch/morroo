import sharp from "sharp";

/**
 * Story CTA bar (1080×200 SVG): renders a rounded white card with the brand
 * URL and "link in bio" CTA. Used as a sharp composite layer so we don't pay
 * for another AI image generation just for the call-to-action.
 *
 * Latin text only — Vercel's Node.js runtime ships DejaVu Sans by default,
 * but no Thai-capable font. The square cover above already carries Thai
 * typography baked in by gpt-image-1.
 */
function buildCtaBarSvg(): string {
  return `<svg width="1080" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect x="60" y="10" width="960" height="180" rx="36" fill="#ffffff" fill-opacity="0.95"/>
  <text x="540" y="90" text-anchor="middle"
        font-family="DejaVu Sans,Helvetica,Arial,sans-serif"
        font-size="64" font-weight="700" fill="#0F172A">morroo.com</text>
  <text x="540" y="155" text-anchor="middle"
        font-family="DejaVu Sans,Helvetica,Arial,sans-serif"
        font-size="34" font-weight="500" fill="#475569" letter-spacing="2">
    READ FULL ARTICLE · LINK IN BIO →
  </text>
</svg>`;
}

/**
 * Compose a 9:16 (1080×1920) Story image from a square cover.
 *
 * Layout (vertical):
 *   y=0     – 280   blurred background, falls inside IG Story top safe area (~14%)
 *   y=280   – 1280  square cover 1000×1000 (headline/subtitle baked by gpt-image-1)
 *   y=1310  – 1510  CTA bar (1080×200) with brand URL + "link in bio" hint
 *   y=1510  – 1920  blurred background, falls inside IG Story bottom safe area (~20%)
 *
 * Bottom safe area starts at ~1530 (20% of 1920); CTA ends at 1510 so it stays
 * above IG's reactions/swipe-up UI overlay.
 *
 * FB Stories + IG Stories share this asset; both accept JPEG ≤ 4 MB. q=90
 * keeps typography crisp while staying under the size limit.
 */
export async function composeStoryImage(coverBuffer: Buffer): Promise<Buffer> {
  const bg = await sharp(coverBuffer)
    .resize(1080, 1920, { fit: "cover" })
    .blur(40)
    .modulate({ brightness: 0.7 })
    .toBuffer();
  const square = await sharp(coverBuffer)
    .resize(1000, 1000, { fit: "cover" })
    .toBuffer();
  const ctaBar = Buffer.from(buildCtaBarSvg());

  return sharp(bg)
    .composite([
      { input: square, top: 280, left: 40 },
      { input: ctaBar, top: 1310, left: 0 },
    ])
    .flatten({ background: "#ffffff" })
    .jpeg({ quality: 90 })
    .toBuffer();
}
