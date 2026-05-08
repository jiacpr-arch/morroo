import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import RedeemAction from "./RedeemAction";

export const dynamic = "force-dynamic";

type Params = Promise<{ code: string }>;

export default async function RedeemPage({ params }: { params: Params }) {
  const { code: rawCode } = await params;
  const code = rawCode.trim().toUpperCase();

  const supabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect(`/login?next=/redeem/${encodeURIComponent(code)}`);
  }

  const admin = createAdminClient();
  const { data: row } = await admin
    .from("redeem_codes")
    .select("code, reward_type, expires_at, redeemed_at, redeemed_by")
    .eq("code", code)
    .maybeSingle();

  const now = new Date();
  const status = !row
    ? "not_found"
    : row.redeemed_at
      ? row.redeemed_by === user.id
        ? "redeemed_by_self"
        : "already_redeemed"
      : new Date(row.expires_at) < now
        ? "expired"
        : "ready";

  return (
    <main className="flex min-h-screen items-center justify-center bg-gradient-to-b from-teal-50 to-white px-4 py-12">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex h-14 w-14 items-center justify-center rounded-full bg-teal-600 text-white text-2xl">
            🎁
          </div>
          <h1 className="text-xl font-semibold">รับสิทธิ์ Morroo</h1>
          <p className="mt-1 font-mono text-sm text-muted-foreground">
            {code}
          </p>
        </CardHeader>
        <CardContent className="space-y-4 text-center">
          {status === "ready" && row && (
            <RedeemAction code={code} rewardType={row.reward_type} />
          )}

          {status === "redeemed_by_self" && (
            <>
              <p className="text-base font-medium text-teal-700">
                คุณใช้โค้ดนี้ไปแล้ว ✓
              </p>
              <p className="text-sm text-muted-foreground">
                สิทธิ์ของคุณพร้อมใช้งานในแดชบอร์ด
              </p>
              <Link href="/dashboard">
                <Button className="w-full">ไปหน้าแดชบอร์ด</Button>
              </Link>
            </>
          )}

          {status === "already_redeemed" && (
            <>
              <p className="text-base font-medium text-red-600">
                โค้ดนี้ถูกใช้ไปแล้ว
              </p>
              <p className="text-sm text-muted-foreground">
                แต่ละโค้ดใช้ได้เพียงครั้งเดียว
              </p>
              <Link href="/dashboard">
                <Button variant="outline" className="w-full">
                  ไปหน้าแดชบอร์ด
                </Button>
              </Link>
            </>
          )}

          {status === "expired" && (
            <>
              <p className="text-base font-medium text-red-600">
                โค้ดหมดอายุแล้ว
              </p>
              <p className="text-sm text-muted-foreground">
                โค้ดมีอายุ 7 วันนับจากวันที่ออก
              </p>
              <Link href="/pricing">
                <Button variant="outline" className="w-full">
                  ดูแพ็กเกจ
                </Button>
              </Link>
            </>
          )}

          {status === "not_found" && (
            <>
              <p className="text-base font-medium text-red-600">
                ไม่พบโค้ดนี้
              </p>
              <p className="text-sm text-muted-foreground">
                ตรวจสอบให้แน่ใจว่าพิมพ์โค้ดถูกต้อง
              </p>
              <Link href="/">
                <Button variant="outline" className="w-full">
                  กลับหน้าแรก
                </Button>
              </Link>
            </>
          )}
        </CardContent>
      </Card>
    </main>
  );
}
