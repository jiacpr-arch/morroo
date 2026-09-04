"use client";

import { useCallback, useEffect, useId, useRef, useState } from "react";
import { Mic, Square, Volume2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { localThaiVoices, recognitionError, speechChunks } from "./device-speech";
import type { DeviceRecognition, SpeechWindow } from "./device-speech";

// Only mounted inside Long Case. Consent/settings are deliberately not shared
// with other features or persisted across visits.
export function DictationButton({ disabled = false, onTranscript, onActiveChange, onBeforeStart }: {
  disabled?: boolean;
  onTranscript: (text: string) => void;
  onActiveChange: (active: boolean) => void;
  onBeforeStart: () => void;
}) {
  const [supported, setSupported] = useState(false);
  const [active, setActive] = useState(false);
  const [allowBrowserService, setAllowBrowserService] = useState(false);
  const [interim, setInterim] = useState("");
  const [message, setMessage] = useState("");
  const recognitionRef = useRef<DeviceRecognition | null>(null);
  const generation = useRef(0);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const callbacks = useRef({ onTranscript, onActiveChange });
  const hintId = useId();
  useEffect(() => { callbacks.current = { onTranscript, onActiveChange }; }, [onTranscript, onActiveChange]);

  const cancel = useCallback(() => {
    generation.current++;
    const recognition = recognitionRef.current;
    recognitionRef.current = null;
    if (timer.current) clearTimeout(timer.current);
    if (recognition) {
      recognition.onresult = recognition.onerror = recognition.onend = null;
      try { recognition.abort(); } catch { /* Already ended. */ }
    }
    setActive(false);
    setInterim("");
    callbacks.current.onActiveChange(false);
  }, []);

  useEffect(() => {
    const browser = window as SpeechWindow;
    setSupported(!!(browser.SpeechRecognition || browser.webkitSpeechRecognition) && window.isSecureContext);
    const onVisibility = () => { if (document.hidden) cancel(); };
    document.addEventListener("visibilitychange", onVisibility);
    window.addEventListener("pagehide", cancel);
    return () => {
      cancel();
      document.removeEventListener("visibilitychange", onVisibility);
      window.removeEventListener("pagehide", cancel);
    };
  }, [cancel]);

  useEffect(() => { if (disabled) cancel(); }, [disabled, cancel]);

  function stop() {
    // Let the final recognition result arrive before re-enabling Send.
    if (!recognitionRef.current) { cancel(); return; }
    try {
      recognitionRef.current.stop();
      if (timer.current) clearTimeout(timer.current);
      // Some engines emit onend synchronously. Do not leave a stale timer that
      // could cancel the next recording started immediately afterwards.
      if (recognitionRef.current) timer.current = setTimeout(cancel, 2000);
    } catch { cancel(); }
  }

  async function start() {
    if (disabled || active || !supported) return;
    onBeforeStart();
    setMessage("");
    setInterim("");
    setActive(true);
    callbacks.current.onActiveChange(true);
    const request = ++generation.current;
    if (timer.current) clearTimeout(timer.current);
    // Also bounds a stalled availability/permission check.
    timer.current = setTimeout(() => {
      cancel();
      setMessage("หยุดไมค์เมื่อครบ 60 วินาที กดอีกครั้งเพื่อพูดต่อได้");
    }, 60_000);
    try {
      const browser = window as SpeechWindow;
      const Constructor = browser.SpeechRecognition || browser.webkitSpeechRecognition;
      if (!Constructor) throw new Error("unsupported");
      const recognition = new Constructor();
      if (!allowBrowserService) {
        // Never silently fall back from local recognition to a remote service.
        if (!("processLocally" in recognition) || !Constructor.available ||
            await Constructor.available({ langs: ["th-TH"], processLocally: true }) !== "available") {
          if (request !== generation.current) return;
          cancel();
          setMessage("ยังไม่มีระบบถอดเสียงไทยในเครื่องที่พร้อมใช้ ใช้ไมค์บนคีย์บอร์ดแทน หรือเลือกยินยอมใช้บริการเบราว์เซอร์ด้านล่าง");
          return;
        }
        recognition.processLocally = true;
      }
      if (request !== generation.current) return;
      recognition.lang = "th-TH";
      recognition.continuous = true;
      recognition.interimResults = true;
      const committed = new Set<number>();
      recognition.onresult = event => {
        if (request !== generation.current) return;
        const finals: string[] = [];
        const pending: string[] = [];
        for (let i = 0; i < event.results.length; i++) {
          const result = event.results[i];
          if (result.isFinal && !committed.has(i)) {
            committed.add(i);
            finals.push(result[0].transcript);
          } else if (!result.isFinal) pending.push(result[0].transcript);
        }
        if (finals.length) callbacks.current.onTranscript(finals.join(" "));
        setInterim(pending.join(" "));
      };
      recognition.onerror = event => {
        if (request !== generation.current) return;
        if (event.error !== "aborted") setMessage(recognitionError(event.error));
        cancel();
      };
      recognition.onend = () => { if (request === generation.current) cancel(); };
      recognitionRef.current = recognition;
      recognition.start();
    } catch {
      if (request !== generation.current) return;
      cancel();
      setMessage("เปิดระบบถอดเสียงไม่ได้ ลองใช้ไมค์บนคีย์บอร์ดหรือพิมพ์ตอบได้ตามปกติ");
    }
  }

  return (
    <div className="space-y-2 text-xs text-gray-600">
      <div className="flex flex-wrap items-center gap-2">
        <Button type="button" variant="outline" size="sm" onClick={active ? stop : start}
          disabled={!supported || (disabled && !active)} aria-pressed={active} aria-describedby={hintId}>
          {active ? <Square className="h-4 w-4" /> : <Mic className="h-4 w-4" />}
          {active ? "หยุดไมค์" : "พูดแทนพิมพ์"}
        </Button>
        <span id={hintId}>ข้อความจะเข้าช่องพิมพ์ ตรวจแก้แล้วกดส่งเอง</span>
      </div>
      {supported ? (
        <label className="flex items-start gap-2 cursor-pointer">
          <input type="checkbox" checked={allowBrowserService} disabled={active}
            onChange={e => setAllowBrowserService(e.target.checked)} className="mt-0.5" />
          <span>ยินยอมใช้บริการถอดเสียงของเบราว์เซอร์ (อาจส่งเสียงออกจากเครื่อง ไม่ใช้ API เสียงแบบเสียเงินของ Morroo)</span>
        </label>
      ) : <p>เบราว์เซอร์นี้ไม่มีปุ่มถอดเสียงที่รองรับ ใช้ไมค์บนคีย์บอร์ดของเครื่อง หรือพิมพ์ได้ตามปกติ</p>}
      <div role="status" aria-live="polite">
        {active && <p className="text-amber-700">กำลังฟัง… {interim}</p>}
        {message && <p className="text-amber-800">{message}</p>}
      </div>
    </div>
  );
}

export function useLongCaseVoice(scope: string) {
  const [voices, setVoices] = useState<SpeechSynthesisVoice[]>([]);
  const [voiceURI, setVoiceURI] = useState("");
  const [rate, setRate] = useState(1);
  const [autoRead, setAutoRead] = useState(false);
  const [speakingId, setSpeakingId] = useState<string | null>(null);
  const [error, setError] = useState("");
  const generation = useRef(0);
  const utteranceRef = useRef<SpeechSynthesisUtterance | null>(null);
  const completion = useRef<((ok: boolean) => void) | null>(null);
  const playbackTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const currentScope = useRef(scope);
  const autoReadRef = useRef(autoRead);
  useEffect(() => { autoReadRef.current = autoRead; }, [autoRead]);
  const selectedVoice = voices.find(voice => voice.voiceURI === voiceURI) || voices[0];

  const stop = useCallback(() => {
    generation.current++;
    if (playbackTimer.current) clearTimeout(playbackTimer.current);
    completion.current?.(false);
    completion.current = null;
    if (utteranceRef.current) {
      utteranceRef.current.onend = utteranceRef.current.onerror = null;
      utteranceRef.current = null;
      window.speechSynthesis?.cancel();
    }
    setSpeakingId(null);
  }, []);

  useEffect(() => {
    const synth = window.speechSynthesis;
    if (!synth) return;
    const refresh = () => setVoices(localThaiVoices(synth.getVoices()));
    refresh();
    synth.addEventListener("voiceschanged", refresh);
    const onVisibility = () => { if (document.hidden) stop(); };
    document.addEventListener("visibilitychange", onVisibility);
    window.addEventListener("pagehide", stop);
    return () => {
      stop();
      synth.removeEventListener("voiceschanged", refresh);
      document.removeEventListener("visibilitychange", onVisibility);
      window.removeEventListener("pagehide", stop);
    };
  }, [stop]);

  useEffect(() => {
    currentScope.current = scope;
    return () => { currentScope.current = ""; stop(); };
  }, [scope, stop]);

  function read(text: string, id: string): Promise<boolean> {
    if (currentScope.current !== scope || document.hidden) return Promise.resolve(false);
    stop();
    setError("");
    // Never allow the browser to choose a remote voice as a fallback.
    const voice = selectedVoice && localThaiVoices(window.speechSynthesis?.getVoices() || [])
      .find(candidate => candidate.voiceURI === selectedVoice.voiceURI);
    if (!voice) { setError("ไม่พบเสียงไทยในเครื่อง กรุณาติดตั้งเสียงไทยในการตั้งค่าระบบ แล้วเปิดหน้าใหม่"); return Promise.resolve(false); }
    const chunks = speechChunks(text);
    if (!chunks.length) return Promise.resolve(false);
    const finished = new Promise<boolean>(resolve => { completion.current = resolve; });
    const request = generation.current;
    setSpeakingId(id);
    function play(index: number) {
      if (request !== generation.current) return;
      if (index >= chunks.length) {
        if (playbackTimer.current) clearTimeout(playbackTimer.current);
        utteranceRef.current = null;
        setSpeakingId(null);
        completion.current?.(true);
        completion.current = null;
        return;
      }
      // Fail closed if a device silently blocks playback or omits onend.
      if (playbackTimer.current) clearTimeout(playbackTimer.current);
      playbackTimer.current = setTimeout(() => {
        stop();
        setError("เครื่องไม่จบการอ่านเสียง กรุณากดเริ่มใหม่หรืออ่านข้อความแทน");
      }, 45_000);
      const utterance = new SpeechSynthesisUtterance(chunks[index]);
      utterance.voice = voice!;
      utterance.lang = voice!.lang;
      utterance.rate = rate;
      utterance.onend = () => play(index + 1);
      utterance.onerror = () => {
        if (request !== generation.current) return;
        stop();
        setError("อ่านเสียงไม่สำเร็จ ลองกดอ่านคำตอบอีกครั้ง");
      };
      utteranceRef.current = utterance;
      try { window.speechSynthesis.speak(utterance); }
      catch { stop(); setError("เครื่องนี้เปิดเสียงอ่านไม่ได้ ยังอ่านข้อความได้ตามปกติ"); }
    }
    play(0);
    return finished;
  }

  // Called only after a successful complete response, never on every SSE token
  // or when restoring history. Ignore replies arriving after navigation/Stop.
  function prepareReply() {
    const request = generation.current;
    return (text: string, id: string) => {
      if (autoReadRef.current && request === generation.current && currentScope.current === scope) read(text, id);
    };
  }

  return { voices, selectedVoice, setVoiceURI, rate, setRate, autoRead, setAutoRead,
    speakingId, error, stop, read, prepareReply };
}

export function VoiceSettings({ voice, disabled }: { voice: ReturnType<typeof useLongCaseVoice>; disabled: boolean }) {
  return (
    <details className="rounded-xl border border-amber-200 bg-white p-4 text-sm">
      <summary className="cursor-pointer font-medium text-amber-900">เสียงอ่านจากเครื่อง · ไม่มีค่า API เสียงเพิ่ม</summary>
      <fieldset disabled={disabled} className="mt-3 space-y-3">
        <p className="text-xs text-gray-600">เสียงสังเคราะห์ของอุปกรณ์ ไม่ใช่เสียงบุคคลจริง ใช้เฉพาะ Long Case</p>
        {voice.voices.length ? <>
          <label className="flex flex-wrap items-center gap-2">เสียงไทย
            <select value={voice.selectedVoice?.voiceURI || ""} className="max-w-full rounded border p-2"
              onChange={e => { voice.stop(); voice.setVoiceURI(e.target.value); }}>
              {voice.voices.map(v => <option key={v.voiceURI} value={v.voiceURI}>{v.name}</option>)}
            </select>
          </label>
          <label className="flex items-center gap-2">ความเร็ว
            <select value={voice.rate} className="rounded border p-2"
              onChange={e => { voice.stop(); voice.setRate(Number(e.target.value)); }}>
              {[0.8, 1, 1.2].map(rate => <option key={rate} value={rate}>{rate}×</option>)}
            </select>
          </label>
          <label className="flex items-center gap-2">
            <input type="checkbox" checked={voice.autoRead} onChange={e => {
              voice.setAutoRead(e.target.checked);
              if (e.target.checked && !disabled) voice.read("เปิดการอ่านคำตอบอัตโนมัติแล้ว", "preview");
              else voice.stop();
            }} />
            อ่านคำตอบใหม่อัตโนมัติเมื่อ AI ตอบเสร็จ
          </label>
          <Button type="button" variant="outline" size="sm" disabled={disabled}
            onClick={() => voice.read("สวัสดีค่ะ พร้อมฝึกสอบ Long Case แล้วค่ะ", "preview")}>
            <Volume2 className="h-4 w-4" /> ทดสอบเสียง
          </Button>
        </> : <p className="text-xs text-gray-600">ไม่พบเสียงไทยแบบ local กรุณาติดตั้งเสียงไทยในการตั้งค่าอุปกรณ์ แล้วเปิดหน้าใหม่ การพิมพ์และระบบสอบยังใช้ได้ตามปกติ</p>}
      </fieldset>
    </details>
  );
}

export function ReadReplyButton({ voice, text, id, disabled = false }: {
  voice: ReturnType<typeof useLongCaseVoice>; text: string; id: string; disabled?: boolean;
}) {
  const playing = voice.speakingId === id;
  return <Button type="button" variant="ghost" size="sm" className="mt-1 h-8 text-xs"
    disabled={!voice.selectedVoice || disabled || !text.trim() || text === "..."}
    onClick={() => playing ? voice.stop() : voice.read(text, id)}>
    {playing ? <Square className="h-3 w-3" /> : <Volume2 className="h-3 w-3" />}
    {playing ? "หยุดอ่าน" : "อ่านคำตอบ"}
  </Button>;
}
