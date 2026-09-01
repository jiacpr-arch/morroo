"use client";

import { useEffect, useState } from "react";
import { Award, Download, ImageDown } from "lucide-react";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import { CERT_KINDS, evaluateTheoryEligibility } from "@/lib/firstaid/content/cert";
import {
  issueTheoryCertificate,
  getStoredTheoryCert,
  type IssuedCert,
} from "@/lib/firstaid/certIssue";
import CertificatePreview from "@/components/firstaid/CertificatePreview";
import LineGateCard from "@/components/firstaid/LineGateCard";
import { downloadCertPdf } from "@/lib/firstaid/certPdf";
import { downloadCertPng } from "@/lib/firstaid/certImage";
import { track } from "@/lib/firstaid/analytics";

function fmtDate(iso?: string) {
  if (!iso) return "—";
  return new Date(iso).toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

const isEmail = (v: string) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim());
const phoneDigits = (v: string) => v.replace(/\D/g, "");

type Props = {
  postAttempt?: any;
  onIssued?: (cert: IssuedCert) => void;
};

// Self-service theory certificate card: collects name + phone + email + PDPA consent,
// issues the certificate once (server-backed with local fallback), then locks.
// Shared by the post-test results screen and the /certificate page.
export default function TheoryCertCard({ postAttempt, onIssued }: Props) {
  const learner = useLearnerStore((s) => s.learner);
  const updateLearner = useLearnerStore((s) => s.updateLearner);

  const [cert, setCert] = useState<IssuedCert | null>(null);
  const [loaded, setLoaded] = useState(false);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [consent, setConsent] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  // Previously issued cert now lives in localStorage (Dexie is gone) — read in
  // an effect so the server render stays deterministic.
  useEffect(() => {
    if (!learner?.id) return;
    setCert(getStoredTheoryCert(learner.id));
    setLoaded(true);
  }, [learner?.id]);

  // Seed the form from the learner profile once it's available.
  const [seededFor, setSeededFor] = useState<string | null>(null);
  if (learner?.id && seededFor !== learner.id) {
    setSeededFor(learner.id);
    setName(learner.name || "");
    setPhone(learner.phone || "");
    setEmail(learner.email || "");
  }

  const accent = CERT_KINDS.theory.accent;
  const theoryEval = evaluateTheoryEligibility({ postTestAttempt: postAttempt });
  const lineAdded = !!learner?.lineAdded;

  const confirmLine = () => {
    // updateLearner persists via the zustand store (localStorage) — no Dexie upsert.
    updateLearner({ lineAdded: true });
    track("line_add", { source: "cert_gate" });
  };

  const nameOk = name.trim().length > 0;
  const phoneOk = phoneDigits(phone).length >= 9;
  const emailOk = isEmail(email);
  const canIssue = nameOk && phoneOk && emailOk && consent && theoryEval.eligible && !busy;

  const issue = async () => {
    if (!canIssue || !learner?.id) return;
    setBusy(true);
    setError("");
    try {
      const patch = { name: name.trim(), phone: phone.trim(), email: email.trim() };
      updateLearner(patch);
      const merged = { ...learner, ...patch };
      const { cert: issued } = await issueTheoryCertificate({
        learner: merged,
        attempt: postAttempt,
        phone: patch.phone,
        email: patch.email,
      });
      setCert(issued);
      onIssued?.(issued);
    } catch (err) {
      console.error("issue theory cert failed", err);
      setError("ออกใบประกาศไม่สำเร็จ กรุณาลองใหม่");
    } finally {
      setBusy(false);
    }
  };

  const certArgs = () => ({
    kind: "theory",
    learnerName: cert!.learnerName || learner?.name || "",
    dateStr: fmtDate(cert!.issuedAt),
    code: cert!.code,
  });

  const downloadPdf = () => {
    downloadCertPdf(certArgs()).catch((err) => {
      console.error("download cert pdf failed", err);
      setError("สร้าง PDF ไม่สำเร็จ กรุณาลองใหม่");
    });
  };

  const downloadPng = () => {
    downloadCertPng(certArgs()).catch((err) => {
      console.error("download cert png failed", err);
      setError("บันทึกรูปไม่สำเร็จ กรุณาลองใหม่");
    });
  };

  return (
    <div className="card" style={{ marginTop: 16, borderTop: `4px solid ${accent}` }}>
      <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
        <Award size={22} color={accent} />
        <div style={{ flex: 1 }}>
          <div className="text-body-strong">ใบประกาศภาคทฤษฎี</div>
          <div className="text-caption">ออกเมื่อผ่าน Post-test ≥ 80%</div>
        </div>
        {cert ? (
          <span className="badge badge-success">ได้รับแล้ว</span>
        ) : theoryEval.eligible && !lineAdded ? (
          <span className="badge badge-brand">อีกขั้นเดียว</span>
        ) : theoryEval.eligible ? (
          <span className="badge badge-brand">พร้อมออก</span>
        ) : (
          <span className="badge badge-muted">ยังไม่พร้อม</span>
        )}
      </div>

      {/* Already issued — locked preview + download */}
      {cert && (
        <>
          <div style={{ marginTop: 14 }}>
            <CertificatePreview
              kind="theory"
              learnerName={cert.learnerName || learner?.name || ""}
              dateStr={fmtDate(cert.issuedAt)}
              code={cert.code}
            />
          </div>
          <div className="text-caption" style={{ marginTop: 8 }}>
            ออกใบประกาศแล้ว — ข้อมูลถูกล็อก หากต้องการแก้ไขกรุณาติดต่อเจ้าหน้าที่
          </div>
          <button
            type="button"
            className="btn btn-secondary btn-block"
            style={{ marginTop: 10 }}
            onClick={downloadPng}
          >
            <ImageDown size={16} /> บันทึกเป็นรูปภาพ (PNG)
          </button>
          <button
            type="button"
            className="btn btn-secondary btn-block"
            style={{ marginTop: 8 }}
            onClick={downloadPdf}
          >
            <Download size={16} /> ดาวน์โหลด PDF
          </button>
        </>
      )}

      {/* Not yet eligible */}
      {loaded && !cert && !theoryEval.eligible && (
        <div className="text-caption" style={{ marginTop: 8 }}>
          {theoryEval.reason}
        </div>
      )}

      {/* Eligible & not issued — LINE gate first, then form */}
      {loaded && !cert && theoryEval.eligible && !lineAdded && (
        <LineGateCard onConfirm={confirmLine} />
      )}

      {loaded && !cert && theoryEval.eligible && lineAdded && (
        <div style={{ marginTop: 12 }}>
          <label className="label">ชื่อ-นามสกุล</label>
          <input
            className="input"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="ชื่อที่จะแสดงบนใบประกาศ"
          />

          <label className="label" style={{ marginTop: 10 }}>
            เบอร์โทร
          </label>
          <input
            className="input"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            inputMode="tel"
            placeholder="0XX-XXX-XXXX"
          />

          <label className="label" style={{ marginTop: 10 }}>
            อีเมล
          </label>
          <input
            className="input"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            inputMode="email"
            type="email"
            placeholder="you@email.com"
          />

          <label
            style={{
              display: "flex",
              gap: 8,
              alignItems: "flex-start",
              marginTop: 12,
              cursor: "pointer",
            }}
          >
            <input
              type="checkbox"
              checked={consent}
              onChange={(e) => setConsent(e.target.checked)}
              style={{ marginTop: 3 }}
            />
            <span className="text-caption">
              ยินยอมให้ Jia Training Center เก็บและใช้ชื่อ เบอร์โทร และอีเมล
              เพื่อออกใบประกาศและติดต่อเรื่องการอบรม ตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล (PDPA)
            </span>
          </label>

          {error && (
            <div className="callout callout-warning" style={{ marginTop: 10 }}>
              {error}
            </div>
          )}

          <button
            type="button"
            className="btn btn-primary btn-block"
            style={{ marginTop: 12 }}
            disabled={!canIssue}
            onClick={issue}
          >
            {busy ? "กำลังออกใบประกาศ…" : "ออกใบประกาศ"}
          </button>
          {!consent && (
            <div className="text-caption" style={{ marginTop: 6, textAlign: "center" }}>
              กรุณากรอกข้อมูลให้ครบและติ๊กยินยอมก่อนออกใบประกาศ
            </div>
          )}
        </div>
      )}
    </div>
  );
}
