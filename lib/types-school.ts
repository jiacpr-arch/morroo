export type SchoolLayer =
  | "anatomy"
  | "physio"
  | "biochem"
  | "path"
  | "pharm"
  | "clinical"
  | "foundation";

export type SchoolDifficulty = "easy" | "medium" | "hard";

export interface SchoolSystem {
  id: string;
  slug: string;
  name_th: string;
  name_en: string;
  icon: string;
  sort_order: number;
}

export interface SchoolTopic {
  id: string;
  system_id: string;
  year: number;
  slug: string;
  name_th: string;
  name_en: string;
  summary: string | null;
  sort_order: number;
  school_systems?: SchoolSystem;
}

export interface SchoolFlashcard {
  id: string;
  topic_id: string;
  layer: SchoolLayer;
  front: string;
  back: string;
  image_url: string | null;
  difficulty: SchoolDifficulty;
  source: string | null;
}

export interface SchoolQuiz {
  id: string;
  topic_id: string;
  layer: SchoolLayer;
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string | null;
  difficulty: SchoolDifficulty;
  source: string | null;
}

export interface SchoolLesson {
  id: string;
  topic_id: string;
  layer: SchoolLayer;
  title: string;
  body_md: string;
  estimated_min: number;
  sort_order: number;
  source: string | null;
}

export type SchoolProgressOutcome =
  | "again"
  | "hard"
  | "good"
  | "easy"
  | "correct"
  | "wrong";
