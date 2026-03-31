"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  Loader2,
  Shield,
  ArrowLeft,
  Users,
  Crown,
  Search,
  Save,
  UserCheck,
  UserX,
} from "lucide-react";

// NOTE: ต้องมี RLS policies ใน Supabase:
// - "Admins can view all profiles" (SELECT) — auth.uid() in (select id from profiles where role = 'admin')
// - "Admins can update profiles" (UPDATE) — auth.uid() in (select id from profiles where role = 'admin')

interface Profile {
  id: string;
  email: string;
  name: string;
  role: string;
  membership_type: string;
  membership_expires_at: string | null;
  created_at: string;
}

const membershipLabels: Record<string, string> = {
  free: "ฟรี",
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
};

const membershipColors: Record<string, string> = {
  free: "bg-gray-100 text-gray-700",
  monthly: "bg-blue-100 text-blue-700",
  yearly: "bg-purple-100 text-purple-700",
  bundle: "bg-brand/10 text-brand",
};

export default function AdminUsersPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [users, setUsers] = useState<Profile[]>([]);
  const [searchQuery, setSearchQuery] = useState("");
  const [savingId, setSavingId] = useState<string | null>(null);

  // Editable fields per user (keyed by user id)
  const [edits, setEdits] = useState<
    Record<
      string,
      {
        membership_type: string;
        membership_expires_at: string;
        role: string;
      }
    >
  >({});

  const loadUsers = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("users")
      .select("id, email, name, role, membership_type, membership_expires_at, created_at")
      .order("created_at", { ascending: false });

    if (data) {
      setUsers(data);
      // Initialize edit state for each user
      const initialEdits: typeof edits = {};
      for (const u of data) {
        initialEdits[u.id] = {
          membership_type: u.membership_type || "free",
          membership_expires_at: u.membership_expires_at
            ? u.membership_expires_at.slice(0, 10)
            : "",
          role: u.role || "user",
        };
      }
      setEdits(initialEdits);
    }
  }, []);

  useEffect(() => {
    async function checkAdmin() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      const { data: profile } = await supabase
        .from("users")
        .select("role")
        .eq("id", user.id)
        .single();

      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }

      setIsAdmin(true);
      await loadUsers();
      setLoading(false);
    }
    checkAdmin();
  }, [router, loadUsers]);

  const handleEditChange = (
    userId: string,
    field: "membership_type" | "membership_expires_at" | "role",
    value: string
  ) => {
    setEdits((prev) => ({
      ...prev,
      [userId]: { ...prev[userId], [field]: value },
    }));
  };

  const handleSave = async (userId: string) => {
    const edit = edits[userId];
    if (!edit) return;

    setSavingId(userId);
    const supabase = createClient();

    await supabase
      .from("users")
      .update({
        membership_type: edit.membership_type,
        membership_expires_at: edit.membership_expires_at
          ? new Date(edit.membership_expires_at).toISOString()
          : null,
        role: edit.role,
      })
      .eq("id", userId);

    // Update local state
    setUsers((prev) =>
      prev.map((u) =>
        u.id === userId
          ? {
              ...u,
              membership_type: edit.membership_type,
              membership_expires_at: edit.membership_expires_at
                ? new Date(edit.membership_expires_at).toISOString()
                : null,
              role: edit.role,
            }
          : u
      )
    );

    setSavingId(null);
  };

  // Check if a user has unsaved changes
  const hasChanges = (user: Profile) => {
    const edit = edits[user.id];
    if (!edit) return false;
    const origExpiry = user.membership_expires_at
      ? user.membership_expires_at.slice(0, 10)
      : "";
    return (
      edit.membership_type !== (user.membership_type || "free") ||
      edit.membership_expires_at !== origExpiry ||
      edit.role !== (user.role || "user")
    );
  };

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
        <p className="text-muted-foreground mt-2">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  // Filter users by search query
  const filtered = users.filter((u) => {
    if (!searchQuery.trim()) return true;
    const q = searchQuery.toLowerCase();
    return (
      (u.email && u.email.toLowerCase().includes(q)) ||
      (u.name && u.name.toLowerCase().includes(q))
    );
  });

  // Stats
  const totalUsers = users.length;
  const paidMembers = users.filter(
    (u) => u.membership_type && u.membership_type !== "free"
  ).length;
  const freeMembers = totalUsers - paidMembers;

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <Link
            href="/admin"
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-2"
          >
            <ArrowLeft className="h-4 w-4" /> Admin Dashboard
          </Link>
          <h1 className="text-2xl font-bold">จัดการสมาชิก</h1>
          <p className="text-muted-foreground mt-1">
            ดูข้อมูล แก้ไขสมาชิกภาพ และกำหนดสิทธิ์ผู้ใช้
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center">
                <Users className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{totalUsers}</p>
                <p className="text-sm text-muted-foreground">สมาชิกทั้งหมด</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-brand/10 flex items-center justify-center">
                <UserCheck className="h-6 w-6 text-brand" />
              </div>
              <div>
                <p className="text-2xl font-bold">{paidMembers}</p>
                <p className="text-sm text-muted-foreground">สมาชิกแบบชำระเงิน</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-gray-100 flex items-center justify-center">
                <UserX className="h-6 w-6 text-gray-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{freeMembers}</p>
                <p className="text-sm text-muted-foreground">สมาชิกฟรี</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Search */}
      <div className="relative mb-6">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
        <Input
          placeholder="ค้นหาด้วยอีเมลหรือชื่อ..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="pl-10"
        />
      </div>

      {/* Users List */}
      {filtered.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <p className="text-muted-foreground">
              {searchQuery ? "ไม่พบสมาชิกที่ตรงกับคำค้นหา" : "ยังไม่มีสมาชิก"}
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {filtered.map((user) => {
            const edit = edits[user.id];
            if (!edit) return null;

            const changed = hasChanges(user);
            const memberColor =
              membershipColors[user.membership_type || "free"] ||
              membershipColors.free;
            const memberLabel =
              membershipLabels[user.membership_type || "free"] ||
              membershipLabels.free;

            return (
              <Card
                key={user.id}
                className={changed ? "border-brand/40" : ""}
              >
                <CardContent className="py-4">
                  <div className="flex flex-col gap-4">
                    {/* User info row */}
                    <div className="flex items-start justify-between flex-wrap gap-2">
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 flex-wrap mb-1">
                          <h3 className="font-semibold truncate">
                            {user.name || "(ไม่มีชื่อ)"}
                          </h3>
                          {user.role === "admin" && (
                            <Badge className="bg-red-100 text-red-700 text-xs">
                              <Crown className="h-3 w-3 mr-1" />
                              แอดมิน
                            </Badge>
                          )}
                          <Badge className={`text-xs ${memberColor}`}>
                            {memberLabel}
                          </Badge>
                        </div>
                        <p className="text-sm text-muted-foreground">
                          {user.email}
                        </p>
                        <div className="flex items-center gap-4 mt-1 text-xs text-muted-foreground">
                          <span>
                            สมัคร:{" "}
                            {new Date(user.created_at).toLocaleDateString(
                              "th-TH"
                            )}
                          </span>
                          {user.membership_expires_at && (
                            <span>
                              หมดอายุ:{" "}
                              {new Date(
                                user.membership_expires_at
                              ).toLocaleDateString("th-TH")}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Edit controls row */}
                    <div className="flex items-end gap-3 flex-wrap">
                      <div className="flex-1 min-w-[140px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          ประเภทสมาชิก
                        </label>
                        <select
                          className="w-full rounded-md border px-3 py-2 text-sm"
                          value={edit.membership_type}
                          onChange={(e) =>
                            handleEditChange(
                              user.id,
                              "membership_type",
                              e.target.value
                            )
                          }
                        >
                          <option value="free">ฟรี</option>
                          <option value="monthly">รายเดือน</option>
                          <option value="yearly">รายปี</option>
                          <option value="bundle">ชุดข้อสอบ</option>
                        </select>
                      </div>
                      <div className="flex-1 min-w-[160px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          วันหมดอายุ
                        </label>
                        <Input
                          type="date"
                          value={edit.membership_expires_at}
                          onChange={(e) =>
                            handleEditChange(
                              user.id,
                              "membership_expires_at",
                              e.target.value
                            )
                          }
                        />
                      </div>
                      <div className="min-w-[120px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          สิทธิ์
                        </label>
                        <select
                          className="w-full rounded-md border px-3 py-2 text-sm"
                          value={edit.role}
                          onChange={(e) =>
                            handleEditChange(user.id, "role", e.target.value)
                          }
                        >
                          <option value="user">user</option>
                          <option value="admin">admin</option>
                        </select>
                      </div>
                      <Button
                        className="bg-brand hover:bg-brand-light text-white gap-1"
                        size="sm"
                        disabled={!changed || savingId === user.id}
                        onClick={() => handleSave(user.id)}
                      >
                        {savingId === user.id ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Save className="h-4 w-4" />
                        )}
                        บันทึก
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
