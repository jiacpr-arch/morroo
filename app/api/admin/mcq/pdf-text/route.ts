import { NextRequest, NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";

// Server-side PDF text extraction fallback. The browser pdf.js (v6) can't parse
// some old PDFs (e.g. NL1 exam papers) — this uses pdf-parse (a different pdf.js
// build, v5) on the server, which tolerates those files.

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(req: NextRequest) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  let file: File | null = null;
  try {
    const form = await req.formData();
    const f = form.get("file");
    if (f instanceof File) file = f;
  } catch {
    return NextResponse.json({ error: "อ่านไฟล์ที่อัปโหลดไม่ได้" }, { status: 400 });
  }
  if (!file) return NextResponse.json({ error: "ไม่พบไฟล์" }, { status: 400 });

  const data = new Uint8Array(await file.arrayBuffer());
  try {
    const mod = (await import("pdf-parse")) as unknown as {
      PDFParse: new (opts: { data: Uint8Array }) => {
        getText: () => Promise<{ text?: string; total?: number }>;
        destroy?: () => Promise<void> | void;
      };
    };
    const parser = new mod.PDFParse({ data });
    const result = await parser.getText();
    await parser.destroy?.();
    return NextResponse.json({ text: result.text ?? "", pages: result.total ?? 0 });
  } catch (e) {
    return NextResponse.json(
      { error: `อ่าน PDF ฝั่ง server ไม่สำเร็จ: ${String(e).slice(0, 200)}` },
      { status: 502 }
    );
  }
}
