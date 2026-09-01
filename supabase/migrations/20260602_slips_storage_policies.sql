-- Storage RLS policies for the private "slips" bucket.
--
-- Root cause of "สลิปไม่อัพเดท": the slips bucket had RLS enabled but ZERO
-- policies, so every authenticated upload was denied. Bank-transfer payment
-- orders silently fell back to a "pending-upload-..." placeholder slip_url and
-- admins could never see the slip. These policies restore uploads/reads.
--
-- Upload path convention (app/payment/[plan]/page.tsx): "<user_id>/<timestamp>.<ext>"
-- so the first path segment identifies the owner.

-- Users can upload slips into their own folder
DROP POLICY IF EXISTS "Users can upload own slips" ON storage.objects;
CREATE POLICY "Users can upload own slips"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'slips'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can view their own slips
DROP POLICY IF EXISTS "Users can view own slips" ON storage.objects;
CREATE POLICY "Users can view own slips"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'slips'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Admins can view every slip (needed for the admin payments review screen)
DROP POLICY IF EXISTS "Admins can view all slips" ON storage.objects;
CREATE POLICY "Admins can view all slips"
  ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'slips'
    AND auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );
