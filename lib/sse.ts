export type SSEPayload = { text?: string; error?: string; done?: boolean };

/**
 * Consume a Server-Sent Events stream (`data: {...}\n\n`) robustly.
 *
 * Buffers across network chunks so multi-byte UTF-8 (Thai) characters and
 * partial `data:` lines are never split mid-parse, decodes with
 * `{ stream: true }`, and ignores malformed fragments instead of throwing.
 * Returns an error string if the server reported one (or the request failed),
 * so callers can surface it instead of silently freezing on "...".
 *
 * The naive approach — `decoder.decode(value).split("\n")` then `JSON.parse`
 * per chunk — breaks two ways: a multi-byte character split across a network
 * chunk gets corrupted, and a `data:` line split across chunks feeds incomplete
 * JSON to `JSON.parse`, which throws and aborts the read loop. Since the server
 * emits many small events per reply, this happened on almost every response.
 */
export async function consumeSSE(
  res: Response,
  onText: (text: string) => void
): Promise<{ error?: string }> {
  if (!res.ok) {
    const data = (await res.json().catch(() => ({}))) as { error?: string };
    return { error: data.error || `เกิดข้อผิดพลาด (${res.status})` };
  }
  const reader = res.body?.getReader();
  if (!reader) return { error: "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้" };

  const decoder = new TextDecoder();
  let buffer = "";
  let streamError: string | undefined;

  const handleLine = (line: string) => {
    if (!line.startsWith("data: ")) return;
    try {
      const parsed = JSON.parse(line.slice(6)) as SSEPayload;
      if (parsed.text) onText(parsed.text);
      else if (parsed.error) streamError = parsed.error;
    } catch {
      // Incomplete/malformed fragment — skip it.
    }
  };

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    let nl: number;
    while ((nl = buffer.indexOf("\n")) !== -1) {
      handleLine(buffer.slice(0, nl));
      buffer = buffer.slice(nl + 1);
    }
  }
  // Flush any trailing buffered event without a final newline.
  buffer += decoder.decode();
  if (buffer.trim()) handleLine(buffer.trim());

  return streamError ? { error: streamError } : {};
}
