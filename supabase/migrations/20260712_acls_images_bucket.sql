-- Public storage bucket for ACLS/BLS course images (lesson step images,
-- Q&A Deep covers/infographics, AI-generated student-question images).
-- Same bucket name as the old emr-ai-clinic project so copied object paths
-- keep working after the URL-domain rewrite.
--
-- Reads are public (public bucket URL); uploads/deletes happen only through
-- admin API routes / the AI pipeline using the service-role key, so no
-- storage.objects policies are granted to clients.

INSERT INTO storage.buckets (id, name, public)
VALUES ('acls-images', 'acls-images', true)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;
