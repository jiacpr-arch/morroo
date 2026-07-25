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
  expect(trackedEvents).toContain("casegame_first_decision");
  expect(trackedEvents).toContain("casegame_complete");
  expect(capiEvents).toContain("complete");

  // ผู้เล่นที่ยังไม่ล็อกอินต้องเจอ CTA เก็บอีเมล ไม่ใช่แค่ลิงก์ "เข้าสู่ระบบ"
  const cta = page.locator(".cbs-lead-cta");
  await expect(cta).toBeVisible();
  await expect(cta.locator("input[type=email]")).toBeVisible();

  // ...และต้องยิง cta_view ด้วย ไม่งั้นเวลาเห็น lead = 0 จะแยกไม่ออกว่าไม่มีคน
  // เล่นถึง, เห็นแล้วไม่กรอก หรือฟอร์มพัง
  await expect
    .poll(() => trackedEvents.includes("casegame_cta_view"), { timeout: 5_000 })
    .toBe(true);

  // ทุก event ของรอบเล่นเดียวกันต้องมี run_id ค่าเดียวกัน — เป็นตัวที่ใช้ต่อ
  // funnel ใน SQL และใช้ตัดการรีโหลดหน้าซ้ำในโหมด autostart ออก
  const runIds = new Set(
    ["casegame_start", "casegame_first_decision", "casegame_complete", "casegame_cta_view"].map(
      (name) => tracked.find((e) => e.name === name)?.props.run_id
    )
  );
  expect(runIds.size).toBe(1);
  expect([...runIds][0]).toBeTruthy();
});
