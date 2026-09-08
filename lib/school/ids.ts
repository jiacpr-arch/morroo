/**
 * Client-safe id helpers for School routes.
 *
 * Every `/school/lesson/[id]` and `/school/topic/[id]` link should be built through
 * these so a missing id (null / undefined / "null") can never end up in a URL and
 * blow up the uuid column lookup on the target page (Postgres 22P02).
 */

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_RE.test(value);
}

/** `/school/lesson/<id>[?query]`, or null when `id` is not a uuid. */
export function lessonHref(id: unknown, query?: string): string | null {
  if (!isUuid(id)) return null;
  return query ? `/school/lesson/${id}?${query}` : `/school/lesson/${id}`;
}

/** `/school/topic/<id>`, or null when `id` is not a uuid. */
export function topicHref(id: unknown): string | null {
  return isUuid(id) ? `/school/topic/${id}` : null;
}
