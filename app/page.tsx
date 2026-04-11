import { getExams, getExamPartCounts, sortExamsAvailableFirst } from "@/lib/supabase/queries";
import { getBlogPosts } from "@/lib/blog";
import HomeContent from "@/components/HomeContent";

export const revalidate = 60;

export default async function HomePage() {
  const [allExams, partCounts, blogPosts] = await Promise.all([
    getExams(),
    getExamPartCounts(),
    getBlogPosts(),
  ]);
  const exams = sortExamsAvailableFirst(allExams, partCounts);
  const latestExams = exams.slice(0, 6);
  const dayIndex = Math.floor(Date.now() / (1000 * 60 * 60 * 24));
  const dailyExam = exams.length > 0 ? exams[dayIndex % exams.length] : null;

  return (
    <HomeContent
      latestExams={latestExams}
      partCounts={partCounts}
      dailyExam={dailyExam}
      blogPosts={blogPosts}
    />
  );
}
