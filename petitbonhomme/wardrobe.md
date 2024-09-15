---
layout: default
---


Hello

{% for item in site.data.clothing_items %}

{% assign wear_count = 0 %}
{% for outfit in site.data.outfits %}
{% for cloth_name in outfit.clothes %}
{% if item.name == cloth_name %}
{% assign wear_count = wear_count | plus: 1 %}
{% endif %}
{% endfor %}
{% endfor %}

{% if wear_count > 0 %}
{% assign price_per_wear = item.buying_price | divided_by: wear_count %} 
{% else %}
{% assign price_per_wear = item.buying_price %}
{% endif %}

<div>
<h3>{{ item.name }}</h3>

{% assign full_image_path = "/assets/img/clothes/" | append: item.image %}
<p><img src="{{ full_image_path | relative_url }}" alt="Image for the item {{ item.name }}"></p>
<p>Worn: {{ wear_count }}</p>
<p>Price per wear: {{ price_per_wear }}</p>
</div>

{% endfor %}