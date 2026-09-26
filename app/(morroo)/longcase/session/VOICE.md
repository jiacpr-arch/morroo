# Long Case device voice

Scope: only `/longcase/session`. No server routes, model IDs, scoring, database
schema, billing, or other product pages are changed.

## Behavior

### Patient conversation (History only)

- Explicit Start opts into automatically sending finalized questions after a
  pause without recognition updates: 5 seconds by default, selectable 2/3/5 s
  so students can think mid-question. Existing drafts must first be sent or
  cleared. The manual dictation workflow remains available.
- Silence alone does not end the conversation: a `no-speech` result, an engine
  ending with nothing heard, or the 60 s guard with an empty draft reopens the
  mic. After 2 minutes with no question the loop stops.
- Local Thai recognition is the default. A separate, initially unchecked
  consent permits the browser recognition service; no silent remote fallback.
- Device voice gives a readiness prompt, then the microphone opens. Recognition
  must end before sending via the unchanged patient text endpoint. A completed
  successful reply is spoken using the selected local Thai voice; only after
  playback ends plus a 400 ms gap does listening restart. No speech interruption.
- Stop, phase changes, pagehide, hidden tabs and unmount cancel the loop. Unsent
  recognition is preserved in the draft, never submitted after cancellation.
  An already sent request may still complete as text, but will not speak/restart.
- AI errors, unavailable/denied mic, incomplete recognition and playback errors
  stop the loop; no automatic AI retries. Guards: 60s listening/setup, 2.5s mic
  stop, 45s per playback chunk, 90s patient request. Each turn uses the existing
  AI quota; speech itself adds no paid audio API. Real device support varies.

### Manual controls

- Microphone controls in History, DDx, Management and Examiner append finalized
  Thai dictation to the existing draft. Interim text is shown separately. Editing
  while listening is preserved; repeated final recognition events are ignored.
- The user stops the microphone and reviews the draft before sending. The same
  existing text endpoint and save payload are used. No audio endpoint is added.
- Recognition defaults to local-only, and checks `processLocally` plus availability
  of `th-TH` before starting. If unavailable, suggest the device keyboard's mic.
  The browser's potentially remote recognition service requires an explicit,
  initially unchecked consent box. Consent is not stored across visits/phases.
- Read buttons and optional auto-read use only installed Thai voices marked
  `localService`. There is no fallback to remote voices or a paid TTS API.
- Auto-read defaults off. It reads only complete successful new AI replies, not
  saved history or streaming fragments. Users can replay or stop, select a local
  Thai voice, and choose 0.8x/1x/1.2x speed.
- Microphone sessions stop after 60 seconds and abort on unmount/tab hiding.
  Speech stops on phase changes, tab hiding, leaving the page and microphone start.
- If unsupported, normal typing and text replies remain usable. Native keyboard
  dictation is controlled by the OS and may itself require internet depending on
  the device/language. Do not claim all recognition is offline.

## Verification

```sh
npx vitest run 'app/(morroo)/longcase/session/device-speech.test.ts'
npx tsc --noEmit -p e2e/longcase-voice.tsconfig.json
npx playwright test --config=e2e/longcase-voice.config.ts
```

The browser tests mount the real session page with mocked speech engines and
text endpoints in a localhost-only Vite harness. No real microphone, production
session, or AI credit is used. Manually verify real Thai voices/recognition on
the intended Chrome, Safari/iPhone and Android devices before production rollout.

Conversation regression coverage includes multiple automatic turns, duplicate
recognition, mic/playback exclusion, Stop before submission, Stop during a pending
reply, AI failure, playback failure, separate remote consent, incomplete interim
results, phase change and pagehide. These tests do not certify hardware audio.

Manual checks: grant/deny mic access, missing local Thai language/voice, keyboard
dictation, edit and send transcript, replay/stop a long reply, automatic playback,
change phase/leave page while listening, and use the page without speech support.

Full-project TypeScript currently reports pre-existing errors outside Long Case
(school enrichment, ACLS/EKG, school queries, and LLM test environment typings).
The focused Long Case typecheck must pass independently of `ignoreBuildErrors`.
