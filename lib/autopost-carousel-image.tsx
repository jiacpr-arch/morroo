import type React from "react";
import sharp from "sharp";
import { ImageResponse } from "next/og";

/**
 * Compose IG carousel slides for a blog post.
 *
 * Returns 5 square (1080×1080) JPEG buffers:
 *   1. Branded cover slide — hook + title
 *   2-4. One bullet per slide with big ✓ + sub-text + "เลื่อนต่อ →"
 *   5. CTA "card link" slide — visually mimics a link preview card with
 *      site favicon-style mark, the article URL, and "Link in bio"
 *
 * IG carousels require all slides to share the same aspect ratio. 1:1 matches
 * the feed cover that the rest of the pipeline already uses.
 *
 * Rendering pipeline matches lib/autopost-story-image.tsx: next/og (Satori)
 * for the layout + sharp for the final JPEG flatten. Sharp's librsvg path
 * can't render Thai glyphs in this Vercel runtime — Satori can.
 *
 * Satori gotchas this file has hit:
 *   - Multi-child JSX text (`KEY POINT {index}`) renders as separate children
 *     and trips Satori's "parent must have display:flex" rule. We pre-compute
 *     all interpolated strings via template literals so each text-bearing div
 *     has a single string child.
 *   - `text-transform`, negative `letter-spacing`, and complex `box-shadow`
 *     are spotty in Satori — kept the design clean of those.
 */

const SLIDE_W = 1080;
const SLIDE_H = 1080;
const BRAND_GREEN = "#16A085";
const BRAND_DARK = "#1A2F23";
const BRAND_INK = "#0F172A";
const BRAND_MUTED = "#475569";

function BrandWordmark(): React.ReactElement {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
      <div
        style={{
          width: "44px",
          height: "44px",
          background: BRAND_GREEN,
          borderRadius: "12px",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          fontSize: "26px",
        }}
      >
        🩺
      </div>
      <div
        style={{
          display: "flex",
          fontSize: "26px",
          fontWeight: 800,
          color: BRAND_INK,
        }}
      >
        หมอรู้
      </div>
    </div>
  );
}

async function renderSlide(node: React.ReactElement, label: string): Promise<Buffer> {
  // Surface the actual Satori / sharp error to the caller — the catch-all in
  // ensureCarouselSlides only logs the wrapped error and Vercel truncates
  // multi-line stacks, so we annotate with which slide threw.
  try {
    const response = new ImageResponse(node, { width: SLIDE_W, height: SLIDE_H });
    const png = Buffer.from(await response.arrayBuffer());
    return await sharp(png).flatten({ background: "#ffffff" }).jpeg({ quality: 92 }).toBuffer();
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    throw new Error(`[carousel] slide "${label}" render failed: ${msg}`);
  }
}

function CoverSlide({ hook, title }: { hook: string; title: string }): React.ReactElement {
  const truncatedHook = hook.length > 90 ? `${hook.slice(0, 87).trimEnd()}…` : hook;
  const truncatedTitle = title.length > 80 ? `${title.slice(0, 77).trimEnd()}…` : title;
  return (
    <div
      style={{
        width: "100%",
        height: "100%",
        background: `linear-gradient(135deg, ${BRAND_GREEN} 0%, ${BRAND_DARK} 100%)`,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        padding: "64px 72px",
        fontFamily: "sans-serif",
      }}
    >
      <div style={{ display: "flex", alignItems: "center", gap: "14px" }}>
        <div style={{ display: "flex", fontSize: "38px" }}>🩺</div>
        <div style={{ display: "flex", fontSize: "30px", fontWeight: 800, color: "#ffffff" }}>
          หมอรู้
        </div>
        <div
          style={{
            display: "flex",
            fontSize: "18px",
            color: "rgba(255,255,255,0.7)",
            marginTop: "4px",
          }}
        >
          · เตรียมสอบแพทย์
        </div>
      </div>
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          gap: "28px",
        }}
      >
        <div
          style={{
            display: "flex",
            fontSize: "60px",
            fontWeight: 900,
            color: "#ffffff",
            lineHeight: 1.15,
            maxWidth: "920px",
          }}
        >
          {truncatedHook}
        </div>
        <div
          style={{
            display: "flex",
            fontSize: "26px",
            color: "rgba(255,255,255,0.8)",
            lineHeight: 1.4,
            maxWidth: "880px",
          }}
        >
          {truncatedTitle}
        </div>
      </div>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <div
          style={{
            display: "flex",
            fontSize: "22px",
            color: "rgba(255,255,255,0.6)",
          }}
        >
          เลื่อนดูทั้งหมด →
        </div>
        <div
          style={{
            display: "flex",
            fontSize: "20px",
            color: "rgba(255,255,255,0.45)",
          }}
        >
          1 / 5
        </div>
      </div>
    </div>
  );
}

function BulletSlide({
  bullet,
  index,
  total,
}: {
  bullet: string;
  index: number;
  total: number;
}): React.ReactElement {
  const truncated = bullet.length > 140 ? `${bullet.slice(0, 137).trimEnd()}…` : bullet;
  // Pre-compute interpolated strings so each text div has a single child —
  // Satori treats `KEY POINT {index}` as 2 children and demands display:flex
  // on the parent of multi-child text. Easier to enforce single-child.
  const keyPointLabel = `KEY POINT ${index}`;
  const pageLabel = `${index + 1} / ${total}`;
  return (
    <div
      style={{
        width: "100%",
        height: "100%",
        background: "#F8FAFC",
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        padding: "64px 72px",
        fontFamily: "sans-serif",
      }}
    >
      <BrandWordmark />
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          gap: "32px",
          maxWidth: "920px",
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: "18px",
          }}
        >
          <div
            style={{
              width: "78px",
              height: "78px",
              background: BRAND_GREEN,
              color: "#ffffff",
              borderRadius: "20px",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              fontSize: "44px",
              fontWeight: 900,
            }}
          >
            ✓
          </div>
          <div
            style={{
              display: "flex",
              fontSize: "22px",
              color: BRAND_MUTED,
              fontWeight: 700,
              letterSpacing: "2px",
            }}
          >
            {keyPointLabel}
          </div>
        </div>
        <div
          style={{
            display: "flex",
            fontSize: "52px",
            fontWeight: 800,
            color: BRAND_INK,
            lineHeight: 1.3,
          }}
        >
          {truncated}
        </div>
      </div>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
        }}
      >
        <div style={{ display: "flex", fontSize: "22px", color: BRAND_MUTED }}>
          เลื่อนต่อ →
        </div>
        <div style={{ display: "flex", fontSize: "20px", color: "#94A3B8" }}>
          {pageLabel}
        </div>
      </div>
    </div>
  );
}

function CtaCardSlide({
  title,
  articleUrl,
  lineHandle,
}: {
  title: string;
  articleUrl: string;
  lineHandle: string;
}): React.ReactElement {
  const hostPath = articleUrl.replace(/^https?:\/\//, "");
  const truncatedTitle = title.length > 80 ? `${title.slice(0, 77).trimEnd()}…` : title;
  const lineLine = `หรือ DM LINE ${lineHandle} เพื่อรับลิงก์`;
  // Visually mimic a link preview card: white card with a colored top strip,
  // big title, brand-green URL. IG strips clickable URLs from captions so the
  // card needs to *look* tappable — viewers screenshot/copy the URL or follow
  // "link in bio".
  return (
    <div
      style={{
        width: "100%",
        height: "100%",
        background: `linear-gradient(160deg, ${BRAND_DARK} 0%, #0B1A14 100%)`,
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        padding: "64px 72px",
        fontFamily: "sans-serif",
      }}
    >
      <div style={{ display: "flex", alignItems: "center", gap: "14px" }}>
        <div style={{ display: "flex", fontSize: "32px" }}>📖</div>
        <div style={{ display: "flex", fontSize: "28px", fontWeight: 800, color: "#ffffff" }}>
          อ่านบทความเต็มได้ที่
        </div>
      </div>

      <div
        style={{
          display: "flex",
          flexDirection: "column",
          background: "#ffffff",
          borderRadius: "24px",
          overflow: "hidden",
          border: "2px solid rgba(255,255,255,0.15)",
        }}
      >
        <div
          style={{
            height: "180px",
            background: `linear-gradient(135deg, ${BRAND_GREEN} 0%, #0E6B5A 100%)`,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: "20px",
          }}
        >
          <div style={{ display: "flex", fontSize: "60px" }}>🩺</div>
          <div
            style={{
              display: "flex",
              fontSize: "44px",
              fontWeight: 900,
              color: "#ffffff",
            }}
          >
            morroo.com
          </div>
        </div>
        <div
          style={{
            padding: "28px 32px",
            display: "flex",
            flexDirection: "column",
            gap: "14px",
          }}
        >
          <div
            style={{
              display: "flex",
              fontSize: "14px",
              fontWeight: 700,
              letterSpacing: "2px",
              color: "#94A3B8",
            }}
          >
            BLOG · MORROO.COM
          </div>
          <div
            style={{
              display: "flex",
              fontSize: "30px",
              fontWeight: 800,
              color: BRAND_INK,
              lineHeight: 1.25,
            }}
          >
            {truncatedTitle}
          </div>
          <div
            style={{
              display: "flex",
              fontSize: "20px",
              color: BRAND_GREEN,
              fontWeight: 600,
            }}
          >
            {hostPath}
          </div>
        </div>
      </div>

      <div
        style={{
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          gap: "8px",
        }}
      >
        <div
          style={{
            display: "flex",
            fontSize: "26px",
            color: "#ffffff",
            fontWeight: 700,
          }}
        >
          👉 แตะ Link in bio
        </div>
        <div
          style={{
            display: "flex",
            fontSize: "18px",
            color: "rgba(255,255,255,0.7)",
          }}
        >
          {lineLine}
        </div>
      </div>
    </div>
  );
}

export interface CarouselSlideInput {
  hook: string;
  title: string;
  bullets: string[];
  articleUrl: string;
  lineHandle?: string;
}

export async function composeCarouselSlides(input: CarouselSlideInput): Promise<Buffer[]> {
  const lineHandle = input.lineHandle ?? "@901nmwcd";
  // Exactly 5 slides: cover + 3 bullets + CTA. Pad/truncate bullets to 3.
  const bullets = input.bullets.slice(0, 3);
  while (bullets.length < 3) bullets.push("ทบทวนเข้มข้นก่อนสอบจริง");

  const total = 5;
  const slides: Buffer[] = [];
  slides.push(
    await renderSlide(
      <CoverSlide hook={input.hook} title={input.title} />,
      "cover",
    ),
  );
  for (let i = 0; i < 3; i++) {
    slides.push(
      await renderSlide(
        <BulletSlide bullet={bullets[i]} index={i + 1} total={total} />,
        `bullet-${i + 1}`,
      ),
    );
  }
  slides.push(
    await renderSlide(
      <CtaCardSlide
        title={input.title}
        articleUrl={input.articleUrl}
        lineHandle={lineHandle}
      />,
      "cta",
    ),
  );
  return slides;
}
