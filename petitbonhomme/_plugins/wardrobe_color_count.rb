# _plugins/generate_color_counts.rb
require 'yaml'

module Jekyll
  class ColorCountGenerator < Generator
    safe true
    priority :high

    def generate(site)
      # Load the clothing items and color definitions
      clothing_items = YAML.load_file(File.join(site.source, '_data', 'clothing_items.yml'))
      color_definitions = YAML.load_file(File.join(site.source, '_data', 'clothing_items_colors.yml'))

      # Initialize color counts based on color definitions
      color_counts = Hash.new(0)
      color_definitions.each do |color|
        color_counts[color['name']] = 0
      end

      # Count occurrences of each color in clothing items
      clothing_items.each do |item|
        item['colors'].each do |color|
          color_counts[color] += 1 if color_counts.key?(color)
        end
      end

      # Store the color counts in the site data for access in templates
      site.data['color_counts'] = color_counts
    end
  end
end
