import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  CLAUDE_HAIKU_MODEL,
  DEFAULT_DEEPSEEK_MODEL,
  generateWithTool,
  resolveEasyMediumProvider,
  toOpenAITool,
} from "./llm.mjs";

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

function anthropicResponse(stopReason = "tool_use") {
  return {
    ok: true,
    json: async () => ({
      content: [{ type: "tool_use", input: { questions: QUESTIONS } }],
      stop_reason: stopReason,
      usage: { input_tokens: 10, output_tokens: 20 },
    }),
  };
}

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
  it("defaults to Claude when MCQ_GEN_PROVIDER is unset or empty", () => {
    expect(resolveEasyMediumProvider({})).toEqual({
      provider: "anthropic",
      model: CLAUDE_HAIKU_MODEL,
    });
    expect(resolveEasyMediumProvider({ MCQ_GEN_PROVIDER: "" })).toEqual({
      provider: "anthropic",
      model: CLAUDE_HAIKU_MODEL,
    });
  });

  it("uses DeepSeek when configured with an API key", () => {
    expect(
      resolveEasyMediumProvider({ MCQ_GEN_PROVIDER: "deepseek", DEEPSEEK_API_KEY: "k" })
    ).toEqual({ provider: "deepseek", model: DEFAULT_DEEPSEEK_MODEL });
  });

  it("honours DEEPSEEK_MODEL override", () => {
    expect(
      resolveEasyMediumProvider({
        MCQ_GEN_PROVIDER: "deepseek",
        DEEPSEEK_API_KEY: "k",
        DEEPSEEK_MODEL: "deepseek-v4-pro",
      })
    ).toEqual({ provider: "deepseek", model: "deepseek-v4-pro" });
  });

  it("falls back to Claude when deepseek is requested without a key", () => {
    const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
    expect(resolveEasyMediumProvider({ MCQ_GEN_PROVIDER: "deepseek" })).toEqual({
      provider: "anthropic",
      model: CLAUDE_HAIKU_MODEL,
    });
    expect(warn).toHaveBeenCalled();
    warn.mockRestore();
  });

  it("falls back to Claude on an unknown provider value", () => {
    const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
    expect(resolveEasyMediumProvider({ MCQ_GEN_PROVIDER: "gpt" })).toEqual({
      provider: "anthropic",
      model: CLAUDE_HAIKU_MODEL,
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
    vi.unstubAllGlobals();
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
    vi.useRealTimers();
  });

  it("calls Anthropic with forced tool_choice and returns the tool input", async () => {
    fetchMock.mockResolvedValueOnce(anthropicResponse());

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
    const [url, init] = fetchMock.mock.calls[0];
    expect(url).toBe("https://api.anthropic.com/v1/messages");
    const body = JSON.parse(init.body);
    expect(init.headers["x-api-key"]).toBe("ant-key");
    expect(body.tools[0].input_schema).toEqual(TOOL.input_schema);
    expect(body.tool_choice).toEqual({ type: "tool", name: TOOL.name });
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
    fetchMock.mockResolvedValueOnce(anthropicResponse("max_tokens"));
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

  it("retries once, then falls back from DeepSeek to Claude Haiku", async () => {
    vi.useFakeTimers();
    fetchMock
      .mockResolvedValueOnce({ ok: false, text: async () => "boom1" })
      .mockResolvedValueOnce({ ok: false, text: async () => "boom2" })
      .mockResolvedValueOnce(anthropicResponse());

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

    expect(fetchMock).toHaveBeenCalledTimes(3);
    expect(fetchMock.mock.calls[0][0]).toBe("https://api.deepseek.com/chat/completions");
    expect(fetchMock.mock.calls[1][0]).toBe("https://api.deepseek.com/chat/completions");
    expect(fetchMock.mock.calls[2][0]).toBe("https://api.anthropic.com/v1/messages");
    expect(res).toMatchObject({
      data: { questions: QUESTIONS },
      provider: "anthropic",
      model: CLAUDE_HAIKU_MODEL,
    });
  });

  it("does not fall back for Anthropic failures — the error propagates", async () => {
    vi.useFakeTimers();
    fetchMock.mockResolvedValue({ ok: false, text: async () => "down" });

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
    const assertion = expect(promise).rejects.toThrow("Anthropic API error");
    await vi.runAllTimersAsync();
    await assertion;
    expect(fetchMock).toHaveBeenCalledTimes(2);
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
    // DeepSeek path falls back to Claude, whose mock also returns the malformed
    // DeepSeek shape — so the run ends with the Anthropic "no tool_use" error.
    const assertion = expect(promise).rejects.toThrow();
    await vi.runAllTimersAsync();
    await assertion;
  });
});
