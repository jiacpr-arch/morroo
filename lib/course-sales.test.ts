import { describe, it, expect } from "vitest";
import {
  COURSES,
  courseSaleEventId,
  findCourse,
  todayInBangkok,
  validateCourseSale,
} from "./course-sales";

const VALID = {
  customerName: "สมชาย ใจดี",
  phone: "081-234-5678",
  courseId: "cpr",
};

function expectOk(input: Parameters<typeof validateCourseSale>[0]) {
  const r = validateCourseSale(input);
  if (!r.ok) throw new Error(`expected ok, got: ${r.errors.join(", ")}`);
  return r.sale;
}

function expectErrors(input: Parameters<typeof validateCourseSale>[0]) {
  const r = validateCourseSale(input);
  if (r.ok) throw new Error("expected validation to fail");
  return r.errors;
}

describe("catalogue", () => {
  it("ราคาตรงกับที่ตกลงในสเปก", () => {
    expect(findCourse("cpr")?.priceThb).toBe(500);
    expect(findCourse("first_aid")?.priceThb).toBe(999);
    expect(findCourse("als")?.priceThb).toBe(5900);
  });

  it("คอร์สที่ไม่รู้จักคืน null", () => {
    expect(findCourse("bls")).toBeNull();
    expect(findCourse("")).toBeNull();
  });

  it("ทุกคอร์สมี id ไม่ซ้ำ", () => {
    expect(new Set(COURSES.map((c) => c.id)).size).toBe(COURSES.length);
  });
});

describe("validateCourseSale", () => {
  it("รับข้อมูลครบถ้วน และเติมราคาจากคอร์สให้เอง", () => {
    const sale = expectOk(VALID);
    expect(sale.customerName).toBe("สมชาย ใจดี");
    expect(sale.course.id).toBe("cpr");
    // ราคาต้องมาจาก catalog ฝั่ง server ไม่ใช่ตัวเลขที่ browser ส่งมา
    expect(sale.priceThb).toBe(500);
    expect(sale.sourceChannel).toBeNull();
  });

  it("ส่วนลดทับราคาเต็มได้", () => {
    expect(expectOk({ ...VALID, priceThb: "450" }).priceThb).toBe(450);
    expect(expectOk({ ...VALID, priceThb: 0 }).priceThb).toBe(0);
  });

  it("ราคาว่างถือว่าไม่ลด ใช้ราคาเต็ม", () => {
    expect(expectOk({ ...VALID, priceThb: "" }).priceThb).toBe(500);
    expect(expectOk({ ...VALID, priceThb: undefined }).priceThb).toBe(500);
  });

  it("ปัดเศษสตางค์", () => {
    expect(expectOk({ ...VALID, priceThb: "499.999" }).priceThb).toBe(500);
    expect(expectOk({ ...VALID, priceThb: "450.55" }).priceThb).toBe(450.55);
  });

  it("ปฏิเสธราคาติดลบและที่ไม่ใช่ตัวเลข", () => {
    expect(expectErrors({ ...VALID, priceThb: "-100" })).toContain("ราคาไม่ถูกต้อง");
    expect(expectErrors({ ...VALID, priceThb: "ห้าร้อย" })).toContain("ราคาไม่ถูกต้อง");
  });

  it("ชื่อและเบอร์เป็นฟิลด์บังคับ", () => {
    expect(expectErrors({ ...VALID, customerName: "   " })).toContain("กรุณากรอกชื่อลูกค้า");
    expect(expectErrors({ ...VALID, phone: "" })).toContain("กรุณากรอกเบอร์โทร");
  });

  it("เบอร์สั้นเกินไปถูกปฏิเสธ — จับคู่กับโฆษณาไม่ได้ถ้าผิด", () => {
    expect(expectErrors({ ...VALID, phone: "0812345" })).toContain(
      "เบอร์โทรไม่ครบ ตรวจสอบอีกครั้ง"
    );
  });

  it("เบอร์ที่มีขีด/ช่องว่างผ่านได้ (นับเฉพาะตัวเลข)", () => {
    expect(expectOk({ ...VALID, phone: "08 1234 5678" }).phone).toBe("08 1234 5678");
    expect(expectOk({ ...VALID, phone: "+66 81 234 5678" })).toBeTruthy();
  });

  it("คอร์สที่ไม่รู้จักถูกปฏิเสธ", () => {
    expect(expectErrors({ ...VALID, courseId: "bls" })).toContain("กรุณาเลือกคอร์ส");
    expect(expectErrors({ ...VALID, courseId: undefined })).toContain("กรุณาเลือกคอร์ส");
  });

  it("ช่องทางที่มาเป็นตัวเลือก แต่ถ้าใส่ต้องอยู่ในลิสต์", () => {
    expect(expectOk({ ...VALID, sourceChannel: "line" }).sourceChannel).toBe("line");
    expect(expectOk({ ...VALID, sourceChannel: "" }).sourceChannel).toBeNull();
    expect(expectErrors({ ...VALID, sourceChannel: "tiktok" })).toContain(
      "ช่องทางที่มาไม่ถูกต้อง"
    );
  });

  it("วันที่ default เป็นวันนี้ตามเวลาไทย", () => {
    expect(expectOk(VALID).soldOn).toBe(todayInBangkok());
  });

  it("ระบุวันที่ย้อนหลังได้", () => {
    expect(expectOk({ ...VALID, soldOn: "2026-09-15" }).soldOn).toBe("2026-09-15");
  });

  it("ปฏิเสธวันที่รูปแบบผิด", () => {
    expect(expectErrors({ ...VALID, soldOn: "15/09/2026" })).toContain("วันที่ไม่ถูกต้อง");
    expect(expectErrors({ ...VALID, soldOn: "2026-13-45" })).toContain("วันที่ไม่ถูกต้อง");
  });

  it("รวบทุก error ในรอบเดียว ไม่ให้แก้ทีละอัน", () => {
    const errors = expectErrors({ customerName: "", phone: "", courseId: "bls" });
    expect(errors).toHaveLength(3);
  });

  it("ทนต่อ body ที่ไม่ใช่ข้อมูลที่คาดไว้ ไม่ throw", () => {
    expect(validateCourseSale({}).ok).toBe(false);
    expect(validateCourseSale({ customerName: 123, phone: null }).ok).toBe(false);
  });
});

describe("todayInBangkok", () => {
  it("ใช้เวลาไทย ไม่ใช่ UTC", () => {
    // 20 ก.ย. 23:30 UTC = 21 ก.ย. 06:30 ที่กรุงเทพ — ยอดขายตอนเย็นต้องไม่
    // ถูกบันทึกเป็นวันถัดไปเพราะ Vercel รันบน UTC
    expect(todayInBangkok(new Date("2026-09-20T23:30:00Z"))).toBe("2026-09-21");
    expect(todayInBangkok(new Date("2026-09-20T16:00:00Z"))).toBe("2026-09-20");
    expect(todayInBangkok(new Date("2026-09-20T17:00:00Z"))).toBe("2026-09-21");
  });
});

describe("courseSaleEventId", () => {
  it("ผูกกับ row id เพื่อให้ dedup ได้ถ้ายิงซ้ำ", () => {
    expect(courseSaleEventId(42)).toBe("course_sale:42");
    expect(courseSaleEventId(42)).toBe(courseSaleEventId("42"));
  });

  it("คนละ sale ต้องได้คนละ id", () => {
    expect(courseSaleEventId(1)).not.toBe(courseSaleEventId(2));
  });
});
