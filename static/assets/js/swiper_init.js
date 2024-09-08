document.addEventListener('DOMContentLoaded', function() {
    const swiper = new Swiper('.swiper', {
      mousewheel: true,
      direction: 'vertical',
      speed: 1700,
      parallax: true
    });
  
    swiper.on('slideChange', function() {
      document.querySelectorAll('.header-content__slide').forEach(function(e, i) {
        return swiper.activeIndex === i ? e.classList.add('active') : e.classList.remove('active');
      });
    });
  
    function navigateToSlide(slideIndex, buttonId) {
      const button = document.getElementById(buttonId);
      button?.addEventListener('click', (e) => {
        e.preventDefault();
        console.log(`${buttonId} clicked`);
        swiper.slideTo(slideIndex, 1900);
        console.log(`Moving to slide ${slideIndex + 1}`);
      });
    }
  
    navigateToSlide(1, 'learn-more-btn');
    navigateToSlide(1, 'about-us');
    navigateToSlide(2, 'events-btn');
    navigateToSlide(2, 'kalender-btn');
    navigateToSlide(3, 'kontakt-btn');
  
    swiper.on('slideChangeTransitionStart', function() {
      const activeSlide = document.querySelectorAll('.header-content__slide')[swiper.activeIndex];
      if (activeSlide) {
        activeSlide.classList.add('slide-enter-animation');
        setTimeout(() => {
          activeSlide.classList.remove('slide-enter-animation');
        }, 1900);
      }
    });
  
    swiper.on('slideChangeTransitionEnd', function () {
      swiper.allowTouchMove = true;
    });
  });