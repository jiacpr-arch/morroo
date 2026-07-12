import type { CprProgress, CprUser } from "@/lib/cpr/storage";

// ชื่อ page ภายในคงเดิมจาก jia-online (ใช้เป็นค่าใน jia_last_page ต่อเนื่องกับของเดิม)
export type CprPage =
  | "landing"
  | "store"
  | "teaserquiz"
  | "signupgate"
  | "register"
  | "lineprompt"
  | "claim"
  | "payment"
  | "course"
  | "certificate"
  | "minicert"
  | "booking"
  | "blog"
  | "blog-detail";

export type Go = (page: CprPage) => void;
export type OpenBlog = (slug: string) => void;

export type { CprProgress, CprUser };
