const q = require('./all_questions.json');
console.log('Total:', q.length);
for (let i = 240; i < 260; i++) {
  const x = q[i];
  if (!x) { console.log(i, 'UNDEFINED'); continue; }
  console.log(JSON.stringify({ idx: i, id: x.id, correct_answer: x.correct_answer, scenario: x.scenario, choices: x.choices }));
}
