import ItemUpsell from "@/components/ItemUpsell";
import { ITEM_PRICES, itemPlanType } from "@/lib/items";

interface Props {
  topic: { id: string; year: number; name_th: string };
  title: string;
  className?: string;
}

/**
 * การ์ดขายวิชาเดียวของโหมด School — ตั้งค่าเดียวกับหน้า guided
 * (วิชานี้ / School ทั้งระบบ / แพ็ก นศพ.) ใช้ร่วมกันใน topic, lesson,
 * book และ visual ให้ราคากับข้อความตรงกันทุกที่
 */
export default function TopicUpsell({ topic, title, className }: Props) {
  return (
    <ItemUpsell
      className={className}
      title={title}
      itemPlan={itemPlanType("school_topic", topic.id)}
      itemLabel={topic.name_th}
      itemAmount={ITEM_PRICES.school_topic}
      productPlan="school_monthly"
      packPlan="monthly"
      note={`ทั้งปี ${topic.year} ทุกบท ฿${ITEM_PRICES.school_year} ซื้อขาด — เลือกได้ที่หน้าชำระเงิน`}
    />
  );
}
