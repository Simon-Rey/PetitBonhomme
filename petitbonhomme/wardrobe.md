---
layout: default
---

<h1>Wardrobe</h1>

<!-- Search and Filter Controls -->
<div class="filters">
  <input type="text" id="search-bar" placeholder="Search by name..." onkeyup="filterItems()">

  <select id="brand-filter" onchange="filterItems()">
    <option value="">All Brands</option>
    {% assign brands = site.data.clothing_items | map: 'brand' | uniq %}
    {% for brand in brands %}
      <option value="{{ brand }}">{{ brand }}</option>
    {% endfor %}
  </select>

  <select id="color-filter" onchange="filterItems()">
    <option value="">All Colors</option>
    {% assign colors = site.data.clothing_items | map: 'colors' | join: ',' | split: ',' | uniq %}
    {% for color in colors %}
      <option value="{{ color }}">{{ color }}</option>
    {% endfor %}
  </select>

  <select id="category-filter" onchange="filterItems()">
    <option value="">All Categories</option>
    {% assign categories = site.data.clothing_items | map: 'category' | uniq %}
    {% for category in categories %}
      <option value="{{ category }}">{{ category }}</option>
    {% endfor %}
  </select>
</div>

<!-- Wardrobe Items Display -->
<div class="wardrobe-container" id="wardrobe-container">
{% for item in site.data.clothing_items %}
{% assign wear_count = 0 %}
{% for day in site.data.day_logs %}
{% assign worn_this_day = false %}
{% for outfit in day.outfits %}
{% for cloth_name in outfit.items %}
{% if item.name == cloth_name %}
{% assign worn_this_day = true %}
{% break %}
{% endif %}
{% endfor %}
{% if worn_this_day %}
{% break %}
{% endif %}
{% endfor %}
{% for cloth_name in day.non-outfit-items %}
{% if item.name == cloth_name %}
{% assign wear_count = wear_count | plus: 1 %}
{% endif %}
{% endfor %}
{% if worn_this_day %}
{% assign wear_count = wear_count | plus: 1 %}
{% endif %}
{% endfor %}

{% if wear_count > 0 %}
{% assign price_per_wear = item.buying_price | divided_by: wear_count %} 
{% else %}
{% assign price_per_wear = item.buying_price %}
{% endif %}

<div class="wardrobe-item" data-brand="{{ item.brand }}" data-colors="{{ item.colors | join: ' ' }}" data-category="{{ item.category }}" data-name="{{ item.name }}">
{% assign full_image_path = "/assets/img/clothes/" | append: item.image %}
<h3>{{ item.name }}</h3>
<img src="{{ full_image_path | relative_url }}" alt="{{ item.name }}">
<p>Worn: {{ wear_count }}</p>
<p>Price per wear: {{ price_per_wear }}</p>
</div>
{% endfor %}
</div>

<script>
function filterItems() {
  const searchBar = document.getElementById('search-bar').value.toLowerCase();
  const brandFilter = document.getElementById('brand-filter').value.toLowerCase();
  const colorFilter = document.getElementById('color-filter').value.toLowerCase();
  const categoryFilter = document.getElementById('category-filter').value.toLowerCase();

  const items = document.querySelectorAll('.wardrobe-item');

  items.forEach(item => {
    const itemName = item.getAttribute('data-name').toLowerCase();
    const itemBrand = item.getAttribute('data-brand').toLowerCase();
    const itemColors = item.getAttribute('data-colors').toLowerCase();
    const itemCategory = item.getAttribute('data-category').toLowerCase();

    if (
      (itemName.includes(searchBar)) &&
      (brandFilter === '' || itemBrand.includes(brandFilter)) &&
      (colorFilter === '' || itemColors.includes(colorFilter)) &&
      (categoryFilter === '' || itemCategory.includes(categoryFilter))
    ) {
      item.style.display = 'block';
    } else {
      item.style.display = 'none';
    }
  });
}
</script>

<style>
/* Responsive Layout */
.wardrobe-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
}

.wardrobe-item {
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 5px;
  text-align: center;
}

.wardrobe-item img {
  max-width: 100%;
  height: auto;
  border-radius: 5px;
}

/* Search and Filters */
.filters {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.filters input,
.filters select {
  padding: 5px;
  border-radius: 5px;
  border: 1px solid #ddd;
  font-size: 1em;
}
</style>
