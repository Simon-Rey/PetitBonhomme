import os.path

import yaml

with open(os.path.join('..', 'petitbonhomme', '_data', 'clothing_items.yml'), 'r',
          encoding='utf-8') as file:
    items = yaml.safe_load(file)

with open(os.path.join('..', 'petitbonhomme', '_data', 'clothing_items_categories.yml'), 'r',
          encoding='utf-8') as file:
    categories = yaml.safe_load(file)


def populate_low_cat_to_z_index(cat):
    if "children" in cat:
        for c in cat["children"]:
            populate_low_cat_to_z_index(c)
    else:
        low_cat_to_z_index[cat["name"]] = cat["default_z_index"]


low_cat_to_z_index = {}
for c in categories:
    populate_low_cat_to_z_index(c)

for item in items:
    item["z_index"] = low_cat_to_z_index[item["category"]]

with open(os.path.join('..', 'petitbonhomme', '_data', 'clothing_items.yml'), 'w',
          encoding='utf-8') as file:
    yaml.dump(items, file, sort_keys=False, encoding='utf-8', allow_unicode=True)
