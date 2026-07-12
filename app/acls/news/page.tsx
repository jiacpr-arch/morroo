import type { Metadata } from "next";
import { getNews } from "@/lib/courses/news";
import NewsList from "@/components/courses/NewsList";

export const metadata: Metadata = {
  title: "ข่าวสาร",
};

export const revalidate = 600;

// Server shell: fetches acls_news (filtered to course in ['acls','both']) and
// hands it to the client list (search/filter tabs + push opt-in).
export default async function AclsNewsPage() {
  const items = await getNews("acls");
  return <NewsList course="acls" items={items} />;
}
