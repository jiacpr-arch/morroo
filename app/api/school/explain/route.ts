import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

const MODEL = "claude-sonnet-4-6";

/**
 * Self-explanation grader (Feynman technique).
 *
 * Body: { concept: string, userExplanation: string }
 * Returns: { score: 1-5, feedback: string, missingPoints: string[], strengths: string[] }
 */
export async function POST(req: NextRequest) {
  try {
    const { concept, userExplanation } = (await req.json()) as {
      concept?: string;
      userExplanation?: string;
    };
    if (!concept || !userExplanation) {
      return NextResponse.json(
        { error: "Missing concept or userExplanation" },
        { status: 400 }
      );
    }

    // Light auth check — we want logged-in users only
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

    const client = new Anthropic({ apiKey });
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 800,
      system: [
        {
          type: "text",
          text: `You are a medical school tutor grading a student's self-explanation (Feynman technique) of a concept.

Score 1-5 (1 = misconception, 3 = partial, 5 = excellent).
List specific strengths, missing points, and corrections (in Thai or English matching the student).
Respond with a tool call only.`,
          cache_control: { type: "ephemeral" },
        },
      ],
      tools: [
        {
          name: "submit_feedback",
          description: "Submit grading feedback for a student's self-explanation",
          input_schema: {
            type: "object",
            properties: {
              score: { type: "integer", minimum: 1, maximum: 5 },
              strengths: { type: "array", items: { type: "string" } },
              missing_points: { type: "array", items: { type: "string" } },
              feedback: { type: "string", description: "1-3 sentence encouraging summary" },
            },
            required: ["score", "strengths", "missing_points", "feedback"],
          },
          cache_control: { type: "ephemeral" },
        },
      ],
      tool_choice: { type: "tool", name: "submit_feedback" },
      messages: [
        {
          role: "user",
          content: `Concept: ${concept}\n\nStudent's explanation: ${userExplanation}\n\nGrade and give actionable feedback.`,
        },
      ],
    });

    const tool = response.content.find((b) => b.type === "tool_use");
    if (!tool || tool.type !== "tool_use") {
      return NextResponse.json({ error: "No grading received" }, { status: 502 });
    }
    return NextResponse.json(tool.input);
  } catch (err) {
    console.error("explain error", err);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
