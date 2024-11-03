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

        const nextCollapsibles = document.querySelectorAll(".collapsible-header");

        nextCollapsibles.forEach(function (e) {
            e.addEventListener("click", function () {
                this.classList.toggle("collapsed");
                this.nextElementSibling.classList.toggle("hidden");
            });
            
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
        
        function setupColorSelector() {
        const familyCheckboxes = document.querySelectorAll(".color-family-checkbox");
        familyCheckboxes.forEach(familyCheckbox => {
          familyCheckbox.addEventListener("click", filterWardrobeItems);
        });
        
        const colorSelectors = document.querySelectorAll(".color-selector");
        colorSelectors.forEach(colorSelector => {
          colorSelector.addEventListener("click", filterWardrobeItems);
        });
        }
        
        function setupBrandSelector() {
        const brandWidgets = document.querySelectorAll('.brand-widget');
        
        brandWidgets.forEach(brandWidget => {
          const resetButton = brandWidget.querySelector(".all-brands-toggle-button");
          resetButton.addEventListener('click', () => {
            brandWidget.querySelectorAll('input[name="brand"]').forEach(checkbox => {
              checkbox.checked = false;
            });
            filterWardrobeItems();
          });
        
          const searchInput = brandWidget.querySelector('.brand-search');
          searchInput.addEventListener('input', () => {
            const filterValue = searchInput.value.toLowerCase();
            brandWidget.querySelectorAll('.brand-checkbox-wrap').forEach(item => {
              item.style.display = item.dataset.brand.toLowerCase().includes(filterValue) ? '' : 'none';
            });
          });
        
          brandWidget.querySelectorAll('input[name="brand"]').forEach(checkbox => {
            checkbox.addEventListener('change', filterWardrobeItems);
          });
        });
        }
        
        setupColorSelector();
        setupBrandSelector();
    });
</script>