import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Network } from "lucide-react";
import { getSchoolConcepts } from "@/lib/supabase/queries-school";

export const revalidate = 60;

export const metadata = {
  title: "Concepts — Cross-subject Tags",
  description: "เชื่อมโยงเนื้อหาทุกปี/ทุกระบบผ่าน concept หลัก",
};

export default async function ConceptsIndexPage() {
  const concepts = await getSchoolConcepts();

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-cyan-100 text-cyan-700">Concepts</Badge>
        <Badge variant="outline">{concepts.length} concept</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Network className="h-6 w-6 text-cyan-600" /> Cross-subject Concepts
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        แต่ละ concept เชื่อม flashcard / lesson / quiz จากหลายปี/หลายระบบ —
        คลิกเพื่อเห็นทุกสิ่งที่เกี่ยวข้องในที่เดียว
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
        {concepts.map((c) => (
          <Link key={c.id} href={`/school/concept/${c.slug}`}>
            <Card className="hover:shadow-md hover:border-cyan-300 transition-all cursor-pointer h-full">
              <CardContent className="p-4 flex items-start gap-3">
                <span className="text-3xl">{c.icon}</span>
                <div className="flex-1 min-w-0">
                  <p className="font-bold">{c.name_th}</p>
                  <p className="text-xs text-muted-foreground mb-1">
                    {c.name_en}
                  </p>
                  {c.description && (
                    <p className="text-xs text-muted-foreground line-clamp-2">
                      {c.description}
                    </p>
                  )}
                </div>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
