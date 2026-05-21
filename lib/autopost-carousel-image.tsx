import type React from "react";
import sharp from "sharp";
import { ImageResponse } from "next/og";

/**
 * Compose IG carousel slides for a blog post.
 *
 * Returns 5 square (1080×1080) JPEG buffers:
 *   1. Branded cover slide — hook + title
 *   2-4. One bullet per slide with big ✅ + sub-text + "เลื่อนต่อ →"
 *   5. CTA "card link" slide — visually mimics a link preview card with
 *      site favicon-style mark, the article URL, and "Link in bio"
 *
 * IG carousels require all slides to share the same aspect ratio. 1:1 matches
 * the feed cover that the rest of the pipeline already uses.
 *
 * Rendering pipeline matches lib/autopost-story-image.tsx: next/og (Satori)
 * for the layout + sharp for the final JPEG flatten. Sharp's librsvg path
 * can't render Thai glyphs in this Vercel runtime — Satori can.
 */

const SLIDE_W = 1080;
const SLIDE_H = 1080;
const BRAND_GREEN = "#16A085";
const BRAND_DARK = "#1A2F23";
const BRAND_INK = "#0F172A";
const BRAND_MUTED = "#475569";

function brandWordmark(): React.ReactElement {
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
          fontSize: "26px",
          fontWeight: 800,
          color: BRAND_INK,
          letterSpacing: "-0.3px",
        }}
      >
        หมอรู้
      </div>
    </div>
  );
}

async function renderSlide(node: React.ReactElement): Promise<Buffer> {
  const response = new ImageResponse(node, { width: SLIDE_W, height: SLIDE_H });
  // ImageResponse emits PNG. Convert to JPEG so IG accepts it — IG's container
  // endpoint rejects PNGs from some renderers ("Only photo or video can be
  // accepted as media type"); see lib/autopost-retry route for the same flatten.
  const png = Buffer.from(await response.arrayBuffer());
  return sharp(png).flatten({ background: "#ffffff" }).jpeg({ quality: 92 }).toBuffer();
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
        <div style={{ fontSize: "38px" }}>🩺</div>
        <div style={{ fontSize: "30px", fontWeight: 800, color: "#ffffff" }}>หมอรู้</div>
        <div style={{ fontSize: "18px", color: "rgba(255,255,255,0.6)", marginTop: "4px" }}>
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
            fontSize: "60px",
            fontWeight: 900,
            color: "#ffffff",
            lineHeight: 1.15,
            letterSpacing: "-1px",
            maxWidth: "920px",
            display: "flex",
          }}
        >
          {truncatedHook}
        </div>
        <div
          style={{
            fontSize: "26px",
            color: "rgba(255,255,255,0.75)",
            lineHeight: 1.4,
            maxWidth: "880px",
            display: "flex",
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
            fontSize: "22px",
            color: "rgba(255,255,255,0.6)",
          }}
        >
          เลื่อนดูทั้งหมด →
        </div>
        <div style={{ fontSize: "20px", color: "rgba(255,255,255,0.45)" }}>1 / 5</div>
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
      {brandWordmark()}
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
              fontSize: "22px",
              color: BRAND_MUTED,
              fontWeight: 700,
              letterSpacing: "2px",
            }}
          >
            KEY POINT {index}
          </div>
        </div>
        <div
          style={{
            fontSize: "52px",
            fontWeight: 800,
            color: BRAND_INK,
            lineHeight: 1.3,
            letterSpacing: "-0.5px",
            display: "flex",
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
        <div style={{ fontSize: "22px", color: BRAND_MUTED }}>เลื่อนต่อ →</div>
        <div style={{ fontSize: "20px", color: "#94A3B8" }}>
          {index + 1} / {total}
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
  // Visually mimic a Facebook/Messenger link preview card: white card,
  // colored top "image" strip, big title, gray subline with the URL. Since IG
  // strips clickable URLs from captions, the card needs to *look* tappable so
  // viewers screenshot/copy the URL — or follow the "link in bio".
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
        <div style={{ fontSize: "32px" }}>📖</div>
        <div style={{ fontSize: "28px", fontWeight: 800, color: "#ffffff" }}>
          อ่านบทความเต็มได้ที่
        </div>
      </div>

      {/* Card */}
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          background: "#ffffff",
          borderRadius: "24px",
          overflow: "hidden",
          boxShadow: "0 24px 60px rgba(0,0,0,0.4)",
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
          <div style={{ fontSize: "60px" }}>🩺</div>
          <div style={{ fontSize: "44px", fontWeight: 900, color: "#ffffff" }}>morroo.com</div>
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
              fontSize: "11px",
              fontWeight: 700,
              letterSpacing: "2px",
              color: "#94A3B8",
              textTransform: "uppercase",
              display: "flex",
            }}
          >
            BLOG · MORROO.COM
          </div>
          <div
            style={{
              fontSize: "30px",
              fontWeight: 800,
              color: BRAND_INK,
              lineHeight: 1.25,
              display: "flex",
            }}
          >
            {truncatedTitle}
          </div>
          <div
            style={{
              fontSize: "20px",
              color: BRAND_GREEN,
              fontWeight: 600,
              display: "flex",
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
            fontSize: "26px",
            color: "#ffffff",
            fontWeight: 700,
            display: "flex",
          }}
        >
          👉 แตะ Link in bio
        </div>
        <div
          style={{
            fontSize: "18px",
            color: "rgba(255,255,255,0.6)",
            display: "flex",
          }}
        >
          หรือ DM LINE {lineHandle} เพื่อรับลิงก์
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
  slides.push(await renderSlide(<CoverSlide hook={input.hook} title={input.title} />));
  for (let i = 0; i < 3; i++) {
    slides.push(
      await renderSlide(
        <BulletSlide bullet={bullets[i]} index={i + 1} total={total} />,
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
    ),
  );
  return slides;
}
