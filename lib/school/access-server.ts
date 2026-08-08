import { createClient } from "@/lib/supabase/server";
import {
  ANONYMOUS_SCHOOL_ACCESS,
  SCHOOL_ACCESS_FIELDS,
  schoolAccessFor,
  type SchoolAccess,
} from "./access";

/**
 * อ่าน session + สิทธิ์ School ในที่เดียว — เดิมทุกหน้าใน /school ก็อป
 * โค้ดชุด `supabase.auth.getUser()` + select profiles ซ้ำกันเอง
 */
export async function getSchoolAccess(): Promise<{
  userId: string | null;
  access: SchoolAccess;
}> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { userId: null, access: ANONYMOUS_SCHOOL_ACCESS };

  const { data: profile } = await supabase
    .from("profiles")
    .select(SCHOOL_ACCESS_FIELDS)
    .eq("id", user.id)
    .maybeSingle();

  return { userId: user.id, access: schoolAccessFor(profile) };
}
