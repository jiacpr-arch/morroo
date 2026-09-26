# MorRoo site design

MorRoo uses a warm clinical learning style: calm reading surfaces, clear medical study imagery, and an uncluttered practice experience. This guide covers the main MorRoo site. The emergency and game microsites keep their own product-specific layouts.

## Tokens

| Role | Token | Value | Use |
| --- | --- | --- | --- |
| Main action | `brand` | `#16A085` | Primary actions and active states |
| Deep green | `brand-dark` | `#1A2F23` | Headings, navigation, dark feature panels |
| Warm surface | `surface-warm` | `#F3F5EF` | Introductions and learning context |
| Warm border | `surface-border` | `#DDE6DA` | Panel and card outlines |
| Supporting text | `ink-soft` | `#536557` | Descriptions on warm surfaces |

The site uses Sarabun for Thai and Latin interface copy. The base radius is `0.75rem`. Shared cards use a light warm border and restrained shadow. Default buttons and inputs are 40px tall; smaller variants are for compact controls. Avoid arbitrary green or gray hex values in new page-level components when a token already serves the purpose.

## Page patterns

- **Discovery pages:** `LearningPageHero` pairs a page introduction with a relevant image. Use a real action below it, such as filters, plan selection, or a free sample.
- **Learning and account pages:** `PageIntro` gives the page a consistent heading and short next-step description. Place progress, topics, or account controls below it in white cards.
- **Focused practice:** Keep questions, timing, progress, and the answer field in a narrow reading column. Hide floating contact and guest promotion controls while a timed question is active.
- **Registration and login:** Use `AuthIllustration` on wide screens and keep the form first on small screens. The illustration does not replace headings or form labels.
- **Navigation:** Keep common learning destinations visible. Put less frequent destinations in the "เพิ่มเติม" menu. On mobile, show grouped links and one contact launcher with chat and LINE choices.

## Accessibility and image rules

Use one `h1` per page. Give links and buttons visible focus states, meaningful labels, and comfortable touch space. Keep information in text instead of inside images. Use descriptive alt text for informative images, and `alt=""` only for purely decorative ones. Label generated study scenes as illustrations; do not portray them as evidence of actual learners or patient care. Verify mobile widths and keyboard navigation when changing shared components.
