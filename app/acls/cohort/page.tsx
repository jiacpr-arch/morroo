import InstructorCohort from "@/components/courses/InstructorCohort";

export const metadata = { title: "หน้าอาจารย์ — ACLS" };

// Thin per-course wrapper — all logic lives in the shared client component
// (components/courses/InstructorCohort.tsx), mirroring the AclsHub/BlsHub
// "shared component, thin per-course page" pattern.
export default function AclsCohortPage() {
  return <InstructorCohort course="acls" />;
}
