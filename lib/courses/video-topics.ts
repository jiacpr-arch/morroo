// หัวข้อของ "วิดีโอบทเรียน" (ACLS) — ใช้ร่วมกันระหว่างหน้าไลบรารี, หน้าแอดมิน และเงื่อนไขใบประกาศนียบัตร
// id ต้องเสถียร (ใช้เป็น topic ในตาราง video_lessons) — ห้ามแก้ภายหลังโดยไม่ migrate ข้อมูล
// Ported verbatim from acls-emr's src/data/videoTopics.js.

export interface VideoTopic {
  id: string;
  emoji: string;
  label: string;
  en: string;
}

export const VIDEO_TOPICS: VideoTopic[] = [
  { id: "airway", emoji: "💨", label: "ทางเดินหายใจ", en: "Airway" },
  { id: "ekg", emoji: "📈", label: "การอ่าน EKG", en: "EKG / Rhythm" },
  { id: "defib", emoji: "⚡", label: "การช็อกไฟฟ้า", en: "Defibrillation" },
  { id: "brady", emoji: "🐢", label: "หัวใจเต้นช้า", en: "Bradycardia" },
  { id: "tachy", emoji: "🏃", label: "หัวใจเต้นเร็ว", en: "Tachycardia" },
  { id: "arrest", emoji: "🫀", label: "ภาวะหัวใจหยุดเต้น", en: "Cardiac Arrest" },
  { id: "iv", emoji: "💉", label: "ยา (IV)", en: "IV Drugs" },
  { id: "postarrest", emoji: "💗", label: "ดูแลหลังหัวใจหยุดเต้น", en: "Post-ROSC" },
  { id: "bls", emoji: "🆘", label: "CPR/BLS พื้นฐาน", en: "BLS / CPR" },
];

export const VIDEO_TOPIC_MAP: Record<string, VideoTopic> = VIDEO_TOPICS.reduce(
  (acc, tpc) => {
    acc[tpc.id] = tpc;
    return acc;
  },
  {} as Record<string, VideoTopic>,
);

// prefix ของ lessonId สำหรับ progress/quiz ของวิดีโอ — กันชนกับบท pre-course (pcNN)
export const VIDEO_LESSON_PREFIX = "vidlesson:";
export const videoLessonKey = (id: string): string => `${VIDEO_LESSON_PREFIX}${id}`;
