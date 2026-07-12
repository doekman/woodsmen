new function() { // closure

    function initializeCarousel() {
      // https://www.slingacademy.com/article/creating-quick-carousels-sliding-through-images-in-javascript/
      const carousel = document.querySelector('.carousel');
      const imgs = document.querySelectorAll('.carousel img');
      const nextButton = document.querySelector('.next');
      const prevButton = document.querySelector('.prev');
      let currentIndex = 0;

      nextButton.addEventListener('click', () => {
        currentIndex = (currentIndex + 1) % imgs.length;
        updateCarousel();
      });

      prevButton.addEventListener('click', () => {
        currentIndex = (currentIndex - 1 + imgs.length) % imgs.length;
        updateCarousel();
      });

      function updateCarousel() {
        carousel.style.transform = 'translateX(' + (-currentIndex * 100) + '%)';
      }
    }
    
    function initializeHorizontalShift() {
      // Not yet generic!
      const matches = document.querySelectorAll('.horizontal-shift');
      let horizontalShiftElements = []
      matches.forEach( (img) => {
        const imgCurrentStyle = window.getComputedStyle(img);
        if (imgCurrentStyle.objectFit == 'cover') {
          horizontalShiftElements.push(img);
          //console.log("Image registered for horizontal shifting", window.innerHeight);
        }
      });
      const maxScrollY = 510;
      const objectPositionStartEnd = [10, 65];
      addEventListener("scroll", (event) => {
        for(const element of horizontalShiftElements) {
          let scrollPercentage = window.scrollY / maxScrollY;
          let objectPositionPct = objectPositionStartEnd[1];
          if (window.scrollY < maxScrollY) {
            objectPositionPct = ((objectPositionStartEnd[1] - objectPositionStartEnd[0]) * scrollPercentage) + objectPositionStartEnd[0];
          }
          else {
            objectPositionPct = objectPositionStartEnd[1]
          }
          //console.info("horizontal %s -- %s", scrollPercentage, objectPositionPct);
          element.style.objectPosition = `${objectPositionPct}%`;
        }
      });
    }

  document.addEventListener("DOMContentLoaded", (event) => {
    initializeHorizontalShift();
    initializeCarousel();
    console.log("%c _   _           __        __              _                          \n" +
                "| |_| |__   ___  \\ \\      / /__   ___   __| |___ _ __ ___   ___ _ __  \n" +
                "| __| '_ \\ / _ \\  \\ \\ /\\ / / _ \\ / _ \\ / _` / __| '_ ` _ \\ / _ \\ '_ \\ \n" +
                "| |_| | | |  __/   \\ V  V / (_) | (_) | (_| \\__ \\ | | | | |  __/ | | |\n" +
                " \\__|_| |_|\\___|    \\_/\\_/ \\___/ \\___/ \\__,_|___/_| |_| |_|\\___|_| |_|", 'font-family: monospace; text-wrap:nowrap');
  });
}