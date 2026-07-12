import BlsHub from "@/components/courses/BlsHub";

// Server shell: BLS pre-course/post-test/tools content is fully static
// (lib/courses/bls/*), so there's no chapter/assessment-set fetch here
// (unlike ACLS's app/acls/page.tsx) — the client hub owns all the
// class/identity/Dexie logic.
export default function BlsReaderHome() {
  return <BlsHub />;
}
