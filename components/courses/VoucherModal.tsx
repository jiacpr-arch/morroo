"use client";

import { useState } from "react";
import { Ticket, AlertCircle } from "lucide-react";
import { validateVoucher } from "@/lib/courses/vouchers";
import { useVoucherStore } from "@/lib/courses/stores/voucher-store";
import { track } from "@/lib/analytics";
import {
  modalOverlay,
  modalPanel,
  textHeadline,
  text2xs,
  btnPrimary,
  btnMd,
  btnBlock,
  inputBase,
  errorBox,
} from "./course-ui";

interface VoucherModalProps {
  open: boolean;
  onClose?: () => void;
  initialCode?: string;
}

// Modal for entering a voucher code that unlocks the Pre-test / Post-test.
// initialCode prefills the input — used when a ?voucher=CODE link carried an
// invalid code and we want to show the user what they typed.
export default function VoucherModal({ open, onClose, initialCode = "" }: VoucherModalProps) {
  const redeemVoucher = useVoucherStore((s) => s.redeemVoucher);
  const [code, setCode] = useState(initialCode);
  const [error, setError] = useState("");

  // Re-sync the input to initialCode each time the modal (re)opens.
  const [prevOpen, setPrevOpen] = useState(open);
  if (open !== prevOpen) {
    setPrevOpen(open);
    if (open) {
      setCode(initialCode);
      setError("");
    }
  }

  if (!open) return null;

  const submit = (e?: React.FormEvent) => {
    e?.preventDefault();
    const v = validateVoucher(code);
    if (!v) {
      setError("รหัสไม่ถูกต้องหรือหมดอายุ");
      return;
    }
    redeemVoucher(v);
    track("voucher_redeemed", { code: v.code, via: "manual" });
    onClose?.();
  };

  return (
    <div className={modalOverlay}>
      <div className={modalPanel}>
        <div className="flex items-center gap-2">
          <div className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
            <Ticket size={18} strokeWidth={2.2} />
          </div>
          <div>
            <div className={textHeadline}>ใช้รหัส voucher</div>
            <div className={`${text2xs} text-muted-foreground`}>
              ปลดล็อกให้เข้าทำ Pre-test / Post-test ได้เลย
            </div>
          </div>
        </div>

        <form onSubmit={submit} className="space-y-3">
          <label className="block">
            <span className="text-xs font-semibold text-foreground/80">รหัส voucher</span>
            <input
              type="text"
              autoFocus
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              placeholder="เช่น ACLS2025"
              className={`${inputBase} mt-1 text-center font-mono text-xl tracking-[0.2em]`}
            />
          </label>
          {error && (
            <div className={errorBox}>
              <AlertCircle size={14} strokeWidth={2.2} /> {error}
            </div>
          )}
          <button type="submit" className={`${btnPrimary} ${btnMd} ${btnBlock}`}>
            ใช้รหัส
          </button>
          <button
            type="button"
            onClick={onClose}
            className="block w-full bg-transparent text-center text-xs text-muted-foreground underline"
          >
            ปิด
          </button>
        </form>
      </div>
    </div>
  );
}
