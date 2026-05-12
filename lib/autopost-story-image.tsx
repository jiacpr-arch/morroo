import sharp from "sharp";
import { ImageResponse } from "next/og";

/**
 * Render the Story CTA bar (1080×260) via next/og. We use next/og instead of
 * sharp+SVG because Vercel's Node runtime has no fontconfig-registered fonts —
 * sharp's librsvg falls back to "tofu" boxes for every glyph. next/og (Satori)
 * ships its own font handling, the same path /api/og/quote already relies on,
 * which is why Thai renders cleanly there.
 */
async function renderCtaBar(headline: string | undefined): Promise<Buffer> {
  // Satori's CSS subset doesn't reliably honor line-clamp, so cap the headline
  // in JS — 90 chars fits comfortably in two lines at fontSize 38.
  const title = (headline ?? "📖 อ่านบทความเต็มก่อนสอบ").trim();
  const truncated = title.length > 90 ? `${title.slice(0, 87).trimEnd()}…` : title;

  const response = new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          padding: "10px 50px",
          fontFamily: "sans-serif",
        }}
      >
        <div
          style={{
            width: "100%",
            height: "100%",
            background: "rgba(255,255,255,0.96)",
            borderRadius: "40px",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            gap: "14px",
            padding: "20px 36px",
          }}
        >
          <div
            style={{
              fontSize: "38px",
              fontWeight: 800,
              color: "#0F172A",
              lineHeight: 1.25,
              textAlign: "center",
              maxWidth: "920px",
              display: "flex",
            }}
          >
            {truncated}
          </div>
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "12px",
              fontSize: "26px",
              fontWeight: 600,
              color: "#16A085",
            }}
          >
            <span>morroo.com</span>
            <span style={{ color: "#94A3B8" }}>·</span>
            <span style={{ color: "#475569" }}>Link in bio →</span>
          </div>
        </div>
      </div>
    ),
    { width: 1080, height: 260 },
  );
  return Buffer.from(await response.arrayBuffer());
}

/**
 * Compose a 9:16 (1080×1920) Story image from a square cover.
 *
 * Layout (vertical):
 *   y=0     – 200   blurred background, falls inside IG Story top safe area (~14%)
 *   y=200   – 1200  square cover 1000×1000 (headline/subtitle baked by gpt-image-1)
 *   y=1230  – 1490  CTA bar 1080×260 with article title + "morroo.com · Link in bio"
 *   y=1490  – 1920  blurred background, falls inside IG Story bottom safe area (~20%)
 *
 * Bottom safe area starts at ~1530 (20% of 1920); CTA ends at 1490 so it stays
 * above IG's reactions/swipe-up UI overlay.
 *
 * FB Stories + IG Stories share this asset; both accept JPEG ≤ 4 MB. q=90
 * keeps typography crisp while staying under the size limit.
 */
export async function composeStoryImage(
  coverBuffer: Buffer,
  options?: { headline?: string },
): Promise<Buffer> {
  const [bg, square, ctaBar] = await Promise.all([
    sharp(coverBuffer)
      .resize(1080, 1920, { fit: "cover" })
      .blur(40)
      .modulate({ brightness: 0.7 })
      .toBuffer(),
    sharp(coverBuffer).resize(1000, 1000, { fit: "cover" }).toBuffer(),
    renderCtaBar(options?.headline),
  ]);

  return sharp(bg)
    .composite([
      { input: square, top: 200, left: 40 },
      { input: ctaBar, top: 1230, left: 0 },
    ])
    .flatten({ background: "#ffffff" })
    .jpeg({ quality: 90 })
    .toBuffer();
}
