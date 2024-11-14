---
layout: default
title: PetitBonhomme | Wardrobe
main_h_title: Wardrobe
main_id: wardrobe-main
content_wrap_id: wardrobe-content-wrap
---

{% include wardrobe_and_filters.html %}

<script>
    if (window.matchMedia('(max-width: 650px)').matches) {
        document.getElementById("wardrobe-filter-title").classList.add("collapsed");
        document.getElementById("wardrobe-filter-content").classList.add("hidden");
    }
</script>