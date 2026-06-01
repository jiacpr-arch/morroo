import { describe, it, expect } from "vitest";
import { normalizeImageUrl } from "./image-url";

describe("normalizeImageUrl", () => {
  it("แปลงลิงก์แชร์ /file/d/.../view เป็น direct link", () => {
    expect(
      normalizeImageUrl(
        "https://drive.google.com/file/d/1A2B3C4D5E6F/view?usp=sharing"
      )
    ).toBe("https://drive.google.com/uc?export=view&id=1A2B3C4D5E6F");
  });

  it("แปลงลิงก์แบบ open?id=", () => {
    expect(
      normalizeImageUrl("https://drive.google.com/open?id=1A2B3C4D5E6F")
    ).toBe("https://drive.google.com/uc?export=view&id=1A2B3C4D5E6F");
  });

  it("ตัดช่องว่างหัวท้ายก่อนแปลง", () => {
    expect(
      normalizeImageUrl("  https://drive.google.com/file/d/XYZ_123/view  ")
    ).toBe("https://drive.google.com/uc?export=view&id=XYZ_123");
  });

  it("คง direct link ของ Drive ไว้เหมือนเดิม", () => {
    const direct = "https://drive.google.com/uc?export=view&id=ABC123";
    expect(normalizeImageUrl(direct)).toBe(direct);
  });

  it("ไม่แตะลิงก์ที่ไม่ใช่ Drive", () => {
    const cloudinary = "https://res.cloudinary.com/demo/image/upload/sample.jpg";
    expect(normalizeImageUrl(cloudinary)).toBe(cloudinary);
  });

  it("คืนค่าเดิมเมื่อเป็นค่าว่าง", () => {
    expect(normalizeImageUrl("")).toBe("");
  });
});
