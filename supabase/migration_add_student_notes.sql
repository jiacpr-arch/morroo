-- Migration: Add student_notes column to long_case_sessions
-- This stores the student's personal notes/scratchpad during a case

ALTER TABLE public.long_case_sessions
ADD COLUMN IF NOT EXISTS student_notes TEXT;
