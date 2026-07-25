"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ChevronDown, Play, Search, Shuffle, Star, Trophy } from "lucide-react";
import { Button } from "@/components/ui/button";
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

const GRADE_TEXT: Record<string, string> = {
  S: "text-amber-600",
  A: "text-teal-600",
  B: "text-emerald-600",
  C: "text-rose-600",
};

const chipBase =
  "shrink-0 rounded-full border px-3 py-1.5 text-sm font-medium transition-colors whitespace-nowrap active:scale-[.97]";
const chipActive = "bg-brand text-white border-brand shadow-sm";
const chipIdle = "bg-white hover:bg-brand/5 hover:border-brand/40 text-foreground border-border";

/** แถวเคสแบบหนาแน่น 1 บรรทัด — เห็นได้เยอะต่อจอ เลื่อนน้อย */
function CaseRow({ card, best, href }: { card: CaseCard; best?: SimBest; href: string }) {
  return (
    <Link
      href={href}
      className="group flex items-start gap-3 border-b px-3 py-3.5 transition-colors last:border-b-0 hover:bg-brand/5 active:bg-brand/10"
    >
      <div className="min-w-0 flex-1">
        <div className="mb-1 flex flex-wrap items-center gap-1.5">
          {/* เคสคัดมือไม่ได้เก็บสาขาไว้ ถ้าโชว์ "อื่น ๆ" จะดูรกเปล่าๆ */}
          {card.type === "featured" ? (
            <span className="rounded-md bg-amber-100 px-1.5 py-0.5 text-[11px] font-medium text-amber-700">
              แนะนำ
            </span>
          ) : (
            <span
              className={`rounded-md px-1.5 py-0.5 text-[11px] font-medium ${specialtyColor(card.specialty)}`}
            >
              {card.specialty}
            </span>
          )}
          <span
            className={`rounded-md px-1.5 py-0.5 text-[11px] font-medium ${DIFFICULTY_STYLE[card.difficulty]}`}
          >
            {card.difficulty}
          </span>
          {best && (
            <span className={`text-[11px] font-bold ${GRADE_TEXT[best.grade] ?? "text-muted-foreground"}`}>
              <Trophy className="mr-0.5 inline h-3 w-3" />
              {best.grade}
            </span>
          )}
        </div>
        <h3 className="truncate text-[15px] font-semibold leading-snug text-gray-900 group-hover:text-brand">
          {cleanTitle(card.title)}
        </h3>
        {/* โจทย์ผู้ป่วยหนึ่งบรรทัด — นี่คือสิ่งที่ทำให้เคสน่าเล่น ก่อนหน้านี้
            แถวโชว์แค่ชื่อเคสเลยดูจืด ไม่รู้ว่าเจอเคสแบบไหน */}
        {card.subtitle && (
          <p className="mt-0.5 line-clamp-1 text-xs leading-relaxed text-muted-foreground">
            {card.subtitle}
          </p>
        )}
      </div>
      {/* ปุ่มจริงมีตัวหนังสือ เห็นตลอด (ไม่ผูกกับ hover — มือถือไม่มี hover) */}
      <span className="mt-0.5 inline-flex shrink-0 items-center gap-1 rounded-full bg-brand px-3 py-1.5 text-xs font-bold text-white shadow-sm transition group-hover:brightness-110 group-active:scale-95">
        <Play className="h-3 w-3 fill-current" /> เล่น
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
  const [openLevels, setOpenLevels] = useState<Set<string> | null>(null);
  // จำนวนแถวที่โชว์ต่อกลุ่ม — คลังมีเป็นร้อยเคส ถ้าเรนเดอร์หมดหน้าจะยาวมาก
  // จนเลื่อนหาไม่เจอ ให้ทยอยกด "ดูเพิ่ม" เอา
  const [shownPerLevel, setShownPerLevel] = useState<Record<string, number>>({});

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

  // พับกลุ่มไหนบ้าง: ค่าเริ่มต้น (openLevels = null) เปิดเฉพาะกลุ่มแรก (ง่ายสุด)
  // เพื่อให้หน้าสั้น กลุ่มอื่นพับไว้กดเปิดเองได้; เมื่อกรอง/ค้นหาเปิดหมด
  const firstLevel = groups[0]?.level;
  const isOpen = (lvl: string) => {
    if (hasFilter) return true;
    return openLevels ? openLevels.has(lvl) : lvl === firstLevel;
  };

  const toggle = (lvl: string) => {
    setOpenLevels((prev) => {
      const next = new Set(prev ?? (firstLevel ? [firstLevel] : []));
      if (next.has(lvl)) next.delete(lvl);
      else next.add(lvl);
      return next;
    });
  };

  // เปลี่ยนตัวกรอง = รายการชุดใหม่ ต้องเริ่มนับใหม่ ไม่งั้นหน้ายาวค้างจากของเดิม
  useEffect(() => {
    setShownPerLevel({});
  }, [search, specialty, level]);

  // แถวสูงขึ้นเพราะมีโจทย์ผู้ป่วยกับปุ่มเล่น เลยลดจำนวนต่อหน้าลงกันหน้ายาว
  const PAGE = 6;
  const shownOf = (lvl: string) => shownPerLevel[lvl] ?? PAGE;
  const showMore = (lvl: string) =>
    setShownPerLevel((prev) => ({ ...prev, [lvl]: (prev[lvl] ?? PAGE) + PAGE }));

  const goRandom = (pool: CaseCard[]) => {
    if (pool.length === 0) return;
    const pick = pool[Math.floor(Math.random() * pool.length)];
    router.push(href(pick.slug));
  };

  return (
    <div className="mt-6">
      {/* แถบควบคุมปักบน: สุ่ม + ค้นหา + กรอง (หาเจอตลอด ไม่ต้องเลื่อนขึ้น) */}
      <div className="sticky top-0 z-10 -mx-4 space-y-2 border-b bg-white/95 px-4 py-3 backdrop-blur sm:mx-0 sm:rounded-xl sm:border sm:px-3">
        <div className="flex gap-2">
          <Button onClick={() => goRandom(filtered.length ? filtered : cards)} className="gap-1.5">
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
        {/* ระดับ + สาขา เลื่อนแนวนอนแถวเดียว ไม่กินพื้นที่แนวตั้ง */}
        <div className="flex gap-1.5 overflow-x-auto pb-1">
          {(["ทั้งหมด", ...DIFFICULTY_ORDER] as const).map((d) => (
            <button
              key={d}
              type="button"
              onClick={() => setLevel(d)}
              className={`${chipBase} ${level === d ? chipActive : chipIdle}`}
            >
              {d === "ทั้งหมด" ? "ทุกระดับ" : d}
            </button>
          ))}
        </div>
        <div className="flex gap-1.5 overflow-x-auto pb-1">
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
              {s} <span className="opacity-60">{specialtyCounts.get(s)}</span>
            </button>
          ))}
        </div>
      </div>

      {/* เคสแนะนำ — แถวหนาแน่น อยู่บนสุดเป็นจุดเริ่ม (เฉพาะตอนไม่กรอง) */}
      {!hasFilter && featured.length > 0 && (
        <section className="mt-4">
          <h2 className="mb-1 flex items-center gap-1.5 px-2 text-xs font-semibold uppercase tracking-wide text-amber-600">
            <Star className="h-3.5 w-3.5" /> เริ่มที่เคสแนะนำ
          </h2>
          <div className="overflow-hidden rounded-xl border bg-amber-50/40">
            {featured.map((c) => (
              <CaseRow key={c.slug} card={c} best={bests[c.slug]} href={href(c.slug)} />
            ))}
          </div>
        </section>
      )}

      {/* รายการหลัก: พับตามระดับ ง่าย → ยาก (เริ่มเปิดกลุ่มแรก) */}
      {filtered.length === 0 ? (
        hasFilter ? (
          <div className="mt-6 rounded-xl border bg-white py-12 text-center text-sm text-muted-foreground">
            ไม่พบเคสที่ตรงกับตัวกรอง — ลองล้างตัวกรองหรือค้นหาคำอื่น
          </div>
        ) : null
      ) : (
        <div className="mt-4 space-y-3">
          {groups.map((g) => {
            const open = isOpen(g.level);
            return (
              <section key={g.level} className="overflow-hidden rounded-xl border bg-white">
                <div className="flex items-center justify-between gap-2 px-3 py-2">
                  <button
                    type="button"
                    onClick={() => toggle(g.level)}
                    className="-mx-1 flex flex-1 items-center gap-2 rounded-lg px-1 py-1 text-left transition-colors hover:bg-muted/60 active:bg-muted"
                  >
                    <ChevronDown
                      className={`h-4 w-4 text-muted-foreground transition-transform ${open ? "" : "-rotate-90"}`}
                    />
                    <span className={`rounded-full px-2 py-0.5 text-xs font-medium ${DIFFICULTY_STYLE[g.level]}`}>
                      {g.level}
                    </span>
                    <span className="text-sm text-muted-foreground">{g.items.length} เคส</span>
                  </button>
                  <button
                    type="button"
                    onClick={() => goRandom(g.items)}
                    className="inline-flex shrink-0 items-center gap-1 rounded-full border border-brand/30 bg-brand/5 px-2.5 py-1 text-xs font-semibold text-brand transition-colors hover:bg-brand/10 active:bg-brand/15"
                  >
                    <Shuffle className="h-3 w-3" /> สุ่ม
                  </button>
                </div>
                {open && (
                  <div className="border-t">
                    {g.items.slice(0, shownOf(g.level)).map((c) => (
                      <CaseRow key={c.slug} card={c} best={bests[c.slug]} href={href(c.slug)} />
                    ))}
                    {g.items.length > shownOf(g.level) && (
                      <div className="border-t p-2">
                        <button
                          type="button"
                          onClick={() => showMore(g.level)}
                          className="w-full rounded-lg border border-brand/30 bg-brand/5 px-3 py-2.5 text-sm font-semibold text-brand transition-colors hover:bg-brand/10 active:bg-brand/15"
                        >
                          ดูเพิ่ม · เหลืออีก {g.items.length - shownOf(g.level)} เคส
                        </button>
                      </div>
                    )}
                  </div>
                )}
              </section>
            );
          })}
        </div>
      )}
    </div>
  );
}
