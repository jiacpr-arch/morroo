"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { JOIN_RESULT_MESSAGE, joinPath, normalizeJoinCode } from "@/lib/organizations";

export default function JoinCodeForm() {
  const router = useRouter();
  const [value, setValue] = useState("");
  const [error, setError] = useState<string | null>(null);

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const code = normalizeJoinCode(value);
    if (!code) {
      setError(JOIN_RESULT_MESSAGE.not_found);
      return;
    }
    router.push(joinPath(code));
  }

  return (
    <form onSubmit={submit} className="space-y-2">
      <div className="flex gap-2">
        <Input
          value={value}
          onChange={(e) => {
            setValue(e.target.value.toUpperCase());
            setError(null);
          }}
          placeholder="เช่น AB7K2QXM"
          className="font-mono uppercase"
          aria-label="รหัสกลุ่ม"
          autoComplete="off"
        />
        <Button type="submit">ถัดไป</Button>
      </div>
      {error && <p className="text-sm text-red-600">{error}</p>}
    </form>
  );
}
