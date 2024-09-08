(function() {
  "use strict";

  const select = (el, all = false) => {
    el = el.trim()
    return all ? [...document.querySelectorAll(el)] : document.querySelector(el)
  }

  const on = (type, el, listener, all = false) => {
    let selectEl = select(el, all)
    if (selectEl) {
      if (all) {
        selectEl.forEach(e => e.addEventListener(type, listener))
      } else {
        selectEl.addEventListener(type, listener)
      }
    }
  }
/**
 * Aktiv Gromadi Swiper and filter
 */
window.addEventListener('load', () => {
  // Initialize Swiper
  const aktivGromadiSwiper = new Swiper('#aktiv-gromadi .swiper-container', {
    slidesPerView: 1,
    spaceBetween: 30,
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
  });

  // Filter functionality
  let aktivGromadiFilters = document.querySelectorAll('#aktiv-gromadi-flters li');

  aktivGromadiFilters.forEach(filter => {
    filter.addEventListener('click', function(e) {
      e.preventDefault();
      aktivGromadiFilters.forEach(el => el.classList.remove('filter-active'));
      this.classList.add('filter-active');

      const filterValue = this.getAttribute('data-filter');

      document.querySelectorAll('#aktiv-gromadi .aktiv-gromadi-item').forEach(item => {
        if (filterValue === '*' || item.classList.contains(filterValue.replace('.', ''))) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });

      aktivGromadiSwiper.update();
      aktivGromadiSwiper.slideTo(0);
    });
  });
});

/**
 * Initiate aktiv gromadi lightbox 
 */
const aktivGromadiLightbox = GLightbox({
  selector: '.aktiv-gromadi-lightbox'
});

/**
 * Initiate aktiv gromadi details lightbox 
 */
const aktivGromadiDetailsLightbox = GLightbox({
  selector: '.aktiv-gromadi-details-lightbox',
  width: '90%',
  height: '90vh'
});

/**
 * Animate letters in the title
 */
const animateLetters = () => {
  const title = document.querySelector('.letters');
  if (title) {
    const text = title.textContent;
    const letters = text.split('');
    title.textContent = '';
    letters.forEach((letter, i) => {
      const span = document.createElement('span');
      span.textContent = letter;
      span.className = 'letter';
      span.style.transitionDelay = `${i * 0.1}s`;
      title.appendChild(span);
    });
  }
}

window.addEventListener('load', animateLetters);

})()