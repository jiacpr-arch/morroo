"use client";

import Link from "next/link";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import {
  Shield, BookOpen, MessageCircleQuestion, Inbox, Images, BarChart3, Users, Video, School,
} from "lucide-react";

// ACLS/BLS admin section landing page — quick links to every sub-section.
// Ported from acls-emr's src/pages/AdminDashboard.jsx (its own top-level
// dashboard, not morroo's main /admin/page.tsx which links here via the
// "จัดการคอร์ส ACLS/BLS" card).
const SECTIONS = [
  {
    href: "/admin/acls/stats",
    title: "สถิติผู้เรียน",
    desc: "ดูจำนวนนักเรียน คลาส และใบประกาศนียบัตร รวมทุกคลาส",
    icon: BarChart3,
  },
  {
    href: "/admin/acls/students",
    title: "รายชื่อนักเรียน",
    desc: "รายชื่อ + เบอร์โทร ทุกคลาส · ค้นหา/Export CSV",
    icon: Users,
  },
  {
    href: "/admin/acls/classes",
    title: "คลาสทั้งหมด",
    desc: "รหัสเข้าคลาส + รหัสอาจารย์ทุกคลาส · กู้รหัส · ปิดคลาสที่จบแล้ว",
    icon: School,
  },
  {
    href: "/admin/acls/chapters",
    title: "คลังความรู้ ALS",
    desc: "แก้ไขบท หัวข้อ และเนื้อหา",
    icon: BookOpen,
  },
  {
    href: "/admin/acls/qa-deep",
    title: "Q&A ACLS เชิงลึก",
    desc: "เพิ่ม/แก้ไขคำถาม-คำตอบ จัดหมวดและรูป",
    icon: MessageCircleQuestion,
  },
  {
    href: "/admin/acls/precourse-images",
    title: "สื่อประกอบบทเรียน",
    desc: "เดินทีละหัวข้อเหมือนแอป — จัดการรูป + วิดีโอของแต่ละหัวข้อ",
    icon: Images,
  },
  {
    href: "/admin/acls/video-lessons",
    title: "วิดีโอบทเรียน",
    desc: "เพิ่ม/แก้คลิป YouTube + สรุป + สารบัญ + ควิซ (เป็นเงื่อนไขใบประกาศนียบัตร)",
    icon: Video,
  },
  {
    href: "/admin/acls/student-questions",
    title: "คำถามจากนักเรียน",
    desc: "ตรวจสอบและเผยแพร่คำถามที่ส่งเข้ามา",
    icon: Inbox,
  },
];

export default function AclsAdminDashboard() {
  const status = useAdminGate();
  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin" className="text-sm text-muted-foreground hover:text-foreground">
          ← Admin
        </Link>
      </div>

      <div className="flex items-center gap-3 mb-8">
        <div className="w-10 h-10 rounded-lg bg-red-600 flex items-center justify-center shrink-0">
          <Shield className="h-5 w-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold">Admin — ACLS/BLS</h1>
          <p className="text-muted-foreground mt-1">เลือกส่วนที่ต้องการเพิ่ม/แก้ไขเนื้อหา</p>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {SECTIONS.map(({ href, title, desc, icon: Icon }) => (
          <Link key={href} href={href}>
            <Card className="hover:shadow-md transition-shadow cursor-pointer h-full">
              <CardHeader className="pb-2">
                <div className="flex items-center gap-2">
                  <Icon className="h-5 w-5 text-brand" />
                  <h3 className="font-bold">{title}</h3>
                </div>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-muted-foreground">{desc}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
