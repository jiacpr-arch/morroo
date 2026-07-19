import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const HIGHLIGHTS = [
  {
    title: "Code Blue Sim",
    body: "จำลองสถานการณ์ช่วยชีวิตแบบ branching case ฝึกตัดสินใจภายใต้เวลาจริง",
  },
  {
    title: "คลังความรู้ + ยา ACLS",
    body: "อัลกอริทึม Tachycardia / Bradycardia / Stroke / MI-ACS พร้อมเครื่องคำนวณยา",
  },
  {
    title: "สอบ + ใบเซอร์",
    body: "สอบก่อน-หลังเรียน ผ่านเกณฑ์รับใบประกาศมาตรฐาน ILCOR 2025 อายุ 2 ปี",
  },
];

export default function AclsCourseHomePage() {
  return (
    <div className="mx-auto max-w-5xl px-4 py-12">
      <div className="flex flex-col items-start gap-4">
        <Badge variant="outline">มาตรฐาน ILCOR-ACLS-2025</Badge>
        <h1 className="font-heading text-3xl font-semibold sm:text-4xl">
          หลักสูตร ACLS Provider
        </h1>
        <p className="max-w-2xl text-muted-foreground">
          Advanced Cardiovascular Life Support สำหรับแพทย์และพยาบาล — เรียนออนไลน์,
          ฝึกผ่าน Code Blue Sim, สอบและรับใบเซอร์ โดย Jia Training Center
        </p>
      </div>

      <div className="mt-10 grid gap-4 sm:grid-cols-3">
        {HIGHLIGHTS.map((item) => (
          <Card key={item.title}>
            <CardHeader>
              <CardTitle>{item.title}</CardTitle>
            </CardHeader>
            <CardContent className="text-sm text-muted-foreground">
              {item.body}
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
