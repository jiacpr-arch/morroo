// Public origin for the firstaid section. Pages live under app/(firstaid)/firstaid/**
// internally, but every public URL (canonical, sitemap, robots) is on the subdomain
// with NO /firstaid prefix — the host-rewrite middleware maps between the two.
export const FIRSTAID_ORIGIN = "https://firstaid.morroo.com";

export const faUrl = (path: string) => `${FIRSTAID_ORIGIN}${path}`;
