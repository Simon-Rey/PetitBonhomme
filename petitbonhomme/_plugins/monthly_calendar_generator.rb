module Jekyll
  class MonthlyCalendarGenerator < Generator
    safe true

    def generate(site)
      # Load the day logs data
      day_logs = site.data['day_logs']

      # Group logs by year and month
      monthly_logs = day_logs.group_by { |day| Date.parse(day['date']).strftime('%Y-%m') }

      latest_month = nil
      latest_year = nil
      latest_logs = nil

      monthly_logs.each do |month, logs|
        year, month_num = month.split('-')

        # Create a new page for each month
        month_page = PageWithoutAFile.new(site, site.source, 'calendar', "#{year}-#{month_num}.html")
        month_page.data['layout'] = 'monthly_calendar'
        month_page.data['year'] = year
        month_page.data['month'] = month_num
        month_page.data['logs'] = logs

        # Add the month page to the site
        site.pages << month_page

        # Determine the latest month by comparing months
        current_month = Date.new(year.to_i, month_num.to_i)
        if latest_month.nil? || current_month > latest_month
          latest_month = current_month
          latest_year = year
          latest_logs = logs
        end
      end

      # Store the latest year and month globally for other pages
      if latest_month
        # Create an index page using the latest month’s data
        index_page = PageWithoutAFile.new(site, site.source, '', 'index.html')
        index_page.data['layout'] = 'monthly_calendar'
        index_page.data['year'] = latest_year
        index_page.data['month'] = latest_month.strftime('%m')
        index_page.data['logs'] = latest_logs

        # Add the index page to the site
        site.pages << index_page
      end
    end
  end
end
