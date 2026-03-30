"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { User, Mail, Crown, Calendar, LogOut, Award, Ticket } from "lucide-react";
import type { Profile } from "@/lib/types";
import { BADGE_ICONS, type UserBadge } from "@/lib/types-standard";

const membershipLabels: Record<string, string> = {
  free: "ฟรี",
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
};

const membershipColors: Record<string, string> = {
  free: "bg-gray-100 text-gray-700",
  monthly: "bg-brand/10 text-brand",
  yearly: "bg-amber-100 text-amber-700",
  bundle: "bg-blue-100 text-blue-700",
};

export default function ProfilePage() {
  const router = useRouter();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [userEmail, setUserEmail] = useState("");
  const [badges, setBadges] = useState<UserBadge[]>([]);

  useEffect(() => {
    async function loadProfile() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      setUserEmail(user.email || "");

      const { data } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", user.id)
        .single();

      setProfile(data);

      // Load user badges
      const { data: badgeData } = await supabase
        .from("user_badges")
        .select("*, badges(*)")
        .eq("user_id", user.id)
        .order("earned_at", { ascending: false });
      setBadges((badgeData as UserBadge[]) || []);

      setLoading(false);
    }
    loadProfile();
  }, [router]);

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/");
    router.refresh();
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[calc(100vh-12rem)]">
        <p className="text-muted-foreground">กำลังโหลด...</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 className="text-3xl font-bold mb-8">โปรไฟล์</h1>

      <div className="space-y-6">
        {/* Profile Info */}
        <Card>
          <CardHeader>
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center">
                <User className="h-8 w-8 text-brand" />
              </div>
              <div>
                <h2 className="text-xl font-bold">
                  {profile?.name || "ผู้ใช้งาน"}
                </h2>
                <p className="text-sm text-muted-foreground flex items-center gap-1">
                  <Mail className="h-3.5 w-3.5" />
                  {profile?.email || userEmail}
                </p>
              </div>
            </div>
          </CardHeader>
        </Card>

        {/* Membership */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Crown className="h-5 w-5 text-brand" /> สถานะสมาชิก
            </h3>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">แพ็กเกจ</span>
              <Badge
                className={
                  membershipColors[profile?.membership_type || "free"]
                }
              >
                {membershipLabels[profile?.membership_type || "free"]}
              </Badge>
            </div>
            {profile?.membership_expires_at && (
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground flex items-center gap-1">
                  <Calendar className="h-4 w-4" /> วันหมดอายุ
                </span>
                <span className="text-sm font-medium">
                  {new Date(
                    profile.membership_expires_at
                  ).toLocaleDateString("th-TH", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </span>
              </div>
            )}
            {(!profile || profile.membership_type === "free") && (
              <Link href="/pricing">
                <Button className="w-full bg-brand hover:bg-brand-light text-white mt-2">
                  อัปเกรดแพ็กเกจ
                </Button>
              </Link>
            )}
          </CardContent>
        </Card>

        {/* Badges */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Award className="h-5 w-5 text-yellow-500" /> เหรียญรางวัล
            </h3>
          </CardHeader>
          <CardContent>
            {badges.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                ยังไม่มีเหรียญ — ทำข้อสอบและเข้าร่วม Challenge เพื่อสะสม!
              </p>
            ) : (
              <div className="flex flex-wrap gap-3">
                {badges.map((ub) => (
                  <div
                    key={ub.id}
                    className="flex items-center gap-2 rounded-lg border px-3 py-2 bg-yellow-50"
                  >
                    <span className="text-xl">
                      {ub.badges
                        ? BADGE_ICONS[ub.badges.condition_type] || "🏅"
                        : "🏅"}
                    </span>
                    <div>
                      <p className="text-sm font-medium">
                        {ub.badges?.name_th || "Badge"}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {new Date(ub.earned_at).toLocaleDateString("th-TH")}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Coupon */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Ticket className="h-5 w-5 text-green-600" /> คูปอง
            </h3>
          </CardHeader>
          <CardContent>
            <Link href="/redeem">
              <Button variant="outline" className="w-full gap-2">
                <Ticket className="h-4 w-4" /> ใช้โค้ดคูปอง
              </Button>
            </Link>
          </CardContent>
        </Card>

        {/* Logout */}
        <Button
          variant="outline"
          className="w-full gap-2 text-destructive border-destructive/30 hover:bg-destructive/5"
          onClick={handleLogout}
        >
          <LogOut className="h-4 w-4" /> ออกจากระบบ
        </Button>
      </div>
    </div>
  );
}
