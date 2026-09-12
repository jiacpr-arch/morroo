import Link from "next/link";
import { PLAN_CATALOG, PLAN_TYPES, PRODUCT_INFO, PRODUCTS } from "@/lib/membership";

const PERIOD: Record<string, string> = {
  month: "/ เดือน",
  year: "/ ปี",
  lifetime: "ซื้อขาด",
};

/**
 * Collapsed "every plan at a glance" table for the bottom of /pricing.
 * Server component — pure data from PLAN_CATALOG, no client JS.
 */
export default function PricingCompareTable() {
  return (
    <details className="group rounded-2xl border bg-card">
      <summary className="cursor-pointer select-none px-6 py-4 font-semibold flex items-center justify-between">
        <span>ตารางเปรียบเทียบทุกแพ็ก</span>
        <span className="text-xs text-muted-foreground group-open:hidden">แสดง</span>
        <span className="text-xs text-muted-foreground hidden group-open:inline">ซ่อน</span>
      </summary>
      <div className="overflow-x-auto px-2 pb-4">
        <table className="w-full text-sm">
          <thead>
            <tr className="text-left text-xs text-muted-foreground">
              <th className="px-4 py-2 font-medium">แพ็ก</th>
              <th className="px-4 py-2 font-medium">ราคา</th>
              {PRODUCTS.map((p) => (
                <th key={p} className="px-2 py-2 font-medium text-center">
                  {PRODUCT_INFO[p].short}
                </th>
              ))}
              <th className="px-4 py-2" />
            </tr>
          </thead>
          <tbody>
            {PLAN_TYPES.map((plan) => {
              const spec = PLAN_CATALOG[plan];
              return (
                <tr key={plan} className="border-t">
                  <td className="px-4 py-2 font-medium whitespace-nowrap">{spec.label}</td>
                  <td className="px-4 py-2 whitespace-nowrap">
                    ฿{spec.amount.toLocaleString()}{" "}
                    <span className="text-xs text-muted-foreground">{PERIOD[spec.duration]}</span>
                  </td>
                  {PRODUCTS.map((p) => (
                    <td key={p} className="px-2 py-2 text-center">
                      {spec.products.includes(p) ? (
                        <span className="text-brand font-bold" aria-label="รวม">✓</span>
                      ) : (
                        <span className="text-muted-foreground/40">–</span>
                      )}
                    </td>
                  ))}
                  <td className="px-4 py-2 text-right">
                    <Link
                      href={`/payment/${plan}`}
                      className="text-xs text-brand hover:underline whitespace-nowrap"
                    >
                      สมัคร
                    </Link>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
        <p className="px-4 pt-3 text-xs text-muted-foreground">
          ชุดข้อสอบ = เครดิต 10 ข้อ ไม่มีวันหมดอายุ · ทุกแพ็กถือพร้อมกันได้ หมดอายุแยกกัน
        </p>
      </div>
    </details>
  );
}
