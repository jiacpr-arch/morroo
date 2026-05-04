import { ImageResponse } from "next/og";
import { NextRequest } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

const WIDTH = 1024;
const HEIGHT = 536;

export async function GET(req: NextRequest) {
  const slug = new URL(req.url).searchParams.get("slug");
  if (!slug) {
    return new Response("Missing slug", { status: 400 });
  }

  const supabase = createAdminClient();
  const { data: post } = await supabase
    .from("blog_posts")
    .select("title, description, content")
    .eq("slug", slug)
    .maybeSingle();

  if (!post) {
    return new Response("Post not found", { status: 404 });
  }

  // Extract first meaningful sentence from content for the quote
  const stripped = post.content.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
  const sentences = stripped.match(/[^.!?。]+[.!?。]?/g) ?? [];
  const quote =
    sentences.find((s: string) => s.trim().length >= 30 && s.trim().length <= 140)?.trim() ??
    post.description.slice(0, 120);

  return new ImageResponse(
    (
      <div
        style={{
          background: "linear-gradient(135deg, #16A085 0%, #1A2F23 100%)",
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
          padding: "48px 56px",
          fontFamily: "sans-serif",
        }}
      >
        {/* Brand */}
        <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
          <div style={{ fontSize: "32px" }}>🩺</div>
          <div style={{ fontSize: "28px", fontWeight: 700, color: "#ffffff", opacity: 0.9 }}>
            หมอรู้
          </div>
          <div
            style={{
              fontSize: "14px",
              color: "rgba(255,255,255,0.5)",
              marginLeft: "8px",
              marginTop: "6px",
            }}
          >
            บทความเตรียมสอบแพทย์
          </div>
        </div>

        {/* Quote */}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            gap: "20px",
          }}
        >
          <div style={{ fontSize: "22px", color: "rgba(255,255,255,0.45)", fontWeight: 700 }}>
            "
          </div>
          <div
            style={{
              fontSize: "26px",
              fontWeight: 600,
              color: "#ffffff",
              lineHeight: 1.5,
              maxWidth: "860px",
            }}
          >
            {quote}
          </div>
        </div>

        {/* Footer */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-end",
          }}
        >
          <div
            style={{
              fontSize: "16px",
              fontWeight: 600,
              color: "rgba(255,255,255,0.75)",
              maxWidth: "720px",
            }}
          >
            {post.title}
          </div>
          <div style={{ fontSize: "14px", color: "rgba(255,255,255,0.45)" }}>morroo.com</div>
        </div>
      </div>
    ),
    { width: WIDTH, height: HEIGHT }
  );
}
