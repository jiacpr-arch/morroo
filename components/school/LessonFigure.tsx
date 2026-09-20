"use client";

import { useState, type ComponentProps } from "react";
import type { Components } from "react-markdown";
import { Maximize2 } from "lucide-react";
import { Dialog } from "@/components/ui/dialog";
import { captionFromTitle } from "@/lib/school/figures";
import { track } from "@/lib/analytics";

/**
 * Figure renderer for markdown images inside School content (lessons, book
 * chapters, cases, guided runs). Authors write a normal markdown image and put
 * the caption in the image *title*:
 *
 *   ![alt](url "caption")
 *
 * This shows the image lazily, prints the caption underneath, and opens a
 * full-size view on tap (tables/diagrams are hard to read at phone width).
 *
 * Everything is rendered with inline-capable elements (`span`, `button`)
 * because react-markdown wraps a lone image in a `<p>`, and `<figure>`/`<div>`
 * inside `<p>` is invalid HTML that breaks hydration. `FigureParagraph` below
 * turns such an image-only paragraph into a `div` so the block layout holds.
 */
export default function LessonFigure(props: ComponentProps<"img">) {
  const { src, alt, title } = props;
  const [open, setOpen] = useState(false);
  const caption = captionFromTitle(title);
  const url = typeof src === "string" ? src : "";
  if (!url) return null;

  function zoom() {
    setOpen(true);
    track("school_figure_zoom", { src: url });
  }

  return (
    <span className="lesson-figure block my-5 not-prose">
      <button
        type="button"
        onClick={zoom}
        aria-label={alt ? `ขยายรูป: ${alt}` : "ขยายรูป"}
        className="group relative block w-full overflow-hidden rounded-xl border bg-white text-left"
      >
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={url}
          alt={alt ?? ""}
          loading="lazy"
          decoding="async"
          className="mx-auto block max-h-[520px] w-full object-contain"
        />
        <span className="pointer-events-none absolute right-2 top-2 rounded-full bg-black/50 p-1.5 text-white opacity-0 transition group-hover:opacity-100">
          <Maximize2 className="h-3.5 w-3.5" />
        </span>
      </button>
      {caption && (
        <span className="mt-2 block px-2 text-center text-xs leading-relaxed text-muted-foreground">
          {caption}
        </span>
      )}
      <Dialog open={open} onClose={() => setOpen(false)} className="max-w-5xl">
        <span className="block p-4 sm:p-6">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={url}
            alt={alt ?? ""}
            className="mx-auto block max-h-[80vh] w-full object-contain"
          />
          {caption && (
            <span className="mt-3 block text-center text-sm text-muted-foreground">
              {caption}
            </span>
          )}
        </span>
      </Dialog>
    </span>
  );
}

type ParagraphProps = ComponentProps<"p"> & {
  node?: { children?: { type: string; tagName?: string; value?: string }[] };
};

/** Paragraph that becomes a block `div` when its only content is an image. */
function FigureParagraph({ node, children, ...rest }: ParagraphProps) {
  const kids = (node?.children ?? []).filter(
    (c) => !(c.type === "text" && !(c.value ?? "").trim())
  );
  const imageOnly =
    kids.length > 0 && kids.every((c) => c.type === "element" && c.tagName === "img");
  if (imageOnly) return <div {...rest}>{children}</div>;
  return <p {...rest}>{children}</p>;
}

/**
 * Drop-in `components` for ReactMarkdown so every School reader renders
 * figures the same way: `<ReactMarkdown components={figureComponents}>`.
 */
export const figureComponents: Components = {
  img: LessonFigure,
  p: FigureParagraph,
};
