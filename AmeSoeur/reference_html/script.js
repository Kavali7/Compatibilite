/*
 * Simple client-side logic for the Astroline clone.
 * This file contains small helpers to support element
 * selection and interactive flourishes (like animating
 * the forecast accuracy gauge). It does not communicate
 * with any backend and serves only as a UX enhancement.
 */

// Highlight selected options on click
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.option-list').forEach(list => {
    list.addEventListener('click', (event) => {
      const target = event.target.closest('.option');
      if (!target) return;
      // deselect siblings
      list.querySelectorAll('.option').forEach(opt => {
        opt.classList.remove('selected');
      });
      target.classList.add('selected');
    });
  });

  // Animate gauges where present
  const gauge = document.querySelector('.gauge');
  const fill = document.querySelector('.gauge .fill');
  const gaugeValue = gauge?.dataset.value;
  if (gauge && fill && gaugeValue) {
    // show value text
    gauge.querySelector('span').innerText = gaugeValue + '%';
    // animate fill height after slight delay
    setTimeout(() => {
      fill.style.height = gaugeValue + '%';
    }, 300);
  }
});