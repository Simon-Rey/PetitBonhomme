require 'yaml'

module Jekyll
  class WornColorCountGenerator < Generator
    safe true
    priority :high

    def generate(site)
      # Load the clothing items and color definitions
      clothing_items = YAML.load_file(File.join(site.source, '_data', 'clothing_items.yml'))
      color_definitions = YAML.load_file(File.join(site.source, '_data', 'clothing_items_colors.yml'))
      color_definitions.sort_by! { |color| color['order'] }
      day_logs = YAML.load_file(File.join(site.source, '_data', 'day_logs.yml'))

      # Initialize a hash to store color data by family
      color_family_counts = {}

      # Create a color lookup hash for quick access and initialize families and colors in color_family_counts
      color_lookup = {}
      color_definitions.each do |color|
        # Populate color_lookup for quick reference
        color_lookup[color['name']] = {
          'hex' => color['HTML_code'],
          'family' => color['family'],
          'order' => color['order']
        }

        # Initialize each family and color within the family in color_family_counts with zero counts
        family_name = color['family']
        hex_code = color['HTML_code']
        order = color['order']

        color_family_counts[family_name] ||= { 'total' => 0, 'colors' => {}, 'hex' => hex_code, 'order' => order }
        color_family_counts[family_name]['colors'][color['name']] = { 'count' => 0, 'hex' => hex_code }
      end

      # Create a clothing item lookup hash for quick access by item name
      item_lookup = {}
      clothing_items.each do |item|
        item_lookup[item['name']] = item
      end

      # Count occurrences of each color in worn items
      day_logs.each do |log|
        log['outfits'].each do |outfit|
          outfit['items'].each do |item_name|
            # Find the item in clothing items
            item = item_lookup[item_name]
            next unless item # Skip if item is not found

            # Update color counts based on item's colors
            item['colors'].each do |color_name|
              if color_lookup.key?(color_name)
                color_data = color_lookup[color_name]
                family_name = color_data['family']
                hex_code = color_data['hex']

                # Update family and color counts for worn items
                color_family_counts[family_name]['total'] += 1
                color_family_counts[family_name]['colors'][color_name]['count'] += 1
              end
            end
          end
        end
      end

      ordered_families = color_family_counts.map do |family, data|
        colors = data['colors'].map do |color, color_data|
          "{ name: '#{color}', count: #{color_data['count']}, hex: '##{color_data['hex']}' }"
        end.join(", ")

        "{ family: '#{family}', total: #{data['total']}, hex: '##{data['hex']}', colors: [#{colors}] }"
      end.join(",\n")

      # Store formatted JS object string in site data
      site.data['worn_color_count'] = "[#{ordered_families}]"
    end
  end
end
