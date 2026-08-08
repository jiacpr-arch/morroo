import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Lock, Sparkles } from "lucide-react";

interface Props {
  /** หัวเรื่องสั้น ๆ ว่าอะไรถูกล็อก */
  title: string;
  /** อธิบายว่าจ่ายแล้วได้อะไรเพิ่ม */
  description: string;
  /** สิ่งที่ผู้ใช้ฟรียังทำได้ต่อ — ปิดท้ายด้วยทางออกที่ไม่ใช่จ่ายเงิน */
  fallbackHref?: string;
  fallbackLabel?: string;
}

/**
 * การ์ดกั้นของที่เป็นสิทธิ์ผู้จ่ายเงินในโหมด School
 * ใช้ตัวเดียวกันทุกที่เพื่อให้ข้อความ/ทางไปหน้าแพ็กเกจตรงกันหมด
 */
export default function UpgradeGate({
  title,
  description,
  fallbackHref = "/school",
  fallbackLabel = "กลับไปเรียนหัวข้อตัวอย่าง",
}: Props) {
  return (
    <Card className="border-brand/30 bg-brand/5">
      <CardContent className="p-8 text-center space-y-4">
        <div className="mx-auto h-12 w-12 rounded-full bg-brand/10 flex items-center justify-center">
          <Lock className="h-6 w-6 text-brand" />
        </div>
        <h2 className="text-xl font-bold">{title}</h2>
        <p className="text-sm text-muted-foreground max-w-md mx-auto">
          {description}
        </p>
        <div className="flex flex-col sm:flex-row gap-3 justify-center pt-2">
          <Link href="/pricing#school">
            <Button className="gap-2 bg-brand hover:bg-brand-light text-white">
              <Sparkles className="h-4 w-4" /> ดูแพ็กเกจ School
            </Button>
          </Link>
          <Link href={fallbackHref}>
            <Button variant="outline">{fallbackLabel}</Button>
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
