import { ImageResponse } from "next/og";

export const runtime = "edge";
export const alt = "หมอรู้ MorRoo — เตรียมสอบแพทย์ด้วย AI";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default function OGImage() {
  return new ImageResponse(
    (
      <div
        style={{
          background: "linear-gradient(135deg, #16A085 0%, #1A2F23 100%)",
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          fontFamily: "sans-serif",
          padding: "60px",
        }}
      >
        {/* Logo area */}
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: "20px",
            marginBottom: "40px",
          }}
        >
          <div
            style={{
              fontSize: "72px",
              lineHeight: 1,
            }}
          >
            🩺
          </div>
          <div
            style={{
              fontSize: "64px",
              fontWeight: 700,
              color: "#ffffff",
              letterSpacing: "-1px",
            }}
          >
            หมอรู้
          </div>
        </div>

        {/* Tagline */}
        <div
          style={{
            fontSize: "36px",
            fontWeight: 600,
            color: "#ffffff",
            textAlign: "center",
            marginBottom: "24px",
            opacity: 0.95,
          }}
        >
          เตรียมสอบแพทย์ ด้วย AI ที่เข้าใจคุณ
        </div>

        {/* Features */}
        <div
          style={{
            display: "flex",
            gap: "24px",
            marginTop: "8px",
          }}
        >
          {["MEQ", "MCQ 1,300+ ข้อ", "Long Case AI"].map((feature) => (
            <div
              key={feature}
              style={{
                background: "rgba(255,255,255,0.15)",
                border: "1px solid rgba(255,255,255,0.3)",
                borderRadius: "40px",
                padding: "10px 24px",
                fontSize: "22px",
                color: "#ffffff",
                fontWeight: 500,
              }}
            >
              {feature}
            </div>
          ))}
        </div>

        {/* Domain */}
        <div
          style={{
            position: "absolute",
            bottom: "40px",
            right: "60px",
            fontSize: "20px",
            color: "rgba(255,255,255,0.6)",
          }}
        >
          morroo.com
        </div>
      </div>
    ),
    { ...size }
  );
}
