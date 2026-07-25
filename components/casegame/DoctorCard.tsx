import { specialtyColor } from "@/lib/casegame/normalize";
import { fullTitle, xpToRank } from "@/lib/school/rank";
import { EXPERT_LEVEL, type SpecialtyExpertise } from "@/lib/sim/expertise";

/** สาขาที่โชว์บนการ์ด — มากกว่านี้แถวจะล้นบนมือถือ */
const MAX_SPECIALTIES = 3;

interface Props {
  xp: number;
  specialties: SpecialtyExpertise[];
  totalWins: number;
}

/**
 * "ตัวละครของคุณ" บนหน้ารวมเกมเคส — ยศตาม XP สะสม + สาขาที่ถนัดที่สุด
 *
 * แสดงเฉพาะผู้ใช้ที่ล็อกอิน (หน้าเรียก `getMyDoctorProfile()` ซึ่งคืน null
 * เมื่อไม่ได้ล็อกอิน) — คนที่ยังไม่ล็อกอินเห็น hero ปกติแล้วเล่นได้เลย
 */
export default function DoctorCard({ xp, specialties, totalWins }: Props) {
  const { rank, next, xpIntoRank, xpForNext, progress } = xpToRank(xp);
  const expert = specialties.find((s) => s.tier.level >= EXPERT_LEVEL);
  const top = specialties.filter((s) => s.wins > 0).slice(0, MAX_SPECIALTIES);

  return (
    <section className="rounded-2xl border border-brand/20 bg-gradient-to-br from-brand/5 to-transparent p-4">
      <div className="flex items-start gap-3">
        <span className="text-3xl leading-none" aria-hidden>{rank.icon}</span>
        <div className="min-w-0 flex-1">
          <p className="text-[11px] font-bold uppercase tracking-wider text-brand">
            ตัวละครของคุณ
          </p>
          <h2 className="mt-0.5 text-[17px] font-extrabold leading-snug text-gray-900">
            {fullTitle(xp, expert?.specialty)}
          </h2>
          <p className="mt-1 text-[13px] leading-relaxed text-gray-600">{rank.trait}</p>
        </div>
      </div>

      <div className="mt-3">
        <div
          className="h-2 overflow-hidden rounded-full bg-gray-200"
          role="progressbar"
          aria-valuenow={progress}
          aria-valuemin={0}
          aria-valuemax={100}
          aria-label={next ? `ความคืบหน้าไปยัง${next.title}` : "ถึงขั้นสูงสุดแล้ว"}
        >
          <span
            className="block h-full rounded-full bg-brand transition-[width] duration-500"
            style={{ width: `${progress}%` }}
          />
        </div>
        <p className="mt-1.5 text-xs text-gray-500">
          {next ? (
            <>
              {xpIntoRank.toLocaleString("th-TH")} / {xpForNext.toLocaleString("th-TH")} XP —
              อีก {(xpForNext - xpIntoRank).toLocaleString("th-TH")} XP ถึง{" "}
              <strong className="text-gray-700">{next.title}</strong>
            </>
          ) : (
            <>ขั้นสูงสุดของสายวิชาการแล้ว · ชนะมาทั้งหมด {totalWins.toLocaleString("th-TH")} เคส</>
          )}
        </p>
      </div>

      {top.length > 0 ? (
        <div className="mt-3 border-t border-brand/10 pt-3">
          <p className="text-[11px] font-bold uppercase tracking-wider text-gray-500">
            ความเชี่ยวชาญ
          </p>
          <ul className="mt-1.5 flex flex-wrap gap-1.5">
            {top.map((s) => (
              <li
                key={s.specialty}
                className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-semibold ${specialtyColor(s.specialty)}`}
              >
                <span aria-hidden>{s.tier.icon}</span>
                {s.specialty}
                <span className="font-normal opacity-70">{s.tier.label}</span>
              </li>
            ))}
          </ul>
        </div>
      ) : (
        <p className="mt-3 border-t border-brand/10 pt-3 text-xs text-gray-500">
          ชนะเคสในสาขาเดียวกันสะสมเพื่อไต่ระดับความเชี่ยวชาญ — เลือกสักเคสด้านล่างได้เลย
        </p>
      )}
    </section>
  );
}
