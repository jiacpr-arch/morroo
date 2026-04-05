"use client";

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

interface AccuracyTrend {
  week_start: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
}

export function AccuracyTrendChart({ data }: { data: AccuracyTrend[] }) {
  const chartData = data.map((d) => ({
    ...d,
    label: new Date(d.week_start).toLocaleDateString("th-TH", {
      day: "numeric",
      month: "short",
    }),
  }));

  return (
    <div className="h-64">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis
            dataKey="label"
            tick={{ fontSize: 12 }}
            tickLine={false}
          />
          <YAxis
            domain={[0, 100]}
            tick={{ fontSize: 12 }}
            tickLine={false}
            tickFormatter={(v) => `${v}%`}
          />
          <Tooltip
            formatter={(value, name) => {
              if (name === "accuracy") return [`${value}%`, "ความถูกต้อง"];
              if (name === "total_attempts")
                return [value, "จำนวนข้อ"];
              return [value, name];
            }}
            labelFormatter={(label) => `สัปดาห์: ${label}`}
          />
          <Line
            type="monotone"
            dataKey="accuracy"
            stroke="#6d28d9"
            strokeWidth={2}
            dot={{ r: 4, fill: "#6d28d9" }}
            activeDot={{ r: 6 }}
          />
          <Line
            type="monotone"
            dataKey="total_attempts"
            stroke="#94a3b8"
            strokeWidth={1}
            strokeDasharray="4 4"
            dot={false}
            yAxisId={0}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
