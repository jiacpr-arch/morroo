import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const HIGHLIGHTS = [
  {
    title: "ฝึกสถานการณ์จำลอง",
    body: "ฝึก CPR คุณภาพสูง การช่วยเหลือผู้สำลัก และใช้ AED ผ่านสถานการณ์จำลอง",
  },
  {
    title: "แนวทางล่าสุด",
    body: "อัลกอริทึม BLS และการใช้ AED ตามมาตรฐาน ILCOR 2025",
  },
  {
    title: "สอบ + ใบเซอร์",
    body: "สอบก่อน-หลังเรียน ผ่านเกณฑ์รับใบประกาศ Healthcare Provider อายุ 2 ปี",
  },
];

export default function BlsCourseHomePage() {
  return (
    <div className="mx-auto max-w-5xl px-4 py-12">
      <div className="flex flex-col items-start gap-4">
        <Badge variant="outline">มาตรฐาน ILCOR-BLS-2025</Badge>
        <h1 className="font-heading text-3xl font-semibold sm:text-4xl">
          หลักสูตร BLS Provider
        </h1>
        <p className="max-w-2xl text-muted-foreground">
          Basic Life Support for Healthcare Providers สำหรับบุคลากรทางการแพทย์ —
          เรียนออนไลน์, ฝึกสถานการณ์จำลอง, สอบและรับใบเซอร์ โดย Jia Training Center
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
