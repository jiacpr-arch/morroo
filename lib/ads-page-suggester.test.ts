import { describe, it, expect } from "vitest";
import { findPageFile, runRiskChecks } from "./ads-page-suggester";

describe("findPageFile", () => {
  it("maps /lp/foo to app/lp/foo/page.tsx", () => {
    expect(findPageFile("/lp/free-trial")).toBe("app/lp/free-trial/page.tsx");
    expect(findPageFile("/p/pricing")).toBe("app/p/pricing/page.tsx");
  });

  it("returns null for non-landing-page paths", () => {
    expect(findPageFile("/dashboard")).toBeNull();
    expect(findPageFile("/admin/users")).toBeNull();
    expect(findPageFile("/")).toBeNull();
  });

  it("refuses dynamic segments", () => {
    expect(findPageFile("/lp/[hash]")).toBeNull();
    expect(findPageFile("/p/[id]")).toBeNull();
  });

  it("strips query strings", () => {
    expect(findPageFile("/lp/foo?utm_source=meta")).toBe(
      "app/lp/foo/page.tsx"
    );
  });
});

const SAMPLE_SOURCE = `import type { Metadata } from "next";
import { track } from "@/lib/analytics";
import LeadForm from "./LeadForm";

export const metadata: Metadata = {
  title: "Try MorRoo",
};

export default function Page() {
  return (
    <main>
      <h1>Try MorRoo free</h1>
      <button onClick={() => track("signup_submit")}>Sign up</button>
      <LeadForm />
    </main>
  );
}
`;

describe("runRiskChecks", () => {
  it("passes when the rewrite preserves tracking + structure", () => {
    const proposed = SAMPLE_SOURCE.replace(
      "Try MorRoo free",
      "Try MorRoo free — ฟรี 7 วัน"
    );
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    expect(checks.every((c) => c.ok)).toBe(true);
  });

  it("fails when tracking call is dropped", () => {
    const proposed = SAMPLE_SOURCE.replace(
      `onClick={() => track("signup_submit")}`,
      ""
    );
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    const trackCheck = checks.find((c) => c.name.includes("signup_submit"));
    expect(trackCheck?.ok).toBe(false);
  });

  it("fails when imports are dropped silently", () => {
    const proposed = SAMPLE_SOURCE
      .replace(`import { track } from "@/lib/analytics";\n`, "")
      .replace(`onClick={() => track("signup_submit")}`, `onClick={() => {}}`);
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    const importsCheck = checks.find((c) => c.name === "imports preserved");
    expect(importsCheck?.ok).toBe(false);
  });

  it("fails when default export disappears", () => {
    const proposed = SAMPLE_SOURCE.replace(
      "export default function Page()",
      "function Page()"
    );
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    expect(
      checks.find((c) => c.name === "exports default function")?.ok
    ).toBe(false);
  });

  it("fails when SEO metadata is dropped", () => {
    const proposed = SAMPLE_SOURCE.replace(
      /export const metadata[\s\S]*?};\n\n/,
      ""
    );
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    expect(
      checks.find((c) => c.name === "SEO metadata export preserved")?.ok
    ).toBe(false);
  });

  it("fails when the rewrite shrinks too much", () => {
    const proposed = "export default function Page() { return null; }";
    const checks = runRiskChecks(SAMPLE_SOURCE, proposed);
    expect(
      checks.find((c) => c.name === "size within ±40% of original")?.ok
    ).toBe(false);
  });
});
