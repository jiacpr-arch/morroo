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

export interface SchoolBook {
  id: string;
  topic_id: string;
  title: string;
  description: string | null;
  source: string | null;
}

export interface SchoolBookChapter {
  id: string;
  book_id: string;
  sort_order: number;
  title: string;
  body_md: string;
  source: string | null;
}

export type SchoolProgressOutcome =
  | "again"
  | "hard"
  | "good"
  | "easy"
  | "correct"
  | "wrong";

export interface SchoolConcept {
  id: string;
  slug: string;
  name_th: string;
  name_en: string;
  description: string | null;
  icon: string;
}

export interface SchoolCase {
  id: string;
  slug: string;
  title: string;
  presentation: string;
  difficulty: SchoolDifficulty;
  audience_years: number[];
  primary_system_id: string | null;
  school_systems?: SchoolSystem;
}

export interface SchoolCaseStage {
  id: string;
  case_id: string;
  stage_order: number;
  layer: SchoolLayer;
  title: string;
  body_md: string;
  mini_quiz_stem: string | null;
  mini_quiz_choices: { label: string; text: string }[] | null;
  mini_quiz_answer: string | null;
  mini_quiz_explanation: string | null;
}

export interface SchoolVisual {
  id: string;
  topic_id: string;
  layer: SchoolLayer;
  title: string;
  image_url: string | null;
  caption: string | null;
  notes_md: string | null;
  check_questions: { q: string; a: string }[];
  linked_flashcard_ids: string[];
  source: string | null;
  sort_order: number;
  school_topics?: SchoolTopic;
}
