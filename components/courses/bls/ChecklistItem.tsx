import { Check as CheckIcon } from "lucide-react";
import { cn } from "@/lib/utils";

export type ChecklistItemTone = "success" | "danger" | "warning" | "info";

// Tones for the checked (on) fill. Spelled out in full (not built with
// template strings) so Tailwind's static class scanner can detect them.
const TONES: Record<ChecklistItemTone, string> = {
  success: "bg-emerald-600 border-emerald-700",
  danger: "bg-red-600 border-red-700",
  warning: "bg-amber-500 border-amber-600",
  info: "bg-sky-500 border-sky-600",
};

const BADGE_TEXT: Record<ChecklistItemTone, string> = {
  success: "text-emerald-600",
  danger: "text-red-600",
  warning: "text-amber-600",
  info: "text-sky-600",
};

export interface ChecklistItemProps {
  checked: boolean;
  onClick: () => void;
  label: string;
  sub?: string;
  tone?: ChecklistItemTone;
}

// Shared "tick" control: the whole row is a clearly tappable button that
// changes color when selected. Unchecked is a raised tile; checked fills
// with the tone's solid color.
export default function ChecklistItem({
  checked,
  onClick,
  label,
  sub,
  tone = "success",
}: ChecklistItemProps) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "mb-2 flex w-full items-center gap-3 rounded-xl border-2 px-4 py-3.5 text-left shadow-sm transition-all active:scale-[0.97]",
        checked
          ? cn(TONES[tone], "text-white")
          : "border-border bg-muted text-foreground",
      )}
    >
      <span
        className={cn(
          "flex h-7 w-7 shrink-0 items-center justify-center rounded-lg border-2",
          checked
            ? cn("border-white bg-white", BADGE_TEXT[tone])
            : "border-muted-foreground bg-background text-transparent",
        )}
      >
        <CheckIcon size={18} strokeWidth={3} />
      </span>
      <div className="min-w-0 flex-1 text-left">
        <div className="text-sm font-bold leading-tight">{label}</div>
        {sub && (
          <div
            className={cn(
              "mt-0.5 text-[11px] leading-snug",
              checked ? "text-white/85" : "text-muted-foreground",
            )}
          >
            {sub}
          </div>
        )}
      </div>
    </button>
  );
}
