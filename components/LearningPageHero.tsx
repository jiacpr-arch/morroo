import Image from "next/image";
import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

const SCENES = {
  practice: {
    src: "/images/learning/focused-practice.webp",
    alt: "ภาพประกอบนักศึกษาแพทย์ทบทวนข้อสอบและจดบันทึกในห้องสมุด",
  },
  clinical: {
    src: "/images/learning/clinical-learning.webp",
    alt: "ภาพประกอบแพทย์รุ่นพี่และแพทย์ฝึกหัดทบทวนเคสร่วมกัน",
  },
  together: {
    src: "/images/home/medical-study-together.webp",
    alt: "ภาพประกอบนักศึกษาแพทย์เรียนรู้และทบทวนบทเรียนด้วยกัน",
  },
  desk: {
    src: "/images/home/calm-study-desk.webp",
    alt: "มุมอ่านหนังสือแสงธรรมชาติ พร้อมสมุด หนังสือ และหูฟังแพทย์",
  },
  game: {
    src: "/images/games/courses/long-case-meq.jpg",
    alt: "ภาพประกอบเกมฝึกคิดเป็นแพทย์ ตั้งแต่ซักประวัติจนถึงวางแผนรักษา",
  },
} as const;

type Props = {
  title: ReactNode;
  description: ReactNode;
  eyebrow: string;
  scene: keyof typeof SCENES;
  tone?: "light" | "dark";
  children?: ReactNode;
  className?: string;
};

/** Shared visual introduction for browsing pages; practice screens stay focused. */
export default function LearningPageHero({
  title,
  description,
  eyebrow,
  scene,
  tone = "light",
  children,
  className,
}: Props) {
  const dark = tone === "dark";
  const image = SCENES[scene];

  return (
    <section
      data-learning-hero
      className={cn(
        "mb-8 grid overflow-hidden rounded-3xl border lg:grid-cols-[1.15fr_0.85fr]",
        dark ? "border-white/10 bg-brand-dark text-white" : "border-[#dfe7da] bg-[#f3f5ef] text-brand-dark",
        className,
      )}
    >
      <div className="min-w-0 self-center p-6 sm:p-8 lg:py-10">
        <p className={cn("flex items-center gap-2 text-sm font-semibold", dark ? "text-emerald-200" : "text-[#35694f]")}>
          <span className={cn("h-1.5 w-1.5 shrink-0 rounded-full", dark ? "bg-emerald-300" : "bg-brand")} aria-hidden="true" />
          {eyebrow}
        </p>
        <h1 className="mt-3 text-[1.75rem] font-bold leading-[1.45] text-balance sm:text-3xl xl:text-4xl">
          {title}
        </h1>
        <div className={cn("mt-3 max-w-2xl text-sm leading-7 sm:text-base", dark ? "text-white/80" : "text-[#536557]")}>
          {description}
        </div>
        {children && <div className="mt-5 space-y-3">{children}</div>}
      </div>
      <div className="relative mx-3 mb-3 aspect-[16/9] min-w-0 overflow-hidden rounded-2xl bg-[#e2e7dc] sm:mx-4 sm:mb-4 lg:my-3 lg:ml-0 lg:mr-3 lg:aspect-auto lg:min-h-64">
        <Image
          src={image.src}
          alt={image.alt}
          fill
          sizes="(max-width: 1023px) calc(100vw - 64px), (max-width: 1279px) 38vw, 490px"
          loading="eager"
          className={cn("object-cover", scene === "practice" || scene === "clinical" ? "object-[center_25%]" : "object-center")}
        />
        <span className="absolute bottom-3 right-3 rounded-full bg-black/50 px-2.5 py-1 text-[10px] text-white">ภาพประกอบ</span>
      </div>
    </section>
  );
}
