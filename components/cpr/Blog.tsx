"use client";
import { useEffect, useState } from "react";
import { B } from "@/lib/cpr/config";
import { supaRest } from "@/lib/cpr/api";
import { css } from "./styles";
import { I } from "./icons";
import { fmtBlogDate, NEWS_SITE_SLUG } from "./News";
import type { OpenBlog } from "./types";

/* eslint-disable @typescript-eslint/no-explicit-any */

export function BlogList({ goBack, openBlog }: { goBack: () => void; openBlog: OpenBlog }) {
  const [posts, setPosts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    let cancelled = false;
    (async () => {
      const cols = "id,url_slug,title,meta_description,cover_image_url,category,published_at";
      const data = await supaRest("blog_posts", "GET", null, `?site_slug=eq.${NEWS_SITE_SLUG}&select=${cols}&order=published_at.desc.nullslast&limit=60`);
      if (!cancelled) {
        setPosts(Array.isArray(data) ? data : []);
        setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);
  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={goBack} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 16, fontWeight: 700 }}>ข่าวสาร & บทความ</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 20, paddingBottom: 40 }}>
        {loading ? <div style={{ textAlign: "center", color: B.dkGray, padding: 40 }}>กำลังโหลด...</div>
          : posts.length === 0 ? <div style={{ textAlign: "center", color: B.dkGray, padding: 40 }}>ยังไม่มีบทความ</div>
          : posts.map((p) => (
            <button key={p.id} onClick={() => openBlog(p.url_slug)} style={{ display: "flex", gap: 12, width: "100%", padding: 12, marginBottom: 10, background: B.white, border: "none", borderRadius: 14, cursor: "pointer", textAlign: "left", alignItems: "flex-start" }}>
              {p.cover_image_url
                ? <div style={{ width: 96, height: 72, flexShrink: 0, borderRadius: 10, background: `${B.gray} url(${p.cover_image_url}) center/cover no-repeat` }} />
                : <div style={{ width: 96, height: 72, flexShrink: 0, borderRadius: 10, background: `linear-gradient(135deg, ${B.red}, ${B.dkRed})` }} />}
              <div style={{ flex: 1, minWidth: 0 }}>
                {p.category && <div style={{ fontSize: 10, color: B.red, fontWeight: 700, marginBottom: 2 }}>{p.category}</div>}
                <div style={{ fontSize: 13, fontWeight: 700, color: B.black, lineHeight: 1.4, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{p.title}</div>
                {p.published_at && <div style={{ fontSize: 11, color: B.dkGray, marginTop: 4 }}>{fmtBlogDate(p.published_at, true)}</div>}
              </div>
            </button>
          ))}
      </div>
    </div>
  );
}

export function BlogDetail({ slug, goBack, openBlog }: { slug: string; goBack: () => void; openBlog: OpenBlog }) {
  const [post, setPost] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [related, setRelated] = useState<any[]>([]);
  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoading(true);
      const data = await supaRest("blog_posts", "GET", null, `?url_slug=eq.${encodeURIComponent(slug)}&select=*&limit=1`);
      const p = Array.isArray(data) && data[0] ? data[0] : null;
      if (!cancelled) {
        setPost(p);
        setLoading(false);
      }
      if (p) {
        const cols = "id,url_slug,title,cover_image_url,category,published_at";
        const rel = await supaRest("blog_posts", "GET", null, `?site_slug=eq.${NEWS_SITE_SLUG}&url_slug=neq.${encodeURIComponent(slug)}&select=${cols}&order=published_at.desc.nullslast&limit=4`);
        if (!cancelled) setRelated(Array.isArray(rel) ? rel : []);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [slug]);
  if (loading)
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <button onClick={goBack} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ fontSize: 16, fontWeight: 700 }}>กำลังโหลด...</div>
        </div>
      </div>
    );
  if (!post)
    return (
      <div style={css.page}>
        <div style={css.header(B.red)}>
          <button onClick={goBack} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
          <div style={{ fontSize: 16, fontWeight: 700 }}>ไม่พบบทความ</div>
        </div>
        <div style={{ ...css.wrap, paddingTop: 40, textAlign: "center", color: B.dkGray }}>บทความนี้อาจถูกลบหรือยังไม่เผยแพร่</div>
      </div>
    );
  return (
    <div style={css.page}>
      <div style={css.header(B.red)}>
        <button onClick={goBack} style={{ background: "none", border: "none", padding: 0, cursor: "pointer" }}><I name="back" size={24} color={B.white} /></button>
        <div style={{ fontSize: 14, fontWeight: 700, flex: 1, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{post.title}</div>
      </div>
      <div style={{ ...css.wrap, paddingTop: 16, paddingBottom: 60 }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        {post.cover_image_url && <img src={post.cover_image_url} alt={post.title} style={{ width: "100%", borderRadius: 14, marginBottom: 14, display: "block" }} />}
        {post.category && <div style={{ fontSize: 11, color: B.red, fontWeight: 700, marginBottom: 6, letterSpacing: 0.5 }}>{post.category.toUpperCase()}</div>}
        <h1 style={{ fontSize: 22, fontWeight: 800, lineHeight: 1.3, margin: "0 0 10px" }}>{post.title}</h1>
        {post.published_at && <div style={{ fontSize: 12, color: B.dkGray, marginBottom: 18 }}>{fmtBlogDate(post.published_at, true)}</div>}
        {post.meta_description && <div style={{ fontSize: 14, color: B.dkGray, lineHeight: 1.6, marginBottom: 16, padding: "12px 14px", background: `${B.gold}10`, borderLeft: `3px solid ${B.gold}`, borderRadius: 6 }}>{post.meta_description}</div>}
        {post.content_html && <div className="jia-blog-content" style={{ fontSize: 15, lineHeight: 1.8, color: B.black, wordBreak: "break-word" }} dangerouslySetInnerHTML={{ __html: post.content_html }} />}
        {related.length > 0 && (
          <>
            <h3 style={{ fontSize: 16, fontWeight: 700, marginTop: 32, marginBottom: 12 }}>บทความอื่นที่น่าสนใจ</h3>
            {related.map((p) => (
              <button key={p.id} onClick={() => openBlog(p.url_slug)} style={{ display: "flex", gap: 12, width: "100%", padding: 10, marginBottom: 8, background: B.white, border: "none", borderRadius: 12, cursor: "pointer", textAlign: "left", alignItems: "center" }}>
                {p.cover_image_url
                  ? <div style={{ width: 64, height: 64, flexShrink: 0, borderRadius: 10, background: `${B.gray} url(${p.cover_image_url}) center/cover no-repeat` }} />
                  : <div style={{ width: 64, height: 64, flexShrink: 0, borderRadius: 10, background: `linear-gradient(135deg, ${B.red}, ${B.dkRed})` }} />}
                <div style={{ flex: 1, minWidth: 0, fontSize: 12, fontWeight: 600, lineHeight: 1.4, display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{p.title}</div>
              </button>
            ))}
          </>
        )}
      </div>
    </div>
  );
}
