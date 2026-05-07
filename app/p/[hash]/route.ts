import { redirect } from "next/navigation";
import crypto from "node:crypto";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ hash: string }> },
) {
  const { hash } = await params;
  const supabase = createAdminClient();
  const { data: posts } = await supabase.from("blog_posts").select("slug");

  const match = posts?.find(
    (p) =>
      crypto.createHash("md5").update(p.slug).digest("hex").slice(0, 6) ===
      hash,
  );

  redirect(match ? `/blog/${match.slug}` : "/blog");
}
