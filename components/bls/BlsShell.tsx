import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { AccentThemeProvider } from "@/components/resus/AccentThemeProvider";

// Nav shell for every BLS page — same shape as components/acls/AclsShell.tsx.
export function BlsShell({ children }: { children: React.ReactNode }) {
  return (
    <AccentThemeProvider course="bls">
      <div className="flex min-h-screen flex-col bg-background text-foreground">
        <header className="border-b bg-card">
          <div className="mx-auto flex max-w-5xl items-center justify-between px-4 py-3">
            <Link
              href="/"
              className="flex items-center gap-2 font-heading text-lg font-semibold text-primary"
            >
              BLS Provider
              <Badge variant="secondary">ILCOR 2025</Badge>
            </Link>
            <a
              href="https://www.morroo.com"
              className="text-sm text-muted-foreground hover:text-foreground"
            >
              เครือ Jia Training Center
            </a>
          </div>
        </header>
        <main className="flex-1">{children}</main>
      </div>
    </AccentThemeProvider>
  );
}
