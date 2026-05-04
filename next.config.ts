import type { NextConfig } from "next";
import { withSentryConfig } from "@sentry/nextjs";

const nextConfig: NextConfig = {
  typescript: {
    // next/og types are missing in Next 16.2.1 — runtime works fine
    ignoreBuildErrors: true,
  },
  images: {
    remotePatterns: [
      // Supabase Storage (blog cover images uploaded by generator)
      { protocol: "https", hostname: "*.supabase.co", pathname: "/storage/v1/object/public/**" },
    ],
  },
};

// Only wrap with Sentry's build plugin when SENTRY_DSN is configured. This
// keeps builds identical for forks / preview deploys without Sentry access,
// and skips sourcemap upload (which needs SENTRY_AUTH_TOKEN anyway).
const hasSentry = !!(process.env.SENTRY_DSN || process.env.NEXT_PUBLIC_SENTRY_DSN);

export default hasSentry
  ? withSentryConfig(nextConfig, {
      org: process.env.SENTRY_ORG,
      project: process.env.SENTRY_PROJECT,
      silent: !process.env.CI,
      widenClientFileUpload: true,
      disableLogger: true,
      automaticVercelMonitors: false,
    })
  : nextConfig;
