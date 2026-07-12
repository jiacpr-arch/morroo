// ตัวช่วยส่งออกใบประกาศนียบัตร (PNG / PDF) — client-only ทั้งไฟล์
export const sanitizeFileName = (name?: string | null) =>
  (name || "ใบประกาศนียบัตร")
    .normalize("NFC")
    .replace(/[\\/:*?"<>|]+/g, "")
    .replace(/\s+/g, "_")
    .slice(0, 40) || "certificate";

// แปลง DOM node เป็น PNG data URL ความละเอียดสูง (retina) ด้วย html-to-image (dynamic import → code-split)
export const captureNodeToPng = async (node: HTMLElement) => {
  const { toPng } = await import("html-to-image");
  if (document.fonts?.ready) {
    try {
      await document.fonts.ready; // รอฟอนต์โหลดเสร็จก่อน capture
    } catch {}
  }
  const opts = {
    pixelRatio: Math.max(2, window.devicePixelRatio || 1),
    backgroundColor: "#FFFFFF",
    cacheBust: true,
    width: node.offsetWidth,
    height: node.offsetHeight,
  };
  try {
    return await toPng(node, opts);
  } catch (_e) {
    // ฟอนต์ Google (cross-origin) embed ไม่ได้ → ลองใหม่โดยข้ามการฝังฟอนต์ ใช้ serif fallback แทน เพื่อให้ดาวน์โหลดสำเร็จเสมอ
    return await toPng(node, { ...opts, skipFonts: true });
  }
};

// แชร์ไฟล์ผ่าน share sheet ของมือถือก่อน (เซฟลง Photos/Files หรือส่ง LINE ได้); ถ้าไม่รองรับ → ดาวน์โหลดแบบ <a download>
export const deliverBlob = async (blob: Blob, filename: string, mime: string) => {
  try {
    const file = new File([blob], filename, { type: mime });
    if (navigator.canShare && navigator.canShare({ files: [file] })) {
      await navigator.share({ files: [file], title: "JIA Certificate" });
      return;
    }
  } catch (e) {
    if (e && (e as Error).name === "AbortError") return; // ผู้ใช้กดยกเลิก share sheet — ถือว่าปกติ
    // อื่น ๆ: ตกไปใช้ดาวน์โหลดด้านล่าง
  }
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.style.display = "none";
  document.body.appendChild(a);
  a.click();
  a.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
};

export const dataUrlToBlob = async (dataUrl: string) => (await fetch(dataUrl)).blob();
