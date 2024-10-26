const outfitStacks = document.querySelectorAll('.outfit-stack');

// Loop through each element and call your function
outfitStacks.forEach((stack) => {
    setupWheel(stack);
});

function setupWheel(outfitStack) {
    const wheelItems = outfitStack.querySelectorAll('.outfit-wheel-item-image-wrap');
    const wheelDiameter = Math.min(window.innerHeight * 0.8, window.innerWidth * 0.8) * 0.7;
    const imgMaxWidth = Math.min(window.innerHeight * 0.12, window.innerWidth * 0.12);
    const imgMaxHeight = Math.min(window.innerHeight * 0.16, window.innerWidth * 0.16);

    // Position the items in a circle around the center of the wheel
    const angleStep = (2 * Math.PI) / wheelItems.length; // Divide the circle by the number of items
    wheelItems.forEach((item, index) => {
        const angle = index * angleStep;
        const x = Math.cos(angle) * wheelDiameter / 2 - imgMaxWidth / 2;
        const y = Math.sin(angle) * wheelDiameter / 2 - imgMaxHeight / 2;

        // Translate items based on calculated x, y positions
        //item.style.transform = `translate(${x}px, ${y}px)`;
    });
}
