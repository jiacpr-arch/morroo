import { test, expect } from 'vitest'
import { generateCertCode } from './certCode'

test('generateCertCode returns FA- prefix + 8 unambiguous chars', () => {
  const c = generateCertCode()
  expect(c).toMatch(/^FA-[2-9A-HJ-NP-Z]{8}$/)
})

test('two consecutive codes are different (probabilistic)', () => {
  const a = generateCertCode()
  const b = generateCertCode()
  expect(a).not.toEqual(b)
})
