import { createClient } from "@/lib/supabase/server";
import { hasScopedAccess } from "@/lib/membership";
import { fetchEntitlements } from "@/lib/entitlements";
import { schoolTopicScopes } from "./topic-access";

/**
 * ผู้ใช้คนนี้เปิดเนื้อหาเต็มของวิชานี้ได้ไหม (School ทั้งระบบ / ซื้อวิชา /
 * ซื้อทั้งชั้นปี) — ยังไม่ล็อกอินถือว่าไม่มีสิทธิ์ แต่ยังอ่านบทตัวอย่างได้
 */
export async function canOpenSchoolTopic(topic: {
  id: string;
  year: number;
}): Promise<boolean> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return false;

  const [{ data: profile }, entitlements] = await Promise.all([
    supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .maybeSingle(),
    fetchEntitlements(supabase, user.id),
  ]);

  return hasScopedAccess("school", schoolTopicScopes(topic), profile, entitlements);
}
