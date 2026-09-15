import { test, expect } from "@playwright/test";

// Code Blue Sim — เกมกู้ชีพ ACLS ที่ /sim

test("sim hub lists the built-in VF scenario", async ({ page }) => {
  await page.goto("/sim");
  await expect(page.locator("h1")).toContainText("CODE BLUE");
  await expect(page.getByText("CODE BLUE: ภารกิจกู้ชีพ")).toBeVisible();
  // หน้ารวมมีหลายเคสแล้ว — ยืนยันว่ามีอย่างน้อยหนึ่งปุ่มเข้าเล่น
  await expect(page.getByRole("link", { name: /รับเคส/ }).first()).toBeVisible();
});

/**
 * แตะ/คลิกซ้ำจนกว่า target จะโผล่ — ใช้ toPass() แทน loop ที่นับรอบด้วย sleep
 * คงที่ เพราะเมื่อรันขนานกับสเปกอื่นบน dev server ตัวเดียวกัน แต่ละคลิกจะช้าลง
 * มากจน loop แบบนับรอบหมดโควตาก่อนเกมจะเดินไปถึงจุดที่รอ (คลิกที่ไม่ใส่ timeout
 * ยังค้างยาวได้ด้วย เพราะ actionability check จะ retry จนหมดเวลาของทั้งเทส)
 */
async function clickUntilVisible(
  page: import("@playwright/test").Page,
  clickSelector: string,
  targetSelector: string,
  timeout = 60_000
) {
  await expect(async () => {
    if (await page.locator(targetSelector).isVisible().catch(() => false)) return;
    await page.locator(clickSelector).click({ timeout: 2_000 }).catch(() => {});
    expect(await page.locator(targetSelector).isVisible().catch(() => false)).toBe(true);
  }).toPass({ timeout, intervals: [300] });
}

test("player can start the VF case and reach the first decision", async ({ page }) => {
  test.slow();
  await page.goto("/sim/vf-arrest-01");
  await expect(page.locator(".cbs-title")).toBeVisible();

  // เริ่มเกม — คลิกซ้ำจนเข้าจอเกม (กันคลิกก่อน hydration)
  await clickUntilVisible(page, ".cbs-btn-main", ".cbs-dlg");

  // แตะ dialog เดินเรื่องจน choice แรกโผล่
  await clickUntilVisible(page, ".cbs-dlg", ".cbs-choices");

  await expect(page.locator(".cbs-qbanner")).toContainText("คำสั่งแรกของคุณ");
  await expect(page.locator(".cbs-choice")).toHaveCount(3);
});

// ทราฟฟิกจากโฆษณาต้องได้เล่นทันทีที่กดเข้ามา ไม่ต้องกดจอ title ก่อน
test("?start=1 drops the player straight into the game", async ({ page }) => {
  await page.goto("/sim/vf-arrest-01?start=1");

  // ไม่ต้องคลิกอะไรเลย — จอบทสนทนาต้องมาเอง
  await expect(page.locator(".cbs-dlg")).toBeVisible({ timeout: 15_000 });
  await expect(page.locator(".cbs-title")).toBeHidden();
});

// เกมคือหัวกรวยของแคมเปญโฆษณา (docs/casegame-acquisition-plan.md) — ถ้า event
// พวกนี้เงียบ แคมเปญจะ optimize ไม่ได้และเงินจะไหลออกโดยไม่มีใครรู้
test("playing a case through to debrief fires the funnel events and shows the lead CTA", async ({
  page,
}) => {
  // เล่นจนจบเคสต้องคลิกหลายสิบครั้ง — งบ 30 วิ default ไม่พอเมื่อรันขนาน
  test.slow();
  const tracked: { name: string; props: Record<string, unknown> }[] = [];
  const trackedEvents: string[] = [];
  const capiEvents: string[] = [];

  await page.route("**/api/analytics/track", async (route) => {
    const body = route.request().postDataJSON() as
      | { event_name?: string; properties?: Record<string, unknown> }
      | null;
    if (body?.event_name) {
      trackedEvents.push(body.event_name);
      tracked.push({ name: body.event_name, props: body.properties ?? {} });
    }
    await route.fulfill({ status: 200, body: JSON.stringify({ ok: true }) });
  });
  await page.route("**/api/track/casegame", async (route) => {
    const body = route.request().postDataJSON() as { event?: string } | null;
    if (body?.event) capiEvents.push(body.event);
    await route.fulfill({ status: 200, body: JSON.stringify({ ok: true }) });
  });
  // "เทียบกับผู้เล่นอื่น" (DebriefResultCard) — stub ตัวอย่างที่พอให้ percentile
  // ขึ้นจริง เพราะสภาพแวดล้อมทดสอบไม่มี analytics_events ให้อ่าน (RPC จริงคุม
  // ด้วย unit test ที่ lib/casegame/percentile.test.ts อยู่แล้ว)
  await page.route("**/api/casegame/rank*", async (route) => {
    await route.fulfill({
      json: { scope: "slug", sample: 120, below: 90, tie: 10, percentile: 75 },
    });
  });

  await page.goto("/sim/vf-arrest-01");
  await expect(page.locator(".cbs-title")).toBeVisible();

  await clickUntilVisible(page, ".cbs-btn-main", ".cbs-dlg");
  expect(trackedEvents).toContain("casegame_start");
  expect(capiEvents).toContain("start");

  // เดินเรื่องไปเรื่อยๆ โดยเลือกตัวเลือกแรกเสมอ — ตอบผิดจะทำให้ HP หมดแล้วจบเคส
  // (แพ้ก็เข้าหน้า debrief เหมือนกัน ซึ่งเป็นสิ่งที่เทสนี้ต้องการ)
  await expect(async () => {
    if (await page.locator(".cbs-debrief").isVisible().catch(() => false)) return;
    if (await page.locator(".cbs-choices").isVisible().catch(() => false)) {
      await page.locator(".cbs-choice").first().click({ timeout: 2_000 }).catch(() => {});
    } else {
      await page.locator(".cbs-dlg").click({ timeout: 2_000 }).catch(() => {});
    }
    expect(await page.locator(".cbs-debrief").isVisible().catch(() => false)).toBe(true);
  }).toPass({ timeout: 90_000, intervals: [300] });

  await expect(page.locator(".cbs-debrief")).toBeVisible();
  // แตะครั้งแรกต้องถูกนับด้วย — เป็นขั้นที่แยก "ไม่เคยแตะเลย" ออกจาก "แตะแล้ว
  // เลิกกลางทาง" ซึ่งเป็นสองปัญหาที่แก้คนละทางกัน
  expect(trackedEvents).toContain("casegame_first_tap");
  expect(trackedEvents).toContain("casegame_first_decision");
  expect(trackedEvents.filter((e) => e === "casegame_first_tap")).toHaveLength(1);

  // taps_before ต้องนับจริง ไม่ใช่ค้างที่ 0 — ถ้าค้างจะแยกบทเกริ่นยาวไม่ออก
  const firstDecision = tracked.find((e) => e.name === "casegame_first_decision");
  expect(typeof firstDecision?.props.taps_before).toBe("number");
  expect(firstDecision?.props.taps_before as number).toBeGreaterThan(0);
  expect(trackedEvents).toContain("casegame_complete");
  expect(capiEvents).toContain("complete");

  // "ผลของคุณ" ต้องขึ้นก่อน CTA เสมอ — เห็นผลลัพธ์ตัวเองก่อนถูกชวนสมัคร
  const resultCard = page.locator(".cbs-result-card");
  const cta = page.locator(".cbs-browse-cta");
  await expect(resultCard).toBeVisible();
  await expect(cta).toBeVisible();
  const resultBox = await resultCard.boundingBox();
  const ctaBox = await cta.boundingBox();
  expect(resultBox && ctaBox && resultBox.y < ctaBox.y).toBe(true);

  // percentile ที่ stub ไว้ต้องโชว์จริง (ไม่ใช่แค่ fetch เฉยๆ)
  await expect(page.locator(".cbs-result-rank")).toContainText("%");

  // ผู้เล่นที่ยังไม่ล็อกอินต้องเจอทางเข้าไปดูเนื้อหาต่อในเว็บ ไม่ใช่แค่ลิงก์
  // "เข้าสู่ระบบ" — และต้องไม่มีฟอร์มขออีเมลหลงเหลืออยู่ (เลิกเก็บ lead แล้ว)
  // CTA หลักต้องมีแค่หนึ่งเดียว (2026-09-15 ลดจาก 6-7 ลิงก์แข่งกันเหลือปุ่มเดียว)
  await expect(cta.locator(".cbs-cta-primary")).toHaveCount(1);
  // LINE เป็นตัวเลือกหลักท้ายเกม (ล็อกอิน หรืออย่างน้อยแอด OA เมื่อ flag ปิด)
  await expect(cta.locator("a.cbs-line-btn").first()).toBeVisible();
  await expect(cta.locator("a.cbs-browse-link").first()).toBeVisible();
  await expect(cta.locator("input[type=email]")).toHaveCount(0);

  // ...และต้องยิง cta_view ด้วย ไม่งั้นเวลาเห็นคลิก = 0 จะแยกไม่ออกว่าไม่มีคน
  // เล่นถึง, เห็นแล้วไม่กด หรือ CTA พัง — ต้องมี cta_variant ด้วยเพื่อเทียบอัตรา
  // สำเร็จของแต่ละทาง (line_login / line_oa_inapp / line_oa_noflag)
  await expect
    .poll(() => trackedEvents.includes("casegame_cta_view"), { timeout: 5_000 })
    .toBe(true);
  const ctaView = tracked.find((e) => e.name === "casegame_cta_view");
  expect(typeof ctaView?.props.cta_variant).toBe("string");

  // casegame_rank_view ยิงเมื่อ percentile โหลดสำเร็จ — ตัวหารของคำถาม "เห็น
  // percentile แล้วกด CTA มากขึ้นไหม" ต่อ run_id เข้ากับ cta_view/cta_click
  await expect
    .poll(() => trackedEvents.includes("casegame_rank_view"), { timeout: 5_000 })
    .toBe(true);

  // ทุก event ของรอบเล่นเดียวกันต้องมี run_id ค่าเดียวกัน — เป็นตัวที่ใช้ต่อ
  // funnel ใน SQL และใช้ตัดการรีโหลดหน้าซ้ำในโหมด autostart ออก
  const runIds = new Set(
    [
      "casegame_start", "casegame_first_tap", "casegame_first_decision",
      "casegame_complete", "casegame_cta_view", "casegame_rank_view",
    ].map((name) => tracked.find((e) => e.name === name)?.props.run_id)
  );
  expect(runIds.size).toBe(1);
  expect([...runIds][0]).toBeTruthy();
});

/**
 * คำใบ้การแตะ — 57% ของคนที่เปิดเกมจากโฆษณาเคยหายไปก่อนตัดสินใจข้อแรก
 * เพราะไม่รู้ว่าต้องแตะตรงไหน เทสนี้กันไม่ให้คำใบ้หลุดหายไปอีก
 */
test("first-time player is told where to tap, and only once", async ({ page }) => {
  await page.goto("/sim/vf-arrest-01?start=1");
  await expect(page.locator(".cbs-dlg")).toBeVisible({ timeout: 20_000 });

  // ต้องบอกตั้งแต่ตอนบทพูดยังพิมพ์ไม่จบ — ช่วงที่คนเพิ่งเปิดเกมเข้ามาพอดี
  await expect(page.locator(".cbs-tap-coach")).toBeVisible();
  await expect(page.locator(".cbs-adv")).toBeVisible();

  // แตะกลางเวที (ไม่ใช่กล่องบทพูด) ต้องเดินเรื่องได้ และคำใบ้ต้องหายไป
  const before = await page.locator(".cbs-dlg-text").innerText();
  await page.locator(".cbs-stage").click({ position: { x: 195, y: 220 } });
  await expect(page.locator(".cbs-tap-coach")).toHaveCount(0);
  await expect(async () => {
    expect(await page.locator(".cbs-dlg-text").innerText()).not.toBe(before);
  }).toPass({ timeout: 20_000, intervals: [300] });

  // เล่นรอบใหม่ในเครื่องเดิมไม่ต้องเจอคำใบ้อีก
  await page.goto("/sim/vf-arrest-01?start=1");
  await expect(page.locator(".cbs-dlg")).toBeVisible({ timeout: 20_000 });
  await expect(page.locator(".cbs-tap-coach")).toHaveCount(0);
});

/**
 * "เคสถัดไปที่ควรเล่น" — แทนปุ่มสุ่มมั่วที่ทำให้คนแตะจริงแค่ 14 จาก 157 เคส
 * stub ปลายทางเพราะสภาพแวดล้อมทดสอบไม่มี DB (catalog ว่าง = คอมโพเนนต์ซ่อนตัว
 * ตามตั้งใจ) เทสนี้จึงคุมการต่อสาย + การแสดงเหตุผล ไม่ใช่ตรรกะการจัดอันดับ
 * ซึ่งมี unit test คุมอยู่แล้วที่ lib/casegame/recommend.test.ts
 */
test("debrief suggests what to play next, with a reason", async ({ page }) => {
  await page.route("**/api/casegame/recommend", async (route) => {
    const body = route.request().postDataJSON() as { excludeSlug?: string };
    expect(body.excludeSlug).toBe("lc-testicular-torsion-01");
    await route.fulfill({
      json: {
        picks: [{
          slug: "lc-demo-1",
          title: "ชายอายุ 24 ปี ปวดท้องขวาล่าง 8 ชั่วโมง",
          specialty: "ศัลยศาสตร์",
          difficulty: "ปานกลาง",
          reason: "คุณเพิ่งพลาดเรื่องศัลยศาสตร์",
        }],
      },
    });
  });

  await page.goto("/sim/lc-testicular-torsion-01?start=1");
  await expect(page.locator(".cbs-dlg")).toBeVisible({ timeout: 20_000 });

  await expect(async () => {
    if (await page.locator(".cbs-debrief").isVisible().catch(() => false)) return;
    if (await page.locator(".cbs-choices").isVisible().catch(() => false)) {
      await page.locator(".cbs-choice").first().click({ timeout: 2_000 }).catch(() => {});
    } else {
      await page.locator(".cbs-dlg").click({ timeout: 2_000 }).catch(() => {});
    }
    expect(await page.locator(".cbs-debrief").isVisible().catch(() => false)).toBe(true);
  }).toPass({ timeout: 120_000, intervals: [300] });

  const next = page.locator(".cbs-next");
  await expect(next).toBeVisible({ timeout: 20_000 });
  await expect(next.locator(".cbs-next-reason").first()).toContainText("ศัลยศาสตร์");
  await expect(next.locator("a").first()).toHaveAttribute("href", "/sim/lc-demo-1");
});
