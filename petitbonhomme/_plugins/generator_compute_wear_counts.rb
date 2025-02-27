module Jekyll
  class WearCountGenerator < Generator
    safe true
    priority :high

    def generate(site)
      clothing_items = site.data['clothing_items'] || []
      day_logs = site.data['day_logs'] || []

      clothing_items.each do |item|
        count = compute_wear_count(item['name'], day_logs)
        total_count =  count + (item['not_logged_wear'] || 0)
        item['logged_wear_count'] = count
        item['total_wear_count'] = total_count
        if count == 0
          item['price_per_logged_wears'] = item['buying_price']
        else
          item['price_per_logged_wears'] = item['buying_price'].to_f / count.to_f
        end
        if total_count == 0
          item['price_per_total_wears'] = item['buying_price']
        else
          item['price_per_total_wears'] = item['buying_price'].to_f / total_count.to_f
        end
      end
    end

    private

    def compute_wear_count(item_name, day_logs)
      wear_count = 0

      day_logs.each do |day|
        worn_this_day = false

        # Check outfits
        day['outfits'].each do |outfit|
          outfit['items'].each do |cloth_name|
            if item_name == cloth_name
              worn_this_day = true
              break
            end
          end
          break if worn_this_day
        end

        # Check non-outfit items
        if day.key?('non-outfit-items') && day['non-outfit-items']
          day['non-outfit-items'].each do |cloth_name|
            wear_count += 1 if item_name == cloth_name
          end
        end

        wear_count += 1 if worn_this_day
      end

      wear_count
    end
  end
end
