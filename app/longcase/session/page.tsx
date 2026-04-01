"use client";

import { useState, useEffect, useRef, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Loader2, Send, ChevronRight, CheckCircle, MessageSquare, Stethoscope, FlaskConical, Brain, ClipboardList, Star, Plus, Trash2, Lightbulb, Eye, ChevronDown, ChevronUp, Timer, FileText } from "lucide-react";
import type { LongCaseSession, LongCaseFull } from "@/lib/types";

type Phase = LongCaseSession["phase"];

const PE_SYSTEMS = ["GA", "HEENT", "Heart", "Lung", "Abdomen", "GU", "Extremities", "Neuro", "Skin"];

const COMMON_LABS = [
  "CBC", "BMP", "LFT", "Coagulation", "UA", "UPT",
  "Troponin I", "CK-MB", "BNP", "Lactate", "Blood culture",
  "Sputum AFB", "CXR", "ECG", "Scrotal US", "Transvaginal US",
  "CT Abdomen", "CT Head", "MRI Brain", "Echo",
];

function LongCaseSessionInner() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const sessionId = searchParams.get("id");

  const [session, setSession] = useState<LongCaseSession | null>(null);
  const [lc, setLc] = useState<Partial<LongCaseFull> | null>(null);
  const [phase, setPhase] = useState<Phase>("history");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  // History chat
  const [chatInput, setChatInput] = useState("");
  const [chatMessages, setChatMessages] = useState<{ role: "user" | "assistant"; content: string }[]>([]);
  const [chatLoading, setChatLoading] = useState(false);

  // PE
  const [peSelected, setPeSelected] = useState<string[]>([]);
  const [peRevealed, setPeRevealed] = useState<Record<string, string>>({});
  const [specialPeInput, setSpecialPeInput] = useState("");

  // Lab
  const [labOrdered, setLabOrdered] = useState<string[]>([]);
  const [labRevealed, setLabRevealed] = useState<Record<string, { value: string; isAbnormal: boolean }>>({});
  const [labKeys, setLabKeys] = useState<string[]>([]);

  // DDx — individual ranked entries
  const [ddxEntries, setDdxEntries] = useState<string[]>(["", "", ""]);
  const [ddxSubmitted, setDdxSubmitted] = useState(false);
  const [ddxHint, setDdxHint] = useState("");

  // Management — individual order entries
  const [mgmtOrders, setMgmtOrders] = useState<{ text: string; confirmed: boolean }[]>([{ text: "", confirmed: false }]);
  const [mgmtHints, setMgmtHints] = useState<Record<number, string>>({});

  // Hint loading
  const [hintLoading, setHintLoading] = useState(false);

  // Answer reveal (after scoring)
  const [ddxRevealed, setDdxRevealed] = useState(false);
  const [acceptedDdx, setAcceptedDdx] = useState<string[]>([]);
  const [correctDiagnosis, setCorrectDiagnosis] = useState("");
  const [correctMgmt, setCorrectMgmt] = useState("");
  const [mgmtRevealed, setMgmtRevealed] = useState(false);
  const [labReviewRevealed, setLabReviewRevealed] = useState(false);

  // Collapsible summaries for later phases
  const [showHistorySummary, setShowHistorySummary] = useState(false);
  const [showPeSummary, setShowPeSummary] = useState(false);
  const [showLabSummary, setShowLabSummary] = useState(false);

  // Notes scratchpad
  const [notes, setNotes] = useState("");
  const [showNotes, setShowNotes] = useState(false);

  // Timer
  const [elapsedSeconds, setElapsedSeconds] = useState(0);
  const [timerActive, setTimerActive] = useState(true);

  // PE review in scoring
  const [peReviewRevealed, setPeReviewRevealed] = useState(false);

  // Case summary toggle
  const [showCaseSummary, setShowCaseSummary] = useState(false);

  // Legacy state for backward compat with save
  const [studentDdx, setStudentDdx] = useState("");
  const [studentMgmt, setStudentMgmt] = useState("");

  // Lab — batch reveal mode
  const [labPendingOrder, setLabPendingOrder] = useState<string[]>([]);
  const [labResultsRevealed, setLabResultsRevealed] = useState(false);
  const [showRecommended, setShowRecommended] = useState(false);
  const [customLabInput, setCustomLabInput] = useState("");

  // Examiner chat
  const [examInput, setExamInput] = useState("");
  const [examMessages, setExamMessages] = useState<{ role: "user" | "assistant"; content: string }[]>([]);
  const [examLoading, setExamLoading] = useState(false);
  const [examinerStarted, setExaminerStarted] = useState(false);

  // Scores
  const [scores, setScores] = useState<Record<string, number | string> | null>(null);
  const [teachingPoints, setTeachingPoints] = useState<string[]>([]);
  const [scoringLoading, setScoringLoading] = useState(false);

  // Load session
  useEffect(() => {
    if (!sessionId) return;
    fetch(`/api/longcase/session?id=${sessionId}`)
      .then(r => r.json())
      .then(data => {
        if (data.error) { setError(data.error); return; }
        setSession(data);
        setLc(data.long_case);
        setPhase(data.phase || "history");
        if (data.history_chat?.length) setChatMessages(data.history_chat);
        if (data.pe_selected?.length) setPeSelected(data.pe_selected);
        if (data.lab_ordered?.length) setLabOrdered(data.lab_ordered);
        if (data.student_ddx) {
          setStudentDdx(data.student_ddx);
          // Try parsing as JSON array; fallback to splitting by newlines
          try {
            const parsed = JSON.parse(data.student_ddx);
            if (Array.isArray(parsed) && parsed.length > 0) {
              setDdxEntries(parsed);
              setDdxSubmitted(true);
            }
          } catch {
            const lines = data.student_ddx.split("\n").map((l: string) => l.replace(/^\d+\.\s*/, "").trim()).filter(Boolean);
            if (lines.length > 0) { setDdxEntries(lines); setDdxSubmitted(true); }
          }
        }
        if (data.student_mgmt) {
          setStudentMgmt(data.student_mgmt);
          try {
            const parsed = JSON.parse(data.student_mgmt);
            if (Array.isArray(parsed) && parsed.length > 0) {
              setMgmtOrders(parsed.map((t: string) => ({ text: t, confirmed: true })));
            }
          } catch {
            const lines = data.student_mgmt.split("\n").filter((l: string) => l.trim());
            if (lines.length > 0) {
              setMgmtOrders(lines.map((t: string) => ({ text: t.trim(), confirmed: true })));
            }
          }
        }
        if (data.student_notes) setNotes(data.student_notes);
        // Restore lab revealed state
        if (data.lab_ordered?.length) {
          setLabPendingOrder(data.lab_ordered);
          setLabResultsRevealed(true);
        }
        if (data.examiner_chat?.length) setExamMessages(data.examiner_chat);
        if (data.score_total_pct !== null) {
          setScores({
            score_history: data.score_history,
            score_pe: data.score_pe,
            score_lab: data.score_lab,
            score_ddx: data.score_ddx,
            score_management: data.score_management,
            score_examiner: data.score_examiner,
            score_total_pct: data.score_total_pct,
            feedback: data.feedback,
          });
        }
      })
      .catch(() => setError("ไม่สามารถโหลด session ได้"))
      .finally(() => setLoading(false));
  }, [sessionId]);

  // Scroll within the chat container only — not the whole page
  const chatContainerRef = useRef<HTMLDivElement>(null);
  const examContainerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const container = chatContainerRef.current;
    if (container) container.scrollTop = container.scrollHeight;
  }, [chatMessages]);

  useEffect(() => {
    const container = examContainerRef.current;
    if (container) container.scrollTop = container.scrollHeight;
  }, [examMessages]);

  useEffect(() => {
    if (phase === "lab" && sessionId && labKeys.length === 0) {
      fetch(`/api/longcase/session?id=${sessionId}&includeLabKeys=true`)
        .then(r => r.json())
        .then(data => {
          const keys = [
            ...(data.long_case?.lab_keys || []),
            ...(data.long_case?.imaging_keys || []),
          ];
          if (keys.length > 0) setLabKeys(keys);
        })
        .catch(() => {});
    }
  }, [phase, sessionId, labKeys.length]);

  // Timer — counts up while case is active
  useEffect(() => {
    if (phase === "done" || !timerActive) return;
    const interval = setInterval(() => setElapsedSeconds(s => s + 1), 1000);
    return () => clearInterval(interval);
  }, [phase, timerActive]);

  // Calculate elapsed from session start
  useEffect(() => {
    if (session?.started_at) {
      const start = new Date(session.started_at).getTime();
      const now = Date.now();
      setElapsedSeconds(Math.floor((now - start) / 1000));
    }
  }, [session?.started_at]);

  // Stop timer when done
  useEffect(() => {
    if (phase === "done") setTimerActive(false);
  }, [phase]);

  // Auto-save notes with debounce
  const notesTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => {
    if (!sessionId || !notes) return;
    if (notesTimerRef.current) clearTimeout(notesTimerRef.current);
    notesTimerRef.current = setTimeout(() => {
      fetch("/api/longcase/session", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, student_notes: notes }),
      });
    }, 1500);
    return () => { if (notesTimerRef.current) clearTimeout(notesTimerRef.current); };
  }, [notes, sessionId]);

  function formatTime(seconds: number) {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    if (h > 0) return `${h}:${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
    return `${m}:${String(s).padStart(2, "0")}`;
  }

  async function savePhase(newPhase: Phase, extra?: Record<string, unknown>) {
    await fetch("/api/longcase/session", {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ sessionId, phase: newPhase, ...extra }),
    });
    setPhase(newPhase);
  }

  async function sendChat() {
    if (!chatInput.trim() || chatLoading) return;
    const userMsg = { role: "user" as const, content: chatInput.trim() };
    const newMessages = [...chatMessages, userMsg];
    setChatMessages(newMessages);
    setChatInput("");
    setChatLoading(true);

    let aiText = "";
    setChatMessages(prev => [...prev, { role: "assistant", content: "..." }]);

    try {
      const res = await fetch("/api/ai/longcase-patient", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, messages: [userMsg] }),
      });
      const reader = res.body?.getReader();
      if (!reader) return;
      const decoder = new TextDecoder();
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        const lines = decoder.decode(value).split("\n");
        for (const line of lines) {
          if (!line.startsWith("data: ")) continue;
          const parsed = JSON.parse(line.slice(6));
          if (parsed.text) {
            aiText += parsed.text;
            setChatMessages(prev => [...prev.slice(0, -1), { role: "assistant", content: aiText }]);
          }
        }
      }
    } finally {
      setChatLoading(false);
    }
  }

  async function revealPe(systems: string[]) {
    const res = await fetch(`/api/longcase/session?id=${sessionId}&includePe=true`);
    const data = await res.json();
    const findings = data.long_case?.pe_findings || {};
    const revealed: Record<string, string> = {};
    for (const sys of systems) revealed[sys] = findings[sys] || "ปกติ ไม่มีสิ่งผิดปกติ";
    setPeRevealed(prev => ({ ...prev, ...revealed }));
  }

  async function revealLabs(labs: string[]) {
    const res = await fetch(`/api/longcase/session?id=${sessionId}&includeLab=true`);
    const data = await res.json();
    const results = data.long_case?.lab_results || {};
    const revealed: Record<string, { value: string; isAbnormal: boolean }> = {};
    for (const lab of labs) revealed[lab] = results[lab] || { value: "ไม่มีผลในระบบ", isAbnormal: false };
    setLabRevealed(prev => ({ ...prev, ...revealed }));
  }

  async function fetchHint(type: "ddx" | "management", input: string) {
    setHintLoading(true);
    try {
      const res = await fetch("/api/ai/longcase-hint", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, type, input }),
      });
      const data = await res.json();
      return data.hint || "";
    } catch {
      return "";
    } finally {
      setHintLoading(false);
    }
  }

  async function fetchAnswers() {
    const res = await fetch(`/api/longcase/session?id=${sessionId}&includeAnswers=true`);
    const data = await res.json();
    if (data.long_case?.accepted_ddx) setAcceptedDdx(data.long_case.accepted_ddx);
    if (data.long_case?.correct_diagnosis) setCorrectDiagnosis(data.long_case.correct_diagnosis);
    if (data.long_case?.management_plan) setCorrectMgmt(data.long_case.management_plan);
  }

  async function startExaminer() {
    setExamLoading(true);
    setExaminerStarted(true);
    let aiText = "";
    setExamMessages([{ role: "assistant", content: "..." }]);

    try {
      const res = await fetch("/api/ai/longcase-examiner", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, messages: [], action: "start" }),
      });
      const reader = res.body?.getReader();
      if (!reader) return;
      const decoder = new TextDecoder();
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        for (const line of decoder.decode(value).split("\n")) {
          if (!line.startsWith("data: ")) continue;
          const parsed = JSON.parse(line.slice(6));
          if (parsed.text) {
            aiText += parsed.text;
            setExamMessages([{ role: "assistant", content: aiText }]);
          }
        }
      }
    } finally {
      setExamLoading(false);
    }
  }

  async function sendExamChat() {
    if (!examInput.trim() || examLoading) return;
    const userMsg = { role: "user" as const, content: examInput.trim() };
    const newMessages = [...examMessages, userMsg];
    setExamMessages(newMessages);
    setExamInput("");
    setExamLoading(true);

    let aiText = "";
    setExamMessages(prev => [...prev, { role: "assistant", content: "..." }]);

    try {
      const res = await fetch("/api/ai/longcase-examiner", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, messages: [userMsg], action: "chat" }),
      });
      const reader = res.body?.getReader();
      if (!reader) return;
      const decoder = new TextDecoder();
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        for (const line of decoder.decode(value).split("\n")) {
          if (!line.startsWith("data: ")) continue;
          const parsed = JSON.parse(line.slice(6));
          if (parsed.text) {
            aiText += parsed.text;
            setExamMessages(prev => [...prev.slice(0, -1), { role: "assistant", content: aiText }]);
          }
        }
      }
    } finally {
      setExamLoading(false);
    }
  }

  async function requestScore() {
    setScoringLoading(true);
    try {
      const res = await fetch("/api/ai/longcase-examiner", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionId, messages: [], action: "score" }),
      });
      const data = await res.json();
      if (data.error) { setError(data.error); return; }
      setScores(data);
      setTeachingPoints(data.teaching_points || []);
      setPhase("done");
    } catch {
      setError("ไม่สามารถประเมินคะแนนได้");
    } finally {
      setScoringLoading(false);
    }
  }

  const pi = lc?.patient_info as { name?: string; age?: number; gender?: string; underlying?: string[]; vitals?: Record<string, string | number> } | undefined;

  if (loading) return (
    <div className="flex items-center justify-center min-h-screen">
      <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
    </div>
  );
  if (error) return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="text-center">
        <p className="text-red-500 mb-4">{error}</p>
        <Button onClick={() => router.push("/longcase")}>กลับ</Button>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-amber-50/30">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-white border-b border-amber-200 px-4 py-3 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button onClick={() => router.push("/longcase")} className="text-sm text-gray-500 hover:text-gray-700">← กลับ</button>
          <span className="text-sm font-semibold text-amber-800 truncate max-w-[200px] sm:max-w-none">
            {lc?.title || "Long Case"}
          </span>
        </div>
        <div className="flex items-center gap-2">
          {phase !== "done" && (
            <span className="flex items-center gap-1 text-xs font-mono text-gray-500 bg-gray-100 px-2 py-1 rounded-md">
              <Timer className="h-3 w-3" />
              {formatTime(elapsedSeconds)}
            </span>
          )}
          <Badge className="bg-amber-100 text-amber-800">{lc?.specialty}</Badge>
          <Badge variant="outline" className="text-xs capitalize">{lc?.difficulty}</Badge>
        </div>
      </div>

      {/* Phase tabs */}
      <div className="bg-white border-b border-amber-100 px-4 py-2 flex gap-1 overflow-x-auto">
        {([
          { key: "history", icon: MessageSquare, label: "ซักประวัติ" },
          { key: "pe", icon: Stethoscope, label: "ตรวจร่างกาย" },
          { key: "lab", icon: FlaskConical, label: "Lab/Imaging" },
          { key: "ddx", icon: Brain, label: "DDx" },
          { key: "management", icon: ClipboardList, label: "Management" },
          { key: "examiner", icon: Star, label: "Examiner" },
        ] as const).map((tab) => {
          const Icon = tab.icon;
          const isActive = phase === tab.key;
          const isDone = (
            (tab.key === "history" && chatMessages.length > 0) ||
            (tab.key === "pe" && peSelected.length > 0) ||
            (tab.key === "lab" && labOrdered.length > 0) ||
            (tab.key === "ddx" && studentDdx) ||
            (tab.key === "management" && studentMgmt) ||
            (tab.key === "examiner" && examMessages.length > 0) ||
            phase === "done"
          );
          return (
            <button
              key={tab.key}
              onClick={() => setPhase(tab.key)}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors ${
                isActive ? "bg-amber-500 text-white" : "text-gray-500 hover:bg-amber-50 hover:text-amber-700"
              }`}
            >
              <Icon className="h-3.5 w-3.5" />
              {tab.label}
              {isDone && !isActive && <CheckCircle className="h-3 w-3 text-green-500" />}
            </button>
          );
        })}
      </div>

      <div className="max-w-3xl mx-auto px-4 py-6 space-y-4">
        {/* Patient Info Card (always visible) */}
        {pi && (
          <div className="rounded-xl border border-amber-200 bg-white p-4">
            <div className="flex flex-wrap gap-x-6 gap-y-1 text-sm">
              <span><span className="text-gray-500">ชื่อ:</span> <strong>{pi.name}</strong></span>
              <span><span className="text-gray-500">อายุ:</span> <strong>{pi.age} ปี</strong></span>
              <span><span className="text-gray-500">เพศ:</span> <strong>{pi.gender}</strong></span>
              {pi.underlying && pi.underlying.length > 0 && (
                <span><span className="text-gray-500">โรคประจำตัว:</span> <strong>{pi.underlying.join(", ")}</strong></span>
              )}
            </div>
            {pi.vitals && (
              <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-gray-600">
                {Object.entries(pi.vitals).map(([k, v]) => (
                  <span key={k}>{k}: <strong>{String(v)}</strong></span>
                ))}
              </div>
            )}
          </div>
        )}

        {/* History Summary — visible in later phases */}
        {phase !== "history" && phase !== "done" && chatMessages.length > 0 && (
          <div className="rounded-xl border border-gray-200 bg-white">
            <button
              onClick={() => setShowHistorySummary(prev => !prev)}
              className="w-full flex items-center justify-between px-4 py-2.5 text-left"
            >
              <span className="text-xs font-semibold text-gray-500 flex items-center gap-1.5">
                <MessageSquare className="h-3.5 w-3.5" />
                ประวัติที่ซักได้ ({chatMessages.filter(m => m.role === "user").length} คำถาม)
              </span>
              {showHistorySummary ? <ChevronUp className="h-4 w-4 text-gray-400" /> : <ChevronDown className="h-4 w-4 text-gray-400" />}
            </button>
            {showHistorySummary && (
              <div className="border-t border-gray-100 px-4 py-3 max-h-48 overflow-y-auto space-y-2">
                {chatMessages.map((m, i) => (
                  <div key={i} className={`text-xs ${m.role === "user" ? "text-amber-700" : "text-gray-600"}`}>
                    <span className="font-semibold">{m.role === "user" ? "คุณ:" : "ผู้ป่วย:"}</span>{" "}
                    {m.content.length > 150 ? m.content.slice(0, 150) + "..." : m.content}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* PE Findings Summary — visible in lab/ddx/management/examiner phases */}
        {["lab", "ddx", "management", "examiner"].includes(phase) && peSelected.length > 0 && (
          <div className="rounded-xl border border-gray-200 bg-white">
            <button
              onClick={() => setShowPeSummary(prev => !prev)}
              className="w-full flex items-center justify-between px-4 py-2.5 text-left"
            >
              <span className="text-xs font-semibold text-gray-500 flex items-center gap-1.5">
                <Stethoscope className="h-3.5 w-3.5" />
                PE ที่ตรวจ ({peSelected.length} ระบบ)
              </span>
              {showPeSummary ? <ChevronUp className="h-4 w-4 text-gray-400" /> : <ChevronDown className="h-4 w-4 text-gray-400" />}
            </button>
            {showPeSummary && (
              <div className="border-t border-gray-100 px-4 py-3 max-h-48 overflow-y-auto space-y-1.5">
                {peSelected.map(sys => (
                  <div key={sys} className="text-xs">
                    <span className="font-semibold text-gray-700">{sys}:</span>{" "}
                    <span className={peRevealed[sys]?.includes("ปกติ") ? "text-gray-500" : "text-red-600 font-medium"}>
                      {peRevealed[sys] || "รอผล"}
                    </span>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Lab Results Summary — visible in ddx/management/examiner phases */}
        {["ddx", "management", "examiner"].includes(phase) && labOrdered.length > 0 && (
          <div className="rounded-xl border border-gray-200 bg-white">
            <button
              onClick={() => setShowLabSummary(prev => !prev)}
              className="w-full flex items-center justify-between px-4 py-2.5 text-left"
            >
              <span className="text-xs font-semibold text-gray-500 flex items-center gap-1.5">
                <FlaskConical className="h-3.5 w-3.5" />
                Lab/Imaging ที่สั่ง ({labOrdered.length} รายการ)
              </span>
              {showLabSummary ? <ChevronUp className="h-4 w-4 text-gray-400" /> : <ChevronDown className="h-4 w-4 text-gray-400" />}
            </button>
            {showLabSummary && (
              <div className="border-t border-gray-100 px-4 py-3 max-h-48 overflow-y-auto space-y-1.5">
                {labOrdered.map(name => {
                  const res = labRevealed[name];
                  return (
                    <div key={name} className="text-xs">
                      <span className="font-semibold text-gray-700">{name}:</span>{" "}
                      {res ? (
                        <span className={res.isAbnormal ? "text-red-600 font-medium" : "text-gray-500"}>
                          {res.value}{res.isAbnormal && " [ผิดปกติ]"}
                        </span>
                      ) : (
                        <span className="text-gray-400">ไม่มีผล</span>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}

        {/* Notes Scratchpad — available in all active phases */}
        {phase !== "done" && (
          <div className="rounded-xl border border-gray-200 bg-white">
            <button
              onClick={() => setShowNotes(prev => !prev)}
              className="w-full flex items-center justify-between px-4 py-2.5 text-left"
            >
              <span className="text-xs font-semibold text-gray-500 flex items-center gap-1.5">
                <ClipboardList className="h-3.5 w-3.5" />
                โน้ตส่วนตัว
                {notes.trim() && <span className="bg-amber-100 text-amber-700 px-1.5 py-0.5 rounded-full text-[10px]">มีบันทึก</span>}
              </span>
              {showNotes ? <ChevronUp className="h-4 w-4 text-gray-400" /> : <ChevronDown className="h-4 w-4 text-gray-400" />}
            </button>
            {showNotes && (
              <div className="border-t border-gray-100 px-4 py-3">
                <Textarea
                  rows={4}
                  value={notes}
                  onChange={e => setNotes(e.target.value)}
                  placeholder="จดบันทึก, สรุปข้อมูล, ข้อสังเกต... (บันทึกอัตโนมัติ)"
                  className="text-xs resize-none"
                />
                <p className="text-[10px] text-gray-400 mt-1 text-right">บันทึกอัตโนมัติ</p>
              </div>
            )}
          </div>
        )}

        {/* === HISTORY === */}
        {phase === "history" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <MessageSquare className="h-5 w-5" /> ซักประวัติ
            </h2>
            <p className="text-sm text-gray-500">คุยกับผู้ป่วย AI ซักประวัติให้ครบถ้วน แล้วกด "เสร็จแล้ว"</p>
            <div ref={chatContainerRef} className="space-y-3 max-h-80 overflow-y-auto">
              {chatMessages.map((m, i) => (
                <div key={i} className={`flex ${m.role === "user" ? "justify-end" : "justify-start"}`}>
                  <div className={`max-w-[80%] rounded-xl px-4 py-2.5 text-sm ${
                    m.role === "user"
                      ? "bg-amber-500 text-white"
                      : "bg-gray-100 text-gray-800"
                  }`}>
                    {m.role === "assistant" && <p className="text-xs font-semibold text-gray-500 mb-1">👤 ผู้ป่วย</p>}
                    {m.content}
                  </div>
                </div>
              ))}
              {chatLoading && <div className="text-xs text-gray-400 animate-pulse">ผู้ป่วยกำลังตอบ...</div>}
            </div>
            <div className="flex gap-2">
              <Textarea
                rows={2}
                value={chatInput}
                onChange={e => setChatInput(e.target.value)}
                placeholder="ถามผู้ป่วย เช่น เจ็บที่ไหน เจ็บมากี่วัน..."
                onKeyDown={e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); sendChat(); } }}
                className="flex-1 resize-none"
              />
              <Button onClick={sendChat} disabled={chatLoading} size="icon" className="bg-amber-500 hover:bg-amber-600 h-auto">
                <Send className="h-4 w-4" />
              </Button>
            </div>
            <Button onClick={() => savePhase("pe")} disabled={chatMessages.length < 4} className="w-full bg-amber-500 hover:bg-amber-600 text-white">
              เสร็จซักประวัติ → ไปตรวจร่างกาย <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === PE === */}
        {phase === "pe" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <Stethoscope className="h-5 w-5" /> ตรวจร่างกาย
            </h2>
            <p className="text-sm text-gray-500">เลือกระบบที่ต้องการตรวจ (เห็นผลเฉพาะที่เลือก)</p>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
              {PE_SYSTEMS.map(sys => {
                const selected = peSelected.includes(sys);
                const revealed = peRevealed[sys];
                return (
                  <div key={sys} className={`rounded-lg border p-3 cursor-pointer transition-colors ${selected ? "border-amber-400 bg-amber-50" : "border-gray-200 hover:border-amber-200"}`}
                    onClick={async () => {
                      if (!selected) {
                        const newSelected = [...peSelected, sys];
                        setPeSelected(newSelected);
                        await revealPe([sys]);
                        await fetch("/api/longcase/session", {
                          method: "PUT",
                          headers: { "Content-Type": "application/json" },
                          body: JSON.stringify({ sessionId, pe_selected: newSelected }),
                        });
                      }
                    }}
                  >
                    <div className="font-medium text-sm text-gray-800">{sys}</div>
                    {revealed && <p className={`text-xs mt-1 ${revealed.includes("ปกติ") ? "text-gray-500" : "text-red-600 font-medium"}`}>{revealed}</p>}
                    {!revealed && selected && <p className="text-xs text-amber-500 mt-1">โหลด...</p>}
                  </div>
                );
              })}
            </div>
            {/* Special Examination */}
            <div className="border-t border-gray-100 pt-3">
              <p className="text-xs text-gray-400 font-medium mb-2">Special Examination</p>
              <div className="flex gap-2">
                <Input
                  value={specialPeInput}
                  onChange={e => setSpecialPeInput(e.target.value)}
                  placeholder="เช่น Kernig's sign, McBurney's point, Brudzinski..."
                  onKeyDown={async e => {
                    if (e.key === "Enter" && specialPeInput.trim()) {
                      const name = specialPeInput.trim();
                      const newSelected = [...peSelected, name];
                      setPeSelected(newSelected);
                      setSpecialPeInput("");
                      await revealPe([name]);
                      await fetch("/api/longcase/session", {
                        method: "PUT",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({ sessionId, pe_selected: newSelected }),
                      });
                    }
                  }}
                  className="flex-1"
                />
                <Button
                  variant="outline"
                  size="icon"
                  className="shrink-0"
                  onClick={async () => {
                    if (!specialPeInput.trim()) return;
                    const name = specialPeInput.trim();
                    const newSelected = [...peSelected, name];
                    setPeSelected(newSelected);
                    setSpecialPeInput("");
                    await revealPe([name]);
                    await fetch("/api/longcase/session", {
                      method: "PUT",
                      headers: { "Content-Type": "application/json" },
                      body: JSON.stringify({ sessionId, pe_selected: newSelected }),
                    });
                  }}
                >
                  <Plus className="h-4 w-4" />
                </Button>
              </div>
              {/* Show special PE results */}
              {peSelected.filter(s => !PE_SYSTEMS.includes(s)).length > 0 && (
                <div className="mt-2 space-y-1">
                  {peSelected.filter(s => !PE_SYSTEMS.includes(s)).map(s => (
                    <div key={s} className="rounded-lg border border-amber-300 bg-amber-50 p-2 text-sm">
                      <span className="font-medium text-gray-800">{s}</span>
                      {peRevealed[s] && (
                        <span className={`ml-2 text-xs ${peRevealed[s].includes("ปกติ") ? "text-gray-500" : "text-red-600 font-medium"}`}>
                          — {peRevealed[s]}
                        </span>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>

            <Button onClick={() => savePhase("lab")} disabled={peSelected.length === 0} className="w-full bg-amber-500 hover:bg-amber-600 text-white">
              เสร็จแล้ว → สั่ง Lab/Imaging <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === LAB === */}
        {phase === "lab" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <FlaskConical className="h-5 w-5" /> สั่ง Lab / Imaging
            </h2>
            <p className="text-sm text-gray-500">
              เลือกการตรวจที่ต้องการสั่ง แล้วกด &quot;ส่งตรวจ&quot; เพื่อดูผลทั้งหมดพร้อมกัน
            </p>

            {/* Selected labs summary */}
            {labPendingOrder.length > 0 && !labResultsRevealed && (
              <div className="rounded-lg border border-amber-300 bg-amber-50 p-3">
                <p className="text-xs font-semibold text-amber-700 mb-2">รายการที่สั่ง ({labPendingOrder.length} รายการ)</p>
                <div className="flex flex-wrap gap-1.5">
                  {labPendingOrder.map(name => (
                    <span key={name} className="inline-flex items-center gap-1 bg-amber-100 text-amber-800 text-xs px-2 py-1 rounded-full">
                      {name}
                      <button onClick={() => setLabPendingOrder(prev => prev.filter(n => n !== name))} className="hover:text-red-600">
                        <Trash2 className="h-3 w-3" />
                      </button>
                    </span>
                  ))}
                </div>
                <Button
                  onClick={async () => {
                    setLabOrdered(labPendingOrder);
                    await revealLabs(labPendingOrder);
                    await fetch("/api/longcase/session", {
                      method: "PUT",
                      headers: { "Content-Type": "application/json" },
                      body: JSON.stringify({ sessionId, lab_ordered: labPendingOrder }),
                    });
                    setLabResultsRevealed(true);
                  }}
                  className="mt-3 w-full bg-blue-600 hover:bg-blue-700 text-white"
                >
                  <Eye className="h-4 w-4 mr-1" /> ส่งตรวจ — ดูผลทั้งหมด
                </Button>
              </div>
            )}

            {/* Results after reveal */}
            {labResultsRevealed && labOrdered.length > 0 && (
              <div className="rounded-lg border border-green-300 bg-green-50 p-3 space-y-2">
                <p className="text-xs font-semibold text-green-700">ผลการตรวจ</p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  {labOrdered.map(name => {
                    const res = labRevealed[name];
                    return (
                      <div key={name} className="rounded-lg border border-green-200 bg-white p-2.5">
                        <div className="font-medium text-sm text-gray-800">{name}</div>
                        {res ? (
                          <p className={`text-xs mt-0.5 ${res.isAbnormal ? "text-red-600 font-semibold" : "text-gray-500"}`}>
                            {res.value} {res.isAbnormal && " [ผิดปกติ]"}
                          </p>
                        ) : (
                          <p className="text-xs text-gray-400 mt-0.5">รอผล...</p>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Lab selection — only show when not yet revealed */}
            {!labResultsRevealed && (
              <>
                {/* Hint toggle for recommended labs */}
                {labKeys.length > 0 && (
                  <button
                    onClick={() => setShowRecommended(prev => !prev)}
                    className="flex items-center gap-1.5 text-xs text-blue-600 hover:text-blue-800 transition-colors"
                  >
                    <Lightbulb className="h-3.5 w-3.5" />
                    {showRecommended ? "ซ่อนคำแนะนำ" : "ดูคำแนะนำสำหรับเคสนี้"}
                    {showRecommended ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />}
                  </button>
                )}

                {showRecommended && labKeys.length > 0 && (
                  <div className="rounded-lg border border-blue-200 bg-blue-50/50 p-3 space-y-2">
                    <p className="text-xs text-blue-600">Lab/Imaging ที่อาจเกี่ยวข้อง (ไม่จำเป็นต้องสั่งทั้งหมด)</p>
                    <div className="flex flex-wrap gap-2">
                      {labKeys.map(name => {
                        const isPending = labPendingOrder.includes(name);
                        return (
                          <button
                            key={name}
                            onClick={() => {
                              if (!isPending) setLabPendingOrder(prev => [...prev, name]);
                            }}
                            disabled={isPending}
                            className={`rounded-lg border px-3 py-1.5 text-xs font-medium transition-colors ${
                              isPending ? "border-blue-400 bg-blue-100 text-blue-700" : "border-blue-200 bg-white text-blue-700 hover:bg-blue-50"
                            }`}
                          >
                            {name} {isPending && <CheckCircle className="h-3 w-3 inline ml-1" />}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                )}

                {/* All labs grid */}
                <p className="text-xs text-gray-400 font-medium">เลือกการตรวจ</p>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                  {COMMON_LABS.map(name => {
                    const isPending = labPendingOrder.includes(name);
                    return (
                      <div key={name} className={`rounded-lg border p-3 cursor-pointer transition-colors ${
                        isPending ? "border-blue-400 bg-blue-50" : "border-gray-200 hover:border-blue-200"
                      }`}
                        onClick={() => {
                          if (isPending) {
                            setLabPendingOrder(prev => prev.filter(n => n !== name));
                          } else {
                            setLabPendingOrder(prev => [...prev, name]);
                          }
                        }}
                      >
                        <div className="font-medium text-sm text-gray-800 flex items-center gap-1">
                          {isPending && <CheckCircle className="h-3.5 w-3.5 text-blue-500" />}
                          {name}
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Custom lab input */}
                <div className="flex gap-2">
                  <Input
                    value={customLabInput}
                    onChange={e => setCustomLabInput(e.target.value)}
                    placeholder="พิมพ์ lab อื่นที่ต้องการ..."
                    onKeyDown={e => {
                      if (e.key === "Enter" && customLabInput.trim()) {
                        setLabPendingOrder(prev => [...prev, customLabInput.trim()]);
                        setCustomLabInput("");
                      }
                    }}
                    className="flex-1"
                  />
                  <Button
                    onClick={() => {
                      if (customLabInput.trim()) {
                        setLabPendingOrder(prev => [...prev, customLabInput.trim()]);
                        setCustomLabInput("");
                      }
                    }}
                    variant="outline"
                    size="icon"
                    className="shrink-0"
                  >
                    <Plus className="h-4 w-4" />
                  </Button>
                </div>
              </>
            )}

            <Button
              onClick={() => savePhase("ddx")}
              disabled={!labResultsRevealed || labOrdered.length === 0}
              className="w-full bg-amber-500 hover:bg-amber-600 text-white"
            >
              {!labResultsRevealed && labPendingOrder.length > 0
                ? "กด \"ส่งตรวจ\" เพื่อดูผลก่อน"
                : !labResultsRevealed
                ? "เลือก Lab แล้วกดส่งตรวจ"
                : "เสร็จแล้ว → เขียน DDx"}
              <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === DDx === */}
        {phase === "ddx" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <Brain className="h-5 w-5" /> Differential Diagnosis
            </h2>
            <p className="text-sm text-gray-500">
              ใส่ DDx ทีละโรค เรียงจากที่น่าจะเป็น <strong>มากที่สุด</strong> ไปน้อยที่สุด (อย่างน้อย 3 ข้อ)
            </p>

            {!ddxSubmitted ? (
              <>
                <div className="space-y-2">
                  {ddxEntries.map((entry, idx) => (
                    <div key={idx} className="flex items-center gap-2">
                      <span className="text-sm font-bold text-amber-600 w-6 text-center shrink-0">{idx + 1}.</span>
                      <Input
                        value={entry}
                        onChange={e => {
                          const updated = [...ddxEntries];
                          updated[idx] = e.target.value;
                          setDdxEntries(updated);
                        }}
                        placeholder={idx === 0 ? "โรคที่น่าจะเป็นมากที่สุด" : idx === 1 ? "โรคอันดับ 2" : `DDx อันดับ ${idx + 1}`}
                        className="flex-1"
                      />
                      {ddxEntries.length > 3 && (
                        <button
                          onClick={() => setDdxEntries(prev => prev.filter((_, i) => i !== idx))}
                          className="text-gray-400 hover:text-red-500 shrink-0"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      )}
                    </div>
                  ))}
                </div>

                <Button
                  variant="outline"
                  onClick={() => setDdxEntries(prev => [...prev, ""])}
                  className="w-full border-dashed border-amber-300 text-amber-700 hover:bg-amber-50"
                >
                  <Plus className="h-4 w-4 mr-1" /> เพิ่ม DDx
                </Button>

                <Button
                  onClick={async () => {
                    const validEntries = ddxEntries.filter(e => e.trim());
                    if (validEntries.length < 3) return;
                    const ddxJson = JSON.stringify(validEntries);
                    setStudentDdx(ddxJson);
                    setDdxSubmitted(true);
                    await fetch("/api/longcase/session", {
                      method: "PUT",
                      headers: { "Content-Type": "application/json" },
                      body: JSON.stringify({ sessionId, student_ddx: ddxJson }),
                    });
                    // Fetch hint from AI
                    const hint = await fetchHint("ddx", validEntries.map((e, i) => `${i + 1}. ${e}`).join("\n"));
                    if (hint) setDdxHint(hint);
                  }}
                  disabled={ddxEntries.filter(e => e.trim()).length < 3}
                  className="w-full bg-amber-500 hover:bg-amber-600 text-white"
                >
                  ยืนยัน DDx
                </Button>
              </>
            ) : (
              <>
                {/* Show submitted DDx list */}
                <div className="rounded-lg border border-green-200 bg-green-50 p-4 space-y-2">
                  <p className="text-xs font-semibold text-green-700 mb-2">DDx ที่ส่งแล้ว</p>
                  {ddxEntries.filter(e => e.trim()).map((entry, idx) => (
                    <div key={idx} className="flex items-center gap-2 text-sm">
                      <span className="font-bold text-green-600 w-6 text-center">{idx + 1}.</span>
                      <span className="text-gray-800">{entry}</span>
                    </div>
                  ))}
                </div>

                {hintLoading && !ddxHint && (
                  <div className="rounded-lg border border-blue-200 bg-blue-50 p-3 flex items-center gap-2">
                    <Loader2 className="h-4 w-4 text-blue-500 animate-spin" />
                    <p className="text-sm text-blue-600">กำลังสร้างคำแนะนำ...</p>
                  </div>
                )}

                {ddxHint && (
                  <div className="rounded-lg border border-blue-200 bg-blue-50 p-3 flex items-start gap-2">
                    <Lightbulb className="h-4 w-4 text-blue-500 mt-0.5 shrink-0" />
                    <p className="text-sm text-blue-700">{ddxHint}</p>
                  </div>
                )}

                <Button
                  onClick={() => setPhase("management")}
                  className="w-full bg-amber-500 hover:bg-amber-600 text-white"
                >
                  ไปเขียนแผนการรักษา <ChevronRight className="h-4 w-4 ml-1" />
                </Button>
              </>
            )}
          </div>
        )}

        {/* === Management === */}
        {phase === "management" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <ClipboardList className="h-5 w-5" /> แผนการรักษา (Orders)
            </h2>
            <p className="text-sm text-gray-500">
              เขียน order ทีละรายการ เหมือนเขียน order จริง กด OK เพื่อยืนยันแต่ละ order
            </p>

            {/* Confirmed orders */}
            <div className="space-y-2">
              {mgmtOrders.map((order, idx) => (
                <div key={idx}>
                  {order.confirmed ? (
                    <div className="flex items-start gap-2">
                      <div className="flex items-center gap-2 flex-1 rounded-lg border border-green-200 bg-green-50 p-3">
                        <CheckCircle className="h-4 w-4 text-green-500 shrink-0" />
                        <span className="text-sm text-gray-800">{order.text}</span>
                      </div>
                      <button
                        onClick={() => {
                          const updated = [...mgmtOrders];
                          updated[idx] = { ...updated[idx], confirmed: false };
                          setMgmtOrders(updated);
                        }}
                        className="text-xs text-gray-400 hover:text-gray-600 mt-2.5"
                      >
                        แก้ไข
                      </button>
                    </div>
                  ) : (
                    <div className="flex items-center gap-2">
                      <Input
                        value={order.text}
                        onChange={e => {
                          const updated = [...mgmtOrders];
                          updated[idx] = { ...updated[idx], text: e.target.value };
                          setMgmtOrders(updated);
                        }}
                        placeholder={idx === 0 ? "เช่น NSS 1000 mL IV drip 80 mL/hr" : "เขียน order ถัดไป..."}
                        onKeyDown={async e => {
                          if (e.key === "Enter" && order.text.trim()) {
                            const updated = [...mgmtOrders];
                            updated[idx] = { ...updated[idx], confirmed: true };
                            setMgmtOrders(updated);
                            const allOrders = updated.filter(o => o.confirmed).map(o => o.text);
                            const hint = await fetchHint("management", allOrders.map((t, i) => `${i + 1}. ${t}`).join("\n"));
                            if (hint) setMgmtHints(prev => ({ ...prev, [idx]: hint }));
                          }
                        }}
                        className="flex-1"
                      />
                      <Button
                        onClick={async () => {
                          if (!order.text.trim()) return;
                          const updated = [...mgmtOrders];
                          updated[idx] = { ...updated[idx], confirmed: true };
                          setMgmtOrders(updated);
                          const allOrders = updated.filter(o => o.confirmed).map(o => o.text);
                          const hint = await fetchHint("management", allOrders.map((t, i) => `${i + 1}. ${t}`).join("\n"));
                          if (hint) setMgmtHints(prev => ({ ...prev, [idx]: hint }));
                        }}
                        disabled={!order.text.trim()}
                        size="sm"
                        className="bg-green-600 hover:bg-green-700 text-white shrink-0"
                      >
                        OK
                      </Button>
                      {mgmtOrders.length > 1 && (
                        <button
                          onClick={() => setMgmtOrders(prev => prev.filter((_, i) => i !== idx))}
                          className="text-gray-400 hover:text-red-500 shrink-0"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      )}
                    </div>
                  )}

                  {/* Hint for confirmed order */}
                  {order.confirmed && hintLoading && !mgmtHints[idx] && idx === mgmtOrders.filter(o => o.confirmed).length - 1 && (
                    <div className="ml-6 mt-1 rounded-lg border border-blue-100 bg-blue-50 p-2 flex items-center gap-1.5">
                      <Loader2 className="h-3.5 w-3.5 text-blue-500 animate-spin" />
                      <p className="text-xs text-blue-600">กำลังสร้างคำแนะนำ...</p>
                    </div>
                  )}
                  {order.confirmed && mgmtHints[idx] && (
                    <div className="ml-6 mt-1 rounded-lg border border-blue-100 bg-blue-50 p-2 flex items-start gap-1.5">
                      <Lightbulb className="h-3.5 w-3.5 text-blue-500 mt-0.5 shrink-0" />
                      <p className="text-xs text-blue-700">{mgmtHints[idx]}</p>
                    </div>
                  )}
                </div>
              ))}
            </div>

            {/* Add new order — only if last order is confirmed */}
            {mgmtOrders.length > 0 && mgmtOrders[mgmtOrders.length - 1].confirmed && (
              <Button
                variant="outline"
                onClick={() => setMgmtOrders(prev => [...prev, { text: "", confirmed: false }])}
                className="w-full border-dashed border-amber-300 text-amber-700 hover:bg-amber-50"
              >
                <Plus className="h-4 w-4 mr-1" /> เพิ่ม Order
              </Button>
            )}

            <Button
              onClick={async () => {
                const confirmedOrders = mgmtOrders.filter(o => o.confirmed && o.text.trim());
                if (confirmedOrders.length === 0) return;
                const mgmtJson = JSON.stringify(confirmedOrders.map(o => o.text));
                setStudentMgmt(mgmtJson);
                await fetch("/api/longcase/session", {
                  method: "PUT",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({ sessionId, student_mgmt: mgmtJson }),
                });
                setPhase("examiner");
              }}
              disabled={mgmtOrders.filter(o => o.confirmed && o.text.trim()).length === 0}
              className="w-full bg-amber-500 hover:bg-amber-600 text-white"
            >
              เสร็จแล้ว → สัมภาษณ์ Examiner <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === Examiner === */}
        {phase === "examiner" && scores === null && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <Star className="h-5 w-5" /> การสัมภาษณ์กับ Examiner
            </h2>
            {!examinerStarted ? (
              <div className="text-center py-6">
                <p className="text-sm text-gray-600 mb-4">พร้อมสัมภาษณ์กับ Examiner AI หรือยัง?</p>
                <Button onClick={startExaminer} className="bg-amber-500 hover:bg-amber-600 text-white px-8">
                  เริ่มสัมภาษณ์
                </Button>
              </div>
            ) : (
              <>
                <div ref={examContainerRef} className="space-y-3 max-h-80 overflow-y-auto">
                  {examMessages.map((m, i) => (
                    <div key={i} className={`flex ${m.role === "user" ? "justify-end" : "justify-start"}`}>
                      <div className={`max-w-[85%] rounded-xl px-4 py-2.5 text-sm ${
                        m.role === "user" ? "bg-amber-500 text-white" : "bg-gray-100 text-gray-800"
                      }`}>
                        {m.role === "assistant" && <p className="text-xs font-semibold text-gray-500 mb-1">👨‍⚕️ Examiner</p>}
                        <p className="whitespace-pre-wrap">{m.content}</p>
                      </div>
                    </div>
                  ))}
                  {examLoading && <div className="text-xs text-gray-400 animate-pulse">Examiner กำลังพิมพ์...</div>}
                </div>
                <div className="flex gap-2">
                  <Textarea
                    rows={2}
                    value={examInput}
                    onChange={e => setExamInput(e.target.value)}
                    placeholder="ตอบ Examiner..."
                    onKeyDown={e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); sendExamChat(); } }}
                    className="flex-1 resize-none"
                  />
                  <Button onClick={sendExamChat} disabled={examLoading} size="icon" className="bg-amber-500 hover:bg-amber-600 h-auto">
                    <Send className="h-4 w-4" />
                  </Button>
                </div>
                {examMessages.length >= 8 && (
                  <Button
                    onClick={requestScore}
                    disabled={scoringLoading}
                    className="w-full bg-green-600 hover:bg-green-700 text-white"
                  >
                    {scoringLoading ? <><Loader2 className="h-4 w-4 mr-2 animate-spin" />กำลังคำนวณคะแนน...</> : "จบการสัมภาษณ์ → ดูคะแนน"}
                  </Button>
                )}
              </>
            )}
          </div>
        )}

        {/* === SCORES === */}
        {(phase === "done" || scores !== null) && scores && (
          <div className="rounded-xl border-2 border-green-400 bg-white p-6 space-y-5">
            <div className="text-center">
              <div className="text-5xl font-bold text-green-600">{scores.score_total_pct}%</div>
              <p className="text-gray-600 mt-1">คะแนนรวม</p>
              <div className={`inline-block mt-2 px-3 py-1 rounded-full text-sm font-semibold ${
                Number(scores.score_total_pct) >= 70 ? "bg-green-100 text-green-700" :
                Number(scores.score_total_pct) >= 50 ? "bg-yellow-100 text-yellow-700" :
                "bg-red-100 text-red-700"
              }`}>
                {Number(scores.score_total_pct) >= 70 ? "ผ่าน" : Number(scores.score_total_pct) >= 50 ? "ปรับปรุง" : "ต้องฝึกเพิ่ม"}
              </div>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              {[
                { label: "ซักประวัติ", key: "score_history" },
                { label: "ตรวจร่างกาย", key: "score_pe" },
                { label: "Lab/Imaging", key: "score_lab" },
                { label: "DDx", key: "score_ddx" },
                { label: "Management", key: "score_management" },
                { label: "Examiner", key: "score_examiner" },
              ].map(({ label, key }) => (
                <div key={key} className="rounded-lg bg-gray-50 p-3 text-center">
                  <div className="text-2xl font-bold text-gray-800">{scores[key] ?? "-"}</div>
                  <div className="text-xs text-gray-500 mt-0.5">{label}</div>
                </div>
              ))}
            </div>

            {/* Time taken */}
            {session?.started_at && session?.completed_at && (
              <div className="text-center text-sm text-gray-500">
                เวลาที่ใช้: {formatTime(Math.floor((new Date(session.completed_at).getTime() - new Date(session.started_at).getTime()) / 1000))}
              </div>
            )}

            {/* PE Review */}
            {peSelected.length > 0 && (
              <div className="rounded-lg bg-orange-50 border border-orange-200 p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-orange-800">🩺 ทบทวน PE</p>
                  {!peReviewRevealed && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => setPeReviewRevealed(true)}
                      className="text-orange-700 border-orange-300 hover:bg-orange-100"
                    >
                      <Eye className="h-3.5 w-3.5 mr-1" /> ดูรายละเอียด
                    </Button>
                  )}
                </div>

                {peReviewRevealed && (
                  <div className="space-y-1.5">
                    <p className="text-xs text-gray-500">ระบบที่ตรวจ ({peSelected.length}/{PE_SYSTEMS.length + peSelected.filter(s => !PE_SYSTEMS.includes(s)).length}):</p>
                    {peSelected.map(sys => (
                      <div key={sys} className="text-sm flex items-start gap-2">
                        <span className="font-medium text-orange-700 w-24 shrink-0">{sys}</span>
                        <span className={peRevealed[sys]?.includes("ปกติ") ? "text-gray-500" : "text-red-600 font-medium"}>
                          {peRevealed[sys] || "-"}
                        </span>
                      </div>
                    ))}
                    {/* Show systems NOT examined */}
                    {PE_SYSTEMS.filter(s => !peSelected.includes(s)).length > 0 && (
                      <div className="border-t border-orange-200 pt-2 mt-2">
                        <p className="text-xs text-gray-400 mb-1">ระบบที่ไม่ได้ตรวจ:</p>
                        <div className="flex flex-wrap gap-1.5">
                          {PE_SYSTEMS.filter(s => !peSelected.includes(s)).map(sys => (
                            <span key={sys} className="text-xs px-2 py-0.5 rounded-full bg-gray-100 text-gray-500">
                              {sys}
                            </span>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}

            {/* Lab Review */}
            {labOrdered.length > 0 && (
              <div className="rounded-lg bg-indigo-50 border border-indigo-200 p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-indigo-800">🔬 ทบทวน Lab/Imaging</p>
                  {!labReviewRevealed && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => setLabReviewRevealed(true)}
                      className="text-indigo-700 border-indigo-300 hover:bg-indigo-100"
                    >
                      <Eye className="h-3.5 w-3.5 mr-1" /> ดูรายละเอียด
                    </Button>
                  )}
                </div>

                {labReviewRevealed && (
                  <>
                    <div>
                      <p className="text-xs text-gray-500 mb-1">Lab ที่คุณสั่ง ({labOrdered.length} รายการ):</p>
                      <div className="flex flex-wrap gap-1.5">
                        {labOrdered.map(name => {
                          const isRecommended = labKeys.includes(name);
                          const res = labRevealed[name];
                          return (
                            <span key={name} className={`text-xs px-2 py-1 rounded-full ${
                              isRecommended
                                ? "bg-green-100 text-green-700 border border-green-300"
                                : "bg-gray-100 text-gray-600 border border-gray-200"
                            }`}>
                              {name}
                              {res?.isAbnormal && " ⚠️"}
                              {isRecommended && " ✓"}
                            </span>
                          );
                        })}
                      </div>
                    </div>

                    {labKeys.length > 0 && (
                      <div className="border-t border-indigo-200 pt-2">
                        <p className="text-xs text-gray-500 mb-1">Lab ที่ควรสั่งสำหรับเคสนี้:</p>
                        <div className="flex flex-wrap gap-1.5">
                          {labKeys.map(name => {
                            const ordered = labOrdered.includes(name);
                            return (
                              <span key={name} className={`text-xs px-2 py-1 rounded-full ${
                                ordered
                                  ? "bg-green-100 text-green-700 border border-green-300"
                                  : "bg-red-50 text-red-600 border border-red-200"
                              }`}>
                                {name} {ordered ? "✓" : "✗ ไม่ได้สั่ง"}
                              </span>
                            );
                          })}
                        </div>
                      </div>
                    )}
                  </>
                )}
              </div>
            )}

            {/* DDx Answer Reveal */}
            {ddxEntries.filter(e => e.trim()).length > 0 && (
              <div className="rounded-lg bg-purple-50 border border-purple-200 p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-purple-800">🧠 เฉลย DDx</p>
                  {!ddxRevealed && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={async () => {
                        await fetchAnswers();
                        setDdxRevealed(true);
                      }}
                      className="text-purple-700 border-purple-300 hover:bg-purple-100"
                    >
                      <Eye className="h-3.5 w-3.5 mr-1" /> ดูเฉลย
                    </Button>
                  )}
                </div>

                {/* Student's DDx */}
                <div>
                  <p className="text-xs text-gray-500 mb-1">DDx ของคุณ:</p>
                  {ddxEntries.filter(e => e.trim()).map((entry, idx) => (
                    <div key={idx} className="text-sm text-gray-700 flex items-center gap-1.5">
                      <span className="font-medium text-purple-600">{idx + 1}.</span> {entry}
                      {ddxRevealed && acceptedDdx.length > 0 && (
                        acceptedDdx.some(a => entry.toLowerCase().includes(a.toLowerCase()) || a.toLowerCase().includes(entry.toLowerCase()))
                          ? <CheckCircle className="h-3.5 w-3.5 text-green-500" />
                          : <span className="text-xs text-gray-400">—</span>
                      )}
                    </div>
                  ))}
                </div>

                {/* Accepted DDx */}
                {ddxRevealed && acceptedDdx.length > 0 && (
                  <div className="border-t border-purple-200 pt-2">
                    <p className="text-xs text-gray-500 mb-1">DDx ที่ยอมรับ:</p>
                    {acceptedDdx.map((ddx, idx) => (
                      <div key={idx} className="text-sm text-purple-700 flex items-center gap-1.5">
                        <span className="font-medium">{idx + 1}.</span> {ddx}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Management Answer Reveal */}
            {mgmtOrders.filter(o => o.confirmed && o.text.trim()).length > 0 && (
              <div className="rounded-lg bg-teal-50 border border-teal-200 p-4 space-y-3">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-teal-800">📋 เฉลย Management</p>
                  {!mgmtRevealed && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={async () => {
                        if (!correctMgmt) await fetchAnswers();
                        setMgmtRevealed(true);
                      }}
                      className="text-teal-700 border-teal-300 hover:bg-teal-100"
                    >
                      <Eye className="h-3.5 w-3.5 mr-1" /> ดูเฉลย
                    </Button>
                  )}
                </div>

                <div>
                  <p className="text-xs text-gray-500 mb-1">Orders ของคุณ:</p>
                  {mgmtOrders.filter(o => o.confirmed && o.text.trim()).map((order, idx) => (
                    <div key={idx} className="text-sm text-gray-700">
                      <span className="font-medium text-teal-600">{idx + 1}.</span> {order.text}
                    </div>
                  ))}
                </div>

                {mgmtRevealed && correctMgmt && (
                  <div className="border-t border-teal-200 pt-2">
                    <p className="text-xs text-gray-500 mb-1">แผนการรักษาที่ถูกต้อง:</p>
                    <p className="text-sm text-teal-700 whitespace-pre-wrap">{correctMgmt}</p>
                  </div>
                )}
              </div>
            )}

            {/* Correct Diagnosis */}
            {ddxRevealed && correctDiagnosis && (
              <div className="rounded-lg bg-green-50 border border-green-300 p-4">
                <p className="text-sm font-semibold text-green-800 mb-1">🎯 การวินิจฉัยที่ถูกต้อง</p>
                <p className="text-base font-bold text-green-700">{correctDiagnosis}</p>
              </div>
            )}

            {scores.feedback && (
              <div className="rounded-lg bg-blue-50 border border-blue-200 p-4">
                <p className="text-sm font-semibold text-blue-800 mb-1">💬 Feedback จาก Examiner</p>
                <p className="text-sm text-blue-700">{String(scores.feedback)}</p>
              </div>
            )}

            {teachingPoints.length > 0 && (
              <div className="rounded-lg bg-amber-50 border border-amber-200 p-4">
                <p className="text-sm font-semibold text-amber-800 mb-2">📚 Teaching Points</p>
                <ul className="space-y-1">
                  {teachingPoints.map((pt, i) => (
                    <li key={i} className="text-sm text-amber-700 flex items-start gap-2">
                      <span className="text-amber-500">•</span> {pt}
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {/* Complete Case Summary */}
            <div className="rounded-lg border border-gray-200 bg-gray-50">
              <button
                onClick={() => setShowCaseSummary(prev => !prev)}
                className="w-full flex items-center justify-between px-4 py-3 text-left"
              >
                <span className="text-sm font-semibold text-gray-700 flex items-center gap-2">
                  <FileText className="h-4 w-4" />
                  ดูสรุปเคสทั้งหมด
                </span>
                {showCaseSummary ? <ChevronUp className="h-4 w-4 text-gray-400" /> : <ChevronDown className="h-4 w-4 text-gray-400" />}
              </button>
              {showCaseSummary && (
                <div className="border-t border-gray-200 px-4 py-4 space-y-4 text-sm">
                  {/* History */}
                  {chatMessages.length > 0 && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">📝 ประวัติที่ซัก</p>
                      <div className="space-y-1 max-h-40 overflow-y-auto">
                        {chatMessages.map((m, i) => (
                          <div key={i} className={`text-xs ${m.role === "user" ? "text-amber-700" : "text-gray-600"}`}>
                            <span className="font-medium">{m.role === "user" ? "ถาม:" : "ตอบ:"}</span> {m.content}
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* PE */}
                  {peSelected.length > 0 && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">🩺 PE</p>
                      <div className="space-y-0.5">
                        {peSelected.map(sys => (
                          <div key={sys} className="text-xs">
                            <span className="font-medium">{sys}:</span>{" "}
                            <span className={peRevealed[sys]?.includes("ปกติ") ? "text-gray-500" : "text-red-600"}>
                              {peRevealed[sys] || "-"}
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Labs */}
                  {labOrdered.length > 0 && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">🔬 Lab/Imaging</p>
                      <div className="space-y-0.5">
                        {labOrdered.map(name => {
                          const res = labRevealed[name];
                          return (
                            <div key={name} className="text-xs">
                              <span className="font-medium">{name}:</span>{" "}
                              <span className={res?.isAbnormal ? "text-red-600" : "text-gray-500"}>
                                {res?.value || "ไม่มีผล"}{res?.isAbnormal && " [ผิดปกติ]"}
                              </span>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  )}

                  {/* DDx */}
                  {ddxEntries.filter(e => e.trim()).length > 0 && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">🧠 DDx</p>
                      {ddxEntries.filter(e => e.trim()).map((e, i) => (
                        <div key={i} className="text-xs text-gray-700">{i + 1}. {e}</div>
                      ))}
                    </div>
                  )}

                  {/* Management */}
                  {mgmtOrders.filter(o => o.confirmed && o.text.trim()).length > 0 && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">📋 Management Orders</p>
                      {mgmtOrders.filter(o => o.confirmed && o.text.trim()).map((o, i) => (
                        <div key={i} className="text-xs text-gray-700">{i + 1}. {o.text}</div>
                      ))}
                    </div>
                  )}

                  {/* Notes */}
                  {notes.trim() && (
                    <div>
                      <p className="font-semibold text-gray-700 mb-1">📒 โน้ต</p>
                      <p className="text-xs text-gray-600 whitespace-pre-wrap">{notes}</p>
                    </div>
                  )}
                </div>
              )}
            </div>

            <Button onClick={() => router.push("/longcase")} className="w-full" variant="outline">
              กลับไปเลือกเคสใหม่
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}

export default function LongCaseSessionPage() {
  return (
    <Suspense fallback={<div className="flex items-center justify-center min-h-screen"><Loader2 className="h-8 w-8 animate-spin text-amber-500" /></div>}>
      <LongCaseSessionInner />
    </Suspense>
  );
}
