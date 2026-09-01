"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

// Legacy client-side LINE OAuth landing URL from the old SPA. The real OAuth
// callback is now the API route (/api/firstaid/auth/line/callback) — anything
// still landing here (stale links, old LINE console entries) just gets sent
// on to /settings, where login state is visible.
export default function LineCallbackClient() {
  const router = useRouter();

  useEffect(() => {
    router.replace("/settings");
  }, [router]);

  return (
    <div className="page-container py-12 text-center text-caption">
      กำลังพาไปหน้าตั้งค่า…
    </div>
  );
}
