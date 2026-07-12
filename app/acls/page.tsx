import { getChapters } from "@/lib/acls-reader/content";
import { getAssessmentSets } from "@/lib/acls-reader/assessment";
import SectionUpdatesBadge from "@/components/SectionUpdatesBadge";
import AclsHub from "@/components/courses/AclsHub";

export const revalidate = 600;

// Server shell: fetches the chapter list + assessment sets and hands them to
// the client-side hub (which owns all the class/identity/Dexie logic).
export default async function AclsReaderHome() {
  const [chapters, sets] = await Promise.all([getChapters(), getAssessmentSets()]);

  return (
    <AclsHub
      chapters={chapters.map((c) => ({
        id: c.id,
        title: c.title,
        icon: c.icon ?? null,
        sectionCount: c.sections.length,
      }))}
      testSets={sets.map((s) => ({ id: s.id, title: s.title }))}
      updatesBadge={<SectionUpdatesBadge section="acls" />}
    />
  );
}
