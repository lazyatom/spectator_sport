module SpectatorSport
  module ScriptHelper
    def spectator_sport_script_tags(metadata: {}, session_id: nil)
      # Prepare the configuration object
      config = {
        metadata: metadata.presence || {}
      }

      # Build the initialization script
      init_script = "window.SPECTATOR_SPORT_CONFIG = #{config.to_json};"

      # Set localStorage session_id if provided
      if session_id.present?
        init_script += "window.localStorage.setItem('spectator_sport_session_id', #{session_id.to_json});"
      end

      metadata_script = tag.script(init_script.html_safe)
      main_script = tag.script defer: true, src: spectator_sport.events_path(format: :js)

      metadata_script + main_script
    end
  end
end
