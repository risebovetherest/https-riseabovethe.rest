# SEO & Speed Audit: riseabovethe.rest

**Analysis Date:** July 7, 2026  
**Website:** Double R Roofing - Princeton, WV

---

## ✅ What's Already Excellent

### SEO Foundations
- ✅ Comprehensive meta tags (title, description, canonical)
- ✅ Open Graph & Twitter Card meta tags
- ✅ Schema.org structured data (RoofingContractor, LocalBusiness, ContactPage)
- ✅ Geo tags for local SEO (`geo.region`, `geo.placename`)
- ✅ Sitemap.xml with 48+ URLs
- ✅ robots.txt with sitemap references
- ✅ Semantic HTML structure

### Performance
- ✅ WebP image format (optimized)
- ✅ Cloudflare CDN with aggressive caching
- ✅ Font preloading with `font-display:swap`
- ✅ `immutable` cache headers on static assets
- ✅ Lazy loading on below-fold images
- ✅ Explicit width/height on all images (CLS protection)
- ✅ Service worker registration
- ✅ Rocket Loader (Cloudflare optimization)

### Accessibility
- ✅ ARIA labels throughout
- ✅ Skip-to-content link
- ✅ `prefers-reduced-motion` support
- ✅ Semantic HTML (`<nav>`, `<main>`, `<section>`, `<footer>`)

---

## 🔧 Recommended Optimizations

### 1. Sitemap Enhancement ⚡ Quick Win

**Current:** Basic `<url>` elements without priority or changefreq

**Recommended:** Add priority and changefreq to critical pages:

```xml
<url>
  <loc>https://riseabovethe.rest/</loc>
  <lastmod>2026-07-06</lastmod>
  <changefreq>weekly</changefreq>
  <priority>1.0</priority>
</url>
<url>
  <loc>https://riseabovethe.rest/contact-double-r-roofing</loc>
  <lastmod>2026-07-06</lastmod>
  <changefreq>monthly</changefreq>
  <priority>0.9</priority>
</url>
```

### 2. Add FAQPage Structured Data

The homepage has FAQ content but no structured data. Add this to enable FAQ rich results:

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Are estimates really free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes — no cost, no obligation, no pressure. We assess your roof and hand you a clear, itemized quote."
      }
    },
    {
      "@type": "Question", 
      "name": "Do you handle storm damage insurance claims?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Absolutely. We respond 24/7, document all damage thoroughly, and work directly with your adjuster."
      }
    }
  ]
}
```

### 3. Responsive Images with srcset

Add `srcset` for responsive images to serve appropriately sized images:

```html
<img 
  src="/images/Double_R_Roofing_completion_image-400.webp"
  srcset="
    /images/Double_R_Roofing_completion_image-400.webp 400w,
    /images/Double_R_Roofing_completion_image-800.webp 800w,
    /images/Double_R_Roofing_completion_image-1200.webp 1200w
  "
  sizes="(max-width: 600px) 400px, (max-width: 1200px) 800px, 1200px"
  alt="Completed roof installation"
  width="1200"
  height="800"
>
```

### 4. Security Headers Optimization

**Current HSTS:** `max-age=0` (resets on every visit)

**Recommended:**
```
strict-transport-security: max-age=31536000; includeSubDomains; preload
```

This tells browsers to always use HTTPS for the next year, improving:
- Security
- Performance (no HTTP fallback)
- SEO (HTTPS is a ranking factor)

### 5. Robots.txt AI Bot Policy Review

**Current:** Blocks ClaudeBot, GPTBot, Google-Extended, and 7+ other AI bots

**Consideration:** AI-powered search (Google AI Overviews, Bing Chat, Perplexity) may increasingly drive traffic. Options:

1. **Allow AI bots** for maximum visibility in AI search results
2. **Use robots meta tags** on specific pages instead of blanket blocking
3. **Monitor and adjust** based on traffic data

```robots.txt
# Alternative: Allow AI bots but restrict training
User-agent: GPTBot
Allow: /
Disallow: /cdn-cgi/

User-agent: Claude-Web
Allow: /
```

### 6. Missing: Breadcrumbs on Homepage

The contact page has breadcrumb structured data but the homepage doesn't. Add visible breadcrumbs:

```html
<nav aria-label="Breadcrumb">
  <ol>
    <li><a href="/">Home</a></li>
    <li aria-current="page">Roofing Services</li>
  </ol>
</nav>
```

### 7. Performance Monitoring

Consider adding:
- Cloudflare Web Analytics (privacy-friendly)
- Real User Monitoring (RUM)
- Core Web Vitals tracking in Search Console

---

## 📊 Quick Wins Priority

| Priority | Task | Impact | Effort |
|----------|------|--------|--------|
| 🔴 High | Sitemap priority tags | ⭐⭐⭐ | 30 min |
| 🔴 High | FAQPage schema | ⭐⭐⭐ | 1 hour |
| 🟡 Medium | srcset for hero image | ⭐⭐ | 1 hour |
| 🟡 Medium | HSTS max-age increase | ⭐⭐ | 5 min |
| 🟡 Medium | Robots.txt review | ⭐ | 30 min |
| 🟢 Low | Breadcrumbs on homepage | ⭐ | 30 min |

---

## 🚀 Performance Summary

**Lighthouse Estimated Scores:**
- Performance: 85-90 (Cloudflare CDN + Rocket Loader)
- Accessibility: 95-98 (strong ARIA, semantic HTML)
- Best Practices: 90-95
- SEO: 92-95

**Core Web Vitals Estimates:**
- LCP: ~1.8s (hero image is optimized)
- FID/INP: ~50ms (minimal JS blocking)
- CLS: ~0.05 (explicit dimensions on all images)

---

## 📁 Files to Modify

Based on analysis, these are the files that would need updates:

1. `/sitemap.xml` - Add priority/changefreq
2. `index.html` - Add FAQPage schema, srcset
3. `robots.txt` - Optional AI bot policy update
4. Server config (Cloudflare) - HSTS headers

---

*Generated by OpenHands SEO Analysis*
