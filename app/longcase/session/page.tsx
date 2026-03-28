"use client";

import { useState, useEffect, useRef, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Loader2, Send, ChevronRight, CheckCircle, MessageSquare, Stethoscope, FlaskConical, Brain, ClipboardList, Star } from "lucide-react";
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
  const chatEndRef = useRef<HTMLDivElement>(null);

  // PE
  const [peSelected, setPeSelected] = useState<string[]>([]);
  const [peRevealed, setPeRevealed] = useState<Record<string, string>>({});

  // Lab
  const [labOrdered, setLabOrdered] = useState<string[]>([]);
  const [labRevealed, setLabRevealed] = useState<Record<string, { value: string; isAbnormal: boolean }>>({});
  const [labKeys, setLabKeys] = useState<string[]>([]);

  // DDx + Management
  const [studentDdx, setStudentDdx] = useState("");
  const [studentMgmt, setStudentMgmt] = useState("");

  // Examiner chat
  const [examInput, setExamInput] = useState("");
  const [examMessages, setExamMessages] = useState<{ role: "user" | "assistant"; content: string }[]>([]);
  const [examLoading, setExamLoading] = useState(false);
  const [examinerStarted, setExaminerStarted] = useState(false);
  const examEndRef = useRef<HTMLDivElement>(null);

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
        if (data.student_ddx) setStudentDdx(data.student_ddx);
        if (data.student_mgmt) setStudentMgmt(data.student_mgmt);
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

  useEffect(() => { chatEndRef.current?.scrollIntoView({ behavior: "smooth" }); }, [chatMessages]);
  useEffect(() => { examEndRef.current?.scrollIntoView({ behavior: "smooth" }); }, [examMessages]);

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

        {/* === HISTORY === */}
        {phase === "history" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <MessageSquare className="h-5 w-5" /> ซักประวัติ
            </h2>
            <p className="text-sm text-gray-500">คุยกับผู้ป่วย AI ซักประวัติให้ครบถ้วน แล้วกด "เสร็จแล้ว"</p>
            <div className="space-y-3 max-h-80 overflow-y-auto">
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
              <div ref={chatEndRef} />
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
            <p className="text-sm text-gray-500">เลือกการตรวจที่ต้องการสั่ง (เห็นผลเฉพาะที่สั่ง)</p>

            {/* Recommended labs for this case */}
            {labKeys.length > 0 && (
              <div className="rounded-lg border border-blue-200 bg-blue-50 p-3 space-y-2">
                <p className="text-xs font-semibold text-blue-700">⭐ แนะนำสำหรับเคสนี้</p>
                <div className="flex flex-wrap gap-2">
                  {labKeys.map(name => {
                    const ordered = labOrdered.includes(name);
                    const res = labRevealed[name];
                    return (
                      <div
                        key={name}
                        onClick={async () => {
                          if (!ordered) {
                            const newOrdered = [...labOrdered, name];
                            setLabOrdered(newOrdered);
                            await revealLabs([name]);
                            await fetch("/api/longcase/session", {
                              method: "PUT",
                              headers: { "Content-Type": "application/json" },
                              body: JSON.stringify({ sessionId, lab_ordered: newOrdered }),
                            });
                          }
                        }}
                        className={`rounded-lg border p-2.5 cursor-pointer transition-colors min-w-[100px] ${ordered ? "border-blue-400 bg-white" : "border-blue-300 bg-white hover:bg-blue-100"}`}
                      >
                        <div className="font-medium text-sm text-blue-800">{name}</div>
                        {res && <p className={`text-xs mt-0.5 ${res.isAbnormal ? "text-red-600 font-medium" : "text-gray-500"}`}>{res.value}</p>}
                        {!res && ordered && <p className="text-xs text-blue-400 mt-0.5">โหลด...</p>}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* All labs */}
            <p className="text-xs text-gray-400 font-medium">การตรวจทั้งหมด</p>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
              {COMMON_LABS.map(name => {
                const ordered = labOrdered.includes(name);
                const res = labRevealed[name];
                const isRecommended = labKeys.includes(name);
                return (
                  <div key={name} className={`rounded-lg border p-3 cursor-pointer transition-colors ${
                    ordered ? "border-blue-400 bg-blue-50"
                    : isRecommended ? "border-blue-200 bg-blue-50/40 hover:border-blue-300"
                    : "border-gray-200 hover:border-blue-200"
                  }`}
                    onClick={async () => {
                      if (!ordered) {
                        const newOrdered = [...labOrdered, name];
                        setLabOrdered(newOrdered);
                        await revealLabs([name]);
                        await fetch("/api/longcase/session", {
                          method: "PUT",
                          headers: { "Content-Type": "application/json" },
                          body: JSON.stringify({ sessionId, lab_ordered: newOrdered }),
                        });
                      }
                    }}
                  >
                    <div className="font-medium text-sm text-gray-800 flex items-center gap-1">
                      {name}
                      {isRecommended && !ordered && <span className="text-blue-400 text-xs">★</span>}
                    </div>
                    {res && <p className={`text-xs mt-1 ${res.isAbnormal ? "text-red-600 font-medium" : "text-gray-500"}`}>{res.value}</p>}
                  </div>
                );
              })}
            </div>
            <Button onClick={() => savePhase("ddx")} disabled={labOrdered.length === 0} className="w-full bg-amber-500 hover:bg-amber-600 text-white">
              เสร็จแล้ว → เขียน DDx <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === DDx === */}
        {phase === "ddx" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <Brain className="h-5 w-5" /> Differential Diagnosis
            </h2>
            <p className="text-sm text-gray-500">เขียน DDx ของคุณ (อย่างน้อย 3 ข้อ เรียงตามความน่าจะเป็น)</p>
            <Textarea
              rows={5}
              value={studentDdx}
              onChange={e => setStudentDdx(e.target.value)}
              placeholder="1. ... (โรคที่น่าจะเป็นมากที่สุด)&#10;2. ...&#10;3. ..."
              className="resize-none"
            />
            <Button
              onClick={async () => {
                await fetch("/api/longcase/session", {
                  method: "PUT",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({ sessionId, student_ddx: studentDdx }),
                });
                setPhase("management");
              }}
              disabled={!studentDdx.trim()}
              className="w-full bg-amber-500 hover:bg-amber-600 text-white"
            >
              บันทึก DDx → เขียนแผนการรักษา <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        )}

        {/* === Management === */}
        {phase === "management" && (
          <div className="rounded-xl border border-amber-200 bg-white p-5 space-y-4">
            <h2 className="font-bold text-amber-800 flex items-center gap-2">
              <ClipboardList className="h-5 w-5" /> แผนการรักษา
            </h2>
            <p className="text-sm text-gray-500">เขียนแผนการรักษา Immediate + Definitive + Follow-up</p>
            <Textarea
              rows={6}
              value={studentMgmt}
              onChange={e => setStudentMgmt(e.target.value)}
              placeholder="Immediate management:&#10;...&#10;&#10;Definitive treatment:&#10;...&#10;&#10;Follow-up:&#10;..."
              className="resize-none"
            />
            <Button
              onClick={async () => {
                await fetch("/api/longcase/session", {
                  method: "PUT",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({ sessionId, student_mgmt: studentMgmt }),
                });
                setPhase("examiner");
              }}
              disabled={!studentMgmt.trim()}
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
                <div className="space-y-3 max-h-80 overflow-y-auto">
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
                  <div ref={examEndRef} />
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
