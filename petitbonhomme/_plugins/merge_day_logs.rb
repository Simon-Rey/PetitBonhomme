require "yaml"

module Jekyll
  class MergeDayLogs < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      merged_logs = []

      # Look inside _data for all files matching day_logs_*.yml
      data_dir = File.join(site.source, "_data")
      Dir.glob(File.join(data_dir, "day_logs_*.yml")).each do |file|
        yaml_data = YAML.load_file(file)
        if yaml_data.is_a?(Array)
          merged_logs.concat(yaml_data)
        elsif yaml_data.is_a?(Hash)
          merged_logs << yaml_data
        end
      end

      # Attach the merged result to site.data
      site.data["day_logs"] = merged_logs
    end
  end
end
