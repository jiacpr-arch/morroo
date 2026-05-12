import sharp from "sharp";
import { ImageResponse } from "next/og";

/**
 * Render the Story CTA bar (1080×200) via next/og. We use next/og instead of
 * sharp+SVG because Vercel's Node runtime has no fontconfig-registered fonts —
 * sharp's librsvg falls back to "tofu" boxes for every glyph. next/og (Satori)
 * ships its own font handling, the same path /api/og/quote already relies on,
 * which is why Thai renders cleanly there.
 */
async function renderCtaBar(): Promise<Buffer> {
  const response = new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          padding: "10px 60px",
          fontFamily: "sans-serif",
        }}
      >
        <div
          style={{
            width: "100%",
            height: "100%",
            background: "rgba(255,255,255,0.95)",
            borderRadius: "36px",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            gap: "6px",
            padding: "16px 24px",
          }}
        >
          <div style={{ fontSize: "60px", fontWeight: 800, color: "#0F172A" }}>
            morroo.com
          </div>
          <div style={{ fontSize: "30px", fontWeight: 500, color: "#475569" }}>
            อ่านบทความเต็ม · Link in bio →
          </div>
        </div>
      </div>
    ),
    { width: 1080, height: 200 },
  );
  return Buffer.from(await response.arrayBuffer());
}

/**
 * Compose a 9:16 (1080×1920) Story image from a square cover.
 *
 * Layout (vertical):
 *   y=0     – 280   blurred background, falls inside IG Story top safe area (~14%)
 *   y=280   – 1280  square cover 1000×1000 (headline/subtitle baked by gpt-image-1)
 *   y=1310  – 1510  CTA bar (1080×200) with brand URL + "อ่านบทความเต็ม" hint
 *   y=1510  – 1920  blurred background, falls inside IG Story bottom safe area (~20%)
 *
 * Bottom safe area starts at ~1530 (20% of 1920); CTA ends at 1510 so it stays
 * above IG's reactions/swipe-up UI overlay.
 *
 * FB Stories + IG Stories share this asset; both accept JPEG ≤ 4 MB. q=90
 * keeps typography crisp while staying under the size limit.
 */
export async function composeStoryImage(coverBuffer: Buffer): Promise<Buffer> {
  const [bg, square, ctaBar] = await Promise.all([
    sharp(coverBuffer)
      .resize(1080, 1920, { fit: "cover" })
      .blur(40)
      .modulate({ brightness: 0.7 })
      .toBuffer(),
    sharp(coverBuffer).resize(1000, 1000, { fit: "cover" }).toBuffer(),
    renderCtaBar(),
  ]);

  return sharp(bg)
    .composite([
      { input: square, top: 280, left: 40 },
      { input: ctaBar, top: 1310, left: 0 },
    ])
    .flatten({ background: "#ffffff" })
    .jpeg({ quality: 90 })
    .toBuffer();
}
