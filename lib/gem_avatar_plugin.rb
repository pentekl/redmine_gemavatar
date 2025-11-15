#    This file is part of Gemavatar.
#
#    Gemavatar is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Gemavatar is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Gemavatar.  If not, see <http://www.gnu.org/licenses/>.

module GemAvatarPlugin

  class GemAvatarHooks < Redmine::Hook::ViewListener
        render_on :view_my_account, :partial => 'hooks/reload'
  end

  module ApplicationHelperGemavatarPatch

    def self.included(base)
      base.class_eval do
        include InstanceMethods

        alias_method :avatar_without_gemavatar, :avatar
        alias_method :avatar, :avatar_with_gemavatar
      end
    end

    module InstanceMethods

      def avatar_with_gemavatar (user, options = { })
        if Setting.gravatar_enabled? && user.is_a?(User)
#          options.merge!({:ssl => (defined?(request) && request.ssl?), :default => Setting.gravatar_default})
#          # options[:size] = "64" unless options[:size]
#          options[:size] = "24" unless options[:size]
#          avatar_url = url_for :controller => :pictures, :action => :delete, :user_id => user
#          return "<img class=\"gravatar\" width=\"#{options[:size]}\" height=\"#{options[:size]}\" src=\"#{avatar_url}\" />".html_safe
      # avoid mutating caller's hash and normalize keys
          opts = options.to_h.symbolize_keys
          opts[:ssl] = request&.ssl?
          opts[:default] ||= Setting.gravatar_default
          opts[:size] ||= 24

          # Build the avatar URL (preserve original behavior - controller/action used by original plugin)
          avatar_url = url_for(controller: :pictures, action: :delete, user_id: user)

          # Use Rails tag helper rather than raw HTML + html_safe
          tag.img(class: 'gravatar',
                  width: opts[:size],
                  height: opts[:size],
                  src: avatar_url)
        else
          avatar_without_gemavatar(user, options)
        end
      end

    end

  end
end