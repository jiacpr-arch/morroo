import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

export async function POST(request: Request) {
  const body = await request.json();
  const { category, rating, message, email } = body;

  if (!message || typeof message !== "string" || message.trim().length === 0) {
    return NextResponse.json({ error: "Message is required" }, { status: 400 });
  }

  const supabase = createAdminClient();

  const { error } = await supabase.from("feedbacks").insert({
    category: category || "other",
    rating: typeof rating === "number" ? rating : null,
    message: message.trim(),
    email: email || null,
  });

  if (error) {
    console.error("[feedback] save error:", error);
    return NextResponse.json({ error: "Failed to save feedback" }, { status: 500 });
  }

  return NextResponse.json({ success: true });
}
