-- ============================================================
-- Pharmacy Management System Schema
-- วิธีใช้: รัน SQL นี้ใน Supabase SQL Editor
-- ============================================================

-- ตารางรายการยา (Drug catalog)
CREATE TABLE IF NOT EXISTS pharmacy_drugs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  generic_name TEXT,
  unit TEXT NOT NULL DEFAULT 'เม็ด',
  system TEXT NOT NULL DEFAULT 'OPD',        -- ระบบ/หน่วยงาน: OPD, IPD, ER, ICU, OR, กุมารฯ
  min_stock INTEGER NOT NULL DEFAULT 10,      -- จำนวนขั้นต่ำที่ต้องมี
  location TEXT,                              -- ตำแหน่งจัดเก็บ
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ตารางล็อตยา (Stock lots with expiry tracking)
CREATE TABLE IF NOT EXISTS pharmacy_stock (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drug_id UUID NOT NULL REFERENCES pharmacy_drugs(id) ON DELETE CASCADE,
  lot_number TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 0,
  expiry_date DATE NOT NULL,
  supplier TEXT,
  cost_per_unit DECIMAL(10,2),
  received_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT,
  CONSTRAINT positive_quantity CHECK (quantity >= 0)
);

-- ตารางรายการรับ-จ่าย (Transaction log)
CREATE TABLE IF NOT EXISTS pharmacy_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  drug_id UUID NOT NULL REFERENCES pharmacy_drugs(id),
  drug_lot_id UUID REFERENCES pharmacy_stock(id),
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('receive', 'dispense', 'adjust', 'return')),
  quantity INTEGER NOT NULL,                  -- บวก = รับเข้า, ลบ = จ่ายออก
  reference TEXT,                             -- เลข HN หรือ Order
  notes TEXT,
  performed_by TEXT DEFAULT 'staff',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- เปิด Row Level Security
ALTER TABLE pharmacy_drugs ENABLE ROW LEVEL SECURITY;
ALTER TABLE pharmacy_stock ENABLE ROW LEVEL SECURITY;
ALTER TABLE pharmacy_transactions ENABLE ROW LEVEL SECURITY;

-- Policies: เปิดทุก operation (ปรับ restrict ตาม role ภายหลัง)
DROP POLICY IF EXISTS "pharmacy_drugs_all" ON pharmacy_drugs;
DROP POLICY IF EXISTS "pharmacy_stock_all" ON pharmacy_stock;
DROP POLICY IF EXISTS "pharmacy_transactions_all" ON pharmacy_transactions;

CREATE POLICY "pharmacy_drugs_all" ON pharmacy_drugs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pharmacy_stock_all" ON pharmacy_stock FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pharmacy_transactions_all" ON pharmacy_transactions FOR ALL USING (true) WITH CHECK (true);

-- เปิด Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE pharmacy_stock;
ALTER PUBLICATION supabase_realtime ADD TABLE pharmacy_transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE pharmacy_drugs;

-- ============================================================
-- ข้อมูลตัวอย่าง: รายการยาทั่วไปในโรงพยาบาล
-- ============================================================

INSERT INTO pharmacy_drugs (name, generic_name, unit, system, min_stock, location) VALUES
-- OPD
('Paracetamol 500mg', 'Paracetamol', 'เม็ด', 'OPD', 500, 'ชั้น A1'),
('Amoxicillin 500mg', 'Amoxicillin', 'แคปซูล', 'OPD', 100, 'ชั้น A2'),
('Ibuprofen 400mg', 'Ibuprofen', 'เม็ด', 'OPD', 200, 'ชั้น A1'),
('Metformin 500mg', 'Metformin', 'เม็ด', 'OPD', 300, 'ชั้น B1'),
('Amlodipine 5mg', 'Amlodipine', 'เม็ด', 'OPD', 200, 'ชั้น B2'),
('Enalapril 10mg', 'Enalapril', 'เม็ด', 'OPD', 150, 'ชั้น B3'),
('Simvastatin 20mg', 'Simvastatin', 'เม็ด', 'OPD', 200, 'ชั้น B4'),
('Omeprazole 20mg', 'Omeprazole', 'แคปซูล', 'OPD', 150, 'ชั้น C1'),
('Prednisolone 5mg', 'Prednisolone', 'เม็ด', 'OPD', 100, 'ชั้น C2'),
('Warfarin 3mg', 'Warfarin', 'เม็ด', 'OPD', 80, 'ชั้น D2'),
-- IPD
('Furosemide 40mg', 'Furosemide', 'เม็ด', 'IPD', 100, 'ชั้น D1'),
('Normal Saline 0.9% 1000ml', 'Sodium Chloride', 'ขวด', 'IPD', 100, 'ห้องน้ำเกลือ'),
('5% Dextrose 1000ml', 'Dextrose 5%', 'ขวด', 'IPD', 100, 'ห้องน้ำเกลือ'),
('Ceftriaxone 1g IV', 'Ceftriaxone', 'ขวด', 'IPD', 50, 'ตู้เย็น A'),
-- ICU
('Vancomycin 500mg IV', 'Vancomycin', 'ขวด', 'ICU', 20, 'ตู้เย็น B'),
('Morphine 10mg/ml', 'Morphine', 'Amp', 'ICU', 30, 'ตู้ควบคุม'),
('Diazepam 5mg/ml', 'Diazepam', 'Amp', 'ICU', 20, 'ตู้ควบคุม'),
('Insulin Regular 100u/ml', 'Regular Insulin', 'ขวด', 'ICU', 10, 'ตู้เย็น C'),
-- ER
('Epinephrine 1mg/ml', 'Epinephrine', 'Amp', 'ER', 30, 'ตู้ฉุกเฉิน'),
('Atropine 0.6mg/ml', 'Atropine', 'Amp', 'ER', 30, 'ตู้ฉุกเฉิน')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ล็อตยาตัวอย่าง (สำหรับทดสอบการแจ้งเตือน)
-- ============================================================

DO $$
DECLARE
  v_drug_id UUID;
BEGIN
  -- Paracetamol: stock ปกติ 2 ล็อต
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Paracetamol 500mg' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'PCM-2024-001', 200, '2026-06-30', 'GPO'),
           (v_drug_id, 'PCM-2024-002', 150, '2025-12-31', 'GPO');
  END IF;

  -- Amoxicillin: ใกล้หมดอายุ (< 90 วัน จากปัจจุบัน)
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Amoxicillin 500mg' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'AMX-2023-015', 30, (CURRENT_DATE + INTERVAL '45 days')::DATE, 'Siam Pharma');
  END IF;

  -- Metformin: stock ต่ำกว่า min (min=300 แต่มีแค่ 5)
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Metformin 500mg' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'MET-2024-001', 5, '2026-12-31', 'Unison');
  END IF;

  -- Ibuprofen: stock ปกติ
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Ibuprofen 400mg' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'IBU-2024-003', 180, '2026-09-30', 'GPO');
  END IF;

  -- Normal Saline: 2 ล็อต
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Normal Saline 0.9% 1000ml' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'NS-2024-010', 80, '2026-03-31', 'B.Braun'),
           (v_drug_id, 'NS-2024-011', 50, '2026-06-30', 'B.Braun');
  END IF;

  -- Epinephrine: หมดอายุแล้ว (สำหรับทดสอบ alert)
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Epinephrine 1mg/ml' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'EPI-2022-005', 5, (CURRENT_DATE - INTERVAL '30 days')::DATE, 'Hospira');
  END IF;

  -- Ceftriaxone: ใกล้หมดอายุ + stock ต่ำ
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Ceftriaxone 1g IV' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'CFX-2024-002', 8, (CURRENT_DATE + INTERVAL '60 days')::DATE, 'GPO');
  END IF;

  -- Morphine: stock ปกติ
  SELECT id INTO v_drug_id FROM pharmacy_drugs WHERE name = 'Morphine 10mg/ml' LIMIT 1;
  IF v_drug_id IS NOT NULL THEN
    INSERT INTO pharmacy_stock (drug_id, lot_number, quantity, expiry_date, supplier)
    VALUES (v_drug_id, 'MOR-2024-001', 25, '2026-08-31', 'GPO');
  END IF;

END $$;
