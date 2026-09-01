"use client";

import {
  Radar,
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
  Legend,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export interface RadarDatum {
  label: string;
  power: number; // ค่าพลังคุณ (ผลเรียนจริง 0–100)
  target?: number; // โปรไฟล์ที่สายเป้าหมายต้องการ 0–100
}

export function SpecialtyRadar({
  data,
  targetName,
}: {
  data: RadarDatum[];
  targetName?: string;
}) {
  return (
    <div className="h-80 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <RadarChart data={data} outerRadius="72%">
          <PolarGrid stroke="#e5e7eb" />
          <PolarAngleAxis dataKey="label" tick={{ fontSize: 11 }} />
          <PolarRadiusAxis domain={[0, 100]} tick={{ fontSize: 9 }} angle={90} />
          {targetName && (
            <Radar
              name={`เป้าหมาย: ${targetName}`}
              dataKey="target"
              stroke="#14b8a6"
              fill="#14b8a6"
              fillOpacity={0.15}
            />
          )}
          <Radar
            name="ค่าพลังคุณ"
            dataKey="power"
            stroke="#6d28d9"
            fill="#6d28d9"
            fillOpacity={0.35}
          />
          <Tooltip
            formatter={(value, name) => [`${value}%`, name as string]}
          />
          <Legend />
        </RadarChart>
      </ResponsiveContainer>
    </div>
  );
}
