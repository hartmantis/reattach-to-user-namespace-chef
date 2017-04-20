# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: reattach-to-user-namespace
# Library:: helpers_app
#
# Copyright 2016-2017, Jonathan Hartman
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
require 'net/http'
require 'chef/mixin/shell_out'

module ReattachToUserNamespace
  module Helpers
    # Helper methods for the RtUN app.
    #
    # @author Jonathan Hartman <j@hartman.io>
    class App
      PATH ||= '/usr/local/bin/reattach-to-user-namespace'.freeze

      class << self
        include Chef::Mixin::ShellOut

        #
        # Shell out to determine what version of RtUN is installed.
        #
        # @return [String, NilClass] the installed version or nil
        #
        def installed_version?
          return nil unless installed?
          shell_out('reattach-to-user-namespace -v').stdout.lines[0].split[-1]
        end

        #
        # Determine whether RtUN is currently installed.
        #
        # @return [TrueClass, FalseClass] whether RtUN is installed
        #
        def installed?
          File.exist?(PATH)
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
end
