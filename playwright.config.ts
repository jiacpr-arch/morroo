import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  // CI เก็บ HTML report ไว้อัปโหลดเป็น artifact ตอนเทสพัง (.github/workflows/verify.yml)
  reporter: process.env.CI ? [["list"], ["html", { open: "never" }]] : "list",
  use: {
    baseURL: process.env.E2E_BASE_URL ?? "http://localhost:3000",
    trace: "on-first-retry",
    // สภาพแวดล้อมที่ดาวน์โหลด browser เองไม่ได้ (เช่น sandbox/cloud) ชี้ binary ที่มีอยู่แล้วผ่าน env นี้
    ...(process.env.PW_EXECUTABLE_PATH
      ? { launchOptions: { executablePath: process.env.PW_EXECUTABLE_PATH } }
      : {}),
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],
  // Only spin up a server if E2E_BASE_URL isn't set (i.e. local runs / CI).
  // E2E_SERVER_COMMAND overrides the default dev server — CI sets it to
  // "npm run start" to test the production build made in the previous step.
  ...(process.env.E2E_BASE_URL
    ? {}
    : {
        webServer: {
          command: process.env.E2E_SERVER_COMMAND ?? "npm run dev",
          url: "http://localhost:3000",
          reuseExistingServer: !process.env.CI,
          timeout: 120 * 1000,
        },
      }),
});
