import Link from "next/link";
import { redirect } from "next/navigation";
import type { Metadata } from "next";
import { Users } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { fetchOrgMemberships, isOrgActive } from "@/lib/organizations";
import { listOwnedOrgs, loadOrgDashboard } from "@/lib/organizations-server";
import JoinCodeForm from "./JoinCodeForm";
import OrgDashboard from "./OrgDashboard";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "กลุ่ม / สถาบัน — MorRoo",
  robots: { index: false, follow: false },
};

type SearchParams = Promise<{ [key: string]: string | string[] | undefined }>;

export default async function OrgPage({ searchParams }: { searchParams: SearchParams }) {
  const sp = await searchParams;
  const requestedId = typeof sp.id === "string" ? sp.id : null;

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/org");

  const [owned, { data: profile }, memberships] = await Promise.all([
    listOwnedOrgs(user.id),
    supabase.from("profiles").select("role").eq("id", user.id).maybeSingle(),
    fetchOrgMemberships(supabase, user.id),
  ]);
  const isSiteAdmin = (profile as { role?: string } | null)?.role === "admin";

  // Owners see their own orgs; site admins may open any org by ?id= (support).
  const selectedId =
    requestedId && (isSiteAdmin || owned.some((o) => o.id === requestedId))
      ? requestedId
      : owned[0]?.id ?? null;
  const data = selectedId ? await loadOrgDashboard(selectedId) : null;

  if (data) {
    return (
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
        {owned.length > 1 && (
          <div className="mb-4 flex flex-wrap gap-2 text-sm">
            {owned.map((o) => (
              <Link
                key={o.id}
                href={`/org?id=${o.id}`}
                className={`rounded-full border px-3 py-1 ${
                  o.id === data.org.id ? "border-brand bg-brand/10 text-brand" : "hover:border-brand"
                }`}
              >
                {o.name}
              </Link>
            ))}
          </div>
        )}
        <OrgDashboard data={data} currentUserId={user.id} />
      </div>
    );
  }

  // Not an owner → show the groups this user belongs to + a join-code box.
  return (
    <div className="mx-auto max-w-lg px-4 py-10 sm:px-6">
      <h1 className="mb-6 flex items-center gap-2 text-2xl font-bold">
        <Users className="h-6 w-6 text-brand" /> กลุ่ม / สถาบัน
      </h1>
      {memberships.length > 0 && (
        <Card className="mb-6">
          <CardHeader className="pb-2">
            <h2 className="font-semibold">กลุ่มของฉัน</h2>
          </CardHeader>
          <CardContent className="space-y-2">
            {memberships.map((m) => (
              <div key={m.org_id} className="flex items-center justify-between rounded-lg border px-3 py-2 text-sm">
                <span className="font-medium">{m.organizations?.name ?? "-"}</span>
                <span className={isOrgActive(m.organizations) ? "text-brand" : "text-red-600"}>
                  {isOrgActive(m.organizations)
                    ? `ใช้ได้ถึง ${new Date(m.organizations!.expires_at).toLocaleDateString("th-TH")}`
                    : "หมดอายุแล้ว"}
                </span>
              </div>
            ))}
          </CardContent>
        </Card>
      )}
      <Card>
        <CardHeader className="pb-2">
          <h2 className="font-semibold">มีรหัสกลุ่ม?</h2>
          <p className="text-sm text-muted-foreground">
            ใส่รหัสที่ได้จากผู้ดูแลกลุ่ม / อาจารย์ / ติวเตอร์ เพื่อใช้งานแบบพรีเมียมผ่านแพ็กเกจของกลุ่ม
          </p>
        </CardHeader>
        <CardContent>
          <JoinCodeForm />
        </CardContent>
      </Card>
      <p className="mt-6 text-center text-sm text-muted-foreground">
        อยากซื้อแพ็กเกจให้ทั้งกลุ่ม?{" "}
        <Link href="/pricing#group" className="text-brand hover:underline">
          ดูแพ็กเกจกลุ่ม / สถาบัน
        </Link>
      </p>
    </div>
  );
}
