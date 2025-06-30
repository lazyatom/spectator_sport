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

      end
    end
  end
end
