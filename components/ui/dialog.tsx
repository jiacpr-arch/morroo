"use client";

import { useEffect } from "react";
import { X } from "lucide-react";
import { cn } from "@/lib/utils";

interface DialogProps {
  open: boolean;
  onClose?: () => void;
  closeOnOverlay?: boolean;
  dismissible?: boolean;
  children: React.ReactNode;
  className?: string;
}

export function Dialog({
  open,
  onClose,
  closeOnOverlay = true,
  dismissible = true,
  children,
  className,
}: DialogProps) {
  useEffect(() => {
    if (!open) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" && dismissible) onClose?.();
    };
    window.addEventListener("keydown", onKey);
    return () => {
      document.body.style.overflow = prev;
      window.removeEventListener("keydown", onKey);
    };
  }, [open, dismissible, onClose]);

  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center p-4 animate-in fade-in"
      role="dialog"
      aria-modal="true"
    >
      <div
        className="absolute inset-0 bg-black/50 backdrop-blur-sm"
        onClick={() => {
          if (closeOnOverlay && dismissible) onClose?.();
        }}
      />
      <div
        className={cn(
          "relative z-10 w-full max-w-lg rounded-2xl bg-white shadow-2xl",
          "max-h-[90vh] overflow-y-auto",
          className
        )}
      >
        {dismissible && (
          <button
            type="button"
            onClick={() => onClose?.()}
            className="absolute top-4 right-4 rounded-full p-1.5 text-muted-foreground hover:bg-muted hover:text-foreground transition"
            aria-label="ปิด"
          >
            <X className="h-5 w-5" />
          </button>
        )}
        {children}
      </div>
    </div>
  );
}

export function DialogHeader({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("px-6 pt-6 pb-2", className)}>{children}</div>
  );
}

export function DialogTitle({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <h2 className={cn("text-xl font-bold leading-snug", className)}>
      {children}
    </h2>
  );
}

export function DialogBody({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return <div className={cn("px-6 py-3 space-y-3", className)}>{children}</div>;
}

export function DialogFooter({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("px-6 pb-6 pt-3 flex flex-col-reverse sm:flex-row sm:justify-end gap-2", className)}>
      {children}
    </div>
  );
}
