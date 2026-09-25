import Link from "next/link";
import { redirect } from "next/navigation";
import type { Metadata } from "next";
import { Users } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PLAN_CATALOG, PRODUCT_INFO } from "@/lib/membership";
import {
  JOIN_RESULT_MESSAGE,
  checkJoin,
  normalizeJoinCode,
  orgPlan,
  seatsRemaining,
} from "@/lib/organizations";
import { getOrgByCode, getOrgRole } from "@/lib/organizations-server";
import JoinOrgAction from "./JoinOrgAction";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "เข้าร่วมกลุ่ม — MorRoo",
  robots: { index: false, follow: false },
};

type Params = Promise<{ code: string }>;

export default async function JoinOrgPage({ params }: { params: Params }) {
  const { code: rawCode } = await params;
  const code = normalizeJoinCode(decodeURIComponent(rawCode));

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    redirect(`/login?next=/org/join/${encodeURIComponent(code ?? rawCode)}`);
  }

  const found = code ? await getOrgByCode(code) : null;
  const role = found ? await getOrgRole(found.org.id, user.id) : null;
  const status = checkJoin(found?.org, found?.memberCount ?? 0, role !== null);
  const plan = found ? PLAN_CATALOG[orgPlan(found.org.plan)] : null;

  return (
    <main className="flex min-h-[70vh] items-center justify-center bg-gradient-to-b from-brand/5 to-white px-4 py-12">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex h-14 w-14 items-center justify-center rounded-full bg-brand text-white">
            <Users className="h-7 w-7" />
          </div>
          <h1 className="text-xl font-semibold">
            {found ? found.org.name : "เข้าร่วมกลุ่ม"}
          </h1>
          {code && <p className="mt-1 font-mono text-sm text-muted-foreground">{code}</p>}
        </CardHeader>
        <CardContent className="space-y-4 text-center">
          {found && plan && (
            <div className="space-y-2 rounded-lg border bg-muted/40 p-3 text-sm">
              <p className="text-muted-foreground">สิทธิ์ที่สมาชิกกลุ่มได้รับ</p>
              <div className="flex flex-wrap justify-center gap-1.5">
                {plan.products.map((p) => (
                  <span key={p} className={`rounded-full px-2 py-0.5 text-xs ${PRODUCT_INFO[p].color}`}>
                    {PRODUCT_INFO[p].short}
                  </span>
                ))}
              </div>
              <p className="text-xs text-muted-foreground">
                ใช้ได้ถึง {new Date(found.org.expires_at).toLocaleDateString("th-TH", { dateStyle: "long" })}
                {" · "}เหลือ {seatsRemaining(found.org.seats, found.memberCount)} ที่นั่ง
              </p>
            </div>
          )}

          {status === "joined" && code && <JoinOrgAction code={code} />}

          {status === "already_member" && (
            <>
              <p className="text-base font-medium text-brand">{JOIN_RESULT_MESSAGE.already_member} ✓</p>
              <Link href={role === "owner" ? "/org" : "/dashboard"}>
                <Button className="w-full">{role === "owner" ? "ไปหน้าจัดการกลุ่ม" : "ไปหน้าแดชบอร์ด"}</Button>
              </Link>
            </>
          )}

          {(status === "full" || status === "expired" || status === "not_found") && (
            <>
              <p className="text-base font-medium text-red-600">{JOIN_RESULT_MESSAGE[status]}</p>
              <Link href={status === "not_found" ? "/org" : "/pricing"}>
                <Button variant="outline" className="w-full">
                  {status === "not_found" ? "ลองใส่รหัสใหม่" : "ดูแพ็กเกจรายบุคคล"}
                </Button>
              </Link>
            </>
          )}
        </CardContent>
      </Card>
    </main>
  );
}
