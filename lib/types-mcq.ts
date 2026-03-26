export interface McqSubject {
  id: string;
  name: string;
  name_th: string;
  icon: string;
  exam_type: "NL1" | "NL2" | "both";
  question_count: number;
  created_at: string;
}

export interface McqChoice {
  label: string;
  text: string;
}

export interface McqChoiceExplanation {
  label: string;
  text: string;
  is_correct: boolean;
  explanation: string;
}

export interface McqQuestion {
  id: string;
  subject_id: string;
  exam_type: "NL1" | "NL2";
  exam_source: string | null;
  question_number: number | null;
  scenario: string;
  choices: McqChoice[];
  correct_answer: string;
  explanation: string | null;
  detailed_explanation: {
    summary: string;
    reason: string;
    choices: McqChoiceExplanation[];
    key_takeaway: string;
  } | null;
  difficulty: "easy" | "medium" | "hard";
  is_ai_enhanced: boolean;
  ai_notes: string | null;
  status: "active" | "review" | "disabled";
  created_at: string;
  // joined
  mcq_subjects?: McqSubject;
}

export interface McqAttempt {
  id: string;
  user_id: string;
  question_id: string;
  selected_answer: string;
  is_correct: boolean;
  time_spent_seconds: number | null;
  mode: "practice" | "mock";
  session_id: string | null;
  created_at: string;
}

export interface McqSession {
  id: string;
  user_id: string;
  mode: "practice" | "mock";
  exam_type: "NL1" | "NL2";
  subject_id: string | null;
  total_questions: number;
  correct_count: number;
  time_limit_minutes: number | null;
  completed_at: string | null;
  created_at: string;
}

export const MCQ_SUBJECTS = [
  { name: "cardio_med", name_th: "อายุรศาสตร์หัวใจ", icon: "❤️" },
  { name: "chest_med", name_th: "อายุรศาสตร์ทรวงอก", icon: "🫁" },
  { name: "ent", name_th: "โสต ศอ นาสิก", icon: "👂" },
  { name: "endocrine", name_th: "ต่อมไร้ท่อ", icon: "🦋" },
  { name: "eye", name_th: "จักษุวิทยา", icon: "👁️" },
  { name: "forensic", name_th: "นิติเวชศาสตร์", icon: "🔍" },
  { name: "gi_med", name_th: "อายุรศาสตร์ทางเดินอาหาร", icon: "🫄" },
  { name: "hemato_med", name_th: "โลหิตวิทยา", icon: "🩸" },
  { name: "infectious_med", name_th: "โรคติดเชื้อ", icon: "🦠" },
  { name: "nephro_med", name_th: "อายุรศาสตร์ไต", icon: "🫘" },
  { name: "neuro_med", name_th: "ประสาทวิทยา", icon: "🧠" },
  { name: "ob_gyn", name_th: "สูติศาสตร์-นรีเวชวิทยา", icon: "🤰" },
  { name: "ortho", name_th: "ออร์โธปิดิกส์", icon: "🦴" },
  { name: "ped", name_th: "กุมารเวชศาสตร์", icon: "👶" },
  { name: "psychi", name_th: "จิตเวชศาสตร์", icon: "🧘" },
  { name: "surgery", name_th: "ศัลยศาสตร์", icon: "🔪" },
  { name: "epidemio", name_th: "ระบาดวิทยา", icon: "📊" },
] as const;
