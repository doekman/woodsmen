new function() { // closure
  document.addEventListener("DOMContentLoaded", (event) => {
    /*
    const matches = document.querySelectorAll('.horizontal-shift');
    let horizontalShiftElements = []
    matches.forEach( (img) => {
      const imgCurrentStyle = window.getComputedStyle(img);
      if (imgCurrentStyle.objectFit == 'cover') {
        horizontalShiftElements.push(img);
        console.log("Image registered for horizontal shifting", window.innerHeight);
      }
    });
    addEventListener("scroll", (event) => {
      for(const element of horizontalShiftElements) {
        const bounds = element.getBoundingClientRect();
        const xxx = bounds.bottom - window.innerHeight;
        if (xxx > 0) console.info("horizontal %s", xxx, bounds);
        else console.info('Nothing to do')
      }
    });
    */
    console.log("%c _   _           __        __              _                          \n" +
                "| |_| |__   ___  \\ \\      / /__   ___   __| |___ _ __ ___   ___ _ __  \n" +
                "| __| '_ \\ / _ \\  \\ \\ /\\ / / _ \\ / _ \\ / _` / __| '_ ` _ \\ / _ \\ '_ \\ \n" +
                "| |_| | | |  __/   \\ V  V / (_) | (_) | (_| \\__ \\ | | | | |  __/ | | |\n" +
                " \\__|_| |_|\\___|    \\_/\\_/ \\___/ \\___/ \\__,_|___/_| |_| |_|\\___|_| |_|", 'font-family: monospace');
  });
}