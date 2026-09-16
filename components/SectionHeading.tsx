import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

type Props = {
  eyebrow?: ReactNode;
  title: ReactNode;
  description?: ReactNode;
  /** ปุ่ม/ลิงก์ประกอบหัวข้อ — รับเป็น node เพราะแต่ละที่ใช้ label/href/ไอคอนต่างกัน */
  action?: ReactNode;
  align?: "left" | "center";
  /** dark = วางบนแถบ bg-brand-dark ซึ่ง text-brand-dark จะมองไม่เห็น */
  tone?: "light" | "dark";
  as?: "h2" | "h3";
  id?: string;
  className?: string;
};

export default function SectionHeading({
  eyebrow,
  title,
  description,
  action,
  align = "left",
  tone = "light",
  as: Tag = "h2",
  id,
  className,
}: Props) {
  const dark = tone === "dark";

  const eyebrowEl = eyebrow ? (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full px-3.5 py-1 text-xs font-semibold sm:text-sm",
        dark
          ? "border border-white/15 bg-white/10 text-white/90"
          : "bg-brand/10 text-brand"
      )}
    >
      {eyebrow}
    </span>
  ) : null;

  const descriptionEl = description ? (
    <p
      className={cn(
        "text-base leading-relaxed sm:text-lg",
        align === "center" ? "mx-auto mt-4 max-w-2xl" : "mt-2 max-w-2xl",
        dark ? "text-white/70" : "text-muted-foreground"
      )}
    >
      {description}
    </p>
  ) : null;

  if (align === "center") {
    return (
      <div className={cn("mb-10 text-center sm:mb-12", className)}>
        {eyebrowEl}
        <Tag
          id={id}
          className={cn(
            "text-2xl font-bold sm:text-3xl lg:text-4xl",
            eyebrow && "mt-4",
            dark ? "text-white" : "text-brand-dark"
          )}
        >
          {title}
        </Tag>
        {/* แถบ accent ของ style guide เป็นแนวตั้งซ้ายมือ ซึ่งใช้กับข้อความ
            กึ่งกลางไม่ได้ — หมุนอุปกรณ์เดียวกัน 90° ให้เป็นเส้นสั้นใต้หัวเรื่อง */}
        <span
          className={cn(
            "mx-auto mt-4 block h-1 w-12 rounded-full bg-gradient-to-r",
            dark ? "from-brand-light to-emerald-300" : "from-brand to-brand-light"
          )}
        />
        {descriptionEl}
        {action && <div className="mt-6 flex justify-center">{action}</div>}
      </div>
    );
  }

  return (
    <div
      className={cn(
        "mb-8 flex flex-col items-start gap-4 sm:mb-10 sm:flex-row sm:items-end sm:justify-between",
        className,
      )}
    >
      <div className="min-w-0">
        {eyebrowEl}
        <Tag
          id={id}
          className={cn(
            "flex items-center gap-3 text-2xl font-bold sm:text-3xl",
            eyebrow && "mt-3",
            dark ? "text-white" : "text-brand-dark"
          )}
        >
          <span
            className={cn(
              "h-7 w-1.5 shrink-0 rounded-full sm:h-8",
              dark ? "bg-brand-light" : "bg-brand"
            )}
          />
          {title}
        </Tag>
        {descriptionEl}
      </div>
      {action && <div className="shrink-0">{action}</div>}
    </div>
  );
}
