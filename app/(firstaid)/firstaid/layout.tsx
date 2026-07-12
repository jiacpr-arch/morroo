import FirstAidShell from "@/components/firstaid/FirstAidShell";

// Nested layout for every firstaid page: wraps the route tree in the client
// shell (learner bootstrap, PostHog, theme, onboarding gate, tab bar).
// The <html>/<body>, fonts, CSS and pixels live in app/(firstaid)/layout.tsx.
export default function FirstAidSectionLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return <FirstAidShell>{children}</FirstAidShell>;
}
