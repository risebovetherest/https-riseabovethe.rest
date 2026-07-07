# SEO & Speed Code Snippets for riseabovethe.rest

## 1. FAQPage Schema (Add to homepage `<head>`)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Are estimates really free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes — no cost, no obligation, no pressure. We assess your roof and hand you a clear, itemized quote. No surprises."
      }
    },
    {
      "@type": "Question",
      "name": "Do you handle storm damage insurance claims?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Absolutely. We respond 24/7, document all damage thoroughly, and work directly with your adjuster to make the process as painless as possible."
      }
    },
    {
      "@type": "Question",
      "name": "What areas do you serve?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Princeton, Bluefield, Athens, Beckley, and all of Mercer County, WV. If you're unsure, just call — we most likely cover your area."
      }
    },
    {
      "@type": "Question",
      "name": "What's included in the 30-year workmanship warranty?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Our warranty covers installation defects for 30 full years and transfers to new owners if you sell. Owens Corning Preferred status also unlocks enhanced material warranties on qualifying systems."
      }
    },
    {
      "@type": "Question",
      "name": "Are you licensed and insured?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. WV state licensed, $2M general liability, full workers' comp coverage, and bonded for commercial work. We'll provide documentation on request."
      }
    }
  ]
}
</script>
```

## 2. Responsive Image with srcset (Replace hero image)

```html
<picture>
  <source 
    type="image/webp"
    srcset="
      /images/Double_R_Roofing_completion_image-400.webp 400w,
      /images/Double_R_Roofing_completion_image-800.webp 800w,
      /images/Double_R_Roofing_completion_image-1200.webp 1200w,
      /images/Double_R_Roofing_completion_image-1600.webp 1600w
    "
    sizes="100vw"
  >
  <img 
    src="/images/Double_R_Roofing_completion_image-1200.webp"
    alt="Completed architectural shingle roof installation in Princeton, WV"
    width="1200"
    height="800"
    fetchpriority="high"
    decoding="async"
  >
</picture>
```

## 3. HowTo Schema for Service Pages

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Get Your Free Roof Estimate",
  "description": "Simple steps to get a free roof inspection from Double R Roofing",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Contact Us",
      "text": "Call (304) 716-5744 or fill out our online form"
    },
    {
      "@type": "HowToStep", 
      "name": "Schedule Inspection",
      "text": "We'll schedule a convenient time to inspect your roof"
    },
    {
      "@type": "HowToStep",
      "name": "Receive Quote",
      "text": "Get a detailed, itemized estimate with no obligation"
    }
  ]
}
</script>
```

## 4. Breadcrumb Navigation HTML + Schema

```html
<!-- Visual Breadcrumb -->
<nav aria-label="Breadcrumb" class="breadcrumb">
  <ol>
    <li><a href="/">Home</a></li>
    <li aria-current="page">Roofing Services</li>
  </ol>
</nav>

<!-- Schema.org BreadcrumbList -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://riseabovethe.rest"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Services",
      "item": "https://riseabovethe.rest/roofing-services-princeton-wv"
    }
  ]
}
</script>
```

## 5. Review/ReviewAggregate Schema (Add to homepage)

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "RoofingContractor",
  "@id": "https://riseabovethe.rest/#business",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "5.0",
    "reviewCount": "127",
    "bestRating": "5",
    "worstRating": "1"
  }
}
</script>
```

## 6. Performance: Preconnect to External Domains

Add to `<head>` for external resources:

```html
<!-- Google Fonts preconnect -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- Google Maps preconnect (if using maps) -->
<link rel="preconnect" href="https://maps.googleapis.com">
```

## 7. CLS Prevention: Aspect Ratio Boxes

```css
/* For images without intrinsic dimensions */
.hero-bg-wrap {
  aspect-ratio: 16 / 9;
  width: 100%;
  background: var(--bg); /* Fallback color */
}

.hero-bg-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

## 8. Critical CSS Inline (Optional Optimization)

For above-the-fold content, inline critical CSS:

```html
<style>
  /* Critical CSS for hero section */
  .hero-cinematic {
    min-height: 88vh;
    display: flex;
    align-items: flex-end;
  }
  .hero-h1 {
    font-family: 'Rubik Lines', sans-serif;
    font-size: clamp(3rem, 9vw, 7.4rem);
  }
  /* Add other critical styles */
</style>
```

## 9. HSTS Header (Cloudflare/Tech Config)

If you can modify server headers, update Cloudflare:

```
strict-transport-security: max-age=31536000; includeSubDomains; preload
```

Or in Cloudflare Dashboard:
1. Security → Headers → Add Header
2. Select "Strict-Transport-Security"
3. Set max-age to 31536000 (1 year)

## 10. Image Lazy Loading with Intersection Observer (Progressive Enhancement)

```javascript
document.addEventListener('DOMContentLoaded', function() {
  // Native lazy loading fallback for older browsers
  if ('loading' in HTMLImageElement.prototype) {
    // Native lazy loading supported
    const images = document.querySelectorAll('img[loading="lazy"]');
    images.forEach(img => {
      img.src = img.dataset.src;
    });
  } else {
    // Fallback with Intersection Observer
    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          observer.unobserve(img);
        }
      });
    });
    
    document.querySelectorAll('img[data-src]').forEach(img => {
      observer.observe(img);
    });
  }
});
```

---

## Quick Checklist

- [ ] Replace sitemap.xml with `sitemap-optimized.xml`
- [ ] Add FAQPage schema to homepage
- [ ] Add Review aggregate schema to homepage
- [ ] Add srcset to hero image (requires multiple image sizes)
- [ ] Add breadcrumb navigation to main pages
- [ ] Review robots.txt AI bot policy
- [ ] Update HSTS max-age in Cloudflare

---

*Generated by OpenHands SEO Analysis*
