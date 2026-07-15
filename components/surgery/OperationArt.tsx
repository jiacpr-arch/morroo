// ภาพการ์ตูนบนเวทีผ่าตัด — SVG data-driven ตาม artId + สถานะที่ทำสำเร็จแล้ว
//
// states = เซ็ตของ fxState จาก step ที่เสร็จแล้ว (สะสม) — ภาพเปลี่ยนทีละชั้น
// stitchProgress = 0..1 ระหว่างลากเย็บ (โชว์ไหมโผล่ทีละเข็ม)
// bleedingActive = step ปัจจุบันยังมีเลือด/ลมรั่ว — ใส่เอฟเฟกต์เตือน

interface OperationArtProps {
  artId: "laceration" | "chest" | "abscess";
  states: Set<string>;
  stitchProgress: number;
  bleedingActive: boolean;
}

export default function OperationArt({ artId, states, stitchProgress, bleedingActive }: OperationArtProps) {
  if (artId === "laceration") {
    return <LacerationArt states={states} stitchProgress={stitchProgress} bleeding={bleedingActive} />;
  }
  if (artId === "chest") return <ChestArt states={states} bleeding={bleedingActive} />;
  return <AbscessArt states={states} bleeding={bleedingActive} />;
}

/** หยดเลือดเต้นๆ ระหว่างยังห้ามเลือดไม่ได้ */
function BloodDrips({ cx, cy }: { cx: number; cy: number }) {
  return (
    <g className="sgy-bleed">
      <circle cx={cx - 30} cy={cy + 46} r="10" fill="#c0392b" />
      <circle cx={cx + 42} cy={cy + 60} r="7" fill="#c0392b" />
      <circle cx={cx + 8} cy={cy + 74} r="5" fill="#e74c3c" />
    </g>
  );
}

// ---------- ด่าน 1: แผลฉีกขาดที่แขน ----------

function LacerationArt({
  states, stitchProgress, bleeding,
}: { states: Set<string>; stitchProgress: number; bleeding: boolean }) {
  const cleaned = states.has("cleaned");
  const prepped = states.has("prepped");
  const stitched = states.has("stitched");
  const trimmed = states.has("trimmed");
  const dressed = states.has("dressed");
  // ไหมโผล่ทีละเข็มตาม progress ตอนลากเย็บ (ครบ 4 เมื่อ step เสร็จ)
  const stitchCount = stitched ? 4 : Math.floor(stitchProgress * 4.999);
  const stitchXs = [420, 480, 540, 600];

  return (
    <g>
      {/* โต๊ะผ่าตัด + ผ้าเขียว */}
      <rect x="0" y="0" width="1000" height="750" fill="#14332b" />
      <rect x="60" y="120" width="880" height="520" rx="28" fill="#1d4a3d" />
      {/* แขน */}
      <g transform="rotate(8 500 375)">
        <rect x="120" y="280" width="760" height="190" rx="95" fill="#f2c49b" />
        <rect x="120" y="280" width="120" height="190" rx="60" fill="#e8b488" />
        {/* มือ */}
        <circle cx="880" cy="375" r="85" fill="#f2c49b" />
      </g>
      {/* วงน้ำยาฆ่าเชื้อรอบแผล */}
      {prepped && !dressed && (
        <ellipse cx="500" cy="375" rx="205" ry="150" fill="#d68a3a" opacity="0.28" />
      )}
      {/* แผล — ก่อนล้าง: ขอบรุ่ย+เศษดิน / หลังล้าง: สะอาดขึ้น */}
      {!dressed && (
        <g>
          <path
            d="M 360 340 Q 430 348 500 375 Q 570 402 640 410"
            stroke={cleaned ? "#b03a2e" : "#8e2b21"}
            strokeWidth={cleaned ? 16 : 22}
            fill="none"
            strokeLinecap="round"
          />
          <path
            d="M 360 340 Q 430 348 500 375 Q 570 402 640 410"
            stroke="#e74c3c"
            strokeWidth={cleaned ? 7 : 10}
            fill="none"
            strokeLinecap="round"
          />
          {!cleaned && (
            <g fill="#5d4037">
              <circle cx="420" cy="352" r="6" />
              <circle cx="505" cy="380" r="5" />
              <circle cx="585" cy="398" r="6" />
              <circle cx="465" cy="360" r="4" />
            </g>
          )}
        </g>
      )}
      {/* ไหมเย็บ */}
      {!dressed &&
        stitchXs.slice(0, stitchCount).map((x, i) => {
          const y = 340 + ((x - 360) / 280) * 70;
          return (
            <g key={i} stroke="#2c3e50" strokeWidth="5" strokeLinecap="round">
              <line x1={x - 16} y1={y - 22} x2={x + 16} y2={y + 22} />
              {/* หางไหม — สั้นลงหลังตัด */}
              {!trimmed && i === stitchCount - 1 && (
                <line x1={x + 16} y1={y + 22} x2={x + 42} y2={y + 34} strokeWidth="3.5" />
              )}
            </g>
          );
        })}
      {/* ผ้าปิดแผล */}
      {dressed && (
        <g transform="rotate(8 500 375)">
          <rect x="330" y="300" width="340" height="150" rx="16" fill="#fdfefe" stroke="#d5dbdb" strokeWidth="4" />
          <rect x="360" y="330" width="280" height="90" rx="10" fill="#eaf2f8" />
        </g>
      )}
      {bleeding && <BloodDrips cx={500} cy={400} />}
    </g>
  );
}

// ---------- ด่าน 2: ทรวงอก (tension pneumothorax) ----------

function ChestArt({ states, bleeding }: { states: Set<string>; bleeding: boolean }) {
  const oxygen = states.has("oxygen");
  const decompressed = states.has("decompressed");
  const prepped = states.has("prepped");
  const incised = states.has("incised");
  const tubed = states.has("tubed");
  const sealed = states.has("sealed");
  const dressed = states.has("dressed");
  const distressed = !decompressed;

  return (
    <g>
      <rect x="0" y="0" width="1000" height="750" fill="#14332b" />
      <rect x="60" y="60" width="880" height="620" rx="28" fill="#1d4a3d" />
      {/* หัว + หน้า */}
      <circle cx="500" cy="130" r="80" fill="#f2c49b" />
      <g>
        {/* ตา — ทุกข์ตอน tension, สบายขึ้นหลังระบาย */}
        {distressed ? (
          <g stroke="#5d4037" strokeWidth="5" strokeLinecap="round">
            <line x1="462" y1="112" x2="486" y2="122" />
            <line x1="538" y1="112" x2="514" y2="122" />
          </g>
        ) : (
          <g fill="#5d4037">
            <circle cx="474" cy="118" r="7" />
            <circle cx="526" cy="118" r="7" />
          </g>
        )}
        {/* ปาก */}
        {distressed ? (
          <ellipse cx="500" cy="158" rx="14" ry="18" fill="#8e2b21" />
        ) : (
          <path d="M 480 155 Q 500 170 520 155" stroke="#5d4037" strokeWidth="5" fill="none" strokeLinecap="round" />
        )}
      </g>
      {/* หน้ากาก O2 */}
      {oxygen && (
        <g>
          <ellipse cx="500" cy="150" rx="42" ry="34" fill="#aed6f1" opacity="0.85" stroke="#5dade2" strokeWidth="4" />
          <path d="M 500 184 Q 500 240 470 300" stroke="#5dade2" strokeWidth="6" fill="none" />
        </g>
      )}
      {/* ลำตัว — อกขวา (ซ้ายจอ) โป่งตอน tension */}
      <path
        d={
          distressed
            ? "M 340 230 Q 240 300 255 460 Q 265 600 400 640 L 600 640 Q 735 600 745 460 Q 755 320 660 230 Q 500 190 340 230 Z"
            : "M 350 235 Q 270 310 275 460 Q 285 600 400 640 L 600 640 Q 715 600 725 460 Q 730 310 650 235 Q 500 195 350 235 Z"
        }
        fill="#f2c49b"
      />
      {/* trachea เอียง (เส้นกลางคอ) */}
      <line
        x1="500" y1="210"
        x2={distressed ? 530 : 500} y2="245"
        stroke="#d68a3a" strokeWidth="8" strokeLinecap="round"
      />
      {/* หัวนม 2 ข้างช่วยกะตำแหน่ง */}
      <circle cx="390" cy="360" r="9" fill="#d68a3a" />
      <circle cx="610" cy="360" r="9" fill="#d68a3a" />
      {/* เข็ม needle decompression คาไว้ที่ 2nd ICS */}
      {decompressed && (
        <g transform="rotate(-30 385 270)">
          <rect x="375" y="215" width="11" height="55" rx="4" fill="#f8f9f9" stroke="#95a5a6" strokeWidth="2" />
          <rect x="372" y="205" width="17" height="14" rx="4" fill="#e67e22" />
        </g>
      )}
      {/* บริเวณ prep ด้านข้าง */}
      {prepped && !dressed && <circle cx="300" cy="420" r="120" fill="#d68a3a" opacity="0.28" />}
      {/* แผลกรีด + สาย ICD */}
      {incised && !dressed && (
        <line x1="255" y1="425" x2="345" y2="425" stroke="#b03a2e" strokeWidth="10" strokeLinecap="round" />
      )}
      {tubed && (
        <path
          d="M 300 425 Q 220 470 175 560 L 170 620"
          stroke="#eaf2f8" strokeWidth="14" fill="none" strokeLinecap="round" opacity="0.95"
        />
      )}
      {/* ขวด water seal + ฟองอากาศ */}
      {sealed && (
        <g>
          <rect x="110" y="580" width="120" height="140" rx="14" fill="#d6eaf8" stroke="#5dade2" strokeWidth="5" />
          <rect x="110" y="650" width="120" height="70" rx="14" fill="#85c1e9" />
          <g className="sgy-bubbles" fill="#fdfefe">
            <circle cx="150" cy="690" r="7" />
            <circle cx="180" cy="670" r="5" />
            <circle cx="165" cy="700" r="4" />
          </g>
        </g>
      )}
      {/* ผ้าปิดรอบสาย */}
      {dressed && (
        <rect x="240" y="380" width="130" height="90" rx="12" fill="#fdfefe" stroke="#d5dbdb" strokeWidth="4" />
      )}
      {bleeding && (
        <g className="sgy-bleed">
          {/* ลมรั่ว — วงสั่นๆ ข้างอกขวา */}
          <circle cx="330" cy="330" r="26" fill="none" stroke="#f4d03f" strokeWidth="5" opacity="0.8" />
          <circle cx="350" cy="300" r="14" fill="none" stroke="#f4d03f" strokeWidth="4" opacity="0.6" />
        </g>
      )}
    </g>
  );
}

// ---------- ด่าน 3: ฝีที่หลัง ----------

function AbscessArt({ states, bleeding }: { states: Set<string>; bleeding: boolean }) {
  const prepped = states.has("prepped");
  const incised = states.has("incised");
  const drained = states.has("drained");
  const irrigated = states.has("irrigated");
  const packed = states.has("packed");
  const dressed = states.has("dressed");

  return (
    <g>
      <rect x="0" y="0" width="1000" height="750" fill="#14332b" />
      <rect x="60" y="80" width="880" height="580" rx="28" fill="#1d4a3d" />
      {/* แผ่นหลัง */}
      <path
        d="M 250 120 Q 500 60 750 120 Q 820 350 760 630 L 240 630 Q 180 350 250 120 Z"
        fill="#f2c49b"
      />
      {/* แนวกลางหลัง */}
      <line x1="500" y1="110" x2="500" y2="620" stroke="#e8b488" strokeWidth="10" strokeLinecap="round" />
      {/* วง prep */}
      {prepped && !dressed && <circle cx="500" cy="400" r="200" fill="#d68a3a" opacity="0.25" />}
      {/* ฝี — บวมแดงก่อนกรีด แฟบลงหลังระบาย */}
      {!dressed && (
        <g>
          <circle
            cx="500" cy="400"
            r={drained ? 70 : 95}
            fill={drained ? "#e59866" : "#e74c3c"}
            opacity={drained ? 0.55 : 0.9}
          />
          {!incised && <circle cx="500" cy="400" r="45" fill="#f9e79f" opacity="0.85" />}
          {/* รอยกรีด */}
          {incised && (
            <line x1="440" y1="392" x2="570" y2="410" stroke="#8e2b21" strokeWidth="10" strokeLinecap="round" />
          )}
          {/* หนองทะลัก (หลังกรีด ก่อนล้าง) */}
          {incised && !irrigated && (
            <g fill="#f4d03f" opacity="0.9">
              <ellipse cx="540" cy="440" rx="34" ry="18" />
              <circle cx="470" cy="435" r="12" />
            </g>
          )}
          {/* packing โผล่จากปากแผล */}
          {packed && (
            <path
              d="M 470 398 Q 500 380 530 402 Q 545 420 520 430"
              stroke="#fdfefe" strokeWidth="12" fill="none" strokeLinecap="round"
            />
          )}
        </g>
      )}
      {dressed && (
        <rect x="380" y="320" width="240" height="160" rx="16" fill="#fdfefe" stroke="#d5dbdb" strokeWidth="4" />
      )}
      {bleeding && <BloodDrips cx={500} cy={430} />}
    </g>
  );
}
