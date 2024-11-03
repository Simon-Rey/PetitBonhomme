---
layout: default
title: PetitBonhomme | Style Me
---

<h1>Style Me</h1>

<div id="style-me-wrap">
  {% include wardrobe_and_filters.html only_first_level="true" item_template_name="style_me" %}
  <div id="style-me-outfit">
    {% include outfit_display.html show_wheel=true %}
  </div>
</div>

<script>
    {% include outfit_display_setup.js %}
    function showWheel(stack) {}
    function hideWheel(stack) {}

    function generateId(str) {
        return str.trim().toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9\-]/g, '');
    }

    const outfitStack = document.querySelector('.outfit-stack');
    const wheel = document.querySelector('.wheel');
    const selectedItems = [];

    function updateWheelAngles() {
        const wheelLinks = wheel.querySelectorAll('.outfit-wheel-item-image-wrap');
        const angle = 360 / selectedItems.length;

        wheelLinks.forEach((link, index) => {
            link.style.setProperty('--angle', `${index * angle}deg`);
        });
    }

    function toggleItemSelection(item) {
        const itemName = item.dataset.name;
        const itemId = generateId(itemName);
        
        if (selectedItems.includes(itemName)) {
            selectedItems.splice(selectedItems.indexOf(itemName), 1);
            
            const existingImg = outfitStack.querySelector(`img[data-item-id="${itemId}"]`);
            if (existingImg) outfitStack.removeChild(existingImg);
    
            const existingWheelItem = wheel.querySelector(`a[data-item-id="${itemId}"]`);
            if (existingWheelItem) wheel.removeChild(existingWheelItem);
    
        } else {
            selectedItems.push(itemName);
            
            const img = document.createElement('img');
            img.src = item.dataset.wornImage;
            img.alt = itemName;
            img.className = 'outfit-item-image';
            img.style.zIndex = item.dataset.zIndex;
            img.setAttribute('data-item-id', itemId);
            outfitStack.prepend(img);
    
            
            const wheelLink = document.createElement('a');
            wheelLink.className = 'outfit-wheel-item-image-wrap';
            wheelLink.setAttribute('data-item-id', itemId);
    
            const wheelDiv = document.createElement('div');
            Object.keys(item.dataset).forEach(key => {
                wheelDiv.dataset[key] = item.dataset[key];
            });
            wheelDiv.addEventListener("click", function () {toggleItemSelection(this)});
            const wheelImg = document.createElement('img');
            wheelImg.src = item.dataset.image;
            wheelImg.alt = itemName;
            wheelImg.className = 'outfit-wheel-item-image';
    
            wheelDiv.appendChild(wheelImg);
            wheelLink.appendChild(wheelDiv);
            wheel.appendChild(wheelLink);
        }
        
        updateWheelAngles();
    }

    document.addEventListener('DOMContentLoaded', function () {
        const stackItems = document.querySelectorAll('#style-me-outfit .outfit-item-image');
        stackItems.forEach((item) => {
            item.style.zIndex = (parseInt(window.getComputedStyle(item).zIndex, 10) || 0) + 20;
        });

        const collapsWardrobe = document.querySelectorAll(".category-title.collapsible-header");
        collapsWardrobe.forEach(function (e) {
            e.classList.toggle("collapsed");
            e.nextElementSibling.classList.toggle("hidden");
            
        });

        function filterWardrobeItems() {
        const selectedBrands = Array.from(document.querySelectorAll('.brand-checkbox-wrap input:checked'))
                                   .map(input => input.value.toLowerCase());
        const selectedColors = Array.from(document.querySelectorAll('.color-selector.selected'))
                                   .map(colorEl => colorEl.dataset.color.toLowerCase());
        
        const wardrobeItems = document.querySelectorAll('.wardrobe-item');
        
        wardrobeItems.forEach(item => {
          const itemBrand = item.dataset.brand.toLowerCase();
          const itemColors = item.dataset.colors.toLowerCase().split(" ");
          
          const brandMatch = selectedBrands.length === 0 || selectedBrands.includes(itemBrand);
          const colorMatch = selectedColors.length === 0 || itemColors.some(color => selectedColors.includes(color));
        
          if (brandMatch && colorMatch) {
            item.style.display = '';
          } else {
            item.style.display = 'none';
          }
        });
        
        const categoryWraps = document.querySelectorAll('.category-wrap');
          categoryWraps.forEach(categoryWrap => {
          const visibleItems = categoryWrap.querySelectorAll('.wardrobe-item:not([style*="display: none"])');
          categoryWrap.style.display = visibleItems.length > 0 ? '' : 'none';
        });
        }
    });
</script>