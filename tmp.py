import yaml


with open('petitbonhomme/_data/clothing_items.yml', 'r', encoding='utf-8') as file:
    items = yaml.safe_load(file)

for item in items:
    old_path = item["image"]
    item["worn_image"] = f"Worn/{old_path}"
    item["image"] = ""


with open('petitbonhomme/_data/clothing_items.yml', 'w', encoding='utf-8') as file:
    yaml.dump(items, file, sort_keys=False, encoding='utf-8', allow_unicode=True)
