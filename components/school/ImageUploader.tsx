"use client";

import { useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import { Upload, Loader2, Check, Copy } from "lucide-react";

interface Props {
  /** Called with the permanent public URL once an upload succeeds. */
  onUploaded: (url: string) => void;
  label?: string;
}

/**
 * Admin image upload widget. Picks a file, POSTs it to
 * /api/admin/school/upload-image (Supabase Storage), and hands the resulting
 * permanent URL to `onUploaded`. Use it to fill an image field or insert an
 * image into lesson/book markdown.
 */
export default function ImageUploader({ onUploaded, label = "อัปโหลดรูป" }: Props) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [busy, setBusy] = useState(false);
  const [lastUrl, setLastUrl] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleFile(file: File) {
    setBusy(true);
    setError(null);
    try {
      const body = new FormData();
      body.append("file", file);
      const res = await fetch("/api/admin/school/upload-image", {
        method: "POST",
        body,
      });
      const data = (await res.json()) as { url?: string; error?: string };
      if (!res.ok || !data.url) {
        setError(data.error ?? "อัปโหลดไม่สำเร็จ");
        return;
      }
      setLastUrl(data.url);
      onUploaded(data.url);
    } catch {
      setError("อัปโหลดไม่สำเร็จ");
    } finally {
      setBusy(false);
      if (inputRef.current) inputRef.current.value = "";
    }
  }

  return (
    <div className="space-y-1">
      <input
        ref={inputRef}
        type="file"
        accept="image/png,image/jpeg,image/webp,image/gif,image/svg+xml"
        className="hidden"
        onChange={(e) => {
          const f = e.target.files?.[0];
          if (f) handleFile(f);
        }}
      />
      <Button
        type="button"
        variant="outline"
        size="sm"
        disabled={busy}
        onClick={() => inputRef.current?.click()}
        className="gap-2"
      >
        {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
        {busy ? "กำลังอัปโหลด…" : label}
      </Button>
      {error && <p className="text-xs text-rose-600">{error}</p>}
      {lastUrl && (
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <Check className="h-3 w-3 text-emerald-600" />
          <span className="truncate max-w-[240px]">{lastUrl}</span>
          <button
            type="button"
            onClick={() => {
              navigator.clipboard?.writeText(lastUrl);
              setCopied(true);
              setTimeout(() => setCopied(false), 1500);
            }}
            className="inline-flex items-center gap-1 underline"
          >
            <Copy className="h-3 w-3" /> {copied ? "คัดลอกแล้ว" : "คัดลอก URL"}
          </button>
        </div>
      )}
    </div>
  );
}
