// Interim voucher creation until the Phase 2 admin UI exists.
// Generates single-use unlock codes directly in morroo's Supabase (fa_vouchers),
// same semantics as the old /api/vouchers/create endpoint.
//
// Usage:
//   NEW_SUPABASE_URL=... NEW_SUPABASE_SERVICE_ROLE_KEY=... \
//     node scripts/firstaid/create-voucher.mjs --chapter 0 --count 5 --price 249
//
// chapter 0 = whole-course bundle, 1-4 = single chapter.
import { createClient } from "@supabase/supabase-js";

const CHARS = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
function generateVoucherCode() {
  let out = "";
  for (let i = 0; i < 8; i++)
    out += CHARS[Math.floor(Math.random() * CHARS.length)];
  return `FAV-${out}`;
}

function arg(name, fallback) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 ? process.argv[i + 1] : fallback;
}

const chapter = Number(arg("chapter", "0"));
const count = Math.min(100, Math.max(1, Number(arg("count", "1"))));
const priceThb = arg("price") != null ? Number(arg("price")) : null;

if (!Number.isInteger(chapter) || chapter < 0 || chapter > 4) {
  console.error("Invalid --chapter (0-4; 0 = bundle)");
  process.exit(1);
}
const url = process.env.NEW_SUPABASE_URL;
const key = process.env.NEW_SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) {
  console.error("Set NEW_SUPABASE_URL and NEW_SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const db = createClient(url, key, { auth: { persistSession: false } });
const rows = Array.from({ length: count }, () => ({
  code: generateVoucherCode(),
  chapter,
  price_thb: priceThb,
}));

const { data, error } = await db
  .from("fa_vouchers")
  .insert(rows)
  .select("code, chapter, price_thb, status");
if (error) {
  console.error(error.message);
  process.exit(1);
}
for (const v of data) console.log(`${v.code}\tchapter=${v.chapter}\t฿${v.price_thb ?? "-"}`);
