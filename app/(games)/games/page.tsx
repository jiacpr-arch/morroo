import { GraduationCap, HeartPulse, Users } from "lucide-react";
import { GameHubCard, GameHubCompactCard } from "@/components/games/GameHubCard";
import { AUDIENCE_GROUPS, gamesForAudience, type GameAudience } from "@/lib/games/registry";

// หน้าเดียวของ game.morroo.com — ป้ายบอกทางรวมเกมทุกเว็บใต้ *.morroo.com
// จัดกลุ่มตามผู้เล่น (เรียงพื้นฐาน → เฉพาะทาง) เพราะกลุ่มเป้าหมายปนกันมาก:
// บางคนเป็นหมอ บางคนเป็นประชาชนทั่วไป — ให้แต่ละคนหาเกมระดับตัวเองเจอใน 5 วินาที

const GROUP_ICON: Record<GameAudience, typeof Users> = {
  public: Users,
  provider: HeartPulse,
  doctor: GraduationCap,
};

export default function GamesHubPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      {/* Hero — โทนเดียวกับหน้า /sim ของ morroo ให้จำได้ว่าเครือเดียวกัน */}
      <section className="relative overflow-hidden rounded-2xl bg-[#0d1a24] px-6 py-10 text-center text-white sm:px-10">
        <div
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(229,72,77,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(26,188,156,.25), transparent 55%)",
          }}
        />
        <div className="relative space-y-3">
          <p className="font-mono text-[11px] uppercase tracking-[.4em] text-rose-400">
            Morroo Games
          </p>
          <h1 className="text-3xl font-black sm:text-4xl">
            เกมฝึก<span className="text-amber-400">ช่วยชีวิต</span> ทุกระดับ
          </h1>
          <p className="mx-auto max-w-md text-sm leading-7 text-slate-300">
            ตั้งแต่ปฐมพยาบาลสำหรับคนทั่วไป จนถึงเกมเคสสำหรับแพทย์ —
            เลือกเล่นให้ตรงกับระดับของคุณ <b className="text-white">เล่นฟรีเกือบทุกเกม</b>
          </p>
          {/* ชิปกระโดดลงกลุ่ม — ผู้ชมปนกันหลายระดับ ให้ข้ามไปกลุ่มตัวเองได้เลย */}
          <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs">
            {AUDIENCE_GROUPS.map((group) => (
              <a
                key={group.id}
                href={`#${group.id}`}
                className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1 text-slate-200 hover:border-white/50 hover:text-white"
              >
                {group.title}
              </a>
            ))}
          </div>
        </div>
      </section>

      {/* สามกลุ่มผู้เล่น เรียงพื้นฐาน → เฉพาะทาง */}
      {AUDIENCE_GROUPS.map((group) => {
        const { featured, compact } = gamesForAudience(group.id);
        const Icon = GROUP_ICON[group.id];
        return (
          <section key={group.id} id={group.id} className="scroll-mt-6 pt-10">
            <div className="mb-1 flex items-center gap-2">
              <Icon className="h-4 w-4 text-brand" aria-hidden />
              <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                {group.title}
              </h2>
            </div>
            <p className="mb-4 text-sm text-muted-foreground">{group.desc}</p>
            <div className="space-y-4">
              {featured.map((game) => (
                <GameHubCard key={game.id} game={game} />
              ))}
            </div>
            {compact.length > 0 && (
              <div className="mt-4 grid grid-cols-3 gap-3">
                {compact.map((game) => (
                  <GameHubCompactCard key={game.id} game={game} />
                ))}
              </div>
            )}
          </section>
        );
      })}

      <p className="mt-12 text-center text-sm text-muted-foreground">
        ทุกเกมพัฒนาโดยทีมเดียวกับ{" "}
        <a
          href="https://www.morroo.com?utm_source=morroo&utm_medium=games_hub&utm_content=footer_home"
          className="font-semibold text-brand underline"
        >
          หมอรู้ (morroo.com)
        </a>{" "}
        และ Jia Training Center
      </p>
    </div>
  );
}
