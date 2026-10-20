/**
 * KUBERNETES & GITOPS ELI5 - INTERACTIVE WEB APP
 */

document.addEventListener('DOMContentLoaded', () => {
  let appData = null;
  let activeLessonNum = 1;
  let currentLang = 'split'; // 'split', 'tr', 'en'
  let flatLessons = [];

  const moduleAccordion = document.getElementById('moduleAccordion');
  const mainContent = document.getElementById('mainContent');
  const searchInput = document.getElementById('searchInput');
  const lessonCounterBadge = document.getElementById('lessonCounterBadge');
  const pdfModal = document.getElementById('pdfModal');
  const btnOpenPdfModal = document.getElementById('btnOpenPdfModal');
  const btnClosePdfModal = document.getElementById('btnClosePdfModal');
  const modalModulePdfList = document.getElementById('modalModulePdfList');
  const langButtons = document.querySelectorAll('.lang-btn');
  const themeToggleBtn = document.getElementById('themeToggleBtn');

  // Theme Management (Defaults to Light Mode)
  function initTheme() {
    const savedTheme = localStorage.getItem('k8s_theme') || 'light';
    applyTheme(savedTheme);

    if (themeToggleBtn) {
      themeToggleBtn.addEventListener('click', () => {
        const isDark = document.body.classList.contains('theme-dark');
        applyTheme(isDark ? 'light' : 'dark');
      });
    }
  }

  function applyTheme(theme) {
    if (theme === 'dark') {
      document.body.classList.add('theme-dark');
      if (themeToggleBtn) themeToggleBtn.textContent = '🌙 Koyu';
    } else {
      document.body.classList.remove('theme-dark');
      if (themeToggleBtn) themeToggleBtn.textContent = '☀️ Açık';
    }
    localStorage.setItem('k8s_theme', theme);
  }

  initTheme();

  // Module Icons
  const moduleIcons = {
    1: '🐳',
    2: '☸️',
    3: '🔄',
    4: '🌐',
    5: '🛡️',
    6: '📟',
    7: '🔴',
    8: '🤖',
    9: '⚡',
    10: '🚀'
  };

  // 1. Initialize Curriculum Data (Supports both file:// protocol via lessons.js and http:// via fetch)
  function initData(data) {
    appData = data;
    flatLessons = [];
    data.modules.forEach(m => {
      m.lessons.forEach(l => {
        flatLessons.push({ ...l, module: m });
      });
    });

    renderSidebar();
    renderActiveLesson();
    renderPdfModalContent();
  }

  if (window.LESSONS_DATA) {
    initData(window.LESSONS_DATA);
  } else {
    fetch('data/lessons.json')
      .then(res => res.json())
      .then(data => initData(data))
      .catch(err => {
        console.error('Failed to load lessons.json:', err);
        mainContent.innerHTML = `<div style="color: #ef4444; padding: 2rem;">Veri yüklenemedi: ${err.message}</div>`;
      });
  }

  // 2. Render Sidebar
  function renderSidebar() {
    moduleAccordion.innerHTML = '';
    appData.modules.forEach(m => {
      const isCurrentModule = m.lessons.some(l => l.num === activeLessonNum);
      const groupEl = document.createElement('li');
      groupEl.className = `module-group ${isCurrentModule ? 'open' : ''}`;
      groupEl.dataset.moduleId = m.id;

      const icon = moduleIcons[m.id] || '📦';

      groupEl.innerHTML = `
        <div class="module-header ${isCurrentModule ? 'active' : ''}">
          <div class="module-info">
            <span class="module-badge">${icon}</span>
            <div class="module-texts">
              <span class="module-num">Bölüm ${m.id}</span>
              <span class="module-name">${m.title_tr}</span>
            </div>
          </div>
          <span class="module-chevron">▶</span>
        </div>
        <ul class="lesson-list">
          ${m.lessons.map(l => `
            <li class="lesson-item ${l.num === activeLessonNum ? 'active' : ''}" data-num="${l.num}">
              <span>Ders ${l.num}: ${l.title_tr.split('—')[0].replace(/“|”|"/g, '')}</span>
            </li>
          `).join('')}
        </ul>
      `;

      // Toggle accordion
      const headerEl = groupEl.querySelector('.module-header');
      headerEl.addEventListener('click', () => {
        groupEl.classList.toggle('open');
      });

      // Click lesson
      groupEl.querySelectorAll('.lesson-item').forEach(item => {
        item.addEventListener('click', (e) => {
          e.stopPropagation();
          const targetNum = parseInt(item.dataset.num, 10);
          switchLesson(targetNum);
        });
      });

      moduleAccordion.appendChild(groupEl);
    });
  }

  // 3. Switch Lesson
  function switchLesson(num) {
    if (num < 1 || num > 60) return;
    activeLessonNum = num;

    // Update active class in sidebar
    document.querySelectorAll('.lesson-item').forEach(item => {
      const itemNum = parseInt(item.dataset.num, 10);
      item.classList.toggle('active', itemNum === activeLessonNum);
    });

    // Make sure active module is open
    const targetItem = document.querySelector(`.lesson-item[data-num="${activeLessonNum}"]`);
    if (targetItem) {
      const parentGroup = targetItem.closest('.module-group');
      if (parentGroup && !parentGroup.classList.contains('open')) {
        parentGroup.classList.add('open');
      }
    }

    renderActiveLesson();
    mainContent.scrollTo({ top: 0, behavior: 'smooth' });
  }

  // 4. Render Active Lesson
  function renderActiveLesson() {
    const item = flatLessons.find(x => x.num === activeLessonNum);
    if (!item) return;

    lessonCounterBadge.textContent = `Ders ${item.num} / 60`;

    const padNum = String(item.num).padStart(2, '0');
    const lessonPdfUrl = `../output/individual/lesson_${padNum}.pdf`;
    const modPadNum = String(item.module.id).padStart(2, '0');
    const modulePdfUrl = `../output/modules/module_${modPadNum}_${item.module.dir}.pdf`;

    const icon = moduleIcons[item.module.id] || '☸️';

    // Build Dual / Single Column HTML
    const showTr = currentLang === 'split' || currentLang === 'tr';
    const showEn = currentLang === 'split' || currentLang === 'en';

    function buildDualBlock(trContent, enContent, trTitle, enTitle) {
      if (currentLang === 'tr') {
        return `<div class="dual-col">${trContent}</div>`;
      }
      if (currentLang === 'en') {
        return `<div class="dual-col">${enContent}</div>`;
      }
      return `
        <div class="dual-content">
          <div class="dual-col">
            <div style="font-size:0.75rem; font-weight:700; color:var(--accent-blue); margin-bottom:4px;">🇹🇷 TÜRKÇE</div>
            ${trContent}
          </div>
          <div class="dual-col col-en">
            <div style="font-size:0.75rem; font-weight:700; color:var(--accent-cyan); margin-bottom:4px;">🇬🇧 ENGLISH</div>
            ${enContent}
          </div>
        </div>
      `;
    }

    // Takeaways render
    const takeawaysHtml = item.takeaways.map(t => {
      if (currentLang === 'tr') {
        return `<div class="takeaway-row"><div class="takeaway-tr">• ${t[0]}</div></div>`;
      }
      if (currentLang === 'en') {
        return `<div class="takeaway-row"><div class="takeaway-en" style="border:none; padding:0;">• ${t[1]}</div></div>`;
      }
      return `
        <div class="takeaway-row">
          <div class="takeaway-tr">• ${t[0]}</div>
          <div class="takeaway-en">• ${t[1]}</div>
        </div>
      `;
    }).join('');

    mainContent.innerHTML = `
      <!-- Banner -->
      <div class="lesson-banner">
        <div class="banner-meta">
          <span class="banner-tag">${icon} BÖLÜM ${item.module.id}: ${item.module.title_tr.toUpperCase()}</span>
          <span style="color:var(--text-muted); font-size:0.85rem;">•</span>
          <span style="color:var(--accent-cyan); font-weight:600; font-size:0.85rem;">Ders #${item.num}</span>
        </div>
        <h1 class="banner-title-tr">${item.title_tr}</h1>
        <h2 class="banner-title-en">${item.title_en}</h2>

        <div class="banner-actions">
          <a href="${lessonPdfUrl}" target="_blank" class="btn-primary">
            📄 Bu Dersin PDF'ini Aç (Ders ${item.num})
          </a>
          <a href="${modulePdfUrl}" target="_blank" class="btn-secondary">
            📁 Bu Bölümün Paket PDF'i (Bölüm ${item.module.id})
          </a>
        </div>
      </div>

      <!-- 1. ELI5 Card -->
      <div class="section-card card-eli5">
        <div class="card-header">
          <div class="card-title-tr">💡 Aptala Anlatım (ELI5 Metaforu)</div>
          <div class="card-title-en">💡 ELI5 Metaphor</div>
        </div>
        ${buildDualBlock(item.eli5_tr, item.eli5_en)}
      </div>

      <!-- 2. Technical Deep Dive Card -->
      <div class="section-card card-deep">
        <div class="card-header">
          <div class="card-title-tr">🔍 Derinlemesine Teknik Röntgen</div>
          <div class="card-title-en">🔍 Technical Deep-Dive</div>
        </div>
        ${buildDualBlock(item.deep_tr, item.deep_en)}
      </div>

      <!-- 3. Spring Boot in Action Card -->
      <div class="section-card card-spring">
        <div class="card-header">
          <div class="card-title-tr">☕ Java Spring Boot & K8s Pratiği</div>
          <div class="card-title-en">☕ Spring Boot in Action</div>
        </div>
        <div class="code-box">
          <div class="code-header">
            <span class="code-lang-badge">manifest / code</span>
            <button class="btn-copy" id="btnCopyCode">📋 Kodu Kopyala</button>
          </div>
          <pre><code id="codeBlock">${escapeHtml(item.spring_code)}</code></pre>
        </div>
      </div>

      <!-- 4. Warning / Gotcha Card -->
      <div class="section-card card-warning">
        <div class="card-header">
          <div class="card-title-tr">⚠️ Acemi Tuzağı & Pro İpucu</div>
          <div class="card-title-en">⚠️ Gotchas & Battle-Tested SRE Tips</div>
        </div>
        ${buildDualBlock(item.warning_tr, item.warning_en)}
      </div>

      <!-- 5. Key Takeaways Card -->
      <div class="section-card card-takeaways">
        <div class="card-header">
          <div class="card-title-tr">🎯 Özet Çıkarımlar</div>
          <div class="card-title-en">🎯 Key Takeaways Checklist</div>
        </div>
        <div class="takeaways-grid">
          ${takeawaysHtml}
        </div>
      </div>

      <!-- Bottom Pagination Controls -->
      <div class="bottom-pagination">
        <button id="btnPrevLesson" class="btn-secondary" ${item.num === 1 ? 'disabled style="opacity:0.4;cursor:not-allowed;"' : ''}>
          ⬅️ Önceki: Ders ${item.num > 1 ? item.num - 1 : 1}
        </button>
        <span style="font-size:0.9rem; color:var(--text-muted); font-weight:600;">
          ${item.num} / 60
        </span>
        <button id="btnNextLesson" class="btn-primary" ${item.num === 60 ? 'disabled style="opacity:0.4;cursor:not-allowed;"' : ''}>
          Sonraki: Ders ${item.num < 60 ? item.num + 1 : 60} ➡️
        </button>
      </div>
    `;

    // Attach listeners
    document.getElementById('btnPrevLesson').addEventListener('click', () => switchLesson(activeLessonNum - 1));
    document.getElementById('btnNextLesson').addEventListener('click', () => switchLesson(activeLessonNum + 1));

    document.getElementById('btnCopyCode').addEventListener('click', () => {
      navigator.clipboard.writeText(item.spring_code).then(() => {
        const btn = document.getElementById('btnCopyCode');
        btn.textContent = '✔ Kopyalandı!';
        setTimeout(() => { btn.textContent = '📋 Kodu Kopyala'; }, 2000);
      });
    });
  }

  // 5. Render PDF Modal Content
  function renderPdfModalContent() {
    modalModulePdfList.innerHTML = appData.modules.map(m => {
      const padNum = String(m.id).padStart(2, '0');
      const pdfPath = `../output/modules/module_${padNum}_${m.dir}.pdf`;
      const icon = moduleIcons[m.id] || '📁';
      return `
        <div class="pdf-item">
          <div>
            <div style="font-weight: 700; color: white;">${icon} Bölüm ${m.id}: ${m.title_tr}</div>
            <div style="font-size: 0.8rem; color: var(--text-secondary);">${m.title_en} (6 Ders)</div>
          </div>
          <a href="${pdfPath}" target="_blank" class="btn-secondary" style="font-size: 0.8rem; padding: 4px 10px;">
            ⬇️ PDF Aç
          </a>
        </div>
      `;
    }).join('');
  }

  // 6. Language Switcher Buttons
  langButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      langButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentLang = btn.dataset.lang;
      renderActiveLesson();
    });
  });

  // 7. Modal Handlers
  btnOpenPdfModal.addEventListener('click', () => {
    pdfModal.classList.add('open');
  });

  btnClosePdfModal.addEventListener('click', () => {
    pdfModal.classList.remove('open');
  });

  pdfModal.addEventListener('click', (e) => {
    if (e.target === pdfModal) pdfModal.classList.remove('open');
  });

  // 8. Live Search
  searchInput.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase().trim();
    if (!query) {
      document.querySelectorAll('.lesson-item').forEach(item => item.style.display = 'flex');
      return;
    }

    flatLessons.forEach(l => {
      const match = 
        l.title_tr.toLowerCase().includes(query) ||
        l.title_en.toLowerCase().includes(query) ||
        l.eli5_tr.toLowerCase().includes(query) ||
        l.deep_tr.toLowerCase().includes(query) ||
        l.spring_code.toLowerCase().includes(query);

      const el = document.querySelector(`.lesson-item[data-num="${l.num}"]`);
      if (el) {
        el.style.display = match ? 'flex' : 'none';
        if (match) {
          const parentGroup = el.closest('.module-group');
          if (parentGroup && !parentGroup.classList.contains('open')) {
            parentGroup.classList.add('open');
          }
        }
      }
    });
  });

  // 9. Keyboard Shortcuts
  window.addEventListener('keydown', (e) => {
    if (e.target.tagName === 'INPUT') return;
    if (e.key === 'ArrowRight') switchLesson(activeLessonNum + 1);
    if (e.key === 'ArrowLeft') switchLesson(activeLessonNum - 1);
    if (e.key === '/' || e.key === 'k') {
      e.preventDefault();
      searchInput.focus();
    }
  });

  function escapeHtml(str) {
    return str
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
});
