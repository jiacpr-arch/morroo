import { test, expect } from "@playwright/test";

// Operation MorRoo — เกมหัตถการที่ /surgery

test("surgery hub lists the 3 built-in operations", async ({ page }) => {
  await page.goto("/surgery");
  await expect(page.locator("h1")).toContainText("OPERATION");
  await expect(page.getByText("เย็บแผลฉีกขาด").first()).toBeVisible();
  await expect(page.getByText("Tension Pneumothorax", { exact: false }).first()).toBeVisible();
  await expect(page.getByText("ผ่าฝีระบายหนอง", { exact: false }).first()).toBeVisible();
  await expect(page.getByRole("link", { name: /เข้าห้องผ่าตัด/ })).toHaveCount(3);
});

test("player can start suture case, gets punished for wrong tool, completes step 1", async ({ page }) => {
  await page.goto("/surgery/suture-laceration-01");
  await expect(page.locator(".sgy-title")).toBeVisible();

  // เริ่มเกม — คลิกซ้ำจนเข้าจอเกม (กันคลิกก่อน hydration)
  for (let i = 0; i < 10; i++) {
    await page.locator(".sgy-btn-main").click().catch(() => {});
    const banner = page.getByTestId("step-banner");
    if (await banner.isVisible().catch(() => false)) break;
    await page.waitForTimeout(1000);
  }
  await expect(page.getByTestId("step-banner")).toContainText("กดห้ามเลือด");

  // แตะเวทีโดยยังไม่เลือกเครื่องมือ → เตือน ไม่นับพลาด
  await page.getByTestId("zone-active").click();
  await expect(page.locator(".sgy-toast-bad")).toContainText("เลือกเครื่องมือ");
  await expect(page.locator(".sgy-wrongchip")).toContainText("0");

  // หยิบมีดผิดจังหวะ → โดนหัก + toast อธิบาย
  await page.getByTestId("tool-scalpel").click();
  await page.getByTestId("zone-active").click();
  await expect(page.locator(".sgy-wrongchip")).toContainText("1");
  await expect(page.locator(".sgy-toast-bad")).toBeVisible();

  // หยิบผ้าก๊อซแล้วกดค้างในเป้าจนครบ → step 1 เสร็จ ไป step 2 (ล้างแผล)
  await page.getByTestId("tool-gauze").click();
  const zone = page.getByTestId("zone-active");
  const box = await zone.boundingBox();
  if (!box) throw new Error("zone-active has no bounding box");
  await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
  await page.mouse.down();
  await page.waitForTimeout(2600);
  await page.mouse.up();
  await expect(page.getByTestId("step-banner")).toContainText("ล้างแผล");
});
