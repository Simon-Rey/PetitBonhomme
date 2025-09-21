module Jekyll
  class MonthlyCalendarGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Load the day logs data
      day_logs = site.data['day_logs']

      # Group logs by year and month
      monthly_logs = day_logs.group_by { |day| Date.parse(day['date']).strftime('%Y-%m') }

      latest_month = nil
      latest_year = nil
      latest_logs = nil

      calendar_dir = File.join(site.source, 'calendar')
      Dir.mkdir(calendar_dir) unless Dir.exist?(calendar_dir)

      monthly_logs.each do |month, logs|
        year, month_num = month.split('-')
        full_month = Date.strptime(month, "%Y-%m").strftime('%B')

        year_dir = File.join(site.source, 'calendar', "#{year}")
        # Create the year directory if it doesn't exist
        Dir.mkdir(year_dir) unless Dir.exist?(year_dir)

        # Create a new page for each month
        month_page = PageWithoutAFile.new(site, site.source, File.join('calendar', "#{year}"), "#{month_num}.html")
        month_page.data['layout'] = 'monthly_calendar'
        month_page.data['year'] = year
        month_page.data['month'] = month_num
        month_page.data['logs'] = logs
        month_page.data['full_month'] = full_month
        month_page.data['main_id'] = "main-calendar"
        month_page.data['content_wrap_id'] = "content-calendar-wrap"
        month_page.data['title'] = "PetitBonhomme | #{full_month} #{year}"
        month_page.data['main_h_title'] = "#{full_month} #{year}"

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
    end
  end
end
