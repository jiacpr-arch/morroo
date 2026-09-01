"use client";

import { useEffect, useState } from "react";
import { Bookmark, BookmarkCheck } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface Props {
  unitType: "flashcard" | "quiz" | "lesson" | "case" | "concept";
  unitId: string;
  size?: "sm" | "md";
}

export default function BookmarkButton({ unitType, unitId, size = "sm" }: Props) {
  const [bookmarked, setBookmarked] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    async function check() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        if (!cancelled) setLoading(false);
        return;
      }
      const { data } = await supabase
        .from("school_user_bookmarks")
        .select("user_id")
        .eq("user_id", user.id)
        .eq("unit_type", unitType)
        .eq("unit_id", unitId)
        .maybeSingle();
      if (!cancelled) {
        setBookmarked(!!data);
        setLoading(false);
      }
    }
    check();
    return () => {
      cancelled = true;
    };
  }, [unitType, unitId]);

  async function toggle(e?: React.MouseEvent) {
    e?.stopPropagation();
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      if (bookmarked) {
        await supabase
          .from("school_user_bookmarks")
          .delete()
          .eq("user_id", user.id)
          .eq("unit_type", unitType)
          .eq("unit_id", unitId);
        setBookmarked(false);
      } else {
        await supabase.from("school_user_bookmarks").insert({
          user_id: user.id,
          unit_type: unitType,
          unit_id: unitId,
        });
        setBookmarked(true);
      }
    } catch {
      // Non-blocking
    }
  }

  if (loading) return null;
  const Icon = bookmarked ? BookmarkCheck : Bookmark;
  const iconSize = size === "sm" ? "h-4 w-4" : "h-5 w-5";
  return (
    <button
      type="button"
      onClick={toggle}
      aria-label={bookmarked ? "Remove bookmark" : "Bookmark"}
      className={`p-1.5 rounded hover:bg-muted transition-colors ${
        bookmarked ? "text-amber-600" : "text-muted-foreground"
      }`}
    >
      <Icon className={iconSize} fill={bookmarked ? "currentColor" : "none"} />
    </button>
  );
}
