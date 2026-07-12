"use client";
// ข่าวสาร & บทความ (blog_posts จากโปรเจกต์ CPR) + ฟีดข่าวสาธารณะ jiaaed.com
import { useEffect, useState } from "react";
import { B } from "@/lib/cpr/config";
import { supaRest } from "@/lib/cpr/api";
import { css } from "./styles";
import type { OpenBlog } from "./types";

/* eslint-disable @typescript-eslint/no-explicit-any */

export const NEWS_SITE_SLUG = "jiacpr";

export function useNewsList(limit = 6) {
  const [posts, setPosts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    let cancelled = false;
    (async () => {
      const cols = "id,url_slug,title,meta_description,cover_image_url,category,published_at,keywords";
      const data = await supaRest("blog_posts", "GET", null, `?site_slug=eq.${NEWS_SITE_SLUG}&select=${cols}&order=published_at.desc.nullslast&limit=${limit}`);
      if (!cancelled) {
        setPosts(Array.isArray(data) ? data : []);
        setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [limit]);
  return { posts, loading };
}

export const fmtBlogDate = (d: string | null | undefined, long = false) => {
  if (!d) return "";
  try {
    return new Date(d).toLocaleDateString("th-TH", long ? { day: "numeric", month: "long", year: "numeric" } : { day: "numeric", month: "short" });
  } catch (_e) {
    return "";
  }
};

const CPR_KEYWORDS = /(CPR|AED|ช่วยชีวิต|หัวใจหยุด|Heimlich|สำลัก|กดหน้าอก|ฟื้นคืนชีพ|ปั๊มหัวใจ|ช็อกหัวใจ)/i;
export const isCprPost = (p: any) =>
  CPR_KEYWORDS.test(p.title || "") || CPR_KEYWORDS.test(p.category || "") || CPR_KEYWORDS.test(p.meta_description || "") || CPR_KEYWORDS.test(p.keywords || "");

export function NewsCarousel({ posts, openBlog, goAll, title, subtitle, accent }: { posts: any[]; openBlog: OpenBlog; goAll: () => void; title: string; subtitle?: string; accent?: string }) {
  if (!posts || posts.length === 0) return null;
  const ac = accent || B.red;
  return (
    <div style={{ ...css.wrap, paddingTop: 8, paddingBottom: 20 }}>
      <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between", marginBottom: 4 }}>
        <h3 style={{ fontSize: 18, fontWeight: 700, margin: 0 }}>{title}</h3>
        <button onClick={goAll} style={{ background: "none", border: "none", color: ac, fontSize: 13, fontWeight: 600, cursor: "pointer", padding: 4 }}>ดูทั้งหมด →</button>
      </div>
      {subtitle && <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 12 }}>{subtitle}</div>}
      <div style={{ display: "flex", gap: 12, overflowX: "auto", paddingBottom: 8, scrollSnapType: "x mandatory", WebkitOverflowScrolling: "touch", marginRight: -20, paddingRight: 20 }}>
        {posts.map((p) => (
          <button key={p.id} onClick={() => openBlog(p.url_slug)} style={{ flex: "0 0 230px", scrollSnapAlign: "start", background: B.white, border: "none", borderRadius: 14, overflow: "hidden", textAlign: "left", cursor: "pointer", padding: 0, boxShadow: "0 2px 8px rgba(0,0,0,.06)" }}>
            {p.cover_image_url
              ? <div style={{ width: "100%", aspectRatio: "16/10", background: `${B.gray} url(${p.cover_image_url}) center/cover no-repeat` }} />
              : <div style={{ width: "100%", aspectRatio: "16/10", background: `linear-gradient(135deg, ${ac}, ${B.dkRed})`, display: "flex", alignItems: "center", justifyContent: "center", color: B.white, fontSize: 13, fontWeight: 700, padding: 12, textAlign: "center" }}>{p.category || "บทความ"}</div>}
            <div style={{ padding: 12 }}>
              {p.category && <div style={{ fontSize: 10, color: ac, fontWeight: 700, marginBottom: 4, letterSpacing: 0.5 }}>{p.category}</div>}
              <div style={{ fontSize: 13, fontWeight: 700, color: B.black, lineHeight: 1.4, display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{p.title}</div>
              {p.published_at && <div style={{ fontSize: 11, color: B.dkGray, marginTop: 6 }}>{fmtBlogDate(p.published_at)}</div>}
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

export function NewsSection({ openBlog, goAll, title = "ข่าวสาร & บทความ", subtitle = "", cprOnly = false, max = 6 }: { openBlog: OpenBlog; goAll: () => void; title?: string; subtitle?: string; cprOnly?: boolean; max?: number }) {
  const { posts, loading } = useNewsList(24);
  if (loading || posts.length === 0) return null;
  const cpr = posts.filter(isCprPost).slice(0, max);
  if (cprOnly) {
    if (cpr.length === 0) return null;
    return <NewsCarousel posts={cpr} openBlog={openBlog} goAll={goAll} title={title || "บทความ CPR & การช่วยชีวิต"} subtitle={subtitle || "ทบทวนความรู้เพิ่มเติม"} accent={B.red} />;
  }
  const general = posts.filter((p) => !isCprPost(p)).slice(0, max);
  return (
    <>
      {cpr.length > 0 && <NewsCarousel posts={cpr} openBlog={openBlog} goAll={goAll} title="บทความ CPR & การช่วยชีวิต" subtitle="เนื้อหาเข้มข้นจาก JIA Trainer Center" accent={B.red} />}
      {general.length > 0 && <NewsCarousel posts={general} openBlog={openBlog} goAll={goAll} title={title} subtitle={subtitle} />}
    </>
  );
}

// ข่าวช่วยชีวิต/AED จากฟีดสาธารณะของ jiaaed.com — ทุกการ์ดลิงก์ออกไปข่าวต้นฉบับ
// (ลิขสิทธิ์เป็นของสำนักข่าวเดิม) ถ้าฟีดล่ม/ออฟไลน์จะซ่อนทั้ง section
export function JiaAedNewsSection({ max = 5 }: { max?: number }) {
  const [items, setItems] = useState<any[] | null>(null);
  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const res = await fetch(`https://jiaaed.com/api/news/public?limit=${max}`);
        const data = res.ok ? await res.json() : null;
        if (!cancelled) setItems(Array.isArray(data?.items) ? data.items : []);
      } catch (_e) {
        if (!cancelled) setItems([]);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [max]);
  if (!items || items.length === 0) return null;
  return (
    <div style={{ ...css.wrap, paddingTop: 8, paddingBottom: 20 }}>
      <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between", marginBottom: 4 }}>
        <h3 style={{ fontSize: 18, fontWeight: 700, margin: 0 }}>ข่าวช่วยชีวิต & AED</h3>
        <a href="https://jiaaed.com" target="_blank" rel="noopener noreferrer" style={{ color: B.red, fontSize: 13, fontWeight: 600, textDecoration: "none", padding: 4 }}>jiaaed.com →</a>
      </div>
      <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 12 }}>อัปเดตจาก JiaAED — แตะข่าวเพื่ออ่านต้นฉบับ</div>
      {items.map((n, i) => (
        <a key={n.source_url || i} href={n.source_url} target="_blank" rel="noopener noreferrer" style={{ display: "block", padding: "12px 14px", marginBottom: 8, background: B.white, borderRadius: 14, textDecoration: "none", boxShadow: "0 2px 8px rgba(0,0,0,.06)" }}>
          <div style={{ fontSize: 10, color: B.red, fontWeight: 700, marginBottom: 3, letterSpacing: 0.5 }}>{[n.topic, n.source_name].filter(Boolean).join(" · ")}</div>
          <div style={{ fontSize: 13, fontWeight: 700, color: B.black, lineHeight: 1.45 }}>{n.source_title}</div>
          {n.our_blurb && <div style={{ fontSize: 12, color: B.dkGray, marginTop: 4, lineHeight: 1.5, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{n.our_blurb}</div>}
          {n.published_at && <div style={{ fontSize: 11, color: B.dkGray, marginTop: 5 }}>{fmtBlogDate(n.published_at, true)}</div>}
        </a>
      ))}
    </div>
  );
}
