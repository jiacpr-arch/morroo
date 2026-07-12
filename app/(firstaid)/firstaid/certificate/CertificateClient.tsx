"use client";

import dynamic from "next/dynamic";

// The certificate render/export machinery (CertificateDocument via
// html-to-image + jsPDF) is browser-only — it touches DOM measurement and
// canvas APIs at module scope. Load the whole page body client-side only.
// (In Next 16, `ssr: false` is only allowed inside a client component, hence
// this wrapper.)
const CertificationBody = dynamic(() => import("./CertificationBody"), {
  ssr: false,
  loading: () => (
    <div className="page-container py-12 text-center text-caption">
      กำลังโหลด…
    </div>
  ),
});

export default function CertificateClient() {
  return <CertificationBody />;
}
