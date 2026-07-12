import type { CourseMode } from "@/lib/courses/config";

export interface CertConfig {
  id: string;
  title: string;
  subtitle: string;
  issuingBody: string;
  centerName: string;
  centerUrl: string;
  /** jsPDF RGB triplet. */
  brandColor: [number, number, number];
  validityMonths: number;
  certIdPrefix: string;
  logoUrl?: string;
  /** Online theory-only certification (ACLS): hands-on skills done separately. */
  theoryOnly?: boolean;
  theoryStatement?: string;
  practicalRecommendation?: string;
}

const CERT_CONFIGS: Record<CourseMode, CertConfig> = {
  acls: {
    id: "acls-ilcor-2025",
    title: "ACLS Certification (Online · Theory)",
    subtitle: "Advanced Cardiovascular Life Support",
    issuingBody: "ACLS per ILCOR 2025",
    centerName: "JIA Trainer Center",
    centerUrl: "jia1669.com",
    brandColor: [220, 38, 38], // #DC2626
    validityMonths: 24,
    certIdPrefix: "JIA-ACLS",
    logoUrl: "/images/acls-badge.png",
    theoryOnly: true,
    theoryStatement: "ผ่านการอบรมภาคทฤษฎี ACLS (ออนไลน์)",
    practicalRecommendation:
      "แนะนำให้เข้ารับการฝึกภาคปฏิบัติที่ศูนย์ฝึกใกล้บ้าน เพื่อรับใบประกาศนียบัตรฉบับสมบูรณ์",
  },
  bls: {
    id: "bls-hcp-ilcor-2025",
    title: "BLS Provider Certification",
    subtitle: "Basic Life Support for Healthcare Providers",
    issuingBody: "BLS per ILCOR 2025",
    centerName: "JIA Trainer Center",
    centerUrl: "jia1669.com",
    brandColor: [14, 165, 233], // #0EA5E9
    validityMonths: 24,
    certIdPrefix: "JIA-BLS",
  },
};

export function getCertConfig(mode: CourseMode): CertConfig {
  return CERT_CONFIGS[mode];
}
