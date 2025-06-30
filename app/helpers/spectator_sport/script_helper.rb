module SpectatorSport
  module ScriptHelper
    def spectator_sport_script_tags(metadata: {})
      metadata_script = if metadata.present?
        tag.script("window.SPECTATOR_SPORT_METADATA = #{metadata.to_json};".html_safe)
      else
        tag.script("window.SPECTATOR_SPORT_METADATA = {};".html_safe)
      end

      main_script = tag.script defer: true, src: spectator_sport.events_path(format: :js)

      metadata_script + main_script
    end
  end
end
