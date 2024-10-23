{% assign wheel_radius = include.wheel_radius | default: "200" %}

const outfitStacks = document.querySelectorAll('.outfit-stack');

// Loop through each element and call your function
outfitStacks.forEach((stack) => {
    setupWheel(stack);
});

function setupWheel(outfitStack) {
    const wheelItems = outfitStack.querySelectorAll('.outfit-wheel-item-image-wrap');
    const pageWidth = window.innerWidth;
    const radius = Math.min(pageWidth / 2, {{ wheel_radius }});

    const wheel = outfitStack.querySelectorAll('.wheel')[0];
    wheel.style.width = `${2 * radius + 200}px`;
    wheel.style.height = `${2 * radius + 200}px`;

    // Position the items in a circle around the center of the wheel
    const angleStep = (2 * Math.PI) / wheelItems.length; // Divide the circle by the number of items
    wheelItems.forEach((item, index) => {
        const angle = index * angleStep;
        const x = Math.cos(angle) * radius - item.offsetWidth / 2;
        const y = Math.sin(angle) * radius - item.offsetHeight / 2;

        // Translate items based on calculated x, y positions
        item.style.transform = `translate(${x}px, ${y}px)`;
    });
}
