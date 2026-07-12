"use client";

import { useSyncEngine } from "@/lib/courses/offline/sync-engine";

// Mounts the offline → cloud sync engine for a course section. Render once
// per course layout (e.g. app/acls/layout.tsx); renders nothing.
export default function SyncEngineMount() {
  useSyncEngine();
  return null;
}
