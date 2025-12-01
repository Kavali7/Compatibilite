/*
 * Lightweight JavaScript helpers for the Astrocartography clone.
 *
 * This script powers the step6 carousel, simple option selection
 * highlighting and any other interactive behaviours needed by
 * the static pages. Because the clone is entirely client side,
 * there are no network requests or form submissions – the
 * interaction is limited to toggling classes to reflect state.
 */

document.addEventListener('DOMContentLoaded', () => {
  // Handle option clicks – add .active class on click
  document.querySelectorAll('.option').forEach(opt => {
    opt.addEventListener('click', () => {
      // for multi‑choice screens (goals) allow multiple active
      const parent = opt.parentElement;
      const multi = parent.dataset.multi === 'true';
      if (!multi) {
        parent.querySelectorAll('.option').forEach(o => o.classList.remove('active'));
      }
      opt.classList.toggle('active');
    });
  });

  // Step6 slides: cycle through messages when next button clicked
  const nextButton = document.getElementById('nextSlide');
  if (nextButton) {
    const slides = Array.from(document.querySelectorAll('.slide'));
    let current = 0;
    function showSlide(index) {
      slides.forEach((slide, i) => {
        slide.classList.toggle('active', i === index);
      });
    }
    showSlide(current);
    nextButton.addEventListener('click', () => {
      current = (current + 1) % slides.length;
      showSlide(current);
    });
  }
});
