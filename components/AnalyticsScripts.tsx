import Script from "next/script";
import { GOOGLE_ADS_ID } from "@/lib/google-ads";

const GA_ID = process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID ?? "";

/**
 * Loads gtag.js with both GA4 and Google Ads tags configured.
 *
 * Either ID can be missing — the script only loads when at least one is set,
 * and `gtag('config', …)` is called only for IDs that are present.
 */
export default function AnalyticsScripts() {
  if (!GA_ID && !GOOGLE_ADS_ID) return null;

  // gtag.js needs one src — use whichever ID we have. Both IDs can be
  // configured against the same loaded script via separate `config` calls.
  const loaderId = GA_ID || GOOGLE_ADS_ID;

  const init = `
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    window.gtag = gtag;
    gtag('js', new Date());
    ${GA_ID ? `gtag('config', '${GA_ID}');` : ""}
    ${GOOGLE_ADS_ID ? `gtag('config', '${GOOGLE_ADS_ID}');` : ""}
  `;

  return (
    <>
      <Script
        src={`https://www.googletagmanager.com/gtag/js?id=${loaderId}`}
        strategy="afterInteractive"
      />
      <Script id="gtag-init" strategy="afterInteractive">
        {init}
      </Script>
    </>
  );
}
