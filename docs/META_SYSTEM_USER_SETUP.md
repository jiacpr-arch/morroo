# Meta System User Setup for IG Autopost

Migration guide: move `lib/facebook.ts` + `lib/instagram.ts` off the legacy
60-day user token onto a Meta Business Portfolio **System User** token that
never expires.

System users belong to the Business Portfolio, not to a personal Facebook
account. The token they issue is the right primitive for server-to-server
crons — no refresh loop, no risk of the cron account being locked out, and
you can grant just the asset permissions you need.

## Prerequisites

- The Morroo Facebook Page and Instagram Business Account must both be
  claimed by the same Business Portfolio.
- A Meta App (developers.facebook.com) — either the existing `FACEBOOK_APP_ID`
  app or a new one. Used only to scope the system user token at generation
  time.
- Admin role on the Business Portfolio.

## 1. Create the system user

1. Open **Meta Business Suite** → **Business Settings** (gear icon).
2. **Users → System Users → Add**.
3. Name: `morroo-autopost`. Role: **Admin**.

## 2. Assign assets to the system user

Still in Business Settings:

1. Select the new `morroo-autopost` user → **Add Assets**.
2. **Pages** → select the Morroo FB Page → permission **Full control**.
3. **Instagram accounts** → select the Morroo IG Business Account →
   permission **Full control**.

If the IG account doesn't appear, it isn't claimed by this Business
Portfolio — claim it first (Business Settings → Instagram accounts → Add).

## 3. Generate the token

1. Back on the system user page → **Generate New Token**.
2. App: pick the Morroo Meta App.
3. **Permissions** — check these:
   - `pages_manage_posts`
   - `pages_read_engagement`
   - `pages_show_list`
   - `instagram_basic`
   - `instagram_content_publish`
   - `business_management`
4. Token expiration: **Never**.
5. Copy the token immediately — it is shown once.

Verify it with the [Access Token Debugger](https://developers.facebook.com/tools/debug/accesstoken/):

- Type: **App User Token** (system users count as app users)
- Expires: **Never**
- Scopes: all six above present
- Valid: yes

## 4. Configure Vercel

In the Morroo Vercel project → Settings → Environment Variables:

| Variable | Value | Environments |
|---|---|---|
| `META_SYSTEM_USER_TOKEN` | the token from step 3 | Production + Preview |
| `INSTAGRAM_BUSINESS_ACCOUNT_ID` | (existing) | Production + Preview |
| `FACEBOOK_PAGE_ID` | (existing) | Production + Preview |
| `CRON_SECRET` | Vercel's auto-set value for cron auth | Production |
| `BLOG_GENERATE_SECRET` | (existing) | Production + Preview |

Redeploy to pick up the new env var.

## 5. (Optional) Drop the legacy cached token

Once you verify the system user token works (see Verification below), clear
the Supabase-cached user token so the only active codepath is the system
user one:

```sql
DELETE FROM app_settings WHERE key = 'facebook_user_token';
```

The legacy `FACEBOOK_USER_TOKEN` env var can stay as an emergency fallback
(the priority chain in `getLatestUserToken()` only falls through to it when
both the system user token and the cached token are missing) or be removed.

## Verification

1. Trigger the cron route by hand:
   ```bash
   curl -i -H "Authorization: Bearer $CRON_SECRET" \
     https://www.morroo.com/api/cron/autopost-ig
   ```
   Expect `200 OK` and a JSON body of either
   `{processed: 0, results: [], message: "No unposted articles found"}` or
   `{processed: 1, results: [{slug, ig: "posted:..."}]}`.

2. Vercel logs for that request must **not** contain
   `[facebook] token refreshed` — that line only fires under the legacy user
   token codepath (`isSystemUserTokenActive() === false`).

3. Visit `/admin/autopost` as an admin and confirm:
   - Stats cards load
   - At least one row shows a `posted` badge with an `ig_posted_at` timestamp
   - Clicking **Retry Feed** on a failed row succeeds (toast-less; row
     refreshes and the badge flips to `posted`)

4. Confirm Vercel cron entry: Project → Settings → Cron Jobs →
   `/api/cron/autopost-ig` listed with next run at 11:00 UTC daily.

## Rate limits (reminder)

- IG: 1 publish/day per account is the **soft** limit; 25/day is the **hard**
  cap. The cron is intentionally `limit=1` so daily runs stay safely under
  the soft limit.
- Manual backfill should still use `scripts/backfill-autopost.sh` with the
  240s delay between posts.

## Rollback

If the system user token misbehaves, unset `META_SYSTEM_USER_TOKEN` in
Vercel and redeploy. The priority chain falls through to the cached user
token + refresh path automatically — no code revert needed.
