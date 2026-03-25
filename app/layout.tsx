import type { Metadata } from "next";
import { Sarabun } from "next/font/google";
import { Geist_Mono } from "next/font/google";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import "./globals.css";

const sarabun = Sarabun({
  variable: "--font-sarabun",
  subsets: ["thai", "latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "หมอรู้ (MorRoo) — แพลตฟอร์มข้อสอบ MEQ สำหรับแพทย์",
    template: "%s | หมอรู้ MorRoo",
  },
  description:
    "เตรียมสอบแพทย์ด้วยข้อสอบ MEQ ออนไลน์ ครบทุกสาขา อายุรศาสตร์ ศัลยศาสตร์ กุมารฯ สูติฯ ออร์โธฯ จิตเวช พร้อมเฉลยละเอียดและ Key Points",
  metadataBase: new URL("https://morroo.com"),
  openGraph: {
    title: "หมอรู้ (MorRoo) — แพลตฟอร์มข้อสอบ MEQ สำหรับแพทย์",
    description:
      "เตรียมสอบแพทย์ด้วยข้อสอบ MEQ ออนไลน์ ครบทุกสาขา พร้อมเฉลยละเอียด",
    url: "https://morroo.com",
    siteName: "หมอรู้ MorRoo",
    locale: "th_TH",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "หมอรู้ (MorRoo)",
    description: "แพลตฟอร์มข้อสอบ MEQ สำหรับแพทย์",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="th"
      className={`${sarabun.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">
        <Navbar />
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
