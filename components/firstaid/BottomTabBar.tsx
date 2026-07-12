"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, BookOpen, Map, Activity, Phone } from "lucide-react";

const ITEMS = [
  { href: "/", label: "หน้าหลัก", icon: Home, exact: true },
  { href: "/learn", label: "เรียน", icon: BookOpen },
  { href: "/algorithms", label: "Algorithm", icon: Map },
  { href: "/simulation", label: "ฝึก", icon: Activity },
  { href: "/call", label: "1669", icon: Phone, danger: true },
] as const;

// usePathname may return the internal rewritten path (/firstaid/...) during the
// server render on the firstaid host — normalize so active states match the
// public URLs the tabs link to.
function publicPath(pathname: string | null) {
  const p = pathname || "/";
  if (p === "/firstaid") return "/";
  return p.startsWith("/firstaid/") ? p.slice("/firstaid".length) : p;
}

export default function BottomTabBar() {
  const pathname = publicPath(usePathname());
  return (
    <nav className="bottom-bar" aria-label="แถบเมนูหลัก">
      {ITEMS.map((item) => {
        const { href, label, icon: Icon, exact } = item as (typeof ITEMS)[number] & {
          exact?: boolean;
          danger?: boolean;
        };
        const danger = "danger" in item && item.danger;
        const active = exact ? pathname === href : pathname.startsWith(href);
        return (
          <Link
            key={href}
            href={href}
            className={`bottom-bar-item ${active ? "active" : ""}`}
            style={danger && !active ? { color: "var(--color-danger)" } : undefined}
          >
            <Icon size={20} />
            <span>{label}</span>
          </Link>
        );
      })}
    </nav>
  );
}
