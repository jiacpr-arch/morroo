"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { StickyNote, Loader2, Check, X } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface Props {
  unitType: "flashcard" | "quiz" | "lesson" | "case" | "concept";
  unitId: string;
}

export default function NoteEditor({ unitType, unitId }: Props) {
  const [open, setOpen] = useState(false);
  const [body, setBody] = useState("");
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        if (!cancelled) setLoading(false);
        return;
      }
      const { data } = await supabase
        .from("school_user_notes")
        .select("body")
        .eq("user_id", user.id)
        .eq("unit_type", unitType)
        .eq("unit_id", unitId)
        .maybeSingle();
      if (!cancelled) {
        setBody(data?.body ?? "");
        setLoading(false);
      }
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [unitType, unitId]);

  async function save() {
    setSaving(true);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      if (body.trim()) {
        await supabase
          .from("school_user_notes")
          .upsert(
            {
              user_id: user.id,
              unit_type: unitType,
              unit_id: unitId,
              body: body.trim(),
              updated_at: new Date().toISOString(),
            },
            { onConflict: "user_id,unit_type,unit_id" }
          );
      } else {
        await supabase
          .from("school_user_notes")
          .delete()
          .eq("user_id", user.id)
          .eq("unit_type", unitType)
          .eq("unit_id", unitId);
      }
      setSaved(true);
      setTimeout(() => setSaved(false), 1500);
    } catch {
      // Non-blocking
    } finally {
      setSaving(false);
    }
  }

  if (loading) return null;

  return (
    <div className="mt-3">
      {!open ? (
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            setOpen(true);
          }}
          className="text-xs flex items-center gap-1 text-violet-700 hover:bg-violet-50 px-2 py-1 rounded"
        >
          <StickyNote className="h-3 w-3" />
          {body ? "ดู/แก้ Note" : "เพิ่ม Note ส่วนตัว"}
        </button>
      ) : (
        <div
          className="border rounded-lg p-3 bg-violet-50/40 space-y-2"
          onClick={(e) => e.stopPropagation()}
        >
          <div className="flex items-center justify-between">
            <p className="text-xs font-semibold flex items-center gap-1 text-violet-700">
              <StickyNote className="h-3 w-3" /> Note ส่วนตัว
            </p>
            <button onClick={() => setOpen(false)}>
              <X className="h-3 w-3" />
            </button>
          </div>
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            placeholder="เพิ่ม mnemonic, สรุปย่อ, หรือทริคจำของคุณเอง..."
            className="w-full border rounded p-2 text-sm min-h-[80px] bg-background"
          />
          <Button size="sm" onClick={save} disabled={saving} className="gap-1">
            {saving ? (
              <Loader2 className="h-3 w-3 animate-spin" />
            ) : saved ? (
              <Check className="h-3 w-3" />
            ) : null}
            {saved ? "บันทึกแล้ว" : "บันทึก"}
          </Button>
        </div>
      )}
    </div>
  );
}
