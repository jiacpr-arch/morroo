# ระบบตัวอักษร & การจัดหน้า (Typography & Layout System)

ชุดดีไซน์ที่ใช้ในหน้า **ACLS Reader → Q&A เชิงลึก** (`/acls-reader/qa-deep/*`)
ถอดออกมาเป็นชุดอ้างอิงเพื่อนำไป **reuse กับหน้าอื่น/โปรเจกต์อื่น**

โทนหลัก: สะอาด อ่านง่าย โทนสีแบรนด์ teal/green, ตัวอักษรไทย Sarabun, หัวเรื่องเด่นชัด

---

## 1. Design Tokens

### 1.1 สีแบรนด์ (กำหนดใน `app/globals.css` → `@theme inline`)

```css
--color-brand:       #16A085;  /* teal เขียวหลัก — ลิงก์, ปุ่ม, accent */
--color-brand-light: #1ABC9C;  /* เขียวอ่อน — ใช้ใน gradient */
--color-brand-dark:  #1A2F23;  /* เขียวเข้มเกือบดำ — หัวเรื่อง (h1/h2) */
```

ใช้ได้ทันทีเป็น utility: `text-brand`, `bg-brand`, `border-brand`, `text-brand-dark`,
`from-brand-light` ฯลฯ และ **รองรับ opacity modifier**: `bg-brand/10`, `border-brand/40`,
`text-foreground/85`, `decoration-brand/30`

### 1.2 ฟอนต์

```css
--font-sans:    var(--font-sarabun);  /* เนื้อหา + หัวเรื่อง (ไทย) */
--font-heading: var(--font-sarabun);
--font-mono:    var(--font-geist-mono);
```

> ทั้งหน้าใช้ Sarabun ผ่าน `html { font-family: sans }` — ไม่ต้องตั้งฟอนต์ซ้ำในแต่ละหน้า

### 1.3 Semantic tokens (โทนเขียวอมเทาทั้งชุด — oklch hue ~155–170)

| Token | ใช้ทำอะไร |
|---|---|
| `background` / `foreground` | พื้นหลังหน้า / สีตัวอักษรหลัก |
| `card` / `card-foreground` | พื้นการ์ด (ขาว) |
| `muted` / `muted-foreground` | พื้นจาง / ตัวอักษรรอง (เทา) |
| `border` | เส้นขอบบาง |
| `primary` / `accent` / `ring` | teal สำหรับ control / focus ring |
| `--radius: 0.625rem` | ฐานความโค้ง (rounded-lg/xl/2xl/3xl คูณต่อจากนี้) |

**หลักการใช้สีตัวอักษรให้อ่านสบาย:** ตัวเนื้อหาใช้ `text-foreground/85`, ตัวรอง `text-muted-foreground`,
หัวเรื่องใหญ่ `text-brand-dark`, หัวเรื่องย่อย/ลิงก์ `text-brand`

---

## 2. ระบบเนื้อหาแบบอ่านยาว (Prose / Markdown)

ใช้ component เดียว render markdown ให้ได้สไตล์การอ่านที่สม่ำเสมอ
(อ้างอิง `components/acls-reader/Markdown.tsx`)

### 2.1 Dependencies

```bash
npm install react-markdown remark-gfm remark-breaks
```

- `remark-gfm` — ตาราง, ~~strikethrough~~, task list
- `remark-breaks` — **สำคัญ:** ทำให้การขึ้นบรรทัดเดี่ยว (`\n`) กลายเป็นการขึ้นบรรทัดจริง
  ป้องกันเนื้อหา plain-text ถูกยุบติดกันเป็นพืด

### 2.2 Component (copy ได้ทั้งก้อน)

```tsx
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import remarkBreaks from "remark-breaks";
import { cn } from "@/lib/utils";

const PROSE =
  "prose prose-lg max-w-none text-[1.0625rem] leading-relaxed sm:text-lg " +
  "prose-headings:scroll-mt-20 prose-headings:font-bold prose-headings:tracking-tight prose-headings:text-brand-dark " +
  "prose-h2:mt-12 prose-h2:mb-4 prose-h2:text-2xl prose-h2:border-l-4 prose-h2:border-brand prose-h2:pl-3 sm:prose-h2:text-3xl " +
  "prose-h3:mt-8 prose-h3:mb-3 prose-h3:text-xl prose-h3:text-brand sm:prose-h3:text-2xl " +
  "prose-h4:mt-6 prose-h4:mb-2 prose-h4:text-lg prose-h4:font-semibold prose-h4:text-foreground " +
  "prose-p:my-4 prose-p:leading-[1.9] prose-p:text-foreground/85 " +
  "prose-a:text-brand prose-a:font-semibold prose-a:underline prose-a:decoration-brand/30 prose-a:underline-offset-2 hover:prose-a:decoration-brand " +
  "prose-li:my-1.5 prose-li:leading-[1.85] prose-li:text-foreground/85 prose-li:marker:text-brand " +
  "prose-strong:font-bold prose-strong:text-brand-dark " +
  "prose-blockquote:rounded-r-xl prose-blockquote:border-l-4 prose-blockquote:border-brand prose-blockquote:bg-brand/5 prose-blockquote:py-1 prose-blockquote:not-italic prose-blockquote:text-foreground/80 " +
  "prose-code:rounded prose-code:bg-brand/10 prose-code:px-1.5 prose-code:py-0.5 prose-code:font-medium prose-code:text-brand prose-code:before:content-none prose-code:after:content-none " +
  "prose-img:rounded-xl prose-img:border prose-img:border-border prose-img:shadow-sm " +
  "prose-hr:my-10 prose-hr:border-border " +
  "prose-table:my-6 prose-table:overflow-hidden prose-table:rounded-xl prose-table:text-base " +
  "prose-th:bg-brand/10 prose-th:p-3 prose-th:text-left prose-th:font-bold prose-th:text-brand-dark " +
  "prose-td:border prose-td:border-border prose-td:p-3 " +
  "prose-tr:even:bg-muted/40";

export default function Markdown({
  children,
  className,
}: {
  children: string;
  className?: string;
}) {
  return (
    <div className={cn(PROSE, className)}>
      <ReactMarkdown remarkPlugins={[remarkGfm, remarkBreaks]}>
        {children}
      </ReactMarkdown>
    </div>
  );
}
```

> ต้องมี `@tailwindcss/typography` (`@plugin "@tailwindcss/typography";` ใน globals.css)

### 2.3 ลำดับชั้นหัวเรื่องในเนื้อหา (content convention)

ให้คอนเทนต์ในฐานข้อมูล/ไฟล์ เขียนเป็น **markdown จริง** เพื่อให้ render สวย:

| ระดับ | markdown | สไตล์ที่ได้ |
|---|---|---|
| หัวข้อหลัก | `## หัวข้อ` | ใหญ่ + เส้นแถบสีแบรนด์ซ้าย, `text-brand-dark` |
| หัวข้อย่อย | `### หัวข้อ` | กลาง, `text-brand` |
| หัวข้อย่อยลึก | `#### หัวข้อ` | เล็ก, ตัวหนา |
| รายการ | `- ข้อความ` | bullet จุดสีแบรนด์ |
| เน้น | `**คำ**` | ตัวหนา `text-brand-dark` |

> ถ้าคอนเทนต์เดิมเป็น plain text ขึ้นบรรทัดเดี่ยว → `remark-breaks` จะช่วยไม่ให้ติดกัน
> แต่ถ้าอยากได้หัวเรื่องเด่น ต้องเติม `##`/`###` ในตัวคอนเทนต์เอง

---

## 3. Layout Recipes (copy-paste)

### 3.1 คอนเทนเนอร์หน้า

```tsx
{/* หน้า list / index */}
<div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8"> … </div>

{/* หน้าอ่านเนื้อหา (แคบลงเพื่ออ่านง่าย) */}
<div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8"> … </div>
```

### 3.2 Hero header (หัวหน้าแบบ gradient)

```tsx
<header className="mb-12 overflow-hidden rounded-3xl border border-brand/15 bg-gradient-to-br from-brand/10 via-brand-light/5 to-transparent px-6 py-10 text-center sm:px-10 sm:py-12">
  <span className="inline-flex items-center gap-2 rounded-full bg-brand/10 px-4 py-1.5 text-sm font-semibold text-brand">
    ป้ายกำกับ
  </span>
  <h1 className="mt-5 text-3xl font-extrabold tracking-tight text-brand-dark sm:text-4xl lg:text-5xl">
    หัวเรื่องหลัก
  </h1>
  <p className="mx-auto mt-4 max-w-2xl text-lg leading-relaxed text-foreground/70 sm:text-xl">
    คำโปรย/คำอธิบาย
  </p>
</header>
```

### 3.3 หัวข้อ section พร้อมแถบสีเน้น

```tsx
<h2 className="mb-5 flex items-center gap-3 text-xl font-bold text-brand-dark sm:text-2xl">
  <span className="h-7 w-1.5 rounded-full bg-brand" />
  ชื่อหัวข้อ
</h2>
```

### 3.4 การ์ดเลือกหมวด (มีไอคอน + hover ยกขึ้น)

```tsx
<Link href="…" className="group block">
  <div className="flex h-full items-start gap-4 rounded-2xl border border-border bg-card p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-lg hover:shadow-brand/5">
    <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-brand/10 text-2xl transition-colors group-hover:bg-brand/15">
      🫀
    </span>
    <div className="min-w-0 flex-1">
      <h3 className="text-base font-bold leading-snug text-foreground transition-colors group-hover:text-brand sm:text-lg">
        ชื่อหมวด
      </h3>
      <p className="mt-1.5 text-sm font-medium text-muted-foreground">คำอธิบายสั้น</p>
    </div>
  </div>
</Link>
```

### 3.5 รายการแบบมีเลขลำดับ (numbered list)

```tsx
<ol className="space-y-3">
  {items.map((it, i) => (
    <li key={it.id}>
      <Link
        href="…"
        className="group flex items-start gap-4 rounded-2xl border border-border bg-card p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-md hover:shadow-brand/5"
      >
        <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-brand/10 text-sm font-bold text-brand transition-colors group-hover:bg-brand group-hover:text-white">
          {i + 1}
        </span>
        <span className="text-base font-semibold leading-relaxed text-foreground transition-colors group-hover:text-brand sm:text-lg">
          {it.title}
        </span>
      </Link>
    </li>
  ))}
</ol>
```

### 3.6 Breadcrumb

```tsx
<nav className="mb-6 text-sm text-muted-foreground">
  <Link href="/" className="hover:text-foreground">หน้าแรก</Link>
  {" / "}
  <span className="font-medium text-foreground">หน้าปัจจุบัน</span>
</nav>
```

### 3.7 Figure (รูป + caption)

```tsx
<figure className="my-6 overflow-hidden rounded-xl border border-border">
  <img src={src} alt={alt} loading="lazy" className="h-auto w-full" />
  <figcaption className="px-4 py-2 text-sm text-muted-foreground">{caption}</figcaption>
</figure>
```

---

## 4. กฎย่อ (cheat-sheet)

- **ความกว้างอ่าน:** list = `max-w-4xl`, อ่านยาว = `max-w-3xl`
- **ความโค้ง:** การ์ด/บล็อก = `rounded-2xl`, hero = `rounded-3xl`, ไอคอน = `rounded-xl`
- **เงา:** ปกติ `shadow-sm` → hover `shadow-md`/`shadow-lg` + `hover:shadow-brand/5`
- **hover การ์ด:** `hover:-translate-y-0.5 hover:border-brand/40` + เปลี่ยนสีหัวเป็น `group-hover:text-brand`
- **ขนาดตัวอักษร:** เนื้อหา `text-base sm:text-lg`, หัวหน้า `text-3xl→5xl`, หัวข้อ `text-xl→2xl`
- **น้ำหนัก:** หัวหน้า `font-extrabold`, หัวข้อ `font-bold`, รายการ `font-semibold`, เนื้อหา ปกติ
- **เส้นนำสายตา:** badge pill (`bg-brand/10 text-brand`) + แถบ accent (`h-7 w-1.5 bg-brand`)

---

## 5. ไฟล์อ้างอิงในรีโพนี้

| ไฟล์ | บทบาท |
|---|---|
| `app/globals.css` | นิยาม token (brand, fonts, semantic colors) |
| `components/acls-reader/Markdown.tsx` | ระบบ prose สำหรับอ่านยาว |
| `components/acls-reader/Figure.tsx` | รูป + caption |
| `app/acls-reader/qa-deep/page.tsx` | hero + section heading + cards + numbered list |
| `app/acls-reader/qa-deep/[chapterId]/page.tsx` | header การ์ด + numbered list |
| `app/acls-reader/qa-deep/q/[itemId]/page.tsx` | breadcrumb + หัวคำถาม gradient + prose + prev/next |

> **นำไป reuse:** ต้องมี (1) brand/font/semantic tokens ใน `globals.css`,
> (2) `@plugin "@tailwindcss/typography"`, (3) deps `react-markdown remark-gfm remark-breaks`,
> (4) helper `cn()` (clsx + tailwind-merge) แล้ว copy `Markdown.tsx` + layout recipes ไปได้เลย
