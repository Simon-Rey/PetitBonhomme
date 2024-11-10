require 'yaml'

module Jekyll
  class WardrobeColorCountGenerator < Generator
    safe true
    priority :high

    def generate(site)
      # Load the clothing items and color definitions
      clothing_items = YAML.load_file(File.join(site.source, '_data', 'clothing_items.yml'))
      color_definitions = YAML.load_file(File.join(site.source, '_data', 'clothing_items_colors.yml'))
      color_definitions.sort_by! { |color| color['order'] }
      day_logs = YAML.load_file(File.join(site.source, '_data', 'day_logs.yml'))

      # Initialize a hash to store color data by family
      wardrobe_color_family_counts = {}
      worn_color_family_counts = {}

      # Helper method: Convert hex color to RGB array
      def hex_to_rgb(hex)
        hex = hex.delete('#')
        [hex[0..1].to_i(16), hex[2..3].to_i(16), hex[4..5].to_i(16)]
      end

      # Helper method: Convert RGB array back to hex
      def rgb_to_hex(rgb)
        rgb.map { |c| c.clamp(0, 255).to_i.to_s(16).rjust(2, '0') }.join
      end

      # Helper method: Calculate the average hex color for a family
      def average_hex_color(colors)
        rgb_totals = colors.map { |color| hex_to_rgb(color['HTML_code']) }
                           .transpose
                           .map { |channel| channel.sum / colors.size }
        rgb_to_hex(rgb_totals)
      end

      # Group colors by family and calculate the average hex for each family
      colors_by_family = color_definitions.group_by { |color| color['family'] }
      colors_by_family.each do |family_name, colors|
        average_hex = average_hex_color(colors)
        wardrobe_color_family_counts[family_name] ||= { 'total' => 0, 'colors' => {}, 'hex' => average_hex, 'order' => colors.first['order'] }
        worn_color_family_counts[family_name] ||= { 'total' => 0, 'colors' => {}, 'hex' => average_hex, 'order' => colors.first['order'] }
      end

      # Create a color lookup hash for quick access and initialize families and colors in color_family_counts
      color_lookup = {}
      color_definitions.each do |color|
        # Populate color_lookup for quick reference
        color_lookup[color['name']] = {
          'hex' => color['HTML_code'],
          'family' => color['family'],
          'order' => color['order']
        }
        family_name = color['family']
        wardrobe_color_family_counts[family_name]['colors'][color['name']] = { 'count' => 0, 'hex' => color['HTML_code'] }
        worn_color_family_counts[family_name]['colors'][color['name']] = { 'count' => 0, 'hex' => color['HTML_code'] }
      end

      # Count occurrences of each color within families
      clothing_items.each do |item|
        item['colors'].each do |color_name|
          if color_lookup.key?(color_name)
            color_data = color_lookup[color_name]
            family_name = color_data['family']
            hex_code = color_data['hex']

            # Update family and color counts
            wardrobe_color_family_counts[family_name]['total'] += 1 / item['colors'].length
            wardrobe_color_family_counts[family_name]['colors'][color_name]['count'] += 1 / item['colors'].length
          end
        end
      end

      wardrobe_total_count = 0
      wardrobe_color_family_counts.each do |name, data|
        wardrobe_total_count += data["total"]
      end

      wardrobe_color_family_counts.each do |family_name, data|
        data['total'] = (data['total'].to_f / wardrobe_total_count * 100).round(2)
        data['colors'].each do |color_name, color_data|
          color_data['percentage'] = (color_data['count'].to_f / wardrobe_total_count * 100).round(2)
        end
      end

      wardrobe_ordered_families = wardrobe_color_family_counts.map do |family, data|
        colors = data['colors'].map do |color, color_data|
          "{ name: '#{color}', count: #{color_data['percentage']}, hex: '##{color_data['hex']}' }"
        end.join(", ")

        "{ family: '#{family}', total: #{data['total']}, hex: '##{data['hex']}', colors: [#{colors}] }"
      end.join(",\n")

      # Store formatted JS object string in site data
      site.data['wardrobe_color_count'] = "[#{wardrobe_ordered_families}]"

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
                worn_color_family_counts[family_name]['total'] += 1 / item['colors'].length
                worn_color_family_counts[family_name]['colors'][color_name]['count'] += 1 / item['colors'].length
              end
            end
          end
        end
      end

      worn_total_count = 0
      worn_color_family_counts.each do |name, data|
        worn_total_count += data["total"]
      end

      worn_color_family_counts.each do |family_name, data|
        data['total'] = (data['total'].to_f / worn_total_count * 100).round(2)
        data['colors'].each do |color_name, color_data|
          color_data['percentage'] = (color_data['count'].to_f / worn_total_count * 100).round(2)
        end
      end

      worn_ordered_families = worn_color_family_counts.map do |family, data|
        colors = data['colors'].map do |color, color_data|
          "{ name: '#{color}', count: #{color_data['percentage']}, hex: '##{color_data['hex']}' }"
        end.join(", ")

        "{ family: '#{family}', total: #{data['total']}, hex: '##{data['hex']}', colors: [#{colors}] }"
      end.join(",\n")

      # Store formatted JS object string in site data
      site.data['worn_color_count'] = "[#{worn_ordered_families}]"
    end
  end
end
