// Assessment constants ported from acls-emr's src/data/assessment.js.
// The pre/post-test attempts are stored in Dexie under these synthetic
// lesson ids so they share the same quizAttempts table as lesson quizzes.

export const PRE_TEST_LESSON_ID = "pre-test";
export const PRE_TEST_PASS_PERCENT = 70;
export const PRE_TEST_QUESTION_COUNT = 20;

export const POST_TEST_LESSON_ID = "post-test";
export const POST_TEST_PASS_PERCENT = 85;
export const POST_TEST_QUESTION_COUNT = 30;
