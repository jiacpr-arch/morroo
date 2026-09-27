import type { Metadata } from "next";
import Link from "next/link";
import { HeartPulse } from "lucide-react";

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
      <div className="border-b border-surface-border bg-white/80 backdrop-blur-md">
        <div className="mx-auto flex max-w-5xl flex-col items-start gap-1 px-4 py-2 sm:min-h-12 sm:flex-row sm:items-center sm:justify-between sm:gap-4 sm:px-6 sm:py-0 lg:px-8">
          <Link
            href="/acls-reader"
            className="flex min-h-9 shrink-0 items-center gap-2 rounded-md text-sm font-semibold text-brand focus-visible:outline-2 focus-visible:outline-brand"
          >
            <HeartPulse className="h-4 w-4" />
            <span>ACLS Reader</span>
          </Link>
          <nav aria-label="เมนู ACLS Reader" className="flex w-full flex-wrap items-center gap-1 text-xs sm:w-auto sm:text-sm">
            <Link
              href="/acls-reader"
              className="inline-flex min-h-9 items-center rounded-lg px-2.5 py-1.5 font-medium text-ink-soft transition-colors hover:bg-surface-warm hover:text-brand-dark focus-visible:outline-2 focus-visible:outline-brand sm:px-3"
            >
              เนื้อหา ACLS
            </Link>
            <Link
              href="/acls-reader/qa-deep"
              className="inline-flex min-h-9 items-center rounded-lg px-2.5 py-1.5 font-medium text-ink-soft transition-colors hover:bg-surface-warm hover:text-brand-dark focus-visible:outline-2 focus-visible:outline-brand sm:px-3"
            >
              Q&A เชิงลึก
            </Link>
            <Link
              href="/acls-reader/test"
              className="inline-flex min-h-9 items-center rounded-lg px-2.5 py-1.5 font-medium text-ink-soft transition-colors hover:bg-surface-warm hover:text-brand-dark focus-visible:outline-2 focus-visible:outline-brand sm:px-3"
            >
              แบบทดสอบ
            </Link>
            <Link
              href="/acls-reader/ekg"
              className="inline-flex min-h-9 items-center rounded-lg px-2.5 py-1.5 font-medium text-ink-soft transition-colors hover:bg-surface-warm hover:text-brand-dark focus-visible:outline-2 focus-visible:outline-brand sm:px-3"
            >
              ฝึก EKG
            </Link>
            <Link
              href="/acls-reader/learn"
              className="inline-flex min-h-9 items-center rounded-lg px-2.5 py-1.5 font-medium text-ink-soft transition-colors hover:bg-surface-warm hover:text-brand-dark focus-visible:outline-2 focus-visible:outline-brand sm:px-3"
            >
              บทเรียน
            </Link>
          </nav>
        </div>
      </div>
      {children}
    </div>
  );
}
