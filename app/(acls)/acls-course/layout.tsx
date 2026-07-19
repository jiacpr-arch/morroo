import { AclsShell } from "@/components/acls/AclsShell";

// The <html>/<body>, fonts, CSS and metadata live in app/(acls)/layout.tsx.
export default function AclsSectionLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return <AclsShell>{children}</AclsShell>;
}
