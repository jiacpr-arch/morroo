import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAnthropic } from "@/lib/anthropic";
import { friendlyAIError, logAIError } from "@/lib/anthropic-error";

const MODEL = "claude-haiku-4-5-20251001";

/**
 * Elaborative interrogation prompt generator.
 *
 * Body: { concept: string }
 * Returns: { question: string }
 *
 * Generates a "why is this true?" / "how does this work?" question that forces
 * the learner to retrieve causal explanations. Research-backed (Dunlosky et al.
 * 2013, "moderate utility").
 */
export async function POST(req: NextRequest) {
  try {
    const { concept } = (await req.json()) as { concept?: string };
    if (!concept) {
      return NextResponse.json({ error: "Missing concept" }, { status: 400 });
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
      max_tokens: 300,
      system: `Generate one elaborative interrogation question for a medical concept. Force the learner to think about WHY or HOW. Use Thai or English matching the input. Return a tool call.`,
      tools: [
        {
          name: "submit_question",
          description: "Submit an elaborative interrogation question",
          input_schema: {
            type: "object",
            properties: {
              question: { type: "string", description: "A 'why' or 'how' question" },
              hint: { type: "string", description: "Optional 1-sentence hint to guide thinking" },
            },
            required: ["question"],
          },
        },
      ],
      tool_choice: { type: "tool", name: "submit_question" },
      messages: [{ role: "user", content: `Concept: ${concept}` }],
    });

    const tool = response.content.find((b) => b.type === "tool_use");
    if (!tool || tool.type !== "tool_use") {
      return NextResponse.json({ error: "No question received" }, { status: 502 });
    }
    return NextResponse.json(tool.input);
  } catch (err) {
    logAIError("school/elaborate", err);
    return NextResponse.json({ error: friendlyAIError(err) }, { status: 500 });
  }
}
