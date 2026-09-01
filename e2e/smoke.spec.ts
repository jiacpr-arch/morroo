import { test, expect } from "@playwright/test";

// Smoke tests — just verify each public page renders with its expected
// landmark text. These catch most "entire page crashed" regressions without
// needing auth or seeded data.

test("home page renders hero copy", async ({ page }) => {
  await page.goto("/");
  // Main brand mention should always be on the landing page.
  await expect(page.locator("body")).toContainText("หมอรู้");
});

test("pricing page renders the three plans", async ({ page }) => {
  await page.goto("/pricing");
  await expect(page.locator("body")).toContainText("Bundle");
  await expect(page.locator("body")).toContainText("รายเดือน");
  await expect(page.locator("body")).toContainText("รายปี");
});

test("login page renders", async ({ page }) => {
  await page.goto("/login");
  // Either the form is visible or redirects to /dashboard if already logged in.
  // In the unauth happy path we land on /login.
  await expect(page).toHaveURL(/\/login|\/dashboard/);
});

test("nl overview renders", async ({ page }) => {
  await page.goto("/nl");
  await expect(page.locator("body")).toContainText("NL");
});

test("unauthenticated dashboard redirects to login", async ({ page }) => {
  await page.goto("/dashboard");
  await expect(page).toHaveURL(/\/login/);
});
