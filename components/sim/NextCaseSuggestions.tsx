"use client";

// "เคสถัดไปที่ควรเล่น" ท้ายเกม — แทนปุ่มสุ่มมั่ว
//
// ปุ่มสุ่มเดิมหยิบจาก 157 เคสแบบ uniform โดยไม่สนใจว่าผู้เล่นเพิ่งพลาดสาขาอะไร
// ผลคือคนแตะจริงแค่ 14 เคส (8%) ตัวนี้เลือกให้ตามประวัติ และ**บอกเหตุผล** ด้วย
// เพราะการบอกว่า "คุณเพิ่งพลาดเรื่องนี้" คือสิ่งที่ทำให้อยากกดต่อ ไม่ใช่แค่ชื่อเคส

import { useEffect, useState } from "react";
import Link from "next/link";
import { readLocalRuns } from "@/lib/sim/local-progress";
import type { Recommendation } from "@/lib/casegame/recommend";

interface Props {
  /** เคสที่เพิ่งเล่นจบ — ไม่แนะนำซ้ำตัวเอง */
  slug: string;
  won: boolean;
  grade: string | null;
  /** utm ที่ carry มา ต้องส่งต่อไม่งั้น attribution ของโฆษณาขาด */
  utm?: string;
}

export default function NextCaseSuggestions({ slug, won, grade, utm = "" }: Props) {
  const [picks, setPicks] = useState<Recommendation[] | null>(null);

  useEffect(() => {
    let cancelled = false;
    const controller = new AbortController();

    void (async () => {
      try {
        const res = await fetch("/api/casegame/recommend", {
          method: "POST",
          headers: { "content-type": "application/json" },
          signal: controller.signal,
          body: JSON.stringify({
            excludeSlug: slug,
            lastWon: won,
            lastGrade: grade,
            limit: 3,
            // คนไม่ล็อกอินไม่มีประวัติฝั่ง server — ส่งของในเครื่องไปแทน
            history: readLocalRuns().map((r) => ({
              slug: r.slug,
              specialty: r.specialty,
              won: r.won,
            })),
          }),
        });
        if (!res.ok) return;
        const json = (await res.json()) as { picks?: Recommendation[] };
        if (!cancelled) setPicks(json.picks ?? []);
      } catch {
        // เงียบ — จอ debrief ยังมีปุ่มอื่นให้ไปต่ออยู่แล้ว
      }
    })();

    return () => { cancelled = true; controller.abort(); };
  }, [slug, won, grade]);

  if (!picks || picks.length === 0) return null;

  return (
    <div className="cbs-next">
      <div className="cbs-tl-title">เคสถัดไปที่ควรเล่น</div>
      {picks.map((p) => (
        <Link key={p.slug} href={`/sim/${p.slug}${utm}`} className="cbs-next-item">
          <span className="cbs-next-title">{p.title}</span>
          <span className="cbs-next-reason">{p.reason}</span>
        </Link>
      ))}
    </div>
  );
}
