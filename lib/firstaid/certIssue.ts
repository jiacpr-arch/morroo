"use client";

import { generateCertCode } from "@/lib/firstaid/content/cert";
import type { Learner } from "@/lib/firstaid/stores/learnerStore";

export type IssuedCert = {
  id: string;
  learnerId: string;
  kind: "theory" | "practical";
  code: string;
  issuedAt: string;
  learnerName: string;
  learnerPhone?: string;
  learnerEmail?: string;
  synced: boolean;
};

// Dexie is gone — issued certificates are remembered per-device in localStorage
// so the card stays locked after a reload. The server (fa_certificates) remains
// the source of truth; issue-theory is idempotent, so a cleared device that
// re-issues just gets the same certificate row back.
const STORE_KEY = "firstaid.certificates.v1";

function readStore(): Record<string, IssuedCert> {
  if (typeof localStorage === "undefined") return {};
  try {
    const parsed = JSON.parse(localStorage.getItem(STORE_KEY) || "null");
    return parsed && typeof parsed === "object" ? parsed : {};
  } catch {
    return {};
  }
}

export function saveCertificate(cert: IssuedCert) {
  try {
    const store = readStore();
    store[cert.id] = cert;
    localStorage.setItem(STORE_KEY, JSON.stringify(store));
  } catch {
    // storage เต็ม/ปิดใช้งาน — ใบเซอร์ยังออกได้ แค่ไม่จำข้ามรีโหลด
  }
}

// The learner's stored theory certificate for this device, or null.
export function getStoredTheoryCert(learnerId: string): IssuedCert | null {
  return readStore()[`theory-${learnerId}`] ?? null;
}

type IssueArgs = {
  learner: Learner;
  attempt?: { answers?: unknown } | null;
  phone?: string;
  email?: string;
};

// Issues the theory certificate, preferring the server (Supabase-backed, gives a
// verifiable code + one-per-learner guarantee) and falling back to a purely local
// certificate when the backend is unreachable. Either way the result is persisted
// to localStorage so it survives reloads.
//
// The server re-scores the post-test from the raw answers (it never trusts a
// client-supplied score), so we send `answers` rather than score/passed.
// Auth rides along on the Supabase session cookie; anonymous issuance is keyed
// by the learnerId in the body — no Authorization header needed anymore.
export async function issueTheoryCertificate({ learner, attempt, phone, email }: IssueArgs) {
  const learnerName = (learner?.name || "").trim();
  const localId = `theory-${learner.id}`;

  try {
    const res = await fetch("/api/firstaid/certificates/issue-theory", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        learnerId: learner.id,
        learnerName,
        learnerPhone: phone,
        learnerEmail: email,
        consent: true,
        answers: attempt?.answers,
      }),
    });
    if (res.ok) {
      const { certificate } = await res.json();
      const cert: IssuedCert = {
        id: localId,
        learnerId: learner.id,
        kind: "theory",
        code: certificate.code,
        issuedAt: certificate.issued_at,
        learnerName: certificate.learner_name || learnerName,
        learnerPhone: certificate.learner_phone || phone,
        learnerEmail: certificate.learner_email || email,
        synced: true,
      };
      saveCertificate(cert);
      return { cert, synced: true };
    }
  } catch {
    // Network error / backend offline — fall through to local issuance.
  }

  // Local fallback: still give the learner a certificate they can keep & download.
  const cert: IssuedCert = {
    id: localId,
    learnerId: learner.id,
    kind: "theory",
    code: generateCertCode(),
    issuedAt: new Date().toISOString(),
    learnerName,
    learnerPhone: phone,
    learnerEmail: email,
    synced: false,
  };
  saveCertificate(cert);
  return { cert, synced: false };
}
