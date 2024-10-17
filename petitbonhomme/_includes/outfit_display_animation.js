function showWheel(outfitStack) {
    const wheel = outfitStack.querySelector('.wheel');
    if (wheel.style.visibility === 'visible') {
        return;
    }
    const wheelItems = outfitStack.querySelectorAll('.outfit-wheel-item-image-wrap');
    const stackItems = outfitStack.querySelectorAll('.outfit-item-image');

    // Show the wheel
    wheel.style.visibility = 'visible';

    wheelItems.forEach((item, index) => {
        item.style.opacity = 1;
    });

    stackItems.forEach((item) => {
        item.style.zIndex = (parseInt(window.getComputedStyle(item).zIndex, 10) || 0) + 20;
    });
}

function hideWheel(outfitStack) {
  const wheel = outfitStack.querySelector('.wheel');
  if (wheel.style.visibility !== 'visible') {
      return;
  }
  const wheelItems = outfitStack.querySelectorAll('.outfit-wheel-item-image-wrap');
  const stackItems = outfitStack.querySelectorAll('.outfit-item-image');

  // Hide the wheel and reset positions
  wheelItems.forEach((item) => {
    item.style.opacity = 0;
  });

  stackItems.forEach((item) => {
      item.style.zIndex = (parseInt(window.getComputedStyle(item).zIndex, 10) || 0) - 20;
  });
  wheel.style.visibility = 'hidden';
}
