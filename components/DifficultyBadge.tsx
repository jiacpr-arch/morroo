"use client";

import { getDifficultyInfo, type DifficultyLevel } from "@/lib/types-standard";

const colorMap = {
  green: "bg-green-100 text-green-700 border-green-200",
  yellow: "bg-yellow-100 text-yellow-700 border-yellow-200",
  red: "bg-red-100 text-red-700 border-red-200",
} as const;

export default function DifficultyBadge({
  level,
  size = "sm",
}: {
  level: DifficultyLevel;
  size?: "sm" | "md";
}) {
  const info = getDifficultyInfo(level);
  const classes = colorMap[info.color];
  const sizeClasses =
    size === "md"
      ? "px-3 py-1 text-sm"
      : "px-2 py-0.5 text-xs";

  return (
    <span
      className={`inline-flex items-center gap-1 rounded-full border font-medium ${classes} ${sizeClasses}`}
    >
      <span
        className="inline-block w-2 h-2 rounded-full"
        style={{ backgroundColor: info.hex }}
      />
      {info.label_th}
    </span>
  );
}
