"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Lock } from "lucide-react";

interface ProtectedContentProps {
  children: React.ReactNode;
  hasAccess: boolean;
}

export default function ProtectedContent({
  children,
  hasAccess,
}: ProtectedContentProps) {
  if (hasAccess) {
    return <>{children}</>;
  }

  return (
    <div className="relative">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-white/80 to-white z-10 flex flex-col items-center justify-end pb-8">
        <div className="text-center space-y-4 bg-white/95 rounded-xl p-8 shadow-lg border max-w-md mx-4">
          <div className="mx-auto w-12 h-12 rounded-full bg-brand/10 flex items-center justify-center">
            <Lock className="h-6 w-6 text-brand" />
          </div>
          <h3 className="text-lg font-bold">เนื้อหาสำหรับสมาชิก Premium</h3>
          <p className="text-sm text-muted-foreground">
            สมัครสมาชิกเพื่อดูเฉลยละเอียดและ Key Points ทุกข้อ
          </p>
          <Link href="/pricing">
            <Button className="bg-brand hover:bg-brand-light text-white">
              ดูแพ็กเกจสมาชิก
            </Button>
          </Link>
        </div>
      </div>
      <div className="blur-sm pointer-events-none select-none" aria-hidden>
        {children}
      </div>
    </div>
  );
}
