// แปลงลิงก์แชร์ Google Drive ให้กลายเป็น "direct link" ที่เอาไปแสดงเป็นรูปได้จริง
//
// ลิงก์ที่ Drive ให้มาตอนกดแชร์ เช่น
//   https://drive.google.com/file/d/FILE_ID/view?usp=sharing
//   https://drive.google.com/open?id=FILE_ID
// จะชี้ไป "หน้าเว็บ Drive" ไม่ใช่ตัวไฟล์รูป — เอาไปใส่ <img> แล้วไม่ขึ้น
// ฟังก์ชันนี้สลับให้เป็น
//   https://drive.google.com/uc?export=view&id=FILE_ID
// ซึ่งชี้ตรงไปที่ไฟล์รูป (ต้องตั้งแชร์ไฟล์เป็น "Anyone with the link" ด้วย)
//
// ลิงก์ที่ไม่ใช่ Drive (Cloudinary / IG / อื่นๆ) หรือ Drive direct-link อยู่แล้ว
// จะคืนค่าเดิมโดยไม่แก้

const DRIVE_FILE_PATH = /drive\.google\.com\/file\/d\/([A-Za-z0-9_-]+)/;
const DRIVE_OPEN_QUERY = /drive\.google\.com\/(?:open|uc)\?[^#]*\bid=([A-Za-z0-9_-]+)/;

export function normalizeImageUrl(input: string): string {
  const url = input.trim();
  if (!url) return input;

  // เป็น direct link ของ Drive อยู่แล้ว — ไม่ต้องแปลง
  if (/drive\.google\.com\/uc\?export=view/.test(url)) return url;

  const fileId =
    url.match(DRIVE_FILE_PATH)?.[1] ?? url.match(DRIVE_OPEN_QUERY)?.[1];
  if (fileId) {
    return `https://drive.google.com/uc?export=view&id=${fileId}`;
  }

  // ไม่ใช่ลิงก์ Drive — คืนค่าเดิม (ตัดช่องว่างหัวท้ายให้)
  return url;
}
