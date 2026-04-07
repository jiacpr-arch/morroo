import { getDb } from "./database";
import { lineMessage } from "./line-notify";
// node:sqlite uses identical API to better-sqlite3 for .prepare/.run/.get/.all

const TOKEN_URL = process.env.FLOWACCOUNT_TOKEN_URL ?? "https://openapi.flowaccount.com/test/token";
const BASE_URL  = process.env.FLOWACCOUNT_BASE_URL  ?? "https://openapi.flowaccount.com/sandbox";
const CLIENT_ID = process.env.FLOWACCOUNT_CLIENT_ID ?? "";
const CLIENT_SECRET = process.env.FLOWACCOUNT_CLIENT_SECRET ?? "";

// Token cache
let cachedToken = "";
let tokenExpiresAt = 0;

async function getToken(): Promise<string> {
  if (cachedToken && Date.now() < tokenExpiresAt - 60_000) return cachedToken;
  const res = await fetch(TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "client_credentials",
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      scope: "flowaccount-api",
    }),
  });
  if (!res.ok) throw new Error(`Token error: ${res.status}`);
  const data = await res.json() as { access_token: string; expires_in: number };
  cachedToken = data.access_token;
  tokenExpiresAt = Date.now() + data.expires_in * 1000;
  return cachedToken;
}

async function flowFetch(path: string): Promise<unknown> {
  const token = await getToken();
  const res = await fetch(`${BASE_URL}${path}`, {
    headers: { Authorization: `Bearer ${token}`, Accept: "application/json" },
  });
  if (!res.ok) throw new Error(`FlowAccount ${path} → ${res.status}: ${await res.text()}`);
  return res.json();
}

interface FAQuotation {
  documentId?: number;
  recordId?: number;
  documentSerial?: string;
  contactName?: string;
  contactTaxId?: string;
  publishedOn?: string;
  dueDate?: string;
  status?: string;
  grandTotal?: number | string;
  salesName?: string;
  items?: Array<{ name?: string }>;
}

export async function syncQuotations(): Promise<{ added: number; updated: number }> {
  const db = getDb();
  let added = 0;
  let updated = 0;

  try {
    const data = await flowFetch(
      "/quotations?currentPage=1&pageSize=100"
    ) as { data?: { totalDocument?: string; list?: FAQuotation[] } };

    const rows = data?.data?.list ?? [];
    for (const q of rows) {
      const faId = String(q.documentId ?? q.recordId ?? "");
      if (!faId) continue;
      const productCodes = JSON.stringify((q.items ?? []).map((i) => i.name).filter(Boolean));
      const grandTotal = typeof q.grandTotal === "string" ? parseFloat(q.grandTotal) : (q.grandTotal ?? 0);
      const existing = db.prepare("SELECT id FROM quotations WHERE fa_document_id = ?").get(faId);
      if (existing) {
        db.prepare(`
          UPDATE quotations
          SET document_number=?, contact_name=?, contact_tax_id=?,
              product_codes=?, total_amount=?, issue_date=?,
              expiry_date=?, fa_status=?, updated_at=datetime('now','localtime')
          WHERE fa_document_id=?
        `).run(
          q.documentSerial ?? "", q.contactName ?? "", q.contactTaxId ?? "",
          productCodes, grandTotal,
          q.publishedOn?.slice(0, 10) ?? "",
          q.dueDate?.slice(0, 10) ?? null,
          q.status ?? "1",
          faId
        );
        updated++;
      } else {
        db.prepare(`
          INSERT INTO quotations
            (fa_document_id, document_number, contact_name, contact_tax_id,
             product_codes, total_amount, issue_date, expiry_date, fa_status)
          VALUES (?,?,?,?,?,?,?,?,?)
        `).run(
          faId, q.documentSerial ?? "", q.contactName ?? "", q.contactTaxId ?? "",
          productCodes, grandTotal,
          q.publishedOn?.slice(0, 10) ?? "",
          q.dueDate?.slice(0, 10) ?? null,
          q.status ?? "1"
        );
        added++;
      }
    }
    db.prepare("INSERT INTO sync_log (status, records, message) VALUES (?,?,?)")
      .run("success", added + updated, `added=${added} updated=${updated}`);

    // Auto-resolve conflicts + notify new conflicts
    await autoResolveConflicts(db);
    await notifyNewConflicts(db);
    await notifyExpiringQuotations(db);
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    db.prepare("INSERT INTO sync_log (status, records, message) VALUES (?,?,?)")
      .run("error", 0, msg);
    console.error("FlowAccount sync error:", msg);
  }
  return { added, updated };
}

// ── Auto-resolve conflicts: ใครออกใบก่อน + follow-up ภายใน 90 วัน = ได้สิทธิ์ ──
async function autoResolveConflicts(db: ReturnType<typeof getDb>): Promise<void> {
  const conflicts = db.prepare("SELECT * FROM v_conflicts").all() as Array<{
    quot_a_id: number; quot_a_date: string; sales_a_id: number; sales_a_name: string;
    quot_b_id: number; quot_b_date: string; sales_b_id: number; sales_b_name: string;
    contact_name: string;
  }>;

  for (const c of conflicts) {
    // Check if already resolved
    const resolved = db.prepare(
      "SELECT id FROM conflict_resolutions WHERE (winner_quot_id=? AND loser_quot_id=?) OR (winner_quot_id=? AND loser_quot_id=?)"
    ).get(c.quot_a_id, c.quot_b_id, c.quot_b_id, c.quot_a_id);
    if (resolved) continue;

    // Who issued first?
    const aFirst = (c.quot_a_date ?? "") <= (c.quot_b_date ?? "");
    const firstId = aFirst ? c.quot_a_id : c.quot_b_id;
    const secondId = aFirst ? c.quot_b_id : c.quot_a_id;
    const firstName = aFirst ? c.sales_a_name : c.sales_b_name;
    const secondName = aFirst ? c.sales_b_name : c.sales_a_name;

    // Check if first issuer followed up within 90 days
    const lastFollow = db.prepare(
      "SELECT MAX(followed_at) AS last FROM follow_ups WHERE quotation_id=?"
    ).get(firstId) as { last: string | null };

    const daysSince = lastFollow?.last
      ? (Date.now() - new Date(lastFollow.last).getTime()) / 86400000
      : Infinity;

    if (daysSince <= 90) {
      // First issuer followed up → gets the customer
      db.prepare(
        "INSERT INTO conflict_resolutions (winner_quot_id, loser_quot_id, resolved_by, reason) VALUES (?,?,0,?)"
      ).run(firstId, secondId, `ตัดสินอัตโนมัติ: ${firstName} ออกใบก่อน + follow-up ภายใน 90 วัน`);

      await lineMessage(
        `⚖️ ตัดสินอัตโนมัติ: ลูกค้า "${c.contact_name}"\n✅ ${firstName} ได้สิทธิ์ (ออกใบก่อน + follow-up)\n❌ ${secondName} สิทธิ์หลุด`
      );
    } else if (daysSince > 90) {
      // First issuer didn't follow up → second gets it
      const secondFollow = db.prepare(
        "SELECT MAX(followed_at) AS last FROM follow_ups WHERE quotation_id=?"
      ).get(secondId) as { last: string | null };

      const secondDays = secondFollow?.last
        ? (Date.now() - new Date(secondFollow.last).getTime()) / 86400000
        : Infinity;

      if (secondDays <= 90) {
        db.prepare(
          "INSERT INTO conflict_resolutions (winner_quot_id, loser_quot_id, resolved_by, reason) VALUES (?,?,0,?)"
        ).run(secondId, firstId, `ตัดสินอัตโนมัติ: ${firstName} ไม่ follow-up 90 วัน → สิทธิ์ตก ${secondName}`);

        await lineMessage(
          `⚖️ ตัดสินอัตโนมัติ: ลูกค้า "${c.contact_name}"\n✅ ${secondName} ได้สิทธิ์ (${firstName} ไม่ follow-up 90 วัน)\n❌ ${firstName} สิทธิ์หลุด`
        );
      }
      // If both didn't follow up → leave unresolved for admin
    }
  }
}

// ── Notify new (unresolved) conflicts ──
async function notifyNewConflicts(db: ReturnType<typeof getDb>): Promise<void> {
  const unresolved = db.prepare(`
    SELECT c.*,
      NOT EXISTS (
        SELECT 1 FROM conflict_resolutions cr
        WHERE (cr.winner_quot_id=c.quot_a_id AND cr.loser_quot_id=c.quot_b_id)
           OR (cr.winner_quot_id=c.quot_b_id AND cr.loser_quot_id=c.quot_a_id)
      ) AS is_new
    FROM v_conflicts c
  `).all() as Array<{
    contact_name: string; sales_a_name: string; sales_b_name: string;
    quot_a_number: string; quot_b_number: string; is_new: number;
  }>;

  const newConflicts = unresolved.filter(c => c.is_new);
  if (newConflicts.length === 0) return;

  const lines = [
    `⚠️ พบลูกค้าชนกัน ${newConflicts.length} คู่ (รอตัดสิน)`,
    "",
    ...newConflicts.slice(0, 5).map(c =>
      `• ${c.contact_name}: ${c.sales_a_name} vs ${c.sales_b_name}`
    ),
    ...(newConflicts.length > 5 ? [`... และอีก ${newConflicts.length - 5} คู่`] : []),
  ];
  await lineMessage(lines.join("\n"));
}

// ── Notify quotations expiring within 7 days (90-day follow-up rule) ──
async function notifyExpiringQuotations(db: ReturnType<typeof getDb>): Promise<void> {
  const expiring = db.prepare(`
    SELECT q.document_number, q.contact_name, u.full_name AS sales_name,
      fu.followed_at AS last_follow,
      CAST(JULIANDAY('now','localtime') - JULIANDAY(fu.followed_at) AS INTEGER) AS days_since
    FROM quotations q
    LEFT JOIN users u ON u.id = q.sales_user_id
    LEFT JOIN (
      SELECT quotation_id, MAX(followed_at) AS followed_at
      FROM follow_ups GROUP BY quotation_id
    ) fu ON fu.quotation_id = q.id
    WHERE fu.followed_at IS NOT NULL
      AND JULIANDAY('now','localtime') - JULIANDAY(fu.followed_at) BETWEEN 83 AND 90
  `).all() as Array<{
    document_number: string; contact_name: string; sales_name: string; days_since: number;
  }>;

  if (expiring.length === 0) return;

  const lines = [
    `🔔 ใบเสนอราคาใกล้หมด 90 วัน — ต้องตามลูกค้า!`,
    "",
    ...expiring.map(q =>
      `• ${q.document_number} — ${q.contact_name} (${q.sales_name}) เหลือ ${90 - q.days_since} วัน`
    ),
  ];
  await lineMessage(lines.join("\n"));
}
