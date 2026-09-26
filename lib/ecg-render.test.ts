import { describe, expect, it } from "vitest";
import { decodeFormat16, estimateHeartRate, parseWfdbHeader, removeBaseline, renderEcgSvg } from "@/lib/ecg-render";

const LEADS = ["I", "II", "III", "AVR", "AVL", "AVF", "V1", "V2", "V3", "V4", "V5", "V6"];

function header(fs = 500, n = 5000) {
  const sig = LEADS.map((l, i) => `00001_hr.dat 16 1000.0(0)/mV 16 0 ${i} 0 0 ${l}`);
  return [`00001_hr 12 ${fs} ${n}`, ...sig].join("\n");
}

/** Synthetic 60 bpm beats: a 1 mV spike every second in every lead. */
function synthDat(fs = 500, n = 5000): Uint8Array {
  const buf = new Uint8Array(n * 12 * 2);
  const view = new DataView(buf.buffer);
  for (let t = 0; t < n; t++) {
    const beat = t % fs;
    const mv = beat >= 100 && beat < 110 ? 1 : 0;
    for (let s = 0; s < 12; s++) view.setInt16((t * 12 + s) * 2, Math.round(mv * 1000), true);
  }
  return buf;
}

describe("parseWfdbHeader", () => {
  it("reads PTB-XL style headers", () => {
    const h = parseWfdbHeader(header());
    expect(h).toMatchObject({ record: "00001_hr", nSig: 12, fs: 500, nSamples: 5000 });
    expect(h.signals[0]).toEqual({ gain: 1000, baseline: 0, name: "I" });
    expect(h.signals.map(s => s.name)).toEqual(LEADS);
  });

  it("falls back to adczero when no baseline is given and rejects other formats", () => {
    const h = parseWfdbHeader("r 1 250 10\nr.dat 16 200/mV 16 5 0 0 0 II");
    expect(h.signals[0]).toEqual({ gain: 200, baseline: 5, name: "II" });
    expect(() => parseWfdbHeader("r 1 250 10\nr.dat 212 200/mV 12 0 0 0 0 II")).toThrow(/format/);
  });
});

describe("decodeFormat16", () => {
  it("de-interleaves and scales to mV", () => {
    const h = parseWfdbHeader(header());
    const leads = decodeFormat16(synthDat(), h);
    expect(leads).toHaveLength(12);
    expect(leads[1][105]).toBeCloseTo(1);
    expect(leads[1][50]).toBeCloseTo(0);
  });
});

describe("removeBaseline / estimateHeartRate", () => {
  it("removes a constant offset", () => {
    const x = new Float32Array(2000).fill(0.5);
    expect(Math.abs(removeBaseline(x, 500)[1000])).toBeLessThan(1e-6);
  });

  it("estimates 60 bpm from synthetic beats", () => {
    const h = parseWfdbHeader(header());
    const leads = decodeFormat16(synthDat(), h);
    expect(estimateHeartRate(leads[1], 500)).toBe(60);
  });
});

describe("renderEcgSvg", () => {
  it("draws 12 leads + rhythm strip with labels and caption", () => {
    const h = parseWfdbHeader(header());
    const svg = renderEcgSvg(h, decodeFormat16(synthDat(), h), { caption: "PTB-XL <test>" });
    expect(svg.startsWith("<svg")).toBe(true);
    expect(svg.match(/<polyline/g)!.length).toBe(12 + 1 + 4); // 12 leads + rhythm strip + 4 calibration pulses
    for (const l of ["aVR", "aVL", "aVF", "V1", "V6"]) expect(svg).toContain(`>${l}<`);
    expect(svg).toContain("PTB-XL &lt;test&gt;");
  });

  it("throws when a lead is missing", () => {
    const h = parseWfdbHeader(header());
    h.signals[6].name = "X";
    expect(() => renderEcgSvg(h, decodeFormat16(synthDat(), h))).toThrow(/V1/);
  });
});
