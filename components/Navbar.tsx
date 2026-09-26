"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { ChevronDown, Menu, X, User, LogOut, Shield } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { unsubscribePushOnLogout } from "@/lib/push-client";
import type { User as SupabaseUser } from "@supabase/supabase-js";
import BetaHeaderCounter from "@/components/beta/BetaHeaderCounter";
import NavbarRankChip from "@/components/school/NavbarRankChip";

const primaryNavLinks: { href: string; label: string; isNew?: boolean }[] = [
  { href: "/", label: "หน้าแรก" },
  { href: "/school", label: "School" },
  { href: "/nl", label: "MCQ" },
  { href: "/exams", label: "MEQ" },
  { href: "/longcase", label: "Long Case" },
  { href: "/casegame", label: "เกมเคส", isNew: true },
  { href: "/pricing", label: "แพ็กเกจ" },
];

const exploreNavLinks = [
  // middleware 301 ไป game.morroo.com บนโปรดักชัน (hub รวมเกมทุกเว็บ)
  { href: "/games", label: "เกม" },
  { href: "/acls-reader", label: "ACLS" },
  { href: "/board", label: "Board" },
  { href: "/blog", label: "บทความ" },
  { href: "/guide", label: "คู่มือ" },
];

function isActive(pathname: string | null, href: string) {
  return pathname === href || (href !== "/" && pathname?.startsWith(`${href}/`));
}

/** จุดสีส้มเน้นเมนูใหม่ — ping ครั้งเดียวตอนโหลดเพื่อไม่กวนสายตาตลอดเวลา */
function NewDot() {
  return (
    <span className="absolute -right-2 -top-0.5 flex h-1.5 w-1.5" aria-label="ฟีเจอร์ใหม่">
      <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-amber-500 opacity-75 [animation-iteration-count:3] motion-reduce:animate-none" />
      <span className="relative inline-flex h-1.5 w-1.5 rounded-full bg-amber-500" />
    </span>
  );
}

const authNavLinks = [
  { href: "/dashboard", label: "ผลการเรียน" },
];

export default function Navbar() {
  const pathname = usePathname();
  const [user, setUser] = useState<SupabaseUser | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const supabase = createClient();

  useEffect(() => {
    const auth = supabase.auth;
    auth.getUser().then(({ data }: { data: { user: SupabaseUser | null } }) => setUser(data.user));
    const {
      data: { subscription },
    } = auth.onAuthStateChange((_event: string, session: { user: SupabaseUser | null } | null) => {
      setUser(session?.user ?? null);
    }) as { data: { subscription: { unsubscribe: () => void } } };
    return () => subscription.unsubscribe();
  }, [supabase.auth]);

  useEffect(() => {
    if (!user) {
      setIsAdmin(false);
      return;
    }
    let cancelled = false;
    supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single()
      .then(({ data }: { data: { role?: string } | null }) => {
        if (!cancelled) setIsAdmin(data?.role === "admin");
      });
    return () => {
      cancelled = true;
    };
  }, [user, supabase]);

  const handleLogout = async () => {
    await unsubscribePushOnLogout();
    await supabase.auth.signOut();
    setUser(null);
    window.location.href = "/";
  };

  return (
    <nav aria-label="เมนูหลัก" className="sticky top-0 z-50 border-b border-surface-border bg-white/95 backdrop-blur-md">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        {/* Logo */}
        <Link href="/" aria-label="MorRoo หมอรู้ — หน้าแรก" className="flex shrink-0 items-center gap-2 font-bold text-lg">
          <Image src="/images/logo-morroo.png" alt="" width={56} height={56} className="h-14 w-14 object-contain" />
          <span className="text-brand-dark">หมอรู้</span>
        </Link>

        {/* Desktop nav */}
        <div className="hidden xl:flex items-center gap-4">
          {primaryNavLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              aria-current={isActive(pathname, link.href) ? "page" : undefined}
              className={`relative rounded-md py-2 text-sm font-medium transition-colors hover:text-brand focus-visible:outline-2 focus-visible:outline-brand ${
                isActive(pathname, link.href) ? "text-brand-dark" : "text-muted-foreground"
              }`}
            >
              {link.label}
              {link.isNew && <NewDot />}
            </Link>
          ))}
          <details className="group relative">
            <summary className="flex cursor-pointer list-none items-center gap-1 rounded-md py-2 text-sm font-medium text-muted-foreground transition-colors hover:text-brand focus-visible:outline-2 focus-visible:outline-brand [&::-webkit-details-marker]:hidden">
              เพิ่มเติม <ChevronDown className="h-4 w-4 transition-transform group-open:rotate-180" />
            </summary>
            <div className="absolute left-1/2 top-full mt-2 w-44 -translate-x-1/2 rounded-2xl border border-surface-border bg-white p-2 shadow-xl">
              {exploreNavLinks.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  aria-current={isActive(pathname, link.href) ? "page" : undefined}
                  onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                  className={`block rounded-lg px-3 py-2 text-sm font-medium hover:bg-surface-warm hover:text-brand-dark ${isActive(pathname, link.href) ? "bg-surface-warm text-brand-dark" : "text-muted-foreground"}`}
                >
                  {link.label}
                </Link>
              ))}
            </div>
          </details>
        </div>

        {/* Auth buttons */}
        <div className="hidden xl:flex items-center gap-3">
          {user && <NavbarRankChip />}
          {user && <BetaHeaderCounter />}
          {user ? (
            <>
              {authNavLinks.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  className={`text-sm font-medium transition-colors hover:text-brand ${
                    pathname === link.href
                      ? "text-brand"
                      : "text-muted-foreground"
                  }`}
                >
                  {link.label}
                </Link>
              ))}
              {isAdmin && (
                <Link href="/admin">
                  <Button variant="ghost" size="sm" className="gap-2">
                    <Shield className="h-4 w-4" />
                    Admin
                  </Button>
                </Link>
              )}
              <Link href="/profile">
                <Button variant="ghost" size="sm" className="gap-2">
                  <User className="h-4 w-4" />
                  โปรไฟล์
                </Button>
              </Link>
              <Button
                variant="outline"
                size="sm"
                onClick={handleLogout}
                className="gap-2"
              >
                <LogOut className="h-4 w-4" />
                ออกจากระบบ
              </Button>
            </>
          ) : (
            <>
              <Link href="/login">
                <Button variant="ghost" size="sm">
                  เข้าสู่ระบบ
                </Button>
              </Link>
              <Link href="/register">
                <Button
                  size="sm"
                  className="bg-brand hover:bg-brand-light text-white"
                >
                  สมัครสมาชิก
                </Button>
              </Link>
            </>
          )}
        </div>

        {/* Mobile account chips leave room for the native menu control. */}
        <div className="flex items-center gap-2 pr-12 xl:hidden">
          {user && <NavbarRankChip />}
          {user && <BetaHeaderCounter />}
        </div>
      </div>

      {/* Native details opens immediately, even before client hydration. */}
      <details className="group xl:hidden" onKeyDown={(event) => {
        if (event.key === "Escape") {
          event.currentTarget.removeAttribute("open");
          event.currentTarget.querySelector("summary")?.focus();
        }
      }}>
        <summary aria-label="เมนู" className="absolute right-4 top-2.5 flex h-11 w-11 cursor-pointer list-none items-center justify-center rounded-xl text-brand-dark hover:bg-surface-warm focus-visible:outline-2 focus-visible:outline-brand [&::-webkit-details-marker]:hidden">
          <Menu className="h-6 w-6 group-open:hidden" />
          <X className="hidden h-6 w-6 group-open:block" />
        </summary>
        <div id="mobile-main-menu" className="absolute inset-x-0 top-full max-h-[calc(100dvh-4rem)] overflow-y-auto border-t border-surface-border bg-white shadow-xl">
          <div className="space-y-1 px-4 py-3">
            <p className="px-3 pb-1 text-xs font-semibold text-muted-foreground">เริ่มเรียน</p>
            {primaryNavLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                aria-current={isActive(pathname, link.href) ? "page" : undefined}
                className={`block rounded-xl px-3 py-2.5 text-sm font-medium ${
                  isActive(pathname, link.href)
                    ? "bg-surface-warm text-brand-dark"
                    : "text-muted-foreground hover:bg-surface-warm"
                }`}
              >
                {link.label}
                {link.isNew && (
                  <span className="ml-2 rounded-full bg-amber-100 px-2 py-0.5 text-[10px] font-bold text-amber-700">
                    ใหม่
                  </span>
                )}
              </Link>
            ))}
            <p className="border-t border-surface-border px-3 pb-1 pt-4 text-xs font-semibold text-muted-foreground">สำรวจเพิ่มเติม</p>
            {exploreNavLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                aria-current={isActive(pathname, link.href) ? "page" : undefined}
                className={`block rounded-xl px-3 py-2.5 text-sm font-medium ${isActive(pathname, link.href) ? "bg-surface-warm text-brand-dark" : "text-muted-foreground hover:bg-surface-warm"}`}
              >
                {link.label}
              </Link>
            ))}
            <div className="border-t pt-3 mt-3 space-y-2">
              {user ? (
                <>
                  {authNavLinks.map((link) => (
                    <Link
                      key={link.href}
                      href={link.href}
                      onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                      className={`block rounded-md px-3 py-2 text-sm font-medium ${
                        pathname === link.href
                          ? "bg-brand/10 text-brand"
                          : "text-muted-foreground hover:bg-muted"
                      }`}
                    >
                      {link.label}
                    </Link>
                  ))}
                  {isAdmin && (
                    <Link
                      href="/admin"
                      onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                      className="block rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted"
                    >
                      Admin
                    </Link>
                  )}
                  <Link
                    href="/profile"
                    onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                    className="block rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted"
                  >
                    โปรไฟล์
                  </Link>
                  <button
                    onClick={handleLogout}
                    className="block w-full text-left rounded-md px-3 py-2 text-sm font-medium text-destructive hover:bg-muted"
                  >
                    ออกจากระบบ
                  </button>
                </>
              ) : (
                <>
                  <Link
                    href="/login"
                    onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                    className="block rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted"
                  >
                    เข้าสู่ระบบ
                  </Link>
                  <Link
                    href="/register"
                    onClick={(event) => event.currentTarget.closest("details")?.removeAttribute("open")}
                    className="block rounded-md bg-brand px-3 py-2 text-center text-sm font-medium text-white"
                  >
                    สมัครสมาชิก
                  </Link>
                </>
              )}
            </div>
          </div>
        </div>
      </details>
    </nav>
  );
}
