import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  GraduationCap,
  Layers,
  Brain,
  Shuffle,
  Clock,
  Calendar,
  Trophy,
  Award,
  Bot,
  Network,
  Stethoscope,
  Search,
  Bookmark,
  GitCompare,
  Route,
  Settings as SettingsIcon,
  Image as ImageIcon,
  Compass,
  Lock,
  type LucideIcon,
} from "lucide-react";
import type { UnlockState } from "@/lib/school/journey";

interface ModeItem {
  href: string;
  icon: LucideIcon;
  color: string;
  title: string;
  desc: string;
}

// โหมดทั้งหมด จัดเป็นหมวดหมู่ให้ไม่งง — เรียงจาก "เริ่มที่นี่" ไปเครื่องมือเสริม
const MODE_GROUPS: { title: string; desc: string; items: ModeItem[] }[] = [
  {
    title: "เรียนประจำวัน",
    desc: "ทำทุกวันเพื่อสร้าง streak",
    items: [
      { href: "/school/daily", icon: Calendar, color: "violet", title: "Daily Lesson", desc: "บทเรียน 5 นาที/วัน" },
      { href: "/school/review", icon: Clock, color: "rose", title: "Review", desc: "ใกล้ลืม — SRS" },
      { href: "/school/mixed", icon: Shuffle, color: "fuchsia", title: "Mixed", desc: "Interleaved practice" },
    ],
  },
  {
    title: "ฝึก & ทบทวน",
    desc: "เลือกฝึกเองตามใจ",
    items: [
      { href: "/school/flashcards", icon: Layers, color: "sky", title: "Flashcards", desc: "ทบทวนทีละการ์ด" },
      { href: "/school/quiz", icon: Brain, color: "emerald", title: "Quiz", desc: "ข้อสอบสั้น + เฉลย" },
      { href: "/school/cases", icon: Stethoscope, color: "orange", title: "Cases", desc: "Y1→Y6 walk-through" },
    ],
  },
  {
    title: "ผู้ช่วย AI",
    desc: "ถาม-อธิบาย-เทียบ ด้วย AI",
    items: [
      { href: "/school/tutor", icon: Bot, color: "indigo", title: "AI Tutor", desc: "ถามได้ตลอด" },
      { href: "/school/concepts", icon: Network, color: "cyan", title: "Concepts", desc: "เชื่อมข้ามวิชา" },
      { href: "/school/compare", icon: GitCompare, color: "pink", title: "Compare", desc: "Side-by-side AI" },
      { href: "/school/visuals", icon: ImageIcon, color: "fuchsia", title: "Visuals", desc: "รูปสรุป + ช็อตโน้ต" },
    ],
  },
  {
    title: "ความก้าวหน้า & แรงจูงใจ",
    desc: "ดูพัฒนาการและรางวัล",
    items: [
      { href: "/school/specialty", icon: Compass, color: "teal", title: "สายเฉพาะทาง", desc: "อาชีพในฝัน + ค่าพลัง" },
      { href: "/school/progress", icon: GraduationCap, color: "indigo", title: "Progress", desc: "Mastery + ปลดล็อก" },
      { href: "/school/badges", icon: Award, color: "amber", title: "Badges", desc: "เหรียญรางวัล" },
      { href: "/school/leaderboard", icon: Trophy, color: "yellow", title: "Leaderboard", desc: "อันดับ XP" },
      { href: "/school/tracks", icon: Route, color: "lime", title: "Tracks", desc: "Curated bundles" },
    ],
  },
  {
    title: "เครื่องมือ & ตั้งค่า",
    desc: "ค้นหา บันทึก ปรับค่า",
    items: [
      { href: "/school/search", icon: Search, color: "slate", title: "Search", desc: "ค้นทุกอย่าง" },
      { href: "/school/saved", icon: Bookmark, color: "amber", title: "Saved", desc: "Bookmarks + Notes" },
      { href: "/school/settings", icon: SettingsIcon, color: "slate", title: "Settings", desc: "เปลี่ยน goal / year" },
    ],
  },
];

function UnlockedCard({ m, isNew }: { m: ModeItem; isNew: boolean }) {
  return (
    <Link href={m.href}>
      <Card className="group relative h-full hover:shadow-md hover:border-brand/30 transition-all cursor-pointer">
        {isNew && (
          <Badge className="absolute right-2 top-2 z-10 bg-brand text-white text-[10px] px-1.5 py-0">
            ใหม่!
          </Badge>
        )}
        <CardContent className="p-4 text-center">
          <div
            className={`w-10 h-10 rounded-full bg-${m.color}-100 flex items-center justify-center mb-2 mx-auto`}
          >
            <m.icon className={`h-5 w-5 text-${m.color}-600`} />
          </div>
          <h3 className="font-bold text-sm">{m.title}</h3>
          <p className="text-xs text-muted-foreground mt-1">{m.desc}</p>
        </CardContent>
      </Card>
    </Link>
  );
}

function LockedCard({ m, label }: { m: ModeItem; label: string | null }) {
  return (
    <Card className="relative h-full border-dashed opacity-60">
      <CardContent className="p-4 text-center">
        <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center mb-2 mx-auto">
          <Lock className="h-5 w-5 text-muted-foreground" />
        </div>
        <h3 className="font-bold text-sm text-muted-foreground">{m.title}</h3>
        <p className="text-[11px] text-muted-foreground mt-1 italic">
          {label ?? "ปลดล็อกเมื่อก้าวหน้าขึ้น"}
        </p>
      </CardContent>
    </Card>
  );
}

/**
 * Renders all School tools grouped by category, with locked tools dimmed so
 * students can see what is coming without being overwhelmed by choice.
 */
export default function ToolGrid({ state }: { state: UnlockState }) {
  return (
    <div className="space-y-6">
      {MODE_GROUPS.map((g) => (
        <div key={g.title}>
          <div className="mb-3">
            <h3 className="font-bold text-base">{g.title}</h3>
            <p className="text-xs text-muted-foreground">{g.desc}</p>
          </div>
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
            {g.items.map((m) =>
              state.unlockedHrefs.has(m.href) ? (
                <UnlockedCard
                  key={m.href}
                  m={m}
                  isNew={state.newHrefs.has(m.href)}
                />
              ) : (
                <LockedCard
                  key={m.href}
                  m={m}
                  label={state.unlockLabelFor(m.href)}
                />
              )
            )}
          </div>
        </div>
      ))}
    </div>
  );
}
