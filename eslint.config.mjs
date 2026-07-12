import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  globalIgnores([
    // Default ignores of eslint-config-next:
    ".next/**",
    "out/**",
    "build/**",
    "next-env.d.ts",
    // CommonJS seed/maintenance scripts — not part of the Next.js app.
    "scripts/**/*.js",
    "scripts/**/*.cjs",
    "scripts/**/*.mjs",
    "seed-*.js",
    // Standalone Express sub-project with its own tooling.
    "jiaraksa-sales-portal/**",
  ]),
  // SSR-hydration "setMounted(true)" + interval setup are intentional patterns;
  // disable the noisy set-state-in-effect rule globally.
  {
    rules: {
      // SSR-hydration "setMounted(true)" + interval setup are intentional patterns.
      "react-hooks/set-state-in-effect": "off",
      // Date.now() / Math.random() in initializers are fine for timestamps/ids.
      "react-hooks/purity": "off",
      // Allow underscore-prefixed args/vars to be unused (intentional placeholders).
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          args: "after-used",
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^_",
        },
      ],
    },
  },
  // firstaid section: components/pages ported verbatim from the Vite app —
  // course-content shapes (lessons/scenarios/algorithms) live in plain JS
  // data files, so `any` at those boundaries is expected rather than a bug.
  {
    files: [
      "app/(firstaid)/**",
      "components/firstaid/**",
      "lib/firstaid/**",
    ],
    rules: {
      "@typescript-eslint/no-explicit-any": "warn",
    },
  },
]);

export default eslintConfig;
