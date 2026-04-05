"use client";

import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  Shield,
  Loader2,
  ChevronLeft,
  BookOpen,
  Target,
  Clock,
  TrendingUp,
  AlertTriangle,
  ArrowRight,
} from "lucide-react";
import { AccuracyTrendChart } from "@/components/AccuracyTrendChart";

interface SubjectStat {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  avg_time_spent: number | null;
}

interface RecentSession {
  session_id: string;
  mode: string;
  exam_type: string;
  subject_name_th: string | null;
  subject_icon: string | null;
  total_questions: number;
  correct_count: number;
  accuracy: number;
  created_at: string;
  completed_at: string;
}

interface WeakTopic {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  wrong_count: number;
}

interface AccuracyTrend {
  week_start: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
}

interface StudentProfile {
  id: string;
  name: string;
  email: string;
  membership_type: string;
  created_at: string;
}

export default function AdminStudentDetailPage() {
  const router = useRouter();
  const params = useParams();
  const studentId = params.id as string;

  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [student, setStudent] = useState<StudentProfile | null>(null);
  const [subjectStats, setSubjectStats] = useState<SubjectStat[]>([]);
  const [recentSessions, setRecentSessions] = useState<RecentSession[]>([]);
  const [weakTopics, setWeakTopics] = useState<WeakTopic[]>([]);
  const [trend, setTrend] = useState<AccuracyTrend[]>([]);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();

      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }

      setIsAdmin(true);

      // Fetch student profile + all analytics in parallel
      const [profileRes, statsRes, sessionsRes, weakRes, trendRes] =
        await Promise.all([
          supabase
            .from("profiles")
            .select("id, name, email, membership_type, created_at")
            .eq("id", studentId)
            .single(),
          supabase.rpc("get_user_subject_stats", { p_user_id: studentId }),
          supabase.rpc("get_user_recent_sessions", {
            p_user_id: studentId,
            p_limit: 10,
          }),
          supabase.rpc("get_user_weak_topics", {
            p_user_id: studentId,
            p_threshold: 60,
          }),
          supabase.rpc("get_user_accuracy_trend", { p_user_id: studentId }),
        ]);

      setStudent(profileRes.data as StudentProfile | null);
      setSubjectStats((statsRes.data as SubjectStat[]) || []);
      setRecentSessions((sessionsRes.data as RecentSession[]) || []);
      setWeakTopics((weakRes.data as WeakTopic[]) || []);
      setTrend((trendRes.data as AccuracyTrend[]) || []);
      setLoading(false);
    }
    load();
  }, [router, studentId]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  if (!student) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <h1 className="text-2xl font-bold">ไม่พบนักเรียน</h1>
      </div>
    );
  }

  const totalAttempts = subjectStats.reduce((s, x) => s + x.total_attempts, 0);
  const totalCorrect = subjectStats.reduce((s, x) => s + x.correct_count, 0);
  const overallAccuracy =
    totalAttempts > 0
      ? Math.round((totalCorrect * 1000) / totalAttempts) / 10
      : 0;
  const bestSubject = [...subjectStats].sort(
    (a, b) => (b.accuracy ?? 0) - (a.accuracy ?? 0)
  )[0];
  const avgTime =
    subjectStats.length > 0
      ? Math.round(
          subjectStats.reduce((s, x) => s + (x.avg_time_spent ?? 0), 0) /
            subjectStats.filter((x) => x.avg_time_spent != null).length
        )
      : 0;

  const membershipLabel: Record<string, string> = {
    free: "Free",
    monthly: "Monthly",
    yearly: "Yearly",
    bundle: "Bundle",
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/students">
          <Button variant="ghost" size="sm">
            <ChevronLeft className="h-4 w-4 mr-1" />
            นักเรียนทั้งหมด
          </Button>
        </Link>
      </div>

      {/* Student Info Header */}
      <div className="flex items-center gap-4 mb-8">
        <div className="w-12 h-12 rounded-full bg-brand/10 flex items-center justify-center text-xl font-bold text-brand">
          {(student.name || student.email)?.[0]?.toUpperCase() || "?"}
        </div>
        <div>
          <h1 className="text-2xl font-bold">{student.name || "ไม่มีชื่อ"}</h1>
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <span>{student.email}</span>
            <Badge
              variant={
                student.membership_type === "free" ? "secondary" : "default"
              }
              className="text-xs"
            >
              {membershipLabel[student.membership_type] ||
                student.membership_type}
            </Badge>
          </div>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-brand/10 flex items-center justify-center">
                <BookOpen className="h-5 w-5 text-brand" />
              </div>
              <div>
                <p className="text-2xl font-bold">{totalAttempts}</p>
                <p className="text-xs text-muted-foreground">ข้อที่ทำแล้ว</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
                <Target className="h-5 w-5 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{overallAccuracy}%</p>
                <p className="text-xs text-muted-foreground">ถูกต้องรวม</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
                <TrendingUp className="h-5 w-5 text-blue-600" />
              </div>
              <div>
                <p className="text-lg font-bold truncate">
                  {bestSubject?.subject_icon} {bestSubject?.accuracy ?? 0}%
                </p>
                <p className="text-xs text-muted-foreground">เก่งที่สุด</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-orange-100 flex items-center justify-center">
                <Clock className="h-5 w-5 text-orange-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{avgTime}s</p>
                <p className="text-xs text-muted-foreground">เวลาเฉลี่ย/ข้อ</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Weak Topics */}
      {weakTopics.length > 0 && (
        <Card className="border-red-200 bg-red-50/50 mb-8">
          <CardHeader className="pb-3">
            <CardTitle className="text-base flex items-center gap-2 text-red-700">
              <AlertTriangle className="h-5 w-5" />
              สาขาที่ต้องปรับปรุง (ถูกต้อง &lt; 60%)
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {weakTopics.map((topic) => (
                <div
                  key={topic.subject_id}
                  className="flex items-center justify-between rounded-lg bg-white p-3 border border-red-100"
                >
                  <div className="flex items-center gap-2">
                    <span className="text-lg">{topic.subject_icon}</span>
                    <div>
                      <p className="text-sm font-medium">
                        {topic.subject_name_th}
                      </p>
                      <p className="text-xs text-red-600">
                        {topic.accuracy}% ({topic.wrong_count} ข้อผิด)
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Accuracy Trend Chart */}
      {trend.length >= 2 && (
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-base">
              แนวโน้มความถูกต้องรายสัปดาห์
            </CardTitle>
          </CardHeader>
          <CardContent>
            <AccuracyTrendChart data={trend} />
          </CardContent>
        </Card>
      )}

      {/* Subject Performance */}
      <Card className="mb-8">
        <CardHeader>
          <CardTitle className="text-base">สถิติแยกตามสาขา</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {subjectStats.map((stat) => {
              const color =
                stat.accuracy >= 80
                  ? "text-green-600"
                  : stat.accuracy >= 60
                  ? "text-yellow-600"
                  : "text-red-600";
              const bgColor =
                stat.accuracy >= 80
                  ? "bg-green-500"
                  : stat.accuracy >= 60
                  ? "bg-yellow-500"
                  : "bg-red-500";
              return (
                <div
                  key={stat.subject_id}
                  className="flex items-center gap-3 rounded-lg border p-3"
                >
                  <span className="text-xl w-8 text-center">
                    {stat.subject_icon}
                  </span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between mb-1">
                      <p className="text-sm font-medium truncate">
                        {stat.subject_name_th}
                      </p>
                      <div className="flex items-center gap-2">
                        <span className={`text-sm font-bold ${color}`}>
                          {stat.accuracy}%
                        </span>
                        <span className="text-xs text-muted-foreground">
                          ({stat.correct_count}/{stat.total_attempts})
                        </span>
                      </div>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2">
                      <div
                        className={`h-2 rounded-full ${bgColor}`}
                        style={{ width: `${Math.min(stat.accuracy, 100)}%` }}
                      />
                    </div>
                  </div>
                </div>
              );
            })}
            {subjectStats.length === 0 && (
              <p className="text-center text-muted-foreground py-4">
                ยังไม่มีข้อมูลการทำข้อสอบ
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Recent Sessions */}
      {recentSessions.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">เซสชันล่าสุด</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {recentSessions.map((session) => (
                <div
                  key={session.session_id}
                  className="flex items-center justify-between rounded-lg border p-3"
                >
                  <div className="flex items-center gap-3">
                    <span className="text-lg">
                      {session.subject_icon || "📝"}
                    </span>
                    <div>
                      <p className="text-sm font-medium">
                        {session.subject_name_th || "หลายสาขา"}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {new Date(session.created_at).toLocaleDateString(
                          "th-TH",
                          {
                            day: "numeric",
                            month: "short",
                            year: "2-digit",
                          }
                        )}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <Badge
                      variant={
                        session.mode === "mock" ? "default" : "secondary"
                      }
                      className="text-xs"
                    >
                      {session.mode === "mock" ? "Mock" : "Practice"}
                    </Badge>
                    <span
                      className={`text-sm font-bold ${
                        session.accuracy >= 60
                          ? "text-green-600"
                          : "text-red-600"
                      }`}
                    >
                      {session.correct_count}/{session.total_questions} (
                      {session.accuracy}%)
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
