"use client";

import Image from "next/image";
import {
  Activity,
  Ambulance,
  ArrowUpRight,
  Bandage,
  ExternalLink,
  Heart,
  HeartPulse,
  Siren,
  Stethoscope,
  Syringe,
  Wind,
  Zap,
  type LucideIcon,
} from "lucide-react";
import { track } from "@/lib/analytics";
import type { HubAccent, HubGame, HubIconName } from "@/lib/games/registry";

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

// Tailwind ต้องเห็นชื่อ class เต็มๆ จึงเก็บ theme ของแต่ละเกมเป็น map คงที่
const ACCENTS: Record<
  HubAccent,
  {
    card: string;
    bubble: string;
    icon: string;
    eyebrow: string;
    action: string;
    glow: string;
  }
> = {
  emerald: {
    card: "hover:border-emerald-200",
    bubble: "bg-emerald-100 ring-emerald-200",
    icon: "text-emerald-700",
    eyebrow: "text-emerald-700",
    action: "bg-emerald-600 text-white group-hover:bg-emerald-700",
    glow: "bg-emerald-300/35",
  },
  rose: {
    card: "hover:border-rose-200",
    bubble: "bg-rose-100 ring-rose-200",
    icon: "text-rose-700",
    eyebrow: "text-rose-700",
    action: "bg-rose-600 text-white group-hover:bg-rose-700",
    glow: "bg-rose-300/35",
  },
  sky: {
    card: "hover:border-sky-200",
    bubble: "bg-sky-100 ring-sky-200",
    icon: "text-sky-700",
    eyebrow: "text-sky-700",
    action: "bg-sky-600 text-white group-hover:bg-sky-700",
    glow: "bg-sky-300/35",
  },
  red: {
    card: "hover:border-red-200",
    bubble: "bg-red-100 ring-red-200",
    icon: "text-red-700",
    eyebrow: "text-red-700",
    action: "bg-red-600 text-white group-hover:bg-red-700",
    glow: "bg-red-300/35",
  },
  cyan: {
    card: "hover:border-cyan-200",
    bubble: "bg-cyan-100 ring-cyan-200",
    icon: "text-cyan-700",
    eyebrow: "text-cyan-700",
    action: "bg-cyan-600 text-white group-hover:bg-cyan-700",
    glow: "bg-cyan-300/35",
  },
  amber: {
    card: "hover:border-amber-200",
    bubble: "bg-amber-100 ring-amber-200",
    icon: "text-amber-700",
    eyebrow: "text-amber-700",
    action: "bg-amber-500 text-white group-hover:bg-amber-600",
    glow: "bg-amber-300/35",
  },
  violet: {
    card: "hover:border-violet-200",
    bubble: "bg-violet-100 ring-violet-200",
    icon: "text-violet-700",
    eyebrow: "text-violet-700",
    action: "bg-violet-600 text-white group-hover:bg-violet-700",
    glow: "bg-violet-300/35",
  },
  teal: {
    card: "hover:border-teal-200",
    bubble: "bg-teal-100 ring-teal-200",
    icon: "text-teal-700",
    eyebrow: "text-teal-700",
    action: "bg-teal-600 text-white group-hover:bg-teal-700",
    glow: "bg-teal-300/35",
  },
};

function hrefWithUtm(game: HubGame): string {
  const sep = game.href.includes("?") ? "&" : "?";
  return `${game.href}${sep}utm_source=morroo&utm_medium=games_hub&utm_content=${game.id}`;
}

function onCardClick(game: HubGame) {
  track("games_hub_click", { target: game.id, group: game.audience });
}

export function GameHubCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  const accent = ACCENTS[game.accent];

  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="group block h-full rounded-3xl focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-teal-600"
      data-hub-card={game.id}
    >
      <article
        className={`relative flex h-full flex-col overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-[0_16px_45px_-32px_rgba(15,23,42,.5)] transition duration-300 group-hover:-translate-y-1 group-hover:shadow-[0_24px_55px_-30px_rgba(15,23,42,.42)] ${accent.card}`}
      >
        {game.image && (
          <div className="relative aspect-[3/2] overflow-hidden bg-slate-100">
            <Image
              src={game.image.src}
              alt={game.image.alt}
              fill
              sizes="(max-width: 767px) calc(100vw - 32px), (max-width: 1023px) 50vw, 33vw"
              className="object-cover transition duration-500 group-hover:scale-[1.035]"
            />
            <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-slate-950/45 to-transparent" />
            <span className={`absolute bottom-4 left-4 flex h-11 w-11 items-center justify-center rounded-2xl bg-white/90 shadow-lg ring-1 backdrop-blur ${accent.icon}`}>
              <Icon className="h-5 w-5" aria-hidden />
            </span>
            <span
              className={`absolute bottom-4 right-4 flex h-10 w-10 items-center justify-center rounded-full shadow-lg transition duration-300 group-hover:rotate-6 group-hover:scale-105 ${accent.action}`}
            >
              <ArrowUpRight className="h-4 w-4" aria-hidden />
            </span>
          </div>
        )}

        <div className="relative flex flex-1 flex-col p-6">
          <div className={`pointer-events-none absolute -right-12 -top-14 h-36 w-36 rounded-full blur-3xl ${accent.glow}`} />
          {!game.image && (
            <div className="relative flex items-start justify-between gap-4">
              <span className={`flex h-14 w-14 items-center justify-center rounded-2xl ring-1 ${accent.bubble} ${accent.icon}`}>
                <Icon className="h-7 w-7" aria-hidden />
              </span>
              <span
                className={`flex h-10 w-10 items-center justify-center rounded-full transition duration-300 group-hover:rotate-6 group-hover:scale-105 ${accent.action}`}
              >
                <ArrowUpRight className="h-4 w-4" aria-hidden />
              </span>
            </div>
          )}

          <div className={`relative flex flex-1 flex-col ${game.image ? "" : "mt-5"}`}>
            <div className={`mb-2 text-[11px] font-bold uppercase tracking-[.18em] ${accent.eyebrow}`}>
              {game.badge ?? "เล่นฟรี · เริ่มได้เลย"}
            </div>
            <h3 className="text-xl font-black leading-snug tracking-tight text-slate-900">
              {game.title}
            </h3>
            <p className="mt-2 flex-1 text-sm leading-6 text-slate-600">{game.desc}</p>

            {game.tags.length > 0 && (
              <div className="mt-5 flex flex-wrap gap-1.5 border-t border-slate-100 pt-4">
                {game.tags.map((tag) => (
                  <span
                    key={tag}
                    className="rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-600"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>
      </article>
    </a>
  );
}

export function GameHubCompactCard({ game }: { game: HubGame }) {
  const Icon = ICONS[game.icon];
  const accent = ACCENTS[game.accent];

  return (
    <a
      href={hrefWithUtm(game)}
      onClick={() => onCardClick(game)}
      className="group rounded-2xl focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-teal-600"
      data-hub-card={game.id}
    >
      <article
        className={`relative flex h-full items-center gap-3 overflow-hidden rounded-2xl border border-slate-200 bg-white p-4 shadow-[0_12px_30px_-26px_rgba(15,23,42,.55)] transition duration-300 group-hover:-translate-y-0.5 group-hover:shadow-[0_18px_35px_-24px_rgba(15,23,42,.45)] ${accent.card}`}
      >
        <span className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-xl ring-1 ${accent.bubble} ${accent.icon}`}>
          <Icon className="h-5 w-5" aria-hidden />
        </span>
        <span className="min-w-0 flex-1">
          <span className="block text-sm font-bold leading-tight text-slate-900">{game.title}</span>
          <span className="mt-1 block text-xs text-slate-500">{game.desc}</span>
        </span>
        <ExternalLink className={`h-4 w-4 shrink-0 transition group-hover:translate-x-0.5 ${accent.icon}`} aria-hidden />
      </article>
    </a>
  );
}
