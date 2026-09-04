import { test, expect, type Page } from "@playwright/test";
import { createServer, type ViteDevServer } from "vite";
import path from "node:path";

let server: ViteDevServer;
let origin: string;
test.beforeAll(async () => {
  const root = path.resolve(__dirname, "..");
  server = await createServer({
    configFile: false, root, server: { host: "127.0.0.1", port: 0, watch: null, hmr: false },
    optimizeDeps: { include: ["react", "react-dom/client", "react/jsx-runtime", "react/jsx-dev-runtime", "lucide-react",
      "@base-ui/react/button", "@base-ui/react/merge-props", "@base-ui/react/use-render", "class-variance-authority", "clsx", "tailwind-merge"] },
    resolve: { alias: [
      { find: "next/navigation", replacement: "virtual:longcase-navigation" },
      { find: "@/components/ai/AiHealthProvider", replacement: "virtual:longcase-health" },
      { find: "@", replacement: root },
    ] },
    plugins: [{
      name: "longcase-client-test",
      configureServer(server) {
        server.middlewares.use((req, res, next) => {
          if (!req.url?.startsWith("/longcase/session")) return next();
          res.setHeader("Content-Type", "text/html");
          res.end('<html lang="th"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><div id="root"></div><script type="module" src="/voice-test-entry.tsx"></script></html>');
        });
      },
      resolveId(id) {
        if (id.startsWith("virtual:longcase-") || id === "/voice-test-entry.tsx") return "\0" + id;
      },
      load(id) {
        if (id === "\0virtual:longcase-navigation") return `
          export const useSearchParams = () => new URLSearchParams(location.search);
          export const useRouter = () => ({ push: url => { location.href = url; } });`;
        if (id === "\0virtual:longcase-health") return `export const useAiHealth = () => ({ reportAiSuccess() {}, reportAiFailure() {} });`;
        if (id === "\0/voice-test-entry.tsx") return `
          import React from 'react'; import { createRoot } from 'react-dom/client';
          import Page from '@/app/(morroo)/longcase/session/page';
          import '@/app/globals.css';
          createRoot(document.getElementById('root')).render(React.createElement(React.StrictMode, null, React.createElement(Page)));`;
      },
    }],
  });
  await server.listen();
  origin = server.resolvedUrls!.local[0].replace(/\/$/, "");
});
test.afterAll(async () => { await server?.close(); });

async function setup(page: Page, options: { local?: boolean; supported?: boolean; thaiVoice?: boolean; phase?: string } = {}) {
  await page.addInitScript(({ local, supported, thaiVoice }) => {
    const state = { recognizer: null as unknown, starts: 0, aborts: 0, local: false,
      spoken: [] as { text: string; voice: string; rate: number }[], cancels: 0, utterance: null as unknown };
    Object.assign(window, { __speech: state });
    class Recognition {
      processLocally = false;
      onresult?: (event: unknown) => void;
      onerror?: (event: unknown) => void;
      onend?: () => void;
      static async available() { return local ? "available" : "unavailable"; }
      start() { state.recognizer = this; state.starts++; state.local = this.processLocally; }
      stop() { this.onend?.(); }
      abort() { state.aborts++; }
    }
    Object.defineProperty(window, "SpeechRecognition", { configurable: true, value: supported ? Recognition : undefined });
    Object.defineProperty(window, "webkitSpeechRecognition", { configurable: true, value: undefined });
    const voices = [
      { voiceURI: "remote-th", lang: "th-TH", localService: false, name: "Remote Thai" },
      { voiceURI: "local-en", lang: "en-US", localService: true, name: "Local English" },
      ...(thaiVoice ? [{ voiceURI: "local-th", lang: "th-TH", localService: true, name: "Local Thai" }] : []),
    ];
    class Utterance { constructor(public text: string) {} }
    Object.defineProperty(window, "SpeechSynthesisUtterance", { configurable: true, value: Utterance });
    Object.defineProperty(window, "speechSynthesis", { configurable: true, value: {
      getVoices: () => voices, addEventListener() {}, removeEventListener() {},
      cancel: () => { state.cancels++; },
      speak: (u: { text: string; voice: { voiceURI: string }; rate: number }) => {
        state.utterance = u;
        state.spoken.push({ text: u.text, voice: u.voice.voiceURI, rate: u.rate });
      },
    } });
  }, { local: options.local ?? true, supported: options.supported ?? true, thaiVoice: options.thaiVoice ?? true });
  const requests: { url: string; body: Record<string, unknown> }[] = [];
  await page.route("**/api/**", async route => {
    const req = route.request();
    if (req.method() !== "GET") requests.push({ url: req.url(), body: req.postDataJSON() });
    if (req.url().includes("/api/ai/")) {
      await route.fulfill({ contentType: "text/event-stream", body: 'data: {"text":"เจ็บหน้าอกมาสองวันครับ"}\n\ndata: {"done":true}\n\n' });
    } else if (req.method() === "GET") {
      await route.fulfill({ json: {
        case_id: "case-test", phase: options.phase || "history", attempt_number: 1, score_total_pct: null,
        history_chat: [
          { role: "user", content: "สวัสดีครับ" }, { role: "assistant", content: "สวัสดีค่ะคุณหมอ" },
          { role: "user", content: "เป็นอย่างไรบ้าง" }, { role: "assistant", content: "ไม่ค่อยสบายค่ะ" },
        ],
        long_case: { title: "Long Case — ทดสอบเสียง", specialty: "อายุรกรรม", difficulty: "medium",
          patient_info: { name: "ผู้ป่วยจำลอง", age: 40, gender: "ชาย" } },
      } });
    } else await route.fulfill({ json: { ok: true } });
  });
  await page.goto(`${origin}/longcase/session?id=test-session`);
  await expect(page.getByText("Long Case — ทดสอบเสียง", { exact: true })).toBeVisible();
  return requests;
}

// Mock callbacks exercise the browser contract without recording anyone.
async function result(page: Page, text: string, final = true) {
  await page.evaluate(({ text, final }) => {
    const state = (window as unknown as { __speech: { recognizer: { onresult: (event: unknown) => void } } }).__speech;
    state.recognizer.onresult({ resultIndex: 0, results: [{ isFinal: final, 0: { transcript: text } }] });
  }, { text, final });
}
async function speechState(page: Page) {
  return page.evaluate(() => (window as unknown as { __speech: {
    starts: number; aborts: number; local: boolean; cancels: number;
    spoken: { text: string; voice: string; rate: number }[];
  } }).__speech);
}

async function endSpeech(page: Page, error = false) {
  await page.evaluate(error => {
    const state = (window as unknown as { __speech: { utterance: { onend?: () => void; onerror?: () => void } } }).__speech;
    if (error) state.utterance.onerror?.();
    else state.utterance.onend?.();
  }, error);
}

async function startConversation(page: Page) {
  await page.getByRole("button", { name: "เริ่มคุยกับคนไข้", exact: true }).click();
  await expect.poll(async () => (await speechState(page)).spoken.length).toBeGreaterThan(0);
  await endSpeech(page);
  await expect(page.getByText("กำลังฟังคำถาม…", { exact: true })).toBeVisible();
}

test("patient conversation auto-sends once, reads the reply with mic off, then listens for another turn", async ({ page }) => {
  const requests = await setup(page);
  await startConversation(page);
  await expect(page.getByRole("textbox")).toBeDisabled();
  await expect(page.getByRole("button", { name: "พูดแทนพิมพ์" })).toBeDisabled();
  await result(page, "เจ็บตรงไหนครับ");
  await result(page, "เจ็บตรงไหนครับ");
  await expect(page.getByText("คนไข้กำลังพูด · ไมค์ปิดอยู่", { exact: true })).toBeVisible();
  expect(requests).toHaveLength(1);
  expect(requests[0].body).toEqual({ sessionId: "test-session", messages: [{ role: "user", content: "เจ็บตรงไหนครับ" }] });
  expect((await speechState(page)).starts).toBe(1);
  expect((await speechState(page)).aborts).toBeGreaterThan(0);
  expect((await speechState(page)).spoken.at(-1)?.text).toBe("เจ็บหน้าอกมาสองวันครับ");
  await endSpeech(page);
  await expect.poll(async () => (await speechState(page)).starts).toBe(2);
  await result(page, "เป็นมานานไหมครับ");
  await expect.poll(() => requests.length).toBe(2);
  await page.getByRole("button", { name: "หยุดคุยกับคนไข้" }).click();
  await expect(page.getByRole("textbox")).toBeEnabled();
  await endSpeech(page);
  expect((await speechState(page)).starts).toBe(2);
});

test("stopping conversation preserves unsent speech and ignores delayed recognition callbacks", async ({ page }) => {
  const requests = await setup(page);
  await startConversation(page);
  await result(page, "คำถามยังพูดไม่จบ", false);
  await page.evaluate(() => {
    const w = window as unknown as { __speech: { recognizer: { onend: () => void } }; lateEnd: () => void };
    w.lateEnd = w.__speech.recognizer.onend;
  });
  await page.getByRole("button", { name: "หยุดคุยกับคนไข้" }).click();
  await page.evaluate(() => (window as unknown as { lateEnd: () => void }).lateEnd());
  await expect(page.getByRole("textbox")).toHaveValue("คำถามยังพูดไม่จบ");
  expect(requests).toHaveLength(0);
  await expect(page.getByRole("button", { name: "เริ่มคุยกับคนไข้" })).toBeDisabled();
});

test("stopping while AI is pending keeps the text reply but never speaks or reopens microphone", async ({ page }) => {
  await setup(page);
  let release!: () => void;
  const gate = new Promise<void>(resolve => { release = resolve; });
  let calls = 0;
  await page.route("**/api/ai/longcase-patient", async route => {
    calls++;
    await gate;
    await route.fulfill({ contentType: "text/event-stream", body: 'data: {"text":"คำตอบหลังหยุด"}\n\ndata: {"done":true}\n\n' });
  });
  await startConversation(page);
  await result(page, "ถามแล้วหยุด");
  await expect.poll(() => calls).toBe(1);
  await page.getByRole("button", { name: "หยุดคุยกับคนไข้" }).click();
  release();
  await expect(page.getByText("คำตอบหลังหยุด", { exact: true })).toBeVisible();
  expect((await speechState(page)).spoken).toHaveLength(1);
  expect((await speechState(page)).starts).toBe(1);
});

test("conversation stops on AI failure without auto retry", async ({ page }) => {
  await setup(page);
  let calls = 0;
  await page.route("**/api/ai/longcase-patient", async route => {
    calls++;
    await route.fulfill({ status: 503, json: { error: "ระบบทดสอบไม่พร้อม" } });
  });
  await startConversation(page);
  await result(page, "เป็นอะไรครับ");
  await expect(page.getByRole("alert")).toContainText("คนไข้ตอบไม่สำเร็จ");
  expect(calls).toBe(1);
  expect((await speechState(page)).spoken).toHaveLength(1);
  await expect(page.getByRole("button", { name: "เริ่มคุยกับคนไข้" })).toBeEnabled();
});

test("conversation requires separate remote consent and stops when playback fails", async ({ page }) => {
  await setup(page, { local: false });
  await page.getByRole("button", { name: "เริ่มคุยกับคนไข้" }).click();
  await expect(page.getByRole("alert")).toContainText("ยังไม่มีระบบถอดเสียงไทยในเครื่องสำหรับโหมดสนทนา");
  expect((await speechState(page)).starts).toBe(0);
  await page.getByRole("checkbox", { name: /อนุญาตโหมดสนทนา/ }).check();
  await startConversation(page);
  expect((await speechState(page)).local).toBe(false);
  await result(page, "คำถามทดสอบ");
  await expect(page.getByText("คนไข้กำลังพูด · ไมค์ปิดอยู่", { exact: true })).toBeVisible();
  await endSpeech(page, true);
  await expect(page.getByRole("alert")).toContainText("เสียงอ่านหยุดหรือเล่นไม่ได้");
  expect((await speechState(page)).starts).toBe(1);
});

test("leaving History stops conversation and it is not shown in other phases", async ({ page }) => {
  const requests = await setup(page);
  await startConversation(page);
  await result(page, "ยังไม่ส่งคำถาม");
  await page.getByRole("button", { name: "ตรวจร่างกาย", exact: true }).click();
  await expect(page.getByRole("heading", { name: "ตรวจร่างกาย" })).toBeVisible();
  await expect(page.getByRole("region", { name: "โหมดคุยกับคนไข้" })).toHaveCount(0);
  expect((await speechState(page)).aborts).toBeGreaterThan(0);
  expect(requests).toHaveLength(0);
});

test("conversation fails closed on incomplete transcription and pagehide stops listening", async ({ page }) => {
  const requests = await setup(page);
  await startConversation(page);
  await result(page, "คำถามที่ยังไม่ยืนยัน", false);
  await expect(page.getByRole("alert")).toContainText("ข้อความยังถอดเสียงไม่ครบ");
  await expect(page.getByRole("textbox")).toHaveValue("คำถามที่ยังไม่ยืนยัน");
  expect(requests).toHaveLength(0);
  await page.getByRole("textbox").fill("");
  await startConversation(page);
  await page.evaluate(() => window.dispatchEvent(new Event("pagehide")));
  await expect(page.getByRole("button", { name: "เริ่มคุยกับคนไข้" })).toBeEnabled();
  expect((await speechState(page)).aborts).toBeGreaterThan(0);
});

test("conversation stops on denied mic and a stalled playback never opens the mic", async ({ page }) => {
  const requests = await setup(page);
  await startConversation(page);
  await page.evaluate(() => {
    (window as unknown as { __speech: { recognizer: { onerror: (event: unknown) => void } } }).__speech.recognizer.onerror({ error: "not-allowed" });
  });
  await expect(page.getByRole("alert")).toContainText("ไม่ได้รับอนุญาตใช้ไมค์");
  await page.clock.install();
  await page.getByRole("button", { name: "เริ่มคุยกับคนไข้" }).click();
  await page.clock.fastForward(46_000);
  await expect(page.getByRole("alert")).toContainText("เปิดเสียงอ่านไม่ได้");
  expect((await speechState(page)).starts).toBe(1);
  expect(requests).toHaveLength(0);
});

test("dictation appends to edited draft once, never sends automatically, and keeps text API unchanged", async ({ page }) => {
  const requests = await setup(page);
  const input = page.getByRole("textbox", { name: "คำถามซักประวัติ" });
  await input.fill("เริ่มต้น");
  await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
  await result(page, "อาการเป็นอย่างไร", false);
  await expect(input).toHaveValue("เริ่มต้น");
  await input.fill("แก้ไขระหว่างฟัง");
  await result(page, "อาการเป็นอย่างไร");
  await result(page, "อาการเป็นอย่างไร");
  await expect(input).toHaveValue("แก้ไขระหว่างฟัง อาการเป็นอย่างไร");
  expect(requests).toHaveLength(0);
  expect((await speechState(page)).local).toBe(true);
  await expect(page.getByRole("button", { name: "ส่งคำถามซักประวัติ" })).toBeDisabled();
  await page.getByRole("button", { name: "หยุดไมค์" }).click();
  await page.getByRole("button", { name: "ส่งคำถามซักประวัติ" }).click();
  await expect(page.getByText("เจ็บหน้าอกมาสองวันครับ", { exact: true })).toBeVisible();
  expect(requests).toHaveLength(1);
  expect(requests[0].body).toEqual({ sessionId: "test-session", messages: [{ role: "user", content: "แก้ไขระหว่างฟัง อาการเป็นอย่างไร" }] });
  expect(requests[0].url).toContain("/api/ai/longcase-patient");
});

test("remote recognition requires explicit consent; errors retain the draft", async ({ page }) => {
  await setup(page, { local: false });
  await page.getByRole("textbox").fill("ข้อความเดิม");
  await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
  await expect(page.getByText(/ยังไม่มีระบบถอดเสียงไทยในเครื่อง/)).toBeVisible();
  expect((await speechState(page)).starts).toBe(0);
  await page.getByRole("checkbox", { name: /ยินยอมใช้บริการ/ }).check();
  await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
  expect((await speechState(page)).local).toBe(false);
  await page.evaluate(() => {
    (window as unknown as { __speech: { recognizer: { onerror: (e: unknown) => void } } }).__speech.recognizer.onerror({ error: "not-allowed" });
  });
  await expect(page.getByText(/ไม่ได้รับอนุญาตใช้ไมค์/)).toBeVisible();
  await expect(page.getByRole("textbox")).toHaveValue("ข้อความเดิม");
  await expect(page.getByRole("button", { name: "ส่งคำถามซักประวัติ" })).toBeEnabled();
});

test("only local Thai voices are used, replay/stop work, and changing phase cancels speech", async ({ page }) => {
  await setup(page);
  await page.getByText("เสียงอ่านจากเครื่อง · ไม่มีค่า API เสียงเพิ่ม", { exact: true }).click();
  await expect(page.getByLabel("เสียงไทย")).toHaveValue("local-th");
  await expect(page.getByLabel("เสียงไทย").locator("option")).toHaveCount(1);
  await page.getByRole("button", { name: "อ่านคำตอบ", exact: true }).first().click();
  expect((await speechState(page)).spoken[0]).toEqual({ text: "สวัสดีค่ะคุณหมอ", voice: "local-th", rate: 1 });
  await page.getByRole("button", { name: "หยุดอ่าน", exact: true }).click();
  expect((await speechState(page)).cancels).toBeGreaterThan(0);
  await page.getByRole("button", { name: "อ่านคำตอบ", exact: true }).first().click();
  const before = (await speechState(page)).cancels;
  await page.getByRole("button", { name: /เสร็จซักประวัติ/ }).click();
  await expect(page.getByRole("heading", { name: "ตรวจร่างกาย" })).toBeVisible();
  expect((await speechState(page)).cancels).toBeGreaterThan(before);
});

test("unsupported recognition and missing local Thai voice keep ordinary typing usable", async ({ page }) => {
  await setup(page, { supported: false, thaiVoice: false });
  await expect(page.getByRole("button", { name: "พูดแทนพิมพ์" })).toBeDisabled();
  await expect(page.getByRole("button", { name: "เริ่มคุยกับคนไข้" })).toBeDisabled();
  await expect(page.getByRole("button", { name: "อ่านคำตอบ", exact: true }).first()).toBeDisabled();
  await page.getByRole("textbox").fill("พิมพ์ได้ปกติ");
  await page.getByRole("button", { name: "ส่งคำถามซักประวัติ" }).click();
  await expect(page.getByText("เจ็บหน้าอกมาสองวันครับ", { exact: true })).toBeVisible();
  expect((await speechState(page)).spoken).toHaveLength(0);
});

test("auto-read speaks only a completed new reply, not restored history", async ({ page }) => {
  await setup(page);
  expect((await speechState(page)).spoken).toHaveLength(0);
  await page.getByText("เสียงอ่านจากเครื่อง · ไม่มีค่า API เสียงเพิ่ม", { exact: true }).click();
  await page.getByRole("checkbox", { name: /อ่านคำตอบใหม่อัตโนมัติ/ }).check();
  await page.getByRole("textbox").fill("เป็นอะไรครับ");
  await page.getByRole("button", { name: "ส่งคำถามซักประวัติ" }).click();
  await expect(page.getByText("เจ็บหน้าอกมาสองวันครับ", { exact: true })).toBeVisible();
  await expect.poll(async () => (await speechState(page)).spoken.map(u => u.text))
    .toEqual(["เปิดการอ่านคำตอบอัตโนมัติแล้ว", "เจ็บหน้าอกมาสองวันครับ"]);
});

for (const [phase, label, nextButton, field] of [
  ["ddx", "Differential Diagnosis", "บันทึก DDx", "student_ddx"],
  ["management", "แผนการรักษา", "เสร็จแล้ว → สัมภาษณ์", "student_mgmt"],
]) {
  test(`dictation uses the existing ${phase} save field`, async ({ page }) => {
    const requests = await setup(page, { phase });
    await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
    await result(page, "คำตอบจากเสียง");
    await page.getByRole("button", { name: "หยุดไมค์" }).click();
    await expect(page.getByRole("textbox", { name: label })).toHaveValue("คำตอบจากเสียง");
    await page.getByRole("button", { name: new RegExp(nextButton) }).click();
    expect(requests[0].body[field]).toBe("คำตอบจากเสียง");
  });
}

test("Examiner uses the existing text chat endpoint", async ({ page }) => {
  const requests = await setup(page, { phase: "examiner" });
  await page.getByRole("button", { name: "เริ่มสัมภาษณ์", exact: true }).click();
  await expect(page.getByRole("textbox", { name: "คำตอบ Examiner" })).toBeVisible();
  await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
  await result(page, "ขอสรุปประวัติครับ");
  await page.getByRole("button", { name: "หยุดไมค์" }).click();
  await page.getByRole("button", { name: "ส่งคำตอบ Examiner" }).click();
  await expect.poll(() => requests.length).toBe(2);
  expect(requests[1].body).toEqual({ sessionId: "test-session", action: "chat", messages: [{ role: "user", content: "ขอสรุปประวัติครับ" }] });
});

test("mobile layout fits and leaving the tab aborts the microphone", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await setup(page);
  await expect(page.getByRole("button", { name: "พูดแทนพิมพ์" })).toBeVisible();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true);
  await page.getByRole("button", { name: "พูดแทนพิมพ์" }).click();
  await page.evaluate(() => window.dispatchEvent(new Event("pagehide")));
  await expect(page.getByRole("button", { name: "พูดแทนพิมพ์" })).toBeVisible();
  expect((await speechState(page)).aborts).toBeGreaterThan(0);
  await page.evaluate(() => window.scrollTo(0, 0));
  await page.screenshot({ path: "test-results/longcase-voice-mobile.png", fullPage: true });
});
