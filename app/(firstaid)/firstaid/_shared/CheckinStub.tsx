import Link from "next/link";

// Phase-1 stub for every /checkin* URL: printed QR posters at training venues
// point here, so the routes must not 404 while the check-in system is rebuilt
// in Phase 2.
export default function CheckinStub() {
  return (
    <div className="page-container">
      <div className="card" style={{ textAlign: "center", padding: 28, marginTop: 16 }}>
        <div style={{ fontSize: 40 }}>🛠️</div>
        <div className="text-title" style={{ marginTop: 12 }}>
          ระบบเช็คชื่อกำลังปรับปรุง
        </div>
        <div className="text-body" style={{ marginTop: 8 }}>
          จะกลับมาเร็วๆ นี้ — ระหว่างนี้แจ้งชื่อกับครูผู้สอนได้เลย
        </div>
      </div>
      <Link href="/" className="btn btn-primary btn-block" style={{ marginTop: 16 }}>
        กลับหน้าแรก
      </Link>
    </div>
  );
}
