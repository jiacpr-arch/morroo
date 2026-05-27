"use client";

import { useEffect } from "react";
import { trackSignup } from "@/lib/analytics/conversions";

// app/auth/callback appends ?signup=1 on a brand-new signup. We read it from
// window (not useSearchParams) so mounting this in the root layout doesn't
// opt every page out of static rendering, then strip the param afterwards.
export default function SignupConversion() {
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    if (params.get("signup") !== "1") return;

    trackSignup();

    params.delete("signup");
    const qs = params.toString();
    window.history.replaceState(
      null,
      "",
      window.location.pathname + (qs ? `?${qs}` : "") + window.location.hash
    );
  }, []);

  return null;
}
