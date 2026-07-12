"use client";

import { useState } from "react";
import { Play, Maximize2 } from "lucide-react";
import type { CourseFeaturedVideo } from "@/lib/courses/config";
import { btnGhost, btnSm, text2xs } from "./course-ui";

// Renders a featured YouTube video at the top of the pre-course landing.
// Click-to-load (no iframe until user clicks) so first paint isn't bogged
// down by the YouTube player. Lazy approach keeps Lighthouse happy.
export default function FeaturedVideo({ video }: { video: CourseFeaturedVideo | null }) {
  const [loaded, setLoaded] = useState(false);
  if (!video?.videoId) return null;

  const thumb = `https://i.ytimg.com/vi/${video.videoId}/hqdefault.jpg`;
  const embedUrl = `https://www.youtube.com/embed/${video.videoId}?autoplay=1&rel=0&modestbranding=1`;
  const watchUrl = `https://youtu.be/${video.videoId}`;

  return (
    <div className="overflow-hidden rounded-xl border border-border bg-card shadow-sm">
      {/* 16:9 aspect-ratio video frame */}
      <div className="relative w-full" style={{ paddingTop: "56.25%" }}>
        {loaded ? (
          <iframe
            className="absolute inset-0 h-full w-full"
            src={embedUrl}
            title={video.title || "Featured video"}
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
            referrerPolicy="strict-origin-when-cross-origin"
          />
        ) : (
          <button
            type="button"
            onClick={() => setLoaded(true)}
            className="group absolute inset-0 h-full w-full cursor-pointer"
            style={{
              backgroundImage: `linear-gradient(180deg, rgba(0,0,0,0) 30%, rgba(0,0,0,0.55) 100%), url(${thumb})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
            }}
            aria-label="Play featured video"
          >
            <span className="absolute inset-0 flex items-center justify-center">
              <span
                className="inline-flex h-16 w-16 items-center justify-center rounded-full bg-white/95 transition-transform group-hover:scale-110"
                style={{ boxShadow: "0 8px 24px rgba(0,0,0,0.32)" }}
              >
                <Play size={28} strokeWidth={2.4} className="ml-1 text-red-600" />
              </span>
            </span>
            <span className="absolute bottom-2 left-3 right-3 text-left">
              <span className="block text-sm font-bold text-white drop-shadow">
                {video.title || "Featured video"}
              </span>
              {video.description && (
                <span className={`${text2xs} mt-0.5 block text-white/85 drop-shadow`}>
                  {video.description}
                </span>
              )}
            </span>
          </button>
        )}
      </div>

      {/* Footer with open-on-YouTube link */}
      {loaded && (
        <div className="flex items-center justify-between border-t border-border px-3 py-2">
          <span className={`${text2xs} truncate text-muted-foreground`}>
            {video.title || "Featured video"}
          </span>
          <a
            href={watchUrl}
            target="_blank"
            rel="noopener noreferrer"
            className={`${btnGhost} ${btnSm} shrink-0`}
          >
            <Maximize2 size={14} strokeWidth={2.4} /> YouTube
          </a>
        </div>
      )}
    </div>
  );
}
