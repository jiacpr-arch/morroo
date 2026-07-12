import { test, expect } from 'vitest'
import { postTest, preTest } from '@/lib/firstaid/content/exams'
import { scoreExam, POST_PASSING } from './examKey'

interface Q {
  id: string
  correctId: string
}
interface Exam {
  questions: Q[]
}

const post = postTest as Exam
const pre = preTest as Exam

const allCorrect = (exam: Exam) =>
  Object.fromEntries(exam.questions.map((q) => [q.id, q.correctId]))
const allWrong = (exam: Exam) =>
  Object.fromEntries(exam.questions.map((q) => [q.id, '__nope__']))

test('scoreExam gives 100 and passes when every post-test answer is correct', () => {
  const r = scoreExam('post', allCorrect(post))
  expect(r.score).toBe(100)
  expect(r.correctCount).toBe(post.questions.length)
  expect(r.passed).toBe(true)
})

test('scoreExam gives 0 and fails for all-wrong answers (forgery attempt)', () => {
  const r = scoreExam('post', allWrong(post))
  expect(r.score).toBe(0)
  expect(r.passed).toBe(false)
})

test('scoreExam ignores unknown answer maps — empty object never passes', () => {
  // This is the closed forgery hole: a caller who cannot supply real correct
  // answers cannot reach a passing score no matter what score they *claim*.
  expect(scoreExam('post', {}).passed).toBe(false)
  expect(scoreExam('post', null).passed).toBe(false)
})

test('scoreExam enforces the 80% post-test threshold', () => {
  const answers: Record<string, string> = {}
  const need = Math.ceil((POST_PASSING / 100) * post.questions.length)
  // Answer exactly (need - 1) correctly → should still fail.
  post.questions.slice(0, need - 1).forEach((q) => {
    answers[q.id] = q.correctId
  })
  expect(scoreExam('post', answers).passed).toBe(false)
  // One more correct → passes.
  answers[post.questions[need - 1].id] = post.questions[need - 1].correctId
  expect(scoreExam('post', answers).passed).toBe(true)
})

test('scoreExam scores the pre-test (informational, no passing threshold)', () => {
  const r = scoreExam('pre', allCorrect(pre))
  expect(r.score).toBe(100)
  expect(r.totalQuestions).toBe(pre.questions.length)
})

test('scoreExam throws on an unknown exam kind', () => {
  expect(() => scoreExam('midterm', {})).toThrow(/unknown exam kind/)
})
