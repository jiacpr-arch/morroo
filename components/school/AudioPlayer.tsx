"use client";

import { useState, useEffect } from "react";
import { Volume2, VolumeX } from "lucide-react";

interface Props {
  text: string;
  lang?: string;
}

/**
 * Tiny TTS button using Web Speech API (browser-native, free).
 * Detects Thai vs English from chars; auto-picks voice when available.
 */
export default function AudioPlayer({ text, lang }: Props) {
  const [supported, setSupported] = useState(true);
  const [speaking, setSpeaking] = useState(false);

  useEffect(() => {
    setSupported(
      typeof window !== "undefined" && "speechSynthesis" in window
    );
    return () => {
      if (typeof window !== "undefined" && "speechSynthesis" in window) {
        window.speechSynthesis.cancel();
      }
    };
  }, []);

  function detectLang(t: string): string {
    if (lang) return lang;
    // Any Thai character?
    return /[฀-๿]/.test(t) ? "th-TH" : "en-US";
  }

  function toggle(e: React.MouseEvent) {
    e.stopPropagation();
    if (!supported) return;
    if (speaking) {
      window.speechSynthesis.cancel();
      setSpeaking(false);
      return;
    }
    const utter = new SpeechSynthesisUtterance(text);
    utter.lang = detectLang(text);
    utter.rate = 1.0;
    utter.onend = () => setSpeaking(false);
    utter.onerror = () => setSpeaking(false);
    window.speechSynthesis.speak(utter);
    setSpeaking(true);
  }

  if (!supported) return null;
  const Icon = speaking ? VolumeX : Volume2;
  return (
    <button
      type="button"
      onClick={toggle}
      title={speaking ? "Stop" : "Listen"}
      className={`p-1.5 rounded hover:bg-muted transition-colors ${
        speaking ? "text-sky-600" : "text-muted-foreground"
      }`}
    >
      <Icon className="h-4 w-4" />
    </button>
  );
}
