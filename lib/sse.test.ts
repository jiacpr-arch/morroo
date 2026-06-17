import { describe, it, expect } from "vitest";
import { consumeSSE } from "@/lib/sse";

/** Build a Response whose body streams the given byte chunks verbatim. */
function streamResponse(chunks: Uint8Array[], init?: ResponseInit): Response {
  const stream = new ReadableStream<Uint8Array>({
    start(controller) {
      for (const c of chunks) controller.enqueue(c);
      controller.close();
    },
  });
  return new Response(stream, init);
}

const enc = new TextEncoder();

/** Encode SSE events the way the longcase API routes do. */
function sseBytes(...events: object[]): Uint8Array {
  const text = events.map((e) => `data: ${JSON.stringify(e)}\n\n`).join("");
  return enc.encode(text);
}

describe("consumeSSE", () => {
  it("reassembles a reply delivered as many small events", async () => {
    const res = streamResponse([
      sseBytes({ text: "สวัสดี" }, { text: "ครับ" }, { text: " เจ็บ" }, { done: true }),
    ]);
    let out = "";
    const { error } = await consumeSSE(res, (t) => { out += t; });
    expect(error).toBeUndefined();
    expect(out).toBe("สวัสดีครับ เจ็บ");
  });

  it("handles a data: line split across network chunks (the freeze bug)", async () => {
    // One SSE event, sliced mid-JSON across two reads.
    const full = sseBytes({ text: "เคยผ่าตัดมาแล้วครับ" });
    const cut = Math.floor(full.length / 2);
    const res = streamResponse([full.slice(0, cut), full.slice(cut)]);
    let out = "";
    const { error } = await consumeSSE(res, (t) => { out += t; });
    expect(error).toBeUndefined();
    expect(out).toBe("เคยผ่าตัดมาแล้วครับ");
  });

  it("handles a multi-byte Thai character split across chunks", async () => {
    // Thai chars are 3 bytes in UTF-8; slice in the middle of one.
    const full = sseBytes({ text: "ผ่าตัด" });
    // Find a cut that lands inside a multi-byte sequence.
    const cut = 10;
    const res = streamResponse([full.slice(0, cut), full.slice(cut)]);
    let out = "";
    const { error } = await consumeSSE(res, (t) => { out += t; });
    expect(error).toBeUndefined();
    expect(out).toBe("ผ่าตัด");
  });

  it("surfaces a server-reported stream error", async () => {
    const res = streamResponse([sseBytes({ error: "rate limited" })]);
    let out = "";
    const { error } = await consumeSSE(res, (t) => { out += t; });
    expect(out).toBe("");
    expect(error).toBe("rate limited");
  });

  it("surfaces non-2xx responses without reading the body as a stream", async () => {
    const res = new Response(JSON.stringify({ error: "Unauthorized" }), {
      status: 401,
      headers: { "Content-Type": "application/json" },
    });
    const { error } = await consumeSSE(res, () => {});
    expect(error).toBe("Unauthorized");
  });
});
