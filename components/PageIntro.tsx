import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = {
  eyebrow: string;
  title: string;
  description: string;
  children?: ReactNode;
  className?: string;
};

/** A compact page introduction for learning and account screens. */
export default function PageIntro({ eyebrow, title, description, children, className }: Props) {
  return (
    <section className={cn("rounded-3xl border border-surface-border bg-surface-warm p-6 sm:p-8", className)}>
      <p className="flex items-center gap-2 text-sm font-semibold text-brand-dark">
        <span aria-hidden="true" className="h-1.5 w-1.5 rounded-full bg-brand" />
        {eyebrow}
      </p>
      <h1 className="mt-2 text-2xl font-bold leading-snug text-brand-dark sm:text-3xl">{title}</h1>
      <p className="mt-2 max-w-2xl text-sm leading-7 text-ink-soft sm:text-base">{description}</p>
      {children && <div className="mt-4 flex flex-wrap items-center gap-2">{children}</div>}
    </section>
  );
}
