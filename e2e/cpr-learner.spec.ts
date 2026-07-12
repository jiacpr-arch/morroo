import { test, expect } from "@playwright/test";

// Flow ผู้เรียนของโซนคอร์ส CPR (/cpr — แบรนด์ JIA ที่ย้ายมาจาก jia-online)
// เทสต์เหล่านี้ไม่แตะ Supabase จริง — ตรวจ routing, การซ่อน chrome ของ morroo,
// deep links และ state ใน localStorage เป็นหลัก

test("cpr landing renders JIA branding without morroo chrome", async ({ page }) => {
  await page.goto("/cpr");
  await expect(page.locator("body")).toContainText("JIA TRAINER CENTER");
  await expect(page.locator("body")).toContainText("คอร์ส CPR & AED");
  // chrome ของ morroo ต้องไม่โผล่ในโซน /cpr
  await expect(page.locator("nav")).toHaveCount(0);
  await expect(page.locator("footer")).toHaveCount(0);
});

test("teaser quiz page renders first question", async ({ page }) => {
  await page.goto("/cpr/quiz");
  await expect(page.locator("body")).toContainText("ทดสอบความรู้ CPR");
  await expect(page.locator("body")).toContainText("ข้อ 1 จาก 5");
});

test("?promo=CODE deep link lands on claim with code prefilled", async ({ page }) => {
  await page.goto("/cpr?promo=LEAD-TEST12");
  await expect(page).toHaveURL(/\/cpr\/claim\?code=LEAD-TEST12/);
  await expect(page.locator('input[placeholder="LEAD-XXXXXX"]')).toHaveValue("LEAD-TEST12");
});

test("stripe success deep link unlocks modules and cleans the url", async ({ page }) => {
  await page.goto("/cpr/course?stripe=success&modules=2,3");
  await expect(page).toHaveURL(/\/cpr\/course$/);
  const purchased = await page.evaluate(() => JSON.parse(localStorage.getItem("jia_purchased") || "[]"));
  expect(purchased).toContain(2);
  expect(purchased).toContain(3);
});

test("course page renders module list with free module 1", async ({ page }) => {
  await page.goto("/cpr/course");
  await expect(page.locator("body")).toContainText("บทที่ 1: CPR ผู้ใหญ่");
  await expect(page.locator("body")).toContainText("แบบทดสอบสุดท้าย");
});

test("returning learner resumes from last page", async ({ page }) => {
  await page.goto("/cpr/course");
  // เปิด /cpr ใหม่ → ต้อง resume กลับไป course (jia_last_page ถูกตั้งจากหน้าก่อน)
  await page.goto("/cpr");
  await expect(page).toHaveURL(/\/cpr\/course/);
});

test("morroo home still shows its own chrome (no /cpr leakage)", async ({ page }) => {
  await page.goto("/");
  await expect(page.locator("nav").first()).toBeVisible();
  await expect(page.locator("footer").first()).toBeVisible();
});
