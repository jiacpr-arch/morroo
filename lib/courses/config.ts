// Central course config for the ACLS / BLS teaching system migrated from
// acls-emr. The old app switched modes at build time (VITE_COURSE_MODE);
// here the mode comes from the route segment (/acls/** vs /bls/**).

export type CourseMode = "acls" | "bls";

export interface CourseFeaturedVideo {
  platform: "youtube";
  videoId: string;
  title: string;
  description: string;
}

export interface CourseMeta {
  mode: CourseMode;
  id: string;
  title: string;
  titleTh: string;
  shortName: string;
  standard: string;
  themeColor: string;
  passingScore: { lesson: number; postTest: number };
  certTemplate: string;
  certValidityMonths: number;
  featuredVideo: CourseFeaturedVideo | null;
  /** Base path of the course inside morroo, e.g. "/acls". */
  basePath: string;
}

export const COURSES: Record<CourseMode, CourseMeta> = {
  acls: {
    mode: "acls",
    id: "als",
    title: "ACLS Provider",
    titleTh: "หลักสูตร ACLS",
    shortName: "ACLS",
    standard: "ILCOR-ACLS-2025",
    themeColor: "#DC2626",
    passingScore: { lesson: 70, postTest: 85 },
    certTemplate: "acls-ilcor-2025",
    certValidityMonths: 24,
    featuredVideo: null,
    basePath: "/acls",
  },
  bls: {
    mode: "bls",
    id: "bls-hcp",
    title: "BLS for Healthcare Providers",
    titleTh: "BLS สำหรับบุคลากรทางการแพทย์",
    shortName: "BLS",
    standard: "ILCOR-BLS-2025",
    themeColor: "#0EA5E9",
    passingScore: { lesson: 75, postTest: 84 },
    certTemplate: "bls-hcp-ilcor-2025",
    certValidityMonths: 24,
    featuredVideo: {
      platform: "youtube",
      videoId: "g3_0kTW6Me8",
      title: "BLS for Healthcare Providers — วิดีโอเต็มหลักสูตร",
      description: "ดูวิดีโอนี้ก่อนเริ่มอ่านบทเรียน",
    },
    basePath: "/bls",
  },
};

export function getCourseMeta(mode: CourseMode): CourseMeta {
  return COURSES[mode];
}
