"use client";

/**
 * Sales enters a closed course sale here, from a phone, right after the
 * customer transfers. Saving fires the Purchase CAPI event that Meta
 * otherwise never sees for chat-closed deals.
 *
 * See docs/spec-capi-conversion-tracking.md, Part A.
 */

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import {
  COURSES,
  SOURCE_CHANNELS,
  findCourse,
  todayInBangkok,
  type CourseId,
} from "@/lib/course-sales";

interface SaleRow {
  id: number;
  customer_name: string;
  phone: string;
  course_name: string;
  price_thb: number;
  source_channel: string | null;
  sold_on: string;
  capi_sent_at: string | null;
}

interface Totals {
  count: number;
  revenueThb: number;
  capiPending: number;
}

const baht = (n: number) => `฿${n.toLocaleString("th-TH")}`;

export default function AdminCourseSalesPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);

  const [customerName, setCustomerName] = useState("");
  const [phone, setPhone] = useState("");
  const [courseId, setCourseId] = useState<CourseId>("cpr");
  // Kept as a string so the field can be cleared while typing.
  const [price, setPrice] = useState(String(COURSES[0].priceThb));
  const [sourceChannel, setSourceChannel] = useState("");
  const [soldOn, setSoldOn] = useState(todayInBangkok());

  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [okMessage, setOkMessage] = useState<string | null>(null);
  const [items, setItems] = useState<SaleRow[]>([]);
  const [totals, setTotals] = useState<Totals | null>(null);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/course-sales?limit=50");
    if (!res.ok) {
      setError("โหลดรายการไม่สำเร็จ");
      return;
    }
    const json = await res.json();
    setItems(json.items ?? []);
    setTotals(json.totals ?? null);
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login?next=/admin/course-sales");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      await load();
      setLoading(false);
    }
    init();
  }, [router, load]);

  // Switching course refills the price with its list value; an edit sticks
  // until the course changes again, so a discount isn't silently reset.
  function onCourseChange(id: CourseId) {
    setCourseId(id);
    setPrice(String(findCourse(id)?.priceThb ?? ""));
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setOkMessage(null);

    const res = await fetch("/api/admin/course-sales", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        customerName,
        phone,
        courseId,
        priceThb: price,
        sourceChannel,
        soldOn,
      }),
    });
    const json = await res.json().catch(() => ({}));
    setSaving(false);

    if (!res.ok) {
      setError(json.error ?? "บันทึกไม่สำเร็จ");
      return;
    }

    setOkMessage(
      json.item?.capi_sent
        ? `บันทึกแล้ว — ส่ง Purchase ให้ Meta เรียบร้อย`
        : `บันทึกแล้ว แต่ส่ง Purchase ให้ Meta ไม่สำเร็จ (ยอดขายไม่หาย ส่งซ้ำได้ภายหลัง)`
    );
    setCustomerName("");
    setPhone("");
    setSourceChannel("");
    setPrice(String(findCourse(courseId)?.priceThb ?? ""));
    await load();
  }

  if (loading) {
    return <div className="p-6 text-sm text-gray-500">กำลังโหลด…</div>;
  }
  if (!isAdmin) {
    return <div className="p-6 text-sm text-red-600">สำหรับผู้ดูแลระบบเท่านั้น</div>;
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-6">
      <h1 className="text-xl font-bold">บันทึกยอดขายคอร์ส</h1>
      <p className="mt-1 text-sm text-gray-500">
        กรอกทันทีหลังลูกค้าโอนเงิน ระบบจะส่ง Purchase ให้ Meta ให้อัตโนมัติ
      </p>

      <form onSubmit={submit} className="mt-6 space-y-4">
        <Field label="ชื่อลูกค้า">
          <input
            value={customerName}
            onChange={(e) => setCustomerName(e.target.value)}
            required
            className={inputClass}
            autoComplete="off"
          />
        </Field>

        <Field label="เบอร์โทร" hint="ใช้จับคู่กับโฆษณา — ส่งให้ Meta แบบเข้ารหัสเท่านั้น">
          <input
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            required
            type="tel"
            inputMode="tel"
            placeholder="081-234-5678"
            className={inputClass}
            autoComplete="off"
          />
        </Field>

        <Field label="คอร์สที่ซื้อ">
          <select
            value={courseId}
            onChange={(e) => onCourseChange(e.target.value as CourseId)}
            className={inputClass}
          >
            {COURSES.map((c) => (
              <option key={c.id} value={c.id}>
                {c.name} — {baht(c.priceThb)}
              </option>
            ))}
          </select>
        </Field>

        <Field label="ราคาที่จ่ายจริง" hint="แก้ได้ถ้ามีส่วนลด">
          <input
            value={price}
            onChange={(e) => setPrice(e.target.value)}
            type="number"
            inputMode="decimal"
            min="0"
            step="1"
            className={inputClass}
          />
        </Field>

        <Field label="ช่องทางที่มา" hint="ไม่บังคับ — ใช้ดูรายงานภายใน">
          <select
            value={sourceChannel}
            onChange={(e) => setSourceChannel(e.target.value)}
            className={inputClass}
          >
            <option value="">ไม่ระบุ</option>
            {SOURCE_CHANNELS.map((s) => (
              <option key={s.id} value={s.id}>
                {s.label}
              </option>
            ))}
          </select>
        </Field>

        <Field label="วันที่">
          <input
            value={soldOn}
            onChange={(e) => setSoldOn(e.target.value)}
            type="date"
            className={inputClass}
          />
        </Field>

        {error && (
          <p className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>
        )}
        {okMessage && (
          <p className="rounded-md bg-green-50 px-3 py-2 text-sm text-green-700">
            {okMessage}
          </p>
        )}

        <button
          type="submit"
          disabled={saving}
          className="w-full rounded-lg bg-blue-600 px-4 py-3 text-base font-semibold text-white disabled:opacity-50"
        >
          {saving ? "กำลังบันทึก…" : "บันทึกยอดขาย"}
        </button>
      </form>

      {totals && (
        <div className="mt-8 flex flex-wrap gap-4 border-t pt-4 text-sm">
          <span className="text-gray-600">
            ล่าสุด {totals.count} รายการ · {baht(totals.revenueThb)}
          </span>
          {totals.capiPending > 0 && (
            <span className="font-medium text-amber-700">
              ยังไม่ถึง Meta {totals.capiPending} รายการ
            </span>
          )}
        </div>
      )}

      <ul className="mt-4 divide-y">
        {items.map((r) => (
          <li key={r.id} className="flex items-center justify-between gap-3 py-2 text-sm">
            <div className="min-w-0">
              <p className="truncate font-medium">{r.customer_name}</p>
              <p className="truncate text-gray-500">
                {r.course_name} · {r.sold_on}
              </p>
            </div>
            <div className="shrink-0 text-right">
              <p className="font-medium">{baht(Number(r.price_thb))}</p>
              <p className={r.capi_sent_at ? "text-gray-400" : "text-amber-700"}>
                {r.capi_sent_at ? "ส่งแล้ว" : "ยังไม่ส่ง"}
              </p>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}

const inputClass =
  "w-full rounded-lg border border-gray-300 px-3 py-2.5 text-base focus:border-blue-500 focus:outline-none";

function Field({
  label,
  hint,
  children,
}: {
  label: string;
  hint?: string;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="text-sm font-medium text-gray-700">{label}</span>
      {hint && <span className="ml-2 text-xs text-gray-400">{hint}</span>}
      <div className="mt-1">{children}</div>
    </label>
  );
}
