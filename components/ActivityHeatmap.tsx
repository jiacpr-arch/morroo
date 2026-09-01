"use client";

interface HeatmapCell {
  day_of_week: number;
  hour_of_day: number;
  attempt_count: number;
}

const DAYS = ["อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"];
const HOURS = Array.from({ length: 24 }, (_, i) => i);

export function ActivityHeatmap({ data }: { data: HeatmapCell[] }) {
  // Build lookup map
  const map: Record<string, number> = {};
  let maxCount = 0;
  for (const cell of data) {
    const key = `${cell.day_of_week}-${cell.hour_of_day}`;
    map[key] = cell.attempt_count;
    if (cell.attempt_count > maxCount) maxCount = cell.attempt_count;
  }

  function getIntensity(day: number, hour: number): number {
    const count = map[`${day}-${hour}`] ?? 0;
    return maxCount > 0 ? count / maxCount : 0;
  }

  function getColor(intensity: number): string {
    if (intensity === 0) return "bg-gray-100";
    if (intensity < 0.2) return "bg-purple-100";
    if (intensity < 0.4) return "bg-purple-200";
    if (intensity < 0.6) return "bg-purple-400";
    if (intensity < 0.8) return "bg-purple-600";
    return "bg-purple-800";
  }

  function getCount(day: number, hour: number): number {
    return map[`${day}-${hour}`] ?? 0;
  }

  return (
    <div className="overflow-x-auto">
      <div className="min-w-[600px]">
        {/* Hour labels */}
        <div className="flex mb-1 ml-8">
          {HOURS.map((h) => (
            <div
              key={h}
              className="flex-1 text-center text-[9px] text-muted-foreground"
            >
              {h % 3 === 0 ? `${h}` : ""}
            </div>
          ))}
        </div>

        {/* Grid rows */}
        {DAYS.map((dayLabel, dayIdx) => (
          <div key={dayIdx} className="flex items-center mb-0.5 gap-0.5">
            <div className="w-7 text-xs text-muted-foreground text-right pr-1 shrink-0">
              {dayLabel}
            </div>
            {HOURS.map((hour) => {
              const intensity = getIntensity(dayIdx, hour);
              const count = getCount(dayIdx, hour);
              return (
                <div
                  key={hour}
                  title={`${dayLabel} ${hour}:00 — ${count} attempts`}
                  className={`flex-1 h-4 rounded-sm cursor-default transition-opacity hover:opacity-80 ${getColor(
                    intensity
                  )}`}
                />
              );
            })}
          </div>
        ))}

        {/* Legend */}
        <div className="flex items-center gap-2 mt-3 justify-end">
          <span className="text-xs text-muted-foreground">น้อย</span>
          {[0, 0.2, 0.4, 0.6, 0.8, 1].map((v) => (
            <div
              key={v}
              className={`w-4 h-4 rounded-sm ${getColor(v)}`}
            />
          ))}
          <span className="text-xs text-muted-foreground">มาก</span>
        </div>
      </div>
    </div>
  );
}
