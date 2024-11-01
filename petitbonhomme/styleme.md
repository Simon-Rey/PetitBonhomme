---
layout: default
---

<h1>Style Me</h1>

<div class="style-me-wrap">
  <!-- Left Panel: Clothing Categories -->
  <div class="left-panel">
  <div class="filters">
    
    <!-- Brands Filter -->
    <label for="brand-filter">Brand</label>
    <select id="brand-filter" onchange="filterItems()">
      <option value="all">All Brands</option>
      {% for brand in site.data.clothing_items_brands %}
      <option value="{{ brand.name }}">{{ brand.name }}</option>
      {% endfor %}
    </select>
    
    <!-- Colors Filter -->
    {% include color_selector.html %}
    
    <!-- Materials Filter -->
    <label for="material-filter">Material</label>
    <select id="material-filter" onchange="filterItems()">
      <option value="all">All Materials</option>
      {% for material in site.data.clothing_items_materials %}
      <option value="{{ material }}">{{ material }}</option>
      {% endfor %}
    </select>
    
    <!-- Size Filter -->
    <label for="size-filter">Size</label>
    <select id="size-filter" onchange="filterItems()">
      <option value="all">All Sizes</option>
      {% for size in site.data.clothing_items_sizes %}
      <option value="{{ size }}">{{ size }}</option>
      {% endfor %}
    </select>
  </div>
  
  <!-- Clothing Items List -->

  <div id="style-me-wardrobe">
    {% include wardrobe_by_category.html categories=site.data.clothing_items_categories  item_template_name="style_me" %}
  </div>
  
</div>


  <!-- Right Panel: Outfit Preview -->
  <div class="right-panel">
  <div id="style-me-stack">
  </div>
</div>
</div>

<script>
let outfitItems = [];

function toggleSelection(item) {
  const name = item.dataset.name;
  const image = item.dataset.wornImage;
  const zIndex = item.dataset.zIndex;
  // Check if the item is already in the outfit
  const existingItemIndex = outfitItems.findIndex(item => item.name === name);
  
  if (existingItemIndex === -1) {
    // Add the item to the outfit list if it doesn't exist
    outfitItems.push({ name: name, image: image, zIndex: zIndex });
  } else {
    // Remove the item from the outfit list if it's already there
    outfitItems.splice(existingItemIndex, 1);
  }

  // Render the updated outfit
  renderOutfit();
}

function renderOutfit() {
  const outfitPreview = document.getElementById('style-me-stack');
  outfitPreview.innerHTML = ''; // Clear previous outfit

  // Loop through items and add them to the preview
  outfitItems.forEach(item => {
    const img = document.createElement('img');
    img.src = `{{ site.baseurl }}/assets/img/clothes/${item.image}`;
    img.alt = item.name;
    img.style.zIndex = item.zIndex;
    img.classList.add('outfit-item-image');
    outfitPreview.appendChild(img);
  });
}

function filterItems() {
  const brand = document.getElementById('brand-filter').value;
  const color = document.getElementById('color-filter').value;
  const material = document.getElementById('material-filter').value;
  const size = document.getElementById('size-filter').value;

  const items = document.querySelectorAll('.item');
  
  items.forEach(item => {
    const itemBrand = item.getAttribute('data-brand');
    const itemColor = item.getAttribute('data-color');
    const itemMaterial = item.getAttribute('data-material');
    const itemSize = item.getAttribute('data-size');

    // Check if the item matches the selected filters
    const matchesBrand = (brand === 'all' || itemBrand === brand);
    const matchesColor = (color === 'all' || itemColor === color);
    const matchesMaterial = (material === 'all' || itemMaterial === material);
    const matchesSize = (size === 'all' || itemSize === size);

    // Show or hide item based on the filters
    if (matchesBrand && matchesColor && matchesMaterial && matchesSize) {
      item.style.display = 'block';
    } else {
      item.style.display = 'none';
    }
  });
}

</script>
