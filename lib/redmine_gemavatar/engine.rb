module RedmineGemavatar
  class Engine < ::Rails::Engine
    engine_name 'redmine_gemavatar'

    # Use Rails' to_prepare so patches are reapplied on code reload (development) and applied at boot (production).
    initializer 'redmine_gemavatar.apply_patches' do
      Rails.application.config.to_prepare do
        # require_dependency so the file is reload-friendly under Zeitwerk (and works with to_prepare)
        require_dependency File.expand_path('redmine_gemavatar/application_avatar_patch', __dir__)
        begin
          ApplicationHelper.prepend RedmineGemavatar::ApplicationAvatarPatch
        rescue NameError
          # If ApplicationHelper isn't loaded yet, try to require it through ActionView load hooks
          ActiveSupport.on_load(:action_view) do
            ApplicationHelper.prepend RedmineGemavatar::ApplicationAvatarPatch
          end
        end
      end
    end
  end
end