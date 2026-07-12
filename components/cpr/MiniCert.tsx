"use client";
import { useRef, useState } from "react";
import { B, COURSE, SERIF } from "@/lib/cpr/config";
import { load, type CprProgress, type CprUser } from "@/lib/cpr/storage";
import { safeTrack } from "@/lib/cpr/analytics";
import { captureNodeToPng, dataUrlToBlob, deliverBlob, sanitizeFileName } from "@/lib/cpr/cert";
import { css } from "./styles";
import { I, Logo } from "./icons";
import type { Go } from "./types";
import type { CourseModule } from "@/lib/cpr/config";

export default function MiniCert({ user, go }: { user: CprUser | null; go: Go }) {
  const progress = load<CprProgress>("progress", { done: [], scores: {} });
  const d = new Date();
  const ds = `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear() + 543}`;
  const completed = COURSE.modules.filter((m) => m.id <= 6 && progress.done.includes(m.id));
  const refs = useRef<Record<number, HTMLDivElement | null>>({});
  const [genId, setGenId] = useState<number | null>(null);
  const saveMiniImage = async (m: CourseModule) => {
    if (genId) return;
    setGenId(m.id);
    try {
      const node = refs.current[m.id];
      if (!node) throw new Error("no node");
      const dataUrl = await captureNodeToPng(node);
      await deliverBlob(await dataUrlToBlob(dataUrl), `JIA_${sanitizeFileName(m.short)}_${sanitizeFileName(user?.name)}.png`, "image/png");
      safeTrack("minicert_download", { module: m.id });
    } catch (_e) {
      safeTrack("minicert_download_error", { module: m.id });
      alert("บันทึกอัตโนมัติไม่สำเร็จ กรุณา screenshot หน้าจอเพื่อบันทึกใบประกาศ");
    } finally {
      setGenId(null);
    }
  };
  return (
    <div style={{ ...css.page, padding: 20 }}>
      <div style={{ maxWidth: 480, margin: "0 auto" }}>
        <button onClick={() => go("course")} style={{ background: "none", border: "none", padding: 0, cursor: "pointer", display: "flex", alignItems: "center", gap: 6, color: B.dkGray, fontSize: 14, marginBottom: 16 }}><I name="back" size={18} color={B.dkGray} /> กลับ</button>
        <h2 style={{ fontSize: 20, fontWeight: 800, textAlign: "center", marginBottom: 20 }}>Mini Certificate</h2>
        {completed.map((m) => (
          <div key={m.id} style={{ marginBottom: 20 }}>
            <div style={{ background: B.white, borderRadius: 16, padding: 4, boxShadow: "0 4px 16px rgba(0,0,0,.08)" }}>
              <div ref={(el) => { refs.current[m.id] = el; }} style={{ position: "relative", border: `2px solid ${B.gold}`, borderRadius: 12, padding: "24px 16px", textAlign: "center", background: "linear-gradient(180deg, #FFFEF7 0%, #FFFFFF 100%)" }}>
                <div style={{ marginBottom: 8 }}><Logo size={64} /></div>
                <div style={{ fontSize: 14, fontWeight: 300, color: B.dkGray }}>Mini Certificate</div>
                <div style={{ fontSize: 16, fontWeight: 700, margin: "6px 0", color: B.black }}>{m.short}</div>
                <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 6 }}>มอบให้แก่</div>
                <div style={{ fontFamily: SERIF, fontSize: 20, fontWeight: 600, lineHeight: 1.5, color: B.black, marginBottom: 8 }}>{user?.name || "ชื่อผู้เรียน"}</div>
                <div style={{ fontSize: 11, color: B.dkGray }}>คะแนน: {progress.scores[m.id]}% • วันที่ {ds}</div>
              </div>
            </div>
            <button onClick={() => saveMiniImage(m)} disabled={!!genId} style={{ ...css.btn(B.white, B.black, true), marginTop: 8, fontSize: 13, border: `1px solid ${B.ltGray}`, display: "flex", alignItems: "center", justifyContent: "center", gap: 8, opacity: genId ? 0.6 : 1, cursor: genId ? "default" : "pointer" }}><I name="save" size={16} color={B.black} /> {genId === m.id ? "กำลังสร้างรูป..." : "บันทึกเป็นรูปภาพ"}</button>
          </div>
        ))}
        {completed.length === 0 && <div style={{ textAlign: "center", color: B.dkGray, padding: 20 }}>ยังไม่มีหัวข้อที่ผ่าน</div>}
      </div>
    </div>
  );
}
