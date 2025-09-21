
module Jekyll
  class ClothingItemPage < Page
    def initialize(site, base, dir, name, item)
      @site = site
      @base = base
      @dir = dir
      @name = name

      self.process(@name)
      self.data ||= {}
      self.data['layout'] = 'clothing_item'
      self.data['item'] = item
      self.data['title'] = "PetitBonhomme | #{item['name']}"
      self.data['extra_html_head'] = '<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>'
    end
  end

  class ClothingItemGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Load the clothing items from the YAML file
      clothing_items = site.data['clothing_items']

      # Loop through each clothing item and create a page
      clothing_items.each do |item|
        # Create a new page for each item
        item_page = ClothingItemPage.new(site, site.source, 'wardrobe', "#{item['id']}.html", item)

        # Add the item page to the site
        site.pages << item_page
      end
    end
  end
end