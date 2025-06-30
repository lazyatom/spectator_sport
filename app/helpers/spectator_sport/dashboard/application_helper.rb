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
    end
  end
end
