module Jekyll
  class MonthlyCalendarGenerator < Generator
    safe true

    def generate(site)
      # Load the day logs data
      day_logs = site.data['day_logs']

      # Group logs by year and month
      monthly_logs = day_logs.group_by { |day| Date.parse(day['date']).strftime('%Y-%m') }

      monthly_logs.each do |month, logs|
        year, month_num = month.split('-')

        # Create a new page for each month
        month_page = PageWithoutAFile.new(site, site.source, 'months', "#{year}-#{month_num}.html")
        month_page.data['layout'] = 'monthly_calendar'
        month_page.data['year'] = year
        month_page.data['month'] = month_num
        month_page.data['logs'] = logs

        # Add the month page to the site
        site.pages << month_page
      end
    end
  end
end
