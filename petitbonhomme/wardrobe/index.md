---
layout: default
---

<h1>Wardrobe</h1>

{% include color_family_selector.html family="Red" %}
{% include color_family_selector.html family="Green" %}
{% include color_family_selector.html family="Blue" %}

<!-- Search and Filter Controls -->
<div class="wardrobe-filters-wrap">
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

{% assign wear_count = item.name | logged_wear_count: site.data.day_logs | plus: item.not_logged_wear %}

{% if wear_count > 0 %}
{% assign price_per_wear = item.buying_price | divided_by: wear_count %} 
{% else %}
{% assign price_per_wear = item.buying_price %}
{% endif %}

<div class="wardrobe-item" data-brand="{{ item.brand }}" data-colors="{{ item.colors | join: ' ' }}" data-category="{{ item.category }}" data-name="{{ item.name }}">
<div class="wardrobe-item-img-wrap">
<a href="{{ '/wardrobe/' | append: item.id | append: '.html' | relative_url }}"><img src="{{ "/assets/img/clothes/" | append: item.image | relative_url }}" alt="{{ item.name }}"></a>
</div>
<div>
<p>Worn: {{ wear_count }}</p>
<p>Price per wear: {{ price_per_wear }}</p>
</div>
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
