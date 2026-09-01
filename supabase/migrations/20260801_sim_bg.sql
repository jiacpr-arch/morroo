-- ฉากหลังต่อโจทย์ของ Code Blue Sim / เกมเคส
-- id ต้องตรงกับ lib/sim/backgrounds.ts — null = ใช้ er_bay (ค่าเริ่มต้นของเกม)

alter table sim_scenarios add column if not exists bg text;

-- backfill เคสเดิมด้วย heuristic จาก title+subtitle (คร่าวๆ พอให้ฉากไม่ขัดตา —
-- แอดมินปรับรายเคสได้ที่ /admin/sim; เคสใหม่ AI เลือก bg เองตั้งแต่ตอน generate)
update sim_scenarios set bg = case
  when (title || ' ' || coalesce(subtitle, '')) ~* 'ห้องคลอด|เจ็บครรภ์|ตั้งครรภ์|ครรภ์|G[0-9]P[0-9]|ฝากครรภ์|น้ำเดิน|คลอด'
    then 'labor_room'
  when (title || ' ' || coalesce(subtitle, '')) ~* 'ทารก|แรกเกิด'
    then 'nursery'
  when (title || ' ' || coalesce(subtitle, '')) ~* '\yICU\y|ใส่ท่อ|เครื่องช่วยหายใจ'
    then 'icu'
  when (title || ' ' || coalesce(subtitle, '')) ~* '\yER\y|ห้องฉุกเฉิน|ฉุกเฉิน|อุบัติเหตุ|รถชน|มอเตอร์ไซค์|หมดสติ|ความดันตก|\yarrest\y|ช็อก|\yDKA\y'
    then 'er_bay'
  when (title || ' ' || coalesce(subtitle, '')) ~* 'กลางดึก|เวรดึก'
    then 'ward_night'
  when (title || ' ' || coalesce(subtitle, '')) ~* 'เวรอายุรกรรม|เวรศัลยกรรม|หอผู้ป่วย|\yward\y|แพทย์เวร'
    then 'ward_day'
  else 'opd_room'
end
where bg is null and category in ('longcase', 'meq');
