"use client";

import { useEffect, useState } from "react";
import { ExternalLink } from "lucide-react";

type Ad = {
  href: string;
  label: string;
  tagline: string;
  emoji: string;
};

const ADS: Ad[] = [
  {
    href: "https://emr.morroo.com",
    label: "MorRoo EMR",
    tagline: "ระบบเวชระเบียนอิเล็กทรอนิกส์สำหรับคลินิก",
    emoji: "🩺",
  },
  {
    href: "https://icd10.morroo.com",
    label: "ICD-10",
    tagline: "ค้นหารหัสโรค ICD-10 ภาษาไทยแบบเร็ว",
    emoji: "🔎",
  },
  {
    href: "https://lab.morroo.com",
    label: "Lab Reference",
    tagline: "ค่าแล็บอ้างอิงครบในที่เดียว",
    emoji: "🧪",
  },
  {
    href: "https://pocket.morroo.com",
    label: "Pocket MorRoo",
    tagline: "คู่มือพกพาสำหรับแพทย์",
    emoji: "📒",
  },
  {
    href: "https://advice.morroo.com",
    label: "MorRoo Advice",
    tagline: "ผู้ช่วย AI ให้คำแนะนำทางคลินิก",
    emoji: "💬",
  },
  {
    href: "https://roodee.me",
    label: "RooDee",
    tagline: "เครื่องมือช่วยอ่านหนังสือสอบ",
    emoji: "📚",
  },
  {
    href: "https://pharmru.com",
    label: "PharmRu",
    tagline: "คู่มือยาออนไลน์",
    emoji: "💊",
  },
  {
    href: "https://jiacpr.com",
    label: "JiaCPR",
    tagline: "บทความและสื่อทางการแพทย์",
    emoji: "✍️",
  },
  {
    href: "https://jia1669.com",
    label: "Jia 1669",
    tagline: "เครื่องมือฉุกเฉินทางการแพทย์",
    emoji: "🚑",
  },
];

const ROTATE_MS = 7000;

interface Props {
  placement: string;
  className?: string;
}

export default function InternalAdsBanner({ placement, className }: Props) {
  const [idx, setIdx] = useState<number | null>(null);

  useEffect(() => {
    setIdx(Math.floor(Math.random() * ADS.length));
    const t = setInterval(() => {
      setIdx((i) => (((i ?? 0) + 1) % ADS.length));
    }, ROTATE_MS);
    return () => clearInterval(t);
  }, []);

  if (idx === null) return null;
  const ad = ADS[idx];

  return (
    <a
      href={ad.href}
      target="_blank"
      rel="noopener noreferrer"
      data-placement={placement}
      data-ad-href={ad.href}
      className={`group block rounded-xl border border-brand/30 bg-gradient-to-r from-brand/5 via-white to-amber-50/40 px-4 py-3 transition hover:border-brand/60 hover:shadow-sm ${className ?? ""}`}
    >
      <div className="flex items-center gap-3">
        <span className="text-2xl shrink-0" aria-hidden>
          {ad.emoji}
        </span>
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2 flex-wrap">
            <span className="font-semibold text-sm text-gray-900">
              {ad.label}
            </span>
            <span className="text-[10px] uppercase tracking-wide text-muted-foreground bg-muted px-1.5 py-0.5 rounded">
              เว็บในเครือเรา
            </span>
          </div>
          <p className="text-xs text-muted-foreground truncate">
            {ad.tagline}
          </p>
        </div>
        <ExternalLink className="h-4 w-4 text-brand shrink-0 transition group-hover:translate-x-0.5" />
      </div>
    </a>
  );
}
