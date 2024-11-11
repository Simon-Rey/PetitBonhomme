module Jekyll
  class MonthlyWearCountsGenerator < Generator
    safe true
    priority :high

    def generate(site)
      # Initialize a hash to store wear counts per item per month
      wear_counts = {}

      # Gather all dates to determine the full month range
      dates = site.data['day_logs'].map { |log| Date.parse(log['date']) }
      start_month = Date.new(dates.min.year, dates.min.month)
      end_month = Date.new(dates.max.year, dates.max.month)

      # Generate a list of all months between the first and last month
      all_months = []
      current_month = start_month
      while current_month <= end_month
        all_months << current_month.strftime('%Y-%m')
        current_month = current_month.next_month
      end

      # Parse the day logs and count each item's usage by month
      site.data['day_logs'].each do |log|
        date = Date.parse(log['date'])
        month_key = date.strftime('%Y-%m')

        # Loop through each outfit's items and count occurrences
        log['outfits'].each do |outfit|
          outfit['items'].each do |item_name|
            # Initialize structure if it doesn't exist
            wear_counts[item_name] ||= Hash[all_months.map { |m| [m, 0] }]
            wear_counts[item_name][month_key] += 1
          end
        end

        # Loop through each non-outfit item and count occurrences
        if log['non-outfit-items']
          log['non-outfit-items'].each do |item_name|
            # Initialize structure if it doesn't exist
            wear_counts[item_name] ||= Hash[all_months.map { |m| [m, 0] }]
            wear_counts[item_name][month_key] += 1
          end
        end
      end

      # Ensure all items have every month initialized in wear_counts
      wear_counts.each do |item_name, months|
        all_months.each do |month|
          months[month] ||= 0
        end
      end

      # Make the wear_counts hash available in Jekyll's site data
      site.data['monthly_wear_counts'] = wear_counts
    end
  end
end
