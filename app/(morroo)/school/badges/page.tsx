import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Award } from "lucide-react";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Badges — School",
  description: "เหรียญรางวัลที่ได้ + เป้าหมายต่อไป",
};

interface BadgeRow {
  id: string;
  slug: string;
  name_th: string;
  description: string | null;
  icon: string;
  xp_reward: number;
  sort_order: number;
}

export default async function BadgesPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const [allRes, ownedRes] = await Promise.all([
    supabase.from("school_badges").select("*").order("sort_order"),
    user
      ? supabase.from("school_user_badges").select("badge_id, earned_at").eq("user_id", user.id)
      : Promise.resolve({ data: [] }),
  ]);
  const all = (allRes.data as BadgeRow[]) ?? [];
  type Owned = { badge_id: string; earned_at: string };
  const ownedRows = (ownedRes.data as Owned[]) ?? [];
  const owned = new Map(ownedRows.map((b) => [b.badge_id, b.earned_at]));

  const earnedCount = ownedRows.length;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-amber-100 text-amber-700">Badges</Badge>
        <Badge variant="outline">{earnedCount} / {all.length}</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Award className="h-6 w-6 text-amber-600" /> เหรียญรางวัล
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ทำเป้าหมายต่างๆ เพื่อปลดล็อก + รับ XP โบนัส
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
        {all.map((b) => {
          const isOwned = owned.has(b.id);
          return (
            <Card
              key={b.id}
              className={isOwned ? "border-amber-300 bg-amber-50/50" : "opacity-70"}
            >
              <CardContent className="p-4 text-center space-y-2">
                <div className="text-4xl">{isOwned ? b.icon : "🔒"}</div>
                <h3 className="font-bold text-sm">{b.name_th}</h3>
                <p className="text-xs text-muted-foreground line-clamp-2">
                  {b.description}
                </p>
                <Badge variant="outline" className="text-xs">
                  +{b.xp_reward} XP
                </Badge>
                {isOwned && (
                  <p className="text-xs text-amber-700 italic">
                    ได้แล้ว ✓
                  </p>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
