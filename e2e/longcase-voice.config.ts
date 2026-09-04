import { defineConfig } from "@playwright/test";

// Isolated client integration: real Long Case page, mocked text backend and
// speech engines. No production credentials, microphone or paid calls needed.
export default defineConfig({
  testDir: ".",
  testMatch: "longcase-voice.spec.ts",
  workers: 1,
  use: { browserName: "chromium", viewport: { width: 1100, height: 900 } },
});
