// Single-use unlock codes for the firstaid course paywall (fa_vouchers).
// Same alphabet/format as the old firstaid repo and scripts/firstaid/create-voucher.mjs
// so codes issued before the migration stay visually consistent: FAV-XXXXXXXX,
// no 0/O/1/I to avoid transcription mistakes over LINE.
const CHARS = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";

export function generateVoucherCode(): string {
  let out = "";
  for (let i = 0; i < 8; i++) {
    out += CHARS[Math.floor(Math.random() * CHARS.length)];
  }
  return `FAV-${out}`;
}
