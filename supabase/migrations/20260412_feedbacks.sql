CREATE TABLE IF NOT EXISTS feedbacks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text DEFAULT 'other',
  rating int,
  message text NOT NULL,
  email text,
  created_at timestamptz DEFAULT now()
);
