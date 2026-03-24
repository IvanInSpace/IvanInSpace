// Content script: scans the page for all images and finds highest quality URLs

const CDN_PATTERNS = [
  // Cloudinary: /upload/c_fill,w_300,h_200/
  { regex: /\/upload\/[^/]+\//, replacement: '/upload/' },
  // imgix / general query params for resizing
  { regex: /[?&](w|h|width|height|size|q|quality|fit|crop|auto|fm|format)=[^&]*/gi, replacement: '' },
  // WordPress thumbnail suffix: -300x200.jpg
  { regex: /-\d+x\d+(\.\w+)$/, replacement: '$1' },
  // Contentful image API
  { regex: /\?w=\d+(&.*)?$/, replacement: '' },
  // Shopify image size suffix: _300x200.jpg
  { regex: /_\d+x\d*(\.\w+)$/, replacement: '$1' },
];

function cleanUrl(url) {
  if (!url || url.startsWith('data:')) return url;
  let cleaned = url;
  for (const pattern of CDN_PATTERNS) {
    cleaned = cleaned.replace(pattern.regex, pattern.replacement);
  }
  // Remove trailing ? or &
  cleaned = cleaned.replace(/[?&]+$/, '');
  return cleaned;
}

function pickBestFromSrcset(srcset) {
  if (!srcset) return null;
  const entries = srcset.split(',').map(s => s.trim()).filter(Boolean);
  let best = null;
  let bestWidth = 0;
  for (const entry of entries) {
    const parts = entry.split(/\s+/);
    const url = parts[0];
    const descriptor = parts[1] || '';
    const width = descriptor.endsWith('w')
      ? parseInt(descriptor)
      : descriptor.endsWith('x')
        ? parseFloat(descriptor) * 1000
        : 1;
    if (width > bestWidth) {
      bestWidth = width;
      best = url;
    }
  }
  return best;
}

function extractBackgroundUrl(cssValue) {
  const match = cssValue && cssValue.match(/url\(["']?([^"')]+)["']?\)/);
  return match ? match[1] : null;
}

function isValidImageUrl(url) {
  if (!url) return false;
  if (url.startsWith('data:')) return false;
  if (url.startsWith('blob:')) return true;
  try {
    const u = new URL(url, location.href);
    return u.protocol === 'http:' || u.protocol === 'https:';
  } catch {
    return false;
  }
}

function absoluteUrl(url) {
  try {
    return new URL(url, location.href).href;
  } catch {
    return url;
  }
}

function collectImages() {
  const results = new Map(); // url → {thumbUrl, originalUrl, hqUrl, width, height, alt}

  function add(thumbUrl, hqUrl, width, height, alt) {
    thumbUrl = absoluteUrl(thumbUrl);
    hqUrl = absoluteUrl(hqUrl);
    if (!isValidImageUrl(thumbUrl)) return;
    if (results.has(hqUrl)) return;
    results.set(hqUrl, { thumbUrl, hqUrl, width: width || 0, height: height || 0, alt: alt || '' });
  }

  // 1. <img> tags
  document.querySelectorAll('img').forEach(img => {
    const srcset = img.srcset || img.getAttribute('srcset');
    const bestFromSrcset = srcset ? pickBestFromSrcset(srcset) : null;
    const src = img.currentSrc || img.src;
    const hq = cleanUrl(bestFromSrcset || src);
    if (src) add(src, hq, img.naturalWidth, img.naturalHeight, img.alt);
  });

  // 2. <picture> elements — find source with largest width descriptor
  document.querySelectorAll('picture').forEach(picture => {
    const img = picture.querySelector('img');
    if (!img) return;
    let bestUrl = null;
    let bestWidth = 0;
    picture.querySelectorAll('source').forEach(source => {
      const srcset = source.srcset;
      if (!srcset) return;
      const url = pickBestFromSrcset(srcset);
      const entries = srcset.split(',');
      const widths = entries.map(e => {
        const parts = e.trim().split(/\s+/);
        const d = parts[1] || '';
        return d.endsWith('w') ? parseInt(d) : 0;
      });
      const maxW = Math.max(...widths, 0);
      if (maxW > bestWidth && url) {
        bestWidth = maxW;
        bestUrl = url;
      }
    });
    const src = img.currentSrc || img.src;
    const hq = cleanUrl(bestUrl || src);
    if (src) add(src, hq, img.naturalWidth, img.naturalHeight, img.alt);
  });

  // 3. Elements with CSS background-image
  const allElements = document.querySelectorAll('*');
  allElements.forEach(el => {
    const style = window.getComputedStyle(el);
    const bgUrl = extractBackgroundUrl(style.backgroundImage);
    if (bgUrl && isValidImageUrl(absoluteUrl(bgUrl))) {
      const hq = cleanUrl(bgUrl);
      add(bgUrl, hq, 0, 0, el.getAttribute('aria-label') || el.title || '');
    }
  });

  // 4. <video> poster images
  document.querySelectorAll('video[poster]').forEach(video => {
    const poster = video.getAttribute('poster');
    if (poster) add(poster, cleanUrl(poster), 0, 0, 'video poster');
  });

  return Array.from(results.values());
}

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'GET_IMAGES') {
    sendResponse({ images: collectImages() });
  }
  return true;
});
