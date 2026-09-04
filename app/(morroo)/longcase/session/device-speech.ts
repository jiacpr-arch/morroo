// Browser speech only. No audio is uploaded to a Morroo/paid audio endpoint.
export type RecognitionResult = { isFinal: boolean; 0: { transcript: string } };
export type RecognitionEvent = { resultIndex: number; results: ArrayLike<RecognitionResult> };
export interface DeviceRecognition {
  lang: string;
  continuous: boolean;
  interimResults: boolean;
  processLocally?: boolean;
  onresult: ((event: RecognitionEvent) => void) | null;
  onerror: ((event: { error: string }) => void) | null;
  onend: (() => void) | null;
  start(): void;
  stop(): void;
  abort(): void;
}
export type RecognitionConstructor = {
  new(): DeviceRecognition;
  available?: (options: { langs: string[]; processLocally: boolean }) => Promise<string>;
};
export type SpeechWindow = Window & {
  SpeechRecognition?: RecognitionConstructor;
  webkitSpeechRecognition?: RecognitionConstructor;
};

export function appendDictation(current: string, transcript: string): string {
  const text = transcript.trim();
  if (!text) return current;
  return current + (current && !/\s$/.test(current) ? " " : "") + text;
}

export function localThaiVoices(voices: SpeechSynthesisVoice[]): SpeechSynthesisVoice[] {
  return voices.filter(voice => voice.localService && /^th(?:[-_]|$)/i.test(voice.lang));
}

export function speechChunks(text: string): string[] {
  // Remove visual Markdown, keep its readable text. Split long replies to avoid
  // device engines truncating large utterances. Array.from preserves Unicode.
  const clean = text.replace(/```[\s\S]*?```/g, " ")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/[*#_`>|]/g, " ").replace(/\s+/g, " ").trim();
  const chars = Array.from(clean);
  const chunks: string[] = [];
  while (chars.length) {
    let end = Math.min(180, chars.length);
    if (end < chars.length) {
      for (let i = end - 1; i >= 90; i--) {
        if (/[\s.!?。]/.test(chars[i])) { end = i + 1; break; }
      }
    }
    const chunk = chars.splice(0, end).join("").trim();
    if (chunk) chunks.push(chunk);
  }
  return chunks;
}

export function recognitionError(error: string): string {
  switch (error) {
    case "not-allowed":
    case "service-not-allowed": return "ไม่ได้รับอนุญาตใช้ไมค์ กรุณาตรวจสิทธิ์ไมโครโฟนของเว็บไซต์ หรือใช้ไมค์บนคีย์บอร์ด";
    case "audio-capture": return "ไม่พบไมโครโฟนที่ใช้งานได้ กรุณาตรวจการเชื่อมต่อไมค์";
    case "network": return "บริการถอดเสียงของเบราว์เซอร์เชื่อมต่อไม่ได้ ยังพิมพ์ตอบได้ตามปกติ";
    case "language-not-supported": return "เครื่องนี้ยังไม่รองรับการถอดเสียงไทยในโหมดที่เลือก ลองใช้ไมค์บนคีย์บอร์ด";
    case "no-speech": return "ยังไม่ได้ยินเสียงพูด กดไมค์เพื่อลองอีกครั้งได้";
    default: return "ถอดเสียงไม่สำเร็จ ลองใหม่หรือใช้ไมค์บนคีย์บอร์ด ข้อความเดิมยังอยู่";
  }
}
