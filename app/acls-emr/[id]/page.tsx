"use client";

import { useState, useEffect, useRef, use } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import {
  ArrowLeft,
  Download,
  Heart,
  User,
  Activity,
  Syringe,
  Zap,
  Clock,
  ClipboardList,
  Shield,
  FileText,
  Printer,
} from "lucide-react";
import type { AclsRecord } from "@/lib/types-acls";

const STORAGE_KEY = "acls-emr-records";

function InfoRow({
  label,
  value,
  className,
}: {
  label: string;
  value: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={className}>
      <p className="text-xs text-muted-foreground">{label}</p>
      <p className="text-sm font-medium">{value || "—"}</p>
    </div>
  );
}

function outcomeBadgeLarge(outcome: string) {
  switch (outcome) {
    case "ROSC":
      return (
        <Badge className="bg-green-100 text-green-700 text-sm px-3 py-1">
          ROSC
        </Badge>
      );
    case "Death":
      return (
        <Badge className="bg-red-100 text-red-700 text-sm px-3 py-1">
          เสียชีวิต
        </Badge>
      );
    case "Transfer":
      return (
        <Badge className="bg-blue-100 text-blue-700 text-sm px-3 py-1">
          ส่งต่อ
        </Badge>
      );
    default:
      return (
        <Badge className="bg-yellow-100 text-yellow-700 text-sm px-3 py-1">
          CPR ต่อ
        </Badge>
      );
  }
}

export default function AclsEmrDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const printRef = useRef<HTMLDivElement>(null);
  const [record, setRecord] = useState<AclsRecord | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    try {
      const all: AclsRecord[] = JSON.parse(
        localStorage.getItem(STORAGE_KEY) || "[]"
      );
      const found = all.find((r) => r.id === id);
      setRecord(found || null);
    } catch {
      setRecord(null);
    }
    setMounted(true);
  }, [id]);

  const handlePrint = () => {
    window.print();
  };

  const handleDownloadPdf = async () => {
    if (!printRef.current || !record) return;

    // Dynamic import to keep bundle small
    const html2canvas = (await import("html2canvas")).default;
    const { jsPDF } = await import("jspdf");

    const element = printRef.current;

    const canvas = await html2canvas(element, {
      scale: 2,
      useCORS: true,
      backgroundColor: "#ffffff",
    });

    const imgData = canvas.toDataURL("image/png");
    const pdf = new jsPDF("p", "mm", "a4");
    const pageWidth = pdf.internal.pageSize.getWidth();
    const pageHeight = pdf.internal.pageSize.getHeight();
    const margin = 10;
    const usableWidth = pageWidth - margin * 2;
    const imgHeight = (canvas.height * usableWidth) / canvas.width;

    let heightLeft = imgHeight;
    let position = margin;

    pdf.addImage(imgData, "PNG", margin, position, usableWidth, imgHeight);
    heightLeft -= pageHeight - margin * 2;

    while (heightLeft > 0) {
      position = -(pageHeight - margin * 2 - (imgHeight - heightLeft)) + margin;
      pdf.addPage();
      pdf.addImage(imgData, "PNG", margin, position, usableWidth, imgHeight);
      heightLeft -= pageHeight - margin * 2;
    }

    const filename = `ACLS_${record.patient_name.replace(/\s+/g, "_")}_${record.arrest_date}.pdf`;
    pdf.save(filename);
  };

  if (!mounted) {
    return (
      <div className="flex items-center justify-center min-h-[40vh]">
        <Activity className="h-8 w-8 animate-pulse text-brand" />
      </div>
    );
  }

  if (!record) {
    return (
      <div className="text-center py-16">
        <FileText className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
        <h2 className="text-xl font-semibold mb-2">ไม่พบบันทึก</h2>
        <Link href="/acls-emr">
          <Button variant="outline" className="gap-1 mt-4">
            <ArrowLeft className="h-4 w-4" /> กลับหน้ารายการ
          </Button>
        </Link>
      </div>
    );
  }

  return (
    <>
      {/* Header — hidden in print */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6 print:hidden">
        <div className="flex items-center gap-3">
          <Link href="/acls-emr">
            <Button variant="ghost" size="icon" className="shrink-0">
              <ArrowLeft className="h-4 w-4" />
            </Button>
          </Link>
          <div>
            <h1 className="text-2xl font-bold flex items-center gap-2">
              <Heart className="h-5 w-5 text-red-500" />
              ACLS Record
            </h1>
            <p className="text-muted-foreground text-sm mt-0.5">
              สร้างเมื่อ{" "}
              {new Date(record.created_at).toLocaleDateString("th-TH", {
                day: "numeric",
                month: "long",
                year: "numeric",
                hour: "2-digit",
                minute: "2-digit",
              })}
            </p>
          </div>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            onClick={handlePrint}
            className="gap-1.5"
          >
            <Printer className="h-4 w-4" /> พิมพ์
          </Button>
          <Button
            onClick={handleDownloadPdf}
            className="bg-brand hover:bg-brand-light text-white gap-1.5"
          >
            <Download className="h-4 w-4" /> ดาวน์โหลด PDF
          </Button>
        </div>
      </div>

      {/* ═══ Printable content ═══ */}
      <div ref={printRef} className="space-y-6 print:space-y-4">
        {/* PDF header — only visible in print */}
        <div className="hidden print:block text-center mb-4">
          <h1 className="text-xl font-bold">ACLS Resuscitation Record</h1>
          <p className="text-sm text-gray-500">
            หมอรู้ (MorRoo) — บันทึกการกู้ชีพขั้นสูง
          </p>
          <Separator className="mt-3" />
        </div>

        {/* Patient & Arrest Info */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center gap-2">
                <User className="h-4 w-4" /> ข้อมูลผู้ป่วย
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-3">
                <InfoRow label="ชื่อ" value={record.patient_name} />
                <InfoRow label="HN" value={record.patient_hn} />
                <InfoRow
                  label="อายุ / เพศ"
                  value={`${record.patient_age} ปี / ${record.patient_gender === "M" ? "ชาย" : "หญิง"}`}
                />
                <InfoRow
                  label="น้ำหนัก"
                  value={
                    record.patient_weight
                      ? `${record.patient_weight} kg`
                      : undefined
                  }
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center gap-2">
                <Activity className="h-4 w-4" /> ข้อมูล Arrest
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-3">
                <InfoRow
                  label="วัน-เวลา"
                  value={`${new Date(record.arrest_date).toLocaleDateString("th-TH", { day: "numeric", month: "short", year: "2-digit" })} ${record.arrest_time}`}
                />
                <InfoRow label="สถานที่" value={record.arrest_location} />
                <InfoRow
                  label="Initial Rhythm"
                  value={
                    <Badge variant="outline" className="font-mono">
                      {record.initial_rhythm}
                    </Badge>
                  }
                />
                <InfoRow
                  label="Witnessed / Bystander CPR"
                  value={`${record.witnessed ? "Yes" : "No"} / ${record.bystander_cpr ? "Yes" : "No"}`}
                />
                <InfoRow label="เริ่ม CPR" value={record.cpr_start_time} />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Team */}
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-base flex items-center gap-2">
              <Shield className="h-4 w-4" /> ทีมกู้ชีพ
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              <InfoRow label="Team Leader" value={record.team_leader} />
              <InfoRow label="Recorder" value={record.recorder} />
              <InfoRow label="สมาชิก" value={record.team_members} />
            </div>
          </CardContent>
        </Card>

        {/* Drugs */}
        {record.drugs.length > 0 && (
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center gap-2">
                <Syringe className="h-4 w-4" /> ยาที่ให้ ({record.drugs.length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b text-left">
                      <th className="pb-2 font-medium text-muted-foreground">
                        เวลา
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        ยา
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Dose
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Route
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {record.drugs.map((d) => (
                      <tr key={d.id} className="border-b last:border-0">
                        <td className="py-2 font-mono">{d.time}</td>
                        <td className="py-2">{d.drug}</td>
                        <td className="py-2">{d.dose}</td>
                        <td className="py-2">
                          <Badge variant="outline" className="text-xs">
                            {d.route}
                          </Badge>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Defibrillation */}
        {record.defibrillations.length > 0 && (
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center gap-2">
                <Zap className="h-4 w-4" /> Defibrillation (
                {record.defibrillations.length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b text-left">
                      <th className="pb-2 font-medium text-muted-foreground">
                        เวลา
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Energy
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Type
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Rhythm ก่อน
                      </th>
                      <th className="pb-2 font-medium text-muted-foreground">
                        Rhythm หลัง
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {record.defibrillations.map((d) => (
                      <tr key={d.id} className="border-b last:border-0">
                        <td className="py-2 font-mono">{d.time}</td>
                        <td className="py-2">{d.energy}J</td>
                        <td className="py-2">{d.type}</td>
                        <td className="py-2">{d.rhythm_before}</td>
                        <td className="py-2">{d.rhythm_after}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Timeline */}
        {record.timeline.length > 0 && (
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base flex items-center gap-2">
                <Clock className="h-4 w-4" /> Timeline
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="relative border-l-2 border-brand/30 pl-4 space-y-3 ml-2">
                {record.timeline.map((evt) => (
                  <div key={evt.id} className="relative">
                    <div className="absolute -left-[22px] top-1 w-3 h-3 rounded-full bg-brand border-2 border-white" />
                    <p className="text-xs text-muted-foreground font-mono">
                      {evt.time}
                    </p>
                    <p className="text-sm font-medium">{evt.event}</p>
                    {evt.detail && (
                      <p className="text-xs text-muted-foreground">
                        {evt.detail}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Airway, IV, Reversible Causes */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base">Airway & Access</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 gap-3">
                <InfoRow
                  label="Airway Management"
                  value={record.airway_management}
                />
                <InfoRow label="IV/IO Access" value={record.iv_access} />
              </div>
            </CardContent>
          </Card>

          {record.reversible_causes.length > 0 && (
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">
                  Reversible Causes (5H5T)
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="flex flex-wrap gap-1.5">
                  {record.reversible_causes.map((cause) => (
                    <Badge
                      key={cause}
                      variant="outline"
                      className="text-xs"
                    >
                      {cause}
                    </Badge>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </div>

        {/* Outcome */}
        <Card
          className={
            record.outcome === "ROSC"
              ? "border-green-200 bg-green-50/50"
              : record.outcome === "Death"
              ? "border-red-200 bg-red-50/50"
              : ""
          }
        >
          <CardHeader className="pb-2">
            <CardTitle className="text-base flex items-center gap-2">
              <ClipboardList className="h-4 w-4" /> Outcome
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap items-start gap-6">
              <div>
                <p className="text-xs text-muted-foreground mb-1">ผลลัพธ์</p>
                {outcomeBadgeLarge(record.outcome)}
              </div>
              <InfoRow label="เวลาสิ้นสุด" value={record.end_time} />
              {record.rosc_time && (
                <InfoRow label="เวลา ROSC" value={record.rosc_time} />
              )}
              {record.total_duration_min != null && (
                <InfoRow
                  label="ระยะเวลา"
                  value={`${record.total_duration_min} นาที`}
                />
              )}
            </div>
            {record.post_rosc_care && (
              <div className="mt-4">
                <p className="text-xs text-muted-foreground mb-1">
                  Post-ROSC Care
                </p>
                <p className="text-sm">{record.post_rosc_care}</p>
              </div>
            )}
            {record.notes && (
              <div className="mt-4">
                <p className="text-xs text-muted-foreground mb-1">หมายเหตุ</p>
                <p className="text-sm">{record.notes}</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Print footer */}
        <div className="hidden print:block text-center text-xs text-gray-400 pt-4 border-t">
          <p>
            Generated by หมอรู้ ACLS EMR —{" "}
            {new Date().toLocaleDateString("th-TH", {
              day: "numeric",
              month: "long",
              year: "numeric",
              hour: "2-digit",
              minute: "2-digit",
            })}
          </p>
        </div>
      </div>

      {/* Print styles */}
      <style jsx global>{`
        @media print {
          body > *:not(main),
          nav,
          footer,
          .print\\:hidden {
            display: none !important;
          }
          main {
            padding: 0 !important;
          }
          .print\\:block {
            display: block !important;
          }
          @page {
            margin: 15mm;
            size: A4;
          }
        }
      `}</style>
    </>
  );
}
