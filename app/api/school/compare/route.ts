import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAnthropic } from "@/lib/anthropic";
import { friendlyAIError, logAIError } from "@/lib/anthropic-error";

const MODEL = "claude-sonnet-4-6";

/**
 * Compare & Contrast — AI generates side-by-side table of 2-3 concepts.
 * Body: { items: string[] (2-3 concepts/diseases) }
 * Returns: { rows: { aspect: string, values: string[] }[], summary: string }
 */
export async function POST(req: NextRequest) {
  try {
    const { items } = (await req.json()) as { items?: string[] };
    if (!items || items.length < 2 || items.length > 4) {
      return NextResponse.json(
        { error: "Provide 2-4 items to compare" },
        { status: 400 }
      );
    }

    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      return NextResponse.json(
        { error: "Service not configured" },
        { status: 503 }
      );
    }

    const client = createAnthropic();
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 2000,
      system: [
        {
          type: "text",
          text: `You are a medical education tutor producing comparison tables for Thai medical students.

Given 2-4 items (diseases, drugs, concepts, etc.), produce a side-by-side comparison covering
the dimensions most useful for discrimination — typically:
- Definition / mechanism
- Epidemiology / risk factors
- Pathophysiology
- Clinical presentation
- Investigations / diagnosis
- Management
- Key distinguishing feature

Skip dimensions that aren't meaningful. Cells should be concise (≤ 30 words). Use Thai
mixed with English medical terms. Submit via the tool.`,
          cache_control: { type: "ephemeral" },
        },
      ],
      tools: [
        {
          name: "submit_comparison",
          description: "Submit a comparison table",
          input_schema: {
            type: "object",
            properties: {
              rows: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    aspect: { type: "string", description: "Dimension being compared" },
                    values: {
                      type: "array",
                      items: { type: "string" },
                      description: "One value per input item, in the same order",
                    },
                  },
                  required: ["aspect", "values"],
                },
              },
              summary: {
                type: "string",
                description: "1-2 sentence takeaway emphasising the key distinguishing feature",
              },
            },
            required: ["rows", "summary"],
          },
          cache_control: { type: "ephemeral" },
        },
      ],
      tool_choice: { type: "tool", name: "submit_comparison" },
      messages: [
        {
          role: "user",
          content: `Compare these: ${items.map((it, i) => `${i + 1}) ${it}`).join("  ")}`,
        },
      ],
    });

    const tool = response.content.find((b) => b.type === "tool_use");
    if (!tool || tool.type !== "tool_use") {
      return NextResponse.json({ error: "No table received" }, { status: 502 });
    }
    return NextResponse.json(tool.input);
  } catch (err) {
    logAIError("school/compare", err);
    return NextResponse.json({ error: friendlyAIError(err) }, { status: 500 });
  }
}
