-- Link chat_messages to leads + register 'line_oa' as a valid lead source.
--
-- Phase 1 of bot↔CRM integration: every Messenger/LINE webhook turn now
-- attaches to a lead row so the admin pipeline view shows real conversations
-- (not just form-captured leads).

-- ─── chat_messages.lead_id ───────────────────────────────────────────────
ALTER TABLE chat_messages
  ADD COLUMN IF NOT EXISTS lead_id uuid REFERENCES leads(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS chat_messages_lead_idx
  ON chat_messages (lead_id, created_at DESC) WHERE lead_id IS NOT NULL;

-- ─── leads.source: allow 'line_oa' ───────────────────────────────────────
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'leads_source_check') THEN
    ALTER TABLE leads DROP CONSTRAINT leads_source_check;
  END IF;
  ALTER TABLE leads ADD CONSTRAINT leads_source_check
    CHECK (source IN ('fb_leadgen_form','fb_messenger','line_oa','landing','organic','admin'));
END $$;

-- ─── leads: index for fast PSID / LINE userId lookup on webhook hot path ─
CREATE INDEX IF NOT EXISTS leads_fb_psid_idx ON leads(fb_psid) WHERE fb_psid IS NOT NULL;
CREATE INDEX IF NOT EXISTS leads_line_user_id_idx ON leads(line_user_id) WHERE line_user_id IS NOT NULL;
