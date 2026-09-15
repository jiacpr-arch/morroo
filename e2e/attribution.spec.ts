import { test, expect } from "@playwright/test";

// UTM persistence + Meta Pixel completeness (2026-09-15) — แคมเปญโฆษณาวัดได้ว่า
// 362 คนเข้าเว็บ เห็นราคาแค่ 1% สมัครแค่ 0.3% แต่ตอบไม่ได้ว่า utm_campaign
// ไหนไปถึงขั้นไหนเพราะ query string หายทันทีที่ navigate ออกจากหน้าแรก
// (lib/attribution.ts) เทสนี้คุมว่า utm ติดไปกับทุก event จริง และ Meta pixel
// ยิง ViewContent(pricing) / Lead(line_oa) ตามที่เพิ่มใหม่

function collectAnalyticsEvents(page: import("@playwright/test").Page) {
  const tracked: { name: string; props: Record<string, unknown> }[] = [];
  page.route("**/api/analytics/track", async (route) => {
    const body = route.request().postDataJSON() as
      | { event_name?: string; properties?: Record<string, unknown> }
      | null;
    if (body?.event_name) tracked.push({ name: body.event_name, props: body.properties ?? {} });
    await route.fulfill({ status: 200, body: JSON.stringify({ ok: true }) });
  });
  return tracked;
}

test("first-touch utm from the ad link is attached to every later event", async ({ page }) => {
  const tracked = collectAnalyticsEvents(page);
  await page.addInitScript(() => {
    (window as unknown as { __fbq: unknown[][] }).__fbq = [];
    (window as unknown as { fbq: (...args: unknown[]) => void }).fbq = (...args: unknown[]) => {
      (window as unknown as { __fbq: unknown[][] }).__fbq.push(args);
    };
  });

  await page.goto("/?utm_source=fb&utm_medium=paid&utm_campaign=e2e_chk&utm_content=feed_a");

  // pageview เองต้องพก utm ไปด้วย (ใช้คู่กับ funnel SQL ใน docs/casegame-acquisition-plan.md)
  await expect
    .poll(() => tracked.some((e) => e.name === "pageview" && e.props.utm_campaign === "e2e_chk"))
    .toBe(true);

  // storage ทั้งสองชุดต้องถูกเขียน — first-touch (localStorage) + last-touch (sessionStorage)
  const stored = await page.evaluate(() => ({
    first: window.localStorage.getItem("morroo_attr_first"),
    last: window.sessionStorage.getItem("morroo_attr_last"),
  }));
  expect(stored.first).toContain("e2e_chk");
  expect(stored.last).toContain("e2e_chk");

  // คลิก HeroPriceLine (→ #pricing) ต้องยิง pricing_cta_click พร้อม utm ก่อน —
  // การนำทางไปกับ hash เองเป็นพฤติกรรมของ next/link ในแอปนี้ (คุมแยกด้วย
  // manual/smoke test เพราะ headless click กับ same-page hash anchor ไม่นิ่งพอ
  // จะยืนยันด้วย automation) เทสนี้จึงยืนยันแค่ว่า handler ยิง event ถูกต้อง
  await page.getByRole("link", { name: /สมาชิก ฿199/ }).first().click();
  await expect
    .poll(() => tracked.some((e) => e.name === "pricing_cta_click" && e.props.utm_campaign === "e2e_chk"))
    .toBe(true);

  // นำทางไปหน้าราคาจริง (คนละหน้า) — utm ที่เก็บไว้ตอนเข้าเว็บต้องยังติดไปกับ
  // pricing_view และคู่กับ Meta ViewContent(pricing) ด้วย พิสูจน์ว่า utm รอด
  // การ navigate ข้ามหน้า ไม่ใช่แค่รอดใน session เดียวกันบนหน้าเดิม
  await page.goto("/pricing");
  await expect
    .poll(() => tracked.some((e) => e.name === "pricing_view" && e.props.utm_campaign === "e2e_chk"), {
      timeout: 10_000,
    })
    .toBe(true);

  const fbqCalls = await page.evaluate(
    () => (window as unknown as { __fbq: unknown[][] }).__fbq,
  );
  expect(
    fbqCalls.some(
      (call) =>
        call[0] === "track" &&
        call[1] === "ViewContent" &&
        (call[2] as { content_name?: string })?.content_name === "pricing",
    ),
  ).toBe(true);
});

test("a fresh tab without utm falls back to first-touch attribution", async ({ page, context }) => {
  const tracked = collectAnalyticsEvents(page);
  await page.goto("/?utm_source=fb&utm_medium=paid&utm_campaign=e2e_first");
  await expect
    .poll(() => tracked.some((e) => e.name === "pageview"))
    .toBe(true);

  // localStorage carries across pages in the same origin/context — a second tab
  // with a clean sessionStorage simulates "opened a new tab, no fresh utm in URL"
  const page2 = await context.newPage();
  const tracked2 = collectAnalyticsEvents(page2);
  await page2.goto("/pricing");
  await expect
    .poll(() =>
      tracked2.some((e) => e.name === "pageview" && e.props.utm_touch === "first" && e.props.utm_campaign === "e2e_first"),
    )
    .toBe(true);
  await page2.close();
});

test("internal games-hub utm_source does not overwrite ad attribution", async ({ page }) => {
  const tracked = collectAnalyticsEvents(page);
  await page.goto("/?utm_source=fb&utm_medium=paid&utm_campaign=e2e_keep");
  await expect.poll(() => tracked.some((e) => e.name === "pageview")).toBe(true);

  await page.goto("/?utm_source=morroo&utm_medium=games_hub&utm_content=x");
  await expect
    .poll(() => tracked.filter((e) => e.name === "pageview").length >= 2)
    .toBe(true);
  const last = tracked.filter((e) => e.name === "pageview").at(-1);
  expect(last?.props.utm_campaign).toBe("e2e_keep");
});

test("LINE CTA clicks fire a Meta Lead pixel event and social_click", async ({ page }) => {
  const tracked = collectAnalyticsEvents(page);
  await page.addInitScript(() => {
    (window as unknown as { __fbq: unknown[][] }).__fbq = [];
    (window as unknown as { fbq: (...args: unknown[]) => void }).fbq = (...args: unknown[]) => {
      (window as unknown as { __fbq: unknown[][] }).__fbq.push(args);
    };
  });
  // อย่าให้เบราว์เซอร์เปิดแท็บใหม่จริงไป line.me
  await page.route("**line.me/**", (route) => route.abort());

  await page.goto("/");
  // ใช้ปุ่ม floating LINE ที่ชื่อ/ตำแหน่งนิ่งกว่าปุ่มอื่นในหน้า (ไม่ปนกับ popup
  // ที่โผล่ตามเงื่อนไข เช่น ExitIntentPopup/FirstVisitNudge) — force:true เพราะ
  // แค่ต้องการทดสอบ onClick handler ไม่ใช่ actionability จริงของ UI
  const lineLink = page.getByRole("link", { name: "เพิ่มเพื่อนใน LINE OA หมอรู้ — รับข้อสอบฟรีทุกเช้า" });
  await lineLink.click({ force: true, timeout: 5_000 }).catch(() => {});

  await expect
    .poll(() => tracked.some((e) => e.name === "social_click" && e.props.platform === "line"))
    .toBe(true);
  const fbqCalls = await page.evaluate(
    () => (window as unknown as { __fbq: unknown[][] }).__fbq,
  );
  expect(
    fbqCalls.some(
      (call) =>
        call[0] === "track" &&
        call[1] === "Lead" &&
        (call[2] as { content_name?: string })?.content_name === "line_oa",
    ),
  ).toBe(true);
});
