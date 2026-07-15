// ภาพการ์ตูนบนเวทีกู้ชีพ — SVG data-driven ตามสถานะที่ทำสำเร็จแล้ว
//
// v1 มีฉากเดียว ("arrest"): ผู้ป่วยหัวใจหยุดเต้นบนเตียง ER มองจากด้านบน
// states = เซ็ตของ fxState จาก step ที่เสร็จแล้ว (สะสม) — ภาพเปลี่ยนทีละชั้น
// cprActive = กำลังอยู่ในจังหวะปั๊มหัวใจ (อกยุบ-เด้งตาม CSS)
// shockFlash = ตัวนับช็อก (เปลี่ยนค่า = แว้บขาวหนึ่งครั้ง)

interface OperationArtProps {
  artId: "arrest";
  states: Set<string>;
  cprActive?: boolean;
}

export default function OperationArt({ states, cprActive = false }: OperationArtProps) {
  return <ArrestArt states={states} cprActive={cprActive} />;
}

function ArrestArt({ states, cprActive }: { states: Set<string>; cprActive: boolean }) {
  const padsOn = states.has("pads_on");
  const ivIn = states.has("iv_in");
  const salineRunning = states.has("saline_running");
  const tubeIn = states.has("tube_in");
  const o2On = states.has("o2_on");
  const bagging = states.has("bagging");
  const rosc = states.has("rosc");

  // สีผิว: ซีดคล้ำตอน arrest → อมชมพูหลัง ROSC
  const skin = rosc ? "#f2c49b" : "#c9bca0";
  const skinShade = rosc ? "#e8b488" : "#b3a98f";

  return (
    <g>
      {/* พื้นห้อง ER + เตียง */}
      <rect x="0" y="0" width="1000" height="750" fill="#0d1a24" />
      <rect x="70" y="70" width="770" height="610" rx="26" fill="#16303f" />
      <rect x="70" y="70" width="770" height="610" rx="26" fill="none" stroke="#1f4256" strokeWidth="3" />

      {/* ===== ตัวผู้ป่วย ===== */}
      {/* ลำตัว */}
      <path
        d="M 360 250 Q 300 320 305 470 Q 312 600 420 630 L 590 630 Q 690 600 700 470 Q 706 320 645 250 Q 500 210 360 250 Z"
        fill={skin as string}
      />
      {/* แขนซ้ายผู้ป่วย ยื่นไปทางขวาจอ (จุดเปิด IV) */}
      <g transform="rotate(12 690 430)">
        <rect x="620" y="392" width="250" height="86" rx="43" fill={skin as string} />
        <circle cx="860" cy="435" r="52" fill={skin as string} />
      </g>

      {/* หัว + ใบหน้า */}
      <circle cx="500" cy="120" r="82" fill={skin as string} />
      {rosc ? (
        <g fill="#5d4037">
          <circle cx="474" cy="110" r="7" />
          <circle cx="526" cy="110" r="7" />
          <path d="M 480 148 Q 500 162 520 148" stroke="#5d4037" strokeWidth="5" fill="none" strokeLinecap="round" />
        </g>
      ) : (
        <g stroke="#5d4037" strokeWidth="5" strokeLinecap="round">
          <line x1="464" y1="104" x2="486" y2="116" />
          <line x1="536" y1="104" x2="514" y2="116" />
          {/* ปากอ้าไม่หายใจ */}
          <ellipse cx="500" cy="150" rx="13" ry="17" fill="#7d4b3a" stroke="none" />
        </g>
      )}

      {/* จุดกึ่งกลางอก (เป้าปั๊ม) — เส้นแนวหัวนม 2 ข้าง */}
      <circle cx="430" cy="330" r="8" fill={skinShade as string} />
      <circle cx="575" cy="330" r="8" fill={skinShade as string} />
      {/* เงายุบตอนปั๊ม */}
      <g className={cprActive ? "rss-cpr-active" : undefined} style={{ transformBox: "fill-box", transformOrigin: "center" }}>
        <ellipse cx="500" cy="355" rx="70" ry="46" fill={skinShade as string} opacity="0.5" />
        {cprActive && (
          <text x="500" y="368" textAnchor="middle" fontSize="46">🫸</text>
        )}
      </g>

      {/* ===== อุปกรณ์ที่ติดไปแล้ว ===== */}
      {/* แผ่น pads */}
      {padsOn && (
        <g>
          <rect x="368" y="266" width="74" height="68" rx="12" fill="#f4d35e" stroke="#d9a800" strokeWidth="4" transform="rotate(-12 405 300)" />
          <rect x="573" y="401" width="74" height="68" rx="12" fill="#f4d35e" stroke="#d9a800" strokeWidth="4" transform="rotate(-12 610 435)" />
          <path d="M 405 300 Q 250 380 175 460" stroke="#d9a800" strokeWidth="6" fill="none" opacity="0.8" />
          <path d="M 610 435 Q 380 470 210 490" stroke="#d9a800" strokeWidth="6" fill="none" opacity="0.8" />
        </g>
      )}
      {/* สาย IV + ถุงน้ำเกลือ */}
      {ivIn && (
        <g>
          <circle cx="775" cy="430" r="10" fill="#e74c3c" />
          <path d="M 775 430 Q 830 360 862 250" stroke="#aed6f1" strokeWidth="6" fill="none" />
        </g>
      )}
      {salineRunning && (
        <g>
          <rect x="838" y="150" width="52" height="90" rx="10" fill="#d6eaf8" stroke="#5dade2" strokeWidth="4" />
          <rect x="838" y="205" width="52" height="35" rx="4" fill="#aed6f1" />
          <g className="rss-bubbles" fill="#fff">
            <circle cx="864" cy="225" r="4" />
          </g>
        </g>
      )}
      {/* หน้ากาก O2 */}
      {o2On && !tubeIn && (
        <ellipse cx="500" cy="145" rx="44" ry="36" fill="#aed6f1" opacity="0.85" stroke="#5dade2" strokeWidth="4" />
      )}
      {/* bag ช่วยหายใจ */}
      {bagging && !tubeIn && (
        <g>
          <ellipse cx="500" cy="150" rx="40" ry="32" fill="#aed6f1" opacity="0.7" stroke="#5dade2" strokeWidth="3" />
          <ellipse cx="500" cy="60" rx="30" ry="40" fill="#566573" stroke="#2c3e50" strokeWidth="3" />
        </g>
      )}
      {/* ท่อช่วยหายใจ ETT */}
      {tubeIn && (
        <g>
          <path d="M 500 150 Q 500 90 500 40" stroke="#eaf2f8" strokeWidth="13" fill="none" strokeLinecap="round" />
          <circle cx="500" cy="150" r="12" fill="#d6eaf8" stroke="#95a5a6" strokeWidth="2" />
        </g>
      )}

      {/* ===== เครื่อง defibrillator ข้างเตียง (ซ้ายล่าง) ===== */}
      <g>
        <rect x="90" y="405" width="150" height="130" rx="12" fill="#2c3e50" stroke="#1b2a38" strokeWidth="4" />
        <rect x="104" y="420" width="122" height="56" rx="6" fill="#0d1a24" />
        <polyline
          points="108,448 128,448 138,428 150,468 162,438 176,448 222,448"
          fill="none" stroke="#2ecc71" strokeWidth="3"
        />
        <circle cx="135" cy="505" r="16" fill="#e74c3c" />
        <text x="135" y="511" textAnchor="middle" fontSize="15" fill="#fff" fontWeight="700">⚡</text>
        <text x="190" y="511" textAnchor="middle" fontSize="13" fill="#ecf0f1">SHOCK</text>
      </g>
    </g>
  );
}
