module SpectatorSport
  class SessionWindow < ApplicationRecord
    belongs_to :session
    has_many :events

    def duration
      return 0 if events.empty?

      earliest_event = events.minimum(:created_at)
      latest_event = events.maximum(:created_at)

      return 0 unless earliest_event && latest_event

      latest_event - earliest_event
    end

    def active_duration
      return 0 if events.empty?

      # Get active events ordered by timestamp
      active_events = events.where("event_data->>'type' = '3' AND (
        event_data->'data'->>'source' IN ('1', '2', '3', '5', '6', '12', '14') OR
        (event_data->'data'->>'source' = '2' AND event_data->'data'->>'type' IN ('0', '1', '2', '3', '4'))
      )").order(:created_at)

      return 0 if active_events.empty?

      # Calculate duration excluding gaps longer than 30 seconds
      total_active_duration = 0
      previous_event_time = nil

      active_events.find_each do |event|
        current_time = event.created_at

        if previous_event_time.nil?
          # First event - start counting
          previous_event_time = current_time
        else
          gap = current_time - previous_event_time
          # If gap is less than 30 seconds, count it as active time
          if gap <= 30.seconds
            total_active_duration += gap
          end
          previous_event_time = current_time
        end
      end

      total_active_duration
    end

    def visited_paths
      return [] if events.empty?

      paths = []

      # Get Meta events (type 4) that contain URL information
      meta_events = events.where("event_data->>'type' = '4'")

      meta_events.find_each do |event|
        href = event.event_data.dig('data', 'href')
        if href.present?
          begin
            uri = URI.parse(href)
            path = uri.path
            path = '/' if path.blank?
            paths << path unless paths.include?(path)
          rescue URI::InvalidURIError
            # Skip invalid URLs
          end
        end
      end

      # Get Custom events (type 5) for Turbo navigation tracking
      custom_events = events.where("event_data->>'type' = '5' AND event_data->'data'->>'tag' IN ('navigation', 'page_load')")

      custom_events.find_each do |event|
        url = event.event_data.dig('data', 'payload', 'url')
        if url.present?
          begin
            uri = URI.parse(url)
            path = uri.path
            path = '/' if path.blank?
            paths << path unless paths.include?(path)
          rescue URI::InvalidURIError
            # Skip invalid URLs
          end
        end
      end

      paths
    end

    def visited_paths_display
      paths = visited_paths
      return "No paths" if paths.empty?

      if paths.length <= 3
        paths.join(", ")
      else
        "#{paths.first(3).join(", ")} +#{paths.length - 3} more"
      end
    end
  end
end
