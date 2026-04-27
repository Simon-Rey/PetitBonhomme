require 'yaml'
require 'date'

class ValidationError < StandardError; end

REQUIRED_FIELDS = %w[id name brand colors category size materials z_index multiplicity bought_new not_logged_wear buying_price buying_date buying_place].freeze

def load_yaml(path)
  YAML.load_file(path)
rescue Errno::ENOENT
  raise ValidationError, "ERROR: File not found: #{path}"
end

# Recursively collect all category names that are assignable (leaf nodes only)
def collect_leaf_categories(nodes)
  nodes.flat_map do |node|
    if node['children']
      collect_leaf_categories(node['children'])
    else
      [node['name']]
    end
  end
end

def run_sanity_checks
  data_dir = File.join(Dir.pwd, '_data')

  clothing_items    = load_yaml(File.join(data_dir, 'clothing_items.yml'))
  valid_brands      = load_yaml(File.join(data_dir, 'clothing_items_brands.yml')).map    { |x| x['name'] }
  valid_colors      = load_yaml(File.join(data_dir, 'clothing_items_colors.yml')).map    { |x| x['name'] }
  valid_categories  = collect_leaf_categories(load_yaml(File.join(data_dir, 'clothing_items_categories.yml')))
  valid_materials   = load_yaml(File.join(data_dir, 'clothing_items_materials.yml'))
  valid_sizes = load_yaml(File.join(data_dir, 'clothing_items_sizes.yml'))

  # --- clothing_items.yml checks ---

  ids   = []
  names = []

  clothing_items.each_with_index do |item, idx|
    label = "Item ##{idx + 1} (#{item['name'] || 'unnamed'})"

    # Required fields
    REQUIRED_FIELDS.each do |field|
      if item[field].nil?
        raise ValidationError, "ERROR: #{label} is missing required field '#{field}'"
      end
    end

    name = item['name']
    id   = item['id']

    # Duplicate name
    raise ValidationError, "ERROR: Duplicate item name '#{name}'" if names.include?(name)
    names << name

    # Duplicate ID
    raise ValidationError, "ERROR: Duplicate item id '#{id}' (on '#{name}')" if ids.include?(id)
    ids << id

    # Type checks
    raise ValidationError, "ERROR: '#{name}' — 'id' must be an Integer, got #{id.class}" unless id.is_a?(Integer)
    raise ValidationError, "ERROR: '#{name}' — 'multiplicity' must be an Integer" unless item['multiplicity'].is_a?(Integer)
    raise ValidationError, "ERROR: '#{name}' — 'not_logged_wear' must be an Integer" unless item['not_logged_wear'].is_a?(Integer)
    raise ValidationError, "ERROR: '#{name}' — 'z_index' must be an Integer" unless item['z_index'].is_a?(Integer)
    raise ValidationError, "ERROR: '#{name}' — 'buying_price' must be Numeric" unless item['buying_price'].is_a?(Numeric)
    raise ValidationError, "ERROR: '#{name}' — 'bought_new' must be true or false" unless [true, false].include?(item['bought_new'])
    raise ValidationError, "ERROR: '#{name}' — 'colors' must be a list" unless item['colors'].is_a?(Array)
    raise ValidationError, "ERROR: '#{name}' — 'materials' must be a list" unless item['materials'].is_a?(Array)
    raise ValidationError, "ERROR: #{name} is missing field 'image'" unless item.key?('image')
    raise ValidationError, "ERROR: #{name} is missing field 'worn_image'" unless item.key?('worn_image')

    # Date format
    begin
      Date.parse(item['buying_date'].to_s)
    rescue ArgumentError
      raise ValidationError, "ERROR: '#{name}' — 'buying_date' is not a valid date: #{item['buying_date']}"
    end

    # Brand
    unless valid_brands.include?(item['brand'])
      raise ValidationError, "ERROR: '#{name}' — brand '#{item['brand']}' not in clothing_items_brands.yml"
    end

    # Category (leaf nodes only)
    unless valid_categories.include?(item['category'])
      raise ValidationError, "ERROR: '#{name}' — category '#{item['category']}' is not a valid assignable category in clothing_items_categories.yml (must be a leaf category, not a parent)"
    end

    # Size
    unless valid_sizes.include?(item['size'])
      raise ValidationError, "ERROR: '#{name}' — size '#{item['size']}' not in clothing_items_sizes.yml"
    end

    # Colors
    item['colors'].each do |color|
      unless valid_colors.include?(color)
        raise ValidationError, "ERROR: '#{name}' — color '#{color}' not in clothing_items_colors.yml"
      end
    end

    # Materials
    item['materials'].each do |material|
      unless valid_materials.include?(material)
        raise ValidationError, "ERROR: '#{name}' — material '#{material}' not in clothing_items_materials.yml"
      end
    end
  end

  # --- day_logs checks ---

  item_names = clothing_items.map { |item| item['name'] }

  day_logs = []
  Dir.glob(File.join(data_dir, "day_logs_*.yml")).each do |file|
    yaml_data = YAML.load_file(file)
    if yaml_data.is_a?(Array)
      day_logs.concat(yaml_data)
    elsif yaml_data.is_a?(Hash)
      day_logs << yaml_data
    end
  end

  day_logs.each do |entry|
    entry['outfits'].each do |outfit|
      outfit['items'].each do |item_name|
        unless item_names.include?(item_name)
          raise ValidationError, "ERROR: Outfit item '#{item_name}' is not listed in clothing_items.yml"
        end
      end
    end

    if entry['non-outfit-items']
      entry['non-outfit-items'].each do |non_outfit_item_name|
        unless item_names.include?(non_outfit_item_name)
          raise ValidationError, "ERROR: Non-outfit item '#{non_outfit_item_name}' is not listed in clothing_items.yml"
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
    puts e.message
    exit 1
  end
end