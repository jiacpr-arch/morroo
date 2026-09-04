"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { Mic, Square } from "lucide-react";
import { Button } from "@/components/ui/button";
import { recognitionError } from "./device-speech";
import type { DeviceRecognition, SpeechWindow } from "./device-speech";
import type { useLongCaseVoice } from "./LongCaseVoice";

type Stage = "idle" | "starting" | "listening" | "waiting" | "speaking";
const labels: Record<Stage, string> = {
  idle: "ปิดโหมดสนทนา", starting: "กำลังเตรียมเสียงและไมค์…",
  listening: "กำลังฟังคำถาม…", waiting: "ปิดไมค์แล้ว กำลังรอคนไข้ตอบ…",
  speaking: "คนไข้กำลังพูด · ไมค์ปิดอยู่",
};

// Half-duplex, opt-in, history-only. Never retry an AI request automatically.
export function PatientConversation({ voice, disabled, onAsk, onActiveChange, onDraft }: {
  voice: ReturnType<typeof useLongCaseVoice>;
  disabled: boolean;
  onAsk: (text: string) => Promise<string | null>;
  onActiveChange: (active: boolean) => void;
  onDraft: (text: string) => void;
}) {
  const [stage, setStage] = useState<Stage>("idle");
  const [supported, setSupported] = useState(false);
  const [allowBrowser, setAllowBrowser] = useState(false);
  const [transcript, setTranscript] = useState("");
  const [message, setMessage] = useState("");
  const generation = useRef(0);
  const running = useRef(false);
  const recognition = useRef<DeviceRecognition | null>(null);
  const draft = useRef("");
  const timers = useRef(new Set<ReturnType<typeof setTimeout>>());
  const callbacks = useRef({ voice, onAsk, onActiveChange, onDraft });
  useEffect(() => { callbacks.current = { voice, onAsk, onActiveChange, onDraft }; }, [voice, onAsk, onActiveChange, onDraft]);

  const clearTimers = useCallback(() => {
    timers.current.forEach(clearTimeout);
    timers.current.clear();
  }, []);
  const detach = useCallback(() => {
    const rec = recognition.current;
    recognition.current = null;
    if (rec) {
      rec.onresult = rec.onerror = rec.onend = null;
      try { rec.abort(); } catch { /* Already ended. */ }
    }
  }, []);
  const stop = useCallback(() => {
    generation.current++;
    running.current = false;
    clearTimers();
    detach();
    if (draft.current.trim()) callbacks.current.onDraft(draft.current.trim());
    draft.current = "";
    callbacks.current.voice.stop();
    callbacks.current.onActiveChange(false);
    setStage("idle");
  }, [clearTimers, detach]);

  useEffect(() => {
    const browser = window as SpeechWindow;
    setSupported(window.isSecureContext && !!(browser.SpeechRecognition || browser.webkitSpeechRecognition));
    const hidden = () => { if (document.hidden) stop(); };
    document.addEventListener("visibilitychange", hidden);
    window.addEventListener("pagehide", stop);
    return () => {
      stop();
      document.removeEventListener("visibilitychange", hidden);
      window.removeEventListener("pagehide", stop);
    };
  }, [stop]);

  function schedule(fn: () => void, ms: number) {
    const timer = setTimeout(() => { timers.current.delete(timer); fn(); }, ms);
    timers.current.add(timer);
    return timer;
  }

  async function start() {
    if (running.current || disabled || !supported || !voice.selectedVoice) return;
    running.current = true;
    const run = ++generation.current;
    const valid = () => running.current && generation.current === run && !document.hidden;
    callbacks.current.onActiveChange(true);
    setMessage("");
    setTranscript("");
    setStage("starting");
    const fail = (text: string) => { if (valid()) { stop(); setMessage(text); } };
    schedule(() => fail("เตรียมเสียงหรือไมค์นานเกินไป กรุณากดเริ่มใหม่"), 60_000);
    try {
      // Speak in the click gesture to unlock device playback. Never open the
      // microphone until this utterance has ended (avoids recognizing itself).
      const ready = callbacks.current.voice.read("พร้อมแล้วค่ะ เชิญถามได้เลยค่ะ", "conversation-ready");
      const browser = window as SpeechWindow;
      const Constructor = browser.SpeechRecognition || browser.webkitSpeechRecognition;
      if (!Constructor) { fail("เครื่องนี้ไม่รองรับโหมดสนทนา ยังพิมพ์คุยได้ตามปกติ"); return; }
      const probe = new Constructor();
      if (!allowBrowser && (!("processLocally" in probe) || !Constructor.available ||
          await Constructor.available({ langs: ["th-TH"], processLocally: true }) !== "available")) {
        fail("ยังไม่มีระบบถอดเสียงไทยในเครื่องสำหรับโหมดสนทนา ใช้การพิมพ์ หรือเลือกอนุญาตบริการเบราว์เซอร์ด้านล่าง");
        return;
      }
      if (!valid()) return;
      if (!await ready) { fail("เปิดเสียงอ่านไม่ได้ กรุณาตรวจเสียงในเครื่องแล้วเริ่มใหม่"); return; }
      if (!valid()) return;
      clearTimers();

      const listen = () => {
        if (!valid()) return;
        try {
          const rec = new Constructor();
          recognition.current = rec;
          rec.lang = "th-TH";
          rec.continuous = true;
          rec.interimResults = true;
          if (!allowBrowser) rec.processLocally = true;
          const finals = new Map<number, string>();
          let settled = false;
          let closing = false;
          let pending = "";
          let silence: ReturnType<typeof setTimeout> | undefined;
          draft.current = "";
          setTranscript("");
          setStage("listening");

          const finish = async () => {
            if (!valid() || settled) return;
            settled = true;
            clearTimers();
            detach(); // Fully release mic before network or playback.
            const text = [...finals.values()].join(" ").trim();
            if (pending.trim()) { fail("ข้อความยังถอดเสียงไม่ครบ เก็บไว้ในช่องพิมพ์แล้ว กรุณาตรวจและส่งเอง"); return; }
            if (!text) { fail("ยังไม่ได้ยินคำถาม กดเริ่มคุยเพื่อลองใหม่ได้"); return; }
            draft.current = ""; // This turn is being sent, never resend on Stop.
            setStage("waiting");
            try {
              const reply = await callbacks.current.onAsk(text);
              if (!valid()) return;
              if (!reply) { fail("คนไข้ตอบไม่สำเร็จ หยุดโหมดสนทนาแล้ว กรุณาตรวจข้อความก่อนลองใหม่"); return; }
              setStage("speaking");
              const played = await callbacks.current.voice.read(reply, "conversation-reply");
              if (!valid()) return;
              if (!played) { fail("เสียงอ่านหยุดหรือเล่นไม่ได้ กดเริ่มใหม่เมื่อพร้อม"); return; }
              schedule(listen, 400); // Allow speaker echo to decay.
            } catch { fail("เชื่อมต่อไม่ได้ หยุดโหมดสนทนาแล้ว ไม่มีการส่งซ้ำอัตโนมัติ"); }
          };
          const closeTurn = () => {
            if (!valid() || settled || closing) return;
            closing = true;
            setStage("waiting");
            try {
              rec.stop(); // Wait for final result + onend; never submit interim.
              if (!settled) schedule(() => fail("ไมค์ไม่หยุดตามปกติ เก็บข้อความไว้ให้ตรวจแล้ว"), 2500);
            } catch { fail("หยุดไมค์ไม่สำเร็จ กรุณาตรวจข้อความในช่องพิมพ์"); }
          };
          rec.onresult = event => {
            if (!valid() || settled) return;
            const interim: string[] = [];
            for (let i = 0; i < event.results.length; i++) {
              const result = event.results[i];
              if (result.isFinal) {
                if (!finals.has(i)) finals.set(i, result[0].transcript);
              } else interim.push(result[0].transcript);
            }
            pending = interim.join(" ");
            draft.current = [...finals.values(), pending].filter(Boolean).join(" ");
            setTranscript(draft.current);
            if (silence) { clearTimeout(silence); timers.current.delete(silence); }
            silence = schedule(closeTurn, 1800);
          };
          rec.onerror = event => { if (!settled) fail(recognitionError(event.error)); };
          rec.onend = () => { void finish(); };
          rec.start();
          schedule(() => fail("หยุดไมค์เมื่อครบ 60 วินาที เก็บข้อความที่ยังไม่ส่งไว้ในช่องพิมพ์แล้ว"), 60_000);
        } catch { fail("เปิดไมค์ไม่ได้ กรุณาตรวจสิทธิ์ไมโครโฟนแล้วกดเริ่มใหม่"); }
      };
      listen();
    } catch { fail("เริ่มโหมดสนทนาไม่ได้ ยังใช้การพิมพ์คุยได้ตามปกติ"); }
  }

  const active = stage !== "idle";
  return <section aria-label="โหมดคุยกับคนไข้" className="rounded-xl border border-amber-300 bg-amber-50 p-4 space-y-3">
    <div className="flex flex-wrap items-center gap-3">
      <Button type="button" onClick={active ? stop : start} aria-pressed={active}
        disabled={!active && (disabled || !supported || !voice.selectedVoice)}>
        {active ? <Square className="h-4 w-4" /> : <Mic className="h-4 w-4" />}
        {active ? "หยุดคุยกับคนไข้" : "เริ่มคุยกับคนไข้"}
      </Button>
      <span role="status" className="text-sm text-amber-900">{labels[stage]}</span>
    </div>
    <p className="text-xs text-gray-700">พูดถามแล้วเว้นจังหวะประมาณ 2 วินาที ระบบจะส่งข้อความอัตโนมัติ คนไข้ AI พูดตอบจบแล้วจึงเปิดไมค์รอบถัดไป · ใช้ AI ข้อความและโควตาเดิม ไม่มีค่า API เสียงเพิ่ม</p>
    <p className="text-xs text-gray-600">กดหยุดได้ทุกเมื่อ ข้อความที่ส่งแล้วอาจยังได้รับคำตอบ · แนะนำหูฟัง และยังไม่รองรับการพูดแทรก</p>
    {supported && <label className="flex items-start gap-2 text-xs text-gray-600">
      <input type="checkbox" checked={allowBrowser} disabled={active} className="mt-0.5" onChange={e => setAllowBrowser(e.target.checked)} />
      <span>อนุญาตโหมดสนทนาใช้บริการเบราว์เซอร์หากเครื่องไม่พร้อม (อาจส่งเสียงออกจากเครื่อง ไม่ใช้ API เสียงแบบเสียเงินของ Morroo)</span>
    </label>}
    {(!supported || !voice.selectedVoice) && <p className="text-xs text-amber-800">โหมดสนทนาต้องใช้เบราว์เซอร์ที่รองรับไมค์และเสียงไทยในเครื่อง ยังพิมพ์หรือใช้ไมค์คีย์บอร์ดแทนได้</p>}
    {transcript && <p className="text-sm break-words" aria-live="polite">ได้ยิน: {transcript}</p>}
    {message && <p role="alert" className="text-sm text-amber-800">{message}</p>}
  </section>;
}
