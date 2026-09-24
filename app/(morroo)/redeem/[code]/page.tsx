import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import RedeemAction from "./RedeemAction";
import { couponRewardLabel, isSelfServeCoupon } from "@/lib/coupons";
import { hasUsedTrial } from "@/lib/redeem";

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
  let status: string = !row
    ? "not_found"
    : row.redeemed_at
      ? row.redeemed_by === user.id
        ? "redeemed_by_self"
        : "already_redeemed"
      : new Date(row.expires_at) < now
        ? "expired"
        : "ready";
  if (status === "ready" && row?.reward_type === "monthly_1m" && (await hasUsedTrial(user.id))) {
    status = "trial_used";
  }
  let rewardType: string | null = row?.reward_type ?? null;
  let rewardLabel: string | null = null;

  // Not a lead code → admin-issued coupon (coupon_codes)? Mirrors the rules in
  // the redeem_coupon_code RPC so the page can show the right state up front.
  if (!row) {
    const { data: coupon } = await admin
      .from("coupon_codes")
      .select("id, coupon_type, value, platform, is_active, starts_at, expires_at, max_uses, current_uses, max_uses_per_user")
      .eq("code", code)
      .maybeSingle();
    if (coupon) {
      const { count: mine } = await admin
        .from("coupon_redemptions")
        .select("id", { count: "exact", head: true })
        .eq("coupon_id", coupon.id)
        .eq("user_id", user.id);
      rewardType = coupon.coupon_type;
      rewardLabel = couponRewardLabel(coupon.coupon_type, coupon.value);
      status =
        (mine ?? 0) >= (coupon.max_uses_per_user ?? 1)
          ? "redeemed_by_self"
          : !isSelfServeCoupon(coupon.coupon_type)
            ? "checkout_only"
            : !coupon.is_active || (coupon.platform !== "all" && coupon.platform !== "medical")
              ? "not_found"
              : coupon.expires_at && new Date(coupon.expires_at) <= now
                ? "expired"
                : coupon.max_uses != null && (coupon.current_uses ?? 0) >= coupon.max_uses
                  ? "exhausted"
                  : coupon.starts_at && new Date(coupon.starts_at) > now
                    ? "not_started"
                    : "ready";
    }
  }

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
          {status === "ready" && rewardType && (
            <RedeemAction code={code} rewardType={rewardType} rewardLabel={rewardLabel} />
          )}

          {status === "exhausted" && (
            <>
              <p className="text-base font-medium text-red-600">
                โค้ดนี้ถูกใช้ครบจำนวนแล้ว
              </p>
              <Link href="/pricing">
                <Button variant="outline" className="w-full">
                  ดูแพ็กเกจ
                </Button>
              </Link>
            </>
          )}

          {status === "trial_used" && (
            <>
              <p className="text-base font-medium text-amber-600">
                บัญชีนี้ใช้สิทธิ์ทดลองฟรีไปแล้ว
              </p>
              <p className="text-sm text-muted-foreground">
                สิทธิ์ทดลองใช้ได้ 1 ครั้งต่อบัญชี
              </p>
              <Link href="/pricing">
                <Button className="w-full">ดูแพ็กเกจ</Button>
              </Link>
            </>
          )}

          {status === "not_started" && (
            <>
              <p className="text-base font-medium text-amber-600">
                โค้ดนี้ยังไม่เปิดใช้งาน
              </p>
              <p className="text-sm text-muted-foreground">
                ลองใหม่อีกครั้งเมื่อถึงวันเริ่มแคมเปญ
              </p>
            </>
          )}

          {status === "checkout_only" && (
            <>
              <p className="text-base font-medium text-teal-700">
                {rewardLabel}
              </p>
              <p className="text-sm text-muted-foreground">
                โค้ดส่วนลดใช้ตอนชำระเงิน — แจ้งโค้ดนี้พร้อมส่งสลิป
              </p>
              <Link href="/pricing">
                <Button className="w-full">ดูแพ็กเกจ</Button>
              </Link>
            </>
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
                โค้ดนี้เลยวันหมดอายุแล้ว
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
