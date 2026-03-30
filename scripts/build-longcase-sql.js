// Build SQL INSERT for Long Case from JSON data
const data = JSON.parse(require('fs').readFileSync('case_data.json', 'utf8'));

const escape = (s) => typeof s === 'string' ? s.replace(/'/g, "''") : s;
const jsonStr = (obj) => escape(JSON.stringify(obj));

const sql = `INSERT INTO public.long_cases (
  title, specialty, difficulty, week_number, is_weekly,
  published_at,
  patient_info, history_script, pe_findings, lab_results,
  correct_diagnosis, accepted_ddx, management_plan, teaching_points,
  examiner_questions, scoring_rubric
) VALUES (
  '${escape(data.title)}',
  '${escape(data.specialty)}',
  '${escape(data.difficulty)}',
  ${data.week_number},
  TRUE,
  NOW() + INTERVAL '1 day',
  '${jsonStr(data.patient_info)}',
  '${jsonStr(data.history_script)}',
  '${jsonStr(data.pe_findings)}',
  '${jsonStr(data.lab_results)}',
  '${escape(data.correct_diagnosis)}',
  '${jsonStr(data.accepted_ddx)}',
  '${escape(data.management_plan)}',
  '${jsonStr(data.teaching_points)}',
  '${jsonStr(data.examiner_questions)}',
  '${jsonStr(data.scoring_rubric)}'
);`;

require('fs').writeFileSync('insert.sql', sql);
console.log('SQL generated for: ' + data.title);
