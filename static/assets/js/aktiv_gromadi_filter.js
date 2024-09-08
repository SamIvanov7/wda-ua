document.addEventListener('DOMContentLoaded', function () {
  initGLightbox();

  var $grid = $('.flex-container').isotope({
    itemSelector: '.flex-item',
    layoutMode: 'fitRows'
  });

  $('#aktiv-gromadi-flters li').on('click', function () {
    $("#aktiv-gromadi-flters li").removeClass('filter-active');
    $(this).addClass('filter-active');

    var filterValue = $(this).attr('data-filter');
    $grid.isotope({ filter: filterValue });
  });

  document.getElementById('popup').addEventListener('click', function (e) {
    if (e.target === this) {
      this.style.display = 'none';
    }
  });
});

function fetchAktivGromadiDetails(postId) {
  fetch(`/aktiv-gromadi-details-content/${postId}/`)
    .then(response => response.text())
    .then(html => {
      const popupContent = document.getElementById('popup-body');
      popupContent.innerHTML = html;
      showPopup();
      initSwiper();
      attachCloseButtonEvent();
    });
}
function initSwiper() {
  const swiperElement = document.querySelector('.aktiv-gromadi-details-slider');
  if (swiperElement) {
    const swiper = new Swiper(swiperElement, {
      slidesPerView: 1,
      spaceBetween: 30,
      loop: true,
      autoplay: {
        delay: 5000,
        disableOnInteraction: false,
      },
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
        type: 'bullets',
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      keyboard: {
        enabled: true,
      },
      on: {
        init: function () {
          console.log('Swiper initialized');
        },
      },
    });
  }
}

function showPopup() {
  const popup = document.getElementById('popup');
  popup.style.display = 'block';
  popup.style.backgroundColor = 'rgba(8, 20, 10, 0.8)';
}

function attachCloseButtonEvent() {
  const closeButton = document.querySelector('.close');
  if (closeButton) {
    closeButton.addEventListener('click', function () {
      document.getElementById('popup').style.display = 'none';
    });
  }
}

function initGLightbox() {
  const lightbox = GLightbox({
    selector: '.aktiv-gromadi-lightbox'
  });
}
