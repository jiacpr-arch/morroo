"use client";

import { Ticket, Check, X, MessageCircle } from "lucide-react";
import { useVoucherStore } from "@/lib/courses/stores/voucher-store";
import { validateVoucher } from "@/lib/courses/vouchers";
import { track } from "@/lib/analytics";
import {
  dashCard,
  modalOverlay,
  modalPanel,
  textHeadline,
  text2xs,
  btnGhost,
  btnSm,
  COURSE_LINE_URL,
} from "./course-ui";

// Entry point + status for the voucher feature. Shared by both the ACLS and
// BLS pre-course pages. Three states:
//   - no voucher            → a button that opens the VoucherModal
//   - voucher, LINE pending → a blocking full-screen gate: must add the LINE
//                              OA friend (or cancel the code) before anything
//                              unlocks — no plain dismiss, by design
//   - voucher, LINE done    → the green "unlocked" banner
export default function VoucherCard({ onOpen }: { onOpen?: () => void }) {
  const voucher = useVoucherStore((s) => s.voucher);
  const clearVoucher = useVoucherStore((s) => s.clearVoucher);
  const confirmLine = useVoucherStore((s) => s.confirmLine);
  const codeValid = !!(voucher && validateVoucher(voucher.code));
  const pending = codeValid && !voucher!.lineConfirmed;
  const active = codeValid && !!voucher!.lineConfirmed;

  if (pending && voucher) {
    return (
      <div className={modalOverlay}>
        <div className={`${modalPanel} text-center`}>
          <div className="mx-auto inline-flex h-14 w-14 items-center justify-center rounded-full bg-emerald-500/15">
            <MessageCircle size={26} strokeWidth={2.4} style={{ color: "#06C755" }} />
          </div>
          <div>
            <div className={textHeadline}>เกือบเสร็จแล้ว — เพิ่มเพื่อน LINE ก่อน</div>
            <div className="mt-1 text-xs text-muted-foreground">
              รหัส{" "}
              <span className="font-bold text-foreground">
                {voucher.label || voucher.code}
              </span>{" "}
              จะปลดล็อก Pre-test / Post-test ทันทีที่เพิ่มเพื่อน LINE
            </div>
          </div>
          <a
            href={COURSE_LINE_URL}
            target="_blank"
            rel="noopener noreferrer"
            onClick={() => {
              confirmLine();
              track("voucher_line_confirmed", {
                code: voucher.code,
                value: 2500,
                currency: "THB",
              });
            }}
            className="inline-flex w-full items-center justify-center gap-1.5 rounded-lg px-4 py-3 text-sm font-semibold text-white no-underline hover:opacity-90"
            style={{ background: "#06C755" }}
          >
            <MessageCircle size={18} strokeWidth={2.4} /> เพิ่มเพื่อน LINE เพื่อปลดล็อก
          </a>
          <button
            onClick={clearVoucher}
            className="block w-full bg-transparent text-center text-xs text-muted-foreground underline"
          >
            ยกเลิกรหัสนี้
          </button>
        </div>
      </div>
    );
  }

  if (active && voucher) {
    return (
      <div className={`${dashCard} flex items-center gap-3 border-emerald-500/30 bg-emerald-500/10`}>
        <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-emerald-500/15 text-emerald-600 dark:text-emerald-400">
          <Check size={18} strokeWidth={2.4} />
        </div>
        <div className="min-w-0 flex-1">
          <div className="truncate text-sm font-semibold text-foreground">
            ปลดล็อกด้วย voucher แล้ว
          </div>
          <div className={`${text2xs} truncate text-muted-foreground`}>
            {voucher.label || voucher.code} · เข้าทำ Post-test ได้เลย
          </div>
        </div>
        <button onClick={clearVoucher} className={`${btnGhost} ${btnSm}`}>
          <X size={13} strokeWidth={2.4} /> นำออก
        </button>
      </div>
    );
  }

  return (
    <button
      onClick={onOpen}
      className={`${dashCard} flex w-full items-center gap-3 text-left transition-colors hover:bg-muted/50`}
    >
      <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
        <Ticket size={18} strokeWidth={2.2} />
      </div>
      <div className="min-w-0 flex-1">
        <div className="text-sm font-semibold text-foreground">มีรหัส voucher?</div>
        <div className={`${text2xs} text-muted-foreground`}>
          กรอกรหัสเพื่อปลดล็อก Pre-test / Post-test
        </div>
      </div>
    </button>
  );
}
