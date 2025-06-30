class AddMetadataToSpectatorSportSessionWindows < ActiveRecord::Migration[7.0]
  def change
    add_column :spectator_sport_session_windows, :metadata, :json, default: {}
  end
end