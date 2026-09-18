import Image from "next/image";
import {
  ArrowDown,
  CheckCircle2,
  Gamepad2,
  GraduationCap,
  HeartPulse,
  Sparkles,
  Users,
} from "lucide-react";
import { GameHubCard, GameHubCompactCard } from "@/components/games/GameHubCard";
import {
  AUDIENCE_GROUPS,
  HUB_GAMES,
  gamesForAudience,
  type GameAudience,
} from "@/lib/games/registry";

// หน้าเดียวของ game.morroo.com — ป้ายบอกทางรวมเกมทุกเว็บใต้ *.morroo.com
// จัดกลุ่มตามผู้เล่น (เรียงพื้นฐาน → เฉพาะทาง) เพราะกลุ่มเป้าหมายปนกันมาก:
// บางคนเป็นหมอ บางคนเป็นประชาชนทั่วไป — ให้แต่ละคนหาเกมระดับตัวเองเจอใน 5 วินาที

const GROUP_STYLE: Record<
  GameAudience,
  {
    icon: typeof Users;
    number: string;
    label: string;
    chip: string;
    iconBox: string;
    glow: string;
  }
> = {
  public: {
    icon: Users,
    number: "01",
    label: "เริ่มต้นตรงนี้",
    chip: "border-emerald-200 bg-emerald-50 text-emerald-700",
    iconBox: "bg-emerald-100 text-emerald-700",
    glow: "bg-emerald-300/25",
  },
  provider: {
    icon: HeartPulse,
    number: "02",
    label: "ฝึกทีมและทักษะ",
    chip: "border-sky-200 bg-sky-50 text-sky-700",
    iconBox: "bg-sky-100 text-sky-700",
    glow: "bg-sky-300/25",
  },
  doctor: {
    icon: GraduationCap,
    number: "03",
    label: "ท้าทายเคสจริง",
    chip: "border-violet-200 bg-violet-50 text-violet-700",
    iconBox: "bg-violet-100 text-violet-700",
    glow: "bg-violet-300/25",
  },
};

export default function GamesHubPage() {
  return (
    <div className="overflow-hidden pb-16 sm:pb-24">
      <div className="mx-auto max-w-6xl px-4 pt-4 sm:px-6 sm:pt-7 lg:px-8">
        <section className="relative isolate min-h-[590px] overflow-hidden rounded-[2rem] bg-[#06192a] shadow-[0_30px_80px_-34px_rgba(6,25,42,.75)] sm:min-h-[560px] lg:min-h-[520px]">
          <Image
            src="/images/games/morroo-games-hero.jpg"
            alt=""
            fill
            sizes="(max-width: 768px) 100vw, 1152px"
            preload
            className="object-cover object-[62%_center] sm:object-center"
          />
          <div className="absolute inset-0 bg-[linear-gradient(90deg,rgba(3,17,31,.98)_0%,rgba(3,17,31,.94)_40%,rgba(3,17,31,.28)_72%,rgba(3,17,31,.05)_100%)] max-sm:bg-[linear-gradient(180deg,rgba(3,17,31,.97)_0%,rgba(3,17,31,.91)_48%,rgba(3,17,31,.28)_100%)]" />
          <div className="absolute -left-16 -top-20 h-64 w-64 rounded-full bg-teal-400/15 blur-3xl" />
          <div className="absolute bottom-0 left-[38%] h-px w-72 bg-gradient-to-r from-transparent via-teal-300/70 to-transparent" />

          <div className="relative z-10 flex min-h-[590px] max-w-2xl flex-col justify-between p-6 sm:min-h-[560px] sm:p-10 lg:min-h-[520px] lg:p-12">
            <div>
              <div className="mb-7 inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/8 px-3 py-1.5 text-xs font-semibold text-teal-200 backdrop-blur-md">
                <Sparkles className="h-3.5 w-3.5 text-amber-300" aria-hidden />
                เรียนรู้ผ่านการลงมือเล่น
              </div>
              <h1 className="max-w-xl text-4xl font-black leading-[1.12] tracking-[-0.03em] text-white sm:text-5xl lg:text-[3.6rem]">
                ฝึกให้พร้อม
                <br />
                ก่อน<span className="relative mx-2 inline-block text-[#ffad48]">
                  นาทีจริง
                  <span className="absolute -bottom-1 left-1 h-1 w-[90%] rounded-full bg-[#ef5b5b]" />
                </span>
                มาถึง
              </h1>
              <p className="mt-6 max-w-lg text-base leading-7 text-slate-300 sm:text-lg sm:leading-8">
                รวมเกมฝึกช่วยชีวิตและเกมเคสการแพทย์ ตั้งแต่ปฐมพยาบาลสำหรับทุกคน
                ไปจนถึงสถานการณ์ท้าทายสำหรับแพทย์
              </p>

              <div className="mt-8 flex flex-wrap items-center gap-3">
                <a
                  href="#choose-your-level"
                  className="inline-flex items-center gap-2 rounded-full bg-[#ef5b5b] px-5 py-3 text-sm font-bold text-white shadow-[0_12px_32px_-12px_rgba(239,91,91,.9)] transition hover:-translate-y-0.5 hover:bg-[#f36b6b] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
                >
                  เลือกเกมที่เหมาะกับคุณ
                  <ArrowDown className="h-4 w-4" aria-hidden />
                </a>
                <span className="inline-flex items-center gap-1.5 text-sm font-medium text-slate-300">
                  <CheckCircle2 className="h-4 w-4 text-teal-300" aria-hidden />
                  เล่นฟรีเกือบทุกเกม
                </span>
              </div>
            </div>

            <div className="mt-10 flex flex-wrap gap-x-8 gap-y-3 border-t border-white/12 pt-5 text-sm text-slate-300">
              <span><b className="mr-1.5 text-xl text-white">{HUB_GAMES.length}</b> เกมฝึกทักษะ</span>
              <span><b className="mr-1.5 text-xl text-white">3</b> ระดับผู้เล่น</span>
              <span><b className="mr-1.5 text-xl text-white">1</b> เป้าหมาย — พร้อมช่วย</span>
            </div>
          </div>
        </section>

        <section id="choose-your-level" className="scroll-mt-24 py-12 sm:py-16">
          <div className="mx-auto mb-7 max-w-2xl text-center">
            <p className="text-xs font-bold uppercase tracking-[.24em] text-teal-700">
              Choose your path
            </p>
            <h2 className="mt-2 text-2xl font-black tracking-tight text-slate-900 sm:text-3xl">
              วันนี้คุณอยากฝึกในระดับไหน?
            </h2>
            <p className="mt-2 text-sm leading-6 text-slate-600 sm:text-base">
              เลือกกลุ่มที่ตรงกับคุณ แล้วเริ่มเล่นได้ทันที
            </p>
          </div>

          <div className="grid gap-3 md:grid-cols-3">
            {AUDIENCE_GROUPS.map((group) => {
              const style = GROUP_STYLE[group.id];
              const Icon = style.icon;
              const count = HUB_GAMES.filter((game) => game.audience === group.id).length;
              return (
                <a
                  key={group.id}
                  href={`#${group.id}`}
                  className="group relative overflow-hidden rounded-2xl border border-slate-200 bg-white p-5 shadow-[0_12px_35px_-26px_rgba(15,23,42,.45)] transition duration-300 hover:-translate-y-1 hover:border-slate-300 hover:shadow-[0_20px_45px_-25px_rgba(15,23,42,.4)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-teal-600"
                >
                  <div className={`absolute -right-10 -top-12 h-28 w-28 rounded-full blur-2xl ${style.glow}`} />
                  <div className="relative flex items-start gap-4">
                    <span className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-xl ${style.iconBox}`}>
                      <Icon className="h-5 w-5" aria-hidden />
                    </span>
                    <div className="min-w-0 flex-1">
                      <div className="mb-1 flex items-center justify-between gap-2">
                        <span className="text-[11px] font-bold uppercase tracking-widest text-slate-400">
                          {style.label}
                        </span>
                        <span className="text-xs font-semibold text-slate-400">{count} เกม</span>
                      </div>
                      <h3 className="font-bold leading-snug text-slate-900 group-hover:text-teal-700">
                        {group.title}
                      </h3>
                    </div>
                  </div>
                </a>
              );
            })}
          </div>
        </section>
      </div>

      <div className="relative">
        <div className="absolute inset-0 -z-10 bg-[linear-gradient(180deg,transparent_0%,rgba(241,245,249,.75)_12%,rgba(241,245,249,.75)_88%,transparent_100%)]" />
        <div className="mx-auto max-w-6xl space-y-20 px-4 py-6 sm:px-6 sm:py-10 lg:px-8">
          {AUDIENCE_GROUPS.map((group) => {
            const { featured, compact } = gamesForAudience(group.id);
            const spotlight = featured.filter((game) => game.spotlight);
            const rest = featured.filter((game) => !game.spotlight);
            const style = GROUP_STYLE[group.id];
            const Icon = style.icon;
            const featuredGrid =
              rest.length >= 3
                ? "grid gap-5 md:grid-cols-2 lg:grid-cols-3"
                : "grid gap-5 md:grid-cols-2";

            return (
              <section key={group.id} id={group.id} className="scroll-mt-24">
                <div className="mb-7 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                  <div className="flex items-start gap-4">
                    <span className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl ${style.iconBox}`}>
                      <Icon className="h-6 w-6" aria-hidden />
                    </span>
                    <div>
                      <div className="mb-1 flex items-center gap-2">
                        <span className={`rounded-full border px-2.5 py-0.5 text-[11px] font-bold ${style.chip}`}>
                          LEVEL {style.number}
                        </span>
                      </div>
                      <h2 className="text-2xl font-black tracking-tight text-slate-900 sm:text-3xl">
                        {group.title}
                      </h2>
                      <p className="mt-1 max-w-2xl text-sm leading-6 text-slate-600 sm:text-base">
                        {group.desc}
                      </p>
                    </div>
                  </div>
                  <span className="hidden items-center gap-2 text-sm font-semibold text-slate-400 sm:flex">
                    <Gamepad2 className="h-4 w-4" aria-hidden />
                    เลือกแล้วเริ่มเล่น
                  </span>
                </div>

                {spotlight.length > 0 && (
                  <div className="mb-5 grid gap-5">
                    {spotlight.map((game) => (
                      <GameHubCard key={game.id} game={game} size="lg" />
                    ))}
                  </div>
                )}

                <div className={featuredGrid}>
                  {rest.map((game) => (
                    <GameHubCard key={game.id} game={game} />
                  ))}
                </div>

                {compact.length > 0 && (
                  <div className="mt-5 grid gap-3 sm:grid-cols-3">
                    {compact.map((game) => (
                      <GameHubCompactCard key={game.id} game={game} />
                    ))}
                  </div>
                )}
              </section>
            );
          })}
        </div>
      </div>

      <div className="mx-auto mt-20 max-w-6xl px-4 sm:px-6 lg:px-8">
        <section className="relative overflow-hidden rounded-[2rem] bg-[#0a2032] px-6 py-9 text-center text-white sm:px-10 sm:py-11">
          <div className="absolute -left-16 -top-24 h-56 w-56 rounded-full bg-teal-400/20 blur-3xl" />
          <div className="absolute -bottom-24 -right-16 h-56 w-56 rounded-full bg-rose-400/20 blur-3xl" />
          <div className="relative">
            <Gamepad2 className="mx-auto h-8 w-8 text-amber-300" aria-hidden />
            <h2 className="mt-3 text-2xl font-black sm:text-3xl">พร้อมแล้ว เลือกเกมแล้วลุยเลย</h2>
            <p className="mx-auto mt-2 max-w-xl text-sm leading-6 text-slate-300 sm:text-base">
              ทุกเกมออกแบบเพื่อให้ได้ลองตัดสินใจ เรียนรู้จากผลลัพธ์ และกลับมาฝึกซ้ำได้เสมอ
            </p>
            <a
              href="#choose-your-level"
              className="mt-6 inline-flex items-center gap-2 rounded-full bg-white px-5 py-2.5 text-sm font-bold text-[#0a2032] transition hover:-translate-y-0.5 hover:bg-amber-50 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-white"
            >
              เลือกระดับของคุณ
              <ArrowDown className="h-4 w-4" aria-hidden />
            </a>
          </div>
        </section>
      </div>
    </div>
  );
}
