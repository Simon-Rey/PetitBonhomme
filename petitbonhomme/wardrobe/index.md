---
layout: default
---

<h1>Wardrobe</h1>

<!-- Search and Filter Controls -->
<div class="wardrobe-filters-wrap">
{% include color_selector.html %}
{% include brand_selector.html %}
</div>

<div id="wardrobe-wrap">
{% include wardrobe_by_category.html categories=site.data.clothing_items_categories item_template_name="wardrobe" %}
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

document.addEventListener("DOMContentLoaded", function() {
    const nextCollapsibles = document.querySelectorAll(".collapsible-header");

    nextCollapsibles.forEach(function (e) {
        e.addEventListener("click", function () {
            this.classList.toggle("collapsed");
            this.nextElementSibling.classList.toggle("hidden");
        });
    });
});
</script>
