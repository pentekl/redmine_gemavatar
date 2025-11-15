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

Redmine::Plugin.register :redmine_gemavatar do
  name 'Ldap avatar plugin'
  author 'Andrea Guarino + Antoni Segura Puimedon'
  description 'Fetches avatars from LDAP'
  version '1.1'
  url ''
  author_url 'https://gitlab.com/u/aguarino/gemavatar'
  requires_redmine :version_or_higher => '6.0.0'

  settings :default => {'refresh_days' => '2', 'LDAP_photoprop' =>'thumbnailPhoto'}, :partial => 'settings/gemavatar'
end

RedmineApp::Application.config.after_initialize do
    ApplicationHelper.include ApplicationAvatarPatch
end
# Load the Rails Engine to wire in reload-safe patches (see lib/redmine_gemavatar/engine.rb)
# Using require_relative ensures loading from plugin's lib folder even if $LOAD_PATH differs.
# require_relative 'lib/redmine_gemavatar/engine'
