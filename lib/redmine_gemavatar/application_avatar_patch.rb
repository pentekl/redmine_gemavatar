module RedmineGemavatar
  # Modern, reload-safe patch for ApplicationHelper#avatar
  # Uses ActiveSupport::Concern so it integrates cleanly with prepend/super semantics.
  require 'active_support/concern'

  module ApplicationAvatarPatch
    extend ActiveSupport::Concern

    included do
      prepend InstanceMethods
    end

    module InstanceMethods
      # Override avatar(user, options = {}) while keeping the original method reachable via super
      def avatar(user, options = {})
        if Setting.gravatar_enabled? && user.is_a?(User)
          # avoid mutating caller's hash and normalize keys
          opts = options.to_h.symbolize_keys
          opts[:ssl] = request&.ssl?
          opts[:default] ||= Setting.gravatar_default
          opts[:size] ||= 64

          # Build the avatar URL (preserve original behavior - controller/action used by original plugin)
          avatar_url = url_for(controller: :pictures, action: :delete, user_id: user)

          # Use Rails tag helper rather than raw HTML + html_safe
          tag.img(class: 'gravatar',
                  width: opts[:size],
                  height: opts[:size],
                  src: avatar_url)
        else
          # call the original implementation
          super
        end
      end
    end
  end
end