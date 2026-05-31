"use client";

import { useEffect, useState } from "react";

const REWARDS = [
  { emoji: "🔥", text: "ติดต่อกันอีก!", bg: "bg-orange-100", color: "text-orange-700" },
  { emoji: "⭐", text: "เก่งมาก!", bg: "bg-amber-100", color: "text-amber-700" },
  { emoji: "🚀", text: "ไปต่อเรื่อยๆ!", bg: "bg-sky-100", color: "text-sky-700" },
  { emoji: "🧠", text: "สมองโตขึ้นแล้ว", bg: "bg-purple-100", color: "text-purple-700" },
  { emoji: "🎯", text: "Bullseye!", bg: "bg-emerald-100", color: "text-emerald-700" },
  { emoji: "🏆", text: "Champion!", bg: "bg-yellow-100", color: "text-yellow-700" },
  { emoji: "💎", text: "การ์ดมูลค่าสูง!", bg: "bg-cyan-100", color: "text-cyan-700" },
  { emoji: "⚡", text: "เร็วและแม่น", bg: "bg-violet-100", color: "text-violet-700" },
];

/**
 * Variable reward — random message after task completion. Skinner box principle
 * — unpredictable reward schedule keeps dopamine response strong (Duolingo,
 * social media use this).
 */
export default function RewardBadge() {
  const [reward, setReward] = useState<typeof REWARDS[number] | null>(null);

  useEffect(() => {
    setReward(REWARDS[Math.floor(Math.random() * REWARDS.length)]);
  }, []);

  if (!reward) return null;

  return (
    <div
      className={`inline-flex items-center gap-2 px-4 py-2 rounded-full font-semibold ${reward.bg} ${reward.color} animate-in fade-in zoom-in duration-500`}
    >
      <span className="text-xl">{reward.emoji}</span>
      <span>{reward.text}</span>
    </div>
  );
}
