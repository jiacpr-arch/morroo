import { describe, it, expect } from "vitest";
import {
  extractAnnouncementLines,
  diffNewLines,
  buildAdminAlert,
} from "./exam-watch";

const SAMPLE_HTML = `
<html><head><title>ข่าว ศรว.</title>
<style>.x{color:red}</style>
<script>var a = "กำหนดการสอบ ปลอมใน script";</script>
</head><body>
<nav><a href="/">หน้าแรก</a><a href="/news">ข่าว</a></nav>
<h2><a href="/news/1">ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569</a></h2>
<h2><a href="/news/2">รับสมัครสอบขั้นตอนที่ 2 ครั้งที่ 3 (19 กรกฎาคม 2569)</a></h2>
<p>เนื้อหาทั่วไปที่ไม่เกี่ยวข้องกับการสอบเลยสักนิดเดียว ยาวพอสมควรแต่ไม่มีคีย์เวิร์ด</p>
<h2><a href="/news/3">ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569</a></h2>
</body></html>`;

describe("extractAnnouncementLines", () => {
  it("สกัดเฉพาะบรรทัดที่มีคีย์เวิร์ดเกี่ยวกับการสอบ ไม่เอา script/เมนู/เนื้อหาทั่วไป", () => {
    const lines = extractAnnouncementLines(SAMPLE_HTML);
    expect(lines).toContain("ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569");
    expect(lines).toContain(
      "รับสมัครสอบขั้นตอนที่ 2 ครั้งที่ 3 (19 กรกฎาคม 2569)"
    );
    expect(lines.join(" ")).not.toContain("ปลอมใน script");
    expect(lines).not.toContain("ข่าว");
  });

  it("บรรทัดซ้ำถูก dedupe", () => {
    const lines = extractAnnouncementLines(SAMPLE_HTML);
    const target = lines.filter(
      (l) => l === "ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569"
    );
    expect(target).toHaveLength(1);
  });

  it("HTML ว่าง → ลิสต์ว่าง", () => {
    expect(extractAnnouncementLines("<html></html>")).toEqual([]);
  });
});

describe("diffNewLines", () => {
  it("คืนเฉพาะบรรทัดที่ไม่เคยเห็น", () => {
    expect(diffNewLines(["a ประกาศ"], ["a ประกาศ", "b วันสอบใหม่"])).toEqual([
      "b วันสอบใหม่",
    ]);
  });

  it("บรรทัดเก่าหายไปจากหน้า ไม่นับเป็นของใหม่", () => {
    expect(diffNewLines(["a", "b"], ["b"])).toEqual([]);
  });
});

describe("buildAdminAlert", () => {
  it("โชว์สูงสุด 6 บรรทัด + บอกจำนวนที่เหลือ", () => {
    const lines = Array.from({ length: 8 }, (_, i) => `ประกาศที่ ${i + 1}`);
    const msg = buildAdminAlert(lines);
    expect(msg).toContain("• ประกาศที่ 6");
    expect(msg).not.toContain("• ประกาศที่ 7");
    expect(msg).toContain("และอีก 2 รายการ");
    expect(msg).toContain("lib/exam-dates.ts");
  });
});
