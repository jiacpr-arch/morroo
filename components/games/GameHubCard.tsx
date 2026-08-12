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
import type { HubGame, HubIconName } from "@/lib/games/registry";

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

/** ติด UTM ให้ทุกลิงก์ — utm_content บอกว่าคลิกจากการ์ดไหน */
function hrefWithUtm(game: HubGame): string {
  const sep = game.href.includes("?") ? "&" : "?";
  return `${game.href}${sep}utm_source=morroo&utm_medium=games_hub&utm_content=${game.id}`;
}

function onCardClick(game: HubGame) {
  track("games_hub_click", { target: game.id, group: game.audience });
}

/** การ์ดเกมหลักของ hub — สไตล์เดียวกับการ์ดเคสในหน้า /sim ของ morroo */
export function GameHubCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="block"
      data-hub-card={game.id}
    >
      <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
        <CardContent className="flex gap-4 p-5">
          <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-brand/10 text-brand">
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
                    className="rounded-full border px-2 py-0.5 text-[11px] text-muted-foreground"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
          <Play className="mt-1 h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
        </CardContent>
      </Card>
    </a>
  );
}

/** การ์ดกะทัดรัด — แถวเว็บคอร์สทักษะ (Airway / Defib / IV) */
export function GameHubCompactCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="block"
      data-hub-card={game.id}
    >
      <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
        <CardContent className="flex flex-col items-center gap-1.5 p-4 text-center">
          <Icon className="h-5 w-5 text-brand" />
          <span className="text-sm font-semibold leading-tight">{game.title}</span>
          <span className="flex items-center gap-1 text-[11px] text-muted-foreground">
            {game.desc} <ExternalLink className="h-3 w-3" aria-hidden />
          </span>
        </CardContent>
      </Card>
    </a>
  );
}
