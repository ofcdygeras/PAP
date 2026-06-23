/* ===========================
   SCROLL REVEAL
=========================== */
const revealEls = document.querySelectorAll('.reveal');

const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, { threshold: 0.12 });

revealEls.forEach(el => revealObserver.observe(el));

// Also trigger hero reveals on load
window.addEventListener('load', () => {
  document.querySelectorAll('.hero .reveal').forEach(el => {
    el.classList.add('visible');
  });
});

/* ===========================
   HEADER SCROLL BEHAVIOR
=========================== */
const header = document.querySelector('#header');

window.addEventListener('scroll', () => {
  if (window.scrollY > 60) {
    header.classList.add('scrolled');
  } else {
    header.classList.remove('scrolled');
  }
}, { passive: true });

/* ===========================
   MOUSE GLOW ON CARDS
=========================== */
const glowCards = document.querySelectorAll('.feature-card, .club-card');

glowCards.forEach(card => {
  card.addEventListener('mousemove', (e) => {
    const rect = card.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    card.style.background = `radial-gradient(circle at ${x}px ${y}px, rgba(180,255,0,0.07), rgba(255,255,255,0.03) 60%, transparent)`;
  });

  card.addEventListener('mouseleave', () => {
    card.style.background = '';
  });
});

/* ===========================
   ANIMATED STAT COUNTERS
=========================== */
const statNums = document.querySelectorAll('.stat-num');

const countUp = (el) => {
  const text = el.textContent;
  const num = parseInt(text);
  const suffix = text.replace(num, '');
  let current = 0;
  const duration = 1500;
  const step = num / (duration / 16);

  const timer = setInterval(() => {
    current = Math.min(current + step, num);
    el.textContent = Math.floor(current) + suffix;
    if (current >= num) clearInterval(timer);
  }, 16);
};

const statsObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      countUp(entry.target);
      statsObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.5 });

statNums.forEach(el => statsObserver.observe(el));

/* ===========================
   SMOOTH ANCHOR SCROLL
=========================== */
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', (e) => {
    const href = anchor.getAttribute('href');
    if (href === '#') return;
    const target = document.querySelector(href);
    if (target) {
      e.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });
});
