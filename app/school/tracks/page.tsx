import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Route } from "lucide-react";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

export const metadata = {
  title: "Learning Tracks — School",
  description: "Curated bundles (เช่น Approach to Chest Pain) ข้ามวิชา/ปี",
};

interface TrackRow {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  icon: string;
  audience_years: number[];
}

export default async function TracksPage() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("school_tracks")
    .select("*")
    .eq("status", "active")
    .order("sort_order");
  const tracks = (data as TrackRow[]) ?? [];

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-lime-100 text-lime-700">Tracks</Badge>
        <Badge variant="outline">{tracks.length} bundle</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Route className="h-6 w-6 text-lime-600" /> Curated Learning Tracks
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        Themed bundles — เช่น "Approach to chest pain" — รวม content จากหลาย topic/ปี ตามลำดับการคิด
      </p>

      {tracks.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี track — admin สร้างผ่าน Supabase Studio (Phase 8 จะมี UI)
        </div>
      ) : (
        <div className="space-y-3">
          {tracks.map((t) => (
            <Link key={t.id} href={`/school/track/${t.slug}`}>
              <Card className="hover:shadow-md hover:border-lime-300 transition-all cursor-pointer">
                <CardContent className="p-4 flex items-start gap-3">
                  <span className="text-3xl">{t.icon}</span>
                  <div className="flex-1 min-w-0">
                    <p className="font-bold">{t.title}</p>
                    <p className="text-xs text-muted-foreground mb-1">
                      Y{t.audience_years.join(", Y")}
                    </p>
                    {t.description && (
                      <p className="text-sm text-muted-foreground line-clamp-2">
                        {t.description}
                      </p>
                    )}
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
