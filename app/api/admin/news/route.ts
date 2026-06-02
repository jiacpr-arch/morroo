import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

const ALLOWED_TYPES = ["product_update", "exam"] as const;
const ALLOWED_SECTIONS = [
  "exams",
  "school",
  "longcase",
  "acls",
  "nl",
] as const;

async function requireAdmin(): Promise<NextResponse | null> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();
  if ((profile as { role?: string } | null)?.role !== "admin") {
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }
  return null;
}

export async function GET() {
  const denied = await requireAdmin();
  if (denied) return denied;
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("news_items")
    .select("*")
    .order("pinned", { ascending: false })
    .order("published_at", { ascending: false })
    .limit(200);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ items: data ?? [] });
}

export async function POST(request: Request) {
  const denied = await requireAdmin();
  if (denied) return denied;

  let body: {
    source_type?: string;
    source_section?: string | null;
    title?: string;
    summary?: string;
    body?: string | null;
    link?: string | null;
    cover_image?: string | null;
    pinned?: boolean;
    published_at?: string;
  };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  if (
    !body.source_type ||
    !ALLOWED_TYPES.includes(body.source_type as (typeof ALLOWED_TYPES)[number])
  ) {
    return NextResponse.json(
      { error: `source_type must be one of: ${ALLOWED_TYPES.join(", ")}` },
      { status: 400 },
    );
  }
  if (!body.title?.trim() || !body.summary?.trim()) {
    return NextResponse.json(
      { error: "title and summary are required" },
      { status: 400 },
    );
  }
  if (
    body.source_section &&
    !ALLOWED_SECTIONS.includes(
      body.source_section as (typeof ALLOWED_SECTIONS)[number],
    )
  ) {
    return NextResponse.json(
      { error: `source_section must be one of: ${ALLOWED_SECTIONS.join(", ")}` },
      { status: 400 },
    );
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("news_items")
    .insert({
      source_type: body.source_type,
      source_section: body.source_section || null,
      title: body.title.trim(),
      summary: body.summary.trim(),
      body: body.body?.trim() || null,
      link: body.link?.trim() || null,
      cover_image: body.cover_image?.trim() || null,
      pinned: !!body.pinned,
      published_at: body.published_at || new Date().toISOString(),
    })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ item: data });
}
