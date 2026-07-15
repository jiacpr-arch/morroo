import { test, expect } from "@playwright/test";

// Resus Hero — เกมหัตถการกู้ชีพ ACLS ที่ /resus

test("resus hub lists the 3 built-in cases", async ({ page }) => {
  await page.goto("/resus");
  await expect(page.locator("h1")).toContainText("RESUS");
  await expect(page.getByText("VF Arrest", { exact: false }).first()).toBeVisible();
  await expect(page.getByText("PEA", { exact: false }).first()).toBeVisible();
  await expect(page.getByText("Airway & Post-ROSC", { exact: false }).first()).toBeVisible();
  await expect(page.getByRole("link", { name: /เริ่มกู้ชีพ/ })).toHaveCount(3);
});

test("player can start VF case, gets punished for wrong tool, completes step 1", async ({ page }) => {
  await page.goto("/resus/vf-arrest-01");
  await expect(page.locator(".rss-title")).toBeVisible();

  // เริ่มเกม — คลิกซ้ำจนเข้าจอเกม (กันคลิกก่อน hydration)
  for (let i = 0; i < 10; i++) {
    await page.locator(".rss-btn-main").click().catch(() => {});
    const banner = page.getByTestId("step-banner");
    if (await banner.isVisible().catch(() => false)) break;
    await page.waitForTimeout(1000);
  }
  await expect(page.getByTestId("step-banner")).toContainText("เขย่าเรียก");

  // แตะเวทีโดยยังไม่เลือกเครื่องมือ → เตือน ไม่นับพลาด
  await page.getByTestId("zone-active").click();
  await expect(page.locator(".rss-toast-bad")).toContainText("เลือกเครื่องมือ");
  await expect(page.locator(".rss-wrongchip")).toContainText("0");

  // กดปุ่มช็อกผิดจังหวะ (ยังไม่ประเมินผู้ป่วย) → โดนหัก + toast อธิบาย
  await page.getByTestId("tool-defib_button").click();
  await page.getByTestId("zone-active").click();
  await expect(page.locator(".rss-wrongchip")).toContainText("1");
  await expect(page.locator(".rss-toast-bad")).toBeVisible();

  // เขย่าเรียกด้วยมือ (tap) → step 1 เสร็จ ไป step 2 (คลำชีพจร)
  await page.getByTestId("tool-hands").click();
  await page.getByTestId("zone-active").click();
  await expect(page.getByTestId("step-banner")).toContainText("คลำชีพจร");
});
