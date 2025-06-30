module SpectatorSport
  module Dashboard
    module ApplicationHelper
      include Dashboard::IconsHelper

      def formatted_duration(duration)
        seconds = duration.to_i
        return "0s" if seconds == 0

        hours = seconds / 3600
        minutes = (seconds % 3600) / 60
        remaining_seconds = seconds % 60

        if hours > 0
          "#{hours}h #{minutes}m #{remaining_seconds}s"
        elsif minutes > 0
          "#{minutes}m #{remaining_seconds}s"
        else
          "#{remaining_seconds}s"
        end
      end

      def visited_paths_display(paths)
        return "No paths" if paths.empty?

        paths.map { |path| truncate_path_with_title(path) }.to_sentence.html_safe
      end

      private

      def truncate_path_with_title(path, max_length = 30)
        if path.length > max_length
          truncated = path[0...max_length] + "..."
          tag.span(truncated, title: path)
        else
          tag.span(path, title: path)
        end
      end
    end
  end
end
