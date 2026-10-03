// POST — "ติดตั้ง rich menu": สร้าง LINE rich menu จาก public/line/rich-menu-main.jpg
// แล้วตั้งเป็น default ให้ทุกคน (ดู lib/line-menu.ts). Admin only.

import { NextResponse, type NextRequest } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { installRichMenu, RICH_MENU_IMAGE_PATH } from "@/lib/line-menu";

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(req: NextRequest) {
  const admin = await requireAdmin();
  if (!admin.ok) return admin.response;

  const img = await fetch(new URL(RICH_MENU_IMAGE_PATH, req.nextUrl.origin));
  if (!img.ok) {
    return NextResponse.json(
      { error: `โหลดรูปเมนูไม่ได้ (${img.status}) — วางรูปที่ public${RICH_MENU_IMAGE_PATH} ก่อน` },
      { status: 500 }
    );
  }

  try {
    const data = await installRichMenu(
      await img.arrayBuffer(),
      img.headers.get("content-type") ?? "image/jpeg"
    );
    return NextResponse.json({ ok: true, data });
  } catch (err) {
    console.error("[admin/line/rich-menu]", err);
    return NextResponse.json({ error: "ติดตั้ง rich menu ไม่สำเร็จ — ดู log" }, { status: 500 });
  }
}
