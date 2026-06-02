import { describe, it, expect } from "vitest";
import { formatChapterBody } from "./format-book";

describe("formatChapterBody", () => {
  it("promotes a leading ALL-CAPS em-dash label to an h3 heading", () => {
    const out = formatChapterBody(
      "FUNCTIONS OF ORGANELLES — cell compartmentalisation makes cell function better."
    );
    expect(out).toBe(
      "### FUNCTIONS OF ORGANELLES\n\ncell compartmentalisation makes cell function better."
    );
  });

  it("promotes a leading Title-case label to an h3 heading", () => {
    const out = formatChapterBody(
      "Golgi apparatus — receives proteins from ER and packages them."
    );
    expect(out).toBe(
      "### Golgi apparatus\n\nreceives proteins from ER and packages them."
    );
  });

  it("splits a mid-paragraph ALL-CAPS sub-label into its own heading", () => {
    const out = formatChapterBody(
      "NUCLEUS — packed as chromosomes. NUCLEOLUS — where ribosomal RNA is made."
    );
    expect(out).toBe(
      "### NUCLEUS\n\npacked as chromosomes.\n\n### NUCLEOLUS\n\nwhere ribosomal RNA is made."
    );
  });

  it("keeps labels containing spaces, slashes and parentheses", () => {
    const out = formatChapterBody(
      "INTERMEDIATE FILAMENTS (IF) — tough structural fibres."
    );
    expect(out).toBe(
      "### INTERMEDIATE FILAMENTS (IF)\n\ntough structural fibres."
    );
  });

  it("does not treat a numbered list block as a heading", () => {
    const text =
      "MT-affecting drugs: (1) colchicine — binds tubulin; (2) taxol — stabilises.";
    expect(formatChapterBody(text)).toBe(text);
  });

  it("does not treat a numbered list item inside a paragraph as a heading", () => {
    const text =
      "compartmentalisation helps. (1) cytosol — metabolic pathways. (8) chloroplast (plants) — carbon fixation.";
    expect(formatChapterBody(text)).toBe(text);
  });

  it("does not split a mid-sentence acronym out of a paragraph", () => {
    const out = formatChapterBody(
      "CELL RESPONSES — vary by cell. Some use a second messenger (cyclic AMP) — to amplify the signal."
    );
    expect(out).toBe(
      "### CELL RESPONSES\n\nvary by cell. Some use a second messenger (cyclic AMP) — to amplify the signal."
    );
  });

  it("separates blocks split by blank lines", () => {
    const out = formatChapterBody(
      "CELLS — units of life.\n\nNUCLEUS — holds DNA."
    );
    expect(out).toBe(
      "### CELLS\n\nunits of life.\n\n### NUCLEUS\n\nholds DNA."
    );
  });

  it("returns empty string for empty input", () => {
    expect(formatChapterBody("")).toBe("");
  });
});
