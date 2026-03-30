// Build SQL INSERT for MCQ questions from JSON data
const data = JSON.parse(require('fs').readFileSync('mcq_data.json', 'utf8'));

const escape = (s) => typeof s === 'string' ? s.replace(/'/g, "''") : s;

let sql = '-- Auto-generated MCQ questions\n\n';

for (const q of data.questions) {
  const choicesJSON = escape(JSON.stringify(q.choices));
  const detailedJSON = q.detailed_explanation ? escape(JSON.stringify(q.detailed_explanation)) : null;

  sql += `INSERT INTO public.mcq_questions (subject_id, exam_type, exam_source, scenario, choices, correct_answer, explanation, detailed_explanation, difficulty, is_ai_enhanced, ai_notes, status)
VALUES (
  (SELECT id FROM public.mcq_subjects WHERE name = '${escape(q.subject)}' LIMIT 1),
  '${escape(q.exam_type || 'NL2')}',
  'AI-generated',
  '${escape(q.scenario)}',
  '${choicesJSON}',
  '${escape(q.correct_answer)}',
  '${escape(q.explanation)}',
  ${detailedJSON ? "'" + detailedJSON + "'" : 'NULL'},
  '${escape(q.difficulty)}',
  true,
  'auto-generated ${new Date().toISOString().split('T')[0]}',
  'active'
);\n\n`;
}

require('fs').writeFileSync('insert_mcq.sql', sql);
console.log('SQL generated for ' + data.questions.length + ' MCQ questions');
