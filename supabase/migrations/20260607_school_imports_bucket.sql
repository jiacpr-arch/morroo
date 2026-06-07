-- Storage bucket for transient PDF uploads during admin school-import.
--
-- The admin browser uploads a PDF directly to this bucket (bypassing Vercel's
-- serverless body limit for large files), then the import API downloads it
-- server-side, sends it to Claude for extraction, and deletes it.
--
-- Files are NOT publicly readable — only admins can upload/read via authed
-- Supabase client calls. The service-role key bypasses RLS for server-side
-- download+delete inside the import route.

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'school-imports',
  'school-imports',
  false,
  104857600,  -- 100 MB per file
  ARRAY['application/pdf']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Admins can upload PDFs into this bucket (path convention: any name)
DROP POLICY IF EXISTS "Admins can upload school imports" ON storage.objects;
CREATE POLICY "Admins can upload school imports"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'school-imports'
    AND auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );

-- Admins can read their own uploads (used by the signed upload flow)
DROP POLICY IF EXISTS "Admins can read school imports" ON storage.objects;
CREATE POLICY "Admins can read school imports"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'school-imports'
    AND auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );

-- Admins can delete their own uploads (cleanup after processing)
DROP POLICY IF EXISTS "Admins can delete school imports" ON storage.objects;
CREATE POLICY "Admins can delete school imports"
  ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id = 'school-imports'
    AND auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );
