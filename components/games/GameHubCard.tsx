"use client";

import {
  Activity,
  Ambulance,
  Bandage,
  ExternalLink,
  Heart,
  HeartPulse,
  Play,
  Siren,
  Stethoscope,
  Syringe,
  Wind,
  Zap,
  type LucideIcon,
} from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { track } from "@/lib/analytics";
import type { HubAccent, HubGame, HubIconName } from "@/lib/games/registry";

// map ชื่อไอคอน (string ใน registry) → lucide component — อยู่ฝั่ง client
// เพื่อให้ registry เป็น data ล้วน ส่งข้าม RSC boundary ได้
// Record<HubIconName, ...> บังคับให้ครบทุกชื่อที่ registry ประกาศ (พลาดแล้ว type error)
const ICONS: Record<HubIconName, LucideIcon> = {
  Bandage,
  Heart,
  HeartPulse,
  Activity,
  Wind,
  Zap,
  Syringe,
  Siren,
  Stethoscope,
  Ambulance,
};

// สีประจำการ์ดตาม accent ใน registry — เขียนเป็น class เต็มๆ ต่อสี (Tailwind
// ต้องเห็น string ตรงๆ ตอน scan, ประกอบ class แบบ dynamic ไม่ได้)
// สามจุดที่ทาสี: แถบขอบซ้าย, วงไอคอน, พื้นการ์ดไล่สีจางๆ + ring ตอน hover
const ACCENTS: Record<
  HubAccent,
  { card: string; bubble: string; icon: string }
> = {
  emerald: {
    card: "border-l-4 border-l-emerald-500 bg-gradient-to-br from-emerald-50/80 to-white hover:ring-emerald-300",
    bubble: "bg-emerald-100",
    icon: "text-emerald-600",
  },
  rose: {
    card: "border-l-4 border-l-rose-500 bg-gradient-to-br from-rose-50/80 to-white hover:ring-rose-300",
    bubble: "bg-rose-100",
    icon: "text-rose-600",
  },
  sky: {
    card: "border-l-4 border-l-sky-500 bg-gradient-to-br from-sky-50/80 to-white hover:ring-sky-300",
    bubble: "bg-sky-100",
    icon: "text-sky-600",
  },
  red: {
    card: "border-l-4 border-l-red-600 bg-gradient-to-br from-red-50/80 to-white hover:ring-red-300",
    bubble: "bg-red-100",
    icon: "text-red-700",
  },
  cyan: {
    card: "border-l-4 border-l-cyan-500 bg-gradient-to-br from-cyan-50/80 to-white hover:ring-cyan-300",
    bubble: "bg-cyan-100",
    icon: "text-cyan-600",
  },
  amber: {
    card: "border-l-4 border-l-amber-500 bg-gradient-to-br from-amber-50/80 to-white hover:ring-amber-300",
    bubble: "bg-amber-100",
    icon: "text-amber-600",
  },
  violet: {
    card: "border-l-4 border-l-violet-500 bg-gradient-to-br from-violet-50/80 to-white hover:ring-violet-300",
    bubble: "bg-violet-100",
    icon: "text-violet-600",
  },
  teal: {
    card: "border-l-4 border-l-teal-500 bg-gradient-to-br from-teal-50/80 to-white hover:ring-teal-300",
    bubble: "bg-teal-100",
    icon: "text-teal-600",
  },
};

/** ติด UTM ให้ทุกลิงก์ — utm_content บอกว่าคลิกจากการ์ดไหน */
function hrefWithUtm(game: HubGame): string {
  const sep = game.href.includes("?") ? "&" : "?";
  return `${game.href}${sep}utm_source=morroo&utm_medium=games_hub&utm_content=${game.id}`;
}

function onCardClick(game: HubGame) {
  track("games_hub_click", { target: game.id, group: game.audience });
}

/** การ์ดเกมหลักของ hub — โครงเดียวกับการ์ดเคสในหน้า /sim แต่มีสีประจำเกม */
export function GameHubCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  const accent = ACCENTS[game.accent];
  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="block"
      data-hub-card={game.id}
    >
      <Card className={`h-full transition-shadow hover:shadow-md ${accent.card}`}>
        <CardContent className="flex gap-4 p-5">
          <div
            className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-xl ${accent.bubble} ${accent.icon}`}
          >
            <Icon className="h-6 w-6" />
          </div>
          <div className="min-w-0 flex-1 space-y-1.5">
            <div className="flex flex-wrap items-center gap-2">
              <h3 className="text-base font-bold leading-snug">{game.title}</h3>
              {game.badge ? (
                <Badge className="bg-amber-100 text-amber-700">{game.badge}</Badge>
              ) : (
                <Badge className="bg-teal-100 text-teal-700">เล่นฟรี</Badge>
              )}
            </div>
            <p className="text-sm leading-6 text-muted-foreground">{game.desc}</p>
            {game.tags.length > 0 && (
              <div className="flex flex-wrap gap-1.5 pt-0.5">
                {game.tags.map((tag) => (
                  <span
                    key={tag}
                    className="rounded-full border bg-white/60 px-2 py-0.5 text-[11px] text-muted-foreground"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
          <Play className={`mt-1 h-4 w-4 shrink-0 ${accent.icon}`} aria-hidden />
        </CardContent>
      </Card>
    </a>
  );
}

/** การ์ดกะทัดรัด — แถวเว็บคอร์สทักษะ (Airway / Defib / IV) */
export function GameHubCompactCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  const accent = ACCENTS[game.accent];
  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="block"
      data-hub-card={game.id}
    >
      <Card className={`h-full transition-shadow hover:shadow-md ${accent.card}`}>
        <CardContent className="flex flex-col items-center gap-1.5 p-4 text-center">
          <div
            className={`flex h-9 w-9 items-center justify-center rounded-lg ${accent.bubble} ${accent.icon}`}
          >
            <Icon className="h-5 w-5" />
          </div>
          <span className="text-sm font-semibold leading-tight">{game.title}</span>
          <span className="flex items-center gap-1 text-[11px] text-muted-foreground">
            {game.desc} <ExternalLink className="h-3 w-3" aria-hidden />
          </span>
        </CardContent>
      </Card>
    </a>
  );
}
