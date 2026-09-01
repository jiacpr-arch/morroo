import type { BlueprintWithTopics } from "@/lib/types-board";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function BoardBlueprintTable({
  blueprints,
}: {
  blueprints: BlueprintWithTopics[];
}) {
  if (blueprints.length === 0) return null;

  const year = blueprints[0].exam_year;
  const totalQuestions = blueprints.reduce(
    (sum, b) => sum + b.question_count,
    0
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-2">
        <div>
          <h2 className="text-xl font-bold">โครงสอบ (Blueprint)</h2>
          <p className="text-sm text-muted-foreground mt-1">
            ตามเกณฑ์ราชวิทยาลัย ปี พ.ศ. {year} · รวม {totalQuestions} ข้อ
          </p>
        </div>
      </div>

      {blueprints.map((bp) => (
        <Card key={bp.id}>
          <CardContent className="pt-5">
            <div className="flex items-start justify-between gap-3 mb-3 flex-wrap">
              <div>
                <h3 className="font-bold">{bp.section_label_th}</h3>
                {bp.section_label_en && (
                  <p className="text-xs text-muted-foreground">
                    {bp.section_label_en}
                  </p>
                )}
              </div>
              <Badge className="bg-brand/10 text-brand">
                {bp.question_count} ข้อ
              </Badge>
            </div>

            {bp.topics.length > 0 && (
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-xs text-muted-foreground border-b">
                      <th className="py-1.5 text-left font-medium">หมวด</th>
                      <th className="py-1.5 text-center font-medium w-16">เด็ก</th>
                      <th className="py-1.5 text-center font-medium w-16">ผู้ใหญ่</th>
                      <th className="py-1.5 text-center font-medium w-16">อื่น</th>
                      <th className="py-1.5 text-center font-medium w-16">รวม</th>
                    </tr>
                  </thead>
                  <tbody>
                    {bp.topics.map((t) => (
                      <tr key={t.id} className="border-b last:border-0">
                        <td className="py-1.5 pr-2">
                          <div>{t.name_th}</div>
                          {t.name_en && (
                            <div className="text-xs text-muted-foreground">
                              {t.name_en}
                            </div>
                          )}
                        </td>
                        <td className="py-1.5 text-center text-muted-foreground">
                          {t.peds_count || "-"}
                        </td>
                        <td className="py-1.5 text-center text-muted-foreground">
                          {t.adult_count || "-"}
                        </td>
                        <td className="py-1.5 text-center text-muted-foreground">
                          {t.other_count || "-"}
                        </td>
                        <td className="py-1.5 text-center font-medium">
                          {t.total_count}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
