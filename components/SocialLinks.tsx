"use client";

import { track } from "@/lib/analytics";
import { cn } from "@/lib/utils";

export const SOCIAL_LINKS = {
  line: "https://line.me/R/ti/p/%40901nmwcd",
  facebook: "https://www.facebook.com/profile.php?id=61589444333781",
  instagram: "https://www.instagram.com/morroodee/",
} as const;

type Variant = "section" | "footer";

/** Official LINE glyph — sized by its wrapping element. */
export function LineGlyph({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M19.365 9.863c.349 0 .63.281.63.63 0 .346-.281.628-.63.628H17.61v1.125h1.755c.348 0 .63.282.63.63 0 .349-.281.63-.63.63h-2.386c-.345 0-.626-.282-.626-.63V8.108c0-.345.282-.63.63-.63h2.386c.346 0 .627.285.627.63 0 .349-.281.63-.63.63H17.61v1.125h1.755zm-3.855 3.016c0 .27-.174.51-.432.596-.064.021-.133.031-.199.031-.211 0-.391-.09-.51-.25l-2.443-3.317v2.94c0 .344-.279.629-.631.629-.346 0-.626-.285-.626-.629V8.108c0-.27.173-.508.43-.595.06-.024.135-.034.196-.034.195 0 .375.104.495.254l2.462 3.33V8.108c0-.345.282-.63.63-.63.345 0 .629.285.629.63v4.771zm-5.741 0c0 .344-.282.629-.631.629-.345 0-.627-.285-.627-.629V8.108c0-.345.282-.63.63-.63.346 0 .628.285.628.63v4.771zm-2.466.629H4.917c-.345 0-.63-.285-.63-.629V8.108c0-.345.285-.63.63-.63.348 0 .63.285.63.63v4.141h1.756c.348 0 .629.283.629.63 0 .344-.282.629-.629.629M24 10.314C24 4.943 18.615.572 12 .572S0 4.943 0 10.314c0 4.811 4.27 8.842 10.035 9.608.391.082.923.258 1.058.59.12.301.079.766.038 1.08l-.164 1.02c-.045.301-.24 1.186 1.049.645 1.291-.539 6.916-4.078 9.436-6.975C23.176 14.393 24 12.458 24 10.314" />
    </svg>
  );
}

/**
 * Standalone LINE add-friend CTA with click tracking. `surface` distinguishes
 * where the click happened (home_hero, pricing, exams, floating, …) so the
 * marketing digest can attribute LINE conversions per placement.
 */
export function LineCtaButton({
  surface,
  label = "แอด LINE รับข้อสอบฟรีทุกเช้า 7 โมง",
  className,
}: {
  surface: string;
  label?: string;
  className?: string;
}) {
  return (
    <a
      href={SOCIAL_LINKS.line}
      target="_blank"
      rel="noopener noreferrer"
      aria-label="เพิ่มเพื่อนใน LINE OA หมอรู้"
      onClick={() => track("social_click", { platform: "line", surface })}
      className={cn(
        "inline-flex items-center justify-center gap-2 rounded-full bg-[#06C755] px-6 py-3 text-sm font-semibold text-white shadow-sm transition-all hover:bg-[#05b34c]",
        className,
      )}
    >
      <span className="h-5 w-5 shrink-0">
        <LineGlyph className="h-full w-full" />
      </span>
      {label}
    </a>
  );
}

const SOCIALS = [
  {
    key: "line" as const,
    label: "แอด LINE รับข้อสอบฟรี",
    aria: "เพิ่มเพื่อนใน LINE",
    href: SOCIAL_LINKS.line,
    bg: "bg-[#06C755] hover:bg-[#05b34c]",
    icon: <LineGlyph />,
  },
  {
    key: "facebook" as const,
    label: "Facebook",
    aria: "ติดตามเฟซบุ๊กหมอรู้",
    href: SOCIAL_LINKS.facebook,
    bg: "bg-[#1877F2] hover:bg-[#1666d4]",
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
        <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.412c0-3.026 1.792-4.697 4.533-4.697 1.312 0 2.686.235 2.686.235v2.971h-1.514c-1.491 0-1.956.93-1.956 1.886v2.265h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z" />
      </svg>
    ),
  },
  {
    key: "instagram" as const,
    label: "Instagram",
    aria: "ติดตามอินสตาแกรมหมอรู้",
    href: SOCIAL_LINKS.instagram,
    bg: "bg-gradient-to-tr from-[#feda75] via-[#d62976] to-[#4f5bd5] hover:opacity-90",
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 1.366.062 2.633.336 3.608 1.311.975.975 1.249 2.242 1.311 3.608.058 1.266.069 1.646.069 4.85s-.012 3.584-.07 4.85c-.062 1.366-.336 2.633-1.311 3.608-.975.975-2.242 1.249-3.608 1.311-1.266.058-1.646.069-4.85.069s-3.584-.012-4.85-.07c-1.366-.062-2.633-.336-3.608-1.311-.975-.975-1.249-2.242-1.311-3.608C2.175 15.647 2.163 15.267 2.163 12s.012-3.584.07-4.85c.062-1.366.336-2.633 1.311-3.608.975-.975 2.242-1.249 3.608-1.311C8.416 2.175 8.796 2.163 12 2.163zm0-2.163C8.741 0 8.332.014 7.052.072 5.776.13 4.602.397 3.635 1.364 2.668 2.331 2.401 3.505 2.343 4.781.014 8.332 0 8.741 0 12s.014 3.668.072 4.948c.058 1.276.325 2.45 1.292 3.417.967.967 2.141 1.234 3.417 1.292C8.332 23.986 8.741 24 12 24s3.668-.014 4.948-.072c1.276-.058 2.45-.325 3.417-1.292.967-.967 1.234-2.141 1.292-3.417.058-1.28.072-1.689.072-4.948s-.014-3.668-.072-4.948c-.058-1.276-.325-2.45-1.292-3.417C19.398.397 18.224.13 16.948.072 15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
      </svg>
    ),
  },
];

export function SocialButtonsRow({ className }: { className?: string }) {
  return (
    <div
      className={cn(
        "flex flex-wrap items-center justify-center gap-3",
        className,
      )}
    >
      {SOCIALS.map((s) => (
        <a
          key={s.key}
          href={s.href}
          target="_blank"
          rel="noopener noreferrer"
          aria-label={s.aria}
          onClick={() => track("social_click", { platform: s.key, surface: "buttons" })}
          className={cn(
            "inline-flex items-center gap-2 rounded-full px-5 py-2.5 text-sm font-medium text-white shadow-sm transition-all",
            s.bg,
          )}
        >
          <span className="h-5 w-5">{s.icon}</span>
          {s.label}
        </a>
      ))}
    </div>
  );
}

export function SocialIconsRow({ className }: { className?: string }) {
  return (
    <div className={cn("flex items-center gap-3", className)}>
      {SOCIALS.map((s) => (
        <a
          key={s.key}
          href={s.href}
          target="_blank"
          rel="noopener noreferrer"
          aria-label={s.aria}
          title={s.label}
          onClick={() => track("social_click", { platform: s.key, surface: "icons" })}
          className={cn(
            "inline-flex h-9 w-9 items-center justify-center rounded-full text-white transition-all",
            s.bg,
          )}
        >
          <span className="h-4 w-4">{s.icon}</span>
        </a>
      ))}
    </div>
  );
}

export default function SocialLinks({
  variant = "section",
  className,
}: {
  variant?: Variant;
  className?: string;
}) {
  return variant === "footer" ? (
    <SocialIconsRow className={className} />
  ) : (
    <SocialButtonsRow className={className} />
  );
}
