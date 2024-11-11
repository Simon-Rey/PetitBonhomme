---
layout: default
title: PetitBonhomme | Wardrobe
---

<h1>Wardrobe</h1>

{% include wardrobe_and_filters.html %}

<script>
    if (window.matchMedia('(max-width: 650px)').matches) {
        document.getElementById("wardrobe-filter-title").classList.add("collapsed");
        document.getElementById("wardrobe-filter-content").classList.add("hidden");
    }
</script>