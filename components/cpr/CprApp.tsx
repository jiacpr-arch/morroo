"use client";
// Root ของแอปคอร์ส CPR — แทน switch(page) state machine เดิมของ jia-online ด้วย URL จริงใต้ /cpr
// state ผู้เรียนทั้งหมดยังอยู่ใน localStorage (คีย์ jia_* เดิม) — render หลัง mount เท่านั้น
// เพื่อเลี่ยง hydration mismatch เพราะคอมโพเนนต์เดิมอ่าน localStorage ระหว่าง render
import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { AUTH_GATE_ENABLED, B, FN_HEADERS, FN_URL } from "@/lib/cpr/config";
import { captureUTM, getGateVariant, getPurchased, getUTM, isSignedUp, load, save, savePurchased, type CprProgress, type CprUser } from "@/lib/cpr/storage";
import { loadLiff, normalizePhone, supaRest } from "@/lib/cpr/api";
import { getPosthog } from "@/lib/cpr/analytics";
import InAppNotice from "./InAppNotice";
import Landing from "./Landing";
import Store from "./Store";
import TeaserQuiz from "./TeaserQuiz";
import SignupGate from "./SignupGate";
import Register from "./Register";
import LineAddPrompt from "./LineAddPrompt";
import Claim from "./Claim";
import Payment from "./Payment";
import Course from "./Course";
import Certificate from "./Certificate";
import MiniCert from "./MiniCert";
import Booking from "./Booking";
import { BlogDetail, BlogList } from "./Blog";
import type { CprPage } from "./types";

// slug ใน URL ↔ ชื่อ page ภายใน (ชื่อ page คงเดิมเพื่อให้ค่า jia_last_page เดิมใช้ต่อได้)
const SLUG_TO_PAGE: Record<string, CprPage> = {
  store: "store",
  quiz: "teaserquiz",
  signup: "signupgate",
  register: "register",
  "line-add": "lineprompt",
  claim: "claim",
  payment: "payment",
  course: "course",
  certificate: "certificate",
  minicert: "minicert",
  booking: "booking",
  blog: "blog",
};
const PAGE_TO_PATH: Record<CprPage, string> = {
  landing: "/cpr",
  store: "/cpr/store",
  teaserquiz: "/cpr/quiz",
  signupgate: "/cpr/signup",
  register: "/cpr/register",
  lineprompt: "/cpr/line-add",
  claim: "/cpr/claim",
  payment: "/cpr/payment",
  course: "/cpr/course",
  certificate: "/cpr/certificate",
  minicert: "/cpr/minicert",
  booking: "/cpr/booking",
  blog: "/cpr/blog",
  "blog-detail": "/cpr/blog",
};
// หน้าที่ "จำตำแหน่งไว้ในเครื่อง" แล้วเปิดกลับมาที่เดิมได้ (กันนักเรียนต้องเริ่มขั้นตอนแรกใหม่ทุกครั้ง)
const RESUMABLE_PAGES: CprPage[] = ["course", "store", "register", "certificate", "minicert", "booking", "claim", "blog"];

// เคยลงทะเบียน/ซื้อ/ปลดล็อก/มีความคืบหน้าแล้ว = กลับเข้าคอร์สได้เลย ไม่ต้องผ่านด่านสมัครซ้ำ
// ใช้คีย์ดิบที่บันทึกจริง (purchased/promo_unlocked) ไม่ใช้ getPurchased()
const hasEnrolledBefore = () =>
  isSignedUp() ||
  load<CprProgress>("progress", { done: [], scores: {} }).done.length > 0 ||
  load("enrolled", false) ||
  load("promo_redeemed", false) ||
  (load<number[]>("purchased", []) || []).some((x) => x > 1) ||
  (load<number[]>("promo_unlocked", []) || []).length > 0;

type Search = Record<string, string | undefined>;

export default function CprApp({ segments, search }: { segments: string[]; search: Search }) {
  const router = useRouter();
  const [ready, setReady] = useState(false);
  const [user, setUserState] = useState<CprUser | null>(null);
  const [progress, setProgressState] = useState<CprProgress>({ done: [], scores: {} });
  const setUser = useCallback((u: CprUser) => { setUserState(u); save("user", u); }, []);
  const setProgress = useCallback((p: CprProgress) => { setProgressState(p); save("progress", p); }, []);

  const go = useCallback((p: CprPage) => { router.push(PAGE_TO_PATH[p]); window.scrollTo(0, 0); }, [router]);
  const openBlog = useCallback((slug: string) => { router.push(`/cpr/blog/${encodeURIComponent(slug)}`); window.scrollTo(0, 0); }, [router]);

  // page ปัจจุบันจาก URL
  const seg0 = segments[0] || "";
  const blogSlug = seg0 === "blog" && segments[1] ? decodeURIComponent(segments[1]) : null;
  const page: CprPage = !seg0 ? "landing" : blogSlug ? "blog-detail" : SLUG_TO_PAGE[seg0] || "landing";

  const promoParam = search.promo || null;
  const codeParam = search.code || null;
  const stripeParam = search.stripe || null;
  const adminParam = search.admin || null;

  // ── mount: hydrate state จาก localStorage + จัดการ deep links + redirect resume ──
  useEffect(() => {
    // ?admin=1 — Admin CRM ยังไม่ย้าย (Phase 4) ให้ไปใช้ระบบเดิมก่อน
    if (adminParam === "1") {
      window.location.href = "https://cpr.morroo.com/?admin=1";
      return;
    }
    captureUTM();
    setUserState(load<CprUser | null>("user", null));
    setProgressState(load<CprProgress>("progress", { done: [], scores: {} }));

    // ?promo=CODE → ไปหน้า claim พร้อมเติมโค้ด
    if (promoParam) {
      router.replace(`/cpr/claim?code=${encodeURIComponent(promoParam)}`);
      setReady(true);
      return;
    }

    // Stripe success → merge โมดูลที่ซื้อ + PATCH สถานะ + ล้าง query
    if (stripeParam === "success") {
      const mods = search.modules;
      if (mods) {
        const newMods = mods.split(",").map(Number).filter(Boolean);
        const current = getPurchased();
        const merged = [...new Set([...current, ...newMods])];
        savePurchased(merged);
        // อัปเดตสถานะเฉพาะเมื่อมีเบอร์จริง — กัน filter phone ว่างไป match ทุกแถวที่ไม่มีเบอร์
        const payPhone = normalizePhone(load<CprUser | null>("user", null)?.phone || "");
        if (payPhone) supaRest("online_purchases", "PATCH", { payment_status: "ชำระแล้ว" }, `?phone=eq.${encodeURIComponent(payPhone)}&payment_status=eq.รอชำระ`);
      }
      router.replace("/cpr/course");
      setReady(true);
      return;
    }
    if (stripeParam === "cancel") {
      router.replace("/cpr/course");
      setReady(true);
      return;
    }

    // เปิดที่ root /cpr → resume ตาม flow เดิม (last_page / เคยสมัครแล้ว / front gate)
    if (!seg0) {
      const last = load<CprPage | null>("last_page", null);
      if (last && RESUMABLE_PAGES.includes(last)) {
        if (last !== "landing") router.replace(PAGE_TO_PATH[last]);
        setReady(true);
        return;
      }
      if (hasEnrolledBefore()) {
        router.replace("/cpr/course");
        setReady(true);
        return;
      }
      // front gate (before-course): เปิดเว็บครั้งแรก → ควิซเกริ่นนำ → ถ้าทำควิซแล้วแต่ยังไม่สมัคร → ด่านสมัคร
      if (AUTH_GATE_ENABLED && getGateVariant() === "before-course") {
        router.replace(load("teaser_done", false) ? "/cpr/signup" : "/cpr/quiz");
        setReady(true);
        return;
      }
    }
    setReady(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // จำหน้าล่าสุดไว้ในเครื่อง (localStorage) เฉพาะหน้าที่กลับมาเปิดต่อได้
  useEffect(() => {
    if (ready && RESUMABLE_PAGES.includes(page)) save("last_page", page);
  }, [ready, page]);

  // A/B variant จาก PostHog feature flag `gate_placement`
  useEffect(() => {
    getPosthog().then((ph) => {
      if (ph) {
        try {
          ph.onFeatureFlags(() => {
            const v = ph.getFeatureFlag("gate_placement");
            if (typeof v === "string" && ["before-course", "after-lesson-1", "soft"].includes(v)) save("gate_variant", v);
          });
        } catch (_e) {}
      }
    });
  }, []);

  // Auto-link LINE: ถ้าเปิดในแอป LINE (LIFF) และเป็นนักเรียนที่สมัครแล้วแต่ยังไม่ผูก line_user_id
  // → ผูกเงียบๆ ผ่าน auth-line-link (ดึง line_user_id + กู้ progress กลับมา) โดยไม่ต้องให้ลูกค้าพิมพ์โค้ด
  useEffect(() => {
    const u = load<CprUser | null>("user", null);
    if (!u?.phone || u?.line_user_id) return;
    (async () => {
      try {
        const liff = await loadLiff();
        if (!liff || typeof liff.isInClient !== "function" || !liff.isInClient()) return;
        if (!liff.isLoggedIn()) return;
        let idToken: string | null = null;
        try { idToken = liff.getIDToken(); } catch (_e) {}
        if (!idToken) return;
        const res = await fetch(FN_URL("auth-line-link"), {
          method: "POST",
          headers: FN_HEADERS,
          body: JSON.stringify({
            id_token: idToken, phone: u.phone, pdpa: true, display_name: u.name || "",
            utm: getUTM(), landing_url: load("landing_url", null), local_progress: load("progress", { done: [], scores: {} }),
            gate_variant: getGateVariant(),
          }),
        });
        const data = await res.json().catch(() => ({}));
        if (data?.ok) {
          const nu: CprUser = { ...u, line_user_id: data.line_user_id, customer_id: data.customer_id || u.customer_id };
          setUserState(nu);
          save("user", nu);
          save("line_added", true);
          if (data.progress) { setProgressState(data.progress); save("progress", data.progress); }
        }
      } catch (_e) {}
    })();
     
  }, []);

  // เข้าคอร์ส: ขึ้นกับตัวแปรด่าน (A/B) — before-course เด้งสมัครก่อน, soft = แอด LINE แบบข้ามได้
  const enterCourse = useCallback(() => {
    const v = getGateVariant();
    if (AUTH_GATE_ENABLED && v === "before-course" && !isSignedUp()) {
      go(load("teaser_done", false) ? "signupgate" : "teaserquiz");
      return;
    }
    if ((!AUTH_GATE_ENABLED || v === "soft") && !load("line_added", false) && !load("line_skipped_at", null)) {
      go("lineprompt");
      return;
    }
    go("course");
  }, [go]);

  const backFromBlog = useCallback(() => {
    go(load<CprProgress>("progress", { done: [], scores: {} }).done.length > 0 ? "course" : "landing");
  }, [go]);

  // กัน hydration mismatch: SSR + first client render เป็น splash เดียวกัน แล้วค่อยเข้าแอปหลัง mount
  if (!ready)
    return (
      <div style={{ minHeight: "100vh", background: B.cream, display: "flex", alignItems: "center", justifyContent: "center", color: B.dkGray, fontSize: 14 }}>
        กำลังโหลด...
      </div>
    );

  return (
    <>
      <InAppNotice />
      {(() => {
        switch (page) {
          case "landing": return <Landing go={go} enterCourse={enterCourse} openBlog={openBlog} />;
          case "register": return <Register go={go} setUser={setUser} />;
          case "lineprompt": return <LineAddPrompt go={go} user={user} variant={isSignedUp() ? "post-register" : "pre-course"} />;
          case "teaserquiz": return <TeaserQuiz go={go} />;
          case "signupgate": return <SignupGate go={go} setUser={setUser} />;
          case "payment": return <Payment go={go} user={user} />;
          case "store": return <Store go={go} />;
          case "course": return <Course go={go} progress={progress} setProgress={setProgress} user={user} openBlog={openBlog} />;
          case "certificate": return <Certificate user={user} go={go} />;
          case "minicert": return <MiniCert user={user} go={go} />;
          case "booking": return <Booking go={go} />;
          case "blog": return <BlogList goBack={backFromBlog} openBlog={openBlog} />;
          case "blog-detail": return <BlogDetail slug={blogSlug || ""} goBack={() => go("blog")} openBlog={openBlog} />;
          case "claim": return <Claim go={go} setUser={setUser} initialStep={codeParam ? "redeem" : load("claim_start_redeem", false) ? "redeem" : "form"} initialCode={codeParam || ""} />;
          default: return <Landing go={go} enterCourse={enterCourse} openBlog={openBlog} />;
        }
      })()}
    </>
  );
}
