# MorRoo หมอรู้

แพลตฟอร์มติวสอบแพทย์ออนไลน์ ([morroo.com](https://www.morroo.com)): ข้อสอบ MCQ / MEQ / Long Case ที่ AI ช่วยสร้างและตรวจ, เตรียมสอบบอร์ดเฉพาะทาง, บทเรียนสำหรับนักศึกษาแพทย์ Y1–Y6 และเกมจำลองกู้ชีพ แอป Next.js ตัวเดียวให้บริการหลายโดเมนย่อย (`firstaid.morroo.com`, `game.morroo.com`) โดยใช้ host rewrite ใน `middleware.ts`

## Product areas

Each route group under `app/` has its own root layout.

| Route group | Served at | What it is |
|---|---|---|
| `app/(morroo)` | `www.morroo.com` | Main site. Exam prep: `/nl` (National License MCQ), `/exams` (MEQ progressive cases), `/longcase` (Long Case with an AI patient and examiner), `/board` (specialty board MCQ), `/school` (Y1–Y6 micro-learning), `/learn`, `/blog`, `/study-plan`. Games: `/casegame`, `/sim` (Code Blue Sim), `/resus` (Resus Hero), `/acls-emr`, `/acls-reader`. Account and billing pages: `/login`, `/register`, `/onboarding`, `/dashboard`, `/profile`, `/pricing`, `/payment`, `/redeem`, `/invoice-request`. Back office at `/admin/*`. |
| `app/(firstaid)` | `firstaid.morroo.com` (internal path `/firstaid/*`) | First aid / BLS course for the general public: lessons, 8-stage BLS game, simulations, algorithms, pre/post-test and certificate. It works without a login (anonymous learner in localStorage) and has its own Meta pixel and PostHog. See `docs/firstaid-migration.md`. |
| `app/(games)` | `game.morroo.com` (internal path `/games`) | Games hub: one page that links to every game on `*.morroo.com`, grouped by audience. |
| `app/(liff)` | `/line/liff/*` | LINE LIFF landing page that links a LINE account and adds the OA as a friend (`NEXT_PUBLIC_LIFF_ID`). See `docs/spec-line-liff.md`. |
| `app/api` | `/api/*` | Route handlers for AI grading and chat, billing (Stripe webhook and reconcile), LINE and Facebook webhooks, analytics, and the cron endpoints. |

On localhost there is no subdomain, so open the internal paths directly (`/firstaid`, `/games`). `firstaid.localhost:3000` also works.

## Tech stack

- **Next.js 16.2** (App Router, built and run with `--webpack`), **React 19.2**, TypeScript
- **Supabase**: Postgres, Auth and RLS, through `@supabase/ssr` and `@supabase/supabase-js`. SQL lives in `supabase/` and `supabase/migrations/`
- **Tailwind CSS 4**, shadcn / Base UI, lucide-react, recharts
- **AI**: Anthropic Claude (`@anthropic-ai/sdk`). The content generators in `scripts/` can also use DeepSeek, Together AI and OpenAI
- **Payments**: Stripe, plus FlowAccount for tax invoices
- **Messaging**: LINE Messaging API, LINE Login and LIFF (`@line/liff`), Resend for email
- **Observability and analytics**: Sentry, PostHog, Vercel Analytics and Speed Insights, Meta Pixel and CAPI
- **Hosting**: Vercel, region `sin1` (`vercel.json`)
- **Tests**: Vitest for unit tests (`**/*.test.ts`) and Playwright for e2e (`e2e/`)

## Local development

Requires Node 24 (the version CI uses) and npm.

```bash
npm install
# create .env.local — see "Environment variables" below
npm run dev          # http://localhost:3000
```

The app starts even without Supabase configured. The server and browser Supabase clients (`lib/supabase/*.ts`) return mock "no user, empty data" results when `NEXT_PUBLIC_SUPABASE_ANON_KEY` is missing or still a placeholder. The middleware, though, needs *some* `NEXT_PUBLIC_SUPABASE_URL` and anon key value to start.

## Scripts

| Command | What it does |
|---|---|
| `npm run dev` / `build` / `start` | Next.js dev server, production build (then `next-sitemap` runs as `postbuild`), and production server |
| `npm run verify` | `lint` + `typecheck` + `test`. The same checks run in CI on every PR |
| `npm run lint` / `typecheck` / `test` | ESLint, `tsc --noEmit`, Vitest (`test:watch` for watch mode) |
| `npm run e2e` | Playwright tests in `e2e/` (see below). `npm run e2e:install` downloads Chromium |
| `npm run seed:boards` | Bulk-generate board MCQs for every active specialty (`scripts/seed-all-boards.ts`) |
| `npm run gen:casegames` | Turn Long Cases into case games, saved as drafts in `sim_scenarios` (`--dry-run`, `--limit N`, …) |
| `npm run gen:meqgames` | Turn MEQ exams into case games, saved as drafts |
| `npm run rebalance:simchoices` | Rewrite case-game choice labels so the right answer can't be guessed from its length |
| `npm run gen:figures` | Generate figures for School lessons and upload them to Supabase Storage |
| `npm run resplit:parts` | Re-split School lessons into short parts with mini quizzes |

The seed and generation scripts write to the production database. They need `SUPABASE_URL` (or `NEXT_PUBLIC_SUPABASE_URL`), `SUPABASE_SERVICE_ROLE_KEY` and `ANTHROPIC_API_KEY`, and most accept `--dry-run`. Read the header comment of each script before running it. The scheduled content generators (daily MCQ, board, MEQ, long case, blog) run as GitLab pipeline schedules; see `.gitlab-ci.yml`.

### E2E tests

```bash
npm run e2e                                  # starts `npm run dev` automatically
E2E_BASE_URL=https://<preview-url> npm run e2e   # run against a deployed site instead
```

- `E2E_SERVER_COMMAND`: the command Playwright uses to start the server (default `npm run dev`). CI sets it to `npm run start` so the tests hit the production build.
- `PW_EXECUTABLE_PATH`: path to an already-installed Chromium, for sandboxes that can't download browsers.

No spec needs secrets. They cover public pages and client-side games, and stub API calls with `page.route`. `e2e/longcase-voice.spec.ts` starts its own Vite server. In CI (`.github/workflows/verify.yml`, job `e2e`, pull requests only) the app is built and started with a placeholder `NEXT_PUBLIC_SUPABASE_URL` that points at a closed port and a dummy anon key, and the whole suite runs. When a run fails, the Playwright HTML report and traces are uploaded as the `playwright-report` artifact.

## Environment variables

Names only. The values are in Vercel project settings, or in `.env.local` for local work (git-ignored). The full list with comments is in `docs/full-system-blueprint.md` §8.

- **Supabase**: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (scripts also accept `SUPABASE_URL`)
- **Site**: `NEXT_PUBLIC_SITE_URL`
- **Auth / LINE**: `LINE_LOGIN_CHANNEL_ID`, `LINE_LOGIN_CHANNEL_SECRET`, `NEXT_PUBLIC_LIFF_ID`, `NEXT_PUBLIC_LINE_LOGIN_ENABLED`, `LINE_CHANNEL_ACCESS_TOKEN`, `LINE_CHANNEL_SECRET`, `LINE_CHANNEL_TOKEN`, `LINE_TARGET_ID`, `ADMIN_LINE_USER_ID`, `FIRSTAID_LINE_LOGIN_CHANNEL_ID`, `FIRSTAID_LINE_LOGIN_CHANNEL_SECRET`
- **Payments**: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `NEXT_PUBLIC_STRIPE_PROMPTPAY_ENABLED`, `FLOWACCOUNT_TOKEN_URL`, `FLOWACCOUNT_BASE_URL`, `FLOWACCOUNT_CLIENT_ID`, `FLOWACCOUNT_CLIENT_SECRET`
- **Email**: `RESEND_API_KEY`, `MAIL_FROM`, `ADMIN_EMAIL`
- **AI**: `ANTHROPIC_API_KEY`. Generators only: `DEEPSEEK_API_KEY`, `MCQ_GEN_PROVIDER`, `DEEPSEEK_MODEL`, `TOGETHER_API_KEY`, `OPENAI_API_KEY`
- **Facebook / Instagram / Meta ads**: `FACEBOOK_PAGE_ID`, `FACEBOOK_APP_ID`, `FACEBOOK_APP_SECRET`, `FACEBOOK_USER_TOKEN`, `FACEBOOK_PAGE_TOKEN`, `INSTAGRAM_BUSINESS_ACCOUNT_ID`, `META_AD_ACCOUNT_ID`, `META_SYSTEM_USER_TOKEN`, `META_CAPI_ACCESS_TOKEN` (see `docs/META_SYSTEM_USER_SETUP.md`)
- **Cron / internal endpoints**: `CRON_SECRET`, `BLOG_GENERATE_SECRET`
- **Observability / analytics**: `SENTRY_DSN`, `NEXT_PUBLIC_SENTRY_DSN`, `SENTRY_ORG`, `SENTRY_PROJECT` (the Sentry build plugin is enabled only when a DSN is set), `NEXT_PUBLIC_POSTHOG_KEY`, `NEXT_PUBLIC_POSTHOG_HOST`, `NEXT_PUBLIC_FIRSTAID_POSTHOG_KEY`, `NEXT_PUBLIC_FIRSTAID_POSTHOG_HOST`, `NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID`, `NEXT_PUBLIC_CLARITY_ID`

To check whether a feature needs a variable, grep for `process.env.<NAME>`.

## Cron jobs

Vercel Cron, defined in `vercel.json`. Schedules are in UTC; Bangkok time is UTC+7. The handlers check `CRON_SECRET`.

| Path | Schedule (UTC) |
|---|---|
| `/api/billing/reconcile` | every 15 min |
| `/api/cron/autopost-scheduled` | every 15 min |
| `/api/cron/board-gen` | every minute (processes the board-question generation queue) |
| `/api/cron/exam-watch` | daily 00:30 |
| `/api/cron/admin-digest` | daily 01:00 |
| `/api/email/weekly-digest` | Mon 01:00 |
| `/api/cron/lead-followup` | daily 02:00 |
| `/api/cron/autopost-ig-carousel` | Mon/Wed/Fri 02:00 |
| `/api/cron/signup-drip` | daily 02:45 |
| `/api/cron/ig-insights` | daily 04:00 |
| `/api/cron/line-weekly-blog-digest` | Wed 05:00 |
| `/api/cron/school-review-reminder` | daily 11:00 |
| `/api/cron/autopost-ig-story` | daily 12:00 |
| `/api/cron/streak-nudge` | daily 12:00 |
| `/api/cron/autopost-ig` | daily 13:00 |
| `/api/cron/school-streak-reminder` | daily 13:00 |
| `/api/cron/school-enrich` | daily 18:00 |
| `/api/cron/ads-postmerge-watch` | daily 21:30 |
| `/api/cron/ads-autofix` | daily 22:00 |
| `/api/cron/ads-autofix-suggest` | daily 23:00 |

## CI

- **GitHub Actions** (`.github/workflows/verify.yml`): the `verify` job runs lint, typecheck and unit tests on every PR and on pushes to `main`. The `e2e` job runs Playwright on PRs. `mirror-to-gitlab.yml` mirrors every branch to GitLab.
- **GitLab CI** (`.gitlab-ci.yml`): the `verify` job on merge requests, plus the scheduled or manual content-generator jobs selected with `JOB=<name>`.

## Docs

| Doc | Topic |
|---|---|
| `docs/full-system-blueprint.md` | Whole-system overview: auth, payments, exam pipelines, DB schema, env vars |
| `docs/membership-entitlements.md` | Plans and what each one unlocks |
| `docs/stripe-flowaccount-blueprint.md` | Payment and tax-invoice flow |
| `docs/game-system-plan.md`, `docs/sim-characters.md` | Case game / sim engine and characters |
| `docs/school-lesson-template.md`, `docs/school-illustrations-plan.md`, `docs/school-content-reset-20260803.md` | School mode content |
| `docs/firstaid-migration.md` | The firstaid subdomain |
| `docs/spec-line-liff.md` | LINE LIFF integration |
| `docs/spec-capi-conversion-tracking.md`, `docs/ads-*.md`, `docs/facebook-ads-template.md`, `docs/handover-ads-leads-bot.md` | Ads, conversion tracking and the leads bot |
| `docs/ai-error-monitoring.md` | AI error monitoring |
| `docs/ui-typography-layout-system.md` | UI typography and layout rules |
| `docs/user-guide.md` | End-user guide |
| `docs/ops/` | Operational runbooks |

> This project uses Next.js 16, whose APIs differ from older versions. Read `AGENTS.md` and `node_modules/next/dist/docs/` before changing framework-level code.
