/**
 * Shared LLM helper for generation scripts — supports two providers behind one
 * call shape so easy/medium question batches can run on DeepSeek (cheap) while
 * hard batches stay on Claude:
 *
 *   - "anthropic": Messages API, forced tool_use (the original callClaude shape)
 *   - "deepseek":  OpenAI-compatible /chat/completions, forced function call
 *
 * Provider selection for easy/medium batches comes from MCQ_GEN_PROVIDER
 * ("deepseek" | "claude", default "claude" — unset env keeps the pipeline
 * exactly as before). If DeepSeek fails after its retries, the call falls back
 * to Claude Haiku automatically so the daily drip never silently drops.
 */

const ANTHROPIC_URL = "https://api.anthropic.com/v1/messages";
const DEEPSEEK_URL = "https://api.deepseek.com/chat/completions";

export const CLAUDE_HAIKU_MODEL = "claude-haiku-4-5-20251001";
export const DEFAULT_DEEPSEEK_MODEL = "deepseek-v4-flash";

const RETRIES_PER_PROVIDER = 2;
const RETRY_DELAY_MS = 2000;

/**
 * Resolve which provider/model easy+medium batches should use.
 * MCQ_GEN_PROVIDER=deepseek switches to DeepSeek (requires DEEPSEEK_API_KEY,
 * model overridable via DEEPSEEK_MODEL); anything else — including unset —
 * stays on Claude Haiku.
 */
export function resolveEasyMediumProvider(env = process.env) {
  const raw = (env.MCQ_GEN_PROVIDER || "claude").toLowerCase();
  if (raw === "deepseek") {
    if (!env.DEEPSEEK_API_KEY) {
      console.warn(
        "[llm] MCQ_GEN_PROVIDER=deepseek but DEEPSEEK_API_KEY is missing — using Claude"
      );
      return { provider: "anthropic", model: CLAUDE_HAIKU_MODEL };
    }
    return {
      provider: "deepseek",
      model: env.DEEPSEEK_MODEL || DEFAULT_DEEPSEEK_MODEL,
    };
  }
  if (raw !== "claude" && raw !== "anthropic") {
    console.warn(`[llm] Unknown MCQ_GEN_PROVIDER "${raw}" — using Claude`);
  }
  return { provider: "anthropic", model: CLAUDE_HAIKU_MODEL };
}

/** Translate an Anthropic-style tool ({name, description, input_schema}) to OpenAI format. */
export function toOpenAITool(tool) {
  return {
    type: "function",
    function: {
      name: tool.name,
      description: tool.description,
      parameters: tool.input_schema,
    },
  };
}

async function callAnthropic({ model, maxTokens, prompt, tool }, env) {
  const res = await fetch(ANTHROPIC_URL, {
    method: "POST",
    headers: {
      "x-api-key": env.ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      tools: [tool],
      tool_choice: { type: "tool", name: tool.name },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    throw new Error(`Anthropic API error (${model}): ${await res.text()}`);
  }

  const data = await res.json();
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input) {
    const blockTypes = (data.content ?? []).map((b) => b.type).join(",") || "(empty)";
    throw new Error(
      `No tool_use in response (${model}) — stop_reason=${data.stop_reason} blocks=[${blockTypes}] usage=${JSON.stringify(data.usage)}`
    );
  }
  return {
    data: toolUse.input,
    truncated: data.stop_reason === "max_tokens",
    usage: data.usage,
  };
}

async function callDeepSeek({ model, maxTokens, prompt, tool }, env) {
  const res = await fetch(DEEPSEEK_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${env.DEEPSEEK_API_KEY}`,
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      messages: [{ role: "user", content: prompt }],
      tools: [toOpenAITool(tool)],
      tool_choice: { type: "function", function: { name: tool.name } },
    }),
  });

  if (!res.ok) {
    throw new Error(`DeepSeek API error (${model}): ${await res.text()}`);
  }

  const data = await res.json();
  const choice = data.choices?.[0];
  const args = choice?.message?.tool_calls?.[0]?.function?.arguments;
  if (!args) {
    throw new Error(
      `No tool_call in response (${model}) — finish_reason=${choice?.finish_reason} usage=${JSON.stringify(data.usage)}`
    );
  }
  let parsed;
  try {
    parsed = JSON.parse(args);
  } catch {
    throw new Error(
      `Unparseable tool_call arguments (${model}) — finish_reason=${choice?.finish_reason} head=${args.slice(0, 200)}`
    );
  }
  return {
    data: parsed,
    truncated: choice.finish_reason === "length",
    usage: data.usage,
  };
}

async function callWithRetry(label, provider, params, env) {
  const call = provider === "deepseek" ? callDeepSeek : callAnthropic;
  let lastErr;
  for (let attempt = 1; attempt <= RETRIES_PER_PROVIDER; attempt++) {
    try {
      return await call(params, env);
    } catch (err) {
      lastErr = err;
      const msg = err?.message ?? String(err);
      if (attempt < RETRIES_PER_PROVIDER) {
        console.warn(`[${label}] ${provider} attempt ${attempt} failed, retrying: ${msg}`);
        await new Promise((r) => setTimeout(r, RETRY_DELAY_MS));
      } else {
        console.error(`[${label}] ${provider} failed after retry: ${msg}`);
      }
    }
  }
  throw lastErr;
}

/**
 * Run one forced-tool generation request.
 *
 * @param {object} opts
 * @param {"anthropic"|"deepseek"} opts.provider
 * @param {string} opts.model
 * @param {number} opts.maxTokens
 * @param {string} opts.prompt
 * @param {object} opts.tool  Anthropic-style tool: {name, description, input_schema}
 * @param {string} opts.label Log prefix (e.g. "haiku-easy")
 * @returns {Promise<{data: object, truncated: boolean, usage: object|undefined,
 *   provider: string, model: string}>}
 *   `data` is the parsed tool input; `provider`/`model` are what actually
 *   served the request (may differ from the ask after a DeepSeek→Claude fallback).
 */
export async function generateWithTool({ provider, model, maxTokens, prompt, tool, label }) {
  const env = process.env;
  try {
    const res = await callWithRetry(label, provider, { model, maxTokens, prompt, tool }, env);
    if (res.truncated) {
      console.warn(`[${label}] ${provider}:${model} hit the output limit — result may be truncated`);
    }
    return { ...res, provider, model };
  } catch (err) {
    if (provider !== "deepseek" || !env.ANTHROPIC_API_KEY) throw err;
    // DeepSeek exhausted its retries — the daily drip must not silently drop,
    // so rerun the same prompt on Claude Haiku (mirrors lib/anthropic.ts's
    // createWithFallback philosophy).
    console.warn(`[${label}] DeepSeek failed — falling back to ${CLAUDE_HAIKU_MODEL}`);
    const res = await callWithRetry(
      label,
      "anthropic",
      { model: CLAUDE_HAIKU_MODEL, maxTokens, prompt, tool },
      env
    );
    if (res.truncated) {
      console.warn(`[${label}] anthropic:${CLAUDE_HAIKU_MODEL} hit the output limit — result may be truncated`);
    }
    return { ...res, provider: "anthropic", model: CLAUDE_HAIKU_MODEL };
  }
}
