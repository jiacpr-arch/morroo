"use client";

import { useEffect, useState } from "react";
import { Award, Download, ImageDown } from "lucide-react";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import { useProgressStore } from "@/lib/firstaid/stores/progressStore";
import { useEnsureProgress } from "@/lib/firstaid/hooks/useProgress";
import {
  CERT_KINDS,
  evaluatePracticalEligibility,
} from "@/lib/firstaid/content/cert";
import CertificatePreview from "@/components/firstaid/CertificatePreview";
import CertUpsellCard from "@/components/firstaid/CertUpsellCard";
import TheoryCertCard from "@/components/firstaid/TheoryCertCard";
import { downloadCertPdf } from "@/lib/firstaid/certPdf";
import { downloadCertPng } from "@/lib/firstaid/certImage";

function fmtDate(iso?: string | null) {
  if (!iso) return "—";
  const d = new Date(iso);
  return d.toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

export default function CertificationBody() {
  useEnsureLearner();
  const learner = useLearnerStore((s) => s.learner);

  // Best post-test attempt now comes from the server-backed progress store
  // (replaces Dexie getBestExam) — refresh() loads bestPost alongside progress.
  const bestPost = useProgressStore((s) => s.bestPost);
  useEnsureProgress(learner?.id);

  const [certs, setCerts] = useState<any[]>([]);

  // Issued certificates (theory + practical, incl. rows migrated from the old
  // app). Tolerates a missing/failed endpoint: the theory card self-manages
  // its own state, and practical then just shows "รออนุมัติ".
  useEffect(() => {
    if (!learner?.id) return;
    let cancelled = false;
    fetch(
      `/api/firstaid/certificates?learnerId=${encodeURIComponent(learner.id)}`,
    )
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        if (cancelled || !data) return;
        const list = Array.isArray(data) ? data : data.certificates;
        if (Array.isArray(list)) setCerts(list);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [learner?.id]);

  const theoryCert = certs.find((c) => c.kind === "theory");
  const practicalCert = certs.find((c) => c.kind === "practical");

  const practicalEval = evaluatePracticalEligibility({
    hasTheory: !!theoryCert,
    approvedAttendance: practicalCert?.fromApproval || false,
  });

  const onTheoryIssued = (cert: any) => {
    setCerts((c) => [...c.filter((x) => x.kind !== "theory"), cert]);
  };

  const certArgs = (cert: any) => ({
    kind: cert.kind,
    learnerName: cert.learnerName || learner?.name || "",
    dateStr: fmtDate(cert.issuedAt),
    code: cert.code,
    instructorName: cert.instructorName,
    location: cert.location,
  });

  const downloadPdf = (cert: any) => {
    downloadCertPdf(certArgs(cert)).catch((err: unknown) => {
      console.error("download cert pdf failed", err);
      alert("สร้าง PDF ไม่สำเร็จ กรุณาลองใหม่");
    });
  };

  const downloadPng = (cert: any) => {
    downloadCertPng(certArgs(cert)).catch((err: unknown) => {
      console.error("download cert png failed", err);
      alert("บันทึกรูปไม่สำเร็จ กรุณาลองใหม่");
    });
  };

  return (
    <div className="page-container">
      <div style={{ marginTop: 8 }}>
        <div className="text-caption">ใบประกาศของฉัน</div>
        <div className="text-title">ทฤษฎี + ปฏิบัติ</div>
      </div>

      {/* Theory — self-service issuance (name + phone + email + PDPA consent) */}
      <TheoryCertCard postAttempt={bestPost} onIssued={onTheoryIssued} />

      {/* Practical */}
      <div className="card" style={{ marginTop: 16, borderTop: `4px solid ${CERT_KINDS.practical.accent}` }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <Award size={22} color={CERT_KINDS.practical.accent} />
          <div style={{ flex: 1 }}>
            <div className="text-body-strong">ใบประกาศภาคปฏิบัติ</div>
            <div className="text-caption">ครูผู้สอนจะอนุมัติให้หลังเรียนปฏิบัติเสร็จ</div>
          </div>
          {practicalCert ? (
            <span className="badge badge-success">ได้รับแล้ว</span>
          ) : (
            <span className="badge badge-muted">รออนุมัติ</span>
          )}
        </div>
        {!practicalCert && (
          <div className="text-caption" style={{ marginTop: 8 }}>
            {practicalEval.reason || "มาเช็คชื่อภาคปฏิบัติแล้วรอครูอนุมัติ"}
          </div>
        )}
        {practicalCert && (
          <>
            <div style={{ marginTop: 14 }}>
              <CertificatePreview
                kind="practical"
                learnerName={practicalCert.learnerName || learner?.name || ""}
                dateStr={fmtDate(practicalCert.issuedAt)}
                code={practicalCert.code}
                instructorName={practicalCert.instructorName}
                location={practicalCert.location}
              />
            </div>
            <button
              type="button"
              className="btn btn-secondary btn-block"
              style={{ marginTop: 10 }}
              onClick={() => downloadPng(practicalCert)}
            >
              <ImageDown size={16} /> บันทึกเป็นรูปภาพ (PNG)
            </button>
            <button
              type="button"
              className="btn btn-secondary btn-block"
              style={{ marginTop: 8 }}
              onClick={() => downloadPdf(practicalCert)}
            >
              <Download size={16} /> ดาวน์โหลด PDF
            </button>
          </>
        )}
      </div>

      {/* ชวนต่อยอดไปอบรมภาคปฏิบัติ — แสดงเมื่อได้ใบประกาศแล้ว */}
      {(theoryCert || practicalCert) && <CertUpsellCard source="cert_page" />}
    </div>
  );
}
