import { Suspense } from "react";
import SuccessContent from "./SuccessContent";

export default function PaymentSuccessPage() {
  return (
    <Suspense fallback={<div className="text-center py-16">กำลังโหลด...</div>}>
      <SuccessContent />
    </Suspense>
  );
}
