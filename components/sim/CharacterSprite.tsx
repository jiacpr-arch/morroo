"use client";

import { useEffect, useState } from "react";
import {
  GenericPlaceholder,
  characterImageUrl,
  getCharacter,
} from "@/lib/sim/characters";
import type { Pose } from "@/lib/sim/types";

// จำผลโหลดรูปต่อ URL ไว้ทั้ง session — กัน request ซ้ำๆ ไปหาไฟล์ที่ไม่มี
const imageCache = new Map<string, boolean>();

function probeImage(url: string): Promise<boolean> {
  const cached = imageCache.get(url);
  if (cached !== undefined) return Promise.resolve(cached);
  return new Promise((resolve) => {
    const img = new Image();
    img.onload = () => { imageCache.set(url, true); resolve(true); };
    img.onerror = () => { imageCache.set(url, false); resolve(false); };
    img.src = url;
  });
}

type ProbeResult = { base: string; talk: string | null } | false;

interface Props {
  charId: string;
  pose?: Pose;
  talking?: boolean;
  /** ตัวละครจาก DB: URL รูปต่อ pose (`${pose}` / `${pose}_talk`) จาก Supabase Storage */
  images?: Record<string, string>;
  /** ชื่อสำหรับ alt เมื่อเป็นตัวละคร DB */
  name?: string;
}

/**
 * ตัวละครบนเวที — image-first + SVG placeholder fallback
 *
 * ตัวละคร built-in: probe /images/sim/characters/{charId}/{pose}.webp
 *   (+ {pose}_talk.webp) → ไม่มีรูปใช้ SVG จาก registry
 * ตัวละคร DB (มี prop images): ใช้ URL ที่อัปโหลดไว้ตรงๆ — ท่าที่ไม่มีรูป
 *   fallback เป็นรูปท่า idle แล้วค่อยเป็น GenericPlaceholder
 */
export default function CharacterSprite({ charId, pose = "idle", talking = false, images, name }: Props) {
  const char = getCharacter(charId);
  const probeKey = `${charId}/${pose}`;
  // เก็บผล probe คู่กับ key — key ไม่ตรง = ยัง probing
  const [probe, setProbe] = useState<{ key: string | null; result: ProbeResult | null }>({
    key: null,
    result: null,
  });
  const [frame, setFrame] = useState(0);

  const isDbCharacter = !char && !!images;

  useEffect(() => {
    if (!char) return undefined;
    let alive = true;
    const baseUrl = characterImageUrl(charId, pose);
    const talkUrl = characterImageUrl(charId, pose, true);
    Promise.all([probeImage(baseUrl), probeImage(talkUrl)]).then(([hasBase, hasTalk]) => {
      if (!alive) return;
      setProbe({
        key: `${charId}/${pose}`,
        result: hasBase ? { base: baseUrl, talk: hasTalk ? talkUrl : null } : false,
      });
    });
    return () => { alive = false; };
  }, [charId, pose, char]);

  // ปากขยับ: สลับ 2 เฟรมระหว่างพิมพ์บทพูด
  useEffect(() => {
    if (!talking) {
      setFrame(0);
      return undefined;
    }
    const iv = setInterval(() => setFrame((f) => (f + 1) % 2), 130);
    return () => clearInterval(iv);
  }, [talking]);

  const mouthOpen = talking && frame === 1;

  if (isDbCharacter) {
    const base = images[pose] ?? images.idle;
    if (base) {
      const talkImg = images[`${pose}_talk`];
      const src = mouthOpen && talkImg ? talkImg : base;
      // eslint-disable-next-line @next/next/no-img-element -- รูปจาก Supabase Storage (URL dynamic); ไม่ใช้ next/image
      return <img src={src} alt={name ?? charId} className="cbs-sprite-img" draggable="false" />;
    }
    return (
      <div className="cbs-sprite-svg">
        <GenericPlaceholder pose={pose} mouthOpen={mouthOpen} />
      </div>
    );
  }

  if (!char) return null;

  const imgState = probe.key === probeKey ? probe.result : null; // null=probing

  if (imgState) {
    const src = mouthOpen && imgState.talk ? imgState.talk : imgState.base;
    // eslint-disable-next-line @next/next/no-img-element -- asset เกมใน public/ ที่ probe แบบ dynamic; ไม่ใช้ next/image
    return <img src={src} alt={char.name} className="cbs-sprite-img" draggable="false" />;
  }

  // probing (สั้นมาก) หรือไม่มีรูปจริง → SVG placeholder
  const Placeholder = char.Placeholder;
  return (
    <div className="cbs-sprite-svg">
      <Placeholder pose={pose} mouthOpen={mouthOpen} />
    </div>
  );
}
