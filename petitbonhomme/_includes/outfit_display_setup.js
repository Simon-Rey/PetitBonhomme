{% assign wheel_radius = include.wheel_radius | default: "200" %}

const outfitStacks = document.querySelectorAll('.outfit-stack');

// Loop through each element and call your function
outfitStacks.forEach((stack) => {
    setupWheel(stack);
});

function setupWheel(outfitStack) {
    const wheelItems = outfitStack.querySelectorAll('.outfit-wheel-item-image-wrap');
    const pageWidth = window.innerWidth;
    const wheelDiameter = Math.min(pageWidth - 40, 2 * {{ wheel_radius }} + 200);
    const radius = wheelDiameter / 2 * 2 / 3;
    const imgMaxWidth = wheelDiameter / 5;
    const imgMaxHeight = imgMaxWidth * 4 / 3;

    const wheel = outfitStack.querySelectorAll('.wheel')[0];
    wheel.style.width = `${wheelDiameter}px`;
    wheel.style.height = `${wheelDiameter}px`;

    // Position the items in a circle around the center of the wheel
    const angleStep = (2 * Math.PI) / wheelItems.length; // Divide the circle by the number of items
    wheelItems.forEach((item, index) => {
        const angle = index * angleStep;
        const x = Math.cos(angle) * radius - imgMaxWidth / 2;
        const y = Math.sin(angle) * radius - imgMaxHeight / 2;

        // Translate items based on calculated x, y positions
        item.style.transform = `translate(${x}px, ${y}px)`;

        const image = item.querySelector('img');
        image.style.maxHeight = `${imgMaxHeight}px`;
        image.style.maxWidth = `${imgMaxWidth}px`;
    });
}
