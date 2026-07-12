import type { Metadata } from "next";
import Link from "next/link";
import { HeartPulse } from "lucide-react";
import SyncEngineMount from "@/components/courses/SyncEngineMount";

export const metadata: Metadata = {
  title: {
    default: "ACLS Reader — คู่มือทบทวน ACLS",
    template: "%s | ACLS Reader",
  },
  description: "เนื้อหาความรู้ ACLS และ Q&A เชิงลึก สำหรับทบทวน",
};

export default function AclsReaderLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div>
      <div className="border-b border-border bg-white/80 backdrop-blur-md">
        <div className="mx-auto flex h-12 max-w-5xl items-center justify-between px-4 sm:px-6 lg:px-8">
          <Link
            href="/acls"
            className="flex items-center gap-2 text-sm font-semibold text-brand"
          >
            <HeartPulse className="h-4 w-4" />
            <span>ACLS Reader</span>
          </Link>
          <div className="flex items-center gap-1 text-sm">
            <Link
              href="/acls"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              เนื้อหา ACLS
            </Link>
            <Link
              href="/acls/qa-deep"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              Q&A เชิงลึก
            </Link>
            <Link
              href="/acls/test"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              แบบทดสอบ
            </Link>
            <Link
              href="/acls/ekg"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              ฝึก EKG
            </Link>
            <Link
              href="/acls/learn"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              บทเรียน
            </Link>
            <Link
              href="/acls/video-lessons"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              วิดีโอบทเรียน
            </Link>
            <Link
              href="/acls/cohort"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              ห้องเรียน
            </Link>
          </div>
        </div>
      </div>
      <SyncEngineMount />
      {children}
    </div>
  );
}
