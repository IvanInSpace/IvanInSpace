let allImages = [];
let hqOnly = false;

function filenameFromUrl(url) {
  try {
    const pathname = new URL(url).pathname;
    const name = pathname.split('/').pop().split('?')[0] || 'image';
    // ensure extension
    if (!/\.\w{2,5}$/.test(name)) return name + '.jpg';
    return name;
  } catch {
    return 'image.jpg';
  }
}

function formatSize(w, h) {
  if (w && h) return `${w}×${h}`;
  return '';
}

function downloadImage(url, cardEl) {
  const btn = cardEl.querySelector('.dl-btn');
  btn.textContent = '...';
  chrome.runtime.sendMessage(
    { type: 'DOWNLOAD_IMAGE', url, filename: filenameFromUrl(url) },
    response => {
      if (response && response.success) {
        btn.textContent = '✓ Saved';
        btn.classList.add('downloaded');
      } else {
        btn.textContent = 'Error';
        setTimeout(() => { btn.innerHTML = '↓ Download'; btn.classList.remove('downloaded'); }, 2000);
      }
    }
  );
}

function renderImages(images) {
  const grid = document.getElementById('grid');
  const empty = document.getElementById('empty');
  const count = document.getElementById('count');

  grid.innerHTML = '';

  if (!images.length) {
    empty.style.display = 'flex';
    grid.style.display = 'none';
    count.textContent = '0 images';
    return;
  }

  empty.style.display = 'none';
  grid.style.display = 'grid';
  count.textContent = `${images.length} image${images.length !== 1 ? 's' : ''}`;

  images.forEach(img => {
    const card = document.createElement('div');
    card.className = 'img-card';
    card.dataset.hqUrl = img.hqUrl;

    const isHq = img.hqUrl !== img.thumbUrl;
    const sizeLabel = formatSize(img.width, img.height);

    card.innerHTML = `
      <div class="img-thumb">
        <img src="${img.thumbUrl}" loading="lazy" alt="${img.alt}"
          onerror="this.style.opacity='0.2'"/>
        ${isHq ? '<span class="hq-badge">HQ</span>' : ''}
        ${sizeLabel ? `<span class="img-size">${sizeLabel}</span>` : ''}
      </div>
      <div class="img-actions">
        <button class="dl-btn">⬇ Download</button>
        <button class="open-btn">Open</button>
      </div>
    `;

    card.querySelector('.dl-btn').addEventListener('click', () => {
      downloadImage(img.hqUrl, card);
    });

    card.querySelector('.open-btn').addEventListener('click', () => {
      chrome.tabs.create({ url: img.hqUrl, active: false });
    });

    grid.appendChild(card);
  });
}

function loadImages() {
  const loading = document.getElementById('loading');
  const grid = document.getElementById('grid');
  loading.style.display = 'flex';
  grid.style.display = 'none';

  chrome.tabs.query({ active: true, currentWindow: true }, tabs => {
    const tab = tabs[0];
    if (!tab) return;

    chrome.tabs.sendMessage(tab.id, { type: 'GET_IMAGES' }, response => {
      loading.style.display = 'none';
      if (chrome.runtime.lastError || !response) {
        // Content script not ready — try injecting it
        chrome.scripting.executeScript(
          { target: { tabId: tab.id }, files: ['content.js'] },
          () => {
            setTimeout(() => {
              chrome.tabs.sendMessage(tab.id, { type: 'GET_IMAGES' }, response2 => {
                allImages = (response2 && response2.images) || [];
                renderImages(allImages);
              });
            }, 300);
          }
        );
        return;
      }
      allImages = response.images || [];
      renderImages(allImages);
    });
  });
}

function isHqImage(img) {
  return img.hqUrl !== img.thumbUrl || (img.width >= 800) || (img.height >= 800);
}

function applyFilters() {
  const query = document.getElementById('search').value.toLowerCase();
  let filtered = allImages;
  if (hqOnly) filtered = filtered.filter(isHqImage);
  if (query) filtered = filtered.filter(img =>
    img.hqUrl.toLowerCase().includes(query) || img.alt.toLowerCase().includes(query)
  );
  renderImages(filtered);
}

// HQ only toggle
document.getElementById('hq-only-btn').addEventListener('click', e => {
  hqOnly = !hqOnly;
  e.currentTarget.classList.toggle('active', hqOnly);
  applyFilters();
});

// Search/filter
document.getElementById('search').addEventListener('input', applyFilters);

// Refresh
document.getElementById('refresh-btn').addEventListener('click', loadImages);

// Download all visible
document.getElementById('download-all-btn').addEventListener('click', () => {
  const cards = document.querySelectorAll('.img-card');
  cards.forEach((card, i) => {
    setTimeout(() => {
      const url = card.dataset.hqUrl;
      downloadImage(url, card);
    }, i * 300); // stagger to avoid overwhelming the browser
  });
});

// Init
loadImages();
