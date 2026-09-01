import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "ลบข้อมูลเรียบร้อย | MorRoo",
  robots: { index: false, follow: false },
};

export default async function DeletionStatusPage({
  searchParams,
}: {
  searchParams: Promise<{ code?: string }>;
}) {
  const { code } = await searchParams;

  return (
    <main className="min-h-[60vh] flex items-center justify-center p-8">
      <div className="max-w-lg text-center space-y-6">
        <div className="text-5xl">✅</div>

        <h1 className="text-2xl font-bold">ลบข้อมูลเรียบร้อยแล้ว</h1>

        <p className="text-gray-600 leading-relaxed">
          ข้อมูลการสนทนาของคุณกับ MorRoo ผ่าน Facebook Messenger
          ถูกลบออกจากระบบของเราอย่างถาวรเรียบร้อยแล้ว
        </p>

        <p className="text-sm text-gray-400 leading-relaxed">
          Your Facebook Messenger conversation history has been permanently
          deleted from MorRoo&apos;s systems in accordance with Facebook&apos;s
          data deletion policy.
        </p>

        {code && (
          <p className="text-xs text-gray-400 font-mono bg-gray-50 rounded px-3 py-2 inline-block">
            Confirmation code: {code}
          </p>
        )}

        <div className="pt-2">
          <a
            href="https://www.morroo.com"
            className="text-sm text-primary hover:underline"
          >
            กลับหน้าแรก MorRoo
          </a>
        </div>
      </div>
    </main>
  );
}
