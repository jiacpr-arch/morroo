"use client";

import { forwardRef, useEffect, useImperativeHandle, useRef } from "react";

// Minimal shape of the bits of the YouTube IFrame API we use.
interface YTPlayerVars {
  start?: number;
  end?: number;
  playsinline?: number;
  rel?: number;
  modestbranding?: number;
  fs?: number;
}
interface YTPlayerEvent {
  data: number;
}
interface YTPlayer {
  seekTo: (sec: number, allowSeekAhead: boolean) => void;
  playVideo: () => void;
  pauseVideo: () => void;
  getCurrentTime: () => number;
  getDuration: () => number;
  destroy: () => void;
}
interface YTNamespace {
  Player: new (
    el: HTMLElement,
    opts: {
      videoId: string;
      playerVars: YTPlayerVars;
      events: { onStateChange: (e: YTPlayerEvent) => void };
    },
  ) => YTPlayer;
  PlayerState: { PLAYING: number; ENDED: number };
}

declare global {
  interface Window {
    YT?: YTNamespace;
    onYouTubeIframeAPIReady?: () => void;
  }
}

// โหลด YouTube IFrame Player API ครั้งเดียว (singleton) แล้ว resolve เมื่อพร้อม
let ytReadyPromise: Promise<YTNamespace | null> | null = null;
function loadYouTubeApi(): Promise<YTNamespace | null> {
  if (typeof window === "undefined") return Promise.resolve(null);
  if (window.YT && window.YT.Player) return Promise.resolve(window.YT);
  if (ytReadyPromise) return ytReadyPromise;
  ytReadyPromise = new Promise((resolve) => {
    const prev = window.onYouTubeIframeAPIReady;
    window.onYouTubeIframeAPIReady = () => {
      if (prev) {
        try {
          prev();
        } catch {
          /* ignore */
        }
      }
      resolve(window.YT ?? null);
    };
    const tag = document.createElement("script");
    tag.src = "https://www.youtube.com/iframe_api";
    document.head.appendChild(tag);
  });
  return ytReadyPromise;
}

export interface YouTubeLessonPlayerHandle {
  seekTo: (sec: number) => void;
}

interface YouTubeLessonPlayerProps {
  videoId: string;
  startSec?: number | null;
  endSec?: number | null;
  orientation?: "portrait" | "landscape";
  watchThreshold?: number;
  onWatched?: () => void;
}

// Player วิดีโอบทเรียน — ใช้ YT IFrame API เพื่อ (1) รองรับ start/end + seek จากสารบัญ
// และ (2) ติดตามความคืบหน้า → เรียก onWatched เมื่อดูถึง ~watchThreshold ของช่วงคลิป
// ref.seekTo(sec) ให้บล็อกสารบัญสั่งกระโดดเวลาได้
const YouTubeLessonPlayer = forwardRef<YouTubeLessonPlayerHandle, YouTubeLessonPlayerProps>(
  function YouTubeLessonPlayer(
    { videoId, startSec = 0, endSec = null, orientation = "portrait", watchThreshold = 0.9, onWatched },
    ref,
  ) {
    const hostRef = useRef<HTMLDivElement | null>(null);
    const playerRef = useRef<YTPlayer | null>(null);
    const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);
    const watchedFired = useRef(false);
    const onWatchedRef = useRef(onWatched);
    onWatchedRef.current = onWatched;

    useImperativeHandle(
      ref,
      () => ({
        seekTo: (sec: number) => {
          const p = playerRef.current;
          if (!p || !p.seekTo) return;
          try {
            p.seekTo(Number(sec) || 0, true);
            p.playVideo();
          } catch {
            /* ignore */
          }
        },
      }),
      [],
    );

    useEffect(() => {
      let cancelled = false;
      watchedFired.current = false;
      const start = Number(startSec) || 0;
      const end = endSec == null ? null : Number(endSec);

      const stopPoll = () => {
        if (pollRef.current) {
          clearInterval(pollRef.current);
          pollRef.current = null;
        }
      };
      const fireWatched = () => {
        if (watchedFired.current) return;
        watchedFired.current = true;
        stopPoll();
        try {
          onWatchedRef.current?.();
        } catch {
          /* ignore */
        }
      };
      const checkProgress = () => {
        const p = playerRef.current;
        if (!p || !p.getCurrentTime) return;
        const cur = p.getCurrentTime();
        const dur = p.getDuration ? p.getDuration() : 0;
        const effEnd = end || dur || 0;
        if (effEnd > start && (cur - start) / (effEnd - start) >= watchThreshold) fireWatched();
        if (end && cur >= end) {
          try {
            p.pauseVideo();
          } catch {
            /* ignore */
          }
        }
      };

      loadYouTubeApi().then((YT) => {
        if (cancelled || !YT || !hostRef.current) return;
        playerRef.current = new YT.Player(hostRef.current, {
          videoId,
          playerVars: {
            start: start || undefined,
            end: end || undefined,
            playsinline: 1,
            rel: 0,
            modestbranding: 1,
            fs: 1,
          },
          events: {
            onStateChange: (e) => {
              if (e.data === YT.PlayerState.PLAYING) {
                stopPoll();
                pollRef.current = setInterval(checkProgress, 1000);
              } else stopPoll();
              if (e.data === YT.PlayerState.ENDED) fireWatched();
            },
          },
        });
      });

      return () => {
        cancelled = true;
        stopPoll();
        try {
          playerRef.current?.destroy();
        } catch {
          /* ignore */
        }
        playerRef.current = null;
      };
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [videoId, startSec, endSec, watchThreshold]);

    const isPortrait = orientation === "portrait";
    return (
      <div
        className="mx-auto w-full overflow-hidden bg-black"
        style={{
          maxWidth: isPortrait ? 340 : "100%",
          aspectRatio: isPortrait ? "9 / 16" : "16 / 9",
          borderRadius: "1rem",
        }}
      >
        {/* YT.Player แทนที่ div นี้ด้วย iframe */}
        <div ref={hostRef} className="h-full w-full" />
      </div>
    );
  },
);

export default YouTubeLessonPlayer;
