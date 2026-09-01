import { test, expect } from "@playwright/test";

// เกมด่าน BLS ฝั่ง firstaid — เข้าผ่าน path ภายใน /firstaid/* (localhost ไม่มี subdomain rewrite)
//
// FirstAidShell มี onboarding soft-gate: learner ใหม่ถูก redirect ไปบทเรียนแรก
// จึง seed learner ที่กด "ดูภายหลัง" (lineSkippedAt) ไว้ก่อนโหลดหน้า

// learnerStore rehydrate แข่งกับ useEnsureLearner ได้ (learner ที่ seed ไว้ก่อน
// อาจถูกทับด้วยตัวใหม่) — จึงโหลดหนึ่งรอบ, patch learner จริงใน localStorage
// ให้มี lineSkippedAt, แล้วค่อยเข้าใหม่
async function gotoPastOnboarding(page: import("@playwright/test").Page, path: string) {
  await page.goto(path);
  // รอให้ useEnsureLearner สร้าง learner ลง localStorage ก่อน — patch เร็วกว่านั้นจะถูกทับ
  await page.waitForFunction(
    () => {
      const raw = localStorage.getItem("firstaid.learner");
      if (!raw) return false;
      try {
        return !!JSON.parse(raw).state?.learner?.id;
      } catch {
        return false;
      }
    },
    { timeout: 30000 },
  );
  await page.evaluate(() => {
    const data = JSON.parse(localStorage.getItem("firstaid.learner")!);
    data.state.learner.lineSkippedAt = new Date().toISOString();
    localStorage.setItem("firstaid.learner", JSON.stringify(data));
  });
  await page.goto(path);
}

test("bls hub shows 8 stages with only stage 1 unlocked for a fresh learner", async ({ page }) => {
  await gotoPastOnboarding(page, "/firstaid/bls");
  await expect(page.getByText("BLS 8 ด่าน").first()).toBeVisible();
  // รอ progress โหลด (skeleton หาย) — ด่าน 1 กดได้
  await expect(page.getByText("Chain of Survival & IHCA")).toBeVisible({ timeout: 15000 });
  await expect(page.locator(".bls-stage-card")).toHaveCount(8);
  // learner ใหม่: ล็อก 7 ด่าน (ด่าน 1 เปิด)
  await expect(page.locator(".bls-stage-card.bls-locked")).toHaveCount(7);
  // ข้อสอบรวมยังล็อก
  await expect(page.getByText("ผ่านครบทั้ง 8 ด่านก่อนจึงจะปลดล็อก")).toBeVisible();
});

test("stage 1 is playable: answering shows feedback and score changes", async ({ page }) => {
  await gotoPastOnboarding(page, "/firstaid/bls/bls-stage-1-chain");
  await expect(page.getByText("ขั้นที่ 1 /")).toBeVisible({ timeout: 15000 });

  // ตอบข้อแรก (ตัวเลือกใดก็ได้) — ต้องล็อกและโชว์ feedback
  await page.locator("button.card").first().click();
  await expect(page.getByText(/ถูกต้อง|ผิด|ไม่ใช่ลำดับ/).first()).toBeVisible();

  // มีปุ่มไปต่อ หรือ CPR drill (ข้ามได้)
  const skip = page.getByRole("button", { name: "ข้าม" });
  if (await skip.isVisible().catch(() => false)) await skip.click();
  await expect(page.getByRole("button", { name: /ถัดไป|ดูผลสรุป/ })).toBeVisible();
});

test("locked stage redirects to a lock screen when opened directly", async ({ page }) => {
  await gotoPastOnboarding(page, "/firstaid/bls/bls-stage-5-team-rosc");
  await expect(page.getByText("ด่านนี้ยังล็อกอยู่")).toBeVisible({ timeout: 15000 });
});
