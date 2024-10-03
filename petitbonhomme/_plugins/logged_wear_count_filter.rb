module Jekyll
  module LoggedWearCountFilter
    def logged_wear_count(item_name, day_logs)
      wear_count = 0
      worn_this_day = false

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

Liquid::Template.register_filter(Jekyll::LoggedWearCountFilter)
