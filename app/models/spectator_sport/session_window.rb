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
  end
end
