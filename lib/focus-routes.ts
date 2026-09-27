/** Keep timed practice and answer screens free of floating promotions. */
export function isFocusedPracticeRoute(pathname: string | null) {
  if (!pathname) return false;
  return (
    pathname.startsWith("/sim/") ||
    pathname.startsWith("/longcase/session") ||
    pathname.startsWith("/nl/practice") ||
    pathname.startsWith("/nl/mock") ||
    pathname.startsWith("/school/quiz") ||
    pathname.startsWith("/acls-reader/test") ||
    /^\/exams\/[^/]+(?:\/answer)?$/.test(pathname)
  );
}

/** Keep setup and checkout flows clear of floating contact and promotion controls. */
export function isUninterruptedRoute(pathname: string | null) {
  if (!pathname) return false;
  return (
    pathname === "/onboarding" ||
    pathname === "/school/onboarding" ||
    pathname.startsWith("/payment/") ||
    isFocusedPracticeRoute(pathname)
  );
}
