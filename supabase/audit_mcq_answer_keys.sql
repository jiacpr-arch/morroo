-- ============================================================
-- Audit: หา MCQ ที่เฉลย (correct_answer) ไม่ตรงกับ
-- detailed_explanation.choices[*].is_correct
-- ============================================================
-- รันใน Supabase SQL Editor — ผลลัพธ์เป็นรายการข้อที่ต้องตรวจด้วยมือ
-- หลังจาก import เฉลยละเอียดแล้ว เราคาดว่า correct_answer ของ
-- mcq_questions ต้อง "ตรง" กับ label ของตัวเลือกที่ is_correct = true
-- ใน detailed_explanation เท่านั้น ข้อที่ไม่ตรง = น่าสงสัยว่าเฉลยผิด
-- ============================================================

-- 1) ข้อที่ correct_answer ไม่มีอยู่ใน choices เลย (label เพี้ยน)
SELECT
  q.id,
  q.exam_type,
  q.exam_source,
  q.question_number,
  q.correct_answer                       AS stored_answer,
  jsonb_path_query_array(q.choices, '$[*].label') AS available_labels,
  LEFT(q.scenario, 120)                  AS scenario_preview
FROM public.mcq_questions q
WHERE q.status = 'active'
  AND NOT EXISTS (
    SELECT 1
      FROM jsonb_array_elements(q.choices) c
     WHERE c->>'label' = q.correct_answer
  )
ORDER BY q.exam_source NULLS LAST, q.question_number;

-- 2) ข้อที่ correct_answer ไม่ตรงกับตัวเลือกที่ is_correct=true
--    ใน detailed_explanation (มี explanation ละเอียดแต่เฉลยเพี้ยน)
SELECT
  q.id,
  q.exam_type,
  q.exam_source,
  q.question_number,
  q.correct_answer                           AS stored_answer,
  (
    SELECT string_agg(c->>'label', ',')
      FROM jsonb_array_elements(q.detailed_explanation->'choices') c
     WHERE (c->>'is_correct')::boolean = true
  )                                          AS explained_correct_labels,
  LEFT(q.scenario, 120)                      AS scenario_preview
FROM public.mcq_questions q
WHERE q.status = 'active'
  AND q.detailed_explanation IS NOT NULL
  AND q.detailed_explanation ? 'choices'
  AND NOT EXISTS (
    SELECT 1
      FROM jsonb_array_elements(q.detailed_explanation->'choices') c
     WHERE (c->>'is_correct')::boolean = true
       AND c->>'label' = q.correct_answer
  )
ORDER BY q.exam_source NULLS LAST, q.question_number;

-- 3) ข้อที่ detailed_explanation มีตัวเลือกที่ is_correct=true มากกว่า 1 label
--    (ไม่มี single-answer ที่ชัดเจน)
SELECT
  q.id,
  q.exam_type,
  q.exam_source,
  q.question_number,
  q.correct_answer,
  (
    SELECT string_agg(c->>'label', ',')
      FROM jsonb_array_elements(q.detailed_explanation->'choices') c
     WHERE (c->>'is_correct')::boolean = true
  ) AS marked_correct_labels
FROM public.mcq_questions q
WHERE q.status = 'active'
  AND q.detailed_explanation IS NOT NULL
  AND q.detailed_explanation ? 'choices'
  AND (
    SELECT COUNT(*) FILTER (WHERE (c->>'is_correct')::boolean = true)
      FROM jsonb_array_elements(q.detailed_explanation->'choices') c
  ) <> 1;

-- 4) Top questions ที่ผู้ใช้เคยแจ้งว่าเฉลยผิด (หลังเปิดใช้ระบบ report)
SELECT
  r.question_id,
  COUNT(*)                                       AS report_count,
  COUNT(*) FILTER (WHERE r.status = 'confirmed') AS confirmed_count,
  array_agg(DISTINCT r.suggested_answer)
    FILTER (WHERE r.suggested_answer IS NOT NULL) AS suggested_answers,
  q.correct_answer                               AS current_answer,
  q.exam_source,
  q.question_number
FROM public.mcq_question_reports r
JOIN public.mcq_questions q ON q.id = r.question_id
WHERE r.reason = 'wrong_answer'
GROUP BY r.question_id, q.correct_answer, q.exam_source, q.question_number
HAVING COUNT(*) >= 1
ORDER BY report_count DESC, confirmed_count DESC;
