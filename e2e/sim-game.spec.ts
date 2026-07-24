import { test, expect } from "@playwright/test";

// Code Blue Sim — เกมกู้ชีพ ACLS ที่ /sim

test("sim hub lists the built-in VF scenario", async ({ page }) => {
  await page.goto("/sim");
  await expect(page.locator("h1")).toContainText("CODE BLUE");
  await expect(page.getByText("CODE BLUE: ภารกิจกู้ชีพ")).toBeVisible();
  // หน้ารวมมีหลายเคสแล้ว — ยืนยันว่ามีอย่างน้อยหนึ่งปุ่มเข้าเล่น
  await expect(page.getByRole("link", { name: /รับเคส/ }).first()).toBeVisible();
});

test("player can start the VF case and reach the first decision", async ({ page }) => {
  await page.goto("/sim/vf-arrest-01");
  await expect(page.locator(".cbs-title")).toBeVisible();

  // เริ่มเกม — คลิกซ้ำจนเข้าจอเกม (กันคลิกก่อน hydration)
  for (let i = 0; i < 10; i++) {
    await page.locator(".cbs-btn-main").click().catch(() => {});
    const dlg = page.locator(".cbs-dlg");
    if (await dlg.isVisible().catch(() => false)) break;
    await page.waitForTimeout(1000);
  }
  await expect(page.locator(".cbs-dlg")).toBeVisible();

  // แตะ dialog เดินเรื่องจน choice แรกโผล่
  for (let i = 0; i < 30; i++) {
    if (await page.locator(".cbs-choices").isVisible().catch(() => false)) break;
    await page.locator(".cbs-dlg").click().catch(() => {});
    await page.waitForTimeout(500);
  }
  await expect(page.locator(".cbs-qbanner")).toContainText("คำสั่งแรกของคุณ");
  await expect(page.locator(".cbs-choice")).toHaveCount(3);
});

// เกมคือหัวกรวยของแคมเปญโฆษณา (docs/casegame-acquisition-plan.md) — ถ้า event
// พวกนี้เงียบ แคมเปญจะ optimize ไม่ได้และเงินจะไหลออกโดยไม่มีใครรู้
test("playing a case through to debrief fires the funnel events and shows the lead CTA", async ({
  page,
}) => {
  const trackedEvents: string[] = [];
  const capiEvents: string[] = [];

  await page.route("**/api/analytics/track", async (route) => {
    const body = route.request().postDataJSON() as { event_name?: string } | null;
    if (body?.event_name) trackedEvents.push(body.event_name);
    await route.fulfill({ status: 200, body: JSON.stringify({ ok: true }) });
  });
  await page.route("**/api/track/casegame", async (route) => {
    const body = route.request().postDataJSON() as { event?: string } | null;
    if (body?.event) capiEvents.push(body.event);
    await route.fulfill({ status: 200, body: JSON.stringify({ ok: true }) });
  });

  await page.goto("/sim/vf-arrest-01");
  await expect(page.locator(".cbs-title")).toBeVisible();

  for (let i = 0; i < 10; i++) {
    await page.locator(".cbs-btn-main").click().catch(() => {});
    if (await page.locator(".cbs-dlg").isVisible().catch(() => false)) break;
    await page.waitForTimeout(1000);
  }
  await expect(page.locator(".cbs-dlg")).toBeVisible();
  expect(trackedEvents).toContain("casegame_start");
  expect(capiEvents).toContain("start");

  // เดินเรื่องไปเรื่อยๆ โดยเลือกตัวเลือกแรกเสมอ — ตอบผิดจะทำให้ HP หมดแล้วจบเคส
  // (แพ้ก็เข้าหน้า debrief เหมือนกัน ซึ่งเป็นสิ่งที่เทสนี้ต้องการ)
  for (let i = 0; i < 80; i++) {
    if (await page.locator(".cbs-debrief").isVisible().catch(() => false)) break;
    if (await page.locator(".cbs-choices").isVisible().catch(() => false)) {
      await page.locator(".cbs-choice").first().click().catch(() => {});
    } else {
      await page.locator(".cbs-dlg").click().catch(() => {});
    }
    await page.waitForTimeout(400);
  }

  await expect(page.locator(".cbs-debrief")).toBeVisible();
  expect(trackedEvents).toContain("casegame_first_decision");
  expect(trackedEvents).toContain("casegame_complete");
  expect(capiEvents).toContain("complete");

  // ผู้เล่นที่ยังไม่ล็อกอินต้องเจอ CTA เก็บอีเมล ไม่ใช่แค่ลิงก์ "เข้าสู่ระบบ"
  const cta = page.locator(".cbs-lead-cta");
  await expect(cta).toBeVisible();
  await expect(cta.locator("input[type=email]")).toBeVisible();
});
