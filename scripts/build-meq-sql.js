// Build SQL INSERT for MEQ from JSON data
const data = JSON.parse(require('fs').readFileSync('meq_data.json', 'utf8'));
const escape = (s) => typeof s === 'string' ? s.replace(/'/g, "''") : s;

const examId = require('crypto').randomUUID();
const exam = data.exam;

let sql = `-- MEQ: ${exam.title}
INSERT INTO public.exams (id, title, category, difficulty, status, is_free, publish_date, created_by)
VALUES (
  '${examId}',
  '${escape(exam.title)}',
  '${escape(exam.category)}',
  '${escape(exam.difficulty)}',
  'published',
  ${exam.is_free || false},
  CURRENT_DATE,
  'ai-generated'
);\n\n`;

for (const part of data.parts) {
  const keyPointsArr = part.key_points.map(k => escape(k));
  const keyPointsSQL = keyPointsArr.map(k => `'${k}'`).join(', ');

  sql += `INSERT INTO public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
VALUES (
  '${examId}',
  ${part.part_number},
  '${escape(part.title)}',
  '${escape(part.scenario)}',
  '${escape(part.question)}',
  '${escape(part.answer)}',
  ARRAY[${keyPointsSQL}],
  ${part.time_minutes || 10}
);\n\n`;
}

require('fs').writeFileSync('insert_meq.sql', sql);
console.log('SQL generated for: ' + exam.title + ' (' + data.parts.length + ' parts)');
