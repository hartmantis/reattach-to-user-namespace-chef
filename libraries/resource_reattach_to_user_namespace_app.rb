# Encoding: UTF-8
#
# Cookbook Name:: reattach-to-user-namespace
# Library:: resource_reattach_to_user_namespace_app
#
# Copyright 2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'json'
require 'chef/mixin/shell_out'
require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for managing the reattach-to-user-namespace application.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class ReattachToUserNamespaceApp < Resource
      include Chef::Mixin::ShellOut

      PATH ||= '/usr/local/bin/reattach-to-user-namespace'

      provides :reattach_to_user_namespace_app, platform_family: 'mac_os_x'

      #
      # The method of installation for either :homebrew or :direct (download
      # from GitHub).
      #
      property :source,
               Symbol,
               coerce: proc { |v| v.to_sym },
               equal_to: %i(direct homebrew),
               default: :homebrew

      #
      # Optionally specify a version of RtUN to install.
      #
      property :version, String

      ######################################################################
      # Every property below this point is for tracking resource state and #
      # should *not* be overridden.                                        #
      ######################################################################

      #
      # A property to track the installed state of Mas.
      #
      property :installed, [TrueClass, FalseClass]

      default_action :install

      load_current_value do
        installed(::File.exist?(PATH))
        if installed
          cmd = 'reattach-to-user-namespace -v'
          version(shell_out(cmd).stdout.lines[0].split[-1])
        end
      end

      #
      # Install RtUN if it's not already.
      #
      action :install do
        case new_resource.source
        when :homebrew
          include_recipe 'homebrew'
          homebrew_package 'reattach-to-user-namespace' do
            version new_resource.version if new_resource.version
          end
        when :direct
          new_resource.installed(true)
          new_resource.version || new_resource.version(latest_version?)

          converge_if_changed :installed do
            remote_path = 'https://github.com/ChrisJohnsen/' \
                          'tmux-MacOSX-pasteboard/archive/'
                          "v#{new_resource.version}.zip"
            local_path = ::File.join(Chef::Config[:file_cache_path],
                                     "rtun-v#{new_resource.version}.zip")
            build_path = ::File.join(Chef::Config[:file_cache_path],
                                     "rtun-v#{new_resource.version}")
            remote_file local_path do
              source remote_path
            end
            execute 'Extract RtUN zip file' do
              command "unzip -j -d #{build_path} -o #{local_path}"
            end
            execute 'Compile RtUN from source' do
              command 'make'
              cwd build_path
            end
            remote_file path do
              s = ::File.join(build_path, 'reattach-to-user-namespace')
              source "file://#{s}"
            end
          end
        end
      end

      #
      # Upgrade RtUN if there's a more recent version than is currently
      # installed.
      #
      action :upgrade do
        case new_resource.source
        when :homebrew
          include_recipe 'homebrew'
          homebrew_package('reattach-to-user-namespace') { action :upgrade }
        when :direct
          new_resource.installed(true)
          new_resource.version || new_resource.version(latest_version?)

          converge_if_changed :version do
            remote_path = 'https://github.com/ChrisJohnsen/' \
                          'tmux-MacOSX-pasteboard/archive/'
                          "v#{new_resource.version}.zip"
            local_path = ::File.join(Chef::Config[:file_cache_path],
                                     "rtun-v#{new_resource.version}.zip")
            build_path = ::File.join(Chef::Config[:file_cache_path],
                                     "rtun-v#{new_resource.version}")
            remote_file local_path do
              source remote_path
            end
            execute 'Extract RtUN zip file' do
              command "unzip -j -d #{build_path} -o #{local_path}"
            end
            execute 'Compile RtUN from source' do
              command 'make'
              cwd build_path
            end
            remote_file path do
              s = ::File.join(build_path, 'reattach-to-user-namespace')
              source "file://#{s}"
            end
          end
        end
      end

      #
      # Uninstall RtUN by either deleting the file or removing the Homebrew
      # package.
      #
      action :remove do
        case new_resource.source
        when :homebrew
          include_recipe 'homebrew'
          homebrew_package('reattach-to-user-namespace') { action :remove }
        when :direct
          new_resource.installed(false)

          converge_if_changed :installed do
            file('/usr/local/bin/reattach-to-user-namespace') { action :delete }
          end
        end
      end

      #
      # Query the GitHub API to find the latest released version of RtUN.
      #
      # @return [String] the latest version in GitHub
      #
      def latest_version?
        @latest_version ||= begin
          uri = 'https://api.github.com/repos/ChrisJohnsen/' \
                'tmux-MacOSX-pasteboard/releases'
          JSON.parse(Net::HTTP.get(URI(uri))).first['tag_name'].gsub(/^v/, '')
        end
      end
    end
  end
end
