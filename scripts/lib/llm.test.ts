import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

// llm.mjs's Anthropic path uses the SDK's streaming client (see the comment
// on callAnthropic for why: idle-connection timeouts on long Sonnet 5
// generations), so it's mocked at the SDK boundary rather than via fetch.
// vi.hoisted makes these available inside the vi.mock factory below, which
// Vitest hoists above this file's imports.
const { anthropicStreamMock, AnthropicCtorMock } = vi.hoisted(() => {
  const anthropicStreamMock = vi.fn();
  // A regular function, not an arrow — arrow functions can't be used as
  // constructors, and this needs to work behind `new Anthropic(...)`.
  const AnthropicCtorMock = vi.fn().mockImplementation(function () {
    return { messages: { stream: anthropicStreamMock } };
  });
  return { anthropicStreamMock, AnthropicCtorMock };
});
vi.mock("@anthropic-ai/sdk", () => ({ default: AnthropicCtorMock }));

import {
  CLAUDE_HAIKU_MODEL,
  CLAUDE_DEFAULT_MODEL,
  DEFAULT_DEEPSEEK_MODEL,
  generateWithTool,
  resolveEasyMediumProvider,
  toOpenAITool,
} from "./llm.mjs";

/** Build a fake `process.env`-shaped object for resolveEasyMediumProvider(). */
function fakeEnv(overrides: Record<string, string | undefined>): NodeJS.ProcessEnv {
  return overrides as NodeJS.ProcessEnv;
}

/** Configure the mocked Anthropic client's next stream().finalMessage() result. */
function mockAnthropicStream(resultOrError: unknown, { throws = false } = {}) {
  anthropicStreamMock.mockReturnValueOnce({
    finalMessage: () => (throws ? Promise.reject(resultOrError) : Promise.resolve(resultOrError)),
  });
}

function anthropicMessage(stopReason = "tool_use") {
  return {
    content: [{ type: "tool_use", input: { questions: QUESTIONS } }],
    stop_reason: stopReason,
    usage: { input_tokens: 10, output_tokens: 20 },
  };
}

const TOOL = {
  name: "submit_mcq_questions",
  description: "Submit a batch of generated MCQ questions",
  input_schema: {
    type: "object",
    properties: { questions: { type: "array" } },
    required: ["questions"],
  },
};

const QUESTIONS = [{ scenario: "ชาย 55 ปี เจ็บอก", correct_answer: "A" }];

function deepseekResponse(finishReason = "tool_calls") {
  return {
    ok: true,
    json: async () => ({
      choices: [
        {
          finish_reason: finishReason,
          message: {
            tool_calls: [
              { function: { name: TOOL.name, arguments: JSON.stringify({ questions: QUESTIONS }) } },
            ],
          },
        },
      ],
      usage: { prompt_tokens: 10, completion_tokens: 20 },
    }),
  };
}

describe("resolveEasyMediumProvider", () => {
  it("defaults to Claude Sonnet 5 when MCQ_GEN_PROVIDER is unset or empty", () => {
    expect(CLAUDE_DEFAULT_MODEL).toBe("claude-sonnet-5");
    expect(CLAUDE_DEFAULT_MODEL).not.toBe(CLAUDE_HAIKU_MODEL);
    expect(resolveEasyMediumProvider(fakeEnv({}))).toEqual({
      provider: "anthropic",
      model: CLAUDE_DEFAULT_MODEL,
    });
    expect(resolveEasyMediumProvider(fakeEnv({ MCQ_GEN_PROVIDER: "" }))).toEqual({
      provider: "anthropic",
      model: CLAUDE_DEFAULT_MODEL,
    });
  });

  it("uses DeepSeek when configured with an API key", () => {
    expect(
      resolveEasyMediumProvider(fakeEnv({ MCQ_GEN_PROVIDER: "deepseek", DEEPSEEK_API_KEY: "k" }))
    ).toEqual({ provider: "deepseek", model: DEFAULT_DEEPSEEK_MODEL });
  });

  it("honours DEEPSEEK_MODEL override", () => {
    expect(
      resolveEasyMediumProvider(fakeEnv({
        MCQ_GEN_PROVIDER: "deepseek",
        DEEPSEEK_API_KEY: "k",
        DEEPSEEK_MODEL: "deepseek-v4-pro",
      }))
    ).toEqual({ provider: "deepseek", model: "deepseek-v4-pro" });
  });

  it("falls back to Claude when deepseek is requested without a key", () => {
    const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
    expect(resolveEasyMediumProvider(fakeEnv({ MCQ_GEN_PROVIDER: "deepseek" }))).toEqual({
      provider: "anthropic",
      model: CLAUDE_DEFAULT_MODEL,
    });
    expect(warn).toHaveBeenCalled();
    warn.mockRestore();
  });

  it("falls back to Claude on an unknown provider value", () => {
    const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
    expect(resolveEasyMediumProvider(fakeEnv({ MCQ_GEN_PROVIDER: "gpt" }))).toEqual({
      provider: "anthropic",
      model: CLAUDE_DEFAULT_MODEL,
    });
    warn.mockRestore();
  });
});

describe("toOpenAITool", () => {
  it("maps input_schema to function parameters", () => {
    expect(toOpenAITool(TOOL)).toEqual({
      type: "function",
      function: {
        name: TOOL.name,
        description: TOOL.description,
        parameters: TOOL.input_schema,
      },
    });
  });
});

describe("generateWithTool", () => {
  const fetchMock = vi.fn();

  beforeEach(() => {
    vi.stubGlobal("fetch", fetchMock);
    vi.stubEnv("ANTHROPIC_API_KEY", "ant-key");
    vi.stubEnv("DEEPSEEK_API_KEY", "ds-key");
    vi.spyOn(console, "warn").mockImplementation(() => {});
    vi.spyOn(console, "error").mockImplementation(() => {});
  });

  afterEach(() => {
    fetchMock.mockReset();
    anthropicStreamMock.mockReset();
    AnthropicCtorMock.mockClear();
    vi.unstubAllGlobals();
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
    vi.useRealTimers();
  });

  it("calls Anthropic (streaming) with forced tool_choice and returns the tool input", async () => {
    mockAnthropicStream(anthropicMessage());

    const res = await generateWithTool({
      provider: "anthropic",
      model: "claude-sonnet-4-6",
      maxTokens: 1000,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });

    expect(res).toMatchObject({
      data: { questions: QUESTIONS },
      truncated: false,
      provider: "anthropic",
      model: "claude-sonnet-4-6",
    });
    // Uses the streaming client (not a plain POST) — see callAnthropic's
    // comment on why a plain fetch risks an idle-connection timeout.
    expect(AnthropicCtorMock).toHaveBeenCalledWith({ apiKey: "ant-key" });
    const params = anthropicStreamMock.mock.calls[0][0];
    expect(params.model).toBe("claude-sonnet-4-6");
    expect(params.max_tokens).toBe(1000);
    // Thinking is intentionally left at its default (adaptive) — see the
    // comment on callAnthropic for why disabling it is the wrong fix.
    expect(params.thinking).toBeUndefined();
    expect(params.tools[0].input_schema).toEqual(TOOL.input_schema);
    expect(params.tool_choice).toEqual({ type: "tool", name: TOOL.name });
  });

  it("calls DeepSeek in OpenAI format and parses tool_call arguments", async () => {
    fetchMock.mockResolvedValueOnce(deepseekResponse());

    const res = await generateWithTool({
      provider: "deepseek",
      model: "deepseek-v4-flash",
      maxTokens: 1000,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });

    expect(res).toMatchObject({
      data: { questions: QUESTIONS },
      truncated: false,
      provider: "deepseek",
      model: "deepseek-v4-flash",
    });
    const [url, init] = fetchMock.mock.calls[0];
    expect(url).toBe("https://api.deepseek.com/chat/completions");
    const body = JSON.parse(init.body);
    expect(init.headers.Authorization).toBe("Bearer ds-key");
    expect(body.tools[0]).toEqual(toOpenAITool(TOOL));
    expect(body.tool_choice).toEqual({ type: "function", function: { name: TOOL.name } });
  });

  it("flags truncation from Anthropic stop_reason=max_tokens", async () => {
    mockAnthropicStream(anthropicMessage("max_tokens"));
    const res = await generateWithTool({
      provider: "anthropic",
      model: "m",
      maxTokens: 10,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });
    expect(res.truncated).toBe(true);
  });

  it("flags truncation from DeepSeek finish_reason=length", async () => {
    fetchMock.mockResolvedValueOnce(deepseekResponse("length"));
    const res = await generateWithTool({
      provider: "deepseek",
      model: "m",
      maxTokens: 10,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });
    expect(res.truncated).toBe(true);
  });

  it("retries once, then falls back from DeepSeek to Claude", async () => {
    vi.useFakeTimers();
    fetchMock
      .mockResolvedValueOnce({ ok: false, text: async () => "boom1" })
      .mockResolvedValueOnce({ ok: false, text: async () => "boom2" });
    mockAnthropicStream(anthropicMessage());

    const promise = generateWithTool({
      provider: "deepseek",
      model: "deepseek-v4-flash",
      maxTokens: 1000,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });
    await vi.runAllTimersAsync();
    const res = await promise;

    expect(fetchMock).toHaveBeenCalledTimes(2);
    expect(fetchMock.mock.calls[0][0]).toBe("https://api.deepseek.com/chat/completions");
    expect(fetchMock.mock.calls[1][0]).toBe("https://api.deepseek.com/chat/completions");
    expect(anthropicStreamMock).toHaveBeenCalledTimes(1);
    expect(anthropicStreamMock.mock.calls[0][0].model).toBe(CLAUDE_DEFAULT_MODEL);
    expect(res).toMatchObject({
      data: { questions: QUESTIONS },
      provider: "anthropic",
      model: CLAUDE_DEFAULT_MODEL,
    });
  });

  it("does not fall back for Anthropic failures — the error propagates", async () => {
    vi.useFakeTimers();
    anthropicStreamMock.mockReturnValue({
      finalMessage: () => Promise.reject(new Error("down")),
    });

    const promise = generateWithTool({
      provider: "anthropic",
      model: "m",
      maxTokens: 10,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });
    // Attach the rejection handler before advancing timers to avoid an
    // unhandled rejection between the final attempt and the assertion.
    const assertion = expect(promise).rejects.toThrow("down");
    await vi.runAllTimersAsync();
    await assertion;
    expect(anthropicStreamMock).toHaveBeenCalledTimes(2);
  });

  it("throws a parse error when DeepSeek returns malformed arguments", async () => {
    fetchMock.mockResolvedValue({
      ok: true,
      json: async () => ({
        choices: [
          {
            finish_reason: "length",
            message: { tool_calls: [{ function: { name: TOOL.name, arguments: '{"questions": [tru' } }] },
          },
        ],
      }),
    });
    vi.useFakeTimers();
    const promise = generateWithTool({
      provider: "deepseek",
      model: "m",
      maxTokens: 10,
      prompt: "p",
      tool: TOOL,
      label: "t",
    });
    anthropicStreamMock.mockReturnValue({
      finalMessage: () => Promise.reject(new Error("no anthropic mock configured for this test")),
    });
    // DeepSeek path exhausts its retries on malformed JSON, then falls back
    // to Claude — which also fails here, so the run ends in a rejection.
    const assertion = expect(promise).rejects.toThrow();
    await vi.runAllTimersAsync();
    await assertion;
  });
});
