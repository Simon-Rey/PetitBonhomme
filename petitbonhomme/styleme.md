---
layout: default
---

<h1>Style Me</h1>

<div id="style-me-wrap">
  <div id="style-me-wardrobe-and-filters-wrap">
    <div id="style-me-filters">
      {% include brand_selector.html %}
      {% include color_selector.html %}
    </div>
    <div id="wardrobe-wrap">
      {% include wardrobe_by_category.html categories=site.data.clothing_items_categories  item_template_name="style_me" %}
    </div>
  </div>
  <div id="style-me-outfit">
    {% include outfit_display.html show_wheel=true %}
  </div>
</div>


<script>
    {% include outfit_display_setup.js %}
    function showWheel(stack) {}
    function hideWheel(stack) {}

    const outfitStack = document.querySelector('.outfit-stack');
    const wheel = document.querySelector('.wheel');
    const selectedItems = [];
    function toggleItemSelection(item) {
        const itemName = item.dataset.name;
        
        if (selectedItems.includes(itemName)) {
            selectedItems.splice(selectedItems.indexOf(itemName), 1);
            
            const existingImg = outfitStack.querySelector(`img[data-item-id="${item.id}"]`);
            if (existingImg) outfitStack.removeChild(existingImg);
    
            const existingWheelItem = wheel.querySelector(`a[data-item-id="${item.id}"]`);
            if (existingWheelItem) wheel.removeChild(existingWheelItem);
    
        } else {
            selectedItems.push(itemName);
            
            const img = document.createElement('img');
            img.src = item.dataset.wornImage;
            img.alt = itemName;
            img.className = 'outfit-item-image';
            img.style.zIndex = item.dataset.zIndex;
            img.setAttribute('data-item-id', item.id);
            outfitStack.prepend(img);
    
            const angle = 360 / (selectedItems.length);
            
            const wheelLink = document.createElement('a');
            wheelLink.className = 'outfit-wheel-item-image-wrap';
            wheelLink.href = `/wardrobe/${item.id}.html`;
            wheelLink.style.setProperty('--angle', `${angle}deg`);
            wheelLink.setAttribute('data-item-id', item.id);
    
            const wheelDiv = document.createElement('div');
            const wheelImg = document.createElement('img');
            wheelImg.src = item.dataset.wheelImage;
            wheelImg.alt = itemName;
            wheelImg.className = 'outfit-wheel-item-image';
    
            wheelDiv.appendChild(wheelImg);
            wheelLink.appendChild(wheelDiv);
            wheel.appendChild(wheelLink);
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const stackItems = document.querySelectorAll('#style-me-outfit .outfit-item-image');
        stackItems.forEach((item) => {
            item.style.zIndex = (parseInt(window.getComputedStyle(item).zIndex, 10) || 0) + 20;
        });
    });
</script>