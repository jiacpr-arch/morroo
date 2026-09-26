"use client";

import { useState } from "react";
import { Loader2, Upload, Copy, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

// อัปโหลดรูป ECG / CXR แล้วได้ snippet ไปวางใน Imaging Results (JSON)
export function ResultImageUploader() {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [url, setUrl] = useState("");
  const [copied, setCopied] = useState(false);

  async function upload(file: File) {
    setBusy(true);
    setError("");
    setCopied(false);
    const form = new FormData();
    form.set("file", file);
    try {
      const res = await fetch("/api/admin/longcases/media", { method: "POST", body: form });
      const json = await res.json().catch(() => ({}));
      if (!res.ok || !json.url) throw new Error(json.error ?? "อัปโหลดไม่สำเร็จ");
      setUrl(json.url);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  }

  const snippet = `"image_url": "${url}", "image_credit": "ที่มา/ลิขสิทธิ์ของรูป"`;

  async function copy() {
    try {
      await navigator.clipboard.writeText(snippet);
      setCopied(true);
    } catch {
      setError("คัดลอกไม่ได้ — เลือกข้อความแล้วคัดลอกเอง");
    }
  }

  return (
    <Card>
      <CardHeader className="pb-2">
        <CardTitle className="text-sm">อัปโหลดรูปผลตรวจ (ECG / CXR)</CardTitle>
      </CardHeader>
      <CardContent className="space-y-3 text-xs text-muted-foreground">
        <p>
          ใช้รูปที่ลบข้อมูลผู้ป่วยแล้ว และมีสิทธิ์ใช้เชิงพาณิชย์เท่านั้น · .webp/.png/.jpg ไม่เกิน 4MB ·
          ห้ามใช้รูปที่ AI สร้างเป็นผลตรวจ
        </p>
        <label className="inline-flex">
          <input
            type="file"
            accept="image/webp,image/png,image/jpeg"
            className="hidden"
            disabled={busy}
            onChange={e => {
              const file = e.target.files?.[0];
              e.target.value = "";
              if (file) void upload(file);
            }}
          />
          <span className="inline-flex items-center gap-2 rounded-md border px-3 py-2 text-sm text-foreground cursor-pointer hover:bg-muted">
            {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
            เลือกรูป
          </span>
        </label>
        {error && <p className="text-red-600">{error}</p>}
        {url && (
          <div className="space-y-2">
            {/* eslint-disable-next-line @next/next/no-img-element -- preview รูปจาก Storage (URL dynamic) */}
            <img src={url} alt="ตัวอย่างรูปที่อัปโหลด" className="max-h-48 rounded border bg-black object-contain" />
            <p>วาง snippet นี้ในรายการที่ต้องการ เช่น <code>&quot;ECG&quot;: {"{"} &quot;value&quot;: &quot;…&quot;, &quot;isAbnormal&quot;: true, <b>วางตรงนี้</b> {"}"}</code></p>
            <pre className="whitespace-pre-wrap break-all rounded bg-muted p-2 font-mono text-foreground">{snippet}</pre>
            <Button type="button" variant="outline" size="sm" onClick={copy} className="gap-1">
              {copied ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
              {copied ? "คัดลอกแล้ว" : "คัดลอก"}
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
