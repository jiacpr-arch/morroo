export interface StudyPlanDay {
  day: string; // "Mon" | "Tue" ... (Thai-friendly label OK)
  tasks: string[];
}

export interface StudyPlanWeek {
  week_number: number;
  start_date: string; // ISO date
  focus: string;
  daily_tasks: StudyPlanDay[];
}

export interface StudyPlan {
  generated_at: string;
  exam_date: string;
  daily_hours: number;
  weeks: StudyPlanWeek[];
  advice: string;
}
