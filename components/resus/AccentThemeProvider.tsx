import "./accent-theme.css";

/**
 * Scopes the ACLS/BLS accent color override (accent-theme.css) to this
 * subtree via a data-course attribute. Never writes to :root — see
 * accent-theme.css for why that's safe against bleeding into morroo/firstaid.
 */
export function AccentThemeProvider({
  course,
  children,
}: {
  course: "acls" | "bls";
  children: React.ReactNode;
}) {
  return (
    <div data-course={course} style={{ minHeight: "100vh" }}>
      {children}
    </div>
  );
}
