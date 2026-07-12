import type { Metadata } from "next";
import Link from "next/link";
import { HeartPulse } from "lucide-react";
import SyncEngineMount from "@/components/courses/SyncEngineMount";
import { getCourseMeta } from "@/lib/courses/config";

const meta = getCourseMeta("bls");

export const metadata: Metadata = {
  title: {
    default: `${meta.shortName} — ${meta.titleTh}`,
    template: `%s | ${meta.shortName}`,
  },
  description: meta.titleTh,
};

export default function BlsLayout({ children }: { children: React.ReactNode }) {
  return (
    <div>
      <div className="border-b border-border bg-white/80 backdrop-blur-md">
        <div className="mx-auto flex h-12 max-w-5xl items-center justify-between px-4 sm:px-6 lg:px-8">
          <Link
            href="/bls"
            className="flex items-center gap-2 text-sm font-semibold"
            style={{ color: meta.themeColor }}
          >
            <HeartPulse className="h-4 w-4" />
            <span>{meta.shortName}</span>
          </Link>
          <div className="flex items-center gap-1 text-sm">
            <Link
              href="/bls"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              หน้าแรก
            </Link>
            <Link
              href="/bls/learn"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              บทเรียน
            </Link>
            <Link
              href="/bls/skill-practice"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              ฝึก CPR
            </Link>
            <Link
              href="/bls/algorithm"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              Algorithm
            </Link>
            <Link
              href="/bls/post-test"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              Post-test
            </Link>
            <Link
              href="/bls/certification"
              className="rounded-lg px-3 py-1.5 font-medium text-muted-foreground transition-colors hover:text-foreground"
            >
              ใบประกาศฯ
            </Link>
            <Link
              href="/bls/cohort"
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
