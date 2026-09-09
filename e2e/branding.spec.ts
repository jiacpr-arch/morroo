import { test, expect } from "@playwright/test";

for (const width of [390, 768, 1280, 1440]) {
  test(`MorRoo logo and navigation work at ${width}px`, async ({ page }, testInfo) => {
    await page.setViewportSize({ width, height: 1000 });
    await page.goto("/");
    const heroLogo = page.getByRole("img", { name: "MorRoo.com หมอรู้ — ติวสอบแพทย์", exact: true });
    await expect(heroLogo).toBeVisible();
    await expect.poll(() => heroLogo.evaluate((image: HTMLImageElement) => image.complete && image.naturalWidth > 0)).toBe(true);
    await expect(page.locator("nav").getByRole("link", { name: "MorRoo หมอรู้ — หน้าแรก", exact: true })).toBeVisible();
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
    await page.screenshot({ path: testInfo.outputPath(`branding-${width}.png`) });
    if (width < 1280) {
      await page.getByRole("button", { name: "เปิดเมนู", exact: true }).click();
    }
    await expect(page.locator("nav").getByRole("link", { name: "สมัครสมาชิก", exact: true })).toBeVisible();
    const schema = await page.locator('script[type="application/ld+json"]').allTextContents();
    expect(schema.some((text) => JSON.parse(text).logo === "https://www.morroo.com/images/logo-morroo.png")).toBe(true);
  });
}
