require 'yaml'

class ValidationError < StandardError; end

def run_sanity_checks
  # Load clothing_items.yml and clothing_brands.yml
  clothing_items_path = File.join(Dir.pwd, '_data', 'clothing_items.yml')

  clothing_items = YAML.load_file(clothing_items_path)

  # Extract brand names from clothing_brands.yml
  clothing_brands_path = File.join(Dir.pwd, '_data', 'clothing_items_brands.yml')
  valid_brands = YAML.load_file(clothing_brands_path).map { |brand| brand['name'] }

  # Loop through clothing_items and check for missing brands
  clothing_items.each do |item|
    brand = item['brand']
    item_name = item['name']
    unless valid_brands.include?(brand)
      raise ValidationError, "ERROR: Brand '#{brand}' of '#{item_name}' is not listed in clothing_items_brands.yml"
    end
  end

  # Check for missing colors
  colors_path = File.join(Dir.pwd, '_data', 'clothing_items_colors.yml')
  valid_colors = YAML.load_file(colors_path).map { |color| color['name'] }

  clothing_items.each do |item|
    item_colors = item['colors']
    item_colors.each do |color|
      unless valid_colors.include?(color)
        raise ValidationError, "ERROR: Color '#{color}' in clothing_items.yml is not listed in clothing_items_colors.yml"
      end
    end
  end

  # Check each day log entry for valid outfit and non-outfit item names

  # Collect all day_logs_*.yml files
  day_logs = []
  Dir.glob(File.join(Dir.pwd, "_data", "day_logs_*.yml")).each do |file|
    yaml_data = YAML.load_file(file)
    if yaml_data.is_a?(Array)
      day_logs.concat(yaml_data)
    elsif yaml_data.is_a?(Hash)
      day_logs << yaml_data
    end
  end
  item_names = clothing_items.map { |item| item['name'] }

  day_logs.each do |entry|
    entry['outfits'].each do |outfit|
      outfit['items'].each do |item_name|
        unless item_names.include?(item_name)
          raise ValidationError, "Error: Outfit item '#{item_name}' is not listed in clothing_items.yml"
        end
      end
    end

    if entry['non-outfit-items']
      entry['non-outfit-items'].each do |non_outfit_item_name|
        unless item_names.include?(non_outfit_item_name)
          raise ValidationError, "Error: Non-outfit item '#{non_outfit_item_name}' is not listed in clothing_items.yml"
        end
      end
    end
  end

  puts "Sanity check completed."
end

if __FILE__ == $0
  begin
    run_sanity_checks
    puts "All sanity checks passed."
  rescue ValidationError => e
    puts "Validation Error: #{e.message}"
    exit 1  # Exit with an error code
  end
end