-- ============================================================
-- Per-question discussion threads for MCQ (with moderation)
-- ============================================================
-- Students who have answered a question can discuss it underneath the
-- explanation. One level of replies (parent_id → top-level comment only),
-- upvotes, and community reports. A comment is auto-hidden once it gets
-- ≥3 reports; admins can unhide/hide/delete from /admin/mcq/comments.
--
-- Write model:
--   * Normal users go through /api/mcq/comments* with their own session, so
--     RLS + column-level GRANTs below are the real guard: a user can only
--     write body/parent/question on insert and body/edited_at on update —
--     never status or upvotes.
--   * upvotes is a denormalised counter maintained by a SECURITY DEFINER
--     trigger on mcq_comment_votes.
--   * status changes (hide/unhide) happen only via the admin UI (service
--     role) or the auto-hide trigger.
-- ============================================================

-- 1) Comments -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mcq_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES public.mcq_questions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parent_id uuid REFERENCES public.mcq_comments(id) ON DELETE CASCADE,
  body text NOT NULL CHECK (char_length(btrim(body)) BETWEEN 1 AND 2000),
  created_at timestamptz NOT NULL DEFAULT now(),
  edited_at timestamptz,
  status text NOT NULL DEFAULT 'visible' CHECK (status IN ('visible', 'hidden')),
  upvotes int NOT NULL DEFAULT 0 CHECK (upvotes >= 0),
  -- Set by an admin when they review the comment (hide/unhide). Auto-hide
  -- only counts reports filed after this moment, so an unhidden comment
  -- isn't immediately re-hidden by the reports the admin already dismissed.
  moderated_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_mcq_comments_question ON public.mcq_comments(question_id, created_at);
CREATE INDEX IF NOT EXISTS idx_mcq_comments_parent   ON public.mcq_comments(parent_id);
CREATE INDEX IF NOT EXISTS idx_mcq_comments_user     ON public.mcq_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_mcq_comments_hidden   ON public.mcq_comments(status) WHERE status = 'hidden';

-- 1a) Enforce one level of replies + same question as the parent.
CREATE OR REPLACE FUNCTION public.mcq_comments_check_parent()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  p record;
BEGIN
  IF NEW.parent_id IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT question_id, parent_id, status INTO p
    FROM public.mcq_comments
   WHERE id = NEW.parent_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'parent comment not found' USING ERRCODE = '23503';
  END IF;
  IF p.status <> 'visible' THEN
    RAISE EXCEPTION 'cannot reply to a hidden comment' USING ERRCODE = '23514';
  END IF;
  IF p.parent_id IS NOT NULL THEN
    RAISE EXCEPTION 'replies can only be one level deep' USING ERRCODE = '23514';
  END IF;
  IF p.question_id <> NEW.question_id THEN
    RAISE EXCEPTION 'reply must belong to the same question' USING ERRCODE = '23514';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_comments_check_parent ON public.mcq_comments;
CREATE TRIGGER trg_mcq_comments_check_parent
  BEFORE INSERT ON public.mcq_comments
  FOR EACH ROW EXECUTE FUNCTION public.mcq_comments_check_parent();

-- 1b) Stamp edited_at whenever the body changes (users can't forge it).
CREATE OR REPLACE FUNCTION public.mcq_comments_stamp_edit()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.body IS DISTINCT FROM OLD.body THEN
    NEW.edited_at := now();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_comments_stamp_edit ON public.mcq_comments;
CREATE TRIGGER trg_mcq_comments_stamp_edit
  BEFORE UPDATE ON public.mcq_comments
  FOR EACH ROW EXECUTE FUNCTION public.mcq_comments_stamp_edit();

-- 2) Votes ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mcq_comment_votes (
  comment_id uuid NOT NULL REFERENCES public.mcq_comments(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (comment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_mcq_comment_votes_user ON public.mcq_comment_votes(user_id);

CREATE OR REPLACE FUNCTION public.mcq_comment_votes_sync()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.mcq_comments
       SET upvotes = upvotes + 1
     WHERE id = NEW.comment_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.mcq_comments
       SET upvotes = GREATEST(upvotes - 1, 0)
     WHERE id = OLD.comment_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_comment_votes_sync ON public.mcq_comment_votes;
CREATE TRIGGER trg_mcq_comment_votes_sync
  AFTER INSERT OR DELETE ON public.mcq_comment_votes
  FOR EACH ROW EXECUTE FUNCTION public.mcq_comment_votes_sync();

-- 3) Reports --------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.mcq_comment_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  comment_id uuid NOT NULL REFERENCES public.mcq_comments(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Keep in sync with COMMENT_REPORT_REASONS in lib/mcq-comments.ts
  reason text NOT NULL CHECK (reason IN (
    'spam', 'offensive', 'spoiler', 'misinformation', 'other'
  )),
  created_at timestamptz NOT NULL DEFAULT now(),
  -- One report per user per comment — stops a single user from hiding
  -- a comment on their own.
  UNIQUE (comment_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_mcq_comment_reports_comment ON public.mcq_comment_reports(comment_id, created_at);

-- 3a) Auto-hide at ≥3 reports (since the last admin review).
CREATE OR REPLACE FUNCTION public.mcq_comment_reports_autohide()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  c record;
  report_count int;
BEGIN
  SELECT status, moderated_at INTO c
    FROM public.mcq_comments
   WHERE id = NEW.comment_id;

  IF NOT FOUND OR c.status <> 'visible' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*) INTO report_count
    FROM public.mcq_comment_reports
   WHERE comment_id = NEW.comment_id
     AND (c.moderated_at IS NULL OR created_at > c.moderated_at);

  IF report_count >= 3 THEN
    UPDATE public.mcq_comments
       SET status = 'hidden'
     WHERE id = NEW.comment_id
       AND status = 'visible';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_comment_reports_autohide ON public.mcq_comment_reports;
CREATE TRIGGER trg_mcq_comment_reports_autohide
  AFTER INSERT ON public.mcq_comment_reports
  FOR EACH ROW EXECUTE FUNCTION public.mcq_comment_reports_autohide();

-- 4) Privileges -----------------------------------------------------------
-- Column-level grants: RLS decides *which rows*, these decide *which
-- columns*. Users never get to write status / upvotes / moderated_at —
-- moderation (hide/unhide) goes through the service role in
-- /api/admin/mcq/comments, which bypasses both RLS and these grants.
REVOKE ALL ON public.mcq_comments FROM anon, authenticated;
GRANT SELECT, DELETE ON public.mcq_comments TO authenticated;
GRANT INSERT (question_id, user_id, parent_id, body) ON public.mcq_comments TO authenticated;
GRANT UPDATE (body) ON public.mcq_comments TO authenticated;

REVOKE ALL ON public.mcq_comment_votes FROM anon, authenticated;
GRANT SELECT, INSERT, DELETE ON public.mcq_comment_votes TO authenticated;

REVOKE ALL ON public.mcq_comment_reports FROM anon, authenticated;
GRANT SELECT ON public.mcq_comment_reports TO authenticated;
GRANT INSERT (comment_id, user_id, reason) ON public.mcq_comment_reports TO authenticated;

-- 5) RLS ------------------------------------------------------------------
ALTER TABLE public.mcq_comments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_comment_votes   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_comment_reports ENABLE ROW LEVEL SECURITY;

-- Comments: signed-in users read visible comments; authors also see their
-- own hidden ones (so they know why a comment vanished); admins see all.
DROP POLICY IF EXISTS "Signed-in read visible comments" ON public.mcq_comments;
CREATE POLICY "Signed-in read visible comments"
  ON public.mcq_comments FOR SELECT
  TO authenticated
  USING (status = 'visible' OR user_id = auth.uid());

DROP POLICY IF EXISTS "Users insert own comments" ON public.mcq_comments;
CREATE POLICY "Users insert own comments"
  ON public.mcq_comments FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Editing a hidden comment is blocked so authors can't swap in new text to
-- sneak it past moderation.
DROP POLICY IF EXISTS "Users edit own visible comments" ON public.mcq_comments;
CREATE POLICY "Users edit own visible comments"
  ON public.mcq_comments FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid() AND status = 'visible')
  WITH CHECK (user_id = auth.uid() AND status = 'visible');

DROP POLICY IF EXISTS "Users delete own comments" ON public.mcq_comments;
CREATE POLICY "Users delete own comments"
  ON public.mcq_comments FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Admins manage comments" ON public.mcq_comments;
CREATE POLICY "Admins manage comments"
  ON public.mcq_comments FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'))
  WITH CHECK (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- Votes: own rows only, and only on visible comments.
DROP POLICY IF EXISTS "Users read own votes" ON public.mcq_comment_votes;
CREATE POLICY "Users read own votes"
  ON public.mcq_comment_votes FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Users vote on visible comments" ON public.mcq_comment_votes;
CREATE POLICY "Users vote on visible comments"
  ON public.mcq_comment_votes FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.mcq_comments c
       WHERE c.id = comment_id AND c.status = 'visible'
    )
  );

DROP POLICY IF EXISTS "Users remove own votes" ON public.mcq_comment_votes;
CREATE POLICY "Users remove own votes"
  ON public.mcq_comment_votes FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

-- Reports: users file/see their own; admins see all.
DROP POLICY IF EXISTS "Users read own comment reports" ON public.mcq_comment_reports;
CREATE POLICY "Users read own comment reports"
  ON public.mcq_comment_reports FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Users report visible comments" ON public.mcq_comment_reports;
CREATE POLICY "Users report visible comments"
  ON public.mcq_comment_reports FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.mcq_comments c
       WHERE c.id = comment_id AND c.status = 'visible'
    )
  );

DROP POLICY IF EXISTS "Admins manage comment reports" ON public.mcq_comment_reports;
CREATE POLICY "Admins manage comment reports"
  ON public.mcq_comment_reports FOR ALL
  TO authenticated
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'))
  WITH CHECK (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));
