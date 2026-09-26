/**
 * Render a real 12-lead ECG (WFDB format-16 record, e.g. PTB-XL 500 Hz) as a
 * standard paper-style SVG: 25 mm/s, 10 mm/mV, 3×4 lead layout + lead II
 * rhythm strip, 1 mV calibration pulse. Pure functions — no I/O.
 */

export interface WfdbSignal {
  gain: number; // ADC units per mV
  baseline: number; // ADC value of 0 mV
  name: string; // lead name, e.g. "II", "AVF", "V1"
}

export interface WfdbHeader {
  record: string;
  nSig: number;
  fs: number;
  nSamples: number;
  signals: WfdbSignal[];
}

/** Parse a WFDB .hea header (single-segment, format 16 records). */
export function parseWfdbHeader(text: string): WfdbHeader {
  const lines = text
    .split(/\r?\n/)
    .map(l => l.trim())
    .filter(l => l && !l.startsWith("#"));
  const [record, nSigStr, fsStr, nSampStr] = lines[0].split(/\s+/);
  const nSig = Number(nSigStr);
  const fs = Number((fsStr ?? "250").split("/")[0]);
  const nSamples = Number(nSampStr);
  if (!nSig || !fs || !nSamples) throw new Error(`bad WFDB header: ${lines[0]}`);

  const signals: WfdbSignal[] = [];
  for (let i = 1; i <= nSig; i++) {
    const f = (lines[i] ?? "").split(/\s+/);
    if (f[1] !== "16") throw new Error(`unsupported WFDB format "${f[1]}" (only 16)`);
    // gain field: "1000.0(0)/mV" — baseline in parentheses defaults to adczero
    const m = /^([\d.+-eE]+)(?:\((-?\d+)\))?/.exec(f[2] ?? "");
    const gain = m ? Number(m[1]) || 200 : 200;
    const adcZero = Number(f[4] ?? 0);
    const baseline = m?.[2] !== undefined ? Number(m[2]) : adcZero;
    signals.push({ gain, baseline, name: f.slice(8).join(" ") || `ch${i}` });
  }
  return { record, nSig, fs, nSamples, signals };
}

/** Decode interleaved little-endian int16 samples into per-lead mV arrays. */
export function decodeFormat16(buf: Uint8Array, header: WfdbHeader): Float32Array[] {
  const { nSig, signals } = header;
  const frames = Math.min(header.nSamples, Math.floor(buf.byteLength / (2 * nSig)));
  const view = new DataView(buf.buffer, buf.byteOffset, buf.byteLength);
  const out = signals.map(() => new Float32Array(frames));
  for (let t = 0; t < frames; t++) {
    for (let s = 0; s < nSig; s++) {
      const raw = view.getInt16((t * nSig + s) * 2, true);
      out[s][t] = (raw - signals[s].baseline) / signals[s].gain;
    }
  }
  return out;
}

/** Remove baseline wander: subtract a centred moving average (prefix sums). */
export function removeBaseline(x: Float32Array, fs: number, windowSec = 1.2): Float32Array {
  const n = x.length;
  const half = Math.max(1, Math.round((windowSec * fs) / 2));
  const prefix = new Float64Array(n + 1);
  for (let i = 0; i < n; i++) prefix[i + 1] = prefix[i] + x[i];
  const out = new Float32Array(n);
  for (let i = 0; i < n; i++) {
    const a = Math.max(0, i - half);
    const b = Math.min(n, i + half + 1);
    out[i] = x[i] - (prefix[b] - prefix[a]) / (b - a);
  }
  return out;
}

/** Rough heart rate from one lead (simple slope-energy R-peak detection). */
export function estimateHeartRate(x: Float32Array, fs: number): number | null {
  const n = x.length;
  if (n < fs * 3) return null;
  const e = new Float32Array(n);
  for (let i = 1; i < n; i++) e[i] = (x[i] - x[i - 1]) ** 2;
  let max = 0;
  for (const v of e) if (v > max) max = v;
  if (max === 0) return null;
  const thr = max * 0.15;
  const refractory = Math.round(0.28 * fs);
  const peaks: number[] = [];
  for (let i = 1; i < n - 1; i++) {
    if (e[i] > thr && e[i] >= e[i - 1] && e[i] >= e[i + 1]) {
      if (peaks.length && i - peaks[peaks.length - 1] < refractory) {
        if (e[i] > e[peaks[peaks.length - 1]]) peaks[peaks.length - 1] = i;
      } else peaks.push(i);
    }
  }
  if (peaks.length < 3) return null;
  const rr = (peaks[peaks.length - 1] - peaks[0]) / (peaks.length - 1) / fs;
  return Math.round(60 / rr);
}

const LAYOUT = [
  ["I", "AVR", "V1", "V4"],
  ["II", "AVL", "V2", "V5"],
  ["III", "AVF", "V3", "V6"],
];
const PRETTY: Record<string, string> = { AVR: "aVR", AVL: "aVL", AVF: "aVF" };

export interface RenderOptions {
  /** px per mm (paper scale); 6 → ~1560px wide */
  pxPerMm?: number;
  /** small caption at the bottom-left, e.g. source attribution */
  caption?: string;
}

/** Build the ECG sheet SVG from per-lead mV arrays keyed by header order. */
export function renderEcgSvg(header: WfdbHeader, leads: Float32Array[], opts: RenderOptions = {}): string {
  const k = opts.pxPerMm ?? 6;
  const fs = header.fs;
  const byName = new Map<string, Float32Array>();
  header.signals.forEach((s, i) => byName.set(s.name.toUpperCase(), removeBaseline(leads[i], fs)));
  const need = (name: string) => {
    const sig = byName.get(name);
    if (!sig) throw new Error(`lead ${name} missing (have ${[...byName.keys()].join(",")})`);
    return sig;
  };

  const mmPerSec = 25;
  const mmPerMv = 10;
  const colSec = 2.5;
  const leftMm = 12; // room for the calibration pulse
  const rowMm = 30;
  const topMm = 8;
  const widthMm = leftMm + colSec * 4 * mmPerSec + 6;
  const heightMm = topMm + rowMm * 4 + 10;
  const W = Math.round(widthMm * k);
  const H = Math.round(heightMm * k);
  const px = (mm: number) => (mm * k).toFixed(1);

  const parts: string[] = [];
  parts.push(`<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}">`);
  parts.push(`<rect width="100%" height="100%" fill="#fff7f5"/>`);
  // grid: 1 mm minor, 5 mm major
  const minor: string[] = [];
  const major: string[] = [];
  for (let x = 0; x <= widthMm; x++) (x % 5 ? minor : major).push(`M${px(x)} 0V${H}`);
  for (let y = 0; y <= heightMm; y++) (y % 5 ? minor : major).push(`M0 ${px(y)}H${W}`);
  parts.push(`<path d="${minor.join("")}" stroke="#f6c9c3" stroke-width="${(k * 0.12).toFixed(2)}"/>`);
  parts.push(`<path d="${major.join("")}" stroke="#ec9a90" stroke-width="${(k * 0.25).toFixed(2)}"/>`);

  const trace = (sig: Float32Array, t0: number, t1: number, x0Mm: number, yMidMm: number) => {
    const a = Math.max(0, Math.floor(t0 * fs));
    const b = Math.min(sig.length, Math.floor(t1 * fs));
    const pts: string[] = [];
    for (let i = a; i < b; i++) {
      const xMm = x0Mm + ((i - a) / fs) * mmPerSec;
      // clamp to ±2.2 mV so a huge QRS can't run into the next row
      const mv = Math.max(-2.2, Math.min(2.2, sig[i]));
      pts.push(`${px(xMm)},${px(yMidMm - mv * mmPerMv)}`);
    }
    return `<polyline fill="none" stroke="#111" stroke-width="${(k * 0.22).toFixed(2)}" stroke-linejoin="round" points="${pts.join(" ")}"/>`;
  };
  const calib = (yMidMm: number) => {
    const x = 3;
    const pts = [
      [x, yMidMm], [x + 1, yMidMm], [x + 1, yMidMm - 10], [x + 6, yMidMm - 10], [x + 6, yMidMm], [x + 7, yMidMm],
    ].map(([a, b]) => `${px(a)},${px(b)}`);
    return `<polyline fill="none" stroke="#111" stroke-width="${(k * 0.22).toFixed(2)}" points="${pts.join(" ")}"/>`;
  };
  const label = (text: string, xMm: number, yMm: number) =>
    `<text x="${px(xMm)}" y="${px(yMm)}" font-family="Helvetica, Arial, sans-serif" font-size="${(k * 3.2).toFixed(1)}" font-weight="600" fill="#222">${text}</text>`;

  LAYOUT.forEach((row, r) => {
    const yMid = topMm + rowMm * r + rowMm * 0.55;
    parts.push(calib(yMid));
    row.forEach((name, c) => {
      const x0 = leftMm + c * colSec * mmPerSec;
      parts.push(trace(need(name), c * colSec, (c + 1) * colSec, x0, yMid));
      if (c > 0) parts.push(`<path d="M${px(x0)} ${px(yMid - 4)}V${px(yMid + 4)}" stroke="#111" stroke-width="${(k * 0.22).toFixed(2)}"/>`);
      parts.push(label(PRETTY[name] ?? name, x0 + 1, yMid - 9));
    });
  });
  const yRhythm = topMm + rowMm * 3 + rowMm * 0.55;
  parts.push(calib(yRhythm));
  parts.push(trace(need("II"), 0, colSec * 4, leftMm, yRhythm));
  parts.push(label("II", leftMm + 1, yRhythm - 9));
  const foot = `25 mm/s · 10 mm/mV${opts.caption ? ` · ${opts.caption}` : ""}`;
  parts.push(
    `<text x="${px(3)}" y="${px(heightMm - 3)}" font-family="Helvetica, Arial, sans-serif" font-size="${(k * 2.4).toFixed(1)}" fill="#555">${escapeXml(foot)}</text>`,
  );
  parts.push(`</svg>`);
  return parts.join("");
}

function escapeXml(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}
