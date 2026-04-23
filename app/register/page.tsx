"use client";

import { useState, useEffect, Suspense } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import BetaPromoBanner from "@/components/beta/BetaPromoBanner";

const LINE_LOGIN_ENABLED = process.env.NEXT_PUBLIC_LINE_LOGIN_ENABLED === "true";

function RegisterForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [refCode, setRefCode] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    const ref = searchParams.get("ref");
    if (ref) setRefCode(ref.toUpperCase());
  }, [searchParams]);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    if (password.length < 6) {
      setError("รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร");
      setLoading(false);
      return;
    }

    const supabase = createClient();
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { name } },
    });

    if (error) {
      setError(error.message);
      setLoading(false);
      return;
    }

    if (data.user) {
      const { data: existing } = await supabase
        .from("profiles")
        .select("id")
        .eq("id", data.user.id)
        .single();

      if (!existing) {
        await supabase.from("profiles").insert({
          id: data.user.id,
          email,
          name,
          role: "user",
          membership_type: "free",
        });
      }

      // Apply referral code if provided
      if (refCode.trim()) {
        await fetch("/api/referral/apply", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ code: refCode.trim(), userId: data.user.id }),
        });
      }

      // Beta enrollment — no-op if promo window has closed.
      try {
        await fetch("/api/beta/enroll", { method: "POST" });
      } catch {
        /* non-fatal */
      }
    }

    setSuccess(true);
    setLoading(false);
  };

  const handleGoogleSignUp = async () => {
    const supabase = createClient();
    const ref = refCode.trim() || searchParams.get("ref") || "";
    await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/auth/callback${ref ? `?ref=${ref}` : ""}`,
      },
    });
  };

  if (success) {
    return (
      <div className="flex items-center justify-center min-h-[calc(100vh-12rem)] px-4 py-8">
        <Card className="w-full max-w-md text-center">
          <CardHeader>
            <div className="text-5xl mb-2">✉️</div>
            <h1 className="text-2xl font-bold">ตรวจสอบอีเมลของคุณ</h1>
          </CardHeader>
          <CardContent>
            <p className="text-muted-foreground">
              เราส่งลิงก์ยืนยันไปที่ <strong>{email}</strong>
              <br />
              กรุณาตรวจสอบอีเมลเพื่อยืนยันการสมัคร
            </p>
          </CardContent>
          <CardFooter className="justify-center">
            <Link href="/login">
              <Button variant="outline">ไปหน้าเข้าสู่ระบบ</Button>
            </Link>
          </CardFooter>
        </Card>
      </div>
    );
  }

  return (
    <div className="flex items-center justify-center min-h-[calc(100vh-12rem)] px-4 py-8">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center space-y-2">
          <div className="text-4xl">🩺</div>
          <h1 className="text-2xl font-bold">สมัครสมาชิก</h1>
          <p className="text-sm text-muted-foreground">
            เริ่มต้นเตรียมสอบแพทย์กับหมอรู้
          </p>
        </CardHeader>
        <CardContent className="space-y-4">
          <BetaPromoBanner variant="inline" />
          {LINE_LOGIN_ENABLED && (
            <a
              href="/api/auth/line?mode=register"
              className="inline-flex items-center justify-center gap-2 w-full rounded-md border border-input bg-[#06C755] hover:bg-[#05b34c] text-white font-medium py-2 px-4 text-sm transition-colors"
            >
              <svg className="h-5 w-5" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.02 2 11c0 3.39 1.9 6.35 4.75 8.07L6 22l3.29-1.72C10.15 20.73 11.06 21 12 21c5.52 0 10-4.02 10-9S17.52 2 12 2z"/>
              </svg>
              สมัครด้วย LINE
            </a>
          )}

          {/* Google */}
          <Button
            variant="outline"
            className="w-full gap-2"
            onClick={handleGoogleSignUp}
          >
            <svg className="h-4 w-4" viewBox="0 0 24 24">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
            </svg>
            สมัครด้วย Google
          </Button>

          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-card px-2 text-muted-foreground">หรือ</span>
            </div>
          </div>

          {/* Form */}
          <form onSubmit={handleRegister} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">ชื่อ-นามสกุล</Label>
              <Input
                id="name"
                type="text"
                placeholder="นพ.สมชาย ใจดี"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">อีเมล</Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">รหัสผ่าน</Label>
              <Input
                id="password"
                type="password"
                placeholder="อย่างน้อย 6 ตัวอักษร"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="refCode" className="flex items-center gap-1">
                รหัสผู้แนะนำ
                <span className="text-xs text-muted-foreground font-normal">(ถ้ามี)</span>
              </Label>
              <Input
                id="refCode"
                type="text"
                placeholder="เช่น MR-ABC123"
                value={refCode}
                onChange={(e) => setRefCode(e.target.value.toUpperCase())}
                className="font-mono tracking-wider"
              />
            </div>
            {error && <p className="text-sm text-destructive">{error}</p>}
            <Button
              type="submit"
              className="w-full bg-brand hover:bg-brand-light text-white"
              disabled={loading}
            >
              {loading ? "กำลังสมัคร..." : "สมัครสมาชิก"}
            </Button>
          </form>
        </CardContent>
        <CardFooter className="justify-center">
          <p className="text-sm text-muted-foreground">
            มีบัญชีอยู่แล้ว?{" "}
            <Link href="/login" className="text-brand font-medium hover:underline">
              เข้าสู่ระบบ
            </Link>
          </p>
        </CardFooter>
      </Card>
    </div>
  );
}

export default function RegisterPage() {
  return (
    <Suspense>
      <RegisterForm />
    </Suspense>
  );
}
