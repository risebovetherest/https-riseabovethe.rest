# Self-Hosting Guide: Remove Cloudflare, Speed Up Your VPS

**Why Remove Cloudflare?**
- Your VPS is already fast - Africa to your server might be faster than Africa → Cloudflare → VPS
- Cloudflare adds DNS lookup + TLS handshake + processing overhead
- Complexity: Rocket Loader, challenge iframes, extra JS slowing things down
- For a single site, Cloudflare is overkill

---

## Step 1: Remove Cloudflare (Do This First)

### 1.1 In Cloudflare Dashboard:
1. Go to **SSL/TLS** → Overview → Set to "Off" (temporarily)
2. Go to **DNS** → Set A record to point directly to your VPS IP
3. Change nameservers back to your domain registrar's nameservers
4. Wait 24-48 hours for DNS propagation
5. After confirming direct connection works, **delete the Cloudflare site**

### 1.2 Alternative: Pause Cloudflare
```
Quick test: Cloudflare Dashboard → Overview → "Pause Cloudflare on site"
```
This bypasses Cloudflare temporarily to test your direct connection.

---

## Step 2: Get Free SSL from Let's Encrypt

On your VPS (SSH in), install Certbot:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install certbot python3-certbot-nginx

# CentOS/RHEL
sudo yum install certbot python3-certbot-nginx

# Generate SSL certificate
sudo certbot --nginx -d riseabovethe.rest -d www.riseabovethe.rest
```

Follow the prompts. Certbot auto-renews!

---

## Step 3: Optimized Nginx Config

Replace your `/etc/nginx/sites-available/riseabovethe.rest` with this optimized config:

```nginx
server {
    listen 80;
    server_name riseabovethe.rest www.riseabovethe.rest;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name riseabovethe.rest www.riseabovethe.rest;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/riseabovethe.rest/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/riseabovethe.rest/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/riseabovethe.rest/chain.pem;

    # Modern SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 1.1.1.1 8.8.8.8 valid=300s;
    resolver_timeout 5s;

    # HSTS (1 year - improves security AND performance)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Cache control for static assets
    location ~* \.(css|js|woff2|webp|jpg|jpeg|png|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # HTML - short cache (always check for new content)
    location ~* \.html$ {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml application/xml;
    gzip_min_length 256;

    # Word count limit
    client_max_body_size 10M;

    # Root directory
    root /var/www/riseabovethe.rest;
    index index.html;

    # Main site
    location / {
        try_files $uri $uri/ =404;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }

    # Performance: disable logs for static assets
    location ~* \.(webp|css|js|woff2)$ {
        access_log off;
        log_not_found off;
    }

    # Enable HTTP/2 Server Push for critical resources (optional)
    http2_push_preload on;
}
```

### Test and reload:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## Step 4: Remove Cloudflare Code from Your HTML

Your current HTML has Cloudflare-specific scripts. Remove these from ALL pages:

### ❌ REMOVE these from your HTML `<head>` and `<body>`:

```html
<!-- REMOVE THIS ENTIRE BLOCK FROM END OF BODY -->
<script>
(function(){
  function c(){
    var b=a.contentDocument||a.contentWindow.document;
    if(b){
      var d=b.createElement('script');
      d.innerHTML="window.__CF$cv$params={r:'...'}";
      // Cloudflare challenge code
    }
  }
  // ... Cloudflare tracking code
})();
</script>
<script src="/cdn-cgi/scripts/7d0fa10a/cloudflare-static/rocket-loader.min.js" defer></script>
```

### Also remove from HTML:
```html
<!-- Remove any references to cloudflare -->
<link rel="dns-prefetch" href="//cloudflare.com">
```

### ✅ Replace with clean headers in nginx:
```nginx
# Add to your nginx server block - cleaner headers without Cloudflare
proxy_hide_header cf-ray;
proxy_hide_header cf-cache-status;
proxy_hide_header nel;
proxy_hide_header server;
```

---

## Step 5: Auto-Renew SSL (Cron Job)

```bash
# Certbot auto-renews, but verify it works:
sudo certbot renew --dry-run

# If not, add to crontab:
sudo crontab -e
# Add this line:
0 0 * * * certbot renew --quiet
```

---

## Step 6: Optimize Images (WebP Already Good!)

Your site already uses WebP - nice! Just make sure images are optimized:

```bash
# Install image optimization tools
sudo apt install webp libwebp-tools

# Bulk convert JPG to WebP (if needed)
for f in *.jpg; do cwebp -q 80 "$f" -o "${f%.jpg}.webp"; done

# Optimize existing WebP files
for f in *.webp; do cwebp -s -o "$f" "$f"; done
```

---

## Step 7: Optional - Add Brotli Compression (Even Faster)

```bash
# Install nginx-extras (includes brotli)
sudo apt install nginx-extras

# Add to nginx config:
brotli on;
brotli_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml application/xml;
brotli_comp_level 6;
brotli_min_length 256;
```

---

## Quick Comparison

| Metric | With Cloudflare | Direct to VPS |
|--------|-----------------|---------------|
| DNS Lookup | +20-50ms | 0ms |
| TLS Handshake | +50-100ms | +50-100ms |
| Cloudflare Processing | +10-30ms | 0ms |
| Your VPS Response | ~100-200ms | ~100-200ms |
| **Total** | **180-380ms** | **150-300ms** |

**Winner for single VPS:** Direct connection! 🚀

---

## Troubleshooting

### SSL Certificate Issues:
```bash
# Check certificate status
sudo certbot certificates

# Renew manually
sudo certbot renew
```

### Nginx won't start:
```bash
# Check syntax
sudo nginx -t

# View error logs
sudo tail -f /var/log/nginx/error.log
```

### Test your site:
```bash
# Check headers
curl -I https://riseabovethe.rest

# Should see:
# - Strict-Transport-Security: max-age=31536000
# - No cf-ray, cf-cache-status headers
# - server: nginx/xxx
```

---

## Need Help?

If you can share SSH access to your VPS, I can help you:
1. Check your current nginx config
2. Install Certbot
3. Remove Cloudflare code from your HTML files
4. Test everything works

Just provide the SSH credentials (or use a temporary one for me to help set things up).
