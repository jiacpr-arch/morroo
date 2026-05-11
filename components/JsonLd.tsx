/**
 * Renders a schema.org JSON-LD block. Server component — safe to drop into
 * any page.tsx without "use client".
 */

export default function JsonLd({ data }: { data: unknown }) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }}
    />
  );
}
