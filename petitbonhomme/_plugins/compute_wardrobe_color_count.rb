require 'yaml'

module Jekyll
  class ColorCountGenerator < Generator
    safe true
    priority :high

    def generate(site)
      # Load the clothing items and color definitions
      clothing_items = YAML.load_file(File.join(site.source, '_data', 'clothing_items.yml'))
      color_definitions = YAML.load_file(File.join(site.source, '_data', 'clothing_items_colors.yml'))

      # Initialize a hash to store color data by family
      color_family_counts = {}

      # Create a color lookup hash for quick access
      color_lookup = {}
      color_definitions.each do |color|
        color_lookup[color['name']] = { 'hex' => color['HTML_code'], 'family' => color['family'] }
      end

      # Count occurrences of each color within families
      clothing_items.each do |item|
        item['colors'].each do |color_name|
          if color_lookup.key?(color_name)
            color_data = color_lookup[color_name]
            family_name = color_data['family']
            hex_code = color_data['hex']

            # Initialize family if not already created
            color_family_counts[family_name] ||= { 'total' => 0, 'colors' => {}, 'hex' => nil }

            # Set prominent color hex code if not already set
            color_family_counts[family_name]['hex'] ||= hex_code

            # Update family and color counts
            color_family_counts[family_name]['total'] += 1
            color_family_counts[family_name]['colors'][color_name] ||= { 'count' => 0, 'hex' => hex_code }
            color_family_counts[family_name]['colors'][color_name]['count'] += 1
          end
        end
      end

      # Store the color family counts in site data for use in templates
      site.data['color_family_counts'] = color_family_counts
    end
  end
end
