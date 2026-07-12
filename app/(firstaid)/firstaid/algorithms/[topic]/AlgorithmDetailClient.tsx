"use client";

import Link from "next/link";
import { useState, useEffect } from "react";
import { ArrowLeft } from "lucide-react";
import { algorithmsById } from "@/lib/firstaid/content/algorithms";
import AlgorithmFlowchart from "@/components/firstaid/AlgorithmFlowchart";
import CallEmergencyButton from "@/components/firstaid/CallEmergencyButton";
import { fetchContentMedia } from "@/lib/firstaid/lessonMediaSteps";

export default function AlgorithmDetailClient({ topic }: { topic: string }) {
  const algorithm = (algorithmsById as Record<string, any>)[topic];
  const [media, setMedia] = useState<any[]>([]);

  // โหลดสื่อที่แอดมินผูกไว้กับผังนี้ (passthrough ใน Phase 1)
  useEffect(() => {
    let cancelled = false;
    fetchContentMedia("algorithm", topic).then((rows: any[]) => {
      if (!cancelled) setMedia(rows);
    });
    return () => {
      cancelled = true;
    };
  }, [topic]);

  if (!algorithm) {
    return (
      <div className="page-container">
        <div className="card">ไม่พบ algorithm</div>
        <Link href="/algorithms" className="btn btn-primary btn-block" style={{ marginTop: 12 }}>
          กลับไปรายการ
        </Link>
      </div>
    );
  }

  return (
    <div className="page-container">
      <Link href="/algorithms" className="btn btn-ghost" style={{ paddingLeft: 0 }}>
        <ArrowLeft size={16} /> รายการ algorithm
      </Link>
      <div style={{ marginTop: 4 }}>
        <div className="text-caption">{algorithm.summary}</div>
        <div className="text-title" style={{ color: algorithm.color }}>{algorithm.title}</div>
      </div>
      <div style={{ marginTop: 16 }}>
        <AlgorithmFlowchart algorithm={algorithm} media={media} />
      </div>
      <CallEmergencyButton />
    </div>
  );
}
