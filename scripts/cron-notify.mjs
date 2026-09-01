/**
 * Lightweight LINE admin notification for cron scripts.
 *
 * Reuses LINE_CHANNEL_TOKEN + LINE_TARGET_ID (same vars used by
 * lib/notifications.ts in the Next.js app). When either is missing the
 * helpers no-op so local runs and forks without LINE credentials still
 * work.
 *
 * Usage:
 *   import { notifyCronFailure, notifyCronSuccess } from "./cron-notify.mjs";
 *   try { ... } catch (err) {
 *     await notifyCronFailure("generate-board-daily", err);
 *     process.exit(1);
 *   }
 */

const LINE_TOKEN = process.env.LINE_CHANNEL_TOKEN ?? "";
const LINE_TARGET = process.env.LINE_TARGET_ID ?? "";

async function pushLine(text) {
  if (!LINE_TOKEN || !LINE_TARGET) return;
  try {
    const res = await fetch("https://api.line.me/v2/bot/message/push", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${LINE_TOKEN}`,
      },
      body: JSON.stringify({
        to: LINE_TARGET,
        messages: [{ type: "text", text: text.slice(0, 4900) }],
      }),
    });
    if (!res.ok) {
      console.error(`[cron-notify] LINE push failed ${res.status}`);
    }
  } catch (err) {
    console.error(`[cron-notify] LINE push error: ${err?.message ?? err}`);
  }
}

export async function notifyCronFailure(jobName, err) {
  const msg = err?.message ?? String(err);
  const stack = err?.stack ? `\n\n${String(err.stack).slice(0, 1500)}` : "";
  await pushLine(`🚨 cron failed: ${jobName}\n${msg}${stack}`);
}

export async function notifyCronSuccess(jobName, summary) {
  await pushLine(`✅ ${jobName}: ${summary}`);
}
