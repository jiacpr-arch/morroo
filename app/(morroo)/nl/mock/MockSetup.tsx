"use client";

import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Clock, ArrowRight } from "lucide-react";
import { useRouter } from "next/navigation";

const EXAM_OPTIONS = [
  { count: 20, label: "20 ข้อ", time: "20 นาที", description: "ทดลองสั้น" },
  { count: 50, label: "50 ข้อ", time: "50 นาที", description: "ซ้อมกลาง" },
  {
    count: 100,
    label: "100 ข้อ",
    time: "100 นาที",
    description: "เหมือนสอบจริง",
  },
];

export default function MockSetup() {
  const router = useRouter();

  return (
    <div className="space-y-6">
      <h2 className="text-lg font-bold">เลือกจำนวนข้อสอบ</h2>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {EXAM_OPTIONS.map((opt) => (
          <Card
            key={opt.count}
            className="group hover:shadow-lg hover:border-brand/30 transition-all cursor-pointer"
            onClick={() => router.push(`/nl/mock?count=${opt.count}`)}
          >
            <CardContent className="p-6 text-center">
              <p className="text-3xl font-bold text-brand mb-2">{opt.count}</p>
              <p className="font-medium mb-1">ข้อ</p>
              <Badge
                variant="secondary"
                className="bg-blue-100 text-blue-700 gap-1 mb-2"
              >
                <Clock className="h-3 w-3" /> {opt.time}
              </Badge>
              <p className="text-xs text-muted-foreground">{opt.description}</p>
              <Button
                className="w-full mt-4 bg-brand hover:bg-brand-light text-white gap-2"
                size="sm"
              >
                เริ่มสอบ <ArrowRight className="h-4 w-4" />
              </Button>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="text-sm text-muted-foreground space-y-1">
        <p>
          <strong>หมายเหตุ:</strong>
        </p>
        <ul className="list-disc pl-5 space-y-1">
          <li>ข้อสอบสุ่มคละจากทุกสาขาวิชา</li>
          <li>จับเวลา 1 นาทีต่อข้อ</li>
          <li>ดูเฉลยได้หลังส่งข้อสอบเท่านั้น</li>
          <li>สามารถข้ามไปทำข้อไหนก่อนก็ได้</li>
        </ul>
      </div>
    </div>
  );
}
