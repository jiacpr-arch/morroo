import { test, expect } from 'vitest'
import { rateLimited, sanitizeLine, clientIp } from './rateLimit'

function reqFrom(ip: string): Request {
  return new Request('http://localhost/api/firstaid/test', {
    headers: { 'x-forwarded-for': ip },
  })
}

test('rateLimited allows up to the limit then blocks with 429', async () => {
  const ip = '203.0.113.7'
  const opts = { key: 'unit-a', limit: 3, windowMs: 60_000 }
  for (let i = 0; i < 3; i++) {
    expect(rateLimited(reqFrom(ip), opts), `hit ${i + 1} should pass`).toBeNull()
  }
  const blocked = rateLimited(reqFrom(ip), opts)
  expect(blocked).not.toBeNull()
  expect(blocked!.status).toBe(429)
  const body = (await blocked!.json()) as { error: string }
  expect(body.error).toMatch(/Too many requests/)
})

test('rateLimited tracks each client IP independently', () => {
  const opts = { key: 'unit-b', limit: 1, windowMs: 60_000 }
  expect(rateLimited(reqFrom('198.51.100.1'), opts)).toBeNull()
  expect(rateLimited(reqFrom('198.51.100.2'), opts)).toBeNull() // different IP, own bucket
})

test('clientIp takes the first x-forwarded-for hop and falls back to unknown', () => {
  expect(clientIp(reqFrom('203.0.113.9, 10.0.0.1'))).toBe('203.0.113.9')
  expect(clientIp(new Request('http://localhost/'))).toBe('unknown')
})

test('sanitizeLine collapses newlines/control chars and caps length', () => {
  expect(sanitizeLine('hello\nworld')).toBe('hello world')
  expect(sanitizeLine('a\t\r\n b')).toBe('a b')
  expect(sanitizeLine('x'.repeat(200)).length).toBe(80)
  expect(sanitizeLine(null)).toBe('')
  // No injected extra lines survive into a LINE message.
  expect(sanitizeLine('name\nโทร: 0000000')).not.toMatch(/\n/)
})
