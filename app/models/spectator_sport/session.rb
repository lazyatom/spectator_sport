module SpectatorSport
  class Session < ApplicationRecord
    has_many :session_windows, dependent: :destroy
    has_many :events, dependent: :destroy
  end
end
