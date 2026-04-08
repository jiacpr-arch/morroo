"use client";

import { useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import {
  ArrowLeft,
  ArrowRight,
  Check,
  Plus,
  Trash2,
  User,
  Activity,
  Syringe,
  Zap,
  ClipboardList,
  Heart,
} from "lucide-react";
import {
  type AclsFormData,
  type AclsDrugEntry,
  type AclsDefibrillation,
  type AclsTimelineEvent,
  type AclsRecord,
  INITIAL_FORM_DATA,
  RHYTHMS,
  REVERSIBLE_CAUSES_5H,
  REVERSIBLE_CAUSES_5T,
  COMMON_ACLS_DRUGS,
} from "@/lib/types-acls";

const STORAGE_KEY = "acls-emr-records";

const STEPS = [
  { label: "ผู้ป่วย", icon: User },
  { label: "Arrest Info", icon: Activity },
  { label: "ยา & Defibrillation", icon: Syringe },
  { label: "Timeline & Airway", icon: Zap },
  { label: "Outcome", icon: ClipboardList },
];

function uid() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

export default function AclsEmrNewPage() {
  const router = useRouter();
  const [step, setStep] = useState(0);
  const [form, setForm] = useState<AclsFormData>({ ...INITIAL_FORM_DATA });

  const set = useCallback(
    <K extends keyof AclsFormData>(key: K, value: AclsFormData[K]) => {
      setForm((prev) => ({ ...prev, [key]: value }));
    },
    []
  );

  const next = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));
  const prev = () => setStep((s) => Math.max(s - 1, 0));

  // ─── Drug helpers ───
  const addDrug = () => {
    const entry: AclsDrugEntry = {
      id: uid(),
      time: "",
      drug: COMMON_ACLS_DRUGS[0],
      dose: "",
      route: "IV",
    };
    set("drugs", [...form.drugs, entry]);
  };
  const updateDrug = (id: string, patch: Partial<AclsDrugEntry>) => {
    set(
      "drugs",
      form.drugs.map((d) => (d.id === id ? { ...d, ...patch } : d))
    );
  };
  const removeDrug = (id: string) => {
    set(
      "drugs",
      form.drugs.filter((d) => d.id !== id)
    );
  };

  // ─── Defib helpers ───
  const addDefib = () => {
    const entry: AclsDefibrillation = {
      id: uid(),
      time: "",
      energy: 200,
      type: "Biphasic",
      rhythm_before: form.initial_rhythm,
      rhythm_after: "VF",
    };
    set("defibrillations", [...form.defibrillations, entry]);
  };
  const updateDefib = (
    id: string,
    patch: Partial<AclsDefibrillation>
  ) => {
    set(
      "defibrillations",
      form.defibrillations.map((d) => (d.id === id ? { ...d, ...patch } : d))
    );
  };
  const removeDefib = (id: string) => {
    set(
      "defibrillations",
      form.defibrillations.filter((d) => d.id !== id)
    );
  };

  // ─── Timeline helpers ───
  const addEvent = () => {
    const entry: AclsTimelineEvent = { id: uid(), time: "", event: "" };
    set("timeline", [...form.timeline, entry]);
  };
  const updateEvent = (id: string, patch: Partial<AclsTimelineEvent>) => {
    set(
      "timeline",
      form.timeline.map((e) => (e.id === id ? { ...e, ...patch } : e))
    );
  };
  const removeEvent = (id: string) => {
    set(
      "timeline",
      form.timeline.filter((e) => e.id !== id)
    );
  };

  // ─── Reversible causes toggle ───
  const toggleCause = (cause: string) => {
    const current = form.reversible_causes;
    if (current.includes(cause)) {
      set(
        "reversible_causes",
        current.filter((c) => c !== cause)
      );
    } else {
      set("reversible_causes", [...current, cause]);
    }
  };

  // ─── Save ───
  const handleSave = () => {
    const record: AclsRecord = {
      ...form,
      id: uid(),
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    // Calculate duration
    if (form.cpr_start_time && form.end_time) {
      const [sh, sm] = form.cpr_start_time.split(":").map(Number);
      const [eh, em] = form.end_time.split(":").map(Number);
      const diff = (eh * 60 + em) - (sh * 60 + sm);
      record.total_duration_min = diff > 0 ? diff : undefined;
    }

    const existing = (() => {
      try {
        return JSON.parse(localStorage.getItem(STORAGE_KEY) || "[]");
      } catch {
        return [];
      }
    })();

    localStorage.setItem(STORAGE_KEY, JSON.stringify([...existing, record]));
    router.push(`/acls-emr/${record.id}`);
  };

  return (
    <>
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/acls-emr">
          <Button variant="ghost" size="icon" className="shrink-0">
            <ArrowLeft className="h-4 w-4" />
          </Button>
        </Link>
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Heart className="h-5 w-5 text-red-500" />
            บันทึก ACLS ใหม่
          </h1>
          <p className="text-muted-foreground text-sm mt-0.5">
            กรอกข้อมูลการกู้ชีพทีละขั้นตอน
          </p>
        </div>
      </div>

      {/* Step indicator */}
      <div className="flex items-center gap-1 mb-6 overflow-x-auto pb-2">
        {STEPS.map((s, i) => {
          const Icon = s.icon;
          const active = i === step;
          const done = i < step;
          return (
            <button
              key={i}
              onClick={() => setStep(i)}
              className={`flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-medium transition-colors whitespace-nowrap ${
                active
                  ? "bg-brand text-white"
                  : done
                  ? "bg-brand/10 text-brand"
                  : "bg-muted text-muted-foreground hover:bg-muted/80"
              }`}
            >
              {done ? (
                <Check className="h-3.5 w-3.5" />
              ) : (
                <Icon className="h-3.5 w-3.5" />
              )}
              <span className="hidden sm:inline">{s.label}</span>
              <span className="sm:hidden">{i + 1}</span>
            </button>
          );
        })}
      </div>

      {/* Step content */}
      <Card className="mb-6">
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            {(() => {
              const Icon = STEPS[step].icon;
              return <Icon className="h-4 w-4" />;
            })()}
            {STEPS[step].label}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {/* ─── Step 0: Patient ─── */}
          {step === 0 && (
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="patient_name">ชื่อผู้ป่วย *</Label>
                <Input
                  id="patient_name"
                  value={form.patient_name}
                  onChange={(e) => set("patient_name", e.target.value)}
                  placeholder="ชื่อ-สกุล"
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="patient_hn">HN</Label>
                <Input
                  id="patient_hn"
                  value={form.patient_hn || ""}
                  onChange={(e) => set("patient_hn", e.target.value)}
                  placeholder="Hospital Number"
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="patient_age">อายุ (ปี) *</Label>
                <Input
                  id="patient_age"
                  type="number"
                  min={0}
                  max={150}
                  value={form.patient_age || ""}
                  onChange={(e) => set("patient_age", parseInt(e.target.value) || 0)}
                  className="mt-1"
                />
              </div>
              <div>
                <Label>เพศ *</Label>
                <div className="flex gap-2 mt-1">
                  {(["M", "F"] as const).map((g) => (
                    <button
                      key={g}
                      onClick={() => set("patient_gender", g)}
                      className={`flex-1 py-2 rounded-lg border text-sm font-medium transition-colors ${
                        form.patient_gender === g
                          ? "bg-brand text-white border-brand"
                          : "border-input hover:bg-muted"
                      }`}
                    >
                      {g === "M" ? "ชาย" : "หญิง"}
                    </button>
                  ))}
                </div>
              </div>
              <div>
                <Label htmlFor="patient_weight">น้ำหนัก (kg)</Label>
                <Input
                  id="patient_weight"
                  type="number"
                  min={0}
                  value={form.patient_weight ?? ""}
                  onChange={(e) =>
                    set(
                      "patient_weight",
                      e.target.value ? parseFloat(e.target.value) : undefined
                    )
                  }
                  className="mt-1"
                />
              </div>
            </div>
          )}

          {/* ─── Step 1: Arrest Info ─── */}
          {step === 1 && (
            <div className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="arrest_date">วันที่ Arrest *</Label>
                  <Input
                    id="arrest_date"
                    type="date"
                    value={form.arrest_date}
                    onChange={(e) => set("arrest_date", e.target.value)}
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="arrest_time">เวลา Arrest *</Label>
                  <Input
                    id="arrest_time"
                    type="time"
                    value={form.arrest_time}
                    onChange={(e) => set("arrest_time", e.target.value)}
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="arrest_location">สถานที่ *</Label>
                  <Input
                    id="arrest_location"
                    value={form.arrest_location}
                    onChange={(e) => set("arrest_location", e.target.value)}
                    placeholder="เช่น Ward 7, ER, ICU"
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label>Initial Rhythm *</Label>
                  <select
                    value={form.initial_rhythm}
                    onChange={(e) => set("initial_rhythm", e.target.value as typeof form.initial_rhythm)}
                    className="mt-1 w-full h-8 rounded-lg border border-input bg-transparent px-2.5 text-sm outline-none focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50"
                  >
                    {RHYTHMS.map((r) => (
                      <option key={r} value={r}>
                        {r}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="flex flex-wrap gap-4">
                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={form.witnessed}
                    onChange={(e) => set("witnessed", e.target.checked)}
                    className="rounded border-input h-4 w-4 accent-brand"
                  />
                  <span className="text-sm">Witnessed arrest</span>
                </label>
                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={form.bystander_cpr}
                    onChange={(e) => set("bystander_cpr", e.target.checked)}
                    className="rounded border-input h-4 w-4 accent-brand"
                  />
                  <span className="text-sm">Bystander CPR</span>
                </label>
              </div>
              <Separator />
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <Label htmlFor="team_leader">Team Leader *</Label>
                  <Input
                    id="team_leader"
                    value={form.team_leader}
                    onChange={(e) => set("team_leader", e.target.value)}
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="recorder">Recorder *</Label>
                  <Input
                    id="recorder"
                    value={form.recorder}
                    onChange={(e) => set("recorder", e.target.value)}
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="team_members">สมาชิกทีม</Label>
                  <Input
                    id="team_members"
                    value={form.team_members || ""}
                    onChange={(e) => set("team_members", e.target.value)}
                    placeholder="คั่นด้วย comma"
                    className="mt-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="cpr_start_time">เวลาเริ่ม CPR *</Label>
                <Input
                  id="cpr_start_time"
                  type="time"
                  value={form.cpr_start_time}
                  onChange={(e) => set("cpr_start_time", e.target.value)}
                  className="mt-1 max-w-xs"
                />
              </div>
            </div>
          )}

          {/* ─── Step 2: Drugs & Defibrillation ─── */}
          {step === 2 && (
            <div className="space-y-6">
              {/* Drugs */}
              <div>
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-semibold text-sm flex items-center gap-1.5">
                    <Syringe className="h-4 w-4" /> ยาที่ให้
                  </h3>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={addDrug}
                    className="gap-1"
                  >
                    <Plus className="h-3.5 w-3.5" /> เพิ่มยา
                  </Button>
                </div>
                {form.drugs.length === 0 && (
                  <p className="text-sm text-muted-foreground text-center py-4 border rounded-lg border-dashed">
                    ยังไม่มียาที่บันทึก — กด &quot;เพิ่มยา&quot;
                  </p>
                )}
                <div className="space-y-2">
                  {form.drugs.map((drug) => (
                    <div
                      key={drug.id}
                      className="grid grid-cols-[80px_1fr_100px_70px_32px] gap-2 items-end"
                    >
                      <div>
                        <Label className="text-xs">เวลา</Label>
                        <Input
                          type="time"
                          value={drug.time}
                          onChange={(e) =>
                            updateDrug(drug.id, { time: e.target.value })
                          }
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">ยา</Label>
                        <select
                          value={drug.drug}
                          onChange={(e) =>
                            updateDrug(drug.id, { drug: e.target.value })
                          }
                          className="mt-0.5 w-full h-8 rounded-lg border border-input bg-transparent px-2 text-sm outline-none focus-visible:border-ring"
                        >
                          {COMMON_ACLS_DRUGS.map((d) => (
                            <option key={d} value={d}>
                              {d}
                            </option>
                          ))}
                          <option value="Other">อื่นๆ</option>
                        </select>
                      </div>
                      <div>
                        <Label className="text-xs">Dose</Label>
                        <Input
                          value={drug.dose}
                          onChange={(e) =>
                            updateDrug(drug.id, { dose: e.target.value })
                          }
                          placeholder="dose"
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">Route</Label>
                        <select
                          value={drug.route}
                          onChange={(e) =>
                            updateDrug(drug.id, {
                              route: e.target.value as "IV" | "IO" | "ET",
                            })
                          }
                          className="mt-0.5 w-full h-8 rounded-lg border border-input bg-transparent px-2 text-sm outline-none focus-visible:border-ring"
                        >
                          <option value="IV">IV</option>
                          <option value="IO">IO</option>
                          <option value="ET">ET</option>
                        </select>
                      </div>
                      <button
                        onClick={() => removeDrug(drug.id)}
                        className="h-8 w-8 flex items-center justify-center rounded-lg text-red-500 hover:bg-red-50"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  ))}
                </div>
              </div>

              <Separator />

              {/* Defibrillation */}
              <div>
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-semibold text-sm flex items-center gap-1.5">
                    <Zap className="h-4 w-4" /> Defibrillation
                  </h3>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={addDefib}
                    className="gap-1"
                  >
                    <Plus className="h-3.5 w-3.5" /> เพิ่ม Shock
                  </Button>
                </div>
                {form.defibrillations.length === 0 && (
                  <p className="text-sm text-muted-foreground text-center py-4 border rounded-lg border-dashed">
                    ไม่มี Defibrillation
                  </p>
                )}
                <div className="space-y-2">
                  {form.defibrillations.map((d) => (
                    <div
                      key={d.id}
                      className="grid grid-cols-[80px_80px_90px_1fr_1fr_32px] gap-2 items-end"
                    >
                      <div>
                        <Label className="text-xs">เวลา</Label>
                        <Input
                          type="time"
                          value={d.time}
                          onChange={(e) =>
                            updateDefib(d.id, { time: e.target.value })
                          }
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">Joules</Label>
                        <Input
                          type="number"
                          value={d.energy}
                          onChange={(e) =>
                            updateDefib(d.id, {
                              energy: parseInt(e.target.value) || 0,
                            })
                          }
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">Type</Label>
                        <select
                          value={d.type}
                          onChange={(e) =>
                            updateDefib(d.id, {
                              type: e.target.value as "Monophasic" | "Biphasic",
                            })
                          }
                          className="mt-0.5 w-full h-8 rounded-lg border border-input bg-transparent px-2 text-xs outline-none focus-visible:border-ring"
                        >
                          <option value="Biphasic">Biphasic</option>
                          <option value="Monophasic">Monophasic</option>
                        </select>
                      </div>
                      <div>
                        <Label className="text-xs">Rhythm ก่อน</Label>
                        <select
                          value={d.rhythm_before}
                          onChange={(e) =>
                            updateDefib(d.id, {
                              rhythm_before: e.target.value as typeof d.rhythm_before,
                            })
                          }
                          className="mt-0.5 w-full h-8 rounded-lg border border-input bg-transparent px-2 text-xs outline-none focus-visible:border-ring"
                        >
                          {RHYTHMS.map((r) => (
                            <option key={r} value={r}>
                              {r}
                            </option>
                          ))}
                        </select>
                      </div>
                      <div>
                        <Label className="text-xs">Rhythm หลัง</Label>
                        <select
                          value={d.rhythm_after}
                          onChange={(e) =>
                            updateDefib(d.id, {
                              rhythm_after: e.target.value as typeof d.rhythm_after,
                            })
                          }
                          className="mt-0.5 w-full h-8 rounded-lg border border-input bg-transparent px-2 text-xs outline-none focus-visible:border-ring"
                        >
                          {RHYTHMS.map((r) => (
                            <option key={r} value={r}>
                              {r}
                            </option>
                          ))}
                        </select>
                      </div>
                      <button
                        onClick={() => removeDefib(d.id)}
                        className="h-8 w-8 flex items-center justify-center rounded-lg text-red-500 hover:bg-red-50"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* ─── Step 3: Timeline & Airway ─── */}
          {step === 3 && (
            <div className="space-y-6">
              {/* Timeline */}
              <div>
                <div className="flex items-center justify-between mb-3">
                  <h3 className="font-semibold text-sm">Timeline Events</h3>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={addEvent}
                    className="gap-1"
                  >
                    <Plus className="h-3.5 w-3.5" /> เพิ่ม Event
                  </Button>
                </div>
                {form.timeline.length === 0 && (
                  <p className="text-sm text-muted-foreground text-center py-4 border rounded-lg border-dashed">
                    ยังไม่มี Event
                  </p>
                )}
                <div className="space-y-2">
                  {form.timeline.map((evt) => (
                    <div
                      key={evt.id}
                      className="grid grid-cols-[80px_1fr_1fr_32px] gap-2 items-end"
                    >
                      <div>
                        <Label className="text-xs">เวลา</Label>
                        <Input
                          type="time"
                          value={evt.time}
                          onChange={(e) =>
                            updateEvent(evt.id, { time: e.target.value })
                          }
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">Event</Label>
                        <Input
                          value={evt.event}
                          onChange={(e) =>
                            updateEvent(evt.id, { event: e.target.value })
                          }
                          placeholder="เช่น Intubation, Pulse check"
                          className="mt-0.5"
                        />
                      </div>
                      <div>
                        <Label className="text-xs">รายละเอียด</Label>
                        <Input
                          value={evt.detail || ""}
                          onChange={(e) =>
                            updateEvent(evt.id, { detail: e.target.value })
                          }
                          className="mt-0.5"
                        />
                      </div>
                      <button
                        onClick={() => removeEvent(evt.id)}
                        className="h-8 w-8 flex items-center justify-center rounded-lg text-red-500 hover:bg-red-50"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  ))}
                </div>
              </div>

              <Separator />

              {/* Airway & IV */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="airway">Airway Management</Label>
                  <Input
                    id="airway"
                    value={form.airway_management}
                    onChange={(e) => set("airway_management", e.target.value)}
                    placeholder="เช่น ET tube 7.5, LMA, BVM"
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="iv_access">IV/IO Access</Label>
                  <Input
                    id="iv_access"
                    value={form.iv_access}
                    onChange={(e) => set("iv_access", e.target.value)}
                    placeholder="เช่น IV 20G Lt. AC, IO Rt. tibia"
                    className="mt-1"
                  />
                </div>
              </div>

              <Separator />

              {/* Reversible Causes 5H5T */}
              <div>
                <h3 className="font-semibold text-sm mb-3">
                  Reversible Causes (5H & 5T)
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <p className="text-xs font-medium text-muted-foreground mb-2">
                      5H
                    </p>
                    <div className="space-y-1.5">
                      {REVERSIBLE_CAUSES_5H.map((cause) => (
                        <label
                          key={cause}
                          className="flex items-center gap-2 cursor-pointer"
                        >
                          <input
                            type="checkbox"
                            checked={form.reversible_causes.includes(cause)}
                            onChange={() => toggleCause(cause)}
                            className="rounded border-input h-4 w-4 accent-brand"
                          />
                          <span className="text-sm">{cause}</span>
                        </label>
                      ))}
                    </div>
                  </div>
                  <div>
                    <p className="text-xs font-medium text-muted-foreground mb-2">
                      5T
                    </p>
                    <div className="space-y-1.5">
                      {REVERSIBLE_CAUSES_5T.map((cause) => (
                        <label
                          key={cause}
                          className="flex items-center gap-2 cursor-pointer"
                        >
                          <input
                            type="checkbox"
                            checked={form.reversible_causes.includes(cause)}
                            onChange={() => toggleCause(cause)}
                            className="rounded border-input h-4 w-4 accent-brand"
                          />
                          <span className="text-sm">{cause}</span>
                        </label>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ─── Step 4: Outcome ─── */}
          {step === 4 && (
            <div className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <Label>Outcome *</Label>
                  <div className="grid grid-cols-2 gap-2 mt-1">
                    {(
                      [
                        { value: "ROSC", label: "ROSC", color: "green" },
                        { value: "Death", label: "เสียชีวิต", color: "red" },
                        { value: "Transfer", label: "ส่งต่อ", color: "blue" },
                        {
                          value: "Ongoing CPR",
                          label: "CPR ต่อ",
                          color: "yellow",
                        },
                      ] as const
                    ).map((opt) => (
                      <button
                        key={opt.value}
                        onClick={() => set("outcome", opt.value)}
                        className={`py-2.5 rounded-lg border text-sm font-medium transition-colors ${
                          form.outcome === opt.value
                            ? opt.color === "green"
                              ? "bg-green-600 text-white border-green-600"
                              : opt.color === "red"
                              ? "bg-red-600 text-white border-red-600"
                              : opt.color === "blue"
                              ? "bg-blue-600 text-white border-blue-600"
                              : "bg-yellow-500 text-white border-yellow-500"
                            : "border-input hover:bg-muted"
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>
                <div>
                  <Label htmlFor="end_time">เวลาสิ้นสุด *</Label>
                  <Input
                    id="end_time"
                    type="time"
                    value={form.end_time}
                    onChange={(e) => set("end_time", e.target.value)}
                    className="mt-1"
                  />
                  {form.outcome === "ROSC" && (
                    <div className="mt-3">
                      <Label htmlFor="rosc_time">เวลา ROSC</Label>
                      <Input
                        id="rosc_time"
                        type="time"
                        value={form.rosc_time || ""}
                        onChange={(e) => set("rosc_time", e.target.value)}
                        className="mt-1"
                      />
                    </div>
                  )}
                </div>
              </div>

              {form.outcome === "ROSC" && (
                <div>
                  <Label htmlFor="post_rosc">Post-ROSC Care</Label>
                  <Textarea
                    id="post_rosc"
                    value={form.post_rosc_care || ""}
                    onChange={(e) => set("post_rosc_care", e.target.value)}
                    placeholder="เช่น TTM, PCI, ICU admission..."
                    className="mt-1"
                    rows={3}
                  />
                </div>
              )}

              <div>
                <Label htmlFor="notes">หมายเหตุ</Label>
                <Textarea
                  id="notes"
                  value={form.notes || ""}
                  onChange={(e) => set("notes", e.target.value)}
                  placeholder="บันทึกเพิ่มเติม..."
                  className="mt-1"
                  rows={3}
                />
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Navigation */}
      <div className="flex items-center justify-between">
        <Button
          variant="outline"
          onClick={prev}
          disabled={step === 0}
          className="gap-1"
        >
          <ArrowLeft className="h-4 w-4" /> ก่อนหน้า
        </Button>

        {step < STEPS.length - 1 ? (
          <Button
            onClick={next}
            className="bg-brand hover:bg-brand-light text-white gap-1"
          >
            ถัดไป <ArrowRight className="h-4 w-4" />
          </Button>
        ) : (
          <Button
            onClick={handleSave}
            className="bg-green-600 hover:bg-green-700 text-white gap-1"
            disabled={!form.patient_name || !form.team_leader}
          >
            <Check className="h-4 w-4" /> บันทึก
          </Button>
        )}
      </div>
    </>
  );
}
