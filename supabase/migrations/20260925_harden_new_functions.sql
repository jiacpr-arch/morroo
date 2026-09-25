-- Tighten function grants flagged by the Supabase security advisor after the
-- 20260925_* migrations (Supabase grants EXECUTE on new public functions to
-- anon/authenticated by default, which REVOKE ... FROM PUBLIC doesn't undo).
--
-- * is_org_member / is_org_owner: RLS policies on organizations /
--   organization_members call them as the signed-in user, so authenticated
--   keeps EXECUTE; anon has no use for them.
-- * Trigger functions: Postgres doesn't check EXECUTE when firing a trigger,
--   so nobody needs to call them directly via /rest/v1/rpc.
-- * mcq_comments_stamp_edit: pin search_path like the other functions.

REVOKE EXECUTE ON FUNCTION public.is_org_member(uuid) FROM anon;
REVOKE EXECUTE ON FUNCTION public.is_org_owner(uuid)  FROM anon;

REVOKE EXECUTE ON FUNCTION public.mcq_comments_check_parent()    FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.mcq_comment_votes_sync()       FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.mcq_comment_reports_autohide() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.mcq_comments_stamp_edit()      FROM PUBLIC, anon, authenticated;

ALTER FUNCTION public.mcq_comments_stamp_edit() SET search_path = public;
