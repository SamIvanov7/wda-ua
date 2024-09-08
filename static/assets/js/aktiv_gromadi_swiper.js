document.addEventListener('DOMContentLoaded', function() {
    new Swiper('#aktiv-gromadi .swiper-container', {
      slidesPerView: 1,
      spaceBetween: 30,
      speed: 1000,
      loop: true,
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });
  });