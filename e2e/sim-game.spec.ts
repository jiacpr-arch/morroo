import { test, expect } from "@playwright/test";

// Code Blue Sim — เกมกู้ชีพ ACLS ที่ /sim

test("sim hub lists the built-in VF scenario", async ({ page }) => {
  await page.goto("/sim");
  await expect(page.locator("h1")).toContainText("CODE BLUE");
  await expect(page.getByText("CODE BLUE: ภารกิจกู้ชีพ")).toBeVisible();
  await expect(page.getByRole("link", { name: /รับเคส/ })).toBeVisible();
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
