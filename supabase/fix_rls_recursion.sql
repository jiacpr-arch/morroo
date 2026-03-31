-- ============================================
-- แก้ปัญหา infinite recursion ใน RLS policies
-- ============================================
-- ปัญหา: admin policies ทำ subquery ไปที่ profiles table
-- ซึ่ง profiles เองก็มี RLS → เกิด recursive loop
-- วิธีแก้: สร้าง SECURITY DEFINER function ที่ bypass RLS

-- 1. สร้าง function is_admin() ที่ bypass RLS
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$$;

-- 2. ลบ policies เก่าที่มี subquery ไป profiles
DROP POLICY IF EXISTS "Admins can manage exams" ON public.exams;
DROP POLICY IF EXISTS "Admins can manage exam parts" ON public.exam_parts;
DROP POLICY IF EXISTS "Admins can view all orders" ON public.payment_orders;
DROP POLICY IF EXISTS "Admins can update orders" ON public.payment_orders;

-- 3. สร้าง policies ใหม่ที่ใช้ is_admin() แทน
CREATE POLICY "Admins can manage exams"
  ON public.exams FOR ALL
  USING (public.is_admin());

CREATE POLICY "Admins can manage exam parts"
  ON public.exam_parts FOR ALL
  USING (public.is_admin());

CREATE POLICY "Admins can view all orders"
  ON public.payment_orders FOR SELECT
  USING (public.is_admin());

CREATE POLICY "Admins can update orders"
  ON public.payment_orders FOR UPDATE
  USING (public.is_admin());

-- 4. แก้ coupon_codes และ coupon_redemptions policies
DROP POLICY IF EXISTS "Admins can manage coupon codes" ON public.coupon_codes;
DROP POLICY IF EXISTS "Admins can view all redemptions" ON public.coupon_redemptions;

CREATE POLICY "Admins can manage coupon codes"
  ON public.coupon_codes FOR ALL
  USING (public.is_admin());

CREATE POLICY "Admins can view all redemptions"
  ON public.coupon_redemptions FOR SELECT
  USING (public.is_admin());

-- 5. เพิ่ม policy ให้ admin อ่าน profiles ของ user อื่นได้ (สำหรับ admin panel)
CREATE POLICY "Admins can view all profiles"
  ON public.profiles FOR SELECT
  USING (public.is_admin() OR auth.uid() = id);

-- ลบ policy เดิมที่จำกัดแค่ own profile
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
