"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Play, Search, Shuffle, Sparkles, Trophy } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import type { SimBest } from "@/lib/supabase/queries-sim";
import {
  cleanTitle,
  DIFFICULTY_ORDER,
  DIFFICULTY_STYLE,
  SPECIALTY_SORT_HINT,
  specialtyColor,
  type CaseCard,
  type Difficulty,
} from "@/lib/casegame/normalize";

const GRADE_STYLE: Record<string, string> = {
  S: "bg-amber-100 text-amber-700",
  A: "bg-teal-100 text-teal-700",
  B: "bg-emerald-100 text-emerald-700",
  C: "bg-rose-100 text-rose-700",
};

const TYPE_LABEL: Record<CaseCard["type"], string> = {
  featured: "แนะนำ",
  longcase: "Long Case",
  meq: "MEQ",
};

const chipBase =
  "inline-flex items-center gap-1 rounded-full border px-3 py-1.5 text-sm transition-colors";
const chipActive = "bg-brand text-white border-brand";
const chipIdle = "bg-background hover:bg-muted text-foreground border-border";

function BestBadge({ best }: { best?: SimBest }) {
  if (!best) return null;
  return (
    <Badge className={GRADE_STYLE[best.grade] ?? "bg-muted"}>
      <Trophy className="mr-1 h-3 w-3" />
      เกรดดีสุด {best.grade}
    </Badge>
  );
}

function CaseTile({
  card,
  best,
  href,
}: {
  card: CaseCard;
  best?: SimBest;
  href: string;
}) {
  return (
    <Link
      href={href}
      className="group flex flex-col rounded-xl border bg-white p-4 transition-shadow hover:shadow-md"
    >
      <div className="mb-2 flex flex-wrap items-center gap-1.5">
        <span
          className={`rounded-full px-2 py-0.5 text-xs font-medium ${specialtyColor(card.specialty)}`}
        >
          {card.specialty}
        </span>
        <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${DIFFICULTY_STYLE[card.difficulty]}`}>
          {card.difficulty}
        </span>
        <span className="rounded-full bg-gray-100 px-2 py-0.5 text-xs font-medium text-gray-600">
          {TYPE_LABEL[card.type]}
        </span>
        {card.audience === "board" && (
          <span className="rounded-full bg-purple-100 px-2 py-0.5 text-xs font-medium text-purple-700">
            บอร์ด
          </span>
        )}
        <BestBadge best={best} />
      </div>
      <h3 className="text-sm font-semibold leading-snug text-gray-900 group-hover:text-brand">
        {cleanTitle(card.title)}
      </h3>
      {card.subtitle && (
        <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">{card.subtitle}</p>
      )}
      <span className="mt-2 inline-flex items-center gap-1 text-xs font-medium text-brand">
        <Play className="h-3 w-3" /> เล่นเคสนี้
      </span>
    </Link>
  );
}

interface Props {
  featured: CaseCard[];
  cards: CaseCard[];
  bests: Record<string, SimBest>;
  /** query string ("" หรือ "?utm_...") ต่อท้ายลิงก์เล่นเพื่อคง attribution จากโฆษณา */
  utm: string;
}

export default function CaseGameBrowser({ featured, cards, bests, utm }: Props) {
  const router = useRouter();
  const [search, setSearch] = useState("");
  const [specialty, setSpecialty] = useState("ทั้งหมด");
  const [level, setLevel] = useState<"ทั้งหมด" | Difficulty>("ทั้งหมด");

  const href = (slug: string) => `/sim/${slug}${utm}`;

  const specialtyCounts = useMemo(() => {
    const m = new Map<string, number>();
    for (const c of cards) m.set(c.specialty, (m.get(c.specialty) ?? 0) + 1);
    return m;
  }, [cards]);

  const specialties = useMemo(() => {
    return [...specialtyCounts.keys()].sort((a, b) => {
      const ia = SPECIALTY_SORT_HINT.indexOf(a);
      const ib = SPECIALTY_SORT_HINT.indexOf(b);
      const ra = ia === -1 ? 999 : ia;
      const rb = ib === -1 ? 999 : ib;
      if (ra !== rb) return ra - rb;
      return (specialtyCounts.get(b) ?? 0) - (specialtyCounts.get(a) ?? 0);
    });
  }, [specialtyCounts]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return cards.filter((c) => {
      if (specialty !== "ทั้งหมด" && c.specialty !== specialty) return false;
      if (level !== "ทั้งหมด" && c.difficulty !== level) return false;
      if (q && !`${c.title} ${c.subtitle ?? ""}`.toLowerCase().includes(q)) return false;
      return true;
    });
  }, [cards, search, specialty, level]);

  const groups = useMemo(
    () =>
      DIFFICULTY_ORDER.map((d) => ({
        level: d,
        items: filtered.filter((c) => c.difficulty === d),
      })).filter((g) => g.items.length > 0),
    [filtered],
  );

  const hasFilter = specialty !== "ทั้งหมด" || level !== "ทั้งหมด" || search.trim() !== "";

  const goRandom = (pool: CaseCard[]) => {
    if (pool.length === 0) return;
    const pick = pool[Math.floor(Math.random() * pool.length)];
    router.push(href(pick.slug));
  };

  return (
    <div className="mt-8">
      {/* แถบควบคุม: สุ่ม + ค้นหา + กรอง */}
      <div className="space-y-3 rounded-2xl border bg-white/60 p-4">
        <div className="flex flex-col gap-2 sm:flex-row">
          <Button
            onClick={() => goRandom(filtered.length ? filtered : cards)}
            size="lg"
            className="gap-2"
          >
            <Shuffle className="h-4 w-4" /> สุ่มเคส
          </Button>
          <div className="relative flex-1">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <Input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="ค้นหาชื่อเคส…"
              className="pl-9"
            />
          </div>
        </div>

        {/* ระดับความยาก */}
        <div className="flex flex-wrap gap-2">
          <button
            type="button"
            onClick={() => setLevel("ทั้งหมด")}
            className={`${chipBase} ${level === "ทั้งหมด" ? chipActive : chipIdle}`}
          >
            ทุกระดับ
          </button>
          {DIFFICULTY_ORDER.map((d) => (
            <button
              key={d}
              type="button"
              onClick={() => setLevel(d)}
              className={`${chipBase} ${level === d ? chipActive : chipIdle}`}
            >
              {d}
            </button>
          ))}
        </div>

        {/* สาขา */}
        <div className="flex flex-wrap gap-2">
          <button
            type="button"
            onClick={() => setSpecialty("ทั้งหมด")}
            className={`${chipBase} ${specialty === "ทั้งหมด" ? chipActive : chipIdle}`}
          >
            ทุกสาขา
          </button>
          {specialties.map((s) => (
            <button
              key={s}
              type="button"
              onClick={() => setSpecialty(s)}
              className={`${chipBase} ${specialty === s ? chipActive : chipIdle}`}
            >
              {s}
              <span className="text-xs opacity-70">{specialtyCounts.get(s)}</span>
            </button>
          ))}
        </div>
      </div>

      {/* เคสแนะนำ (pin เฉพาะตอนไม่ได้กรอง) */}
      {!hasFilter && featured.length > 0 && (
        <section className="mt-8">
          <h2 className="mb-3 flex items-center gap-1.5 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
            <Sparkles className="h-4 w-4 text-amber-500" /> เริ่มที่เคสแนะนำ
          </h2>
          <div className="space-y-4">
            {featured.map((s) => (
              <Card key={s.slug} className="transition-shadow hover:shadow-md hover:ring-brand/30">
                <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
                  <div className="flex-1 space-y-1.5">
                    <div className="flex flex-wrap items-center gap-2">
                      <Badge className="bg-amber-100 text-amber-700">เคสแนะนำ</Badge>
                      <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${DIFFICULTY_STYLE[s.difficulty]}`}>
                        {s.difficulty}
                      </span>
                      <BestBadge best={bests[s.slug]} />
                    </div>
                    <h3 className="text-lg font-bold">{cleanTitle(s.title)}</h3>
                    {s.subtitle && <p className="text-sm text-muted-foreground">{s.subtitle}</p>}
                  </div>
                  <Link href={href(s.slug)} className="shrink-0">
                    <Button size="lg" className="w-full gap-2 sm:w-auto">
                      <Play className="h-4 w-4" /> รับเคส
                    </Button>
                  </Link>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>
      )}

      {/* รายการหลัก จัดกลุ่มตามความยาก ง่าย → ยาก */}
      {filtered.length === 0 ? (
        hasFilter ? (
          <div className="mt-8 rounded-xl border bg-white py-16 text-center text-muted-foreground">
            ไม่พบเคสที่ตรงกับตัวกรอง — ลองล้างตัวกรองหรือค้นหาคำอื่น
          </div>
        ) : null
      ) : (
        groups.map((g) => (
          <section key={g.level} className="mt-8">
            <div className="mb-3 flex items-center justify-between">
              <h2 className="flex items-center gap-1.5 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                <span className={`rounded-full px-2 py-0.5 text-xs ${DIFFICULTY_STYLE[g.level]}`}>
                  {g.level}
                </span>
                · {g.items.length} เคส
              </h2>
              <button
                type="button"
                onClick={() => goRandom(g.items)}
                className="inline-flex items-center gap-1 text-xs font-medium text-brand hover:underline"
              >
                <Shuffle className="h-3 w-3" /> สุ่มระดับนี้
              </button>
            </div>
            <div className="grid gap-3 sm:grid-cols-2">
              {g.items.map((c) => (
                <CaseTile key={c.slug} card={c} best={bests[c.slug]} href={href(c.slug)} />
              ))}
            </div>
          </section>
        ))
      )}
    </div>
  );
}
