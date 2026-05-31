import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import remarkBreaks from "remark-breaks";

import { cn } from "@/lib/utils";

// Prose classes tuned for the ACLS Q&A reading experience: clear headings,
// comfortable type sizes, and brand-colored accents.
const PROSE =
  "prose prose-lg max-w-none text-[1.0625rem] leading-relaxed sm:text-lg " +
  "prose-headings:scroll-mt-20 prose-headings:font-bold prose-headings:tracking-tight prose-headings:text-brand-dark " +
  "prose-h2:mt-12 prose-h2:mb-4 prose-h2:text-2xl prose-h2:border-l-4 prose-h2:border-brand prose-h2:pl-3 sm:prose-h2:text-3xl " +
  "prose-h3:mt-8 prose-h3:mb-3 prose-h3:text-xl prose-h3:text-brand sm:prose-h3:text-2xl " +
  "prose-h4:mt-6 prose-h4:mb-2 prose-h4:text-lg prose-h4:font-semibold prose-h4:text-foreground " +
  "prose-p:my-4 prose-p:leading-[1.9] prose-p:text-foreground/85 " +
  "prose-a:text-brand prose-a:font-semibold prose-a:underline prose-a:decoration-brand/30 prose-a:underline-offset-2 hover:prose-a:decoration-brand " +
  "prose-li:my-1.5 prose-li:leading-[1.85] prose-li:text-foreground/85 prose-li:marker:text-brand " +
  "prose-strong:font-bold prose-strong:text-brand-dark " +
  "prose-blockquote:rounded-r-xl prose-blockquote:border-l-4 prose-blockquote:border-brand prose-blockquote:bg-brand/5 prose-blockquote:py-1 prose-blockquote:not-italic prose-blockquote:text-foreground/80 " +
  "prose-code:rounded prose-code:bg-brand/10 prose-code:px-1.5 prose-code:py-0.5 prose-code:font-medium prose-code:text-brand prose-code:before:content-none prose-code:after:content-none " +
  "prose-img:rounded-xl prose-img:border prose-img:border-border prose-img:shadow-sm " +
  "prose-hr:my-10 prose-hr:border-border " +
  "prose-table:my-6 prose-table:overflow-hidden prose-table:rounded-xl prose-table:text-base " +
  "prose-th:bg-brand/10 prose-th:p-3 prose-th:text-left prose-th:font-bold prose-th:text-brand-dark " +
  "prose-td:border prose-td:border-border prose-td:p-3 " +
  "prose-tr:even:bg-muted/40";

export default function Markdown({
  children,
  className,
}: {
  children: string;
  className?: string;
}) {
  return (
    <div className={cn(PROSE, className)}>
      {/* remarkBreaks: honor single newlines in the source so plain-text
          answers (which use single line breaks rather than markdown markup)
          don't collapse into one run-on paragraph. */}
      <ReactMarkdown remarkPlugins={[remarkGfm, remarkBreaks]}>
        {children}
      </ReactMarkdown>
    </div>
  );
}
