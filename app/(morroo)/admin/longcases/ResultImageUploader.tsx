"use client";

import { useState } from "react";
import { Loader2, Upload, Copy, Check, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

// อัปโหลดรูป ECG / CXR / รูปตรวจร่างกาย หรือสร้างภาพประกอบตรวจร่างกายด้วย AI
// แล้วได้ snippet ไปวางใน JSON ของเคส
export function ResultImageUploader() {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [url, setUrl] = useState("");
  const [copied, setCopied] = useState(false);
  const [credit, setCredit] = useState("ที่มา/ลิขสิทธิ์ของรูป");
  const [scene, setScene] = useState("");

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
      setCredit("ที่มา/ลิขสิทธิ์ของรูป");
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  }

  async function generate() {
    setBusy(true);
    setError("");
    setCopied(false);
    try {
      const res = await fetch("/api/admin/longcases/pe-illustration", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ scene }),
      });
      const json = await res.json().catch(() => ({}));
      if (!res.ok || !json.url) throw new Error(json.error ?? "สร้างภาพไม่สำเร็จ");
      setUrl(json.url);
      setCredit(json.credit);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  }

  const snippet = `"image_url": "${url}", "image_credit": "${credit}"`;

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
        <CardTitle className="text-sm">อัปโหลดรูปผลตรวจ (ECG / CXR / ตรวจร่างกาย)</CardTitle>
      </CardHeader>
      <CardContent className="space-y-3 text-xs text-muted-foreground">
        <p>
          ใช้รูปที่ลบข้อมูลผู้ป่วยแล้ว และมีสิทธิ์ใช้เชิงพาณิชย์เท่านั้น · .webp/.png/.jpg ไม่เกิน 4MB ·
          ห้ามใช้รูปที่ AI สร้างเป็นผล ECG / CXR / imaging
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
        <div className="space-y-2 border-t pt-3">
          <p className="font-medium text-foreground flex items-center gap-1">
            <Sparkles className="h-4 w-4 text-amber-500" /> หรือสร้างภาพประกอบตรวจร่างกายด้วย AI
          </p>
          <p>
            เฉพาะ sign ที่เห็นด้วยตา (ผื่น, บวมกดบุ๋ม, ตาเหลือง, facial droop) — ไม่ใช้กับ ECG / CXR / CT / US ·
            บรรยายเป็นภาษาอังกฤษให้ตรงกับผลตรวจในเคส · ให้แพทย์ตรวจภาพก่อนใช้ทุกครั้ง · ใช้เวลา ~1 นาที
          </p>
          <textarea
            value={scene}
            onChange={e => setScene(e.target.value)}
            rows={3}
            disabled={busy}
            placeholder="เช่น Both lower legs of a 58-year-old woman with bilateral pitting edema up to the knees, examiner's thumb leaving a visible pit"
            className="w-full rounded-md border border-input bg-background px-3 py-2 text-xs text-foreground"
          />
          <Button type="button" variant="outline" size="sm" onClick={generate} disabled={busy || scene.trim().length < 15} className="gap-1">
            {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
            {busy ? "กำลังสร้าง…" : "สร้างภาพประกอบ"}
          </Button>
        </div>
        {error && <p className="text-red-600">{error}</p>}
        {url && (
          <div className="space-y-2">
            {/* eslint-disable-next-line @next/next/no-img-element -- preview รูปจาก Storage (URL dynamic) */}
            <img src={url} alt="ตัวอย่างรูปที่อัปโหลด" className="max-h-48 rounded border bg-black object-contain" />
            <p>วาง snippet นี้ในรายการที่ต้องการ</p>
            <ul className="list-disc pl-4 space-y-1">
              <li>Imaging: <code>&quot;ECG&quot;: {"{"} &quot;value&quot;: &quot;…&quot;, &quot;isAbnormal&quot;: true, <b>วางตรงนี้</b> {"}"}</code></li>
              <li>ตรวจร่างกาย: <code>&quot;Skin&quot;: {"{"} &quot;text&quot;: &quot;…&quot;, <b>วางตรงนี้</b> {"}"}</code></li>
            </ul>
            <p>ต้องกรอกผลอ่าน (value / text) ทุกครั้ง — AI ผู้คุมสอบและการให้คะแนนอ่านจากข้อความเท่านั้น</p>
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
