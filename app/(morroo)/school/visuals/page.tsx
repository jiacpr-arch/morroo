import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Image as ImageIcon } from "lucide-react";
import { getSchoolVisuals } from "@/lib/supabase/queries-school";
import VisualCard from "@/components/school/VisualCard";

export const revalidate = 60;

export const metadata = {
  title: "Visual Summaries — School",
  description: "รูปสรุป + ช็อตโน้ต — เรียนจากรูปได้ง่ายขึ้น",
};

export default async function VisualsIndexPage() {
  const visuals = await getSchoolVisuals({});

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-fuchsia-100 text-fuchsia-700">Visuals</Badge>
        <Badge variant="outline">{visuals.length} cards</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <ImageIcon className="h-6 w-6 text-fuchsia-600" /> Visual Summaries
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        รูปสรุป + ช็อตโน้ต + quick check + flashcards inline — dual coding (Paivio) สำหรับการจำ
      </p>

      {visuals.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี visual summaries — admin เพิ่มได้ที่ `/admin/school` tab Visual
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {visuals.map((v) => (
            <VisualCard key={v.id} visual={v} />
          ))}
        </div>
      )}
    </div>
  );
}
