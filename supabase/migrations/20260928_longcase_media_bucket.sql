-- Bucket เก็บรูปผลตรวจของ Long Case (ECG / CXR ฯลฯ)
-- public read ผ่าน public URL (ชื่อไฟล์เป็น UUID สุ่ม ไม่บอกโรค);
-- upload ผ่าน service role ใน /api/admin/longcases/media เท่านั้น
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'longcase-media',
  'longcase-media',
  true,
  4194304, -- 4 MB
  array['image/webp', 'image/png', 'image/jpeg']::text[]
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;
