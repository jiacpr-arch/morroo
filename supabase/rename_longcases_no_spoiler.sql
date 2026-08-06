-- เปลี่ยนชื่อ long_cases.title ที่เฉลยการวินิจฉัยในชื่อ ให้เป็นชื่อแบบ
-- "อาการนำ" — ชื่อนี้โชว์ค้างบนหัวจอตลอด session /longcase (รวมช่วงตอบ DDx)
-- และในหน้า /board/[specialty]/oral
--
-- ตารางนี้ส่วนใหญ่ (100+ แถว) ตั้งชื่อแบบอาการนำอยู่แล้ว มีแค่ 2 แถวที่หลุด
-- เฉลยชื่อโรคเต็มๆ (Hypertrophic Obstructive Cardiomyopathy, Hypertensive
-- Emergency/Encephalopathy) — sim_scenarios ของ 2 เคสนี้ (lc-b01d23b3,
-- lc-692d1cfc) ถูกแก้ไปแล้วในรอบก่อนหน้า แต่ long_cases.title ต้นทางยังไม่ได้แก้

update long_cases as lc
set title = v.new_title
from (
  values
    ('b01d23b3-ead7-457c-bc0a-86d171ceecdf'::uuid, 'ชาย 38 ปี เป็นลมขณะวิ่งออกกำลังกาย ประวัติครอบครัวเสียชีวิตกะทันหัน'),
    ('692d1cfc-155f-4458-9b11-abc37fbe3aa3'::uuid, 'ชายสูงอายุหมดสติและชักที่บ้าน ความดันโลหิตสูงมาก')
) as v(id, new_title)
where lc.id = v.id;
