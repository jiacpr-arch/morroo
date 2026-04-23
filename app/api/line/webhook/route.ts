import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, verifyLineSignature } from "@/lib/line";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("x-line-signature") ?? "";

  if (!verifyLineSignature(body, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const { events } = JSON.parse(body) as {
    events: Array<{
      type: string;
      source?: { userId?: string };
      message?: { type: string; text?: string };
    }>;
  };

  const supabase = createAdminClient();

  for (const event of events) {
    const lineUserId = event.source?.userId;
    if (!lineUserId) continue;

    // User added the OA
    if (event.type === "follow") {
      await sendLineMessage(lineUserId, [
        {
          type: "text",
          text: "ยินดีต้อนรับสู่ MorRoo! 🎉\n\nเชื่อมต่อบัญชีเพื่อรับการแจ้งเตือน:\n1. เปิดแอป MorRoo → Profile\n2. กด \"เชื่อมต่อ LINE\"\n3. Copy รหัส แล้วส่งมาที่นี่",
        },
      ]);
    }

    // User sent a message — check if it's a link code
    if (event.type === "message" && event.message?.type === "text") {
      const text = (event.message.text ?? "").trim().toUpperCase();

      if (!text.startsWith("MORROO-")) continue;

      const { data: linkCode, error: codeError } = await supabase
        .from("line_link_codes")
        .select("user_id, expires_at")
        .eq("code", text)
        .maybeSingle();

      if (codeError) {
        console.error("LINE link code lookup failed:", codeError);
        continue;
      }

      if (!linkCode) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ ไม่พบรหัสนี้ หรือรหัสหมดอายุแล้ว\n\nสร้างรหัสใหม่ได้ที่ Profile ในแอป MorRoo",
          },
        ]);
        continue;
      }

      if (new Date(linkCode.expires_at) < new Date()) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ รหัสหมดอายุแล้ว กรุณาสร้างรหัสใหม่ที่แอป MorRoo",
          },
        ]);
        continue;
      }

      // Check this LINE user isn't already linked to another account
      const { data: existing, error: existingError } = await supabase
        .from("profiles")
        .select("id")
        .eq("line_user_id", lineUserId)
        .maybeSingle();

      if (existingError) {
        console.error("LINE existing-link lookup failed:", existingError);
        continue;
      }

      if (existing && existing.id !== linkCode.user_id) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ LINE นี้เชื่อมต่อกับบัญชีอื่นอยู่แล้ว หากต้องการเปลี่ยน ติดต่อ support",
          },
        ]);
        continue;
      }

      // Link LINE user to profile
      const { error: linkError } = await supabase
        .from("profiles")
        .update({
          line_user_id: lineUserId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", linkCode.user_id);

      if (linkError) {
        console.error("Failed to link LINE user to profile:", linkError);
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ เกิดข้อผิดพลาดระหว่างเชื่อมต่อ กรุณาลองใหม่อีกครั้ง",
          },
        ]);
        continue;
      }

      // Delete used code
      const { error: deleteError } = await supabase
        .from("line_link_codes")
        .delete()
        .eq("code", text);

      if (deleteError) {
        // Linking succeeded — log but don't fail the flow.
        console.error("Failed to delete used LINE link code:", deleteError);
      }

      await sendLineMessage(lineUserId, [
        {
          type: "text",
          text: "✅ เชื่อมต่อ LINE สำเร็จ!\n\nคุณจะได้รับการแจ้งเตือนจาก MorRoo ผ่าน LINE แล้ว 🎉",
        },
      ]);
    }
  }

  return NextResponse.json({ ok: true });
}
