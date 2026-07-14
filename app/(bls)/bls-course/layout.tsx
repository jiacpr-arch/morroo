import { BlsShell } from "@/components/bls/BlsShell";

// The <html>/<body>, fonts, CSS and metadata live in app/(bls)/layout.tsx.
export default function BlsSectionLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return <BlsShell>{children}</BlsShell>;
}
