import Image from "next/image";

type Props = {
  scene: "desk" | "together";
  title: string;
  description: string;
};

export default function AuthIllustration({ scene, title, description }: Props) {
  const image = scene === "desk"
    ? { src: "/images/home/calm-study-desk.webp", alt: "มุมอ่านหนังสือสว่างสบายตาพร้อมอุปกรณ์การเรียนแพทย์" }
    : { src: "/images/home/medical-study-together.webp", alt: "ภาพประกอบนักศึกษาแพทย์ช่วยกันทบทวนบทเรียน" };

  return (
    <div className="overflow-hidden rounded-3xl border border-surface-border bg-surface-warm">
      <div className="relative aspect-[16/9]">
        <Image src={image.src} alt={image.alt} fill sizes="(max-width: 1023px) 100vw, 500px" className="object-cover" />
        <span className="absolute bottom-3 right-3 rounded-full bg-black/50 px-2.5 py-1 text-[10px] text-white">ภาพประกอบ</span>
      </div>
      <div className="p-6">
        <p className="text-xs font-semibold text-brand">หมอรู้ MorRoo</p>
        <h2 className="mt-2 text-xl font-bold leading-snug text-brand-dark">{title}</h2>
        <p className="mt-2 text-sm leading-7 text-ink-soft">{description}</p>
      </div>
    </div>
  );
}
